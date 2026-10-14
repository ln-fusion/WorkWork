# 正式资源替换

后续已接入用户Image目录素材，见 `ui-art-integration.md`。Canvas不挂背景Image，背景和设置纸张均为独立子Image；页面根由ResponsiveUiFrame做等比适配。制作当前正式风格界面使用 `WorkWork/Apply Layered Art UI`，原Create MVP Scene菜单仅生成早期占位框架，不能用于保留正式布局。

打开 `Assets/WorkWork/Config/VisualTheme.asset` 在Inspector修改：

- Font：中文TMP字体资源。
- Card Face：卡牌通用底图；点数和花色文字由独立组件显示。
- Suit Icons：按黑桃、红桃、梅花、方块顺序引用Sprite；未配置时使用花色文字。
- Content Art：按员工/道具稳定ID填图标。ID来自GameCatalog里的content.id，不依赖文件名。例：employee.chips、item.mult。
- Office Background：背景Sprite。
- Suit Colors、Card Color、Selected Color：花色和选中颜色。

PNG导入设为Sprite (2D and UI)，按素材需求选过滤和透明设置；背景不必继承占位素材尺寸。更换Sprite不改牌点数、效果或网络ID。

卡牌底图不应预印固定点数/花色，当前Prefab会叠加这些文字。如要用24张完整卡面，后续可在主题里扩展按花色/点数的映射，规则层不需要修改。

改卡牌布局：编辑 `Assets/WorkWork/Prefabs/Card.prefab`，保留CardView的Face、RankText、SuitText、SuitIcon、Button和Drag引用；交互根和视觉元素分开。实例化时按工位和准备区容器尺寸填充，素材尺寸不控制拖放范围。

改工位/商店布局：编辑MVP场景中对应UI子节点，保留GameController引用。当前工位布局在场景中，卡牌已是Prefab；其他节点后续可继续拆Prefab。

改数值/效果：用 `GameCatalog.asset`，不要在VisualTheme中改业务配置。示例内容非正式员工数值表。

生成菜单 `WorkWork/Create MVP Scene` 会重建MVP场景，但已有GameCatalog、VisualTheme和Card.prefab会保留。已经手改布局后不要为了换图重新生成场景，直接修改配置或Prefab即可。
