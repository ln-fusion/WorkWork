# 拖拽空位提示（2026-10-16）

购买或移动员工/道具的拖拽开始时显示所有对应空位：员工对应空员工工位，道具对应已有员工且为空的装备槽。占用槽不闪烁，原有交换功能保留；卡牌不参与本提示。购买时仅判断空间资格，资金不足仍可看到空位，落下时使用既有资金不足反馈。

GameController挂DropHints；Highlight Color默认#FFEFD1，Pulse Period默认0.8秒，Min/Max Alpha默认0.15/0.8。覆盖层为目标按钮的子Image，拉伸适配区域，不修改原底图、不接收射线，不影响原Button配置。覆盖层按目标缓存复用。

DragToken.OnBeginDrag开启，OnEndDrag/源停用时隐藏，Drop和CancelScoring也隐藏。忙碌时清理，组件停用隐藏，销毁清理覆盖层。阶段沿用规则：员工Playing/Shop，道具和商品仅Shop。

Play隔离会话验证通过：员工空工位数、道具筛选、精确RGB和透明度闪烁、无射线阻挡、覆盖层复用、阶段和卡牌排除，真实DragToken开始/结束及源停用清理。报告drop-hints-verification.txt。控制台无错误，已退出Play；未改存档。
