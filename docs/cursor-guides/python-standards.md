# Python 代码规范

> **最后更新**: 2025-10-27
> **Python 版本**: 3.11+
> **代码风格**: Black + Ruff

---

## 🐍 核心原则

1. **类型注解必须**：所有函数都要有完整类型注解
2. **文档字符串必须**：所有公开函数/类都要有中文 docstring
3. **双引号标准**：统一使用双引号
4. **格式化自动**：使用 Black/Ruff 自动格式化
5. **测试驱动**：使用 pytest，测试覆盖率 ≥ 80%

---

## ✅ 类型注解（强制）

### 基本规则

```python
# ✅ 正确：完整的类型注解
from typing import Optional, Dict, List

def scrape_news(
    url: str,
    formats: List[str] = ["markdown"],
    timeout: int = 60
) -> Optional[Dict[str, str]]:
    """爬取新闻内容"""
    return {"markdown": content}

# ❌ 错误：缺少类型注解
def scrape_news(url, formats=["markdown"]):
    return {"markdown": content}
```

### 常用类型

| 类型          | 用途   | 示例                     |
| ------------- | ------ | ------------------------ |
| `str`         | 字符串 | `url: str`               |
| `int`         | 整数   | `timeout: int`           |
| `float`       | 浮点数 | `cost: float`            |
| `bool`        | 布尔值 | `success: bool`          |
| `List[T]`     | 列表   | `urls: List[str]`        |
| `Dict[K, V]`  | 字典   | `data: Dict[str, int]`   |
| `Optional[T]` | 可选   | `result: Optional[str]`  |
| `Union[A, B]` | 联合   | `value: Union[str, int]` |
| `Tuple[A, B]` | 元组   | `point: Tuple[int, int]` |

### Python 3.10+ 新语法

```python
# ✅ 推荐：使用新语法（Python 3.10+）
def process(data: dict[str, int]) -> str | None:
    """使用新语法"""
    pass

# ✅ 也可以：使用旧语法（兼容性）
from typing import Optional, Dict

def process(data: Dict[str, int]) -> Optional[str]:
    """使用旧语法"""
    pass
```

---

## 📖 文档字符串（强制）

### 标准格式

```python
def scrape_articles(
    sources: List[str],
    limit: int = 10,
    use_cache: bool = True
) -> List[Dict[str, str]]:
    """
    爬取多个新闻源的文章

    从指定的新闻源批量爬取文章内容，支持缓存和限制数量。

    Args:
        sources: 新闻源 URL 列表
        limit: 每个源最多爬取的文章数，默认 10
        use_cache: 是否使用缓存，默认 True

    Returns:
        文章列表，每个文章包含：
        - title: 文章标题
        - url: 文章 URL
        - content: 文章内容（Markdown）
        - date: 发布日期

    Raises:
        ValueError: 当 sources 为空时
        RequestTimeoutError: 当请求超时时

    Example:
        >>> sources = ["https://news.example.com"]
        >>> articles = scrape_articles(sources, limit=5)
        >>> print(len(articles))
        5

    Note:
        - 使用缓存可节省 50% 成本
        - 建议 limit ≤ 100
    """
    if not sources:
        raise ValueError("sources 不能为空")

    # 实现...
```

### 最小要求

```python
# ✅ 最小文档（简单函数）
def clean_text(text: str) -> str:
    """
    清洗文本，移除多余空白

    Args:
        text: 原始文本

    Returns:
        清洗后的文本
    """
    return text.strip()
```

---

## 🎨 代码风格

### 1. 引号规则

```python
# ✅ 正确：使用双引号
message = "爬取成功"
url = "https://example.com"
data = {"key": "value"}

# ❌ 错误：使用单引号
message = '爬取成功'
url = 'https://example.com'
data = {'key': 'value'}
```

### 2. 导入顺序

```python
# ✅ 正确的导入顺序
# 1. 标准库
import json
import re
from datetime import datetime
from collections import defaultdict

# 2. 第三方库
from firecrawl import FirecrawlApp
from dotenv import load_dotenv
import pandas as pd

# 3. 本地模块
from .utils import parse_date
from .config import FIRECRAWL_API_KEY
```

### 3. 命名规范

