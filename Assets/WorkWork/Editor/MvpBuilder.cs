using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using TMPro;
using UnityEditor;
using UnityEditor.Events;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class MvpBuilder
    {
        const string Root = "Assets/WorkWork";
        static TMP_FontAsset font;
        static readonly Color Ink = new Color(.07f,.10f,.15f), Panel = new Color(.11f,.15f,.21f), Light = new Color(.88f,.91f,.94f), Muted = new Color(.57f,.66f,.75f), Gold = new Color(.95f,.70f,.30f);
        [MenuItem("WorkWork/Create MVP Scene")]
        public static void Build()
        {
            Directory.CreateDirectory(Root + "/Config"); Directory.CreateDirectory(Root + "/Prefabs"); Directory.CreateDirectory(Root + "/Scenes");
            AssetDatabase.Refresh();
            font = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/Fonts/LXGWMarkerGothic-Regular SDF.asset");
            var theme = AssetDatabase.LoadAssetAtPath<VisualTheme>(Root + "/Config/VisualTheme.asset");
            if (theme == null) { theme = ScriptableObject.CreateInstance<VisualTheme>(); theme.font = font; AssetDatabase.CreateAsset(theme, Root + "/Config/VisualTheme.asset"); }
            var catalog = AssetDatabase.LoadAssetAtPath<GameCatalog>(Root + "/Config/GameCatalog.asset");
            if (catalog == null)
            {
                catalog = ScriptableObject.CreateInstance<GameCatalog>();

                AssetDatabase.CreateAsset(catalog, Root + "/Config/GameCatalog.asset");
                FinalContentSetup.Apply();
            }
            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            var root = new GameObject("WorkWork MVP", typeof(GameController));
            var game = root.GetComponent<GameController>(); game.catalog = catalog; game.theme = theme;
            var cameraObject = new GameObject("Main Camera", typeof(Camera), typeof(AudioListener));
            cameraObject.tag = "MainCamera";
            cameraObject.GetComponent<Camera>().clearFlags = CameraClearFlags.SolidColor;
            cameraObject.GetComponent<Camera>().backgroundColor = Ink;
            cameraObject.GetComponent<Camera>().cullingMask = 0;
            var canvasObj = new GameObject("Office Canvas", typeof(RectTransform), typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            canvasObj.transform.SetParent(root.transform);
            game.canvas = canvasObj.GetComponent<Canvas>(); game.canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            var scaler = canvasObj.GetComponent<CanvasScaler>(); scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize; scaler.referenceResolution = new Vector2(1600,900); scaler.matchWidthOrHeight = .5f;
            scaler.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand;
            new GameObject("EventSystem", typeof(EventSystem), typeof(StandaloneInputModule));
            game.officeBackground = Box(canvasObj.transform, "Office Background", 0,0,1600,900,Ink).GetComponent<Image>();
            Label(canvasObj.transform,"Title", "WORK / WORK", 40,28,360,42,32,Gold);
            Label(canvasObj.transform,"Subtitle", "把每周的资源，变成本月的业绩。", 40,75,530,30,19,Muted);
            game.header = Label(canvasObj.transform,"Calendar", "第 01 月 / 第 1 周", 670,32,520,40,27,Light);
            var reset = Button(canvasObj.transform,"New Game", "新游戏",1260,30,130,42,Panel);
            UnityEventTools.AddPersistentListener(reset.onClick, game.NewGame);
            var resume = Button(canvasObj.transform,"Continue", "继续游戏",1410,30,150,42,Panel);
            UnityEventTools.AddPersistentListener(resume.onClick, game.ContinueGame);
            Box(canvasObj.transform,"Ledger",40,132,300,720,Panel);
            Label(canvasObj.transform,"Ledger Heading","月度经营",62,152,254,35,24,Gold);
            game.totals = Label(canvasObj.transform,"Totals","",62,207,252,190,23,Light);
            Label(canvasObj.transform,"Event Heading","最近一次结算",62,432,252,32,21,Gold);
            game.history = Label(canvasObj.transform,"History","",62,479,252,350,17,Light);
            game.history.overflowMode = TextOverflowModes.Truncate;
            Label(canvasObj.transform,"Board Heading","员工工位",376,129,250,34,23,Light);
            Label(canvasObj.transform,"Board Help","从左到右结算 / 拖动员工交换工位",1030,135,520,30,17,Muted);
            game.slotRoots = new RectTransform[6]; game.handRoots = new RectTransform[6];
            game.slotButtons = new Button[6]; game.employeeButtons = new Button[6]; game.itemButtons = new Button[18];
            game.itemTexts = new TMP_Text[18]; game.employeeIcons = new Image[6]; game.itemIcons = new Image[18];
            for (int i = 0; i < 6; i++)
            {
                float x = 376 + i * 198;
                var workstation = Box(canvasObj.transform,"Workstation " + (i+1),x,180,184,290,Panel);
                var drop = workstation.AddComponent<DropZone>(); drop.controller = game; drop.slot = i;
                game.employeeButtons[i] = Button(workstation.transform,"Employee","",8,10,168,46,new Color(.17f,.22f,.29f));
                UnityEngine.Object.DestroyImmediate(game.employeeButtons[i].GetComponentInChildren<TMP_Text>().gameObject);
                game.employeeButtons[i].gameObject.AddComponent<DragToken>(); AddDrop(game.employeeButtons[i].gameObject,game,i);
                game.employeeIcons[i] = Icon(game.employeeButtons[i].transform,"Portrait",3,4,32,36);
                for(int j=0;j<3;j++)
                {
                    int k=i*3+j;
                    game.itemButtons[k]=Button(workstation.transform,"Equipment "+j,"",8+j*56,61,54,30,new Color(.14f,.18f,.24f));
                    game.itemButtons[k].gameObject.AddComponent<DragToken>(); AddDrop(game.itemButtons[k].gameObject,game,i);
                    game.itemButtons[k].GetComponent<DropZone>().equipmentSlot=j;
                    game.itemTexts[k]=game.itemButtons[k].GetComponentInChildren<TMP_Text>();
                    game.itemIcons[k]=Icon(game.itemButtons[k].transform,"Item Icon",4,3,24,24);
                }
                game.slotButtons[i] = Button(workstation.transform,"Card Slot","放置卡牌",27,104,130,172,new Color(.08f,.12f,.17f));
                AddDrop(game.slotButtons[i].gameObject,game,i);
                game.slotRoots[i] = Rect(game.slotButtons[i].transform,"Card Visual",0,0,130,172);
            }
            Box(canvasObj.transform,"Preview Bar",376,486,1180,52,new Color(.16f,.22f,.29f));
            game.preview = Label(canvasObj.transform,"Score Preview","",398,495,1136,32,22,Gold);
            Label(canvasObj.transform,"Hand Heading","准备区",376,557,250,32,23,Light);
            var handPanel = Box(canvasObj.transform,"Hand Drop Area",376,601,1180,184,new Color(.09f,.13f,.19f));
            var handDrop = handPanel.AddComponent<DropZone>(); handDrop.controller = game; handDrop.hand = true;
            for (int i = 0; i < 6; i++) game.handRoots[i] = Rect(handPanel.transform,"Hand " + i,27 + i*198,6,130,172);
            game.status = Label(canvasObj.transform,"Status","",376,804,750,50,18,Muted);
            game.redrawButton = Button(canvasObj.transform,"Redraw","重抽手牌",1150,806,176,46,Panel);
            game.scoreButton = Button(canvasObj.transform,"Score Week","结算本周",1346,806,210,46,new Color(.34f,.26f,.14f));
            game.shopPanel = Box(canvasObj.transform,"Shop",354,546,1220,326,new Color(.12f,.19f,.22f));
            var shopDrop = game.shopPanel.AddComponent<DropZone>(); shopDrop.controller = game; shopDrop.shop = true;
            game.shopTitle = Label(game.shopPanel.transform,"Shop Heading","",24,16,1170,36,21,Gold);
            game.offerButtons = new Button[6]; game.offerTexts = new TMP_Text[6]; game.offerIcons = new Image[6];
            for (int i = 0; i < 6; i++)
            {
                game.offerButtons[i] = Button(game.shopPanel.transform,"Offer " + i,"",24+i*196,66,180,162,new Color(.18f,.25f,.27f));
                game.offerTexts[i] = game.offerButtons[i].GetComponentInChildren<TMP_Text>(); game.offerTexts[i].fontSize = 21;
                game.offerButtons[i].gameObject.AddComponent<DragToken>();
                game.offerIcons[i] = Icon(game.offerButtons[i].transform,"Content Icon",6,6,28,28);
                var offerDrop = game.offerButtons[i].gameObject.AddComponent<DropZone>(); offerDrop.controller = game; offerDrop.shop = true;
            }
            game.refreshButton = Button(game.shopPanel.transform,"Refresh Shop","刷新",756,252,210,48,Panel);
            game.nextMonthButton = Button(game.shopPanel.transform,"Next Month","进入下个月",986,252,210,48,new Color(.34f,.26f,.14f));
            Label(game.shopPanel.transform,"Shop Hint","拖入工位或道具槽购买 / 装备先出售再开除员工",24,249,710,58,17,Muted);
            game.shopPanel.SetActive(false);
            game.resultPanel = Box(canvasObj.transform,"Month Result",450,275,900,340,new Color(.16f,.21f,.27f));
            game.resultText = Label(game.resultPanel.transform,"Result Text","",32,30,836,210,25,Light);
            game.resultText.alignment = TextAlignmentOptions.Center;
            game.resultButton = Button(game.resultPanel.transform,"Enter Shop","进入月末商店",300,264,300,48,new Color(.34f,.26f,.14f));
            game.resultPanel.SetActive(false);
            game.cardPrefab = MakeCardPrefab();
            EditorUtility.SetDirty(game);
            EditorSceneManager.SaveScene(scene, Root + "/Scenes/WorkWorkMvp.unity");
            EditorBuildSettings.scenes = new[] { new EditorBuildSettingsScene(Root + "/Scenes/WorkWorkMvp.unity", true) }
                .Concat(EditorBuildSettings.scenes.Where(s => s.path != Root + "/Scenes/WorkWorkMvp.unity")).ToArray();
            AssetDatabase.SaveAssets();
            Debug.Log("WORKWORK_MVP_CREATED");
        }
        static void AddDrop(GameObject obj, GameController game, int slot)
        { var zone = obj.AddComponent<DropZone>(); zone.controller = game; zone.slot = slot; }
        static CardView MakeCardPrefab()
        {
            string path = Root + "/Prefabs/Card.prefab";
            var existing = AssetDatabase.LoadAssetAtPath<CardView>(path);
            if (existing != null) return existing;
            var root = Box(null,"Card",0,0,130,172,new Color(.96f,.94f,.89f));
            var view = root.AddComponent<CardView>(); view.face = root.GetComponent<Image>();
            view.button = root.AddComponent<Button>(); view.button.targetGraphic = view.face;
            view.drag = root.AddComponent<DragToken>();
            view.rankText = Label(root.transform,"Rank","1",12,12,106,95,58,Ink); view.rankText.alignment = TextAlignmentOptions.Center;
            view.suitText = Label(root.transform,"Suit","黑桃",12,123,106,32,20,Ink); view.suitText.alignment = TextAlignmentOptions.Center;
            view.suitIcon = Icon(root.transform,"Suit Icon",51,94,28,28);
            var saved = PrefabUtility.SaveAsPrefabAsset(root,path); UnityEngine.Object.DestroyImmediate(root);
            return saved.GetComponent<CardView>();
        }
        static RectTransform Rect(Transform parent, string name, float x, float y, float w, float h)
        {
            var obj = new GameObject(name,typeof(RectTransform)); obj.transform.SetParent(parent,false);
            var rect = (RectTransform)obj.transform; rect.anchorMin = rect.anchorMax = new Vector2(0,1); rect.pivot = new Vector2(0,1);
            rect.anchoredPosition = new Vector2(x,-y); rect.sizeDelta = new Vector2(w,h); return rect;
        }
        static GameObject Box(Transform parent,string name,float x,float y,float w,float h,Color color)
        { var rect=Rect(parent,name,x,y,w,h); var image=rect.gameObject.AddComponent<Image>(); image.color=color; return rect.gameObject; }
        static Image Icon(Transform parent,string name,float x,float y,float w,float h)
        { var image = Box(parent,name,x,y,w,h,Color.white).GetComponent<Image>(); image.preserveAspect=true; image.raycastTarget=false; return image; }
        static TMP_Text Label(Transform parent,string name,string text,float x,float y,float w,float h,int size,Color color)
        {
            var rect=Rect(parent,name,x,y,w,h); var label=rect.gameObject.AddComponent<TextMeshProUGUI>();
            label.font=font; label.text=text; label.fontSize=size; label.color=color; label.raycastTarget=false;
            label.alignment=TextAlignmentOptions.TopLeft; return label;
        }
        static Button Button(Transform parent,string name,string text,float x,float y,float w,float h,Color color)
        {
            var obj=Box(parent,name,x,y,w,h,color); var button=obj.AddComponent<Button>(); button.targetGraphic=obj.GetComponent<Image>();
            var label=Label(obj.transform,"Label",text,8,5,w-16,h-10,20,Light); label.alignment=TextAlignmentOptions.Center;
            return button;
        }
        public static void BuildAndVerify()
        {
            Build();
            if (AssetDatabase.LoadAssetAtPath<GameObject>(Root + "/Prefabs/Card.prefab") == null) throw new Exception("Card prefab missing");
            if (UnityEngine.Object.FindObjectOfType<GameController>().slotRoots.Length != 6) throw new Exception("Six workstations required");
            Debug.Log("WORKWORK_MVP_VERIFIED");
        }
    }
}
