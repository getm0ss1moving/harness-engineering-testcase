#!/usr/bin/env bash
set -Eeuo pipefail

REF="${1:-HEAD}"
PORT="${PORT:-8080}"
STARTUP_TIMEOUT_SECONDS="${STARTUP_TIMEOUT_SECONDS:-60}"
WORKTREE_DIR="${WORKTREE_DIR:-$(mktemp -d /tmp/agent-verify.XXXXXX)}"
APP_LOG="${APP_LOG:-/tmp/agent-verify-app.log}"
DEFAULT_BOOT_RUN_ARGUMENTS="--server.port=${PORT} --spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration,org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration"
BOOT_RUN_ARGUMENTS="${BOOT_RUN_ARGUMENTS:-${DEFAULT_BOOT_RUN_ARGUMENTS}}"
MAVEN_EXECUTABLE="${MAVEN_EXECUTABLE:-}"
APP_PID=""
REPO_ROOT=""

log() {
  printf '%s\n' "$*"
}

fail() {
  log "ERROR: $*"
  exit 1
}

cleanup() {
  local exit_code=$?

  if [[ -n "${APP_PID}" ]] && kill -0 "${APP_PID}" 2>/dev/null; then
    kill "${APP_PID}" 2>/dev/null || true
    wait "${APP_PID}" 2>/dev/null || true
  fi

  if [[ -n "${REPO_ROOT}" && -d "${WORKTREE_DIR}" ]]; then
    git -C "${REPO_ROOT}" worktree remove --force "${WORKTREE_DIR}" >/dev/null 2>&1 || true
  fi

  if [[ -z "${REPO_ROOT}" && -d "${WORKTREE_DIR}" ]]; then
    rmdir "${WORKTREE_DIR}" >/dev/null 2>&1 || true
  fi

  exit "${exit_code}"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing command: $1. FIX: install $1 first."
}

verify_toolchain() {
  log "Checking toolchain..."

  java -version 2>&1 | grep -q 'version "25' \
    || fail "JDK must be 25. FIX: install and select JDK 25."

  "${MAVEN_EXECUTABLE}" -version | grep -q 'Apache Maven 3.9.16' \
    || fail "Maven must be 3.9.16. FIX: install and select Maven 3.9.16."
}

run_verify() {
  log "Running full Maven verification..."
  "${MAVEN_EXECUTABLE}" -B clean verify
}

start_application() {
  log "Starting Spring Boot runtime check on port ${PORT}..."
  : > "${APP_LOG}"
  "${MAVEN_EXECUTABLE}" -B spring-boot:run \
    -Dspring-boot.run.arguments="${BOOT_RUN_ARGUMENTS}" \
    >"${APP_LOG}" 2>&1 &
  APP_PID=$!
}

resolve_maven_executable() {
  if [[ -n "${MAVEN_EXECUTABLE}" ]]; then
    return 0
  fi

  if [[ -x "./mvnw" ]]; then
    MAVEN_EXECUTABLE="./mvnw"
    return 0
  fi

  require_command mvn
  MAVEN_EXECUTABLE="mvn"
}

is_actuator_healthy() {
  curl -fsS "http://localhost:${PORT}/actuator/health" 2>/dev/null | grep -q '"status":"UP"'
}

is_http_reachable() {
  local status
  status="$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:${PORT}/" || true)"
  [[ "${status}" =~ ^(2|3|4)[0-9][0-9]$ ]]
}

has_started_log() {
  grep -q 'Started .*Application' "${APP_LOG}"
}

wait_for_startup() {
  local deadline=$((SECONDS + STARTUP_TIMEOUT_SECONDS))

  while (( SECONDS < deadline )); do
    if ! kill -0 "${APP_PID}" 2>/dev/null; then
      print_runtime_diagnostics
      fail "Application process exited before becoming healthy."
    fi

    if is_actuator_healthy || is_http_reachable || has_started_log; then
      log "Runtime check passed."
      return 0
    fi

    sleep 2
  done

  print_runtime_diagnostics
  fail "Application did not become healthy within ${STARTUP_TIMEOUT_SECONDS}s."
}

print_runtime_diagnostics() {
  log "Recent application logs:"
  tail -n 80 "${APP_LOG}" || true
}

create_worktree() {
  log "Creating temporary worktree: ${WORKTREE_DIR}"
  git -C "${REPO_ROOT}" worktree add --detach "${WORKTREE_DIR}" "${REF}"
}

main() {
  trap cleanup EXIT

  require_command git
  require_command java
  require_command curl

  if ! REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    fail "Current directory is not a Git repository. FIX: run this script from a real Git checkout with a remote."
  fi

  create_worktree
  cd "${WORKTREE_DIR}"

  resolve_maven_executable
  verify_toolchain
  run_verify
  start_application
  wait_for_startup

  log "Verification completed successfully."
}

main "$@"
