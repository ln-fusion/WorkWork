using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    public enum TokenKind { HandCard, SlotCard, Employee, Item, Offer, Developer }
    public class DragToken : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler, IPointerClickHandler
    {
        public GameController controller;
        public TokenKind kind;
        public int value;
        public string contentId;
        public static DragToken Current;
        GameObject ghost;
        CanvasGroup sourceGroup;
        float sourceAlpha;
        bool sourceBlocksRaycasts;
        Vector2 pointerOffset;
        public GameObject Preview => ghost;
        bool CanDrag()
        {
            if(controller==null || controller.Session==null || controller.IsBusy) return false;
            var state=controller.Session.State;
            if(kind==TokenKind.HandCard || kind==TokenKind.SlotCard) return state.phase==Phase.Playing && GetComponent<CardView>()?.BoundCard!=null;
            if(string.IsNullOrEmpty(contentId)) return false;
            if(kind==TokenKind.Developer)return controller.DeveloperOpen;
            if(kind==TokenKind.Offer) return state.phase==Phase.Shop && state.offers.Contains(contentId);
            if(kind==TokenKind.Item) return state.phase==Phase.Shop || controller.DeveloperOpen;
            return state.phase==Phase.Playing || state.phase==Phase.Shop;
        }
        public void OnBeginDrag(PointerEventData e)
        {
            if(e.button!=PointerEventData.InputButton.Left || !CanDrag()) return;
            controller.detailsTooltip?.Hide();
            if(Current!=null) Current.FinishDrag();
            Current=this;e.eligibleForClick=false;
            var canvasRect=(RectTransform)controller.canvas.transform;
            var sourceCard=GetComponent<CardView>();
            RectTransform sourceRect;
            if(sourceCard!=null)
            {
                var view=Instantiate(controller.cardPrefab,canvasRect);
                view.button.transition=Selectable.Transition.None;view.button.enabled=false;
                view.Bind(sourceCard.BoundCard,controller.theme,false);view.face.color=sourceCard.face.color;
                view.drag.enabled=false;
                ghost=view.gameObject;sourceRect=(RectTransform)transform;
                ((RectTransform)ghost.transform).sizeDelta=sourceRect.rect.size;
            }
            else
            {
                // For shop/staff/equipment, carry its artwork rather than a text placeholder.
                var icon=GetComponentsInChildren<Image>().FindVisibleSprite();
                sourceRect=icon!=null?icon.rectTransform:(RectTransform)transform;
                ghost=new GameObject("Drag Artwork",typeof(RectTransform),typeof(Image));
                ghost.transform.SetParent(canvasRect,false);
                var image=ghost.GetComponent<Image>();image.sprite=icon!=null?icon.sprite:controller.theme.Icon(contentId);image.preserveAspect=true;image.raycastTarget=false;
                ((RectTransform)ghost.transform).sizeDelta=sourceRect.rect.size;
            }
            ghost.name="Drag Preview";
            var rect=(RectTransform)ghost.transform;rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f);
            var canvasScale=canvasRect.lossyScale;var scale=sourceRect.lossyScale;
            rect.localScale=new Vector3(scale.x/canvasScale.x,scale.y/canvasScale.y,1);
            if(sourceCard==null && ContentRules.Definition(controller.catalog.rules,contentId)?.item==false && controller.bangFeedback!=null)
                controller.bangFeedback.Bind(ghost.GetComponent<Image>());
            rect.SetAsLastSibling();
            var previewGroup=ghost.AddComponent<CanvasGroup>();previewGroup.blocksRaycasts=false;previewGroup.interactable=false;
            Vector2 pointer;RectTransformUtility.ScreenPointToLocalPointInRectangle(canvasRect,e.position,e.pressEventCamera,out pointer);
            var center=canvasRect.InverseTransformPoint(sourceRect.TransformPoint(sourceRect.rect.center));
            pointerOffset=new Vector2(center.x,center.y)-pointer;
            sourceGroup=GetComponent<CanvasGroup>();if(sourceGroup==null) sourceGroup=gameObject.AddComponent<CanvasGroup>();
            sourceAlpha=sourceGroup.alpha;sourceBlocksRaycasts=sourceGroup.blocksRaycasts;
            sourceGroup.alpha=0;sourceGroup.blocksRaycasts=false;
            controller.ShowDropHints(this);
            controller.BeginDeploymentTilt(this);
            OnDrag(e);
        }
        public void OnPointerClick(PointerEventData e)
        {
            if(e.button==PointerEventData.InputButton.Right && controller!=null && Current==null)
                controller.ShowInspection(this,e.position);
        }
        public void OnDrag(PointerEventData e)
        {
            if(ghost==null) return;
            Vector2 pointer;
            if(RectTransformUtility.ScreenPointToLocalPointInRectangle((RectTransform)controller.canvas.transform,e.position,e.pressEventCamera,out pointer))
                ((RectTransform)ghost.transform).anchoredPosition=pointer+pointerOffset;
        }
        public void OnEndDrag(PointerEventData e) {e.eligibleForClick=false;FinishDrag();}
        void FinishDrag()
        {
            if(Current==this) {controller?.HideDropHints();controller?.EndDeploymentTilt();Current=null;}
            if(sourceGroup!=null) {sourceGroup.alpha=sourceAlpha;sourceGroup.blocksRaycasts=sourceBlocksRaycasts;sourceGroup=null;}
            if(ghost!=null) {ghost.SetActive(false);Destroy(ghost);ghost=null;}
        }
        void OnDisable() { FinishDrag(); }
    }
    static class DragArtworkLookup
    {
        public static Image FindVisibleSprite(this Image[] images)
        {
            foreach(var image in images) if(image.sprite!=null && image.gameObject.activeInHierarchy) return image;
            return null;
        }
    }
}
