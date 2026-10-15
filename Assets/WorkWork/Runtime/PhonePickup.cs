using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace WorkWork
{
    [RequireComponent(typeof(RectTransform))]
    public class PhonePickup : MonoBehaviour
    {
        public RectTransform sourcePhone,phoneGraphic;
        public CanvasGroup backdrop;
        [Min(.01f)] public float duration=.55f;
        public float liftHeight=60,tableTilt=50,tableRotation=-12;
        [Range(.03f,.5f)] public float fallbackScale=.18f;
        public bool IsPlaying {get;private set;}
        struct Pose {public RectTransform rect;public Vector3 position,scale;public Quaternion rotation;}
        readonly List<Pose> poses=new List<Pose>();
        CanvasGroup group;bool captured,wasInteractable;float shadeAlpha;
        void OnEnable()
        {
            if(!Application.isPlaying || phoneGraphic==null)return;
            Canvas.ForceUpdateCanvases();
            var root=(RectTransform)transform;
            group=GetComponent<CanvasGroup>();if(group==null)group=gameObject.AddComponent<CanvasGroup>();
            wasInteractable=group.interactable;group.interactable=false;
            shadeAlpha=backdrop!=null?backdrop.alpha:1;captured=true;
            foreach(Transform child in transform)
            {
                var rect=child as RectTransform;
                if(rect==null || (backdrop!=null && rect==backdrop.transform))continue;
                poses.Add(new Pose{rect=rect,position=rect.localPosition,scale=rect.localScale,rotation=rect.localRotation});
            }
            Vector3 center=root.InverseTransformPoint(phoneGraphic.TransformPoint(phoneGraphic.rect.center));
            Vector3 source=sourcePhone!=null?root.InverseTransformPoint(sourcePhone.TransformPoint(sourcePhone.rect.center)):center+new Vector3(-450,-300,0);
            source.z=center.z;
            float scale=fallbackScale;
            if(sourcePhone!=null)
            {
                float sourceHeight=root.InverseTransformVector(sourcePhone.TransformVector(Vector3.up*sourcePhone.rect.height)).magnitude;
                float finalHeight=root.InverseTransformVector(phoneGraphic.TransformVector(Vector3.up*phoneGraphic.rect.height)).magnitude;
                if(finalHeight>0)scale=Mathf.Clamp(sourceHeight/finalHeight,.06f,.4f);
            }
            IsPlaying=true;StartCoroutine(Animate(center,source,scale));
        }
        IEnumerator Animate(Vector3 center,Vector3 source,float scale)
        {
            float seconds=Mathf.Max(.01f,duration);
            for(float elapsed=0;elapsed<seconds;elapsed+=Time.deltaTime)
            {
                float t=Mathf.Clamp01(elapsed/seconds);
                float move=1-Mathf.Pow(1-Mathf.Clamp01(t/.8f),3);
                float settle=t<.8f?0:Mathf.SmoothStep(0,1,(t-.8f)/.2f);
                float size=t<.8f?Mathf.Lerp(scale,1.025f,move):Mathf.Lerp(1.025f,1,settle);
                var rotation=Quaternion.Slerp(Quaternion.Euler(tableTilt,0,tableRotation),Quaternion.identity,move);
                var position=Vector3.Lerp(source,center,move)+Vector3.up*(Mathf.Sin(Mathf.PI*move)*liftHeight);
                foreach(var pose in poses)
                {
                    if(pose.rect==null)continue;
                    pose.rect.localPosition=position+rotation*((pose.position-center)*size);
                    pose.rect.localRotation=rotation*pose.rotation;pose.rect.localScale=pose.scale*size;
                }
                if(backdrop!=null)backdrop.alpha=shadeAlpha*Mathf.SmoothStep(0,1,t);
                yield return null;
            }
            Restore();
        }
        void Restore()
        {
            if(captured)
            {
                foreach(var pose in poses)if(pose.rect!=null){pose.rect.localPosition=pose.position;pose.rect.localScale=pose.scale;pose.rect.localRotation=pose.rotation;}
                if(backdrop!=null)backdrop.alpha=shadeAlpha;
                if(group!=null)group.interactable=wasInteractable;
            }
            poses.Clear();captured=false;IsPlaying=false;
        }
        void OnDisable(){StopAllCoroutines();Restore();}
    }
}
