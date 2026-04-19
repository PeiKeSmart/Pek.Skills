# PeiKeSmart 多仓库定位说明

本文用于说明 PeiKeSmart 组织的仓库结构，以及 Pek.Skills 在其中的职责边界，避免把“组织下多个独立仓库”误解为“单仓库内多个子项目”。

## 1. 结论

- PeiKeSmart 是一个包含多个独立 Git 仓库的组织，不是单一业务 monorepo。
- Pek.Skills 是组织级 Copilot 资产仓库，负责统一维护技能、指令、提示词和代理。
- Pek.Skills 本身不承载各业务仓库的 C# 项目源码，也不替代目标仓库自己的 `csproj`、测试和发布流程。
- 各代理、提示词、指令默认应先分析用户当前打开的目标代码仓库，再按需回退到 Pek.Skills 中沉淀的组织级规则。

## 2. 仓库角色划分

### 2.1 Pek.Skills

职责：

- 维护组织级 Copilot 资产
- 沉淀跨仓库复用的协作规范
- 汇总从上游 NewLife 与下游 PeiKeSmart 代码仓库提炼出的稳定经验
- 提供统一安装脚本，把资产同步到 VS Code 用户目录

不负责：

- 承载业务模块源码
- 作为运行时应用或类库进行编译发布
- 替代目标仓库的项目结构、依赖关系和测试工程

### 2.2 目标代码仓库

典型示例：

- Pek.NAI
- Pek.Common
- Pek.Maui.Base
- DH.FrameWork
- DH.NCore
- DH.NCode

职责：

- 承载真实业务或基础组件源码
- 定义仓库自己的项目结构、依赖、测试与发布规则
- 在需要时加载 Pek.Skills 分发的协作资产

## 3. 使用规则

### 3.1 在 Pek.Skills 中工作时

应优先处理：

- README、docs、安装脚本
- `.github/skills/`、`.github/instructions/`、`.github/prompts/`、`.github/agents/`
- 资产分发逻辑与组织级协作规范

不应假定：

- 当前仓库存在 `csproj`、`.sln` 或业务代码目录
- 可以直接对 Pek.Skills 运行业务编译、单元测试、发版流程

### 3.2 在目标代码仓库中使用这些资产时

应优先分析：

- 当前打开仓库的源码、项目文件、README、工作流、测试
- 当前打开仓库本地已有的 `copilot-instructions.md` 与模块指令
- 目标仓库真实依赖的是 PeikeSmart 自有组件还是上游 NewLife 生态

仅在目标仓库缺少显式规范时，才回退到 Pek.Skills 中的通用规则。

## 4. 常见误区

### 误区一：把组织下多个仓库当成当前工作区里的多个子 Git 项目

正确理解：

- PeiKeSmart 组织下确实有很多独立仓库
- 但 Pek.Skills 本地工作区通常只包含 Pek.Skills 自己这一个 Git 仓库
- 除非显式做了子模块或嵌套仓库集成，否则不能把组织页上的仓库列表当成当前工作区结构

### 误区二：把 Pek.Skills 当成业务源码仓库

正确理解：

- Pek.Skills 是“规则与资产源”
- 真正的源码分析、代码审查、编译验证、发布准备，原则上都应针对当前打开的目标代码仓库执行

### 误区三：把品牌名称替换成技术名词替换

正确理解：

- 品牌层可使用 PeikeSmart / PeiKeSmart
- 真实技术名词、包名、模板命令仍应保留 `NewLife.*`、`XCode`、`Cube`、`NewLife.Templates` 等原始名称

## 5. 文档维护建议

- 在 README 中始终强调 Pek.Skills 是组织级资产仓库
- 在 agent / prompt / instructions 开头明确“实际执行对象是目标代码仓库”
- 当从某个目标仓库提炼出稳定经验时，优先沉淀到 Pek.Skills，再回流到其他仓库复用
- 若未来需要做组织总览，可单独维护“仓库地图”文档，不要把 Pek.Skills README 写成源码总览