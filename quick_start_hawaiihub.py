#!/usr/bin/env python3
"""HawaiiHub Firecrawl 快速启动脚本

快速测试所有 Firecrawl 核心功能

使用方法:
    python quick_start_hawaiihub.py
"""

import logging
import os

from dotenv import load_dotenv
from firecrawl import Firecrawl


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
    logging.info("\n" + "="*60)
    logging.info("1️⃣  测试 SCRAPE（单页爬取）")
    logging.info("="*60)

    try:
        doc = firecrawl.scrape(
            "https://www.hawaiinewsnow.com/",
            formats=["markdown"]
        )

        logging.info("✅ 成功爬取")
        logging.info(f"   URL: {doc.url}")
        logging.info(f"   内容长度: {len(doc.markdown)} 字符")
        logging.info(f"   前100字符: {doc.markdown[:100]}...")

        return True

    except Exception as e:
        logging.error(f"❌ Scrape 失败: {e}")
        return False

def test_map():
    """测试 Map 功能"""
    logging.info("\n" + "="*60)
    logging.info("2️⃣  测试 MAP（网站地图）")
    logging.info("="*60)

    try:
        urls = firecrawl.map(
            url="https://www.hawaiinewsnow.com/",
            limit=10
        )

        logging.info("✅ 成功发现链接")
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
    logging.info("\n" + "="*60)
    logging.info("3️⃣  测试 SEARCH（搜索）")
    logging.info("="*60)

    try:
        results = firecrawl.search(
            query="Hawaii news",
            limit=3
        )

        logging.info("✅ 成功搜索")
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
    logging.info("\n" + "="*60)
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

        logging.info("✅ 成功批量爬取")
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
    logging.info("\n" + "🔥"*30)
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
    logging.info("\n" + "="*60)
    logging.info("📊 测试结果汇总")
    logging.info("="*60)

    for name, success in results.items():
        status = "✅ 通过" if success else "❌ 失败"
        logging.info(f"   {name}: {status}")

    # 总结
    total = len(results)
    passed = sum(1 for r in results.values() if r)

    logging.info("\n" + "="*60)
    if passed == total:
        logging.info(f"🎉 完美！所有 {total} 个测试都通过了！")
        logging.info("   你已经准备好使用 Firecrawl 了！")
    else:
        logging.warning(f"⚠️  {passed}/{total} 个测试通过")
        logging.warning("   请检查失败的测试")
    logging.info("="*60)

if __name__ == "__main__":
    main()
