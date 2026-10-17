using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class FinalContentTests
    {
        [Serializable] class Source {public long firstTarget;public List<Content> content;public List<TaskDefinition> tasks;}
        static Settings Config()
        {
            var source=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json"));
            return new Settings{firstTarget=source.firstTarget,content=source.content,tasks=source.tasks};
        }
        static Card Card(int id,int rank,Suit suit=Suit.Spades)=>new Card{id=id,rank=rank,suit=suit};
        static GameState Board(params int[] ranks)
        {var s=new GameState{randomState=19};for(int i=0;i<ranks.Length;i++)s.slots[i]=Card(100+i,ranks[i],(Suit)(i%4));return s;}
        static GameSession TaskGame(string id)
        {
            var config=Config();config.firstTarget=1;var task=config.tasks.Single(t=>t.id==id);config.tasks=new List<TaskDefinition>{task};
            var game=SessionFixture.Playing(config,19);game.State.acceptedTasks.Add(GameSession.CopyTask(task));return game;
        }
        static void Score(GameSession game,params int[] ranks)
        {
            game.State.slots=new Card[6];for(int i=0;i<ranks.Length;i++)game.State.slots[i]=Card(1000+game.State.month*100+game.State.week*10+i,ranks[i],(Suit)(i%4));
            game.State.monthScore=10000;Assert.IsTrue(game.ScoreWeek());
        }
        static void Next(GameSession game){Assert.IsTrue(game.OpenShop());Assert.IsTrue(game.NextMonth());}
        [Test] public void CatalogContainsOnlyFinalContentAndPreciseUtilityGrants()
        {
            var c=Config();Assert.AreEqual(33,c.content.Count(d=>!d.item));Assert.AreEqual(38,c.content.Count(d=>d.item));Assert.AreEqual(15,c.tasks.Count);
            Assert.AreEqual(71,c.content.Select(d=>d.id).Distinct().Count());Assert.IsTrue(c.content.All(d=>d.price>0 && !d.name.Contains("测试员工") && !string.IsNullOrEmpty(d.rule)));
            foreach(var d in c.content)foreach(var e in d.effects.Where(e=>e.enchantment==Enchantment.Copy || e.enchantment==Enchantment.Retry))
            {Assert.GreaterOrEqual(e.rankFilter,0);Assert.GreaterOrEqual(e.suitFilter,0);}
            Assert.AreEqual(4,c.tasks.Count(t=>t.reward==1));Assert.AreEqual(4,c.tasks.Count(t=>t.reward==2));Assert.AreEqual(7,c.tasks.Count(t=>t.reward==3));
            Assert.IsTrue(c.tasks.All(t=>t.name.Length<=15 && !string.IsNullOrEmpty(t.description)));
        }
        [Test] public void DuplicateLegacyEnchantmentsDeduplicateBeforeCapacityAndScoring()
        {
            var c=Card(1,3);c.enchantments=new List<Enchantment>{Enchantment.Coin,Enchantment.Coin,Enchantment.Fans,Enchantment.Arrow,Enchantment.X2};
            c.NormalizeEnchantmentSources();Assert.AreEqual(4,c.enchantments.Count);Assert.IsFalse(c.AddEnchantment(Enchantment.Coin));
            var s=new GameState();s.slots[0]=c;var r=Scoring.Evaluate(s,new Settings());Assert.AreEqual(26,r.chips);Assert.AreEqual(7,r.multiplier);
        }
        [Test] public void RejectedDuplicateDoesNotTurnEmployeeEnchantmentIntoPermanentNativeSource()
        {
            var g=SessionFixture.Playing(Config(),19);var card=g.State.hand[0];g.SetCardRank(card.id,6);g.SetCardSuit(card.id,Suit.Hearts);
            g.State.phase=Phase.Shop;g.State.cash=100;g.State.offers.Add("employee.01");Assert.IsTrue(g.Buy("employee.01",0));
            g.State.phase=Phase.Playing;string source=card.enchantmentSources[0];Assert.IsFalse(g.AddCardEnchantment(card.id,Enchantment.Coin));Assert.AreEqual(source,card.enchantmentSources[0]);
            g.State.phase=Phase.Shop;Assert.IsTrue(g.Sell(0,false));CollectionAssert.DoesNotContain(card.enchantments,Enchantment.Coin);
        }
        [Test] public void PreviewIsPureAndPreparedSettlementCommitsExactRandomOutcome()
        {
            var config=Config();var g=SessionFixture.Playing(config,19);g.State.slots[0]=g.State.hand[0];g.State.hand.RemoveAt(0);g.State.items[0]="item.FangSi";g.State.items[1]="item.Clock";
            string before=WorkWork.SaveCodec.Serialize(g.State);var a=Scoring.Evaluate(g.State,config);var b=Scoring.Evaluate(g.State,config);
            Assert.AreEqual(before,WorkWork.SaveCodec.Serialize(g.State));Assert.AreEqual(a.total,b.total);Assert.AreEqual(a.resolvedState.randomState,b.resolvedState.randomState);
            int size=ContentRules.AllCards(g.State).Count();Assert.IsTrue(g.ScoreWeek(a));Assert.AreEqual(a.total,g.State.lastScore.total);Assert.AreEqual(size+2,ContentRules.AllCards(g.State).Count());
        }
        [Test] public void LampRescoresUtilityOnceAndEmptyRightWorkstationStillExecutesStaffAndTool()
        {
            var s=Board(2,0,4);s.slots[1].AddEnchantment(Enchantment.Copy);s.slots[1].AddEnchantment(Enchantment.Retry);
            s.items[0]="item.C4";s.employees[1]="employee.10";s.items[3]="item.BenZai";
            var r=Scoring.Evaluate(s,Config());Assert.AreEqual(1,r.extraRedraws);Assert.AreEqual(1,r.copies.Count);CollectionAssert.DoesNotContain(r.copies[0].enchantments,Enchantment.Copy);
            Assert.AreEqual(1,r.steps.Count(x=>x.source==ScoreSource.Card && x.slot==1 && x.chipsDelta==0 && x.copiedCard==null && x.extraRedrawDelta==0));
            Assert.AreEqual(130,r.steps.Single(x=>x.source==ScoreSource.Employee && x.sourceSlot==1).chipsDelta);
            Assert.AreEqual(40,r.steps.Single(x=>x.source==ScoreSource.Item && x.sourceSlot==1).chipsDelta);
            Assert.IsNull(r.resolvedState.slots[0]);Assert.IsNull(r.resolvedState.slots[1]);Assert.IsNotNull(r.resolvedState.slots[2]);
        }
        [Test] public void InitialPatternSurvivesLampDeletionAndRankChangesPersistOnlyOnSnapshot()
        {
            var s=Board(2,2,2,2,3,3);s.items[0]="item.C4";s.items[6]="item.TNT";
            var r=Scoring.Evaluate(s,Config());Assert.AreEqual(11,r.patternPriority);Assert.AreEqual(16,r.steps.Single(x=>x.label=="TNT").multiplierDelta);
            s=Board(1,0,3);s.items[0]="item.Potato";s.items[1]="item.Gun";r=Scoring.Evaluate(s,Config());
            Assert.AreEqual(0,s.slots[1].rank);Assert.AreEqual(0,r.resolvedState.slots[1].rank);
            s.items[1]=null;r=Scoring.Evaluate(s,Config());Assert.AreEqual(1,r.resolvedState.slots[1].rank);Assert.AreEqual(0,s.slots[1].rank);
        }
        [Test] public void LawDeletesHiddenUnenchantedLowCardsAndPreservesCoreAndBoard()
        {
            var s=Board(1);s.employees[0]="employee.09";var core=Card(7,1);core.AddEnchantment(Enchantment.Coin);
            s.deck.AddRange(new[]{core,Card(8,0),Card(9,2),Card(10,6)});
            var r=Scoring.Evaluate(s,Config());Assert.AreEqual(4,r.steps.Single(x=>x.source==ScoreSource.Employee).multiplierDelta);
            CollectionAssert.AreEquivalent(new[]{7,10},r.resolvedState.deck.Select(c=>c.id));Assert.IsNotNull(r.resolvedState.slots[0]);Assert.AreEqual(4,s.deck.Count);
        }
        [Test] public void GeneratedCardsPayGenerationAndSizeInOrderWithoutMultiplyingLaterAdditions()
        {
            var s=Board(1,2,3);for(int i=0;i<45;i++)s.deck.Add(Card(i+1,6));
            s.employees[0]="employee.07";s.employees[1]="employee.32";s.employees[2]="employee.25";
            s.items[6]=s.items[7]=s.items[8]="item.BenZai";
            var r=Scoring.Evaluate(s,Config());Assert.AreEqual(56,ContentRules.AllCards(r.resolvedState).Count());Assert.AreEqual(105,r.steps.Single(x=>x.sourceSlot==1 && x.source==ScoreSource.Employee).chipsDelta);
            var supplier=r.steps.Where(x=>x.sourceSlot==2 && x.source==ScoreSource.Employee).ToArray();Assert.AreEqual(2,supplier.Length);Assert.AreEqual(4,supplier[0].multiplierDelta);Assert.IsTrue(supplier[1].multipliesMultiplier);Assert.AreEqual(10,r.multiplier);
        }
        [Test] public void TechArtDoesNotStackFansOrRequireObsoleteMonthlyGrantFlag()
        {
            var s=Board(5);s.employees[0]="employee.33";s.slots[0].suitChangedThisMonth=true;
            var r=Scoring.Evaluate(s,Config());Assert.AreEqual(1,r.resolvedState.slots[0].enchantments.Count);Assert.IsEmpty(r.resolvedState.slots[0].monthlyGrants);
            var second=Scoring.Evaluate(r.resolvedState,Config());Assert.AreEqual(1,second.resolvedState.slots[0].enchantments.Count);
            s.slots[0].AddEnchantment(Enchantment.Fans);r=Scoring.Evaluate(s,Config());Assert.IsEmpty(r.resolvedState.slots[0].monthlyGrants);
        }
        [Test] public void SevenCardGrantCannotBeFarmedBySellingOrLoadingAndResetsWithMonth()
        {
            var c=Config();var g=SessionFixture.Playing(c,19);g.State.phase=Phase.Shop;g.State.cash=100;g.State.offers.Add("employee.18");
            Assert.IsTrue(g.Buy("employee.18",0));Assert.IsTrue(g.Sell(0,false));g.State.offers.Add("employee.18");Assert.IsTrue(g.Buy("employee.18",0));
            g=SessionFixture.Playing(c,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));Assert.IsTrue(g.NextMonth());
            Assert.AreEqual(52,ContentRules.AllCards(g.State).Count());Assert.AreEqual(4,ContentRules.AllCards(g.State).Count(x=>x.rank==7));
            Assert.AreEqual(4,ContentRules.AllCards(g.State).Where(x=>x.rank==7).Select(x=>x.suit).Distinct().Count());
            g.State.phase=Phase.Shop;Assert.IsTrue(g.NextMonth());Assert.AreEqual(52,ContentRules.AllCards(g.State).Count());
        }
        [Test] public void EquipmentAgeFollowsMovesAndLockedEquipmentBlocksBothSwapDirections()
        {
            var g=SessionFixture.Playing(Config(),19);g.State.employees[0]="employee.01";g.State.employees[1]="employee.02";g.State.items[0]="item.HotPot";g.State.itemBoughtMonths[0]=2;
            Assert.IsFalse(g.MoveEmployee(0,1));Assert.IsFalse(g.MoveEmployee(1,0));g.State.phase=Phase.Shop;Assert.IsTrue(g.MoveEmployee(0,1));Assert.AreEqual(2,g.State.itemBoughtMonths[3]);
            Assert.IsTrue(g.MoveItem(3,1));Assert.AreEqual(2,g.State.itemBoughtMonths[1]);Assert.AreEqual(0,g.State.itemBoughtMonths[3]);
        }
        [Test] public void MaturityPaysCandyOnlyAtNaturalExpiryAndChargesFinalHatMonthAfterIncome()
        {
            var g=SessionFixture.Playing(Config(),19);var s=g.State;s.month=3;s.week=4;s.target=10;s.monthScore=1000;s.cash=9;
            s.employees[0]="employee.01";s.items[0]="item.Hat";s.items[1]="item.Candy";s.items[2]="item.Candy";s.itemBoughtMonths[0]=s.itemBoughtMonths[1]=1;s.itemBoughtMonths[2]=2;
            s.slots[0]=Card(500,1);Assert.IsTrue(g.ScoreWeek());Assert.AreEqual(20,s.cash);Assert.AreEqual(5,s.lastStaffIncome);Assert.AreEqual(11,s.lastIncome);
            Assert.IsNull(s.items[0]);Assert.IsNull(s.items[1]);Assert.AreEqual("item.Candy",s.items[2]);
            Assert.IsTrue(g.OpenShop());int before=s.cash;Assert.IsTrue(g.Sell(2,true));Assert.AreEqual(before+2,s.cash);
        }
        [Test] public void DiscountsAndFreeRefreshAreConsumedOnceAndSurviveReload()
        {
            var c=Config();var g=SessionFixture.Playing(c,19);g.State.phase=Phase.Shop;g.State.cash=100;g.State.employees[0]="employee.11";g.State.employees[1]="employee.29";
            g.State.offers.Add("employee.02");Assert.AreEqual(4,g.PurchasePrice("employee.02"));Assert.IsTrue(g.Buy("employee.02",2));Assert.AreEqual(5,g.PurchasePrice("employee.03"));
            g=SessionFixture.Playing(c,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));Assert.AreEqual(5,g.PurchasePrice("employee.03"));
        }
        [Test] public void FreeRefreshAdvancesPriceAndPersistsAcrossSave()
        {
            var c=Config();var g=SessionFixture.Playing(c,19);g.State.phase=Phase.Shop;g.State.cash=100;g.State.employees[0]="employee.29";
            Assert.AreEqual(0,g.RefreshPrice);Assert.IsTrue(g.RefreshShop());Assert.AreEqual(100,g.State.cash);Assert.AreEqual(2,g.RefreshPrice);
            g=SessionFixture.Playing(c,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));Assert.AreEqual(2,g.RefreshPrice);
        }
        [TestCase("task.02",Suit.Hearts,true)] [TestCase("task.02",Suit.Clubs,false)]
        [TestCase("task.03",Suit.Spades,true)] [TestCase("task.03",Suit.Diamonds,false)]
        public void ColorTasksInspectActualSubmittedCards(string id,Suit suit,bool matches)
        {
            var g=TaskGame(id);g.State.slots[0]=Card(500,4,suit);Assert.IsTrue(g.ScoreWeek());Assert.AreEqual(matches?1:0,g.State.tasks.Single().current);
        }
        [Test] public void HighCardsTaskCanCompleteInFinalDeadlineMonthAndOnlyPaysOnce()
        {
            var g=TaskGame("task.05");int cash=g.State.cash;Score(g,4,5);Score(g,4,6);Score(g,5,6);
            Assert.IsTrue(g.State.tasks.Single().rewarded);Assert.AreEqual(cash+2,g.State.cash);Score(g,4,5);Assert.IsFalse(g.State.tasks.Single().expired);
        }
        [Test] public void ThreeNoRedrawMonthsCompleteBeforeDeadlineExpires()
        {
            var g=TaskGame("task.04");
            for(int month=0;month<3;month++){for(int w=0;w<4;w++)Score(g,1,2);if(month<2)Next(g);}
            var p=g.State.tasks.Single();Assert.AreEqual(3,p.current);Assert.IsTrue(p.rewarded);Assert.IsFalse(p.expired);
        }
        [Test] public void FailedRedrawAndPreviewDoNotInvalidateNoRedrawMonthButActualRedrawDoes()
        {
            var g=TaskGame("task.04");g.State.redraws=0;Assert.IsFalse(g.Redraw());Scoring.Evaluate(g.State,g.Config);Assert.AreEqual(0,g.State.monthRedraws);
            g.State.redraws=1;Assert.IsTrue(g.Redraw());for(int w=0;w<4;w++)Score(g,1,2);Assert.AreEqual(0,g.State.tasks.Single().current);
        }
        [Test] public void NoTradeCountsConsecutiveMonthsAndARealPurchaseInvalidatesMonth()
        {
            var g=TaskGame("task.10");for(int w=0;w<4;w++)Score(g,1,2);Assert.AreEqual(1,g.State.tasks.Single().current);Next(g);
            g.State.phase=Phase.Shop;g.State.cash=100;g.State.offers.Add("employee.01");Assert.IsTrue(g.Buy("employee.01",0));g.State.phase=Phase.Playing;
            for(int w=0;w<4;w++)Score(g,1,2);Assert.AreEqual(0,g.State.tasks.Single().current);Next(g);
            for(int w=0;w<4;w++)Score(g,1,2);Assert.IsTrue(g.State.tasks.Single().expired);Assert.IsFalse(g.State.tasks.Single().rewarded);
        }
        [Test] public void NoTradeCanFinishAtThirdMonthEndAndIgnoresFailedCommands()
        {
            var g=TaskGame("task.10");Assert.IsFalse(g.Sell(0,false));
            for(int m=0;m<3;m++){for(int w=0;w<4;w++)Score(g,1,2);if(m<2)Next(g);}
            Assert.IsTrue(g.State.tasks.Single().rewarded);Assert.IsFalse(g.State.tasks.Single().expired);
        }
        [Test] public void BuyingShelfTaskRequiresThreeItemsFromSameBatch()
        {
            var g=TaskGame("task.09");g.State.phase=Phase.MonthResult;g.State.cash=1000;g.OpenShop();g.State.employees[0]="employee.01";g.State.employees[1]="employee.02";
            Assert.IsTrue(g.Buy(g.State.offers[3],0));Assert.IsTrue(g.RefreshShop());Assert.IsTrue(g.Buy(g.State.offers[3],0));Assert.IsTrue(g.Buy(g.State.offers[4],0));
            Assert.IsFalse(g.State.tasks.Any(p=>p.rewarded));Assert.IsTrue(g.Buy(g.State.offers[5],1));Assert.IsTrue(g.State.tasks.Single().rewarded);
        }
        [Test] public void MonthlyFourPatternsRequiresFourRewardedDistinctStrongestPatterns()
        {
            var g=TaskGame("task.08");Score(g,1,1);Score(g,1,1,2,2);Score(g,1,1,1);Score(g,1,1,2,2,3,3);
            Assert.IsTrue(g.State.tasks.Single().rewarded);
            g=TaskGame("task.08");Score(g,1,1);Score(g,2,2);Score(g,1,1,1);Score(g,1,1,2,2,3,3);Assert.IsFalse(g.State.tasks.Single().rewarded);
        }
        [Test] public void AllOtherPatternsCountsTwelveDistinctRewardsAndExcludesNoPatternAndSixFlush()
        {
            var g=TaskGame("task.13");Score(g,1,2);Assert.AreEqual(0,g.State.tasks.Single().current);
            string[] ranks={"112346","112234","111234","112233","112345","123456","112346","111224","111222","111123","111122","112345"};
            for(int i=0;i<ranks.Length;i++)
            {
                if(g.State.phase==Phase.MonthResult)Next(g);
                g.State.slots=new Card[6];for(int j=0;j<6;j++)g.State.slots[j]=Card(500+j,ranks[i][j]-'0',i==6 || i==11?Suit.Hearts:(Suit)(j%4));g.State.monthScore=10000;Assert.IsTrue(g.ScoreWeek());
            }
            Assert.AreEqual(12,g.State.tasks.Single().current);Assert.IsTrue(g.State.tasks.Single().rewarded);
        }
        [Test] public void MonthMultiplesOnlyCountAtMonthEndAndNotOnPreview()
        {
            foreach(string id in new[]{"task.06","task.14"})
            {
                var g=TaskGame(id);for(int w=0;w<3;w++){Score(g,4);Assert.AreEqual(0,g.State.tasks.Single().current);}Score(g,4);Assert.AreEqual(1,g.State.tasks.Single().current);
            }
        }
        [Test] public void TargetUsesSixHundredAndApprovedGrowthWithoutChangingCash()
        {
            var g=SessionFixture.Playing(Config(),19);Assert.AreEqual(600,g.State.target);Assert.AreEqual(5,g.State.cash);
            g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(750,g.State.target);g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(940,g.State.target);
        }
        [TestCase("BenZai",40,0)] [TestCase("Farmer",0,4)] [TestCase("HotPot",100,0)]
        [TestCase("Spray",70,0)] [TestCase("Prince",0,8)] [TestCase("Clock",80,0)] [TestCase("NaiLong",0,8)]
        [TestCase("Light1",20,0)] [TestCase("Light2",20,0)] [TestCase("Light3",20,0)] [TestCase("Light4",20,0)] [TestCase("Light5",20,0)] [TestCase("Light6",20,0)]
        [TestCase("Book1",0,4)] [TestCase("Book2",0,2)] [TestCase("Book3",0,2)] [TestCase("Book4",0,4)]
        [TestCase("Fusion",0,6)] [TestCase("Fangdan",60,0)] [TestCase("CockTail",25,0)] [TestCase("Hat",200,0)]
        public void FinalItemNumbersUseActualBoardAndCurrentHistory(string code,int chips,int multiplier)
        {
            var s=Board(1,2,3,4,5,6);s.previousRanks[0]=1;s.achievedPatterns.AddRange(new[]{1,2});
            var baseline=Scoring.Evaluate(s,Config());s.items[0]="item."+code;var score=Scoring.Evaluate(s,Config());
            Assert.AreEqual(baseline.chips+chips,score.chips);Assert.AreEqual(baseline.multiplier+multiplier,score.multiplier);
        }
        [Test] public void EmptyOwnSlotStillReceivesGlobalItemEffectButEmptyBoardIsNotAllEvenOrBlack()
        {
            var s=Board(0);s.items[3]="item.Rail";s.items[4]="item.Rubbish";
            var r=Scoring.Evaluate(s,Config());Assert.AreEqual(120,r.chips);Assert.AreEqual(11,r.multiplier);
            s.slots[0]=null;r=Scoring.Evaluate(s,Config());Assert.AreEqual(0,r.chips);Assert.AreEqual(1,r.multiplier);
        }
        [Test] public void NotFullTaskNeedsFourQualifyingWeeksAndKeepsMonthlyProgressAcrossSave()
        {
            var g=TaskGame("task.07");Score(g,1,2);Score(g,1,2);g=SessionFixture.Playing(g.Config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));
            Score(g,1,2);Score(g,1,2);Assert.AreEqual(1,g.State.tasks.Single().current);Next(g);
            Score(g,1,2);Score(g,1,2,3,4,5,6);Score(g,1,2);Score(g,1,2);Assert.AreEqual(1,g.State.tasks.Single().current);
        }
        [Test] public void ShelfBatchProgressAndTaskKindSurviveReload()
        {
            var g=TaskGame("task.09");g.State.phase=Phase.MonthResult;g.State.cash=1000;g.OpenShop();g.State.employees[0]="employee.01";
            Assert.IsTrue(g.Buy(g.State.offers[3],0));Assert.IsTrue(g.Buy(g.State.offers[4],0));
            g=SessionFixture.Playing(g.Config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));Assert.AreEqual(2,g.State.shelfBoughtItems);
            Assert.IsTrue(g.Buy(g.State.offers[5],0));Assert.IsTrue(g.State.tasks.Single().rewarded);
        }
    }
}
