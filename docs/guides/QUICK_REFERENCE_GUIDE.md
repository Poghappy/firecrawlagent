# ⚡ 快速参考指南 - AI 编程工作流

## 🚀 5 分钟快速启动

### 场景 1：我想快速构建 MVP 验证想法

**推荐**：Vibe Coding 工作流 + Bolt.new

```bash
# 步骤（2-4小时完成MVP）
1. 访问 AI Studio (https://aistudio.google.com/)
2. 粘贴研究提示：part1-deepresearch.md
3. 回答问题，保存结果
4. 重复：PRD → Tech Design → AI Instructions
5. 在Bolt.new中粘贴PRD，点击生成
6. 部署并测试

成功率：87%
平均时间：4小时
成本：$0（使用免费工具）
```

### 场景 2：我在现有项目添加功能

**推荐**：Structured AI Workflows + Cursor

```bash
# 步骤（30分钟-2小时）
1. 在Cursor中打开项目
2. 提示："使用@create-prd.md 实现[功能]"
3. 审查生成的PRD
4. 提示："使用@generate-tasks.md和@PRD-Feature.md"
5. 提示："从任务1.1开始，使用@process-task-list.md"
6. 逐任务审查和批准

适合：中等复杂度功能
工具：Cursor ($20/月) 或 Claude Code（免费）
```

### 场景 3：我需要生产级代码质量

**推荐**：PRPs 方法论 + Claude Code

```bash
# 步骤（1-3天）
1. git clone https://github.com/Wirasm/PRPs-agentic-eng.git
2. cp -r .claude/commands your-project/.claude/
3. cp -r PRPs your-project/
4. 在Claude Code中：/create-base-prp [功能描述]
5. 审查PRP，特别是验证循环
6. /execute-base-prp PRPs/feature.md
7. 运行所有验证级别：Level 1 → 2 → 3
8. 提交并创建PR

适合：关键功能、生产应用
质量：生产就绪
时间：较长但可靠
```

---

## 📊 工具对比速查表

| 需求         | 推荐工具       | 成本     | 学习曲线 | 适用场景       |
| ------------ | -------------- | -------- | -------- | -------------- |
| **快速原型** | Bolt.new       | $20/月   | ⭐       | 演示、验证想法 |
| **学习编码** | Cursor + GPT   | $20/月   | ⭐⭐     | 教育、学习项目 |
| **日常开发** | Cursor         | $20/月   | ⭐⭐     | 中小型功能     |
| **复杂重构** | Claude Code    | 免费     | ⭐⭐⭐   | 代码库重构     |
| **生产代码** | PRPs + Claude  | 模型费用 | ⭐⭐⭐⭐ | 关键功能       |
| **团队协作** | GHM + 任意     | 工具费用 | ⭐⭐⭐⭐ | 企业项目       |
| **零预算**   | Cline + Gemini | 免费     | ⭐⭐⭐   | 个人项目       |

---

## 🎯 方法论速查

### PRP 方法（生产级）

```
✅ 使用时机
- 关键业务功能
- 需要"一次性成功"
- 复杂的系统集成

📋 核心组件
1. Goal - 明确目标
2. Why - 商业价值
3. Context - 详细上下文
   - 文件路径
   - 库文档
   - 已知陷阱
4. Implementation - 实施蓝图
5. Validation Loop - 三层验证
   - Level 1: Linting
   - Level 2: 单元测试
   - Level 3: 集成测试

⏱️ 时间投入
- 创建PRP: 30-60分钟
- 执行: 2-8小时
- 总计: 半天到1天

🎯 成功率：90%+（高质量代码）
```

### Vibe Coding（快速 MVP）

```
✅ 使用时机
- 验证新想法
- 需要快速演示
- 预算有限

📋 四阶段流程
1. Research (20-30分钟)
   - 市场验证
   - 竞品分析

2. PRD (15-20分钟)
   - 定义核心功能
   - 目标用户

3. Tech Design (15-20分钟)
   - 选择技术栈
   - 架构决策

4. Build (1-3小时)
   - AI生成代码
   - 测试部署

⏱️ 总时间：2-4小时

🎯 成功率：87%（达到部署）
```

### Structured Workflows（平衡）

```
✅ 使用时机
- 日常功能开发
- 团队协作
- 需要渐进式验证

📋 工作流
1. 创建PRD (15分钟)
2. 生成任务 (10分钟)
3. 逐任务执行 (1-4小时)
4. 每任务审查和批准

⏱️ 总时间：1.5-5小时

🎯 成功率：80%+（可控质量）
```

### GHM（企业级）

