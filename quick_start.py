#!/usr/bin/env python3
"""Firecrawl 快速开始示例.

演示如何使用 Firecrawl API 爬取夏威夷新闻网站
"""

import os
from datetime import datetime
from typing import Any, Tuple

from dotenv import load_dotenv
from firecrawl import FirecrawlApp


# 加载环境变量
load_dotenv()

# ✅ 安全的密钥管理：从环境变量读取
API_KEY = os.getenv("FIRECRAWL_API_KEY")

if not API_KEY:
    raise ValueError(
        "❌ 未找到 FIRECRAWL_API_KEY 环境变量！\n"
        "请检查 .env 文件是否存在且包含有效的 API 密钥。\n"
        "运行 'python test_api_keys.py' 进行诊断。"
    )

# 初始化 Firecrawl 客户端
app = FirecrawlApp(api_key=API_KEY)


def example_1_basic_scrape() -> Any:
    """示例 1: 基础爬取.

    Returns:
        爬取结果对象（Document 类型）
    """
    print("\n" + "=" * 60)
    print("📰 示例 1: 爬取夏威夷新闻首页")
    print("=" * 60)

    url = "https://www.hawaiinewsnow.com/"

    print(f"🔄 爬取中: {url}")
    start_time = datetime.now()

    result = app.scrape(
        url=url,
        formats=["markdown"],
        only_main_content=True,  # 只要主要内容，去除广告和导航栏
    )

    elapsed = (datetime.now() - start_time).total_seconds()

    print(f"✅ 爬取成功！耗时: {elapsed:.2f}秒")
    print(f"📄 标题: {getattr(result.metadata, 'title', 'N/A')}")
    content = str(getattr(result, "markdown", ""))
    print(f"📝 内容长度: {len(content)} 字符")
    print("\n前 200 字符预览:")
    preview = content[:200] if len(content) >= 200 else content
    print(f"{preview}...")

    return result


def example_2_batch_scrape() -> Any:
    """示例 2: 批量爬取多个新闻源.

    Returns:
        批量爬取任务对象（BatchScrapeJob 类型）
    """
    print("\n" + "=" * 60)
    print("📰 示例 2: 批量爬取夏威夷新闻网站")
    print("=" * 60)

    news_sources = [
        "https://www.hawaiinewsnow.com/",
        "https://www.staradvertiser.com/",
        "https://www.civilbeat.org/",
    ]

    print(f"🔄 爬取 {len(news_sources)} 个网站...")
    start_time = datetime.now()

    # SDK v2: batch_scrape 返回 BatchScrapeJob 对象
    batch_job = app.batch_scrape(
        urls=news_sources,
        formats=["markdown"],
        only_main_content=True,
    )

    elapsed = (datetime.now() - start_time).total_seconds()

    print(f"✅ 批量爬取完成！总耗时: {elapsed:.2f}秒")
    avg_time = elapsed / len(news_sources)
    print(f"📊 平均每个网站: {avg_time:.2f}秒")

    # SDK v2: batch_job.data 是结果列表
    if batch_job.data:
        print(f"✅ 成功爬取 {len(batch_job.data)} 个网站\n")
        for i, result in enumerate(batch_job.data, 1):
            # 获取元数据
            metadata = result.metadata
            url = metadata.url if hasattr(metadata, "url") else "N/A"
            title = metadata.title if hasattr(metadata, "title") else "N/A"
            print(f"{i}. {url}")
            print(f"   标题: {title[:50]}")
            content = getattr(result, "markdown", "")
            print(f"   内容: {len(content)} 字符")
    else:
        print("⚠️ 没有获取到数据")

    return batch_job


