# Cursor 自动授权配置指南

> 🎯 **目标**：让 AI 助手自动执行安全操作，无需手动点击 "run"

---

## 📋 配置概览

已为项目配置自动授权，配置文件：`.cursor/settings.json`

### ✅ 自动批准的操作（安全）

以下操作会自动执行，无需确认：

#### 🔍 读取和搜索

- `read_file` - 读取文件
- `grep` - 文件内容搜索
- `codebase_search` - 代码库语义搜索
- `list_dir` - 列出目录内容
- `glob_file_search` - 文件名模式搜索

#### 🌐 浏览器操作

- `browser_navigate` - 导航到 URL
- `browser_snapshot` - 页面快照
- `browser_click` - 点击元素
- `browser_type` - 输入文本
- `browser_screenshot` - 截图

### ⚠️ 需要手动确认的操作（危险）

以下操作仍需手动批准，保护生产环境：

- `delete_file` - 删除文件
- `run_terminal_cmd` - 执行终端命令
- `search_replace` - 修改文件内容
- `write` - 创建/覆盖文件

---

## 🚀 快速启用

### 方法 1：工作区配置（已完成）✅

配置文件已创建：`.cursor/settings.json`

**重启 Cursor IDE** 以使配置生效：

```bash
# macOS
Cmd + Q (退出) → 重新打开 Cursor

# 或重新加载窗口
Cmd + Shift + P → "Developer: Reload Window"
```

### 方法 2：全局设置（可选）

在 Cursor 设置中启用：

1. 打开设置：`Cmd + ,` (macOS) 或 `Ctrl + ,` (Windows)
2. 搜索 "auto approve"
3. 启用以下选项：
   - ✅ Auto-approve tool calls
   - ✅ Auto-approve read operations
   - ✅ Auto-approve browser operations

---

## 🔧 配置详解

### 基础配置

```json
{
  // 自动批准所有工具调用（读取类）
  "ai.autoApproveToolCalls": true,

  // 自动批准读取操作
  "ai.autoApproveReadOperations": true,

  // 自动批准浏览器操作
  "ai.autoApproveBrowserOperations": true,

  // 自动批准文件操作（读取）
  "ai.autoApproveFileOperations": true,

  // 自动批准搜索操作
  "ai.autoApproveSearchOperations": true
}
```

### 工具级别配置

```json
{
  "ai.toolCallApproval": {
    // 浏览器工具
    "browser_navigate": "auto",
    "browser_snapshot": "auto",
    "browser_click": "auto",
    "browser_type": "auto",
    "browser_screenshot": "auto",

    // 文件读取工具
    "read_file": "auto",
    "grep": "auto",
    "codebase_search": "auto",
    "list_dir": "auto",
    "glob_file_search": "auto"
  }
}
```

### 安全保护

```json
{
  // 危险操作仍需手动确认
  "ai.dangerousOperationsRequireApproval": true,

  // 定义危险操作列表
  "ai.dangerousOperations": [
    "delete_file", // 删除文件
    "run_terminal_cmd", // 执行命令
    "search_replace", // 修改代码
    "write" // 写入文件
  ]
}
```

---

## 🧪 测试配置

重启 Cursor 后，测试自动授权是否生效：

### 测试 1：浏览器操作

```
提示词："打开 hawaiihub.net 并截图"
预期：自动执行，无需点击 run
```

### 测试 2：文件读取

```
提示词："读取 README.md 文件"
预期：自动执行，无需点击 run
```

### 测试 3：代码搜索

```
提示词："搜索项目中的 'hawaiihub' 关键词"
预期：自动执行，无需点击 run
```

### 测试 4：文件修改（应该需要确认）

```
提示词："修改 package.json 文件"
预期：仍需手动点击 run（安全保护）
```

---

## 🎯 HawaiiHub 项目最佳实践

### 推荐配置策略

根据项目的"自动化第一"原则：

#### ✅ 自动批准（高频安全操作）

- 所有 MCP 工具调用（Time、Steel Browser、NewsAPI、Firecrawl）
- 浏览器自动化（内容采集、信息审核）
- 文件读取和搜索（代码审查、日志分析）

#### ⚠️ 手动确认（关键业务操作）

- 生产环境部署（遵循 99-deployment-safety.mdc）
- 数据库操作（用户数据、内容数据）
- 文件删除和覆盖
- 系统级命令执行

### 工作流示例

**场景 1：新闻采集任务**

```
用户："采集 10 条夏威夷本地新闻"
AI：自动执行
  1. 调用 NewsAPI 搜索（自动）
  2. 调用 Firecrawl 采集（自动）
  3. 分析内容质量（自动）
  4. 生成 Markdown 报告（需确认）
```

**场景 2：内容审核任务**

```
用户："审核待发布的分类信息"
AI：自动执行
  1. 打开后台管理页面（自动）
  2. 抓取待审核列表（自动）
  3. 分析内容合规性（自动）
  4. 提交审核结果（需确认）
```

---

## 🔍 故障排查

### 问题 1：配置未生效

**解决方案**：

```bash
# 1. 确认配置文件存在
cat .cursor/settings.json

# 2. 重启 Cursor IDE
Cmd + Q → 重新打开

# 3. 重新加载窗口
Cmd + Shift + P → "Developer: Reload Window"
```

### 问题 2：仍需手动确认某些操作

**检查清单**：

- [ ] 配置文件格式正确（有效的 JSON）
- [ ] Cursor 已重启
- [ ] 操作确实在 "auto" 列表中
- [ ] 全局设置未覆盖工作区设置

### 问题 3：危险操作被自动执行

**立即处理**：

```json
{
  "ai.dangerousOperationsRequireApproval": true,
  "ai.dangerousOperations": ["delete_file", "run_terminal_cmd", "search_replace", "write"]
}
```

确保 `dangerousOperationsRequireApproval` 为 `true`

---

## 📚 相关文档

- [Cursor 官方文档](https://cursor.sh/docs)
- [99-deployment-safety.mdc](mdc:.cursor/rules/99-deployment-safety.mdc) - 生产部署安全协议
- [00-hawaiihub-core.mdc](mdc:.cursor/rules/00-hawaiihub-core.mdc) - 项目核心规范

---

## 📝 版本历史

- **v1.0.0** (2025-10-27) - 初始配置
  - 自动批准：浏览器操作、文件读取、代码搜索
  - 手动确认：文件修改、命令执行、文件删除

---

**配置状态**：✅ 已完成
**生效方式**：重启 Cursor IDE
**安全级别**：高（危险操作仍需确认）
**最后更新**：2025-10-27
