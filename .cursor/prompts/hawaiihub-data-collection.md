# HawaiiHub 数据采集项目提示词

## 🎯 核心工作流

### /hawaiihub.collection 流程
在聊天中依次执行：
- `/hawaiihub.sources`（审阅100个信息源质量）
- `/hawaiihub.strategy`（生成采集策略）
- `/hawaiihub.plan`（产出实施计划）
- `/hawaiihub.implement`（按模块实施）
- `/hawaiihub.validate`（验证数据质量）

---

## 📋 模块化采集提示

### 🏠 租房模块采集
```
使用 Firecrawl 学习手册中的 automated_price_tracking 项目，
采集 Zillow、Apartments.com、Rent.com 的檀香山租房信息。
要求：
1. 使用 Map API 发现所有房源 URL
2. 使用 Batch Scrape 并发采集（限制50个/次）
3. 提取结构化数据：地址、价格、户型、面积、联系方式
4. 设置1天缓存（max_age=86400000）
5. 保存为 JSON + Markdown + CSV 三种格式
6. 参考：案例03（⭐⭐）和案例06（⭐⭐⭐⭐）
```

### 🍜 餐饮模块采集
```
使用 company-data-scraper（学习手册Top1推荐项目），
采集 TripAdvisor、Yelp、OpenTable 的华人餐厅信息。
要求：
1. 使用 Search API 搜索 "Chinese restaurants Honolulu"
2. 使用 Extract API 自动提取结构化数据（餐厅名、地址、评分、菜系、价格区间、热门菜品）
3. 采集用户评论（前20条）
4. 设置7天缓存（max_age=604800000）
5. 生成餐厅推荐列表（按评分排序）
6. 参考：案例02（⭐）、案例04（⭐⭐⭐）、案例09
```

### 💼 就业模块采集
```
使用 ai-resume-job-matching（学习手册Top9推荐），
采集 Indeed、LinkedIn、ZipRecruiter 的中文职位信息。
要求：
1. 使用 Crawl API 深度爬取（max_discovery_depth=2）
2. 提取职位标题、公司、薪资范围、地点、要求、发布日期
3. 过滤中文相关职位（关键词：Chinese, Mandarin, Cantonese, bilingual）
4. 设置12小时缓存（max_age=43200000，更新频繁）
5. 生成职位分类统计（餐饮、零售、教育、医疗等）
6. 参考：案例10
```

### 📰 新闻模块采集
```
使用 deepseek-v3-trend-finder（学习手册Top6推荐） + NewsAPI，
采集夏威夷本地新闻和华人社区动态。
要求：
1. NewsAPI 搜索获取 URL 列表
2. Firecrawl Search API 智能搜索（sources=[{"type": "news"}]）
3. 使用 Summary 格式快速获取摘要（formats=["summary"]）
4. 完整文章使用 Scrape API + Markdown
5. 设置1小时缓存（max_age=3600000，实时性优先）
6. 生成每日新闻摘要（Top 10）
7. 参考：案例01（⭐）、案例07（⭐⭐⭐）、案例12（⭐⭐⭐⭐⭐）
```

### 🎉 活动模块采集
```
使用 change-detection-tutorial（学习手册Top5推荐），
采集唐人街文化广场、Hawaii Chinese Center、寺庙等活动信息。
要求：
1. 使用 Crawl API 爬取活动日历页面
2. 使用 Change Tracking 监控新活动发布
3. 提取：活动名称、时间、地点、主办方、描述、费用、报名链接
4. 设置1天缓存（max_age=86400000）
5. 生成月度活动日历（按时间排序）
6. 参考：案例05（⭐⭐⭐）、案例08
```

---

## 🚀 快速启动提示

### 快速测试单个模块
```
使用 Firecrawl MCP 工具快速测试租房模块：
1. 采集 Zillow 檀香山唐人街公寓列表（前10个）
2. 提取价格、户型、地址
3. 保存为 JSON 格式到 data/test_rental.json
4. 预估成本：$0.10
5. 预计时间：2分钟
```

