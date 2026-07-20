# PeikeSmart Skills

**PeikeSmart Copilot 资产统一管理库**——集中管理 PeiKeSmart 组织下多个独立代码仓库共用的 Copilot 资产：全局指令、专用指令、技能、智能体、提示词，规范基于 DH 框架与 NewLife 体系持续演化。

本仓库保留湖北登灏科技有限公司主体表述与"基于DH框架"等必要品牌信息；品牌清理仅清理不应保留的旧品牌信息，不得误删上述表述。

克隆到任意机器后执行一条脚本即可安装到 VS Code 用户数据目录，**无需在每个项目放一份 `.github`**。

> 本仓库不是业务源码 monorepo，它是面向 PeiKeSmart 组织级复用的 Copilot 资产源仓库。详见 `docs/PeiKeSmart多仓库定位说明.md`。

---

## 设计理念

资产采用**三层架构**，分层承担不同职责：

| 层级 | 载体 | 内容 | 维护成本 |
|------|------|------|----------|
| **Tier 1** | NuGet 包 XML 注释 | 类与成员的「如何使用」 | 跟代码一起维护 |
| **Tier 2** | 全局 instructions + 专用 instructions | PeikeSmart 反常规约定（硬约束） | 集中维护 |
| **Tier 3** | skills / agents / prompts | 流程类、架构决策类、跨组件取舍 | 仅必要项 |

**判定原则**：能由 XML 注释或通用知识覆盖的，不做 skill；能由全局 instructions 承担的，不做专用 instructions。

> 详细治理原则见 [`docs/三层架构与维护原则.md`](docs/三层架构与维护原则.md)。

---

## 快速开始

```powershell
git clone https://github.com/PeiKeSmart/Pek.Skills.git
cd Pek.Skills
.\scripts\install-copilot-assets.ps1
```

安装完成后**重启 VS Code**，所有项目即可使用全部资产。

### 更新

直接重新执行 `install-copilot-assets.ps1`。脚本基于 manifest 自动同步：

- 新资产 → 复制
- 仓库已删除但上次安装过的 → **自动清理**（孤儿清理）
- 不会触碰 manifest 之外的文件

### 首次从旧脚本迁移

如果之前用过旧版安装脚本（无 manifest），磁盘上残留了大量旧资产，加 `-AssumeAllOrphans` 一次性清理：

```powershell
# 先预览将清理什么
.\scripts\install-copilot-assets.ps1 -AssumeAllOrphans -WhatIf

# 确认后执行
.\scripts\install-copilot-assets.ps1 -AssumeAllOrphans
```

### 卸载

```powershell
.\scripts\install-copilot-assets.ps1 -Uninstall
```

### 校验

```powershell
# 检查源资产完整性
.\scripts\verify-copilot-assets.ps1

# 同时检查已安装到 VS Code 的资产
.\scripts\verify-copilot-assets.ps1 -CheckInstalled
```

---

## 资产清单

> 完整资产清单以本 README 为**唯一事实源**，新增或删除资产后需同时更新本清单，并运行 `verify-copilot-assets.ps1` 校验一致性。

### 全局指令

[`.github/copilot-instructions.md`](.github/copilot-instructions.md)——所有 PeikeSmart 项目通用的硬约束：加载标注、兼容性、编码规范、防御性注释、工作流、深度思考、Agent 协作协议。

### 专用指令（按关键词触发加载）

存放于 [`.github/instructions/`](.github/instructions)：

| 文件 | 触发场景 |
|------|----------|
| `xcode.instructions.md` | XCode / Model.xml / 实体生成 / 数据库 ORM |
| `cube.instructions.md` | Cube / 魔方 / 后台管理 / EntityController |
| `development.instructions.md` | 新建系统 / 需求分析 / 架构设计 / 迭代开发 |
| `net.instructions.md` | NetServer / 网络编程 / TCP/UDP |
| `benchmark.instructions.md` | 性能测试 / BenchmarkDotNet |
| `caching.instructions.md` | ICache / MemoryCache / Redis 缓存 |
| `serialization.instructions.md` | JSON / Binary / Span 序列化 |
| `security.instructions.md` | 加密 / Hash / JWT / RSA |
| `remoting.instructions.md` | ApiHttpClient / RPC / 负载均衡 |
| `configuration.instructions.md` | Config / IConfigProvider / 配置中心 |

### Skills（按需加载）

存放于 [`.github/skills/`](.github/skills)，每个技能一个子目录（`<name>/SKILL.md`）。当前共 73 个技能文件夹。

**使用指南（usage 类）**——代码示例为主：

