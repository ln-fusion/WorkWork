using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    public class CardDeletionFeedback : MonoBehaviour
    {
        [Min(.01f)] public float slashDuration=.1f,splitDuration=.4f;
        [Min(0)] public float separation=40,sideways=22,rotation=12,cardStagger=.04f;
        public Color slashColor=new Color(1,.85f,.65f,1);
        public bool IsPlaying {get;private set;}
        public int LastDeletedCount {get;private set;}
        readonly HashSet<int> deleted=new HashSet<int>();
        readonly Dictionary<CanvasGroup,float> originals=new Dictionary<CanvasGroup,float>();
        GameObject layer;
        class Cut
        {
            public RectTransform top,bottom,slash;
            public CanvasGroup pieces,light;
            public float halfOffset,delay;
        }
        public bool IsDeleted(int id)=>deleted.Contains(id);
        public void Clear()
        {
            StopAllCoroutines();RemoveLayer();
            foreach(var pair in originals)if(pair.Key!=null)pair.Key.alpha=pair.Value;
            originals.Clear();deleted.Clear();
        }
        void OnDisable()=>Clear();
        void RemoveLayer(){if(layer!=null)Destroy(layer);layer=null;IsPlaying=false;}
        RectTransform Rect(string name,Transform parent,Vector2 size)
        {
            var obj=new GameObject(name,typeof(RectTransform));obj.transform.SetParent(parent,false);
            var rect=(RectTransform)obj.transform;rect.sizeDelta=size;return rect;
        }
        RectTransform Half(GameController game,RectTransform root,Card card,Vector2 size,int direction)
        {
            var clip=Rect(direction>0?"Top Half":"Bottom Half",root,new Vector2(size.x,size.y*.5f));clip.anchoredPosition=Vector2.up*(direction*size.y*.25f);
            clip.gameObject.AddComponent<RectMask2D>();
            var view=Instantiate(game.cardPrefab,clip);view.Bind(card,game.theme,false);view.button.enabled=false;view.drag.enabled=false;
            var rect=(RectTransform)view.transform;rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f);rect.sizeDelta=size;
            rect.anchoredPosition=Vector2.down*(direction*size.y*.25f);return clip;
        }
        public IEnumerator Play(GameController game,IEnumerable<Card> cards,RectTransform source)
        {
            var batch=cards.Where(c=>c!=null && !deleted.Contains(c.id)).GroupBy(c=>c.id).Select(g=>g.First()).ToArray();if(batch.Length==0)yield break;
            var views=game.handRoots.Concat(game.slotRoots).SelectMany(r=>r.GetComponentsInChildren<CardView>()).Where(v=>v.BoundCard!=null)
                .GroupBy(v=>v.BoundCard.id).ToDictionary(g=>g.Key,g=>g.First());
            while(game.scoreFeedback!=null && batch.Any(c=>views.ContainsKey(c.id) && game.scoreFeedback.IsBouncing((RectTransform)views[c.id].transform)))yield return null;
            RemoveLayer();IsPlaying=true;LastDeletedCount=batch.Length;
            layer=new GameObject("Card Deletion Layer",typeof(RectTransform),typeof(CanvasGroup));layer.transform.SetParent(game.canvas.transform,false);
            var layerGroup=layer.GetComponent<CanvasGroup>();layerGroup.blocksRaycasts=false;layerGroup.interactable=false;
            var canvas=(RectTransform)game.canvas.transform;var cuts=new List<Cut>();
            for(int index=0;index<batch.Length;index++)
            {
                var card=batch[index].Copy();CardView original;bool visible=views.TryGetValue(card.id,out original);
                var target=visible?(RectTransform)original.transform:source;
                if(visible)
                {
                    card.rank=original.DisplayedRank;card.suit=original.DisplayedSuit;card.enchantments=original.DisplayedEnchantments.ToList();
                    var group=original.GetComponent<CanvasGroup>();if(group==null)group=original.gameObject.AddComponent<CanvasGroup>();
                    if(!originals.ContainsKey(group))originals.Add(group,group.alpha);group.alpha=0;
                }
                deleted.Add(card.id);
                var size=visible?((RectTransform)original.transform).rect.size:game.CardSize;
                var root=Rect("Cut Card",layer.transform,size);root.position=target.TransformPoint(target.rect.center);root.rotation=target.rotation;
                if(visible)root.localScale=new Vector3(target.lossyScale.x/canvas.lossyScale.x,target.lossyScale.y/canvas.lossyScale.y,1);
                else root.anchoredPosition+=Vector2.right*((index-(batch.Length-1)*.5f)*18);
                var pieces=Rect("Pieces",root,size);var groupPieces=pieces.gameObject.AddComponent<CanvasGroup>();
                var top=Half(game,pieces,card,size,1);var bottom=Half(game,pieces,card,size,-1);
                var slash=Rect("Slash",root,new Vector2(size.x*1.5f,8));slash.pivot=new Vector2(0,.5f);slash.anchoredPosition=Vector2.left*(size.x*.75f);
                var light=slash.gameObject.AddComponent<CanvasGroup>();
                foreach(bool core in new[]{false,true})
                {
                    var line=Rect(core?"White Blade":"Blade Glow",slash,new Vector2(size.x*1.5f,core?2:8));line.anchorMin=line.anchorMax=new Vector2(0,.5f);line.pivot=new Vector2(0,.5f);
                    var image=line.gameObject.AddComponent<Image>();image.color=core?Color.white:slashColor;image.raycastTarget=false;
                }
                cuts.Add(new Cut{top=top,bottom=bottom,slash=slash,pieces=groupPieces,light=light,halfOffset=size.y*.25f,delay=index*Mathf.Max(0,cardStagger)});
            }
            float slashTime=Mathf.Max(.01f,slashDuration),splitTime=Mathf.Max(.01f,splitDuration),total=slashTime+splitTime+(batch.Length-1)*Mathf.Max(0,cardStagger);
            for(float elapsed=0;elapsed<total;elapsed+=Time.deltaTime)
            {
                foreach(var cut in cuts)
                {
                    float time=elapsed-cut.delay,sweep=Mathf.Clamp01(time/slashTime),p=Mathf.Clamp01((time-slashTime)/splitTime);
                    cut.slash.localScale=new Vector3(sweep,1,1);cut.light.alpha=time<0?0:1-Mathf.Clamp01((time-slashTime)/(splitTime*.4f));
                    cut.pieces.alpha=time<0?0:1-Mathf.SmoothStep(0,1,p);
                    cut.top.anchoredPosition=new Vector2(sideways*p,cut.halfOffset+separation*p);cut.bottom.anchoredPosition=new Vector2(-sideways*p,-cut.halfOffset-separation*p);
                    cut.top.localRotation=Quaternion.Euler(0,0,-rotation*p);cut.bottom.localRotation=Quaternion.Euler(0,0,rotation*p);
                }
                yield return null;
            }
            RemoveLayer();
        }
    }
}
