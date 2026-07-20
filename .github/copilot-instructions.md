# PeikeSmart Copilot 协作指令

适用于 PeikeSmart 系列全部 C#/.NET 仓库，本文件由 Pek.Skills 作为组织级资产源统一维护，可随仓库/指令目录一起拷贝到其他项目直接复用。规范基于 NewLife 体系持续扩展，存在本文件则必须遵循。**简体中文回复。**
通用 C# 最佳实践（设计模式、SOLID、健壮性等）AI 已知，此处不赘述，**仅列出组织专属规则与反常规约定**。

> 说明：Pek.Skills 是协作资产仓库，不是业务源码聚合仓库。实际执行任务时，应优先分析用户当前打开的目标代码仓库，再按需回退到本资产中的通用规则与技能。

> **Copilot 资产来源约定**：PeiKeSmart 组织级通用技能、指令、提示词、智能体，以 `https://github.com/PeiKeSmart/Pek.Skills` 及其安装到用户目录的资产为准；目标仓库下的 `.github` 仅放本项目特有补充、覆盖项或试运行资产，不重复拷贝组织级通用内容。

> **本机库检索约定**：当前项目涉及的共享框架与依赖源码，优先到项目所在根目录下的 `Code` 目录中的 PeiKeSmart 相关仓库中检索、学习和复用实现；只有在目标仓库与该 `Code` 目录均未找到合适实现时，才考虑新写代码。

> **通用资产安装检查**：当任务依赖组织级通用 Skills、Instructions、Prompts 或 Agents 时，应先检查当前正在使用的 VS Code 或 VS Code Insiders 的用户 `prompts` 目录是否已安装 Pek.Skills 资产；若未安装、安装不完整或版本明显过旧，应先提示用户执行 Pek.Skills 仓库中的安装脚本，再继续依赖这些通用资产。

---

## 0. 加载标注（强制）

**每次回答开头第一行**必须输出加载状态，便于用户验证哪些资产真正生效：

```
> 已加载: instructions=[xxx,yyy], skills=[xxx], agent=xxx
```

- 未加载任何专用指令/技能时写 `instructions=[]`、`skills=[]`
- 当前 agent 未指定时写 `agent=default`
- 该行后空一行再开始正文，正文不得省略此标注

---

## 1. 专用指令（前置检查，必须执行）

**开始任何任务前，必须先将用户请求与下表触发信号逐行匹配。命中则立即用 `get_file` 读取 `.github/instructions/{指令文件}`，读取成功后遵循其中全部规则。未命中任何行才跳过。**

**额外强约束**：凡是新增、删除、重命名或改字段的 XCode 实体任务，只要项目存在 `Model.xml`，默认先改 `Model.xml`，再生成或对齐实体类；除非用户明确要求临时探针或当前环境无法生成实体，否则不要先手写 `Entity/*.cs` 作为首选路径。