def example_3_search() -> Any:
    """示例 3: 搜索功能.

    Returns:
        搜索结果对象（SearchData 类型）
    """
    print("\n" + "=" * 60)
    print("🔍 示例 3: 搜索夏威夷华人社区新闻")
    print("=" * 60)

    query = "Hawaii Chinese community events 夏威夷华人社区"

    print(f"🔍 搜索: {query}")
    start_time = datetime.now()

    # SDK v2: search 返回 SearchData 对象
    search_data = app.search(
        query=query,
        sources=[{"type": "web"}],
        limit=5,  # 限制结果数量
    )

    elapsed = (datetime.now() - start_time).total_seconds()

    print(f"✅ 搜索完成！耗时: {elapsed:.2f}秒")

    # SDK v2: 结果在 search_data.web 列表中
    if search_data.web:
        print(f"📊 找到 {len(search_data.web)} 个结果")
        for i, result in enumerate(search_data.web, 1):
            print(f"\n{i}. {result.title[:60]}")
            print(f"   URL: {result.url}")
            if result.description:
                print(f"   描述: {result.description[:80]}...")
    else:
        print("⚠️ 没有找到结果")

    return search_data


def example_4_with_cache() -> Tuple[Any, Any]:
    """示例 4: 使用缓存节省成本.

    Returns:
        两次爬取结果的元组（Document, Document）
    """
    print("\n" + "=" * 60)
    print("💾 示例 4: 使用缓存功能")
    print("=" * 60)

    url = "https://www.firecrawl.dev/"

    # 第一次爬取（无缓存）
    print("🔄 第一次爬取（无缓存）...")
    start_time = datetime.now()

    # 缓存 1 小时
    result1 = app.scrape(
        url=url,
        formats=["markdown"],
        max_age=3600000,
    )

    elapsed1 = (datetime.now() - start_time).total_seconds()
    print(f"⏱️ 耗时: {elapsed1:.2f}秒")

    # 第二次爬取（有缓存）
    print("\n🔄 第二次爬取（有缓存）...")
    start_time = datetime.now()

    # 使用缓存
    result2 = app.scrape(
        url=url,
        formats=["markdown"],
        max_age=3600000,
    )

    elapsed2 = (datetime.now() - start_time).total_seconds()
    print(f"⏱️ 耗时: {elapsed2:.2f}秒")

    # 对比
    print("\n📊 性能提升:")
    if elapsed2 < elapsed1:
        speedup = (elapsed1 - elapsed2) / elapsed1 * 100
        print(f"   速度提升: {speedup:.1f}%")
        print(f"   节省时间: {elapsed1 - elapsed2:.2f}秒")
        print("   💰 节省成本: 使用缓存，不消耗 API 配额")

    return result1, result2


def main() -> None:
    """主函数.

    演示 Firecrawl SDK 的 4 个核心功能
    """
    print("\n" + "🔥" * 30)
    print("   Firecrawl 快速开始示例")
    print("   HawaiiHub 新闻爬虫演示")
    print("🔥" * 30)

    try:
        # 示例 1: 基础爬取
        example_1_basic_scrape()

        # 示例 2: 批量爬取
        example_2_batch_scrape()

        # 示例 3: 搜索功能
        example_3_search()

        # 示例 4: 缓存功能
        example_4_with_cache()

        # 总结
        print("\n" + "=" * 60)
        print("🎉 所有示例运行成功！")
        print("=" * 60)
        print("\n💡 下一步:")
        print("1. 阅读 FIRECRAWL_CLOUD_API_RULES.md 学习高级用法")
        print("2. 实现成本监控和错误处理")
        print("3. 部署到生产环境")
        guide_path = "/Users/zhiledeng/Downloads/FireShot/"
        print(f"\n📚 文档位置: {guide_path}")

    except (ValueError, RuntimeError, OSError) as e:
        print(f"\n❌ 错误: {e}")
        print("\n💡 可能的原因:")
        print("1. API 密钥无效 - 先运行 python test_api_keys.py 验证")
        print("2. 网络连接问题")
        print("3. Firecrawl 服务异常")
        print("\n🔧 故障排查: 查看 FIRECRAWL_CLOUD_SETUP_GUIDE.md")


if __name__ == "__main__":
    main()
