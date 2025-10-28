# Agent 团队 OpenSpec 快速上手指南

**适用对象**: FireShot AI Agent 团队
**培训时间**: 30 分钟
**更新日期**: 2025-10-28

---

## 🎯 培训目标

完成本培训后，你将能够：

- ✅ 理解 OpenSpec 的核心概念和工作流
- ✅ 独立创建和实施变更提案
- ✅ 查看和审查项目规范
- ✅ 与其他 Agent 协作开发

---

## 📋 第 1 步：验证环境（2 分钟）

### 检查 OpenSpec CLI

打开终端，运行：

```bash
cd /Users/zhiledeng/Downloads/FireShot
openspec list
```

**预期输出**:
```
No active changes.
```

如果看到错误，请运行：
```bash
npm install -g @fission-ai/openspec@latest
```

### 查看项目结构

```bash
tree openspec/ -L 2
```

**预期输出**:
```
openspec/
├── project.md
├── specs/
│   ├── firecrawl-scraper/
│   └── hawaiihub-data/
├── changes/
└── archive/
```

---

## 📖 第 2 步：理解核心概念（5 分钟）

### 目录结构说明

```
openspec/
├── project.md          # 📋 项目全局规范（技术栈、编码标准）
├── specs/              # ✅ 当前规范（系统的真实状态）
│   ├── firecrawl-scraper/
│   │   └── spec.md    # Firecrawl 爬虫使用规范
│   └── hawaiihub-data/
│       └── spec.md    # HawaiiHub 数据采集规范
├── changes/            # 🚧 待实施变更（新功能的提案）
│   └── add-feature/
│       ├── proposal.md
│       ├── tasks.md
│       └── specs/     # Delta（规范差异）
└── archive/            # 📦 已归档变更（历史记录）
```

### 关键概念

| 术语 | 说明 | 类比 |
|------|------|------|
| **Spec** | 功能规范文档 | 建筑设计图 |
| **Change** | 变更提案 | 装修方案 |
| **Delta** | 规范差异 | Git diff |
| **Requirement** | 需求项 | "系统必须..." |
| **Scenario** | 使用场景 | "当...则..." |

---

## 🚀 第 3 步：查看现有规范（8 分钟）

### 3.1 查看项目总规范

```bash
cat openspec/project.md | head -50
```

**关注要点**:
- 项目定位和技术栈
- Python 代码标准（类型注解、命名约定）
- Firecrawl 使用规范（工具选择、成本控制）
- Git 提交规范（Conventional Commits）

### 3.2 查看 Firecrawl 爬虫规范

```bash
cat openspec/specs/firecrawl-scraper/spec.md
```

**学习重点**:

#### Requirement 结构示例
```markdown
### Requirement: 工具选择策略
系统必须按照以下优先级选择爬取工具。

#### Scenario: 复杂动态页面
- 当页面包含大量 JavaScript 或动态加载内容时
- 则必须使用 MCP Firecrawl 工具
- 并且设置 onlyMainContent=True
```

**规范要素**:
1. **Requirement**: 以 `### Requirement:` 开头
2. **描述**: 一句话说明要求（使用"必须"/"应该"）
3. **Scenario**: 以 `#### Scenario:` 开头
4. **三段式**: 当...时 / 则... / 并且...

### 3.3 查看 HawaiiHub 数据规范

```bash
cat openspec/specs/hawaiihub-data/spec.md
```

**关注点**:
- 数据模型定义（Rental、Restaurant、Article）
- 数据清洗规则
- 存储格式要求（MD + JSON + CSV）
- 质量检查标准

---

## 🎨 第 4 步：创建你的第一个变更（10 分钟）

### 场景：添加夏威夷租房信息爬虫

#### 4.1 创建变更提案

在 Cursor 中对我（AI）说：

```
创建一个 OpenSpec 变更提案：添加夏威夷租房信息爬虫

要求：
1. 从 Craigslist Hawaii 采集租房信息
2. 数据包含：标题、价格、位置、卧室数、浴室数、描述
3. 每天更新 4 次（每 6 小时）
4. 价格范围过滤：$500-$5000
```

**或使用快捷命令**:
```
/openspec:proposal 添加夏威夷租房信息爬虫
```

#### 4.2 AI 会自动生成

```
openspec/changes/add-rental-scraper/
├── proposal.md      # 变更说明
├── tasks.md         # 任务清单
└── specs/
    └── hawaiihub-data/
        └── spec.md  # 规范差异（Delta）
```

#### 4.3 查看生成的提案

```bash
openspec show add-rental-scraper
```

**或使用 cat 命令**:
```bash
cat openspec/changes/add-rental-scraper/proposal.md
cat openspec/changes/add-rental-scraper/tasks.md
cat openspec/changes/add-rental-scraper/specs/hawaiihub-data/spec.md
```

#### 4.4 验证规范格式

