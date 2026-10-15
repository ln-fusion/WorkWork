# 员工部署倾斜（2026-10-16）

拖起持有员工或商店员工商品时，DeploymentTilt旋转GameShell.board，默认Tilt Angles=(28,-6,-3)，Enter Duration=0.2秒，松手Return Duration=0.18秒平滑复位。道具/卡牌不触发。此为UI桌面部署视角模拟，未改变Canvas渲染模式或摄像头。

Drag Preview位于主Canvas，脱离board保持正向，空位提示属于工位按钮随桌面倾斜。只修改board.localRotation，不改位置、缩放或层级，兼容ResponsiveUiFrame。保存并恢复原始旋转而不是强制归零；重入从当前进度转入，不累积旋转。返回欢迎/新游戏/继续/组件停用立即还原；进入下一月也先复位。

GameController上的DeploymentTilt可调角度和进入/返回时长。通过DragToken开始/结束生命周期触发，源购买后停用也会结束。动画跟随Time.deltaTime暂停。

Play验证通过：员工和员工商品触发、道具卡牌排除、拖拽图保持正向、平滑还原、取消/禁用恢复原旋转，以及真实倾斜工位的UI射线仍可命中。报告deployment-tilt-verification.txt。控制台无错误，已退出Play；未改存档或编辑态布局。