```
✅ 使用时机
- 大型团队（5+人）
- 长期项目
- 需要严格治理

📋 三文件纪律
1. Command Center - 操作真相
2. PRD - 产品需求
3. EPIC - 当前任务

📋 门控系统
- 设计门控
- 实现门控
- 验证门控
- 部署门控

⏱️ 设置时间：1-2天
⏱️ 持续维护：每天15分钟

🎯 适合：企业、合规要求高的项目
```

---

## 🔧 工具配置速查

### Cursor 配置（3 分钟）

```bash
# 1. 创建.cursorrules文件
touch .cursorrules

# 2. 复制模板（选择适合你的）
# 通用全栈：CURSOR_GPT_TEMPLATES.md中的模板1
# Python/FastAPI：模板2

# 3. 添加AI dev tasks（可选）
git clone https://github.com/jasonleinart/structured-ai-workflows.git /tmp/workflows
cp /tmp/workflows/*.md .

# 4. 在Cursor中测试
# 提示："使用@create-prd.md创建认证功能的PRD"
```

### Claude Code 配置（5 分钟）

```bash
# 1. 创建CLAUDE.md
cat > CLAUDE.md << 'EOF'
# Project: [Your Project]
# Tech Stack: [Your Stack]

## AI Workflows
使用以下文件进行结构化开发：
/ai-dev-tasks/create-prd.md
/ai-dev-tasks/generate-tasks.md
/ai-dev-tasks/process-task-list.md

[添加项目特定规则]
EOF

# 2. 添加自定义命令
mkdir -p .claude/commands

cat > .claude/commands/create-prd.md << 'EOF'
请使用/ai-dev-tasks/create-prd.md
帮我创建新功能的PRD
EOF

# 3. 重启Claude Code
/exit
# 重新启动

# 4. 测试
/create-prd
```

### ChatGPT GPT 创建（10 分钟）

```markdown
1. 打开 ChatGPT → "Explore" → "Create a GPT"

2. 选择模板（从 CURSOR_GPT_TEMPLATES.md）
   - 编码助手：技术实现
   - 产品经理：PRD 创建

3. 配置
   Name: [GPT 名称]
   Description: [简短描述]
   Instructions: [粘贴完整模板]

4. 上传知识文档（可选）
   - 技术文档 PDF
   - 项目规范
   - 最佳实践

5. 配置能力
   ☑ Web Browsing
   ☑ Code Interpreter
   ☐ DALL·E（按需）

6. 测试
   使用 Conversation Starters 测试

7. 发布
   - Private: 仅自己
   - Link: 团队分享
   - Public: GPT Store
```

---

## 📋 Prompt 模板库

### 创建 PRD

```markdown
**基础版**
"使用@create-prd.md 帮我创建一个[功能]的 PRD"

**高级版**
"使用@create-prd.md 创建 PRD

功能：[详细描述]
目标用户：[用户角色]
关键约束：[技术/时间/预算约束]
成功指标：[KPI]

参考以下文件：@file1.ts @file2.py"

**团队版**
"创建 PRD 用于[功能]

我们的标准：

- 遵循@CLAUDE.md 中的规范
- 包含用户故事和验收标准
- 添加 Mermaid 架构图
- 列出 API 端点和数据模型"
```

### 生成任务

```markdown
**简单版**
"使用@generate-tasks.md 和@PRD-Feature.md 创建任务列表"

**详细版**
"基于@PRD-Feature.md 生成详细任务列表

要求：

- 分解为 3-4 个主要阶段
- 每个阶段 3-5 个子任务
- 包含预估时间
- 标注依赖关系
- 标明优先级（P0/P1/P2）"
```

### 执行任务

```markdown
**标准版**
"从任务 1.1 开始并使用@process-task-list.md"

**安全版**
"执行任务但遵循以下规则：

- 每个任务完成后等待我审查
- 解释每个重要决策
- 运行测试验证
- 提供回滚计划"
```

### 代码审查

```markdown
**快速审查**
"审查@file.ts 并提供改进建议"

**全面审查**
"深度审查@file.ts

关注：

1. 类型安全
2. 错误处理
3. 性能问题
4. 安全漏洞
5. 测试覆盖
6. 代码可维护性

对每个问题：

- 说明严重性（高/中/低）
- 解释影响
- 提供修复代码
- 给出最佳实践建议"
```

### 性能优化

```markdown
"优化@component.tsx 的性能

检查：

- 不必要的重渲染
- 大型数据结构的记忆化
- 昂贵计算的缓存
- Bundle 大小优化
- 延迟加载机会

提供：

- 当前问题诊断
- 优化后的代码
- 性能对比（预期改进）
- 测量性能的方法"
```

### Bug 修复

