#!/usr/bin/env python3
"""
HawaiiHub 数据采集脚本

基于 HAWAIIHUB_DATA_SOURCES_CATALOG.md 中定义的数据源进行采集

用法:
    python3 hawaiihub_scraper.py --category news --priority P0
    python3 hawaiihub_scraper.py --source "Hawaii News Now"
    python3 hawaiihub_scraper.py --all
"""

import json
import logging
import os
import sys
import time
from datetime import datetime
from pathlib import Path

from dotenv import load_dotenv

# 导入 Firecrawl SDK
try:
    from firecrawl import FirecrawlApp
except ImportError:
    print("错误: 请先安装 Firecrawl SDK")
    print("运行: pip3 install --break-system-packages firecrawl-py")
    sys.exit(1)

# 加载环境变量
load_dotenv()

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("logs/hawaiihub_scraper.log"),
        logging.StreamHandler(),
    ],
)
logger = logging.getLogger(__name__)


# ==================== 数据源配置 ====================

NEWS_SOURCES = [
    {
        "name": "Hawaii News Now",
        "url": "https://www.hawaiinewsnow.com/",
        "category": "news",
        "priority": "P0",
        "frequency": "*/2 * * * *",  # 每2小时
        "scrape_config": {
            "formats": ["markdown"],
            "only_main_content": True,
            "max_age": 7200000,  # 2小时缓存
        },
    },
    {
        "name": "Honolulu Civil Beat",
        "url": "https://www.civilbeat.org/",
        "category": "news",
        "priority": "P0",
        "frequency": "0 */6 * * *",  # 每6小时
        "scrape_config": {
            "formats": ["markdown"],
            "only_main_content": True,
            "max_age": 21600000,  # 6小时缓存
        },
    },
    {
        "name": "Honolulu Star-Advertiser",
        "url": "https://www.staradvertiser.com/",
        "category": "news",
        "priority": "P0",
        "frequency": "0 */4 * * *",  # 每4小时
        "scrape_config": {
            "formats": ["markdown"],
            "only_main_content": True,
            "max_age": 14400000,  # 4小时缓存
        },
    },
    {
        "name": "KHON2",
        "url": "https://www.khon2.com/",
        "category": "news",
        "priority": "P0",
        "frequency": "0 */6 * * *",
        "scrape_config": {"formats": ["markdown"], "only_main_content": True},
    },
]

CHINESE_COMMUNITY_SOURCES = [
    {
        "name": "夏威夷中国日报",
        "url": "https://hawaiichinesedaily.com/",
        "category": "chinese_community",
        "priority": "P0",
        "frequency": "0 */4 * * *",  # 每4小时
        "scrape_config": {"formats": ["markdown"], "only_main_content": True},
    },
    {
        "name": "Chinese Chamber of Commerce",
        "url": "https://www.chinesechamber.com/",
        "category": "chinese_community",
        "priority": "P0",
        "frequency": "0 9,18 * * 1,4",  # 每周一、四
        "scrape_config": {"formats": ["markdown"], "only_main_content": True},
    },
]

RESTAURANT_SOURCES = [
    {
        "name": "Yelp Honolulu Hawaiian",
        "url": "https://www.yelp.com/search?cflt=hawaiian&find_loc=Honolulu%2C+HI",
        "category": "restaurant",
        "priority": "P1",
        "frequency": "0 10 * * *",  # 每天10点
        "scrape_config": {"formats": ["markdown"], "only_main_content": True},
    },
    {
        "name": "OpenTable Hawaii",
        "url": "https://www.opentable.com/metro/hawaii-restaurants",
        "category": "restaurant",
        "priority": "P1",
        "frequency": "0 11 * * *",  # 每天11点
        "scrape_config": {"formats": ["markdown"], "only_main_content": True},
    },
]

EVENT_SOURCES = [
    {
        "name": "Go Hawaii Official Events",
        "url": "https://www.gohawaii.com/trip-planning/events-festivals",
        "category": "events",
        "priority": "P1",
        "frequency": "0 8 * * 1",  # 每周一8点
        "scrape_config": {"formats": ["markdown"], "only_main_content": True},
    },
    {
        "name": "Go Hawaii 中文版",
        "url": "https://www.gohawaii.cn/cn",
        "category": "events",
        "priority": "P1",
        "frequency": "0 9 * * 1",  # 每周一9点
        "scrape_config": {"formats": ["markdown"], "only_main_content": True},
    },
]

