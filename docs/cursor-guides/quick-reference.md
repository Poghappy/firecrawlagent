# 🚀 Firecrawl 快速参考卡

> **一页纸掌握所有核心要点**
> 打印此页，贴在显示器旁边！

---

## ⚡ 5 秒决策：用什么工具？

```
┌─ 复杂页面（JS多、动态加载）→ MCP 工具（一行代码）
├─ 批量爬取（已知URLs）    → batch_scrape()
├─ 整站爬取              → crawl()
└─ 搜索+爬取             → search()
```

---

## 🔥 最常用的 3 个命令

### 1. MCP 工具（最简单，推荐！）

```python
result = mcp_firecrawl_scrape(
    url="https://example.com",
    formats=["markdown"],
    onlyMainContent=True  # 只要主要内容
)
content = result.markdown
```

### 2. Python SDK 批量爬取

```python
from firecrawl import FirecrawlApp
app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))

# 批量爬取（最快！）
urls = ["url1", "url2", "url3"]
results = app.batch_scrape(urls, formats=["markdown"])
```

### 3. 带缓存的安全爬取

```python
def safe_scrape(url: str) -> dict | None:
    """带重试 + 缓存"""
    # 1. 检查缓存
    cached = redis.get(f"cache:{url}")
    if cached:
        return cached

    # 2. 爬取（3次重试）
    for i in range(3):
        try:
            result = app.scrape(url, only_main_content=True)
            redis.setex(f"cache:{url}", 3600, result.markdown)
            return result
        except:
            if i == 2:
                return None
            time.sleep(2 ** i)
```

---

## 💰 成本控制 3 要素

| 要素        | 做法         | 节省           |
| ----------- | ------------ | -------------- |
| **1. 缓存** | Redis 1小时  | **-50%**       |
| **2. 批量** | batch_scrape | **-30%**       |
| **3. 轮换** | 4个密钥      | **+300% 配额** |

**每月成本**: 预估 $43 << 预算 $200 ✅

---

## ⚠️ 5 个绝对禁止

```python
# ❌ 1. 硬编码密钥
api_key = "fc-xxx"  # 错误！

# ✅ 正确
api_key = os.getenv("FIRECRAWL_API_KEY")
```

```python
# ❌ 2. 无错误处理
result = app.scrape(url)  # 可能崩溃

# ✅ 正确
try:
    result = app.scrape(url)
except Exception as e:
    logging.error(f"错误: {e}")
```

```python
# ❌ 3. 串行处理
for url in urls:
    scrape(url)  # 慢！

# ✅ 正确
batch_scrape(urls)  # 快！
```

```python
# ❌ 4. 单引号
msg = 'hello'  # 错误

# ✅ 正确
msg = "hello"  # 项目标准
```

```python
# ❌ 5. 无类型注解
def scrape(url):  # 错误

# ✅ 正确
def scrape(url: str) -> dict:
```

---

## 🐍 Python 必备 4 件套

```python
# 1. 类型注解（必须！）
def scrape(url: str, timeout: int = 60) -> Optional[Dict[str, str]]:

# 2. 文档字符串（中文）
"""
爬取网页内容

Args:
    url: 目标 URL
    timeout: 超时时间（秒）

Returns:
    包含 markdown 内容的字典，失败返回 None
"""

# 3. 错误处理
try:
    result = app.scrape(url)
except Exception as e:
    logging.error(f"错误: {e}")
    return None

# 4. 日志记录
logging.info(f"成功爬取: {url}")
```

---

## 🎯 HawaiiHub 新闻爬取模板

```python
# 夏威夷新闻源
SOURCES = [
    "https://www.hawaiinewsnow.com/",
    "https://www.staradvertiser.com/",
    "https://www.civilbeat.org/",
]

# 爬取流程
for source in SOURCES:
    # 1. 爬首页
    result = app.scrape(source, only_main_content=True)

    # 2. 提取链接
    links = extract_links(result.markdown)

    # 3. 批量爬取
    articles = batch_scrape(links[:10])

    # 4. 保存数据
    save_to_db(articles)
```

---

## 🆕 SDK v2 重要变化

| 场景           | 命名方式 | 示例                     |
| -------------- | -------- | ------------------------ |
| **MCP 工具**   | 驼峰式   | `onlyMainContent=True`   |
| **Python SDK** | 下划线   | `only_main_content=True` |
| **返回值**     | 属性访问 | `result.markdown`        |

```python
# ✅ 正确：SDK v2 属性访问
content = result.markdown  # 正确
title = result.metadata.title  # 正确

# ❌ 错误：字典访问
content = result["markdown"]  # 会报错
```

---

## 🆘 遇到问题？

### 常见错误和解决方案

| 错误                | 原因       | 解决                         |
| ------------------- | ---------- | ---------------------------- |
| **Request Timeout** | 页面太复杂 | 用 MCP 工具                  |
| **Rate Limit**      | 请求太频繁 | 密钥轮换                     |
| **Invalid API Key** | 密钥错误   | 检查 .env                    |
| **Empty Result**    | 页面无内容 | 设置 `onlyMainContent=False` |

### 诊断命令

```bash
# 测试 API 密钥
python3 scripts/test_api_keys.py

# 查看日志
tail -f logs/firecrawl.log

# 查看规则
cat .cursorrules
```

---

## 📚 文件位置

| 文件          | 位置                                   | 说明               |
| ------------- | -------------------------------------- | ------------------ |
| **主规则**    | `.cursorrules`                         | 完整规则（851行）  |
| **Firecrawl** | `.cursor/rules/firecrawl-rules.md`     | Firecrawl 详细规范 |
| **Python**    | `.cursor/rules/python-standards.md`    | Python 代码标准    |
| **成本**      | `.cursor/rules/cost-control.md`        | 成本控制           |
| **模板**      | `.cursor/rules/hawaiihub-templates.md` | HawaiiHub 模板     |

---

## 🎓 记住这 5 条

1. ✅ **MCP 工具优先**（简单页面也推荐）
2. ✅ **批量处理**（别一个个爬）
3. ✅ **使用缓存**（省钱又快）
4. ✅ **错误处理**（必须 try-except）
5. ✅ **类型注解**（所有函数都要）

---

**💡 提示**: 把这页打印出来，贴在显示器旁边，随时查阅！

---

_最后更新: 2025-10-27_
_适用项目: FireShot + HawaiiHub_
_维护者: HawaiiHub AI Team_
