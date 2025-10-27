# Markdown 编写规范指南

> **HawaiiHub Admin Agent** - 防止 Markdown linter 错误
> **创建时间**：2025-10-27

---

## 🎯 目标

确保所有 Markdown 文档符合 linter 规范，避免重复出现格式错误。

---

## ⚡ 快速自检（60 秒）

1. **标题**：确认只有 1 个一级标题，层级不跳级。
2. **代码块**：所有 ```后面必须跟语言（缺省时用`text`）。
3. **空行**：列表、表格、代码块、引用前后都留 1 个空行。
4. **列表符号**：统一使用 `-`，子列表缩进 2 个空格，不混用 `*`/`+`。
5. **多余空行**：全文不允许出现连续两行空白。
6. **lint**：在项目根目录执行 `npx markdownlint "**/*.md"` 确认 0 报错。

> 以上 6 步完成后，Markdown lint 基本不会再报错。

---

## ✅ 核心规则

### 1. MD040 - 代码块必须指定语言

❌ **错误示例**：

````markdown
```
代码内容
```
````

✅ **正确示例**：

````markdown
```bash
代码内容
```

```javascript
代码内容;
```

```text
纯文本内容
```
````

**支持的语言标识符**：

- `bash` / `sh` - Shell 命令
- `javascript` / `js` - JavaScript 代码
- `typescript` / `ts` - TypeScript 代码
- `python` - Python 代码
- `json` - JSON 数据
- `markdown` / `md` - Markdown 文本
- `html` - HTML 代码
- `css` - CSS 样式
- `yaml` - YAML 配置
- `text` - 纯文本（默认选择）

### 2. MD032 - 列表前后需要空行

❌ **错误示例**：

```markdown
## 标题

- 列表项 1
- 列表项 2
```

✅ **正确示例**：

```markdown
## 标题

- 列表项 1
- 列表项 2

下一段文字
```

### 3. MD031 - 代码块前后需要空行

❌ **错误示例**：

````markdown
正文内容

```bash
代码
```

下一段
````

✅ **正确示例**：

````markdown
正文内容

```bash
代码
```

下一段
````

### 4. MD012 - 不要有多余空行

❌ **错误示例**：

```markdown
段落 1

段落 2
```

✅ **正确示例**：

```markdown
段落 1

段落 2
```

---

## 🛠️ 自动修复工具

### 方法 1: 保存时自动修复（推荐）

已配置保存时自动修复，只需：

1. 打开 Markdown 文件
2. 编辑内容
3. 按 `Cmd+S` (Mac) 或 `Ctrl+S` (Windows) 保存
4. **自动修复所有 linter 错误**

### 方法 2: 手动修复当前文件

**使用命令面板**：

1. 按 `Cmd+Shift+P` (Mac) 或 `Ctrl+Shift+P` (Windows)
2. 输入 "Markdown: Fix All"
3. 回车执行

### 方法 3: 修复所有文件

**使用 markdownlint CLI**：

```bash
# 安装 markdownlint-cli
npm install -g markdownlint-cli

# 修复所有 Markdown 文件
markdownlint --fix "**/*.md"

# 修复特定目录
markdownlint --fix "文档/**/*.md"
```

---

## 📋 快速检查清单

在提交代码前，确保：

- [ ] 所有代码块都有语言标识符（如 `bash`、`javascript`、`text`）
- [ ] 列表前后都有空行
- [ ] 代码块前后都有空行
- [ ] 文件末尾只有一个空行（自动处理）
- [ ] 没有连续多个空行

---

## 🔍 验证配置

### 检查 Markdownlint 是否工作

1. 打开任意 `.md` 文件
2. 故意创建一个错误（如代码块不加语言标识符）
3. 应该看到黄色波浪线提示错误
4. 保存文件后应该自动修复

### 验证命令

```bash
# 检查配置文件
cat .markdownlint.json

# 检查 VSCode 配置
cat .vscode/settings.json | grep markdown
```

---

## 🚀 最佳实践

### 1. 使用文本作为默认语言

如果不确定使用什么语言标识符，使用 `text`：

````markdown
```text
这是纯文本内容
```
````

### 2. 列表和段落间保持空行

```markdown
## 标题

这是一段介绍文字。

- 列表项 1
- 列表项 2

这是后续段落。
```

### 3. 代码块独立成段

````markdown
正文内容。

```bash
# 命令示例
npm install
```

继续正文。
````

### 4. 文件结构模板

````markdown
# 标题

> 简介

---

## 章节 1

内容介绍。

- 要点 1
- 要点 2

代码示例：

```bash
命令内容
```
````

---

## 章节 2

...

```text
(文件结束)
```

---

## ⚠️ 常见错误及解决方案

### 错误 1: MD040 - 代码块缺少语言

**错误信息**：

```text
MD040/fenced-code-language: Fenced code blocks should have a language specified
```

**解决方案**：为所有 ` ``` ` 代码块添加语言标识符

### 错误 2: MD032 - 列表缺少空行

**错误信息**：

```text
MD032/blanks-around-lists: Lists should be surrounded by blank lines
```

**解决方案**：在列表前后添加空行

### 错误 3: MD031 - 代码块缺少空行

**错误信息**：

```text
MD031/blanks-around-fences: Fenced code blocks should be surrounded by blank lines
```

**解决方案**：在代码块前后添加空行

### 错误 4: MD012 - 多余空行

**错误信息**：

```text
MD012/no-multiple-blanks: Multiple consecutive blank lines
```

**解决方案**：删除多余的空行，保持单个空行

---

## 📚 参考资源

- **Markdownlint 规则**：<https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md>
- **项目配置**：`.markdownlint.json`
- **工作区配置**：`.vscode/settings.json`

---

## 🎯 总结

### 核心要点

1. ✅ **代码块必须有语言标识符**（最常见错误）
2. ✅ **列表前后要有空行**
3. ✅ **代码块前后要有空行**
4. ✅ **删除多余空行**

### 自动化保障

- 保存时自动修复
- Linter 实时提示
- Git commit 前检查

### 快速修复流程

1. 编辑 Markdown 文件
2. 按 `Cmd+S` 保存
3. **自动修复完成**

---

**文档版本**：v1.0
**最后更新**：2025-10-27
**维护者**：HawaiiHub Agent Team