BUSINESS_SOURCES = [
    {
        "name": "Yellow Pages Honolulu",
        "url": "https://www.yellowpages.com/honolulu-hi",
        "category": "business",
        "priority": "P2",
        "frequency": "0 2 1 * *",  # 每月1号
        "scrape_config": {"formats": ["markdown"], "only_main_content": True},
    }
]

# 合并所有数据源
ALL_SOURCES = (
    NEWS_SOURCES
    + CHINESE_COMMUNITY_SOURCES
    + RESTAURANT_SOURCES
    + EVENT_SOURCES
    + BUSINESS_SOURCES
)


# ==================== 采集类 ====================


class HawaiiHubScraper:
    """HawaiiHub 数据采集器"""

    def __init__(self, api_key: str | None = None):
        """
        初始化采集器

        Args:
            api_key: Firecrawl API 密钥，默认从环境变量读取
        """
        self.api_key = api_key or os.getenv("FIRECRAWL_API_KEY")
        if not self.api_key:
            raise ValueError("未找到 FIRECRAWL_API_KEY，请设置环境变量")

        self.app = FirecrawlApp(api_key=self.api_key)
        self.request_count = 0
        self.success_count = 0
        self.failed_count = 0
        self.total_cost = 0.0

        # 创建数据目录
        self.data_dir = Path("data/hawaiihub")
        self.data_dir.mkdir(parents=True, exist_ok=True)

    def scrape_source(self, source: dict) -> dict | None:
        """
        采集单个数据源

        Args:
            source: 数据源配置

        Returns:
            采集结果字典，失败返回 None
        """
        name = source["name"]
        url = source["url"]
        config = source["scrape_config"]

        logger.info(f"开始采集: {name} ({url})")

        try:
            # 执行采集
            result = self.app.scrape(url=url, **config)

            # 更新统计
            self.request_count += 1
            self.success_count += 1
            self.total_cost += 0.01  # 假设每次 $0.01

            # 构建结果
            scraped_data = {
                "source_name": name,
                "source_url": url,
                "category": source["category"],
                "priority": source["priority"],
                "content": result.markdown
                if hasattr(result, "markdown")
                else str(result),
                "metadata": result.metadata if hasattr(result, "metadata") else {},
                "scraped_at": datetime.now().isoformat(),
            }

            logger.info(
                f"采集成功: {name} | "
                f"请求 #{self.request_count} | "
                f"成本: ${self.total_cost:.2f}"
            )

            return scraped_data

        except Exception as e:
            self.request_count += 1
            self.failed_count += 1
            logger.error(f"采集失败: {name} - {e}")
            return None

    def scrape_by_category(self, category: str) -> list[dict]:
        """
        按类别采集

        Args:
            category: 类别名称（news, chinese_community, restaurant, events, business）

        Returns:
            采集结果列表
        """
        sources = [s for s in ALL_SOURCES if s["category"] == category]

        if not sources:
            logger.warning(f"未找到类别: {category}")
            return []

        logger.info(f"按类别采集: {category} ({len(sources)} 个数据源)")

        results = []
        for source in sources:
            result = self.scrape_source(source)
            if result:
                results.append(result)
            time.sleep(1)  # 避免速率限制

        return results

    def scrape_by_priority(self, priority: str) -> list[dict]:
        """
        按优先级采集

        Args:
            priority: 优先级（P0, P1, P2）

        Returns:
            采集结果列表
        """
        sources = [s for s in ALL_SOURCES if s["priority"] == priority]

        if not sources:
            logger.warning(f"未找到优先级: {priority}")
            return []

        logger.info(f"按优先级采集: {priority} ({len(sources)} 个数据源)")

        results = []
        for source in sources:
            result = self.scrape_source(source)
            if result:
                results.append(result)
            time.sleep(1)

        return results

    def scrape_by_name(self, name: str) -> dict | None:
        """
        按名称采集单个数据源

        Args:
            name: 数据源名称

        Returns:
            采集结果，失败返回 None
        """
        sources = [s for s in ALL_SOURCES if s["name"] == name]

        if not sources:
            logger.warning(f"未找到数据源: {name}")
            return None

        return self.scrape_source(sources[0])

    def scrape_all(self) -> list[dict]:
        """
        采集所有数据源

        Returns:
            采集结果列表
        """
        logger.info(f"采集所有数据源 ({len(ALL_SOURCES)} 个)")

        results = []
        for source in ALL_SOURCES:
            result = self.scrape_source(source)
            if result:
                results.append(result)
            time.sleep(2)  # 避免速率限制

        return results

    def save_results(self, results: list[dict], prefix: str = "scraped"):
        """
        保存采集结果

        Args:
            results: 采集结果列表
            prefix: 文件名前缀
        """
        if not results:
            logger.warning("无数据可保存")
            return

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

        # 1. 保存 JSON
        json_file = self.data_dir / f"{prefix}_{timestamp}.json"
        with open(json_file, "w", encoding="utf-8") as f:
            json.dump(results, f, ensure_ascii=False, indent=2)
        logger.info(f"已保存 JSON: {json_file}")

        # 2. 保存 Markdown（按类别）
        by_category = {}
        for item in results:
            category = item["category"]
            if category not in by_category:
                by_category[category] = []
            by_category[category].append(item)

        for category, items in by_category.items():
            md_file = self.data_dir / f"{prefix}_{category}_{timestamp}.md"
            with open(md_file, "w", encoding="utf-8") as f:
                f.write(f"# {category.upper()} 采集结果\n\n")
                f.write(f"> 采集时间: {datetime.now()}\n\n")
                f.write(f"> 数据源数量: {len(items)}\n\n")
                f.write("---\n\n")

                for item in items:
                    f.write(f"## {item['source_name']}\n\n")
                    f.write(f"- **URL**: {item['source_url']}\n")
                    f.write(f"- **优先级**: {item['priority']}\n")
                    f.write(f"- **采集时间**: {item['scraped_at']}\n\n")
                    f.write("### 内容\n\n")
                    f.write(item["content"][:1000])  # 截取前1000字符
                    f.write("\n\n---\n\n")

            logger.info(f"已保存 Markdown: {md_file}")

    def print_statistics(self):
        """打印采集统计"""
        success_rate = (
            self.success_count / self.request_count * 100
            if self.request_count > 0
            else 0
        )

        print("\n" + "=" * 60)
        print("📊 采集统计")
        print("=" * 60)
        print(f"总请求数: {self.request_count}")
        print(f"成功数: {self.success_count}")
        print(f"失败数: {self.failed_count}")
        print(f"成功率: {success_rate:.1f}%")
        print(f"总成本: ${self.total_cost:.2f}")
        print("=" * 60 + "\n")


