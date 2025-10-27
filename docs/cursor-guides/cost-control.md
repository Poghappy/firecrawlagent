# 成本控制规范

> **最后更新**: 2025-10-27
> **月度预算**: $200
> **目标成本**: <$50/月

---

## 💰 成本概览

### Firecrawl 定价

| 操作             | 成本        | 说明                   |
| ---------------- | ----------- | ---------------------- |
| **Scrape**       | $0.005/页   | 单页爬取               |
| **Batch Scrape** | $0.005/页   | 批量爬取（无额外费用） |
| **Crawl**        | $0.005/页   | 整站爬取               |
| **Search**       | $0.01/请求  | 搜索（含爬取）         |
| **Map**          | $0.001/请求 | 获取站点地图           |

### 月度成本预估

| 场景         | 月请求量  | 月成本 | 说明      |
| ------------ | --------- | ------ | --------- |
| **轻度使用** | 1,000 页  | $5     | 测试/开发 |
| **中度使用** | 5,000 页  | $25    | 日常运营  |
| **重度使用** | 10,000 页 | $50    | 高频爬取  |
| **极端使用** | 40,000 页 | $200   | 预算上限  |

### HawaiiHub 预估

```python
# 夏威夷新闻爬取（每日）
daily_requests = {
    "新闻首页": 3 * 1,      # 3 个源 × 1 次
    "新闻详情": 3 * 10,     # 3 个源 × 10 篇
    "商家信息": 5 * 2,      # 5 个源 × 2 次
    "租房信息": 2 * 5,      # 2 个源 × 5 次
}

daily_total = sum(daily_requests.values())  # 48 次/天
monthly_total = daily_total * 30  # 1,440 次/月
monthly_cost = monthly_total * 0.005  # $7.2/月

# ✅ 远低于预算 $200
```

---

## 🎯 成本优化策略

### 策略 1: 缓存（节省 50%+）

```python
# ✅ 推荐：使用缓存
result = app.scrape(
    url="https://example.com",
    formats=["markdown"],
    max_age=172800000  # 2 天缓存（48小时 × 3600秒 × 1000毫秒）
)

# 缓存策略表
CACHE_STRATEGY = {
    # 内容类型: (TTL毫秒, 节省%)
    "实时新闻": (3600000, 30),      # 1 小时
    "每日新闻": (86400000, 50),     # 24 小时
    "商家信息": (604800000, 80),    # 7 天
    "公司信息": (2592000000, 90),   # 30 天
}
```

#### Redis 缓存实现

```python
import redis
from functools import lru_cache

# Redis 客户端
redis_client = redis.Redis(host='localhost', port=6379, db=0)

def cached_scrape(url: str, ttl: int = 3600) -> str:
    """
    带 Redis 缓存的爬取

    Args:
        url: 目标 URL
        ttl: 缓存时间（秒）

    Returns:
        爬取的 Markdown 内容
    """
    cache_key = f"firecrawl:{url}"

    # 检查缓存
    cached = redis_client.get(cache_key)
    if cached:
        logging.info(f"缓存命中: {url}")
        return cached.decode('utf-8')

    # 爬取新数据
    result = app.scrape(url, formats=["markdown"], only_main_content=True)
    content = result.markdown

    # 存入缓存
    redis_client.setex(cache_key, ttl, content)
    logging.info(f"缓存存储: {url} (TTL: {ttl}s)")

    return content
```

### 策略 2: 批量处理（节省 30%）

```python
# ✅ 推荐：批量爬取
urls = [
    "https://example.com/article1",
    "https://example.com/article2",
    "https://example.com/article3",
]
results = app.batch_scrape(urls, formats=["markdown"])

# 成本：3 × $0.005 = $0.015

# ❌ 避免：逐个爬取
for url in urls:
    result = app.scrape(url)  # 3 次单独请求，慢且贵
```

### 策略 3: 密钥轮换（4x 配额）