### 批量采集P0模块
```
批量采集P0优先级模块（租房、餐饮、新闻）：
1. 加载 config/hawaiihub_data_sources.json
2. 过滤高质量源（data_quality: "high"）
3. 并发采集（每个模块前3个源）
4. 保存到 data/scraped/{module_id}_{timestamp}.json
5. 生成采集报告（成功/失败/成本统计）
6. 预估总成本：$1.20
7. 预计时间：15分钟
```

---

## 🎓 学习手册集成提示

### 查找相关示例项目
```
从学习手册的96个项目中，找到适合{模块名}的前3个项目：
1. 搜索项目描述关键词
2. 按技术栈匹配度排序（Python优先）
3. 按难度评级筛选（⭐⭐⭐以下）
4. 提供项目路径和快速启动命令
5. 列出关键代码片段可复用部分
```

### 应用学习手册案例
```
应用学习手册案例{案例编号}到{模块名}采集：
1. 阅读案例文档（Firecrawl学习手册/05-实战案例/HawaiiHub实战案例手册.md）
2. 复制示例代码到 scripts/{module_name}_scraper.py
3. 修改配置：API密钥、URL列表、数据模型
4. 添加错误处理和日志记录
5. 测试运行（限制5个URL）
6. 完整运行并保存数据
```

---

## 🔧 代码生成提示

### 生成采集脚本
```
基于 Firecrawl Python SDK v2，为{模块名}生成采集脚本：
要求：
1. 导入：FirecrawlApp, os, json, datetime, typing
2. 配置：从环境变量读取 FIRECRAWL_API_KEY
3. 函数签名：完整类型注解（参考学习手册规范）
4. 错误处理：try-except + 最多3次重试 + 指数退避
5. 日志记录：使用 logging 模块（INFO级别）
6. 数据验证：使用 Pydantic 模型
7. 缓存策略：根据模块设置 max_age
8. 成本监控：记录每次请求成本
9. 输出格式：JSON + Markdown + CSV
10. 文档字符串：完整的中文 docstring（参数、返回值、示例）
```

### 生成数据模型
```
为{模块名}生成 Pydantic 数据模型：
要求：
1. 继承 BaseModel
2. 所有字段添加类型注解
3. 使用 Field() 添加验证规则（min_length, max_length, regex）
4. 添加 Config 类（allow_extra=True）
5. 添加中文字段说明
6. 生成示例 JSON Schema
7. 添加数据验证方法（@validator）
8. 参考火鸟 JSON 格式规范（hawaiihub_news/火鸟新闻JSON格式规范.md）
```

---

## 📊 质量验证提示

### 数据质量检查
```
验证{模块名}采集数据质量：
检查项：
1. 数据完整性：必填字段无空值（>95%）
2. 数据准确性：URL可访问（>90%）
3. 数据时效性：发布日期在30天内（>80%）
4. 数据一致性：格式符合 Schema（100%）
5. 数据去重：基于URL或标题去重
6. 数据统计：总数、成功率、失败率、平均字段填充率
7. 生成质量报告（Markdown表格）
```

### 成本分析
```
分析{模块名}采集成本效益：
统计：
1. 总请求数（Scrape + Crawl + Map + Search + Extract）
2. 总成本（$0.01/请求）
3. 缓存命中率（%）
4. 平均响应时间（秒）
5. 失败重试次数
6. 每条数据成本（总成本/有效数据数）
7. ROI分析（数据价值vs成本）
8. 优化建议（缓存、批量、密钥轮换）
```

---

## 🔄 自动化流程提示

### 创建定时任务
```
为{模块名}创建自动化采集定时任务：
要求：
1. 使用 cron 表达式定义执行频率（P0每日、P1每周、P2每月）
2. 创建 shell 脚本 scripts/cron_{module_name}.sh
3. 添加日志记录到 logs/{module_name}_{date}.log
4. 添加错误告警（失败发送 Slack 通知）
5. 添加成功通知（采集数据摘要）
6. 创建数据备份（保留最近30天）
7. 生成每日/每周/每月采集报告
8. 参考 Makefile 中的自动化任务
```

