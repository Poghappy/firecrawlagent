# Agent 团队角色分工指南

**项目**: FireShot
**更新日期**: 2025-10-28
**版本**: v1.0.0

---

## 🎭 角色概览

FireShot 项目采用多 Agent 协作模式，每个 Agent 专注于特定领域。

### 团队结构

```
HawaiiHub AI Team
│
├── 📋 Product Agent（产品规划）
│   └── 创建变更提案、定义需求
│
├── 💻 Development Agent（核心开发）
│   ├── Backend Agent（后端/爬虫）
│   └── Data Agent（数据处理）
│
├── 🧪 Quality Agent（质量保证）
│   └── 测试、验证、代码审查
│
├── 📚 Documentation Agent（文档）
│   └── 编写文档、维护知识库
│
└── 🚀 DevOps Agent（运维）
    └── 部署、监控、性能优化
```

---

## 📋 Product Agent（产品规划 Agent）

### 核心职责

负责将业务需求转化为 OpenSpec 变更提案。

### 主要工作

1. **需求分析**
   - 收集用户需求
   - 分析业务价值
   - 确定优先级（P0/P1/P2）

2. **创建变更提案**
   - 使用 `/openspec:proposal` 创建提案
   - 编写 proposal.md（背景、目标、价值）
   - 定义 tasks.md（任务清单）
   - 编写规范差异（Delta）

3. **审查和批准**
   - 审查开发 Agent 的实施结果
   - 确认功能符合业务需求
   - 批准归档

### 工作流程

```
用户需求
    ↓
需求分析（评估可行性、价值）
    ↓
创建 OpenSpec 提案
    ↓
    /openspec:proposal <功能描述>
    ↓
审查生成的提案
    ↓
openspec show <变更名>
    ↓
批准 / 要求修改
    ↓
交给 Development Agent
```

### 示例任务

**场景**: 用户要求"添加夏威夷租房信息聚合功能"

**Product Agent 的工作**:

```
1. 分析需求
   - 目标用户：在夏威夷找房的华人
   - 核心价值：节省找房时间 50%
   - 数据源：Craigslist Hawaii
   - 更新频率：每 6 小时

2. 创建提案
   对 AI 说：
   "创建一个 OpenSpec 变更提案：添加夏威夷租房信息爬虫

   要求：
   - 从 Craigslist Hawaii 采集租房信息
   - 数据包含：标题、价格、位置、卧室数、浴室数
   - 每天更新 4 次
   - 价格范围：$500-$5000
   - 去重：基于 URL"

3. 审查提案
   openspec show add-rental-scraper

4. 验证规范
   - 检查 Requirement 是否明确
   - 检查 Scenario 是否完整
   - 检查任务清单是否具体
```

### 关键技能

- ✅ 理解业务需求
- ✅ 编写清晰的规范文档
- ✅ 使用 Requirement 和 Scenario 表达需求
- ✅ 定义可量化的验收标准

### 常用命令

```bash
# 创建提案
/openspec:proposal <功能描述>

# 查看提案
openspec show <变更名>

# 验证提案
openspec validate <变更名>

# 查看所有变更
openspec list
```

---

## 💻 Development Agent（开发 Agent）

### 核心职责

实施 OpenSpec 变更提案，编写代码和测试。

### 子角色

#### Backend Agent（后端/爬虫开发）
- 实现 Firecrawl 爬虫逻辑
- 处理 API 集成
- 实现错误处理和重试

#### Data Agent（数据处理）
- 实现数据模型（Pydantic）
- 数据清洗和验证
- 数据存储和查询

### 主要工作

1. **审查提案**
   ```bash
   openspec show <变更名>
   openspec validate <变更名>
   ```

2. **实施变更**
   ```
   /openspec:apply <变更名>
   ```

3. **编写代码**
   - 遵循 `openspec/project.md` 的编码规范
   - 遵循 `.cursorrules` 的代码风格
   - 实现 tasks.md 中的每个任务

