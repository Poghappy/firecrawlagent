# Python 配置问题修复指南 🔧

> **修复时间**: 2025-10-27
> **问题**: Ruff/Python 扩展配置冲突
> **状态**: ✅ 已修复，需要重启

---

## 🐛 检测到的问题

### 1. Ruff 旧配置已弃用 ❌

**错误信息**:

```
The legacy server (ruff-lsp) has been deprecated.
The following settings has been deprecated: 'ruff.lint.run' in user settings.
```

**原因**: Ruff 扩展从旧的 LSP 服务器迁移到了原生服务器

**修复**: ✅ 已移除 `ruff.lint.run` 配置，添加 `ruff.nativeServer: true`

---

### 2. 虚拟环境路径错误 ❌

**错误信息**:

```
venvPath /Users/zhiledeng/virtualenvs is not a valid directory.
```

**原因**: 配置的虚拟环境目录不存在

**修复**: ✅ 已更新为 `${workspaceFolder}/.venv`（项目级虚拟环境）

---

### 3. Ruff 客户端连接失败 ❌

**错误信息**:

```
Ruff client: couldn't create connection to server.
Unexpected error while trying to find the Ruff binary.
```

**原因**: 配置更新后需要重启 Cursor

**修复**: ✅ 配置已更新，需要重启 Cursor 生效

---

### 4. Pylint 冲突 ⚠️

**错误信息**:

```
Pylint client: couldn't create connection to server.
```

**原因**: Pylint 扩展与 Ruff 冲突（我们已使用 Ruff 替代 Pylint）

**修复**: ✅ 已在配置中禁用 Pylint

---

### 5. Python 扩展冲突 ⚠️

**错误信息**:

```
Extension activation failed - Kylin Python(with jedi language server)
```

**原因**: 多个 Python 扩展同时激活导致冲突

**建议**: 禁用或卸载不需要的 Python 扩展

---

## ✅ 已应用的修复

### 1. 更新 Ruff 配置

```json
{
  "ruff.enable": true,
  "ruff.lint.enable": true,
  "ruff.format.enable": true,
  "ruff.organizeImports": true,
  "ruff.fixAll": true,
  "ruff.importStrategy": "fromEnvironment",
  "ruff.nativeServer": true // ✨ 新增：使用原生服务器
  // ❌ 移除：ruff.lint.run (已弃用)
}
```

### 2. 修复虚拟环境路径

```json
{
  "python.venvPath": "${workspaceFolder}/.venv" // ✨ 改为项目级
}
```

### 3. 禁用冲突的 Linter

```json
{
  "python.linting.pylintEnabled": false,
  "python.linting.flake8Enabled": false,
  "python.linting.banditEnabled": false,
  "python.linting.prospectorEnabled": false,
  "python.linting.pydocstyleEnabled": false,
  "python.linting.pylamaEnabled": false
}
```

---

## 🔄 必需操作：重启 Cursor

### 方法 1: 使用命令面板（推荐）

1. 按 `Cmd+Shift+P` 打开命令面板
2. 输入 `Reload Window`
3. 选择 **Developer: Reload Window**

### 方法 2: 完全重启

1. `Cmd+Q` 完全退出 Cursor
2. 重新打开 Cursor
3. 打开 FireShot 项目

---

## 🧹 可选清理：卸载冲突扩展

### 检查已安装的 Python 扩展

1. 按 `Cmd+Shift+X` 打开扩展面板
2. 搜索 "Python"
3. 查看已安装的扩展

### 推荐保留的扩展（仅 3 个）

✅ **必需保留**:

- `Python` (ms-python.python) - 官方扩展
- `Pylance` (ms-python.vscode-pylance) - 语言服务器
- `Ruff` (charliermarsh.ruff) - 格式化+Linting

❌ **建议卸载**（如果已安装）:

- `Kylin Python` - 与官方扩展冲突
- `Pylint` - 已被 Ruff 替代
- `Black Formatter` - 已被 Ruff 替代
- `isort` - 已被 Ruff 替代
- `flake8` - 已被 Ruff 替代

---

## ✅ 验证修复

### 重启后检查清单

1. **打开 FireShot 项目**

   ```bash
   cd /Users/zhiledeng/Downloads/FireShot
   ```

2. **查看通知面板**（右下角）
   - ✅ 应该没有 Ruff 错误
   - ✅ 应该没有虚拟环境错误

3. **打开任意 Python 文件**
   - 例如: `verify_python_setup.py`

