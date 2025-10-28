#!/usr/bin/env python3
"""
Firecrawl 学习手册 PDF 生成器 v2.0

功能：
- 合并所有 Markdown 文档
- 生成带目录的 PDF 电子书
- 支持中文、代码高亮、图片
- 自动添加页码和书签

依赖：
pip3 install markdown weasyprint pygments pillow
"""

import os
from datetime import datetime
from pathlib import Path

import markdown
from weasyprint import HTML
from weasyprint.text.fonts import FontConfiguration

# 配置
TEMP_DIR = "temp_pdf"
OUTPUT_PDF = f"Firecrawl学习手册_v2.0_{datetime.now().strftime('%Y%m%d')}.pdf"

# HTML 模板
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Firecrawl 完整学习手册</title>
    <style>
        @page {{
            size: A4;
            margin: 2cm 2.5cm;

            @top-center {{
                content: "Firecrawl 完整学习手册";
                font-family: "PingFang SC", "Microsoft YaHei", sans-serif;
                font-size: 9pt;
                color: #666;
            }}

            @bottom-right {{
                content: "第 " counter(page) " 页";
                font-family: "PingFang SC", "Microsoft YaHei", sans-serif;
                font-size: 9pt;
                color: #666;
            }}
        }}

        body {{
            font-family: "PingFang SC", "Microsoft YaHei", "SimSun", sans-serif;
            font-size: 11pt;
            line-height: 1.6;
            color: #333;
            background: white;
        }}

        h1, h2, h3, h4, h5, h6 {{
            font-weight: bold;
            margin-top: 1.5em;
            margin-bottom: 0.5em;
            page-break-after: avoid;
        }}

        h1 {{
            font-size: 24pt;
            color: #1a1a1a;
            border-bottom: 2px solid #ff6b00;
            padding-bottom: 0.3em;
            page-break-before: always;
        }}

        h2 {{
            font-size: 20pt;
            color: #2c2c2c;
            border-bottom: 1px solid #ddd;
            padding-bottom: 0.2em;
        }}

        h3 {{
            font-size: 16pt;
            color: #444;
        }}

        h4 {{
            font-size: 14pt;
            color: #555;
        }}

        p {{
            margin: 0.8em 0;
            text-align: justify;
        }}

        code {{
            font-family: "Menlo", "Monaco", "Courier New", monospace;
            background: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 10pt;
            color: #d73a49;
        }}

        pre {{
            background: #f6f8fa;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 1em;
            overflow-x: auto;
            page-break-inside: avoid;
            margin: 1em 0;
        }}

        pre code {{
            background: none;
            padding: 0;
            color: #24292e;
            font-size: 9pt;
        }}

        blockquote {{
            border-left: 4px solid #ff6b00;
            margin: 1em 0;
            padding: 0.5em 1em;
            background: #fff8f0;
            color: #555;
            page-break-inside: avoid;
        }}

        table {{
            width: 100%;
            border-collapse: collapse;
            margin: 1em 0;
            page-break-inside: avoid;
        }}

        table th {{
            background: #ff6b00;
            color: white;
            padding: 0.6em;
            text-align: left;
            font-weight: bold;
        }}

        table td {{
            border: 1px solid #ddd;
            padding: 0.6em;
        }}

        table tr:nth-child(even) {{
            background: #f9f9f9;
        }}

        ul, ol {{
            margin: 0.8em 0;
            padding-left: 2em;
        }}

        li {{
            margin: 0.3em 0;
        }}

        a {{
            color: #0366d6;
            text-decoration: none;
        }}

        a:hover {{
            text-decoration: underline;
        }}

        img {{
            max-width: 100%;
            height: auto;
            display: block;
            margin: 1em auto;
            page-break-inside: avoid;
        }}

        hr {{
            border: none;
            border-top: 1px solid #ddd;
            margin: 2em 0;
        }}

        .cover {{
            text-align: center;
            padding-top: 100px;
            page-break-after: always;
        }}

        .cover h1 {{
            font-size: 36pt;
            color: #ff6b00;
            border: none;
            margin-bottom: 0.5em;
        }}

        .cover h2 {{
            font-size: 24pt;
            color: #666;
            border: none;
            font-weight: normal;
        }}

        .cover .meta {{
            margin-top: 3em;
            font-size: 12pt;
            color: #888;
        }}

        .toc {{
            page-break-before: always;
            page-break-after: always;
        }}

        .toc h1 {{
            border-bottom: 2px solid #ff6b00;
        }}

        .toc ul {{
            list-style: none;
            padding-left: 0;
        }}

        .toc li {{
            margin: 0.5em 0;
        }}

        .page-break {{
            page-break-after: always;
        }}

        /* 代码高亮 */
        .codehilite .hll {{ background-color: #ffffcc }}
        .codehilite .c {{ color: #999988; font-style: italic }}
        .codehilite .k {{ color: #000000; font-weight: bold }}
        .codehilite .o {{ color: #000000; font-weight: bold }}
        .codehilite .cm {{ color: #999988; font-style: italic }}
        .codehilite .cp {{ color: #999999; font-weight: bold; font-style: italic }}
        .codehilite .c1 {{ color: #999988; font-style: italic }}
        .codehilite .cs {{ color: #999999; font-weight: bold; font-style: italic }}
        .codehilite .gd {{ color: #000000; background-color: #ffdddd }}
        .codehilite .ge {{ color: #000000; font-style: italic }}
        .codehilite .gr {{ color: #aa0000 }}
        .codehilite .gh {{ color: #999999 }}
        .codehilite .gi {{ color: #000000; background-color: #ddffdd }}
        .codehilite .go {{ color: #888888 }}
        .codehilite .gp {{ color: #555555 }}
        .codehilite .gs {{ font-weight: bold }}
        .codehilite .gu {{ color: #aaaaaa }}
        .codehilite .gt {{ color: #aa0000 }}
        .codehilite .kc {{ color: #000000; font-weight: bold }}
        .codehilite .kd {{ color: #000000; font-weight: bold }}
        .codehilite .kn {{ color: #000000; font-weight: bold }}
        .codehilite .kp {{ color: #000000; font-weight: bold }}
        .codehilite .kr {{ color: #000000; font-weight: bold }}
        .codehilite .kt {{ color: #445588; font-weight: bold }}
        .codehilite .m {{ color: #009999 }}
        .codehilite .s {{ color: #d01040 }}
        .codehilite .na {{ color: #008080 }}
        .codehilite .nb {{ color: #0086B3 }}
        .codehilite .nc {{ color: #445588; font-weight: bold }}
        .codehilite .no {{ color: #008080 }}
        .codehilite .nd {{ color: #3c5d5d; font-weight: bold }}
        .codehilite .ni {{ color: #800080 }}
        .codehilite .ne {{ color: #990000; font-weight: bold }}
        .codehilite .nf {{ color: #990000; font-weight: bold }}
        .codehilite .nl {{ color: #990000; font-weight: bold }}
        .codehilite .nn {{ color: #555555 }}
        .codehilite .nt {{ color: #000080 }}
        .codehilite .nv {{ color: #008080 }}
        .codehilite .ow {{ color: #000000; font-weight: bold }}
        .codehilite .w {{ color: #bbbbbb }}
        .codehilite .mf {{ color: #009999 }}
        .codehilite .mh {{ color: #009999 }}
        .codehilite .mi {{ color: #009999 }}
        .codehilite .mo {{ color: #009999 }}
        .codehilite .sb {{ color: #d01040 }}
        .codehilite .sc {{ color: #d01040 }}
        .codehilite .sd {{ color: #d01040 }}
        .codehilite .s2 {{ color: #d01040 }}
        .codehilite .se {{ color: #d01040 }}
        .codehilite .sh {{ color: #d01040 }}
        .codehilite .si {{ color: #d01040 }}
        .codehilite .sx {{ color: #d01040 }}
        .codehilite .sr {{ color: #009926 }}
        .codehilite .s1 {{ color: #d01040 }}
        .codehilite .ss {{ color: #990073 }}
        .codehilite .bp {{ color: #999999 }}
        .codehilite .vc {{ color: #008080 }}
        .codehilite .vg {{ color: #008080 }}
        .codehilite .vi {{ color: #008080 }}
        .codehilite .il {{ color: #009999 }}
    </style>
</head>
<body>
{content}
</body>
</html>
"""


def print_color(text, color="blue"):
    """打印彩色文本"""
    colors = {
        "red": "\033[0;31m",
        "green": "\033[0;32m",
        "yellow": "\033[1;33m",
        "blue": "\033[0;34m",
        "reset": "\033[0m",
    }
    print(f"{colors.get(color, colors['blue'])}{text}{colors['reset']}")


def read_markdown_file(filepath):
    """读取 Markdown 文件"""
    try:
        with open(filepath, encoding="utf-8") as f:
            return f.read()
    except Exception as e:
        print_color(f"❌ 读取文件失败: {filepath}", "red")
        print_color(f"   错误: {e}", "red")
        return ""


def merge_markdown_files():
    """合并所有 Markdown 文件"""
    print_color("📝 合并 Markdown 文件...", "blue")

    content_parts = []

    # 文件列表（按顺序）
    files = [
        ("00-手册导读/PDF封面.md", "封面"),
        ("00-手册导读/手册使用指南.md", "手册使用指南"),
        ("00-手册导读/完整学习路线图.md", "学习路线图"),
        ("00-手册导读/快速开始指南.md", "快速开始"),
        ("01-基础入门/Firecrawl完整学习手册.md", "核心教程"),
        ("03-API参考/云端API规范.md", "API规范"),
        ("04-配置指南/云端配置指南.md", "配置指南"),
        ("05-实战案例/HawaiiHub实战案例手册.md", "HawaiiHub实战案例"),
        ("05-实战案例/案例架构图集.md", "案例架构图"),
        ("05-实战案例/完整项目总索引.md", "项目索引"),
        ("06-进阶主题/Firecrawl更新日志汇总.md", "更新日志"),
    ]

    for filepath, name in files:
        full_path = Path(filepath)
        if full_path.exists():
            print_color(f"  ✓ 添加: {name}", "yellow")
            content = read_markdown_file(full_path)
            content_parts.append(content)
            content_parts.append("\n\n<div class='page-break'></div>\n\n")
        else:
            print_color(f"  ⚠ 跳过: {name} (文件不存在)", "yellow")

    merged_content = "\n\n".join(content_parts)

    print_color(f"✅ 合并完成，总长度: {len(merged_content)} 字符", "green")
    return merged_content


def markdown_to_html(md_content):
    """将 Markdown 转换为 HTML"""
    print_color("🔄 转换 Markdown 到 HTML...", "blue")

    # 配置 Markdown 扩展
    extensions = [
        "extra",  # 表格、脚注等
        "codehilite",  # 代码高亮
        "toc",  # 目录
        "nl2br",  # 换行支持
        "sane_lists",  # 列表改进
    ]

    extension_configs = {
        "codehilite": {
            "linenums": False,
            "css_class": "codehilite",
        },
        "toc": {
            "toc_depth": 3,
        },
    }

    # 转换
    md = markdown.Markdown(extensions=extensions, extension_configs=extension_configs)
    html_content = md.convert(md_content)

    # 包装完整 HTML
    full_html = HTML_TEMPLATE.format(content=html_content)

    print_color("✅ HTML 转换完成", "green")
    return full_html


def generate_pdf(html_content, output_file):
    """生成 PDF"""
    print_color(f"📄 生成 PDF: {output_file}...", "blue")

    try:
        # 字体配置
        font_config = FontConfiguration()

        # 生成 PDF
        HTML(string=html_content).write_pdf(
            output_file,
            font_config=font_config,
        )

        # 获取文件大小
        file_size = os.path.getsize(output_file)
        size_mb = file_size / (1024 * 1024)

        print_color("✅ PDF 生成成功！", "green")
        print_color(f"   文件: {output_file}", "green")
        print_color(f"   大小: {size_mb:.2f} MB", "green")

        return True

    except Exception as e:
        print_color("❌ PDF 生成失败", "red")
        print_color(f"   错误: {e}", "red")
        return False


def show_stats():
    """显示统计信息"""
    print_color("\n📊 手册统计信息", "blue")
    print("=" * 50)

    # 统计 Markdown 文件
    md_files = list(Path(".").rglob("*.md"))
    print_color(f"Markdown 文件: {len(md_files)} 个", "yellow")

    # 统计总字数
    total_words = 0
    for md_file in md_files:
        try:
            content = md_file.read_text(encoding="utf-8")
            total_words += len(content)
        except:
            pass

    print_color(f"总字数: {total_words:,} 字", "yellow")
    print_color(f"预计阅读: {total_words // 300} 分钟", "yellow")

    # PDF 信息
    if os.path.exists(OUTPUT_PDF):
        file_size = os.path.getsize(OUTPUT_PDF)
        size_mb = file_size / (1024 * 1024)
        print_color(f"\nPDF 文件: {OUTPUT_PDF}", "yellow")
        print_color(f"PDF 大小: {size_mb:.2f} MB", "yellow")
        print_color(
            f"创建时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", "yellow"
        )

    print()


def main():
    """主函数"""
    print()
    print_color("🔥 Firecrawl 学习手册 PDF 生成器 v2.0", "blue")
    print("=" * 50)
    print()

    # 1. 合并 Markdown
    md_content = merge_markdown_files()

    # 2. 转换为 HTML
    html_content = markdown_to_html(md_content)

    # 3. 生成 PDF
    success = generate_pdf(html_content, OUTPUT_PDF)

    # 4. 显示统计
    if success:
        show_stats()

        print_color("🎉 PDF 电子书生成完成！", "green")
        print()

        # 提示打开
        print_color("💡 使用以下命令打开 PDF:", "blue")
        print_color(f'   open "{OUTPUT_PDF}"', "yellow")
        print()


if __name__ == "__main__":
    # 切换到脚本所在目录
    os.chdir(Path(__file__).parent)
    main()
