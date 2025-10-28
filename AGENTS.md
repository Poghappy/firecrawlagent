# FireShot AI 助手规范

**版本**: v1.0.0
**更新时间**: 2025-10-28
**适用范围**: 所有 AI 编码助手（Cursor、Claude Code、CodeBuddy 等）

---

## 🌐 核心原则

### 语言要求

- **所有输出必须使用简体中文**（代码注释、文档、日志、提示信息）
- 英文仅用于：代码变量名、函数名、类名、包名
- 技术术语可保留英文（如 Firecrawl、MCP、API）

### 项目定位

- **项目名称**: FireShot
- **核心使命**: Firecrawl 云 API 最佳实践 + HawaiiHub 数据采集
- **技术栈**: Python 3.14 + Firecrawl SDK v2 + MCP 工具链
- **团队模式**: AI 团队协作（多 Agent 并行）

---

## 📋 OpenSpec 工作流

### 1. 创建变更提案

当用户提出新功能或改进需求时：

```
用户: 添加夏威夷租房信息爬虫

AI: 我会为您创建 OpenSpec 变更提案。
    *创建 openspec/changes/add-rental-scraper/ 目录*
    *生成 proposal.md, tasks.md, specs/ 等文件*
```

**Slash 命令快捷方式**（Cursor/Claude Code/CodeBuddy）:

```
/openspec:proposal 添加夏威夷租房信息爬虫
```

### 2. 验证和审查

在实施前检查规范：

```bash
openspec list                        # 查看活动变更
openspec validate add-rental-scraper # 验证格式
openspec show add-rental-scraper     # 查看详情
```

### 3. 实施变更

```
用户: 规范看起来不错，开始实施吧

AI: 我会按照任务清单实施 add-rental-scraper 变更。
    *从 openspec/changes/add-rental-scraper/tasks.md 读取任务*
    *逐个实施并标记完成状态*
```

**Slash 命令快捷方式**:

```
/openspec:apply add-rental-scraper
```

### 4. 归档完成的变更

```
用户: 请归档这个变更

AI: 我会归档 add-rental-scraper 变更。
    *运行: openspec archive add-rental-scraper --yes*
    *更新规范到 openspec/specs/*
    *移动变更文件到 openspec/archive/*
```

**Slash 命令快捷方式**:

```
/openspec:archive add-rental-scraper
```

---

## 🔥 Firecrawl 使用规范

### 工具选择决策树

```python
# ✅ P0: MCP 工具（最简单、最可靠）
result = mcp_firecrawl_firecrawl_scrape(
    url="https://example.com",
    formats=["markdown"],
    onlyMainContent=True  # ⚠️ MCP 工具使用驼峰式
)

# ✅ P1: Python SDK v2（需要更多控制时）
from firecrawl import FirecrawlApp
app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))
result = app.scrape(
    url="https://example.com",
    formats=["markdown"],
    only_main_content=True  # ⚠️ SDK 使用下划线
)
# 访问结果：result.markdown（属性），不是 result.get("markdown")

# ❌ 避免: 直接使用 requests + BeautifulSoup
```

**选择规则**:

- 复杂页面（JS、动态加载）→ **MCP 工具**
- 批量爬取（已知 URL）→ **Python SDK batch_scrape**
- 整站爬取 → **Python SDK crawl**
- 搜索 + 爬取 → **Python SDK search**

### 必须遵守的配置规范

```python
# ✅ 正确：使用环境变量
import os
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("FIRECRAWL_API_KEY")

# ❌ 错误：硬编码 API 密钥
api_key = "fc-xxxx"  # 永远不要这样做！
```

### 错误处理模式（强制）

```python
def safe_scrape(url: str, max_retries: int = 3) -> Optional[dict]:
    """
    安全爬取，带重试和日志

    Args:
        url: 要爬取的 URL
        max_retries: 最大重试次数

    Returns:
        爬取结果字典，失败返回 None
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
                wait_time = 2 ** attempt  # 指数退避
                logging.warning(f"超时，{wait_time}秒后重试... ({attempt+1}/{max_retries})")
                time.sleep(wait_time)
            else:
                logging.error(f"失败（{max_retries}次重试后）: {url} - {e}")
                return None
        except Exception as e:
            logging.error(f"未知错误: {url} - {e}")
            return None
```

### 性能优化（必须）

```python
# ✅ 使用缓存（节省成本 50%+）
result = app.scrape(
    url="https://example.com",
    formats=["markdown"],
    only_main_content=True,
    max_age=172800000  # 2天缓存
)

# ✅ 批量爬取（更高效）
urls = ["url1", "url2", "url3"]
results = app.batch_scrape(urls, formats=["markdown"])

# ❌ 错误：逐个爬取（慢 + 贵）
for url in urls:
    result = app.scrape(url)  # 串行处理
```

---

## 🐍 Python 代码规范

### 类型注解（强制）

```python
from typing import Optional, Dict, List

def scrape_news(
    url: str,
    formats: List[str] = ["markdown"],
    timeout: int = 60
) -> Optional[Dict[str, str]]:
    """
    爬取新闻内容

    Args:
        url: 新闻 URL
        formats: 返回格式列表
        timeout: 超时时间（秒）

    Returns:
        包含 markdown、html 等内容的字典，失败返回 None
    """
    # ... 实现
    return {"markdown": content}
```

### 文档字符串（强制，中文）

