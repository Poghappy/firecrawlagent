# HawaiiHub 专项模板

> **最后更新**: 2025-10-27
> **适用场景**: 夏威夷本地内容采集

---

## 🌴 新闻爬取模板

### 夏威夷新闻源

```python
# 主要新闻源
HAWAII_NEWS_SOURCES = {
    "hawaiinewsnow": {
        "url": "https://www.hawaiinewsnow.com/",
        "name": "Hawaii News Now",
        "type": "general",
        "cache_ttl": 3600  # 1 小时
    },
    "staradvertiser": {
        "url": "https://www.staradvertiser.com/",
        "name": "Honolulu Star-Advertiser",
        "type": "general",
        "cache_ttl": 3600
    },
    "civilbeat": {
        "url": "https://www.civilbeat.org/",
        "name": "Honolulu Civil Beat",
        "type": "investigative",
        "cache_ttl": 7200  # 2 小时
    },
    "khon2": {
        "url": "https://www.khon2.com/",
        "name": "KHON2 News",
        "type": "general",
        "cache_ttl": 3600
    }
}

# 华人社区源
CHINESE_COMMUNITY_SOURCES = {
    "kauai_chinese": {
        "url": "https://www.kauaichineseassociation.org/news",
        "name": "Kauai Chinese Association",
        "type": "community",
        "cache_ttl": 86400  # 24 小时
    }
}
```

### 标准爬取流程

```python
from typing import List, Dict
from firecrawl import FirecrawlApp
import logging

def scrape_hawaii_news(
    sources: Dict[str, Dict],
    articles_per_source: int = 10
) -> List[Dict[str, str]]:
    """
    爬取夏威夷新闻

    Args:
        sources: 新闻源配置字典
        articles_per_source: 每个源爬取的文章数

    Returns:
        文章列表
    """
    app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))
    all_articles = []

    for source_id, config in sources.items():
        try:
            logging.info(f"开始爬取: {config['name']}")

            # 1. 爬取首页
            homepage = app.scrape(
                url=config["url"],
                formats=["markdown"],
                only_main_content=True,
                max_age=config["cache_ttl"] * 1000  # 转换为毫秒
            )

            # 2. 提取文章链接
            article_urls = extract_article_links(
                homepage.markdown,
                base_url=config["url"],
                limit=articles_per_source
            )

            logging.info(
                f"发现 {len(article_urls)} 篇文章: {config['name']}"
            )

            # 3. 批量爬取文章
            if article_urls:
                articles = app.batch_scrape(
                    urls=article_urls,
                    formats=["markdown"],
                    only_main_content=True
                )

                # 4. 解析和标记
                for article in articles:
                    if hasattr(article, "markdown"):
                        parsed = {
                            "source_id": source_id,
                            "source_name": config["name"],
                            "source_type": config["type"],
                            "url": article.url,
                            "title": article.metadata.title if article.metadata else "",
                            "content": article.markdown,
                            "scraped_at": datetime.now().isoformat()
                        }
                        all_articles.append(parsed)

            logging.info(
                f"成功爬取 {len(article_urls)} 篇: {config['name']}"
            )

        except Exception as e:
            logging.error(f"爬取失败 {config['name']}: {e}")
            continue

    return all_articles

# 使用
articles = scrape_hawaii_news(HAWAII_NEWS_SOURCES, articles_per_source=10)
```

---

## 🏪 商家信息爬取

### Yelp 夏威夷餐厅

