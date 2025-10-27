# ===============================
# AI Markdown Workflow Makefile
# 作者: 乐哥
# 功能: 自动化 Markdown 格式化 + 校验 + 生成目录
# ===============================

# 默认目标
.PHONY: all
all: format lint toc

# 格式化所有 Markdown 文件
format:
	@echo "🧹 格式化所有 Markdown 文件..."
	@npx prettier --write "**/*.md"

# 校验 Markdown 规则（用 markdownlint）
lint:
	@echo "🔍 检查 markdownlint 规则..."
	@npx markdownlint "**/*.md" || true

# 自动生成目录（需要安装 markdown-toc）
toc:
	@echo "📚 自动生成 Markdown 目录..."
	@for file in *.md; do \
		if [ -f "$$file" ]; then \
			echo "  处理: $$file"; \
			npx markdown-toc -i "$$file" 2>/dev/null || true; \
		fi; \
	done

# 清理缓存或输出
clean:
	@echo "🗑️ 清理临时文件..."
	rm -rf .cache

# 一键执行所有任务
check:
	@make format
	@make lint
	@make toc
	@echo "✅ 所有任务完成！"

# 显示帮助
help:
	@echo ""
	@echo "🎯 可用命令："
	@echo "  make format   - 格式化所有 .md 文件"
	@echo "  make lint     - 检查 Markdown 错误"
	@echo "  make toc      - 自动生成目录"
	@echo "  make clean    - 清除缓存"
	@echo "  make check    - 一键执行所有任务"
	@echo ""
