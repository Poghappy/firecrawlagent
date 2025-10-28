#!/bin/bash
# ===================================================================
# FireShot 项目健康检查脚本
# ===================================================================
# 功能：全面检查项目配置、依赖、安全性和性能
# 版本：v1.0.0
# 作者：HawaiiHub AI Team
# ===================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 计数器
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ===================================================================
# 辅助函数
# ===================================================================

print_header() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}  $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

check_pass() {
  TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
  PASSED_CHECKS=$((PASSED_CHECKS + 1))
  echo -e "${GREEN}✅ $1${NC}"
}

check_fail() {
  TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
  FAILED_CHECKS=$((FAILED_CHECKS + 1))
  echo -e "${RED}❌ $1${NC}"
  if [ -n "$2" ]; then
    echo -e "${RED}   → $2${NC}"
  fi
}

check_warn() {
  TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
  WARNING_CHECKS=$((WARNING_CHECKS + 1))
  echo -e "${YELLOW}⚠️  $1${NC}"
  if [ -n "$2" ]; then
    echo -e "${YELLOW}   → $2${NC}"
  fi
}

# ===================================================================
# 1. 环境检查
# ===================================================================

check_environment() {
  print_header "1️⃣  环境检查"

  # Python 版本
  if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    if [[ $(echo "$PYTHON_VERSION" | cut -d. -f1) -ge 3 ]] && [[ $(echo "$PYTHON_VERSION" | cut -d. -f2) -ge 11 ]]; then
      check_pass "Python 版本: $PYTHON_VERSION (>= 3.11)"
    else
      check_warn "Python 版本: $PYTHON_VERSION" "建议升级到 3.11+"
    fi
  else
    check_fail "Python 未安装" "请安装 Python 3.11+"
  fi

  # Node.js 版本
  if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | sed 's/v//')
    if [[ $(echo "$NODE_VERSION" | cut -d. -f1) -ge 18 ]]; then
      check_pass "Node.js 版本: $NODE_VERSION (>= 18)"
    else
      check_warn "Node.js 版本: $NODE_VERSION" "建议升级到 18+"
    fi
  else
    check_fail "Node.js 未安装" "请安装 Node.js 18+"
  fi

  # Git 版本
  if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    check_pass "Git 版本: $GIT_VERSION"
  else
    check_fail "Git 未安装"
  fi
}

# ===================================================================
# 2. 配置文件检查
# ===================================================================

check_config_files() {
  print_header "2️⃣  配置文件检查"

  cd "$PROJECT_ROOT"

  # 必需配置文件
  REQUIRED_FILES=(
    ".cursorrules"
    ".gitignore"
    ".editorconfig"
    "pyproject.toml"
    "package.json"
    "env.template"
    "README.md"
    "AGENTS.md"
    "CHANGELOG.md"
  )

  for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
      check_pass "存在: $file"
    else
      check_fail "缺失: $file" "请创建此文件"
    fi
  done

  # 可选但推荐的文件
  OPTIONAL_FILES=(
    ".prettierrc.json"
    ".prettierignore"
    ".markdownlint.json"
    ".eslintignore"
    "Makefile"
    "tsconfig.json"
  )

  for file in "${OPTIONAL_FILES[@]}"; do
    if [ -f "$file" ]; then
      check_pass "存在: $file (可选)"
    else
      check_warn "缺失: $file (可选)" "建议添加以提升项目质量"
    fi
  done

  # .env 文件检查
  if [ -f ".env" ]; then
    check_pass "存在: .env"

    # 检查是否被 Git 忽略
    if grep -q "^\.env$" .gitignore 2>/dev/null; then
      check_pass ".env 已在 .gitignore 中"
    else
      check_fail ".env 未在 .gitignore 中" "安全风险！请立即添加"
    fi
  else
    check_warn "缺失: .env" "如果项目需要环境变量，请从 env.template 复制"
  fi
}

# ===================================================================
# 3. 依赖检查
# ===================================================================

check_dependencies() {
  print_header "3️⃣  依赖检查"

  cd "$PROJECT_ROOT"

  # Python 依赖
  if [ -f "pyproject.toml" ]; then
    check_pass "Python 依赖配置: pyproject.toml"

    # 检查是否有必需的包
    if grep -q "firecrawl-py" pyproject.toml; then
      check_pass "包含: firecrawl-py"
    else
      check_warn "缺少: firecrawl-py" "主项目核心依赖"
    fi
  fi

  # Node.js 依赖
  if [ -f "package.json" ]; then
    check_pass "Node.js 依赖配置: package.json"

    # 检查 node_modules
    if [ -d "node_modules" ]; then
      NODE_MODULES_SIZE=$(du -sh node_modules 2>/dev/null | awk '{print $1}')
      check_pass "node_modules 存在 (大小: $NODE_MODULES_SIZE)"
    else
      check_warn "node_modules 不存在" "运行 npm install"
    fi
  fi

  # 子项目依赖检查
  if [ -d "hawaiihub-admin-agent" ] && [ -f "hawaiihub-admin-agent/package.json" ]; then
    check_pass "子项目依赖配置: hawaiihub-admin-agent/package.json"
  fi
}

