# 任务面板（2026-10-15）

2026-10-16最新接入：15条正式任务已替换候选池，按周、月、交易和牌型集合分别统计，期限仍先完成再过期。原文见task-design.md，实际计数口径及配置入口见final-content-integration.md；下面测试任务、只按牌型统计的段落为历史实现。

背景使用 Assets/Image/PhonePanel.png，接到现有 Task（查看任务）按钮，保留按钮手调位置。原生Button变色；Backdrop、关闭按钮、Esc可关闭。面板独立Task Panel组，Phone Background为独立Image；最多三行，每行名称、水平Filled Image、current/target及奖金。统一项目字体，名称支持一般15字内自动缩小。无任务时显示暂无任务。

用户确认：不按月清零；奖金1～3元。当前测试任务：结算2次一对（奖励1）；结算2次炸弹（奖励3）。完成即时自动入账，每任务每局只发一次，已完成继续显示。新游戏清空，继续游戏恢复进度和已发奖状态；不自动换新任务。

计数规则：只在实际ScoreWeek时按最强牌型计一次，预览不计数。一对priority1；炸弹priority10/11（四条/四带对）。测试阶段如此配置，任务可在GameCatalog.asset → Rules → Tasks配置id/name/target/reward/patternPriorities。最多启用前三个有效且ID不重复任务，reward限制1～3。后续新增其他任务类型可扩充计数条件。

任务进度TaskProgress保存至GameState及SaveCodec，跨月保留，不改变牌堆重置。奖金在该周结算即时发，不依赖月度验收成功。

编辑布局：Hierarchy Task Panel及其Task 1/2/3；第三行当前隐藏，可临时激活调整。WorkWork/Preview/Task Panel可预览，WorkWork/Configure Task Panel为首次创建和绑定入口，已有面板不重新生成布局。

验证：Unity MCP EditMode Test Runner 67项全部通过，覆盖跨月、跨存档、发奖一次、三任务上限、1～3元限制。Play模式已检查PhonePanel、两行文本、进度轨道和关闭按钮显示，未进行完整人工鼠标点击验收；控制台无运行错误。Play切换曾短暂断开MCP，已恢复并告知用户。

## 期限任务（2026-10-15，用户最终确认按月数）

以月末实际结算为计时单位。GameCatalog → Rules → Tasks → Deadline Months：0不限期；正数为允许的月数。2表示允许两个月，第2个月第4周结算先检查完成，仍未完成才过期。月内其他周、预览、商店、重抽和现实等待不减少期限。

第三条测试任务改为“2个月内结算1次三条”，奖金2元，deadlineMonths=2、patternPriorities=[3]；前两条仍不限期。当前任务开局即启用，第一个月月末算用掉1个月；以后若增加中途发放任务机制，发放当月月末同样计1个月，除非另外约定。

面板显示“剩余X个月”。到期未完成隐藏并保存expired，不复活、不自动补任务，不扣现金或血量。存档保存elapsedMonths、expired和已发奖状态，跨月不重置；新游戏才全部重置。完成任务继续保留已发奖显示，不因后续期限而消失。

此前周数版是开发默认，已撤回；旧周计数字段不沿用为月计数，新月计数默认0。旧存档已经expired的任务仍维持过期状态。

验证：覆盖最后一个月最后一周达成、月末到期、月内不扣期限、跨存档与跨月保留、发奖一次；70项EditMode测试通过。
## 货币图标（2026-10-15）

所有运行时¥/￥文本统一改用VisualTheme.CurrencyIcon（TMP内嵌ShopPoint图标），保留原金额数字。任务奖金、已获奖金及旧资金/商店文字均替换，不改变手调位置、字号。素材为Assets/Image/ShopPoint.png，TMP图集资源Assets/WorkWork/Config/CurrencySprites.asset，由VisualTheme.currencySprites统一引用。

编辑器菜单WorkWork/Configure Currency Icon生成/更新图集并替换现有场景文字；GameController启动时为文字配置图集。图标跟随字号等比缩放，不被正文颜色染色。Play模式截图已确认三条任务图标及数字正确，控制台无错误，已退出Play。

## 每三个月四选一（2026-10-15，覆盖此前开局自动任务）

第4、7、10……月BeginMonth后生成四个随机候选，奖金分布固定1、2、2、3。TaskChoice是独立阶段，未选不能放牌/重抽/计分；进入欢迎或设置可暂时隐藏，继续后仍必须选择。完成选择立即保存周初检查点。

GameCatalog → Rules → Tasks现在是候选池，不自动成为玩家任务，也不限制池子只有三条。池至少有1条1元、2条2元、1条3元有效且ID唯一的任务，否则该轮不生成（当前已配置7条测试任务供随机）。一轮四个模板不重复，不同轮允许同一模板再次出现，实例ID追加@领取月份。模板名称建议15字以内。

用户确认活动任务已满3条时跳过本轮，等下一次计划月份；中间空位不会立即补发。完成/到期任务不再占活动位，也从活动面板隐藏，但进度和发奖状态留存历史。旧记录的“已完成继续显示”被此实现覆盖。

任务期限从领取月份计，第N个月末先判断完成再过期。只统计领取之后的结算。候选、领取任务的规则快照、进度、期限、发奖状态和最后发放月份均存档，读档不重抽，不因之后改模板而改变已领取规则。此前旧开发存档未保存领取列表的自动任务不再激活，新流程按下一次计划月份发放。

选择界面使用独立Task Choice组、独立Phone Background Image（PhonePanel），四条可点击选项均用原生Button变色。奖金仍用ShopPoint。可在WorkWork/Preview/Task Choice编辑模式预览，在Hierarchy的Task Choice下手调布局；Configure Task Choice仅首次创建不重置已有布局。

验证：72项EditMode测试通过，含4月首次、7/10月周期、1/2/2/3奖金配比、读档不重抽、选一个只领一次、满3条跳过及到16月恢复发放。控制台无错误。

2026-10-15：Task Panel新增独立Current Cash文字，位于Task 1上方，显示目前资金+ShopPoint+实际现金；Refresh和打开面板时更新，无任务也显示。在Hierarchy Task Panel/Current Cash可手调位置和字号，不受任务行隐藏影响。
