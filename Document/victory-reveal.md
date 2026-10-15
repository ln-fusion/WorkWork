# 成功界面入场与喷花（2026-10-15）

Win Group复用FailureReveal（和Lose Group相同），下坠并逐渐减弱反弹3次，停回手调原位。GameShell.RevealResult等待Win Group的FailureReveal.IsPlaying结束，再依次播放奖金。等待期间所有奖金数字空白，进入商店按钮继续隐藏，IsResultRevealing持续锁住操作；编辑态不播放。

Win Group挂VictoryFlowers，使用Assets/Image/sakura.png（导入为Single Sprite，原图不改）。界面显示期间持续从画布左右两侧同时向内上方随机喷射，默认每0.22秒两侧各一朵，50–75画布单位。多数横向速度70–150，使两侧密集；12%概率使用300–450横向速度向中央飘，中央额外淡化避免遮挡信息。花朵随机速度/大小/旋转，重力下落，3秒寿命末尾淡出。效果层在画布下独立创建，不随面板下坠，不拦截鼠标。

花朵之间使用画布坐标圆形碰撞：消除重叠并按相对速度与Restitution施加反弹冲量；120Hz最大子步，不接触场景Physics2D或其他对象。独立System.Random不消耗规则随机数。对象池预热32朵、硬上限48朵，寿命结束或离开屏幕底部回池；满时跳过发射。禁用成功组时全部回池并隐藏效果层，再次启用复用；销毁组件才销毁池和效果层。

Inspector：Win Group → FailureReveal调整下坠/反弹，VictoryFlowers调整Flower Size、Emission Interval（越大越慢）、Center Spray Chance、Max Flowers、Prewarm Count、Horizontal/Vertical Speed、Gravity、Restitution、Lifetime。移除旧的一次性喷射字段Flowers Per Side/Emission Duration。

Play隔离复制界面验证通过：入场与两侧喷花同时启动、落地前数字不显示、停稳后顺序结算、总和准确、实际碰撞、超过寿命后持续喷射、池总量稳定且不超过上限、停用回收及重开复用。报告victory-reveal-verification.txt。控制台无错误，已退出Play；未修改存档或手调布局。MCP进入Play时短暂断连后已恢复。
