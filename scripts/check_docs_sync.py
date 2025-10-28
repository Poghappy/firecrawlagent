#!/usr/bin/env python3
"""
Firecrawl 文档同步检查工具

功能：
1. 检测英文文档是否有新增文件
2. 对比中英文文件的修改时间
3. 生成需要更新的文件清单

用法：
    python3 check_docs_sync.py
"""

from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple


# 配置
DOCS_ROOT = Path(
    "/Users/zhiledeng/Downloads/FireShot/Firecrawl文档资料/官方文档/firecrawl-docs"
)
EN_ROOT = DOCS_ROOT
ZH_ROOT = DOCS_ROOT / "zh"
EXCLUDE_DIRS = {
    "zh",
    "es",
    "fr",
    "ja",
    "pt-BR",
    "snippets",
    "images",
    "logo",
    "notebooks",
    ".git",
}


def get_mdx_files(root: Path, exclude_dirs: set) -> List[Path]:
    """获取目录下所有 .mdx 文件，排除指定目录"""
    mdx_files = []
    for file in root.rglob("*.mdx"):
        # 检查是否在排除目录中
        if any(excluded in file.parts for excluded in exclude_dirs):
            continue
        mdx_files.append(file)
    return mdx_files


def get_relative_path(file: Path, root: Path) -> str:
    """获取相对于根目录的路径"""
    return str(file.relative_to(root))


def check_file_exists(en_file: Path, zh_root: Path) -> bool:
    """检查中文文件是否存在"""
    relative_path = get_relative_path(en_file, EN_ROOT)
    zh_file = zh_root / relative_path
    return zh_file.exists()


def get_file_mtime(file: Path) -> datetime:
    """获取文件修改时间"""
    return datetime.fromtimestamp(file.stat().st_mtime)


def compare_files_by_mtime(en_file: Path, zh_root: Path) -> Tuple[bool, str]:
    """
    通过修改时间对比文件是否需要更新

    返回：(需要更新, 原因)
    """
    relative_path = get_relative_path(en_file, EN_ROOT)
    zh_file = zh_root / relative_path

    if not zh_file.exists():
        return True, "中文文件不存在"

    en_mtime = get_file_mtime(en_file)
    zh_mtime = get_file_mtime(zh_file)

    if en_mtime > zh_mtime:
        days_diff = (en_mtime - zh_mtime).days
        return True, f"英文版更新（晚 {days_diff} 天）"

    return False, "已同步"


def generate_sync_report() -> Dict:
    """生成同步报告"""
    print("🔍 正在扫描 Firecrawl 文档...")

    # 获取所有英文 .mdx 文件
    en_files = get_mdx_files(EN_ROOT, EXCLUDE_DIRS)
    print(f"📄 找到 {len(en_files)} 个英文文档")

    # 分析结果
    missing_files = []
    outdated_files = []
    synced_files = []

    for en_file in en_files:
        relative_path = get_relative_path(en_file, EN_ROOT)
        needs_update, reason = compare_files_by_mtime(en_file, ZH_ROOT)

        if not check_file_exists(en_file, ZH_ROOT):
            missing_files.append(relative_path)
        elif needs_update:
            outdated_files.append((relative_path, reason))
        else:
            synced_files.append(relative_path)

    return {
        "total": len(en_files),
        "missing": missing_files,
        "outdated": outdated_files,
        "synced": synced_files,
    }


def print_report(report: Dict) -> None:
    """打印报告"""
    print("\n" + "=" * 70)
    print("📊 Firecrawl 文档同步状态报告")
    print("=" * 70)
    print(f"📅 生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print()

    # 统计信息
    total = report["total"]
    missing_count = len(report["missing"])
    outdated_count = len(report["outdated"])
    synced_count = len(report["synced"])

    print("📈 统计信息:")
    print(f"   - 总文件数: {total}")
    print(f"   - ✅ 已同步: {synced_count} ({synced_count/total*100:.1f}%)")
    print(f"   - ⚠️  需更新: {outdated_count} ({outdated_count/total*100:.1f}%)")
    print(f"   - ❌ 缺失: {missing_count} ({missing_count/total*100:.1f}%)")
    print()

    # 缺失文件
    if report["missing"]:
        print("❌ 缺失的中文文件:")
        for file in report["missing"][:10]:  # 只显示前 10 个
            print(f"   - {file}")
        if len(report["missing"]) > 10:
            print(f"   ... 还有 {len(report['missing']) - 10} 个文件")
        print()

    # 过时文件
    if report["outdated"]:
        print("⚠️  需要更新的文件:")
        for file, reason in report["outdated"][:10]:  # 只显示前 10 个
            print(f"   - {file} ({reason})")
        if len(report["outdated"]) > 10:
            print(f"   ... 还有 {len(report['outdated']) - 10} 个文件")
        print()

    # 总结
    if missing_count == 0 and outdated_count == 0:
        print("🎉 太棒了！所有文档都已同步！")
    else:
        print("📝 建议：")
        if missing_count > 0:
            print(f"   1. 翻译 {missing_count} 个缺失的文件")
        if outdated_count > 0:
            print(f"   2. 更新 {outdated_count} 个过时的文件")

    print("=" * 70)


def save_report_to_file(report: Dict, output_file: str) -> None:
    """保存报告到文件"""
    with open(output_file, "w", encoding="utf-8") as f:
        f.write("# Firecrawl 文档同步检查报告\n\n")
        f.write(f"**生成时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")

        # 统计
        total = report["total"]
        missing_count = len(report["missing"])
        outdated_count = len(report["outdated"])
        synced_count = len(report["synced"])

        f.write("## 统计信息\n\n")
        f.write(f"- 总文件数: {total}\n")
        f.write(f"- ✅ 已同步: {synced_count} ({synced_count/total*100:.1f}%)\n")
        f.write(f"- ⚠️ 需更新: {outdated_count} ({outdated_count/total*100:.1f}%)\n")
        f.write(f"- ❌ 缺失: {missing_count} ({missing_count/total*100:.1f}%)\n\n")

        # 缺失文件
        if report["missing"]:
            f.write("## ❌ 缺失的中文文件\n\n")
            for file in report["missing"]:
                f.write(f"- [ ] `{file}`\n")
            f.write("\n")

        # 过时文件
        if report["outdated"]:
            f.write("## ⚠️ 需要更新的文件\n\n")
            for file, reason in report["outdated"]:
                f.write(f"- [ ] `{file}` - {reason}\n")
            f.write("\n")

    print(f"📄 详细报告已保存到: {output_file}")


def main() -> None:
    """主函数"""
    try:
        # 检查目录是否存在
        if not EN_ROOT.exists():
            print(f"❌ 错误：找不到英文文档目录 {EN_ROOT}")
            return

        if not ZH_ROOT.exists():
            print(f"❌ 错误：找不到中文文档目录 {ZH_ROOT}")
            return

        # 生成报告
        report = generate_sync_report()

        # 打印报告
        print_report(report)

        # 保存报告
        output_file = "/Users/zhiledeng/Downloads/FireShot/docs_sync_report.md"
        save_report_to_file(report, output_file)

    except Exception as e:
        print(f"❌ 错误：{e}")
        import traceback

        traceback.print_exc()


if __name__ == "__main__":
    main()
