using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
namespace WorkWork.Editor
{
    public static class ConditionFeedbackSetup
    {
        [MenuItem("WorkWork/Configure Condition Feedback")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();if(game==null)return;
            var feedback=game.GetComponent<ConditionFeedback>();if(feedback==null)feedback=game.gameObject.AddComponent<ConditionFeedback>();
            game.conditionFeedback=feedback;EditorUtility.SetDirty(game);EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
    }
}
