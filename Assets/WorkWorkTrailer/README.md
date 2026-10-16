# 宣传片专用内容

本目录与正式内容分开管理。员工、道具的演示技能和价格不代表正式规则或正式平衡。

- 场景仍使用用户原有的 `Assets/WorkWork/Scenes/WorkWorkMvp 1.unity`，保留布局、工位、按钮和交互。
- `Config/TrailerCatalog.asset`：16名员工和30件道具的临时技能、价格与商店候选。
- `Config/TrailerTheme.asset`：独立图像映射，引用原有 Image 素材，不修改原主题。
- `Runtime/TrailerCastPreview.cs`：运行后填入演示阵容，直接显示原游戏界面；不创建额外 Canvas 或镜头。
- `Editor/TrailerContentSetup.cs`：一次性配置入口。菜单 `WorkWork/Trailer/Configure Cast In Existing Scene` 会重建临时目录配置，仅在需要重新装配时使用；日常改技能请直接编辑 TrailerCatalog。
- `Previews/existing-scene-cast.png`：此次现有界面的检查截图。

打开宣传片场景直接 Play。默认六人：程序、美术设计、财务、游戏运营、QA、PM；每人三件道具，手牌为梅花1至6。初始资金100、演示目标20000。F1/F2/F3 切换三组阵容并重置演示局；所有员工及道具也已加入该场景专用商店池。右键使用原有详情浮窗查看临时技能。

预览存档为 `workwork-trailer-preview.json`；正式场景默认存档保持 `workwork-mvp.json`。存档隔离通过 GameController 的可选 checkpointFileName 字段完成，正式场景留空保持原行为。

所有后续新增脚本、图片等宣传片资源继续放在本目录。字幕/banner尚未添加；先前自动45秒独立画布演出方案已撤销。

完整表格与边界见 Document/trailer-content-config.md 和 Document/trailer-scene-outline.md。
