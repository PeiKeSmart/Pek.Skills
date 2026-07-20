---
name: xml-comment-enrichment
description: 'XML 注释 AI 友好化刷新：分级策略补全 <summary>/<param>/<returns>/<example>/<remarks>。适用于核心库的公共 API 文档注释完善任务，提升 NuGet 包 XML 注释质量。'
---

# XML 注释 AI 友好化刷新

## 适用场景

- 核心库（NewLife.Core / NewLife.XCode / NewLife.Cube 等）的公共 API 注释完善
- NuGet 包即将发版前，XML 注释质量基线检查
- AI 作为主要读者——清晰完整的 XML 注释是 AI 正确使用 API 的第一信息源

## 分级策略

### P0: 核心类型（最高优先级，逐文件人工+AI 通读）

| 目标 | 要求 | 产出 |
|------|------|------|
| `public` 类/接口/委托 | `<summary>` + `<remarks>`（含适用/不适用场景） | 每类型至少一个 `<example>` |
| `public` 方法（含参数） | `<summary>` + 每个参数 `<param>` + `<returns>` | 核心方法有 `<example>` |
| `public` 属性 | `<summary>` + `<value>`（如非自描述） | — |
| 关键枚举 | `<summary>` + 每个成员逐行注释 | — |

### P1: 普通类型（覆盖全部 public 成员）

| 目标 | 要求 | 产出 |
|------|------|------|
| 全部 `public` 类型 | `<summary>` 一句话定位 | 无 `<example>` |
| 全部 `public` 方法 | `<summary>` + `<param>`×N + `<returns>` | 无 `<example>` |

### P2: 工具级别（最少干预）

| 目标 | 要求 |
|------|------|
| 内部/私有成员 | 不动 |
| 明显的自描述方法（如 `GetId()`） | 保持原样 |
| 明显过时注释 | 仅删除明显错误的注释 |

## 注释规范

```csharp
/// <summary>根据订单编号获取订单信息</summary>
/// <param name="orderId">订单编号</param>
/// <returns>订单实体，未找到时返回 null</returns>
/// <remarks>
/// 此方法会查询数据库并缓存结果。适用于高频读取场景。
/// 不适用于需要实时一致性的场景（请改用 FindByKey）。
/// </remarks>
/// <example>
/// <code>
/// var order = OrderService.FindByOrderId("ORD20240101001");
/// if (order != null) Console.WriteLine(order.Status);
/// </code>
/// </example>
```

## 执行流程

1. 从项目 `.csproj` 确定目标框架和 `public` API 表面
2. 扫描 `public` 类型和方法，统计缺少注释的比率
3. 按 P0 → P1 → P2 优先级逐类补全
4. 编译验证（错误的 XML 注释会导致编译警告）
5. 重新生成 NuGet 包并验证 XML 文件包含在包中
