# HawaiiHub Cursor 规则目录

## 📚 规则文件列表

### 核心规则（3 个）

| 文件 | 优先级 | 说明 | 适用文件 |
|-----|-------|------|---------|
| [00-hawaiihub-core.mdc](mdc:00-hawaiihub-core.mdc) | 1000 | 核心规范 - 角色定义、MCP 工具、标准任务 | 所有文件 |
| [01-code-standards.mdc](mdc:01-code-standards.mdc) | 800 | 代码质量规范 - JavaScript/Markdown 标准 | `*.js, *.ts, *.md, *.json` |
| [99-deployment-safety.mdc](mdc:99-deployment-safety.mdc) | 2000 | 生产部署安全协议（最高优先级） | 所有文件 |

---

## 🎯 规则说明

### 规则文件格式

所有规则文件使用 Cursor 官方的 `.mdc` 格式，包含：

**Frontmatter（元数据）**:

```yaml
---
description: "规则描述"
globs: "**/*"           # 适用文件模式
priority: 1000          # 优先级（数字越大越优先）
---
```

**规则内容**:

- Markdown 格式
- 简体中文编写
- 清晰的章节结构

### 优先级说明

- **2000**: 安全规范（最高优先级，始终优先）
- **1000**: 核心规范（项目基础规则）
- **800**: 代码质量（文件类型匹配时应用）

---

## 📖 快速导航

### 我是谁？

查阅：[00-hawaiihub-core.mdc](mdc:00-hawaiihub-core.mdc) - "你是谁" 章节

### 如何使用 MCP 工具？

查阅：[00-hawaiihub-core.mdc](mdc:00-hawaiihub-core.mdc) - "核心 MCP 工具" 章节

### 如何执行标准任务？

查阅：[00-hawaiihub-core.mdc](mdc:00-hawaiihub-core.mdc) - "标准任务流程" 章节

### 代码规范是什么？

查阅：[01-code-standards.mdc](mdc:01-code-standards.mdc)

### 生产部署需要注意什么？

查阅：[99-deployment-safety.mdc](mdc:99-deployment-safety.mdc)

---

## ✨ 规则特性

### 1. 简洁高效

- 只有 3 个核心规则文件
- 每个规则文件职责单一
- 没有冗余信息

### 2. 符合 Cursor 官方标准

- 使用 `.mdc` 格式
- 包含 frontmatter 元数据
- 支持 globs 和 priority

### 3. 中文优先

- 所有规则使用简体中文
- 技术术语保留英文
- 易于理解和执行

### 4. 安全第一

- 最高优先级的部署安全规范
- 明确的授权流程
- 完整的风险评估

---

## 🚀 使用示例

### 场景 1: 发布新闻

AI 会自动应用：

1. `00-hawaiihub-core.mdc` - 标准任务 T1 流程
2. `99-deployment-safety.mdc` - 生产操作授权检查

### 场景 2: 编写 JavaScript 代码

AI 会自动应用：

1. `01-code-standards.mdc` - JavaScript 代码规范（globs 匹配 `*.js`）
2. `00-hawaiihub-core.mdc` - 基础工作原则

### 场景 3: 生产部署

AI 会自动应用：

1. `99-deployment-safety.mdc` - 安全协议（priority: 2000，最高优先级）
2. 停止并请求用户授权

---

## 📊 与 .cursorrules 的关系

| 文件 | 作用 | 关系 |
|-----|------|------|
| `.cursorrules` | 项目入口规则，简要说明 | 指向 `.cursor/rules/` 详细规则 |
| `.cursor/rules/*.mdc` | 详细规则文件 | 被 `.cursorrules` 引用 |

**推荐做法**:

- `.cursorrules` 保持简洁（< 200 行）
- 详细规则放在 `.cursor/rules/` 目录
- 使用 `mdc:` 协议互相引用

---

## 🔧 维护指南

### 添加新规则

1. 创建新的 `.mdc` 文件
2. 添加 frontmatter（description, globs, priority）
3. 使用简体中文编写规则内容
4. 更新本 README.md

### 修改现有规则

1. 找到对应的 `.mdc` 文件
2. 修改规则内容
3. 保持简洁明了
4. 测试 AI 行为是否符合预期

### 规则优先级建议

- `2000+`: 安全规范、强制规则
- `1000-1999`: 核心规范、项目基础
- `500-999`: 功能规范、可选规则
- `100-499`: 辅助规范、优化建议

---

## 📚 相关文档

- **项目说明**: [../../README.md](mdc:../../README.md)
- **快速上手**: [../../docs/GET_STARTED.md](mdc:../../docs/GET_STARTED.md)
- **项目愿景**: [../../PROJECT_VISION_V2.md](mdc:../../PROJECT_VISION_V2.md)

---

**版本**: v2.0.0 (Cursor 官方标准版)  
**创建日期**: 2025-10-26  
**维护者**: HawaiiHub Team  
**标准**: Cursor Official Documentation
