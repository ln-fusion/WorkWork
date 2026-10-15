using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using System.Collections.Generic;

namespace WorkWork.Editor
{
    public static class DeploymentTiltSetup
    {
        [MenuItem("WorkWork/Configure Deployment Tilt")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();
            var tilt=game.GetComponent<DeploymentTilt>();if(tilt==null)tilt=Undo.AddComponent<DeploymentTilt>(game.gameObject);
            tilt.game=game;tilt.board=(RectTransform)game.GetComponent<GameShell>().board.transform;game.deploymentTilt=tilt;
            EditorUtility.SetDirty(tilt);EditorUtility.SetDirty(game);EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
        [MenuItem("WorkWork/Verify Deployment Tilt")]
        public static void Verify()
        {
            if(!EditorApplication.isPlaying)return;
            var game=Object.FindObjectOfType<GameController>();game.StartCoroutine(Check(game));
        }
        static System.Collections.IEnumerator Check(GameController live)
        {
            var root=new GameObject("Temporary Deployment Tilt",typeof(RectTransform));
            var game=root.AddComponent<GameController>();game.enabled=false;game.catalog=live.catalog;
            var board=new GameObject("Board",typeof(RectTransform),typeof(ResponsiveUiFrame));board.transform.SetParent(root.transform,false);
            var rect=(RectTransform)board.transform;rect.localRotation=Quaternion.Euler(0,0,2);var home=rect.localRotation;
            var preview=new GameObject("Drag Preview",typeof(RectTransform));preview.transform.SetParent(root.transform,false);
            var tilt=root.AddComponent<DeploymentTilt>();game.deploymentTilt=tilt;tilt.game=game;tilt.board=rect;
            var token=root.AddComponent<DragToken>();token.controller=game;token.kind=TokenKind.Employee;
            string report="FAIL";
            try
            {
                tilt.Begin(token);yield return new WaitForSeconds(.3f);
                bool enters=tilt.IsTilted && Quaternion.Angle(rect.localRotation,home)>20;
                bool previewStraight=preview.transform.localRotation==Quaternion.identity;
                tilt.End();yield return new WaitForSeconds(.3f);
                bool returns=!tilt.IsTilted && rect.localRotation==home;
                token.kind=TokenKind.Offer;token.contentId=game.catalog.rules.content.First(c=>!c.item).id;
                tilt.Begin(token);yield return new WaitForSeconds(.05f);bool offer=tilt.IsTilted;
                tilt.ResetPose();bool cancel=rect.localRotation==home && !tilt.IsTilted;
                token.contentId=game.catalog.rules.content.First(c=>c.item).id;tilt.Begin(token);
                token.kind=TokenKind.HandCard;tilt.Begin(token);bool excluded=!tilt.IsTilted && rect.localRotation==home;
                token.kind=TokenKind.Employee;tilt.Begin(token);yield return null;tilt.enabled=false;
                bool disable=rect.localRotation==home;
                bool raycast=false;var shell=live.GetComponent<GameShell>();bool shown=shell.board.activeSelf,welcome=shell.welcome.activeSelf;
                try
                {
                    shell.welcome.SetActive(false);shell.board.SetActive(true);Canvas.ForceUpdateCanvases();
                    var realToken=preview.AddComponent<DragToken>();realToken.controller=live;realToken.kind=TokenKind.Employee;
                    live.deploymentTilt.Begin(realToken);yield return new WaitForSeconds(.3f);
                    var target=(RectTransform)live.employeeButtons[0].transform;
                    var camera=live.canvas.renderMode==RenderMode.ScreenSpaceOverlay?null:live.canvas.worldCamera;
                    var point=RectTransformUtility.WorldToScreenPoint(camera,target.TransformPoint(target.rect.center));
                    var hits=new List<RaycastResult>();EventSystem.current.RaycastAll(new PointerEventData(EventSystem.current){position=point},hits);
                    raycast=hits.Any(hit=>hit.gameObject.transform==target || hit.gameObject.transform.IsChildOf(target));
                }
                finally {live.deploymentTilt.ResetPose();shell.board.SetActive(shown);shell.welcome.SetActive(welcome);}
                report=enters&&previewStraight&&returns&&offer&&cancel&&excluded&&disable&&raycast?"PASS: staff/offer tilt, preview stays upright, smooth return, tool/card exclusions, cancel/disable restore, actual tilted workstation raycast hits":$"FAIL enters={enters} previewStraight={previewStraight} returns={returns} offer={offer} cancel={cancel} excluded={excluded} disable={disable} raycast={raycast}";
            }
            finally {Object.Destroy(root);System.IO.File.WriteAllText("Document/deployment-tilt-verification.txt",report);Debug.Log("WORKWORK_DEPLOYMENT_TILT "+report);}
        }
    }
}
