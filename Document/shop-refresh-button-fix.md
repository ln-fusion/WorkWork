# 进商店刷新按钮锁定修复（2026-10-18）

显示补充：刷新5次耗尽机会（当前价格递增到6时）后，价格文本改为“无机会”，固定20号字并关闭自动字号；新商店刷新次数归零后恢复正常价格和原有字号/自动字号设置。仅改显示，不额外增加刷新机会。运行验证覆盖耗尽和归零恢复。

原因：Render在ShopReveal入场时读取IsBusy=true并禁用刷新按钮；ShopReveal结束仅恢复CanvasGroup和IsPlaying，不触发Render。结果按钮自身interactable仍为false，直到另一操作触发Render才恢复。

GameController抽出RefreshInteractionState，由Render和LateUpdate调用，只同步刷新、重抽、结算按钮状态，不逐帧重建卡牌/文本。商店入场结束后下帧恢复刷新；资金不足、刷新次数到5、其他动画忙碌时仍禁止。重抽/结算同样跟随动态忙碌状态恢复。

Unity运行验证：重新启用商店入场时IsPlaying=true、刷新按钮false；动画结束后未购买、未调用Render，按钮自动true。将资金设0后按钮自动false，将刷新次数设5后按钮自动false。控制台无错误/警告，退出运行模式并解除暂停。未调用交易入口写存档，未改场景或用户的刷新价格配置。
