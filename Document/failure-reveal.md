# 失败界面下坠（2026-10-15）

Lose Group挂FailureReveal，运行时每次显示从画布上方加速坠落，再向上反弹3次，反弹高度和时长逐次衰减，最后恢复进入前的anchoredPosition。编辑态不播放，不修改手调位置/缩放/图像。

Inspector参数：Fall Duration默认0.45秒；Bounce Height默认65（画布坐标）；Bounce Duration默认0.28秒；Bounce Count默认3；Bounce Decay默认0.4。起点按可见Graphic最低边自动算到画布顶部之外，适应画布尺寸。

动画中CanvasGroup禁止内部按钮交互，完成或禁用组件后还原。停用会取消协程和恢复位置；再次显示重新播放。

Play隔离复制界面验证通过：起点在上方、落地反弹、最终原位、交互恢复、中断还原。报告failure-reveal-verification.txt；控制台无错误，已退出Play。MCP在进入Play时短暂断连，重试已恢复。未修改存档。
