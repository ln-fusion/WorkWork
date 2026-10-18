# 开发记录入口

2026-10-18：检查0点牌生成，游戏运营两次结算为6→12张0牌，反复预览、读档不重复；校对/月初、闹钟与奶蛙逐次生成、跨月重置均核对通过。未复现重复触发，未改规则，见 [zero-card-audit.md](zero-card-audit.md)。

2026-10-18：修复商店入场后刷新按钮未解锁；按钮状态逐帧同步，动画结束无需先购买即可刷新，仍受资金/次数限制。运行验证见 [shop-refresh-button-fix.md](shop-refresh-button-fix.md)。

2026-10-18：13条SFX音效接入；卡牌计分按1～6递增并封顶6，每次周结算重置，交易/卡牌操作/胜负/通用按钮按事件播放，统一走音效音量。232项测试通过，见 [sound-effects.md](sound-effects.md)。

2026-10-18：用户已将19号素材改为市场经理，现配置employee.32使用员工19-市场经理.png。全部33名员工均有对应图，无缺图、无多余员工图；主题、配置源和对应表同步更新。

2026-10-18：按现有员工画风生成引擎开发、电竞经理、技术美术三张透明PNG并配置，现仅市场经理保留占位。文件位置与内置imagegen提示词见 [staff-generated-art.md](staff-generated-art.md)。

2026-10-18：员工图像按当前Staff素材重新配置，29名对应正式图，4名（引擎开发、电竞经理、市场经理、技术美术）缺专属图并保留原占位；多余员工19-采购.png。主题与配置源图片路径同步，未更改规则或数值，见 [employee-art-mapping.md](employee-art-mapping.md)。

2026-10-17：商店刷新起价改为1元，之后依次2/3/4/5元，每店仍最多5次，重新进店重置。开局商店与月末商店共用规则；项目经理首次免费仍消耗刷新次数，之后为2元。完整Unity EditMode回归226项通过，见 [opening-shop.md](opening-shop.md)。

2026-10-17：新增开发者按钮与商店区域面板，左员工/右道具名称滚动列表，免费拖入、拖回删除，0资金可用；225项规则测试通过。隐藏入口对象Developer Toggle即可，见 [developer-panel.md](developer-panel.md)。

2026-10-17：新增唯一道具“昨日的酒”（Bang，4费，+50基础分），持有时循环Bang音乐，工位/商店/拖拽的员工图像同步压缩跳动。唯一标记仅限制指定道具；223项规则回归通过，配置入口与验证见 [yesterday-wine.md](yesterday-wine.md)。

2026-10-17：新游戏第一批商店员工保底原价不超过5（包含5费），3名不重复；首次刷新及之后商店恢复全池，道具不受限。见 [opening-shop.md](opening-shop.md)。

2026-10-17：条件联动高亮已接入；匹配的牌、员工、道具或空位短暂亮起后显示收益，按每步实际场面记录。214项规则测试通过，见 [condition-feedback.md](condition-feedback.md)。

2026-10-17：删牌刀光、上下两半分离消散已接入员工与道具；小夜灯先重结算再斩断，删牌不再参加末尾收牌。204项规则回归通过，见 [card-deletion-motion.md](card-deletion-motion.md)。

2026-10-17：生成新牌已复用复制上送动画，覆盖员工、道具及月初补牌，多张并行，月初先上送补牌再发手牌；198项规则测试通过。见 [generated-card-motion.md](generated-card-motion.md)。

2026-10-17：改花色与改点数动画已接入，统一缩小淡出、放大至115%再回弹，并在附魔更替之前播放。参数在WorkWork MVP/Card Face Feedback；188项规则回归通过，见 [card-face-motion.md](card-face-motion.md)。

2026-10-17：附魔出现、消失与图标补位已接入结算和员工交易，参数在WorkWork MVP/Enchantment Feedback，见 [enchantment-motion.md](enchantment-motion.md)。完整规则回归现为181项通过。

2026-10-17：新游戏改为先进入一次开局商店，购物后开始第1月第1周；保留初始资金与目标，旧存档不强制插入商店。175项规则回归通过，见 [opening-shop.md](opening-shop.md)。

