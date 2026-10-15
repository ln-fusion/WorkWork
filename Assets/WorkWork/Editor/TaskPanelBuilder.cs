using System.Linq;
using TMPro;
using UnityEditor;
using UnityEditor.Events;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork.Editor
{
    public static class TaskPanelBuilder
    {
        [MenuItem("WorkWork/Configure Task Panel")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var game=Object.FindObjectOfType<GameController>();var shell=game.GetComponent<GameShell>();
            const string path="Assets/Image/PhonePanel.png";
            AssetDatabase.ImportAsset(path);
            var importer=(TextureImporter)AssetImporter.GetAtPath(path);
            if(importer.textureType!=TextureImporterType.Sprite || importer.spriteImportMode!=SpriteImportMode.Single)
            {importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.mipmapEnabled=false;importer.SaveAndReimport();}
            if(shell.taskPanel==null)
            {
                var root=new GameObject("Task Panel",typeof(RectTransform),typeof(ResponsiveUiFrame),typeof(TaskPanel));root.transform.SetParent(game.canvas.transform,false);
                var panel=root.GetComponent<TaskPanel>();shell.taskPanel=panel;panel.game=game;
                var shade=Image(root.transform,"Backdrop",0,0,1600,900,new Color(0,0,0,.5f));
                Button(shade,shell.CloseTasks);
                var phone=Image(root.transform,"Phone Background",528,70,544,704,Color.white);phone.sprite=AssetDatabase.LoadAssetAtPath<Sprite>(path);phone.preserveAspect=true;
                Text(root.transform,game,"Title","额外奖金任务",610,185,380,50,34);
                panel.empty=Text(root.transform,game,"Empty","暂无任务",610,300,380,50,26).gameObject;
                panel.rows=new GameObject[3];panel.names=new TMP_Text[3];panel.counts=new TMP_Text[3];panel.rewards=new TMP_Text[3];panel.fills=new Image[3];
                for(int i=0;i<3;i++)
                {
                    var row=new GameObject("Task "+(i+1),typeof(RectTransform));row.transform.SetParent(root.transform,false);Layout((RectTransform)row.transform,610,260+i*110,380,100);panel.rows[i]=row;
                    panel.names[i]=Text(row.transform,game,"Name","任务名称",0,0,380,36,26);panel.names[i].enableAutoSizing=true;panel.names[i].fontSizeMin=20;panel.names[i].fontSizeMax=26;
                    var track=Image(row.transform,"Progress Track",0,44,290,20,new Color(.72f,.71f,.67f));track.raycastTarget=false;
                    var fill=Image(track.transform,"Fill",0,0,290,20,Color.white);fill.raycastTarget=false;fill.type=UnityEngine.UI.Image.Type.Filled;fill.fillMethod=UnityEngine.UI.Image.FillMethod.Horizontal;fill.fillOrigin=0;fill.sprite=AssetDatabase.GetBuiltinExtraResource<Sprite>("UI/Skin/UISprite.psd");fill.fillAmount=0;panel.fills[i]=fill;
                    panel.counts[i]=Text(row.transform,game,"Count","0/2",300,37,80,34,25);panel.counts[i].alignment=TextAlignmentOptions.MidlineRight;
                    panel.rewards[i]=Text(row.transform,game,"Reward","奖金 "+VisualTheme.CurrencyIcon+"1",0,73,380,24,20);
                    var task=game.catalog.rules.tasks?.ElementAtOrDefault(i);
                    row.SetActive(task!=null);
                    if(task!=null) {panel.names[i].text=task.name;panel.counts[i].text="0/"+task.target;panel.rewards[i].text="奖金 "+VisualTheme.CurrencyIcon+Mathf.Clamp(task.reward,1,3);}
                }
                var close=Image(root.transform,"Close",730,610,140,42,new Color(1,.91f,.72f));Button(close,shell.CloseTasks);Text(close.transform,game,"Label","关闭",0,0,140,42,24).alignment=TextAlignmentOptions.Center;
                root.SetActive(false);EditorUtility.SetDirty(panel);
            }
            // Bind the existing hand-adjusted task hit area without moving it.
            shell.taskPanel.empty.SetActive(game.catalog.rules.tasks==null || game.catalog.rules.tasks.Count==0);
            var trigger=game.GetComponentsInChildren<Transform>(true).FirstOrDefault(t=>t.name=="Task" || t.name=="Tasks Reserved");
            if(trigger==null) throw new System.Exception("Task button not found");
            var graphic=trigger.GetComponent<Image>();if(graphic==null) graphic=trigger.gameObject.AddComponent<Image>();graphic.raycastTarget=true;
            var button=trigger.GetComponent<UnityEngine.UI.Button>();if(button==null)button=trigger.gameObject.AddComponent<UnityEngine.UI.Button>();
            button.interactable=true;button.targetGraphic=graphic;button.onClick=new UnityEngine.UI.Button.ButtonClickedEvent();UnityEventTools.AddPersistentListener(button.onClick,shell.OpenTasks);ArtUiBuilder.ConfigureButtonTint(button);
            EditorUtility.SetDirty(button);EditorUtility.SetDirty(graphic);EditorUtility.SetDirty(shell);
            EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);AssetDatabase.SaveAssets();
            Debug.Log("WORKWORK_TASK_PANEL_READY");
        }
        [MenuItem("WorkWork/Preview/Task Panel")]
        public static void Preview()
        {
            var shell=Object.FindObjectOfType<GameShell>(true);
            shell.taskPanel.gameObject.SetActive(true);shell.taskPanel.transform.SetAsLastSibling();shell.taskPanel.Refresh();
        }
        static void Button(Image image,UnityEngine.Events.UnityAction action)
        {var button=image.gameObject.AddComponent<UnityEngine.UI.Button>();button.targetGraphic=image;UnityEventTools.AddPersistentListener(button.onClick,action);ArtUiBuilder.ConfigureButtonTint(button);}
        internal static Image Image(Transform parent,string name,float x,float y,float w,float h,Color color)
        {var obj=new GameObject(name,typeof(RectTransform),typeof(Image));obj.transform.SetParent(parent,false);Layout((RectTransform)obj.transform,x,y,w,h);var image=obj.GetComponent<Image>();image.color=color;return image;}
        internal static TMP_Text Text(Transform parent,GameController game,string name,string value,float x,float y,float w,float h,int size)
        {var obj=new GameObject(name,typeof(RectTransform),typeof(TextMeshProUGUI));obj.transform.SetParent(parent,false);Layout((RectTransform)obj.transform,x,y,w,h);var label=obj.GetComponent<TextMeshProUGUI>();label.text=value;label.font=game.theme.font;label.spriteAsset=game.theme.currencySprites;label.fontSharedMaterial=game.theme.font.material;label.fontSize=size;label.color=new Color(.22f,.18f,.13f);label.alignment=TextAlignmentOptions.MidlineLeft;label.raycastTarget=false;return label;}
        static void Layout(RectTransform rect,float x,float y,float w,float h)
        {rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(0,1);rect.anchoredPosition=new Vector2(x,-y);rect.sizeDelta=new Vector2(w,h);}
    }
}
