#!/bin/bash

# OpenSpec Agent 团队培训启动脚本
# 项目: FireShot
# 版本: v1.0.0
# 更新: 2025-10-28

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# 项目根目录
PROJECT_ROOT="/Users/zhiledeng/Downloads/FireShot"
OPENSPEC_DIR="${PROJECT_ROOT}/openspec"

# 清屏
clear

# 显示欢迎信息
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}OpenSpec Agent 团队培训系统${NC}                              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}FireShot 项目 - HawaiiHub AI Team${NC}                       ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 检查环境
echo -e "${YELLOW}🔍 正在检查培训环境...${NC}"
echo ""

# 检查 OpenSpec CLI
if command -v openspec &> /dev/null; then
    echo -e "${GREEN}✓${NC} OpenSpec CLI 已安装"
    OPENSPEC_VERSION=$(openspec --version 2>&1 | head -n 1 || echo "未知版本")
    echo -e "  版本: ${OPENSPEC_VERSION}"
else
    echo -e "${RED}✗${NC} OpenSpec CLI 未安装"
    echo -e "  请运行: ${CYAN}npm install -g @fission-ai/openspec@latest${NC}"
    exit 1
fi

# 检查项目目录
if [ -d "$OPENSPEC_DIR" ]; then
    echo -e "${GREEN}✓${NC} OpenSpec 目录存在"
else
    echo -e "${RED}✗${NC} OpenSpec 目录不存在"
    exit 1
fi

# 检查培训文档
TRAINING_DOCS=(
    "${OPENSPEC_DIR}/README.md"
    "${OPENSPEC_DIR}/AGENT_TEAM_QUICKSTART.md"
    "${OPENSPEC_DIR}/AGENT_ROLES_GUIDE.md"
    "${OPENSPEC_DIR}/project.md"
)

MISSING_DOCS=0
for doc in "${TRAINING_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        echo -e "${GREEN}✓${NC} $(basename $doc)"
    else
        echo -e "${RED}✗${NC} $(basename $doc) 缺失"
        MISSING_DOCS=$((MISSING_DOCS + 1))
    fi
done

if [ $MISSING_DOCS -gt 0 ]; then
    echo -e "${RED}错误: 缺少 $MISSING_DOCS 个培训文档${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ 环境检查完成！所有培训资料已就绪。${NC}"
echo ""

# 显示学习路径
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}📚 3 天学习路径${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}第 1 天：环境熟悉${NC} (总计约 60 分钟)"
echo -e "  ${GREEN}✓${NC} 阅读 README.md (10 分钟)"
echo -e "  ${GREEN}✓${NC} 阅读 AGENT_TEAM_QUICKSTART.md (30 分钟)"
echo -e "  ${GREEN}✓${NC} 完成 3 个实战练习 (20 分钟)"
echo ""
echo -e "${CYAN}第 2 天：规范学习${NC} (总计约 35 分钟)"
echo -e "  ${GREEN}✓${NC} 阅读 project.md (15 分钟)"
echo -e "  ${GREEN}✓${NC} 阅读爬虫规范示例 (10 分钟)"
echo -e "  ${GREEN}✓${NC} 阅读数据规范示例 (10 分钟)"
echo ""
echo -e "${CYAN}第 3 天：角色定位${NC} (总计约 2.5 小时)"
echo -e "  ${GREEN}✓${NC} 阅读 AGENT_ROLES_GUIDE.md (20 分钟)"
echo -e "  ${GREEN}✓${NC} 明确自己的角色职责 (10 分钟)"
echo -e "  ${GREEN}✓${NC} 创建第一个真实变更 (2 小时)"
echo ""

# 询问用户选择
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}请选择培训阶段：${NC}"
echo ""
echo -e "  ${CYAN}1${NC} - 第 1 天：环境熟悉 (从头开始)"
echo -e "  ${CYAN}2${NC} - 第 2 天：规范学习"
echo -e "  ${CYAN}3${NC} - 第 3 天：角色定位"
echo -e "  ${CYAN}4${NC} - 查看所有培训文档列表"
echo -e "  ${CYAN}5${NC} - 运行快速验证测试"
echo -e "  ${CYAN}q${NC} - 退出"
echo ""
echo -ne "${YELLOW}请输入选项 [1-5/q]: ${NC}"
read -r choice