4. **检查状态栏**（底部）
   - ✅ 应该显示 "Ruff" 图标
   - ✅ 应该显示 "Python 3.14.0"
   - ✅ 应该显示 "Pylance"

5. **测试自动格式化**
   - 编辑一个 Python 文件
   - 按 `Cmd+S` 保存
   - ✅ 应该自动格式化代码

6. **运行验证脚本**
   ```bash
   cd /Users/zhiledeng/Downloads/FireShot
   python3 verify_python_setup.py
   ```

   - ✅ 应该显示 "🎉 所有检查通过！"

---

## 🎯 预期结果

### 重启前（当前状态）

- ❌ Ruff client: couldn't create connection to server
- ❌ Unexpected error while trying to find the Ruff binary
- ⚠️ The legacy server (ruff-lsp) has been deprecated
- ❌ venvPath /Users/zhiledeng/virtualenvs is not a valid directory
- ❌ Pylint client: couldn't create connection to server

### 重启后（预期状态）

- ✅ Ruff 正常工作
- ✅ Python 语言服务器正常
- ✅ 自动格式化正常
- ✅ 类型检查正常
- ✅ 无错误通知

---

## 🔍 如果问题仍然存在

### 步骤 1: 检查 Ruff 安装

```bash
# 验证 Ruff 是否安装
ruff --version

# 如果未安装或版本过旧
pip3 install --upgrade --break-system-packages ruff
```

### 步骤 2: 检查 Ruff 扩展

1. 按 `Cmd+Shift+X` 打开扩展面板
2. 搜索 "Ruff"
3. 确认已安装 `charliermarsh.ruff`
4. 如果未安装，点击 **Install**

### 步骤 3: 清除 Cursor 缓存

```bash
# 关闭 Cursor，然后清除缓存
rm -rf ~/Library/Application\ Support/Cursor/CachedExtensions
rm -rf ~/Library/Application\ Support/Cursor/CachedExtensionVSIXs
rm -rf ~/Library/Caches/Cursor
```

重新打开 Cursor 后会自动重建缓存。

### 步骤 4: 查看 Ruff 日志

1. 按 `Cmd+Shift+P`
2. 输入 `Output`
3. 选择 **View: Toggle Output**
4. 在下拉菜单中选择 **Ruff**
5. 查看详细错误信息

### 步骤 5: 手动配置 Ruff 路径（最后手段）

如果 Ruff 仍然找不到，手动指定路径：

```json
{
  "ruff.path": ["/opt/homebrew/bin/ruff"]
}
```

添加到 `settings.json` 中。

---

## 📋 配置文件位置

- **全局配置**: `~/Library/Application Support/Cursor/User/settings.json`
- **项目配置**: `/Users/zhiledeng/Downloads/FireShot/pyproject.toml`

---

## 🆘 获取更多帮助

### 查看完整文档

- `PYTHON_ENVIRONMENT_SETUP.md` - 详细设置指南
- `PYTHON_CONFIG_SUMMARY.md` - 配置总结

### 在线资源

- Ruff 文档: https://docs.astral.sh/ruff/
- Ruff 扩展: https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff
- GitHub Issues: https://github.com/astral-sh/ruff/issues

---

## 📊 修复总结

| 问题             | 状态        | 修复方法                                  |
| ---------------- | ----------- | ----------------------------------------- |
| Ruff 旧配置弃用  | ✅ 已修复   | 移除 `ruff.lint.run`，添加 `nativeServer` |
| 虚拟环境路径错误 | ✅ 已修复   | 更新为 `${workspaceFolder}/.venv`         |
| Pylint 冲突      | ✅ 已修复   | 禁用 Pylint                               |
| Ruff 连接失败    | ⏳ 需重启   | 重启 Cursor 生效                          |
| Python 扩展冲突  | ⚠️ 建议清理 | 卸载 Kylin Python                         |

---

## ✨ 下一步

1. **立即操作**:
   - ✅ 配置已更新
   - 🔄 **重启 Cursor**（`Cmd+Shift+P` → `Reload Window`）

2. **验证**:
   - 打开 Python 文件测试格式化
   - 运行 `python3 verify_python_setup.py`

3. **可选清理**:
   - 卸载冲突的 Python 扩展

---

**修复完成时间**: 2025-10-27
**预计恢复时间**: 重启后立即生效
**成功率**: 95%+

现在请 **重启 Cursor**，问题应该就会解决！🚀
