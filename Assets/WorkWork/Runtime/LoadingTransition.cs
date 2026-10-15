using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork
{
    public class LoadingTransition : MonoBehaviour
    {
        public Image face;
        public Sprite front,back;
        public CanvasGroup group;
        [Min(0)] public float fadeInDuration=.18f,frontHold=.15f,flipDuration=.7f,backHold=.15f,fadeOutDuration=.22f;
        public bool IsPlaying {get;private set;}
        bool ready;Exception loadError;
        public bool Play(Func<IEnumerator> load,Action completed,Action<Exception> failed=null,Action reveal=null)
        {
            if(IsPlaying)return false;
            IsPlaying=true;ready=false;loadError=null;
            gameObject.SetActive(true);transform.SetAsLastSibling();
            group.alpha=0;group.blocksRaycasts=true;group.interactable=true;
            face.sprite=front;face.rectTransform.localRotation=Quaternion.identity;
            StartCoroutine(Run(load,completed,failed,reveal));return true;
        }
        IEnumerator Run(Func<IEnumerator> load,Action completed,Action<Exception> failed,Action reveal)
        {
            yield return Fade(0,1,fadeInDuration);
            StartCoroutine(Load(load));
            yield return Pause(frontHold);
            while(!ready)yield return null;
            if(loadError==null)
            {
                try {reveal?.Invoke();}catch(Exception error){loadError=error;}
            }
            yield return Flip(0,90,flipDuration*.5f);
            face.sprite=back;
            yield return Flip(-90,0,flipDuration*.5f);
            yield return Pause(backHold);
            yield return Fade(1,0,fadeOutDuration);
            var resultError=loadError;ResetState();gameObject.SetActive(false);
            if(resultError==null)completed?.Invoke();else failed?.Invoke(resultError);
        }
        IEnumerator Load(Func<IEnumerator> load)
        {
            var stack=new Stack<IEnumerator>();
            try {var routine=load?.Invoke();if(routine!=null)stack.Push(routine);}
            catch(Exception error){loadError=error;}
            while(stack.Count>0 && loadError==null)
            {
                var routine=stack.Peek();bool next=false;object current=null;
                try {next=routine.MoveNext();if(next)current=routine.Current;}
                catch(Exception error){loadError=error;}
                if(loadError!=null)break;
                if(!next){stack.Pop();continue;}
                if(current is IEnumerator nested)stack.Push(nested);
                else yield return current;
            }
            ready=true;
        }
        IEnumerator Fade(float from,float to,float duration)
        {
            for(float elapsed=0;elapsed<duration;elapsed+=Time.unscaledDeltaTime)
            {group.alpha=Mathf.Lerp(from,to,Mathf.SmoothStep(0,1,elapsed/duration));yield return null;}
            group.alpha=to;
        }
        IEnumerator Flip(float from,float to,float duration)
        {
            for(float elapsed=0;elapsed<duration;elapsed+=Time.unscaledDeltaTime)
            {
                float t=Mathf.SmoothStep(0,1,elapsed/duration);
                face.rectTransform.localRotation=Quaternion.Euler(0,Mathf.Lerp(from,to,t),0);yield return null;
            }
            face.rectTransform.localRotation=Quaternion.Euler(0,to,0);
        }
        IEnumerator Pause(float duration)
        {for(float elapsed=0;elapsed<duration;elapsed+=Time.unscaledDeltaTime)yield return null;}
        void ResetState()
        {
            IsPlaying=false;ready=false;loadError=null;
            if(face!=null){face.sprite=front;face.rectTransform.localRotation=Quaternion.identity;}
            if(group!=null){group.alpha=0;group.blocksRaycasts=false;group.interactable=false;}
        }
        public void Cancel(){StopAllCoroutines();ResetState();gameObject.SetActive(false);}
        void OnDisable(){StopAllCoroutines();ResetState();}
    }
}
