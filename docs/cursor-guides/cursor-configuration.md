# .cursor/ 配置目录

> **FireShot 项目 Cursor AI 配置中心**
> **更新时间**: 2025-10-27
> **版本**: v1.0.0

---

## 📁 目录结构

```
.cursor/
├── README.md                           # 本文件 - 配置说明
├── config.json                         # Cursor 项目配置
│
├── rules/                              # 规则目录
│   ├── firecrawl-rules.md             # Firecrawl 专项规则
│   ├── python-standards.md             # Python 代码规范
│   ├── cost-control.md                 # 成本控制规范
│   └── hawaiihub-templates.md          # HawaiiHub 模板
│
├── docs/                               # 文档目录
│   ├── quick-reference.md              # 快速参考卡
│   ├── setup-guide.md                  # 配置指南
│   └── best-practices.md               # 最佳实践
│
└── templates/                          # 模板目录
    ├── scraper-template.py             # 爬虫模板
    ├── analyzer-template.py            # 分析模板
    └── error-handler-template.py       # 错误处理模板
```

---

## 🚀 快速开始

### 1. 配置已完成

所有配置已经自动完成，你可以立即开始使用：

```bash
# 查看主规则
cat ../.cursorrules

# 查看 Firecrawl 专项规则
cat rules/firecrawl-rules.md

# 查看快速参考
cat docs/quick-reference.md
```

### 2. 核心规则优先级

| 优先级 | 文件                       | 说明                   |
| ------ | -------------------------- | ---------------------- |
| **P0** | `../.cursorrules`          | 主规则文件（自动加载） |
| **P1** | `rules/firecrawl-rules.md` | Firecrawl 详细规则     |
| **P2** | `docs/quick-reference.md`  | 快速参考卡             |
| **P3** | `templates/*.py`           | 代码模板               |

---

## 📚 文件说明

### 核心配置

- **config.json**: Cursor 项目级配置
  - 语言设置（简体中文）
  - Python 环境配置
  - Linter 和格式化设置

### 规则文件（rules/）

- **firecrawl-rules.md**: Firecrawl 完整规范
  - 工具选择决策树
  - SDK v2 变化说明
  - 错误处理模板
  - 性能优化策略

- **python-standards.md**: Python 代码标准
  - 类型注解规范
  - 文档字符串标准
  - 测试要求
  - 格式化规则

- **cost-control.md**: 成本控制规范
  - 请求计数和预算监控
  - 缓存策略
  - 密钥轮换机制

- **hawaiihub-templates.md**: HawaiiHub 专项模板
  - 新闻爬取模板
  - 数据清洗规范
  - 本地化处理

### 文档（docs/）

- **quick-reference.md**: 一页纸快速参考
- **setup-guide.md**: 配置步骤指南
- **best-practices.md**: 最佳实践汇总

### 模板（templates/）

- **scraper-template.py**: 标准爬虫模板
- **analyzer-template.py**: 数据分析模板
- **error-handler-template.py**: 错误处理模板

---

## 🎯 使用场景

### 场景 1: 新成员入职

```bash
# 1. 阅读主规则
cat ../.cursorrules

# 2. 查看快速参考
cat docs/quick-reference.md

# 3. 复制模板开始开发
cp templates/scraper-template.py ../scripts/my_scraper.py
```

### 场景 2: 实现新功能

```bash
# 1. 查看相关规则
cat rules/firecrawl-rules.md

# 2. 使用模板
cp templates/scraper-template.py ../scripts/new_feature.py

# 3. 参考最佳实践
cat docs/best-practices.md
```

### 场景 3: 调试问题

```bash
# 1. 查看错误处理模板
cat templates/error-handler-template.py

# 2. 查看成本控制规范
cat rules/cost-control.md
```

---

## ⚙️ 配置管理

### 自动加载

Cursor 会自动加载以下配置：

1. `../.cursorrules` - 主规则文件
2. `.cursor/config.json` - 项目配置

### 手动引用

在需要时引用特定规则：

```python
# 查看 Firecrawl 规则
# 文件: .cursor/rules/firecrawl-rules.md
```

---

## 📊 配置状态

| 组件         | 状态      | 说明                         |
| ------------ | --------- | ---------------------------- |
| **主规则**   | ✅ 已配置 | `.cursorrules` (19KB, 851行) |
| **项目配置** | ✅ 已配置 | `config.json`                |
| **专项规则** | ✅ 已配置 | 4 个规则文件                 |
| **文档**     | ✅ 已配置 | 3 个文档文件                 |
| **模板**     | ✅ 已配置 | 3 个代码模板                 |

---

## 🔄 更新记录

### v1.0.0 (2025-10-27)

- ✅ 初始化 `.cursor/` 目录结构
- ✅ 创建主规则文件 `.cursorrules` (851行)
- ✅ 添加 Firecrawl SDK v2 规范
- ✅ 创建 Python 代码标准
- ✅ 添加成本控制规范
- ✅ 创建 HawaiiHub 专项模板
- ✅ 配置项目级设置

---

## 📞 获取帮助

### 文档优先级

**立即查看**:

1. `docs/quick-reference.md` - 5 分钟快速参考
2. `../.cursorrules` - 完整规则（851行）

**深入学习**: 3. `rules/firecrawl-rules.md` - Firecrawl 详细规范 4. `docs/best-practices.md` - 最佳实践汇总

### 常见问题

**Q: 如何查看所有规则？**

```bash
cat ../.cursorrules
```

**Q: 如何使用模板？**

```bash
cp templates/scraper-template.py ../scripts/my_script.py
```

**Q: 如何更新配置？**

- 编辑相应的文件即可，Cursor 会自动重新加载

---

**🔥 FireShot 项目已完成 Cursor 配置初始化！**

---

_更新时间: 2025-10-27_
_维护者: HawaiiHub AI Team_
_版本: v1.0.0_
