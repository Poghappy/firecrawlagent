# OpenSpec 文档索引

**项目**: FireShot
**更新日期**: 2025-10-28

---

## 📚 文档导航

### 🚀 快速开始（新 Agent 必读）

| 文档 | 用途 | 阅读时间 | 优先级 |
|------|------|---------|--------|
| [Agent 团队快速上手](./AGENT_TEAM_QUICKSTART.md) | 30分钟实战培训 | 30 分钟 | **P0** |
| [项目全局规范](./project.md) | 技术栈、编码标准 | 15 分钟 | **P0** |
| [团队角色分工](./AGENT_ROLES_GUIDE.md) | 明确每个 Agent 的职责 | 20 分钟 | **P1** |

### 📖 规范文档

| 模块 | 文档路径 | 说明 |
|------|---------|------|
| Firecrawl 爬虫 | [specs/firecrawl-scraper/spec.md](./specs/firecrawl-scraper/spec.md) | 爬虫工具使用规范 |
| HawaiiHub 数据 | [specs/hawaiihub-data/spec.md](./specs/hawaiihub-data/spec.md) | 数据采集和处理规范 |

### 🛠️ 完整指南

| 文档 | 位置 | 说明 |
|------|------|------|
| OpenSpec 完整指南 | [../OPENSPEC_GUIDE.md](../OPENSPEC_GUIDE.md) | 详细使用说明（25KB）|
| 配置完成报告 | [../OPENSPEC_SETUP_COMPLETE.md](../OPENSPEC_SETUP_COMPLETE.md) | 环境配置说明 |
| AI 助手规范 | [../AGENTS.md](../AGENTS.md) | AI 行为规范 |

---

## 🎯 按角色查找文档

### 📋 Product Agent
**你的核心任务**: 创建变更提案，定义需求

**必读文档**:
1. [Agent 团队快速上手](./AGENT_TEAM_QUICKSTART.md) - 第 4 步
2. [团队角色分工](./AGENT_ROLES_GUIDE.md) - Product Agent 章节
3. [项目全局规范](./project.md) - 了解技术约束

**常用命令**:
```bash
# 创建提案
/openspec:proposal <功能描述>

# 查看提案
openspec show <变更名>

# 验证提案
openspec validate <变更名>
```

---

### 💻 Development Agent
**你的核心任务**: 实施变更，编写代码

**必读文档**:
1. [Agent 团队快速上手](./AGENT_TEAM_QUICKSTART.md) - 第 5 步
2. [团队角色分工](./AGENT_ROLES_GUIDE.md) - Development Agent 章节
3. [specs/firecrawl-scraper/spec.md](./specs/firecrawl-scraper/spec.md) - 爬虫规范
4. [specs/hawaiihub-data/spec.md](./specs/hawaiihub-data/spec.md) - 数据规范

**常用命令**:
```bash
# 实施变更
/openspec:apply <变更名>

# 运行测试
pytest tests/ --cov

# 提交代码
git commit -m "feat(scraper): 添加功能"

# 归档变更
openspec archive <变更名> --yes
```

---

### 🧪 Quality Agent
**你的核心任务**: 测试验证，确保质量

**必读文档**:
1. [团队角色分工](./AGENT_ROLES_GUIDE.md) - Quality Agent 章节
2. [specs/](./specs/) - 所有规范（对照测试）
3. [项目全局规范](./project.md) - 质量标准

**常用命令**:
```bash
# 运行测试
pytest tests/ -v --cov

# 代码质量检查
ruff check .
mypy src/

# 性能测试
pytest tests/ --profile
```

---

### 📚 Documentation Agent
**你的核心任务**: 编写文档，知识管理

**必读文档**:
1. [团队角色分工](./AGENT_ROLES_GUIDE.md) - Documentation Agent 章节
2. [OpenSpec 完整指南](../OPENSPEC_GUIDE.md) - 参考格式

**工作重点**:
- 更新 API 文档
- 编写使用示例
- 维护 CHANGELOG
- 整理 FAQ

---

### 🚀 DevOps Agent
**你的核心任务**: 部署监控，性能优化

**必读文档**:
1. [团队角色分工](./AGENT_ROLES_GUIDE.md) - DevOps Agent 章节
2. [项目全局规范](./project.md) - 成本控制部分

**关注指标**:
- 爬取成功率 > 95%
- 响应时间 < 5 秒
- 每日成本 < $10
- 缓存命中率 > 60%

---

## 🔍 按任务查找文档

### 我想创建一个新功能
→ 阅读 [Agent 团队快速上手](./AGENT_TEAM_QUICKSTART.md) 第 4 步

### 我想查看现有规范
→ 查看 [specs/](./specs/) 目录

### 我想实施一个变更
→ 阅读 [Agent 团队快速上手](./AGENT_TEAM_QUICKSTART.md) 第 5 步

### 我想编写测试
→ 阅读 [团队角色分工](./AGENT_ROLES_GUIDE.md) Quality Agent 章节

### 我想了解完整工作流
→ 阅读 [OpenSpec 完整指南](../OPENSPEC_GUIDE.md)

