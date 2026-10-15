# 商店进入动画（2026-10-15）

Shop增加ShopReveal组件，进入/载入商店时整组从画面下方向上滑出，ease-out减速，结束恢复原anchoredPosition。根据Canvas坐标和可见Graphic边界计算移出画面的距离，兼容不同分辨率；保留手调位置、大小和比例。

Duration默认0.45秒；Slide Distance=0自动计算，正值指定Canvas设计单位距离。刷新和买卖不重新播放，因为Shop没有重新激活。进入期间CanvasGroup阻止交互，GameController.IsBusy同步锁定点牌、拖拽、刷新、进入下月；完成恢复之前的CanvasGroup设置。关闭/禁用时停止动画并还原位置，设置暂停沿用Time.deltaTime。

Play实际场景验证通过：从下方开始、交互锁定、完成回原布局、再次激活后中途关闭还原。未修改游戏会话或存档，临时验证结束恢复页面激活状态，已退出Play。报告shop-reveal-verification.txt；控制台无错误。首次通过MCP直接改运行对象的接口不支持Play，后改用项目菜单验证。
# 商店退出补充（2026-10-16）

点击下个月结束购买时，ChangeCards先等待ShopReveal.Retract将商店整体缩回画布下方，再进入新月份和发牌，不在每次购买后关闭商店。Retract Duration默认0.35秒，复用Slide Distance自动边界计算。退出期间IsCardTransition/ShopReveal.IsPlaying锁住重复操作。到达隐藏位置才禁用商店，OnDisable在不可见时恢复手调位置及交互状态，避免下次打开错位；返回欢迎/切换会话时CancelScoring也取消商店动画。

Play验证进入/收回、交互锁、收回后隐藏、重开和中断还原通过，报告shop-reveal-verification.txt。当前运行控制台无错误，已退出Play；未改存档。