4. **测试验证**
   ```bash
   pytest tests/
   pytest --cov
   ```

5. **提交代码**
   ```bash
   git add .
   git commit -m "feat(scraper): 添加租房信息爬虫"
   ```

6. **归档变更**
   ```bash
   openspec archive <变更名> --yes
   ```

### 工作流程

```
接收提案
    ↓
审查规范（openspec show）
    ↓
提出问题 / 批准
    ↓
实施变更（/openspec:apply）
    ↓
编写代码（按 tasks.md 顺序）
    ↓
编写测试
    ↓
运行测试（pytest）
    ↓
提交代码（git commit）
    ↓
归档变更（openspec archive）
```

### 示例任务

**场景**: 实施"添加租房信息爬虫"

**Backend Agent 的工作**:

```python
# 1. 创建数据模型（models/rental.py）
from pydantic import BaseModel, HttpUrl, Field
from typing import Optional

class Rental(BaseModel):
    """租房信息数据模型"""
    title: str = Field(..., min_length=1, max_length=200)
    url: HttpUrl
    price: float = Field(..., gt=0)
    location: str
    bedrooms: int = Field(..., ge=0)
    bathrooms: float = Field(..., ge=0)
    description: Optional[str] = None
    posted_date: str  # ISO 8601
    source: str = "craigslist_hawaii"

# 2. 实现爬取逻辑（scrapers/craigslist.py）
from firecrawl import FirecrawlApp
import os

def scrape_craigslist_rentals(max_results: int = 50) -> list[Rental]:
    """
    从 Craigslist Hawaii 爬取租房信息

    Args:
        max_results: 最大结果数

    Returns:
        租房信息列表
    """
    app = FirecrawlApp(api_key=os.getenv("FIRECRAWL_API_KEY"))

    # 爬取列表页
    result = app.scrape(
        url="https://honolulu.craigslist.org/search/apa",
        formats=["markdown"],
        only_main_content=True
    )

    # 提取租房链接
    links = extract_rental_links(result.markdown)

    # 批量爬取详情
    rentals = batch_scrape_details(links[:max_results])

    return rentals

# 3. 编写测试（tests/test_rental.py）
import pytest
from models.rental import Rental

def test_rental_model_validation():
    """测试：租房数据模型验证"""
    rental = Rental(
        title="2BR/1BA Apartment",
        url="https://honolulu.craigslist.org/oah/apa/123456.html",
        price=1500.0,
        location="Honolulu",
        bedrooms=2,
        bathrooms=1.0,
        posted_date="2025-10-28T10:00:00Z",
        source="craigslist_hawaii"
    )

    assert rental.title == "2BR/1BA Apartment"
    assert rental.price == 1500.0
```

### 关键技能

- ✅ 理解和实施 OpenSpec 规范
- ✅ 编写符合项目标准的代码
- ✅ 完整的错误处理和日志记录
- ✅ 编写单元测试和集成测试
- ✅ 使用 Git Conventional Commits

### 常用命令

```bash
# 实施变更
/openspec:apply <变更名>

# 运行测试
pytest tests/
pytest --cov

# 代码格式化
ruff format .
ruff check --fix .

# 类型检查
mypy src/

# 提交代码
git commit -m "feat(scraper): 添加租房信息爬虫"

# 归档变更
openspec archive <变更名> --yes
```

---

## 🧪 Quality Agent（质量保证 Agent）

### 核心职责

验证实施结果符合 OpenSpec 规范，确保代码质量。

### 主要工作

1. **规范符合度检查**
   - 对照 `specs/` 文件验证功能
   - 检查每个 Scenario 是否都有对应测试
   - 验证边界条件和错误处理

2. **代码质量审查**
   ```bash
   ruff check .
   mypy src/
   pytest --cov --cov-report=html
   ```

3. **性能测试**
   - 爬取速度测试
   - 内存使用监控
   - 成本估算验证

4. **回归测试**
   - 确保新功能不影响现有功能
   - 运行完整测试套件

### 工作流程

