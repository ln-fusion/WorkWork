using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class EnchantmentFeedbackTests
    {
        [Serializable] class Source {public List<Content> content;}
        static Settings Config()=>new Settings{content=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json")).content};
        static GameState Board(string employee,int rank=4,Suit suit=Suit.Hearts)
        {
            var s=new GameState{randomState=19};s.employees[0]=employee;s.slots[0]=new Card{id=1,rank=rank,suit=suit};return s;
        }
        [Test] public void MusicGrantEventPrecedesExtraScoreAndPreviewDoesNotChangeRealCard()
        {
            var s=Board("employee.06");var r=Scoring.Evaluate(s,Config());
            var step=r.steps.Single(x=>x.enchantmentChanges.Count>0);
            Assert.AreEqual(ScoreSource.Employee,step.source);Assert.AreEqual(0,step.sourceSlot);
            Assert.IsEmpty(step.enchantmentChanges[0].before);CollectionAssert.AreEqual(new[]{Enchantment.Wild},step.enchantmentChanges[0].after);
            Assert.Less(r.steps.IndexOf(step),r.steps.FindIndex(x=>x.label=="“同花加分”额外结算"));Assert.IsEmpty(s.slots[0].enchantments);
        }
        [Test] public void FullSlotsAndDuplicateGrantDoNotProduceFalseAppearanceEvents()
        {
            var s=Board("employee.06");foreach(var e in new[]{Enchantment.Coin,Enchantment.Fans,Enchantment.Arrow,Enchantment.X2})s.slots[0].AddEnchantment(e);
            Assert.IsFalse(Scoring.Evaluate(s,Config()).steps.Any(x=>x.enchantmentChanges.Count>0));
            s.slots[0].enchantments.Clear();s.slots[0].enchantmentSources.Clear();s.slots[0].AddEnchantment(Enchantment.Wild);
            Assert.IsFalse(Scoring.Evaluate(s,Config()).steps.Any(x=>x.enchantmentChanges.Count>0));
        }
        [Test] public void RecolorCarriesRemovalAndAdditionInSameEmployeeEvent()
        {
            var s=Board("employee.33");s.employees[1]="employee.01";ContentRules.RefreshEnchantments(s,Config());
            var r=Scoring.Evaluate(s,Config());var change=r.steps.First(x=>x.source==ScoreSource.Employee && x.sourceSlot==0).enchantmentChanges.Single();
            CollectionAssert.AreEqual(new[]{Enchantment.Coin},change.before);CollectionAssert.AreEqual(new[]{Enchantment.Fans},change.after);
            Assert.Contains(Enchantment.Coin,s.slots[0].enchantments);
        }
        [Test] public void HiddenGeneratedAndCopiedCardsDoNotCreateExtraAppearanceEvents()
        {
            var s=Board("employee.32",6);ContentRules.RefreshEnchantments(s,Config());
            s.slots[0].AddEnchantment(Enchantment.Copy);var r=Scoring.Evaluate(s,Config());
            Assert.AreEqual(2,r.resolvedState.deck.Count);Assert.IsFalse(r.steps.Any(x=>x.enchantmentChanges.Count>0));
        }
        [Test] public void TransactionDiffIgnoresNewCardsAndRemovedSourcesThatStillHaveAnotherSource()
        {
            var s=Board("employee.01",6);s.employees[1]="employee.32";ContentRules.RefreshEnchantments(s,Config());
            var before=new Dictionary<int,List<Enchantment>>{{1,s.slots[0].enchantments.ToList()}};
            s.employees[0]=null;ContentRules.RefreshEnchantments(s,Config());
            Assert.IsEmpty(EnchantmentFeedback.Changes(before,s.slots.Where(c=>c!=null)));
            s.employees[1]=null;ContentRules.RefreshEnchantments(s,Config());
            var changes=EnchantmentFeedback.Changes(before,s.slots.Where(c=>c!=null));Assert.AreEqual(1,changes.Count);Assert.IsEmpty(changes[0].after);
            Assert.IsEmpty(EnchantmentFeedback.Changes(before,new[]{new Card{id=2,enchantments=new List<Enchantment>{Enchantment.Coin}}}));
        }
        [Test] public void PresentationOverrideDoesNotModifyCardOrSurviveExplicitReset()
        {
            var obj=new GameObject("Temporary Card View");
            try
            {
                var view=obj.AddComponent<CardView>();view.PresentEnchantments(new[]{Enchantment.Fans,Enchantment.Fans});
                Assert.AreEqual(1,view.DisplayedEnchantments.Count);Assert.IsNull(view.BoundCard);view.ResetPresentedEnchantments();Assert.IsNull(view.DisplayedEnchantments);
            }
            finally{UnityEngine.Object.DestroyImmediate(obj);}
        }
    }
}
