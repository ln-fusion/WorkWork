# 昨日的酒与唯一道具（2026-10-17）

新增道具：昨日的酒，编号Bang，配置ID为item.Bang，原价4，结算时+50基础分。固定收益在所属工位道具的正常结算顺序触发，本工位无牌也生效；沿用现有绿色加分飘字。

## 持有规则

Content新增unique布尔配置。员工始终唯一；普通道具默认false，可重复；unique=true的道具同款全场最多1件，可同时持有不同款唯一道具。它仍占员工的一个道具槽，仍要求员工存在，每员工3个槽。

商店候选与购买命令共用ContentRules.CanAcquire，以实际员工/道具槽的持有状态判定。持有昨日的酒时不再刷出；即使货架或客户端指令过时，核心Buy也拒绝第二件。售出即恢复候选资格。读档直接从已保存的道具槽恢复持有、音乐与动画，不另存一份开关，不影响普通道具重复购买。

## 音乐与动画

只要经营界面中持有item.Bang，GameShell选择Bang Music - Yesterday并停止另外两条音乐。商店、结算与任务界面均属于游戏中。售出后恢复Deadline，回欢迎界面播放Before；继续持有时重新进入游戏恢复Bang。普通Render不会重启正在播放的同一首歌。Bang循环播放并接入原主音量、音乐音量滑动条及AudioChannel.Base Volume。

用户提供的Assets/Sound/Music/Bang实际为MP3，已补扩展名为Bang.mp3并保留原meta的GUID。图片使用Assets/Image/Tools/Bang.png。

BangFeedback绑定所有工位员工、商店员工图片和员工拖拽预览；道具和卡牌不绑定。BangPortraitMotion通过UI图像网格做纵向压缩、回弹、轻微伸展和向上跳起，以图像底部为基准，所有员工共用当前音乐时间的拍子。无需改变RectTransform的位置、大小、锚点、父子层级或拖拽指针偏移；现有结算跳起、部署倾斜仍可叠加。停止持有或返回菜单时网格恢复原样，渲染时始终从原始网格重算，不累积变形。

## 调参入口

场景WorkWork MVP → Bang Feedback：

- Beats Per Minute：默认130；按音源低频起音周期粗估，不是实时自动识别拍点。
- Beat Offset：默认0.2秒，控制音乐起点与压扁瞬间的对齐；正数向后延迟。
- Compression：默认0.16，即压缩至原高84%。
- Stretch：默认0.04，跳起时轻微拉长。
- Jump Height：默认7，使用图像自身UI坐标。

音量：WorkWork MVP → Music → Bang Music - Yesterday → Audio Channel → Base Volume。GameShell.bangMusic是音源引用，可换正式音频。Editor菜单WorkWork/Configure Yesterday Wine可单独补齐此道具、图片、音乐和组件，不重建UI、不应用整表目标/资金默认值。完整导入与生成脚本也已同步为33员工、38道具、15任务、71张对应图片。

## 验证

新增5项测试：购买/唯一限制/刷新/售出回池/重买/读档、按实际持有判定且不限制普通道具、空卡槽固定50分、节拍重复、售出后网格恢复且布局不变。完整Unity EditMode 223项通过，失败0、跳过0（c4355e40a44b4cbcb44c451b8bf1d0f0）；默认节拍改为130后BangTests再跑5项通过（a9140833b18648dfa1c73c80550150be）。

场景逐对象比较：原有对象无删除，仅控制器增加组件/引用，GameShell增加音乐引用，Music增加Bang音源子对象；原有RectTransform与其他字段保持一致。运行截图：Temp/BangQA/bang-shop.png。验证后退出运行模式、解除暂停，控制台无错误或警告。

实际运行检查：核心购买后Bang独占播放，工位与商店员工绑定、道具不绑定；拖拽预览使用正确员工Sprite且绑定动画；回菜单恢复Before并停止跳动，继续经营恢复Bang，卖出恢复Deadline并停止跳动。测试使用内存会话与核心命令，未调用写存档的交易入口。配置保留当前Inspector目标1000、初始资金5及手调UI；未做独立构建。