更新：2026-10-16（北京时间）。单机MVP已接入美术、音乐、附魔、周期任务选择及基础动画。最新归档与清理见[archive-review-2026-10-16.md](archive-review-2026-10-16.md)，当前范围见[mvp-status.md](mvp-status.md)，接口和参数入口见[presentation-interfaces.md](presentation-interfaces.md)。midterm-review.md保留10月15日历史检查。

正式内容最新接入：[final-content-integration.md](final-content-integration.md)。33员工、37道具、15任务及首月600曲线已配置；图片70项齐全，134项规则测试通过。此记录覆盖此前“仅文档、尚未实现”的阶段状态。

最新员工第二版已接入：[employee-effects-v2.md](employee-effects-v2.md)，实现与验证见 [employee-revision-integration.md](employee-revision-integration.md)。完整33名按用户修改后的表配置，167项规则回归通过；生成脚本已切换第二版。此次仅应用员工内容，保留当前Inspector初始目标400、两副牌组、道具、任务、美术和手调UI。

## 项目约束

- 宣传片专用场景及初版剧本见 [trailer-scene-outline.md](trailer-scene-outline.md)。其中镜头、字幕、剧情和演示安排仅用于宣传片，与正式功能无关，不得据此修改正式规则、认定功能已实现或新增正式待办。

- 2026-10-16最新规则：道具可重复获得和装备，员工仍保持唯一；每员工仍为3个道具槽。覆盖旧记录中道具唯一性的描述，见repeatable-items.md。

- 2026-10-15 用户明确取消月度 Buff、逐周场地揭示：完全不做，不列入待办或后续开发范围。此确认覆盖原策划及旧记录中的相关内容。
- 2026-10-15 用户明确忽略牌型升级、投资兑付：均不做，不列入待办，也不再作为待确认需求；此决定覆盖策划正文及旧记录中的相关内容。

- Unity 2022.3.62f3，用户提供自己的美术素材。
- 以 Cats 的玩法与结算为参考，把骰子系统换成卡牌系统，主题换成员工经营。
- 最终支持局域网联机，本地房主当服务器。多人经营关系尚未定义，不自行假设为合作或对战。
- 用户授权在 Document 里持续记录，记录以便后续开发接续为目的，无需美化或每项向用户确认。
- 用户已明确：全部采用策划案规则。Cats仅用于研究实现思路和触发组织，不用于覆盖策划案或补充未经确认的旧版机制。
- 用户确认超额奖励：达到目标150%给1块，达到200%给2块，封顶2块；成功但不足150%给0块超额奖励。此奖励在固定收入4块之外计算。
- 用户确认MVP规则：牌型只取最强一种；基础倍率1（按用户最新更正）；每月重抽4次；牌库耗尽时将弃牌堆洗回牌库，手牌和工位中的牌不参与；玩家无需查看牌库或弃牌堆。
- Unity实现必须方便后续替换正式美术资源，具体约束见 `unity-resource-guidelines.md`。
- 推测、建议、实现默认值必须与已确认规则区分。
- 2026-10-16最新附魔确认已接入：每张牌最多4种不同附魔，同一种不能重复获得，重复赋予不多占槽或叠加效果；多个来源合并生效但保留来源关系。明确的额外结算仍可再次触发附魔。覆盖旧文档中允许重复附魔的记述，见[employee-design.md](employee-design.md)。

## 文件导航

- [enchantment-motion.md](enchantment-motion.md)：附魔逐步显示、来源飞入、失去消散、同批补位、Inspector参数与取消清理。

- [opening-shop.md](opening-shop.md)：开局购物、首次离店月份、补牌/装备/优惠归属与存档兼容。

- `ui-art-integration.md`：用户分层资源接入、欢迎/设置、背景自适应和任务入口的后续实现记录。

