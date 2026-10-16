using System.Linq;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
namespace WorkWork.Editor
{
    public static class DeveloperPanelSetup
    {
        static RectTransform Rect(string name,Transform parent)
        {var go=new GameObject(name,typeof(RectTransform));go.transform.SetParent(parent,false);return (RectTransform)go.transform;}
        static void Fill(RectTransform rect,Vector2 min,Vector2 max,Vector2 inset)
        {rect.anchorMin=min;rect.anchorMax=max;rect.offsetMin=inset;rect.offsetMax=-inset;}
        static Image Background(RectTransform rect,Color color)
        {var image=rect.gameObject.AddComponent<Image>();image.color=color;return image;}
        static TMP_Text Text(string name,Transform parent,string value,GameController game)
        {var rect=Rect(name,parent);Fill(rect,Vector2.zero,Vector2.one,Vector2.zero);var t=rect.gameObject.AddComponent<TextMeshProUGUI>();t.font=game.theme.font;t.fontSize=25;t.text=value;t.color=new Color32(73,44,23,255);t.alignment=TextAlignmentOptions.Center;t.raycastTarget=false;return t;}
        static Button Button(string name,Transform parent,string value,GameController game)
        {var rect=Rect(name,parent);var image=Background(rect,new Color32(255,239,209,255));var b=rect.gameObject.AddComponent<Button>();b.targetGraphic=image;var colors=b.colors;colors.highlightedColor=new Color(.88f,.88f,.88f);colors.pressedColor=new Color(.7f,.7f,.7f);b.colors=colors;Text("Label",rect,value,game);return b;}
        [MenuItem("WorkWork/Configure Developer Panel")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>(true);if(game==null || game.developerPanel!=null)return;
            var dev=game.gameObject.AddComponent<DeveloperPanel>();dev.game=game;game.developerPanel=dev;
            var shop=(RectTransform)game.shopPanel.transform;var panel=Rect("Developer Panel",shop.parent);
            panel.anchorMin=shop.anchorMin;panel.anchorMax=shop.anchorMax;panel.pivot=shop.pivot;panel.sizeDelta=shop.sizeDelta;panel.anchoredPosition=shop.anchoredPosition;panel.localScale=shop.localScale;
            panel.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical,Mathf.Max(200,shop.rect.height-28));
            Background(panel,new Color32(241,218,175,255));var zone=panel.gameObject.AddComponent<DropZone>();zone.controller=game;zone.developer=true;
            dev.panel=panel.gameObject;
            var title=Text("Heading",panel,"开发者面板 · 拖入添加 / 拖回删除 · 不消耗资金",game);var tr=title.rectTransform;tr.anchorMin=new Vector2(0,1);tr.anchorMax=Vector2.one;tr.pivot=new Vector2(.5f,1);tr.sizeDelta=new Vector2(-120,42);tr.anchoredPosition=new Vector2(-35,0);title.fontSize=23;
            dev.close=Button("Close",panel,"关闭",game);var cr=(RectTransform)dev.close.transform;cr.anchorMin=cr.anchorMax=cr.pivot=Vector2.one;cr.sizeDelta=new Vector2(90,40);cr.anchoredPosition=new Vector2(-8,-4);
            Column(panel,game,false);Column(panel,game,true);
            dev.toggle=Button("Developer Toggle",shop.parent,"开发者",game);var br=(RectTransform)dev.toggle.transform;br.anchorMin=br.anchorMax=br.pivot=Vector2.one;br.sizeDelta=new Vector2(110,40);br.anchoredPosition=new Vector2(-10,-155);
            panel.gameObject.SetActive(false);EditorUtility.SetDirty(game);EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
        static void Column(RectTransform panel,GameController game,bool item)
        {
            var column=Rect(item?"Tools":"Employees",panel);Fill(column,new Vector2(item ? .5f : 0,0),new Vector2(item ? 1 : .5f,1),new Vector2(12,12));column.offsetMax=new Vector2(-12,-48);
            var heading=Text("Heading",column,item?"道具":"员工",game);heading.rectTransform.anchorMin=new Vector2(0,1);heading.rectTransform.anchorMax=Vector2.one;heading.rectTransform.pivot=new Vector2(.5f,1);heading.rectTransform.sizeDelta=new Vector2(0,32);
            var scrollRoot=Rect("Scroll",column);Fill(scrollRoot,Vector2.zero,Vector2.one,Vector2.zero);scrollRoot.offsetMax=new Vector2(0,-35);Background(scrollRoot,new Color32(255,248,234,255));var scroll=scrollRoot.gameObject.AddComponent<ScrollRect>();scroll.horizontal=false;
            var viewport=Rect("Viewport",scrollRoot);Fill(viewport,Vector2.zero,Vector2.one,Vector2.zero);viewport.offsetMax=new Vector2(-22,0);viewport.gameObject.AddComponent<RectMask2D>();scroll.viewport=viewport;
            var content=Rect("Content",viewport);content.anchorMin=new Vector2(0,1);content.anchorMax=Vector2.one;content.pivot=new Vector2(.5f,1);
            var definitions=game.catalog.rules.content.Where(c=>c.item==item).ToArray();content.sizeDelta=new Vector2(0,definitions.Length*44);scroll.content=content;
            for(int i=0;i<definitions.Length;i++)
            {
                var def=definitions[i];var row=Button(def.id,content,def.name,game);var r=(RectTransform)row.transform;r.anchorMin=new Vector2(0,1);r.anchorMax=Vector2.one;r.pivot=new Vector2(.5f,1);r.sizeDelta=new Vector2(-8,40);r.anchoredPosition=new Vector2(0,-i*44);
                var token=row.gameObject.AddComponent<DragToken>();token.controller=game;token.kind=TokenKind.Developer;token.contentId=def.id;
            }
            var barRect=Rect("Scrollbar",scrollRoot);Fill(barRect,new Vector2(1,0),Vector2.one,Vector2.zero);barRect.pivot=new Vector2(1,.5f);barRect.sizeDelta=new Vector2(20,0);Background(barRect,new Color32(202,181,149,255));
            var handle=Rect("Handle",barRect);Fill(handle,Vector2.zero,Vector2.one,Vector2.zero);var handleImage=Background(handle,new Color32(130,94,59,255));var bar=barRect.gameObject.AddComponent<Scrollbar>();bar.handleRect=handle;bar.targetGraphic=handleImage;bar.direction=Scrollbar.Direction.BottomToTop;scroll.verticalScrollbar=bar;scroll.movementType=ScrollRect.MovementType.Clamped;
        }
    }
}
