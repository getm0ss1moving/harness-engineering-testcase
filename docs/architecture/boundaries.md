---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Module Boundaries

## Dependency Rule

The allowed dependency direction is:

```text
domain -> config -> mapper -> service -> controller
```

This means:

- `controller` may depend on `service`, `mapper`, `config`, and `domain`.
- `service` may depend on `mapper`, `config`, and `domain`.
- `mapper` may depend on `config` and `domain`.
- `config` may depend on `domain`.
- `domain` must not depend on application infrastructure.

Prefer narrower dependencies when possible. For example, controllers should usually depend on services only.

## Package Intent

Use package names that make the layer and feature clear:

```text
com.example.harnessengineering.<feature>.<layer>
```

Example:

```text
com.example.harnessengineering.project.controller
com.example.harnessengineering.project.service
com.example.harnessengineering.project.mapper
com.example.harnessengineering.project.domain
```

## Boundary Rules

- Controllers must not contain business workflow logic.
- Services must not return persistence-specific implementation details unless part of an explicit API contract.
- Mappers must not call services or controllers.
- Domain objects must not depend on Spring MVC, MyBatis, or transport-specific classes.
- Shared auth, log, and telemetry components must be injected by Spring.
- Do not construct infrastructure collaborators directly with `new`.

## External API Access

All external HTTP calls must go through the `ApiClient` abstraction. Do not use raw `RestTemplate` or `HttpURLConnection`.

## Enforcement

Boundary rules should be covered by ArchUnit tests. Add or update ArchUnit tests whenever a new package or architectural dependency is introduced.
