#!/bin/bash
# Cursor 配置检查脚本
# 版本: v1.0.0
# 更新时间: 2025-10-28

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔍 Cursor 配置检查脚本"
echo "================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 计数器
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

# 检查函数
check_file() {
    local file=$1
    local desc=$2

    if [ -f "$file" ]; then
        echo -e "${GREEN}✅${NC} $desc: 存在"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}❌${NC} $desc: 不存在"
        ((FAIL_COUNT++))
        return 1
    fi
}

check_dir() {
    local dir=$1
    local desc=$2

    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅${NC} $desc: 存在"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${YELLOW}⚠️${NC}  $desc: 不存在"
        ((WARN_COUNT++))
        return 1
    fi
}

check_json_key() {
    local file=$1
    local key=$2
    local desc=$3

    if [ ! -f "$file" ]; then
        echo -e "${RED}❌${NC} $desc: 文件不存在 ($file)"
        ((FAIL_COUNT++))
        return 1
    fi

    # 使用 grep 检查（更可靠）
    if grep -q "\"${key}\"" "$file"; then
        local value=$(grep "\"${key}\"" "$file" | head -1 | sed 's/.*: *//' | sed 's/,$//')
        echo -e "${GREEN}✅${NC} $desc: $value"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}❌${NC} $desc: 键不存在 ($key)"
        ((FAIL_COUNT++))
        return 1
    fi
}

cd "$PROJECT_ROOT"

# ========================================
# 1. 基础配置文件检查
# ========================================

echo "📋 1. 基础配置文件检查"
echo "--------------------------------"

check_file ".cursorrules" ".cursorrules 主规则文件"
check_file ".cursorignore" ".cursorignore 忽略文件"
check_dir ".cursor" ".cursor 配置目录"

echo ""

# ========================================
# 2. Cursor 设置检查
# ========================================

echo "⚙️  2. Cursor 设置检查"
echo "--------------------------------"

check_file ".cursor/settings.json" "Cursor 设置文件"

if [ -f ".cursor/settings.json" ]; then
    echo ""
    echo "检查具体配置项..."
    check_json_key ".cursor/settings.json" "ai.autoApproveToolCalls" "自动批准工具调用"
    check_json_key ".cursor/settings.json" "ai.autoApproveReadOperations" "自动批准读操作"
    check_json_key ".cursor/settings.json" "ai.dangerousOperationsRequireApproval" "危险操作需批准"
fi

echo ""

# ========================================
# 3. 模块化规则检查
# ========================================

echo "📚 3. 模块化规则检查"
echo "--------------------------------"

check_dir ".cursor/rules" ".cursor/rules 目录"

if [ -d ".cursor/rules" ]; then
    check_file ".cursor/rules/00-hawaiihub-core.mdc" "核心规范"
    check_file ".cursor/rules/01-code-standards.mdc" "代码标准"
    check_file ".cursor/rules/99-deployment-safety.mdc" "部署安全"
    check_file ".cursor/rules/README.md" "规则说明文档"
fi

echo ""

# ========================================
# 4. MCP 集成检查
# ========================================

echo "🔌 4. MCP 集成检查"
echo "--------------------------------"

if check_file ".cursor/mcp.json" "MCP 配置文件"; then
    if command -v jq &> /dev/null; then
        echo ""
        echo "MCP 服务器列表:"
        jq -r '.mcpServers | keys[]' .cursor/mcp.json 2>/dev/null | while read server; do
            echo -e "  ${GREEN}•${NC} $server"
        done
    fi
else
    echo -e "${YELLOW}⚠️${NC}  建议: 创建 .cursor/mcp.json 配置 MCP 服务器"
fi

echo ""

# ========================================
# 5. 工作区设置检查
# ========================================

echo "🏗️  5. 工作区设置检查"
echo "--------------------------------"

if check_dir ".vscode" ".vscode 目录"; then
    check_file ".vscode/settings.json" "工作区设置"
    check_file ".vscode/extensions.json" "推荐插件列表"
else
    echo -e "${YELLOW}⚠️${NC}  建议: 创建 .vscode 目录和设置文件"
fi

echo ""

# ========================================
# 6. 文档完整性检查
# ========================================

echo "📖 6. 文档完整性检查"
echo "--------------------------------"

check_file "AGENTS.md" "AI 助手规范"
check_file "README.md" "项目说明"
check_file ".cursor/AUTO_APPROVAL_GUIDE.md" "自动批准指南"
check_file ".cursor/INITIALIZATION_REPORT.md" "初始化报告"

