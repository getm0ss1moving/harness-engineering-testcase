---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Testing Conventions

## Baseline

Use JUnit 5 for all new tests. New code must include corresponding tests and keep line coverage at or above 80%.

## Test Types

### Unit Tests

Use unit tests for focused business rules and branching logic. Mock external collaborators where appropriate.

### Slice Tests

Use Spring test slices when testing web, mapper, or persistence behavior in isolation.

### Integration Tests

Use integration tests for workflows that cross multiple application layers or depend on Spring wiring.

### Architecture Tests

Use ArchUnit tests to enforce package dependencies and layer boundaries.

## Naming

Test class names should end with `Test`.

Use behavior-oriented test method names:

```java
createsProjectWhenRequestIsValid()
rejectsProjectWhenNameIsBlank()
returnsNotFoundWhenProjectDoesNotExist()
```

## Test Data

Keep test data local to the test unless reuse improves clarity. Avoid hidden shared mutable fixtures.

## Coverage

Coverage is a quality signal, not the goal by itself. Prioritize meaningful assertions for business rules, error paths, and integration boundaries.
