using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;
namespace WorkWork
{
    public class ConditionFeedback : MonoBehaviour
    {
        [Min(.01f)] public float duration=.2f;
        [Min(0)] public float borderWidth=3;
        [Range(0,1)] public float fillAlpha=.14f;
        public Color highlightColor=new Color(1,.85f,.4f,1);
        public bool IsPlaying {get;private set;}
        public int LastTargetCount {get;private set;}
        GameObject layer;
        class Glow {public RectTransform target,rect;public CanvasGroup group;}
        public static bool HasTargets(ScoreStep step)=>(step.linkedCardIds?.Count??0)+(step.linkedEmployeeSlots?.Count??0)+(step.linkedItemSlots?.Count??0)+(step.linkedEmptySlots?.Count??0)>0;
        void RemoveLayer(){if(layer!=null)Destroy(layer);layer=null;IsPlaying=false;}
        public void Clear(){StopAllCoroutines();RemoveLayer();}
        void OnDisable()=>Clear();
        public IEnumerator Play(GameController game,ScoreStep step)
        {
            var targets=new HashSet<RectTransform>();
            var cards=game.handRoots.Concat(game.slotRoots).SelectMany(r=>r.GetComponentsInChildren<CardView>()).Where(v=>v.BoundCard!=null).ToArray();
            foreach(int id in step.linkedCardIds??new List<int>())
            {
                var view=cards.FirstOrDefault(v=>v.BoundCard.id==id);
                if(view!=null && (game.cardDeletionFeedback==null || !game.cardDeletionFeedback.IsDeleted(id)))targets.Add((RectTransform)view.transform);
            }
            foreach(int i in step.linkedEmployeeSlots??new List<int>())if(i>=0 && i<game.employeeIcons.Length && game.employeeIcons[i].gameObject.activeInHierarchy)targets.Add(game.employeeIcons[i].rectTransform);
            foreach(int i in step.linkedItemSlots??new List<int>())if(i>=0 && i<game.itemIcons.Length && game.itemIcons[i].gameObject.activeInHierarchy)targets.Add(game.itemIcons[i].rectTransform);
            foreach(int i in step.linkedEmptySlots??new List<int>())if(i>=0 && i<game.slotRoots.Length)targets.Add(game.slotRoots[i]);
            RemoveLayer();LastTargetCount=targets.Count;if(targets.Count==0)yield break;IsPlaying=true;
            layer=new GameObject("Condition Highlight Layer",typeof(RectTransform),typeof(CanvasGroup));layer.transform.SetParent(game.canvas.transform,false);
            var group=layer.GetComponent<CanvasGroup>();group.blocksRaycasts=false;group.interactable=false;
            var canvas=(RectTransform)game.canvas.transform;var glows=new List<Glow>();
            foreach(var target in targets)
            {
                var obj=new GameObject("Condition Match",typeof(RectTransform),typeof(CanvasGroup),typeof(Image));obj.transform.SetParent(layer.transform,false);
                var rect=(RectTransform)obj.transform;var fill=obj.GetComponent<Image>();fill.color=new Color(highlightColor.r,highlightColor.g,highlightColor.b,fillAlpha);fill.raycastTarget=false;
                for(int side=0;side<4;side++)
                {
                    var line=new GameObject("Edge",typeof(RectTransform),typeof(Image));line.transform.SetParent(rect,false);var r=(RectTransform)line.transform;
                    bool horizontal=side<2;float edge=side%2;
                    r.anchorMin=horizontal?new Vector2(0,edge):new Vector2(edge,0);r.anchorMax=horizontal?new Vector2(1,edge):new Vector2(edge,1);
                    r.sizeDelta=horizontal?new Vector2(0,borderWidth):new Vector2(borderWidth,0);r.anchoredPosition=Vector2.zero;
                    var image=line.GetComponent<Image>();image.color=highlightColor;image.raycastTarget=false;
                }
                glows.Add(new Glow{target=target,rect=rect,group=obj.GetComponent<CanvasGroup>()});
            }
            float time=Mathf.Max(.01f,duration);
            for(float elapsed=0;elapsed<time;elapsed+=Time.deltaTime)
            {
                foreach(var glow in glows)
                {
                    if(glow.target==null)continue;var corners=new Vector3[4];glow.target.GetWorldCorners(corners);
                    glow.rect.position=glow.target.TransformPoint(glow.target.rect.center);glow.rect.rotation=glow.target.rotation;
                    glow.rect.sizeDelta=new Vector2(Vector3.Distance(canvas.InverseTransformPoint(corners[0]),canvas.InverseTransformPoint(corners[3])),Vector3.Distance(canvas.InverseTransformPoint(corners[0]),canvas.InverseTransformPoint(corners[1])));
                    glow.group.alpha=Mathf.Sin(Mathf.PI*elapsed/time);
                }
                yield return null;
            }
            RemoveLayer();
        }
    }
}
