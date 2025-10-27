#!/usr/bin/env python3
"""
Python 环境配置验证脚本

检查所有必需的工具和配置是否正确安装。
"""
import subprocess
import sys


def run_command(command: list[str]) -> tuple[bool, str]:
    """
    运行命令并返回结果

    Args:
        command: 命令列表

    Returns:
        (是否成功, 输出信息)
    """
    try:
        result = subprocess.run(
            command, capture_output=True, text=True, check=False, timeout=10
        )
        if result.returncode == 0:
            return True, result.stdout.strip()
        return False, result.stderr.strip()
    except Exception as e:
        return False, str(e)


def check_python_version() -> dict[str, str]:
    """检查 Python 版本"""
    success, output = run_command([sys.executable, "--version"])
    return {
        "status": "✅" if success else "❌",
        "name": "Python 版本",
        "result": output if success else "未找到 Python",
    }


def check_pip_version() -> dict[str, str]:
    """检查 pip 版本"""
    success, output = run_command([sys.executable, "-m", "pip", "--version"])
    return {
        "status": "✅" if success else "❌",
        "name": "pip 版本",
        "result": output if success else "未找到 pip",
    }


def check_package(package: str) -> dict[str, str]:
    """检查 Python 包是否安装"""
    success, output = run_command([sys.executable, "-m", "pip", "show", package])
    if success:
        # 提取版本号
        for line in output.split("\n"):
            if line.startswith("Version:"):
                version = line.split(":", 1)[1].strip()
                return {
                    "status": "✅",
                    "name": f"{package} 包",
                    "result": f"已安装 v{version}",
                }
    return {
        "status": "❌",
        "name": f"{package} 包",
        "result": f"未安装（运行: pip3 install {package}）",
    }


def check_ruff() -> dict[str, str]:
    """检查 Ruff"""
    success, output = run_command(["ruff", "--version"])
    return {
        "status": "✅" if success else "⚠️",
        "name": "Ruff（格式化+Linting）",
        "result": output if success else "未安装（运行: pip3 install ruff）",
    }


def check_mypy() -> dict[str, str]:
    """检查 mypy"""
    # 优先尝试直接命令
    success, output = run_command(["mypy", "--version"])
    if not success:
        # 回退到 Python 模块方式
        success, output = run_command([sys.executable, "-m", "mypy", "--version"])
    return {
        "status": "✅" if success else "⚠️",
        "name": "mypy（类型检查）",
        "result": output if success else "未安装（运行: pip3 install mypy）",
    }


def check_pytest() -> dict[str, str]:
    """检查 pytest"""
    success, output = run_command(["pytest", "--version"])
    return {
        "status": "✅" if success else "⚠️",
        "name": "pytest（测试框架）",
        "result": output if success else "未安装（运行: pip3 install pytest）",
    }


def check_config_file(filename: str) -> dict[str, str]:
    """检查配置文件是否存在"""
    import os

    exists = os.path.exists(filename)
    return {
        "status": "✅" if exists else "⚠️",
        "name": f"配置文件: {filename}",
        "result": "已创建" if exists else "未创建（可选）",
    }


def main() -> None:
    """主函数"""
    print("=" * 60)
    print("🐍 FireShot Python 环境配置验证")
    print("=" * 60)
    print()

    # 检查项列表
    checks = [
        check_python_version(),
        check_pip_version(),
        check_package("firecrawl-py"),
        check_package("python-dotenv"),
        check_package("requests"),
        check_package("pydantic"),
        check_ruff(),
        check_mypy(),
        check_pytest(),
        check_config_file("pyproject.toml"),
        check_config_file(".env"),
    ]

    # 显示结果
    success_count = 0
    warning_count = 0
    error_count = 0

    for check in checks:
        status = check["status"]
        name = check["name"]
        result = check["result"]

        print(f"{status} {name}")
        print(f"   {result}")
        print()

        if status == "✅":
            success_count += 1
        elif status == "⚠️":
            warning_count += 1
        else:
            error_count += 1

    # 汇总
    print("=" * 60)
    print("📊 检查结果汇总")
    print("=" * 60)
    total = success_count + warning_count + error_count
    print(f"✅ 成功: {success_count}/{total}")
    print(f"⚠️  警告: {warning_count}/{total}")
    print(f"❌ 错误: {error_count}/{total}")
    print()

    # 建议
    if error_count > 0:
        print("❌ 存在关键错误，请先解决再继续开发")
        sys.exit(1)
    elif warning_count > 0:
        print("⚠️  存在警告，建议安装缺失的开发工具")
        print()
        print("📦 安装开发工具:")
        print("   pip3 install --break-system-packages ruff mypy pytest pytest-cov")
        print()
        print("或者使用 pipx（推荐）:")
        print("   brew install pipx")
        print("   pipx install ruff")
        print("   pipx install mypy")
        print("   pipx install pytest")
        sys.exit(0)
    else:
        print("🎉 所有检查通过！Python 环境配置完美！")
        print()
        print("📚 下一步:")
        print("   1. 运行测试: pytest tests/ -v")
        print("   2. 类型检查: mypy scripts/ --strict")
        print("   3. 代码检查: ruff check .")
        print("   4. 格式化: ruff format .")
        sys.exit(0)


if __name__ == "__main__":
    main()

