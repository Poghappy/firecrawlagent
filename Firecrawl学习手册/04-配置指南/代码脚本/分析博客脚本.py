#!/usr/bin/env python3
"""分析 Firecrawl 博客内容

提取所有文章的标题、作者、日期、URL 等结构化数据
"""

import json
import re
from collections import defaultdict
from datetime import datetime


# 从 MCP 工具返回的 markdown 内容
MARKDOWN_CONTENT = """We just raised our Series A and shipped Firecrawl /v2 🎉. [Read the blog.](https://www.firecrawl.dev/blog/firecrawl-v2-series-a-announcement)

Blog

All Posts

Updates

Customers

Example Apps

Web Extraction

AI Engineering

Low Code

[![placeholder](https://www.firecrawl.dev/_next/image?url=%2Fimages%2Fblog%2F15-python-projects-2025%2Ftop_15_python_projects_to_build_in_2025.webp&w=3840&q=75&dpl=dpl_EHyrqtTiFDFWEn279mFtbDKkaoDJ)\\\\
\\\\
Top 15 Python Projects to Build in 2025: From Beginner to Production\\\\
\\\\
Explore a range of Python projects tailored for beginners to advanced developers, empowering you to progressively improve your Python skills, AI automation skills, and build and deploy real-world applications.\\\\
\\\\
![placeholder](https://www.firecrawl.dev/_next/image?url=%2Fblog%2Fauthors%2Fabid.jpg&w=48&q=75&dpl=dpl_EHyrqtTiFDFWEn279mFtbDKkaoDJ)\\\\
\\\\
Abid Ali Awan\\\\
\\\\
Oct 16, 2025](https://www.firecrawl.dev/blog/15-python-projects-2025)"""


def extract_articles(markdown):
    """从 Markdown 内容中提取文章信息"""
    # 正则表达式匹配文章模式
    # 格式: [标题\\\\描述\\\\作者\\\\日期](URL)
    pattern = r"\[(.*?)\\\\\n\\\\\n(.*?)\\\\\n\\\\\n.*?\\\\\n\\\\\n(.*?)\\\\\n\\\\\n(.*?)\]\((https://www\.firecrawl\.dev/blog/.*?)\)"

    articles = []
    matches = re.findall(pattern, markdown, re.DOTALL)

    for match in matches:
        title = match[0].strip()
        description = match[1].strip()
        author = match[2].strip()
        date = match[3].strip()
        url = match[4].strip()

        # 提取 slug
        slug = url.split("/")[-1]

        articles.append(
            {
                "title": title,
                "description": description,
                "author": author,
                "date": date,
                "url": url,
                "slug": slug,
            }
        )

    return articles


def analyze_articles(articles):
    """分析文章数据"""
    print("=" * 80)
    print("📊 Firecrawl 博客分析报告")
    print("=" * 80)

    print(f"\n📝 总文章数: {len(articles)}")

    # 按作者统计
    authors = defaultdict(int)
    for article in articles:
        authors[article["author"]] += 1

    print("\n👥 作者统计 (前 10 名):")
    for i, (author, count) in enumerate(
        sorted(authors.items(), key=lambda x: x[1], reverse=True)[:10], 1
    ):
        print(f"{i:2d}. {author:30s} - {count:3d} 篇")

    # 按月份统计
    months = defaultdict(int)
    for article in articles:
        date_str = article["date"]
        try:
            # 解析日期（格式: "Oct 16, 2025"）
            parts = date_str.split()
            if len(parts) >= 2:
                month_year = f"{parts[0]} {parts[2]}" if len(parts) >= 3 else parts[0]
                months[month_year] += 1
        except:
            pass

    print("\n📅 发布时间统计 (前 12 个月):")
    for i, (month, count) in enumerate(sorted(months.items(), reverse=True)[:12], 1):
        print(f"{i:2d}. {month:15s} - {count:3d} 篇")

    # 热门主题（从标题中提取关键词）
    keywords = defaultdict(int)
    stop_words = {
        "the",
        "a",
        "an",
        "and",
        "or",
        "but",
        "in",
        "on",
        "at",
        "to",
        "for",
        "of",
        "with",
        "how",
        "using",
        "guide",
        "tutorial",
        "introduction",
        "complete",
    }

    for article in articles:
        title = article["title"].lower()
        words = re.findall(r"\b\w+\b", title)
        for word in words:
            if word not in stop_words and len(word) > 3:
                keywords[word] += 1

    print("\n🔥 热门主题关键词 (前 20 个):")
    for i, (keyword, count) in enumerate(
        sorted(keywords.items(), key=lambda x: x[1], reverse=True)[:20], 1
    ):
        print(f"{i:2d}. {keyword:20s} - {count:3d} 次")

    # 最新文章
    print("\n📌 最新文章 (前 10 篇):")
    for i, article in enumerate(articles[:10], 1):
        print(f"{i:2d}. {article['date']:15s} - {article['title'][:60]}")

    return {
        "total_articles": len(articles),
        "authors": dict(authors),
        "months": dict(months),
        "keywords": dict(
            sorted(keywords.items(), key=lambda x: x[1], reverse=True)[:50]
        ),
    }