```markdown
"帮我修复这个 bug

错误消息：[完整错误消息]
重现步骤：[步骤]
预期行为：[描述]
实际行为：[描述]

相关文件：@file1.ts @file2.ts

请：

1. 分析根本原因
2. 解释为什么会发生
3. 提供修复方案
4. 添加测试防止回归
5. 建议预防性措施"
```

---

## 🎓 学习路径（30 天计划）

### 第 1 周：基础（每天 1-2 小时）

**Day 1-2：理解概念**

- [ ] 阅读 AI_WORKFLOW_RESEARCH_SUMMARY.md
- [ ] 观看 PRPs 演示视频
- [ ] 了解 Vibe Coding vs PRPs vs GHM

**Day 3-4：工具设置**

- [ ] 安装 Cursor 或设置 Claude Code
- [ ] 配置.cursorrules 文件
- [ ] 测试基本提示

**Day 5-7：第一个项目**

- [ ] 使用 Vibe Coding 构建简单待办事项应用
- [ ] 完整走一遍 4 阶段流程
- [ ] 部署到 Vercel

**Week 1 目标**：理解工作流，完成 1 个简单项目

### 第 2 周：结构化（每天 2-3 小时）

**Day 8-10：PRD 驱动开发**

- [ ] 学习 Structured AI Workflows
- [ ] 为 Cursor 配置 AI dev tasks 命令
- [ ] 实践 PRD → 任务 → 执行流程

**Day 11-12：测试和质量**

- [ ] 学习单元测试编写
- [ ] 添加集成测试
- [ ] 设置 CI/CD pipeline

**Day 13-14：中等项目**

- [ ] 构建博客系统（CRUD + Auth）
- [ ] 使用 Structured Workflows
- [ ] 包含完整测试

**Week 2 目标**：掌握结构化工作流，完成 1 个中等项目

### 第 3 周：生产级（每天 3-4 小时）

**Day 15-17：PRP 方法论**

- [ ] 深入学习 PRPs
- [ ] 设置验证循环
- [ ] 编写第一个完整 PRP

**Day 18-19：复杂功能**

- [ ] 实现支付集成（Stripe）
- [ ] 使用 PRP 方法
- [ ] 达到 90%+测试覆盖率

**Day 20-21：性能和安全**

- [ ] 学习性能优化技术
- [ ] 实施安全最佳实践
- [ ] 审计现有代码

**Week 3 目标**：掌握 PRPs，完成 1 个生产级功能

### 第 4 周：企业级（每天 2-3 小时）

**Day 22-24：GHM 方法**

- [ ] 学习 Gear Heart Methodology
- [ ] 设置三文件纪律
- [ ] 实施门控系统

**Day 25-26：团队协作**

- [ ] 文档化团队工作流
- [ ] 设置代码审查流程
- [ ] 创建团队知识库

**Day 27-28：综合项目**

- [ ] 使用 GHM 构建多用户系统
- [ ] 完整的 SDLC 流程
- [ ] 包含所有最佳实践

**Day 29-30：回顾和优化**

- [ ] 总结学到的经验
- [ ] 优化个人工作流
- [ ] 创建个人模板库

**Week 4 目标**：理解企业级流程，建立个人系统

---

## 🆘 常见问题速查

### Q: AI 生成的代码质量不好怎么办？

**A: 提升上下文质量**

```markdown
❌ 坏提示：
"创建一个登录页面"

✅ 好提示：
"创建登录页面

要求：

- 使用@src/components/auth/LoginForm.tsx 作为参考
- 遵循@CLAUDE.md 中的错误处理模式
- 使用 Zod 验证
- 包含单元测试
- 实施速率限制

布局参考：@src/app/(auth)/layout.tsx"
```

### Q: 如何处理大型重构？

**A: 分阶段方法**

```markdown
Phase 1: 分析（不写代码）
"分析@old-code.ts，列出：

1. 当前架构问题
2. 重构目标
3. 风险评估
4. 分步计划"

Phase 2: 准备（添加测试）
"为@old-code.ts 添加测试覆盖
确保现有行为有测试"

Phase 3: 执行（小步迭代）
"执行重构 Phase 1：

- 仅重构 X 部分
- 保持测试通过
- 不改变行为"

Phase 4: 验证（运行所有测试）
"运行完整测试套件
性能基准对比"
```

### Q: 团队如何采用 AI 工作流？

**A: 渐进式推广**

```markdown
Week 1: 试点

- 选择 1-2 个开发者
- 选择非关键功能测试
- 收集反馈

Week 2-3: 扩展

- 分享成功案例
- 创建团队模板
- 举办 workshop

Week 4+: 标准化

- 制定团队规范
- 集成到 CI/CD
- 定期回顾优化
```

### Q: 如何选择合适的工具？

**A: 决策矩阵**