# ==================== 命令行接口 ====================


def main():
    """主函数"""
    import argparse

    parser = argparse.ArgumentParser(
        description="HawaiiHub 数据采集脚本",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  # 采集所有新闻源
  python3 hawaiihub_scraper.py --category news

  # 采集 P0 优先级数据源
  python3 hawaiihub_scraper.py --priority P0

  # 采集单个数据源
  python3 hawaiihub_scraper.py --source "Hawaii News Now"

  # 采集所有数据源
  python3 hawaiihub_scraper.py --all

  # 列出所有数据源
  python3 hawaiihub_scraper.py --list
        """,
    )

    parser.add_argument(
        "--category",
        choices=["news", "chinese_community", "restaurant", "events", "business"],
        help="按类别采集",
    )
    parser.add_argument("--priority", choices=["P0", "P1", "P2"], help="按优先级采集")
    parser.add_argument("--source", help="采集指定名称的数据源")
    parser.add_argument("--all", action="store_true", help="采集所有数据源")
    parser.add_argument("--list", action="store_true", help="列出所有数据源")

    args = parser.parse_args()

    # 列出数据源
    if args.list:
        print("\n📋 可用数据源列表:\n")
        for source in ALL_SOURCES:
            print(f"- {source['name']}")
            print(f"  类别: {source['category']}")
            print(f"  优先级: {source['priority']}")
            print(f"  URL: {source['url']}")
            print()
        return

    # 创建采集器
    try:
        scraper = HawaiiHubScraper()
    except ValueError as e:
        logger.error(e)
        sys.exit(1)

    # 执行采集
    results = []

    if args.category:
        results = scraper.scrape_by_category(args.category)
        prefix = f"category_{args.category}"
    elif args.priority:
        results = scraper.scrape_by_priority(args.priority)
        prefix = f"priority_{args.priority}"
    elif args.source:
        result = scraper.scrape_by_name(args.source)
        if result:
            results = [result]
        prefix = "single_source"
    elif args.all:
        results = scraper.scrape_all()
        prefix = "all_sources"
    else:
        parser.print_help()
        return

    # 保存结果
    if results:
        scraper.save_results(results, prefix=prefix)

    # 打印统计
    scraper.print_statistics()


if __name__ == "__main__":
    main()
