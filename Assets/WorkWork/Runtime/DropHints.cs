using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    public class DropHints : MonoBehaviour
    {
        public GameController game;
        public Color highlightColor=new Color32(0xFF,0xEF,0xD1,255);
        [Min(.1f)] public float pulsePeriod=.8f;
        [Range(0,1)] public float minAlpha=.15f,maxAlpha=.8f;
        readonly Dictionary<RectTransform,Image> overlays=new Dictionary<RectTransform,Image>();
        readonly List<Image> active=new List<Image>();
        float elapsed;
        public int ActiveCount=>active.Count;
        public void Show(DragToken token)
        {
            Hide();
            if(game==null || game.Session==null || token==null || token.controller!=game || game.IsBusy)return;
            var state=game.Session.State;bool item=false;
            if(token.kind==TokenKind.Developer && game.DeveloperOpen)
            {var def=game.catalog.rules.content.Find(c=>c.id==token.contentId);if(def==null || !ContentRules.CanAcquire(state,def))return;item=def.item;}
            else if(token.kind==TokenKind.Offer)
            {
                var def=game.catalog.rules.content.Find(c=>c.id==token.contentId);
                if(state.phase!=Phase.Shop || def==null || !state.offers.Contains(token.contentId))return;
                item=def.item;
            }
            else if(token.kind==TokenKind.Employee)
            {if(state.phase!=Phase.Playing && state.phase!=Phase.Shop)return;}
            else if(token.kind==TokenKind.Item)
            {if(state.phase!=Phase.Shop && !game.DeveloperOpen)return;item=true;}
            else return;
            if(item)
            {
                for(int i=0;i<18;i++)
                    if(!string.IsNullOrEmpty(state.employees[i/3]) && string.IsNullOrEmpty(state.items[i]))Add((RectTransform)game.itemButtons[i].transform);
            }
            else
            {
                for(int i=0;i<6;i++)if(string.IsNullOrEmpty(state.employees[i]))Add((RectTransform)game.employeeButtons[i].transform);
            }
            ApplyAlpha(maxAlpha);
        }
        void Add(RectTransform target)
        {
            if(target==null || !target.gameObject.activeInHierarchy)return;
            if(!overlays.TryGetValue(target,out var image) || image==null)
            {
                var obj=new GameObject("Empty Slot Highlight",typeof(RectTransform),typeof(Image),typeof(LayoutElement));obj.transform.SetParent(target,false);
                var rect=(RectTransform)obj.transform;rect.anchorMin=Vector2.zero;rect.anchorMax=Vector2.one;rect.offsetMin=rect.offsetMax=Vector2.zero;
                image=obj.GetComponent<Image>();image.raycastTarget=false;obj.GetComponent<LayoutElement>().ignoreLayout=true;
                overlays[target]=image;
            }
            image.gameObject.SetActive(true);active.Add(image);
        }
        void ApplyAlpha(float alpha)
        {
            var color=highlightColor;color.a*=alpha;
            foreach(var image in active)if(image!=null)image.color=color;
        }
        void Update()
        {
            if(active.Count==0)return;
            if(game==null || game.IsBusy){Hide();return;}
            elapsed+=Time.deltaTime;
            float wave=(1+Mathf.Cos(elapsed*Mathf.PI*2/Mathf.Max(.1f,pulsePeriod)))*.5f;
            ApplyAlpha(Mathf.Lerp(minAlpha,maxAlpha,wave));
        }
        public void Hide()
        {
            foreach(var image in active)if(image!=null)image.gameObject.SetActive(false);
            active.Clear();elapsed=0;
        }
        void OnDisable()=>Hide();
        void OnDestroy()
        {
            foreach(var image in overlays.Values)if(image!=null)Destroy(image.gameObject);
            overlays.Clear();
        }
    }
}
