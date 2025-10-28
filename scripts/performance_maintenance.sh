#!/bin/bash
# ========================================
# FireShot 性能维护脚本
# 用途: 定期清理缓存，优化项目性能
# 使用: ./scripts/performance_maintenance.sh
# ========================================

set -e

echo "🧹 开始 FireShot 项目性能维护..."
echo ""

# 进入项目根目录
cd "$(dirname "$0")/.."

# 1. 清理 Python 缓存
echo "1️⃣ 清理 Python 缓存..."
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true
find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
echo "   ✅ Python 缓存已清理"

# 2. 清理 Node.js 缓存
echo ""
echo "2️⃣ 清理 Node.js 缓存..."
rm -rf .npm .eslintcache 2>/dev/null || true
rm -rf node_modules/.cache 2>/dev/null || true
echo "   ✅ Node.js 缓存已清理"

# 3. 清理旧日志（保留最近 7 天）
echo ""
echo "3️⃣ 清理旧日志（保留最近 7 天）..."
if [ -d "logs" ]; then
    find logs/ -name "*.log" -mtime +7 -delete 2>/dev/null || true
    echo "   ✅ 旧日志已清理"
else
    echo "   ⚠️  logs 目录不存在，跳过"
fi

# 4. Git 垃圾回收
echo ""
echo "4️⃣ Git 优化..."
git gc --auto
echo "   ✅ Git 已优化"

# 5. 清理 Cursor 缓存（可选，慎用）
echo ""
read -p "5️⃣ 是否清理 Cursor 缓存？这会清除所有 AI 对话历史 (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf .cursor/cache/* 2>/dev/null || true
    echo "   ✅ Cursor 缓存已清理"
else
    echo "   ⏭️  跳过 Cursor 缓存清理"
fi

# 6. 显示磁盘占用分析
echo ""
echo "6️⃣ 磁盘占用分析:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "大型目录占用:"
du -sh node_modules/ 2>/dev/null | awk '{print "   📦 node_modules:        " $1}' || echo "   📦 node_modules:        (不存在)"
du -sh hawaiihub-admin-agent/node_modules/ 2>/dev/null | awk '{print "   📦 admin node_modules:  " $1}' || echo "   📦 admin node_modules:  (不存在)"
du -sh hawaiihub-admin-agent/Firecrawl官方文档/ 2>/dev/null | awk '{print "   📚 Firecrawl 文档:      " $1}' || echo "   📚 Firecrawl 文档:      (不存在)"
du -sh data/ 2>/dev/null | awk '{print "   📊 data 目录:           " $1}' || echo "   📊 data 目录:           (不存在)"
du -sh logs/ 2>/dev/null | awk '{print "   📝 logs 目录:           " $1}' || echo "   📝 logs 目录:           (不存在)"

echo ""
echo "缓存目录占用:"
du -sh .ruff_cache/ 2>/dev/null | awk '{print "   🗑️  .ruff_cache:        " $1}' || echo "   🗑️  .ruff_cache:        (已清理)"
du -sh .pytest_cache/ 2>/dev/null | awk '{print "   🗑️  .pytest_cache:      " $1}' || echo "   🗑️  .pytest_cache:      (已清理)"
du -sh .mypy_cache/ 2>/dev/null | awk '{print "   🗑️  .mypy_cache:        " $1}' || echo "   🗑️  .mypy_cache:        (已清理)"

echo ""
echo "项目总大小:"
du -sh . 2>/dev/null | awk '{print "   📁 总计:               " $1}'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 7. 统计文件数量
echo ""
echo "7️⃣ 文件统计:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
total_files=$(find . -type f 2>/dev/null | wc -l | xargs)
md_files=$(find . -name "*.md" 2>/dev/null | wc -l | xargs)
py_files=$(find . -name "*.py" 2>/dev/null | wc -l | xargs)
js_files=$(find . -name "*.js" -o -name "*.ts" 2>/dev/null | wc -l | xargs)

echo "   📄 总文件数:            $total_files"
echo "   📝 Markdown 文件:       $md_files"
echo "   🐍 Python 文件:         $py_files"
echo "   📜 JS/TS 文件:          $js_files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 8. 完成
echo ""
echo "✅ 维护完成！"
echo ""
echo "📌 下一步操作:"
echo "   1. 重新加载 Cursor: Cmd+Shift+P → Developer: Reload Window"
echo "   2. 观察性能是否有改善"
echo "   3. 建议每周运行一次此脚本"
echo ""
