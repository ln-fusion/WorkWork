using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace WorkWork.Editor
{
    public static class PhonePickupSetup
    {
        [MenuItem("WorkWork/Configure Phone Pickup")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();var shell=game.GetComponent<GameShell>();
            var source=game.GetComponentsInChildren<RectTransform>(true).First(t=>t.name=="Task" || t.name=="Tasks Reserved");
            foreach(var panel in new[]{shell.taskPanel.gameObject,shell.taskChoicePanel.gameObject})
            {
                var pickup=panel.GetComponent<PhonePickup>();if(pickup==null)pickup=Undo.AddComponent<PhonePickup>(panel);
                pickup.sourcePhone=source;pickup.phoneGraphic=(RectTransform)panel.transform.Find("Phone Background");
                var shade=panel.transform.Find("Backdrop");
                if(shade==null)
                {
                    var close=panel.transform.Find("Close") as RectTransform;
                    if(close!=null && close.rect.width>=1000 && close.rect.height>=700)shade=close;
                }
                if(shade!=null){pickup.backdrop=shade.GetComponent<CanvasGroup>();if(pickup.backdrop==null)pickup.backdrop=Undo.AddComponent<CanvasGroup>(shade.gameObject);}
                EditorUtility.SetDirty(pickup);
            }
            EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
        [MenuItem("WorkWork/Verify Phone Pickup")]
        public static void Verify()
        {
            if(!EditorApplication.isPlaying)return;
            var game=Object.FindObjectOfType<GameController>();game.StartCoroutine(Check(game));
        }
        static System.Collections.IEnumerator Check(GameController game)
        {
            var shell=game.GetComponent<GameShell>();string report="PASS: both phone panels lift/scale/tilt, restore layout and interaction, reopen and cancel safely";
            foreach(var original in new[]{shell.taskPanel.gameObject,shell.taskChoicePanel.gameObject})
            {
                var clone=Object.Instantiate(original,game.canvas.transform);clone.SetActive(false);
                var pickup=clone.GetComponent<PhonePickup>();var rect=pickup.phoneGraphic;
                var home=rect.localPosition;var scale=rect.localScale;var rotation=rect.localRotation;
                try
                {
                    clone.SetActive(true);yield return null;
                    bool start=pickup.IsPlaying && rect.localScale.x<scale.x && Vector3.Distance(rect.localPosition,home)>1 && !clone.GetComponent<CanvasGroup>().interactable;
                    yield return new WaitForSeconds(pickup.duration+.1f);
                    bool finish=!pickup.IsPlaying && rect.localPosition==home && rect.localScale==scale && rect.localRotation==rotation && clone.GetComponent<CanvasGroup>().interactable;
                    clone.SetActive(false);clone.SetActive(true);yield return null;clone.SetActive(false);
                    bool cancel=!pickup.IsPlaying && rect.localPosition==home && rect.localScale==scale && rect.localRotation==rotation;
                    if(!start || !finish || !cancel)report=$"FAIL {original.name}: start={start} finish={finish} cancel={cancel}";
                }
                finally {Object.Destroy(clone);}
            }
            System.IO.File.WriteAllText("Document/phone-pickup-verification.txt",report);Debug.Log("WORKWORK_PHONE_PICKUP "+report);
        }
    }
}
