# ✅ Cursor 配置检查清单

> **用途**: 快速验证 Cursor 配置是否正确  
> **时间**: 5-10 分钟  
> **更新**: 2025-10-27

---

## 🎯 使用说明

复制此清单，逐项检查。所有项目都应该打 ✅ 才能正常使用 Cursor。

---

## 📋 核心配置检查

### 1️⃣ Cursor 编辑器

- [ ] **Cursor 已安装**
  ```bash
  # 检查版本
  打开 Cursor → Cmd+Shift+P → 输入 "About"
  ```
  - ✅ 版本 ≥ 0.40.0

- [ ] **Cursor 已登录**
  - 右上角显示用户头像
  - 或邮箱地址

- [ ] **订阅状态正常**
  - Free / Pro / Business
  - 查看: Settings → Account

---

### 2️⃣ 主配置文件

- [ ] **`.cursorrules` 文件存在**
  ```bash
  ls -lh /Users/zhiledeng/Downloads/FireShot/.cursorrules
  ```
  - ✅ 文件存在
  - ✅ 大小 > 10 KB

- [ ] **`.cursorrules` 内容正确**
  ```bash
  head -20 .cursorrules
  ```
  应该包含:
  - ✅ Firecrawl 规范
  - ✅ Python 规范
  - ✅ 成本控制规范

- [ ] **`.gitignore` 配置正确**
  ```bash
  grep -E "\.env|node_modules|__pycache__" .gitignore
  ```
  - ✅ 包含 `.env`
  - ✅ 包含 `node_modules`
  - ✅ 包含 `__pycache__`

---

### 3️⃣ VSCode/Cursor Settings

- [ ] **settings.json 位置正确**
  ```bash
  ls ~/Library/Application\ Support/Cursor/User/settings.json
  ```

- [ ] **AI 工具自动授权已启用**
  打开 settings.json，检查:
  ```json
  "ai.autoApproveToolCalls": true,
  "ai.autoApproveReadOperations": true,
  "ai.autoApproveBrowserOperations": true,
  ```

- [ ] **Python 配置正确**
  ```json
  "python.defaultInterpreterPath": "/opt/homebrew/bin/python3",
  "ruff.enable": true,
  "python.testing.pytestEnabled": true,
  ```

- [ ] **格式化配置启用**
  ```json
  "[python]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "charliermarsh.ruff"
  }
  ```

---

### 4️⃣ 环境变量

- [ ] **`.env` 文件存在**
  ```bash
  ls -lh .env
  ```

- [ ] **Firecrawl API 密钥配置**
  ```bash
  grep FIRECRAWL_API_KEY .env
  ```
  应该有:
  - ✅ `FIRECRAWL_API_KEY=fc-xxx`
  - ✅ `FIRECRAWL_API_KEY_BACKUP_1=fc-xxx`（可选）

- [ ] **API 密钥有效**
  ```bash
  python3 test_api_keys.py
  ```
  - ✅ 主密钥测试通过
  - ✅ 返回 > 1000 字符

---

### 5️⃣ MCP 服务器

- [ ] **MCP 配置文件存在**
  ```bash
  cat ~/Library/Application\ Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
  ```

- [ ] **Firecrawl MCP 服务器配置**
  应该包含:
  ```json
  {
    "mcpServers": {
      "firecrawl": {
        "command": "npx",
        "args": ["-y", "@mendable/firecrawl-mcp-server"],
        "env": {
          "FIRECRAWL_API_KEY": "fc-xxx"
        }
      }
    }
  }
  ```

- [ ] **MCP 服务器可用**
  在 Cursor Agent 中测试:
  ```markdown
  Cmd+I → 输入: "使用 Firecrawl 爬取 https://example.com"
  ```
  - ✅ Agent 能调用 `mcp_firecrawl_firecrawl_scrape` 工具

---

## 🔍 功能测试

### 6️⃣ 斜杠命令

- [ ] **斜杠命令可用**
  1. 按 `Cmd+I` 打开 Agent
  2. 输入 `/`
  3. 等待 1-2 秒
  - ✅ 显示命令列表

- [ ] **常用命令测试**
  尝试以下命令:
  - [ ] `/generate` - 代码生成
  - [ ] `/refactor` - 代码重构
  - [ ] `/explain` - 代码解释
  - [ ] `/test` - 测试生成

---

### 7️⃣ 符号引用

- [ ] **@ 符号可用**
  ```markdown
  Cmd+I → 输入: @
  ```
  - ✅ 显示代码符号列表（函数、类）

- [ ] **# 符号可用**
  ```markdown
  Cmd+I → 输入: #
  ```
  - ✅ 显示文件列表

- [ ] **代码库索引完成**
  - 查看右下角状态栏
  - ✅ 无 "Indexing..." 提示