```
开发完成通知
    ↓
读取规范（openspec/specs/）
    ↓
对照规范编写测试用例
    ↓
运行测试套件
    ↓
代码质量检查（ruff, mypy）
    ↓
性能测试
    ↓
问题反馈 / 批准发布
```

### 测试检查清单

#### 功能测试
- [ ] 所有 Requirement 都有对应功能实现
- [ ] 所有 Scenario 都有对应测试用例
- [ ] 边界条件测试（空值、异常值）
- [ ] 错误处理测试（超时、网络错误）

#### 代码质量
- [ ] 所有函数有类型注解
- [ ] 所有函数有中文 docstring
- [ ] 无 Ruff 告警
- [ ] 无 mypy 类型错误
- [ ] 测试覆盖率 > 80%

#### 性能
- [ ] 爬取速度符合预期（< 5 秒/页）
- [ ] 内存使用合理（< 500MB）
- [ ] 成本在预算内（< $10/天）

### 示例任务

**场景**: 验证"租房信息爬虫"

**Quality Agent 的工作**:

```python
# tests/test_rental_integration.py
import pytest
from scrapers.craigslist import scrape_craigslist_rentals
from models.rental import Rental

def test_scrape_rentals_success():
    """测试：成功爬取租房信息"""
    rentals = scrape_craigslist_rentals(max_results=10)

    assert len(rentals) > 0
    assert len(rentals) <= 10

    for rental in rentals:
        assert isinstance(rental, Rental)
        assert rental.price > 0
        assert rental.bedrooms >= 0

def test_price_filter():
    """测试：价格范围过滤"""
    rentals = scrape_craigslist_rentals(
        max_results=50,
        min_price=500,
        max_price=5000
    )

    for rental in rentals:
        assert 500 <= rental.price <= 5000

def test_error_handling():
    """测试：错误处理机制"""
    # Mock 网络错误
    with pytest.raises(NetworkError):
        scrape_craigslist_rentals(url="https://invalid.url")
```

### 关键技能

- ✅ 编写全面的测试用例
- ✅ 使用 pytest fixtures 和 mocks
- ✅ 性能分析和优化
- ✅ 代码审查最佳实践

### 常用命令

```bash
# 运行测试
pytest tests/ -v

# 测试覆盖率
pytest --cov=src --cov-report=html

# 代码质量检查
ruff check .
mypy src/

# 性能分析
pytest tests/ --profile
```

---

## 📚 Documentation Agent（文档 Agent）

### 核心职责

维护项目文档、编写使用指南、知识库管理。

### 主要工作

1. **更新规范文档**
   - 补充 `openspec/specs/` 中的规范
   - 编写实现参考代码
   - 维护数据模型文档

2. **编写使用指南**
   - 快速开始指南
   - API 参考文档
   - 故障排查指南

3. **知识库管理**
   - 整理常见问题（FAQ）
   - 记录最佳实践
   - 维护示例代码库

4. **变更日志维护**
   - 更新 CHANGELOG.md
   - 记录重要变更
   - 编写发布说明

### 工作流程

```
新功能发布
    ↓
阅读 OpenSpec 规范
    ↓
编写用户文档
    ↓
编写 API 参考
    ↓
更新 CHANGELOG
    ↓
审查和发布
```

### 文档模板

#### API 文档模板

```markdown
# Rental API 参考

## scrape_craigslist_rentals()

从 Craigslist Hawaii 爬取租房信息。

### 签名

```python
def scrape_craigslist_rentals(
    max_results: int = 50,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None
) -> list[Rental]:
```

### 参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| max_results | int | 50 | 最大结果数 |
| min_price | float | None | 最低价格 |
| max_price | float | None | 最高价格 |

### 返回值

返回 `list[Rental]`，每个元素包含：
- title: 标题
- price: 价格
- location: 位置
- ...

### 示例

```python
from scrapers.craigslist import scrape_craigslist_rentals

# 爬取前 10 条租房信息
rentals = scrape_craigslist_rentals(max_results=10)

