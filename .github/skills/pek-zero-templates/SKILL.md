---
name: pek-zero-templates
description: >
  Pek.Zero 新建项目模板指南：用于 PekMvc、PekVueZero、PekBundle.Template 聚合模板的安装、选型、生成和 SmokeTest。
  适用于新建项目、初始化后台系统、初始化前后端分离项目、选择 pekmvc 或 pekvuezero 模板、处理 Pek.Zero 模板安装与使用问题。
  当用户提到 Pek.Zero、PekMvc、PekVueZero、pekmvc、pekvuezero、模板、脚手架、dotnet new、新建项目时优先使用。
  不用于修改已有业务代码或替代目标仓库本身的业务设计。
argument-hint: >
  说明想创建的项目类型：后台管理系统 / 前后端分离系统 / 仅项目骨架；
  并补充是否已有 Pek.Zero 本地源码仓库。
---

# Pek.Zero 新建项目模板

## 适用场景

- 使用 Pek.Zero 体系快速创建后台管理项目。
- 使用 PekVueZero 创建 Vue 3 + ASP.NET Core 前后端分离骨架。
- 使用 PekMvc 创建服务端渲染或后台管理项目骨架。
- 在新机器上安装、校验或更新 Pek.Zero 模板包。

## 模板来源

- 本地源码优先：若项目所在根目录下存在 `Code` 目录，优先检索其中的 `Pek.Zero/Templates/`。
- 对外安装入口统一使用聚合模板包 `PekBundle.Template`。
- 单模板包仅用于本地打包验证，不作为对外安装入口。

## 模板选型

| 场景 | 推荐模板 | 说明 |
|------|----------|------|
| 后台管理网站 / MVC 项目 | `pekmvc` | 生成单项目 PekMvc Web 项目 |
| 后台管理网站解决方案骨架 | `pekmvc-sln` | 生成带解决方案骨架的 PekMvc 项目 |
| 前后端分离项目 | `pekvuezero` | 生成 Vue 3 + Vite + ASP.NET Core 项目骨架 |
| 前后端分离解决方案骨架 | `pekvuezero-sln` | 生成带解决方案文件的完整骨架 |

## 安装与更新

### 优先方式：使用本地 Pek.Zero 仓库打包安装

```powershell
cd .\Templates\PeiKeSmart.Template.Bundle
.\pack-template.ps1 -Install
```

### 已发布包安装

```powershell
dotnet new install PekBundle.Template
```

### 更新或重装

```powershell
dotnet new uninstall PekBundle.Template
dotnet new install PekBundle.Template
```

### 校验模板是否可用

```powershell
dotnet new list | Select-String -Pattern 'pekmvc|pekvuezero'
dotnet new pekmvc -h
dotnet new pekvuezero -h
```

## 常用命令

### PekMvc 项目模板

```powershell
dotnet new pekmvc -n DemoPekMvc -o .\Output\DemoPekMvc
```

### PekMvc 解决方案模板

```powershell
dotnet new pekmvc-sln -n DemoPekMvcSolution -o .\Output\DemoPekMvcSolution
```

### PekVueZero 项目模板

```powershell
dotnet new pekvuezero -n DemoPekVueZero -o .\Output\DemoPekVueZero
```

### PekVueZero 解决方案模板

```powershell
dotnet new pekvuezero-sln -n DemoPekVueZero -o .\Output\DemoPekVueZero
```

## 常用参数

### PekMvc

- `ProjectTitle`
- `ProjectDescription`
- `CompanyName`
- `ServiceName`
- `DbConnName`

### PekVueZero

- `ProjectTitle`
- `ProjectDescription`
- `CompanyName`
- `ServiceName`
- `ServerHttpPort`
- `ServerHttpsPort`
- `ClientDevPort`
- `ClientPackageName`

## 生成后验证

### PekMvc

```powershell
dotnet build .\Output\DemoPekMvc\DemoPekMvc.csproj -nologo
```

### PekVueZero 后端

```powershell
dotnet build .\Output\DemoPekVueZero\DemoPekVueZero.Server\DemoPekVueZero.Server.csproj -nologo
```

### PekVueZero 解决方案

```powershell
dotnet build .\Output\DemoPekVueZero\DemoPekVueZero.slnx -nologo
```

## 使用约定

- 当用户提到 Pek.Zero、PekMvc、PekVueZero、模板、脚手架、新建项目时，默认优先使用本技能给出的 Pek.Zero 模板链路。
- 本技能不再提供 NewLife 通用模板分流；项目初始化场景默认按 PeiKeSmart 自有模板处理。
- 若当前机器还未安装 Pek.Zero 聚合模板，先提示安装或从本地 Pek.Zero 仓库执行打包安装。
- 模板生成后，至少执行一次帮助检查或编译检查，避免只给命令不验证。