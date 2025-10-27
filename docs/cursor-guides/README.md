# 🎯 Cursor 配置和使用指南

> **项目**: FireShot - Firecrawl 云 API 最佳实践
> **更新时间**: 2025-10-27
> **适用版本**: Cursor 最新版

---

## 📚 文档导航

### 🚀 快速开始

1. **[斜杠命令指南](./slash-commands.md)** ⭐ 必读
   - 斜杠命令完整说明
   - `@` `#` `/` 三大符号系统
   - 核心快捷键速查
   - 常见问题排查

2. **[配置检查清单](./configuration-checklist.md)**
   - Cursor 配置验证
   - MCP 服务器状态
   - 环境变量检查

3. **[快速参考卡片](./quick-reference.md)**
   - 常用快捷键
   - 工作流模板
   - 提示词示例

### 📖 详细指南

4. **[Cursor 完整配置](./cursor-configuration.md)**
   - settings.json 详解
   - AI 工具自动授权
   - 性能优化配置

5. **[Firecrawl 规范](./firecrawl-rules.md)**
   - Firecrawl MCP 工具使用
   - Python SDK 最佳实践
   - 成本控制策略

6. **[Python 开发规范](./python-standards.md)**
   - 类型注解要求
   - 测试规范（pytest）
   - Ruff 配置

7. **[成本控制指南](./cost-control.md)**
   - API 密钥管理
   - 请求计数监控
   - 缓存策略

8. **[HawaiiHub 模板](./hawaiihub-templates.md)**
   - 新闻爬取模板
   - 数据清洗流程
   - 常用工作流

---

## ⚙️ Cursor 官方配置文件

### 主配置文件

```
FireShot/
├── .cursorrules           ✅ 主配置文件（唯一官方文件）
├── .vscode/               ✅ IDE 配置
│   └── settings.json      # Cursor 设置
├── .gitignore             ✅ Git 忽略规则
└── .env                   ✅ 环境变量
```

### 不推荐的做法

- ❌ 创建 `.cursor/` 目录（非官方）
- ❌ 使用自定义 JSON 配置
- ❌ 硬编码 API 密钥

---

## 🎯 核心功能速查

### 三大符号系统

| 符号 | 功能         | 示例                     |
| ---- | ------------ | ------------------------ |
| `@`  | 引用代码符号 | `@functionName`          |
| `#`  | 引用文件     | `#src/app.py`            |
| `/`  | 快捷命令     | `/generate`、`/refactor` |

### 核心快捷键

| 快捷键  | 功能               |
| ------- | ------------------ |
| `Cmd+I` | 打开 Agent         |
| `Cmd+K` | 行内编辑           |
| `Cmd+L` | 新聊天（选中代码） |
| `Cmd+T` | 新标签页           |
| `Cmd+/` | 切换模型           |

---

## 🔧 配置验证

### 1. 检查 Cursor 版本

```bash
# 打开 Cursor
Cmd+Shift+P → "About"
```

### 2. 检查 MCP 服务器

```bash
# 查看 MCP 配置
cat ~/Library/Application\ Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

### 3. 检查环境变量

```bash
# 验证 API 密钥
cat .env | grep FIRECRAWL_API_KEY
```

### 4. 测试斜杠命令

1. 按 `Cmd+I` 打开 Agent
2. 输入 `/`
3. 查看命令列表是否显示

---

## 📊 常见问题排查

### Q1: 斜杠命令消失了？

**症状**: 在 Agent 中输入 `/` 没有弹出命令列表

**解决方案**:

1. ✅ 确保在 Agent 聊天框（`Cmd+I`）
2. ✅ 输入 `/` 后稍等 1-2 秒
3. ✅ 检查 Cursor 版本是否最新
4. ✅ 重启 Cursor 编辑器
5. ✅ 检查网络连接

### Q2: @ 符号无法引用代码？

**解决方案**:

1. 等待代码库索引完成（右下角状态栏）
2. 检查 `.cursorignore` 是否排除了文件
3. 尝试重建索引：`Cmd+Shift+P` → "Rebuild Codebase Index"

### Q3: Agent 响应慢？

**解决方案**:

1. 查看 settings.json 中的优化配置
2. 检查 API 配额
3. 尝试切换模型 (`Cmd+/`)
4. 清理工作区缓存

---

## 🚀 快速启动工作流

### 工作流 1: 代码生成

```markdown
1. Cmd+I → 打开 Agent
2. #src/app.py → 引用文件
3. @existingFunction → 引用函数
4. 描述需求 → "基于 existingFunction 创建新功能"
5. Cmd+Return → 执行
```

### 工作流 2: Bug 修复

```markdown
1. 选中有问题的代码
2. Cmd+K → 打开行内编辑
3. 描述问题 → "修复空指针异常"
4. Return → 提交
5. Cmd+Return → 接受更改
```

### 工作流 3: 代码重构

```markdown
1. Cmd+I → 打开 Agent
2. /refactor → 使用重构命令
3. 描述要求 → "使用最新 Python 最佳实践"
4. 审查差异 → 查看修改
5. Cmd+Return → 接受
```

---

## 📖 学习路径

### 第 1 天：基础配置

- [ ] 阅读 [斜杠命令指南](./slash-commands.md)
- [ ] 完成 [配置检查清单](./configuration-checklist.md)
- [ ] 测试 `@` `#` `/` 三大符号

### 第 2 天：工作流实践

- [ ] 学习 3 个核心工作流
- [ ] 尝试 5 次 Agent 对话
- [ ] 使用行内编辑 10 次

### 第 3 天：高级功能

- [ ] 配置 MCP 服务器
- [ ] 自定义 `.cursorrules`
- [ ] 创建代码模板

### 第 1 周：精通 Cursor

- [ ] 完成 20+ Agent 任务
- [ ] 导出 3 个知识库对话
- [ ] 优化工作流提效 50%+

---

## 📚 官方资源

### Cursor 官方

- **文档**: https://cursor.com/cn/docs
- **更新日志**: https://www.cursor.com/changelog
- **论坛**: https://forum.cursor.com/
- **支持**: hi@cursor.com

### 社区资源

- **awesome-cursorrules**: https://github.com/PatrickJS/awesome-cursorrules
- **Cursor Directory**: https://cursor.directory/
- **Discord**: https://discord.gg/cursor

---

## 🎯 项目专用配置

### FireShot 项目特性

1. **Firecrawl 集成**
   - MCP 工具优先
   - Python SDK 备用
   - 自动缓存策略

2. **HawaiiHub 专用**
   - 新闻爬取模板
   - 数据清洗规范
   - 成本控制严格

3. **Python 规范**
   - 类型注解强制
   - pytest 测试
   - Ruff 格式化

---

## 🔄 版本历史

- **v1.0.0** (2025-10-27) - 初始版本
  - 创建完整文档结构
  - 斜杠命令完整指南
  - 配置检查清单

---

## 💡 贡献指南

如需更新文档：

1. 编辑对应的 `.md` 文件
2. 更新版本号和日期
3. 提交 Commit（使用 Conventional Commits）

---

**快速开始**: 阅读 [斜杠命令指南](./slash-commands.md) (5 分钟)
