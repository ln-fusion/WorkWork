using UnityEngine;

namespace WorkWork
{
    [ExecuteAlways]
    [RequireComponent(typeof(RectTransform))]
    public class ResponsiveUiFrame : MonoBehaviour
    {
        public Vector2 designSize=new Vector2(1600,900);
        bool fitting;
        void OnEnable() => Fit();
        void OnRectTransformDimensionsChange() => Fit();
        void LateUpdate() => Fit();
        void Fit()
        {
            if(fitting) return;
            var rect=(RectTransform)transform; var parent=transform.parent as RectTransform;
            if(parent==null || designSize.x<=0 || designSize.y<=0) return;
            float scale=Mathf.Min(parent.rect.width/designSize.x,parent.rect.height/designSize.y);
            if(scale<=0) return;
            var center=new Vector2(.5f,.5f); var desiredScale=new Vector3(scale,scale,1);
            if(rect.anchorMin==center && rect.anchorMax==center && rect.pivot==center && rect.anchoredPosition==Vector2.zero && rect.sizeDelta==designSize && rect.localScale==desiredScale) return;
            fitting=true;
            try {
                rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f);
                rect.anchoredPosition=Vector2.zero; rect.sizeDelta=designSize;
                rect.localScale=new Vector3(scale,scale,1);
            } finally { fitting=false; }
        }
    }
}
