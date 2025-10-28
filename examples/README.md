# Firecrawl Python SDK 示例代码

这个目录包含了 Firecrawl Python SDK 的各种实战示例。

---

## 📁 示例列表

### 基础示例

1. **01_basic_scrape.py** - 基础 Scrape 采集
   - 最简单的爬取
   - 多种返回格式
   - 只提取主要内容
   - 使用缓存节省成本
   - 完整配置示例

2. **02_crawl_website.py** - Crawl 深度爬取
   - 简单爬取（阻塞式）
   - 非阻塞爬取（启动后检查）
   - 高级爬取选项（路径过滤、深度控制）
   - 保存爬取结果

3. **03_batch_scrape.py** - Batch Scrape 批量采集
   - 简单批量爬取
   - 批量爬取文档页面
   - 智能批量处理（分批 + 错误处理）
   - 统计分析

---

## 🚀 快速开始

### 前置条件

1. **安装依赖**：
```bash
pip install firecrawl-py python-dotenv
```

2. **配置环境变量**：
```bash
# 复制模板
cp env.template .env

# 编辑 .env 文件，填入你的 API 密钥
FIRECRAWL_API_KEY=fc-YOUR-API-KEY
```

### 运行示例

```bash
# 基础 Scrape 示例
python3 examples/01_basic_scrape.py

# Crawl 爬取示例
python3 examples/02_crawl_website.py

# Batch Scrape 批量采集示例
python3 examples/03_batch_scrape.py
```

---

## 📊 示例输出

### 01_basic_scrape.py

```
============================================================
  Firecrawl SDK - 基础 Scrape 示例
============================================================

📝 示例 1: 最简单的爬取
------------------------------------------------------------
✅ 爬取成功
📊 内容长度: 15234 字符
🔗 源 URL: https://firecrawl.dev
📰 标题: Firecrawl - Turn websites into LLM-ready data

内容预览:
# Firecrawl

Turn websites into LLM-ready data
...

📝 示例 2: 多种返回格式
------------------------------------------------------------
✅ 爬取成功
📊 Markdown: 15234 字符
📊 HTML: 45678 字符
📊 链接数: 42

🔗 前 5 个链接:
  1. https://firecrawl.dev/pricing
  2. https://firecrawl.dev/docs
  3. https://firecrawl.dev/blog
  ...
```

### 02_crawl_website.py

```
============================================================
  Firecrawl SDK - Crawl 深度爬取示例
============================================================

📝 示例 1: 简单爬取（限制5个页面）
------------------------------------------------------------
✅ 爬取完成
📊 状态: completed
📄 页面数: 5/5

🔗 爬取的页面:
  1. https://docs.firecrawl.dev/introduction
     标题: Introduction | Firecrawl
     内容: 8234 字符
  2. https://docs.firecrawl.dev/features/scrape
     标题: Scrape | Firecrawl
     内容: 6543 字符
  ...
```

### 03_batch_scrape.py

```
============================================================
  Firecrawl SDK - Batch Scrape 批量采集示例
============================================================

📝 示例 1: 批量爬取多个页面
------------------------------------------------------------
🔗 待爬取 URL (3 个):
  1. https://firecrawl.dev
  2. https://docs.firecrawl.dev
  3. https://docs.firecrawl.dev/introduction

⏳ 开始批量爬取...

✅ 批量爬取完成
📊 状态: completed
📄 完成: 3/3

📋 结果:

  1. https://firecrawl.dev
     标题: Firecrawl - Turn websites into LLM-ready data
     内容: 15234 字符
  ...
```

---

## 🎯 学习路径

### 新手入门

1. **阅读完整指南**: `Firecrawl学习手册/03-API参考/08-Python-SDK完整指南.md`
2. **运行基础示例**: `01_basic_scrape.py`
3. **理解核心概念**: Scrape、Crawl、Batch Scrape 的区别

### 进阶学习

4. **深度爬取**: `02_crawl_website.py`
5. **批量处理**: `03_batch_scrape.py`
6. **错误处理**: 学习如何处理各种异常
7. **性能优化**: 缓存、分批、成本控制

### 实战应用

8. **HawaiiHub 新闻采集**: 参考学习手册中的实战案例
9. **竞品监控**: 监控竞品网站变更
10. **数据分析**: 处理和分析采集的数据

---

## 💡 提示

### 成本控制

- **使用缓存**: 设置 `max_age=172800000`（2天）可节省 50%+ 成本
- **批量处理**: 使用 `batch_scrape` 比逐个 `scrape` 更高效
- **限制数量**: 设置合理的 `limit` 参数
- **监控使用量**: 定期检查 API 使用情况

### 性能优化

- **并发控制**: 使用 `max_concurrency` 参数
- **延迟设置**: 使用 `delay` 避免速率限制
- **路径过滤**: 使用 `include_paths` 和 `exclude_paths` 精准爬取
- **只提取主要内容**: 设置 `only_main_content=True`

### 错误处理

- **重试机制**: 实现指数退避重试
- **超时控制**: 设置合理的 `timeout` 参数
- **日志记录**: 记录所有错误和异常
- **降级策略**: 批量失败时逐个重试

---

## 📚 参考资源

- **官方文档**: https://docs.firecrawl.dev/sdks/python
- **学习手册**: `Firecrawl学习手册/03-API参考/08-Python-SDK完整指南.md`
- **快速参考**: `QUICK_REFERENCE.md`
- **配置总结**: `SDK_CONFIGURATION_COMPLETE.md`

---

## 🆘 获取帮助

遇到问题？

1. **查看完整指南**: `Firecrawl学习手册/03-API参考/08-Python-SDK完整指南.md`
2. **检查环境配置**: 运行 `python3 test_api_keys.py`
3. **查看日志**: `logs/firecrawl.log`
4. **官方资源**:
   - Discord: https://discord.gg/gSmWdAkdwd
   - GitHub: https://github.com/mendableai/firecrawl
   - 文档: https://docs.firecrawl.dev/

---

**维护者**: HawaiiHub AI Team
**版本**: v1.0.0
**最后更新**: 2025-10-28
