using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork.Editor
{
    public static class ResultUiBuilder
    {
        [MenuItem("WorkWork/Split Win Lose Result Groups")]
        public static void Apply()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var g=Object.FindObjectOfType<GameController>();Bind(g);
            EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene);
        }
        public static void Bind(GameController g)
        {
            var shell=g.GetComponent<GameShell>();var parent=g.resultPanel.transform;
            if(shell.winGroup!=null && shell.loseGroup!=null) return;
            shell.winGroup=Group(parent,"Win Group");shell.loseGroup=Group(parent,"Lose Group");
            var old=parent.Find("Result Art");
            if(old!=null) {old.SetParent(shell.winGroup.transform,false);old.name="Background Image";old.GetComponent<Image>().sprite=Sprite("Assets/Image/Win.psd");}
            else Background(shell.winGroup.transform,"Assets/Image/Win.psd",null);
            Background(shell.loseGroup.transform,"Assets/Image/Lose.psd",old as RectTransform);
            foreach(var label in shell.winNumbers) {label.transform.SetParent(shell.winGroup.transform,false);label.gameObject.SetActive(true);}
            foreach(var label in shell.loseNumbers) {label.transform.SetParent(shell.loseGroup.transform,false);label.gameObject.SetActive(true);}
            g.resultButton.transform.SetParent(shell.winGroup.transform,false);g.resultButton.gameObject.SetActive(true);
            shell.restart.transform.SetParent(shell.loseGroup.transform,false);shell.restart.gameObject.SetActive(true);
            if(g.resultText!=null) {Object.DestroyImmediate(g.resultText.gameObject);g.resultText=null;}
            var image=parent.GetComponent<Image>();if(image!=null) Object.DestroyImmediate(image);
            var renderer=parent.GetComponent<CanvasRenderer>();if(renderer!=null) Object.DestroyImmediate(renderer);
            shell.winGroup.SetActive(true);shell.loseGroup.SetActive(false);
            EditorUtility.SetDirty(shell);EditorUtility.SetDirty(g);
        }
        static GameObject Group(Transform parent,string name)
        {
            var obj=new GameObject(name,typeof(RectTransform));obj.transform.SetParent(parent,false);
            var r=(RectTransform)obj.transform;r.anchorMin=Vector2.zero;r.anchorMax=Vector2.one;r.offsetMin=r.offsetMax=Vector2.zero;r.pivot=new Vector2(0,1);return obj;
        }
        static Sprite Sprite(string path) => AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().FirstOrDefault();
        static void Background(Transform parent,string path,RectTransform source)
        {
            var obj=new GameObject("Background Image",typeof(RectTransform),typeof(Image));obj.transform.SetParent(parent,false);
            var r=(RectTransform)obj.transform;
            if(source!=null) {r.anchorMin=source.anchorMin;r.anchorMax=source.anchorMax;r.pivot=source.pivot;r.anchoredPosition=source.anchoredPosition;r.sizeDelta=source.sizeDelta;}
            else {r.anchorMin=r.anchorMax=r.pivot=new Vector2(0,1);r.anchoredPosition=Vector2.zero;r.sizeDelta=new Vector2(940,705);}
            var image=obj.GetComponent<Image>();image.sprite=Sprite(path);image.preserveAspect=true;image.raycastTarget=true;
        }
        [MenuItem("WorkWork/Preview/Win Result")]
        public static void Win() {Preview(true);}
        [MenuItem("WorkWork/Preview/Lose Result")]
        public static void Lose() {Preview(false);}
        static void Preview(bool won)
        {
            var g=Object.FindObjectOfType<GameController>();var shell=g.GetComponent<GameShell>();
            shell.welcome.SetActive(false);shell.board.SetActive(true);g.resultPanel.SetActive(true);
            shell.winGroup.SetActive(won);shell.loseGroup.SetActive(!won);Selection.activeGameObject=won?shell.winGroup:shell.loseGroup;
        }
    }
}