```python
import itertools

class RotatingFirecrawlClient:
    """支持密钥轮换的客户端"""

    def __init__(self, api_keys: List[str]):
        self.api_keys = itertools.cycle(api_keys)
        self.current_key = next(self.api_keys)
        self.app = FirecrawlApp(api_key=self.current_key)
        self.request_count = defaultdict(int)

    def scrape(self, url: str, **kwargs) -> dict:
        try:
            result = self.app.scrape(url, **kwargs)
            self.request_count[self.current_key] += 1
            return result
        except RateLimitError:
            # 切换到下一个密钥
            old_key = self.current_key
            self.current_key = next(self.api_keys)
            self.app = FirecrawlApp(api_key=self.current_key)

            logging.info(
                f"密钥轮换: {old_key[:10]}... → {self.current_key[:10]}... "
                f"(已用: {self.request_count[old_key]})"
            )

            return self.app.scrape(url, **kwargs)

# 使用 4 个密钥
client = RotatingFirecrawlClient([
    os.getenv("FIRECRAWL_API_KEY"),
    os.getenv("FIRECRAWL_API_KEY_BACKUP_1"),
    os.getenv("FIRECRAWL_API_KEY_BACKUP_2"),
    os.getenv("FIRECRAWL_API_KEY_BACKUP_3"),
])

# 效果：4x 速率限制，4x 免费配额
```

### 策略 4: 智能调度

```python
# ✅ 错峰爬取（避免高峰期）
import schedule
import time

def scrape_job():
    """定时爬取任务"""
    urls = get_daily_urls()
    results = app.batch_scrape(urls)
    save_results(results)

# 在凌晨 2:00 执行（低峰期）
schedule.every().day.at("02:00").do(scrape_job)

while True:
    schedule.run_pending()
    time.sleep(60)
```

---

## 📊 请求计数和监控

### 1. 请求计数器

```python
class FirecrawlClient:
    """带成本控制的 Firecrawl 客户端"""

    def __init__(self, api_key: str, daily_budget: float = 10.0):
        self.app = FirecrawlApp(api_key=api_key)
        self.daily_budget = daily_budget
        self.request_count = 0
        self.total_cost = 0.0
        self.start_date = datetime.now().date()

    def _reset_if_new_day(self):
        """新的一天重置计数"""
        today = datetime.now().date()
        if today != self.start_date:
            self.request_count = 0
            self.total_cost = 0.0
            self.start_date = today
            logging.info("新的一天，计数重置")

    def scrape(self, url: str, **kwargs) -> dict:
        """爬取并记录成本"""
        self._reset_if_new_day()

        # 检查预算
        if self.total_cost >= self.daily_budget:
            raise BudgetExceededError(
                f"超出每日预算: ${self.daily_budget:.2f}"
            )

        # 执行爬取
        result = self.app.scrape(url, **kwargs)

        # 记录成本
        cost = 0.005  # $0.005/页
        self.request_count += 1
        self.total_cost += cost

        logging.info(
            f"请求 #{self.request_count} | "
            f"成本: ${cost:.4f} | "
            f"今日累计: ${self.total_cost:.4f}/{self.daily_budget}"
        )

        return result

    def get_stats(self) -> Dict[str, float]:
        """获取统计信息"""
        return {
            "request_count": self.request_count,
            "total_cost": self.total_cost,
            "daily_budget": self.daily_budget,
            "remaining_budget": self.daily_budget - self.total_cost,
            "budget_used_percent": (self.total_cost / self.daily_budget) * 100
        }
```

### 2. 成本报告

