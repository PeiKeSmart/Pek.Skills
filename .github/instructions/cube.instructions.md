# Cube 协作指令

本指令面向基于 NewLife.Cube 的管理后台与 WebAPI 开发任务，帮助 Copilot 在 PeikeSmart 目标仓库中正确区分 Cube MVC、Cube WebAPI、配置页面、权限菜单和定时作业等常见场景。

---

## 1. 适用边界

- 适用于 `NewLife.Cube`、`NewLife.CubeNC`、`EntityController<T>`、`ConfigController<T>`、`AreaBase`、`TokenService`、`ManageProvider` 等相关任务。
- 目标应是用户当前打开的业务代码仓库，而不是 Pek.Skills 资产仓库本身。
- 若任务主要涉及数据建模、`Model.xml`、实体生成或数据库 CRUD，优先回到 `xcode.instructions.md`。
- 若任务主要涉及页面样式优化、表格/表单/导航美化，优先结合前端美化系列 skills，而不是只停留在 Cube 控制器层。

---

## 2. 场景分流

### 2.1 Cube MVC 后台

适用于：

- Area 区域注册
- `EntityController<T>` 实体 CRUD 页面
- 字段定制、视图覆盖、菜单与权限配置

优先参考：

- `cube-mvc-backend`
- `cube-membership`
- `cube-jobs`

### 2.2 Cube WebAPI

适用于：

- REST API 开发
- Token / JWT 认证
- `ControllerBaseX` / `BaseController` / `AppControllerBase`
- Swagger、OAuth、SSO 集成

优先参考：

- `cube-webapi`
- `cube-oauth-sso`

---

## 3. 执行规则

- 先识别目标仓库使用的是 Cube MVC 还是 Cube WebAPI，不要混用控制器基类与中间件说明。
- 优先复用现有 `AddCube()` / `UseCube()` 启动方式、现有 Area 结构和权限菜单约定，不要凭空创造新入口。
- 涉及认证、用户、角色、令牌、在线状态时，优先沿用 Membership 体系，不要绕开 `ManageProvider` / `UserService` / `TokenService` 自建一套。
- 涉及配置页面时，优先考虑 `ConfigController<T>`；涉及定时任务时，优先考虑 `AddCubeJob()` 与 `ICubeJob` 体系。

---

## 4. 产出要求

- 说明当前任务属于 Cube MVC、Cube WebAPI、配置管理还是作业系统。
- 给出与目标仓库现有结构一致的修改点，例如 Area、控制器、配置类、作业类或启动入口。
- 若需要代码示例，保留真实 `NewLife.Cube` / `NewLife.CubeNC` / `NewLife.Templates` 名称，不做品牌化改写。