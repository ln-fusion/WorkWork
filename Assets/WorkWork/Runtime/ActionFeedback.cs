using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

namespace WorkWork
{
    public class ActionFeedback : MonoBehaviour
    {
        public RectTransform taskPhone;
        [Min(.01f)] public float settleDuration=.25f,shakeDuration=.35f,popupDuration=.9f;
        public float settleScale=1.12f,patternScale=1.16f,shakeDistance=7,phoneAngle=7,popupRise=45;
        public float moneyFontSize=55,messageFontSize=30;
        public Vector2 moneyPopupOffset=new Vector2(0,28);
        public Color costColor=new Color32(0xAC,0,1,255);
        struct Pose {public Vector2 position;public Vector3 scale;public Quaternion rotation;public Coroutine routine;}
        readonly Dictionary<RectTransform,Pose> poses=new Dictionary<RectTransform,Pose>();
        readonly List<GameObject> popups=new List<GameObject>();
        string previousPattern;
        public void ObservePattern(GameController game,string pattern,bool hasCards)
        {
            bool changed=previousPattern!=null && previousPattern!=pattern;
            previousPattern=pattern;
            if(changed && hasCards && pattern!="无牌型" && !game.IsBusy)
                Pulse(game.GetComponent<GameShell>()?.pattern?.rectTransform,patternScale);
        }
        public void Pulse(RectTransform target,float amount=0)
        {Animate(target,false,false,amount>0?amount:settleScale);}
        public void VibratePhone() {Animate(taskPhone,true,true,1);}
        public void Failure(GameController game,RectTransform target,string reason)
        {
            Animate(target,true,false,1);Popup(game,target,reason,costColor,messageFontSize);
        }
        public void Spend(GameController game,int amount)
        {
            if(amount<=0)return;
            var shell=game.GetComponent<GameShell>();
            Popup(game,shell!=null?shell.shopCash?.rectTransform:null,"-"+amount,costColor,moneyFontSize,true);
        }
        void Animate(RectTransform rect,bool shake,bool phone,float scale)
        {
            if(rect==null || !rect.gameObject.activeInHierarchy)return;
            if(poses.TryGetValue(rect,out var old))
            {StopCoroutine(old.routine);Restore(rect,old);poses.Remove(rect);}
            var pose=new Pose{position=rect.anchoredPosition,scale=rect.localScale,rotation=rect.localRotation};
            poses[rect]=pose;
            pose.routine=StartCoroutine(Tween(rect,pose,shake,phone,scale));poses[rect]=pose;
        }
        IEnumerator Tween(RectTransform rect,Pose pose,bool shake,bool phone,float scale)
        {
            float duration=Mathf.Max(.01f,shake?shakeDuration:settleDuration);
            for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
            {
                if(rect==null){poses.Remove(rect);yield break;}
                float t=elapsed/duration;
                if(shake)
                {
                    float wave=Mathf.Sin(t*Mathf.PI*12)*(1-t);
                    rect.anchoredPosition=pose.position+Vector2.right*(wave*shakeDistance);
                    if(phone)rect.localRotation=pose.rotation*Quaternion.Euler(0,0,wave*phoneAngle);
                }
                else rect.localScale=pose.scale*(1+(scale-1)*Mathf.Sin(Mathf.PI*t)*(1-t));
                yield return null;
            }
            Restore(rect,pose);poses.Remove(rect);
        }
        static void Restore(RectTransform rect,Pose pose)
        {if(rect!=null){rect.anchoredPosition=pose.position;rect.localScale=pose.scale;rect.localRotation=pose.rotation;}}
        void Popup(GameController game,RectTransform target,string value,Color color,float size,bool money=false)
        {
            if(game.canvas==null || target==null)return;
            var root=(RectTransform)game.canvas.transform;
            var obj=new GameObject("Action Popup",typeof(RectTransform),typeof(TextMeshProUGUI),typeof(CanvasGroup));obj.transform.SetParent(root,false);
            var rect=(RectTransform)obj.transform;rect.anchorMin=rect.anchorMax=root.pivot;rect.sizeDelta=new Vector2(620,100);
            var label=obj.GetComponent<TextMeshProUGUI>();label.font=game.theme.font;label.fontSize=size;label.fontStyle=FontStyles.Bold;
            label.color=color;label.text=value;label.alignment=TextAlignmentOptions.Center;label.raycastTarget=false;
            // Currency needs only its actual text width; a full message box pushed it away from the right-side funds display.
            float width=money?Mathf.Min(root.rect.width,Mathf.Max(60,label.GetPreferredValues(value).x+20)):Mathf.Min(620,root.rect.width);
            rect.sizeDelta=new Vector2(width,100);
            Vector2 point=root.InverseTransformPoint(target.TransformPoint(target.rect.center));
            point+=money?moneyPopupOffset:new Vector2(0,45);
            point.x=Mathf.Clamp(point.x,root.rect.xMin+width*.5f,root.rect.xMax-width*.5f);
            point.y=Mathf.Clamp(point.y,root.rect.yMin+50,root.rect.yMax-50-popupRise);rect.anchoredPosition=point;
            var group=obj.GetComponent<CanvasGroup>();group.blocksRaycasts=false;group.interactable=false;
            popups.Add(obj);StartCoroutine(Float(obj,rect,group));
        }
        IEnumerator Float(GameObject obj,RectTransform rect,CanvasGroup group)
        {
            Vector2 start=rect.anchoredPosition;float duration=Mathf.Max(.01f,popupDuration);
            for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
            {
                if(rect==null)yield break;float t=elapsed/duration;
                rect.anchoredPosition=start+Vector2.up*(popupRise*t);group.alpha=1-Mathf.SmoothStep(0,1,Mathf.InverseLerp(.5f,1,t));yield return null;
            }
            popups.Remove(obj);if(obj!=null)Destroy(obj);
        }
        public void Clear()
        {
            StopAllCoroutines();foreach(var pair in poses)Restore(pair.Key,pair.Value);poses.Clear();
            foreach(var obj in popups)if(obj!=null)Destroy(obj);popups.Clear();previousPattern=null;
        }
        void OnDisable()=>Clear();
    }
}
