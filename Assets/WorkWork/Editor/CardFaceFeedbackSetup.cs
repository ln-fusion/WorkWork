using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace WorkWork.Editor
{
    public static class CardFaceFeedbackSetup
    {
        [MenuItem("WorkWork/Configure Card Face Feedback")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();if(game==null)return;
            var feedback=game.GetComponent<CardFaceFeedback>();if(feedback==null)feedback=game.gameObject.AddComponent<CardFaceFeedback>();
            game.cardFaceFeedback=feedback;EditorUtility.SetDirty(game);
            EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
    }
}
