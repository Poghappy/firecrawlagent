"""
示例测试模块

演示如何编写符合 FireShot 项目规范的测试。
"""
from typing import Dict, List, Optional
import pytest


# ========================================
# 🧪 单元测试示例
# ========================================


def parse_url(url: str) -> Dict[str, str]:
    """
    解析 URL 为协议和域名

    Args:
        url: 待解析的 URL

    Returns:
        包含 protocol 和 domain 的字典
    """
    if not url.startswith(("http://", "https://")):
        raise ValueError("URL 必须以 http:// 或 https:// 开头")

    protocol = "https" if url.startswith("https://") else "http"
    domain = url.replace(f"{protocol}://", "").split("/")[0]

    return {"protocol": protocol, "domain": domain}


@pytest.mark.unit
def test_parse_url_success() -> None:
    """测试：成功解析 HTTPS URL"""
    # Arrange
    url = "https://www.hawaiinewsnow.com/news/article-123"

    # Act
    result = parse_url(url)

    # Assert
    assert result["protocol"] == "https"
    assert result["domain"] == "www.hawaiinewsnow.com"


@pytest.mark.unit
def test_parse_url_http() -> None:
    """测试：成功解析 HTTP URL"""
    url = "http://example.com/page"

    result = parse_url(url)

    assert result["protocol"] == "http"
    assert result["domain"] == "example.com"


@pytest.mark.unit
def test_parse_url_invalid() -> None:
    """测试：无效 URL 应抛出异常"""
    invalid_url = "www.example.com"

    with pytest.raises(ValueError, match="URL 必须以"):
        parse_url(invalid_url)


# ========================================
# 🔄 参数化测试示例
# ========================================


@pytest.mark.unit
@pytest.mark.parametrize(
    "url,expected_protocol,expected_domain",
    [
        ("https://example.com", "https", "example.com"),
        ("http://test.org/page", "http", "test.org"),
        ("https://api.firecrawl.dev/v1/scrape", "https", "api.firecrawl.dev"),
    ],
)
def test_parse_url_parametrized(
    url: str, expected_protocol: str, expected_domain: str
) -> None:
    """测试：参数化测试多个 URL"""
    result = parse_url(url)

    assert result["protocol"] == expected_protocol
    assert result["domain"] == expected_domain


# ========================================
# 🎭 Fixture 示例
# ========================================


@pytest.fixture
def sample_urls() -> List[str]:
    """提供示例 URL 列表"""
    return [
        "https://www.hawaiinewsnow.com/",
        "https://www.staradvertiser.com/",
        "https://www.civilbeat.org/",
    ]


@pytest.mark.unit
def test_with_fixture(sample_urls: List[str]) -> None:
    """测试：使用 Fixture 提供的测试数据"""
    assert len(sample_urls) == 3
    assert all(url.startswith("https://") for url in sample_urls)


# ========================================
# 🔒 Mock 示例（集成测试时使用）
# ========================================


def fetch_news(url: str) -> Optional[Dict[str, str]]:
    """
    模拟获取新闻（实际应调用 Firecrawl API）

    Args:
        url: 新闻 URL

    Returns:
        新闻内容字典
    """
    # 实际实现会调用 Firecrawl API
    # 这里只是示例
    return {"title": "测试新闻", "content": "新闻内容"}


@pytest.mark.integration
def test_fetch_news_success(monkeypatch: pytest.MonkeyPatch) -> None:
    """测试：使用 monkeypatch 模拟 API 调用"""

    def mock_fetch(url: str) -> Dict[str, str]:
        return {"title": "模拟新闻", "content": "模拟内容"}

    # 使用 monkeypatch 替换函数
    monkeypatch.setattr("tests.test_example.fetch_news", mock_fetch)

    result = fetch_news("https://example.com")

    assert result is not None
    assert result["title"] == "模拟新闻"


# ========================================
# 🐌 慢速测试示例（需要真实 API）
# ========================================


@pytest.mark.slow
@pytest.mark.integration
def test_real_api_call() -> None:
    """
    测试：真实 API 调用（标记为 slow）

    使用：pytest -m "not slow" 跳过慢速测试
    使用：pytest -m slow 只运行慢速测试
    """
    # 这里应该是真实的 Firecrawl API 调用
    # result = app.scrape("https://example.com")
    # assert result is not None
    pytest.skip("需要真实 API 密钥，跳过")


# ========================================
# ⚠️ 预期失败测试示例
# ========================================


@pytest.mark.xfail(reason="已知 Bug，待修复")
def test_known_bug() -> None:
    """测试：已知 Bug（预期失败）"""
    # 这个测试目前会失败，但标记为 xfail
    assert 1 + 1 == 3  # 故意错误


# ========================================
# 🎯 类组织测试示例
# ========================================


class TestUrlParser:
    """URL 解析器测试套件"""

    def test_https_url(self) -> None:
        """测试：HTTPS URL"""
        result = parse_url("https://example.com")
        assert result["protocol"] == "https"

    def test_http_url(self) -> None:
        """测试：HTTP URL"""
        result = parse_url("http://example.com")
        assert result["protocol"] == "http"

    def test_domain_extraction(self) -> None:
        """测试：域名提取"""
        result = parse_url("https://api.example.com/v1/endpoint")
        assert result["domain"] == "api.example.com"


# ========================================
# 📊 测试覆盖率示例
# ========================================


def calculate_cost(requests: int, price_per_request: float = 0.01) -> float:
    """
    计算 API 调用成本

    Args:
        requests: 请求次数
        price_per_request: 每次请求单价

    Returns:
        总成本
    """
    if requests < 0:
        raise ValueError("请求次数不能为负数")

    return requests * price_per_request


@pytest.mark.unit
def test_calculate_cost_normal() -> None:
    """测试：正常成本计算"""
    cost = calculate_cost(100, 0.01)
    assert cost == 1.0


@pytest.mark.unit
def test_calculate_cost_zero() -> None:
    """测试：零请求成本"""
    cost = calculate_cost(0)
    assert cost == 0.0


@pytest.mark.unit
def test_calculate_cost_negative() -> None:
    """测试：负数请求应抛出异常"""
    with pytest.raises(ValueError, match="请求次数不能为负数"):
        calculate_cost(-10)


# ========================================
# 📝 测试文档字符串规范
# ========================================


def test_example_with_full_docstring() -> None:
    """
    测试：完整的文档字符串示例

    本测试演示了标准的测试文档格式：
    1. 简短描述（第一行）
    2. 详细说明（可选）
    3. 测试步骤（Arrange、Act、Assert）

    Example:
        >>> result = parse_url("https://example.com")
        >>> assert result["protocol"] == "https"

    Note:
        所有测试必须有类型注解和中文文档字符串
    """
    # Arrange（准备测试数据）
    url = "https://example.com"

    # Act（执行被测试的函数）
    result = parse_url(url)

    # Assert（验证结果）
    assert result["protocol"] == "https"
    assert result["domain"] == "example.com"


# ========================================
# 🏃 运行测试命令
# ========================================

# 运行所有测试：
#   pytest tests/ -v

# 只运行单元测试：
#   pytest tests/ -v -m unit

# 跳过慢速测试：
#   pytest tests/ -v -m "not slow"

# 查看覆盖率：
#   pytest tests/ --cov=src --cov-report=html
#   open htmlcov/index.html

# 运行单个测试：
#   pytest tests/test_example.py::test_parse_url_success -v

# 运行单个测试类：
#   pytest tests/test_example.py::TestUrlParser -v