```bash
openspec validate add-rental-scraper
```

**预期输出**:
```
✓ Proposal found
✓ Tasks found (8 tasks)
✓ Spec deltas found (1 module)
✓ All scenarios have proper format
```

---

## 🔄 第 5 步：实施变更（3 分钟演示）

### 5.1 实施变更

对我（AI）说：

```
提案看起来不错，开始实施 add-rental-scraper 变更
```

**或使用快捷命令**:
```
/openspec:apply add-rental-scraper
```

### 5.2 AI 的工作流程

我会：
1. 读取 `tasks.md` 中的任务清单
2. 按顺序实施每个任务：
   - 创建数据模型（`models/rental.py`）
   - 添加 Pydantic 验证
   - 实现爬取逻辑（`scrapers/craigslist.py`）
   - 添加错误处理
   - 编写单元测试
   - 更新文档
3. 完成后在任务前打勾 `[x]`

### 5.3 查看任务进度

```bash
cat openspec/changes/add-rental-scraper/tasks.md
```

**示例输出**:
```markdown
## 1. 数据模型
- [x] 1.1 创建 Rental 数据模型（models/rental.py）
- [x] 1.2 添加 Pydantic 验证

## 2. 爬虫实现
- [x] 2.1 实现 Craigslist 爬取逻辑（scrapers/craigslist.py）
- [ ] 2.2 添加错误处理（进行中...）
```

---

## 📦 第 6 步：归档完成的变更（2 分钟）

### 6.1 归档变更

当所有任务完成后，运行：

```bash
openspec archive add-rental-scraper --yes
```

**或对我（AI）说**:
```
请归档 add-rental-scraper 变更
```

### 6.2 归档过程

系统会自动：
1. ✅ 将规范差异合并到 `openspec/specs/hawaiihub-data/spec.md`
2. ✅ 移动变更到 `openspec/archive/add-rental-scraper/`
3. ✅ 更新 CHANGELOG.md（如果存在）
4. ✅ 清理 `openspec/changes/` 目录

### 6.3 验证归档结果

```bash
# 检查规范已更新
cat openspec/specs/hawaiihub-data/spec.md | grep "租房信息采集"

# 检查归档目录
ls openspec/archive/

# 确认 changes/ 为空
openspec list  # 应该显示 "No active changes"
```

---

## 🤝 团队协作指南

### 角色分工

#### 📋 产品 Agent（你可能是这个角色）
**职责**: 创建变更提案

**工作流**:
```
1. 分析需求
2. 对 AI 说：/openspec:proposal <功能描述>
3. 审查生成的提案
4. 提出修改建议
5. 批准后交给开发 Agent
```

#### 💻 开发 Agent（你可能是这个角色）
**职责**: 实施变更

**工作流**:
```
1. 查看提案：openspec show <变更名>
2. 验证规范：openspec validate <变更名>
3. 实施变更：/openspec:apply <变更名>
4. 提交代码：git commit
5. 归档变更：openspec archive <变更名> --yes
```

#### 🧪 测试 Agent（你可能是这个角色）
**职责**: 验证实施结果

**工作流**:
```
1. 对照 specs/ 文件编写测试用例
2. 运行测试：pytest tests/
3. 检查覆盖率：pytest --cov
4. 反馈问题给开发 Agent
```

### 协作规范

#### ✅ 推荐做法

1. **小步快跑**
   ```
   ✅ 创建多个小变更（每个 1-3 天完成）
   ❌ 创建一个巨大变更（几周才能完成）
   ```

2. **模块化分工**
   ```
   ✅ Agent A 负责 firecrawl-scraper 模块
   ✅ Agent B 负责 hawaiihub-data 模块
   ✅ 并行开发，减少冲突
   ```

3. **频繁同步**
   ```bash
   # 每天开始工作前
   git pull
   openspec list  # 查看其他 Agent 的变更
   ```

4. **及时归档**
   ```
   ✅ 完成一个变更立即归档
   ❌ 积累 10+ 个已完成的变更不归档
   ```

---

## 📝 常用命令速查

### 查看命令

```bash
openspec list                  # 查看所有活动变更
openspec view                  # 交互式仪表板
openspec show <change>         # 查看变更详情
openspec validate <change>     # 验证规范格式
```

### 操作命令

```bash
# 创建变更（通过 AI）
对 AI 说：/openspec:proposal <功能描述>

# 实施变更（通过 AI）
对 AI 说：/openspec:apply <变更名>

# 归档变更
openspec archive <change> --yes

# 更新 AI 配置
openspec update
```

### Git 集成

```bash
# 提交变更
git add .
git commit -m "feat(scraper): 添加租房信息爬虫"

# 推送到远程
git push origin main
```

---

## 🎯 实战练习

### 练习 1：查看现有规范（5 分钟）

**任务**: 找出 Firecrawl 爬虫规范中关于"成本控制"的要求

