#!/usr/bin/env python3
"""HawaiiHub 新闻爬取模板

功能: 爬取夏威夷本地新闻并保存到数据库

使用方法:
    python news_scraper.py
"""

import json
import logging
import os
from datetime import datetime
from pathlib import Path
from typing import Dict, List

from dotenv import load_dotenv
from firecrawl import Firecrawl


# 加载环境变量
load_dotenv()

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/hawaiihub_scraper.log'),
        logging.StreamHandler()
    ]
)

# 初始化 Firecrawl 客户端
firecrawl = Firecrawl(api_key=os.getenv("FIRECRAWL_API_KEY"))

# 加载数据源配置
with open("config/hawaiihub_sources.json", "r", encoding="utf-8") as f:
    SOURCES_CONFIG = json.load(f)

def scrape_news_source(source_id: str, config: Dict) -> List[Dict]:
    """爬取单个新闻源"""
    logging.info(f"开始爬取: {config['name']}")

    articles = []

    try:
        # 1. 使用 Map 发现文章链接
        urls = firecrawl.map(
            url=config["url"],
            search="news article",
            limit=50
        )

        logging.info(f"  发现 {len(urls.links)} 个链接")

        # 2. 批量爬取文章（取前20个）
        if urls.links:
            result = firecrawl.batch_scrape(
                urls=urls.links[:20],
                formats=["markdown"],
                poll_interval=2
            )

            # 3. 处理结果
            for doc in result.data:
                if not doc.error:
                    article = {
                        "source_id": source_id,
                        "source_name": config["name"],
                        "url": doc.url,
                        "title": doc.metadata.title if doc.metadata else "",
                        "content": doc.markdown,
                        "scraped_at": datetime.now().isoformat()
                    }
                    articles.append(article)

            logging.info(f"  成功爬取 {len(articles)} 篇文章")

    except Exception as e:
        logging.error(f"  爬取失败: {e}")

    return articles

def save_articles(articles: List[Dict]) -> None:
    """保存文章到文件"""
    if not articles:
        logging.warning("没有文章需要保存")
        return

    # 创建数据目录
    data_dir = Path("data/hawaiihub/news")
    data_dir.mkdir(parents=True, exist_ok=True)

    # 生成文件名
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    # 保存 JSON
    json_file = data_dir / f"news_{timestamp}.json"
    with open(json_file, "w", encoding="utf-8") as f:
        json.dump(articles, f, ensure_ascii=False, indent=2)

    logging.info(f"✅ 保存到: {json_file}")
    logging.info(f"   总计: {len(articles)} 篇文章")

def main():
    """主函数"""
    logging.info("🔥 开始 HawaiiHub 新闻采集")

    all_articles = []

    # 遍历所有启用的新闻源
    for source_id, config in SOURCES_CONFIG["news_sources"].items():
        if config.get("enabled", False):
            articles = scrape_news_source(source_id, config)
            all_articles.extend(articles)

    # 保存结果
    save_articles(all_articles)

    logging.info("✅ 新闻采集完成")

if __name__ == "__main__":
    main()