---

### 8️⃣ Agent 功能

- [ ] **Agent 响应正常**
  ```markdown
  Cmd+I → 输入: "Hello, 帮我生成一个 Python 函数"
  ```
  - ✅ Agent 返回代码
  - ✅ 使用简体中文回复
  - ✅ 响应时间 < 10 秒

- [ ] **代码差异显示**
  - ✅ 修改建议以颜色区分
  - ✅ 可以逐个接受/拒绝

- [ ] **检查点功能可用**
  - ✅ Agent 自动创建快照
  - ✅ 可以恢复到之前状态

---

### 9️⃣ 行内编辑

- [ ] **行内编辑可用**
  1. 选中任意代码
  2. 按 `Cmd+K`
  3. 输入描述
  - ✅ 显示编辑建议
  - ✅ 可以接受/拒绝

- [ ] **快速提问可用**
  1. 选中代码
  2. 按 `Cmd+K`
  3. 按 `Opt+Return`
  - ✅ 切换到提问模式

---

### 🔟 Tab 自动补全

- [ ] **Tab 补全启用**
  在任意 Python 文件中:
  1. 开始输入代码
  2. 等待 1-2 秒
  - ✅ 显示灰色补全建议
  - ✅ 按 `Tab` 接受建议

- [ ] **多行补全可用**
  - ✅ 可以补全整个函数
  - ✅ 理解上下文

---

## 🎨 扩展和主题

### 1️⃣1️⃣ 必需扩展

- [ ] **Python 扩展已安装**
  ```
  ms-python.python
  ```

- [ ] **Ruff 扩展已安装**
  ```
  charliermarsh.ruff
  ```

- [ ] **Prettier 扩展已安装**（可选）
  ```
  esbenp.prettier-vscode
  ```

### 1️⃣2️⃣ 推荐扩展

- [ ] GitLens
- [ ] Error Lens
- [ ] Path Intellisense
- [ ] Python Test Explorer

---

## 🐍 Python 环境

### 1️⃣3️⃣ Python 版本

- [ ] **Python 版本正确**
  ```bash
  python3 --version
  ```
  - ✅ Python ≥ 3.11

- [ ] **pip 可用**
  ```bash
  pip3 --version
  ```

### 1️⃣4️⃣ Python 包

- [ ] **Firecrawl SDK 已安装**
  ```bash
  pip3 list | grep firecrawl
  ```
  - ✅ `firecrawl-py`

- [ ] **必需包已安装**
  ```bash
  pip3 list | grep -E "pydantic|pytest|ruff"
  ```
  - ✅ pydantic
  - ✅ pytest
  - ✅ ruff

---

## 🔧 性能优化

### 1️⃣5️⃣ 性能设置

- [ ] **代码库索引优化**
  ```json
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/.git/**": true,
    "**/dist/**": true
  }
  ```

- [ ] **AI 响应速度优化**
  ```json
  "cursor.general.enableShadowWorkspace": true,
  "cursor.general.enableAutocompletions": true,
  "editor.quickSuggestionsDelay": 10
  ```

---

## 📊 检查结果

### 完成统计

- **总项目数**: 60+
- **已完成**: _____ / 60+
- **完成率**: _____ %

### 状态判断

- ✅ **90%+**: 配置完美，可以开始使用
- ⚠️ **70-90%**: 基本可用，建议完善
- ❌ **< 70%**: 配置不完整，需要修复

---

## 🚨 常见问题修复

### 问题 1: 斜杠命令不显示

```bash
# 解决方案 1: 重启 Cursor
Cmd+Q → 重新打开

# 解决方案 2: 检查网络
ping api.cursor.com

# 解决方案 3: 重建索引
Cmd+Shift+P → "Rebuild Codebase Index"
```

### 问题 2: MCP 工具不可用

```bash
# 检查 MCP 配置
cat ~/Library/Application\ Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json

# 验证 API 密钥
echo $FIRECRAWL_API_KEY

# 重启 MCP 服务
重启 Cursor
```

### 问题 3: Python 格式化失败

```bash
# 重新安装 Ruff
pip3 install --upgrade ruff

# 检查 Ruff 扩展
Cursor → Extensions → 搜索 "Ruff" → 确保已启用
```

---

## 🎯 下一步

### 配置完成后

1. ✅ 阅读 [斜杠命令指南](./slash-commands.md)
2. ✅ 尝试 3 个工作流示例
3. ✅ 创建第一个 Agent 任务

### 学习资源

- [Cursor 官方文档](https://cursor.com/cn/docs)
- [快速参考卡片](./quick-reference.md)
- [Firecrawl 规范](./firecrawl-rules.md)

---

**提示**: 定期（每周）运行此检查清单，确保配置持续正确 ✅

