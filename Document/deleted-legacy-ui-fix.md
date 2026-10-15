# 删除旧版商店标题后的空引用（2026-10-15）

报错 GameController.Render 第 190 行访问 shopTitle.text；当前场景 shopTitle 为 fileID 0，旧 Shop Heading 已删除。该文本在美术界面本来就已隐藏，不必恢复。

已将 shopTitle 与旧版基础 UI 文本 header/totals/preview/status/history 按可选引用处理；GameShell 的旧 header 同步保护，旧 officeBackground 也允许删除。ArtUiBuilder 当前场景修正时跳过已删除的旧 shopTitle。必要的手牌/工位/商店商品图片、按钮及 GameShell 数值引用仍需保留。

MCP WebSocket/Http 连接失败是编辑器工具服务未连接，与 shopTitle 的 NullReferenceException 无关，游戏本身不依赖 MCP 连接。