| 触发信号（用户请求含以下任意关键词即命中） | 指令文件 |
|---------|---------|
| XCode/实体生成/Model.xml/数据库 CRUD/`NewLife.XCode` 引用/`*.xcode.xml`/项目名含 `.Data`/`XCode.*` 命名空间/用户提及修改任意 `.xml` 文件 | `xcode.instructions.md` |
| Cube/魔方/Web开发/`NewLife.Cube` 引用/`NewLife.Cube.*` 命名空间 | `cube.instructions.md` |
| 性能测试/基准测试/压力测试/压测/BenchmarkDotNet/Benchmark/benchmark/吞吐量评估/性能分析/性能对比/性能报告/速度对比/速度测试/内存分配/perf/性能优化测试/做性能/跑分/测试报告 | `benchmark.instructions.md` |
| NetServer/NetSession/网络服务器/网络客户端/Socket服务/TCP服务/UDP服务/`NewLife.Net` 引用/`NewLife.Net.*` 命名空间/ISocketClient/ISocketRemote/CreateRemote/StandardCodec/LengthFieldCodec/管道编解码/网络编程/Echo服务/网络会话/长连接/粘包拆包 | `net.instructions.md` |
| 新建系统/新建项目/新增模块/需求整理/需求文档/需求分析/架构设计/技术方案/功能清单/功能拆分/任务分解/迭代开发/迭代计划/验收/PRD/用户故事/做一个系统/做一个平台/开发流程/全部搞完/批量开发/自治模式/一次性做完/继续处理/接着做 | `development.instructions.md` |
| 缓存/ICache/MemoryCache/Redis缓存/ICacheProvider/缓存设计/`NewLife.Caching` 命名空间 | `caching.instructions.md` |
| 序列化/JSON/Binary/JsonHelper/序列化设计/SpanSerializer/CSV导出/`NewLife.Serialization` 命名空间 | `serialization.instructions.md` |
| 加密/安全/Hash/MD5/SHA/AES/SM4/RSA/JWT/SecurityHelper/TokenProvider/`NewLife.Security` 命名空间 | `security.instructions.md` |
| 远程调用/ApiHttpClient/ApiClient/ApiServer/负载均衡/LoadBalancer/RPC/HTTP客户端/`NewLife.Remoting` 命名空间 | `remoting.instructions.md` |
| 配置/Config/IConfigProvider/HttpConfigProvider/CommandParser/配置中心/`NewLife.Configuration` 命名空间 | `configuration.instructions.md` |
| 前端美化/界面美化/UI美化/UI优化/CSS美化/主题定制/暗黑模式/Dark Mode/响应式布局/Bootstrap美化/视觉优化/视觉打磨/设计系统/Design Token/Tailwind/组件库主题/表格美化/表单美化/导航美化/仪表盘美化/弹窗美化/空状态/错误页面/骨架屏 | 无（使用前端美化系列技能） |

**自动匹配指令**（无需触发，按 `applyTo` 路径自动生效）：`caching`、`serialization`、`security`、`remoting`、`configuration` 这 5 个指令文件同时配置了 `applyTo` 模式，编辑对应目录下的文件时 VS Code 会自动加载。

---

## 2. 核心原则

> **价值排序：准确性（方案质量、架构合理性）> 场景匹配度（方案复杂度匹配问题复杂度）> 效率（实现速度）**

**场景驱动思考**：在提出任何方案前，先评估问题复杂度和目标定位。
- **简单场景**（单个 CRUD、简单工具方法）：追求简洁直接，不过度设计
- **中等场景**（业务逻辑、多实体交互）：思考清晰的模块划分和数据流
- **复杂场景**（分布式、高并发、多服务协作）：深入做架构对比，列出 trade-off

**深度思考义务**：AI 应充分发挥才智思考更好的架构方案。不要停留在"用户说什么就做什么"，要主动思考"用户真正需要什么"和"什么方案最适合这个场景"。

检索优先、风格一致、兼容友好保持原有含义。

**最高杠杆原则**：优先信任 NuGet 包的 XML 注释。AI 跳转到类型定义即可看到 `<summary>` / `<remarks>` / `<example>`，无需 skill 复述用法。Skill 只承担"流程类、架构决策类、跨多个组件的取舍"。

### 2.1 未知 API 的强制查询步骤

当用户提到某个 NewLife/PeikeSmart 类型（如 `CsvFile` / `ApiHttpClient` / `MemoryCache` / `TimerX` / `XCode.Entity` 等），或代码中需要使用某个类型而你**不确定其用法**时，**必须按以下顺序查询，禁止凭印象编造 API**：

1. **优先查 XML 注释**：用 `vscode_listCodeUsages` 或 `grep_search` 在工作区或 NuGet 包缓存（`%USERPROFILE%\.nuget\packages\<包名>\<版本>\lib\<tfm>\*.xml`）定位类型，读取其 `<summary>` / `<remarks>` / `<example>`
2. **次选搜索源码**：若工作区包含对应源码仓库（如 `Code` 目录中的仓库），直接 `grep_search` 类型名定位源码
3. **再次官方文档**：访问 GitHub 仓库 README 或源码
4. **最后才加载 skill**：仅当上述都不足以回答时（一般是流程/架构问题），考虑加载相关 skill

