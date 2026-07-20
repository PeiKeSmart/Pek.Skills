---
name: design-md
description: >-
  知名品牌设计系统参考合集，涵盖 Apple、Stripe、Spotify、Tesla、Supabase 等 67 个品牌的设计令牌
  （色板、字体层级、间距圆角、投影、交互色等）。适用于前端美化、主题定制、设计系统参考、
  品牌视觉分析等任务。每个品牌子目录包含 DESIGN.md（完整设计令牌 YAML）和 README.md（来源说明）。
  使用方式：`design-md/<品牌名>/DESIGN.md`。
---

# Design MD — 品牌设计系统参考合集

本技能提供 67 个知名品牌的设计系统分析参考，每个品牌一个子目录，包含完整的色板、字体层级、间距规范等设计令牌。

## 使用方式

当用户要求前端美化、主题定制、或参考某个品牌风格时：

1. 从用户描述中识别品牌关键词
2. 在 `design-md/` 下找到对应品牌目录
3. 读取 `DESIGN.md` 中的 YAML frontmatter 获取设计令牌
4. 将色彩、字体等设计令牌应用到用户的前端项目中

## 品牌列表

| 品牌目录 | 设计风格特征 |
|----------|-------------|
| `apple` | 摄影优先、SF Pro Display、单品牌蓝、光影产品卡 |
| `airbnb` | 温暖圆润、Cereal 字体、Rausch 红、 hospitality 感 |
| `binance` | 加密深色主题、金黄品牌色、科技感、数据密集 |
| `bmw` | 德国精密主义、运动蓝白、清晰信息层级 |
| `bmw-m` | 高性能子品牌、三色条纹、赛道基因、深色激进 |
| `bugatti` | 超豪华、深碳纤黑、法式优雅、极简奢华 |
| `claude` | AI 对话界面、柔和紫、温暖中性、清晰排版 |
| `clickhouse` | 数据技术品牌、亮黄+深蓝、极简数据感 |
| `coinbase` | 加密金融、品牌蓝、透明信任感、简洁 SaaS |
| `cursor` | AI 编程工具、现代深色、高对比代码界面 |
| `elevenlabs` | AI 语音、声波纹紫、深色沉浸、科技感 |
| `expo` | React Native 工具、紫色渐变、开发者友好 |
| `ferrari` | 超跑品牌、法拉利红、黑色运动、意式激情 |
| `figma` | 设计工具、品牌紫、社区驱动、协作界面 |
| `framer` | 网站构建器、动态交互、深色/亮色双模式 |
| `hashicorp` | 基础设施品牌、简洁深色、企业级、产品家族 |
| `ibm` | 企业级设计、IBM Plex 字体、蓝色体系、Carbon 设计系统 |
| `intercom` | SaaS 客服、蓝色系、对话式界面、温暖专业 |
| `linear.app` | 极简项目管理、深色模式标杆、高性能感 |
| `mastercard` | 支付品牌、双色圆、简洁全球感、红色系 |
| `meta` | 社交巨头、品牌蓝、Facebook/Meta 渐变 |
| `mongodb` | 数据库品牌、MongoDB 绿、开发者文档感 |
| `nike` | 运动品牌、Just Do It、黑白云、动感排版 |
| `notion` | 笔记/文档、灰色系、无 chrome、内容优先 |
| `nvidia` | GPU 品牌、英伟达绿、科技深色、游戏/计算 |
| `ollama` | AI 本地运行、温和紫、开源感、简洁 |
| `pinterest` | 视觉发现、红色系、瀑布流、灵感驱动 |
| `playstation` | 游戏品牌、PS 蓝、深色沉浸、娱乐感 |
| `posthog` | 产品分析、橙色系、开源、数据可视化 |
| `raycast` | macOS 效率工具、深色/亮色、扩展生态 |
| `replicate` | AI 模型平台、紫色渐变、科技简洁 |
| `resend` | 邮件 API、深色品牌、开发者体验 |
| `revolut` | 金融科技、深色/亮色、现代 banking |
| `sanity` | 无头 CMS、红色系、内容平台、开发者友好 |
| `sentry` | 错误追踪、橙色系、监控面板、数据驱动 |
| `shopify` | 电商平台、绿色系、商家优先、SaaS 感 |
| `slack` | 协作工具、紫色系、多色频道、对话界面 |
| `spacex` | 航天品牌、深空黑、科技白、未来感 |
| `spotify` | 音乐流媒体、黑色+绿色、暗色模式、内容优先 |
| `starbucks` | 咖啡品牌、星巴克绿、温暖、生活方式 |
| `stripe` | 支付基础设施、Stripe 蓝紫、极简、开发者至上的深色/亮色系统 |
| `supabase` | 开源数据库、翠绿单品牌色、白+近黑系统、自定义人文无衬线字体 |
| `tesla` | 电动汽车、极简科技、深色/亮色、产品优先 |
| `uber` | 出行平台、黑色系、城市感、高效 |
| `vercel` | 部署平台、白色/黑色、紫色品牌、开发者优先 |
| `zapier` | 自动化平台、黄色品牌色、连接感、SaaS |

## 设计令牌说明

每个 `DESIGN.md` 的 YAML frontmatter 包含以下字段：

| 字段 | 说明 |
|------|------|
| `colors` | 品牌色板（primary、ink、canvas、surface 等语义色） |
| `typography` | 字体层级（fontFamily、fontSize、fontWeight、lineHeight、letterSpacing） |
| `description` | 品牌设计语言一句话概括 |

## 适用场景

- **前端美化**：参考知名品牌的色彩体系和排版规范
- **主题定制**：提取品牌色板作为主题配置输入
- **设计系统参考**：对比不同品牌的设计令牌差异
- **品牌视觉分析**：快速了解某个品牌的视觉语言特征
