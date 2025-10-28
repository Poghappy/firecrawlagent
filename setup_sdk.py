#!/usr/bin/env python3
"""Firecrawl SDK 配置脚本

自动检测并配置 Firecrawl Python SDK 环境
"""

import os
import subprocess
import sys
from pathlib import Path

from dotenv import load_dotenv


def print_header(text: str) -> None:
    """打印标题"""
    print("\n" + "=" * 60)
    print(f"  {text}")
    print("=" * 60)


def check_python_version() -> bool:
    """检查 Python 版本"""
    print_header("🐍 检查 Python 版本")

    version = sys.version_info
    print(f"当前 Python 版本: {version.major}.{version.minor}.{version.micro}")

    if version.major < 3 or (version.major == 3 and version.minor < 8):
        print("❌ 需要 Python 3.8 或更高版本")
        return False

    print("✅ Python 版本符合要求")
    return True


def check_pip() -> bool:
    """检查 pip 是否可用"""
    print_header("📦 检查 pip")

    try:
        result = subprocess.run(
            ["pip3", "--version"], capture_output=True, text=True, check=True
        )
        print(f"✅ pip 已安装: {result.stdout.strip()}")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ pip3 未找到")
        return False


def install_dependencies() -> bool:
    """安装依赖包"""
    print_header("📥 安装依赖包")

    requirements_file = Path(__file__).parent / "requirements.txt"

    if not requirements_file.exists():
        print("❌ 未找到 requirements.txt")
        return False

    print(f"📄 从 {requirements_file} 安装依赖...")

    try:
        # 使用 --break-system-packages 标志（适用于 macOS）
        result = subprocess.run(
            [
                "pip3",
                "install",
                "--break-system-packages",
                "-r",
                str(requirements_file),
            ],
            capture_output=True,
            text=True,
            check=True,
        )
        print("✅ 依赖包安装成功")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ 安装失败: {e.stderr}")

        # 尝试不使用 --break-system-packages
        print("\n尝试标准安装...")
        try:
            subprocess.run(
                ["pip3", "install", "-r", str(requirements_file)],
                capture_output=True,
                text=True,
                check=True,
            )
            print("✅ 依赖包安装成功")
            return True
        except subprocess.CalledProcessError as e2:
            print(f"❌ 安装失败: {e2.stderr}")
            return False


def check_env_file() -> bool:
    """检查 .env 文件"""
    print_header("🔐 检查环境配置")

    env_file = Path(__file__).parent / ".env"
    env_template = Path(__file__).parent / "env.template"

    if not env_file.exists():
        if env_template.exists():
            print("⚠️  .env 文件不存在")
            print(f"📋 发现模板文件: {env_template}")

            response = input("\n是否从模板创建 .env 文件? (y/n): ").lower()
            if response == "y":
                import shutil

                shutil.copy(env_template, env_file)
                print("✅ 已创建 .env 文件")
                print("⚠️  请编辑 .env 文件，填入你的 API 密钥")
                return True
            print("❌ 需要手动创建 .env 文件")
            return False
        print("❌ 未找到 .env 或 env.template 文件")
        return False

    print(f"✅ 找到 .env 文件: {env_file}")
    return True


def test_api_key() -> bool:
    """测试 API 密钥"""
    print_header("🔑 测试 API 密钥")

    # 加载环境变量
    load_dotenv()

    api_key = os.getenv("FIRECRAWL_API_KEY")

    if not api_key:
        print("❌ 未找到 FIRECRAWL_API_KEY 环境变量")
        print("💡 请在 .env 文件中设置 FIRECRAWL_API_KEY")
        return False

    print(f"✅ 找到 API 密钥: {api_key[:10]}...{api_key[-10:]}")

    try:
        from firecrawl import FirecrawlApp

        print("🔄 测试 API 连接...")
        app = FirecrawlApp(api_key=api_key)

        # 测试简单的 scrape
        result = app.scrape(
            url="https://firecrawl.dev/", formats=["markdown"], only_main_content=True
        )

        if result and hasattr(result, "markdown") and result.markdown:
            print("✅ API 密钥有效，连接成功！")
            print(f"📊 测试数据: {len(result.markdown)} 字符")
            return True
        print("❌ API 返回结果异常")
        return False

    except ImportError:
        print("❌ firecrawl-py 包未安装")
        print("💡 运行: pip3 install firecrawl-py")
        return False
    except Exception as e:
        print(f"❌ API 测试失败: {e}")
        return False