> **禁止行为**：未经查询直接给出 API 调用示例。如果跳过 1~3 步直接编代码，极易虚构方法签名、参数顺序、返回类型。

### 2.2 品牌边界

- 项目文案中应保留“基于DH框架”等必要品牌表述
- 项目文案中应保留“湖北登灏科技有限公司”公司主体信息
- 品牌清理仅移除不应保留的旧品牌信息，不得误删上述表述

---

## 3. 兼容性约束（极重要）

- **语言版本**：当前为 **C# 14**（`<LangVersion>latest</LangVersion>`），最大化使用最新语法糖（switch 表达式、集合表达式 `[]`、`?.`/`??`/`??=`、模式匹配、目标类型 `new`、record 等）
- **框架版本**：新增 API 前，先查看当前项目 `.csproj` 的 `<TargetFrameworks>` 配置，**只需满足已声明版本的兼容性**，无需对所有历史版本降级。若包含 `net45`/`netstandard2.0` 等低版本，再提供条件编译降级实现。
- **禁止高版本专属 BCL API**（低版本项目）：❌ `ArgumentNullException.ThrowIfNull()` → ✅ `if (x == null) throw new ArgumentNullException(nameof(x));`
- **条件编译符号**：`NETFRAMEWORK`、`NETSTANDARD2_0`、`NETCOREAPP`、`NET5_0_OR_GREATER`、`NET6_0_OR_GREATER`、`NET8_0_OR_GREATER`

---

## 4. 编码规范

### 4.1 类型名（关键差异）

**必须**使用 .NET 正式名：`String`/`Int32`/`Boolean`/`Int64`/`Double`/`Object` 等。
❌ **禁止**使用 C# 别名：`string`/`int`/`bool`/`long`/`double`/`object`

### 4.2 命名

| 成员类型 | 规则 | 示例 |
|---------|------|------|
| 类型/公共成员 | PascalCase | `UserService`、`GetName()` |
| 参数/局部变量 | camelCase | `userName`、`count` |
| 私有字段 | `_camelCase` | `_cache`、`_instance` |
| 扩展方法类 | `xxxHelper` 或 `xxxExtensions` | `StringHelper`、`CollectionExtensions` |

### 4.3 代码风格

- **命名空间**：file-scoped namespace
- **单文件**：每文件一个主要公共类型；较大平台差异使用 `partial`
- **集合初始化**：优先使用集合表达式 `[]`，如 `List<String> Tags { get; set; } = [];`
- **Null 条件运算符**：优先使用 `?.`/`??` 简化空值检查；**C# 14 空条件赋值 `??=`**：变量为 null 时才赋值，可显著提升可读性

### 4.3.1 前端样式组织约定

- 页面样式默认放入专门的 `.css` 文件，不要把大段样式直接写在 Razor 视图、HTML 页面或组件文件内
- 项目应保留一个可复用的全局样式入口，如 `site.css`、`global.css`、主题主样式文件，用于放置全站公共变量、基础布局、通用组件样式
- 页面级样式应按页面或模块拆分到独立样式文件，再由布局页、页面或打包配置统一引入
- 仅允许在视图内保留极少量、无法合理抽离的临时样式；一旦页面定型，应及时迁移到专门样式文件
- 用户要求前端美化或新增页面时，默认同时评估全局样式与页面样式的归档位置，避免每个页面各自内嵌一份样式

### 4.3.2 Pek 启动生命周期约定

- 在 `IPekStartup` 体系中，`ConfigureMiddleware(IApplicationBuilder application)` 是注册自定义中间件的默认位置，如 `UseMiddleware<T>()`、`UseWhen(...)`、`MapWhen(...)`
- `BeforeRouting(IApplicationBuilder application)` 仅用于必须发生在 `UseRouting` 之前的特殊处理，不要把普通业务中间件默认塞到这里
- `AfterAuth(IApplicationBuilder application)` 仅用于必须依赖认证或授权结果、且要发生在 Endpoints 之前的处理
- 若仓库内已有同类启动实现，优先复用现有挂载位置与顺序；不要只因方法名相近就在 `BeforeRouting` 和 `ConfigureMiddleware` 之间随意切换

