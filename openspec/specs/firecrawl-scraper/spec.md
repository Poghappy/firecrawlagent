# Firecrawl 爬虫规范

**模块**: firecrawl-scraper  
**负责人**: HawaiiHub AI Team  
**更新时间**: 2025-10-28  
**版本**: v1.0.0

---

## 目的

定义 Firecrawl 云 API 爬虫的标准使用方式，确保数据采集的稳定性、成本效率和代码质量。

---

## 要求

### Requirement: 工具选择策略

系统必须按照以下优先级选择爬取工具。

#### Scenario: 复杂动态页面
- 当页面包含大量 JavaScript 或动态加载内容时
- 则必须使用 MCP Firecrawl 工具
- 并且设置 `onlyMainContent=True`

#### Scenario: 批量已知 URL
- 当需要爬取多个已知 URL 时
- 则必须使用 Python SDK 的 `batch_scrape()` 方法
- 并且一次处理不超过 100 个 URL

#### Scenario: 整站深度爬取
- 当需要爬取网站所有页面时
- 则必须使用 Python SDK 的 `crawl()` 方法
- 并且设置合理的 `limit` 参数控制成本

---

### Requirement: API 密钥管理

系统必须安全管理 API 密钥并支持密钥轮换。

#### Scenario: 环境变量读取
- 当系统初始化 Firecrawl 客户端时
- 则必须从环境变量读取 API 密钥
- 并且不能硬编码密钥到代码中

#### Scenario: 密钥轮换
- 当遇到速率限制错误时
- 则系统应自动切换到备用 API 密钥
- 并且记录切换日志

---

### Requirement: 错误处理和重试

系统必须实现完整的错误处理和重试机制。

#### Scenario: 超时重试
- 当请求超时时
- 则系统应使用指数退避策略重试
- 并且最多重试 3 次

#### Scenario: 速率限制
- 当遇到速率限制错误时
- 则系统应等待指定时间后重试
- 或切换到备用 API 密钥

#### Scenario: 不可恢复错误
- 当遇到 4xx 客户端错误时
- 则系统应记录错误日志并返回 None
- 并且不应重试

---

### Requirement: 成本控制

系统必须监控和控制 API 使用成本。

#### Scenario: 每日预算检查
- 在执行每次爬取前
- 则系统应检查是否超出每日预算
- 并且超出时抛出 BudgetExceededError

#### Scenario: 缓存策略
- 当爬取相同 URL 时
- 则系统应优先使用缓存数据（2天内有效）
- 并且设置 `max_age=172800000` 参数

#### Scenario: 成本记录
- 在每次 API 调用后
- 则系统应记录请求次数和累计成本
- 并且输出到日志文件

---

### Requirement: 数据保存格式

系统必须以 3 种格式保存爬取的数据。

#### Scenario: 多格式保存
- 当爬取成功后
- 则系统应同时保存 Markdown、JSON 和 CSV 格式
- 并且使用时间戳作为文件名

#### Scenario: 原始数据保留
- 当保存 Markdown 格式时
- 则必须包含元数据（URL、时间、来源）
- 并且保持原始内容不变

---

### Requirement: 数据验证

系统必须使用 Pydantic 验证爬取的数据结构。

#### Scenario: 文章数据验证
- 当解析文章数据时
- 则必须验证 title、url、author、date 字段
- 并且在验证失败时记录详细错误信息

---

### Requirement: 日志记录

系统必须记录所有关键操作的日志。

#### Scenario: 成功日志
- 当爬取成功时
- 则应记录 INFO 级别日志，包含 URL 和耗时
- 并且格式为："成功爬取: {url} (耗时: {duration}秒)"

#### Scenario: 警告日志
- 当发生可恢复错误时
- 则应记录 WARNING 级别日志
- 并且包含重试信息

#### Scenario: 错误日志
- 当发生不可恢复错误时
- 则应记录 ERROR 级别日志
- 并且包含完整堆栈信息

---

## 实现参考

### Python SDK v2 标准用法

```python
from firecrawl import FirecrawlApp
from typing import Optional
import os
import logging

def scrape_with_retry(url: str, max_retries: int = 3) -> Optional[dict]:
    """
    带重试的标准爬取方法
    
    Args:
        url: 要爬取的 URL
        max_retries: 最大重试次数
        
    Returns:
        爬取结果，失败返回 None
    """
    app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))
    
    for attempt in range(max_retries):
        try:
            result = app.scrape(
                url=url,
                formats=["markdown"],
                only_main_content=True,
                max_age=172800000  # 2天缓存
            )
            
            if not result or not hasattr(result, "markdown"):
                raise ValueError("返回结果无效")
            
            logging.info(f"成功爬取: {url}")
            return result
            
        except Exception as e:
            if attempt < max_retries - 1:
                wait_time = 2 ** attempt
                logging.warning(f"重试 {attempt+1}/{max_retries}: {url}")
                time.sleep(wait_time)
            else:
                logging.error(f"爬取失败: {url} - {e}")
                return None
```

---

## 依赖关系

- **环境变量**: `FIRECRAWL_API_KEY`, `FIRECRAWL_DAILY_BUDGET`
- **Python 包**: `firecrawl-py`, `pydantic`, `python-dotenv`
- **MCP 服务器**: firecrawl-mcp-server（可选）

---

## 测试要求

### 单元测试
- Mock Firecrawl API 调用
- 测试重试逻辑
- 测试错误处理
- 测试成本控制

### 集成测试
- 使用真实 API 测试（开发环境）
- 验证数据格式
- 验证缓存机制

---

## 性能指标

- **平均响应时间**: < 5 秒
- **成功率**: > 95%
- **缓存命中率**: > 60%
- **每日成本**: < $10

---

## 变更历史

- **2025-10-28**: 初始版本，定义核心规范

