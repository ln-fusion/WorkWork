using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
namespace WorkWork.Editor
{
    public static class CardMotionSetup
    {
        [MenuItem("WorkWork/Configure Card Motion")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();
            if(game.cardMotion==null)game.cardMotion=game.GetComponent<CardMotion>()??game.gameObject.AddComponent<CardMotion>();
            EditorUtility.SetDirty(game);EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
    }
}
