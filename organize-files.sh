#!/bin/bash

# ============ FireShot 项目文件自动整理脚本 ============
# 用途：将根目录散落的文档文件整理到 docs/ 目录
# 版本：v1.0
# 更新时间：2025-10-27

set -e  # 遇到错误立即退出

echo "📁 FireShot 项目文件自动整理"
echo "================================"
echo ""

# 检查是否在正确的目录
if [ ! -f "README.md" ] || [ ! -f "package.json" ]; then
    echo "❌ 错误：请在 FireShot 项目根目录下运行此脚本"
    exit 1
fi

# 创建备份（跳过权限错误）
echo "💾 步骤 1/6: 创建备份..."
echo "   (跳过无权限访问的文件)"
BACKUP_DIR="../fireshot-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 只备份文档文件（不备份整个项目）
cp *.md "$BACKUP_DIR/" 2>/dev/null || true
cp *.sh "$BACKUP_DIR/" 2>/dev/null || true
cp *.json "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ 备份已保存到: $BACKUP_DIR"
echo ""

# 创建目录结构
echo "📁 步骤 2/6: 创建目录结构..."
mkdir -p docs/guides
mkdir -p docs/reports
mkdir -p docs/analysis
mkdir -p docs/setup
mkdir -p docs/archive
echo "✅ 目录结构创建完成"
echo ""

# 移动指南文档
echo "📖 步骤 3/6: 整理指南文档..."
moved_guides=0

for file in \
    FIRECRAWL_QUICK_START.md \
    FIRECRAWL_ECOSYSTEM_SETUP.md \
    FIRECRAWL_SETUP_COMPLETE.md \
    MARKDOWN_SETUP_GUIDE.md \
    QUICK_REFERENCE_GUIDE.md \
    CURSOR_GPT_TEMPLATES.md
do
    if [ -f "$file" ]; then
        mv "$file" docs/guides/
        echo "  ✓ $file → docs/guides/"
        ((moved_guides++))
    fi
done

echo "✅ 已移动 $moved_guides 个指南文档"
echo ""

# 移动报告文档
echo "📊 步骤 4/6: 整理报告文档..."
moved_reports=0

for file in \
    CONFIGURATION_REPORT.md \
    PROJECT_CLEANUP_REPORT.md \
    CURSOR_RULES_UPDATE_SUMMARY.md \
    docs_sync_report.md \
    FIRECRAWL_文档翻译完成总结.md \
    FIRECRAWL_文档翻译状态报告.md \
    Firecrawl文档整理完成报告.md \
    项目清理完成总结.md
do
    if [ -f "$file" ]; then
        mv "$file" docs/reports/
        echo "  ✓ $file → docs/reports/"
        ((moved_reports++))
    fi
done

echo "✅ 已移动 $moved_reports 个报告文档"
echo ""

# 移动分析文档
echo "🔍 步骤 5/6: 整理分析文档..."
moved_analysis=0

for file in \
    AI_WORKFLOW_RESEARCH_SUMMARY.md \
    GITHUB_PROJECTS_ANALYSIS.md \
    PROJECT_STRUCTURE_OPTIMIZATION.md
do
    if [ -f "$file" ]; then
        mv "$file" docs/analysis/
        echo "  ✓ $file → docs/analysis/"
        ((moved_analysis++))
    fi
done

echo "✅ 已移动 $moved_analysis 个分析文档"
echo ""

# 移动配置文档
echo "⚙️ 步骤 6/6: 整理配置文档..."
moved_setup=0

for file in \
    API_KEYS_SETUP.md \
    SETUP_COMPLETE.md \
    CLOUD_API_RULES_SUMMARY.md \
    README_文档翻译.md
do
    if [ -f "$file" ]; then
        mv "$file" docs/setup/
        echo "  ✓ $file → docs/setup/"
        ((moved_setup++))
    fi
done

# 移动旧版文档到归档
if [ -f "QUICK_REFERENCE.md" ]; then
    mv QUICK_REFERENCE.md docs/archive/
    echo "  ✓ QUICK_REFERENCE.md → docs/archive/（旧版）"
    ((moved_setup++))
fi

echo "✅ 已移动 $moved_setup 个配置文档"
echo ""

# 清理空文件
echo "🗑️ 清理空文件..."
if [ -f ".md" ]; then
    rm -f .md
    echo "  ✓ 已删除空文件: .md"
fi
echo ""

# 统计结果
echo "================================"
echo "✅ 整理完成！"
echo ""
echo "📊 统计："
echo "  - 指南文档: $moved_guides 个"
echo "  - 报告文档: $moved_reports 个"
echo "  - 分析文档: $moved_analysis 个"
echo "  - 配置文档: $moved_setup 个"
echo "  - 总计移动: $((moved_guides + moved_reports + moved_analysis + moved_setup)) 个文件"
echo ""
echo "📁 新目录结构："
tree -L 2 docs/ 2>/dev/null || {
    echo "  docs/"
    echo "    ├── guides/    ($moved_guides 个文件)"
    echo "    ├── reports/   ($moved_reports 个文件)"
    echo "    ├── analysis/  ($moved_analysis 个文件)"
    echo "    ├── setup/     ($moved_setup 个文件)"
    echo "    └── archive/   (旧版文档)"
}
echo ""
echo "🎯 根目录保留："
echo "  - README.md"
echo "  - 配置文件（package.json, tsconfig.json, requirements.txt）"
echo "  - 脚本文件（quick-setup-firecrawl.sh, organize-files.sh）"
echo ""
echo "💾 备份位置: $BACKUP_DIR"
echo ""
echo "⚠️  提示："
echo "  1. 请检查 docs/ 目录下的文件是否正确"
echo "  2. 如需恢复，运行: cp -r $BACKUP_DIR/* ."
echo "  3. 更新 README.md 中的文件路径引用"
echo ""
echo "================================"
