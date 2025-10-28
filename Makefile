# ===================================================================
# FireShot 项目 - Makefile
# ===================================================================
# 版本: v1.0.0
# 更新时间: 2025-10-28
# 维护者: HawaiiHub AI Team
# ===================================================================

.PHONY: help setup install dev test lint format type-check clean all

# 默认目标
.DEFAULT_GOAL := help

# Python 解释器
PYTHON := python3
PIP := pip3

# 项目路径
PROJECT_ROOT := $(shell pwd)
VENV := .venv
ACTIVATE := source $(VENV)/bin/activate

# ===========================
# 帮助信息
# ===========================
help: ## 显示帮助信息
	@echo "═══════════════════════════════════════════════════════════"
	@echo "FireShot 项目 - Makefile 命令清单"
	@echo "═══════════════════════════════════════════════════════════"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"

# ===========================
# 环境配置
# ===========================
setup: ## 一键配置开发环境
	@echo "🚀 配置 Python 环境..."
	@chmod +x scripts/setup_python_env.sh
	@./scripts/setup_python_env.sh

install: ## 安装依赖（生产环境）
	@echo "📦 安装生产依赖..."
	@$(PIP) install --break-system-packages -r requirements.txt

dev: ## 安装依赖（开发环境）
	@echo "📦 安装开发依赖..."
	@$(PIP) install --break-system-packages -r requirements.txt
	@$(PIP) install --break-system-packages ruff mypy pytest pytest-cov types-requests

# ===========================
# 代码质量
# ===========================
lint: ## 运行 Linter（Ruff）
	@echo "🔍 运行代码检查..."
	@ruff check . --fix

format: ## 格式化代码（Ruff）
	@echo "🎨 格式化代码..."
	@ruff format .
	@ruff check . --fix --select I

type-check: ## 类型检查（MyPy）
	@echo "🔍 运行类型检查..."
	@mypy --config-file pyproject.toml .

# ===========================
# 测试
# ===========================
test: ## 运行测试（Pytest）
	@echo "🧪 运行测试..."
	@pytest tests/ -v

test-cov: ## 运行测试并生成覆盖率报告
	@echo "🧪 运行测试（带覆盖率）..."
	@pytest tests/ -v --cov=src --cov-report=html --cov-report=term-missing
	@echo "📊 覆盖率报告: htmlcov/index.html"

test-watch: ## 监听文件变化并自动运行测试
	@echo "👀 监听测试..."
	@pytest-watch tests/

# ===========================
# 完整检查
# ===========================
all: format lint type-check test ## 运行所有检查（格式化、Lint、类型检查、测试）
	@echo "✅ 所有检查通过！"

check: lint type-check ## 快速检查（Lint + 类型检查）
	@echo "✅ 代码检查通过！"

# ===========================
# 清理
# ===========================
clean: ## 清理缓存和临时文件
	@echo "🧹 清理缓存..."
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type f -name "*.pyo" -delete 2>/dev/null || true
	@find . -type f -name ".coverage" -delete 2>/dev/null || true
	@rm -rf htmlcov/ 2>/dev/null || true
	@rm -rf dist/ 2>/dev/null || true
	@rm -rf build/ 2>/dev/null || true
	@echo "✅ 清理完成！"

clean-all: clean ## 深度清理（包括虚拟环境）
	@echo "🧹 深度清理..."
	@rm -rf $(VENV) 2>/dev/null || true
	@echo "✅ 深度清理完成！"

# ===========================
# 快速启动
# ===========================
quick-start: ## 运行快速启动脚本
	@echo "🚀 运行快速启动..."
	@$(PYTHON) quick_start.py

scrape-blog: ## 爬取 Firecrawl 博客
	@echo "🔥 爬取 Firecrawl 博客..."
	@$(PYTHON) scripts/scrape_firecrawl_blog.py

# ===========================
# 文档
# ===========================
docs: ## 查看项目文档
	@echo "📚 项目文档清单："
	@echo ""
	@echo "  • README.md                      - 项目概览"
	@echo "  • AGENTS.md                      - AI 助手规范"
	@echo "  • SDK_CONFIGURATION_COMPLETE.md  - SDK 配置指南"
	@echo "  • QUICK_REFERENCE.md             - 快速参考"
	@echo "  • docs/                          - 完整文档目录"
	@echo ""

# ===========================
# 版本信息
# ===========================
version: ## 显示版本信息
	@echo "═══════════════════════════════════════════════════════════"
	@echo "FireShot 项目 - 版本信息"
	@echo "═══════════════════════════════════════════════════════════"
	@echo ""
	@echo "Python:    $$(python3 --version)"
	@echo "pip:       $$(pip3 --version | awk '{print $$2}')"
	@echo "ruff:      $$(ruff --version 2>/dev/null || echo '未安装')"
	@echo "mypy:      $$(mypy --version 2>/dev/null || echo '未安装')"
	@echo "pytest:    $$(pytest --version 2>/dev/null | head -n1 || echo '未安装')"
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
