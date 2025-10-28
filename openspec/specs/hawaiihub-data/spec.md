# HawaiiHub 数据采集规范

**模块**: hawaiihub-data
**负责人**: HawaiiHub AI Team
**更新时间**: 2025-10-28
**版本**: v1.0.0

---

## 目的

定义 HawaiiHub 数据采集的标准流程、数据模型和质量要求。

---

## 要求

### Requirement: 数据源配置

系统必须维护标准化的数据源配置。

#### Scenario: 新闻源配置
- 当添加新闻源时
- 则必须在 `config/hawaiihub_sources.json` 中配置
- 并且包含 name、url、type、category 字段

#### Scenario: 数据源优先级
- 当选择数据源时
- 则应按照配置的 priority 字段排序
- 并且优先使用 P0 级别的源

---

### Requirement: 数据模型标准

系统必须使用统一的 Pydantic 数据模型。

#### Scenario: 租房信息模型
- 当采集租房信息时
- 则必须验证 title、price、location、bedrooms、bathrooms 字段
- 并且 price 必须是数字类型

#### Scenario: 餐厅信息模型
- 当采集餐厅信息时
- 则必须验证 name、cuisine、address、rating、phone 字段
- 并且 rating 必须在 0-5 之间

#### Scenario: 新闻文章模型
- 当采集新闻文章时
- 则必须验证 title、url、author、date、content 字段
- 并且 date 必须是 ISO 8601 格式

---

### Requirement: 数据清洗

系统必须清洗采集的原始数据。

#### Scenario: 移除广告内容
- 当解析网页内容时
- 则必须移除广告、导航栏、推荐文章等无关内容
- 并且只保留主体内容

#### Scenario: 文本规范化
- 当处理文本内容时
- 则必须规范化空白字符（统一为单个空格或换行）
- 并且去除首尾空白

#### Scenario: 日期标准化
- 当处理日期字段时
- 则必须转换为 ISO 8601 格式
- 并且处理时区信息

---

### Requirement: 数据去重

系统必须避免重复采集相同数据。

#### Scenario: URL 去重
- 在采集前
- 则系统应检查 URL 是否已经采集过
- 并且在缓存中存在时跳过

#### Scenario: 内容去重
- 在保存数据前
- 则系统应计算内容哈希
- 并且相同哈希的内容只保存一次

---

### Requirement: 数据存储

系统必须按照标准目录结构存储数据。

#### Scenario: 目录组织
- 当保存数据时
- 则必须按照 `data/{category}/{date}/` 格式组织
- 并且使用时间戳命名文件

#### Scenario: 多格式保存
- 在保存每条数据时
- 则必须同时保存 Markdown、JSON、CSV 三种格式
- 并且确保内容一致性

---

### Requirement: 数据质量检查

系统必须验证采集数据的质量。

#### Scenario: 必填字段检查
- 在保存数据前
- 则必须检查所有必填字段是否存在
- 并且不为空

#### Scenario: 字段格式验证
- 在保存数据前
- 则必须验证字段格式（如 URL、日期、邮箱等）
- 并且不符合格式时拒绝保存

#### Scenario: 内容长度验证
- 在保存数据前
- 则必须验证内容长度是否在合理范围
- 并且过短或过长时记录警告

---

### Requirement: 增量更新

系统应支持增量更新而非全量重新采集。

#### Scenario: 新闻增量采集
- 当采集新闻时
- 则应只采集自上次采集后的新文章
- 并且使用 date 字段过滤

#### Scenario: 餐厅信息更新
- 当更新餐厅信息时
- 则应只更新发生变化的字段
- 并且保留历史版本

---

### Requirement: 采集频率控制

系统必须控制数据源的采集频率。

#### Scenario: 新闻源采集频率
- 当采集新闻源时
- 则每天最多采集 4 次（每 6 小时）
- 并且记录上次采集时间

#### Scenario: 静态数据采集频率
- 当采集餐厅、商家等静态数据时
- 则每周最多采集 1 次
- 并且缓存 7 天

---

## 数据模型定义

### 租房信息（Rental）

```python
from pydantic import BaseModel, HttpUrl, Field
from typing import Optional

class Rental(BaseModel):
    """租房信息数据模型"""
    title: str = Field(..., min_length=1, max_length=200)
    url: HttpUrl
    price: float = Field(..., gt=0)
    location: str
    bedrooms: int = Field(..., ge=0)
    bathrooms: float = Field(..., ge=0)
    description: Optional[str] = None
    posted_date: str  # ISO 8601
    source: str  # 数据源名称
```

### 餐厅信息（Restaurant）

```python
class Restaurant(BaseModel):
    """餐厅信息数据模型"""
    name: str = Field(..., min_length=1, max_length=100)
    cuisine: str  # 菜系类型
    address: str
    phone: Optional[str] = None
    rating: float = Field(..., ge=0, le=5)
    price_range: Optional[str] = None  # $, $$, $$$, $$$$
    url: Optional[HttpUrl] = None
    description: Optional[str] = None
    source: str
```

### 新闻文章（Article）

```python
class Article(BaseModel):
    """新闻文章数据模型"""
    title: str = Field(..., min_length=1, max_length=200)
    url: HttpUrl
    author: str
    date: str  # ISO 8601
    content: str = Field(..., min_length=100)
    summary: Optional[str] = None
    category: str  # 分类
    source: str
    tags: Optional[list[str]] = None
```

---

## 数据源清单

### P0 核心数据源
- Hawaii News Now (新闻)
- Star Advertiser (新闻)
- Craigslist Hawaii (租房)
- Yelp Hawaii (餐厅)

### P1 补充数据源
- Civil Beat (深度报道)
- 本地华人社区网站
- Facebook 社区群组

---

## 实现参考

### 标准采集流程

```python
def scrape_hawaii_news(source_config: dict) -> list[Article]:
    """
    标准新闻采集流程

    Args:
        source_config: 数据源配置

    Returns:
        文章列表
    """
    # 1. 检查上次采集时间
    last_scrape = get_last_scrape_time(source_config["name"])
    if should_skip(last_scrape, frequency="6h"):
        logging.info(f"跳过采集: {source_config['name']}（未到采集时间）")
        return []

    # 2. 爬取首页
    result = scrape_with_retry(source_config["url"])
    if not result:
        return []

    # 3. 提取文章链接
    links = extract_article_links(result.markdown)

    # 4. 过滤已采集的链接
    new_links = filter_uncrawled_urls(links)

    # 5. 批量爬取文章内容
    articles = batch_scrape_articles(new_links[:10])

    # 6. 数据清洗和验证
    cleaned = [clean_article(a) for a in articles]
    validated = [Article(**a) for a in cleaned]

    # 7. 保存数据
    save_articles(validated, source_config["name"])

    # 8. 更新采集时间
    update_last_scrape_time(source_config["name"])

    return validated
```

---

## 性能指标

- **数据新鲜度**: 新闻 < 6 小时，静态数据 < 7 天
- **数据准确率**: > 95%
- **去重率**: > 99%
- **采集成功率**: > 90%

---

## 变更历史

- **2025-10-28**: 初始版本，定义核心数据模型和采集规范
