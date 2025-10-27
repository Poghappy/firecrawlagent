#!/bin/bash

# ============ .cursor 目录优化脚本 ============
# 用途：将非官方的 .cursor 目录重构为符合 Cursor 官方规范
# 版本：v1.0
# 更新时间：2025-10-27

set -e  # 遇到错误立即退出

echo "🔧 .cursor 目录优化脚本"
echo "================================"
echo ""
echo "📋 优化目标："
echo "  ✅ 符合 Cursor 官方规范"
echo "  ✅ 移除非官方 .cursor 目录"
echo "  ✅ 重新组织文件到正确位置"
echo ""

# 检查是否在正确的目录
if [ ! -f ".cursorrules" ]; then
    echo "❌ 错误：请在 FireShot 项目根目录下运行此脚本"
    exit 1
fi

# 检查 .cursor 目录是否存在
if [ ! -d ".cursor" ]; then
    echo "ℹ️  .cursor 目录不存在，无需优化"
    exit 0
fi

# 创建备份
echo "💾 步骤 1/7: 创建备份..."
BACKUP_DIR="../fireshot-cursor-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r .cursor "$BACKUP_DIR/"
echo "✅ 备份已保存到: $BACKUP_DIR"
echo ""

# 创建新目录结构
echo "📁 步骤 2/7: 创建新目录结构..."
mkdir -p docs/cursor-guides
mkdir -p templates/python
echo "✅ 新目录创建完成"
echo ""

# 移动 rules 文件
echo "📖 步骤 3/7: 移动规则文档..."
moved_rules=0

if [ -d ".cursor/rules" ]; then
    for file in .cursor/rules/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            mv "$file" "docs/cursor-guides/$filename"
            echo "  ✅ $filename → docs/cursor-guides/"
            ((moved_rules++))
        fi
    done
fi

echo "✅ 移动了 $moved_rules 个规则文件"
echo ""

# 移动 docs 文件
echo "📄 步骤 4/7: 移动文档文件..."
moved_docs=0

if [ -d ".cursor/docs" ]; then
    for file in .cursor/docs/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            mv "$file" "docs/cursor-guides/$filename"
            echo "  ✅ $filename → docs/cursor-guides/"
            ((moved_docs++))
        fi
    done
fi

echo "✅ 移动了 $moved_docs 个文档文件"
echo ""

# 移动 templates 文件
echo "🔧 步骤 5/7: 移动模板文件..."
moved_templates=0

if [ -d ".cursor/templates" ]; then
    for file in .cursor/templates/*.py; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            # 转换文件名：template.py → _template.py（Python 命名规范）
            new_filename="${filename//-/_}"
            mv "$file" "templates/python/$new_filename"
            echo "  ✅ $filename → templates/python/$new_filename"
            ((moved_templates++))
        fi
    done
fi

echo "✅ 移动了 $moved_templates 个模板文件"
echo ""

# 移动 README
echo "📝 步骤 6/7: 移动 README..."
if [ -f ".cursor/README.md" ]; then
    mv .cursor/README.md docs/cursor-guides/cursor-configuration.md
    echo "  ✅ README.md → docs/cursor-guides/cursor-configuration.md"
fi
echo ""

# 清理 .cursor 目录
echo "🗑️  步骤 7/7: 清理 .cursor 目录..."

# 删除 config.json（内容已在 .cursorrules）
if [ -f ".cursor/config.json" ]; then
    rm -f .cursor/config.json
    echo "  ✅ 删除 config.json（已整合到 .cursorrules）"
fi

# 删除空目录
rmdir .cursor/rules 2>/dev/null && echo "  ✅ 删除空目录 .cursor/rules" || true
rmdir .cursor/docs 2>/dev/null && echo "  ✅ 删除空目录 .cursor/docs" || true
rmdir .cursor/templates 2>/dev/null && echo "  ✅ 删除空目录 .cursor/templates" || true

# 删除 .cursor 目录
if rmdir .cursor 2>/dev/null; then
    echo "  ✅ 删除 .cursor 目录"
else
    echo "  ⚠️  .cursor 目录不为空，请手动检查"
    ls -la .cursor/
fi

echo ""
echo "================================"
echo "🎉 优化完成！"
echo ""

# 显示统计
echo "📊 优化统计："
echo "  • 移动规则文档: $moved_rules 个"
echo "  • 移动普通文档: $moved_docs 个"
echo "  • 移动代码模板: $moved_templates 个"
echo "  • 总计: $((moved_rules + moved_docs + moved_templates)) 个文件"
echo ""

# 显示新结构
echo "📁 新文件位置："
echo ""
echo "docs/cursor-guides/              # Cursor 使用指南"
ls -1 docs/cursor-guides/ | sed 's/^/  ├── /'
echo ""
echo "templates/python/                # Python 代码模板"
ls -1 templates/python/ | sed 's/^/  ├── /'
echo ""

# 验证
echo "✅ 验证："
if [ -d ".cursor" ]; then
    echo "  ⚠️  .cursor 目录仍然存在"
else
    echo "  ✅ .cursor 目录已成功删除"
fi

if [ -f ".cursorrules" ]; then
    echo "  ✅ .cursorrules 文件存在"
else
    echo "  ⚠️  .cursorrules 文件不存在"
fi

echo ""
echo "💾 备份位置: $BACKUP_DIR"
echo ""
echo "🚀 下一步："
echo "  1. 检查新文件位置是否正确"
echo "  2. 验证 .cursorrules 文件完整性"
echo "  3. 更新项目文档中的路径引用"
echo ""
