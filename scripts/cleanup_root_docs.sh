#!/bin/bash
# ========================================
# FireShot 根目录文档清理脚本
# ========================================
# 目标：根目录仅保留 5 个核心文档
# 其他文档归档到 docs/archive/

set -e

cd "$(dirname "$0")/.."

echo "🧹 FireShot 根目录文档清理"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 统计当前文档数量
CURRENT_COUNT=$(ls -1 *.md 2>/dev/null | wc -l | tr -d ' ')
echo "📊 当前根目录有 ${CURRENT_COUNT} 个 Markdown 文档"
echo ""

# 1. 创建备份
BACKUP_DIR=".backup/docs/$(date +%Y%m%d_%H%M%S)"
echo "1️⃣ 创建备份..."
mkdir -p "${BACKUP_DIR}"
cp *.md "${BACKUP_DIR}/" 2>/dev/null || true
cp *.txt "${BACKUP_DIR}/" 2>/dev/null || true
echo "   ✅ 备份到: ${BACKUP_DIR}"
echo ""

# 2. 创建归档目录
echo "2️⃣ 创建归档目录..."
mkdir -p docs/archive/2025-10-28-cleanup
echo "   ✅ 归档目录: docs/archive/2025-10-28-cleanup/"
echo ""

# 3. 定义要保留的核心文档
KEEP_FILES=(
    "README.md"
    "CHANGELOG.md"
    "AGENTS.md"
)

echo "3️⃣ 保留核心文档："
for file in "${KEEP_FILES[@]}"; do
    echo "   ✅ $file"
done
echo ""

# 4. 移动其他文档到归档目录
echo "4️⃣ 归档其他文档..."
MOVED_COUNT=0

for file in *.md; do
    # 跳过不存在的文件
    [ -e "$file" ] || continue

    # 检查是否在保留列表中
    SHOULD_KEEP=false
    for keep_file in "${KEEP_FILES[@]}"; do
        if [ "$file" = "$keep_file" ]; then
            SHOULD_KEEP=true
            break
        fi
    done

    # 移动不保留的文件
    if [ "$SHOULD_KEEP" = false ]; then
        mv "$file" "docs/archive/2025-10-28-cleanup/"
        echo "   📦 $file"
        ((MOVED_COUNT++))
    fi
done

# 5. 移动 .txt 文件
for file in *.txt; do
    [ -e "$file" ] || continue
    mv "$file" "docs/archive/2025-10-28-cleanup/"
    echo "   📦 $file"
    ((MOVED_COUNT++))
done

echo ""
echo "   移动了 ${MOVED_COUNT} 个文档"
echo ""

# 6. 统计结果
FINAL_COUNT=$(ls -1 *.md 2>/dev/null | wc -l | tr -d ' ')
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 清理结果"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "清理前: ${CURRENT_COUNT} 个文档"
echo "清理后: ${FINAL_COUNT} 个文档"
echo "减少: $((CURRENT_COUNT - FINAL_COUNT)) 个文档"
echo ""

# 7. 显示当前根目录文档
echo "✅ 当前根目录文档："
ls -1 *.md 2>/dev/null || echo "   (无 Markdown 文件)"
echo ""

# 8. 创建归档索引
echo "5️⃣ 创建归档索引..."
cat > docs/archive/2025-10-28-cleanup/README.md << 'EOF'
# 2025-10-28 文档归档

**归档原因**: 根目录文档过多（40+ 个），影响项目清晰度

**归档时间**: 2025-10-28

**归档内容**: 所有非核心的 Markdown 和 TXT 文档

---

## 📋 归档文档列表

EOF

# 列出归档的文件
ls -1 docs/archive/2025-10-28-cleanup/*.md docs/archive/2025-10-28-cleanup/*.txt 2>/dev/null | while read file; do
    basename "$file" >> docs/archive/2025-10-28-cleanup/README.md
done

echo "   ✅ 归档索引已创建"
echo ""

# 9. 更新 CHANGELOG
echo "6️⃣ 更新 CHANGELOG.md..."
if [ -f CHANGELOG.md ]; then
    # 在 ## [Unreleased] 后添加
    sed -i.bak '/^## \[Unreleased\]/a\
\
### 清理\
\
- 🧹 整理根目录文档，从 '$CURRENT_COUNT' 个减少到 '$FINAL_COUNT' 个\
- 📦 归档 '$MOVED_COUNT' 个历史文档到 `docs/archive/2025-10-28-cleanup/`\
- ✅ 根目录现在仅保留核心文档（README, CHANGELOG, AGENTS）\
- 📝 添加文档生成控制规范（.cursor/rules/02-documentation-control.mdc）\
' CHANGELOG.md
    rm CHANGELOG.md.bak
    echo "   ✅ CHANGELOG.md 已更新"
else
    echo "   ⚠️  CHANGELOG.md 不存在，跳过"
fi
echo ""

# 10. 完成提示
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 清理完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📍 归档位置:"
echo "   docs/archive/2025-10-28-cleanup/"
echo ""
echo "💾 备份位置:"
echo "   ${BACKUP_DIR}/"
echo ""
echo "📝 下一步建议:"
echo "   1. 查看 docs/archive/ 确认归档内容"
echo "   2. 更新 README.md 确保信息完整"
echo "   3. 提交变更: git add . && git commit -m 'chore: 清理根目录文档'"
echo ""
echo "⚠️  如需恢复某个文档:"
echo "   cp docs/archive/2025-10-28-cleanup/文件名 ."
echo ""
