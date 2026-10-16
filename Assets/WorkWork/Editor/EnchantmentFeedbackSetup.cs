using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace WorkWork.Editor
{
    public static class EnchantmentFeedbackSetup
    {
        [MenuItem("WorkWork/Configure Enchantment Feedback")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();if(game==null)return;
            var feedback=game.GetComponent<EnchantmentFeedback>();
            if(feedback==null)feedback=game.gameObject.AddComponent<EnchantmentFeedback>();
            game.enchantmentFeedback=feedback;
            EditorUtility.SetDirty(game);EditorSceneManager.MarkSceneDirty(game.gameObject.scene);
            EditorSceneManager.SaveScene(game.gameObject.scene);
        }
    }
}
