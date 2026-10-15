using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class DropHintsSetup
    {
        [MenuItem("WorkWork/Configure Drop Hints")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();
            var hints=game.GetComponent<DropHints>();if(hints==null)hints=Undo.AddComponent<DropHints>(game.gameObject);
            hints.game=game;game.dropHints=hints;EditorUtility.SetDirty(game);EditorUtility.SetDirty(hints);
            EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
        [MenuItem("WorkWork/Verify Drop Hints")]
        public static void Verify()
        {
            if(!EditorApplication.isPlaying)return;
            var live=Object.FindObjectOfType<GameController>();live.StartCoroutine(Check(live));
        }
        static System.Collections.IEnumerator Check(GameController live)
        {
            var root=new GameObject("Temporary Drop Hints",typeof(RectTransform),typeof(Canvas));
            var game=root.AddComponent<GameController>();game.enabled=false;game.canvas=root.GetComponent<Canvas>();game.canvas.renderMode=RenderMode.ScreenSpaceOverlay;game.catalog=live.catalog;game.theme=live.theme;
            var session=new GameSession(game.catalog.rules,123);
            typeof(GameController).GetProperty("Session").SetValue(game,session);
            var state=session.State;state.phase=Phase.Shop;
            var employee=game.catalog.rules.content.First(c=>!c.item);var item=game.catalog.rules.content.First(c=>c.item);
            state.employees[0]=employee.id;state.employees[2]=employee.id;state.items[0]=item.id;
            state.offers.Clear();state.offers.Add(employee.id);state.offers.Add(item.id);
            game.employeeButtons=Enumerable.Range(0,6).Select(i=>Button(root.transform,"Employee "+i)).ToArray();
            game.itemButtons=Enumerable.Range(0,18).Select(i=>Button(root.transform,"Item "+i)).ToArray();
            var hints=root.AddComponent<DropHints>();hints.game=game;game.dropHints=hints;
            var source=new GameObject("Offer",typeof(RectTransform),typeof(DragToken));source.transform.SetParent(root.transform,false);
            var token=source.GetComponent<DragToken>();token.controller=game;token.kind=TokenKind.Offer;token.contentId=employee.id;
            string report="FAIL";
            try
            {
                hints.Show(token);bool staff=hints.ActiveCount==4;
                token.contentId=item.id;hints.Show(token);bool tools=hints.ActiveCount==5;
                var overlays=root.GetComponentsInChildren<Image>().Where(i=>i.name=="Empty Slot Highlight").ToArray();
                bool style=overlays.Length==5 && overlays.All(i=>!i.raycastTarget && Mathf.Abs(i.color.r-1)<.001f && Mathf.Abs(i.color.g-239f/255)<.001f && Mathf.Abs(i.color.b-209f/255)<.001f);
                float alpha=overlays[0].color.a;yield return new WaitForSeconds(.15f);bool pulse=overlays[0].color.a!=alpha;
                hints.Hide();bool hidden=hints.ActiveCount==0 && overlays.All(i=>!i.gameObject.activeSelf);
                int created=root.GetComponentsInChildren<Image>(true).Length;hints.Show(token);
                bool reuse=root.GetComponentsInChildren<Image>(true).Length==created;
                state.phase=Phase.Playing;hints.Show(token);bool phase=hints.ActiveCount==0;
                token.kind=TokenKind.Employee;hints.Show(token);phase=phase && hints.ActiveCount==4;
                token.kind=TokenKind.HandCard;hints.Show(token);bool cards=hints.ActiveCount==0;
                state.phase=Phase.Shop;token.kind=TokenKind.Offer;token.contentId=employee.id;
                var e=new PointerEventData(EventSystem.current){button=PointerEventData.InputButton.Left,position=Vector2.zero};
                token.OnBeginDrag(e);bool hook=hints.ActiveCount==4 && DragToken.Current==token;
                token.OnEndDrag(e);hook=hook && hints.ActiveCount==0 && DragToken.Current==null;
                token.OnBeginDrag(e);source.SetActive(false);bool cancel=hints.ActiveCount==0 && DragToken.Current==null;
                report=staff&&tools&&style&&pulse&&hidden&&reuse&&phase&&cards&&hook&&cancel?"PASS: correct empty staff/tool slots, FFEFD1 pulse, no raycast blocking, reuse, phase/card exclusions, real drag end/disable cleanup":$"FAIL staff={staff} tools={tools} style={style} pulse={pulse} hidden={hidden} reuse={reuse} phase={phase} cards={cards} hook={hook} cancel={cancel}";
            }
            finally {Object.Destroy(root);System.IO.File.WriteAllText("Document/drop-hints-verification.txt",report);Debug.Log("WORKWORK_DROP_HINTS "+report);}
        }
        static Button Button(Transform parent,string name)
        {
            var obj=new GameObject(name,typeof(RectTransform),typeof(Image),typeof(Button));obj.transform.SetParent(parent,false);return obj.GetComponent<Button>();
        }
    }
}