# ===================================================================
# 4. 安全检查
# ===================================================================

check_security() {
  print_header "4️⃣  安全检查"

  cd "$PROJECT_ROOT"

  # 检查敏感文件是否被忽略
  SENSITIVE_FILES=(".env" ".env.local" ".env.production" "*.key" "*.pem")

  for pattern in "${SENSITIVE_FILES[@]}"; do
    if grep -q "$pattern" .gitignore 2>/dev/null; then
      check_pass "已忽略: $pattern"
    else
      check_fail "未忽略: $pattern" "安全风险！请添加到 .gitignore"
    fi
  done

  # 检查是否有硬编码的 API 密钥
  echo -e "\n${BLUE}检查硬编码 API 密钥...${NC}"
  HARDCODED_KEYS=$(grep -r "api[_-]key.*=.*['\"][a-zA-Z0-9]\{20,\}" \
    --include="*.py" --include="*.js" --include="*.ts" \
    --exclude-dir=node_modules --exclude-dir=.git \
    --exclude-dir=.backup 2>/dev/null | wc -l)

  if [ "$HARDCODED_KEYS" -eq 0 ]; then
    check_pass "未发现硬编码 API 密钥"
  else
    check_fail "发现 $HARDCODED_KEYS 个可疑的硬编码 API 密钥" "请检查代码并使用环境变量"
  fi
}

# ===================================================================
# 5. 代码质量检查
# ===================================================================

check_code_quality() {
  print_header "5️⃣  代码质量检查"

  cd "$PROJECT_ROOT"

  # Python 工具
  if command -v ruff &> /dev/null; then
    check_pass "Ruff 已安装 (Python linter)"
  else
    check_warn "Ruff 未安装" "建议安装: pip install ruff"
  fi

  if command -v mypy &> /dev/null; then
    check_pass "MyPy 已安装 (类型检查)"
  else
    check_warn "MyPy 未安装" "建议安装: pip install mypy"
  fi

  # Node.js 工具
  if [ -f "node_modules/.bin/eslint" ]; then
    check_pass "ESLint 已安装 (JavaScript linter)"
  else
    check_warn "ESLint 未安装" "建议添加到 devDependencies"
  fi

  if [ -f "node_modules/.bin/prettier" ]; then
    check_pass "Prettier 已安装 (代码格式化)"
  else
    check_warn "Prettier 未安装" "建议添加到 devDependencies"
  fi
}

# ===================================================================
# 6. 文档检查
# ===================================================================

check_documentation() {
  print_header "6️⃣  文档检查"

  cd "$PROJECT_ROOT"

  # 核心文档
  CORE_DOCS=("README.md" "CHANGELOG.md" "AGENTS.md")

  for doc in "${CORE_DOCS[@]}"; do
    if [ -f "$doc" ]; then
      SIZE=$(wc -c < "$doc")
      if [ "$SIZE" -gt 100 ]; then
        check_pass "$doc 存在且非空 (${SIZE} 字节)"
      else
        check_warn "$doc 存在但太小 (${SIZE} 字节)" "内容可能不完整"
      fi
    else
      check_fail "$doc 缺失"
    fi
  done

  # 检查文档目录
  if [ -d "docs" ]; then
    DOC_COUNT=$(find docs -name "*.md" 2>/dev/null | wc -l)
    check_pass "docs/ 目录存在 (包含 $DOC_COUNT 个 Markdown 文件)"
  else
    check_warn "docs/ 目录不存在" "建议创建以组织文档"
  fi

  # 检查示例代码
  if [ -d "examples" ]; then
    EXAMPLE_COUNT=$(find examples -name "*.py" -o -name "*.js" 2>/dev/null | wc -l)
    check_pass "examples/ 目录存在 (包含 $EXAMPLE_COUNT 个示例)"
  else
    check_warn "examples/ 目录不存在" "建议创建示例代码"
  fi
}

# ===================================================================
# 7. 性能检查
# ===================================================================