### CI/CD集成
```
将{模块名}采集集成到 CI/CD 流程：
要求：
1. 创建 GitHub Actions workflow
2. 触发条件：定时（cron）+ 手动触发（workflow_dispatch）
3. 环境变量：从 GitHub Secrets 读取 API 密钥
4. 执行步骤：安装依赖 → 运行采集 → 验证数据 → 提交数据
5. 测试：运行 pytest 测试采集脚本
6. 部署：推送数据到生产数据库
7. 通知：Slack 通知采集结果
```

---

## 🏗️ 架构设计提示

### 设计数据采集中台
```
设计 HawaiiHub 企业级数据采集中台架构：
要求：
1. 微服务架构：API Gateway + 10个采集服务（每模块一个）
2. 消息队列：RabbitMQ 解耦采集任务
3. 缓存层：Redis 缓存采集结果（按模块设置TTL）
4. 数据库：PostgreSQL 存储结构化数据
5. 向量数据库：Pinecone 存储文章向量（RAG）
6. 监控：Sentry 错误追踪 + DataDog 性能监控
7. 部署：Docker Compose + Kubernetes
8. 绘制架构图（Mermaid）
9. 参考学习手册：案例14、案例15（⭐⭐⭐⭐⭐）
```

### 性能优化方案
```
优化{模块名}采集性能和成本：
优化点：
1. 缓存优化：实施多级缓存（内存 + Redis + CDN）
2. 并发优化：使用 asyncio + aiohttp 异步采集
3. 批量优化：Batch Scrape 替代单次 Scrape（5-10倍提速）
4. 智能采集：Change Tracking 只采集变更页面（节省50%+）
5. 密钥轮换：4个 API 密钥负载均衡（突破速率限制）
6. 代理池：避免 IP 封禁
7. 数据压缩：gzip 压缩存储（节省70%空间）
8. 增量更新：只采集新数据（基于时间戳）
9. 预计性能提升：3-5倍，成本节省：50-70%
```

---

## 📖 文档生成提示

### 生成API文档
```
为{模块名}采集脚本生成完整 API 文档：
要求：
1. 使用 Sphinx 或 MkDocs
2. 自动从 docstring 生成（支持中文）
3. 包含：函数签名、参数说明、返回值、示例代码、错误处理
4. 生成交互式 API 参考（Swagger/OpenAPI）
5. 添加使用教程（Quick Start）
6. 添加常见问题（FAQ）
7. 发布到 Read the Docs
```

### 生成数据字典
```
生成{模块名}数据字典（Data Dictionary）：
要求：
1. 表格格式：字段名、数据类型、说明、示例、是否必填、验证规则
2. 包含所有数据模型（Pydantic）
3. 标注数据来源（URL）
4. 标注更新频率
5. 标注数据质量指标（完整性、准确性、时效性）
6. 生成 ER 图（实体关系图）
7. 保存为 Markdown（docs/data-dictionary/{module_name}.md）
```

---

## 🧪 测试提示

### 编写单元测试
```
为{模块名}采集脚本编写 pytest 单元测试：
要求：
1. 测试文件：tests/test_{module_name}_scraper.py
2. 使用 Mock 模拟 Firecrawl API（避免实际请求）
3. 测试用例：
   - test_scrape_success：成功采集
   - test_scrape_timeout：超时重试
   - test_scrape_invalid_url：无效URL处理
   - test_data_validation：数据验证
   - test_cache_hit：缓存命中
   - test_batch_scrape：批量采集
4. 覆盖率：>80%
5. 参考学习手册：Python 规范（类型注解、docstring）
```

