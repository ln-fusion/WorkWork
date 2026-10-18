# 新员工图像（2026-10-18）

后续更新：用户将19号图修改为市场经理，现已配置employee.32使用员工19-市场经理.png。全部33名员工均有对应图，无缺图或多余图；下文“市场经理缺图”“19号采购多余”为生成三张图片时的历史状态。

使用内置image_gen工具，以员工4-程序.png和员工2-美术设计.png为参考，每个岗位单独生成。原始输出保留在D:/Codex/generated_images/01a13a51-e672-74c3-ad06-c8bc95a37af3，最终PNG已复制入项目，保留生成的透明Alpha，不覆盖现有素材。

| 游戏ID | 图像 | 生成原件 |
| --- | --- | --- |
| employee.30 | Assets/Image/Staff/员工31-引擎开发.png | exec-73b31548-2ccc-4d79-87d6-0f8867cc4a47.png |
| employee.31 | Assets/Image/Staff/员工32-电竞经理.png | exec-4c5eab78-dbba-457c-83f0-41bb028920ea.png |
| employee.33 | Assets/Image/Staff/员工33-技术美术.png | exec-20b0ba05-64b5-4204-9325-aaddde44c355.png |

三张原始文件均1254×1254、透明PNG，沿用正方形宽高比与小人/桌面构图。原有员工图1000×1000；生成图未额外缩放，游戏显示大小仍由Image的RectTransform与preserveAspect控制。Single Sprite导入配置沿用现有员工，创建独立GUID。VisualTheme、配置源images和员工对应表已同步，未改员工名称、编号、效果或其他数值。市场经理仍缺专属图，保持原占位；多余员工19-采购.png仍保留。

## 提示词

公共要求：Use case: style-transfer. Use existing programmer and artist employee sprites as composition/style references. One cute Japanese office clipart chibi employee, large round head, tiny torso, simple dot/arc eyes, muted flat colors, slight paper texture, restrained outlines. Square transparent canvas, ample top margin about22%, employee seated left facing right on blue office chair, gray monitor right, white oval desk below, full desk/chair included; art approximately x4–98%, y24–81%. Readable at small game size. Genuine transparency, no scene background, caption, watermark, brand logo or stray pixels. Prompt requested1000×1000; tool returned1254×1254.

- 引擎开发：Young male engine developer, short dark slightly messy hair, small rectangular glasses, navy hoodie with muted teal accents. Keyboard, dark game-engine editor with blue wireframe cube, profiler performance graphs and abstract code lines, no readable text. No hard hat.
- 电竞经理：Young esports team manager, short auburn hair, black over-ear headset with small mic, navy sporty jacket with muted red accents. Friendly confident expression, small clipboard with strategy marks. Monitor with esports tournament bracket and simplified arena map, no readable text or logos; seated office worker, not warrior.
- 技术美术：Young technical artist, ash-lavender bob hair, round glasses, dark teal cardigan. Stylus and small pen tablet. Monitor with colorful shader-node graph, iridescent3D-sphere preview and wireframe mesh, no readable text. Friendly focused expression bridging artist/programmer.

已目视检查三张生成输出；文件角落Alpha均0，保持真实透明背景。配置引用静态验证，Unity画面尚未验收。
