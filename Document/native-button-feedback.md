# 原生按钮反馈（2026-10-15）

只使用 Unity Button 自带 Color Tint；未新增运行时脚本。当前场景 52 个 Button 与 Card.prefab 中的 Button 已配置：Normal 白色，Highlighted RGB 0.85，Pressed RGB 0.7，Selected 白色，Color Multiplier 1，Fade Duration 0.08 秒。Disabled 保留原值。

员工、道具与商品的透明点击区域将 Target Graphic 指向可见图像；刷新与下月按钮指向现有美术图层。空卡槽没有可见图像时保留透明点击区域，卡牌本身会在悬停/按下时加深。

Restart 图案烘焙在失败背景内：使用 Unity 自带 RectMask2D 和 Image，仅在按钮区域显示同一背景的对应部分，作为 Color Tint 的 Target Graphic，因此加深不会影响整个失败界面。Button Artwork 是普通 UI 图像，可在 Inspector 换为正式独立按钮图片。

全场景配置菜单：WorkWork/Apply Button Color Tint。现有美术生成代码与 Done/Roll/Setting 绑定代码已同步配置；这仅负责编辑器配置，不在运行时挂自定义反馈脚本。拖动预览不可交互，继续不带悬停效果。

静态验证：53 个 Button 的 Color Tint、悬停色、按下色及 Target Graphic 引用全部通过；新增 UI 父引用检查通过。
