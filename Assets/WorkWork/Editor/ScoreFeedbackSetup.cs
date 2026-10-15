using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
namespace WorkWork.Editor
{
    public static class ScoreFeedbackSetup
    {
        [MenuItem("WorkWork/Configure Score Feedback")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();
            if(game.scoreFeedback==null)game.scoreFeedback=game.GetComponent<ScoreFeedback>()??game.gameObject.AddComponent<ScoreFeedback>();
            game.scoreFeedback.popupFontSize=55;
            EditorUtility.SetDirty(game);EditorUtility.SetDirty(game.scoreFeedback);EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
    }
}