def create_gitignore() -> None:
    """创建/更新 .gitignore 文件"""
    print_header("📝 更新 .gitignore")

    gitignore_file = Path(__file__).parent / ".gitignore"

    essential_entries = [
        "# 环境变量（敏感信息）",
        ".env",
        "",
        "# Python",
        "__pycache__/",
        "*.py[cod]",
        "*$py.class",
        "*.so",
        ".Python",
        "venv/",
        "env/",
        "ENV/",
        "",
        "# IDE",
        ".vscode/",
        ".idea/",
        "*.swp",
        "*.swo",
        "",
        "# 数据文件",
        "*.csv",
        "*.json",
        "data/",
        "cache/",
        "",
        "# 日志",
        "*.log",
        "logs/",
        "",
        "# 操作系统",
        ".DS_Store",
        "Thumbs.db",
    ]

    existing_entries = set()
    if gitignore_file.exists():
        with open(gitignore_file, "r", encoding="utf-8") as f:
            existing_entries = {
                line.strip() for line in f if line.strip() and not line.startswith("#")
            }

    with open(gitignore_file, "a", encoding="utf-8") as f:
        if gitignore_file.stat().st_size > 0:
            f.write("\n\n# === Firecrawl SDK 配置 ===\n")

        for entry in essential_entries:
            if not entry.startswith("#") and entry and entry not in existing_entries or entry.startswith("#") or not entry:
                f.write(entry + "\n")

    print(f"✅ 已更新 .gitignore: {gitignore_file}")


def print_summary() -> None:
    """打印配置总结"""
    print_header("📋 配置总结")

    print("✅ Firecrawl SDK 配置完成！")
    print("\n📚 快速开始:")
    print("   1. 运行测试脚本: python3 quick_start.py")
    print("   2. 测试 API 密钥: python3 test_api_keys.py")
    print("   3. 爬取示例: python3 scrape_firecrawl_blog.py")
    print("\n📖 文档位置:")
    print("   - 快速指南: FIRECRAWL_CLOUD_SETUP_GUIDE.md")
    print("   - API 规则: FIRECRAWL_CLOUD_API_RULES.md")
    print("   - 生态系统: FIRECRAWL_ECOSYSTEM_GUIDE.md")
    print("\n💡 提示:")
    print("   - 所有 Python 脚本现在都会从 .env 读取配置")
    print("   - API 密钥永远不要硬编码到代码中")
    print("   - 定期检查 API 使用量和成本")


def main() -> None:
    """主函数"""
    print("\n" + "🔥" * 30)
    print("   Firecrawl SDK 自动配置脚本")
    print("   FireShot 项目 - HawaiiHub")
    print("🔥" * 30)

    steps = [
        ("检查 Python 版本", check_python_version),
        ("检查 pip", check_pip),
        ("安装依赖包", install_dependencies),
        ("检查环境配置", check_env_file),
        ("更新 .gitignore", lambda: (create_gitignore(), True)[1]),
        ("测试 API 密钥", test_api_key),
    ]

    failed_steps = []

    for step_name, step_func in steps:
        try:
            if not step_func():
                failed_steps.append(step_name)
        except Exception as e:
            print(f"❌ {step_name} 执行失败: {e}")
            failed_steps.append(step_name)

    if failed_steps:
        print("\n" + "⚠️ " * 20)
        print(f"部分步骤失败: {', '.join(failed_steps)}")
        print("⚠️ " * 20)
        print("\n💡 请手动完成这些步骤，然后重新运行此脚本")
        sys.exit(1)

    print_summary()
    print("\n🎉 配置成功！现在可以开始使用 Firecrawl SDK 了！")


if __name__ == "__main__":
    main()