# 价格过滤
rentals = scrape_craigslist_rentals(
    max_results=50,
    min_price=500,
    max_price=5000
)
```

### 错误处理

可能抛出的异常：
- `NetworkError`: 网络连接失败
- `RateLimitError`: 超出速率限制
- `ValidationError`: 数据验证失败
```

### 关键技能

- ✅ 清晰的技术写作
- ✅ Markdown 熟练使用
- ✅ 代码示例编写
- ✅ 文档结构设计

---

## 🚀 DevOps Agent（运维 Agent）

### 核心职责

部署、监控、性能优化、成本控制。

### 主要工作

1. **部署管理**
   - CI/CD 配置
   - 环境变量管理
   - 密钥轮换

2. **监控和告警**
   - 爬取成功率监控
   - 成本监控（每日 API 使用量）
   - 错误率告警

3. **性能优化**
   - 缓存策略优化
   - 并发处理优化
   - 数据库查询优化

4. **成本控制**
   - API 使用量分析
   - 缓存命中率优化
   - 资源使用优化

### 监控指标

```python
# 核心性能指标
METRICS = {
    "scraping": {
        "success_rate": 0.95,        # 成功率 > 95%
        "avg_response_time": 5.0,    # 平均响应时间 < 5秒
        "cache_hit_rate": 0.60,      # 缓存命中率 > 60%
    },
    "cost": {
        "daily_budget": 10.0,        # 每日预算 $10
        "monthly_budget": 200.0,     # 每月预算 $200
        "cost_per_request": 0.01,    # 每次请求成本
    },
    "quality": {
        "data_accuracy": 0.95,       # 数据准确率 > 95%
        "dedup_rate": 0.99,          # 去重率 > 99%
    }
}
```

### 关键技能

- ✅ 系统监控和告警
- ✅ 性能分析和优化
- ✅ 成本控制
- ✅ CI/CD 配置

---

## 🤝 协作流程示例

### 完整功能开发流程

```
Product Agent: 创建提案
    ↓
    /openspec:proposal 添加租房信息爬虫
    ↓
Development Agent: 审查提案
    ↓
    openspec show add-rental-scraper
    ↓（提出问题）
Product Agent: 完善提案
    ↓（批准）
Development Agent: 实施变更
    ↓
    /openspec:apply add-rental-scraper
    ↓
Quality Agent: 测试验证
    ↓
    pytest tests/ --cov
    ↓（发现问题）
Development Agent: 修复问题
    ↓（测试通过）
Documentation Agent: 编写文档
    ↓
DevOps Agent: 部署上线
    ↓
Product Agent: 归档变更
    ↓
    openspec archive add-rental-scraper --yes
```

---

## 📊 角色分工表

| 角色 | 主要工具 | 关键输出 | 时间占比 |
|------|---------|---------|---------|
| Product Agent | `/openspec:proposal` | 变更提案、规范文档 | 20% |
| Development Agent | `/openspec:apply` | 代码、测试 | 50% |
| Quality Agent | `pytest` | 测试报告、质量报告 | 15% |
| Documentation Agent | Markdown | 文档、示例 | 10% |
| DevOps Agent | 监控工具 | 性能报告、成本报告 | 5% |

---

## ✅ 团队协作最佳实践

1. **Daily Standup（每日站会）**
   - 分享昨天完成的工作
   - 今天的计划
   - 遇到的阻碍

2. **Weekly Planning（每周规划）**
   - 审查 `openspec list` 的活动变更
   - 分配任务给各 Agent
   - 确定优先级

3. **Code Review（代码审查）**
   - 所有代码提交前必须审查
   - 至少 1 个其他 Agent 批准
   - 检查符合 OpenSpec 规范

4. **Knowledge Sharing（知识分享）**
   - 每周分享一个最佳实践
   - 记录到 Documentation

---

**维护者**: HawaiiHub AI Team
**版本**: v1.0.0
**最后更新**: 2025-10-28