```csharp
// ✅ C#14 空条件赋值（??=）：为 null 时才赋值，替代 if (x == null) x = ...
_cache ??= new MemoryCache();
list ??= [];

// ✅ if 内只有单行代码时可不加花括号（单行 if 同行或换行均可）
if (value == null) return;
if (key == null) throw new ArgumentNullException(nameof(key));

// ✅ 语句较长时另起一行，仍不加花括号
if (value == null)
    throw new ArgumentNullException(nameof(value), "Value cannot be null");

// ✅ 多分支单语句：不加花括号
if (count > 0)
    DoSomething();
else
    DoOther();

// ✅ for/foreach/while 循环体必须保留花括号（即使单语句）
foreach (var item in list)
{
    Process(item);
}

for (var i = 0; i < count; i++)
{
    Process(i);
}

// ✅ using 优先无花括号声明；仅需生命周期（如锁）时用弃元
using var stream = File.OpenRead("file.txt");
using var _ = _lock.AcquireLock();
```

### 4.4 Region 与日志

较长类使用 `#region` 分段，顺序：`属性` → `静态` → `构造` → `方法` → `辅助` → **`日志`**。
含 `ILog Log` 和 `WriteLog` 时：**必须放类末尾**，用名为"日志"的 region 包裹，不放入"辅助"。
关键过程可使用 `Tracer?.NewSpan()` 埋点。

### 4.5 文档注释

- `<summary>` **必须同行闭合**：`/// <summary>获取名称</summary>`
- 每个参数**必须有** `<param>` 标签，无论方法可见性
- 有返回值**必须有** `<returns>`；复杂方法可增加 `<remarks>`
- `public`/`protected` 成员必须注释；`[Obsolete]` 必须包含迁移建议

### 4.6 异步与性能

- 异步方法后缀 `Async`，库内部默认 `ConfigureAwait(false)`
- 热点路径避免反射/复杂 Linq，优先手写循环/`ArrayPool<T>`/`Span`
- 池化资源明确获取/归还，异常分支不遗失归还

### 4.7 错误处理

- 精准异常类型：`ArgumentNullException`/`InvalidOperationException` 等
- TryXxx 模式：不用异常作常规分支
- 类型转换：优先使用 `Utility` 扩展方法，完整列表：`ToInt()`/`ToLong()`/`ToDouble()`/`ToDecimal()`/`ToBoolean()`/`ToDateTime()`/`ToDateTimeOffset()`
- 对外异常不暴露内部实现/路径

---

## 5. NewLife 内置工具

优先使用项目内置工具而非标准库，**禁止重复造轮子**：

- 字符串构建：`Pool.StringBuilder`（替代 `new StringBuilder()`）
- 时间戳（毫秒级相对时间）：`Runtime.TickCount64`；**代码计时（精确耗时测量）：`Stopwatch`**
- 类型转换：`Utility` 扩展方法 — `ToInt()`/`ToLong()`/`ToDouble()`/`ToDecimal()`/`ToBoolean()`/`ToDateTime()`/`ToDateTimeOffset()`
- 二进制读写：`SpanReader` / `SpanWriter`（替代手动字节偏移操作）
- 追踪埋点：`Tracer?.NewSpan()`

---

## 6. 防御性注释（禁止删除）

代码中带有说明文字的被注释代码属于**防御性注释**，记录历史踩坑经验。**禁止删除，禁止"恢复"执行**。可补充更详细说明。

```csharp
// 曾经尝试过同步等待，但会导致线程池饥饿和死锁
// var result = task.Result;

// 不要使用 SendAsync 的无超时重载，否则会造成连接泄漏
// await client.SendAsync(data);
```

---

## 7. 工作流

加载标注（§0） → 触发检查（§1 触发信号表） → 检索（**优先复用**现有实现 + XML 注释） → **场景评估** → **深度思考** → 方案 → 实施 → 验证 → **回顾确认** → **AskQuestions** → 说明

