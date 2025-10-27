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

## 📁 项目目录速查

```
FireShot/
├── .env              ← API 密钥（不提交Git）
├── .cursorrules      ← 完整规则（20KB）
├── scripts/          ← 工具脚本
│   ├── test_api_keys.py      ← 测试密钥
│   └── scrape_*.py           ← 爬取示例
├── docs/             ← 文档
│   ├── FIRECRAWL_CLOUD_SETUP_GUIDE.md  ← 10分钟上手
│   └── SETUP_COMPLETE.md               ← 配置总结
└── data/             ← 数据存储
    ├── raw/          ← 原始数据
    └── cache/        ← 缓存
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
    result = mcp_firecrawl_scrape(source, onlyMainContent=True)

    # 2. 提取链接
    links = extract_links(result.markdown)

    # 3. 批量爬取
    articles = batch_scrape(links[:10])

    # 4. 保存数据
    save_to_db(articles)
```

---

## 📊 Git 提交规范速查

| 类型       | 说明     | 示例                              |
| ---------- | -------- | --------------------------------- |
| `feat`     | 新功能   | `feat(scraper): 添加MCP工具支持`  |
| `fix`      | Bug修复  | `fix(parser): 修复日期解析错误`   |
| `docs`     | 文档     | `docs(api): 更新配置指南`         |
| `refactor` | 重构     | `refactor(storage): 优化存储格式` |
| `perf`     | 性能优化 | `perf(cache): 实现Redis缓存`      |

**格式**: `<类型>(<范围>): <描述>`

---

## 🔧 开发环境设置（3 步）

```bash
# 1. 安装依赖
pip3 install --break-system-packages firecrawl-py python-dotenv pydantic

# 2. 配置环境
cp env.template .env
# 编辑 .env，填入 4 个 API 密钥

# 3. 测试
python3 test_api_keys.py
```

---

## 📚 必读文档（按顺序）

1. **QUICK_REFERENCE.md** ← 本文件（5分钟）
2. **FIRECRAWL_CLOUD_SETUP_GUIDE.md** ← 快速上手（10分钟）
3. **SETUP_COMPLETE.md** ← 配置完成报告（5分钟）
4. **.cursorrules** ← 完整规范（需要时查阅）
5. **FIRECRAWL_CLOUD_API_RULES.md** ← 深入学习（1小时）

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
python3 test_api_keys.py

# 查看日志
tail -f logs/firecrawl.log

# 运行示例
python3 quick_start.py
```

---

## 🎓 记住这 5 条

1. ✅ **MCP 工具优先**（简单页面也推荐）
2. ✅ **批量处理**（别一个个爬）
3. ✅ **使用缓存**（省钱又快）
4. ✅ **错误处理**（必须 try-except）
5. ✅ **类型注解**（所有函数都要）

---

## 📞 官方资源

- 📚 **文档**: https://docs.firecrawl.dev/
- 💬 **Discord**: https://discord.gg/firecrawl
- 🐙 **GitHub**: https://github.com/mendableai/firecrawl (65K⭐)

---

**💡 提示**: 把这页打印出来，贴在显示器旁边，随时查阅！

---

_最后更新: 2025-10-27_
_适用项目: FireShot + HawaiiHub_
_维护者: HawaiiHub AI Team_
