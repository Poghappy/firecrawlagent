# 🔑 Firecrawl API 密钥配置指南

> **创建时间**: 2025-10-27
> **密钥数量**: 3 个
> **状态**: 待验证

---

## 📋 你的 API 密钥

你已经提供了 **3 个 Firecrawl API 密钥**，这非常好！可以用于**密钥轮换**和**故障转移**。

### 密钥列表

| 序号 | 密钥类型 | 密钥 ID | 用途 |
|------|---------|---------|------|
| 1 | **主密钥** | `fc-31eb...eea8` | 日常使用 |
| 2 | **备用密钥 1** | `fc-0085...fb28` | 故障转移 |
| 3 | **备用密钥 2** | `fc-9eb3...4c5a` | 密钥轮换 |

### 安全提示 ⚠️

**绝不要**将完整的 API 密钥：
- ❌ 提交到 Git 仓库
- ❌ 硬编码到代码中
- ❌ 分享到公开渠道
- ❌ 打印到日志中

**必须**：
- ✅ 使用环境变量存储
- ✅ 添加 `.env` 到 `.gitignore`
- ✅ 定期轮换密钥
- ✅ 监控使用情况

---

## ⚡ 快速开始（5 分钟）

### 步骤 1: 创建 .env 文件

```bash
# 在项目根目录创建 .env 文件
cd /Users/zhiledeng/Downloads/FireShot

# 复制模板
cp env.template .env

# .env 文件已包含你的密钥配置！
```

**`.env` 文件内容**（已自动配置）:

```bash
# 主密钥
FIRECRAWL_API_KEY=fc-31ebbe4647b84fdc975318d372eebea8

# 备用密钥
FIRECRAWL_API_KEY_BACKUP_1=fc-00857d82ec534e8598df1bae9af9fb28
FIRECRAWL_API_KEY_BACKUP_2=fc-9eb380b0dec74d6ebb6c756ee4de4c5a

# 其他配置
FIRECRAWL_API_URL=https://api.firecrawl.dev
FIRECRAWL_TIMEOUT=60
FIRECRAWL_DAILY_BUDGET=10.0
```

### 步骤 2: 添加 .gitignore

```bash
# 创建 .gitignore 文件（如果还没有）
cat >> .gitignore << 'EOF'

# 环境变量文件
.env
.env.*
!.env.example
!env.template

# 密钥和凭证
*.key
*.pem
credentials.json

# 缓存
cache/
__pycache__/
*.pyc
EOF
```

### 步骤 3: 安装依赖

```bash
# 安装 Firecrawl SDK
pip install firecrawl-py python-dotenv requests
```

### 步骤 4: 测试密钥

```bash
# 运行测试脚本
python test_api_keys.py
```

预期输出：

```
============================================================
🔥 Firecrawl API 密钥测试
============================================================
测试 URL: https://www.firecrawl.dev/
密钥数量: 3
测试时间: 2025-10-27 10:30:00

🔍 测试 main (fc-31eb...eea8)...
✅ main 有效！
   耗时: 1.85秒
   内容长度: 5432 字符
   标题: Firecrawl - Turn websites into LLM-ready data

🔍 测试 backup_1 (fc-0085...fb28)...
✅ backup_1 有效！
   耗时: 1.92秒
   内容长度: 5432 字符

🔍 测试 backup_2 (fc-9eb3...4c5a)...
✅ backup_2 有效！
   耗时: 1.88秒
   内容长度: 5432 字符

============================================================
📊 测试总结
============================================================

总计: 3 个密钥
✅ 有效: 3
❌ 无效: 0
⚠️ 错误: 0
```

### 步骤 5: 运行快速示例

```bash
# 运行快速开始示例
python quick_start.py
```

这将演示：
1. ✅ 基础爬取
2. ✅ 批量爬取
3. ✅ 搜索功能
4. ✅ 缓存优化

---

## 🚀 使用示例

### Python 代码

