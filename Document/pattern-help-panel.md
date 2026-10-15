# 组合提示与牌型奖励面板（2026-10-15）

Game PSD Layers/组合提示 已添加原生 Button，开启图像射线，点击 GameShell.OpenPatternHelp。按钮使用原生 Color Tint，悬停 RGB 0.85、按下 0.7、过渡 0.08 秒。

Office Canvas/Pattern Help 是独立可编辑页面（默认隐藏），包含遮罩、纸面背景、标题、三列奖励表、规则说明和关闭按钮。列出 13 个奖励牌型及无牌型，从强到弱，分别显示基础分和倍率的额外奖励。背景复用 WindowContent.png，字体沿用统一 SDF。关闭按钮、点击空白处、Esc 都能关闭；切换设置、欢迎或新游戏也会关闭。

Scoring.Rewards 是只读共享奖励表，BestPattern 与面板都使用此表。基础倍率仍为 1，只取最强牌型，牌型奖励不叠加。打开面板时刷新奖励文字，不改手调布局，不影响分数、钱或游戏阶段。

GameShell.patternHelp 与三组文本引用均已配置。手调时可启用 Hierarchy 中 Pattern Help；重新配置当前场景可用 WorkWork/Apply Pattern Help Panel。完整美术生成也已同步。

验证：Core C# 编译与六张同花顺的基础分/倍率/总分检查通过；14 行三列文本引用、三个原生 Button 回调、场景父子引用检查通过。Unity Core/Runtime/Editor 程序集重新编译通过。本轮未执行完整 Unity Test Runner 或鼠标实机点击验证。

## 字号调整后的排版

已直接在 Unity 当前编辑场景中保留用户手调字号，重新计算行高与列宽。当前三列行文字字号均为 40，行高 58；列宽约为 313.27 / 288.01 / 288.01，列间留 28。奖励数值与表头居中对齐，牌型名字左对齐。纸面宽度按表头与牌型文字需求扩大并保持居中，关闭按钮居中。

较大字号下使用 Unity 原生 ScrollRect、RectMask2D、Scrollbar 显示超出的行；表头和关闭按钮固定，不会挤压文字。未添加运行时布局脚本。手调完字号后可以再执行 WorkWork/Layout Pattern Help（Ctrl+Shift+H），只重新排版并保存，不改字号。应用结果见 pattern-help-layout.txt。
