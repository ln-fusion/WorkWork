using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using WorkWork.Core;
using WorkWork.Trailer;

namespace WorkWork.TrailerEditor
{
    public static class TrailerContentSetup
    {
        const string Root="Assets/WorkWorkTrailer";
        static Effect Chips(int amount,Trigger trigger=Trigger.CardScored)=>new Effect{kind=EffectKind.AddChips,trigger=trigger,amount=amount};
        static Effect Mult(int amount)=>new Effect{kind=EffectKind.AddMultiplier,trigger=Trigger.CardScored,amount=amount};
        static Effect Double()=>new Effect{kind=EffectKind.MultiplyMultiplier,trigger=Trigger.CardScored,amount=2};
        static Effect Retry()=>new Effect{kind=EffectKind.ExtraRedraw,trigger=Trigger.CardScored,amount=1};
        static Effect Enchant(Enchantment type,int rank=-1,int suit=-1)=>new Effect{kind=EffectKind.AddEnchantment,trigger=Trigger.WhileOwned,enchantment=type,rankFilter=rank,suitFilter=suit,local=false,amount=1};
        static Effect SuitTo(int suit)=>new Effect{kind=EffectKind.SetSuit,trigger=Trigger.BeforePattern,amount=suit};
        static Effect RankTo(int rank)=>new Effect{kind=EffectKind.SetRank,trigger=Trigger.BeforePattern,amount=rank};
        sealed class Design
        {
            public string label,description;public int price;public Effect[] effects;
            public Design(string label,string description,int price,params Effect[] effects)
            {this.label=label;this.description=description;this.price=price;this.effects=effects;}
        }
        static readonly Design[] Employees={
            new Design("客服","所在工位计分：基础分 +12。",4,Chips(12)),
            new Design("美术设计","所在工位计分：倍率 +2。",6,Mult(2)),
            new Design("游戏测试QA","持有时，梅花牌获得重抽附魔；结算该牌时重抽次数 +1。",5,Enchant(Enchantment.Retry,-1,2)),
            new Design("程序","持有时，所有6点牌获得复制附魔；结算后复制到本月牌库。",6,Enchant(Enchantment.Copy,6)),
            new Design("特效师","持有时，所有6点牌获得双倍点数附魔，不改变牌型。",6,Enchant(Enchantment.Arrow,6)),
            new Design("音乐音效","持有时，梅花6获得双倍额外倍率附魔；需搭配粉丝等倍率附魔。",7,Enchant(Enchantment.X2,6,2)),
            new Design("游戏运营","持有时，梅花牌获得粉丝附魔：额外倍率增加牌面点数。",7,Enchant(Enchantment.Fans,-1,2)),
            new Design("文案策划","持有时，梅花6获得同花加分附魔：额外增加场上梅花点数总和。",6,Enchant(Enchantment.Wild,6,2)),
            new Design("法务","牌型判定前，将所在工位卡牌改为黑桃。",5,SuitTo(0)),
            new Design("行政管理","每周结束：基础分 +30。",5,Chips(30,Trigger.WeekEnd)),
            new Design("HR","所在工位卡牌计分：重抽次数 +1。",5,Retry()),
            new Design("商务","所在工位卡牌计分：累计倍率 ×2。",9,Double()),
            new Design("活动策划","每周结束：基础分 +18；所在工位计分：倍率 +1。",6,Chips(18,Trigger.WeekEnd),Mult(1)),
            new Design("采购","所在工位计分：基础分 +10，倍率 +1。",5,Chips(10),Mult(1)),
            new Design("财务","持有时，所有6点牌获得金币附魔：结算基础分 +20。",6,Enchant(Enchantment.Coin,6)),
            new Design("PM","所在工位卡牌计分：基础分 +8，重抽次数 +1。",6,Chips(8),Retry())
        };
        static readonly Dictionary<string,Design> Tools=new Dictionary<string,Design>{
            {"3men",new Design("三人组","所在工位计分：倍率 +3。",6,Mult(3))},
            {"Angle",new Design("Angle","持有时，红桃牌获得双倍点数附魔。",6,Enchant(Enchantment.Arrow,-1,1))},
            {"BenZai",new Design("盆栽","每周结束：基础分 +12。",4,Chips(12,Trigger.WeekEnd))},
            {"Bing",new Design("饼","所在工位计分：基础分 +16。",4,Chips(16))},
            {"C4",new Design("C4","所在工位计分：基础分 +40。",7,Chips(40))},
            {"Candy",new Design("糖果","所在工位计分：倍率 +1。",4,Mult(1))},
            {"Clock",new Design("时钟","所在工位卡牌计分：重抽次数 +1。",5,Retry())},
            {"CockTail",new Design("鸡尾酒","牌型判定前，将所在工位卡牌改为红桃。",5,SuitTo(1))},
            {"FangDan",new Design("FangDan","所在工位计分：基础分 +15，倍率 +1。",5,Chips(15),Mult(1))},
            {"FangSi",new Design("FangSi","所在工位计分：倍率 +2。",5,Mult(2))},
            {"Farmer",new Design("Farmer","每周结束：基础分 +20。",5,Chips(20,Trigger.WeekEnd))},
            {"FatDragon",new Design("FatDragon","所在工位计分：基础分 +25。（复用标记废弃的图片，仅宣传片）",5,Chips(25))},
            {"Fbqb",new Design("Fbqb","所在工位计分：倍率 +2。（复用标记废弃的图片，仅宣传片）",5,Mult(2))},
            {"Fusion",new Design("Fusion","所在工位计分：累计倍率 ×2。",8,Double())},
            {"Gun",new Design("Gun","所在工位计分：基础分 +24。",5,Chips(24))},
            {"Hat",new Design("帽子","牌型判定前，将所在工位卡牌改为梅花。",5,SuitTo(2))},
            {"HotPot",new Design("火锅","所在工位计分：基础分 +10。",4,Chips(10))},
            {"Log",new Design("木头","每周结束：基础分 +15。",4,Chips(15,Trigger.WeekEnd))},
            {"NaiLong",new Design("奶龙","所在工位计分：基础分 +30。",6,Chips(30))},
            {"Potato",new Design("土豆","所在工位计分：基础分 +8，倍率 +1。",4,Chips(8),Mult(1))},
            {"Prince",new Design("Prince","所在工位计分：倍率 +3。",6,Mult(3))},
            {"Rail",new Design("Rail","牌型判定前，将所在工位卡牌点数设为6。",6,RankTo(6))},
            {"RIPot",new Design("RIPot","持有时，方块牌获得金币附魔。",6,Enchant(Enchantment.Coin,-1,3))},
            {"Rubbish",new Design("垃圾桶","所在工位卡牌计分：重抽次数 +1。",5,Retry())},
            {"Spray",new Design("喷雾","牌型判定前，将所在工位卡牌改为方块。",5,SuitTo(3))},
            {"Steam",new Design("Steam","持有时，黑桃牌获得粉丝附魔。",7,Enchant(Enchantment.Fans,-1,0))},
            {"TNT",new Design("TNT","所在工位计分：累计倍率 ×2。",8,Double())},
            {"Tomato",new Design("番茄","持有时，红桃牌获得金币附魔。",6,Enchant(Enchantment.Coin,-1,1))},
            {"WSQ",new Design("WSQ","所在工位卡牌计分：重抽次数 +1。（复用标记废弃的图片，仅宣传片）",5,Retry())},
            {"Zhan",new Design("Zhan","所在工位计分：基础分 +18，倍率 +1。",5,Chips(18),Mult(1))}
        };
        [MenuItem("WorkWork/Trailer/Configure Cast In Existing Scene")]
        public static void Configure()
        {
            var scene=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
            if(Application.isPlaying || scene.path!="Assets/WorkWork/Scenes/WorkWorkMvp 1.unity")throw new InvalidOperationException("Open only the trailer scene in Edit Mode.");
            Directory.CreateDirectory(Root+"/Config");AssetDatabase.Refresh();
            var old=scene.GetRootGameObjects().FirstOrDefault(g=>g.name=="Trailer Director (Presentation Only)");
            if(old!=null)Undo.DestroyObjectImmediate(old);
            var game=UnityEngine.Object.FindObjectOfType<GameController>(true);
            game.transform.root.gameObject.SetActive(true);
            var catalog=AssetDatabase.LoadAssetAtPath<GameCatalog>(Root+"/Config/TrailerCatalog.asset");
            if(catalog==null){catalog=ScriptableObject.CreateInstance<GameCatalog>();AssetDatabase.CreateAsset(catalog,Root+"/Config/TrailerCatalog.asset");}
            var original=AssetDatabase.LoadAssetAtPath<GameCatalog>("Assets/WorkWork/Config/GameCatalog.asset");
            catalog.rules=JsonUtility.FromJson<Settings>(JsonUtility.ToJson(original.rules));catalog.rules.content.Clear();
            var theme=AssetDatabase.LoadAssetAtPath<VisualTheme>(Root+"/Config/TrailerTheme.asset");
            var originalTheme=AssetDatabase.LoadAssetAtPath<VisualTheme>("Assets/WorkWork/Config/VisualTheme.asset");
            if(theme==null){theme=UnityEngine.Object.Instantiate(originalTheme);theme.name="TrailerTheme";AssetDatabase.CreateAsset(theme,Root+"/Config/TrailerTheme.asset");}
            else EditorUtility.CopySerialized(originalTheme,theme);
            var employeeIds=new List<string>();var itemIds=new List<string>();
            var staffPaths=Directory.GetFiles("Assets/Image/Staff","*.png").OrderBy(p=>StaffNumber(p)).ToArray();
            for(int i=0;i<staffPaths.Length;i++)
            {
                var id="trailer.employee."+StaffNumber(staffPaths[i]);employeeIds.Add(id);
                Add(catalog,theme,id,Employees[i],false,staffPaths[i]);
            }
            foreach(var path in Directory.GetFiles("Assets/Image/Tools","*.png").OrderBy(p=>p,StringComparer.Ordinal))
            {
                var stem=Path.GetFileNameWithoutExtension(path).Split('（')[0];var id="trailer.item."+stem;
                itemIds.Add(id);Add(catalog,theme,id,Tools[stem],true,path);
            }
            game.catalog=catalog;game.theme=theme;game.checkpointFileName="workwork-trailer-preview.json";
            var preview=UnityEngine.Object.FindObjectOfType<TrailerCastPreview>(true);
            if(preview==null)preview=new GameObject("Trailer Cast Preview").AddComponent<TrailerCastPreview>();
            var opening=new[]{"trailer.employee.4","trailer.employee.2","trailer.employee.15","trailer.employee.7","trailer.employee.3","trailer.employee.30"};
            preview.game=game;preview.employeeIds=opening.Concat(employeeIds.Where(id=>!opening.Contains(id))).ToArray();preview.itemIds=itemIds.ToArray();
            var shell=game.GetComponent<GameShell>();shell.welcome.SetActive(false);shell.board.SetActive(true);shell.settings.SetActive(false);
            game.shopPanel.SetActive(false);game.resultPanel.SetActive(false);
            ShowEditorCast(preview);
            EditorUtility.SetDirty(game);EditorUtility.SetDirty(preview);EditorUtility.SetDirty(theme);EditorUtility.SetDirty(catalog);
            AssetDatabase.SaveAssets();EditorSceneManager.MarkSceneDirty(scene);EditorSceneManager.SaveScene(scene);
            WriteManifest(catalog,theme);
            Selection.activeGameObject=preview.gameObject;
            Debug.Log($"TRAILER_CONTENT_READY: {employeeIds.Count} employees / {itemIds.Count} items. Existing UI preserved. F1/F2/F3 change cast in Play Mode.");
        }
        static void Add(GameCatalog cat,VisualTheme theme,string id,Design design,bool item,string path)
        {
            cat.rules.content.Add(new Content{id=id,name=design.label,description="【宣传片临时配置，非正式数值】\n"+design.description,price=design.price,item=item,effects=design.effects.ToList()});
            var icon=AssetDatabase.LoadAllAssetsAtPath(path.Replace('\\','/')).OfType<Sprite>().FirstOrDefault();
            if(icon==null)throw new InvalidOperationException("No sprite: "+path);
            theme.contentArt.Add(new ContentArt{id=id,icon=icon});
        }
        static int StaffNumber(string path)=>int.Parse(new string(Path.GetFileName(path).Skip(2).TakeWhile(char.IsDigit).ToArray()));
        static void ShowEditorCast(TrailerCastPreview p)
        {
            for(int i=0;i<6;i++)
            {
                p.game.employeeIcons[i].sprite=p.game.theme.Icon(p.employeeIds[(p.castPage*6+i)%p.employeeIds.Length]);p.game.employeeIcons[i].gameObject.SetActive(true);
                EditorUtility.SetDirty(p.game.employeeIcons[i]);
                for(int j=0;j<3;j++)
                {
                    int slot=i*3+j;string id=p.itemIds[(p.castPage*18+slot)%p.itemIds.Length];
                    p.game.itemIcons[slot].sprite=p.game.theme.Icon(id);p.game.itemIcons[slot].gameObject.SetActive(true);
                    if(p.game.itemTexts[slot]!=null)p.game.itemTexts[slot].text=p.game.catalog.rules.content.Find(c=>c.id==id).name;
                    EditorUtility.SetDirty(p.game.itemIcons[slot]);
                }
            }
        }
        static void WriteManifest(GameCatalog catalog,VisualTheme theme)
        {
            var lines=new List<string>{"# 宣传片专用员工与道具配置","","更新：2026-10-16。仅用于 WorkWorkMvp 1 宣传片场景。所有效果、价格均为演示设计，不代表正式平衡或正式内容全集。","","保留原场景界面、工位和交互；已撤销独立宣传片画布方案。Run 自动进入现有游戏界面。F1/F2/F3 切换三组阵容（会重置本次演示局）。最多同时展示6员工、18道具，其余均已加入本场景专用商店池。","","资源位于 Assets/WorkWorkTrailer/Config；复用 Assets/Image 原图，不另制图。员工附魔遵守每牌最多4个的现有规则，先取得的来源优先，满额后其他来源可能不生效。标记废弃的三张图片仅在此处复用。文件名含义不明的道具保留原名。","","预览存档：workwork-trailer-preview.json；正式场景仍使用 workwork-mvp.json。正式 GameController 仅增加可选存档文件名入口，未更改正式玩法。","","| 类别 | 名称 | 图片 | 价格 | 演示效果 |","| --- | --- | --- | --- | --- |"};
            foreach(var c in catalog.rules.content)lines.Add($"| {(c.item?"道具":"员工")} | {c.name} | {AssetDatabase.GetAssetPath(theme.Icon(c.id))} | {c.price} | {c.description.Replace("【宣传片临时配置，非正式数值】\n","")} |");
            File.WriteAllLines("Document/trailer-content-config.md",lines);
        }
    }
}
