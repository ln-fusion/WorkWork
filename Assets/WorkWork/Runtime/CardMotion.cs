using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
namespace WorkWork
{
    public class CardMotion : MonoBehaviour
    {
        public Vector2 entryPoint=new Vector2(.5f,1.18f);
        public float flightDuration=.42f, settleDuration=.16f, stagger=.065f, tossAngle=18, arcHeight=35;
        [Tooltip("飞行阶段牌底高于最终牌底的最低距离；0表示不低于最终牌底。整理阶段逐渐归零，最终位置不变。")]
        [Min(0)] public float landingLift=0;
        class Flight
        {
            public RectTransform ghost;
            public CanvasGroup original;
            public float alpha;
            public Vector3 home;
            public Quaternion rotation;
            public float bottom;
            public bool sounded;
        }
        readonly List<Flight> flights=new List<Flight>();
        GameObject layer;
        GameObject generatedSources;
        void ClearFlights()
        {
            foreach(var flight in flights)if(flight.original!=null)flight.original.alpha=flight.alpha;
            flights.Clear();if(layer!=null)Destroy(layer);layer=null;
        }
        public void Clear(){ClearFlights();if(generatedSources!=null)Destroy(generatedSources);generatedSources=null;}
        void OnDisable() => Clear();
        public IEnumerator FlyGenerated(GameController game,IEnumerable<WorkWork.Core.Card> cards,RectTransform source)
        {
            Clear();var batch=cards.Where(c=>c!=null).ToArray();if(batch.Length==0)yield break;
            generatedSources=new GameObject("Generated Card Sources",typeof(RectTransform),typeof(CanvasGroup));generatedSources.transform.SetParent(game.canvas.transform,false);
            var hidden=generatedSources.GetComponent<CanvasGroup>();hidden.alpha=0;hidden.blocksRaycasts=false;hidden.interactable=false;
            var views=new List<CardView>();
            try
            {
                foreach(var card in batch)
                {
                    var view=Instantiate(game.cardPrefab,generatedSources.transform);view.Bind(card,game.theme,false);view.button.enabled=false;view.drag.enabled=false;
                    var rect=(RectTransform)view.transform;rect.sizeDelta=game.CardSize;rect.position=source.TransformPoint(source.rect.center);rect.rotation=source.rotation;
                    views.Add(view);
                }
                yield return Fly(game,views,false,false);
            }
            finally{if(generatedSources!=null)Destroy(generatedSources);generatedSources=null;}
        }
        public IEnumerator Fly(GameController game,IEnumerable<CardView> cards,bool drawing,bool hideOriginal=true,WorkWork.Core.Card copiedCard=null)
        {
            ClearFlights();var views=cards.Where(v=>v!=null && v.BoundCard!=null).ToArray();if(views.Length==0)yield break;
            var canvas=(RectTransform)game.canvas.transform;
            layer=new GameObject("Card Flight Layer",typeof(RectTransform));layer.transform.SetParent(canvas,false);
            var holder=(RectTransform)layer.transform;holder.anchorMin=Vector2.zero;holder.anchorMax=Vector2.one;holder.offsetMin=holder.offsetMax=Vector2.zero;
            var origin=canvas.TransformPoint(new Vector3(Mathf.LerpUnclamped(canvas.rect.xMin,canvas.rect.xMax,entryPoint.x),Mathf.LerpUnclamped(canvas.rect.yMin,canvas.rect.yMax,entryPoint.y),0));
            foreach(var view in views)
            {
                var source=(RectTransform)view.transform;
                var clone=Instantiate(game.cardPrefab,holder);clone.Bind(copiedCard??view.BoundCard,game.theme,false);clone.button.enabled=false;clone.drag.enabled=false;
                var ghost=(RectTransform)clone.transform;ghost.sizeDelta=source.rect.size;
                ghost.localScale=new Vector3(source.lossyScale.x/holder.lossyScale.x,source.lossyScale.y/holder.lossyScale.y,1);
                ghost.position=source.position;ghost.rotation=source.rotation;
                var group=clone.GetComponent<CanvasGroup>();if(group==null)group=clone.gameObject.AddComponent<CanvasGroup>();group.alpha=1;group.blocksRaycasts=false;group.interactable=false;
                CanvasGroup original=null;
                if(hideOriginal){original=view.GetComponent<CanvasGroup>();if(original==null)original=view.gameObject.AddComponent<CanvasGroup>();}
                flights.Add(new Flight{ghost=ghost,original=original,alpha=original!=null?original.alpha:1,home=source.position,rotation=source.rotation,bottom=Bottom(source,canvas)});
                if(original!=null)original.alpha=0;
            }
            float flightTime=Mathf.Max(.01f,flightDuration),settle=Mathf.Max(0,settleDuration),spacing=Mathf.Max(0,stagger);
            float duration=flightTime+(drawing?settle:0),total=duration+spacing*(flights.Count-1);
            for(float elapsed=0;elapsed<total;elapsed+=Time.deltaTime)
            {
                for(int i=0;i<flights.Count;i++)
                {
                    var f=flights[i];if(f.ghost==null)continue;
                    float time=elapsed-i*spacing,sign=i%2==0?1:-1;
                    if(drawing && time>=0 && !f.sounded){f.sounded=true;if(game.sounds!=null)game.sounds.Play(game.sounds.deal);}
                    if(!drawing){f.ghost.GetComponent<CanvasGroup>().alpha=time<0?0:1;if(time<0)continue;}
                    float t=Mathf.Clamp01(time/flightTime),ease=drawing?1-Mathf.Pow(1-t,3):t*t;
                    float lift=Mathf.Max(0,landingLift);
                    var landing=f.home+canvas.TransformVector(new Vector3(sign*12,lift,0));
                    if(drawing)
                    {
                        f.ghost.position=Vector3.Lerp(origin,landing,ease)+canvas.TransformVector(Vector3.up*(Mathf.Sin(Mathf.PI*t)*arcHeight));
                        f.ghost.rotation=f.rotation*Quaternion.Euler(0,0,Mathf.Lerp(sign*tossAngle,sign*3,ease));
                        float finish=0;
                        if(time>=flightTime)
                        {finish=settle<=0?1:Mathf.SmoothStep(0,1,(time-flightTime)/settle);f.ghost.position=Vector3.Lerp(landing,f.home,finish);f.ghost.rotation=Quaternion.Slerp(f.rotation*Quaternion.Euler(0,0,sign*3),f.rotation,finish);}
                        // Bound the actual rotated card edge, not just its centre/pivot.
                        float correction=f.bottom+lift*(1-finish)-Bottom(f.ghost,canvas);
                        if(correction>0)f.ghost.position+=canvas.TransformVector(Vector3.up*correction);
                    }
                    else
                    {f.ghost.position=Vector3.Lerp(f.home,origin,ease);f.ghost.rotation=f.rotation*Quaternion.Euler(0,0,sign*tossAngle*ease);}
                }
                yield return null;
            }
            ClearFlights();
        }
        static float Bottom(RectTransform rect,RectTransform canvas)
        {
            var corners=new Vector3[4];rect.GetWorldCorners(corners);
            float bottom=float.PositiveInfinity;
            for(int i=0;i<4;i++)bottom=Mathf.Min(bottom,canvas.InverseTransformPoint(corners[i]).y);
            return bottom;
        }
    }
}