def main():
    """主函数"""
    # 读取完整的 Markdown 文件
    try:
        with open("firecrawl_blog.md", "r", encoding="utf-8") as f:
            content = f.read()
    except:
        print("❌ 无法读取 firecrawl_blog.md 文件")
        print("💡 请先运行 Firecrawl MCP 工具爬取博客内容")
        return

    # 提取文章
    print("🔍 正在提取文章...")
    articles = extract_articles(content)

    if not articles:
        print("⚠️ 未找到文章，尝试使用备用解析方法...")

        # 备用方法：简单按行解析
        lines = content.split("\n")
        articles = []
        current_title = None

        for line in lines:
            # 查找包含日期的链接行
            if "https://www.firecrawl.dev/blog/" in line and (
                "2025" in line or "2024" in line
            ):
                # 提取 URL
                url_match = re.search(r"https://www\.firecrawl\.dev/blog/[^\)]+", line)
                if url_match:
                    url = url_match.group(0)
                    slug = url.split("/")[-1]

                    # 提取标题（URL 前的文本）
                    title_match = re.search(r"\[(.*?)\]", line)
                    title = title_match.group(1) if title_match else "Unknown"

                    # 提取日期
                    date_match = re.search(
                        r"(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d+,\s+\d{4}",
                        line,
                    )
                    date = date_match.group(0) if date_match else "Unknown"

                    articles.append(
                        {
                            "title": title.split("\\\\")[
                                0
                            ].strip(),  # 取第一部分作为标题
                            "description": "",
                            "author": "",
                            "date": date,
                            "url": url,
                            "slug": slug,
                        }
                    )

    print(f"✅ 成功提取 {len(articles)} 篇文章\n")

    # 分析文章
    stats = analyze_articles(articles)

    # 保存结构化数据
    output = {
        "scraped_at": datetime.now().isoformat(),
        "source_url": "https://www.firecrawl.dev/blog",
        "total_articles": len(articles),
        "statistics": stats,
        "articles": articles,
    }

    output_file = "firecrawl_blog_articles.json"
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

    print(f"\n💾 结构化数据已保存到: {output_file}")

    # 生成 CSV
    csv_file = "firecrawl_blog_articles.csv"
    with open(csv_file, "w", encoding="utf-8") as f:
        f.write("标题,作者,日期,URL,Slug\n")
        for article in articles:
            title = article["title"].replace(",", ";")  # 处理逗号
            f.write(
                f'"{title}","{article["author"]}","{article["date"]}","{article["url"]}","{article["slug"]}"\n'
            )

    print(f"💾 CSV 数据已保存到: {csv_file}")

    print("\n" + "=" * 80)
    print("✅ 分析完成！")
    print("=" * 80)
    print("\n📁 生成的文件:")
    print("  1. firecrawl_blog.md - 完整 Markdown 内容")
    print("  2. firecrawl_blog_articles.json - 结构化 JSON 数据")
    print("  3. firecrawl_blog_articles.csv - CSV 格式数据")


if __name__ == "__main__":
    main()
