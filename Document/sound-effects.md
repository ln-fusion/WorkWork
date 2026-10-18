# 音效接入（2026-10-18）

Assets/Sound/SFX的13条音频均已配置到WorkWork MVP → Sound Feedback。音源位于同对象的Audio Source，音量在Audio Channel → Base Volume调整（isMusic=false）；接入主音量与音效音量，BGM仍走独立音乐通道，允许短音效重叠。

| 音频 | 触发 |
| --- | --- |
| 1～6.mp3 | 每次周结算从1开始，逐张牌计分时递增，第7次及以后固定6；小夜灯重结算和同花加分额外结算计入，复制/重抽的独立步骤不计入 |
| 卡牌选中.MP3 | 拖起手牌/场上牌，或点击手牌自动放置前 |
| 卡牌放置.mp3 | 放置、换位或收回卡牌成功时 |
| 卡牌发放.mp3 | 发牌动画中逐张起飞时，按stagger错开；收牌/复制上送不播放 |
| 购入&售出.mp3 | 正常商店购买/出售成功；失败与开发者免费添加/删除不播放 |
| 胜利.mp3 / 失败.mp3 | 游戏界面显示月结算/失败阶段时一次；同阶段多次Render不重复，欢迎界面背后的刷新不播放 |
| 通用功能按钮.mp3 | 非卡牌/员工/商品条目的其他Unity Button.onClick，包括设置、任务、重抽、结算、刷新、继续等；只响应实际点击，代码Render不触发 |

核心ScoreStep.cardSettlement只标记真正的牌计分事件；不依赖显示名称/翻译识别。SoundFeedback.BeginSettlement/Score管理本次计数，ScoreIndex将序号映射到0～5。Play使用PlayOneShot。编辑器菜单WorkWork/Configure Sound Effects可重新绑定素材，完整构建器也已接入。避免运行整套UI重建菜单以覆盖手调布局。

运行检查：第7次计分ScoredCount=7、索引5（音效6），AudioSource.isPlaying=true，6条计分音频全部Loaded；音效音量倍率0.25时实际volume=0.25，之后恢复原设置。控制台无错误/警告，检查结束退出运行并解除暂停。尚未做独立构建或逐条人工听感评估。

Unity EditMode全部232项通过，失败0、跳过0（25f1a49b4c6348aa99b6562eb664edc1）。新增6项覆盖1/6/7/40序号、复制与重抽步骤不推进序列、每次结算清零、小夜灯额外结算推进序号。全部13个AudioClip引用已在编辑器读取确认。配置前将用户当前未保存的场景完整备份到Temp/SfxQA/scene-memory-before-sfx.unity，再保留内存中的手调内容添加组件并保存；磁盘原件另存scene-before-sfx.unity。不修改规则数值或用户存档。
