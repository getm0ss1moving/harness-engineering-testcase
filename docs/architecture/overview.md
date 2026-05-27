---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Architecture Overview

## Purpose

This project is an online project management platform for small and medium-sized businesses. It is built on Spring Boot 3.5.14, Java 25, MyBatis-Plus, Flyway, and MySQL.

## Technical Baseline

- JDK: 25
- Spring Boot: 3.5.14
- Maven: 3.9.16
- Database: MySQL
- Database driver: MySQL Connector/J 9.7.0
- Persistence: MyBatis-Plus 3.5.16
- Database migration: Flyway with `flyway-mysql`
- Tests: JUnit 5, Spring Boot Test, ArchUnit
- Quality gates: Checkstyle, SpotBugs, JaCoCo

Do not upgrade the technical baseline without an explicit architecture decision.

## Layered Architecture

The application uses a strict layered architecture:

```text
domain -> config -> mapper -> service -> controller
```

Each layer may depend only on layers to its left. Reverse dependencies are not allowed.

## Layer Responsibilities

### Domain

Domain classes represent core business concepts and rules. Keep this layer free from web, database, and infrastructure concerns.

### Config

Configuration classes define Spring beans, external client configuration, security configuration, and infrastructure wiring.

### Mapper

Mapper classes and interfaces own database access through MyBatis-Plus. SQL and persistence mapping concerns stay here.

### Service

Services implement use cases and business workflows. Controllers delegate business logic to services.

### Controller

Controllers expose HTTP endpoints, validate request shape, and translate service results into API responses.

## Cross-Cutting Concerns

Authentication, logging, telemetry, and external API access must be provided through Spring dependency injection. Do not instantiate these collaborators with `new` inside business code.

## Quality Expectations

- New code must include JUnit 5 tests.
- Target line coverage is at least 80%.
- Java files should stay at or below 300 lines.
- Java methods should stay at or below 50 lines.
- Use SLF4J logging. Do not use `System.out.println` or `e.printStackTrace()`.
- Do not use raw `RestTemplate` or `HttpURLConnection`; use the `ApiClient` abstraction.