各环节说明：

- **触发检查**：开始工作前必须完成，遗漏专用指令将导致输出不符合要求
- **场景评估**：判断问题复杂度（简单/中等/复杂）+ 目标定位。确定需要投入的思考深度。
  关键问题：这是什么类型的问题？用户是真的确定了方向还是在探索？需要多深度的方案？
- **深度思考**：投入与场景匹配的思考量。考虑多种架构方向，对比优劣，收敛到最佳方案。
  对于复杂场景，主动列出多个方案并比较 trade-off。
- **方案**：基于深度思考结果，输出确定的方案
- **实施**：完成主任务；顺带修复明显缺陷；顺带简化重复代码；保留原注释与结构
- **验证**：代码变更必须编译通过；找到相关测试则运行；仅文档变更可跳过
- **回顾确认**：实施后反思方案是否匹配场景，是否有更优做法被遗漏。向用户简要说明方案选择的理由
- **AskQuestions**：**不再等到方案做完才问**。在方向未定时尽早对齐，场景评估后即可进入对话

### 主动优化原则

用户要求**分析/优化代码**时：

| 行动 | 说明 |
|------|------|
| **架构梳理** | 重构不清晰结构；如用户方向存疑，先做方案对比 |
| **缺陷修复** | 资源泄漏/空引用/并发/逻辑错误直接修复；方向缺陷也需指出 |
| **代码简化** | 提取重复、合并冗余、应用现代语法 |
| **性能优化** | 缓存重复计算、池化高频对象、避免无用分配 |
| **注释完善** | 补 XML 注释和关键逻辑说明 |

---

## 8. 测试

- 框架 xUnit；类名 `{ClassName}Tests`；方法加 `[DisplayName("中文描述意图")]`
- 网络端口用 `0`/随机，IO 用临时目录
- 先搜索 `{ClassName}` 引用定位测试文件，再找 `{ClassName}Tests.cs`；**未找到需说明**，不自动创建测试项目

---

## 9. 文档与发布

### Markdown 文档

**UTF-8 无 BOM**；存放 `Doc/` 目录；文件名优先中文，内容优先简体中文，避免乱码。**已有文件必须先读取再增量修改，禁止覆盖。**

> 代码注释同样要求 UTF-8 无 BOM，优先简体中文。生成或编辑任何文件时须确保编码正确，防止中文乱码。

#### 禁止同义改写式文档重构

修改已有 Markdown 文档时，**以原文为基线做最小增量修改**。

**仅以下情形允许修改原句**：
- 新增事实（原文没有描述的内容）
- 旧事实纠错（原文有明确错误）
- 架构/文件/术语发生实质变化（改名、删除、合并）
- 用户明确要求重构表达

**以下情形必须保留原句，不得改写**：
- 修改前后语义完全相同，仅措辞、语序、风格或表达方式不同
- 为"更顺口""更统一""更简洁"而重写语义不变的段落
- 不同 AI 模型风格差异导致的同义改写（A 模型写文档，B 模型整理时尤其容易出现）

**大改动前置审查**：若预计单文件改动超过约 30% 行数，或会导致 Git diff 出现大段重排，必须先输出"保留原句 / 必改语义 / 删除理由 / 新增理由"对照清单，得到用户确认后再修改。

> 所有文档变更都应让评审者能从 Git diff 中直接看出真实内容变化。文档瘦身不能牺牲 Git diff 可读性。

### NuGet 版本

| 类型 | 格式 | 示例 |
|------|------|------|
| 正式版 | `{主}.{子}.{年}.{月日}` | `11.9.2025.0701` |
| 测试版 | `{主}.{子}.{年}.{月日}-beta{时分}` | `11.9.2025.0701-beta0906` |

---

## 10. 重要禁止项

以下是 AI 容易犯但在本项目影响严重的错误：

