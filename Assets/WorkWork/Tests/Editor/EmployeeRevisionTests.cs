using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class EmployeeRevisionTests
    {
        [Serializable] class Source { public List<Content> content; }
        static Settings Config() => new Settings {content=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json")).content};
        static Card Card(int id,int rank,Suit suit=Suit.Spades) => new Card{id=id,rank=rank,suit=suit};
        static GameState Board(params Card[] cards)
        {
            var s=new GameState{randomState=19};for(int i=0;i<cards.Length;i++)s.slots[i]=cards[i];return s;
        }
        static string Staff(int n) => "employee."+n.ToString("00");
        static ScoreResult Evaluate(GameState s,int staff,int slot=0) {s.employees[slot]=Staff(staff);return Scoring.Evaluate(s,Config());}
        static IEnumerable<ScoreStep> EmployeeSteps(ScoreResult r,int slot=0) => r.steps.Where(x=>x.source==ScoreSource.Employee && x.sourceSlot==slot);
        static GameSession Reload(GameSession g) => SessionFixture.Playing(g.Config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));

        [TestCase(1,Enchantment.Coin,12)] [TestCase(3,Enchantment.Retry,2)] [TestCase(4,Enchantment.Copy,2)]
        [TestCase(8,Enchantment.Fans,8)] [TestCase(15,Enchantment.Coin,12)] [TestCase(17,Enchantment.Arrow,8)]
        [TestCase(19,Enchantment.Fans,8)] [TestCase(20,Enchantment.Wild,12)] [TestCase(32,Enchantment.Coin,8)]
        public void OwnedCoverageMatchesRevisedFullSuitOrRankAndUtilityStaysPrecise(int staff,Enchantment enchantment,int count)
        {
            var g=SessionFixture.Playing(Config(),19);g.State.phase=Phase.Shop;g.State.cash=100;g.State.offers.Add(Staff(staff));
            Assert.IsTrue(g.Buy(Staff(staff),0));Assert.AreEqual(count,ContentRules.AllCards(g.State).Count(c=>c.enchantments.Contains(enchantment)));
            Assert.IsTrue(g.Sell(0,false));Assert.IsFalse(ContentRules.AllCards(g.State).Any(c=>c.enchantments.Contains(enchantment)));
        }
        [Test] public void RefreshKeepsExistingValidSlotsAndMergesSharedSourcesWithoutEviction()
        {
            var s=Board(Card(1,2,Suit.Hearts));s.employees[0]=Staff(1);s.acquired.Add(Staff(1));var c=s.slots[0];
            ContentRules.RefreshEnchantments(s,Config());c.AddEnchantment(Enchantment.Fans,"staff:"+Staff(23));s.employees[1]=Staff(23);
            c.AddEnchantment(Enchantment.Wild);c.AddEnchantment(Enchantment.X2);
            s.employees[2]=Staff(17);s.acquired.Add(Staff(17));ContentRules.RefreshEnchantments(s,Config());
            CollectionAssert.AreEquivalent(new[]{Enchantment.Coin,Enchantment.Fans,Enchantment.Wild,Enchantment.X2},c.enchantments);
            s.employees[3]=Staff(19);s.acquired.Add(Staff(19));ContentRules.RefreshEnchantments(s,Config());
            s.employees[1]=null;ContentRules.RefreshEnchantments(s,Config());Assert.Contains(Enchantment.Fans,c.enchantments);
            s.employees[3]=null;ContentRules.RefreshEnchantments(s,Config());Assert.IsFalse(c.enchantments.Contains(Enchantment.Fans));Assert.Contains(Enchantment.Arrow,c.enchantments);
        }
        [Test] public void CustomerServiceAndArtUseUserEditedRewards()
        {
            var s=Board(Card(1,2,Suit.Hearts),Card(2,3,Suit.Hearts));var r=Evaluate(s,1);
            Assert.AreEqual(8,EmployeeSteps(r).Single().multiplierDelta);
            s=Board(Card(1,2,Suit.Hearts),Card(2,3,Suit.Clubs));r=Evaluate(s,2);
            Assert.AreEqual(Suit.Clubs,r.resolvedState.slots[0].suit);Assert.AreEqual(40,EmployeeSteps(r).Single().chipsDelta);
        }
        [Test] public void TestingUsesSuccessfulRedrawsNotRetryTriggersAndMonthResetsCounter()
        {
            var g=SessionFixture.Playing(Config(),19);g.State.employees[0]=Staff(3);g.State.redraws=0;Assert.IsFalse(g.Redraw());
            g.State.redraws=2;Assert.IsTrue(g.Redraw());Assert.IsTrue(g.Redraw());g.State.slots[0]=Card(500,6);
            var r=Scoring.Evaluate(g.State,g.Config);Assert.AreEqual(20,EmployeeSteps(r).Single().chipsDelta);Assert.AreEqual(1,r.extraRedraws);
            g=Reload(g);Assert.AreEqual(2,g.State.monthRedraws);g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(0,g.State.monthRedraws);
        }
        [Test] public void MusicGrantsWildBeforeItsExtraScoreWithoutReplayingOtherEnchantments()
        {
            var s=Board(Card(1,3,Suit.Hearts),Card(2,2,Suit.Diamonds));s.slots[0].AddEnchantment(Enchantment.Retry);
            var r=Evaluate(s,6);Assert.Contains(Enchantment.Wild,r.resolvedState.slots[0].enchantments);Assert.AreEqual(1,r.extraRedraws);
            var cards=r.steps.Where(x=>x.source==ScoreSource.Card && x.slot==0 && x.extraRedrawDelta==0).ToArray();
            Assert.AreEqual(2,cards.Length);Assert.AreEqual(3,cards[0].chipsDelta);Assert.AreEqual(3,cards[1].chipsDelta);
            Assert.AreEqual(4,EmployeeSteps(r).Sum(x=>x.multiplierDelta));
            var again=Scoring.Evaluate(r.resolvedState,Config());Assert.AreEqual(2,again.resolvedState.slots[0].enchantments.Count);
        }
        [Test] public void MusicDoesNotReplaceFullEnchantmentsOrInventWildScore()
        {
            var s=Board(Card(1,3));foreach(var e in new[]{Enchantment.Coin,Enchantment.Fans,Enchantment.Arrow,Enchantment.X2})s.slots[0].AddEnchantment(e);
            var r=Evaluate(s,6);Assert.IsFalse(r.resolvedState.slots[0].enchantments.Contains(Enchantment.Wild));Assert.IsFalse(r.steps.Any(x=>x.label=="“同花加分”额外结算"));
        }
        [Test] public void OperationsCreatesSixZeroCardsButPaysOnlyCurrentBoardZerosAsChips()
        {
            var s=Board(Card(1,0),Card(2,0,Suit.Hearts));var r=Evaluate(s,7);
            Assert.AreEqual(6,r.resolvedState.deck.Count);Assert.IsTrue(r.resolvedState.deck.All(c=>c.rank==0));
            Assert.AreEqual(40,EmployeeSteps(r).Single().chipsDelta);Assert.AreEqual(0,EmployeeSteps(r).Single().multiplierDelta);Assert.AreEqual(6,r.resolvedState.weekAddedCards);
        }
        [Test] public void AdministrationDeletesAfterFaceScoringAndImmediatelyReadsNewEmptyAndSize()
        {
            var s=Board(Card(1,2));for(int i=0;i<44;i++)s.deck.Add(Card(10+i,4));var r=Evaluate(s,10);
            Assert.AreEqual(2,r.steps.First(x=>x.source==ScoreSource.Card).chipsDelta);Assert.IsNull(r.resolvedState.slots[0]);Assert.AreEqual(44,ContentRules.AllCards(r.resolvedState).Count());
            Assert.AreEqual(150,EmployeeSteps(r).Single().chipsDelta);Assert.AreEqual(5,EmployeeSteps(r).Single().multiplierDelta);
        }
        [TestCase(Suit.Hearts,Suit.Spades,Suit.Diamonds,6,30)]
        [TestCase(Suit.Spades,Suit.Clubs,Suit.Diamonds,3,0)]
        public void BusinessCopiesLeftNeighborAndThenReadsBothColors(Suit left,Suit own,Suit right,int multiplier,int chips)
        {
            var s=Board(Card(1,2,left),Card(2,3,own),Card(3,4,right));var r=Evaluate(s,12,1);
            Assert.AreEqual(left,r.resolvedState.slots[1].suit);Assert.AreEqual(multiplier,EmployeeSteps(r,1).Single().multiplierDelta);Assert.AreEqual(chips,EmployeeSteps(r,1).Single().chipsDelta);
        }
        [Test] public void BusinessUsesRightNeighborWhenLeftEmpty()
        {
            var s=new GameState();s.slots[1]=Card(1,3,Suit.Hearts);s.slots[2]=Card(2,5,Suit.Spades);var r=Evaluate(s,12,1);
            Assert.AreEqual(Suit.Spades,r.resolvedState.slots[1].suit);Assert.AreEqual(3,EmployeeSteps(r,1).Single().multiplierDelta);
        }
        [Test] public void ActivityCopiesOnceWithoutCountingDeckCopyAsBoardOrInheritingCopy()
        {
            var s=Board(Card(1,1));s.slots[0].AddEnchantment(Enchantment.Copy);s.slots[0].AddEnchantment(Enchantment.Retry);
            var r=Evaluate(s,13);Assert.AreEqual(2,r.copies.Count);Assert.AreEqual(1,r.extraRedraws);Assert.AreEqual(2,r.resolvedState.deck.Count);
            Assert.IsTrue(r.copies.All(c=>!c.enchantments.Contains(Enchantment.Copy) && c.enchantments.Contains(Enchantment.Retry)));
            Assert.AreEqual(0,EmployeeSteps(r).Sum(x=>x.chipsDelta));Assert.AreEqual(0,EmployeeSteps(r).Sum(x=>x.multiplierDelta));
            Assert.AreEqual(1,EmployeeSteps(r).Count(x=>x.copiedCard!=null));
        }
        [Test] public void ProofreaderMonthlyGrantQueuesOncePersistsAfterSaleAndResetsNextMonth()
        {
            var g=SessionFixture.Playing(Config(),19);g.State.phase=Phase.Shop;g.State.cash=100;g.State.offers.Add(Staff(16));Assert.IsTrue(g.Buy(Staff(16),0));
            Assert.IsTrue(g.Sell(0,false));g.State.offers.Add(Staff(16));Assert.IsTrue(g.Buy(Staff(16),0));g=Reload(g);Assert.IsTrue(g.NextMonth());
            Assert.AreEqual(54,ContentRules.AllCards(g.State).Count());Assert.AreEqual(6,ContentRules.AllCards(g.State).Count(c=>c.rank==0));
            g=Reload(g);Assert.AreEqual(54,ContentRules.AllCards(g.State).Count());g.State.phase=Phase.Shop;Assert.IsTrue(g.Sell(0,false));Assert.AreEqual(54,ContentRules.AllCards(g.State).Count());
            Assert.IsTrue(g.NextMonth());Assert.AreEqual(48,ContentRules.AllCards(g.State).Count());
        }
        [Test] public void ExistingPlayingSaveReceivesNewProofreaderGrantOnceWithoutRebuildingMonth()
        {
            var g=SessionFixture.Playing(Config(),19);g.State.employees[0]=Staff(16);g.State.monthScore=123;g.State.week=2;
            g=Reload(g);Assert.AreEqual(54,ContentRules.AllCards(g.State).Count());Assert.AreEqual(6,g.State.weekAddedCards);Assert.AreEqual(123,g.State.monthScore);Assert.AreEqual(2,g.State.week);
            g=Reload(g);Assert.AreEqual(54,ContentRules.AllCards(g.State).Count());
        }
        [Test] public void LegacyQueuedSevensMigrateWithoutDuplicatingOrLosingCards()
        {
            var g=SessionFixture.Playing(Config(),19);g.State.phase=Phase.Shop;g.State.monthGrantRecords.Add("2:employee.18");g.State.pendingSevenMonths.Add(2);
            g=Reload(g);Assert.IsEmpty(g.State.pendingSevenMonths);Assert.AreEqual(1,g.State.pendingMonthlyCards.Count);g.NextMonth();
            Assert.AreEqual(4,ContentRules.AllCards(g.State).Count(c=>c.rank==7));Assert.AreEqual(52,ContentRules.AllCards(g.State).Count());Assert.IsEmpty(g.State.pendingMonthlyCards);
        }
        [Test] public void NumericGrantsMissingOrdinaryEnchantmentsAndCanSupplyDouble()
        {
            bool foundDouble=false;
            for(uint seed=1;seed<=30;seed++)
            {
                var s=Board(Card(1,6));s.randomState=seed;var r=Evaluate(s,23);var c=r.resolvedState.slots[0];
                Assert.AreEqual(1,c.enchantments.Count);Assert.IsFalse(c.enchantments.Contains(Enchantment.Copy));Assert.IsFalse(c.enchantments.Contains(Enchantment.Retry));
                Assert.AreEqual(20,EmployeeSteps(r).Single().chipsDelta);foundDouble|=c.enchantments.Contains(Enchantment.X2);
            }
            Assert.IsTrue(foundDouble);
        }
        [Test] public void NumericFillsFourthSlotAndThenStopsWithoutConsumingRandomness()
        {
            var s=Board(Card(1,6));foreach(var e in new[]{Enchantment.Coin,Enchantment.Fans,Enchantment.Wild})s.slots[0].AddEnchantment(e);
            var r=Evaluate(s,23);Assert.AreEqual(4,r.resolvedState.slots[0].enchantments.Count);Assert.AreEqual(80,EmployeeSteps(r).Single().chipsDelta);Assert.AreEqual(4,EmployeeSteps(r).Single().multiplierDelta);
            var again=Scoring.Evaluate(r.resolvedState,Config());Assert.AreEqual(r.resolvedState.randomState,again.resolvedState.randomState);Assert.AreEqual(4,again.resolvedState.slots[0].enchantments.Count);
        }
        [Test] public void SupplierGeneratesMatchingOneAndAnyThreeToolsMultiplyBeforeToolRewards()
        {
            var s=Board(Card(1,4,Suit.Diamonds));for(int i=0;i<48;i++)s.deck.Add(Card(10+i,3));
            s.items[0]="item.BenZai";s.items[1]="item.Farmer";s.items[2]="item.Clock";
            var r=Evaluate(s,25);Assert.AreEqual(2,EmployeeSteps(r).Count());Assert.AreEqual(1,EmployeeSteps(r).First().multiplierDelta);
            Assert.IsTrue(EmployeeSteps(r).Last().multipliesMultiplier);Assert.AreEqual(8,r.multiplier);
            Assert.IsTrue(r.resolvedState.deck.Any(c=>c.rank==1 && c.suit==Suit.Diamonds));
            s.slots[0]=null;r=Scoring.Evaluate(s,Config());Assert.IsFalse(r.resolvedState.deck.Any(c=>c.rank==1));
        }
        [Test] public void LevelDesignAddsMissingSuitOnlyWhenItDoesNotRemoveUniqueSuit()
        {
            var s=Board(Card(1,1),Card(2,2),Card(3,3,Suit.Hearts),Card(4,4,Suit.Clubs));var r=Evaluate(s,26);
            Assert.AreEqual(Suit.Diamonds,r.resolvedState.slots[0].suit);Assert.AreEqual(24,EmployeeSteps(r).Single().multiplierDelta);
            s=Board(Card(1,1),Card(2,2,Suit.Hearts),Card(3,3,Suit.Clubs));r=Evaluate(s,26);
            Assert.AreEqual(Suit.Spades,r.resolvedState.slots[0].suit);Assert.AreEqual(12,EmployeeSteps(r).Single().multiplierDelta);
        }
        [Test] public void AnimationAddsArrowForExtraFaceOnlyAndDoesNotRepeatCopyOrRetry()
        {
            var s=Board(Card(1,3));s.slots[0].AddEnchantment(Enchantment.Copy);s.slots[0].AddEnchantment(Enchantment.Retry);var r=Evaluate(s,27);
            Assert.AreEqual(9,r.chips);Assert.AreEqual(1,r.copies.Count);Assert.AreEqual(1,r.extraRedraws);Assert.Contains(Enchantment.Arrow,r.resolvedState.slots[0].enchantments);
            s.slots[0]=null;r=Scoring.Evaluate(s,Config());Assert.AreEqual(0,EmployeeSteps(r).Single().chipsDelta);
        }
        [Test] public void EngineConvertsAndRaisesRankBeforeCheckingUniqueHighest()
        {
            var s=Board(Card(1,5,Suit.Hearts),Card(2,5,Suit.Diamonds));var r=Evaluate(s,30);
            Assert.AreEqual(Suit.Clubs,r.resolvedState.slots[0].suit);Assert.AreEqual(6,r.resolvedState.slots[0].rank);Assert.IsTrue(EmployeeSteps(r).Single().multipliesMultiplier);
            s.slots[1].rank=6;r=Scoring.Evaluate(s,Config());Assert.IsFalse(EmployeeSteps(r).Single().multipliesMultiplier);Assert.AreEqual(30,EmployeeSteps(r).Single().chipsDelta);
        }
        [Test] public void MarketManagerGeneratesItsOwnCoinSixAndReceivesOnlyItsActualCoinTriggers()
        {
            var s=Board(Card(1,6),Card(2,6,Suit.Hearts));var r=Evaluate(s,32);
            Assert.AreEqual(25,EmployeeSteps(r).Sum(x=>x.chipsDelta));Assert.AreEqual(1,r.resolvedState.deck.Count);
            Assert.Contains(Enchantment.Coin,r.resolvedState.deck[0].enchantments);Assert.AreEqual(6,r.resolvedState.deck[0].rank);
        }
        [Test] public void TechArtSelfStartsAndSaleRemovesOnlyItsFansSource()
        {
            var s=Board(Card(1,4,Suit.Diamonds));var r=Evaluate(s,33);var c=r.resolvedState.slots[0];
            Assert.AreEqual(Suit.Spades,c.suit);Assert.IsTrue(c.suitChangedThisMonth);Assert.Contains(Enchantment.Fans,c.enchantments);Assert.AreEqual(3,EmployeeSteps(r).Single().multiplierDelta);
            Assert.AreEqual(0,r.steps.First(x=>x.source==ScoreSource.Card).multiplierDelta);
            r.resolvedState.employees[0]=null;ContentRules.RefreshEnchantments(r.resolvedState,Config());Assert.IsEmpty(c.enchantments);
        }
        [Test] public void RecolorRemovesOwnedCoinForLaterReplayButKeepsAlreadyScoredChips()
        {
            var s=Board(Card(1,4,Suit.Hearts));s.employees[1]=Staff(1);s.items[0]="item.C4";var r=Evaluate(s,33);
            var cards=r.steps.Where(x=>x.source==ScoreSource.Card && x.slot==0).ToArray();Assert.AreEqual(24,cards[0].chipsDelta);Assert.AreEqual(4,cards[1].chipsDelta);Assert.AreEqual(4,cards[1].multiplierDelta);
        }
        [Test] public void PublisherPaysBelowTwentyOneIncludingAllZeroAndEmptyOwnSlot()
        {
            var s=Board(Card(1,0));var r=Evaluate(s,24,2);Assert.AreEqual(40,EmployeeSteps(r,2).Single().chipsDelta);
            s.slots[0]=null;r=Scoring.Evaluate(s,Config());Assert.AreEqual(40,EmployeeSteps(r,2).Single().chipsDelta);
        }
    }
}
