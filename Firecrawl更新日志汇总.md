# Firecrawl 更新日志汇总

> **来源**: https://www.firecrawl.dev/changelog
> **整理时间**: 2025-10-27
> **版本跨度**: v1.0.0 (2024-08) → v2.4.0 (2025-10)

---

## 📊 版本演进时间线

```
v1.0.0 (2024-08-29) → v1.15.0 (2025-07-18) → v2.0.0 (2025-08-19) → v2.4.0 (2025-10-13)
    └─ 首个稳定版          └─ v1 最终版      └─ 重大升级         └─ 最新版本
```

---

## 🔥 重大版本更新

### v2.4.0 (2025-10-13) - 最新版本

**新功能**:

- **PDF 搜索分类**: 通过 `categories=["pdf"]` 专门搜索 PDF 文档
- **10倍语义爬取改进**: 使用 prompt 参数时准确性和相关性大幅提升
- **x402 搜索端点**: 通过 Coinbase x402 集成访问搜索 API
- **增强爬取状态**: robots.txt 限制和低结果场景的实时反馈
- **20+ 自部署改进**: 稳定性和功能大幅升级

### v2.3.0 (2025-09-19)

**新功能**:

- **YouTube 转录支持**: 直接提取 YouTube 视频字幕
- **ODT & RTF 解析**: 新增文档格式支持
- **Docx 解析提速 50倍**: 性能大幅优化
- **企业自动充值**: 企业客户自动充值功能

### v2.2.0 (2025-09-12)

**新功能**:

- **MCP v3**: HTTP Transport 和 SSE 模式稳定支持
- **Webhooks 增强**: 签名 + extract 支持 + 事件失败处理
- **Map 提速 15倍**: 支持更多 URL
- **新增地理位置**: CA、CZ、IL、IN、IT、PL、PT
- **API 密钥用量追踪**: 按密钥跟踪使用情况

### v2.1.0 (2025-08-29)

**新功能**:

- **搜索分类**:
  - `categories=["github"]` - GitHub 仓库、代码、Issues、文档
  - `categories=["research"]` - 学术网站（arXiv、Nature、IEEE、PubMed）
- **图片提取**: v2 scrape 端点支持图片提取
- **Data 属性爬取**: 支持提取 `data-*` 属性
- **Hash 路由**: Crawl 端点处理基于 hash 的路由
- **Google Drive 增强**: 支持 TXT、PDF、Sheets
- **Map 支持 100k 结果**: 大幅提升限制

### v2.0.0 (2025-08-19) - 重大升级

**核心改进**:

- **默认更快**: 缓存默认 2 天，默认启用 blockAds、skipTlsVerification、removeBase64Images
- **Summary 格式**: 新增 `formats=["summary"]` 直接获取页面摘要
- **JSON 提取更新**: 使用对象格式，旧的 "extract" 改名为 "json"
- **增强截图选项**: 使用对象形式
- **新搜索源**: 支持 "news" 和 "images" 搜索
- **智能爬取**: 传入自然语言 prompt，系统自动推导路径/限制

**重大变化**:

- 🔴 **命名约定**: 驼峰式 → 下划线式（`onlyMainContent` → `only_main_content`）
- 🔴 **返回类型**: 字典 → Document 对象（`result["markdown"]` → `result.markdown`）

---

### v1.15.0 (2025-07-18) - v1 最终版

- **SSO**: 企业级单点登录
- **FireGEO**: 开源地理数据示例
- 50+ PR 合并的 bug 修复和改进

### v1.14.0 (2025-07-04)

- **认证爬取**: 支持需要登录的网站（等待列表）
- **零数据保留**: 企业级数据隐私
- **MCP 改进**: maxAge + 更好的工具调用
- **Open Researcher**: 开源研究工具示例

### v1.13.0 (2025-06-27)

- **Stealth Mode 扩展**: 新增 AU、FR、DE 地区
- **子域名爬取**: `allowSubdomains` 参数
- **Google Slides 爬取**: 官方支持
- **PDF 生成**: 生成当前页面的 PDF
- **Fireplexity**: 开源 Perplexity 示例

### v1.12.0 (2025-06-20)

- **并发控制**: 请求级别的 max concurrency
- **整站爬取**: `crawlEntireDomain` 参数
- **Google Docs**: 官方支持
- **Firestarter**: 开源聊天机器人平台示例

### v1.11.0 (2025-06-13)

- **Firecrawl Index**: 选择性开启后速度提升 500%
- **增强活动日志**: Webhook 事件 + 活跃爬取管理
- **Fire Enrich**: 开源 Clay 集成
- **Java SDK**: 社区 SDK 支持

### v1.9.0 (2025-05-16)