| 技能 | 覆盖领域 |
|------|----------|
| `caching` | ICache/MemoryCache/Redis 统一缓存接口 |
| `logging-tracing` | ILog/XTrace 日志与链路追踪 |
| `networking` | NetServer/NetSession TCP/UDP/WebSocket |
| `serialization` | JSON/Binary/Span/CSV 序列化 |
| `configuration` | Config&lt;T&gt;/IConfigProvider 配置管理 |
| `http-client` | ApiHttpClient 多节点 HTTP 客户端 |
| `dependency-injection` | ObjectContainer/Host/Plugin 依赖注入 |
| `timer-scheduling` | TimerX/Cron 高级定时调度 |
| `security` | Hash/AES/SM4/RSA/JWT 安全与加密 |
| `type-conversion` | ToInt/ToBoolean/StringHelper 类型转换 |
| `pek-zero-templates` | Pek.Zero 新建项目模板 |

**前端美化系列（frontend 类）**——12 个技能：

| 技能 | 覆盖领域 |
|------|----------|
| `frontend-design-system` | 设计令牌：色彩/字号/间距/圆角/投影 |
| `frontend-dark-theme` | 亮色/暗色主题设计与实现 |
| `frontend-responsive-layout` | 响应式布局与导航适配 |
| `frontend-tailwind-patterns` | Tailwind CSS 现代模式集 |
| `frontend-theme-customization` | Element Plus/Ant Design 等主题定制 |
| `frontend-table-styling` | 表格美化：斑马纹/Badge/骨架屏 |
| `frontend-form-styling` | 表单美化：浮动标签/校验反馈 |
| `frontend-navigation-styling` | 导航美化：侧边栏/顶栏/标签页 |
| `frontend-card-dashboard` | 仪表盘与卡片布局 |
| `frontend-modal-feedback` | 弹窗与反馈：模态框/Toast/空状态 |
| `frontend-bootstrap-modernize` | Bootstrap 3/4 现代化美化 |
| `frontend-visual-polish` | 视觉精修检查清单（20+ 项） |
| `design-md` | 67 个知名品牌设计令牌集合（色板/字体间距/圆角投影），每个品牌为独立子技能，供前端美化参考 |

**完整技能列表**（共 76 个）：

| 技能 | 覆盖领域 |
|------|----------|
| `agent-service` | NewLife.Agent 跨平台系统服务 |
| `benchmark-testing` | BenchmarkDotNet 性能基准测试 |
| `cache-provider-architecture` | ICache 统一缓存接口与分布式锁 |
| `capture-conventions` | 从仓库中提炼编码风格规律 |
| `coding-standards` | 编码标准与命名规范检查 |
| `compatibility-checks` | 多框架兼容性审查 |
| `compression` | TarFile/SevenZip 文件压缩 |
| `config-provider-system` | 配置提供者架构设计 |
| `cube-jobs` | Cube 定时作业体系 |
| `cube-membership` | Cube 用户认证与权限管理 |
| `cube-mvc-backend` | Cube MVC 后台管理系统 |
| `cube-oauth-sso` | OAuth/SSO 第三方登录 |
| `cube-webapi` | Cube WebAPI 后端 API 服务 |
| `data-file-formats` | CSV/Excel/DbTable 文件读写 |
| `dependency-injection-ioc` | ObjectContainer IoC 容器 |
| `design-md` | 67 个品牌设计令牌参考（含各品牌独立子技能：airbnb/apple/stripe 等） |
| `development-workflow` | 研发全流程规范 |
| `distributed-id` | Snowflake 分布式唯一 ID |
| `event-bus-messaging` | 事件总线与消息解耦 |
| `frontend-reference-faithful` | 像素级前端还原 |
| `high-performance-buffers` | 零拷贝二进制缓冲区 |
| `holiday-calendar` | 中国法定节假日判断 |
| `hosted-services-lifecycle` | 托管服务生命周期 |
| `http-client-loadbalancer` | 多端点负载均衡 HTTP 客户端 |
| `http-server` | 轻量级 HTTP 服务端 |
| `ip-location` | IPv4 归属地查询 |
| `logging-tracing-system` | 日志与链路追踪体系 |
| `map-geocoding` | 地理编码与逆编码 |
| `merge-skill-knowledge` | 技能知识合并 |
| `mqtt-client-server` | MQTT 客户端与内嵌 Broker |
| `network-client` | NetClient/WebClientX 网络客户端 |
| `network-server-sessions` | NetServer/NetSession 高性能服务器 |
| `object-pool` | 无锁 CAS 对象池 |
| `office-documents` | Excel/Word/PPT/PDF 文档生成 |
| `pipeline-handler-model` | 管道处理器责任链 |
| `plugin-framework` | 应用内插件系统 |
| `project-architecture` | 两层/三层架构选型、充血模型 |
| `redis-client` | NewLife.Redis 高性能客户端 |
| `rocketmq-messaging` | Apache RocketMQ 消息队列 |
| `security-crypto-patterns` | Hash/AES/RSA/JWT 加密模式 |
| `serialization-patterns` | 序列化方案选型与扩展 |
| `span-reader-writer` | SpanReader/SpanWriter 二进制读写 |
| `stardust-platform` | 星尘分布式服务平台接入 |
| `system-introspection` | 系统硬件与运行时信息 |
| `testing-strategy` | XCode SQLite 集成测试策略 |
| `timer-scheduler` | TimerX/Cron 高级调度原理 |
| `utility-extensions` | 类型转换/字符串/路径扩展 |
| `xcode-data-access-layer` | DAL 数据访问层与高级查询 |
| `xcode-data-modeling` | Model.xml 数据建模 |
| `xcode-entity-caching` | XCode 多级实体缓存 |
| `xcode-entity-orm` | XCode 实体 CRUD 开发 |
| `xcode-sharding-etl` | 分库分表与数据同步 |

