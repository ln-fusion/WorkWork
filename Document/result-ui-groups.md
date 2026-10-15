# 胜败结算界面拆组与废弃代码检查（2026-10-15）

Month Result 只作为布局容器，移除其 Image/CanvasRenderer，避免无 Sprite 的白块遮挡。下分两个可编辑组：

- Win Group：独立 Background Image（Win.psd）、五项结算数值、Enter Shop。
- Lose Group：独立 Background Image（Lose.psd）、目标/实际分数、Restart。

不再运行时切换同一个背景 Sprite，也不逐项开关两套文本；GameShell.Refresh 只切换整个组并填写数值，不改位置、大小或 Sprite。已有数值控件、按钮和外层 Month Result 的 RectTransform 保留手调位置。

手调：在 Hierarchy 展开 Month Result，开启 Win Group 或 Lose Group 即可；也可使用 WorkWork/Preview/Win Result 和 WorkWork/Preview/Lose Result 菜单。正常游戏会按阶段自动切换。两个组的独立背景、文本和按钮都可分别调整。

生成器同步：ArtUiBuilder 调用 ResultUiBuilder.Bind。只转换现有结果界面可用 WorkWork/Split Win Lose Result Groups，不会重建整个游戏界面；已拆组后再次执行不重置布局。

清理与审查：移除 GameShell 中废弃的 resultArt/winArt/loseArt 字段与背景切换逻辑；移除美术场景中的旧 Result Text，GameController 保留空值保护，因为基础 MvpBuilder 仍使用文本结算回退。checkpoint 缓存字段原本只写不读，改成保存函数的局部变量，并删除读档时的无用序列化。旧 Score Week/Redraw/Settings Button 对象场景中已不存在，按钮绑定生成器也改为删除被替换的旧对象。生成工具、验证工具和基础 MVP 回退有明确用途，继续保留。

静态验证：胜利组 7 个直属控件、失败组 4 个直属控件；背景排最前；所有 RectTransform 父引用存在；旧共享图片字段与旧结算文本引用已移除。Unity 已重新编译 Runtime/Editor 程序集并重新加载迁移后的场景。提供 WorkWork/Verify Win Lose Result Groups 菜单，可检查独立背景、父子关系及胜利/失败/商店阶段切换，检查后恢复原编辑文本与显隐。本轮已确认编译与场景引用检查通过，未通过 MCP 运行游戏验证。