case $choice in
    1)
        # 第 1 天培训
        clear
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}  ${BOLD}第 1 天：环境熟悉${NC}                                          ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${YELLOW}📖 步骤 1/3: 阅读文档导航索引 (10 分钟)${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "即将打开: ${CYAN}openspec/README.md${NC}"
        echo ""
        echo -ne "${YELLOW}按 Enter 继续...${NC}"
        read
        
        cat "${OPENSPEC_DIR}/README.md"
        
        echo ""
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo -ne "${YELLOW}已完成阅读？按 Enter 继续下一步...${NC}"
        read
        
        clear
        echo -e "${YELLOW}📖 步骤 2/3: 30分钟快速上手培训${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "即将打开: ${CYAN}openspec/AGENT_TEAM_QUICKSTART.md${NC}"
        echo ""
        echo -e "${GREEN}培训内容包括：${NC}"
        echo -e "  • 验证环境（2分钟）"
        echo -e "  • 理解核心概念（5分钟）"
        echo -e "  • 查看现有规范（8分钟）"
        echo -e "  • 创建第一个变更（10分钟）"
        echo -e "  • 实施变更（3分钟）"
        echo -e "  • 归档完成（2分钟）"
        echo ""
        echo -ne "${YELLOW}按 Enter 继续...${NC}"
        read
        
        cat "${OPENSPEC_DIR}/AGENT_TEAM_QUICKSTART.md"
        
        echo ""
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo -ne "${YELLOW}已完成阅读？按 Enter 继续实战练习...${NC}"
        read
        
        clear
        echo -e "${YELLOW}🎯 步骤 3/3: 实战练习 (20 分钟)${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "${BOLD}练习 1: 查找成本控制要求 (5 分钟)${NC}"
        echo ""
        echo -e "任务: 在 Firecrawl 爬虫规范中找出关于"成本控制"的要求"
        echo ""
        echo -e "${CYAN}提示命令:${NC}"
        echo -e "  cat openspec/specs/firecrawl-scraper/spec.md | grep -A 10 \"成本控制\""
        echo ""
        echo -e "问题："
        echo -e "  1. 系统在执行每次爬取前应该检查什么？"
        echo -e "  2. 缓存策略的参数是什么？"
        echo -e "  3. 成本记录应该输出到哪里？"
        echo ""
        echo -ne "${YELLOW}完成练习 1？按 Enter 继续...${NC}"
        read
        
        echo ""
        echo -e "${BOLD}练习 2: 创建变更提案 (10 分钟)${NC}"
        echo ""
        echo -e "任务: 创建一个"添加结构化日志记录"的变更提案"
        echo ""
        echo -e "${CYAN}在 Cursor 中对 AI 说:${NC}"
        echo -e "  ${GREEN}/openspec:proposal 添加结构化日志记录${NC}"
        echo ""
        echo -e "或自然语言："
        echo -e "  ${GREEN}创建一个 OpenSpec 变更提案：添加结构化日志记录${NC}"
        echo ""
        echo -e "然后运行："
        echo -e "  ${CYAN}openspec show add-logging${NC}"
        echo -e "  ${CYAN}openspec validate add-logging${NC}"
        echo ""
        echo -ne "${YELLOW}完成练习 2？按 Enter 继续...${NC}"
        read
        
        echo ""
        echo -e "${BOLD}练习 3: 审查规范差异 (5 分钟)${NC}"
        echo ""
        echo -e "任务: 查看 add-logging 变更的规范差异"
        echo ""
        echo -e "${CYAN}运行命令:${NC}"
        echo -e "  cat openspec/changes/add-logging/specs/*/spec.md"
        echo ""
        echo -e "检查："
        echo -e "  1. 规范差异使用什么标记（ADDED/MODIFIED/REMOVED）？"
        echo -e "  2. 每个 Requirement 是否都有至少一个 Scenario？"
        echo -e "  3. Scenario 是否遵循"当...则...并且..."格式？"
        echo ""
        echo -ne "${YELLOW}完成练习 3？按 Enter 继续...${NC}"
        read
        
        clear
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}  ${BOLD}🎉 恭喜！第 1 天培训完成！${NC}                               ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${CYAN}✅ 已完成:${NC}"
        echo -e "  • 阅读文档导航索引"
        echo -e "  • 完成 30 分钟快速上手培训"
        echo -e "  • 完成 3 个实战练习"
        echo ""
        echo -e "${YELLOW}📅 明天继续:${NC}"
        echo -e "  第 2 天 - 规范学习 (35 分钟)"
        echo ""
        echo -e "${PURPLE}提示: 再次运行此脚本并选择 \"2\" 继续第 2 天培训${NC}"
        echo ""
        ;;
        
    2)
        # 第 2 天培训
        clear
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}  ${BOLD}第 2 天：规范学习${NC}                                          ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${YELLOW}📖 步骤 1/3: 阅读项目全局规范 (15 分钟)${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "即将打开: ${CYAN}openspec/project.md${NC}"
        echo ""
        echo -e "${GREEN}关注要点：${NC}"
        echo -e "  • 项目定位和技术栈"
        echo -e "  • Python 代码标准（类型注解、命名约定）"
        echo -e "  • Firecrawl 使用规范（工具选择、成本控制）"
        echo -e "  • Git 提交规范（Conventional Commits）"
        echo ""
        echo -ne "${YELLOW}按 Enter 继续...${NC}"
        read
        
        cat "${OPENSPEC_DIR}/project.md"
        
        echo ""
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo -ne "${YELLOW}已完成阅读？按 Enter 继续...${NC}"
        read
        
        clear
        echo -e "${YELLOW}📖 步骤 2/3: 阅读 Firecrawl 爬虫规范 (10 分钟)${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "即将打开: ${CYAN}openspec/specs/firecrawl-scraper/spec.md${NC}"
        echo ""
        echo -e "${GREEN}学习重点：${NC}"
        echo -e "  • 工具选择策略（MCP vs SDK）"
        echo -e "  • API 密钥管理和轮换"
        echo -e "  • 错误处理和重试机制"
        echo -e "  • 成本控制（预算、缓存）"
        echo -e "  • 数据保存格式"
        echo ""
        echo -ne "${YELLOW}按 Enter 继续...${NC}"
        read
        
        cat "${OPENSPEC_DIR}/specs/firecrawl-scraper/spec.md"
        
        echo ""
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo -ne "${YELLOW}已完成阅读？按 Enter 继续...${NC}"
        read
        
        clear
        echo -e "${YELLOW}📖 步骤 3/3: 阅读 HawaiiHub 数据规范 (10 分钟)${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "即将打开: ${CYAN}openspec/specs/hawaiihub-data/spec.md${NC}"
        echo ""
        echo -e "${GREEN}关注点：${NC}"
        echo -e "  • 数据模型定义（Rental、Restaurant、Article）"
        echo -e "  • 数据清洗规则"
        echo -e "  • 存储格式要求（MD + JSON + CSV）"
        echo -e "  • 质量检查标准"
        echo ""
        echo -ne "${YELLOW}按 Enter 继续...${NC}"
        read
        
        cat "${OPENSPEC_DIR}/specs/hawaiihub-data/spec.md"
        
        echo ""
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        
        clear
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}  ${BOLD}🎉 恭喜！第 2 天培训完成！${NC}                               ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${CYAN}✅ 已完成:${NC}"
        echo -e "  • 阅读项目全局规范"
        echo -e "  • 学习 Firecrawl 爬虫规范"
        echo -e "  • 学习 HawaiiHub 数据规范"
        echo ""
        echo -e "${YELLOW}📅 明天继续:${NC}"
        echo -e "  第 3 天 - 角色定位与实战 (2.5 小时)"
        echo ""
        echo -e "${PURPLE}提示: 再次运行此脚本并选择 \"3\" 继续第 3 天培训${NC}"
        echo ""
        ;;
        
    3)
        # 第 3 天培训
        clear
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}  ${BOLD}第 3 天：角色定位${NC}                                          ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${YELLOW}📖 步骤 1/3: 阅读团队角色分工 (20 分钟)${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "即将打开: ${CYAN}openspec/AGENT_ROLES_GUIDE.md${NC}"
        echo ""
        echo -e "${GREEN}5 个专业角色：${NC}"
        echo -e "  • 📋 Product Agent（创建提案，20%）"
        echo -e "  • 💻 Development Agent（编写代码，50%）"
        echo -e "  • 🧪 Quality Agent（测试验证，15%）"
        echo -e "  • 📚 Documentation Agent（维护文档，10%）"
        echo -e "  • 🚀 DevOps Agent（部署监控，5%）"
        echo ""
        echo -ne "${YELLOW}按 Enter 继续...${NC}"
        read
        
        cat "${OPENSPEC_DIR}/AGENT_ROLES_GUIDE.md"
        
        echo ""
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo -ne "${YELLOW}已完成阅读？按 Enter 继续...${NC}"
        read
        
        clear
        echo -e "${YELLOW}🎯 步骤 2/3: 明确角色职责 (10 分钟)${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "${BOLD}请选择你的主要角色：${NC}"
        echo ""
        echo -e "  ${CYAN}1${NC} - Product Agent（产品规划）"
        echo -e "  ${CYAN}2${NC} - Development Agent（核心开发）"
        echo -e "  ${CYAN}3${NC} - Quality Agent（质量保证）"
        echo -e "  ${CYAN}4${NC} - Documentation Agent（文档维护）"
        echo -e "  ${CYAN}5${NC} - DevOps Agent（运维部署）"
        echo ""
        echo -ne "${YELLOW}请输入选项 [1-5]: ${NC}"
        read -r role_choice
        
        case $role_choice in
            1)
                ROLE_NAME="Product Agent"
                ROLE_DESC="产品规划 - 创建变更提案、定义需求"
                ROLE_CMD="/openspec:proposal <功能描述>"
                ;;
            2)
                ROLE_NAME="Development Agent"
                ROLE_DESC="核心开发 - 实施变更、编写代码"
                ROLE_CMD="/openspec:apply <变更名>"
                ;;
            3)
                ROLE_NAME="Quality Agent"
                ROLE_DESC="质量保证 - 测试验证、代码审查"
                ROLE_CMD="pytest tests/ --cov"
                ;;
            4)
                ROLE_NAME="Documentation Agent"
                ROLE_DESC="文档维护 - 编写文档、知识管理"
                ROLE_CMD="编写 API 文档和使用示例"
                ;;
            5)
                ROLE_NAME="DevOps Agent"
                ROLE_DESC="运维部署 - 部署监控、性能优化"
                ROLE_CMD="监控系统性能和成本"
                ;;
            *)
                ROLE_NAME="Development Agent"
                ROLE_DESC="核心开发 - 实施变更、编写代码"
                ROLE_CMD="/openspec:apply <变更名>"
                ;;
        esac
        
        clear
        echo -e "${GREEN}✅ 你选择的角色：${BOLD}${ROLE_NAME}${NC}"
        echo -e "${CYAN}职责：${ROLE_DESC}${NC}"
        echo -e "${YELLOW}核心命令：${ROLE_CMD}${NC}"
        echo ""
        echo -ne "${YELLOW}按 Enter 继续最后一步...${NC}"
        read
        
        clear
        echo -e "${YELLOW}🚀 步骤 3/3: 创建第一个真实变更 (2 小时)${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "${BOLD}实战任务：根据你的角色创建一个真实变更${NC}"
        echo ""
        
        if [ "$role_choice" == "1" ]; then
            echo -e "${GREEN}Product Agent 实战任务：${NC}"
            echo -e "  在 Cursor 中对 AI 说："
            echo -e "  ${CYAN}/openspec:proposal 添加夏威夷华人餐厅数据采集${NC}"
            echo ""
            echo -e "  要求："
            echo -e "  • 从 Yelp 采集华人餐厅信息"
            echo -e "  • 包含餐厅名称、菜系、地址、评分"
            echo -e "  • 每周更新一次"
        elif [ "$role_choice" == "2" ]; then
            echo -e "${GREEN}Development Agent 实战任务：${NC}"
            echo -e "  1. 查看现有变更："
            echo -e "     ${CYAN}openspec list${NC}"
            echo ""
            echo -e "  2. 选择一个变更实施："
            echo -e "     在 Cursor 中对 AI 说："
            echo -e "     ${CYAN}/openspec:apply <变更名>${NC}"
            echo ""
            echo -e "  3. 编写代码、测试、提交"
        else
            echo -e "${GREEN}你的实战任务：${NC}"
            echo -e "  根据角色分工指南中的示例任务"
            echo -e "  完成一个完整的工作流程"
        fi
        
        echo ""
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "${YELLOW}💡 提示：${NC}"
        echo -e "  • 遇到问题查看文档：cat openspec/README.md"
        echo -e "  • 查看规范示例：cat openspec/specs/*/spec.md"
        echo -e "  • 运行验证：openspec validate <变更名>"
        echo ""
        echo -ne "${YELLOW}准备好开始实战了吗？按 Enter 完成培训...${NC}"
        read
        
        clear
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}  ${BOLD}🎉 恭喜！3 天培训全部完成！${NC}                             ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${CYAN}✅ 培训成果:${NC}"
        echo -e "  • 熟悉 OpenSpec 环境和工具"
        echo -e "  • 理解项目规范和编码标准"
        echo -e "  • 明确自己的角色和职责"
        echo -e "  • 能够独立创建和实施变更"
        echo ""
        echo -e "${YELLOW}🚀 下一步:${NC}"
        echo -e "  • 完成至少 2-3 个真实变更"
        echo -e "  • 与团队建立协作"
        echo -e "  • 持续优化规范库"
        echo ""
        echo -e "${PURPLE}你现在已经是 FireShot Agent 团队的正式成员了！${NC}"
        echo ""
        ;;
        
    4)
        # 查看所有文档
        clear
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}  ${BOLD}OpenSpec 培训文档列表${NC}                                    ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${YELLOW}📚 核心培训文档${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        ls -lh "${OPENSPEC_DIR}/README.md" 2>/dev/null || echo "  README.md (缺失)"
        ls -lh "${OPENSPEC_DIR}/AGENT_TEAM_QUICKSTART.md" 2>/dev/null || echo "  AGENT_TEAM_QUICKSTART.md (缺失)"
        ls -lh "${OPENSPEC_DIR}/AGENT_ROLES_GUIDE.md" 2>/dev/null || echo "  AGENT_ROLES_GUIDE.md (缺失)"
        ls -lh "${OPENSPEC_DIR}/project.md" 2>/dev/null || echo "  project.md (缺失)"
        echo ""
        
        echo -e "${YELLOW}📖 规范文档${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        ls -lh "${OPENSPEC_DIR}/specs/firecrawl-scraper/spec.md" 2>/dev/null || echo "  firecrawl-scraper/spec.md (缺失)"
        ls -lh "${OPENSPEC_DIR}/specs/hawaiihub-data/spec.md" 2>/dev/null || echo "  hawaiihub-data/spec.md (缺失)"
        echo ""
        
        echo -e "${YELLOW}📑 其他文档${NC}"
        echo -e "${PURPLE}───────────────────────────────────────────────────────────────${NC}"
        ls -lh "${PROJECT_ROOT}/OPENSPEC_GUIDE.md" 2>/dev/null || echo "  OPENSPEC_GUIDE.md (缺失)"
        ls -lh "${PROJECT_ROOT}/OPENSPEC_SETUP_COMPLETE.md" 2>/dev/null || echo "  OPENSPEC_SETUP_COMPLETE.md (缺失)"
        ls -lh "${PROJECT_ROOT}/AGENTS.md" 2>/dev/null || echo "  AGENTS.md (缺失)"
        echo ""
        ;;
        
    5)
        # 快速验证
        clear
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}  ${BOLD}OpenSpec 环境验证${NC}                                        ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${YELLOW}运行验证测试...${NC}"
        echo ""
        
        # 运行 openspec list
        echo -e "${CYAN}► openspec list${NC}"
        cd "$PROJECT_ROOT" && openspec list
        echo ""
        
        # 检查规范文件数
        SPEC_COUNT=$(find "${OPENSPEC_DIR}/specs" -name "spec.md" 2>/dev/null | wc -l)
        echo -e "规范模块数: ${GREEN}${SPEC_COUNT}${NC}"
        echo ""
        
        # 检查变更数
        CHANGE_COUNT=$(find "${OPENSPEC_DIR}/changes" -maxdepth 1 -type d 2>/dev/null | wc -l)
        CHANGE_COUNT=$((CHANGE_COUNT - 1))  # 减去 changes 目录自身
        echo -e "活动变更数: ${YELLOW}${CHANGE_COUNT}${NC}"
        echo ""
        
        echo -e "${GREEN}✅ 验证完成！${NC}"
        echo ""
        ;;
        
    q|Q)
        echo ""
        echo -e "${CYAN}感谢使用 OpenSpec 培训系统！${NC}"
        echo -e "${YELLOW}随时回来继续学习。${NC}"
        echo ""
        exit 0
        ;;
        
    *)
        echo ""
        echo -e "${RED}无效选项，请重新运行脚本。${NC}"
        echo ""
        exit 1
        ;;
esac

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "培训脚本执行完毕。再次运行可选择其他培训阶段。"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

