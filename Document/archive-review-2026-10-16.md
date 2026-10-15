# 归档与清理检查（2026-10-16）

## 已补归档

- README新增全部表现功能导航；mvp-status更新为当前完成范围，删除“逐事件动画尚未实现”等过时待办。保留10月15日检查作为历史。
- 新增presentation-interfaces.md，统一记录计分事件、牌动画、奖金揭示、胜负入场、持续喷花对象池、商店收回、手机拾起、操作反馈、空位闪烁、部署倾斜和加载回调的入口与生命周期。
- 修正stepwise-scoring.md关于动画完成状态及提交时机的旧说明；加载文档按最终实现归档：透明镂空、先加载并切游戏，再翻转，最后发牌。
- 明确GameShell.cash实际为累计分数，shopCash才是资金，避免后续接口迁移误接；记录IsBusy/IsEntering及PhonePickup的锁定例外。
- 联机、重资源异步加载和正式技能全集仍未实现，未把预留接口写成已完成功能。四项已取消机制保持取消。

## 清理及维护

删除4个确认无运行依赖的产物：两张本轮临时镂空截图、Document/Captures/settings-art-1.png、Document/unity-build.log。其中settings-art-1.png与保留的game-art-1.png具有相同SHA256且无文档引用。仅删除明确文件，不递归清空目录。

移除LoadingTransitionSetup中一次性Verify Loading Transparency截图菜单和捕获协程，将透明输入层/等比覆盖的断言并入Verify Loading Transition。正常加载回归保留。

修正GameSession仍写“五个附魔槽”的过时注释，实际始终是四个；将一个规则测试的晦涩加法断言改为直接比较执行前后重抽数。

ArtUiBuilder完整初始化入口此前漏接新增表现组件，已补齐ScoreFeedback、CardMotion、ShopReveal、胜负入场、喷花、PhonePickup、ActionFeedback、DropHints、DeploymentTilt和LoadingTransition的装配调用。本次仅编译，没有执行整场景重建，不覆盖手调UI和参数。

未发现可确认废弃的运行时组件。MvpBuilder/ArtUiBuilder及各Setup有生成/修复入口，Verification和MvpSmoke仍用于回归，MvpEditorBridge用于MCP连接，保留。用户美术、字体、音频、场景、Prefab、Reference、反编译研究工具与历史报告保留。

## 验证

- Unity重新编译成功。
- EditMode 80/80通过，0失败、0跳过，job：01ea8f260f924641bf495aa3de649abd。
- ProjectAudit新增表现组件必需引用检查；当前场景及Prefab共357对象/1190组件，0问题，见project-audit-results.txt。
- Play加载过场验证通过：透明输入层与全屏等比适配、真实就绪等待、切游戏先于翻转、输入/重复调用锁、成功/失败/取消清理，见loading-transition-verification.txt。
- 当前控制台无错误，已退出Play，验证未修改存档。没有重跑全部动画手工回归、整场景再生成或独立构建，不将历史验证当成本次新验收。

未执行Git提交；归档指工作区内记录，不意味着已进入版本库历史。