### Agents（用户 `@` 调用）

存放于 [`.github/agents/`](.github/agents)：

| Agent | 用途 |
|-------|------|
| `newlife-expert` | PeikeSmart 全生态技术专家 |
| `code-review` | 按 PeikeSmart 规范 8 维度审查代码 |
| `project-init` | 新项目初始化（优先 Pek.Zero 模板） |
| `requirement-planning` | 需求整理、功能拆分、技术方案、任务分解 |
| `write-tech-docs` | 中文技术文档写作 |
| `release-prep` | 月度发版准备（ChangeLog/版本号/README） |
| `convention-mining` | 分析代码库提炼编码约定 |
| `dev-loop` | 自治开发循环：选取→实现→验证→提交 |
| `implementation-audit` | 需求 vs 实现差距分析审计 |
| `doc-sync` | 代码与文档双向同步 |

### Prompts

存放于 [`.github/prompts/`](.github/prompts)：

| 文件 | 用途 |
|------|------|
| `doc-writer.prompt.md` | 为 C# 代码生成高质量 Markdown 文档 |

---

## 仓库结构

```text
.github/
  copilot-instructions.md      # 全局 Copilot 协作规范（必须遵守）
  instructions/                # 专用指令（关键词触发）
  skills/                      # 技能（按需加载）
  agents/                      # 智能体（@ 调用）
  prompts/                     # 提示词模板
docs/                          # 维护原则与治理文档
scripts/
  install-copilot-assets.ps1   # 安装/更新/卸载（主入口）
  sync-skills-to-user.ps1      # 旧名称兼容包装器
  verify-copilot-assets.ps1    # 校验脚本
```

---

## 安装路径

`install-copilot-assets.ps1` 将资产复制到：

| 资产 | 目标路径 |
|------|----------|
| Skills | `%USERPROFILE%\.copilot\skills\`（官方路径） + `%APPDATA%\Code\User\prompts\skills\`（兼容） |
| Instructions / Prompts / Agents | `%APPDATA%\Code\User\prompts\` |
| 全局指令 | `%APPDATA%\Code\User\prompts\peikesmart-global.instructions.md` |
| VS Code Insiders | 同上，对应 `Code - Insiders` 目录 |

---

## 维护原则

1. **30 天淘汰制**：连续 30 天未触发的 skill / instructions 进入删除候选
2. **搬运型禁止**：能由 XML 注释或通用知识覆盖的内容不做 skill
3. **单一事实源**：API 用法首选 XML 注释；架构决策首选 skill；硬约束首选全局 instructions
4. **改动验证**：修改后在真实项目随机提一个相关问题，观察「已加载」标注是否符合预期

详见 [`docs/三层架构与维护原则.md`](docs/三层架构与维护原则.md)。

---

## 项目使用建议

将本仓库资产安装到 VS Code 后，建议在你的项目 `README.md` 中声明以下信息，帮助 AI 更准确地工作：

```markdown
## AI 协作声明

- **项目类型**：.NET 后端 / Node.js 前端 / 全栈
- **编译命令**：`dotnet build` / `pnpm build`
- **测试命令**：`dotnet test` / `pnpm test`
- **核心项目**：`src/MyApp.Service`（后端）、`src/MyApp.Web`（前端）
```

> 声明后，开发循环 agent 的编译/测试命令检测步骤会优先以 README 声明为准，无需每次手动指定。