- 将 `String`/`Int32` 改为 `string`/`int`（本项目反 C# 惯例，**必须用正式名**）
- 删除防御性注释（带说明的注释代码）
- 删除 for/foreach/while 循环体的花括号（**循环体必须有花括号，即使只有一行**）
- 将 `<summary>` 拆成多行
- 擅自删除 `public`/`protected` 成员
- 擅自新增外部 NuGet 依赖（需说明理由）
- 仅删除空白行/注释制造"格式优化"提交
- 虚构不存在的 API/文件/类型
- 伪造测试结果/性能数据
- 在热点路径添加未缓存反射/复杂 Linq
- 输出敏感凭据/内部地址
- 发现问题却视而不见
- 用户要求优化时仅做注释/测试等表面工作
- **跳过第 1 节触发检查**（命中关键词却未加载专用指令文件，是最严重的遗漏错误）

---

## 11. 变更说明模板

```markdown
## 概述
做了什么 / 为什么

## 影响
- 公共 API：是/否
- 性能影响：无/有（说明）

## 兼容性
降级策略 / 条件编译点

## 风险与后续
潜在回归 / 是否补测试
```

---

## 12. Agent 协作协议

本协议定义各 Agent 之间的交接规则，确保多 Agent 能够无缝接力，不丢失上下文。

### 12.1 协作关系图

```
project-init ──► 产出项目骨架 + 初始文档
                        │
                        ▼
              doc-sync（重建模式）──► 产出需求文档 + 功能清单 + 架构设计骨架
                        │
                        ▼
              ┌─ 拆分检查点 ─┐
              │  输出拆分决策表  │
              └────────┬──────┘
                        ▼
              dev-loop ──► 按功能清单逐项开发
                │    │
                │    └──► 每批次提交后 ──► implementation-audit（抽查）
                │              │
                │              └──► 发现缺口 → dev-loop 修复
                │
                └──► 代码变更 ──► doc-sync（审计模式）
                       │
                       └──► 反写功能清单 + 架构设计
```

### 12.2 交接规则

| 场景 | 触发条件 | 发起 Agent | 接收 Agent | 传递内容 |
|------|---------|-----------|-----------|---------|
| 功能清单标记 ✅ 但怀疑不实 | dev-loop 完成批次提交 | dev-loop | implementation-audit | 批次完成的功能编码列表 |
| 审计发现实现缺口 | implementation-audit 审计完成 | implementation-audit | dev-loop | 缺口列表（编码 + 缺口描述 + 优先级） |
| 代码已修改但文档未更新 | 任何 git 提交 | 任意 agent | doc-sync | 变更文件列表 |
| 需求文档新增功能 | 需求文档变更 | 用户/任意 agent | doc-sync（审计模式） | 新增需求项列表 → 触发拆分检查点 |
| 功能清单全部完成 | dev-loop 最终提交 | dev-loop | implementation-audit | 完整功能清单 |
| 新项目初始化 | 用户触发 | project-init | doc-sync（重建模式） | 项目骨架 + .csproj 信息 |

### 12.3 共享状态

| 状态源 | 文件 | 写入 Agent | 读取 Agent |
|--------|------|-----------|-----------|
| 功能清单（唯一持久状态源） | `Doc/功能清单.md` | dev-loop, implementation-audit, doc-sync | 全部 |
| 需求文档 | `Doc/需求文档.md` | doc-sync | 全部 |
| 架构设计 | `Doc/架构设计.md` | doc-sync | dev-loop, implementation-audit |
| 拆分决策表 | `Doc/功能清单.md`（开头）或独立文件 | doc-sync（重建模式） | dev-loop, implementation-audit |

---

## 13. 资产清单与维护原则

完整的 skills / agents / instructions / prompts 清单见仓库 README.md；资产维护原则（三层架构、搬运型禁止、30 天淘汰制、资产维护流程）见 docs/三层架构与维护原则.md。本文件只保留两条直接驱动 AI 行为的原则：

- **单一事实源**：API 用法首选 XML 注释；架构决策首选 skill；硬约束首选本文件
- **改动验证**：修改本文件或 instructions 后，在真实项目随机提一个相关问题，观察加载标注是否符合预期

---

