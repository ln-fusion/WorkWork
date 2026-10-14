# 分层美术界面接入

用户要求：按参考图接入Image目录现有游戏、商店、欢迎、胜负素材，Staff和Tools直接引用；补欢迎四按钮和设置三音量滑动条、返回欢迎。后续纠正：Canvas/页面容器不承载背景Image，背景独立成子Image以便自适应。

## 实现

- 用户后续指定统一字体：Assets/Fonts/LXGWMarkerGothic-Regular SDF.asset。统一场景（含隐藏界面）、卡牌Prefab、主题和TMP默认字体；生成器完成导入后再次绑定该字体与其默认材质，避免新文字回退到默认字体。

- 场景仍是 `Assets/WorkWork/Scenes/WorkWorkMvp.unity`。GameShell负责欢迎、设置和表现切换；GameController负责原有操作与规则。
- GameUI2、ShopUI、Welcome直接读取当前PSD导入的SpriteRenderer分层，按来源bounds还原UI坐标和层级；不把正式美术烘焙进业务代码。
- Win/Lose当前资源使用TextureImporter，Unity中只有单张Sprite，使用现成图片并在留白框上叠动态数值。没有改原PSD或强行更换其导入器。
- 主题配置中登记43张非废弃员工/道具资源，另有6个现有测试ID映射，共49条绑定。实际规则内容仍为MVP测试内容，没有凭美术文件名编造正式员工效果。
- 欢迎按钮：新游戏、继续游戏、设置、退出。进入场景先显示欢迎；无存档时继续不可用；不会因为启动欢迎就覆盖存档。
- 设置：主音量作用于AudioListener；音乐/音效由AudioChannel分类，音源自身基础音量另存；PlayerPrefs持久化。暂无新增音乐或音效文件，已有或后续音源添加AudioChannel并指定isMusic即可。
- 设置打开暂停，关闭恢复；返回欢迎关闭设置和游戏视图；ESC切换设置。Unity编辑器中退出按钮退出Play，构建后Application.Quit。
- 月末收入明细冻结lastIncome/lastInterest/lastStaffIncome，并随快照保存，供Win留白区显示。

## 背景与适配

- Canvas没有Image；Game Screen、Welcome Screen、Settings Overlay页面根不挂Image。
- 背景、设置纸张、遮罩移为独立 `Background Image` 子节点，stretch锚点跟随各自容器。
- ResponsiveUiFrame以1600×900设计坐标居中等比适配父RectTransform；16:9、4:3、超宽屏按较小比例缩放，不拉伸内容。
- PSD层的装饰Image关闭raycast；独立遮罩保留raycast拦截，交互层位于装饰之上。
- 生成入口 `WorkWork/Apply Layered Art UI`；只修背景用 `WorkWork/Separate UI Background Images`。重新生成全界面会覆盖场景布局；只换素材仍使用VisualTheme/Inspector，不需要重生成。

## 任务

用户明确先不实现，后续是如两次对子、两次炸弹等额外奖金任务。当前只保留不可点击的查看任务入口，不显示结算日志充当任务，不发任务奖金。

## 验证

- ArtUiVerification检查：独立背景、1920×1080/1280×720/1024×768/2560×1080比例，欢迎/继续/设置切换，三音量、分类增益、持久化，以及正式素材绑定，通过；检查恢复原偏好和原游戏状态。
- 游戏、欢迎、设置、商店、胜负视图已截图核对；修复手牌被背景遮挡、滑动条填充超出容器、失败数字及重新开始命中区域位置。
- 修改后继续运行WorkWork.Tests，结果记录在本轮工具输出；不得把此前截图生成过程中已经修复的错误视为最终运行状态。
- 原PSD未修改。Document/ArtPreview为只读提取合成图的QA文件，不是替代游戏资源。
- 更新原MVP素材替换检查：主题已有正式图后，测试应替换同ID条目，不能追加重复ID然后期望Find返回后一个条目。
- 修改后28项规则测试通过；背景、比例适配、欢迎/设置与音量检查通过。
- 最终MvpSmoke与ArtUiVerification均通过；实际点击放牌/拖回手牌、素材替换继续可用，运行控制台0条错误。日期数字、失败数值框、重新开始命中区域已修正。任务入口只作为后续占位。
