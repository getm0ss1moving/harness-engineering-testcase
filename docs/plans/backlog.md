---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Backlog

## Foundation

- Add base package structure.
- Add application entry point.
- Add global exception handler.
- Add standard API response and error response models.
- Add ArchUnit tests for layer dependencies.
- Add Flyway baseline migration.

## Auth

- Implement login endpoint.
- Implement current-user endpoint.
- Add authorization checks for project resources.
- Add auth error handling.

## Project Management

- Add project CRUD.
- Add project members.
- Add task CRUD.
- Add task assignment.
- Add status transitions.

## Search

- Add keyword search.
- Add search pagination.
- Add search permission filtering.

## Billing

- Add billing account read API.
- Add subscription read API.
- Add invoice list API.
- Integrate payment provider through `ApiClient`.

## Quality

- Add Checkstyle verification to CI.
- Add SpotBugs verification to CI.
- Add JaCoCo coverage report to CI.
- Enforce 80% line coverage.