```python
YELP_SEARCH_URLS = [
    # 檀香山中餐
    "https://www.yelp.com/search?find_desc=Chinese&find_loc=Honolulu,+HI",
    # 檀香山日料
    "https://www.yelp.com/search?find_desc=Japanese&find_loc=Honolulu,+HI",
    # 檀香山韩餐
    "https://www.yelp.com/search?find_desc=Korean&find_loc=Honolulu,+HI",
]

def scrape_yelp_restaurants(
    search_urls: List[str],
    max_restaurants: int = 50
) -> List[Dict]:
    """
    爬取 Yelp 餐厅信息

    Args:
        search_urls: Yelp 搜索 URL 列表
        max_restaurants: 每个搜索最多爬取的餐厅数

    Returns:
        餐厅信息列表
    """
    app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))
    restaurants = []

    for url in search_urls:
        try:
            # 爬取搜索结果页
            result = app.scrape(
                url=url,
                formats=["markdown"],
                only_main_content=True,
                max_age=604800000  # 7 天缓存
            )

            # 提取餐厅链接
            restaurant_urls = extract_yelp_restaurant_links(
                result.markdown,
                limit=max_restaurants
            )

            # 批量爬取餐厅详情
            details = app.batch_scrape(
                urls=restaurant_urls,
                formats=["markdown"]
            )

            # 解析餐厅信息
            for detail in details:
                if hasattr(detail, "markdown"):
                    info = parse_yelp_restaurant(detail.markdown)
                    if info:
                        restaurants.append(info)

        except Exception as e:
            logging.error(f"爬取 Yelp 失败: {e}")

    return restaurants

def parse_yelp_restaurant(markdown: str) -> Dict | None:
    """解析 Yelp 餐厅 Markdown"""
    # TODO: 实现解析逻辑
    # 提取：名称、评分、地址、电话、营业时间、评论等
    return {
        "name": "",
        "rating": 0.0,
        "address": "",
        "phone": "",
        "hours": "",
        "price_range": "",
        "cuisine": []
    }
```

---

## 🏠 租房信息爬取

### Craigslist 夏威夷租房

```python
CRAIGSLIST_HOUSING_URLS = [
    # 檀香山租房
    "https://honolulu.craigslist.org/search/apa",
    # 整个夏威夷
    "https://honolulu.craigslist.org/search/oah/apa",
]

def scrape_housing_listings(
    urls: List[str],
    max_listings: int = 100
) -> List[Dict]:
    """
    爬取租房信息

    Args:
        urls: Craigslist URL 列表
        max_listings: 最大列表数

    Returns:
        租房列表
    """
    app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))
    listings = []

    for url in urls:
        try:
            # 爬取列表页
            result = app.scrape(
                url=url,
                formats=["markdown"],
                only_main_content=True,
                max_age=3600000  # 1 小时缓存（更新快）
            )

            # 提取租房链接
            listing_urls = extract_craigslist_links(
                result.markdown,
                limit=max_listings
            )

            # 批量爬取详情
            details = app.batch_scrape(
                urls=listing_urls,
                formats=["markdown"]
            )

            # 解析租房信息
            for detail in details:
                if hasattr(detail, "markdown"):
                    info = parse_housing_listing(detail.markdown)
                    if info:
                        listings.append(info)

        except Exception as e:
            logging.error(f"爬取租房信息失败: {e}")

    return listings

def parse_housing_listing(markdown: str) -> Dict | None:
    """解析租房列表 Markdown"""
    # TODO: 实现解析逻辑
    # 提取：标题、价格、地址、卧室数、面积、联系方式等
    return {
        "title": "",
        "price": 0,
        "address": "",
        "bedrooms": 0,
        "bathrooms": 0,
        "sqft": 0,
        "contact": "",
        "posted_date": ""
    }
```

---

## 🧹 数据清洗规范

### 新闻内容清洗

```python
import re

def clean_news_content(content: str) -> str:
    """
    清洗新闻内容

    移除：
    - 广告
    - 导航栏
    - 相关文章推荐
    - 社交媒体按钮
    - Cookie 通知
    """
    # Firecrawl 的 only_main_content 已经做了基础清洗
    # 这里只需要额外处理特定模式

    # 移除广告模式
    ad_patterns = [
        r"Subscribe to.*newsletter",
        r"Advertisement",
        r"ADVERTISEMENT",
        r"Sponsored Content",
        r"Related Articles?",
        r"You May Also Like",
        r"Recommended For You",
        r"Share on (Facebook|Twitter|LinkedIn|Email)",
        r"Follow us on.*",
        r"Sign up for.*",
        r"Cookie Policy",
        r"Accept Cookies"
    ]

    for pattern in ad_patterns:
        content = re.sub(pattern, "", content, flags=re.IGNORECASE)

    # 规范化空白
    content = re.sub(r"\n{3,}", "\n\n", content)  # 多个换行 → 2 个换行
    content = re.sub(r" {2,}", " ", content)      # 多个空格 → 1 个空格

    # 移除首尾空白
    content = content.strip()

    return content
```

### 价格格式化

