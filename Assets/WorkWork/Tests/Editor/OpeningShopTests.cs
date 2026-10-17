using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class OpeningShopTests
    {
        [Serializable] class Source { public List<Content> content;public List<TaskDefinition> tasks; }
        static Settings Config(int cash=100)
        {
            var source=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json"));
            return new Settings{firstTarget=400,initialCash=cash,content=source.content,tasks=source.tasks};
        }
        static GameSession Reload(GameSession g) => new GameSession(g.Config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));
        [Test] public void RefreshCostsOneThroughFiveAndResetsInNextShop()
        {
            var g=new GameSession(Config(15),19);
            for(int price=1;price<=5;price++)
            {
                Assert.AreEqual(price,g.RefreshPrice);
                int before=g.State.cash;Assert.IsTrue(g.RefreshShop());Assert.AreEqual(before-price,g.State.cash);
                g=Reload(g);Assert.AreEqual(price,g.State.refreshes);Assert.AreEqual(price+1,g.RefreshPrice);
            }
            g.State.cash=100;Assert.IsFalse(g.RefreshShop());Assert.AreEqual(100,g.State.cash);Assert.AreEqual(5,g.State.refreshes);
            Assert.IsTrue(g.NextMonth());g.State.phase=Phase.MonthResult;Assert.IsTrue(g.OpenShop());
            Assert.AreEqual(1,g.RefreshPrice);Assert.AreEqual(0,g.State.refreshes);
            g.State.cash=0;uint rng=g.State.randomState;var shelf=g.State.offers.ToArray();
            Assert.IsFalse(g.RefreshShop());Assert.AreEqual(0,g.State.refreshes);Assert.AreEqual(rng,g.State.randomState);
            CollectionAssert.AreEqual(shelf,g.State.offers);
            g.State.cash=1;Assert.IsTrue(g.RefreshShop());Assert.AreEqual(0,g.State.cash);
        }
        [Test] public void FirstShelfGuaranteesThreeDistinctStaffAtMostFiveAcrossSeeds()
        {
            var config=Config();
            for(uint seed=1;seed<=100;seed++)
            {
                var g=new GameSession(config,seed);var staff=g.State.offers.Take(3).ToArray();
                Assert.AreEqual(3,staff.Distinct().Count());
                Assert.IsTrue(staff.All(id=>config.content.Any(c=>c.id==id && !c.item && c.price<=5)),"Seed "+seed);
                var same=new GameSession(config,seed);
                CollectionAssert.AreEqual(g.State.offers,same.State.offers);
                Assert.AreEqual(g.State.randomState,same.State.randomState);
            }
        }
        [Test] public void FirstShelfLeavesMissingCheapStaffEmptyAndDoesNotRestrictTools()
        {
            var config=new Settings{content=new List<Content>{
                new Content{id="cheap",price=4},new Content{id="five",price=5},new Content{id="expensive",price=8},
                new Content{id="tool",item=true,price=8}}};
            var g=new GameSession(config,19);
            CollectionAssert.AreEquivalent(new string[]{"cheap","five",null},g.State.offers.Take(3));
            CollectionAssert.AreEqual(new string[]{"tool",null,null},g.State.offers.Skip(3));
        }
        [Test] public void RefreshAndLaterShopsUseFullStaffPool()
        {
            var config=new Settings{initialCash=100,content=new List<Content>{
                new Content{id="cheap",price=4},new Content{id="five",price=5},new Content{id="expensive",price=8}}};
            var g=new GameSession(config,19);
            Assert.IsTrue(g.Buy("cheap",0));Assert.IsTrue(g.RefreshShop());
            CollectionAssert.AreEquivalent(new string[]{"five","expensive",null},g.State.offers.Take(3));
            g.NextMonth();g.State.phase=Phase.MonthResult;Assert.IsTrue(g.OpenShop());
            CollectionAssert.AreEquivalent(new string[]{"five","expensive",null},g.State.offers.Take(3));
        }
        [Test] public void ReloadKeepsFirstShelfAndDoesNotReapplyGuaranteeAfterRefresh()
        {
            var g=new GameSession(Config(),19);var shelf=g.State.offers.ToArray();uint rng=g.State.randomState;
            g=Reload(g);CollectionAssert.AreEqual(shelf,g.State.offers);Assert.AreEqual(rng,g.State.randomState);
            Assert.IsTrue(g.RefreshShop());
            // A saved opening shop may already have refreshed into an unrestricted shelf.
            g.State.offers[0]="employee.04";shelf=g.State.offers.ToArray();rng=g.State.randomState;
            Assert.Greater(g.Config.content.Find(c=>c.id==shelf[0]).price,5);
            g=Reload(g);CollectionAssert.AreEqual(shelf,g.State.offers);Assert.AreEqual(rng,g.State.randomState);
        }
        [Test] public void NewGameStartsInStockedShopWithoutDrawingCardsOrPayingIncome()
        {
            var g=new GameSession(Config(5),19);var s=g.State;
            Assert.AreEqual(Phase.Shop,s.phase);Assert.IsTrue(s.openingShop);Assert.AreEqual(1,s.month);Assert.AreEqual(1,s.week);
            Assert.AreEqual(400,s.target);Assert.AreEqual(0,s.monthScore);Assert.AreEqual(5,s.cash);Assert.AreEqual(4,s.redraws);
            Assert.AreEqual(6,s.offers.Count);Assert.AreEqual(3,s.offers.Count(id=>g.Config.content.Any(c=>c.id==id && !c.item)));
            Assert.AreEqual(3,s.offers.Count(id=>g.Config.content.Any(c=>c.id==id && c.item)));
            Assert.IsEmpty(ContentRules.AllCards(s));Assert.IsEmpty(s.taskOffers);Assert.AreEqual(0,s.lastIncome);
            Assert.IsFalse(g.ScoreWeek());Assert.IsFalse(g.Redraw());Assert.IsFalse(g.OpenShop());
        }
        [Test] public void LeavingOpeningShopStartsFirstMonthAndOnlyLaterShopsAdvanceMonth()
        {
            var g=new GameSession(Config(5),19);Assert.IsTrue(g.NextMonth());var s=g.State;
            Assert.IsFalse(s.openingShop);Assert.AreEqual(Phase.Playing,s.phase);Assert.AreEqual(1,s.month);Assert.AreEqual(1,s.week);
            Assert.AreEqual(400,s.target);Assert.AreEqual(5,s.cash);Assert.AreEqual(6,s.hand.Count);Assert.AreEqual(48,ContentRules.AllCards(s).Count());Assert.IsFalse(g.NextMonth());
            s.week=4;s.monthScore=1000;g.Place(s.hand[0].id,0);Assert.IsTrue(g.ScoreWeek());Assert.AreEqual(Phase.MonthResult,s.phase);
            Assert.IsTrue(g.OpenShop());Assert.IsFalse(s.openingShop);Assert.AreEqual(500,s.target);Assert.IsTrue(g.NextMonth());Assert.AreEqual(2,s.month);
        }
        [Test] public void ContinuingOpeningShopRetainsShelfPurchasesMoneyAndRandomState()
        {
            var g=new GameSession(Config(),19);g.State.offers=new List<string>{"employee.01",null,null,null,null,null};
            Assert.IsTrue(g.Buy("employee.01",0));var stock=g.State.offers.Select(id=>id??"").ToArray();uint rng=g.State.randomState;int cash=g.State.cash;
            g=Reload(g);Assert.IsTrue(g.State.openingShop);Assert.AreEqual(Phase.Shop,g.State.phase);Assert.AreEqual(400,g.State.target);
            CollectionAssert.AreEqual(stock,g.State.offers.Select(id=>id??""));Assert.AreEqual(rng,g.State.randomState);Assert.AreEqual(cash,g.State.cash);Assert.AreEqual("employee.01",g.State.employees[0]);
            Assert.IsEmpty(ContentRules.AllCards(g.State));g.NextMonth();Assert.AreEqual(1,g.State.month);
            Assert.AreEqual(12,ContentRules.AllCards(g.State).Count(c=>c.enchantments.Contains(Enchantment.Coin)));
        }
        [Test] public void OpeningMonthlyEmployeesGrantFirstMonthOnceEvenAfterSaleAndReload()
        {
            var g=new GameSession(Config(),19);g.State.offers=new List<string>{"employee.16","employee.18",null,null,null,null};
            Assert.IsTrue(g.Buy("employee.16",0));Assert.IsTrue(g.Buy("employee.18",1));Assert.IsTrue(g.Sell(0,false));
            g.State.offers[0]="employee.16";Assert.IsTrue(g.Buy("employee.16",0));Assert.AreEqual(2,g.State.pendingMonthlyCards.Count);
            Assert.IsTrue(g.State.pendingMonthlyCards.All(x=>x.month==1));g=Reload(g);g.NextMonth();
            Assert.AreEqual(1,g.State.month);Assert.AreEqual(58,ContentRules.AllCards(g.State).Count());Assert.AreEqual(6,ContentRules.AllCards(g.State).Count(c=>c.rank==0));
            Assert.AreEqual(4,ContentRules.AllCards(g.State).Count(c=>c.rank==7));Assert.AreEqual(10,g.State.weekAddedCards);
            g=Reload(g);Assert.AreEqual(58,ContentRules.AllCards(g.State).Count());Assert.IsEmpty(g.State.pendingMonthlyCards);
            g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(2,g.State.month);Assert.AreEqual(58,ContentRules.AllCards(g.State).Count());
        }
        [Test] public void OpeningFreeRefreshAndDiscountsBelongToMonthOne()
        {
            var g=new GameSession(Config(),19);g.State.employees[0]="employee.11";g.State.employees[1]="employee.14";g.State.employees[2]="employee.29";
            g.State.offers=new List<string>{"employee.02",null,null,"item.BenZai",null,null};
            Assert.AreEqual(4,g.PurchasePrice("employee.02"));Assert.IsTrue(g.Buy("employee.02",3));Assert.AreEqual(1,g.State.staffDiscountMonth);
            Assert.AreEqual(2,g.PurchasePrice("item.BenZai"));Assert.IsTrue(g.Buy("item.BenZai",3));Assert.AreEqual(1,g.State.itemDiscountMonth);
            Assert.AreEqual(0,g.RefreshPrice);Assert.IsTrue(g.RefreshShop());Assert.AreEqual(1,g.State.freeRefreshMonth);g=Reload(g);
            Assert.AreEqual(2,g.RefreshPrice);g.NextMonth();Assert.AreEqual(5,g.PurchasePrice("employee.02"));Assert.AreEqual(3,g.PurchasePrice("item.BenZai"));
            g.State.phase=Phase.MonthResult;g.OpenShop();Assert.AreEqual(4,g.PurchasePrice("employee.02"));Assert.AreEqual(0,g.RefreshPrice);
        }
        [Test] public void OpeningLimitedToolPurchaseCountsFirstMonthAsItsFirstAgeMonth()
        {
            var g=new GameSession(Config(),19);g.State.offers=new List<string>{"employee.01",null,null,"item.Bing",null,null};
            Assert.IsTrue(g.Buy("employee.01",0));Assert.IsTrue(g.Buy("item.Bing",0));Assert.AreEqual(1,g.State.itemBoughtMonths[0]);
            g=Reload(g);g.NextMonth();Assert.AreEqual(1,g.State.itemBoughtMonths[0]);
            for(int month=1;month<=3;month++)
            {
                g.State.week=4;g.State.monthScore=10000;g.Place(g.State.hand[0].id,0);Assert.IsTrue(g.ScoreWeek());
                if(month<3){Assert.AreEqual("item.Bing",g.State.items[0]);g.OpenShop();g.NextMonth();}else Assert.IsNull(g.State.items[0]);
            }
        }
        [Test] public void LegacyPlayingAndMonthEndShopSavesDoNotGainOpeningShop()
        {
            var c=Config();var playing=new GameState{month=1,phase=Phase.Playing,target=333,cash=17,randomState=19};
            var g=new GameSession(c,1,playing);Assert.AreEqual(Phase.Playing,g.State.phase);Assert.IsFalse(g.State.openingShop);Assert.AreEqual(333,g.State.target);
            var shop=new GameState{month=1,phase=Phase.Shop,target=333,cash=17,randomState=19};
            g=new GameSession(c,1,shop);Assert.IsFalse(g.State.openingShop);Assert.AreEqual(500,g.State.target);g.NextMonth();Assert.AreEqual(2,g.State.month);
        }
        [Test] public void TaskOfferScheduleStillStartsAtMonthFourAfterOpeningShop()
        {
            var g=new GameSession(Config(),19);Assert.IsEmpty(g.State.taskOffers);g.NextMonth();Assert.IsEmpty(g.State.taskOffers);
            for(int month=2;month<=4;month++){g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(month,g.State.month);Assert.AreEqual(month==4?Phase.TaskChoice:Phase.Playing,g.State.phase);}
            Assert.AreEqual(4,g.State.taskOffers.Count);
        }
    }
}
