# 月末奖金揭示（2026-10-15）

胜利界面所有数字为奖金金额：达到目标=基础奖金4；剩余点数=超额比例奖金（达到目标150%给1、200%给2）；利息=lastInterest；特殊效果=lastStaffIncome；底部总和=lastIncome。基础奖金通过已保存总收入减去其他三项恢复，不重复入账。失败界面继续显示目标分数和实际分数。

依次揭示基础奖金→超额奖金→利息→特殊效果→总和，每项先随机跳数再停到准确整数，0也播放。后续数字保持空白，总和最后揭示；原布局和美术不变。重复Render不重播；重新进入保存的月末结算会重新播放。

GameShell可调Result Roll Duration（每项默认0.45秒）、Result Reveal Delay（每项前默认0.15秒）、Result Roll Interval（默认0.035秒）。5项默认约3秒。独立随机源，不改变游戏随机结果。

播放时IsResultRevealing计入GameController.IsBusy，进入商店按钮隐藏且禁用，点击回调也检查锁。设置/返回欢迎入口在播放时禁止，不能跳过动画。播放完恢复按钮；运行时组件停用会清理协程。

验证：编辑态胜负界面检查涵盖4/2/1/0/7奖金；Play隔离对象验证依次揭示、准确落点、总和最后显示及按钮和忙碌锁恢复，通过。报告result-reveal-verification.txt。控制台无错误，已退出Play，未修改存档。

进入商店提示在揭示完成、按钮可用后呼吸闪烁，仅改变文字透明度，不改变原始文字颜色/布局或Button的ColorTint。GameShell的Shop Hint Pulse Period默认1.6秒一周期，Shop Hint Min Alpha默认0.35；按钮隐藏/禁用或组件停用后重置，从全亮开始。暂停跟随Time.deltaTime。已编译，控制台无错误。
