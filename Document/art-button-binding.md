# 主界面按钮图层绑定（2026-10-15）

Done 接收原 Score Week 的结算功能；Roll 接收原 Redraw 的重抽功能；Setting 接收原 Settings Button 的打开设置功能。

现有场景迁移 Button 组件并保留原组件引用、设置回调，三个图片开启 Raycast Target，关闭按钮颜色过渡以保留美术原色；已替换的旧透明按钮对象删除。主界面无需额外透明点击层。欢迎界面的设置按钮继续保留。

ArtUiBuilder 已同步调用 ArtButtonBinding.Bind，重新生成完整美术场景时也会绑定这三个图层。手动应用菜单：WorkWork/Bind Done Roll Setting Buttons。

已静态检查场景中三个 Button 的所属对象、Target Graphic、图像射线开关及原按钮停用状态。当前聊天的 Unity MCP 不可用，未进行本轮编辑器运行验证。

