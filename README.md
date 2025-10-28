# 🔥 FireShot - Firecrawl 云 API 实践项目

> **项目**: FireShot - Firecrawl 云 API 最佳实践和 HawaiiHub 数据采集
> **更新时间**: 2025-10-27
> **维护者**: HawaiiHub AI Team

---

## 📖 项目简介

FireShot 是 HawaiiHub 的数据采集专项项目，基于 **Firecrawl 云 API**，为 HawaiiHub 平台提供强大的网页采集、爬取和数据提取能力。

### 🎯 核心功能

- ✅ **Scrape**: 单页内容采集，转换为 LLM-ready Markdown
- ✅ **Crawl**: 深度爬取，自动发现和采集整站内容
- ✅ **Map**: 快速生成网站结构图
- ✅ **Search**: 智能搜索互联网内容
- ✅ **Batch Scrape**: 高效并发处理多个 URL

### 🌐 应用场景

- 🏠 夏威夷租房信息采集（Craigslist、本地租房网站）
- 🍜 餐厅数据爬取（Yelp、华人餐厅网站）
- 📰 本地新闻采集（Hawaii News Now、Star Advertiser）
- 🏢 商家信息提取（分类信息网站）
- 📊 竞品监控（本地华人平台动态追踪）

---

## 🚀 快速开始

### 1. 环境要求

- Python 3.11+
- Node.js 18+ (可选，用于 MCP 工具)
- Cursor AI 编辑器（推荐）

### 2. 安装依赖

```bash
# Python 依赖
pip3 install -r requirements.txt

# Node.js 依赖（可选）
npm install
```

### 3. 配置环境变量

```bash
# 复制环境变量模板
cp env.template .env

# 编辑 .env 文件，填入你的 Firecrawl API 密钥
# FIRECRAWL_API_KEY=fc-xxx
```

### 4. 测试 API

```bash
# 测试 API 密钥
python3 test_api_keys.py

# 运行快速开始示例
python3 quick_start.py
```

---

## 📚 文档索引

### 🎓 必读文档（优先级排序）

#### P0 - 立即阅读

1. **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** - 快速参考指南
2. **[Firecrawl学习手册/](./Firecrawl学习手册/)** - 完整学习体系
   - [快速使用指南](./Firecrawl学习手册/🚀快速使用指南.md)
   - [README](./Firecrawl学习手册/README.md)

#### P1 - Cursor 配置

3. **[CURSOR_SETUP_SUMMARY.md](./CURSOR_SETUP_SUMMARY.md)** - Cursor 完整设置总结
4. **[CURSOR_CONFIG_AUDIT.md](./CURSOR_CONFIG_AUDIT.md)** - Cursor 配置审计报告
5. **[CURSOR_SLASH_COMMANDS_GUIDE.md](./CURSOR_SLASH_COMMANDS_GUIDE.md)** - Slash 命令详解

#### P2 - Python 开发环境

6. **[PYTHON_ENVIRONMENT_SETUP.md](./PYTHON_ENVIRONMENT_SETUP.md)** - Python 完整环境配置
7. **[SDK_CONFIGURATION_COMPLETE.md](./SDK_CONFIGURATION_COMPLETE.md)** - Firecrawl SDK 配置

#### P3 - 业务文档

8. **[hawaii_hub_net_agent_运营团队_prd_v_1.md](./hawaii_hub_net_agent_运营团队_prd_v_1.md)** - HawaiiHub 运营团队 PRD
9. **[Ad_Rate_Card.md](./Ad_Rate_Card.md)** - 广告费率卡

### 📊 报告和总结

10. **[docs/reports/](./docs/reports/)** - 所有项目报告
    - [PROJECT_CLEANUP_COMPLETE.md](./docs/reports/PROJECT_CLEANUP_COMPLETE.md) - 项目清理完成报告
    - [CONFIGURATION_SUMMARY.md](./docs/reports/CONFIGURATION_SUMMARY.md) - 完整配置总结
    - [RESOURCES_SUMMARY.md](./docs/reports/RESOURCES_SUMMARY.md) - 资源总结
    - [Firecrawl学习手册完整整理报告.md](./docs/reports/Firecrawl学习手册完整整理报告.md)

### 🔧 详细指南

