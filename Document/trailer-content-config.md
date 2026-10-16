# 宣传片专用员工与道具配置

更新：2026-10-16。仅用于 WorkWorkMvp 1 宣传片场景。所有效果、价格均为演示设计，不代表正式平衡或正式内容全集。

保留原场景界面、工位和交互；已撤销独立宣传片画布方案。Run 自动进入现有游戏界面。F1/F2/F3 切换三组阵容（会重置本次演示局）。最多同时展示6员工、18道具，其余均已加入本场景专用商店池。

资源位于 Assets/WorkWorkTrailer/Config；复用 Assets/Image 原图，不另制图。员工附魔遵守每牌最多4个的现有规则，先取得的来源优先，满额后其他来源可能不生效。标记废弃的三张图片仅在此处复用。文件名含义不明的道具保留原名。

预览存档：workwork-trailer-preview.json；正式场景仍使用 workwork-mvp.json。正式 GameController 仅增加可选存档文件名入口，未更改正式玩法。

| 类别 | 名称 | 图片 | 价格 | 演示效果 |
| --- | --- | --- | --- | --- |
| 员工 | 客服 | Assets/Image/Staff/员工1-客服.png | 4 | 所在工位计分：基础分 +12。 |
| 员工 | 美术设计 | Assets/Image/Staff/员工2-美术设计.png | 6 | 所在工位计分：倍率 +2。 |
| 员工 | 游戏测试QA | Assets/Image/Staff/员工3-游戏测试QA.png | 5 | 持有时，梅花牌获得重抽附魔；结算该牌时重抽次数 +1。 |
| 员工 | 程序 | Assets/Image/Staff/员工4-程序.png | 6 | 持有时，所有6点牌获得复制附魔；结算后复制到本月牌库。 |
| 员工 | 特效师 | Assets/Image/Staff/员工5-特效师.png | 6 | 持有时，所有6点牌获得双倍点数附魔，不改变牌型。 |
| 员工 | 音乐音效 | Assets/Image/Staff/员工6-音乐音效.png | 7 | 持有时，梅花6获得双倍额外倍率附魔；需搭配粉丝等倍率附魔。 |
| 员工 | 游戏运营 | Assets/Image/Staff/员工7-游戏运营.png | 7 | 持有时，梅花牌获得粉丝附魔：额外倍率增加牌面点数。 |
| 员工 | 文案策划 | Assets/Image/Staff/员工8-文案策划.png | 6 | 持有时，梅花6获得同花加分附魔：额外增加场上梅花点数总和。 |
| 员工 | 法务 | Assets/Image/Staff/员工9-法务.png | 5 | 牌型判定前，将所在工位卡牌改为黑桃。 |
| 员工 | 行政管理 | Assets/Image/Staff/员工10-行政管理.png | 5 | 每周结束：基础分 +30。 |
| 员工 | HR | Assets/Image/Staff/员工11-HR.png | 5 | 所在工位卡牌计分：重抽次数 +1。 |
| 员工 | 商务 | Assets/Image/Staff/员工12-商务.png | 9 | 所在工位卡牌计分：累计倍率 ×2。 |
| 员工 | 活动策划 | Assets/Image/Staff/员工13-活动策划.png | 6 | 每周结束：基础分 +18；所在工位计分：倍率 +1。 |
| 员工 | 采购 | Assets/Image/Staff/员工14-采购.png | 5 | 所在工位计分：基础分 +10，倍率 +1。 |
| 员工 | 财务 | Assets/Image/Staff/员工15-财务.png | 6 | 持有时，所有6点牌获得金币附魔：结算基础分 +20。 |
| 员工 | PM | Assets/Image/Staff/员工30-PM.png | 6 | 所在工位卡牌计分：基础分 +8，重抽次数 +1。 |
| 道具 | 三人组 | Assets/Image/Tools/3men.png | 6 | 所在工位计分：倍率 +3。 |
| 道具 | Angle | Assets/Image/Tools/Angle.png | 6 | 持有时，红桃牌获得双倍点数附魔。 |
| 道具 | 盆栽 | Assets/Image/Tools/BenZai.png | 4 | 每周结束：基础分 +12。 |
| 道具 | 饼 | Assets/Image/Tools/Bing.png | 4 | 所在工位计分：基础分 +16。 |
| 道具 | C4 | Assets/Image/Tools/C4.png | 7 | 所在工位计分：基础分 +40。 |
| 道具 | 糖果 | Assets/Image/Tools/Candy.png | 4 | 所在工位计分：倍率 +1。 |
| 道具 | 时钟 | Assets/Image/Tools/Clock.png | 5 | 所在工位卡牌计分：重抽次数 +1。 |
| 道具 | 鸡尾酒 | Assets/Image/Tools/CockTail.png | 5 | 牌型判定前，将所在工位卡牌改为红桃。 |
| 道具 | FangDan | Assets/Image/Tools/FangDan.png | 5 | 所在工位计分：基础分 +15，倍率 +1。 |
| 道具 | FangSi | Assets/Image/Tools/FangSi.png | 5 | 所在工位计分：倍率 +2。 |
| 道具 | Farmer | Assets/Image/Tools/Farmer.png | 5 | 每周结束：基础分 +20。 |
| 道具 | FatDragon | Assets/Image/Tools/FatDragon（废弃）.png | 5 | 所在工位计分：基础分 +25。（复用标记废弃的图片，仅宣传片） |
| 道具 | Fbqb | Assets/Image/Tools/Fbqb（废弃）.png | 5 | 所在工位计分：倍率 +2。（复用标记废弃的图片，仅宣传片） |
| 道具 | Fusion | Assets/Image/Tools/Fusion.png | 8 | 所在工位计分：累计倍率 ×2。 |
| 道具 | Gun | Assets/Image/Tools/Gun.png | 5 | 所在工位计分：基础分 +24。 |
| 道具 | 帽子 | Assets/Image/Tools/Hat.png | 5 | 牌型判定前，将所在工位卡牌改为梅花。 |
| 道具 | 火锅 | Assets/Image/Tools/HotPot.png | 4 | 所在工位计分：基础分 +10。 |
| 道具 | 木头 | Assets/Image/Tools/Log.png | 4 | 每周结束：基础分 +15。 |
| 道具 | 奶龙 | Assets/Image/Tools/NaiLong.png | 6 | 所在工位计分：基础分 +30。 |
| 道具 | 土豆 | Assets/Image/Tools/Potato.png | 4 | 所在工位计分：基础分 +8，倍率 +1。 |
| 道具 | Prince | Assets/Image/Tools/Prince.png | 6 | 所在工位计分：倍率 +3。 |
| 道具 | RIPot | Assets/Image/Tools/RIPot.png | 6 | 持有时，方块牌获得金币附魔。 |
| 道具 | Rail | Assets/Image/Tools/Rail.png | 6 | 牌型判定前，将所在工位卡牌点数设为6。 |
| 道具 | 垃圾桶 | Assets/Image/Tools/Rubbish.png | 5 | 所在工位卡牌计分：重抽次数 +1。 |
| 道具 | 喷雾 | Assets/Image/Tools/Spray.png | 5 | 牌型判定前，将所在工位卡牌改为方块。 |
| 道具 | Steam | Assets/Image/Tools/Steam.png | 7 | 持有时，黑桃牌获得粉丝附魔。 |
| 道具 | TNT | Assets/Image/Tools/TNT.png | 8 | 所在工位计分：累计倍率 ×2。 |
| 道具 | 番茄 | Assets/Image/Tools/Tomato.png | 6 | 持有时，红桃牌获得金币附魔。 |
| 道具 | WSQ | Assets/Image/Tools/WSQ（废弃）.png | 5 | 所在工位卡牌计分：重抽次数 +1。（复用标记废弃的图片，仅宣传片） |
| 道具 | Zhan | Assets/Image/Tools/Zhan.png | 5 | 所在工位计分：基础分 +18，倍率 +1。 |
