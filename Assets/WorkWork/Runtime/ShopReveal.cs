using System.Collections;
using UnityEngine;
using UnityEngine.UI;
namespace WorkWork
{
    [RequireComponent(typeof(RectTransform))]
    public class ShopReveal : MonoBehaviour
    {
        [Min(0)] public float duration=.45f;
        [Min(0)] public float retractDuration=.35f;
        [Tooltip("0为自动从画面下方移出；正数指定滑出距离。")]
        [Min(0)] public float slideDistance;
        public bool IsPlaying {get;private set;}
        RectTransform rect;
        CanvasGroup group;
        Vector2 home;
        bool captured,wasInteractable,wasBlocking;
        void OnEnable()
        {
            if(!Application.isPlaying)return;
            Capture();StartCoroutine(Reveal());
        }
        void Capture()
        {
            rect=(RectTransform)transform;home=rect.anchoredPosition;captured=true;
            group=GetComponent<CanvasGroup>();if(group==null)group=gameObject.AddComponent<CanvasGroup>();
            wasInteractable=group.interactable;wasBlocking=group.blocksRaycasts;
            group.interactable=false;group.blocksRaycasts=false;IsPlaying=true;
        }
        Vector2 HiddenOffset()
        {
            var canvas=GetComponentInParent<Canvas>();var parent=rect.parent;
            float distance=slideDistance;Vector3 offset;
            if(canvas!=null)
            {
                var frame=(RectTransform)canvas.transform;
                if(distance<=0)
                {
                    float top=float.NegativeInfinity;var corners=new Vector3[4];
                    foreach(var graphic in GetComponentsInChildren<Graphic>())
                    {
                        if(!graphic.isActiveAndEnabled || graphic.color.a<=0)continue;
                        graphic.rectTransform.GetWorldCorners(corners);
                        foreach(var corner in corners)top=Mathf.Max(top,frame.InverseTransformPoint(corner).y);
                    }
                    distance=float.IsNegativeInfinity(top)?rect.rect.height:Mathf.Max(0,top-frame.rect.yMin)+30;
                }
                offset=parent.InverseTransformVector(frame.TransformVector(Vector3.down*distance));
            }
            else offset=Vector3.down*(distance>0?distance:rect.rect.height);
            return offset;
        }
        IEnumerator Reveal()
        {
            var start=home+HiddenOffset();rect.anchoredPosition=start;
            var game=GetComponentInParent<GameController>();
            while(game!=null && game.IsEntering)yield return null;
            for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
            {float t=Mathf.Clamp01(elapsed/duration);rect.anchoredPosition=Vector2.Lerp(start,home,1-Mathf.Pow(1-t,3));yield return null;}
            Restore();
        }
        public IEnumerator Retract()
        {
            if(IsPlaying || !gameObject.activeInHierarchy)yield break;
            Capture();var end=home+HiddenOffset();
            for(float elapsed=0;elapsed<retractDuration;elapsed+=Time.deltaTime)
            {
                if(!captured)yield break;
                float t=Mathf.Clamp01(elapsed/retractDuration);
                rect.anchoredPosition=Vector2.Lerp(home,end,t*t*t);yield return null;
            }
            if(!captured)yield break;
            rect.anchoredPosition=end;
            gameObject.SetActive(false); // OnDisable restores the saved layout while hidden.
        }
        public void CancelAnimation(){StopAllCoroutines();Restore();}
        void Restore()
        {
            if(captured)
            {
                if(rect!=null)rect.anchoredPosition=home;
                if(group!=null){group.interactable=wasInteractable;group.blocksRaycasts=wasBlocking;}
            }
            captured=false;IsPlaying=false;
        }
        void OnDisable()=>CancelAnimation();
    }
}