**步骤**:
```bash
cat openspec/specs/firecrawl-scraper/spec.md | grep -A 10 "成本控制"
```

**问题**:
1. 系统在执行每次爬取前应该检查什么？
2. 缓存策略的参数是什么？
3. 成本记录应该输出到哪里？

<details>
<summary>查看答案</summary>

1. 检查是否超出每日预算
2. `max_age=172800000`（2天）
3. 输出到日志文件
</details>

### 练习 2：创建一个简单变更（10 分钟）

**任务**: 创建一个"添加结构化日志记录"的变更提案

**步骤**:
1. 对 AI 说：`/openspec:proposal 添加结构化日志记录`
2. 运行：`openspec show add-logging`
3. 验证：`openspec validate add-logging`

**检查清单**:
- [ ] proposal.md 包含背景和目标
- [ ] tasks.md 至少有 3 个任务
- [ ] specs/ 目录有规范差异

### 练习 3：审查规范差异（5 分钟）

**任务**: 查看 add-logging 变更的规范差异

**步骤**:
```bash
cat openspec/changes/add-logging/specs/*/spec.md
```

**问题**:
1. 规范差异使用什么标记（ADDED/MODIFIED/REMOVED）？
2. 每个 Requirement 是否都有至少一个 Scenario？
3. Scenario 是否遵循"当...则...并且..."格式？

---

## ⚠️ 常见错误和解决方案

### 错误 1: 规范太模糊

❌ **错误示例**:
```markdown
### Requirement: 数据质量
数据应该是好的。
```

✅ **正确示例**:
```markdown
### Requirement: 数据完整性验证
系统必须验证所有必填字段都存在且有效。

#### Scenario: 缺失必填字段
- 当 title 或 price 字段缺失时
- 则系统应记录 ERROR 日志
- 并且拒绝保存该条目
```

### 错误 2: 任务不够具体

❌ **错误示例**:
```markdown
- [ ] 实现功能
```

✅ **正确示例**:
```markdown
- [ ] 1.1 创建数据模型（models/rental.py）
- [ ] 1.2 添加 Pydantic 验证（使用 Field 约束）
- [ ] 2.1 实现爬取逻辑（scrapers/craigslist.py）
- [ ] 2.2 添加单元测试（tests/test_rental.py）
```

### 错误 3: 直接修改 specs/

❌ **错误做法**:
```bash
# 手动编辑现有规范
vim openspec/specs/hawaiihub-data/spec.md
```

✅ **正确做法**:
```
1. 创建变更提案
2. 在 changes/ 中编辑规范差异
3. 实施变更
4. 归档时自动合并到 specs/
```

---

## 📚 扩展学习

### 推荐阅读顺序

1. **OPENSPEC_GUIDE.md**（15 分钟）- 完整使用指南
2. **openspec/project.md**（10 分钟）- 项目全局规范
3. **AGENTS.md**（5 分钟）- AI 助手行为规范
4. **官方文档**: https://openspec.dev/

### 进阶主题

- 如何编写高质量的 Requirement
- 如何处理跨模块变更
- 如何解决规范冲突
- 如何迁移遗留代码到 OpenSpec

---

## ✅ 培训检查清单

完成以下项目后，你就掌握了 OpenSpec！

- [ ] 能够运行 `openspec list` 和 `openspec view`
- [ ] 理解 specs/、changes/、archive/ 的区别
- [ ] 能够阅读和理解现有规范
- [ ] 能够创建变更提案（通过 AI）
- [ ] 能够验证规范格式（`openspec validate`）
- [ ] 能够查看变更详情（`openspec show`）
- [ ] 理解 Requirement 和 Scenario 的格式
- [ ] 能够归档完成的变更
- [ ] 知道如何避免常见错误
- [ ] 知道在哪里查找帮助文档

---

## 🆘 获取帮助

### 遇到问题？

1. **查看文档**
   ```bash
   cat OPENSPEC_GUIDE.md
   cat OPENSPEC_SETUP_COMPLETE.md
   ```

2. **运行诊断**
   ```bash
   openspec validate <change>
   ```

3. **查看示例**
   ```bash
   cat openspec/specs/firecrawl-scraper/spec.md
   ```

4. **咨询团队**
   - 在团队会议中讨论
   - 查看其他 Agent 的变更提案

---

## 🎉 下一步

恭喜！你已经完成了 OpenSpec 快速上手培训。

**立即行动**:
1. 创建你的第一个真实变更提案
2. 实施并归档它
3. 与团队分享你的经验

**持续提升**:
- 每周至少创建 1-2 个变更
- 审查其他 Agent 的提案
- 优化现有规范

---

**培训完成时间**: _____________
**培训师**: HawaiiHub AI Team
**版本**: v1.0.0
**最后更新**: 2025-10-28

祝你在 OpenSpec 的世界里开发愉快！🚀
