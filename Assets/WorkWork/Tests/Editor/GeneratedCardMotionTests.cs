using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class GeneratedCardMotionTests
    {
        [Serializable] class Source{public List<Content> content;}
        static Settings Config()=>new Settings{initialCash=100,content=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json")).content};
        [TestCase("employee.07",6,0)] [TestCase("employee.32",1,6)] [TestCase("employee.25",1,1)]
        [TestCase("item.Clock",2,0)] [TestCase("item.NaiLong",2,0)]
        public void GeneratedCardsAreBatchedOnActualSourceStepWithIndependentSnapshots(string id,int count,int rank)
        {
            var s=new GameState{randomState=19};s.slots[1]=new Card{id=1,rank=4,suit=Suit.Diamonds};
            if(id.StartsWith("employee"))s.employees[1]=id;else s.items[4]=id;
            var r=Scoring.Evaluate(s,Config());var step=r.steps.Single(x=>x.generatedCards.Count>0);
            Assert.AreEqual(count,step.generatedCards.Count);Assert.IsTrue(step.generatedCards.All(c=>c.rank==rank));
            Assert.AreEqual(1,step.sourceSlot);Assert.AreEqual(id.StartsWith("employee")?ScoreSource.Employee:ScoreSource.Item,step.source);
            if(step.source==ScoreSource.Item)Assert.AreEqual(1,step.equipmentSlot);
            CollectionAssert.AreEquivalent(r.resolvedState.deck.Select(c=>c.id),step.generatedCards.Select(c=>c.id));Assert.IsEmpty(s.deck);
            step.generatedCards[0].rank=99;Assert.IsFalse(r.resolvedState.deck.Any(c=>c.rank==99));
        }
        [Test] public void CopiedCardsDoNotAlsoEmitGeneratedCardAnimation()
        {
            var s=new GameState{randomState=19};s.employees[0]="employee.13";s.slots[0]=new Card{id=1,rank=1};s.slots[0].AddEnchantment(Enchantment.Copy);
            var r=Scoring.Evaluate(s,Config());Assert.AreEqual(2,r.steps.Count(x=>x.copiedCard!=null));Assert.IsFalse(r.steps.Any(x=>x.generatedCards.Count>0));
        }
        [Test] public void RepeatedGeneratorsKeepSeparateSourceBatchesInEquipmentOrder()
        {
            var s=new GameState{randomState=19};s.slots[0]=new Card{id=1,rank=4};s.items[0]="item.Clock";s.items[1]="item.Clock";
            var steps=Scoring.Evaluate(s,Config()).steps.Where(x=>x.generatedCards.Count>0).ToArray();Assert.AreEqual(2,steps.Length);
            Assert.AreEqual(0,steps[0].equipmentSlot);Assert.AreEqual(1,steps[1].equipmentSlot);
            Assert.AreEqual(4,steps.SelectMany(x=>x.generatedCards).Select(c=>c.id).Distinct().Count());
        }
        [Test] public void MonthlyPresentationBatchesFollowActualGrantsAndDoNotReplayOnReload()
        {
            var config=Config();var g=new GameSession(config,19);g.State.offers=new List<string>{"employee.16","employee.18",null,null,null,null};
            Assert.IsTrue(g.Buy("employee.16",0));Assert.IsTrue(g.Buy("employee.18",1));Assert.IsEmpty(g.MonthlyGeneratedCards);g.NextMonth();
            Assert.AreEqual(2,g.MonthlyGeneratedCards.Count);Assert.AreEqual(6,g.MonthlyGeneratedCards.Single(b=>b.employeeId=="employee.16").cards.Count);
            var sevens=g.MonthlyGeneratedCards.Single(b=>b.employeeId=="employee.18").cards;Assert.AreEqual(4,sevens.Count);Assert.AreEqual(4,sevens.Select(c=>c.suit).Distinct().Count());
            Assert.AreEqual(58,ContentRules.AllCards(g.State).Count());
            var restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));Assert.IsEmpty(restored.MonthlyGeneratedCards);Assert.AreEqual(58,ContentRules.AllCards(restored.State).Count());
            g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(2,g.MonthlyGeneratedCards.Count);Assert.AreEqual(10,g.MonthlyGeneratedCards.Sum(b=>b.cards.Count));
        }
        [Test] public void GeneratedSixIncludesCurrentOwnedEnchantmentsInFlightSnapshot()
        {
            var s=new GameState{randomState=19};s.employees[0]="employee.32";s.slots[0]=new Card{id=1,rank=4};
            var card=Scoring.Evaluate(s,Config()).steps.SelectMany(x=>x.generatedCards).Single();Assert.Contains(Enchantment.Coin,card.enchantments);
        }
        [Test] public void MonthlyDealCanHideRootsWithoutCanvasGroupsAndCancelRestoresCustomAlpha()
        {
            var obj=new GameObject("Temporary Monthly Deal",typeof(GameController));
            try
            {
                var g=obj.GetComponent<GameController>();var a=new GameObject("Hand A",typeof(RectTransform),typeof(CanvasGroup));a.transform.SetParent(obj.transform);
                var b=new GameObject("Hand B",typeof(RectTransform));b.transform.SetParent(obj.transform);a.GetComponent<CanvasGroup>().alpha=.35f;
                g.handRoots=new[]{(RectTransform)a.transform,(RectTransform)b.transform};
                typeof(GameController).GetMethod("HideDealHand",System.Reflection.BindingFlags.Instance|System.Reflection.BindingFlags.NonPublic).Invoke(g,null);
                Assert.AreEqual(0,a.GetComponent<CanvasGroup>().alpha);Assert.AreEqual(0,b.GetComponent<CanvasGroup>().alpha);
                g.CancelScoring();Assert.AreEqual(.35f,a.GetComponent<CanvasGroup>().alpha);Assert.AreEqual(1,b.GetComponent<CanvasGroup>().alpha);
            }
            finally{UnityEngine.Object.DestroyImmediate(obj);}
        }
    }
}
