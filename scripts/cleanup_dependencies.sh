#!/bin/bash
# FireShot 项目依赖清理脚本
# 版本: v1.0.0
# 更新时间: 2025-10-28

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔥 FireShot 依赖清理脚本"
echo "================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 检查确认
confirm() {
    read -p "$(echo -e ${YELLOW}$1${NC}) [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

cd "$PROJECT_ROOT"

echo "📍 项目路径: $PROJECT_ROOT"
echo ""

# ========================================
# 1. 备份依赖文件
# ========================================

log_info "步骤 1/5: 备份依赖文件..."

BACKUP_DIR=".backup/dependency_cleanup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [ -f "package.json" ]; then
    cp package.json "$BACKUP_DIR/package.json.backup"
    log_success "已备份 package.json → $BACKUP_DIR/"
fi

if [ -f "requirements.txt" ]; then
    cp requirements.txt "$BACKUP_DIR/requirements.txt.backup"
    log_success "已备份 requirements.txt → $BACKUP_DIR/"
fi

if [ -f "pyproject.toml" ]; then
    cp pyproject.toml "$BACKUP_DIR/pyproject.toml.backup"
    log_success "已备份 pyproject.toml → $BACKUP_DIR/"
fi

echo ""

# ========================================
# 2. 清理 Node.js 依赖
# ========================================

log_info "步骤 2/5: 清理 Node.js 依赖..."

if [ -d "node_modules" ]; then
    NODE_MODULES_SIZE=$(du -sh node_modules | cut -f1)
    log_warning "当前 node_modules 大小: $NODE_MODULES_SIZE"

    if confirm "是否删除 node_modules 并重新安装最小依赖？"; then
        log_info "删除 node_modules..."
        rm -rf node_modules package-lock.json
        log_success "已删除 node_modules"

        # 创建简化的 package.json
        log_info "创建简化的 package.json..."
        cat > package.json << 'EOF'
{
  "name": "fireshot",
  "version": "1.0.0",
  "description": "Firecrawl 云 API 最佳实践和 HawaiiHub 数据采集",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "dev": "tsx watch src/config.ts"
  },
  "dependencies": {
    "dotenv": "^16.4.7"
  },
  "devDependencies": {
    "@types/node": "^22.10.5",
    "tsx": "^4.19.2",
    "typescript": "^5.7.2"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF
        log_success "已创建简化的 package.json（仅保留必需依赖）"

        log_info "重新安装 Node.js 依赖..."
        npm install

        NEW_SIZE=$(du -sh node_modules | cut -f1)
        log_success "新的 node_modules 大小: $NEW_SIZE"
        log_success "Node.js 依赖清理完成！"
    else
        log_warning "跳过 Node.js 依赖清理"
    fi
else
    log_warning "未找到 node_modules 目录"
fi

echo ""

# ========================================
# 3. 清理 Python 依赖
# ========================================

log_info "步骤 3/5: 清理 Python 依赖..."

if [ -f "requirements.txt" ]; then
    log_warning "检测到 requirements.txt（已过时）"

    if confirm "是否移除 requirements.txt 并使用 pyproject.toml？"; then
        mv requirements.txt "$BACKUP_DIR/requirements.txt.removed"
        log_success "已移动 requirements.txt → $BACKUP_DIR/"

        log_info "使用 pyproject.toml 安装依赖..."
        pip3 install -e ".[dev]" --break-system-packages 2>/dev/null || pip3 install -e ".[dev]"

        log_success "Python 依赖清理完成！"
    else
        log_warning "跳过 requirements.txt 移除"
    fi
else
    log_info "requirements.txt 不存在，使用 pyproject.toml"

    if [ -f "pyproject.toml" ]; then
        log_info "安装 Python 依赖..."
        pip3 install -e ".[dev]" --break-system-packages 2>/dev/null || pip3 install -e ".[dev]"
        log_success "已安装 Python 依赖"
    else
        log_error "未找到 pyproject.toml"
    fi
fi

echo ""

# ========================================
# 4. 检查未使用的 Python 包
# ========================================

log_info "步骤 4/5: 检查未使用的 Python 包..."

if command -v pip3 &> /dev/null; then
    log_info "已安装的 Python 包:"
    pip3 list --format=columns | head -20

    echo ""
    log_info "💡 提示: 使用 'pip3 uninstall <package>' 卸载不需要的包"
else
    log_warning "未找到 pip3 命令"
fi

echo ""

# ========================================
# 5. 生成清理报告
# ========================================

log_info "步骤 5/5: 生成清理报告..."

REPORT_FILE="DEPENDENCY_CLEANUP_SUMMARY_$(date +%Y%m%d_%H%M%S).txt"

cat > "$REPORT_FILE" << EOF
# FireShot 依赖清理摘要报告

生成时间: $(date '+%Y-%m-%d %H:%M:%S')
备份目录: $BACKUP_DIR

## Node.js 依赖

EOF

if [ -d "node_modules" ]; then
    echo "node_modules 大小: $(du -sh node_modules | cut -f1)" >> "$REPORT_FILE"
    echo "已安装包数量: $(ls node_modules | wc -l)" >> "$REPORT_FILE"
else
    echo "node_modules: 不存在" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << EOF

## Python 依赖

已安装 Python 包:
EOF

if command -v pip3 &> /dev/null; then
    pip3 list --format=freeze >> "$REPORT_FILE"
else
    echo "pip3: 未安装" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << EOF

## 配置文件

EOF

if [ -f "package.json" ]; then
    echo "✅ package.json: 存在" >> "$REPORT_FILE"
else
    echo "❌ package.json: 不存在" >> "$REPORT_FILE"
fi

if [ -f "requirements.txt" ]; then
    echo "⚠️  requirements.txt: 存在（建议移除）" >> "$REPORT_FILE"
else
    echo "✅ requirements.txt: 不存在" >> "$REPORT_FILE"
fi

if [ -f "pyproject.toml" ]; then
    echo "✅ pyproject.toml: 存在" >> "$REPORT_FILE"
else
    echo "❌ pyproject.toml: 不存在" >> "$REPORT_FILE"
fi

log_success "清理报告已生成: $REPORT_FILE"

echo ""
echo "================================"
log_success "依赖清理完成！"
echo ""
log_info "备份文件位于: $BACKUP_DIR"
log_info "清理报告: $REPORT_FILE"
log_info "详细分析: DEPENDENCY_CLEANUP_REPORT.md"
echo ""
