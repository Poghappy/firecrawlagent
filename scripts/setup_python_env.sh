#!/usr/bin/env bash
# ===================================================================
# FireShot 项目 - Python 环境一键配置脚本
# ===================================================================
# 版本: v1.0.0
# 更新时间: 2025-10-28
# 维护者: HawaiiHub AI Team
# ===================================================================

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  FireShot Python 环境配置向导                              ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ===========================
# 1. 检查 Python 版本
# ===========================
echo -e "${YELLOW}[1/7]${NC} 检查 Python 版本..."
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
REQUIRED_VERSION="3.11"

if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" == "$REQUIRED_VERSION" ]]; then
    echo -e "${GREEN}✓${NC} Python $PYTHON_VERSION (符合要求 >= $REQUIRED_VERSION)"
else
    echo -e "${RED}✗${NC} Python 版本过低: $PYTHON_VERSION (需要 >= $REQUIRED_VERSION)"
    exit 1
fi
echo ""

# ===========================
# 2. 检查虚拟环境
# ===========================
echo -e "${YELLOW}[2/7]${NC} 检查虚拟环境..."
if [[ ! -d ".venv" ]]; then
    echo -e "${BLUE}→${NC} 创建虚拟环境..."
    python3 -m venv .venv
    echo -e "${GREEN}✓${NC} 虚拟环境创建完成"
else
    echo -e "${GREEN}✓${NC} 虚拟环境已存在"
fi
echo ""

# ===========================
# 3. 激活虚拟环境
# ===========================
echo -e "${YELLOW}[3/7]${NC} 激活虚拟环境..."
source .venv/bin/activate
echo -e "${GREEN}✓${NC} 虚拟环境已激活"
echo ""

# ===========================
# 4. 升级 pip
# ===========================
echo -e "${YELLOW}[4/7]${NC} 升级 pip..."
python3 -m pip install --upgrade pip --quiet
echo -e "${GREEN}✓${NC} pip 已升级到最新版本"
echo ""

# ===========================
# 5. 安装核心依赖
# ===========================
echo -e "${YELLOW}[5/7]${NC} 安装核心依赖..."
pip install -q --break-system-packages \
    firecrawl-py \
    python-dotenv \
    requests \
    pydantic \
    loguru
echo -e "${GREEN}✓${NC} 核心依赖安装完成"
echo ""

# ===========================
# 6. 安装开发工具
# ===========================
echo -e "${YELLOW}[6/7]${NC} 安装开发工具..."
pip install -q --break-system-packages \
    ruff \
    mypy \
    pytest \
    pytest-cov \
    types-requests
echo -e "${GREEN}✓${NC} 开发工具安装完成"
echo ""

# ===========================
# 7. 验证安装
# ===========================
echo -e "${YELLOW}[7/7]${NC} 验证安装..."
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "已安装包清单:"
echo "═══════════════════════════════════════════════════════════"
echo ""

# 核心包
echo -e "${BLUE}核心包:${NC}"
pip list --format=columns | grep -E "(firecrawl|dotenv|requests|pydantic|loguru)" || true
echo ""

# 开发工具
echo -e "${BLUE}开发工具:${NC}"
pip list --format=columns | grep -E "(ruff|mypy|pytest)" || true
echo ""

# ===========================
# 配置文件检查
# ===========================
echo "═══════════════════════════════════════════════════════════"
echo "配置文件检查:"
echo "═══════════════════════════════════════════════════════════"
echo ""

check_file() {
    if [[ -f "$1" ]]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${RED}✗${NC} $1 (缺失)"
    fi
}

check_file ".env"
check_file "pyproject.toml"
check_file ".vscode/settings.json"
check_file ".vscode/extensions.json"
check_file ".editorconfig"
echo ""

# ===========================
# 完成提示
# ===========================
echo "═══════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ Python 环境配置完成！${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "下一步操作："
echo ""
echo "1. 重启 Cursor IDE 以应用新配置"
echo "2. 安装推荐的 VSCode 扩展："
echo "   - Pylance (ms-python.vscode-pylance)"
echo "   - Ruff (charliermarsh.ruff)"
echo "   - MyPy Type Checker (ms-python.mypy-type-checker)"
echo ""
echo "3. 运行测试验证："
echo "   ${BLUE}make test${NC} 或 ${BLUE}pytest${NC}"
echo ""
echo "4. 运行代码检查："
echo "   ${BLUE}make lint${NC} 或 ${BLUE}ruff check .${NC}"
echo ""
echo "5. 格式化代码："
echo "   ${BLUE}make format${NC} 或 ${BLUE}ruff format .${NC}"
echo ""
echo "═══════════════════════════════════════════════════════════"