echo ""

# ========================================
# 7. 配置文件大小检查
# ========================================

echo "📏 7. 配置文件大小检查"
echo "--------------------------------"

if [ -f ".cursorrules" ]; then
    RULES_SIZE=$(wc -l < .cursorrules)
    RULES_BYTES=$(du -h .cursorrules | cut -f1)
    echo -e "${BLUE}ℹ️${NC}  .cursorrules: $RULES_SIZE 行, $RULES_BYTES"
fi

if [ -f "AGENTS.md" ]; then
    AGENTS_SIZE=$(wc -l < AGENTS.md)
    AGENTS_BYTES=$(du -h AGENTS.md | cut -f1)
    echo -e "${BLUE}ℹ️${NC}  AGENTS.md: $AGENTS_SIZE 行, $AGENTS_BYTES"
fi

echo ""

# ========================================
# 8. 环境变量检查
# ========================================

echo "🔑 8. 环境变量检查"
echo "--------------------------------"

check_file ".env" ".env 环境变量文件"
check_file "env.template" "env.template 模板文件"

if [ -f ".env" ]; then
    echo ""
    echo "检查关键环境变量..."

    source .env 2>/dev/null || true

    if [ -n "$FIRECRAWL_API_KEY" ]; then
        echo -e "${GREEN}✅${NC} FIRECRAWL_API_KEY: 已设置"
        ((PASS_COUNT++))
    else
        echo -e "${RED}❌${NC} FIRECRAWL_API_KEY: 未设置"
        ((FAIL_COUNT++))
    fi

    if [ -n "$FIRECRAWL_API_KEY_BACKUP_1" ]; then
        echo -e "${GREEN}✅${NC} FIRECRAWL_API_KEY_BACKUP_1: 已设置（密钥轮换）"
        ((PASS_COUNT++))
    else
        echo -e "${YELLOW}⚠️${NC}  FIRECRAWL_API_KEY_BACKUP_1: 未设置（可选）"
        ((WARN_COUNT++))
    fi
fi

echo ""

# ========================================
# 9. Git 配置检查
# ========================================

echo "🔧 9. Git 配置检查"
echo "--------------------------------"

check_file ".gitignore" ".gitignore 文件"

if [ -f ".gitignore" ]; then
    if grep -q ".env" .gitignore; then
        echo -e "${GREEN}✅${NC} .gitignore 包含 .env"
        ((PASS_COUNT++))
    else
        echo -e "${RED}❌${NC} .gitignore 缺少 .env（安全风险！）"
        ((FAIL_COUNT++))
    fi

    if grep -q "node_modules" .gitignore; then
        echo -e "${GREEN}✅${NC} .gitignore 包含 node_modules"
        ((PASS_COUNT++))
    else
        echo -e "${YELLOW}⚠️${NC}  .gitignore 缺少 node_modules"
        ((WARN_COUNT++))
    fi
fi

echo ""

# ========================================
# 10. 生成摘要
# ========================================

echo "================================"
echo "📊 检查摘要"
echo "================================"

TOTAL_CHECKS=$((PASS_COUNT + FAIL_COUNT + WARN_COUNT))
SCORE=$(awk "BEGIN {printf \"%.0f\", ($PASS_COUNT / $TOTAL_CHECKS) * 100}")

echo ""
echo -e "${GREEN}✅ 通过: $PASS_COUNT${NC}"
echo -e "${RED}❌ 失败: $FAIL_COUNT${NC}"
echo -e "${YELLOW}⚠️  警告: $WARN_COUNT${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "总计: $TOTAL_CHECKS 项检查"
echo -e "得分: ${BLUE}$SCORE/100${NC}"

echo ""

# 评级
if [ $SCORE -ge 90 ]; then
    echo -e "${GREEN}⭐⭐⭐⭐⭐ 优秀${NC}"
elif [ $SCORE -ge 80 ]; then
    echo -e "${GREEN}⭐⭐⭐⭐ 良好${NC}"
elif [ $SCORE -ge 70 ]; then
    echo -e "${YELLOW}⭐⭐⭐ 中等${NC}"
elif [ $SCORE -ge 60 ]; then
    echo -e "${YELLOW}⭐⭐ 及格${NC}"
else
    echo -e "${RED}⭐ 需改进${NC}"
fi

echo ""
echo "📝 详细报告: CURSOR_CONFIG_COMPLETE_AUDIT.md"
echo ""

# 退出码
if [ $FAIL_COUNT -gt 0 ]; then
    exit 1
else
    exit 0
fi
