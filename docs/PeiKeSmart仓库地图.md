# PeiKeSmart 仓库地图

本文基于 PeiKeSmart 组织页当前可见的公开仓库信息整理，用于帮助在 Pek.Skills 中快速判断目标仓库的大致领域、角色和与本资产仓库的关系。

> 说明：这是一份非穷尽地图，目的是帮助协作定位，不替代各仓库自己的 README、项目文件和源码分析。

## 1. 组织概览

- PeiKeSmart 当前公开展示为多个独立 Git 仓库组成的组织，而不是单一 monorepo。
- Pek.Skills 负责统一沉淀并分发 Copilot 资产。
- 其他仓库按功能大致可分为 AI 基础设施、基础框架、数据访问、存储、中间件、文档处理和 UI 基础库等方向。

## 2. 仓库分类

### 2.1 Copilot 资产与协作规范

| 仓库 | 角色 | 说明 |
|------|------|------|
| `Pek.Skills` | 组织级协作资产仓库 | 集中管理技能、指令、提示词、代理，用于分发到各目标仓库 |

### 2.2 AI 与模型接入

| 仓库 | 角色 | 说明 |
|------|------|------|
| `Pek.NAI` | AI 网关基础库 | 多协议、多模型适配的 AI 基础设施，支持 OpenAI / Anthropic / Gemini 等服务商 |

### 2.3 基础框架与通用核心库

| 仓库 | 角色 | 说明 |
|------|------|------|
| `DH.FrameWork` | 应用基础框架 | 基于 .NET Core 的底层开发框架，含插件模式、ORM 集成与虚拟文件系统 |
| `DH.NCore` | 通用核心组件库 | 日志、配置、缓存、网络、RPC、序列化、APM 等基础能力 |
| `Pek.Common` | 通用基础类库 | 面向 DH / Pek 体系的公共基类与核心抽象 |
| `Pek.AOT` | AOT 支撑库 | 面向 Pek 框架的 AOT 方向能力 |
| `Pek.Maui.Base` | MAUI 基础库 | .NET MAUI 应用程序基础设施 |

### 2.4 数据与存储相关

| 仓库 | 角色 | 说明 |
|------|------|------|
| `DH.NCode` | 数据中间件 | 支持多数据库，侧重缓存、性能、分表、自动建表 |
| `DH.NRedis` | Redis 客户端 | 面向高性能缓存与消息队列场景 |
| `DH.MySql` | MySQL 驱动 | 零第三方依赖、高性能 ADO.NET 驱动 |
| `Pek.MDB` | 内存数据库 | 基于 JSON 持久化存储的内存数据库 |
| `Pek.VirtualFileSystem` | 虚拟文件系统 | 文件系统抽象与相关基础能力 |

### 2.5 文档与 Office 处理

| 仓库 | 角色 | 说明 |
|------|------|------|
| `Pek.MiniExcel` | Excel 处理库 | 侧重查询、写入、填充数据且避免 OOM |
| `Pek.MiniWord` | Word 模板引擎 | .NET Word(docx) 导出模板引擎，支持 Linux / Mac |
| `Pek.MiniPdf` | PDF 转换工具库 | 提供 Word / Excel 转 PDF 能力 |

## 3. 在 Pek.Skills 中如何使用这份地图

### 3.1 当用户打开的是目标代码仓库时

- 先判断目标仓库属于哪一类：AI、基础框架、数据存储、文档处理还是 UI 基础库。
- 再决定优先启用哪些技能和指令，例如：
  - 数据/ORM 类仓库优先关注 `xcode-*`、`cache-provider-architecture`、`serialization-patterns`
  - Web/Cube 类仓库优先关注 `cube-*`、`frontend-*`、`write-tech-docs`
  - 基础框架类仓库优先关注 `coding-standards`、`compatibility-checks`、`logging-tracing-system`

### 3.2 当用户在 Pek.Skills 中工作时

- 不要把这份地图当成“当前工作区源码结构”。
- 应把它当成组织级导航信息，用于帮助判断某条规则或某个技能未来主要服务哪类目标仓库。

## 4. 使用限制

- 本文基于组织页当前可见公开仓库摘要整理，不包含全部 119 个仓库的逐一源码分析。
- 具体技术边界仍应以目标仓库的 README、源码、项目文件和实际依赖为准。
- 当组织中新仓库出现、旧仓库定位变化时，应同步更新本文。 