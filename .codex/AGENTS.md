# AGENTS.md

## 项目简介
- [一句话] 这是一个面向中小企业的在线项目管理平台，基于 Spring Boot 3.5.14 + Java 25 + MySQL Connector/J 9.7.0。

## 技术基线（不允许擅自升级）
- JDK: 25
- Spring Boot: 3.5.14 (Spring Framework 6.2.18)
- Maven: 3.9.16
- 数据库驱动: MySQL Connector/J 9.7.0
- 持久化: MyBatis-Plus 3.5.16 (基于 MyBatis 3.5.19) + Flyway 11.7.2 (含 flyway-mysql 模块)，不引入 JPA / Hibernate

## 快速导航
|你想做什么|去哪里看|
|---|---|
|了解系统架构|docs/architecture/overview.md|
|了解模块边界和依赖规则|docs/architecture/boundaries.md|
|了解编码规范|docs/conventions/README.md|
|了解当前选代任务|docs/plans/current-snippet.md|
|了解 API 规范|docs/reference/api-spec.yaml|
|了解错误码|docs/reference/error-codes.md|
|了解测试规范|docs/testing/README.md|

## 硬性规则（必须遵守，CI 会验证）
1. 依赖方向: domain -> config -> mapper -> service -> controller
2. 模块关注点 (auth/log/telemetry) 只能通过 Spring 注入，禁止 `new` 实例
3. 单文件 (.java) ≤ 300 行；单方法 ≤ 50 行
4. 禁止 `System.out.println` / `e.printStackTrace()`，统一使用 SLF4J `Logger`
5. 禁止裸 `RestTemplate` / `HttpURLConnection`，统一通过 `ApiClient` 抽象
6. 禁止字段级 `@Autowired`，必须构造注入 (推荐 Lombok `@RequiredArgsConstructor`)
7. 新增代码必须有对应 JUnit 5 测试，行覆盖率 ≥ 80%

## 提交规范
- feat: 新功能
- fix: 修复
- refactor: 重构
- test：测试