```
项目类型 × 经验水平 → 推荐工具

MVP验证 × 初学者 → Bolt.new
MVP验证 × 有经验 → Vibe + Cursor

中型功能 × 初学者 → Structured Workflows + Windsurf
中型功能 × 有经验 → Structured Workflows + Cursor

生产功能 × 初学者 → PRPs + 导师审查
生产功能 × 有经验 → PRPs + Claude Code

企业项目 × 团队 → GHM + 团队选择的工具
```

### Q: 成本如何控制？

**A: 成本优化策略**

```markdown
免费组合：

- Cline (VSCode 插件)
- Gemini CLI
- GitHub Copilot Free（学生）
  总成本：$0

性价比组合：

- Cursor Pro ($20/月)
- Claude API (按需)
- Gemini 2.5 Pro (免费)
  总成本：~$20-30/月

专业组合：

- Cursor Pro ($20/月)
- Claude Pro ($20/月)
- Bolt.new Pro ($20/月)
  总成本：$60/月
```

---

## 📞 获取帮助

### GitHub Issues

- **PRPs**: <https://github.com/Wirasm/PRPs-agentic-eng/issues>
- **Vibe Coding**: <https://github.com/KhazP/vibe-coding-prompt-template/issues>

### 社区论坛

- [Reddit: r/cursor](https://reddit.com/r/cursor)
- [Reddit: r/ClaudeAI](https://reddit.com/r/ClaudeAI)
- [Discord: Cursor Community](https://discord.gg/cursor)

### 视频教程

- [PRPs 完整演示](https://www.youtube.com/watch?v=KVOZ9s1S9Gk)
- [Cursor VP 实时 Demo](https://www.youtube.com/watch?v=8QN23ZThdRY)

### 文档

- [Cursor 文档](https://cursor.sh/docs)
- [Claude Code 文档](https://docs.anthropic.com/en/docs/claude-code)
- [OpenAI Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering)

---

## ✅ 检查清单

### 项目启动清单

- [ ] 选择工作流方法（Vibe/Structured/PRPs/GHM）
- [ ] 设置开发环境（Cursor/Claude Code）
- [ ] 创建配置文件（.cursorrules 或 CLAUDE.md）
- [ ] 准备模板（PRD/任务/测试）
- [ ] 设置 Git 仓库和分支策略
- [ ] 配置 CI/CD pipeline
- [ ] 创建项目文档结构
- [ ] 定义团队规范
- [ ] 设置监控和日志
- [ ] 准备部署环境

### 功能开发清单

- [ ] 创建 PRD 或 PRP
- [ ] 生成任务列表
- [ ] 设置功能分支
- [ ] 实现代码（TDD）
- [ ] 编写单元测试
- [ ] 编写集成测试
- [ ] 本地测试通过
- [ ] 代码审查
- [ ] 更新文档
- [ ] 部署到 staging
- [ ] QA 测试
- [ ] 部署到生产

### 代码质量清单

- [ ] 类型完整（TypeScript/Python）
- [ ] 错误处理完整
- [ ] 输入验证（Zod/Pydantic）
- [ ] 测试覆盖率>70%
- [ ] Linter 零错误
- [ ] 性能优化（必要时）
- [ ] 安全检查通过
- [ ] 可访问性（Web 项目）
- [ ] 移动响应式（Web 项目）
- [ ] 文档完整

---

## 🎯 记住

### 核心原则

1. **从简单开始** - 不要一开始就用最复杂的方法
2. **持续迭代** - 工作流会随实践改进
3. **记录经验** - 建立个人知识库
4. **分享学习** - 帮助他人，加深理解

### 成功秘诀

- 🎯 明确目标和约束
- 📝 详细的上下文和文档
- ✅ 每步验证，不要大跃进
- 🔄 快速迭代，频繁反馈
- 📚 持续学习，保持更新

### 避免陷阱

- ❌ 跳过 PRD 直接编码
- ❌ 给 AI 模糊的指令
- ❌ 不审查生成的代码
- ❌ 忽略测试和文档
- ❌ 过度依赖单一工具

---

## 📈 进度追踪

建议使用以下指标追踪你的 AI 编程效率提升：

```markdown
| 指标         | 基线 | 目标 | 当前 |
| ------------ | ---- | ---- | ---- |
| 功能完成时间 | [天] | -50% | [?]  |
| Bug 率       | [%]  | -70% | [?]  |
| 测试覆盖率   | [%]  | >80% | [?]  |
| 代码审查问题 | [个] | -60% | [?]  |
| 文档完整度   | [%]  | 100% | [?]  |

每月回顾并更新
```

---

🚀 **现在就开始你的 AI 编程之旅吧！**

选择一个适合你的场景，跟随指南，开始构建！