---

## 📊 目录结构

```
openspec/
├── README.md                          # 📍 本文件（文档索引）
├── project.md                         # 📋 项目全局规范
├── AGENT_TEAM_QUICKSTART.md          # 🚀 30分钟快速上手
├── AGENT_ROLES_GUIDE.md              # 🎭 团队角色分工
│
├── specs/                             # ✅ 当前规范（系统真实状态）
│   ├── firecrawl-scraper/
│   │   └── spec.md                   # Firecrawl 爬虫规范
│   └── hawaiihub-data/
│       └── spec.md                   # HawaiiHub 数据规范
│
├── changes/                           # 🚧 待实施变更
│   └── <change-name>/
│       ├── proposal.md
│       ├── tasks.md
│       └── specs/                    # 规范差异（Delta）
│
└── archive/                           # 📦 已归档变更
    └── <change-name>/                # 历史记录
```

---

## ⚡ 快速命令参考

### 查看类命令

```bash
# 查看所有变更
openspec list

# 交互式仪表板
openspec view

# 查看变更详情
openspec show <change-name>

# 验证规范格式
openspec validate <change-name>
```

### 操作类命令

```bash
# 创建变更（通过 AI）
/openspec:proposal <功能描述>

# 实施变更（通过 AI）
/openspec:apply <change-name>

# 归档变更
openspec archive <change-name> --yes
```

### Git 命令

```bash
# 查看状态
git status

# 提交代码
git add .
git commit -m "feat(scraper): 添加功能"

# 推送代码
git push origin main
```

---

## 🎓 学习路径

### 第 1 天：环境熟悉（30 分钟）
1. ✅ 运行 `openspec list` 验证环境
2. ✅ 阅读 [Agent 团队快速上手](./AGENT_TEAM_QUICKSTART.md)
3. ✅ 完成培训练习 1-3

### 第 2 天：规范学习（1 小时）
1. ✅ 阅读 [specs/firecrawl-scraper/spec.md](./specs/firecrawl-scraper/spec.md)
2. ✅ 阅读 [specs/hawaiihub-data/spec.md](./specs/hawaiihub-data/spec.md)
3. ✅ 理解 Requirement 和 Scenario 格式

### 第 3 天：实战练习（2 小时）
1. ✅ 创建第一个变更提案
2. ✅ 实施并测试
3. ✅ 归档变更

### 第 1 周：角色熟悉
1. ✅ 阅读 [团队角色分工](./AGENT_ROLES_GUIDE.md)
2. ✅ 明确自己的角色职责
3. ✅ 完成至少 2 个真实变更

---

## 💡 最佳实践提示

### ✅ 推荐做法

1. **小步快跑**
   - 每个变更 1-3 天完成
   - 频繁归档，保持 changes/ 整洁

2. **模块化分工**
   - 不同 Agent 负责不同模块
   - 减少冲突，提高效率

3. **频繁同步**
   - 每天 `git pull` 获取最新规范
   - 查看 `openspec list` 了解团队进展

4. **完善文档**
   - 规范要明确具体
   - Scenario 要覆盖边界情况

### ⚠️ 避免的错误

1. ❌ 直接修改 `specs/`（应通过变更提案）
2. ❌ 规范太模糊（缺少 Scenario）
3. ❌ 任务不够具体（缺少文件路径）
4. ❌ 跳过测试验证
5. ❌ 不及时归档

---

## 🆘 获取帮助

### 遇到问题？

1. **查看文档**
   ```bash
   cat openspec/AGENT_TEAM_QUICKSTART.md
   cat ../OPENSPEC_GUIDE.md
   ```

2. **运行诊断**
   ```bash
   openspec validate <change>
   openspec show <change>
   ```

3. **查看示例**
   ```bash
   cat specs/firecrawl-scraper/spec.md
   ```

4. **咨询团队**
   - 在团队会议中讨论
   - 查看其他 Agent 的变更

---

## 📈 进度追踪

### 个人检查清单

- [ ] 完成环境验证（`openspec list`）
- [ ] 阅读快速上手指南（30 分钟）
- [ ] 理解角色职责
- [ ] 创建第一个变更提案
- [ ] 实施并归档第一个变更
- [ ] 熟悉常用命令
- [ ] 能够独立工作

### 团队检查清单

- [ ] 所有 Agent 完成培训
- [ ] 明确角色分工
- [ ] 建立协作流程
- [ ] 每周至少 3-5 个变更
- [ ] 规范库逐步完善

---

## 🎉 开始你的 OpenSpec 之旅

选择适合你的起点：

- **我是新 Agent** → 从 [Agent 团队快速上手](./AGENT_TEAM_QUICKSTART.md) 开始
- **我想创建提案** → 阅读 Product Agent 章节
- **我想写代码** → 阅读 Development Agent 章节
- **我想了解全貌** → 阅读 [OpenSpec 完整指南](../OPENSPEC_GUIDE.md)

---

**维护者**: HawaiiHub AI Team
**版本**: v1.0.0
**最后更新**: 2025-10-28

**祝你在 FireShot 项目中开发愉快！** 🚀
