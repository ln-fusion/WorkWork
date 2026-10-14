using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork.Editor
{
    public static class TooltipUiBuilder
    {
        const string Path="Assets/WorkWork/Prefabs/DetailsTooltip.prefab";
        [MenuItem("WorkWork/Apply Right Click Details UI")]
        public static void Apply()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var g=Object.FindObjectOfType<GameController>();ApplyTo(g);
            EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene);
        }
        public static void ApplyTo(GameController g)
        {
            var prefab=AssetDatabase.LoadAssetAtPath<DetailsTooltip>(Path);
            if(prefab==null)
            {
                var root=new GameObject("Details Tooltip",typeof(RectTransform),typeof(CanvasGroup),typeof(DetailsTooltip));
                var details=root.GetComponent<DetailsTooltip>();details.panel=(RectTransform)root.transform;details.panel.sizeDelta=new Vector2(440,250);details.panel.pivot=new Vector2(0,1);
                var group=root.GetComponent<CanvasGroup>();group.blocksRaycasts=false;group.interactable=false;
                var paper=new GameObject("Background Image",typeof(RectTransform),typeof(Image));paper.transform.SetParent(root.transform,false);
                var image=paper.GetComponent<Image>();image.sprite=AssetDatabase.LoadAssetAtPath<Sprite>("Assets/Image/WindowContent.png");image.color=Color.white;image.raycastTarget=false;
                var rect=(RectTransform)paper.transform;rect.anchorMin=Vector2.zero;rect.anchorMax=Vector2.one;rect.offsetMin=rect.offsetMax=Vector2.zero;
                details.nameText=Label(root.transform,"Name","名字",26,g.theme.font);details.nameText.fontStyle=FontStyles.Bold;
                details.effectText=Label(root.transform,"Effects","效果",22,g.theme.font);details.effectText.enableAutoSizing=true;details.effectText.fontSizeMin=16;details.effectText.fontSizeMax=22;
                var saved=PrefabUtility.SaveAsPrefabAsset(root,Path);Object.DestroyImmediate(root);prefab=saved.GetComponent<DetailsTooltip>();
            }
            g.tooltipPrefab=prefab;EditorUtility.SetDirty(g);AssetDatabase.SaveAssets();
        }
        static TMP_Text Label(Transform parent,string name,string text,int size,TMP_FontAsset font)
        {
            var obj=new GameObject(name,typeof(RectTransform),typeof(TextMeshProUGUI));obj.transform.SetParent(parent,false);
            var rect=(RectTransform)obj.transform;rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(0,1);rect.anchoredPosition=new Vector2(40,name=="Name"?-30:-88);rect.sizeDelta=new Vector2(360,name=="Name"?42:126);
            var label=obj.GetComponent<TextMeshProUGUI>();label.text=text;label.font=font;label.fontSharedMaterial=font.material;label.fontSize=size;label.color=new Color(.32f,.19f,.08f);label.alignment=TextAlignmentOptions.TopLeft;label.raycastTarget=false;label.richText=false;
            return label;
        }
    }
}
