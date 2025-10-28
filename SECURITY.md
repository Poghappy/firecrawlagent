# 安全政策

## 🔒 安全承诺

FireShot 项目团队非常重视安全问题。我们感谢安全研究人员和用户帮助我们保持项目的安全性。

## 🛡️ 支持的版本

我们目前为以下版本提供安全更新：

| 版本   | 支持状态           |
| ------ | ------------------ |
| 1.0.x  | ✅ 完全支持        |
| < 1.0  | ❌ 不再支持        |

## 🚨 报告安全漏洞

### 请勿公开披露

如果您发现了安全漏洞，**请勿**通过公开的 GitHub Issues 报告。

### 私密报告流程

1. **通过 GitHub Security Advisories 报告**（推荐）
   - 访问仓库的 "Security" 标签
   - 点击 "Report a vulnerability"
   - 填写详细信息

2. **通过电子邮件报告**（备选）
   - 发送到：security@hawaiihub.net
   - 标题：`[SECURITY] FireShot - [简要描述]`

### 报告应包含

请在报告中包含以下信息：

- **漏洞类型**: 例如 XSS、SQL 注入、信息泄露等
- **完整路径**: 受影响的源文件
- **漏洞位置**: 相关的代码片段或行号
- **复现步骤**: 详细的复现步骤
- **影响范围**: 漏洞可能造成的影响
- **建议修复**: 如果有修复建议
- **POC**: 概念验证代码（如果有）

### 报告示例

```markdown
**漏洞类型**: API 密钥泄露

**受影响文件**: `src/config.ts`

**漏洞描述**:
在 config.ts 中硬编码了 API 密钥，存在泄露风险。

**复现步骤**:
1. 检查 src/config.ts 文件
2. 发现第 10 行有硬编码的 API 密钥

**影响范围**:
攻击者可以获取 API 密钥并滥用服务。

**建议修复**:
使用环境变量管理 API 密钥，并添加到 .gitignore。
```

## ⏱️ 响应时间

- **首次响应**: 48 小时内
- **初步评估**: 5 个工作日内
- **修复时间**: 根据严重程度，7-30 天

## 🔐 安全最佳实践

### API 密钥管理

❌ **禁止**：硬编码 API 密钥

```python
# ❌ 永远不要这样做
FIRECRAWL_API_KEY = "fc-xxxx"
```

✅ **正确**：使用环境变量

```python
# ✅ 使用环境变量
import os
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("FIRECRAWL_API_KEY")
```

### 环境变量安全

1. **使用 .env 文件**

```bash
# .env（不提交到 Git）
FIRECRAWL_API_KEY=fc-xxxx
FIRECRAWL_API_KEY_BACKUP_1=fc-xxxx
```

2. **添加到 .gitignore**

```gitignore
# 环境变量
.env
.env.local
.env.*.local
```

3. **提供模板文件**

```bash
# env.template（可以提交）
FIRECRAWL_API_KEY=your_api_key_here
FIRECRAWL_API_KEY_BACKUP_1=your_backup_key_here
```

### 依赖安全

1. **定期更新依赖**

```bash
# 检查过期依赖
pip list --outdated

# 更新依赖
pip install --upgrade firecrawl-py
```

2. **审计依赖**

```bash
# Python 依赖审计
pip-audit

# Node.js 依赖审计
npm audit
```

### 代码安全

1. **输入验证**

```python
def scrape_url(url: str) -> dict:
    """爬取 URL，带输入验证"""
    # 验证 URL 格式
    if not url.startswith(("http://", "https://")):
        raise ValueError("无效的 URL 格式")

    # 验证 URL 长度
    if len(url) > 2048:
        raise ValueError("URL 过长")

    return app.scrape(url)
```

2. **错误处理**

```python
try:
    result = app.scrape(url)
except Exception as e:
    # 不要暴露敏感信息
    logging.error("爬取失败")  # ✅ 安全
    # logging.error(f"API Key: {api_key}")  # ❌ 危险
```

3. **日志安全**

```python
# ✅ 安全：不记录敏感信息
logging.info(f"爬取 URL: {url}")

# ❌ 危险：记录了 API 密钥
logging.info(f"使用密钥 {api_key} 爬取 {url}")
```

## 🔍 已知安全问题

### 已修复

| 日期       | 问题                | 严重程度 | 修复版本 |
| ---------- | ------------------- | -------- | -------- |
| 2025-10-28 | API 密钥硬编码      | 高       | 1.0.0    |

### 正在处理

目前没有已知的安全问题。

## 🏆 致谢

我们感谢以下安全研究人员的贡献：

<!-- 安全贡献者列表 -->
- （待添加）

## 📚 安全资源

### 内部文档

- [API 密钥管理指南](./docs/cursor-guides/api-key-management.md)
- [安全编码规范](./.cursorrules)
- [环境配置指南](./docs/setup/SETUP_COMPLETE.md)

### 外部资源

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [Python Security](https://python.readthedocs.io/en/latest/library/security_warnings.html)

## 📞 联系方式

- **安全问题**: security@hawaiihub.net
- **一般问题**: 通过 [GitHub Issues](https://github.com/Poghappy/firecrawlagent/issues)
- **Discord**: [加入讨论](https://discord.gg/firecrawl)

## 📝 免责声明

本安全政策可能会不时更新。建议定期查看此页面以了解最新的安全政策。

---

**维护者**: HawaiiHub AI Team
**最后更新**: 2025-10-28

🔒 安全是我们的首要任务！
