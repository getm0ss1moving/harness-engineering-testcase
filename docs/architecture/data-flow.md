---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Data Flow

## Request Flow

```text
HTTP request
  -> controller
  -> service
  -> mapper
  -> database
```

The response follows the reverse path:

```text
database
  -> mapper
  -> service
  -> controller
  -> HTTP response
```

## Controller Flow

Controllers are responsible for:

- Mapping HTTP routes.
- Reading request parameters and request bodies.
- Applying request-level validation.
- Delegating use cases to services.
- Returning stable response DTOs.

Controllers should not contain database logic, complex branching workflows, or infrastructure setup.

## Service Flow

Services are responsible for:

- Executing business use cases.
- Enforcing business rules.
- Coordinating mapper calls.
- Calling injected infrastructure abstractions.
- Translating low-level failures into application-level errors.

Keep service methods focused. If a method grows beyond 50 lines, split the workflow into named private methods or smaller services.

## Persistence Flow

Mappers are responsible for:

- Querying and mutating MySQL data.
- Encapsulating MyBatis-Plus usage.
- Keeping SQL and persistence mapping concerns out of controllers.

Database schema changes must be captured as Flyway migrations.

## Error Flow

Use typed application exceptions and centralized error handling. API responses should use stable error codes from `docs/reference/error-codes.md`.

## Observability Flow

Use SLF4J for logs. Do not log secrets, passwords, tokens, or full payment data. Use structured, searchable fields where practical.