check_performance() {
  print_header "7️⃣  性能检查"

  cd "$PROJECT_ROOT"

  # 检查 .cursorignore
  if [ -f ".cursorignore" ]; then
    check_pass ".cursorignore 存在"

    # 检查是否排除了大型目录
    LARGE_DIRS=("node_modules" "data" "logs" ".backup")
    for dir in "${LARGE_DIRS[@]}"; do
      if grep -q "^$dir" .cursorignore 2>/dev/null; then
        check_pass "已排除大型目录: $dir"
      else
        check_warn "未排除大型目录: $dir" "可能影响 Cursor 性能"
      fi
    done
  else
    check_warn ".cursorignore 不存在" "建议创建以提升 Cursor 性能"
  fi

  # 检查大型文件
  echo -e "\n${BLUE}检查大型文件 (> 10MB)...${NC}"
  LARGE_FILES=$(find . -type f -size +10M \
    ! -path "./.git/*" \
    ! -path "./node_modules/*" \
    ! -path "./.backup/*" \
    2>/dev/null | wc -l)

  if [ "$LARGE_FILES" -eq 0 ]; then
    check_pass "未发现大型文件"
  else
    check_warn "发现 $LARGE_FILES 个大型文件 (> 10MB)" "建议添加到 .gitignore 或 .cursorignore"
  fi
}

# ===================================================================
# 8. Git 仓库检查
# ===================================================================

check_git() {
  print_header "8️⃣  Git 仓库检查"

  cd "$PROJECT_ROOT"

  if [ -d ".git" ]; then
    check_pass "Git 仓库已初始化"

    # 检查远程仓库
    if git remote -v | grep -q "origin"; then
      REMOTE_URL=$(git remote get-url origin)
      check_pass "已配置远程仓库: $REMOTE_URL"
    else
      check_warn "未配置远程仓库" "建议添加 GitHub 远程仓库"
    fi

    # 检查当前分支
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    check_pass "当前分支: $CURRENT_BRANCH"

    # 检查未提交的更改
    if git diff --quiet && git diff --cached --quiet; then
      check_pass "工作目录干净"
    else
      CHANGED_FILES=$(git status --short | wc -l)
      check_warn "有 $CHANGED_FILES 个文件未提交" "建议定期提交代码"
    fi
  else
    check_fail "Git 仓库未初始化" "运行 git init"
  fi
}

# ===================================================================
# 主函数
# ===================================================================

main() {
  echo ""
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}          🔍 FireShot 项目健康检查${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo ""
  echo -e "项目路径: ${GREEN}$PROJECT_ROOT${NC}"
  echo -e "检查时间: ${GREEN}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
  echo ""

  # 执行所有检查
  check_environment
  check_config_files
  check_dependencies
  check_security
  check_code_quality
  check_documentation
  check_performance
  check_git

  # 打印总结
  print_header "📊 检查总结"

  echo ""
  echo -e "总检查项: ${BLUE}$TOTAL_CHECKS${NC}"
  echo -e "通过: ${GREEN}$PASSED_CHECKS${NC}"
  echo -e "警告: ${YELLOW}$WARNING_CHECKS${NC}"
  echo -e "失败: ${RED}$FAILED_CHECKS${NC}"
  echo ""

  # 计算健康度
  HEALTH_SCORE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "项目健康度: ${GREEN}$HEALTH_SCORE%${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  # 提供建议
  if [ "$HEALTH_SCORE" -ge 90 ]; then
    echo -e "${GREEN}🎉 优秀！项目配置非常健康！${NC}"
  elif [ "$HEALTH_SCORE" -ge 75 ]; then
    echo -e "${YELLOW}👍 良好！有一些小问题需要改进。${NC}"
  elif [ "$HEALTH_SCORE" -ge 60 ]; then
    echo -e "${YELLOW}⚠️  一般。建议尽快解决失败和警告的项目。${NC}"
  else
    echo -e "${RED}❌ 需要改进！请立即处理失败的检查项。${NC}"
  fi

  echo ""
  echo -e "${BLUE}💡 下一步行动：${NC}"
  if [ "$FAILED_CHECKS" -gt 0 ]; then
    echo -e "   1. 解决 ${RED}$FAILED_CHECKS${NC} 个失败的检查项"
  fi
  if [ "$WARNING_CHECKS" -gt 0 ]; then
    echo -e "   2. 改进 ${YELLOW}$WARNING_CHECKS${NC} 个警告项"
  fi
  echo -e "   3. 定期运行此脚本监控项目健康状态"
  echo ""

  # 返回状态
  if [ "$FAILED_CHECKS" -gt 0 ]; then
    exit 1
  else
    exit 0
  fi
}

# 运行主函数
main "$@"