```python
import os
from dotenv import load_dotenv
from firecrawl import FirecrawlApp

# 加载环境变量
load_dotenv()

# 初始化客户端（自动从环境变量读取密钥）
app = FirecrawlApp(api_key=os.getenv('FIRECRAWL_API_KEY'))

# 爬取网站
result = app.scrape(
    url="https://www.hawaiinewsnow.com/",
    formats=['markdown'],
    onlyMainContent=True,
    maxAge=3600000  # 使用 1 小时缓存
)

print(f"标题: {result.get('title')}")
print(f"内容: {result.get('markdown')[:200]}...")
```

### TypeScript/Node.js 代码

```typescript
import Firecrawl from '@mendable/firecrawl-js';
import * as dotenv from 'dotenv';

// 加载环境变量
dotenv.config();

// 初始化客户端
const app = new Firecrawl({ apiKey: process.env.FIRECRAWL_API_KEY });

// 爬取网站
const result = await app.scrapeUrl('https://www.hawaiinewsnow.com/', {
  formats: ['markdown'],
  onlyMainContent: true,
  maxAge: 3600000 // 1 小时缓存
});

console.log('标题:', result.title);
console.log('内容:', result.markdown.slice(0, 200) + '...');
```

---

## 🔐 密钥轮换策略

### 为什么需要多个密钥？

1. **故障转移**: 如果主密钥失效，自动切换到备用密钥
2. **负载均衡**: 分散 API 请求到多个密钥
3. **速率限制**: 突破单个密钥的速率限制
4. **安全性**: 定期轮换密钥，提高安全性

### 自动轮换配置

```python
# config/firecrawl.py
import os
from datetime import datetime, timedelta
from firecrawl import FirecrawlApp

class FirecrawlConfig:
    """Firecrawl 配置管理（支持密钥轮换）"""

    # 所有可用密钥
    API_KEYS = [
        os.getenv('FIRECRAWL_API_KEY'),
        os.getenv('FIRECRAWL_API_KEY_BACKUP_1'),
        os.getenv('FIRECRAWL_API_KEY_BACKUP_2'),
    ]

    # 当前使用的密钥索引
    current_key_index = 0

    # 轮换时间（每 24 小时）
    rotation_interval = timedelta(hours=24)
    last_rotation = datetime.now()

    @classmethod
    def get_api_key(cls) -> str:
        """获取当前 API 密钥"""
        # 检查是否需要轮换
        if datetime.now() - cls.last_rotation > cls.rotation_interval:
            cls.rotate_key()

        return cls.API_KEYS[cls.current_key_index]

    @classmethod
    def rotate_key(cls):
        """轮换到下一个密钥"""
        cls.current_key_index = (cls.current_key_index + 1) % len(cls.API_KEYS)
        cls.last_rotation = datetime.now()
        print(f"🔄 已轮换到密钥 #{cls.current_key_index + 1}")

    @classmethod
    def get_client(cls) -> FirecrawlApp:
        """获取 Firecrawl 客户端"""
        return FirecrawlApp(api_key=cls.get_api_key())

# 使用示例
app = FirecrawlConfig.get_client()
result = app.scrape("https://example.com")
```

---

## 💰 成本监控

### 检查 API 使用量

