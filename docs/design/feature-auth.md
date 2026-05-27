---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Feature Design: Auth

## Goal

Provide authentication and authorization capabilities for project management workflows.

## Scope

- User login.
- User identity lookup.
- Permission checks for project resources.
- Token validation through injected auth components.

## Out of Scope

- Direct password storage design.
- Third-party identity provider migration.
- Organization billing permissions.

## Main Concepts

- User: an authenticated person using the platform.
- Session or token: proof of authentication.
- Role: a named set of permissions.
- Permission: an action allowed on a resource.

## Architecture Notes

- Auth components must be injected through Spring.
- Services should not instantiate auth helpers with `new`.
- Controllers should delegate permission decisions to services or dedicated auth components.
- Authorization failures should return stable error codes.

## API Candidates

- `POST /api/auth/login`
- `POST /api/auth/logout`
- `GET /api/auth/me`

## Error Codes

- `AUTH_REQUIRED`
- `AUTH_INVALID_CREDENTIALS`
- `AUTH_FORBIDDEN`
- `AUTH_TOKEN_EXPIRED`

## Tests

- Login succeeds with valid credentials.
- Login rejects invalid credentials.
- Protected endpoints reject unauthenticated requests.
- Project access rejects users without permission.
