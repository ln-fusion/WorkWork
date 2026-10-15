# 菜单进入游戏翻面过场（2026-10-16）

素材Assets/Image/Loading/1.png与2.png是保留透明区域的正反面镂空遮罩，原PNG不修改，导入Single Sprite并显式使用原图Alpha。主Canvas下独立Loading Transition组，只有全屏透明Input Blocker和翻转PNG；不叠加黑底，镂空处透出下方页面。图像通过AspectRatioFitter.EnvelopeParent等比覆盖画布，避免屏幕边缘露缝；不移动现有菜单或游戏布局。

NewGame/ContinueGame共用EnterGame：遮罩淡入→后台PrepareEntry→正面停留并等待加载完成→先切换到游戏界面→绕Y轴0到90度→切背面并从-90转回0（背面不镜像）→背面停留→淡出→完成后Render解锁，新游戏才开始初次发牌。整个翻转期间镂空下方都是已准备好的游戏界面。继续不重新发牌。没有存档时保留原来的提示，不播放过场。

LoadingTransition.Play(Func<IEnumerator> load, Action completed, Action<Exception> failed, Action reveal)是后续加载接口；load支持嵌套IEnumerator，真实就绪前停留正面，异常交给failed并清理遮罩，不用固定延时冒充完成。reveal在加载就绪后、开始翻转前切换页面，completed在淡出完成后执行。取消/停用停止所有工作协程并重置图像、旋转及射线拦截。

Inspector默认：Fade In Duration=0.18、Front Hold=0.15、Flip Duration=0.7、Back Hold=0.15、Fade Out Duration=0.22，正常约1.4秒。按PNG相同比例显示，宽高响应屏幕，过场使用unscaledDeltaTime。镂空修正后已查看正反面运行截图，确认下方页面透出；归档清理时删除临时截图及其捕获菜单，将透明输入层和等比覆盖的结构断言并入Verify Loading Transition。MCP进入Play时短暂断连后恢复。

IsEntering计入IsBusy，重复开始会被拦截，遮罩阻止鼠标、设置/返回欢迎不能跳过；每次播放置顶。存档若在月末结算，数字揭示等过场结束后的Render再启动；商店/失败入场等待IsEntering结束，避免被黑屏吞掉动画。

验证：Play隔离克隆过场，正反面翻转、真实就绪等待、重复调用与输入锁、reveal/完成顺序、加载失败与取消清理通过。报告loading-transition-verification.txt。当前控制台无错误，已退出Play；验证未写入存档。代码中发现的局部变量重名编译错误已修复。
