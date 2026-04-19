# 目标仓库接入 Pek.Skills 指南

本文用于说明：PeiKeSmart 组织下的业务仓库、组件仓库、基础库仓库，如何稳定接入 Pek.Skills 提供的 Copilot 资产。

## 1. 适用范围

适用于以下类型仓库：

- Pek.NAI
- Pek.Common
- Pek.Maui.Base
- DH.FrameWork
- DH.NCore
- DH.NCode
- 其他 PeiKeSmart 组织内独立代码仓库

不适用于：

- 把 Pek.Skills 本身当作业务源码仓库使用
- 希望用 Pek.Skills 替代目标仓库自己的项目结构、测试工程、CI/CD 配置

## 2. 接入目标

稳定接入的标准不是“目标仓库里也复制一份 `.github`”，而是满足以下几点：

1. 开发机已安装 Pek.Skills 分发的用户级 Copilot 资产
2. 目标仓库自身仍保留最小必要的本仓库规则
3. Copilot 在执行任务时，优先读取目标仓库源码与规则，再回退到 Pek.Skills 通用资产

## 3. 推荐接入方式

### 3.1 开发机侧安装一次即可

在任意机器上克隆 Pek.Skills 后执行：

```powershell
git clone https://github.com/PeiKeSmart/Pek.Skills.git
cd Pek.Skills
.\scripts\install-copilot-assets.ps1
```

建议在安装后执行：

```powershell
.\scripts\verify-copilot-assets.ps1 -CheckInstalled
```

含义：

- `install-copilot-assets.ps1` 负责把 Skills、Instructions、Prompts、Agents、全局指令同步到 VS Code 用户目录
- `verify-copilot-assets.ps1 -CheckInstalled` 负责确认“源仓库资产”与“用户目录已安装资产”同时完整

### 3.2 目标仓库保留最小本地规则

即使已经安装 Pek.Skills，目标仓库仍建议保留以下最小上下文：

- 仓库自己的 `README.md`
- 仓库自己的 `copilot-instructions.md` 或 `.github/copilot-instructions.md`
- 仓库自己的项目文件、测试工程、CI/CD 配置
- 仓库自己的模块说明或架构文档

原因：

- Pek.Skills 解决的是“跨仓库复用的组织规则”
- 目标仓库自己的规则，仍然只有目标仓库自己最清楚

## 4. Copilot 的正确决策顺序

在目标仓库中工作时，应按以下顺序组织上下文：

1. 先读目标仓库源码、项目文件、测试、README
2. 再读目标仓库本地的协作指令和模块规则
3. 若目标仓库缺少显式规则，再回退到 Pek.Skills 的通用 Skills / Instructions / Agents
4. 必要时才回溯上游 NewLife 生态源码或说明资料

这条顺序很关键，因为它直接决定 Copilot 输出的是“贴合当前仓库”的建议，还是“泛化模板式”的建议。

## 5. 目标仓库建议保留的本地内容

为了让 Pek.Skills 真正在目标仓库里发挥作用，建议目标仓库至少具备以下内容：

### 5.1 仓库入口文档

- 仓库目标是什么
- 主要项目/模块有哪些
- 如何编译、测试、运行
- 依赖哪些核心包或基础设施

### 5.2 本仓库特殊约束

例如：

- 是否必须使用 `String` / `Int32` 正式名
- 是否允许引入新 NuGet 依赖
- 是否有必须遵循的目录结构
- 是否有特定测试策略或性能基线

### 5.3 关键模块指令

如果目标仓库有明显模块边界，建议补充模块级说明，例如：

- XCode 数据层说明
- Cube 后台说明
- API 接口规范
- 前端主题或组件库约束

## 6. 什么时候应该改 Pek.Skills，什么时候只改目标仓库

### 应改 Pek.Skills 的情况

- 某条规则适用于多个仓库
- 某个技能已经在多个仓库里重复出现
- 某个 Agent / Prompt / Instruction 属于组织级共识
- 某个经验来自目标仓库，但具备跨仓库复用价值

### 只应改目标仓库的情况

- 只适用于当前仓库的目录结构
- 只适用于当前仓库的业务术语
- 只适用于当前仓库的构建、测试、部署流程
- 只适用于当前仓库的特殊历史兼容约束

## 7. 推荐落地流程

新仓库接入时，建议按以下顺序执行：

1. 在开发机安装 Pek.Skills 资产
2. 在目标仓库补齐 README、项目说明、测试说明
3. 为目标仓库补齐最小 `copilot-instructions.md`
4. 用真实任务验证 Copilot 是否会先读取目标仓库再回退 Pek.Skills
5. 若发现某条规则具备跨仓库复用价值，再沉淀回 Pek.Skills

## 8. 验收标准

一个目标仓库可以认为“已经稳定接入 Pek.Skills”，至少应满足：

- 开发机上 Pek.Skills 已正确安装
- 目标仓库保留了自己的最小规则与文档
- Copilot 输出会优先贴合目标仓库，而不是把 Pek.Skills 当业务仓库处理
- 组织级通用规则能在目标仓库中正常被复用

## 9. 常见错误接法

### 错误一：把 Pek.Skills 拷贝进每个目标仓库

问题：

- 容易形成多份分叉资产
- 维护成本高
- 很快出现不同仓库规则不一致

### 错误二：目标仓库什么都不写，完全依赖 Pek.Skills

问题：

- Copilot 缺少当前仓库真实上下文
- 代码建议容易偏向通用规则，而不是当前实现

### 错误三：把上游 NewLife 技术名词全部替换成品牌名

问题：

- 会破坏真实包名、命名空间、模板命令的准确性
- 让代码建议和实际依赖脱节

## 10. 结论

Pek.Skills 的正确角色是“组织级协作资产源”，不是“目标仓库替身”。

最稳的接法是：

- 机器级安装 Pek.Skills
- 仓库级保留目标仓库自己的最小规则
- Copilot 决策时始终先看目标仓库，再回退 Pek.Skills

这样才能既复用组织资产，又不丢失目标仓库真实上下文。