```python
def analyze_articles(articles: List[Dict]) -> Dict[str, int]:
    """
    分析文章数据统计信息

    统计内容：
    - 作者分布
    - 发布时间分布
    - 热门关键词

    Args:
        articles: 文章列表，每个文章包含 title、author、date 等字段

    Returns:
        统计结果字典，包含：
        - total_articles: 总文章数
        - authors: 作者统计 {作者名: 文章数}
        - keywords: 关键词统计 {关键词: 出现次数}

    Example:
        >>> articles = [{"title": "测试", "author": "张三", "date": "2025-10-27"}]
        >>> stats = analyze_articles(articles)
        >>> print(stats["total_articles"])
        1
    """
    # ... 实现
```

### 代码风格（基于 Ruff）

```python
# ✅ 使用双引号（项目标准）
message = "爬取成功"
url = "https://example.com"

# ✅ 导入顺序：标准库 → 第三方库 → 本地模块
import json
import re
from datetime import datetime

from firecrawl import FirecrawlApp
from dotenv import load_dotenv

from .utils import parse_date
from .config import FIRECRAWL_API_KEY

# ✅ 命名规范
class ArticleScraper:  # 类名：大驼峰
    def __init__(self):
        self.api_key = ""  # 实例变量：snake_case

    def scrape_article(self) -> str:  # 方法名：snake_case
        return ""

FIRECRAWL_API_URL = "https://api.firecrawl.dev"  # 常量：大写+下划线
```

---

## 📊 数据处理规范

### 保存格式（必须 3 种）

```python
def save_scraped_data(content: str, metadata: Dict) -> None:
    """
    保存爬取的数据到多种格式
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

### 数据验证

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

## 💰 成本控制规范

### 请求计数和预算监控

```python
class FirecrawlClient:
    """Firecrawl 客户端（带成本控制）"""

    def __init__(self, api_key: str, daily_budget: float = 10.0):
        self.app = FirecrawlApp(api_key=api_key)
        self.daily_budget = daily_budget
        self.request_count = 0
        self.total_cost = 0.0

    def scrape(self, url: str, **kwargs) -> dict:
        """爬取并记录成本"""
        # 检查预算
        if self.total_cost >= self.daily_budget:
            raise BudgetExceededError(f"超出每日预算: ${self.daily_budget}")

        # 执行爬取
        result = self.app.scrape(url, **kwargs)

        # 记录成本（假设 $0.01/请求）
        cost = 0.01
        self.request_count += 1
        self.total_cost += cost

        logging.info(
            f"请求 #{self.request_count} | "
            f"成本: ${cost:.4f} | "
            f"累计: ${self.total_cost:.2f}/{self.daily_budget}"
        )

        return result
```

---

## 📝 Git 提交规范

### Conventional Commits（强制）

```bash
# ✅ 正确的提交消息
git commit -m "feat(scraper): 添加 Firecrawl MCP 工具支持"
git commit -m "fix(parser): 修复文章日期解析错误"
git commit -m "docs(api): 更新 API 密钥配置指南"
git commit -m "refactor(storage): 优化数据存储格式"
git commit -m "perf(cache): 实现 Redis 缓存，节省 50% 成本"

# ❌ 错误的提交消息
git commit -m "更新代码"
git commit -m "fix bug"
```

**类型清单**:

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `refactor`: 代码重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建/工具链
- `style`: 代码格式

---

## ⚠️ 禁止事项

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

## 📚 快速参考

### OpenSpec 命令

```bash
openspec list                  # 查看活动变更
openspec view                  # 交互式仪表板
openspec show <change>         # 查看变更详情
openspec validate <change>     # 验证规范格式
openspec archive <change> -y   # 归档完成的变更
```

### Firecrawl SDK v2 关键特性

- 命名约定：下划线 `only_main_content=True`（非驼峰）
- 返回类型：Document 对象 `result.markdown`（非字典）
- 默认缓存：`max_age=172800000`（2天）

### 环境变量

```bash
# 必需
FIRECRAWL_API_KEY=fc-xxx

# 推荐（密钥轮换）
FIRECRAWL_API_KEY_BACKUP_1=fc-xxx
FIRECRAWL_API_KEY_BACKUP_2=fc-xxx
FIRECRAWL_API_KEY_BACKUP_3=fc-xxx

# 成本控制
FIRECRAWL_DAILY_BUDGET=10.0
FIRECRAWL_TIMEOUT=60
```

---

## 📖 参考文档

### 核心文档

- **OpenSpec 项目规范**: `openspec/project.md`
- **SDK 配置总结**: `SDK_CONFIGURATION_COMPLETE.md`
- **快速参考**: `QUICK_REFERENCE.md`
- **性能优化报告**: `CURSOR_性能优化完成报告_2025-10-28.md`

### 学习资源

- **Firecrawl 学习手册**: `Firecrawl学习手册/` 目录
- **模板库**: `FIRECRAWL_TEMPLATES_CATALOG.md`（55个模板）
- **数据源目录**: `HAWAIIHUB_DATA_SOURCES_CATALOG.md`

### 在线资源

- OpenSpec 官网: https://openspec.dev/
- Firecrawl 文档: https://docs.firecrawl.dev/
- NewsAPI 文档: https://newsapi.org/docs

---

**维护者**: HawaiiHub AI Team
**版本**: v1.0.0
**最后更新**: 2025-10-28
