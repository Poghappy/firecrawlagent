#!/usr/bin/env python3
"""Firecrawl API 密钥测试脚本

用途：验证所有 API 密钥是否有效
"""

from datetime import datetime

from firecrawl import FirecrawlApp


# 你的 API 密钥列表
API_KEYS = {
    'main': 'fc-31ebbe4647b84fdc975318d372eebea8',
    'backup_1': 'fc-00857d82ec534e8598df1bae9af9fb28',
    'backup_2': 'fc-9eb380b0dec74d6ebb6c756ee4de4c5a',
    'backup_3': 'fc-0a2c801f433d4718bcd8189f2742edf4',
}

# 测试 URL
TEST_URL = 'https://www.firecrawl.dev/'

def mask_key(key: str) -> str:
    """隐藏 API 密钥（安全显示）"""
    return f"{key[:8]}...{key[-4:]}" if len(key) > 12 else "***"

def test_api_key(name: str, api_key: str) -> dict:
    """测试单个 API 密钥"""
    print(f"\n🔍 测试 {name} ({mask_key(api_key)})...")

    try:
        # 初始化客户端
        app = FirecrawlApp(api_key=api_key)

        # 测试爬取
        start_time = datetime.now()
        result = app.scrape(
            url=TEST_URL,
            formats=['markdown'],
            only_main_content=True  # Python SDK 使用 snake_case
        )
        elapsed = (datetime.now() - start_time).total_seconds()

        # 检查结果（Firecrawl v2 返回 Document 对象）
        if result and hasattr(result, 'markdown'):
            content_length = len(result.markdown or '')
            title = getattr(result, 'title', 'N/A') or 'N/A'

            print(f"✅ {name} 有效！")
            print(f"   耗时: {elapsed:.2f}秒")
            print(f"   内容长度: {content_length} 字符")
            print(f"   标题: {title[:50]}")

            return {
                'status': 'success',
                'key': name,
                'masked_key': mask_key(api_key),
                'elapsed': elapsed,
                'content_length': content_length,
                'title': title
            }
        print(f"⚠️ {name} 响应异常")
        return {
            'status': 'warning',
            'key': name,
            'masked_key': mask_key(api_key),
            'error': '响应格式异常'
        }

    except Exception as e:
        error_msg = str(e)
        print(f"❌ {name} 失败: {error_msg}")

        # 判断错误类型
        if 'unauthorized' in error_msg.lower() or 'api key' in error_msg.lower():
            status = 'invalid'
        elif 'rate limit' in error_msg.lower():
            status = 'rate_limited'
        else:
            status = 'error'

        return {
            'status': status,
            'key': name,
            'masked_key': mask_key(api_key),
            'error': error_msg
        }

def main():
    """主函数"""
    print("=" * 60)
    print("🔥 Firecrawl API 密钥测试")
    print("=" * 60)
    print(f"测试 URL: {TEST_URL}")
    print(f"密钥数量: {len(API_KEYS)}")
    print(f"测试时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    # 测试所有密钥
    results = []
    for name, api_key in API_KEYS.items():
        result = test_api_key(name, api_key)
        results.append(result)

    # 打印总结
    print("\n" + "=" * 60)
    print("📊 测试总结")
    print("=" * 60)

    # 统计
    success_count = sum(1 for r in results if r['status'] == 'success')
    invalid_count = sum(1 for r in results if r['status'] == 'invalid')
    error_count = sum(1 for r in results if r['status'] in ['error', 'warning', 'rate_limited'])

    print(f"\n总计: {len(results)} 个密钥")
    print(f"✅ 有效: {success_count}")
    print(f"❌ 无效: {invalid_count}")
    print(f"⚠️ 错误: {error_count}")

    # 详细结果
    print("\n详细结果:")
    for i, result in enumerate(results, 1):
        print(f"\n{i}. {result['key']} ({result['masked_key']})")
        print(f"   状态: {result['status']}")

        if result['status'] == 'success':
            print("   ✅ 可用")
            print(f"   耗时: {result['elapsed']:.2f}s")
            print(f"   内容: {result['content_length']} 字符")
        else:
            print(f"   ❌ {result.get('error', '未知错误')}")

    # 推荐配置
    print("\n" + "=" * 60)
    print("💡 推荐配置")
    print("=" * 60)

    valid_keys = [r for r in results if r['status'] == 'success']

    if valid_keys:
        print("\n建议使用以下密钥配置到 .env 文件：\n")

        if len(valid_keys) >= 1:
            print("# 主密钥")
            print(f"FIRECRAWL_API_KEY={API_KEYS[valid_keys[0]['key']]}")

        if len(valid_keys) >= 2:
            print("\n# 备用密钥 1")
            print(f"FIRECRAWL_API_KEY_BACKUP_1={API_KEYS[valid_keys[1]['key']]}")

        if len(valid_keys) >= 3:
            print("\n# 备用密钥 2")
            print(f"FIRECRAWL_API_KEY_BACKUP_2={API_KEYS[valid_keys[2]['key']]}")

        if len(valid_keys) >= 4:
            print("\n# 备用密钥 3")
            print(f"FIRECRAWL_API_KEY_BACKUP_3={API_KEYS[valid_keys[3]['key']]}")
    else:
        print("\n⚠️ 没有找到有效的 API 密钥！")
        print("请检查：")
        print("1. 密钥是否正确")
        print("2. 网络连接是否正常")
        print("3. Firecrawl 服务是否在线")

    print("\n" + "=" * 60)

if __name__ == "__main__":
    main()
