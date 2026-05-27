---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Current Sprint

## Sprint Goal

Establish the project foundation for a Spring Boot project management platform with clear architecture, coding standards, quality gates, and initial feature design.

## Active Work

- Create architecture documentation.
- Create development conventions.
- Define initial auth, search, and billing feature designs.
- Define API and error-code references.
- Prepare the project for implementation with tests and quality checks.

## Engineering Rules

- Keep the Java 25 and Spring Boot 3.5.14 baseline.
- Use MyBatis-Plus and Flyway for persistence.
- Do not introduce JPA or Hibernate.
- Use constructor injection.
- Add tests with new implementation work.
- Maintain at least 80% line coverage.

## Exit Criteria

- Documentation exists under `docs/`.
- Architecture boundaries are clear enough to implement ArchUnit tests.
- API reference has initial endpoint placeholders.
- Error-code reference has initial stable codes.
- `mvn verify` remains the standard verification command.
