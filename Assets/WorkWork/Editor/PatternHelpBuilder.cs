using TMPro;
using System.Linq;
using UnityEditor;
using UnityEditor.Events;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class PatternHelpBuilder
    {
        [MenuItem("WorkWork/Apply Pattern Help Panel")]
        public static void Apply()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var g=Object.FindObjectOfType<GameController>();Build(g);
            EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene);AssetDatabase.SaveAssets();
        }
        public static void Build(GameController g)
        {
            var shell=g.GetComponent<GameShell>();
            if(shell.patternHelp==null)
            {
                var root=new GameObject("Pattern Help",typeof(RectTransform),typeof(ResponsiveUiFrame));root.transform.SetParent(g.canvas.transform,false);shell.patternHelp=root;
                var shade=Image(root.transform,"Backdrop",0,0,1600,900,new Color(0,0,0,.55f));
                var dismiss=shade.gameObject.AddComponent<Button>();dismiss.targetGraphic=shade;UnityEventTools.AddPersistentListener(dismiss.onClick,shell.ClosePatternHelp);ArtUiBuilder.ConfigureButtonTint(dismiss);
                var paper=Image(root.transform,"Paper Background",330,50,940,800,Color.white);paper.sprite=AssetDatabase.LoadAssetAtPath<Sprite>("Assets/Image/WindowContent.png");paper.raycastTarget=true;
                Text(paper.transform,g,"Title","牌型与奖励",90,38,760,50,36);
                Text(paper.transform,g,"Name Header","牌型（从强到弱）",100,108,400,32,24);
                Text(paper.transform,g,"Chips Header","基础分奖励",530,108,160,32,24);
                Text(paper.transform,g,"Multiplier Header","倍率奖励",710,108,140,32,24);
                int count=Scoring.Rewards.Count;shell.patternNames=new TMP_Text[count];shell.patternChips=new TMP_Text[count];shell.patternMultipliers=new TMP_Text[count];
                for(int i=0;i<count;i++)
                {
                    var reward=Scoring.Rewards[count-1-i];float y=152+i*32;
                    shell.patternNames[i]=Text(paper.transform,g,"Pattern "+reward.priority,reward.name,100,y,400,31,24);
                    shell.patternChips[i]=Text(paper.transform,g,"Chips "+reward.priority,"+"+reward.chips,530,y,160,31,24);
                    shell.patternMultipliers[i]=Text(paper.transform,g,"Multiplier "+reward.priority,"+"+reward.mult,710,y,140,31,24);
                }
                Text(paper.transform,g,"Rule Note","基础倍率为 1；上表数值均为额外奖励。\n只结算最强牌型；卡牌点数及员工、道具效果另计。",100,628,740,68,22);
                var close=Image(paper.transform,"Close",350,720,240,44,new Color(1,.91f,.72f));var button=close.gameObject.AddComponent<Button>();button.targetGraphic=close;
                Text(close.transform,g,"Label","关闭",0,0,240,44,24);UnityEventTools.AddPersistentListener(button.onClick,shell.ClosePatternHelp);ArtUiBuilder.ConfigureButtonTint(button);
                root.SetActive(false);
            }
            var hint=shell.board.transform.Find("Game PSD Layers/组合提示");var image=hint.GetComponent<Image>();image.raycastTarget=true;
            var trigger=hint.GetComponent<Button>();if(trigger==null) trigger=hint.gameObject.AddComponent<Button>();trigger.targetGraphic=image;
            trigger.onClick=new Button.ButtonClickedEvent();UnityEventTools.AddPersistentListener(trigger.onClick,shell.OpenPatternHelp);ArtUiBuilder.ConfigureButtonTint(trigger);
            EditorUtility.SetDirty(shell);EditorUtility.SetDirty(image);EditorUtility.SetDirty(trigger);
        }
        [MenuItem("WorkWork/Layout Pattern Help %#h")]
        public static void Relayout()
        {
            string report=System.IO.Path.GetFullPath(System.IO.Path.Combine(Application.dataPath,"../Document/pattern-help-layout.txt"));
            try
            {
                if(EditorApplication.isPlayingOrWillChangePlaymode) throw new System.Exception("请在编辑模式下调整，避免丢失 Play 模式中的修改。");
                var g=Object.FindObjectOfType<GameController>();var shell=g.GetComponent<GameShell>();
                var paper=shell.patternHelp.transform.Find("Paper Background") as RectTransform;
                var title=paper.Find("Title")?.GetComponent<TMP_Text>();
                var note=paper.Find("Rule Note")?.GetComponent<TMP_Text>();
                var heads=new[]{"Name Header","Chips Header","Multiplier Header"}.Select(n=>paper.Find(n).GetComponent<TMP_Text>()).ToArray();
                float width=paper.rect.width,height=paper.rect.height,inner=width-140;
                float numberWidth=Mathf.Max(136,heads[1].GetPreferredValues().x+24,heads[2].GetPreferredValues().x+24);
                float gap=28;
                float minimumNameWidth=Mathf.Max(240,shell.patternNames.Max(t=>t.GetPreferredValues().x)+24);
                float requiredWidth=minimumNameWidth+2*numberWidth+2*gap+140;
                if(width<requiredWidth)
                {
                    var center=paper.TransformPoint(paper.rect.center);width=requiredWidth;
                    paper.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal,width);paper.position+=center-paper.TransformPoint(paper.rect.center);inner=width-140;
                }
                float nameWidth=inner-2*numberWidth-2*gap;
                float[] xs={0,nameWidth+gap,nameWidth+2*gap+numberWidth};float[] widths={nameWidth,numberWidth,numberWidth};
                float y=46;
                if(title!=null && title.gameObject.activeSelf)
                {float h=Mathf.Max(44,title.fontSize*1.4f);Layout((RectTransform)title.transform,70,y,inner,h);y+=h+18;}
                float headerHeight=Mathf.Max(42,heads.Max(t=>t.fontSize)*1.45f);
                for(int i=0;i<3;i++) {Layout((RectTransform)heads[i].transform,70+xs[i],y,widths[i],headerHeight);heads[i].alignment=i==0?TextAlignmentOptions.MidlineLeft:TextAlignmentOptions.Midline;}
                y+=headerHeight+18;
                var close=paper.Find("Close Pattern Help")??paper.Find("Close");var closeRect=(RectTransform)close;
                var closeLabel=close.GetComponentInChildren<TMP_Text>(true);float closeHeight=Mathf.Max(46,closeLabel.fontSize*1.4f);
                float closeWidth=Mathf.Max(200,closeRect.rect.width);float closeY=height-closeHeight-36;
                Layout(closeRect,(width-closeWidth)/2,closeY,closeWidth,closeHeight);
                var labelRect=(RectTransform)closeLabel.transform;labelRect.anchorMin=Vector2.zero;labelRect.anchorMax=Vector2.one;labelRect.offsetMin=labelRect.offsetMax=Vector2.zero;closeLabel.alignment=TextAlignmentOptions.Midline;
                float bodyBottom=closeY-22;
                if(note!=null && note.gameObject.activeSelf)
                {float h=Mathf.Max(54,note.GetPreferredValues(note.text,inner,Mathf.Infinity).y+8);Layout((RectTransform)note.transform,70,bodyBottom-h,inner,h);bodyBottom-=h+20;}
                var body=RectChild(paper,"Reward Table");Layout(body,70,y,inner,Mathf.Max(100,bodyBottom-y));
                var viewport=RectChild(body,"Viewport");Layout(viewport,0,0,inner,body.rect.height);Ensure<RectMask2D>(viewport.gameObject);
                var hit=Ensure<Image>(viewport.gameObject);hit.color=Color.clear;hit.raycastTarget=true;
                var content=RectChild(viewport,"Content");
                float maxFont=shell.patternNames.Concat(shell.patternChips).Concat(shell.patternMultipliers).Max(t=>t.fontSize);
                float rowHeight=Mathf.Max(38,maxFont*1.45f);Layout(content,0,0,inner,rowHeight*shell.patternNames.Length);
                var columns=new[]{shell.patternNames,shell.patternChips,shell.patternMultipliers};
                for(int c=0;c<3;c++) for(int i=0;i<columns[c].Length;i++)
                {
                    var label=columns[c][i];label.transform.SetParent(content,false);
                    Layout((RectTransform)label.transform,xs[c],i*rowHeight,widths[c],rowHeight-6);
                    label.alignment=c==0?TextAlignmentOptions.MidlineLeft:TextAlignmentOptions.Midline;EditorUtility.SetDirty(label);
                }
                var scroll=Ensure<ScrollRect>(body.gameObject);scroll.viewport=viewport;scroll.content=content;scroll.horizontal=false;scroll.vertical=true;scroll.movementType=ScrollRect.MovementType.Clamped;scroll.scrollSensitivity=32;
                var barRect=RectChild(paper,"Table Scrollbar");Layout(barRect,width-48,y,12,body.rect.height);
                var track=Ensure<Image>(barRect.gameObject);track.color=new Color(.32f,.19f,.08f,.12f);
                var handle=RectChild(barRect,"Handle");handle.anchorMin=Vector2.zero;handle.anchorMax=Vector2.one;handle.offsetMin=handle.offsetMax=Vector2.zero;
                var handleImage=Ensure<Image>(handle.gameObject);handleImage.color=new Color(.32f,.19f,.08f,.6f);
                var bar=Ensure<Scrollbar>(barRect.gameObject);bar.targetGraphic=handleImage;bar.handleRect=handle;bar.direction=Scrollbar.Direction.BottomToTop;
                scroll.verticalScrollbar=bar;scroll.verticalScrollbarVisibility=ScrollRect.ScrollbarVisibility.AutoHide;
                Canvas.ForceUpdateCanvases();scroll.verticalNormalizedPosition=1;
                EditorUtility.SetDirty(scroll);EditorUtility.SetDirty(shell);EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene);
                System.IO.File.WriteAllText(report,"PASS: preserved all font sizes; row height="+rowHeight+"; column widths="+string.Join(",",widths)+"; viewport height="+body.rect.height+". Native ScrollRect/Scrollbar handles overflow; header and close button remain fixed.");
            }
            catch(System.Exception ex) {System.IO.File.WriteAllText(report,"FAILED: "+ex);Debug.LogException(ex);}
        }
        static RectTransform RectChild(Transform parent,string name)
        {
            var existing=parent.Find(name) as RectTransform;if(existing!=null) return existing;
            var obj=new GameObject(name,typeof(RectTransform));obj.transform.SetParent(parent,false);return (RectTransform)obj.transform;
        }
        static T Ensure<T>(GameObject obj) where T:Component {var existing=obj.GetComponent<T>();return existing!=null?existing:obj.AddComponent<T>();}
        static Image Image(Transform parent,string name,float x,float y,float w,float h,Color color)
        {
            var obj=new GameObject(name,typeof(RectTransform),typeof(Image));obj.transform.SetParent(parent,false);Layout((RectTransform)obj.transform,x,y,w,h);var image=obj.GetComponent<Image>();image.color=color;return image;
        }
        static TMP_Text Text(Transform parent,GameController g,string name,string value,float x,float y,float w,float h,int size)
        {
            var obj=new GameObject(name,typeof(RectTransform),typeof(TextMeshProUGUI));obj.transform.SetParent(parent,false);Layout((RectTransform)obj.transform,x,y,w,h);
            var label=obj.GetComponent<TextMeshProUGUI>();label.text=value;label.font=g.theme.font;label.fontSharedMaterial=g.theme.font.material;label.fontSize=size;label.alignment=TextAlignmentOptions.MidlineLeft;label.color=new Color(.32f,.19f,.08f);label.raycastTarget=false;return label;
        }
        static void Layout(RectTransform rect,float x,float y,float w,float h)
        {
            rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(0,1);rect.anchoredPosition=new Vector2(x,-y);rect.sizeDelta=new Vector2(w,h);
        }
    }
}