### 编写E2E测试
```
编写{模块名}端到端（E2E）冒烟测试：
要求：
1. 使用真实 API 密钥（测试环境）
2. 采集1-2个真实URL
3. 验证：数据保存成功、格式正确、字段完整
4. 断言：至少返回1条有效数据
5. 成本预算：<$0.05
6. 超时设置：60秒
7. 失败告警：发送 Slack 通知
```

---

## 🎯 SpecKit 流程应用

### /hawaiihub.constitution（宪章审阅）
```
审阅 HawaiiHub 数据采集项目宪章：
1. 项目使命：为夏威夷华人社区提供全面、准确、及时的本地信息
2. 核心价值观：
   - 数据质量第一（准确性 > 数量）
   - 用户隐私保护（遵守robots.txt、不采集个人信息）
   - 成本可控（<$200/月）
   - 开源透明（代码开源、文档完整）
3. 技术原则：
   - 优先使用 Firecrawl 云 API（不自建）
   - 遵循 Firecrawl 学习手册最佳实践
   - 代码规范：Python PEP 8、类型注解、中文 docstring
   - 测试驱动：单元测试 + E2E 测试
4. 约束条件：
   - 预算限制：$200/月
   - 时间限制：4周完成首次采集
   - 人力限制：AI Agent 团队（初级、中级、高级、专家）
5. 修订建议：{填写修订意见}
```

### /hawaiihub.specify（生成规范草案）
```
生成{模块名}数据采集规范草案：
包含章节：
1. 模块概述（业务需求、数据价值）
2. 数据源清单（URL、质量评级、中文友好度、更新频率）
3. 数据模型（Pydantic Schema + JSON Schema）
4. 采集策略（API选择、缓存策略、成本估算）
5. 技术实现（代码示例、错误处理、日志记录）
6. 质量标准（完整性 >95%、准确性 >90%、时效性 <24h）
7. 测试计划（单元测试 + E2E 测试）
8. 部署方案（定时任务 + CI/CD）
9. 监控告警（Sentry + DataDog + Slack）
10. 参考资料（学习手册案例、示例项目）
保存为：openspec/specs/{module_name}-data-collection.md
```

### /hawaiihub.plan（产出实施计划）
```
生成{模块名}采集实施计划：
时间线：
- Week 1 Day 1-2：环境配置、学习手册学习
- Week 1 Day 3-4：编写采集脚本、单元测试
- Week 1 Day 5：E2E 测试、数据验证
- Week 2 Day 1-2：定时任务配置、CI/CD 集成
- Week 2 Day 3-4：监控告警、文档编写
- Week 2 Day 5：Code Review、部署上线
- Week 3-4：数据积累、质量优化

里程碑：
- M1（Day 3）：首次成功采集5个URL
- M2（Day 7）：完整采集所有高质量源
- M3（Day 10）：定时任务稳定运行
- M4（Day 14）：数据质量达标（完整性>95%）

交付物：
- 采集脚本（scripts/{module_name}_scraper.py）
- 数据模型（src/models/{module_name}.py）
- 单元测试（tests/test_{module_name}_scraper.py）
- E2E 测试（tests/e2e/test_{module_name}_e2e.py）
- 定时任务（scripts/cron_{module_name}.sh）
- 文档（docs/{module_name}/）
- 采集报告（reports/{module_name}_report.md）
```

