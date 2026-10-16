using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    public class CardFaceFeedback : MonoBehaviour
    {
        [Min(.01f)] public float disappearDuration=.12f,appearDuration=.16f,settleDuration=.1f;
        [Min(1)] public float overshootScale=1.15f;
        [Min(0)] public float jumpHeight=6;
        public bool IsPlaying {get;private set;}
        public int LastChangedCards {get;private set;}
        class GraphicPose {public Graphic graphic;public Vector3 scale;public float alpha;}
        class Change
        {
            public CardView view;
            public CardFaceChange change;
            public Vector2 position;
            public List<GraphicPose> graphics=new List<GraphicPose>();
        }
        readonly List<Change> active=new List<Change>();
        readonly HashSet<CardView> presented=new HashSet<CardView>();
        public static float AppearanceScale(float progress,float overshoot)
            => Mathf.Lerp(0,Mathf.Max(1,overshoot),1-Mathf.Pow(1-Mathf.Clamp01(progress),3));
        public void Clear(){StopAllCoroutines();Finish(true);}
        void OnDisable()=>Clear();
        void Finish(bool reset)
        {
            if(reset){foreach(var view in presented)if(view!=null)view.ResetPresentedFace();presented.Clear();}
            foreach(var item in active)if(item.view!=null)
            {
                ((RectTransform)item.view.transform).anchoredPosition=item.position;
                foreach(var pose in item.graphics)if(pose.graphic!=null)
                {pose.graphic.rectTransform.localScale=pose.scale;var color=pose.graphic.color;color.a=pose.alpha;pose.graphic.color=color;}
            }
            active.Clear();
            IsPlaying=false;
        }
        public IEnumerator Play(GameController game,IEnumerable<CardFaceChange> changes)
        {
            var views=game.handRoots.Concat(game.slotRoots).Where(r=>r!=null).SelectMany(r=>r.GetComponentsInChildren<CardView>())
                .Where(v=>v.BoundCard!=null).GroupBy(v=>v.BoundCard.id).ToDictionary(g=>g.Key,g=>g.First());
            var batch=changes.Where(c=>views.ContainsKey(c.cardId) && (c.beforeRank!=c.afterRank || c.beforeSuit!=c.afterSuit)).ToArray();
            if(batch.Length==0)yield break;
            // Avoid two animation drivers writing the same card position at fast scoring speeds.
            while(game.scoreFeedback!=null && batch.Any(c=>views[c.cardId]!=null && game.scoreFeedback.IsBouncing((RectTransform)views[c.cardId].transform)))yield return null;
            Finish(false);IsPlaying=true;LastChangedCards=batch.Length;presented.RemoveWhere(v=>v==null);
            foreach(var change in batch)
            {
                var view=views[change.cardId];var item=new Change{view=view,change=change,position=((RectTransform)view.transform).anchoredPosition};
                bool colorChanges=game.theme.suitColors[(int)change.beforeSuit]!=game.theme.suitColors[(int)change.afterSuit];
                var graphics=new List<Graphic>();if(change.beforeRank!=change.afterRank || colorChanges)graphics.Add(view.rankText);
                if(change.beforeSuit!=change.afterSuit)graphics.Add(view.suitIcon);
                foreach(var graphic in graphics)if(graphic!=null)item.graphics.Add(new GraphicPose{graphic=graphic,scale=graphic.rectTransform.localScale,alpha=graphic.color.a});
                view.PresentFace(change.beforeRank,change.beforeSuit);active.Add(item);presented.Add(view);
            }
            float disappear=Mathf.Max(.01f,disappearDuration),appear=Mathf.Max(.01f,appearDuration),settle=Mathf.Max(.01f,settleDuration);
            float duration=disappear+appear+settle;bool swapped=false;
            for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
            {
                if(!swapped && elapsed>=disappear)
                {foreach(var item in active)if(item.view!=null)item.view.PresentFace(item.change.afterRank,item.change.afterSuit);swapped=true;}
                float scale,alpha;
                if(elapsed<disappear){float t=Mathf.SmoothStep(0,1,elapsed/disappear);scale=alpha=1-t;}
                else if(elapsed<disappear+appear){float t=(elapsed-disappear)/appear;scale=AppearanceScale(t,overshootScale);alpha=Mathf.SmoothStep(0,1,t);}
                else {float t=Mathf.SmoothStep(0,1,(elapsed-disappear-appear)/settle);scale=Mathf.Lerp(Mathf.Max(1,overshootScale),1,t);alpha=1;}
                foreach(var item in active)if(item.view!=null)
                {
                    ((RectTransform)item.view.transform).anchoredPosition=item.position+Vector2.up*(Mathf.Sin(Mathf.PI*elapsed/duration)*jumpHeight);
                    foreach(var pose in item.graphics)if(pose.graphic!=null)
                    {pose.graphic.rectTransform.localScale=pose.scale*scale;var color=pose.graphic.color;color.a=pose.alpha*alpha;pose.graphic.color=color;}
                }
                yield return null;
            }
            foreach(var item in active)if(item.view!=null)item.view.PresentFace(item.change.afterRank,item.change.afterSuit);
            Finish(false);
        }
    }
}
