---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Error Handling

## Principles

- Errors returned by APIs must be stable and machine-readable.
- Use error codes from `docs/reference/error-codes.md`.
- Do not expose stack traces, SQL details, secrets, tokens, or internal implementation details in API responses.
- Translate low-level exceptions into application-level exceptions at service boundaries.

## API Error Shape

Use this response shape for API errors:

```json
{
  "code": "PROJECT_NOT_FOUND",
  "message": "Project was not found.",
  "traceId": "optional-trace-id"
}
```

## Exception Strategy

Use specific exceptions for expected business failures:

- Resource not found.
- Validation failure.
- Permission denied.
- Conflict or duplicate state.
- External dependency failure.

Unexpected failures should be logged and returned as `INTERNAL_ERROR`.

## Controller Advice

Centralize exception mapping with Spring controller advice. Controllers should not repeat error response construction.

## Logging Failures

Log unexpected exceptions with context and stack traces through SLF4J. For expected business failures, prefer concise logs or no log when the client already receives a clear response.
