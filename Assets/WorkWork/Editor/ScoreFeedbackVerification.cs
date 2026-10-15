using System.Collections;
using System.Linq;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;
namespace WorkWork.Editor
{
    public static class ScoreFeedbackVerification
    {
        [MenuItem("WorkWork/Verify Score Feedback")]
        public static void Run()
        {
            if(!EditorApplication.isPlaying) return;
            var runner=Object.FindObjectOfType<GameController>();runner.StartCoroutine(Check(runner));
        }
        static IEnumerator Check(GameController runner)
        {
            var root=new GameObject("Temporary Feedback Verification",typeof(RectTransform),typeof(Canvas));
            var fake=root.AddComponent<GameController>();fake.enabled=false;fake.theme=runner.theme;fake.canvas=root.GetComponent<Canvas>();fake.canvas.renderMode=RenderMode.ScreenSpaceOverlay;
            var shell=root.AddComponent<GameShell>();shell.enabled=false;
            var card=new GameObject("Card",typeof(RectTransform),typeof(CardView));card.transform.SetParent(root.transform,false);
            var employee=new GameObject("Employee",typeof(RectTransform),typeof(Image));employee.transform.SetParent(root.transform,false);
            fake.slotRoots=Enumerable.Repeat((RectTransform)card.transform,6).ToArray();fake.employeeIcons=Enumerable.Repeat(employee.GetComponent<Image>(),6).ToArray();fake.itemIcons=Enumerable.Repeat(employee.GetComponent<Image>(),18).ToArray();
            var chips=new GameObject("Chips",typeof(RectTransform),typeof(TextMeshProUGUI));chips.transform.SetParent(root.transform,false);shell.chips=chips.GetComponent<TMP_Text>();
            var mult=new GameObject("Multiplier",typeof(RectTransform),typeof(TextMeshProUGUI));mult.transform.SetParent(root.transform,false);shell.multiplier=mult.GetComponent<TMP_Text>();
            var redraw=new GameObject("Redraw Count",typeof(RectTransform),typeof(TextMeshProUGUI));redraw.transform.SetParent(root.transform,false);shell.redraws=redraw.GetComponent<TMP_Text>();
            var feedback=root.AddComponent<ScoreFeedback>();var rect=(RectTransform)card.transform;var home=rect.anchoredPosition;var rotation=rect.localRotation;string result="FAIL";
            try
            {
                feedback.Play(fake,new ScoreStep{source=ScoreSource.Card,sourceSlot=0,chipsDelta=3,multiplierDelta=2});
                yield return null;
                yield return new WaitForSeconds(.08f);
                var labels=root.GetComponentsInChildren<TMP_Text>().Where(t=>t.name=="Score Popup").ToArray();
                bool styles=labels.Length==4 && labels.All(t=>t.fontSize==55 && (t.fontStyle&FontStyles.Bold)!=0);
                bool colors=labels.Count(t=>t.color==feedback.chipsColor)==2 && labels.Count(t=>t.color==feedback.multiplierColor)==2;
                bool motion=rect.anchoredPosition.y>home.y && Quaternion.Angle(rect.localRotation,rotation)>0;
                yield return new WaitForSeconds(.6f);
                bool restored=rect.anchoredPosition==home && rect.localRotation==rotation && root.GetComponentsInChildren<TMP_Text>().All(t=>t.name!="Score Popup");
                feedback.Play(fake,new ScoreStep{source=ScoreSource.Card,sourceSlot=0,chipsDelta=3});yield return null;feedback.ClearFeedback();
                bool cancelled=rect.anchoredPosition==home && rect.localRotation==rotation;
                yield return null;
                var redrawRect=(RectTransform)redraw.transform;var redrawHome=redrawRect.anchoredPosition;
                feedback.Play(fake,new ScoreStep{source=ScoreSource.Card,sourceSlot=0,extraRedrawDelta=1});yield return new WaitForSeconds(.08f);
                bool retry=redrawRect.anchoredPosition.y>redrawHome.y && root.GetComponentsInChildren<TMP_Text>().Count(t=>t.name=="Score Popup" && t.text=="+1")==2;
                feedback.ClearFeedback();retry=retry && redrawRect.anchoredPosition==redrawHome;
                yield return feedback.RollScore(shell.chips,123,9876543210123,.15f);
                bool roll=shell.chips.text==9876543210123L.ToString("N0");
                var cancelledRoll=feedback.RollScore(shell.chips,0,24680,.5f);cancelledRoll.MoveNext();yield return null;feedback.ClearFeedback();roll=roll && shell.chips.text==24680L.ToString("N0");
                result=styles&&colors&&motion&&restored&&cancelled&&retry&&roll ? "PASS: 55 bold paired popups, jump/tilt, retry feedback, score roll lands exactly on long target and cancellation restores target" : $"FAIL styles={styles} colors={colors} motion={motion} restored={restored} cancelled={cancelled} retry={retry} roll={roll}";
            }
            finally {Object.Destroy(root);System.IO.File.WriteAllText("Document/score-feedback-verification.txt",result);Debug.Log("WORKWORK_SCORE_FEEDBACK "+result);}
        }
    }
}
