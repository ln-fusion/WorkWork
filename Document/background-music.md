# 背景音乐（2026-10-15）

- 欢迎界面：Assets/Sound/Music/Before_the_Rush_Menu_Loop.ogg。
- 新游戏/继续游戏后：Assets/Sound/Music/DeadlineRush.ogg。商店、胜负结算延续，不重启。
- 返回欢迎时切回Before；设置暂停Time.timeScale不会暂停音乐。
- 两个AudioSource均Loop=true、PlayOnAwake=false、SpatialBlend=0，GameShell负责切换；停止另一首，避免叠播。

## Inspector调整

Hierarchy搜索 Menu Music - Before 或 Game Music - Deadline（位于GameShell对象下的Music节点）。在AudioChannel组件调整Base Volume（0～1）。

实际音量=Base Volume × 设置中的音乐音量 × 主音量（AudioListener）。两首基础音量独立，在编辑模式修改后保存场景可持久化；运行时调整会立即生效，但退出Play后Unity会恢复原场景值。

AudioSource的Clip可换曲，Loop保持勾选。不要用AudioSource.Volume保存基础音量，该值由AudioChannel结合设置音量计算。

编辑器菜单WorkWork/Configure Music只创建/更新音乐节点和引用，不重建UI；重复执行保留现有Base Volume。脚本：MusicSetup、GameShell、AudioChannel。

验证：音乐场景引用已保存，两源循环开启。进入Play实际读取Before音源：isPlaying=true、loop=true、time持续前进，控制台无错误；已退出Play。Deadline切换路径接在GameShell.BeginPlay，未进行人工听音验收。
