using System.Collections;
using System.Linq;
using UnityEditor;
using UnityEngine;
using WorkWork.Core;
namespace WorkWork.Editor
{
    public static class CardMotionVerification
    {
        [MenuItem("WorkWork/Verify Card Motion")]
        public static void Run()
        {
            if(!EditorApplication.isPlaying)return;
            var runner=Object.FindObjectOfType<GameController>();runner.StartCoroutine(Check(runner));
        }
        static IEnumerator Check(GameController runner)
        {
            var root=new GameObject("Temporary Card Motion Verification",typeof(RectTransform),typeof(Canvas));
            var fake=root.AddComponent<GameController>();fake.enabled=false;fake.theme=runner.theme;fake.cardPrefab=runner.cardPrefab;fake.canvas=root.GetComponent<Canvas>();fake.canvas.renderMode=RenderMode.ScreenSpaceOverlay;
            var motion=root.AddComponent<CardMotion>();var views=new CardView[6];
            for(int i=0;i<6;i++)
            {
                views[i]=Object.Instantiate(runner.cardPrefab,root.transform);views[i].Bind(new Card{id=i+1,rank=i+1},runner.theme,false);
                var rect=(RectTransform)views[i].transform;rect.anchoredPosition=new Vector2(-250+i*100,-80);rect.sizeDelta=new Vector2(70,108);
            }
            var homes=views.Select(v=>((RectTransform)v.transform).anchoredPosition).ToArray();string report="FAIL";
            try
            {
                var draw=motion.Fly(fake,views,true);draw.MoveNext();yield return null;
                var ghosts=root.GetComponentsInChildren<CardView>().Where(v=>!views.Contains(v)).ToArray();
                bool batch=ghosts.Length==6 && views.All(v=>v.GetComponent<CanvasGroup>().alpha==0);
                bool above=ghosts[0].transform.position.y>views[0].transform.position.y;
                bool ids=ghosts.Select(v=>v.BoundCard.id).SequenceEqual(views.Select(v=>v.BoundCard.id));
                while(draw.MoveNext())yield return draw.Current;yield return null;
                bool finish=views.All(v=>v.GetComponent<CanvasGroup>().alpha==1) && root.GetComponentsInChildren<CardView>().Length==6;
                bool positions=views.Select((v,i)=>((RectTransform)v.transform).anchoredPosition==homes[i]).All(value=>value);
                yield return motion.Fly(fake,views,false);yield return null;
                bool discard=views.All(v=>v.GetComponent<CanvasGroup>().alpha==1) && root.GetComponentsInChildren<CardView>().Length==6;
                var cancel=motion.Fly(fake,views,true);cancel.MoveNext();yield return null;motion.Clear();yield return null;
                bool restored=views.All(v=>v.GetComponent<CanvasGroup>().alpha==1) && root.GetComponentsInChildren<CardView>().Length==6;
                motion.entryPoint=new Vector2(.5f,-.5f);motion.landingLift=0;motion.tossAngle=45;
                var zero=motion.Fly(fake,views,true);zero.MoveNext();
                float floor=Bottom((RectTransform)views[0].transform,(RectTransform)root.transform);
                var first=root.GetComponentsInChildren<CardView>().First(v=>!views.Contains(v));float zeroBottom=Bottom((RectTransform)first.transform,(RectTransform)root.transform);
                motion.Clear();yield return null;
                motion.landingLift=50;var lifted=motion.Fly(fake,views,true);lifted.MoveNext();
                first=root.GetComponentsInChildren<CardView>().First(v=>!views.Contains(v));float liftedBottom=Bottom((RectTransform)first.transform,(RectTransform)root.transform);
                bool bounds=zeroBottom>=floor-.01f && liftedBottom>=floor+49.99f && Mathf.Abs(liftedBottom-zeroBottom-50)<.01f;
                motion.Clear();yield return null;
                motion.entryPoint=new Vector2(.5f,1.18f);var copy=views[0].BoundCard.Copy();copy.rank=6;copy.suit=Suit.Diamonds;copy.AddEnchantment(Enchantment.Coin);
                var send=motion.Fly(fake,new[]{views[0]},false,false,copy);send.MoveNext();
                first=root.GetComponentsInChildren<CardView>().First(v=>!views.Contains(v));
                bool copyMode=views[0].GetComponent<CanvasGroup>().alpha==1 && first.BoundCard.rank==6 && first.BoundCard.suit==Suit.Diamonds && first.BoundCard.enchantments.Contains(Enchantment.Coin);
                while(send.MoveNext())yield return send.Current;yield return null;
                copyMode=copyMode && root.GetComponentsInChildren<CardView>().Length==6 && views.All(v=>v.GetComponent<CanvasGroup>().alpha==1);
                report=batch&&above&&ids&&finish&&positions&&discard&&restored&&bounds&&copyMode ? "PASS: draw/discard, rotated card-bottom bound, Landing Lift 0/50, copy sends independent snapshot upward while original stays visible, cleanup and restore" : $"FAIL batch={batch} above={above} ids={ids} finish={finish} positions={positions} discard={discard} restored={restored} bounds={bounds} copy={copyMode}";
            }
            finally {Object.Destroy(root);System.IO.File.WriteAllText("Document/card-motion-verification.txt",report);Debug.Log("WORKWORK_CARD_MOTION "+report);}
        }
        static float Bottom(RectTransform rect,RectTransform canvas)
        {var corners=new Vector3[4];rect.GetWorldCorners(corners);return corners.Min(p=>canvas.InverseTransformPoint(p).y);}
    }
}
