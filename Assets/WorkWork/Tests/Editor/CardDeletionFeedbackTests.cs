using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;
namespace WorkWork.Tests
{
    public class CardDeletionFeedbackTests
    {
        [Serializable] class Source{public List<Content> content;}
        static Settings Config()=>new Settings{content=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json")).content};
        static GameState Board(params int[] ranks)
        {var s=new GameState{randomState=19};for(int i=0;i<ranks.Length;i++)s.slots[i]=new Card{id=i+1,rank=ranks[i],suit=(Suit)(i%4)};return s;}
        [TestCase("employee.10")] [TestCase("employee.28")]
        public void OwnCardDeletionRecordsActualCardAfterItsNormalScore(string employee)
        {
            var s=Board(2);s.employees[0]=employee;var r=Scoring.Evaluate(s,Config());var step=r.steps.Single(x=>x.deletedCards.Count>0);
            Assert.AreEqual(ScoreSource.Employee,step.source);Assert.AreEqual(1,step.deletedCards.Single().id);Assert.IsNull(r.resolvedState.slots[0]);Assert.IsNotNull(s.slots[0]);
            Assert.Greater(r.steps.IndexOf(step),r.steps.FindIndex(x=>x.source==ScoreSource.Card));
        }
        [Test] public void LampRescoresCopyAndRetryBeforeItsItemDeletionEventAndDeletesEachCardOnce()
        {
            var s=Board(2,0,4);s.slots[1].AddEnchantment(Enchantment.Copy);s.slots[1].AddEnchantment(Enchantment.Retry);s.items[0]="item.C4";s.items[1]="item.C4";
            var r=Scoring.Evaluate(s,Config());var deletions=r.steps.Where(x=>x.deletedCards.Count>0).ToArray();Assert.AreEqual(2,deletions.Length);
            Assert.AreEqual(2,deletions.SelectMany(x=>x.deletedCards).Select(c=>c.id).Distinct().Count());Assert.IsTrue(deletions.All(x=>x.source==ScoreSource.Item && x.sourceSlot==0 && x.equipmentSlot==0));
            var right=deletions.Single(x=>x.deletedCards[0].id==2);int at=r.steps.IndexOf(right);
            Assert.IsTrue(r.steps.Take(at).Any(x=>x.copiedCard!=null));Assert.IsTrue(r.steps.Take(at).Any(x=>x.extraRedrawDelta==1));Assert.AreEqual(1,r.copies.Count);Assert.AreEqual(1,r.extraRedraws);
        }
        [Test] public void PhotographDeletesOnlyExistingCardsAsOneBatchWithoutRescoring()
        {
            var s=Board(2,3,4);s.items[3]="item.3men";var r=Scoring.Evaluate(s,Config());var step=r.steps.Single(x=>x.deletedCards.Count>0);
            Assert.AreEqual(3,step.deletedCards.Count);Assert.AreEqual(6,step.multiplierDelta);Assert.AreEqual(2,r.steps.Count(x=>x.source==ScoreSource.Card));
        }
        [Test] public void LawReportsHiddenVictimsWithIndependentSnapshotsAndNeverDeletesProtectedCard()
        {
            var s=Board(4);s.employees[0]="employee.09";s.deck.Add(new Card{id=10,rank=0});s.discard.Add(new Card{id=11,rank=2});
            var core=new Card{id=12,rank=1};core.AddEnchantment(Enchantment.Coin);s.deck.Add(core);
            var r=Scoring.Evaluate(s,Config());var cards=r.steps.SelectMany(x=>x.deletedCards).ToArray();CollectionAssert.AreEquivalent(new[]{10,11},cards.Select(c=>c.id));
            cards[0].rank=99;Assert.IsFalse(s.deck.Concat(s.discard).Any(c=>c.rank==99));Assert.IsTrue(r.resolvedState.deck.Any(c=>c.id==12));
        }
        [Test] public void IneligibleDeletionDoesNotEmitAnimation()
        {
            var s=Board(6);s.employees[0]="employee.28";Assert.IsFalse(Scoring.Evaluate(s,Config()).steps.Any(x=>x.deletedCards.Count>0));
            s.employees[0]="employee.09";Assert.IsFalse(Scoring.Evaluate(s,Config()).steps.Any(x=>x.deletedCards.Count>0));
        }
    }
}
