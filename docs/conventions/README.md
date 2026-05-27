---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Development Conventions

## Baseline

Follow the technical baseline defined in `.codex/AGENTS.md`:

- Java 25
- Spring Boot 3.5.14
- Maven 3.9.16
- MyBatis-Plus and Flyway for persistence
- MySQL as the primary database

Do not introduce JPA or Hibernate.

## Required Practices

- Use constructor injection. Field-level `@Autowired` is not allowed.
- Prefer Lombok `@RequiredArgsConstructor` for required dependencies.
- Add JUnit 5 tests for new code.
- Keep line coverage at or above 80%.
- Keep Java files at or below 300 lines.
- Keep Java methods at or below 50 lines.
- Use SLF4J logging.
- Do not use `System.out.println` or `e.printStackTrace()`.
- Do not use raw `RestTemplate` or `HttpURLConnection`.
- Avoid star imports and unused imports.

## Quality Commands

Use Maven verification before merging:

```bash
mvn verify
```

Run Checkstyle explicitly when working on formatting or imports:

```bash
mvn checkstyle:check
```

Run SpotBugs explicitly when reviewing defect risk:

```bash
mvn spotbugs:check
```

## Related Documents

- `docs/conventions/naming.md`
- `docs/conventions/error-handling.md`
- `docs/conventions/testing.md`
- `docs/conventions/logging.md`
