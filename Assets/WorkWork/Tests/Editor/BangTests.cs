using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class BangTests
    {
        [Serializable] class Source {public List<Content> content;}
        static Content Bang()=>JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json")).content.Single(c=>c.id=="item.Bang");
        static Settings Config()=>new Settings{initialCash=100,content=new List<Content>{new Content{id="staff",price=4},Bang()}};
        [Test] public void UniqueEquipmentCannotBeBoughtTwiceAndReturnsToPoolAfterSaleAndReload()
        {
            var config=Config();var g=new GameSession(config,19);var s=g.State;
            Assert.IsTrue(g.Buy("staff",0));Assert.IsTrue(g.Buy("item.Bang",0));
            Assert.IsTrue(g.RefreshShop());CollectionAssert.DoesNotContain(s.offers,"item.Bang");
            // Even a stale shelf cannot bypass the ownership guard.
            s.offers[3]="item.Bang";int cash=s.cash;
            Assert.IsFalse(g.Buy("item.Bang",0,1));Assert.AreEqual(cash,s.cash);Assert.IsNull(s.items[1]);
            g=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(s)));s=g.State;
            Assert.IsFalse(g.Buy("item.Bang",0,1));Assert.AreEqual(1,s.items.Count(id=>id=="item.Bang"));
            Assert.IsTrue(g.Sell(0,true));Assert.IsTrue(g.RefreshShop());CollectionAssert.Contains(s.offers,"item.Bang");
            Assert.IsTrue(g.Buy("item.Bang",0,2));Assert.AreEqual(1,s.items.Count(id=>id=="item.Bang"));
        }
        [Test] public void UniqueFlagIsPerDefinitionAndChecksActualHeldSlots()
        {
            var s=new GameState();var bang=Bang();
            Assert.AreEqual("昨日的酒",bang.name);Assert.AreEqual(4,bang.price);Assert.IsTrue(bang.unique);
            s.items[17]=bang.id;Assert.IsFalse(ContentRules.CanAcquire(s,bang));
            Assert.IsTrue(ContentRules.CanAcquire(s,new Content{id=bang.id,item=true}));
            s.items[17]=null;Assert.IsTrue(ContentRules.CanAcquire(s,bang));
            s.employees[4]="staff";Assert.IsFalse(ContentRules.CanAcquire(s,new Content{id="staff"}));
        }
        [Test] public void BangAddsFiftyAtItsEquipmentStepEvenWhenItsOwnSlotHasNoCard()
        {
            var s=new GameState();s.employees[0]="staff";s.items[0]="item.Bang";
            s.slots[1]=new Card{id=1,rank=3,suit=Suit.Clubs};
            var score=Scoring.Evaluate(s,Config());var step=score.steps.Single(x=>x.label=="昨日的酒");
            Assert.AreEqual(ScoreSource.Item,step.source);Assert.AreEqual(0,step.sourceSlot);Assert.AreEqual(0,step.equipmentSlot);
            Assert.AreEqual(50,step.chipsDelta);Assert.AreEqual(53,score.chips);Assert.AreEqual(1,score.multiplier);
            s.items[0]=null;Assert.AreEqual(3,Scoring.Evaluate(s,Config()).chips);
        }
        [Test] public void RhythmCompressesThenJumpsAndRepeatsOnBeat()
        {
            var root=new GameObject("Bang rhythm test");
            try
            {
                var feedback=root.AddComponent<WorkWork.BangFeedback>();feedback.beatsPerMinute=120;feedback.beatOffset=0;float scale,lift;
                feedback.EvaluateAt(0,out scale,out lift);Assert.AreEqual(.84f,scale,.001f);Assert.AreEqual(0,lift,.001f);
                feedback.EvaluateAt(.25f,out scale,out lift);Assert.AreEqual(1.04f,scale,.001f);Assert.AreEqual(7,lift,.001f);
                feedback.EvaluateAt(.5f,out scale,out lift);Assert.AreEqual(.84f,scale,.001f);Assert.AreEqual(0,lift,.001f);
            }
            finally{UnityEngine.Object.DestroyImmediate(root);}
        }
        [Test] public void PortraitMeshRestoresAfterSaleAndDoesNotAlterLayout()
        {
            var root=new GameObject("Bang mesh test",typeof(RectTransform));var catalog=ScriptableObject.CreateInstance<WorkWork.GameCatalog>();
            try
            {
                var game=root.AddComponent<WorkWork.GameController>();catalog.rules=Config();game.catalog=catalog;
                var session=new GameSession(catalog.rules,19);session.State.items[0]="item.Bang";
                typeof(WorkWork.GameController).GetProperty("Session").SetValue(game,session);
                var feedback=root.AddComponent<WorkWork.BangFeedback>();feedback.game=game;
                var child=new GameObject("Portrait",typeof(RectTransform),typeof(CanvasRenderer),typeof(Image));child.transform.SetParent(root.transform,false);
                var image=child.GetComponent<Image>();feedback.Bind(image);var motion=child.GetComponent<WorkWork.BangPortraitMotion>();
                var rect=image.rectTransform;rect.anchoredPosition=new Vector2(20,30);rect.localScale=new Vector3(2,3,1);
                using(var mesh=new VertexHelper())
                {
                    mesh.AddVert(new Vector3(0,0,0),Color.white,Vector2.zero);mesh.AddVert(new Vector3(0,100,0),Color.white,Vector2.up);
                    float scale,lift;feedback.Pose(out scale,out lift);Assert.IsTrue(feedback.IsDancing);motion.ModifyMesh(mesh);
                    var vertex=new UIVertex();mesh.PopulateUIVertex(ref vertex,1);Assert.AreEqual(100*scale+lift,vertex.position.y,.001f);
                    Assert.AreEqual(new Vector2(20,30),rect.anchoredPosition);Assert.AreEqual(new Vector3(2,3,1),rect.localScale);
                    session.State.items[0]=null;Assert.IsFalse(feedback.IsDancing);
                    mesh.Clear();mesh.AddVert(new Vector3(0,100,0),Color.white,Vector2.zero);motion.ModifyMesh(mesh);
                    mesh.PopulateUIVertex(ref vertex,0);Assert.AreEqual(100,vertex.position.y);
                }
            }
            finally{UnityEngine.Object.DestroyImmediate(root);UnityEngine.Object.DestroyImmediate(catalog);}
        }
    }
}
