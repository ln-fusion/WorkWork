# 商品图片居中（2026-10-15）

闹钟原图是带火焰的竖图，商品图片区原来高 174，从 y=104 到 278；名字框从 y=246 开始，两者重叠 32。闹钟填满高度时容易显得靠下且压到名字。

六个商品 Image 均改为宽 164、高 132，保持原来顶部 y=104，与名字区域留出 10 的间隙。Anchor 与 Pivot 改为中心，Pos X=0、Pos Y=10，开启 Preserve Aspect。没有移动价格、名字或整个商店，也没有修改 PNG。商品换栏后仍使用相同图片区，不依赖闹钟当前所在栏。

手调方式：展开 Shop/Offer N/Content Icon，修改 Rect Transform 的 Pos X、Pos Y 和 Width/Height；保持中心锚点与 Preserve Aspect。全部六栏一起改能保证刷新后的布局一致。后续修改素材本身可继续从 VisualTheme 配置。

当前场景六栏图片框几何检查通过，ArtUiBuilder 生成布局同步为 164×132。未进行本轮运行时截图验证。
