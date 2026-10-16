using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
namespace WorkWork.Editor
{
    public static class CardDeletionFeedbackSetup
    {
        [MenuItem("WorkWork/Configure Card Deletion Feedback")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();if(game==null)return;
            var feedback=game.GetComponent<CardDeletionFeedback>();if(feedback==null)feedback=game.gameObject.AddComponent<CardDeletionFeedback>();
            game.cardDeletionFeedback=feedback;EditorUtility.SetDirty(game);EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
    }
}
