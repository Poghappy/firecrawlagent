#!/bin/bash

# FireShot Python 虚拟环境自动修复脚本
# 基于 Ruff 官方文档和社区最佳实践

set -e  # 遇到错误立即退出

echo "🔧 FireShot Python 虚拟环境修复脚本"
echo "======================================"
echo ""

# 获取脚本所在目录（项目根目录）
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "📁 项目目录: $PROJECT_DIR"
echo ""

# 步骤 1: 检查虚拟环境是否存在
echo "🔍 步骤 1/5: 检查虚拟环境"
if [ -d ".venv" ]; then
    echo "  ✅ 虚拟环境已存在: .venv/"
    read -p "  是否重新创建虚拟环境？(y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "  🗑️  删除现有虚拟环境..."
        rm -rf .venv
    else
        echo "  ⏭️  跳过虚拟环境创建"
    fi
fi

if [ ! -d ".venv" ]; then
    echo "  📦 创建虚拟环境..."
    python3 -m venv .venv
    echo "  ✅ 虚拟环境创建成功"
fi
echo ""

# 步骤 2: 激活虚拟环境并安装依赖
echo "📦 步骤 2/5: 安装项目依赖"
echo "  🔄 激活虚拟环境..."
source .venv/bin/activate

echo "  📥 安装核心依赖..."
pip install --quiet --upgrade pip
pip install --quiet firecrawl-py python-dotenv requests pydantic

echo "  📥 安装开发工具..."
pip install --quiet ruff mypy pytest pytest-cov types-requests

echo "  ✅ 依赖安装完成"
echo ""

# 步骤 3: 验证安装
echo "🧪 步骤 3/5: 验证安装"

# 验证 Python 路径
PYTHON_PATH=$(which python)
echo "  Python 路径: $PYTHON_PATH"
if [[ $PYTHON_PATH == *".venv"* ]]; then
    echo "  ✅ Python 解释器正确（在虚拟环境中）"
else
    echo "  ⚠️  警告: Python 解释器不在虚拟环境中"
fi

# 验证 Ruff
if command -v ruff &> /dev/null; then
    RUFF_VERSION=$(ruff --version)
    echo "  ✅ Ruff: $RUFF_VERSION"
else
    echo "  ⚠️  警告: Ruff 未安装到 PATH"
fi

# 验证 mypy
if python -m mypy --version &> /dev/null; then
    MYPY_VERSION=$(python -m mypy --version)
    echo "  ✅ mypy: $MYPY_VERSION"
else
    echo "  ⚠️  警告: mypy 未正确安装"
fi

# 验证 pytest
if python -m pytest --version &> /dev/null; then
    PYTEST_VERSION=$(python -m pytest --version)
    echo "  ✅ pytest: $PYTEST_VERSION"
else
    echo "  ⚠️  警告: pytest 未正确安装"
fi
echo ""

# 步骤 4: 生成 VSCode 配置建议
echo "⚙️  步骤 4/5: 生成 VSCode 配置"

cat > .vscode_settings_suggestion.json << 'EOF'
{
  "// 说明": "将以下配置复制到 ~/Library/Application Support/Cursor/User/settings.json",

  "[python]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.codeActionsOnSave": {
      "source.fixAll": "explicit",
      "source.organizeImports": "explicit"
    },
    "editor.tabSize": 4,
    "editor.rulers": [88]
  },

  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",
  "python.terminal.activateEnvironment": true,

  "ruff.enable": true,
  "ruff.nativeServer": true,
  "ruff.lint.enable": true,
  "ruff.format.enable": true,
  "ruff.organizeImports": true,
  "ruff.importStrategy": "fromEnvironment",

  "python.languageServer": "Pylance",
  "python.analysis.typeCheckingMode": "strict",

  "python.linting.pylintEnabled": false,
  "python.linting.flake8Enabled": false,
  "python.formatting.provider": "none"
}
EOF

echo "  ✅ VSCode 配置建议已生成: .vscode_settings_suggestion.json"
echo ""

# 步骤 5: 运行验证脚本
echo "✅ 步骤 5/5: 运行验证测试"
if [ -f "verify_python_setup.py" ]; then
    echo "  🧪 运行 verify_python_setup.py..."
    echo ""
    python verify_python_setup.py
    VERIFY_EXIT_CODE=$?
    echo ""

    if [ $VERIFY_EXIT_CODE -eq 0 ]; then
        echo "  ✅ 验证测试通过！"
    else
        echo "  ⚠️  验证测试有警告，请检查上面的输出"
    fi
else
    echo "  ⏭️  跳过验证测试（verify_python_setup.py 不存在）"
fi
echo ""

# 总结
echo "======================================"
echo "🎉 虚拟环境配置完成！"
echo "======================================"
echo ""
echo "📋 下一步操作："
echo ""
echo "1. 📝 更新 VSCode 配置"
echo "   配置文件: ~/Library/Application Support/Cursor/User/settings.json"
echo "   参考配置: .vscode_settings_suggestion.json"
echo "   或查看: RUFF_VENV_SOLUTION.md（完整配置指南）"
echo ""
echo "2. 🔄 重启 Cursor"
echo "   方法1: Cmd+Shift+P → 'Reload Window'"
echo "   方法2: Cmd+Q 退出 → 重新打开"
echo ""
echo "3. ✅ 验证配置"
echo "   - 底部状态栏应显示: Ruff (native)"
echo "   - Python 解释器应指向: .venv/bin/python"
echo "   - 打开 Python 文件测试自动格式化"
echo ""
echo "4. 📚 查看完整文档"
echo "   RUFF_VENV_SOLUTION.md - 官方文档 + 社区最佳实践"
echo "   PYTHON_CONFIG_FIX.md - 问题诊断和修复指南"
echo ""
echo "🔗 参考资源:"
echo "   - Ruff 官方: https://docs.astral.sh/ruff/"
echo "   - VSCode 扩展: https://github.com/astral-sh/ruff-vscode"
echo ""

# 提示激活虚拟环境
echo "💡 提示: 在当前终端中激活虚拟环境"
echo "   source .venv/bin/activate"
echo ""
