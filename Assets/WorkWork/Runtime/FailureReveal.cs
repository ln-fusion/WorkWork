using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork
{
    [RequireComponent(typeof(RectTransform))]
    public class FailureReveal : MonoBehaviour
    {
        [Min(.01f)] public float fallDuration=.45f;
        [Min(0)] public float bounceHeight=65;
        [Min(.01f)] public float bounceDuration=.28f;
        [Range(0,5)] public int bounceCount=3;
        [Range(0,1)] public float bounceDecay=.4f;
        public bool IsPlaying {get;private set;}
        RectTransform rect;
        CanvasGroup group;
        Vector2 home;
        bool captured,wasInteractable;
        void OnEnable()
        {
            if(!Application.isPlaying)return;
            rect=(RectTransform)transform;home=rect.anchoredPosition;captured=true;
            group=GetComponent<CanvasGroup>();if(group==null)group=gameObject.AddComponent<CanvasGroup>();
            wasInteractable=group.interactable;group.interactable=false;IsPlaying=true;
            StartCoroutine(Animate());
        }
        IEnumerator Animate()
        {
            var canvas=GetComponentInParent<Canvas>();Vector2 up=Vector2.up;float distance=rect.rect.height;
            if(canvas!=null)
            {
                var frame=(RectTransform)canvas.transform;
                float bottom=float.PositiveInfinity;var corners=new Vector3[4];
                foreach(var graphic in GetComponentsInChildren<Graphic>())
                {
                    if(!graphic.isActiveAndEnabled || graphic.color.a<=0)continue;
                    graphic.rectTransform.GetWorldCorners(corners);
                    foreach(var corner in corners)bottom=Mathf.Min(bottom,frame.InverseTransformPoint(corner).y);
                }
                if(!float.IsPositiveInfinity(bottom))distance=Mathf.Max(0,frame.rect.yMax-bottom)+30;
                up=rect.parent.InverseTransformVector(frame.TransformVector(Vector3.up));
            }
            rect.anchoredPosition=home+up*distance;
            var game=GetComponentInParent<GameController>();
            while(game!=null && game.IsEntering)yield return null;
            float duration=Mathf.Max(.01f,fallDuration);
            for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
            {
                float t=elapsed/duration;rect.anchoredPosition=home+up*(distance*(1-t*t));yield return null;
            }
            rect.anchoredPosition=home;
            for(int bounce=0;bounce<bounceCount;bounce++)
            {
                float height=bounceHeight*Mathf.Pow(bounceDecay,bounce);
                duration=Mathf.Max(.01f,bounceDuration*Mathf.Pow(Mathf.Sqrt(bounceDecay),bounce));
                for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
                {
                    float t=elapsed/duration;
                    rect.anchoredPosition=home+up*(height*4*t*(1-t));yield return null;
                }
                rect.anchoredPosition=home;
            }
            Restore();
        }
        void Restore()
        {
            if(captured)
            {
                if(rect!=null)rect.anchoredPosition=home;
                if(group!=null)group.interactable=wasInteractable;
            }
            captured=false;IsPlaying=false;
        }
        void OnDisable(){StopAllCoroutines();Restore();}
    }
}