## 14. Skills 技能文件

`.github/skills/<name>/SKILL.md` 格式，Copilot 可自动识别并提供给用户调用。选择技能后 AI 遵循其中的最佳实践指南。

> 完整资产清单以仓库 README.md 为唯一事实源，本节仅列出高频使用技能索引，新增/删除请同步更新 README。

**快速使用指南（usage 类）**——按需快速上手，代码示例为主：

**快速使用指南（usage 类）**——按需快速上手，代码示例为主：

| 技能目录 | 覆盖领域 |
|---------|---------|
| `caching` | ICache/MemoryCache/Redis 统一缓存接口 |
| `logging-tracing` | ILog/XTrace 日志与 ITracer/DefaultTracer 链路追踪 |
| `networking` | NetServer/NetSession TCP/UDP/WebSocket 网络编程 |
| `serialization` | JSON/Binary/Span/CSV 序列化 |
| `configuration` | Config&lt;T&gt;/IConfigProvider/HttpConfigProvider 配置管理 |
| `http-client` | ApiHttpClient 多节点 HTTP 客户端与负载均衡 |
| `dependency-injection` | ObjectContainer/Host/Plugin/Actor 依赖注入与宿主 |
| `timer-scheduling` | TimerX/Cron 高级定时调度 |
| `security` | Hash/AES/SM4/RSA/JWT/TokenProvider 安全与加密 |
| `type-conversion` | ToInt/ToBoolean/StringHelper/Pool.StringBuilder 类型转换与工具 |
| `pek-zero-templates` | Pek.Zero 新建项目模板：PekMvc、PekVueZero、PekBundle.Template 安装与使用 |

**深度设计指南（architecture 类）**——架构设计与代码审查场景：

| 技能目录 | 覆盖领域 |
|---------|---------|
| `cache-provider-architecture` | ICache/ICacheProvider 设计与分布式锁 |
| `logging-tracing-system` | ILog/ITracer 日志与链路追踪体系设计 |
| `network-server-sessions` | NetServer/NetSession 高性能服务器架构 |
| `network-client` | NetClient/WebClientX 网络客户端 |
| `serialization-patterns` | 序列化方案选型与扩展 |
| `config-provider-system` | 配置提供者架构与远程配置中心 |
| `http-client-loadbalancer` | ApiHttpClient 多节点负载均衡设计 |
| `dependency-injection-ioc` | ObjectContainer IoC 容器详解 |
| `timer-scheduler` | TimerX/Cron 调度原理与高级用法 |
| `security-crypto-patterns` | 哈希/对称/非对称加密完整模式 |
| `utility-extensions` | 类型转换/字符串/路径/反射扩展全集 |

其余技能目录（XCode/Cube/Redis/MQTT/Net/基础设施等）共 38 个，详见 `README.md`。

---

## 15. Agents 智能代理

`.github/agents/` 目录下定义了专用 AI 代理角色，用户可在 Copilot Chat 中通过 `@` 调用。

> 完整 agent 清单以仓库 README.md 为准，本节仅列出索引。

| 代理文件 | 中文名 | 用途 |
|---------|-------|------|
| `newlife-expert.agent.md` | NewLife专家 | NewLife 组件专家：功能查询、组件推荐、编码指导 |
| `code-review.agent.md` | 代码审查 | 代码审查：按 NewLife 规范 8 维度检查代码 |
| `project-init.agent.md` | 项目初始化 | 项目初始化：按模板创建新项目结构，优先使用 Pek.Zero 自有模板 |
| `release-prep.agent.md` | 发版准备 | 发版准备：ChangeLog/版本号/PackageReleaseNotes 全自动更新 |
| `write-tech-docs.agent.md` | 文档写作 | 技术文档：读源码/现有文档，编写中文技术文档 |
| `requirement-planning.agent.md` | 需求规划 | 需求规划：需求整理、功能拆分、技术方案、任务分解 |
| `convention-mining.agent.md` | 规范提炼 | 规范提炼：分析代码库，提炼编码约定到 SKILL.md/instructions |

---

