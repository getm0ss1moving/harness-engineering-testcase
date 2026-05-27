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

## Codex Agent 清理自动化
当用户或应用内自动化提醒触发“代码库卫生清理”“清理 agent”“自动清理”或类似任务时，Codex 必须由 agent 自行执行以下流程，不依赖额外清理脚本。

### 清理检查清单
1. 超长文件: 找出 `src/main/java/` 下超过 300 行的 `.java` 文件，能安全拆分时拆分为更小的类。
2. 缺失测试: 找出 `src/main/java/` 下没有对应 `*Test.java` 的业务类，补充基础 JUnit 5 测试；`package-info.java` 不视为待测业务类。
3. 未使用 import: 清理所有未使用的 import；如项目引入 Spotless，可优先使用 `spotless:apply`，否则按 IDE/编译/Checkstyle 结果手动清理。
4. TODO/FIXME: 列出所有 `TODO` 和 `FIXME`。超过 30 天未处理且能安全修复的，单独生成清理修改；无法判断日期或安全性的，跳过并记录原因。
5. 重复代码: 找出高度相似的代码段（超过 10 行），能安全抽取时提取到合适的共享组件；基础设施工具放在 `infrastructure/` 边界内。
6. 过时文档: 检查 `docs/design/` 中状态为 `Draft` 且超过 30 天未更新的文档；能安全更新状态或内容时单独处理，否则记录原因。
7. Checkstyle/SpotBugs 历史告警: 执行 `mvn -B clean verify`，清理累计的非阻塞告警；如果告警来自已知工具兼容性且无法安全修复，记录原因。

### 修复与 PR 切分
- 每个发现的问题必须作为独立修复单元处理，不要把不同清理项混在同一个提交或 PR。
- 每个修复单元的 PR 标题格式必须为 `chore(cleanup): [具体描述]`。
- 每个修复单元完成后必须执行 `mvn -B clean verify`。
- 如果需要隔离验证，执行 `./scripts/agent-verify.sh HEAD`。
- 如果当前没有 GitHub remote 或认证信息，不要伪造 PR；改为在本地生成独立提交，并在最终说明中列出建议 PR 标题、提交范围和缺失的上传条件。

### 代码约束
- 严禁使用 Java 8 及以下的老旧语法或样板写法，例如 Lombok `@Data`。
- 必须使用 Java 25 语法范式，优先使用 `record`、`var`、text blocks。
- 严禁引入 `javax.*`，必须全面使用 `jakarta.*`。
- 不允许升级 Spring Boot 主版本，必须保持 3.5.x。
- 如果不确定某个修改是否安全，跳过并在结果中标注原因。

### 应用内自动化提醒建议
建议在 Codex 应用中设置提醒文案：
`每天早上 9:00 提醒我在 /Users/duanzeyu/Desktop/Harness_enginering 执行代码库卫生清理 agent：按 .codex/AGENTS.md 的 Codex Agent 清理自动化清单检查并修复问题；每个问题独立处理，修复后运行 mvn -B clean verify；需要隔离验证时运行 ./scripts/agent-verify.sh HEAD；不要上传 GitHub，除非我明确要求。`

