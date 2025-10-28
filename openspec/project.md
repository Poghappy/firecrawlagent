# FireShot 项目规范

## 项目概述

**项目名称**: FireShot
**项目定位**: Firecrawl 云 API 最佳实践和 HawaiiHub 数据采集平台
**技术栈**: Python 3.14 + Firecrawl SDK v2 + MCP 工具链
**团队规模**: AI 团队（多 Agent 协作）
**更新时间**: 2025-10-28

---

## 核心能力

### 1. 数据采集引擎

- **Firecrawl Cloud API**: 智能网页爬取、批量采集、搜索集成
- **NewsAPI 集成**: 150,000+ 全球新闻源实时头条
- **Steel Browser**: 云端浏览器自动化
- **Playwright MCP**: 本地浏览器交互

### 2. HawaiiHub 数据源

- 租房信息（Craigslist Hawaii）
- 餐厅数据（Yelp、本地华人餐厅）
- 本地新闻（Hawaii News Now、Star Advertiser）
- 商家信息（分类信息网站）
- 社区动态（华人社区平台）

### 3. 开发工具链

- **MCP 服务器**: Firecrawl、GitHub、filesystem、Playwright
- **Cursor AI**: 主开发环境
- **OpenSpec**: 规范驱动开发框架

---

## 技术规范

### Python 代码标准

#### 类型注解（强制）

```python
from typing import Optional, Dict, List

def scrape_news(
    url: str,
    formats: List[str] = ["markdown"],
    timeout: int = 60
) -> Optional[Dict[str, str]]:
    """
    爬取新闻内容（必须有类型注解和中文 docstring）
    """
    pass
```

#### 命名约定

- **Firecrawl SDK v2**: 使用下划线 `only_main_content=True`（非驼峰）
- **返回值**: Document 对象 `result.markdown`（非字典）
- **环境变量**: 大写下划线 `FIRECRAWL_API_KEY`

#### 工具链

- **格式化**: Ruff（替代 Black）
- **类型检查**: mypy --strict
- **测试**: pytest（不使用 unittest）
- **依赖管理**: pip + requirements.txt

### Firecrawl 使用规范

#### 工具选择优先级

```python
# P0: MCP 工具（最简单）
result = mcp_firecrawl_firecrawl_scrape(
    url="https://example.com",
    formats=["markdown"],
    onlyMainContent=True  # ⚠️ MCP 使用驼峰
)

# P1: Python SDK（需要更多控制）
from firecrawl import FirecrawlApp
app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))
result = app.scrape(
    url="https://example.com",
    formats=["markdown"],
    only_main_content=True  # ⚠️ SDK 使用下划线
)
```

#### 成本控制

- **缓存策略**: `max_age=172800000`（2天）节省 50%+ 成本
- **批量处理**: 使用 `batch_scrape()` 而非循环
- **密钥轮换**: 4个 API 密钥支持负载均衡
- **每日预算**: $10（环境变量 `FIRECRAWL_DAILY_BUDGET`）

### 错误处理模式（强制）

```python
def safe_scrape(url: str, max_retries: int = 3) -> Optional[dict]:
    """
    安全爬取，带重试和日志
    """
    for attempt in range(max_retries):
        try:
            result = app.scrape(url, formats=["markdown"], only_main_content=True)

            if not result or not hasattr(result, "markdown"):
                raise ValueError("返回结果无效")

            logging.info(f"成功爬取: {url}")
            return result

        except RequestTimeoutError as e:
            if attempt < max_retries - 1:
                wait_time = 2 ** attempt
                logging.warning(f"超时，{wait_time}秒后重试...")
                time.sleep(wait_time)
            else:
                logging.error(f"失败（{max_retries}次重试后）: {url}")
                return None
        except Exception as e:
            logging.error(f"未知错误: {url} - {e}")
            return None
```

---

## 项目结构约定

```
FireShot/
├── openspec/                    # 📋 OpenSpec 规范（本目录）
│   ├── project.md              # 项目总规范
│   ├── specs/                  # 当前规范
│   ├── changes/                # 待实施变更
│   └── archive/                # 已归档变更
│
├── scripts/                     # 🛠️ 工具脚本
│   ├── hawaiihub_scraper.py    # HawaiiHub 爬虫
│   ├── test_api_keys.py        # API 密钥测试
│   └── performance_maintenance.sh
│
├── templates/                   # 📦 代码模板
│   ├── hawaiihub/              # HawaiiHub 专用模板
│   └── python/                 # Python 通用模板
│
├── data/                        # 📊 数据目录
│   ├── raw/                    # 原始数据
│   ├── processed/              # 处理后数据
│   └── cache/                  # 缓存
│
├── docs/                        # 📚 文档
│   ├── guides/                 # 使用指南
│   ├── reports/                # 项目报告
│   └── cursor-guides/          # Cursor 专用指南
│
└── Firecrawl学习手册/           # 🎓 Firecrawl 培训资料
```

---

## Git 提交规范

### Conventional Commits（强制）

```bash
# ✅ 正确格式
git commit -m "feat(scraper): 添加 Firecrawl MCP 工具支持"
git commit -m "fix(parser): 修复文章日期解析错误"
git commit -m "docs(api): 更新 API 密钥配置指南"
git commit -m "refactor(storage): 优化数据存储格式"
git commit -m "perf(cache): 实现 Redis 缓存，节省 50% 成本"

# ❌ 错误格式
git commit -m "更新代码"
git commit -m "fix bug"
```