| 类型 | 规范             | 示例                       |
| ---- | ---------------- | -------------------------- |
| 变量 | snake_case       | `user_name`, `total_count` |
| 函数 | snake_case       | `scrape_article()`         |
| 类   | PascalCase       | `ArticleScraper`           |
| 常量 | UPPER_SNAKE_CASE | `API_KEY`, `MAX_RETRIES`   |
| 私有 | 前缀 `_`         | `_internal_method()`       |

```python
# ✅ 正确的命名
class ArticleScraper:
    """文章爬虫"""

    MAX_RETRIES = 3  # 常量

    def __init__(self):
        self.api_key = ""  # 实例变量
        self._cache = {}  # 私有变量

    def scrape_article(self, url: str) -> str:  # 公开方法
        """爬取文章"""
        return self._fetch_content(url)

    def _fetch_content(self, url: str) -> str:  # 私有方法
        """获取内容"""
        return ""

API_URL = "https://api.example.com"  # 模块常量
```

### 4. 行长度和格式

```python
# ✅ 正确：每行最多 88 字符
result = app.scrape(
    url="https://example.com",
    formats=["markdown"],
    only_main_content=True
)

# ✅ 正确：长字符串换行
message = (
    "这是一个很长的消息，"
    "需要换行显示，"
    "保持可读性"
)

# ✅ 正确：长列表换行
urls = [
    "https://example1.com",
    "https://example2.com",
    "https://example3.com",
]
```

---

## 🧪 测试规范

### pytest 标准

```python
# ✅ 测试文件：tests/test_scraper.py
import pytest
from unittest.mock import Mock, patch
from my_module import scrape_news

def test_scrape_success():
    """测试：成功爬取文章"""
    # Arrange
    mock_result = Mock()
    mock_result.markdown = "# 测试文章"

    # Act
    with patch("firecrawl.FirecrawlApp.scrape", return_value=mock_result):
        result = scrape_news("https://test.com")

    # Assert
    assert result is not None
    assert "markdown" in result
    assert result["markdown"] == "# 测试文章"

def test_scrape_timeout():
    """测试：超时重试机制"""
    # Arrange & Act
    with patch("firecrawl.FirecrawlApp.scrape", side_effect=RequestTimeoutError):
        result = safe_scrape("https://test.com", max_retries=2)

    # Assert
    assert result is None

@pytest.mark.parametrize("url,expected", [
    ("https://test.com", True),
    ("invalid-url", False),
])
def test_validate_url(url: str, expected: bool):
    """测试：URL 验证"""
    assert validate_url(url) == expected
```

### 测试覆盖率

```bash
# 运行测试并生成覆盖率报告
pytest --cov=src --cov-report=term-missing

# 要求：覆盖率 ≥ 80%
```

---

## 🔧 工具配置

### Ruff 配置

```toml
# pyproject.toml
[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
]

[tool.ruff.format]
quote-style = "double"  # 强制双引号
```

### mypy 配置

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

---

## 📋 代码检查清单

### 提交前必须检查

- [ ] 所有函数有类型注解
- [ ] 所有公开函数有文档字符串
- [ ] 使用双引号
- [ ] 运行 `ruff format .`
- [ ] 运行 `ruff check .`
- [ ] 运行 `mypy --strict .`
- [ ] 运行 `pytest`
- [ ] 测试覆盖率 ≥ 80%

---

## ⚠️ 常见错误

### 错误 1: 缺少返回类型

```python
# ❌ 错误
def get_data():
    return {"key": "value"}

# ✅ 正确
def get_data() -> Dict[str, str]:
    return {"key": "value"}
```

### 错误 2: 使用 `Any` 类型

```python
# ❌ 避免：使用 Any
from typing import Any

def process(data: Any) -> Any:
    pass

# ✅ 推荐：具体类型
def process(data: Dict[str, int]) -> str:
    pass
```

### 错误 3: 缺少 docstring

```python
# ❌ 错误：没有文档
def important_function(x, y):
    return x + y

# ✅ 正确：有文档
def important_function(x: int, y: int) -> int:
    """
    计算两数之和

    Args:
        x: 第一个数
        y: 第二个数

    Returns:
        两数之和
    """
    return x + y
```

---

_最后更新: 2025-10-27_
_Python 版本: 3.11+_
_代码风格: Black + Ruff_
