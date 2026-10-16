using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork
{
    public class ScoreFeedback : MonoBehaviour
    {
        public float jumpHeight=10, cardTilt=6, jumpDuration=.22f, popupDuration=.55f, popupRise=42;
        public float popupFontSize=55;
        public Color chipsColor=new Color32(0x13,0x78,0x00,255), multiplierColor=new Color32(0xAC,0x00,0x01,255);
        public Color redrawColor=new Color32(0x13,0x78,0x00,255);
        [Range(.1f,1)] public float scoreRollDurationRatio=.8f;
        [Min(.01f)] public float scoreRollInterval=.035f;
        TMP_Text rollingScore;
        long finalScore;
        readonly System.Random rollRandom=new System.Random();
        public IEnumerator RollScore(TMP_Text label,long previous,long target,float duration)
        {
            if(label==null)yield break;
            rollingScore=label;finalScore=target;label.text=previous.ToString("N0");
            string text=target.ToString("N0");int digits=0;
            foreach(char c in text)if(char.IsDigit(c))digits++;
            float nextTick=0;
            if(previous!=target)
            for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
            {
                if(label==null)break;
                if(elapsed>=nextTick)
                {
                    float progress=Mathf.Clamp01(elapsed/Mathf.Max(.01f,duration));
                    int locked=Mathf.FloorToInt(digits*(1-Mathf.Pow(1-progress,2)));
                    var chars=text.ToCharArray();int digit=0;
                    for(int i=0;i<chars.Length;i++)
                    {
                        if(!char.IsDigit(chars[i]))continue;
                        if(digit>=locked)chars[i]=(char)('0'+rollRandom.Next(digit==0 && digits>1?1:0,10));
                        digit++;
                    }
                    label.text=new string(chars);nextTick=elapsed+Mathf.Max(.01f,scoreRollInterval)*(1+2*progress);
                }
                yield return null;
            }
            if(label!=null)label.text=target.ToString("N0");rollingScore=null;
        }
        struct Pose {public Vector2 position;public Quaternion rotation;}
        readonly Dictionary<RectTransform,Pose> poses=new Dictionary<RectTransform,Pose>();
        public bool IsBouncing(RectTransform rect)=>rect!=null && poses.ContainsKey(rect);
        readonly List<GameObject> popups=new List<GameObject>();
        public void ClearFeedback()
        {
            StopAllCoroutines();
            if(rollingScore!=null)rollingScore.text=finalScore.ToString("N0");rollingScore=null;
            foreach(var pair in poses) if(pair.Key!=null) {pair.Key.anchoredPosition=pair.Value.position;pair.Key.localRotation=pair.Value.rotation;}
            poses.Clear();foreach(var popup in popups)if(popup!=null)Destroy(popup);popups.Clear();
        }
        void OnDisable() => ClearFeedback();
        public void Play(GameController game,ScoreStep step)
        {Play(game,step,true);}
        public void AnimateSource(GameController game,ScoreStep step)
        {if(step.source!=ScoreSource.Pattern)Source(game,step,true);}
        RectTransform Source(GameController game,ScoreStep step,bool jump)
        {
            RectTransform source=null;int owner=step.sourceSlot;
            if(step.source==ScoreSource.Card)
            {
                var view=game.slotRoots[owner].GetComponentInChildren<CardView>();
                if(view!=null) {source=(RectTransform)view.transform;if(jump)Jump(source,true);}
                if(jump && step.extraRedrawDelta==0 && step.copiedCard==null && game.employeeIcons[owner].gameObject.activeInHierarchy)Jump(game.employeeIcons[owner].rectTransform,false);
            }
            else if(step.source==ScoreSource.Employee)
            {source=game.employeeIcons[owner].rectTransform;if(jump && source.gameObject.activeInHierarchy)Jump(source,false);}
            else if(step.source==ScoreSource.Item)source=game.itemIcons[owner*3+step.equipmentSlot].rectTransform;
            return source;
        }
        public void Play(GameController game,ScoreStep step,bool animateSource)
        {
            if(step.source==ScoreSource.Pattern)return;
            var source=Source(game,step,animateSource);
            var shell=game.GetComponent<GameShell>();
            if(step.extraRedrawDelta!=0 && shell!=null && shell.redraws!=null)
            {
                Jump((RectTransform)shell.redraws.transform,false);
                Pair(game,source,shell.redraws,FormatAdd(step.extraRedrawDelta),redrawColor,0);
            }
            if(step.chipsDelta!=0)
                Pair(game,source,shell?.chips,FormatAdd(step.chipsDelta),chipsColor,0);
            if(step.multipliesMultiplier)
                Pair(game,source,shell?.multiplier,"×"+step.multiplierOperand.ToString("0.##"),multiplierColor,step.chipsDelta!=0?60:0);
            else if(step.multiplierDelta!=0)
                Pair(game,source,shell?.multiplier,FormatAdd(step.multiplierDelta),multiplierColor,step.chipsDelta!=0?60:0);
        }
        static string FormatAdd(double value) => (value>=0?"+":"")+value.ToString("0.##");
        void Jump(RectTransform rect,bool card)
        {if(rect==null || poses.ContainsKey(rect))return;StartCoroutine(Bounce(rect,card));}
        IEnumerator Bounce(RectTransform rect,bool card)
        {
            var pose=new Pose{position=rect.anchoredPosition,rotation=rect.localRotation};poses.Add(rect,pose);
            float duration=Mathf.Max(.01f,jumpDuration);
            for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
            {
                if(rect==null)break;float arc=Mathf.Sin(Mathf.PI*elapsed/duration);
                rect.anchoredPosition=pose.position+Vector2.up*(jumpHeight*arc);
                if(card)rect.localRotation=pose.rotation*Quaternion.Euler(0,0,-cardTilt*arc);
                yield return null;
            }
            if(rect!=null) {rect.anchoredPosition=pose.position;rect.localRotation=pose.rotation;}
            poses.Remove(rect);
        }
        void Pair(GameController game,RectTransform source,TMP_Text total,string text,Color color,float offset)
        {
            if(source!=null && source.gameObject.activeInHierarchy)Popup(game,source,text,color,offset);
            if(total!=null)Popup(game,(RectTransform)total.transform,text,color,0);
        }
        void Popup(GameController game,RectTransform target,string value,Color color,float offset)
        {
            var canvas=game.canvas;var root=(RectTransform)canvas.transform;
            var camera=canvas.renderMode==RenderMode.ScreenSpaceOverlay?null:canvas.worldCamera;
            var screen=RectTransformUtility.WorldToScreenPoint(camera,target.TransformPoint(target.rect.center));
            RectTransformUtility.ScreenPointToLocalPointInRectangle(root,screen,camera,out var local);
            var obj=new GameObject("Score Popup",typeof(RectTransform),typeof(TextMeshProUGUI),typeof(CanvasGroup));obj.transform.SetParent(root,false);obj.layer=canvas.gameObject.layer;
            var rect=(RectTransform)obj.transform;rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f);rect.sizeDelta=new Vector2(320,90);
            local+=Vector2.up*(40+offset);local.x=Mathf.Clamp(local.x,root.rect.xMin+160,root.rect.xMax-160);local.y=Mathf.Clamp(local.y,root.rect.yMin+50,root.rect.yMax-50-popupRise);rect.anchoredPosition=local;
            var label=obj.GetComponent<TextMeshProUGUI>();label.font=game.theme.font;label.fontSharedMaterial=game.theme.font.material;label.fontSize=popupFontSize;label.fontStyle=FontStyles.Bold;label.color=color;label.text=value;label.alignment=TextAlignmentOptions.Center;label.raycastTarget=false;
            var group=obj.GetComponent<CanvasGroup>();group.blocksRaycasts=false;group.interactable=false;popups.Add(obj);StartCoroutine(Float(obj,rect,group));
        }
        IEnumerator Float(GameObject obj,RectTransform rect,CanvasGroup group)
        {
            Vector2 start=rect.anchoredPosition;float duration=Mathf.Max(.01f,popupDuration);
            for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
            {if(rect==null)yield break;float t=elapsed/duration;rect.anchoredPosition=start+Vector2.up*(popupRise*t);group.alpha=1-Mathf.SmoothStep(0,1,Mathf.Clamp01((t-.35f)/.65f));yield return null;}
            popups.Remove(obj);if(obj!=null)Destroy(obj);
        }
    }
}
