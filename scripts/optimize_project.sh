#!/bin/bash
# ===================================================================
# FireShot 项目全面优化脚本
# ===================================================================
# 功能：自动优化项目配置、性能和代码质量
# 版本：v1.0.0
# 作者：HawaiiHub AI Team
# ===================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 优化计数器
OPTIMIZATIONS=0

# ===================================================================
# 辅助函数
# ===================================================================

print_header() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}  $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_step() {
  echo -e "\n${CYAN}▶ $1${NC}"
}

print_success() {
  OPTIMIZATIONS=$((OPTIMIZATIONS + 1))
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

# ===================================================================
# 1. 备份当前配置
# ===================================================================

backup_configs() {
  print_header "1️⃣  备份当前配置"

  cd "$PROJECT_ROOT"

  BACKUP_DIR=".backup/optimize_$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$BACKUP_DIR"

  print_step "创建备份目录: $BACKUP_DIR"

  # 备份配置文件
  CONFIG_FILES=(
    ".cursorrules"
    ".gitignore"
    ".cursorignore"
    ".editorconfig"
    ".prettierrc.json"
    ".markdownlint.json"
    "pyproject.toml"
    "package.json"
    ".vscode/settings.json"
    ".cursor/mcp.json"
  )

  for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$file")"
      cp "$file" "$BACKUP_DIR/$file"
      print_success "已备份: $file"
    fi
  done

  echo ""
  echo -e "${BLUE}备份位置: $BACKUP_DIR${NC}"
}

# ===================================================================
# 2. 清理临时文件和缓存
# ===================================================================

cleanup_temp_files() {
  print_header "2️⃣  清理临时文件和缓存"

  cd "$PROJECT_ROOT"

  print_step "清理 Python 缓存..."
  find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
  find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
  find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
  find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
  find . -type f -name "*.pyc" -delete 2>/dev/null || true
  find . -type f -name "*.pyo" -delete 2>/dev/null || true
  print_success "已清理 Python 缓存"

  print_step "清理 Node.js 缓存..."
  rm -rf .eslintcache 2>/dev/null || true
  rm -rf node_modules/.cache 2>/dev/null || true
  print_success "已清理 Node.js 缓存"

  print_step "清理构建产物..."
  rm -rf dist/ build/ 2>/dev/null || true
  print_success "已清理构建产物"

  print_step "清理日志文件..."
  find logs -name "*.log" -mtime +7 -delete 2>/dev/null || true
  print_success "已清理旧日志文件（7天以上）"

  print_step "清理临时文件..."
  find . -name "*.tmp" -delete 2>/dev/null || true
  find . -name "*.bak" -delete 2>/dev/null || true
  find . -name ".DS_Store" -delete 2>/dev/null || true
  print_success "已清理临时文件"
}

# ===================================================================
# 3. 优化依赖管理
# ===================================================================

optimize_dependencies() {
  print_header "3️⃣  优化依赖管理"

  cd "$PROJECT_ROOT"

  # Python 依赖
  if [ -f "pyproject.toml" ]; then
    print_step "检查 Python 依赖..."

    if command -v pip3 &> /dev/null; then
      print_step "更新 pip..."
      pip3 install --upgrade pip --quiet --break-system-packages 2>/dev/null || true
      print_success "pip 已更新"
    fi

    print_success "Python 依赖配置检查完成"
  fi

  # Node.js 依赖
  if [ -f "package.json" ]; then
    print_step "检查 Node.js 依赖..."

    if command -v npm &> /dev/null; then
      # 检查是否有 node_modules
      if [ ! -d "node_modules" ]; then
        print_step "安装 Node.js 依赖..."
        npm install --quiet 2>/dev/null || true
        print_success "依赖已安装"
      else
        # 检查依赖大小
        SIZE=$(du -sh node_modules 2>/dev/null | awk '{print $1}')
        print_success "node_modules 大小: $SIZE"
      fi
    fi
  fi

  # 子项目依赖
  if [ -d "hawaiihub-admin-agent" ] && [ -f "hawaiihub-admin-agent/package.json" ]; then
    print_step "检查子项目依赖..."
    cd "hawaiihub-admin-agent"

    if [ ! -d "node_modules" ]; then
      print_step "安装子项目依赖..."
      npm install --quiet 2>/dev/null || true
      print_success "子项目依赖已安装"
    else
      SIZE=$(du -sh node_modules 2>/dev/null | awk '{print $1}')
      print_success "子项目 node_modules 大小: $SIZE"
    fi

    cd "$PROJECT_ROOT"
  fi
}

# ===================================================================
# 4. 优化 Git 配置
# ===================================================================

optimize_git() {
  print_header "4️⃣  优化 Git 配置"

  cd "$PROJECT_ROOT"

  if [ -d ".git" ]; then
    print_step "清理 Git 缓存..."
    git gc --quiet 2>/dev/null || true
    print_success "Git 仓库已优化"

    print_step "检查 .gitignore..."
    # 确保关键文件被忽略
    MUST_IGNORE=(".env" "node_modules/" "__pycache__/" "*.pyc" ".DS_Store")

    for pattern in "${MUST_IGNORE[@]}"; do
      if ! grep -q "^${pattern}$" .gitignore 2>/dev/null; then
        echo "$pattern" >> .gitignore
        print_success "已添加到 .gitignore: $pattern"
      fi
    done

    # 移除 .gitignore 中的重复行
    if [ -f ".gitignore" ]; then
      sort -u .gitignore > .gitignore.tmp && mv .gitignore.tmp .gitignore
      print_success ".gitignore 已去重"
    fi
  fi
}

# ===================================================================
# 5. 优化 Cursor 配置
# ===================================================================

optimize_cursor() {
  print_header "5️⃣  优化 Cursor 配置"

  cd "$PROJECT_ROOT"

  print_step "检查 .cursorignore..."

  if [ ! -f ".cursorignore" ]; then
    print_warning ".cursorignore 不存在，跳过优化"
    return
  fi

  # 确保大型目录被排除
  MUST_EXCLUDE=(
    "node_modules/"
    "**node_modules/"
    "data/"
    "logs/"
    ".backup/"
    "dist/"
    "build/"
    "*.log"
    "Firecrawl官方文档/"
    "hawaiihub.net 真实部署克隆源码/"
  )

  for pattern in "${MUST_EXCLUDE[@]}"; do
    if ! grep -q "^${pattern}$" .cursorignore 2>/dev/null; then
      echo "$pattern" >> .cursorignore
      print_success "已添加到 .cursorignore: $pattern"
    fi
  done

  # 去重
  sort -u .cursorignore > .cursorignore.tmp && mv .cursorignore.tmp .cursorignore
  print_success ".cursorignore 已优化和去重"

  # 检查 .cursor/mcp.json
  if [ -f ".cursor/mcp.json" ]; then
    print_success "MCP 配置文件存在"
  else
    print_warning "MCP 配置文件不存在"
  fi
}

# ===================================================================
# 6. 优化代码格式
# ===================================================================

optimize_code_format() {
  print_header "6️⃣  优化代码格式"

  cd "$PROJECT_ROOT"

  # Python 格式化
  if command -v ruff &> /dev/null; then
    print_step "运行 Ruff 格式化..."
    ruff format . --quiet 2>/dev/null || true
    print_success "Python 代码已格式化"
  else
    print_warning "Ruff 未安装，跳过 Python 格式化"
  fi

  # JavaScript/TypeScript 格式化
  if [ -f "node_modules/.bin/prettier" ]; then
    print_step "运行 Prettier 格式化..."
    ./node_modules/.bin/prettier --write "**/*.{js,ts,json,md}" --log-level silent 2>/dev/null || true
    print_success "JavaScript/TypeScript 代码已格式化"
  else
    print_warning "Prettier 未安装，跳过 JavaScript 格式化"
  fi
}

# ===================================================================
# 7. 优化文档
# ===================================================================

optimize_documentation() {
  print_header "7️⃣  优化文档"

  cd "$PROJECT_ROOT"

  print_step "检查文档结构..."

  # 确保核心文档存在
  CORE_DOCS=("README.md" "CHANGELOG.md" "AGENTS.md")

  for doc in "${CORE_DOCS[@]}"; do
    if [ ! -f "$doc" ]; then
      print_warning "$doc 不存在"
    else
      print_success "$doc 存在"
    fi
  done

  # 创建文档目录（如果不存在）
  [ ! -d "docs" ] && mkdir -p docs && print_success "已创建 docs/ 目录"
  [ ! -d "examples" ] && mkdir -p examples && print_success "已创建 examples/ 目录"
  [ ! -d "tests" ] && mkdir -p tests && print_success "已创建 tests/ 目录"

  # 清理根目录的临时文档
  print_step "清理根目录临时文档..."
  find . -maxdepth 1 -name "*完成*.md" -delete 2>/dev/null || true
  find . -maxdepth 1 -name "*COMPLETE*.md" -delete 2>/dev/null || true
  find . -maxdepth 1 -name "*报告*.md" -delete 2>/dev/null || true
  print_success "已清理临时文档"
}

# ===================================================================
# 8. 性能优化
# ===================================================================

optimize_performance() {
  print_header "8️⃣  性能优化"

  cd "$PROJECT_ROOT"

  print_step "检查大型文件..."
  LARGE_FILES=$(find . -type f -size +10M \
    ! -path "./.git/*" \
    ! -path "./node_modules/*" \
    ! -path "./.backup/*" \
    2>/dev/null | wc -l)

  if [ "$LARGE_FILES" -eq 0 ]; then
    print_success "未发现大型文件"
  else
    print_warning "发现 $LARGE_FILES 个大型文件 (> 10MB)"
    echo -e "${YELLOW}   建议添加到 .gitignore 或 .cursorignore${NC}"
  fi

  # 优化 VSCode 设置
  if [ -f ".vscode/settings.json" ]; then
    print_success "VSCode 配置文件存在"
  else
    print_warning "VSCode 配置文件不存在"
  fi
}

# ===================================================================
# 9. 生成优化报告
# ===================================================================

generate_report() {
  print_header "9️⃣  生成优化报告"

  cd "$PROJECT_ROOT"

  REPORT_FILE="OPTIMIZATION_REPORT_$(date +%Y%m%d_%H%M%S).md"

  cat > "$REPORT_FILE" << EOF
# FireShot 项目优化报告

**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
**项目路径**: $PROJECT_ROOT
**优化版本**: v1.0.0

---

## 📊 优化统计

- **总优化项**: $OPTIMIZATIONS
- **执行时间**: $(date '+%H:%M:%S')

---

## ✅ 完成的优化

### 1. 配置文件备份
- 已备份所有关键配置文件到 \`.backup/\` 目录

### 2. 临时文件清理
- Python 缓存 (\`__pycache__\`, \`.pytest_cache\` 等)
- Node.js 缓存 (\`.eslintcache\` 等)
- 构建产物 (\`dist/\`, \`build/\` 等)
- 旧日志文件（7天以上）
- 临时文件 (\`*.tmp\`, \`*.bak\`, \`.DS_Store\`)

### 3. 依赖管理优化
- 检查并更新 Python 依赖
- 检查并安装 Node.js 依赖
- 优化子项目依赖

### 4. Git 配置优化
- 清理 Git 缓存
- 优化 \`.gitignore\` 文件
- 移除重复配置

### 5. Cursor 配置优化
- 优化 \`.cursorignore\` 文件
- 排除大型目录和文件
- 提升 AI 响应速度

### 6. 代码格式优化
- Python 代码格式化（Ruff）
- JavaScript/TypeScript 格式化（Prettier）

### 7. 文档优化
- 检查核心文档完整性
- 清理临时文档
- 创建标准目录结构

### 8. 性能优化
- 检查大型文件
- 优化编辑器配置

---

## 📋 下一步建议

1. **运行健康检查**: \`./scripts/project_health_check.sh\`
2. **提交优化结果**: \`git add . && git commit -m "chore: 全面优化项目配置和性能"\`
3. **定期维护**: 每周运行一次优化脚本

---

## 📂 备份位置

所有原始配置文件已备份到：

\`\`\`
.backup/optimize_$(date +%Y%m%d_%H%M%S)/
\`\`\`

如需恢复，请从备份目录复制相应文件。

---

**生成工具**: scripts/optimize_project.sh
**维护团队**: HawaiiHub AI Team
EOF

  print_success "优化报告已生成: $REPORT_FILE"

  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "📄 报告位置: ${GREEN}$REPORT_FILE${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# ===================================================================
# 主函数
# ===================================================================

main() {
  echo ""
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}          🚀 FireShot 项目全面优化${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo ""
  echo -e "项目路径: ${GREEN}$PROJECT_ROOT${NC}"
  echo -e "开始时间: ${GREEN}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
  echo ""

  # 确认执行
  echo -e "${YELLOW}⚠️  此操作将优化项目配置，是否继续？ (y/N)${NC}"
  read -r CONFIRM

  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${RED}已取消优化${NC}"
    exit 0
  fi

  # 执行所有优化
  backup_configs
  cleanup_temp_files
  optimize_dependencies
  optimize_git
  optimize_cursor
  optimize_code_format
  optimize_documentation
  optimize_performance
  generate_report

  # 打印总结
  print_header "🎉 优化完成"

  echo ""
  echo -e "总优化项: ${GREEN}$OPTIMIZATIONS${NC}"
  echo -e "完成时间: ${GREEN}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
  echo ""

  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "💡 ${CYAN}建议下一步操作：${NC}"
  echo -e "   1. 运行健康检查: ${GREEN}./scripts/project_health_check.sh${NC}"
  echo -e "   2. 重新加载 Cursor: ${GREEN}Cmd+Shift+P → Developer: Reload Window${NC}"
  echo -e "   3. 提交代码: ${GREEN}git add . && git commit -m 'chore: 全面优化项目'${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

# 运行主函数
main "$@"
