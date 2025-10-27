#!/usr/bin/env python3
"""
爬虫模板

用途：标准的网页爬取模板，包含错误处理、缓存、日志等
作者：HawaiiHub AI Team
日期：2025-10-27
"""

import logging
import os
import time
from datetime import datetime
from typing import Dict, List, Optional

from dotenv import load_dotenv
from firecrawl import FirecrawlApp
from firecrawl.exceptions import RateLimitError, RequestTimeoutError

# 加载环境变量
load_dotenv()

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.FileHandler("logs/scraper.log"), logging.StreamHandler()],
)
logger = logging.getLogger(__name__)


class WebScraper:
    """网页爬虫类"""

    def __init__(self, api_key: Optional[str] = None):
        """
        初始化爬虫

        Args:
            api_key: Firecrawl API 密钥，默认从环境变量读取
        """
        self.api_key = api_key or os.getenv("FIRECRAWL_API_KEY")
        if not self.api_key:
            raise ValueError("未找到 FIRECRAWL_API_KEY")

        self.app = FirecrawlApp(api_key=self.api_key)
        self.request_count = 0
        self.total_cost = 0.0

        logger.info("爬虫初始化完成")

    def scrape_single(
        self,
        url: str,
        formats: List[str] = ["markdown"],
        only_main_content: bool = True,
        max_retries: int = 3,
    ) -> Optional[Dict[str, str]]:
        """
        爬取单个页面

        Args:
            url: 目标 URL
            formats: 返回格式列表
            only_main_content: 是否只提取主要内容
            max_retries: 最大重试次数

        Returns:
            爬取结果，包含 markdown 等内容，失败返回 None
        """
        for attempt in range(max_retries):
            try:
                logger.info(f"开始爬取: {url} (第 {attempt + 1} 次)")

                result = self.app.scrape(
                    url=url, formats=formats, only_main_content=only_main_content
                )

                # 验证结果
                if not result or not hasattr(result, "markdown"):
                    raise ValueError("返回结果无效")

                # 记录成功
                self.request_count += 1
                self.total_cost += 0.005  # $0.005/页

                logger.info(
                    f"成功爬取: {url} "
                    f"(第 {self.request_count} 次请求，"
                    f"总成本: ${self.total_cost:.4f})"
                )

                return {
                    "url": url,
                    "markdown": result.markdown,
                    "metadata": result.metadata.__dict__ if result.metadata else {},
                    "scraped_at": datetime.now().isoformat(),
                }

            except RequestTimeoutError as e:
                if attempt < max_retries - 1:
                    wait_time = 2**attempt  # 指数退避
                    logger.warning(
                        f"超时，{wait_time}秒后重试... "
                        f"({attempt + 1}/{max_retries})"
                    )
                    time.sleep(wait_time)
                else:
                    logger.error(f"失败（{max_retries}次重试后）: {url} - {e}")
                    return None

            except RateLimitError:
                logger.error(f"速率限制: {url} - 考虑切换密钥")
                return None

            except Exception as e:
                logger.error(f"未知错误: {url} - {e}")
                return None

        return None

    def scrape_batch(
        self,
        urls: List[str],
        formats: List[str] = ["markdown"],
        only_main_content: bool = True,
    ) -> List[Dict[str, str]]:
        """
        批量爬取页面

        Args:
            urls: URL 列表
            formats: 返回格式列表
            only_main_content: 是否只提取主要内容

        Returns:
            爬取结果列表
        """
        logger.info(f"开始批量爬取: {len(urls)} 个 URL")

        try:
            results = self.app.batch_scrape(
                urls=urls, formats=formats, only_main_content=only_main_content
            )

            # 处理结果
            processed = []
            for item in results:
                if isinstance(item, tuple):
                    success, result = item
                    if success and hasattr(result, "markdown"):
                        processed.append(
                            {
                                "url": result.url,
                                "markdown": result.markdown,
                                "metadata": (
                                    result.metadata.__dict__ if result.metadata else {}
                                ),
                                "scraped_at": datetime.now().isoformat(),
                            }
                        )
                elif hasattr(item, "markdown"):
                    processed.append(
                        {
                            "url": item.url,
                            "markdown": item.markdown,
                            "metadata": item.metadata.__dict__ if item.metadata else {},
                            "scraped_at": datetime.now().isoformat(),
                        }
                    )

            # 记录成本
            self.request_count += len(urls)
            self.total_cost += len(urls) * 0.005

            logger.info(
                f"批量爬取完成: {len(processed)}/{len(urls)} 成功 "
                f"(总成本: ${self.total_cost:.4f})"
            )

            return processed

        except Exception as e:
            logger.error(f"批量爬取失败: {e}")
            return []

    def get_stats(self) -> Dict[str, float]:
        """
        获取统计信息

        Returns:
            统计数据字典
        """
        return {
            "request_count": self.request_count,
            "total_cost": self.total_cost,
            "average_cost": (
                self.total_cost / self.request_count if self.request_count > 0 else 0
            ),
        }


def main():
    """主函数"""
    # 初始化爬虫
    scraper = WebScraper()

    # 示例 1: 爬取单个页面
    url = "https://www.firecrawl.dev/"
    result = scraper.scrape_single(url)

    if result:
        print(f"\n成功爬取: {url}")
        print(f"内容长度: {len(result['markdown'])} 字符")

    # 示例 2: 批量爬取
    urls = [
        "https://www.firecrawl.dev/",
        "https://www.firecrawl.dev/blog",
    ]
    results = scraper.scrape_batch(urls)

    print(f"\n批量爬取完成: {len(results)} 个页面")

    # 显示统计
    stats = scraper.get_stats()
    print("\n统计信息:")
    print(f"  总请求数: {stats['request_count']}")
    print(f"  总成本: ${stats['total_cost']:.4f}")
    print(f"  平均成本: ${stats['average_cost']:.4f}")


if __name__ == "__main__":
    main()
