#!/usr/bin/env python3
"""
HawaiiHub Firecrawl 模板配置脚本

功能：
1. 安装所需依赖
2. 验证 API 密钥
3. 创建配置文件
4. 生成示例代码
5. 测试连接

作者: HawaiiHub AI Team
日期: 2025-10-28
"""

import json
import logging
import os
import sys
from pathlib import Path


# 配置日志
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


class HawaiiHubTemplatesSetup:
    """HawaiiHub Firecrawl 模板配置管理器"""

    def __init__(self, project_root: Path | None = None):
        """初始化配置管理器"""
        self.project_root = project_root or Path(__file__).parent.parent
        self.templates_dir = self.project_root / "templates" / "hawaiihub"
        self.config_dir = self.project_root / "config"
        self.data_dir = self.project_root / "data" / "hawaiihub"

        # 创建必要目录
        self.templates_dir.mkdir(parents=True, exist_ok=True)
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.data_dir.mkdir(parents=True, exist_ok=True)

    def check_dependencies(self) -> bool:
        """检查依赖是否安装"""
        logging.info("🔍 检查 Python 依赖...")

        # (包名, 导入名)
        required_packages = [
            ("firecrawl-py", "firecrawl"),
            ("python-dotenv", "dotenv"),
            ("requests", "requests"),
            ("pydantic", "pydantic"),
        ]

        missing_packages = []

        for package_name, import_name in required_packages:
            try:
                __import__(import_name)
                logging.info(f"  ✅ {package_name}")
            except ImportError:
                logging.warning(f"  ❌ {package_name}")
                missing_packages.append(package_name)

        if missing_packages:
            logging.error(f"缺少以下依赖: {', '.join(missing_packages)}")
            logging.info("请运行: pip3 install " + " ".join(missing_packages))
            return False

        logging.info("✅ 所有依赖已安装")
        return True

    def verify_api_key(self) -> bool:
        """验证 Firecrawl API 密钥"""
        logging.info("🔑 验证 Firecrawl API 密钥...")

        from dotenv import load_dotenv

        load_dotenv()

        api_key = os.getenv("FIRECRAWL_API_KEY")

        if not api_key:
            logging.error("❌ 未找到 FIRECRAWL_API_KEY")
            logging.info("请在 .env 文件中配置 FIRECRAWL_API_KEY=fc-xxx")
            return False

        if not api_key.startswith("fc-"):
            logging.error("❌ API 密钥格式不正确（应以 'fc-' 开头）")
            return False

        # 测试 API 连接
        try:
            from firecrawl import Firecrawl

            firecrawl = Firecrawl(api_key=api_key)

            # 简单测试
            logging.info("  测试 API 连接...")
            result = firecrawl.scrape("https://firecrawl.dev", formats=["markdown"])

            if result and hasattr(result, "markdown"):
                logging.info("✅ API 密钥有效，连接成功！")
                return True
            logging.error("❌ API 返回异常")
            return False

        except Exception as e:
            logging.error(f"❌ API 测试失败: {e}")
            return False

    def create_config_files(self) -> None:
        """创建配置文件"""
        logging.info("📝 创建配置文件...")

        # 1. HawaiiHub 数据源配置
        sources_config = {
            "news_sources": {
                "hawaiinewsnow": {
                    "url": "https://www.hawaiinewsnow.com/",
                    "name": "Hawaii News Now",
                    "type": "general",
                    "scrape_method": "crawl",
                    "cache_ttl": 3600,
                    "enabled": True,
                },
                "staradvertiser": {
                    "url": "https://www.staradvertiser.com/",
                    "name": "Honolulu Star-Advertiser",
                    "type": "general",
                    "scrape_method": "crawl",
                    "cache_ttl": 3600,
                    "enabled": True,
                },
                "civilbeat": {
                    "url": "https://www.civilbeat.org/",
                    "name": "Honolulu Civil Beat",
                    "type": "investigative",
                    "scrape_method": "crawl",
                    "cache_ttl": 7200,
                    "enabled": True,
                },
            },
            "restaurant_sources": {
                "yelp_chinese": {
                    "url": "https://www.yelp.com/search?find_desc=Chinese&find_loc=Honolulu,+HI",
                    "name": "Yelp - 檀香山中餐",
                    "type": "restaurant",
                    "scrape_method": "search",
                    "cache_ttl": 86400,
                    "enabled": True,
                },
                "yelp_japanese": {
                    "url": "https://www.yelp.com/search?find_desc=Japanese&find_loc=Honolulu,+HI",
                    "name": "Yelp - 檀香山日料",
                    "type": "restaurant",
                    "scrape_method": "search",
                    "cache_ttl": 86400,
                    "enabled": True,
                },
            },
            "housing_sources": {
                "craigslist_honolulu": {
                    "url": "https://honolulu.craigslist.org/search/apa",
                    "name": "Craigslist - 檀香山租房",
                    "type": "housing",
                    "scrape_method": "crawl",
                    "cache_ttl": 1800,
                    "enabled": True,
                }
            },
            "community_sources": {
                "kauai_chinese": {
                    "url": "https://www.kauaichineseassociation.org/",
                    "name": "Kauai Chinese Association",
                    "type": "community",
                    "scrape_method": "map",
                    "cache_ttl": 86400,
                    "enabled": True,
                }
            },
        }

        # 保存数据源配置
        sources_file = self.config_dir / "hawaiihub_sources.json"
        with open(sources_file, "w", encoding="utf-8") as f:
            json.dump(sources_config, f, ensure_ascii=False, indent=2)
        logging.info(f"  ✅ 数据源配置: {sources_file}")

        # 2. 数据Schema配置
        schemas_config = {
            "news_article": {
                "type": "object",
                "properties": {
                    "title": {"type": "string"},
                    "author": {"type": "string"},
                    "published_date": {"type": "string"},
                    "content": {"type": "string"},
                    "summary": {"type": "string"},
                    "category": {"type": "string"},
                    "tags": {"type": "array", "items": {"type": "string"}},
                },
                "required": ["title", "content"],
            },
            "restaurant": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "rating": {"type": "number"},
                    "price_range": {"type": "string"},
                    "address": {"type": "string"},
                    "phone": {"type": "string"},
                    "cuisine": {"type": "array", "items": {"type": "string"}},
                    "hours": {"type": "object"},
                    "reviews_count": {"type": "number"},
                    "website": {"type": "string"},
                },
                "required": ["name", "address"],
            },
            "housing_listing": {
                "type": "object",
                "properties": {
                    "title": {"type": "string"},
                    "price": {"type": "number"},
                    "bedrooms": {"type": "number"},
                    "bathrooms": {"type": "number"},
                    "sqft": {"type": "number"},
                    "address": {"type": "string"},
                    "description": {"type": "string"},
                    "posted_date": {"type": "string"},
                    "contact": {"type": "string"},
                },
                "required": ["title", "price"],
            },
            "community_event": {
                "type": "object",
                "properties": {
                    "title": {"type": "string"},
                    "date": {"type": "string"},
                    "time": {"type": "string"},
                    "location": {"type": "string"},
                    "organizer": {"type": "string"},
                    "description": {"type": "string"},
                    "registration_url": {"type": "string"},
                    "cost": {"type": "string"},
                },
                "required": ["title", "date"],
            },
        }

        # 保存Schema配置
        schemas_file = self.config_dir / "hawaiihub_schemas.json"
        with open(schemas_file, "w", encoding="utf-8") as f:
            json.dump(schemas_config, f, ensure_ascii=False, indent=2)
        logging.info(f"  ✅ Schema 配置: {schemas_file}")

        logging.info("✅ 配置文件创建完成")

    def create_templates(self) -> None:
        """创建代码模板"""
        logging.info("📄 创建代码模板...")

        # 1. 新闻爬取模板
        news_template = '''#!/usr/bin/env python3
"""
HawaiiHub 新闻爬取模板

功能: 爬取夏威夷本地新闻并保存到数据库

使用方法:
    python news_scraper.py
"""

import os
import json
import logging
from datetime import datetime
from pathlib import Path
from typing import List, Dict

from firecrawl import Firecrawl
from dotenv import load_dotenv

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
'''

        # 保存新闻模板
        news_file = self.templates_dir / "news_scraper.py"
        with open(news_file, "w", encoding="utf-8") as f:
            f.write(news_template)
        logging.info(f"  ✅ 新闻爬取模板: {news_file}")

        # 2. 餐厅爬取模板
        restaurant_template = '''#!/usr/bin/env python3
"""
HawaiiHub 餐厅信息爬取模板

功能: 爬取 Yelp 上的夏威夷餐厅信息

使用方法:
    python restaurant_scraper.py
"""

import os
import json
import logging
from datetime import datetime
from pathlib import Path
from typing import List, Dict

from firecrawl import Firecrawl
from dotenv import load_dotenv

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
'''

        # 保存餐厅模板
        restaurant_file = self.templates_dir / "restaurant_scraper.py"
        with open(restaurant_file, "w", encoding="utf-8") as f:
            f.write(restaurant_template)
        logging.info(f"  ✅ 餐厅爬取模板: {restaurant_file}")

        logging.info("✅ 代码模板创建完成")

    def create_quick_start_script(self) -> None:
        """创建快速启动脚本"""
        logging.info("🚀 创建快速启动脚本...")

        quick_start = '''#!/usr/bin/env python3
"""
HawaiiHub Firecrawl 快速启动脚本

快速测试所有 Firecrawl 核心功能

使用方法:
    python quick_start_hawaiihub.py
"""

import os
import logging
from firecrawl import Firecrawl
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s: %(message)s'
)

# 初始化客户端
firecrawl = Firecrawl(api_key=os.getenv("FIRECRAWL_API_KEY"))

def test_scrape():
    """测试 Scrape 功能"""
    logging.info("\\n" + "="*60)
    logging.info("1️⃣  测试 SCRAPE（单页爬取）")
    logging.info("="*60)

    try:
        doc = firecrawl.scrape(
            "https://www.hawaiinewsnow.com/",
            formats=["markdown"]
        )

        logging.info(f"✅ 成功爬取")
        logging.info(f"   URL: {doc.url}")
        logging.info(f"   内容长度: {len(doc.markdown)} 字符")
        logging.info(f"   前100字符: {doc.markdown[:100]}...")

        return True

    except Exception as e:
        logging.error(f"❌ Scrape 失败: {e}")
        return False

def test_map():
    """测试 Map 功能"""
    logging.info("\\n" + "="*60)
    logging.info("2️⃣  测试 MAP（网站地图）")
    logging.info("="*60)

    try:
        urls = firecrawl.map(
            url="https://www.hawaiinewsnow.com/",
            limit=10
        )

        logging.info(f"✅ 成功发现链接")
        logging.info(f"   发现 {len(urls.links)} 个链接:")
        for i, link in enumerate(urls.links[:5], 1):
            logging.info(f"   {i}. {link}")

        if len(urls.links) > 5:
            logging.info(f"   ... 还有 {len(urls.links) - 5} 个链接")

        return True

    except Exception as e:
        logging.error(f"❌ Map 失败: {e}")
        return False

def test_search():
    """测试 Search 功能"""
    logging.info("\\n" + "="*60)
    logging.info("3️⃣  测试 SEARCH（搜索）")
    logging.info("="*60)

    try:
        results = firecrawl.search(
            query="Hawaii news",
            limit=3
        )

        logging.info(f"✅ 成功搜索")
        logging.info(f"   找到 {len(results)} 个结果:")
        for i, result in enumerate(results, 1):
            logging.info(f"   {i}. {result.title}")
            logging.info(f"      {result.url}")

        return True

    except Exception as e:
        logging.error(f"❌ Search 失败: {e}")
        return False

def test_batch_scrape():
    """测试 Batch Scrape 功能"""
    logging.info("\\n" + "="*60)
    logging.info("4️⃣  测试 BATCH SCRAPE（批量爬取）")
    logging.info("="*60)

    urls = [
        "https://www.hawaiinewsnow.com/",
        "https://www.staradvertiser.com/"
    ]

    try:
        job = firecrawl.batch_scrape(
            urls=urls,
            formats=["markdown"],
            poll_interval=2
        )

        logging.info(f"✅ 成功批量爬取")
        logging.info(f"   状态: {job.status}")
        logging.info(f"   完成: {job.completed}/{job.total}")

        for i, doc in enumerate(job.data, 1):
            if not doc.error:
                logging.info(f"   {i}. {doc.url} - {len(doc.markdown)} 字符")
            else:
                logging.info(f"   {i}. {doc.url} - 失败: {doc.error}")

        return True

    except Exception as e:
        logging.error(f"❌ Batch Scrape 失败: {e}")
        return False

def main():
    """主函数"""
    logging.info("\\n" + "🔥"*30)
    logging.info("HawaiiHub Firecrawl 快速启动测试")
    logging.info("🔥"*30)

    # 运行所有测试
    tests = [
        ("Scrape", test_scrape),
        ("Map", test_map),
        ("Search", test_search),
        ("Batch Scrape", test_batch_scrape)
    ]

    results = {}
    for name, test_func in tests:
        results[name] = test_func()

    # 汇总结果
    logging.info("\\n" + "="*60)
    logging.info("📊 测试结果汇总")
    logging.info("="*60)

    for name, success in results.items():
        status = "✅ 通过" if success else "❌ 失败"
        logging.info(f"   {name}: {status}")

    # 总结
    total = len(results)
    passed = sum(1 for r in results.values() if r)

    logging.info("\\n" + "="*60)
    if passed == total:
        logging.info(f"🎉 完美！所有 {total} 个测试都通过了！")
        logging.info("   你已经准备好使用 Firecrawl 了！")
    else:
        logging.warning(f"⚠️  {passed}/{total} 个测试通过")
        logging.warning("   请检查失败的测试")
    logging.info("="*60)

if __name__ == "__main__":
    main()
'''

        # 保存快速启动脚本
        quick_start_file = self.project_root / "quick_start_hawaiihub.py"
        with open(quick_start_file, "w", encoding="utf-8") as f:
            f.write(quick_start)

        # 设置执行权限
        os.chmod(quick_start_file, 0o755)

        logging.info(f"  ✅ 快速启动脚本: {quick_start_file}")
        logging.info("✅ 快速启动脚本创建完成")

    def run_setup(self) -> bool:
        """运行完整配置流程"""
        logging.info("\\n" + "🔥" * 30)
        logging.info("HawaiiHub Firecrawl 模板配置工具")
        logging.info("🔥" * 30 + "\\n")

        # 1. 检查依赖
        if not self.check_dependencies():
            return False

        logging.info("")

        # 2. 验证 API 密钥
        if not self.verify_api_key():
            return False

        logging.info("")

        # 3. 创建配置文件
        self.create_config_files()

        logging.info("")

        # 4. 创建模板
        self.create_templates()

        logging.info("")

        # 5. 创建快速启动脚本
        self.create_quick_start_script()

        logging.info("")
        logging.info("=" * 60)
        logging.info("🎉 配置完成！")
        logging.info("=" * 60)
        logging.info("")
        logging.info("📁 生成的文件:")
        logging.info(f"   • 配置目录: {self.config_dir}")
        logging.info(f"   • 模板目录: {self.templates_dir}")
        logging.info(f"   • 数据目录: {self.data_dir}")
        logging.info("")
        logging.info("🚀 下一步:")
        logging.info("   1. 运行快速启动测试:")
        logging.info("      python3 quick_start_hawaiihub.py")
        logging.info("")
        logging.info("   2. 运行新闻爬取模板:")
        logging.info("      python3 templates/hawaiihub/news_scraper.py")
        logging.info("")
        logging.info("   3. 运行餐厅爬取模板:")
        logging.info("      python3 templates/hawaiihub/restaurant_scraper.py")
        logging.info("")
        logging.info("📚 文档:")
        logging.info("   • 模板目录: docs/FIRECRAWL_TEMPLATES_CATALOG.md")
        logging.info("   • 快速参考: QUICK_REFERENCE.md")
        logging.info("=" * 60)

        return True


def main() -> None:
    """主入口"""
    setup = HawaiiHubTemplatesSetup()
    success = setup.run_setup()

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
