using System;
using System.Linq;
using TMPro;
using UnityEditor;
using UnityEditor.Events;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork.Editor
{
    public static class ArtUiBuilder
    {
        static TMP_FontAsset font;
        static readonly Color Brown=new Color(.32f,.19f,.08f), Paper=new Color(1,.91f,.72f);
        [MenuItem("WorkWork/Apply Layered Art UI")]
        public static void Build()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) { Debug.LogError("Stop Play mode before generating art UI."); return; }
            MvpBuilder.Build();
            var g=UnityEngine.Object.FindObjectOfType<GameController>(); font=g.theme.font;
            var shell=g.gameObject.AddComponent<GameShell>(); shell.game=g;
            var canvas=g.canvas.transform;
            var board=Panel(canvas,"Game Screen",0,0,1600,900,Color.clear); shell.board=board;
            foreach(Transform child in canvas.Cast<Transform>().ToArray()) if(child!=board.transform) child.SetParent(board.transform,false);
            // Keep original controller references; only the visuals and layout are replaced.
            foreach(Transform child in board.transform) child.gameObject.SetActive(false);
            var art=Panel(board.transform,"Game PSD Layers",0,0,1600,900,Color.clear);
            Layers(art.transform,"Assets/Image/GameUI2.psd","Back",0,0,1600,894);
            g.officeBackground.gameObject.SetActive(false); g.theme.officeBackground=null;
            for(int i=0;i<6;i++)
            {
                float x=18+i*264;
                Move(g.employeeButtons[i].transform,board.transform,x,255,246,194,true);
                g.employeeButtons[i].GetComponent<Image>().color=Color.clear;
                Move(g.employeeIcons[i].transform,g.employeeButtons[i].transform,0,0,246,194,false);
                Move(g.slotButtons[i].transform,board.transform,x+50,475,146,183,true);
                g.slotButtons[i].GetComponent<Image>().color=Color.clear;
                g.slotButtons[i].GetComponentInChildren<TMP_Text>().text="";
                Move(g.slotRoots[i],g.slotButtons[i].transform,0,0,146,183,true);
            }
            var handPanel=g.handRoots[0].parent;
            Move(handPanel,board.transform,250,690,990,177,true); handPanel.GetComponent<Image>().color=Color.clear;
            for(int i=0;i<6;i++) Move(g.handRoots[i],handPanel,20+i*156,9,116,150,true);
            Move(g.scoreButton.transform,board.transform,1280,705,222,83,true);
            Move(g.redrawButton.transform,board.transform,1280,797,222,76,true);
            g.scoreButton.GetComponent<Image>().color=g.redrawButton.GetComponent<Image>().color=Color.clear;
            g.scoreButton.GetComponentInChildren<TMP_Text>().gameObject.SetActive(false); g.redrawButton.GetComponentInChildren<TMP_Text>().gameObject.SetActive(false);
            shell.chips=Text(board.transform,"Chips", "0",540,27,220,94,66);
            shell.multiplier=Text(board.transform,"Multiplier","0",820,27,205,94,66);
            shell.target=Text(board.transform,"Target","0",1190,20,210,48,38);
            shell.cash=Text(board.transform,"Cash","0",1190,81,210,48,38);
            shell.pattern=Text(board.transform,"Pattern","",366,102,142,30,17);
            shell.plays=Text(board.transform,"Remaining Weeks","4",1453,713,60,72,45);
            shell.redraws=Text(board.transform,"Redraw Count","4",1453,805,60,58,45);
            shell.dateNumbers=new[]{Text(board.transform,"Year","1",162,40,35,44,30),Text(board.transform,"Month","1",218,40,35,44,30),Text(board.transform,"Week","1",200,91,35,40,30)};
            var tasks=Button(board.transform,"Task","查看\n任务",18,703,164,177,Paper);
            UnityEventTools.AddPersistentListener(tasks.onClick,shell.OpenTasks);
            var settingsButton=Button(board.transform,"Settings Button","",1420,18,105,100,Color.clear);
            UnityEventTools.AddPersistentListener(settingsButton.onClick,shell.OpenSettings);
            BindArt(g);
            BuildShop(g,board.transform);
            ApplyCorrections(g);
            BuildResult(g,shell,board.transform);
            var welcome=Panel(canvas,"Welcome Screen",0,0,1600,900,Paper); shell.welcome=welcome;
            Layers(welcome.transform,"Assets/Image/Welcome.psd","图层 8",0,0,1600,900);
            var newGame=Button(welcome.transform,"New Game","新游戏",120,443,380,76,Paper);
            UnityEventTools.AddPersistentListener(newGame.onClick,g.NewGame);
            shell.continueButton=Button(welcome.transform,"Continue","继续游戏",120,537,380,76,Paper);
            UnityEventTools.AddPersistentListener(shell.continueButton.onClick,g.ContinueGame);
            var setting=Button(welcome.transform,"Settings","设置",120,631,380,76,Paper); UnityEventTools.AddPersistentListener(setting.onClick,shell.OpenSettings);
            var quit=Button(welcome.transform,"Quit","退出游戏",120,725,380,76,Paper); UnityEventTools.AddPersistentListener(quit.onClick,shell.Quit);
            BuildSettings(shell,canvas);
            board.SetActive(true); welcome.SetActive(true); shell.settings.SetActive(false);
            SeparateBackgrounds(g);
            CardUiBuilder.ApplyAssets();
            TooltipUiBuilder.ApplyTo(g);
            // PNG/PSD imports may reload ScriptableObjects. Rebind after all art imports.
            BindArt(g);
            foreach(var label in g.GetComponentsInChildren<TMP_Text>(true))
            {
                label.font=g.theme.font; label.fontSharedMaterial=g.theme.font.material;
                EditorUtility.SetDirty(label);
            }
            ArtButtonBinding.Bind(g);
            PatternHelpBuilder.Build(g);
            ConfigureAllButtons(g);
            EditorUtility.SetDirty(g); EditorUtility.SetDirty(shell); if(g.theme!=null) EditorUtility.SetDirty(g.theme);
            AssetDatabase.SaveAssets(); EditorSceneManager.SaveScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene());
            MusicSetup.Configure();CurrencyIconSetup.Configure();TaskPanelBuilder.Configure();TaskChoiceBuilder.Configure();
            ScoreFeedbackSetup.Configure();ConditionFeedbackSetup.Configure();EnchantmentFeedbackSetup.Configure();CardFaceFeedbackSetup.Configure();CardDeletionFeedbackSetup.Configure();CardMotionSetup.Configure();ShopRevealSetup.Configure();
            FailureRevealSetup.Configure();VictoryRevealSetup.Configure();PhonePickupSetup.Configure();
            ActionFeedbackSetup.Configure();DropHintsSetup.Configure();DeploymentTiltSetup.Configure();LoadingTransitionSetup.Configure();
            Debug.Log("WORKWORK_ART_UI_READY");
        }
        static void BindArt(GameController g)
        {
            g.theme=AssetDatabase.LoadAssetAtPath<VisualTheme>("Assets/WorkWork/Config/VisualTheme.asset");
            FinalContentSetup.BindArt(g.theme);
        }
        [MenuItem("WorkWork/Separate UI Background Images")]
        public static void FixBackgrounds()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var g=UnityEngine.Object.FindObjectOfType<GameController>(); SeparateBackgrounds(g);
            EditorSceneManager.MarkSceneDirty(g.gameObject.scene); EditorSceneManager.SaveScene(g.gameObject.scene);
        }
        static void SeparateBackgrounds(GameController g)
        {
            var shell=g.GetComponent<GameShell>();
            // Canvas and page/container transforms own layout; only separate child Images paint.
            var canvasImage=g.canvas.GetComponent<Image>(); if(canvasImage!=null) UnityEngine.Object.DestroyImmediate(canvasImage);
            foreach(var root in new[]{shell.board,shell.welcome,shell.settings})
            {
                MoveBackgroundToChild(root);
                if(root.GetComponent<ResponsiveUiFrame>()==null) root.AddComponent<ResponsiveUiFrame>();
            }
            foreach(var name in new[]{"Game PSD Layers","Shop PSD Layers","Settings Paper"})
            {
                var rect=g.GetComponentsInChildren<RectTransform>(true).FirstOrDefault(t=>t.name==name);
                if(rect!=null) MoveBackgroundToChild(rect.gameObject);
            }
        }
        static void MoveBackgroundToChild(GameObject container)
        {
            var image=container.GetComponent<Image>(); if(image==null) return;
            var child=new GameObject("Background Image",typeof(RectTransform),typeof(Image)); child.transform.SetParent(container.transform,false); child.transform.SetAsFirstSibling();
            var rect=(RectTransform)child.transform; rect.anchorMin=Vector2.zero; rect.anchorMax=Vector2.one; rect.offsetMin=rect.offsetMax=Vector2.zero;
            var background=child.GetComponent<Image>(); background.sprite=image.sprite; background.color=image.color; background.type=image.type; background.preserveAspect=image.preserveAspect; background.raycastTarget=image.raycastTarget;
            UnityEngine.Object.DestroyImmediate(image);
        }
        static Sprite SpriteAt(string path) => AssetDatabase.LoadAssetAtPath<Sprite>(path) ?? AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().FirstOrDefault();
        static void BuildShop(GameController g,Transform board)
        {
            Move(g.shopPanel.transform,board,0,475,1600,425,false); g.shopPanel.GetComponent<Image>().color=Color.clear;
            foreach(Transform child in g.shopPanel.transform) child.gameObject.SetActive(false);
            var art=Panel(g.shopPanel.transform,"Shop PSD Layers",0,0,1600,425,Color.clear);
            Layers(art.transform,"Assets/Image/ShopUI.psd","shopPanel",0,16,1600,399);
            for(int i=0;i<6;i++)
            {
                Move(g.offerButtons[i].transform,g.shopPanel.transform,112+i*214,89,180,259,true);
                g.offerButtons[i].GetComponent<Image>().color=Color.clear;
                Move(g.offerIcons[i].transform,g.offerButtons[i].transform,8,0,164,135,false);
                Move(g.offerTexts[i].transform,g.offerButtons[i].transform,4,138,172,114,true);
                g.offerTexts[i].color=Brown; g.offerTexts[i].fontSize=17;
            }
            Move(g.refreshButton.transform,g.shopPanel.transform,0,41,90,152,true); g.refreshButton.GetComponent<Image>().color=Color.clear;
            var refreshLabel=g.refreshButton.GetComponentInChildren<TMP_Text>(); Move(refreshLabel.transform,g.refreshButton.transform,0,150,98,68,true); refreshLabel.fontSize=15; refreshLabel.color=Brown;
            Move(g.nextMonthButton.transform,g.shopPanel.transform,1461,24,105,180,true); g.nextMonthButton.GetComponent<Image>().color=Color.clear; g.nextMonthButton.GetComponentInChildren<TMP_Text>().text="";
            Move(g.shopTitle.transform,g.shopPanel.transform,178,6,1210,42,true); g.shopTitle.fontSize=17; g.shopTitle.color=Brown;
            g.shopPanel.SetActive(false);
        }
        [MenuItem("WorkWork/Apply UI Corrections")]
        public static void CorrectCurrentScene()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var g=UnityEngine.Object.FindObjectOfType<GameController>();
            ApplyCorrections(g);
            EditorUtility.SetDirty(g); EditorUtility.SetDirty(g.GetComponent<GameShell>());
            EditorSceneManager.MarkSceneDirty(g.gameObject.scene); EditorSceneManager.SaveScene(g.gameObject.scene);
        }
        static void ApplyCorrections(GameController g)
        {
            font=g.theme.font; var shell=g.GetComponent<GameShell>();
            if(g.itemButtons.Length==6)
            {
                var old=g.itemButtons;
                g.itemButtons=new Button[18]; g.itemTexts=new TMP_Text[18]; g.itemIcons=new Image[18];
                for(int i=0;i<6;i++) for(int j=0;j<3;j++)
                {
                    int k=i*3+j;
                    var obj=j==0?old[i].gameObject:UnityEngine.Object.Instantiate(old[i].gameObject,old[i].transform.parent);
                    g.itemButtons[k]=obj.GetComponent<Button>(); g.itemTexts[k]=obj.GetComponentInChildren<TMP_Text>(true); g.itemIcons[k]=obj.GetComponentsInChildren<Image>(true).First(v=>v.gameObject!=obj);
                }
            }
            for(int i=0;i<18;i++)
            {
                var button=g.itemButtons[i]; button.name="Equipment "+(i/3+1)+" Slot "+(i%3+1);
                Move(button.transform,shell.board.transform,18+(i/3)*264+(i%3)*82,148,82,82,true);
                button.GetComponent<Image>().color=Color.clear;
                Move(g.itemIcons[i].transform,button.transform,4,3,74,76,false);
                g.itemTexts[i].gameObject.SetActive(false);
                var drop=button.GetComponent<DropZone>(); drop.controller=g; drop.slot=i/3; drop.equipmentSlot=i%3;
            }
            if(g.offerPrices==null || g.offerPrices.Length!=6) g.offerPrices=new TMP_Text[6];
            for(int i=0;i<6;i++)
            {
                Move(g.offerButtons[i].transform,g.shopPanel.transform,120+i*222,30,180,360,true);
                Move(g.offerIcons[i].transform,g.offerButtons[i].transform,8,104,164,132,false);
                Move(g.offerTexts[i].transform,g.offerButtons[i].transform,4,246,172,48,true);
                g.offerTexts[i].fontSize=20; g.offerTexts[i].text="";
                if(g.offerPrices[i]==null) g.offerPrices[i]=Text(g.offerButtons[i].transform,"Price","",-12,0,64,65,32);
                Move(g.offerPrices[i].transform,g.offerButtons[i].transform,-12,0,64,65,true); g.offerPrices[i].color=Color.white;
            }
            if(g.shopTitle!=null) g.shopTitle.gameObject.SetActive(false);
            var refreshLabel=g.refreshButton.GetComponentInChildren<TMP_Text>(true);
            Move(refreshLabel.transform,g.refreshButton.transform,0,78,90,45,true); refreshLabel.fontSize=30; refreshLabel.text="3";
            g.nextMonthButton.GetComponentInChildren<TMP_Text>(true).text="";
            if(shell.shopCash==null) shell.shopCash=Text(g.shopPanel.transform,"Shop Cash","0",1460,161,135,80,38);
            Move(shell.shopCash.transform,g.shopPanel.transform,1460,161,135,80,true);
            shell.cash.name="Current Score"; shell.cash.text="0"; shell.multiplier.text="1";
            foreach(var label in g.GetComponentsInChildren<TMP_Text>(true)) {label.font=font;label.fontSharedMaterial=font.material;}
        }
        static void BuildResult(GameController g,GameShell shell,Transform board)
        {
            Move(g.resultPanel.transform,board,330,80,940,740,false); g.resultPanel.GetComponent<Image>().color=Color.clear;
            g.resultText.gameObject.SetActive(false);
            var resultArt=Panel(g.resultPanel.transform,"Result Art",0,0,940,705,Color.white).GetComponent<Image>();
            resultArt.preserveAspect=true; resultArt.sprite=SpriteAt("Assets/Image/Win.psd");
            shell.winNumbers=new[]{Text(g.resultPanel.transform,"Win Target","",145,274,194,49,25),Text(g.resultPanel.transform,"Win Excess","",584,274,194,49,25),Text(g.resultPanel.transform,"Win Interest","",145,395,194,49,25),Text(g.resultPanel.transform,"Win Staff","",584,395,194,49,25),Text(g.resultPanel.transform,"Win Income","",354,552,194,38,28)};
            shell.loseNumbers=new[]{Text(g.resultPanel.transform,"Lose Target","",185,340,215,52,30),Text(g.resultPanel.transform,"Lose Result","",548,340,215,52,30)};
            Move(g.resultButton.transform,g.resultPanel.transform,337,669,266,58,true); g.resultButton.GetComponent<Image>().color=Paper; g.resultButton.GetComponentInChildren<TMP_Text>().color=Brown;
            shell.restart=Button(g.resultPanel.transform,"Restart","",335,424,270,81,Color.clear); UnityEventTools.AddPersistentListener(shell.restart.onClick,g.NewGame);
            ResultUiBuilder.Bind(g);
            g.resultPanel.SetActive(false);
        }
        static void BuildSettings(GameShell shell,Transform canvas)
        {
            shell.settings=Panel(canvas,"Settings Overlay",0,0,1600,900,new Color(0,0,0,.55f));
            var paper=Panel(shell.settings.transform,"Settings Paper",420,180,760,550,Paper);
            var sprite=SpriteAt("Assets/Image/WindowContent.png"); if(sprite!=null) { paper.GetComponent<Image>().sprite=sprite; paper.GetComponent<Image>().color=Color.white; }
            Text(paper.transform,"Settings Title","设置",40,35,680,60,36);
            shell.volumeLabels=new TMP_Text[3]; var sliders=new Slider[3]; string[] titles={"主音量","音乐音量","音效音量"};
            for(int i=0;i<3;i++)
            {
                Text(paper.transform,"Volume Name "+i,titles[i],48,135+i*85,150,36,24);
                var track=Panel(paper.transform,"Volume Slider "+i,211,140+i*85,377,28,new Color(.51f,.34f,.18f));
                var slider=track.AddComponent<Slider>(); slider.minValue=0; slider.maxValue=1;
                var fill=Panel(track.transform,"Fill",0,0,377,28,new Color(.93f,.64f,.25f));
                var fillRect=(RectTransform)fill.transform; fillRect.anchorMin=Vector2.zero; fillRect.anchorMax=Vector2.one; fillRect.offsetMin=fillRect.offsetMax=Vector2.zero;
                var handle=Panel(track.transform,"Handle",0,-7,24,42,Brown);
                slider.fillRect=(RectTransform)fill.transform; slider.handleRect=(RectTransform)handle.transform; slider.targetGraphic=handle.GetComponent<Image>();
                sliders[i]=slider; shell.volumeLabels[i]=Text(paper.transform,"Volume Percent "+i,"100%",600,134+i*85,105,36,24);
            }
            shell.master=sliders[0]; shell.music=sliders[1]; shell.effects=sliders[2];
            var back=Button(paper.transform,"Back to Welcome","回到欢迎界面",70,426,350,67,Paper); UnityEventTools.AddPersistentListener(back.onClick,shell.ShowWelcome);
            var close=Button(paper.transform,"Close Settings","关闭",456,426,225,67,Paper); UnityEventTools.AddPersistentListener(close.onClick,shell.CloseSettings);
        }
        static void Layers(Transform parent,string path,string baseName,float x,float y,float w,float h)
        {
            var prefab=AssetDatabase.LoadAssetAtPath<GameObject>(path);
            if(prefab==null) { var img=Panel(parent,"Art",x,y,w,h,Color.white).GetComponent<Image>(); img.sprite=SpriteAt(path); return; }
            var renderers=prefab.GetComponentsInChildren<SpriteRenderer>(true).Where(r=>r.sprite!=null).ToArray();
            Bounds bounds=renderers.First(r=>r.name.StartsWith(baseName,StringComparison.Ordinal)).bounds;
            foreach(var r in renderers.OrderBy(r=>r.sortingOrder))
            {
                float iw=r.bounds.size.x/bounds.size.x*w, ih=r.bounds.size.y/bounds.size.y*h;
                float ix=x+(r.bounds.center.x-bounds.min.x)/bounds.size.x*w-iw/2;
                float iy=y+(bounds.max.y-r.bounds.center.y)/bounds.size.y*h-ih/2;
                var img=Panel(parent,r.name,ix,iy,iw,ih,Color.white).GetComponent<Image>(); img.sprite=r.sprite; img.raycastTarget=false;
            }
        }
        static void Move(Transform obj,Transform parent,float x,float y,float w,float h,bool active)
        {
            obj.SetParent(parent,false); obj.SetAsLastSibling(); var rect=(RectTransform)obj; rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(0,1); rect.anchoredPosition=new Vector2(x,-y); rect.sizeDelta=new Vector2(w,h); obj.gameObject.SetActive(active);
        }
        static GameObject Panel(Transform parent,string name,float x,float y,float w,float h,Color color)
        { var obj=new GameObject(name,typeof(RectTransform),typeof(Image)); Move(obj.transform,parent,x,y,w,h,true); if(parent.GetComponent<Canvas>()!=null && w==1600 && h==900) { var rect=(RectTransform)obj.transform; rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f); rect.anchoredPosition=Vector2.zero; } obj.GetComponent<Image>().color=color; return obj; }
        static TMP_Text Text(Transform parent,string name,string text,float x,float y,float w,float h,int size)
        {
            var obj=new GameObject(name,typeof(RectTransform),typeof(TextMeshProUGUI)); Move(obj.transform,parent,x,y,w,h,true);
            var label=obj.GetComponent<TextMeshProUGUI>(); label.text=text; label.font=font; label.fontSize=size; label.color=Brown; label.alignment=TextAlignmentOptions.Center; label.raycastTarget=false; return label;
        }
        [MenuItem("WorkWork/Apply Button Color Tint")]
        public static void ApplyButtonTint()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var g=UnityEngine.Object.FindObjectOfType<GameController>();ConfigureAllButtons(g);
            EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene);AssetDatabase.SaveAssets();
        }
        public static void ConfigureAllButtons(GameController g)
        {
            foreach(var button in g.GetComponentsInChildren<Button>(true)) ConfigureButtonTint(button);
            ConfigureButtonTint(g.cardPrefab.button);EditorUtility.SetDirty(g.cardPrefab.button);
        }
        public static void ConfigureButtonTint(Button button)
        {
            var colors=button.colors;colors.normalColor=Color.white;colors.highlightedColor=new Color(.85f,.85f,.85f,1);colors.pressedColor=new Color(.7f,.7f,.7f,1);colors.selectedColor=Color.white;colors.colorMultiplier=1;colors.fadeDuration=.08f;
            button.colors=colors;button.transition=Selectable.Transition.ColorTint;
            if(button.targetGraphic!=null && button.targetGraphic.color.a==0)
            {
                var icon=button.GetComponentsInChildren<Image>(true).FirstOrDefault(i=>i.color.a>0);
                if(icon!=null) button.targetGraphic=icon;
                else if(button.name=="Refresh Shop" || button.name=="Next Month")
                {
                    var art=button.transform.parent.Find("Shop PSD Layers");
                    var target=art==null?null:art.Find(button.name=="Refresh Shop"?"图层 8":"下个月");
                    if(target!=null) button.targetGraphic=target.GetComponent<Image>();
                }
                else if(button.name=="Restart")
                {
                    var source=button.transform.parent.Find("Background Image") as RectTransform;
                    if(source!=null)
                    {
                        // Native UI mask reveals only the baked button region; Color Tint affects this Image.
                        if(button.GetComponent<RectMask2D>()==null) button.gameObject.AddComponent<RectMask2D>();
                        var obj=new GameObject("Button Artwork",typeof(RectTransform),typeof(Image));obj.transform.SetParent(button.transform,false);
                        var rect=(RectTransform)obj.transform;rect.pivot=source.pivot;rect.sizeDelta=source.rect.size;rect.position=source.position;
                        var scale=source.lossyScale;var parentScale=button.transform.lossyScale;rect.localScale=new Vector3(scale.x/parentScale.x,scale.y/parentScale.y,1);
                        var image=obj.GetComponent<Image>();var original=source.GetComponent<Image>();image.sprite=original.sprite;image.preserveAspect=original.preserveAspect;image.color=original.color;image.raycastTarget=false;
                        obj.transform.SetAsFirstSibling();button.targetGraphic=image;
                    }
                }
            }
            EditorUtility.SetDirty(button);
        }
        static Button Button(Transform parent,string name,string text,float x,float y,float w,float h,Color color)
        {
            var obj=Panel(parent,name,x,y,w,h,color); var button=obj.AddComponent<Button>(); button.targetGraphic=obj.GetComponent<Image>();
            var label=Text(obj.transform,"Label",text,6,3,w-12,h-6,30);
            if(color.a>0) { var outline=obj.AddComponent<Outline>(); outline.effectColor=Brown; outline.effectDistance=new Vector2(2,-2); }
            return button;
        }
    }
}