- `mvp-status.md`：当前MVP范围、运行入口、测试及临时规则。
- `resource-replacement.md`：正式美术替换入口与约定。
- `presentation-interfaces.md`：新功能总表、组件位置、事件接口、输入锁及联机接入边界。
- `stepwise-scoring.md`：顺序计分、来源事件、倍率先后、飘字与累计分数滚动。
- `card-motion.md`：抽牌/收牌/重抽/复制上送；`action-feedback.md`：落位回弹、扣款与失败提示、任务手机震动、牌型强调。
- `month-result-reveal.md`：奖金金额及依次揭示；`failure-reveal.md`、`victory-reveal.md`：胜负入场及持续喷花与对象池。
- `shop-reveal.md`：商店伸出/缩回；`phone-pickup.md`：任务与任务选择手机拾起。
- `drop-hints.md`：员工/道具空位闪烁；`deployment-tilt.md`：员工部署视角倾斜。
- `loading-transition.md`：正反镂空PNG翻转、加载就绪接口与游戏界面切换时机。
- `deck-copies.md`：两副24张基础牌及Inspector配置入口。
- `repeatable-items.md`：重复道具购买、持有、出售、独立效果及旧存档兼容。
- [item-design.md](item-design.md)：已配置的37件道具完整设计表、结算边界和首轮测试数值。
- [item-design-review.md](item-design-review.md)：道具平衡评审及本轮确认结果，保留后续测试方向。
- [target-curve.md](target-curve.md)：已采用首月600及分段增长，累计乘积向上取整到10；原800起点表不再适用。
- [employee-design.md](employee-design.md)：多效果与跨流派员工、大卡组/小卡组/中间型的方向与附魔规则；最新接入状态见正式内容记录。
- [employee-effects-draft.md](employee-effects-draft.md)：第一版33个普通岗位与组合说明，作为历史记录保留。
- [employee-effects-v2.md](employee-effects-v2.md)：当前已接入的完整33名员工，含价格、逐项附魔说明、结算边界与跨流派组合。
- [employee-revision-integration.md](employee-revision-integration.md)：第二版规则、员工专用导入入口、旧存档兼容与验证。
- [employee-art-mapping.md](employee-art-mapping.md)：已配置的员工图片对应表，16张对应图、17名缺图岗位复用占位。
- [task-design.md](task-design.md)：用户提供的15条正式任务原文；计数口径、配置简称与期限说明见正式内容接入记录。
- `unity-mcp.md`：安装版本、连接服务和恢复步骤。

- `rules-comparison.md`：原版与策划案对照，歧义和实现风险。
- `cats-research.md`：反编译结果、关键脚本路径、实际结算链。
- `ReferenceExtract/design-text.txt`：策划案正文提取。
- `ReferenceExtract/Workbook1.xlsx.txt`：目标曲线逐单元格记录。
- `ReferenceExtract/Workbook2.xlsx.txt`：牌型表逐单元格记录。
- `ReferenceExtract/CatsCode/CodeEntries/`：277份反编译 GML，仅用于研究，不放入 Unity Assets。
- `extract-reference.ps1`：可重复执行的正文、内嵌表和包结构提取脚本。

## 下一步

1. 确定第一批正式员工、道具和特殊技能，逐项接入并平衡数值。
2. 确定多人经营模式、玩家人数、共享资源和操作权限，再实现房主服务器与客户端。
3. 用户提出的基础动画已完成；实际音效按用户安排后做，正式新技能按需补对应事件反馈。
4. 独立打包、多分辨率、连续多月的完整手工验收。
5. 月度Buff、逐周场地揭示、牌型升级、投资兑付均不做。
## 已完成

- 确认 Cats 包为 GameMaker Studio 2 VM，不是 Unity，不是 YYC。
- 官方 UndertaleModTool CLI 0.9.2.0 已下载并成功运行。
- 导出全部顶层代码，提取正文和两份内嵌工作簿。
- 阅读组合判断、回合控制、计分按钮、工位、收益、初始配置等关键路径。
- 原始 data.win SHA256 为 AB2F11A0DD37601B04885BD183151210010396F6D739721A29C6391B0924B0ED，研究只读原包。

## 联机方案确认（2026-10-15）

用户比较房间号/互联网中继后，最终选择局域网联机。房主电脑兼任服务器；其他玩家在同一局域网加入。不接Unity Relay、互联网房间码服务，不需要云中继费用。房间发现或局域网IP直连入口尚未实现。

多人玩法（合作经营或各自经营）、玩家人数、共享资源与权限尚未确认，实施游戏同步前需明确。房主退出是否结束房间仍作为首版建议，未当作用户已确认规则。

- 局域网开发计划与目标表现（讨论稿）：lan-development-plan.md。下一步先对齐多人玩法，具体联机规则尚未确认。

2026-10-15最新确认：基础牌库改为两副24张，共48张；GameCatalog/Rules/Deck Copies可配置，覆盖旧记录的一副24张。手牌仍6张，旧存档下个月生效，详见deck-copies.md。
