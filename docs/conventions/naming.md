---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Naming Conventions

## Packages

Use lowercase package names. Prefer feature-first package layout:

```text
com.example.harnessengineering.<feature>.<layer>
```

Examples:

```text
com.example.harnessengineering.auth.controller
com.example.harnessengineering.project.service
com.example.harnessengineering.billing.mapper
```

## Classes

Use clear role suffixes:

- Controllers: `ProjectController`
- Services: `ProjectService`
- Service implementations: `ProjectServiceImpl`, only when an interface is needed.
- Mappers: `ProjectMapper`
- Request DTOs: `CreateProjectRequest`
- Response DTOs: `ProjectResponse`
- Exceptions: `ProjectNotFoundException`
- Configuration: `ApiClientConfig`

Avoid generic names such as `Manager`, `Helper`, `Util`, or `Common` unless the class is genuinely cross-cutting and the name is precise.

## Methods

Use verbs that describe the behavior:

- `createProject`
- `archiveProject`
- `findProjectById`
- `listProjects`
- `ensureProjectExists`

Methods returning booleans should read as predicates:

- `isOwner`
- `hasPermission`
- `canAccessProject`

## Variables

Use descriptive names. Avoid one-letter variables except in small local scopes where the meaning is standard and obvious.

## Database Objects

Use snake_case for tables and columns:

```text
project
project_member
created_at
updated_at
```

Flyway migration files should use this format:

```text
V<version>__<description>.sql
```

Example:

```text
V1__create_project_tables.sql
```
