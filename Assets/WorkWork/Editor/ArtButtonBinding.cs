using System.Linq;
using UnityEditor;
using UnityEditor.Events;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork.Editor
{
    public static class ArtButtonBinding
    {
        [MenuItem("WorkWork/Bind Done Roll Setting Buttons")]
        public static void Apply()
        {
            var g=Object.FindObjectOfType<GameController>();Bind(g);
            EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene);
        }
        public static void Bind(GameController g)
        {
            var art=g.GetComponentsInChildren<Transform>(true).First(t=>t.name=="Game PSD Layers");
            g.scoreButton=Replace(g.scoreButton,art.Find("Done"));
            g.redrawButton=Replace(g.redrawButton,art.Find("Roll"));
            var old=g.GetComponentsInChildren<Button>(true).FirstOrDefault(b=>b.name=="Settings Button");
            var settings=Replace(old,art.Find("Setting"));
            settings.onClick=new Button.ButtonClickedEvent();UnityEventTools.AddPersistentListener(settings.onClick,g.GetComponent<GameShell>().OpenSettings);
            EditorUtility.SetDirty(settings);EditorUtility.SetDirty(g);
        }
        static Button Replace(Button old,Transform target)
        {
            var image=target.GetComponent<Image>();image.raycastTarget=true;
            var button=target.GetComponent<Button>();if(button==null) button=target.gameObject.AddComponent<Button>();
            button.targetGraphic=image;ArtUiBuilder.ConfigureButtonTint(button);
            if(old!=null && old!=button) Object.DestroyImmediate(old.gameObject);
            target.gameObject.SetActive(true);EditorUtility.SetDirty(image);EditorUtility.SetDirty(button);
            return button;
        }
    }
}


