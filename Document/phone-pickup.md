# 手机面板拾起动画（2026-10-16）

Task Panel和Task Choice挂PhonePickup。显示时从桌面Task按钮中心出发，小尺寸、X轴倾斜和轻微Z轴旋转，向上抬起后放大摆正，末段轻微放大至1.025后停稳。最终恢复各子物体原位置、缩放、旋转，不重建层级，不修改手调布局。背景遮罩保持全屏并淡入；Task Panel的大尺寸Close是遮罩，Task Choice使用Backdrop。

默认Duration=0.55秒、Lift Height=60、Table Tilt=50、Table Rotation=-12。Source Phone引用桌面Task按钮，Phone Graphic引用各面板Phone Background。初始大小依据桌面手机与面板手机高度比例计算，无法取得来源时用Fallback Scale=0.18。

动画期间CanvasGroup禁用面板内部交互，完成恢复，隐藏/中途关闭立即停止并恢复所有姿态和遮罩透明度，再次显示重新播放。设置暂停跟随Time.deltaTime。任务内容/选择和奖励规则不变，不加入GameController.IsBusy以免任务选择自动显示逻辑反复关闭自己。

Play隔离克隆两个面板验证：起始位移/缩小、落位准确、交互恢复、再次打开及中途停用还原。报告phone-pickup-verification.txt。未改存档。MCP进入Play时短暂断连，重试后恢复。
