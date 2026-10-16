# 开发记录入口

更新：2026-10-16（北京时间）。单机MVP已接入美术、音乐、附魔、周期任务选择及基础动画。最新归档与清理见[archive-review-2026-10-16.md](archive-review-2026-10-16.md)，当前范围见[mvp-status.md](mvp-status.md)，接口和参数入口见[presentation-interfaces.md](presentation-interfaces.md)。midterm-review.md保留10月15日历史检查。

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

## 文件导航

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
