#!/bin/bash
# ========================================
# 应用 Cursor 性能优化配置
# ========================================

cd "$(dirname "$0")"

echo "🔧 应用 Cursor 性能优化配置..."
echo ""

# 备份当前配置
if [ -f ".vscode/settings.json" ]; then
    echo "1️⃣ 备份当前配置..."
    cp .vscode/settings.json .vscode/settings.json.backup.$(date +%Y%m%d_%H%M%S)
    echo "   ✅ 备份完成: .vscode/settings.json.backup.*"
else
    echo "⚠️  当前不存在 settings.json，将创建新文件"
fi

# 应用新配置
echo ""
echo "2️⃣ 应用性能优化配置..."
cp .vscode/settings.json.new .vscode/settings.json
echo "   ✅ 已应用新配置"

echo ""
echo "📋 配置变更摘要:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   ✅ 排除大型目录（node_modules, 文档等）"
echo "   ✅ 禁用文件监视器（大型目录）"
echo "   ✅ 禁用 minimap（减少 UI 负担）"
echo "   ✅ 修复 Makefile Tools 警告"
echo "   ✅ 优化 TypeScript 内存限制"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "🚀 下一步:"
echo "   1. 重新加载 Cursor: Cmd+Shift+P → Developer: Reload Window"
echo "   2. 测试性能是否有改善"
echo "   3. 如需恢复旧配置: cp .vscode/settings.json.backup.* .vscode/settings.json"
echo ""
