using System.Linq;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class ActionFeedbackSetup
    {
        [MenuItem("WorkWork/Configure Action Feedback")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();
            var feedback=game.GetComponent<ActionFeedback>();if(feedback==null)feedback=Undo.AddComponent<ActionFeedback>(game.gameObject);
            game.actionFeedback=feedback;
            feedback.taskPhone=game.GetComponentsInChildren<RectTransform>(true).First(t=>t.name=="Task" || t.name=="Tasks Reserved");
            EditorUtility.SetDirty(game);EditorUtility.SetDirty(feedback);
            EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
        [MenuItem("WorkWork/Verify Action Feedback")]
        public static void Verify()
        {
            if(!EditorApplication.isPlaying)return;
            var game=Object.FindObjectOfType<GameController>();game.StartCoroutine(Check(game));
        }
        static System.Collections.IEnumerator Check(GameController live)
        {
            var root=new GameObject("Temporary Action Feedback",typeof(RectTransform),typeof(Canvas));
            var game=root.AddComponent<GameController>();game.enabled=false;game.canvas=root.GetComponent<Canvas>();game.canvas.renderMode=RenderMode.ScreenSpaceOverlay;game.theme=live.theme;
            var shell=root.AddComponent<GameShell>();shell.enabled=false;shell.game=game;
            var target=new GameObject("Feedback Target",typeof(RectTransform),typeof(TextMeshProUGUI));target.transform.SetParent(root.transform,false);
            var rect=(RectTransform)target.transform;var label=target.GetComponent<TMP_Text>();label.font=live.theme.font;
            shell.pattern=label;shell.shopCash=label;
            var feedback=root.AddComponent<ActionFeedback>();feedback.taskPhone=rect;
            var home=rect.anchoredPosition;var scale=rect.localScale;var rotation=rect.localRotation;
            string report="FAIL";
            try
            {
                feedback.Pulse(rect);yield return new WaitForSeconds(.06f);
                bool pulse=rect.localScale.x>scale.x;
                feedback.Clear();
                feedback.VibratePhone();yield return new WaitForSeconds(.045f);
                bool phone=rect.anchoredPosition!=home && rect.localRotation!=rotation;
                yield return new WaitForSeconds(.4f);
                bool restore=rect.anchoredPosition==home && rect.localScale==scale && rect.localRotation==rotation;
                feedback.Spend(game,4);feedback.Failure(game,rect,"资金不足");yield return null;
                var texts=root.GetComponentsInChildren<TMP_Text>();
                bool popups=texts.Any(t=>t.name=="Action Popup" && t.text=="-4" && !t.raycastTarget && t.font.HasCharacter('-')) && texts.Any(t=>t.text=="资金不足");
                feedback.Clear();yield return null;
                rect.anchoredPosition=new Vector2(((RectTransform)root.transform).rect.xMax-90,0);
                feedback.Spend(game,4);
                var cost=root.GetComponentsInChildren<TMP_Text>().First(t=>t.name=="Action Popup");
                bool nearFunds=Mathf.Abs(cost.rectTransform.anchoredPosition.x-rect.anchoredPosition.x)<1 && cost.rectTransform.rect.width<200;
                feedback.Clear();rect.anchoredPosition=home;yield return null;
                feedback.Clear();yield return null;
                feedback.ObservePattern(game,"无牌型",true);feedback.ObservePattern(game,"一对",true);yield return new WaitForSeconds(.06f);
                bool pattern=rect.localScale.x>scale.x;
                feedback.Clear();feedback.ObservePattern(game,"一对",true);feedback.ObservePattern(game,"一对",true);yield return null;
                bool noRepeat=rect.localScale==scale;
                feedback.Pulse(rect);yield return null;feedback.Clear();
                bool cancel=rect.anchoredPosition==home && rect.localScale==scale && rect.localRotation==rotation;
                report=pulse&&phone&&restore&&popups&&nearFunds&&pattern&&noRepeat&&cancel?"PASS: landing pulse, phone vibration, ASCII-minus cost stays near right-edge funds, reason popups, changed-pattern pulse without repeats, completion/cancellation restore layout":$"FAIL pulse={pulse} phone={phone} restore={restore} popups={popups} nearFunds={nearFunds} pattern={pattern} noRepeat={noRepeat} cancel={cancel}";
            }
            finally {Object.Destroy(root);System.IO.File.WriteAllText("Document/action-feedback-verification.txt",report);Debug.Log("WORKWORK_ACTION_FEEDBACK "+report);}
        }
        [MenuItem("WorkWork/Verify Shop Feedback Integration")]
        public static void Integration()
        {
            if(!EditorApplication.isPlaying)return;
            var game=Object.FindObjectOfType<GameController>();game.StartCoroutine(CheckShop(game));
        }
        static System.Collections.IEnumerator CheckShop(GameController game)
        {
            var shell=game.GetComponent<GameShell>();var saved=game.Session;
            bool board=shell.board.activeSelf,welcome=shell.welcome.activeSelf;
            var property=typeof(GameController).GetProperty("Session");
            var session=new GameSession(game.catalog.rules,123);session.State.phase=Phase.Shop;session.State.cash=100;
            var employee=game.catalog.rules.content.First(c=>!c.item);var item=game.catalog.rules.content.First(c=>c.item);
            session.State.offers.Clear();session.State.offers.Add(employee.id);session.State.offers.Add(item.id);
            var source=new GameObject("Temporary Offer",typeof(DragToken));var token=source.GetComponent<DragToken>();token.controller=game;token.kind=TokenKind.Offer;
            var target=new GameObject("Temporary Drop",typeof(DropZone));var zone=target.GetComponent<DropZone>();zone.controller=game;zone.slot=0;
            string report="FAIL";
            try
            {
                property.SetValue(game,session);shell.welcome.SetActive(false);shell.board.SetActive(true);game.Render();
                yield return new WaitForSeconds(1);
                token.contentId=employee.id;game.Drop(token,zone);
                bool employeeBought=session.State.employees[0]==employee.id && session.State.cash==100-employee.price;
                token.contentId=item.id;game.Drop(token,zone);
                bool equipped=session.State.items[0]==item.id;
                var money=game.canvas.GetComponentsInChildren<TMP_Text>().Count(t=>t.name=="Action Popup" && t.text.StartsWith("-"));
                session.State.items[0]=null;session.State.acquired.Remove(item.id);session.State.offers[1]=item.id;session.State.cash=0;
                game.Drop(token,zone);
                bool failed=session.State.items[0]==null && game.canvas.GetComponentsInChildren<TMP_Text>().Any(t=>t.name=="Action Popup" && t.text=="资金不足");
                report=employeeBought&&equipped&&money==2&&failed?"PASS: actual shop drop buys staff/equipment, two cost popups, insufficient funds fails without purchase and displays reason":$"FAIL employee={employeeBought} equipped={equipped} money={money} failed={failed}";
            }
            finally
            {
                game.actionFeedback.Clear();property.SetValue(game,saved);game.Render();shell.board.SetActive(board);shell.welcome.SetActive(welcome);
                Object.Destroy(source);Object.Destroy(target);System.IO.File.WriteAllText("Document/shop-feedback-integration.txt",report);Debug.Log("WORKWORK_SHOP_FEEDBACK "+report);
            }
        }
    }
}