### 类型清单

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `refactor`: 代码重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建/工具链
- `style`: 代码格式

---

## 数据处理规范

### 保存格式（必须 3 种）

```python
def save_scraped_data(content: str, metadata: Dict) -> None:
    """
    保存爬取数据到多种格式（三角互验）
    """
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    # 1. 原始 Markdown（人类可读）
    with open(f"raw_{timestamp}.md", "w", encoding="utf-8") as f:
        f.write(f"# 爬取数据\n\n")
        f.write(f"> 时间: {datetime.now()}\n\n")
        f.write(content)

    # 2. 结构化 JSON（程序处理）
    with open(f"data_{timestamp}.json", "w", encoding="utf-8") as f:
        json.dump({
            "content": content,
            "metadata": metadata,
            "scraped_at": datetime.now().isoformat()
        }, f, ensure_ascii=False, indent=2)

    # 3. CSV（分析工具）
    # ... CSV 导出逻辑
```

### 数据验证（使用 Pydantic）

```python
from pydantic import BaseModel, HttpUrl, Field

class Article(BaseModel):
    """文章数据模型"""
    title: str = Field(..., min_length=1, max_length=200)
    url: HttpUrl
    author: str
    date: str  # ISO 8601 格式
    content: Optional[str] = None
```

---

## 禁止事项

### 绝对禁止 ❌

1. 硬编码 API 密钥到代码中
2. 提交 `.env` 文件到 Git
3. 跳过错误处理（所有外部调用必须 try-except）
4. 无限重试（必须设置 max_retries）
5. 忽略成本监控（必须记录每次 API 调用）
6. 使用单引号（Python 统一双引号）
7. 缺少类型注解（所有函数必须有完整类型）
8. 缺少文档字符串（所有公开函数/类必须有 docstring）

### 强烈不推荐 ⚠️

1. 不检查缓存直接爬取（浪费成本）
2. 串行处理大量 URL（使用 batch_scrape）
3. 不记录日志（难以调试）
4. 不验证数据格式（使用 Pydantic）

---

## 环境配置

### 必需环境变量

```bash
# Firecrawl API（4个密钥支持轮换）
FIRECRAWL_API_KEY=fc-xxx
FIRECRAWL_API_KEY_BACKUP_1=fc-xxx
FIRECRAWL_API_KEY_BACKUP_2=fc-xxx
FIRECRAWL_API_KEY_BACKUP_3=fc-xxx

# 成本控制
FIRECRAWL_DAILY_BUDGET=10.0
FIRECRAWL_TIMEOUT=60

# NewsAPI
NEWSAPI_KEY=your_api_key_here
NEWSAPI_PLAN=developer
NEWSAPI_RATE_LIMIT=100
```

---

## 开发工作流

### 1. 创建功能规范

```bash
# 使用 OpenSpec 创建变更提案
/openspec:proposal 添加夏威夷租房信息爬虫
```

### 2. 审查和验证

```bash
openspec list                          # 查看活动变更
openspec validate add-rental-scraper   # 验证规范格式
openspec show add-rental-scraper       # 审查详细内容
```

### 3. 实施变更

```bash
# 让 AI 实施任务
/openspec:apply add-rental-scraper
```

### 4. 归档完成的变更

```bash
openspec archive add-rental-scraper --yes
```

---

## 参考资源

### 核心文档

- **SDK 配置**: `SDK_CONFIGURATION_COMPLETE.md`
- **Firecrawl 规则**: `.cursor/rules/00-hawaiihub-core.mdc`
- **快速启动**: `QUICK_REFERENCE.md`
- **性能优化**: `CURSOR_性能优化完成报告_2025-10-28.md`

### 学习资源

- **Firecrawl 学习手册**: `Firecrawl学习手册/` 目录
- **模板库**: `FIRECRAWL_TEMPLATES_CATALOG.md`（55个模板）
- **数据源目录**: `HAWAIIHUB_DATA_SOURCES_CATALOG.md`

### 在线资源

- Firecrawl 文档: https://docs.firecrawl.dev/
- NewsAPI 文档: https://newsapi.org/docs
- OpenSpec 官网: https://openspec.dev/

---

## 质量保证

### 代码审查检查清单

- [ ] 所有函数有类型注解和中文 docstring
- [ ] 使用环境变量读取 API 密钥
- [ ] 实现完整错误处理（try-except + 重试）
- [ ] 记录日志（logging.info/warning/error）
- [ ] 数据保存 3 种格式（MD + JSON + CSV）
- [ ] 使用 Pydantic 验证数据
- [ ] Git 提交信息符合 Conventional Commits
- [ ] 通过 Ruff 格式化和 mypy 类型检查

### 测试要求

- 使用 pytest（不使用 unittest）
- 所有测试必须有类型注解和 docstrings
- 测试位置：`./tests/` 目录
- Mock 外部 API 调用

---

## 更新记录

- **2025-10-28**: 初始化 OpenSpec 项目规范
- **2025-10-27**: Firecrawl SDK v2 配置完成
- **2025-10-26**: NewsAPI 全局集成
- **2025-10-24**: Cursor AI 团队规范优化

---

**维护者**: HawaiiHub AI Team
**版本**: v1.0.0
**适用项目**: FireShot + HawaiiHub
