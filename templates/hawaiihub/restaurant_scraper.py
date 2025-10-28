#!/usr/bin/env python3
"""HawaiiHub 餐厅信息爬取模板

功能: 爬取 Yelp 上的夏威夷餐厅信息

使用方法:
    python restaurant_scraper.py
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
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# 初始化 Firecrawl 客户端
firecrawl = Firecrawl(api_key=os.getenv("FIRECRAWL_API_KEY"))

# 加载配置
with open("config/hawaiihub_sources.json", "r", encoding="utf-8") as f:
    SOURCES_CONFIG = json.load(f)

with open("config/hawaiihub_schemas.json", "r", encoding="utf-8") as f:
    SCHEMAS = json.load(f)

def scrape_restaurants(source_id: str, config: Dict) -> List[Dict]:
    """爬取餐厅信息"""
    logging.info(f"开始爬取: {config['name']}")

    restaurants = []

    try:
        # 使用 Extract 功能提取结构化数据
        result = firecrawl.scrape(
            url=config["url"],
            formats=[{
                "type": "json",
                "schema": SCHEMAS["restaurant"],
                "prompt": "Extract restaurant information"
            }]
        )

        if result.extract:
            restaurants = result.extract if isinstance(result.extract, list) else [result.extract]
            logging.info(f"  提取了 {len(restaurants)} 家餐厅")

    except Exception as e:
        logging.error(f"  爬取失败: {e}")

    return restaurants

def save_restaurants(restaurants: List[Dict]) -> None:
    """保存餐厅数据"""
    if not restaurants:
        logging.warning("没有餐厅数据需要保存")
        return

    # 创建数据目录
    data_dir = Path("data/hawaiihub/restaurants")
    data_dir.mkdir(parents=True, exist_ok=True)

    # 生成文件名
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    # 保存 JSON
    json_file = data_dir / f"restaurants_{timestamp}.json"
    with open(json_file, "w", encoding="utf-8") as f:
        json.dump(restaurants, f, ensure_ascii=False, indent=2)

    logging.info(f"✅ 保存到: {json_file}")
    logging.info(f"   总计: {len(restaurants)} 家餐厅")

def main():
    """主函数"""
    logging.info("🍜 开始 HawaiiHub 餐厅信息采集")

    all_restaurants = []

    # 遍历所有启用的餐厅源
    for source_id, config in SOURCES_CONFIG["restaurant_sources"].items():
        if config.get("enabled", False):
            restaurants = scrape_restaurants(source_id, config)
            all_restaurants.extend(restaurants)

    # 保存结果
    save_restaurants(all_restaurants)

    logging.info("✅ 餐厅信息采集完成")

if __name__ == "__main__":
    main()
