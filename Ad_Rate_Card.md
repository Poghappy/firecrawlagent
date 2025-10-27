# HawaiiHub 广告图片资源库

**更新日期**: 2025-10-26  
**用途**: 存放所有平台广告素材、Banner、封面图等图片资源

---

## 📁 目录结构

```
ad-assets/
├── banners/              # Banner 广告图
│   ├── homepage/         # 首页 Banner
│   ├── category/         # 分类页 Banner
│   └── mobile/           # 移动端 Banner
├── covers/               # 文章封面图
│   ├── news/             # 新闻封面
│   ├── lifestyle/        # 生活封面
│   ├── food/             # 美食封面
│   └── travel/           # 旅游封面
├── promotions/           # 促销活动图
│   ├── merchants/        # 商家促销
│   ├── events/           # 活动海报
│   └── seasonal/         # 节日活动
├── social/               # 社交媒体图
│   ├── wechat/           # 微信公众号
│   ├── facebook/         # Facebook
│   └── instagram/        # Instagram
└── templates/            # 设计模板
    ├── psd/              # Photoshop 源文件
    └── figma/            # Figma 设计稿
```

---

## 🎨 图片规格标准

### Banner 广告位

| 位置 | 尺寸（px） | 格式 | 最大文件 | 备注 |
|------|-----------|------|----------|------|
| 首页顶部 | 1200x400 | JPG/PNG/WebP | 500KB | 16:9 比例 |
| 首页侧栏 | 300x600 | JPG/PNG | 200KB | 竖版长图 |
| 频道页顶部 | 970x250 | JPG/PNG/WebP | 400KB | 横幅 |
| 频道页侧栏 | 300x250 | JPG/PNG | 150KB | 正方形 |
| 信息流原生 | 640x360 | JPG/WebP | 300KB | 16:9 比例 |
| 移动端 Banner | 750x400 | JPG/WebP | 250KB | 移动端优化 |

### 内容封面图

| 类型 | 尺寸（px） | 格式 | 最大文件 | 备注 |
|------|-----------|------|----------|------|
| 新闻封面 | 800x450 | JPG/WebP | 300KB | 16:9 比例 |
| 文章缩略图 | 400x225 | JPG/WebP | 100KB | 列表展示 |
| 分类信息图 | 600x400 | JPG | 200KB | 4:3 比例 |
| 圈子动态图 | 800x800 | JPG/PNG | 400KB | 正方形 |

### 社交媒体图

| 平台 | 尺寸（px） | 格式 | 最大文件 | 备注 |
|------|-----------|------|----------|------|
| 微信公众号封面 | 900x500 | JPG | 2MB | 16:9 比例 |
| 微信朋友圈 | 1080x1260 | JPG/PNG | 5MB | 9:10 比例 |
| Facebook 封面 | 820x312 | JPG/PNG | 100KB | 宽幅 |
| Facebook Post | 1200x630 | JPG/PNG | 8MB | 1.9:1 比例 |
| Instagram Post | 1080x1080 | JPG/PNG | 8MB | 正方形 |
| Instagram Story | 1080x1920 | JPG/PNG | 30MB | 9:16 比例 |

---

## 📦 现有资源清单

### Banner 广告（0 个）

暂无资源，待上传

### 内容封面（0 个）

暂无资源，待上传

### 促销活动（0 个）

暂无资源，待上传

### 社交媒体（0 个）

暂无资源，待上传

---

## 🔧 使用说明

### 上传图片

1. **命名规范**：`{类型}_{日期}_{描述}.{扩展名}`
   - 示例：`banner_20251026_christmas_sale.jpg`

2. **存储位置**：
   - 本地：`/ad-assets/{分类}/`
   - CDN：`https://cdn.hawaiihub.net/ad-assets/{分类}/`

3. **上传流程**：
   ```bash
   # 1. 将图片放入对应目录
   cp my-banner.jpg ad-assets/banners/homepage/
   
   # 2. 压缩优化
   npm run optimize-images
   
   # 3. 上传到 CDN
   npm run upload-to-cdn
   ```

### 获取图片 URL

```javascript
// 方式 1: 本地路径
const bannerUrl = '/ad-assets/banners/homepage/banner_20251026_christmas_sale.jpg';

// 方式 2: CDN URL
const bannerUrl = 'https://cdn.hawaiihub.net/ad-assets/banners/homepage/banner_20251026_christmas_sale.jpg';
```

### 图片优化

```bash
# 批量压缩图片（使用 ImageMagick）
npm run compress-images

# 转换为 WebP 格式
npm run convert-to-webp

# 生成多种尺寸
npm run generate-sizes
```

---

## 🎯 设计规范

### 品牌色

- **主色**: #1677FF (蓝色)
- **辅助色**: #52C41A (绿色)
- **强调色**: #FF4D4F (红色)
- **背景色**: #F5F5F5 (浅灰)

### 字体

- **中文**: PingFang SC, Microsoft YaHei
- **英文**: Roboto, Arial, Helvetica
- **标题**: Bold 700
- **正文**: Regular 400

### 文案要求

- 标题：不超过 15 个汉字
- 副标题：不超过 30 个汉字
- 正文：简洁明了，突出重点
- CTA 按钮：动词开头（如：立即查看、马上预订）

---

## 📊 使用统计

| 图片类型 | 数量 | 总大小 | 平均大小 | 最后更新 |
|---------|------|--------|----------|----------|
| Banner | 0 | 0 MB | - | - |
| 封面图 | 0 | 0 MB | - | - |
| 促销图 | 0 | 0 MB | - | - |
| 社交媒体 | 0 | 0 MB | - | - |
| **总计** | **0** | **0 MB** | **-** | **-** |

---

## 🔗 相关资源

- **图片压缩工具**: [TinyPNG](https://tinypng.com/)
- **在线设计工具**: [Canva](https://www.canva.com/)
- **免费图库**: [Unsplash](https://unsplash.com/), [Pexels](https://www.pexels.com/)
- **CDN 管理**: 宝塔面板 → 文件管理

---

**维护者**: HawaiiHub 运营团队  
**联系方式**: admin@hawaiihub.net