### /hawaiihub.tasks（任务分解）
```
分解{模块名}采集任务（按 Agent 等级分配）：

🥉 初级 Agent 任务：
- [ ] Task 1.1：配置开发环境（Python、Firecrawl SDK）
- [ ] Task 1.2：测试 API 密钥（运行 test_api_keys.py）
- [ ] Task 1.3：采集单个 URL（使用 Scrape API）
- [ ] Task 1.4：保存数据为 JSON

🥈 中级 Agent 任务：
- [ ] Task 2.1：使用 Map API 发现所有 URL
- [ ] Task 2.2：使用 Batch Scrape 批量采集（10个URL）
- [ ] Task 2.3：数据清洗和验证（Pydantic）
- [ ] Task 2.4：保存数据为 JSON + Markdown + CSV
- [ ] Task 2.5：编写单元测试（pytest）

🥇 高级 Agent 任务：
- [ ] Task 3.1：使用 Extract API 自动提取结构化数据
- [ ] Task 3.2：实现错误处理和重试机制
- [ ] Task 3.3：实现成本监控（记录每次请求）
- [ ] Task 3.4：实现缓存策略（Redis）
- [ ] Task 3.5：编写 E2E 测试
- [ ] Task 3.6：创建定时任务（cron）

💎 专家 Agent 任务：
- [ ] Task 4.1：设计微服务架构（Mermaid 图）
- [ ] Task 4.2：实现 Change Tracking 监控
- [ ] Task 4.3：集成 CI/CD（GitHub Actions）
- [ ] Task 4.4：配置监控告警（Sentry + Slack）
- [ ] Task 4.5：编写完整文档（API 文档 + 数据字典）
- [ ] Task 4.6：Code Review 和上线部署
```

### /hawaiihub.implement（按任务实施）
```
实施{模块名}采集任务 {任务编号}：
1. 查看任务描述和验收标准
2. 查找相关学习手册章节（PDF 页码）
3. 查找参考项目代码（96个项目中）
4. 编写代码（遵循 Python 规范）
5. 编写测试（pytest）
6. 运行测试（pytest -v）
7. 提交代码（Conventional Commits）
8. 更新任务状态（✅ 已完成）
9. 生成实施报告（代码变更、测试结果、遇到的问题、解决方案）
```

---

## 🎨 UI/数据可视化提示

### 生成数据仪表板
```
为{模块名}生成数据可视化仪表板：
要求：
1. 使用 Streamlit 或 Plotly Dash
2. 图表类型：
   - 折线图：每日采集数据趋势
   - 柱状图：数据源质量对比
   - 饼图：数据分类占比
   - 地图：地理位置分布（租房、餐厅）
   - 表格：最新数据列表（Top 20）
3. 交互功能：时间范围筛选、数据源筛选、关键词搜索
4. 实时更新：每小时刷新
5. 导出功能：下载为 CSV、JSON、PDF
6. 部署：Streamlit Cloud 或 Vercel
```

---

## 💬 Slack 通知提示

### 发送采集成功通知
```
发送{模块名}采集成功 Slack 通知：
消息内容：
📊 {模块名}采集成功！
- 采集时间：{timestamp}
- 数据源数量：{source_count}
- 成功采集：{success_count} 条
- 失败：{failure_count} 条
- 成功率：{success_rate}%
- 总成本：${total_cost}
- 新增数据：{new_data_count} 条
- 数据质量：完整性 {completeness}%，准确性 {accuracy}%
查看详情：{report_url}
```

### 发送采集失败告警
```
发送{模块名}采集失败 Slack 告警：
消息内容：
🚨 {模块名}采集失败！
- 失败时间：{timestamp}
- 错误类型：{error_type}
- 错误消息：{error_message}
- 失败URL：{failed_url}
- 重试次数：{retry_count}
- 建议操作：{suggested_action}
查看日志：{log_url}
立即修复：{fix_url}
```

---

## 🔐 安全与合规提示

### 检查采集合规性
```
检查{模块名}采集是否符合安全合规要求：
检查项：
1. ✅ robots.txt：遵守网站爬取规则
2. ✅ 速率限制：不超过网站速率限制（max 1 req/sec）
3. ✅ User-Agent：设置合理的 User-Agent
4. ✅ 个人信息：不采集敏感个人信息（电话号码脱敏）
5. ✅ 版权：遵守内容版权（标注来源）
6. ✅ API 密钥：不硬编码、不提交到 Git
7. ✅ 数据存储：加密存储敏感数据
8. ✅ 访问控制：数据库访问权限控制
9. ✅ 审计日志：记录所有采集操作
10. ✅ 数据保留：定期清理过期数据（30天）
生成合规报告：compliance/{module_name}_compliance_report.md
```