```python
def parse_price(price_text: str) -> float | None:
    """
    解析价格文本

    支持格式：
    - $1,500
    - $1500/mo
    - 1500 per month
    """
    if not price_text:
        return None

    # 移除非数字字符（保留逗号和点）
    price_str = re.sub(r"[^\d,.]", "", price_text)

    # 移除逗号
    price_str = price_str.replace(",", "")

    try:
        return float(price_str)
    except:
        return None

# 使用
price = parse_price("$1,500/mo")  # 1500.0
```

### 日期解析

```python
from dateutil.parser import parse as parse_date

def normalize_date(date_text: str) -> str | None:
    """
    规范化日期格式

    支持：
    - "2 hours ago"
    - "Yesterday"
    - "Oct 27, 2025"
    - "10/27/2025"

    Returns:
        ISO 8601 格式：YYYY-MM-DD
    """
    if not date_text:
        return None

    try:
        # 处理相对时间
        if "ago" in date_text.lower():
            return datetime.now().date().isoformat()
        elif "yesterday" in date_text.lower():
            return (datetime.now() - timedelta(days=1)).date().isoformat()
        elif "today" in date_text.lower():
            return datetime.now().date().isoformat()
        else:
            # 解析绝对日期
            dt = parse_date(date_text)
            return dt.date().isoformat()
    except:
        return None

# 使用
date = normalize_date("2 hours ago")  # "2025-10-27"
```

---

## 📊 数据存储模板

### Pydantic 数据模型

```python
from pydantic import BaseModel, HttpUrl, Field
from typing import Optional
from datetime import date

class NewsArticle(BaseModel):
    """新闻文章模型"""
    source_id: str
    source_name: str
    url: HttpUrl
    title: str = Field(..., min_length=1, max_length=500)
    content: str
    author: Optional[str] = None
    published_date: Optional[date] = None
    scraped_at: str

    class Config:
        extra = "allow"

class Restaurant(BaseModel):
    """餐厅信息模型"""
    name: str = Field(..., min_length=1)
    url: HttpUrl
    rating: float = Field(..., ge=0, le=5)
    address: str
    phone: Optional[str] = None
    cuisine: List[str] = []
    price_range: Optional[str] = None

    class Config:
        extra = "allow"

class HousingListing(BaseModel):
    """租房列表模型"""
    title: str
    url: HttpUrl
    price: float = Field(..., gt=0)
    address: str
    bedrooms: int = Field(..., ge=0)
    bathrooms: float = Field(..., ge=0)
    sqft: Optional[int] = None
    posted_date: Optional[date] = None

    class Config:
        extra = "allow"
```

### 保存到数据库

```python
import json
from datetime import datetime

def save_articles(articles: List[Dict], format: str = "all"):
    """
    保存文章数据

    Args:
        articles: 文章列表
        format: 保存格式 (json|csv|all)
    """
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    if format in ["json", "all"]:
        # 保存 JSON
        filename = f"hawaii_news_{timestamp}.json"
        with open(filename, "w", encoding="utf-8") as f:
            json.dump(articles, f, ensure_ascii=False, indent=2)
        print(f"✅ JSON 已保存: {filename}")

    if format in ["csv", "all"]:
        # 保存 CSV
        filename = f"hawaii_news_{timestamp}.csv"
        import pandas as pd
        df = pd.DataFrame(articles)
        df.to_csv(filename, index=False, encoding="utf-8")
        print(f"✅ CSV 已保存: {filename}")
```

---

## 🎯 定时任务模板

### 每日新闻聚合

```python
import schedule
import time

def daily_news_job():
    """每日新闻聚合任务"""
    logging.info("开始每日新闻聚合")

    # 1. 爬取新闻
    articles = scrape_hawaii_news(HAWAII_NEWS_SOURCES)

    # 2. 清洗数据
    for article in articles:
        article["content"] = clean_news_content(article["content"])

    # 3. 保存数据
    save_articles(articles, format="all")

    # 4. 发送摘要
    send_daily_summary(articles)

    logging.info(f"完成每日新闻聚合: {len(articles)} 篇文章")

# 每天早上 6:00 执行
schedule.every().day.at("06:00").do(daily_news_job)

# 运行调度器
while True:
    schedule.run_pending()
    time.sleep(60)
```

---

_最后更新: 2025-10-27_
_适用场景: HawaiiHub 本地内容采集_
_维护者: HawaiiHub AI Team_