11. **[docs/cursor-guides/](./docs/cursor-guides/)** - Cursor 详细指南集合
12. **[docs/analysis/](./docs/analysis/)** - AI 工作流研究报告
13. **[docs/guides/](./docs/guides/)** - 通用开发指南

---

## 🔑 核心配置

### 环境变量

项目使用 `.env` 文件管理敏感信息：

```bash
# 必需配置
FIRECRAWL_API_KEY=fc-xxx              # 主 API 密钥
FIRECRAWL_API_KEY_BACKUP_1=fc-xxx     # 备用密钥 1
FIRECRAWL_API_KEY_BACKUP_2=fc-xxx     # 备用密钥 2
FIRECRAWL_API_KEY_BACKUP_3=fc-xxx     # 备用密钥 3

# 可选配置
FIRECRAWL_API_URL=https://api.firecrawl.dev
FIRECRAWL_TIMEOUT=60
FIRECRAWL_MAX_RETRIES=3
FIRECRAWL_DAILY_BUDGET=10.0
```

### Cursor AI 规则

项目使用 `.cursorrules` 文件定义 AI 助手行为规范：

- 🇨🇳 强制简体中文输出
- 🐍 Python 代码规范（类型注解、文档字符串、Ruff 格式化）
- 🔥 Firecrawl 最佳实践
- 💰 成本控制和缓存策略
- 🔒 安全规范（API 密钥管理）

---

## 📂 项目结构

```
FireShot/
├── README.md                           # 📖 项目总览（本文件）
├── CHANGELOG.md                        # 📝 变更日志
├── QUICK_REFERENCE.md                  # ⚡ 快速参考
│
├── .cursorrules                        # 🎯 Cursor AI 规则
├── .env                                # 🔐 环境变量（不提交到 Git）
├── env.template                        # 📋 环境变量模板
│
├── requirements.txt                    # 📦 Python 依赖
├── package.json                        # 📦 Node.js 依赖
├── pyproject.toml                      # ⚙️ Python 项目配置
│
├── quick_start.py                      # 🚀 快速开始示例
├── setup_sdk.py                        # 🔧 SDK 配置脚本
├── test_api_keys.py                    # 🔑 API 密钥测试
│
├── Firecrawl学习手册/                   # 📚 完整学习资料
│   ├── README.md
│   ├── 🚀快速使用指南.md
│   ├── 00-手册导读/
│   ├── 01-快速入门/
│   ├── 02-核心功能/
│   ├── 03-高级特性/
│   ├── 04-最佳实践/
│   └── 05-实战案例/
│
├── docs/                               # 📚 文档目录
│   ├── cursor-guides/                  # Cursor 指南
│   ├── analysis/                       # 分析报告
│   ├── guides/                         # 通用指南
│   ├── reports/                        # 项目报告
│   └── setup/                          # 设置文档
│
├── scripts/                            # 🔧 工具脚本
│   └── check_docs_sync.py
│
├── templates/                          # 📋 代码模板
│   └── python/
│
├── tests/                              # 🧪 测试文件
│   └── __init__.py
│
└── hawaiihub-admin-agent/              # 🎯 HawaiiHub 管理子项目
```

---

## 🛠️ 开发工具

### Python 工具链

- **Ruff**: 格式化 + Linting（替代 Black/flake8/isort）
- **mypy**: 严格类型检查
- **pytest**: 测试框架
- **Pylance**: 智能代码补全

### Cursor 配置

项目已完成专业级 Cursor 配置：

- ✅ 完整的规则体系（`.cursorrules`）
- ✅ 安全的自动批准配置
- ✅ 强制简体中文输出
- ✅ Slash Commands 集成

详见 [CURSOR_SETUP_SUMMARY.md](./CURSOR_SETUP_SUMMARY.md)

---

## 📖 使用示例

### 示例 1：爬取单个网页

```python
from firecrawl import FirecrawlApp
import os

# 初始化 Firecrawl
app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))

# 爬取网页
result = app.scrape(
    url="https://example.com",
    formats=["markdown"],
    only_main_content=True
)

print(result.markdown)
```

### 示例 2：批量爬取