---

## 📞 获取帮助提示

### 查找学习手册资源
```
查找{问题描述}相关的学习手册资源：
搜索范围：
1. Firecrawl学习手册/README.md（总览）
2. Firecrawl学习手册/01-基础入门/（核心教程）
3. Firecrawl学习手册/03-API参考/（API 文档）
4. Firecrawl学习手册/05-实战案例/（96个项目）
5. Firecrawl学习手册/🎓Agent团队培训分类方案.md（培训方案）
输出：
- 相关章节（PDF 页码）
- 相关案例（案例编号、难度评级）
- 相关项目（项目名称、路径）
- 代码示例（关键代码片段）
```

### 诊断采集错误
```
诊断{模块名}采集错误：
步骤：
1. 查看错误日志（logs/{module_name}_{date}.log）
2. 分析错误类型（Timeout、RateLimitError、ValidationError等）
3. 检查 API 密钥是否有效（test_api_keys.py）
4. 检查网络连接（ping URL）
5. 检查 URL 是否可访问（curl -I URL）
6. 检查数据格式是否变化（对比历史数据）
7. 查找相似错误案例（GitHub Issues、Discord）
8. 生成诊断报告（错误描述、可能原因、解决方案、参考资料）
保存为：reports/errors/{module_name}_error_diagnosis_{timestamp}.md
```

---

## 📝 提交规范提示

### 生成规范提交信息
```
为{模块名}采集任务生成 Conventional Commits 格式的提交信息：
格式：<type>(<scope>): <subject>

类型（type）：
- feat：新功能（如：新增租房模块采集）
- fix：Bug 修复（如：修复数据验证错误）
- docs：文档更新（如：更新 API 文档）
- refactor：代码重构（如：优化批量采集逻辑）
- perf：性能优化（如：实现缓存策略）
- test：测试相关（如：添加单元测试）
- chore：构建/工具链（如：更新依赖）

示例：
feat(rental): 添加 Zillow 租房信息采集功能
fix(dining): 修复 Yelp 评分解析错误
docs(api): 更新数据模型文档
refactor(scraper): 重构错误处理逻辑为装饰器
perf(cache): 实现 Redis 缓存，节省 50% API 成本
test(rental): 添加租房模块单元测试（覆盖率 85%）

提交信息：
{生成的提交信息}

影响范围：
- 新增文件：{new_files}
- 修改文件：{modified_files}
- 删除文件：{deleted_files}

迁移指南：
{如有 breaking changes，提供迁移指南}
```

---

## 🎉 总结

这些提示词覆盖了 **HawaiiHub 100个信息源采集项目**的完整生命周期：

- 🎯 工作流：从源评审到实施验证
- 📋 模块化：10大模块专项采集方案
- 🚀 快速启动：单模块测试、批量采集
- 🎓 学习集成：96个项目、15个案例
- 🔧 代码生成：采集脚本、数据模型
- 📊 质量验证：数据质量、成本分析
- 🔄 自动化：定时任务、CI/CD
- 🏗️ 架构设计：微服务、性能优化
- 📖 文档生成：API 文档、数据字典
- 🧪 测试：单元测试、E2E 测试
- 🎯 SpecKit：宪章、规范、计划、任务、实施
- 🎨 可视化：数据仪表板
- 💬 通知：Slack 成功/失败通知
- 🔐 安全合规：合规性检查
- 📝 提交规范：Conventional Commits

**使用方法**：
在 Cursor 聊天中直接输入提示词，例如：
- "使用 /hawaiihub.sources 审阅100个信息源质量"
- "为租房模块生成采集脚本"
- "分析餐饮模块采集成本效益"

**下一步**：
将这些提示词保存到 `.cursor/prompts/` 目录，Cursor 会自动识别为自定义命令。
