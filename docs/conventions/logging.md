---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Logging Conventions

## Logger

Use SLF4J logging. Do not use `System.out.println` or `e.printStackTrace()`.

Example:

```java
private static final Logger log = LoggerFactory.getLogger(ProjectService.class);
```

When Lombok is already used in a class, `@Slf4j` is acceptable.

## Levels

- `ERROR`: unexpected failures that require investigation.
- `WARN`: recoverable problems or unusual states.
- `INFO`: important lifecycle or business events.
- `DEBUG`: diagnostic details for local investigation.
- `TRACE`: very detailed diagnostics, rarely needed.

## Sensitive Data

Never log:

- Passwords
- Access tokens
- Refresh tokens
- API keys
- Full payment data
- Personal data that is not necessary for investigation

## Message Style

Write logs as concise facts with useful identifiers:

```java
log.info("Project created: projectId={}, ownerId={}", projectId, ownerId);
```

Use parameterized logging instead of string concatenation.

## Exceptions

Log unexpected exceptions with the throwable:

```java
log.error("Failed to create project: ownerId={}", ownerId, ex);
```

Do not call `printStackTrace()`.
