using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    // Presentation only. Card models and reward execution remain owned by GameSession.
    public class EnchantmentFeedback : MonoBehaviour
    {
        [Min(.01f)] public float flightDuration=.2f,settleDuration=.15f,removeDuration=.2f,shiftDuration=.15f;
        [Min(0)] public float cardStagger=.03f;
        [Min(1)] public float landingScale=1.2f;
        public bool IsPlaying {get;private set;}
        public int LastAdded {get;private set;}
        public int LastRemoved {get;private set;}
        GameObject layer;
        readonly List<CardView> touched=new List<CardView>();
        readonly HashSet<CardView> presented=new HashSet<CardView>();
        class Icon
        {
            public CardView view;
            public int oldIndex,newIndex;
            public Image image;
            public Outline glow;
            public float delay;
            public bool added,removed;
        }
        IEnumerable<CardView> Views(GameController game) => game.handRoots.Concat(game.slotRoots)
            .Where(r=>r!=null).SelectMany(r=>r.GetComponentsInChildren<CardView>()).Where(v=>v.BoundCard!=null);
        public Dictionary<int,List<Enchantment>> Capture(GameController game) => Views(game)
            .GroupBy(v=>v.BoundCard.id).ToDictionary(g=>g.Key,g=>g.First().DisplayedEnchantments.ToList());
        public static List<EnchantmentChange> Changes(Dictionary<int,List<Enchantment>> before,IEnumerable<Card> after)
        {
            var changes=new List<EnchantmentChange>();
            foreach(var card in after)
            {
                List<Enchantment> old;
                if(!before.TryGetValue(card.id,out old))continue;
                var current=card.enchantments.Distinct().ToList();
                if(!old.SequenceEqual(current))changes.Add(new EnchantmentChange{cardId=card.id,before=new List<Enchantment>(old),after=current});
            }
            return changes;
        }
        public void Transaction(GameController game,Dictionary<int,List<Enchantment>> before,Vector3 source)
        {
            var changes=Changes(before,game.Session.State.hand.Concat(game.Session.State.slots.Where(c=>c!=null)));
            if(changes.Count>0)StartCoroutine(PlayTransaction(game,changes,source));
        }
        IEnumerator PlayTransaction(GameController game,List<EnchantmentChange> changes,Vector3 source)
        {
            yield return Play(game,changes,source);
            if(game!=null && game.Session!=null)game.Render();
        }
        public void Clear()
        {
            StopAllCoroutines();Finish(true);
        }
        void OnDisable()=>Clear();
        void Finish(bool reset)
        {
            if(reset)
            {
                foreach(var view in presented)if(view!=null)view.ResetPresentedEnchantments();
                presented.Clear();
            }
            else foreach(var view in touched)if(view!=null)view.PresentEnchantments(view.DisplayedEnchantments);
            touched.Clear();if(layer!=null)Destroy(layer);layer=null;IsPlaying=false;
        }
        Vector2 Position(RectTransform rect,RectTransform canvas)
            => canvas.InverseTransformPoint(rect.TransformPoint(rect.rect.center));
        RectTransform Slot(Icon icon,int index) => icon.view.enchantmentIcons[Mathf.Clamp(index,0,icon.view.enchantmentIcons.Length-1)].rectTransform;
        public IEnumerator Play(GameController game,IEnumerable<EnchantmentChange> changes,Vector3 source)
        {
            var views=Views(game).GroupBy(v=>v.BoundCard.id).ToDictionary(g=>g.Key,g=>g.First());
            var batch=changes.Where(c=>views.ContainsKey(c.cardId)).ToArray();
            if(batch.Length==0)yield break;
            Finish(false);LastAdded=LastRemoved=0;IsPlaying=true;
            var canvas=(RectTransform)game.canvas.transform;
            layer=new GameObject("Enchantment Feedback Layer",typeof(RectTransform));layer.transform.SetParent(canvas,false);
            var root=(RectTransform)layer.transform;root.anchorMin=root.anchorMax=root.pivot=new Vector2(.5f,.5f);root.sizeDelta=canvas.rect.size;
            Vector2 origin=canvas.InverseTransformPoint(source);
            var icons=new List<Icon>();float total=0;
            for(int cardIndex=0;cardIndex<batch.Length;cardIndex++)
            {
                var change=batch[cardIndex];var view=views[change.cardId];
                if(view.enchantmentIcons==null || view.enchantmentIcons.Length==0)continue;
                bool removing=change.before.Except(change.after).Any();float delay=cardIndex*Mathf.Max(0,cardStagger);
                foreach(var kind in change.before.Concat(change.after).Distinct())
                {
                    var sprite=game.theme.EnchantmentIcon(kind);if(sprite==null)continue;
                    var obj=new GameObject("Enchantment "+kind,typeof(RectTransform),typeof(CanvasRenderer),typeof(Image),typeof(Outline));obj.transform.SetParent(root,false);
                    var image=obj.GetComponent<Image>();image.sprite=sprite;image.preserveAspect=true;image.raycastTarget=false;
                    var icon=new Icon{view=view,oldIndex=change.before.IndexOf(kind),newIndex=change.after.IndexOf(kind),image=image,glow=obj.GetComponent<Outline>(),delay=delay};
                    icon.added=icon.oldIndex<0;icon.removed=icon.newIndex<0;
                    if(icon.added)LastAdded++;if(icon.removed)LastRemoved++;
                    icon.glow.effectDistance=new Vector2(2,2);icon.glow.effectColor=Color.clear;
                    icons.Add(icon);
                }
                // Keep the model unchanged, and hide its native icons underneath the animated copies.
                view.PresentEnchantments(change.after);view.HideEnchantmentIcons();touched.Add(view);
                presented.RemoveWhere(v=>v==null);presented.Add(view);
                bool adding=change.after.Except(change.before).Any();
                total=Mathf.Max(total,delay+(removing?removeDuration:0)+(adding?Mathf.Max(shiftDuration,flightDuration+settleDuration):shiftDuration));
            }
            for(float elapsed=0;elapsed<total;elapsed+=Time.deltaTime)
            {
                foreach(var icon in icons)
                {
                    if(icon.view==null || icon.image==null)continue;
                    var change=batch.First(c=>c.cardId==icon.view.BoundCard.id);
                    float t=elapsed-icon.delay,remove=change.before.Except(change.after).Any()?Mathf.Max(.01f,removeDuration):0;
                    var target=Slot(icon,icon.removed?icon.oldIndex:icon.newIndex);var rect=icon.image.rectTransform;
                    Vector2 end=Position(target,canvas);var corners=new Vector3[4];target.GetWorldCorners(corners);
                    rect.sizeDelta=new Vector2(Vector3.Distance(canvas.InverseTransformPoint(corners[0]),canvas.InverseTransformPoint(corners[3])),Vector3.Distance(canvas.InverseTransformPoint(corners[0]),canvas.InverseTransformPoint(corners[1])));
                    rect.rotation=target.rotation;float alpha=1,scale=1;
                    if(icon.removed)
                    {
                        float p=Mathf.Clamp01(t/Mathf.Max(.01f,removeDuration));scale=p<.3f?Mathf.Lerp(1,1.15f,p/.3f):Mathf.Lerp(1.15f,0,(p-.3f)/.7f);alpha=1-p;rect.anchoredPosition=end;
                    }
                    else if(icon.added)
                    {
                        float time=t-remove;float p=Mathf.Clamp01(time/Mathf.Max(.01f,flightDuration));
                        rect.anchoredPosition=Vector2.Lerp(origin,end,1-Mathf.Pow(1-p,3))+Vector2.up*(Mathf.Sin(p*Mathf.PI)*15);
                        alpha=time<0?0:1;scale=Mathf.Lerp(.4f,1,p);
                        if(time>=flightDuration){float settle=Mathf.Clamp01((time-flightDuration)/Mathf.Max(.01f,settleDuration));scale=1+(landingScale-1)*Mathf.Sin(settle*Mathf.PI);icon.glow.effectColor=new Color(1,1,1,.65f*Mathf.Sin(settle*Mathf.PI));}
                    }
                    else
                    {
                        float p=Mathf.SmoothStep(0,1,Mathf.Clamp01((t-remove)/Mathf.Max(.01f,shiftDuration)));
                        rect.anchoredPosition=Vector2.Lerp(Position(Slot(icon,icon.oldIndex),canvas),end,p);
                    }
                    rect.localScale=Vector3.one*scale;icon.image.color=new Color(1,1,1,alpha);
                }
                yield return null;
            }
            Finish(false);
        }
    }
}
