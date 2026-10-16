# 功能与表现接口归档（2026-10-16）

2026-10-17：ConditionFeedback.Play/Clear读取ScoreStep.linkedCardIds/linkedEmployeeSlots/linkedItemSlots/linkedEmptySlots，按步骤高亮后再显示收益；ScoreFeedback.AnimateSource与Play(game,step,false)分开发来源动作和飘字。接口与覆盖范围见 condition-feedback.md。

2026-10-17：新增CardDeletionFeedback.Play/IsDeleted/Clear与ScoreStep.deletedCards；小夜灯各目标额外计分后发独立删除步骤，末尾收牌过滤已经斩断的实体。参数与规则见 card-deletion-motion.md。

2026-10-17：CardMotion.FlyGenerated复用原上送动画，读取ScoreStep.generatedCards；月初读取GameSession.MonthlyGeneratedCards，并由DealMonthHand控制手牌隐藏/恢复。表现不生成实际奖励，见 generated-card-motion.md。

2026-10-17：新增 CardFaceFeedback 与ScoreStep.faceChanges；CardView.PresentFace只覆盖显示，先播放牌面再播放附魔变化，取消时恢复。参数与接口见 card-face-motion.md。

2026-10-17：新增 EnchantmentFeedback，读取ScoreStep.enchantmentChanges（cardId、before、after），通过Play/Transaction表现结算与交易中的附魔变化；CardView仅覆盖显示，不提前修改权威状态。参数与取消接口见 enchantment-motion.md。

2026-10-17流程调整：新会话从开局商店开始，openingShop标记使首次NextMonth仍进入第1月；过场后不再立即发牌，首次离店复用商店缩回与抽牌。后续月末流程不变，见 opening-shop.md。

正式内容与新规则接口已接入，见final-content-integration.md。新增Settlement快照结算、ContentRules牌堆操作、独立任务事件统计及限期装备月份记录；既有动画读取结算步骤，提交已经播放的同一份结果，不重复生成随机收益。

本文是入口索引，具体规则和参数细节在分项文档。Inspector中的值可由用户手调，文档给出的是代码初始值，不覆盖场景中的自定义值。场景位于Assets/WorkWork/Scenes/WorkWorkMvp.unity。

| 功能 | 组件/对象 | 触发接口或数据 | 记录 |
| --- | --- | --- | --- |
| 摆牌预览/顺序结算 | Core.Scoring、GameController | Preview只含牌型初值；Evaluate生成ScoreResult.steps；ScoreWeek实际提交 | stepwise-scoring.md |
| 来源跳动与飘字 | GameController上的ScoreFeedback | Play(game,step)、RollScore(label,previous,target,duration)、ClearFeedback | stepwise-scoring.md |
| 抽收牌与复制上送 | GameController上的CardMotion | Fly(game,cards,drawing,hideOriginal=true,copiedCard=null)、Clear | card-motion.md |
| 胜利奖金逐项揭示 | GameShell | Refresh启动；IsResultRevealing锁住跳过；基础/超额/利息/特殊/总和 | month-result-reveal.md |
| 胜负入场 | Win Group/Lose Group上的FailureReveal | OnEnable下坠反弹；IsPlaying供胜利奖金等待；停用还原 | failure-reveal.md、victory-reveal.md |
| 持续喷花 | Win Group上的VictoryFlowers | OnEnable持续发射，OnDisable回池，OnDestroy清理；LiveCount/CreatedCount/ReusedCount/CollisionCount是验证计数 | victory-reveal.md |
| 商店伸出/缩回 | Shop上的ShopReveal | OnEnable、Retract()、CancelAnimation()、IsPlaying；点击下个月先收回 | shop-reveal.md |
| 任务手机拾起 | Task Panel/Task Choice上的PhonePickup | OnEnable自动播放，Source Phone为桌面Task，Phone Graphic为Phone Background；停用还原 | phone-pickup.md |
| 操作反馈 | GameController上的ActionFeedback | Pulse、Spend、Failure、VibratePhone、ObservePattern、Clear | action-feedback.md |
| 可放入空位提示 | GameController上的DropHints | DragToken调用Show/Hide，经GameController.ShowDropHints/HideDropHints；覆盖层缓存复用 | drop-hints.md |
| 员工部署倾斜 | GameController上的DeploymentTilt | Begin(token)、End()、ResetPose()；DragToken开始/结束触发 | deployment-tilt.md |
| 双面镂空过场 | Canvas/Loading Transition | Play(load,completed,failed,reveal)、Cancel；GameController.NewGame/ContinueGame共用EnterGame | loading-transition.md |
| 牌库副数 | GameCatalog资源Rules | Deck Copies；每副24张，每月重建，当前默认2 | deck-copies.md |

## 加载回调顺序

`Play(Func<IEnumerator> load, Action completed, Action<Exception> failed=null, Action reveal=null)`：先淡入正面，执行并等待load；成功后调用reveal切换底下的游戏界面，再翻到背面、淡出，最后completed解锁并开始新局发牌。异常交给failed；取消不调用成功回调。load支持嵌套IEnumerator和Unity可等待对象。当前只是同步会话准备包装成协程，未来资源/场景加载应放入load；不能把过场播放结束当作资源加载完成。

正反面资源是Assets/Image/Loading/1.png、2.png；Flipping Mask显示PNG，Input Blocker全透明但拦截输入。无需额外黑底。退场后才播放商店/胜负入场及奖金动画。

## 计分数据与权威边界

ScoreStep携带来源类型/工位/装备槽、累计chips/multiplier、点数增量、倍率增量或乘数、extraRedrawDelta及copiedCard快照。表现组件只播放，不发奖励或重复入账；GameSession.ScoreWeek才改变分数、资金、重抽次数和牌库。当前在隔离副本上Evaluate预生成步骤，按步骤播完再调用ScoreWeek提交；尚未接网络权威结果。

GameShell.cash历史字段名实际显示本月累计分数；shopCash和TaskPanel.currentCash才是资金。后续改名必须迁移序列化引用，不可仅改字段造成手调场景引用丢失。

## 生命周期和输入锁

GameController.IsBusy含计分、发/收牌、商店动画、入场过场和奖金揭示。新游戏/继续/返回欢迎走CancelScoring清理来源跳动、牌动画、操作提示、空位提示和桌面倾斜。PhonePickup不加入IsBusy，避免GameShell的任务选择自动开关与其形成自我关闭循环；自身CanvasGroup暂时禁用按钮。普通按钮悬停/按下继续用Unity原生ColorTint。

多数动画跟随Time.deltaTime暂停；LoadingTransition用unscaledDeltaTime，设置不能跳过入场或奖金揭示。编辑态不自动动画，结束/取消还原原始布局。运行中短暂生成的覆盖层、预览和花朵不应写入场景。

## 编辑器入口与维护

各*Setup.Configure菜单用于单项装配/恢复引用，可能保存场景或重置该项默认参数，不应拿来日常改动画速度；日常调Inspector。*Verification/Verify菜单是回归工具，不进入运行时构建，保留。新的表现组件已补入ArtUiBuilder完整生成链，但完整生成会覆盖手调UI，本次只编译检查，没有执行。

ProjectAudit检查场景/Prefab缺失脚本与断开引用，并检查这些新组件的必需引用、任务手机、加载透明层、胜负入场和花朵资源。它不把可选旧文本一律当作错误。

联机仍未实现；未来接房主权威事件时复用上述表现入口，不能让客户端动画决定规则结果。已取消的月度Buff、逐周场地、牌型升级、投资兑付不恢复。
