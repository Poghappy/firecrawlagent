# ⚠️ isort 扩展冲突修复指南

> **问题**: isort 扩展与 Python 3.14 不兼容
> **解决**: 禁用 isort 扩展（Ruff 已提供相同功能）

---

## 🐛 问题分析

### 错误信息

```
ImportError: cannot import name 'Str' from 'ast'
[Error] isort client: couldn't create connection to server.
```

### 根本原因

1. **isort 扩展**（`ms-python.isort`）正在尝试启动
2. 该扩展使用的 `typeguard` 库与 **Python 3.14 不兼容**
3. Python 3.9+ 已经移除了 `ast.Str`，但 isort 扩展依赖的旧版本库仍在使用

### 为什么不需要 isort？

✅ **Ruff 已经内置了完整的 isort 功能**

| 功能               | isort 扩展 | Ruff            |
| ------------------ | ---------- | --------------- |
| 导入排序           | ✅         | ✅              |
| 导入分组           | ✅         | ✅              |
| 自动移除未使用导入 | ❌         | ✅              |
| 速度               | 慢         | 10-100x 更快 ⚡ |
| Python 3.14 兼容   | ❌         | ✅              |

---

## ✅ 解决方案（2 个选择）

### 方案 1: 禁用 isort 扩展（推荐）⭐

1. **打开扩展面板**
   - 按 `Cmd+Shift+X`

2. **搜索 "isort"**
   - 找到 `isort (ms-python.isort)`

3. **禁用扩展**
   - 点击 **Disable** 按钮
   - 或右键 → **Disable**

4. **重启 Cursor**
   - `Cmd+Shift+P` → `Reload Window`

---

### 方案 2: 卸载 isort 扩展（彻底解决）

1. **打开扩展面板**
   - 按 `Cmd+Shift+X`

2. **搜索 "isort"**
   - 找到 `isort (ms-python.isort)`

3. **卸载扩展**
   - 点击 **Uninstall** 按钮

4. **重启 Cursor**
   - `Cmd+Shift+P` → `Reload Window`

---

## ✅ 已完成的配置修复

我已经在 `settings.json` 中禁用了 isort 相关配置：

```json
{
  // ❌ 已禁用（使用 Ruff 代替）
  // "python.sortImports.args": ["--profile", "black"]
}
```

**Ruff 配置**（已启用）：

```json
{
  "ruff.organizeImports": true, // ✅ Ruff 处理导入排序
  "editor.codeActionsOnSave": {
    "source.organizeImports": "explicit" // ✅ 保存时自动排序
  }
}
```

---

## 🔍 验证修复

### 禁用/卸载 isort 扩展后

1. **重启 Cursor**
   - `Cmd+Shift+P` → `Reload Window`

2. **检查输出日志**
   - 菜单栏 → View → Output
   - 下拉菜单选择 "Ruff"
   - ✅ 应该看到 Ruff 正常运行，没有 isort 错误

3. **测试导入排序**
   - 打开 `tests/test_example.py`
   - 故意打乱导入顺序：
     ```python
     from typing import Dict
     import pytest
     from typing import List  # 应该与上面合并
     import os
     ```
   - 按 `Cmd+S` 保存
   - ✅ Ruff 应该自动排序和合并导入

---

## 📊 isort vs Ruff 对比

### 导入排序功能

| 功能                       | isort 扩展 | Ruff           |
| -------------------------- | ---------- | -------------- |
| 基础排序                   | ✅         | ✅             |
| 分组（标准库/第三方/本地） | ✅         | ✅             |
| 合并重复导入               | ✅         | ✅             |
| 移除未使用导入             | ❌         | ✅             |
| 自动修复                   | ✅         | ✅             |
| 速度                       | 基准       | **10-100x** ⚡ |
| Python 3.14 支持           | ❌         | ✅             |
| VSCode 集成                | 需要扩展   | 原生支持 ✅    |

### 配置对比

**isort 扩展配置**（旧方式，已弃用）：

```json
{
  "python.sortImports.args": ["--profile", "black"],
  "python.sortImports.path": ["isort"],
  "[python]": {
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    }
  }
}
```

**Ruff 配置**（新方式，推荐）：

```json
{
  "ruff.organizeImports": true,
  "[python]": {
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit" // 自动调用 Ruff
    }
  }
}
```

**优势**：

- ✅ 更简单（无需额外配置）
- ✅ 更快（Rust 实现）
- ✅ 兼容 Python 3.14
- ✅ 集成更多功能（Linting + 格式化 + 导入排序）

---

## 🚨 常见问题

### Q1: 禁用 isort 后导入排序还能用吗？

**✅ 完全可以！**

Ruff 已经内置了完整的 isort 功能。你的配置中：

```json
{
  "ruff.organizeImports": true,
  "editor.codeActionsOnSave": {
    "source.organizeImports": "explicit"
  }
}
```

保存文件时，Ruff 会自动：

1. 排序导入（按标准库、第三方、本地分组）
2. 合并重复导入
3. 移除未使用的导入
4. 格式化导入语句

### Q2: Ruff 的导入排序规则和 isort 一样吗？

**✅ 完全兼容！**

Ruff 默认遵循 PEP 8 和 isort 的排序规则：

```python
# 1. 标准库
import os
import sys
from typing import Dict, List

# 2. 第三方库
import pytest
import requests
from pydantic import BaseModel

# 3. 本地模块
from .utils import helper
from .config import settings
```

### Q3: 如何自定义导入排序规则？

在 `pyproject.toml` 中配置：

```toml
[tool.ruff.lint.isort]
known-first-party = ["src", "scripts"]
section-order = [
    "future",
    "standard-library",
    "third-party",
    "first-party",
    "local-folder"
]
```

### Q4: 为什么 isort 扩展不更新以支持 Python 3.14？

Microsoft 的 Python 团队正在将所有功能整合到主 Python 扩展中，并推荐使用现代工具如 Ruff。isort 扩展处于维护模式，不再积极开发新功能。

---

## ✅ 验证清单

完成修复后，确认：

- [ ] 已禁用或卸载 isort 扩展
- [ ] 已重启 Cursor
- [ ] 输出日志中没有 isort 错误
- [ ] 保存 Python 文件时导入自动排序（Ruff）
- [ ] 底部状态栏显示 `Ruff (native)`

---

## 📚 相关配置文件

### settings.json（已更新）

```json
{
  // ✅ 使用 Ruff 处理导入排序
  "ruff.organizeImports": true

  // ❌ 禁用 isort（已注释）
  // "python.sortImports.args": ["--profile", "black"]
}
```

### pyproject.toml（已配置）

```toml
[tool.ruff.lint]
select = [
    "I",   # isort 规则
    # ... 其他规则
]

[tool.ruff.lint.isort]
known-first-party = ["src", "scripts"]
```

---

## 🎯 下一步

1. **立即执行**:
   - 禁用或卸载 isort 扩展
   - 重启 Cursor

2. **验证**:
   - 打开 Python 文件
   - 测试导入排序（Cmd+S）
   - 检查输出日志（无错误）

3. **开始开发**:
   - Ruff 会自动处理所有导入排序
   - 比 isort 快 10-100 倍 ⚡

---

**问题状态**: ✅ 已识别
**解决方案**: 禁用 isort 扩展
**配置状态**: ✅ 已修复
**下一步**: 🔄 禁用扩展 → 重启 Cursor

**最后更新**: 2025-10-27