- **自部署改进**: Supabase 修复 + LLM 提供商支持
- **MCP 改进**: 提示、示例和参数使用优化
- **Change Tracking**: SDK 2.0 新增变更追踪
- **Map 限制提升**: 5,000 → 30,000 链接

### v1.6.0 (2025-03-07) - 关键里程碑

- **LLMs.txt API**: 将网站转换为 LLM-ready 文本
- **Deep Research API**: AI 驱动的深度研究（Alpha）
- **官方 MCP Server**: Cursor/Windsurf/Claude 集成

### v1.2.0 (2025-01-03)

- **Search API**: 搜索 + 爬取一体化
- MinerU PDF 解析成为默认

### v1.1.0 (2024-12-27)

- 地理位置 + 移动爬取
- 批量爬取支持
- 4倍解析速度提升

### v1.0.0 (2024-08-29) - 首个稳定版

- 输出格式选择
- Map 端点
- 2倍速率限制
- Go SDK + Rust SDK
- 团队支持
- API 密钥管理

---

## 🆕 v2 新功能亮点

### 1. 搜索分类系统

```python
# GitHub 搜索
results = app.search(
    query="firecrawl python",
    categories=["github"]
)

# 学术搜索
results = app.search(
    query="AI machine learning",
    categories=["research"]
)

# PDF 搜索（v2.4.0 新增）
results = app.search(
    query="研究报告",
    categories=["pdf"]
)
```

### 2. 智能提示爬取

```python
# 传入自然语言描述
results = app.crawl(
    url="https://example.com",
    prompt="找到所有产品页面并提取价格信息"
)
```

### 3. Summary 格式

```python
# 直接获取摘要
result = app.scrape(
    url="https://long-article.com",
    formats=["summary"]
)
print(result.summary)
```

### 4. YouTube 转录

```python
# 提取视频字幕（v2.3.0）
result = app.scrape(
    url="https://www.youtube.com/watch?v=xxx",
    formats=["markdown"]
)
```

---

## 📈 性能优化历程

| 版本    | 优化项          | 提升幅度      |
| ------- | --------------- | ------------- |
| v1.11.0 | Firecrawl Index | 500% 速度提升 |
| v2.2.0  | Map 速度        | 15倍提升      |
| v2.3.0  | Docx 解析       | 50倍提升      |
| v2.4.0  | 语义爬取        | 10倍准确性    |
| v1.1.0  | 解析速度        | 4倍提升       |

---

## 🔄 SDK 版本对比

### v1 vs v2 语法变化

| 功能       | v1 语法                       | v2 语法                  |
| ---------- | ----------------------------- | ------------------------ |
| 参数命名   | `onlyMainContent=True`        | `only_main_content=True` |
| 缓存设置   | `maxAge=3600000`              | `max_age=3600000`        |
| 返回值访问 | `result["markdown"]`          | `result.markdown`        |
| 元数据访问 | `result["metadata"]["title"]` | `result.metadata.title`  |

---

## 🛠️ 关键集成

### MCP Server

- **v1.6.0** (2025-03-07): 首次官方支持
- **v1.14.0** (2025-07-04): maxAge + 工具调用改进
- **v2.2.0** (2025-09-12): v3 稳定版（HTTP + SSE）

### 开源示例项目

- **FireGEO** (v1.15.0): 地理数据处理
- **Open Researcher** (v1.14.0): 研究助手
- **Fireplexity** (v1.13.0): Perplexity 克隆
- **Firestarter** (v1.12.0): 聊天机器人平台
- **Fire Enrich** (v1.11.0): 数据增强工具

---

## 📚 文档资源

- **官方文档**: https://docs.firecrawl.dev/
- **更新日志**: https://www.firecrawl.dev/changelog
- **GitHub**: https://github.com/firecrawl/firecrawl
- **Discord**: https://discord.gg/firecrawl

---

## ⚠️ 迁移建议

### 从 v1 迁移到 v2

1. **参数重命名** (全局替换)

   ```bash
   # 批量替换
   onlyMainContent → only_main_content
   maxAge → max_age
   blockAds → block_ads
   skipTlsVerification → skip_tls_verification
   ```

2. **返回值访问** (代码重构)

   ```python
   # 旧代码
   content = result.get("markdown")
   title = result.get("metadata", {}).get("title")

   # 新代码
   content = result.markdown
   title = result.metadata.title
   ```

3. **测试验证**
   ```bash
   python3 setup_sdk.py  # 验证 SDK v2
   python3 test_api_keys.py  # 测试 API
   python3 quick_start.py  # 运行示例
   ```

---

**最后更新**: 2025-10-27
**整理人**: HawaiiHub AI Team
**数据来源**: Firecrawl 官方 Changelog
