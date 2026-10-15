using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
namespace WorkWork.Editor
{
    public static class FailureRevealSetup
    {
        [MenuItem("WorkWork/Configure Failure Reveal")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var panel=Object.FindObjectOfType<GameShell>().loseGroup;
            if(panel.GetComponent<FailureReveal>()==null)Undo.AddComponent<FailureReveal>(panel);
            EditorSceneManager.MarkSceneDirty(panel.scene);EditorSceneManager.SaveScene(panel.scene);
        }
        [MenuItem("WorkWork/Verify Failure Reveal")]
        public static void Verify()
        {
            if(!EditorApplication.isPlaying)return;
            var game=Object.FindObjectOfType<GameController>();game.StartCoroutine(Check(game));
        }
        static System.Collections.IEnumerator Check(GameController game)
        {
            // Isolated clone preserves live phase, UI and saved progress.
            var original=game.GetComponent<GameShell>().loseGroup;
            var clone=Object.Instantiate(original,game.canvas.transform);clone.SetActive(false);
            var rect=(RectTransform)clone.transform;var home=rect.anchoredPosition;
            var reveal=clone.GetComponent<FailureReveal>();string report="FAIL";
            try
            {
                clone.SetActive(true);
                bool starts=reveal.IsPlaying && rect.anchoredPosition.y>home.y && !clone.GetComponent<CanvasGroup>().interactable;
                // Sample the bounce section after the initial fall.
                yield return new WaitForSeconds(reveal.fallDuration+reveal.bounceDuration*.4f);
                bool bounce=reveal.IsPlaying && rect.anchoredPosition.y>home.y;
                yield return new WaitForSeconds(1);
                bool finish=!reveal.IsPlaying && Vector2.Distance(rect.anchoredPosition,home)<.01f && clone.GetComponent<CanvasGroup>().interactable;
                clone.SetActive(false);clone.SetActive(true);yield return null;clone.SetActive(false);
                bool cancel=!reveal.IsPlaying && Vector2.Distance(rect.anchoredPosition,home)<.01f;
                report=starts&&bounce&&finish&&cancel?"PASS: falls from above, bounces, restores original position and interaction, cancellation restores layout":$"FAIL starts={starts} bounce={bounce} finish={finish} cancel={cancel}";
            }
            finally {Object.Destroy(clone);System.IO.File.WriteAllText("Document/failure-reveal-verification.txt",report);Debug.Log("WORKWORK_FAILURE_REVEAL "+report);}
        }
    }
}