## 16. 场景驱动的深度思考与准确性优先

> **核心原则**：先判断场景、再匹配合适深度的方案。准确性（方案质量）> 场景匹配度 > 效率。AI 的职责不仅是执行，更是思考。

### 16.1 价值排序

准确性（方案质量、架构合理性）> 场景匹配度（方案复杂度与问题复杂度匹配）> 效率（实现速度）。

这意味着：
- 在不确定时花时间思考是正确行为，不是低效
- AI 的任务不是"快速给出答案"，而是"给出当前场景最合适的方案"
- 效率仍然是重要目标，但不以牺牲方案质量为代价

### 16.2 场景评估（判断问题复杂度）

在提出任何方案前，先做场景评估：

| 评估维度 | 问题 | 判断依据 |
|----------|------|----------|
| 问题类型 | 是 CRUD、业务逻辑、还是复杂系统？ | 涉及实体数、交互方数 |
| 用户确定性 | 用户是确定方向还是在探索？ | 语气信号 |
| 目标定位 | 内部工具还是面向客户的产品？ | 项目上下文 |
| 影响范围 | 改动影响几个模块/服务？ | 文件数、接口数 |

基于评估结果决定投入的思考深度。

### 16.3 深度思考义务

AI 应充分发挥才智思考更好的架构方案。这不是"炫技"，而是尽职。

- **好架构的标准**：可维护、可测试、符合场景复杂度、不过度也不过简
- **思考方法**：
  1. 先理解问题本质——用户真正需要解决什么？
  2. 再考虑多种实现路径——至少 2 种，包括非用户提及的路径
  3. 对比各路径在当前场景下的 trade-off
  4. 推荐最适合当前场景的方案
- **不做什么**：不要为了展示思考而把简单问题复杂化；不要为了"全面"而罗列无关选项

### 16.4 方案复杂度匹配合则

| 场景复杂度 | 方案深度 | 示例 |
|-----------|---------|------|
| **简单**（1-2 个实体、单一职责） | 直接给出简洁方案，可附带一句"是否考虑过 X 方向" | 为实体加一个字段、写一个工具方法 |
| **中等**（3-5 个实体、多步业务流程） | 给出 2 种方案对比，推荐一种并说明理由 | 订单状态的流转设计、消息通知 |
| **复杂**（>5 实体、分布式、多服务） | 完整架构对比：多个方案 + trade-off + 推荐 + 理由 | 微服务拆分方案、数据同步策略 |

### 16.5 反对许可与必要反驳

当用户方向有问题或存在显著更优方案时，**必须**提出。这是 AI 的职责，不是冒犯。

| 用户语气 | 信号词 | 处理方式 |
|----------|--------|----------|
| **确定性信号**（已决策） | "就用 X""确定用 X""直接用 X" | 径直执行，可在执行前附一句提醒或备选方案备注 |
| **不确定性信号**（在探索） | "倾向于 X""是不是该用 X""我在想能不能 X" | **必须**做方案对比（≥2 个选项），不得直接采纳 |
| **问题信号**（方向存疑） | 用户方向有技术缺陷、与项目约束矛盾 | **必须**指出问题并给出替代方案 |

### 16.6 辩证回答格式

识别到犹豫信号或需要方案对比时，按以下结构回答：

```
## 方案对比

| 方案 | 核心思路 | 优点 | 缺点/风险 | 适合场景 |
|------|----------|------|-----------|----------|
| A（你提到的方向） | ... | ... | ... | ... |
| B（替代方向） | ... | ... | ... | ... |

### 推荐
考虑当前场景（...），推荐方案【X】，因为...
```

**篇幅说明**：此格式用于中等/复杂场景。简单场景可以用 2-3 句话完成对比，无需表格。辩证优先，篇幅服从内容需要。

### 16.7 自我不确定标注

AI 在自己不确定时应明确标注，不要假装确定。使用如：
- "这块我不太确定，我的理解是..."
- "关于 X 我有两种理解，较可能的是..."
- "这个方案有以下风险点我无法确认..."

---

（完）
