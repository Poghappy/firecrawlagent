# 🤝 贡献指南

感谢您对 FireShot 项目的兴趣！我们欢迎所有形式的贡献。

## 📋 目录

- [行为准则](#行为准则)
- [如何贡献](#如何贡献)
- [开发流程](#开发流程)
- [代码规范](#代码规范)
- [提交规范](#提交规范)
- [测试要求](#测试要求)

---

## 行为准则

参与本项目即表示您同意遵守我们的[行为准则](CODE_OF_CONDUCT.md)。

---

## 如何贡献

### 报告 Bug

在提交 Bug 报告前，请：

1. **检查现有 Issues**: 确保问题尚未被报告
2. **使用最新版本**: 确认问题在最新版本中仍然存在
3. **提供详细信息**: 包含复现步骤、预期行为、实际行为

Bug 报告应包含：

```markdown
**环境信息**:
- OS: [e.g., macOS 14.0]
- Python 版本: [e.g., 3.11.5]
- Firecrawl SDK 版本: [e.g., 2.4.0]

**复现步骤**:
1. ...
2. ...

**预期行为**:
...

**实际行为**:
...

**错误日志**:
```
...
```
```

### 提出新功能

功能建议应包含：

- **使用场景**: 描述为什么需要这个功能
- **具体需求**: 详细说明功能的行为
- **替代方案**: 您考虑过的其他实现方式

### 提交 Pull Request

1. **Fork 本仓库**
2. **创建功能分支**: `git checkout -b feature/amazing-feature`
3. **提交更改**: `git commit -m 'feat: 添加某某功能'`
4. **推送到分支**: `git push origin feature/amazing-feature`
5. **创建 Pull Request**

---

## 开发流程

### 1. 设置开发环境

```bash
# 克隆项目
git clone https://github.com/Poghappy/firecrawlagent.git
cd firecrawlagent

# 安装 Python 依赖
pip3 install -r requirements.txt

# 安装开发依赖
pip3 install ruff mypy pytest pytest-cov

# 配置环境变量
cp env.template .env
# 编辑 .env 文件，填入测试 API 密钥
```

### 2. 运行测试

```bash
# 运行所有测试
pytest

# 运行测试并生成覆盖率报告
pytest --cov=src --cov-report=html

# 查看覆盖率报告
open htmlcov/index.html
```

### 3. 代码检查

```bash
# Ruff 格式化
ruff format .

# Ruff Linting
ruff check .

# 类型检查
mypy src/
```

---

## 代码规范

### Python 代码规范

项目遵循 [.cursorrules](.cursorrules) 中定义的规范：

#### 1. 类型注解（强制）

```python
# ✅ 正确
def scrape_page(url: str, timeout: int = 60) -> Optional[Dict[str, str]]:
    """爬取网页内容"""
    # ... 实现
    return {"markdown": content}

# ❌ 错误：缺少类型注解
def scrape_page(url, timeout=60):
    return {"markdown": content}
```

#### 2. 文档字符串（强制，中文）

```python
# ✅ 正确
def analyze_articles(articles: List[Dict]) -> Dict[str, int]:
    """
    分析文章数据统计信息

    Args:
        articles: 文章列表，每个文章包含 title、author、date 等字段

    Returns:
        统计结果字典，包含：
        - total_articles: 总文章数
        - authors: 作者统计
        - keywords: 关键词统计

    Example:
        >>> articles = [{"title": "测试", "author": "张三"}]
        >>> stats = analyze_articles(articles)
        >>> print(stats["total_articles"])
        1
    """
    # ... 实现
```

#### 3. 代码风格

- 使用**双引号**（不是单引号）
- 每行最多 88 字符
- 使用 Ruff 自动格式化

#### 4. 导入顺序

```python
# 标准库
import json
import re
from datetime import datetime

# 第三方库
from firecrawl import FirecrawlApp
from dotenv import load_dotenv

# 本地模块
from .utils import parse_date
from .config import FIRECRAWL_API_KEY
```

#### 5. 错误处理

```python
# ✅ 必须有错误处理
def safe_scrape(url: str, max_retries: int = 3) -> Optional[dict]:
    """安全爬取，带重试机制"""
    for attempt in range(max_retries):
        try:
            result = app.scrape(url)
            return result
        except RequestTimeoutError as e:
            if attempt < max_retries - 1:
                time.sleep(2 ** attempt)  # 指数退避
            else:
                logging.error(f"失败: {url} - {e}")
                return None
        except Exception as e:
            logging.error(f"未知错误: {url} - {e}")
            return None
```

### Firecrawl 使用规范

```python
# ✅ 优先使用 MCP 工具（Cursor AI）
# 在 Cursor 中直接调用 mcp_firecrawl_firecrawl_scrape

# ✅ Python SDK v2 正确写法
result = app.scrape(
    url="https://example.com",
    formats=["markdown"],
    only_main_content=True,  # ✅ 下划线命名
    max_age=172800000  # ✅ 使用缓存
)

# 访问结果
content = result.markdown  # ✅ 属性访问

# ❌ 错误：驼峰命名（v1 旧版本）
result = app.scrape(
    url="https://example.com",
    onlyMainContent=True  # ❌ 会报错
)
```

---

## 提交规范

### Conventional Commits（强制）

使用 [Conventional Commits](https://www.conventionalcommits.org/) 格式：

```
<类型>(<范围>): <描述>

[可选的正文]

[可选的脚注]
```

#### 类型清单

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `refactor`: 代码重构（不改变功能）
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建/工具链
- `style`: 代码格式（不影响功能）

#### 示例

```bash
# ✅ 正确
git commit -m "feat(scraper): 添加 Firecrawl MCP 工具支持"
git commit -m "fix(parser): 修复文章日期解析错误"
git commit -m "docs(api): 更新 API 密钥配置指南"
git commit -m "perf(cache): 实现 Redis 缓存，节省 50% 成本"

# ❌ 错误
git commit -m "更新代码"
git commit -m "fix bug"
```

---

## 测试要求

### 测试覆盖率

- 所有新功能必须有对应的测试
- 测试覆盖率必须 ≥ 80%
- 关键路径测试覆盖率必须 = 100%

### 测试文件命名

```
tests/
├── __init__.py
├── test_scraper.py      # 测试 scraper.py
├── test_parser.py       # 测试 parser.py
└── test_storage.py      # 测试 storage.py
```

### 测试示例

```python
import pytest
from unittest.mock import Mock, patch

def test_scrape_success():
    """测试：成功爬取文章"""
    # Arrange
    mock_result = Mock()
    mock_result.markdown = "# 测试文章"

    # Act
    with patch("firecrawl.FirecrawlApp.scrape", return_value=mock_result):
        result = scrape_news("https://test.com")

    # Assert
    assert result is not None
    assert "markdown" in result
    assert result["markdown"] == "# 测试文章"


def test_scrape_timeout():
    """测试：超时重试机制"""
    with patch("firecrawl.FirecrawlApp.scrape", side_effect=RequestTimeoutError):
        result = safe_scrape("https://test.com", max_retries=2)

    assert result is None
```

---

## 文档更新

### 文档规则

根据 [.cursor/rules/02-documentation-control.mdc](.cursor/rules/02-documentation-control.mdc)：

#### 根目录文档限制（最多 5 个）

1. README.md - 项目说明
2. CHANGELOG.md - 变更日志
3. AGENTS.md - AI 助手规范
4. CONTRIBUTING.md - 贡献指南（本文件）
5. LICENSE - 许可证

#### 其他文档必须放在子目录

- `.cursor/` - Cursor 配置和规范
- `docs/` - 项目文档
- `openspec/` - OpenSpec 规范
- `Firecrawl学习手册/` - 学习资料

#### 更新优先级

1. **P0**: 更新 `CHANGELOG.md`
2. **P1**: 更新 `README.md` 对应章节
3. **P2**: 添加日志到 `.cursor/logs/development/`
4. **P3**: 创建 `docs/` 下的专题文档（仅当必要）

---

## Pull Request 清单

提交 PR 前请确认：

- [ ] 代码已通过所有测试
- [ ] 代码已通过 Ruff 检查
- [ ] 代码已通过 mypy 类型检查
- [ ] 添加了必要的测试
- [ ] 测试覆盖率 ≥ 80%
- [ ] 更新了相关文档
- [ ] 使用 Conventional Commits 格式
- [ ] 更新了 CHANGELOG.md
- [ ] PR 描述清晰，包含测试证据

---

## 代码审查

### 审查重点

1. **功能正确性**: 代码是否实现了预期功能
2. **代码质量**: 是否遵循代码规范
3. **测试充分性**: 测试是否覆盖关键路径
4. **性能影响**: 是否引入性能问题
5. **安全性**: 是否存在安全隐患

### 审查流程

1. **自动检查**: GitHub Actions 自动运行测试和检查
2. **人工审查**: 至少 1 位维护者审查
3. **讨论**: 通过评论讨论问题
4. **修改**: 根据反馈修改代码
5. **合并**: 审查通过后合并

---

## 获取帮助

### 资源

- **文档**: [Firecrawl学习手册/](./Firecrawl学习手册/)
- **Discord**: [加入讨论](https://discord.gg/firecrawl)
- **Issue 追踪**: [GitHub Issues](https://github.com/Poghappy/firecrawlagent/issues)

### 联系方式

- 提问: 在 GitHub Issues 中创建问题
- 讨论: 在 GitHub Discussions 中讨论
- 紧急问题: 联系项目维护者

---

## 感谢

感谢每一位贡献者！您的贡献让 FireShot 变得更好。

### 贡献者

<!-- ALL-CONTRIBUTORS-LIST:START -->
<!-- 贡献者列表将自动生成 -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

---

## 许可证

通过贡献代码，您同意在 [MIT License](LICENSE) 下发布您的贡献。

---

**维护者**: HawaiiHub AI Team
**最后更新**: 2025-10-28

Made with ❤️ by contributors
