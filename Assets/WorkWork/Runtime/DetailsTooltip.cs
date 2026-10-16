using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork
{
    public class DetailsTooltip : MonoBehaviour
    {
        public TMP_Text nameText,effectText;
        public RectTransform panel;
        public float preferredWidth=440;
        GameController game;
        DragToken owner;
        Vector2 screenPoint;
        ScrollRect bodyScroll;
        public bool IsVisible => gameObject.activeSelf;
        public void Initialize(GameController controller) {game=controller;Hide();}
        public void Hide() {owner=null;gameObject.SetActive(false);}
        public void Show(DragToken source,string title,string effects,Vector2 position)
        {
            owner=source;screenPoint=position;
            gameObject.SetActive(true);transform.SetAsLastSibling();
            Layout(title,effects);
        }
        void Update()
        {
            if(Input.GetMouseButtonDown(0) || Input.GetMouseButtonDown(1)) {Hide();return;}
            if(owner==null || !owner.isActiveAndEnabled || game==null || !game.TryGetInspection(owner,out var title,out var effects)) {Hide();return;}
            if(nameText.text!=title || effectText.text!=effects) Layout(title,effects);
        }
        void Layout(string title,string effects)
        {
            var canvasRect=(RectTransform)game.canvas.transform;
            bool named=!string.IsNullOrEmpty(title);
            nameText.text=title;nameText.gameObject.SetActive(named);effectText.text=effects;
            nameText.font=effectText.font=game.theme.font;
            nameText.fontSharedMaterial=effectText.fontSharedMaterial=game.theme.font.material;
            float width=Mathf.Min(preferredWidth,canvasRect.rect.width-16);
            float textWidth=width-80,bodyY=named?88:36;
            float bodyHeight=effectText.GetPreferredValues(effects,textWidth,Mathf.Infinity).y+8;
            float height=Mathf.Min(canvasRect.rect.height-16,bodyY+bodyHeight+36);
            panel.sizeDelta=new Vector2(width,height);
            Place((RectTransform)nameText.transform,40,30,textWidth,42);
            if(bodyScroll==null)
            {
                var viewport=new GameObject("Effect Viewport",typeof(RectTransform),typeof(RectMask2D),typeof(ScrollRect));viewport.transform.SetParent(panel,false);
                bodyScroll=viewport.GetComponent<ScrollRect>();bodyScroll.viewport=(RectTransform)viewport.transform;
                effectText.transform.SetParent(viewport.transform,false);bodyScroll.content=(RectTransform)effectText.transform;
                bodyScroll.horizontal=false;bodyScroll.vertical=true;bodyScroll.movementType=ScrollRect.MovementType.Clamped;bodyScroll.scrollSensitivity=35;
                effectText.raycastTarget=true;
            }
            Place((RectTransform)bodyScroll.transform,40,bodyY,textWidth,height-bodyY-36);
            Place((RectTransform)effectText.transform,0,0,textWidth,Mathf.Max(bodyHeight,height-bodyY-36));
            bodyScroll.verticalNormalizedPosition=1;
            Vector2 point;RectTransformUtility.ScreenPointToLocalPointInRectangle(canvasRect,screenPoint,game.canvas.renderMode==RenderMode.ScreenSpaceOverlay?null:game.canvas.worldCamera,out point);
            point+=new Vector2(18,-18);
            point.x=Mathf.Clamp(point.x,canvasRect.rect.xMin+8,canvasRect.rect.xMax-width-8);
            point.y=Mathf.Clamp(point.y,canvasRect.rect.yMin+height+8,canvasRect.rect.yMax-8);
            panel.anchorMin=panel.anchorMax=new Vector2(.5f,.5f);panel.pivot=new Vector2(0,1);
            panel.anchoredPosition=point-canvasRect.rect.center;
        }
        static void Place(RectTransform rect,float x,float y,float width,float height)
        {
            rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(0,1);
            rect.anchoredPosition=new Vector2(x,-y);rect.sizeDelta=new Vector2(width,height);
        }
    }
}
