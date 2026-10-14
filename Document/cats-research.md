# Cats 原包研究

## 工具与证据

源：`Reference/cat/data.win`。官方工具：https://github.com/UnderminersTeam/UndertaleModTool/releases/tag/0.9.2.0

CLI info 结果：Project Name Cats_and_Dice_demo；Is GMS2 True；Is YYC False；bytecode 17；326 Code Entries；94 Scripts；72对象；2房间。

实际执行：

```powershell
& ./Document/extract-reference.ps1
& ./Document/Tools/UTMT_CLI/UndertaleModCli.exe info ./Reference/cat/data.win
& ./Document/Tools/UTMT_CLI/UndertaleModCli.exe dump ./Reference/cat/data.win -o ./Document/ReferenceExtract/CatsCode -c UMT_DUMP_ALL
```

输出277份 GML。326是字节码条目数，含嵌套函数；导出器将函数合并入顶层文件，不应把数量差解释成49次失败。输出目录检索未发现 Exception/Error/failed 标记。部分枚举还原为 UnknownEnum.Value_N，数值可追踪，原符号不可据此补造。尚未运行游戏对照动画，也未验证每项反编译语义。

下载工具含完整运行时，存于 Tools 并由 Document/.gitignore 排除，避免大量第三方二进制进入提交。

## 原版初始值

证据 `gml_Object_global_Level_Create_0.gml`：初始现金5，计分次数3，重掷次数4，Stage_progress=1，商店初始刷新费用1；Start_points 和 Start_mult 都为0，不可臆造基础倍率为1。

`gml_Object_obj_Ctrl_Cat_Create_0.gml` 的新局初始化设置骰型奖励：Pair 20/2；Triple 30/4；4Kind 40/7；5Kind 50/10；6Kind 60/14；Distinct 60/12。其余骰型是否初始启用应按 List_bonus 完整创建分支核对，不能只因 combo_check 支持就视为默认启用。

## 原版组合判定

证据 `gml_GlobalScript_scr_Dice_combo_check.gml`：

- 仅收集 Dice_tray==-1 的已放置骰子。
- 起始 Chips=Chips_next+Start_points，Mult=Mult_next+Start_mult。
- Distinct 要6个不同值；顺子代码忽略重复值后检查连续长度至少4。
- Blackjack 点数合计21时最终分翻倍，超过21时减半（Track_21 在最终分阶段读取）。
- Lowroll 检查所有值<=3；Highroll 检查所有值>=4。
- 同点组按组大小判断，优先启用的较高同点奖励，否则回退较低奖励；不同同点组可以各获奖励。
- 不同类别独立判断并累加，并非从全场牌型表只挑一个最强组合。
- arg0==1 的分支用于后续效果检查，需要另行核验，不能当作初始牌型重算直接照搬。

## 结算控制路径

主入口 `gml_Object_obj_Ctrl_Cat_Step_0.gml`。

1. Start_setup 调用 scr_Stage_score；特殊 Boss 回合进入恩祸等待。
2. Start_roll 初次由各工位/猫创建骰子；后续将已计分工位的骰子重新投回托盘。托盘中的未用骰子未在该分支统一重新生成。
3. Start_wait 等滚动结束，进入 Play，并保存 meta/run/cat/dice。
4. 按计分按钮：先要求至少放置一个骰子；Round_score--，Attempt_score++；调用 scr_Cat_score_check，再启动工位结算。
5. Score_order 从0遍历到5。工位先 Cat_check 被动阶段，再 Dice_check 骰子计分。骰子本身先累加点数，再处理自身附加效果，再逐猫检查得分被动；重复计分/重复猫触发通过 Dice_repeat、Dice_Catagain 分支返回处理。
6. 所有工位结束，Score_current=floor(Chips*Mult)。随后应用21点、首次和最后一次计分的全局倍乘，并逐次 floor，再加到 Score_total。
7. 每次计分后检查 Score_total>=Score_needed，立即胜利；否则有剩余计分则继续，无次数则失败。
8. Round_won 调用 scr_Cat_endround_check；收益窗口点击收款后进 Shop_wait，清空本回合总分。

上述是主链核对，不是全部效果的完整执行规格。猫咪分支、倍乘和重复触发仍需逐项映射。

## 收益实际调用路径

`gml_Object_obj_Display_Scoreboard_Create_0.gml` 冻结利息：现金 div 10，基础利息封顶10。

`gml_Object_obj_Display_Scoreboard_Step_0.gml` 支付：Stage_earnings+Extra_earnings+剩余Round_score+Interest_earned。

Stage_earnings：起始为4，普通后续为5，Boss为6（scr_Stage_score）。原版奖励剩余计分次数，不是把超额分数换现金。

注意另有 scr_Stage_earnings 脚本没有利息封顶；实际收益窗口路径有封顶。不能只读同名脚本就推断实际游戏收益。

## 原版目标

scr_Stage_score：progress0为300，但新局progress1，因此正常新局初始目标为500；之后800、1400、2400、3800、6200……。不能把case0的300写成正常首关目标。该包是demo，只代表提供的版本。
