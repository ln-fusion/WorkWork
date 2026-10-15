using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
namespace WorkWork.Editor
{
    public static class ShopRevealSetup
    {
        [MenuItem("WorkWork/Verify Shop Reveal")]
        public static void Verify()
        {
            if(!EditorApplication.isPlaying)return;
            var game=Object.FindObjectOfType<GameController>();game.StartCoroutine(Check(game));
        }
        static System.Collections.IEnumerator Check(GameController game)
        {
            var shell=game.GetComponent<GameShell>();var reveal=game.shopReveal;var panel=game.shopPanel;var rect=(RectTransform)panel.transform;
            bool board=shell.board.activeSelf,welcome=shell.welcome.activeSelf,active=panel.activeSelf;
            float duration=reveal.duration,retractDuration=reveal.retractDuration;string result="FAIL";
            panel.SetActive(false);shell.welcome.SetActive(false);shell.board.SetActive(true);Canvas.ForceUpdateCanvases();var home=rect.anchoredPosition;
            try
            {
                reveal.duration=.3f;panel.SetActive(true);
                bool entered=reveal.IsPlaying && game.IsBusy && rect.anchoredPosition.y<home.y;
                yield return new WaitForSeconds(.4f);
                bool landed=!reveal.IsPlaying && Vector2.Distance(rect.anchoredPosition,home)<.01f && panel.GetComponent<CanvasGroup>().interactable;
                reveal.retractDuration=.2f;reveal.StartCoroutine(reveal.Retract());
                yield return new WaitForSeconds(.05f);
                bool retracting=reveal.IsPlaying && game.IsBusy && rect.anchoredPosition.y<home.y && !panel.GetComponent<CanvasGroup>().interactable;
                yield return new WaitForSeconds(.25f);
                bool closed=!panel.activeSelf && !reveal.IsPlaying && Vector2.Distance(rect.anchoredPosition,home)<.01f;
                panel.SetActive(true);yield return new WaitForSeconds(.4f);
                reveal.StartCoroutine(reveal.Retract());yield return new WaitForSeconds(.05f);panel.SetActive(false);
                bool retractCancelled=!reveal.IsPlaying && Vector2.Distance(rect.anchoredPosition,home)<.01f;
                panel.SetActive(false);panel.SetActive(true);yield return new WaitForSeconds(.05f);panel.SetActive(false);
                bool cancelled=!reveal.IsPlaying && Vector2.Distance(rect.anchoredPosition,home)<.01f;
                result=entered&&landed&&retracting&&closed&&retractCancelled&&cancelled?"PASS: reveal and retract, interaction lock, hides after retract, reopen and cancellation restore original layout":$"FAIL entered={entered} landed={landed} retracting={retracting} closed={closed} retractCancelled={retractCancelled} cancelled={cancelled}";
            }
            finally
            {
                panel.SetActive(false);reveal.duration=duration;reveal.retractDuration=retractDuration;shell.board.SetActive(board);shell.welcome.SetActive(welcome);panel.SetActive(active);
                System.IO.File.WriteAllText("Document/shop-reveal-verification.txt",result);Debug.Log("WORKWORK_SHOP_REVEAL "+result);
            }
        }
        [MenuItem("WorkWork/Configure Shop Reveal")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();
            if(game.shopReveal==null)game.shopReveal=game.shopPanel.GetComponent<ShopReveal>();
            if(game.shopReveal==null)game.shopReveal=game.shopPanel.AddComponent<ShopReveal>();
            EditorUtility.SetDirty(game);EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
    }
}