根据 [Firecrawl 官方定价](https://www.firecrawl.dev)：

- **Scrape**: ~$0.005/页
- **Search**: ~$0.01/次
- **Crawl**: ~$0.004/页（批量折扣）

### 预算建议

| 使用场景 | 每日预算 | 每月预算 | 预估用量 |
|----------|---------|---------|---------|
| **开发测试** | $2-5 | $50-100 | 500-1000 页/天 |
| **生产环境（MVP）** | $5-10 | $150-300 | 1000-2000 页/天 |
| **增长期** | $10-20 | $300-600 | 2000-4000 页/天 |

### 成本优化技巧

1. ✅ **启用缓存**: 节省 50-70% 成本
2. ✅ **批量处理**: 使用 `batch_scrape` 获得折扣
3. ✅ **内容过滤**: `onlyMainContent=True` 减少数据传输
4. ✅ **定时任务**: 错峰执行（夜间）
5. ✅ **URL 去重**: 避免重复爬取

---

## 🔍 故障排查

### 问题 1: `Authentication failed` 错误

**原因**: API 密钥无效或未正确配置

**解决**:

```bash
# 1. 检查环境变量
python -c "import os; from dotenv import load_dotenv; load_dotenv(); print(os.getenv('FIRECRAWL_API_KEY'))"

# 2. 运行测试脚本
python test_api_keys.py

# 3. 确认 .env 文件存在且格式正确
cat .env | grep FIRECRAWL_API_KEY
```

### 问题 2: `Rate limit exceeded` 错误

**原因**: 超过 API 速率限制

**解决**:

```python
# 使用密钥轮换
from config.firecrawl import FirecrawlConfig

app = FirecrawlConfig.get_client()  # 自动轮换密钥
result = app.scrape(url)
```

### 问题 3: 成本过高

**原因**: 未优化请求

**解决**:

```python
# 1. 启用缓存
result = app.scrape(url, maxAge=3600000)

# 2. 使用批量接口
results = app.batch_scrape(urls)

# 3. 过滤内容
result = app.scrape(url, onlyMainContent=True)
```

---

## 📚 相关文档

### 必读文档

1. **FIRECRAWL_CLOUD_SETUP_GUIDE.md** - 10 分钟快速配置
2. **FIRECRAWL_CLOUD_API_RULES.md** - 完整使用规范
3. **FIRECRAWL_QUICK_INDEX.md** - 快速索引

### 官方资源

- 🌐 [Firecrawl 官网](https://www.firecrawl.dev/)
- 📚 [官方文档](https://docs.firecrawl.dev/)
- 💬 [Discord 社区](https://discord.gg/firecrawl)
- 🐙 [GitHub 仓库](https://github.com/mendableai/firecrawl) (65K ⭐)

---

## ✅ 检查清单

### 配置检查

- [ ] ✅ 已创建 `.env` 文件
- [ ] ✅ 已配置 3 个 API 密钥
- [ ] ✅ 已添加 `.env` 到 `.gitignore`
- [ ] ✅ 已安装 `firecrawl-py` 依赖
- [ ] ✅ 已运行 `test_api_keys.py` 验证密钥
- [ ] ✅ 已运行 `quick_start.py` 测试功能

### 安全检查

- [ ] ✅ 密钥未硬编码到代码中
- [ ] ✅ `.env` 文件不会被提交到 Git
- [ ] ✅ 日志中不会显示完整密钥
- [ ] ✅ 已配置密钥轮换策略

### 功能检查

- [ ] ✅ 基础爬取功能正常
- [ ] ✅ 批量爬取功能正常
- [ ] ✅ 搜索功能正常
- [ ] ✅ 缓存功能启用

---

## 🎯 下一步

### 立即执行（今天）

1. [ ] 运行 `python test_api_keys.py` 验证所有密钥
2. [ ] 运行 `python quick_start.py` 测试基础功能
3. [ ] 创建 `.env` 文件并配置密钥
4. [ ] 添加 `.gitignore` 保护密钥

### 本周任务

1. [ ] 阅读 `FIRECRAWL_CLOUD_API_RULES.md` 完整规范
2. [ ] 实现成本监控系统
3. [ ] 配置密钥轮换策略
4. [ ] 部署新闻采集系统

### 本月目标

1. [ ] 上线 HawaiiHub 新闻聚合功能
2. [ ] 优化成本，降低 50%+
3. [ ] 实现完整的错误处理和监控
4. [ ] 培训团队成员

---

## 📞 获取帮助

### 遇到问题？

1. **查看文档**: `FIRECRAWL_CLOUD_SETUP_GUIDE.md` 第 9 章 "故障排查"
2. **运行诊断**: `python test_api_keys.py`
3. **检查日志**: `logs/firecrawl.log`

### 联系方式

- 📧 Firecrawl 官方: hello@firecrawl.dev
- 💬 Discord: https://discord.gg/firecrawl
- 📖 团队文档: `/Users/zhiledeng/Documents/augment-projects/AGENTS.md`

---

**🔥 恭喜！你的 Firecrawl API 密钥已配置完成！现在开始爬取数据吧！🌴**

---

_创建时间: 2025-10-27_
_维护者: HawaiiHub AI Team_
_版本: v1.0.0_
