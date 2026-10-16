using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;
namespace WorkWork.Tests
{
    public class ConditionFeedbackTests
    {
        [Serializable] class Source{public List<Content> content;}
        static Settings Config()=>new Settings{content=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json")).content};
        static GameState Board(params int[] ranks)
        {var s=new GameState{randomState=19};for(int i=0;i<ranks.Length;i++)s.slots[i]=new Card{id=i+1,rank=ranks[i],suit=(Suit)(i%4)};return s;}
        static ScoreStep Employee(ScoreResult r,int slot)=>r.steps.Last(x=>x.source==ScoreSource.Employee && x.sourceSlot==slot);
        [Test] public void CustomerServiceHighlightsOnlyHeartsAndHasNoConditionTargetsWithoutHearts()
        {
            var s=Board(1,2,3,4);s.slots[0].suit=Suit.Hearts;s.employees[0]="employee.01";
            CollectionAssert.AreEquivalent(new[]{1,2},Employee(Scoring.Evaluate(s,Config()),0).linkedCardIds);
            s.slots[0].suit=s.slots[1].suit=Suit.Spades;Assert.IsFalse(ConditionFeedback.HasTargets(Employee(Scoring.Evaluate(s,Config()),0)));
        }
        [Test] public void ArtCountsNewSuitAfterItsOwnRecolor()
        {
            var s=Board(1,2,3);s.employees[0]="employee.02";var r=Scoring.Evaluate(s,Config());
            CollectionAssert.AreEquivalent(new[]{1,3},Employee(r,0).linkedCardIds);Assert.AreEqual(Suit.Spades,s.slots[0].suit);
        }
        [Test] public void BusinessLinksOnlySelfAndImmediateMatchingNeighbors()
        {
            var s=Board(1,2,3,4,5);s.employees[1]="employee.12";var r=Scoring.Evaluate(s,Config());
            CollectionAssert.AreEquivalent(new[]{1,2,3},Employee(r,1).linkedCardIds);
        }
        [Test] public void AffixCounterCountsEachPhysicalCardOnceAndIgnoresOtherAffixes()
        {
            var s=Board(5,6,4);s.employees[0]="employee.19";s.slots[0].AddEnchantment(Enchantment.Fans);s.slots[0].AddEnchantment(Enchantment.Coin);s.slots[0].AddEnchantment(Enchantment.X2);
            s.slots[2].AddEnchantment(Enchantment.Fans);CollectionAssert.AreEquivalent(new[]{1,3},Employee(Scoring.Evaluate(s,Config()),0).linkedCardIds);
        }
        [Test] public void SameRankDoesNotIncludeNewDeckCopyOrDifferentBoardRanks()
        {
            var s=Board(4,4,2);s.employees[0]="employee.13";var r=Scoring.Evaluate(s,Config());CollectionAssert.AreEquivalent(new[]{1,2},Employee(r,0).linkedCardIds);
            Assert.AreEqual(1,r.copies.Count);CollectionAssert.DoesNotContain(Employee(r,0).linkedCardIds,r.copies[0].id);
        }
        [Test] public void AllEvenRequiresActualSuccessAndDoesNotLeakTargetsToNextFixedItem()
        {
            var s=Board(2,4);s.items[0]="item.Rail";s.items[1]="item.BenZai";var r=Scoring.Evaluate(s,Config());
            CollectionAssert.AreEquivalent(new[]{1,2},r.steps.Single(x=>x.source==ScoreSource.Item && x.equipmentSlot==0).linkedCardIds);
            Assert.IsFalse(ConditionFeedback.HasTargets(r.steps.Single(x=>x.source==ScoreSource.Item && x.equipmentSlot==1)));
            s.slots[1].rank=3;r=Scoring.Evaluate(s,Config());Assert.IsFalse(ConditionFeedback.HasTargets(r.steps.Single(x=>x.source==ScoreSource.Item && x.equipmentSlot==0)));
        }
        [Test] public void RankToolConditionUsesValuesAfterEarlierItemChanges()
        {
            var s=Board(1,3,4);s.items[0]="item.Potato";s.items[3]="item.Light4";var r=Scoring.Evaluate(s,Config());
            CollectionAssert.AreEquivalent(new[]{2,3},r.steps.Single(x=>x.source==ScoreSource.Item && x.sourceSlot==1).linkedCardIds);
        }
        [Test] public void EmployeeEquipmentAndEmptyConditionsTargetTheirActualUiObjects()
        {
            var s=Board(1);s.employees[0]="employee.11";s.employees[2]="employee.14";s.items[6]="item.BenZai";s.items[8]="item.Farmer";var r=Scoring.Evaluate(s,Config());
            CollectionAssert.AreEqual(new[]{2},Employee(r,0).linkedEmployeeSlots);CollectionAssert.AreEqual(new[]{6,8},Employee(r,2).linkedItemSlots);
            s.employees[0]="employee.10";r=Scoring.Evaluate(s,Config());CollectionAssert.AreEquivalent(new[]{0,1,2,3,4,5},Employee(r,0).linkedEmptySlots);
        }
        [Test] public void WildHighlightsOnlyCurrentSameSuitCardsAndHistoryUsesInitialPatternCards()
        {
            var s=Board(1,2,3);s.slots[0].AddEnchantment(Enchantment.Wild);s.slots[2].suit=Suit.Spades;var r=Scoring.Evaluate(s,Config());
            CollectionAssert.AreEquivalent(new[]{1,3},r.steps.First(x=>x.source==ScoreSource.Card).linkedCardIds);
            s=Board(2,2,2,2,3,4);s.items[0]="item.Potato";s.items[3]="item.TNT";r=Scoring.Evaluate(s,Config());
            CollectionAssert.AreEquivalent(new[]{1,2,3,4},r.steps.Single(x=>x.label=="TNT").linkedCardIds);
        }
        [Test] public void DistinctSuitHighlightsOneRepresentativePerSuitAndPreviewIsPure()
        {
            var s=Board(1,2,3,4,5);s.employees[0]="employee.26";s.slots[4].suit=Suit.Spades;
            string before=WorkWork.SaveCodec.Serialize(s);var r=Scoring.Evaluate(s,Config());Assert.AreEqual(4,Employee(r,0).linkedCardIds.Count);
            Assert.AreEqual(before,WorkWork.SaveCodec.Serialize(s));
        }
    }
}