```python
def generate_cost_report(client: FirecrawlClient) -> str:
    """生成成本报告"""
    stats = client.get_stats()

    report = f"""
    ═══════════════════════════════════════════════
    📊 Firecrawl 成本报告
    ═══════════════════════════════════════════════

    日期: {datetime.now().strftime('%Y-%m-%d')}

    📈 今日统计:
       请求次数: {stats['request_count']}
       总成本:   ${stats['total_cost']:.4f}
       每日预算: ${stats['daily_budget']:.2f}
       剩余预算: ${stats['remaining_budget']:.4f}
       预算使用: {stats['budget_used_percent']:.1f}%

    💡 优化建议:
    """

    if stats['budget_used_percent'] > 80:
        report += "   ⚠️ 预算使用超过 80%，建议启用更多缓存\n"
    elif stats['budget_used_percent'] > 50:
        report += "   ✅ 预算使用正常\n"
    else:
        report += "   ✅ 预算充足，运行良好\n"

    report += "   ═══════════════════════════════════════════════\n"

    return report

# 使用
print(generate_cost_report(client))
```

---

## 🚨 预算告警

### 1. 预算监控

```python
class BudgetMonitor:
    """预算监控器"""

    def __init__(
        self,
        daily_budget: float = 10.0,
        warning_threshold: float = 0.8,  # 80% 告警
        critical_threshold: float = 0.95  # 95% 严重
    ):
        self.daily_budget = daily_budget
        self.warning_threshold = warning_threshold
        self.critical_threshold = critical_threshold
        self.total_cost = 0.0
        self.alerts_sent = set()

    def record_cost(self, cost: float):
        """记录成本"""
        self.total_cost += cost
        self._check_alerts()

    def _check_alerts(self):
        """检查并发送告警"""
        usage_percent = self.total_cost / self.daily_budget

        if usage_percent >= self.critical_threshold:
            if 'critical' not in self.alerts_sent:
                self._send_alert(
                    "🚨 严重",
                    f"预算使用 {usage_percent*100:.1f}%"
                )
                self.alerts_sent.add('critical')

        elif usage_percent >= self.warning_threshold:
            if 'warning' not in self.alerts_sent:
                self._send_alert(
                    "⚠️ 警告",
                    f"预算使用 {usage_percent*100:.1f}%"
                )
                self.alerts_sent.add('warning')

    def _send_alert(self, level: str, message: str):
        """发送告警"""
        logging.warning(f"{level}: {message}")
        # 这里可以集成 Slack/Email/钉钉等告警渠道
```

### 2. Slack 告警集成

```python
import requests

def send_slack_alert(message: str, webhook_url: str):
    """发送 Slack 告警"""
    payload = {
        "text": message,
        "username": "Firecrawl 成本监控",
        "icon_emoji": ":chart_with_upwards_trend:"
    }

    try:
        response = requests.post(webhook_url, json=payload)
        response.raise_for_status()
        logging.info("Slack 告警发送成功")
    except Exception as e:
        logging.error(f"Slack 告警发送失败: {e}")
```

---

## 📋 成本控制清单

### 每日检查

- [ ] 查看今日请求次数
- [ ] 检查缓存命中率（目标 >50%）
- [ ] 确认成本在预算内
- [ ] 检查是否有异常高频请求

### 每周检查

- [ ] 分析周成本趋势
- [ ] 优化高频爬取的缓存策略
- [ ] 检查密钥轮换是否正常
- [ ] 审查不必要的爬取请求

### 每月检查

- [ ] 生成月度成本报告
- [ ] 评估是否需要调整预算
- [ ] 优化整体爬取策略
- [ ] 更新成本预测

---

## 💡 最佳实践

### ✅ 推荐做法

1. **启用缓存**：所有爬取都应设置合理的 `max_age`
2. **批量处理**：使用 `batch_scrape` 而非循环 `scrape`
3. **密钥轮换**：配置 4 个 API 密钥轮流使用
4. **预算监控**：实时监控成本，设置告警阈值
5. **错峰爬取**：在低峰期（凌晨）执行大批量任务

### ❌ 避免做法

1. **过度爬取**：不必要的重复爬取
2. **忽略缓存**：每次都重新爬取
3. **串行处理**：逐个 URL 爬取
4. **无成本监控**：不记录成本数据
5. **高峰期爬取**：在业务高峰期大量爬取

---

_最后更新: 2025-10-27_
_月度预算: $200_
_目标成本: <$50/月_