```python
urls = [
    "https://example.com/page1",
    "https://example.com/page2",
    "https://example.com/page3",
]

results = app.batch_scrape(
    urls=urls,
    formats=["markdown"]
)

for result in results:
    print(result.markdown)
```

### 示例 3：搜索夏威夷新闻

```python
results = app.search(
    query="Hawaii housing rental",
    sources=[{"type": "web"}],
    limit=10,
    scrapeOptions={"formats": ["markdown"]}
)

for item in results:
    print(item.markdown)
```

更多示例见 [Firecrawl学习手册/05-实战案例/](./Firecrawl学习手册/05-实战案例/)

---

## 💰 成本控制

### API 使用策略

1. **缓存优先**: 使用 `max_age` 参数，避免重复爬取
2. **批量处理**: 使用 `batch_scrape` 而非逐个爬取
3. **密钥轮换**: 配置多个 API 密钥，避免速率限制
4. **预算监控**: 设置每日预算上限

```python
# 使用缓存（2天有效期，可节省 50%+ 成本）
result = app.scrape(
    url="https://example.com",
    formats=["markdown"],
    max_age=172800000  # 2天缓存
)
```

详见 [docs/cursor-guides/cost-control.md](./docs/cursor-guides/cost-control.md)

---

## 🔒 安全规范

### API 密钥管理

❌ **禁止**：硬编码 API 密钥

```python
# ❌ 永远不要这样做
api_key = "fc-xxxx"
```

✅ **正确**：使用环境变量

```python
# ✅ 使用环境变量
import os
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("FIRECRAWL_API_KEY")
```

### Git 安全

`.env` 文件已添加到 `.gitignore`，不会提交到 Git。

---

## 🤝 贡献指南

### Git 提交规范

使用 [Conventional Commits](https://www.conventionalcommits.org/)：

```bash
feat(scraper): 添加 Firecrawl MCP 工具支持
fix(parser): 修复文章日期解析错误
docs(api): 更新 API 密钥配置指南
refactor(storage): 优化数据存储格式
perf(cache): 实现 Redis 缓存机制
```

### 代码规范

- Python: 遵循 `.cursorrules` 中的规范
- 类型注解: 所有函数必须有完整类型注解
- 文档字符串: 使用简体中文编写
- 测试: 使用 pytest，测试覆盖率 >80%

---

## 📊 项目状态

### 当前版本

- **项目版本**: v1.0.0
- **Firecrawl SDK**: v2.x
- **Python**: 3.11+
- **Node.js**: 18+

### 完成度

- ✅ 环境配置 (100%)
- ✅ SDK 集成 (100%)
- ✅ Cursor 配置 (100%)
- ✅ 文档体系 (100%)
- 🔄 示例应用 (进行中)
- 🔄 HawaiiHub 集成 (进行中)

### 最近更新

查看 [CHANGELOG.md](./CHANGELOG.md) 获取完整变更历史。

---

## 📞 获取帮助

### 遇到问题？

1. **查看文档**: 优先查看 [Firecrawl学习手册/](./Firecrawl学习手册/)
2. **运行诊断**: `python3 test_api_keys.py`
3. **查看日志**: 检查错误信息
4. **官方资源**:
   - 📖 [Firecrawl 文档](https://docs.firecrawl.dev/)
   - 💬 [Discord 社区](https://discord.gg/firecrawl)
   - 🐛 [GitHub Issues](https://github.com/mendableai/firecrawl/issues)

### 相关项目

- 🌐 [HawaiiHub](./hawaiihub-admin-agent/) - 主网站项目
- 🔥 [Firecrawl 官方](https://github.com/mendableai/firecrawl) - 上游项目

---

## 📄 许可证

MIT License

---

## 🙏 致谢

特别感谢：

- [Firecrawl](https://firecrawl.dev/) - 提供强大的云 API 服务
- [Mendable AI](https://mendable.ai/) - Firecrawl 开发团队
- HawaiiHub AI Team - 项目维护团队

---

<div align="center">

## 🎉 开始使用 FireShot！

**[快速开始](#-快速开始)** | **[文档索引](#-文档索引)** | **[示例代码](#-使用示例)**

记住：优先使用 MCP 工具，合理控制成本，保护 API 密钥安全！

---

Made with ❤️ by HawaiiHub AI Team

最后更新：2025-10-27

</div>
