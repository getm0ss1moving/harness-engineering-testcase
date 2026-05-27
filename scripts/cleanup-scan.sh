#!/usr/bin/env bash
set -Eeuo pipefail

MAX_FILE_LINES="${MAX_FILE_LINES:-300}"
MIN_DUPLICATE_LINES="${MIN_DUPLICATE_LINES:-10}"
VERIFY="${VERIFY:-1}"

log() {
  printf '%s\n' "$*"
}

fail() {
  log "ERROR: $*"
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing command: $1. FIX: install $1 first."
}

main_java_files() {
  find src/main/java -type f -name '*.java' ! -name 'package-info.java' | sort
}

test_file_for() {
  local source_file="$1"
  local relative="${source_file#src/main/java/}"
  printf 'src/test/java/%sTest.java\n' "${relative%.java}"
}

check_long_files() {
  log "Checking Java files longer than ${MAX_FILE_LINES} lines..."
  local found=0

  while IFS= read -r file; do
    local lines
    lines="$(wc -l < "${file}")"
    if (( lines > MAX_FILE_LINES )); then
      found=1
      log "LONG_FILE ${file}:${lines} FIX: split responsibilities into smaller classes."
    fi
  done < <(main_java_files)

  return "${found}"
}

check_missing_tests() {
  log "Checking missing tests..."
  local found=0

  while IFS= read -r file; do
    local test_file
    test_file="$(test_file_for "${file}")"
    if [[ ! -f "${test_file}" ]]; then
      found=1
      log "MISSING_TEST ${file} -> ${test_file} FIX: add a focused JUnit 5 test."
    fi
  done < <(main_java_files)

  return "${found}"
}

check_todos() {
  log "Checking task markers outside generated output..."
  local pattern
  pattern='TO''DO|FIX''ME'

  if grep -RInE "${pattern}" src docs config pom.xml .github scripts 2>/dev/null; then
    log "TASK_MARKER_FOUND FIX: triage age and either resolve or create a cleanup PR."
    return 1
  fi
}

check_draft_design_docs() {
  log "Checking draft design docs..."
  local found=0

  while IFS= read -r file; do
    local status
    status="$(grep -E '^status:' "${file}" | head -n 1 | cut -d '#' -f 1 | tr -d '[:space:]' || true)"
    if [[ "${status}" == "status:draft" ]]; then
      found=1
      log "DRAFT_DOC ${file} ${status} FIX: update status or close stale draft."
    fi
  done < <(find docs/design -type f -name '*.md' | sort)

  return "${found}"
}

check_duplicate_candidates() {
  log "Checking duplicate candidates of ${MIN_DUPLICATE_LINES}+ identical non-empty lines..."
  local duplicates
  duplicates="$(
    find src/main/java -type f -name '*.java' ! -name 'package-info.java' -print0 \
      | xargs -0 awk 'NF && $0 !~ /^[[:space:]]*(\/\*\*|\*\/|\*)[[:space:]]*$/ { count[$0]++; text[$0]=$0 } END { for (line in count) if (count[line] >= 2) print count[line] "x " text[line] }' \
      | head -n "${MIN_DUPLICATE_LINES}"
  )"

  if [[ -n "${duplicates}" ]]; then
    log "${duplicates}"
    log "DUPLICATE_CANDIDATES FIX: inspect similarity before extracting shared infrastructure utilities."
  fi
}

run_verify() {
  if [[ "${VERIFY}" != "1" ]]; then
    log "Skipping mvn verify because VERIFY=${VERIFY}."
    return 0
  fi

  log "Running mvn -B clean verify..."
  mvn -B clean verify
}

main() {
  require_command find
  require_command grep
  require_command awk
  require_command xargs
  require_command mvn

  local failed=0
  check_long_files || failed=1
  check_missing_tests || failed=1
  check_todos || failed=1
  check_draft_design_docs || failed=1
  check_duplicate_candidates
  run_verify

  if (( failed )); then
    fail "Cleanup scan found actionable issues. FIX: create separate PRs for each issue category."
  fi

  log "Cleanup scan completed successfully."
}

main "$@"
