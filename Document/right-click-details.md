# 右键详情浮窗（2026-10-15）

右键手牌或场上牌：仅有附魔时弹出浮窗，按卡牌附魔的添加顺序逐条显示名称与效果，最多五项；没有附魔时不显示并关闭之前的浮窗。

右键员工或道具：显示各自名字与效果，分别使用 Name 和 Effects 两个 TMP 文本框。支持游戏内员工/道具、商店内已拥有员工/道具以及在售商品。道具显示道具自身的名字与效果。空工位、空道具槽不弹窗。商品右键查看不会购买或扣款；右键不会开始拖动。

文字数据：员工/道具使用 GameCatalog.rules.content 中 name 与 description；附魔统一由 InspectionText 映射七种已实现效果。浮窗不会修改游戏状态，查看时附魔变化会更新说明。

浮窗在鼠标附近显示，并限制在画布可见范围内。背景是独立 Image，复用 WindowContent.png，字体统一 LXGWMarkerGothic-Regular SDF。点击、拖动、Esc 或切换欢迎/设置界面关闭浮窗；浮窗不阻挡落点射线。

资源与布局：Assets/WorkWork/Prefabs/DetailsTooltip.prefab，可独立调整背景、宽度、名字和效果两个文本框。GameController.tooltipPrefab 配置预制体引用。WorkWork/Apply Right Click Details UI 菜单配置当前场景；完整美术场景生成器也包含此配置。

验证：44 项 EditMode 规则测试通过；TooltipVerification 验证手牌/场上牌附魔顺序、无附魔/空槽隐藏、员工/道具在游戏及商店中显示正确、全部商品右键不购买、右键不拖动、屏幕边缘限制与不阻挡输入。DragVerification 回归通过。验证使用隔离局，不修改玩家存档。
