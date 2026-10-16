using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class RulesTests
    {
        static Card[] Cards(int[] ranks, Suit suit = Suit.Spades) => ranks.Select((r,i) => new Card {id=i+1,rank=r,suit=suit}).ToArray();
        static GameSession TaskSession(Settings config,uint seed)
        {var game=new GameSession(config,seed);game.State.acceptedTasks=config.tasks.Take(3).Select(GameSession.CopyTask).ToList();return game;}
        static Settings TaskPool()
        {
            var config=new Settings{firstTarget=1};
            for(int reward=1;reward<=3;reward++)for(int i=0;i<2;i++)config.tasks.Add(new TaskDefinition{id="pool"+reward+"_"+i,name="测试任务",reward=reward,target=2,deadlineMonths=2,patternPriorities=new System.Collections.Generic.List<int>{1}});
            return config;
        }
        [Test] public void TaskOffersStartInFourthMonthAndRestoreWithoutRerolling()
        {
            var config=TaskPool();var g=new GameSession(config,19);Assert.IsEmpty(g.ActiveTasks);Assert.IsEmpty(g.State.taskOffers);
            for(int month=2;month<=4;month++) {g.State.phase=Phase.Shop;Assert.IsTrue(g.NextMonth());Assert.AreEqual(month==4?Phase.TaskChoice:Phase.Playing,g.State.phase);}
            CollectionAssert.AreEqual(new[]{1,2,2,3},g.State.taskOffers.Select(t=>t.reward));Assert.AreEqual(4,g.State.taskOffers.Select(t=>t.id).Distinct().Count());
            string snapshot=WorkWork.SaveCodec.Serialize(g.State);var restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(snapshot));
            Assert.AreEqual(snapshot,WorkWork.SaveCodec.Serialize(restored.State));
            Assert.IsFalse(restored.Redraw());Assert.IsFalse(restored.ScoreWeek());Assert.IsFalse(restored.ChooseTask(-1));
            Assert.IsTrue(restored.ChooseTask(2));Assert.IsFalse(restored.ChooseTask(0));Assert.AreEqual(1,restored.ActiveTasks.Count());Assert.IsEmpty(restored.State.taskOffers);
            Assert.IsEmpty(restored.State.tasks);Assert.AreEqual(2,restored.ActiveTasks.Single().reward);
            restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(restored.State)));
            Assert.AreEqual(Phase.Playing,restored.State.phase);Assert.AreEqual(1,restored.ActiveTasks.Count());
        }
        [Test] public void TaskCycleSkipsWhenFullAndWaitsForNextScheduledMonth()
        {
            var g=new GameSession(TaskPool(),19);
            foreach(int month in new[]{4,7,10}) {g.State.month=month-1;g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(Phase.TaskChoice,g.State.phase);Assert.IsTrue(g.ChooseTask(0));}
            Assert.AreEqual(3,g.ActiveTasks.Count());
            g.State.month=12;g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(Phase.Playing,g.State.phase);Assert.IsEmpty(g.State.taskOffers);
            g.State.tasks.Add(new TaskProgress{id=g.ActiveTasks.First().id,expired=true});Assert.AreEqual(2,g.ActiveTasks.Count());
            for(int month=14;month<=16;month++) {g.State.phase=Phase.Shop;g.NextMonth();Assert.AreEqual(month==16?Phase.TaskChoice:Phase.Playing,g.State.phase);}
            Assert.IsTrue(g.ChooseTask(3));Assert.AreEqual(3,g.ActiveTasks.Count());
        }
        static void ScoreTaskBoard(GameSession game,params int[] ranks)
        {
            game.State.slots=new Card[6];
            for(int i=0;i<ranks.Length;i++) game.State.slots[i]=new Card{id=100+i,rank=ranks[i],suit=(Suit)(i%4)};
            Assert.IsTrue(game.ScoreWeek());
        }
        [Test] public void TasksPersistAcrossMonthsAndSavesAndPayOnlyOnce()
        {
            var config=new Settings{firstTarget=1};
            config.tasks.Add(new TaskDefinition{id="pair",name="结算2次一对",reward=1,patternPriorities=new System.Collections.Generic.List<int>{1}});
            config.tasks.Add(new TaskDefinition{id="bomb",name="结算2次炸弹",reward=3,patternPriorities=new System.Collections.Generic.List<int>{10,11}});
            var g=TaskSession(config,19);int initial=g.State.cash;
            ScoreTaskBoard(g,2,2);Assert.AreEqual(1,g.State.tasks.Single().current);Assert.AreEqual(initial,g.State.cash);
            Scoring.Evaluate(g.State,config);Assert.AreEqual(1,g.State.tasks.Single().current);
            g=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));
            ScoreTaskBoard(g,3,3);Assert.AreEqual(initial+1,g.State.cash);Assert.IsTrue(g.State.tasks.Single().rewarded);
            ScoreTaskBoard(g,4,4);Assert.AreEqual(initial+1,g.State.cash);Assert.AreEqual(2,g.State.tasks.Single().current);
            ScoreTaskBoard(g,2,2,2,2,3,3);Assert.AreEqual(1,g.State.tasks.Single(t=>t.id=="bomb").current);
            Assert.IsTrue(g.OpenShop());Assert.IsTrue(g.NextMonth());
            Assert.AreEqual(2,g.State.tasks.Single(t=>t.id=="pair").current);Assert.AreEqual(1,g.State.tasks.Single(t=>t.id=="bomb").current);
            int cash=g.State.cash;ScoreTaskBoard(g,4,4,4,4);Assert.AreEqual(cash+3,g.State.cash);
            var restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));
            ScoreTaskBoard(restored,4,4,4,4);Assert.AreEqual(cash+3,restored.State.cash);
            Assert.IsEmpty(new GameSession(config,1).State.tasks);
        }
        [Test] public void MonthlyDeadlineCanFinishOnLastSettlementAndPaysOnce()
        {
            var config=new Settings{firstTarget=1};config.tasks.Add(new TaskDefinition{id="timed",target=2,deadlineMonths=2,reward=2,patternPriorities=new System.Collections.Generic.List<int>{1}});
            var g=TaskSession(config,19);
            ScoreTaskBoard(g,2,2);for(int i=0;i<3;i++) ScoreTaskBoard(g,2,3);
            Assert.AreEqual(1,g.State.tasks[0].elapsedMonths);Assert.IsFalse(g.State.tasks[0].expired);
            g=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));
            Assert.IsTrue(g.OpenShop());Assert.IsTrue(g.NextMonth());
            for(int i=0;i<3;i++) ScoreTaskBoard(g,2,3);
            Assert.AreEqual(1,g.State.tasks[0].elapsedMonths);int cash=g.State.cash;
            ScoreTaskBoard(g,3,3);Assert.IsTrue(g.State.tasks[0].rewarded);Assert.IsFalse(g.State.tasks[0].expired);
            Assert.AreEqual(cash+2+g.State.lastIncome,g.State.cash);
            Assert.IsTrue(g.OpenShop());Assert.IsTrue(g.NextMonth());cash=g.State.cash;
            ScoreTaskBoard(g,4,4);Assert.AreEqual(cash,g.State.cash);
        }
        [Test] public void MonthlyDeadlineExpiresAndCannotReviveAfterSaveOrNewMonth()
        {
            var config=new Settings{firstTarget=1};config.tasks.Add(new TaskDefinition{id="timed",deadlineMonths=2,patternPriorities=new System.Collections.Generic.List<int>{1}});
            var g=TaskSession(config,19);
            for(int month=0;month<2;month++)
            {
                for(int week=0;week<4;week++)ScoreTaskBoard(g,2,3);
                Assert.AreEqual(month+1,g.State.tasks[0].elapsedMonths);
                Assert.AreEqual(month==1,g.State.tasks[0].expired);
                Assert.IsTrue(g.OpenShop());Assert.IsTrue(g.NextMonth());
            }
            g=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));
            int cash=g.State.cash;ScoreTaskBoard(g,4,4);
            Assert.IsTrue(g.State.tasks[0].expired);Assert.AreEqual(0,g.State.tasks[0].current);
            Assert.IsFalse(g.State.tasks[0].rewarded);Assert.AreEqual(cash,g.State.cash);
        }
        [Test] public void MonthlyDeadlineDoesNotTickOnPreviewOrNonfinalWeeks()
        {
            var config=new Settings{firstTarget=1};config.tasks.Add(new TaskDefinition{id="timed",deadlineMonths=1,patternPriorities=new System.Collections.Generic.List<int>{1}});
            var g=TaskSession(config,19);Assert.IsFalse(g.ScoreWeek());
            for(int i=0;i<3;i++) {ScoreTaskBoard(g,2,3);Scoring.Evaluate(g.State,config);Assert.AreEqual(0,g.State.tasks[0].elapsedMonths);Assert.IsFalse(g.State.tasks[0].expired);}
            ScoreTaskBoard(g,2,3);Assert.IsTrue(g.State.tasks[0].expired);Assert.AreEqual(1,g.State.tasks[0].elapsedMonths);
        }
        [Test] public void TaskRewardsClampToOneThroughThreeAndOnlyThreeTasksAreActive()
        {
            var config=new Settings();
            for(int i=0;i<4;i++) config.tasks.Add(new TaskDefinition{id="task"+i,target=1,reward=i==0?0:100,patternPriorities=new System.Collections.Generic.List<int>{1}});
            var g=TaskSession(config,19);int cash=g.State.cash;ScoreTaskBoard(g,2,2);
            Assert.AreEqual(3,g.State.tasks.Count);Assert.AreEqual(cash+7,g.State.cash);
        }
        [TestCase("112346",1)] [TestCase("112234",2)] [TestCase("111234",3)]
        [TestCase("112233",4)] [TestCase("112345",5)] [TestCase("123456",6)]
        [TestCase("111224",8)] [TestCase("111222",9)] [TestCase("111123",10)] [TestCase("111122",11)]
        public void MixedSuitPatternsMatchDesign(string ranks,int priority)
        {
            var cards=Cards(ranks.Select(c=>c-'0').ToArray());
            for(int i=0;i<cards.Length;i++) cards[i].suit=(Suit)(i%4);
            Assert.AreEqual(priority,Scoring.BestPattern(cards).priority);
        }
        [TestCase("112346",7)] [TestCase("112345",12)] [TestCase("123456",13)]
        public void FlushPatternsMatchDesign(string ranks,int priority)
            => Assert.AreEqual(priority,Scoring.BestPattern(Cards(ranks.Select(c=>c-'0').ToArray())).priority);
        [Test] public void StrongestPatternWinsInsteadOfStacking()
        {
            Assert.AreEqual(13,Scoring.BestPattern(Cards(new[]{1,2,3,4,5,6})).priority);
            var cards=Cards(new[]{1,1,1,2,2,2}); for(int i=0;i<6;i++) cards[i].suit=(Suit)(i%4);
            Assert.AreEqual(9,Scoring.BestPattern(cards).priority);
        }
        [TestCase(1499,0)] [TestCase(1500,1)] [TestCase(1999,1)] [TestCase(2000,2)] [TestCase(9000,2)]
        public void ExcessMoneyUsesExactBoundaries(long score,int reward) => Assert.AreEqual(reward,GameSession.ExcessReward(score,1000));
        [Test] public void NoPatternUsesBaseMultiplierOne()
        {
            var s=new GameState(); s.slots[0]=new Card {id=1,rank=6,suit=Suit.Hearts};
            Assert.AreEqual(6,Scoring.Evaluate(s,new Settings()).total);
            Assert.AreEqual(1,Scoring.Evaluate(s,new Settings()).multiplier);
        }
        [TestCase(1,24)] [TestCase(2,48)] [TestCase(3,72)] [TestCase(0,24)]
        public void DeckCopiesCreateIndependentCardsAndResetOnlyAtNextMonth(int copies,int expected)
        {
            var config=new Settings{deckCopies=copies};var game=new GameSession(config,19);
            var all=AllCards(game.State).ToArray();Assert.AreEqual(expected,all.Length);Assert.AreEqual(expected,all.Select(c=>c.id).Distinct().Count());
            Assert.IsTrue(all.GroupBy(c=>new{c.rank,c.suit}).All(group=>group.Count()==System.Math.Max(1,copies)));
            var restored=new GameSession(new Settings{deckCopies=2},1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(game.State)));
            Assert.AreEqual(expected,AllCards(restored.State).Count());
            restored.State.phase=Phase.Shop;Assert.IsTrue(restored.NextMonth());Assert.AreEqual(48,AllCards(restored.State).Count());
        }
        [Test] public void RedrawNeverMovesPlacedCardAndPreservesAll48Cards()
        {
            var game=new GameSession(new Settings(),71); int id=game.State.hand[0].id; game.Place(id,0);
            for(int i=0;i<4;i++) Assert.IsTrue(game.Redraw());
            Assert.IsFalse(game.Redraw()); Assert.AreEqual(id,game.State.slots[0].id);
            var all=game.State.deck.Concat(game.State.discard).Concat(game.State.hand).Concat(game.State.slots.Where(c=>c!=null)).ToArray();
            Assert.AreEqual(48,all.Length); Assert.AreEqual(48,all.Select(c=>c.id).Distinct().Count());
        }
        [Test] public void EmptyDeckReshufflesDiscardWithoutDuplicatingHand()
        {
            var game=new GameSession(new Settings(),12); var s=game.State;
            s.discard.AddRange(s.deck); s.deck.Clear(); int[] ids=s.hand.Select(c=>c.id).ToArray();
            Assert.IsTrue(game.Redraw()); Assert.AreEqual(6,s.hand.Count); Assert.AreEqual(0,s.discard.Count);
            Assert.AreEqual(48,s.deck.Concat(s.hand).Select(c=>c.id).Distinct().Count());
        }
        [Test] public void MonthlySuccessWaitsUntilFourthWeek()
        {
            var game=new GameSession(new Settings {firstTarget=10},2); game.State.monthScore=100;
            for(int week=1;week<=4;week++)
            {
                game.Place(game.State.hand[0].id,0); Assert.IsTrue(game.ScoreWeek());
                Assert.AreEqual(week<4 ? Phase.Playing : Phase.MonthResult,game.State.phase);
            }
            Assert.AreEqual(11,game.State.cash); // initial 5 + fixed 4 + excess 2
        }
        [Test] public void FailedMonthDoesNotPayAndCannotOpenShop()
        {
            var game=new GameSession(new Settings(),19);
            for(int i=0;i<4;i++) { game.Place(game.State.hand[0].id,0); game.ScoreWeek(); }
            Assert.AreEqual(Phase.Failed,game.State.phase); Assert.AreEqual(5,game.State.cash); Assert.IsFalse(game.OpenShop());
        }
        [Test] public void SavedRandomStateProducesSameFutureDraws()
        {
            var config=new Settings(); var first=new GameSession(config,12);
            var restored=new GameSession(config,1,JsonUtility.FromJson<GameState>(JsonUtility.ToJson(first.State)));
            first.Redraw(); restored.Redraw();
            CollectionAssert.AreEqual(first.State.hand.Select(c=>c.id),restored.State.hand.Select(c=>c.id));
            Assert.IsTrue(restored.State.slots.All(c=>c==null),"Null slots must remain empty after JSON restore.");
        }
        [Test] public void SavingDoesNotMaterializeEmptyCardsOnLiveBoard()
        {
            var game=new GameSession(new Settings(),17);
            string save=WorkWork.SaveCodec.Serialize(game.State);
            Assert.IsTrue(game.State.slots.All(c=>c==null));
            var restored=new GameSession(new Settings(),1,WorkWork.SaveCodec.Deserialize(save));
            Assert.IsTrue(restored.State.slots.All(c=>c==null));
            Assert.IsNull(restored.State.lastScore);
            WorkWork.SaveCodec.Serialize(restored.State);
            Assert.IsTrue(restored.State.slots.All(c=>c==null));
            Assert.AreEqual(0,Scoring.Evaluate(restored.State,restored.Config).total);
        }
        [Test] public void LocalEffectAndMultiplierProductsRespectOrder()
        {
            var config=new Settings(); config.content.Add(new Content { id="test",effects=new System.Collections.Generic.List<Effect>{new Effect {kind=EffectKind.MultiplyMultiplier,amount=2,trigger=Trigger.CardScored},new Effect {kind=EffectKind.AddMultiplier,amount=3,trigger=Trigger.CardScored}} });
            var s=new GameState(); s.slots[0]=new Card {rank=2}; s.slots[1]=new Card {rank=2}; s.employees[0]="test";
            var score=Scoring.Evaluate(s,config); Assert.AreEqual(7,score.multiplier); Assert.AreEqual(63,score.total);
        }
        [Test] public void PreviewContainsOnlyPatternAndTraceAddsEachCardInOrder()
        {
            var s=new GameState();s.slots[0]=new Card{rank=2,suit=Suit.Hearts};s.slots[1]=new Card{rank=3,suit=Suit.Spades};s.slots[2]=new Card{rank=3,suit=Suit.Diamonds};
            var preview=Scoring.Preview(s,new Settings());Assert.AreEqual(5,preview.chips);Assert.AreEqual(2,preview.multiplier);
            var score=Scoring.Evaluate(s,new Settings());CollectionAssert.AreEqual(new long[]{5,7,10,13},score.steps.Select(t=>t.chips));Assert.AreEqual(26,score.total);
        }
        [Test] public void ScoreStepsIdentifyActualSourceAndMultiplierOperation()
        {
            var config=new Settings();config.content.Add(new Content{id="global",effects=new System.Collections.Generic.List<Effect>{new Effect{kind=EffectKind.AddChips,amount=20,local=false,trigger=Trigger.CardScored}}});
            config.content.Add(new Content{id="gear",effects=new System.Collections.Generic.List<Effect>{new Effect{kind=EffectKind.MultiplyMultiplier,amount=2,trigger=Trigger.CardScored}}});
            var s=new GameState();s.slots[0]=new Card{rank=2};s.slots[1]=new Card{rank=3};s.employees[0]="global";s.items[5]="gear";
            var steps=Scoring.Evaluate(s,config).steps;
            var remote=steps.Single(t=>t.slot==1 && t.source==ScoreSource.Employee);
            Assert.AreEqual(0,remote.sourceSlot);Assert.AreEqual(20,remote.chipsDelta);
            var gear=steps.Single(t=>t.source==ScoreSource.Item);Assert.AreEqual(1,gear.sourceSlot);Assert.AreEqual(2,gear.equipmentSlot);
            Assert.IsTrue(gear.multipliesMultiplier);Assert.AreEqual(2,gear.multiplierOperand);
            Assert.AreEqual(2,steps.Single(t=>t.slot==0 && t.source==ScoreSource.Card).chipsDelta);
        }
        [Test] public void MultiplierAdditionBeforeAndAfterProductProduceDifferentScores()
        {
            var config=new Settings();config.content.Add(new Content{id="plus",effects=new System.Collections.Generic.List<Effect>{new Effect{kind=EffectKind.AddMultiplier,amount=3,trigger=Trigger.CardScored}}});
            config.content.Add(new Content{id="times",effects=new System.Collections.Generic.List<Effect>{new Effect{kind=EffectKind.MultiplyMultiplier,amount=2,trigger=Trigger.CardScored}}});
            var s=new GameState();s.slots[0]=new Card{rank=2};s.slots[1]=new Card{rank=2};s.employees[0]="plus";s.employees[1]="times";
            Assert.AreEqual(10,Scoring.Evaluate(s,config).multiplier);
            s.employees[0]="times";s.employees[1]="plus";Assert.AreEqual(7,Scoring.Evaluate(s,config).multiplier);
            s.employees[0]=null;s.employees[1]=null;s.items[0]="times";s.items[1]="plus";Assert.AreEqual(7,Scoring.Evaluate(s,config).multiplier);
        }
        [Test] public void ThreeEquipmentSlotsScoreAndFollowEmployeeWithoutCompacting()
        {
            var config=new Settings(); config.content.Add(new Content{id="staff",price=1});
            for(int i=0;i<4;i++) config.content.Add(new Content{id="gear"+i,item=true,price=1,effects=new System.Collections.Generic.List<Effect>{new Effect{kind=EffectKind.AddChips,amount=2,trigger=Trigger.CardScored}}});
            var g=new GameSession(config,1); var s=g.State; s.phase=Phase.Shop;s.cash=100;s.employees[0]="staff";
            s.offers=new System.Collections.Generic.List<string>{null,null,null,"gear0","gear1","gear2","gear3"};
            Assert.IsTrue(g.Buy("gear1",0,1)); Assert.IsNull(s.offers[4]); Assert.AreEqual("gear2",s.offers[5]);
            Assert.IsTrue(g.Buy("gear0",0,0)); Assert.IsTrue(g.Buy("gear2",0,2)); Assert.IsFalse(g.Buy("gear3",0));
            s.slots[0]=new Card{id=1,rank=1}; Assert.AreEqual(7,Scoring.Evaluate(s,config).total);
            Assert.IsTrue(g.Sell(1,true)); Assert.IsNull(s.items[1]); Assert.AreEqual("gear2",s.items[2]);
            Assert.IsTrue(g.MoveEmployee(0,1)); Assert.AreEqual("gear0",s.items[3]); Assert.IsNull(s.items[4]); Assert.AreEqual("gear2",s.items[5]);
            Assert.IsFalse(g.Sell(1,false));
        }
        [Test] public void RefreshRestocksPurchasedHolesWhenEligibleStockExists()
        {
            var config=new Settings();
            for(int i=0;i<4;i++)
            {
                config.content.Add(new Content{id="staff"+i,price=1});
                config.content.Add(new Content{id="gear"+i,item=true,price=1});
            }
            var g=new GameSession(config,19);var s=g.State;s.phase=Phase.MonthResult;s.cash=100;g.OpenShop();
            string employee=s.offers[1],gear=s.offers[4];
            Assert.IsTrue(g.Buy(employee,0));Assert.IsTrue(g.Buy(gear,0));
            Assert.IsNull(s.offers[1]);Assert.IsNull(s.offers[4]);
            int before=s.cash;Assert.IsTrue(g.RefreshShop());Assert.AreEqual(before-3,s.cash);
            Assert.AreEqual(6,s.offers.Count);Assert.IsTrue(s.offers.All(id=>!string.IsNullOrEmpty(id)));
            CollectionAssert.DoesNotContain(s.offers,employee);CollectionAssert.DoesNotContain(s.offers,gear);
            for(int i=0;i<6;i++) Assert.AreEqual(i>=3,config.content.Find(c=>c.id==s.offers[i]).item);
        }
        [Test] public void ShopKeepsSixCategoryColumnsWhenContentIsExhausted()
        {
            var config=new Settings(); config.content.Add(new Content{id="gear",item=true,price=1});
            var g=new GameSession(config,1); g.State.phase=Phase.MonthResult;g.OpenShop();
            Assert.AreEqual(6,g.State.offers.Count); Assert.IsTrue(g.State.offers.Take(3).All(string.IsNullOrEmpty));Assert.AreEqual("gear",g.State.offers[3]);
        }
        [Test] public void LegacyEquipmentSaveMigratesToFirstSlotOfEachEmployee()
        {
            var state=new GameState{items=new[]{"a","b",null,null,null,"f"}};
            var g=new GameSession(new Settings(),1,state);
            Assert.AreEqual(18,g.State.items.Length);Assert.AreEqual("b",g.State.items[3]);Assert.AreEqual("f",g.State.items[15]);
            var restored=new GameSession(new Settings(),1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State)));
            CollectionAssert.AreEqual(g.State.items,restored.State.items);
        }
        [Test] public void FailedEmployeeSaleKeepsOwnershipAndSuccessfulSaleSurvivesSave()
        {
            var config=new Settings();config.content.Add(new Content{id="staff",price=5});config.content.Add(new Content{id="gear",item=true,price=1});
            var g=new GameSession(config,1);var s=g.State;s.phase=Phase.MonthResult;s.cash=100;g.OpenShop();
            Assert.IsTrue(g.Buy("staff",0));Assert.IsTrue(g.Buy("gear",0));
            Assert.IsFalse(g.Sell(0,false));CollectionAssert.Contains(s.acquired,"staff");
            Assert.IsTrue(g.Sell(0,true));int cash=s.cash;
            Assert.IsTrue(g.Sell(0,false));Assert.AreEqual(cash+3,s.cash);CollectionAssert.DoesNotContain(s.acquired,"staff");
            var restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(s)));
            Assert.IsTrue(restored.RefreshShop());CollectionAssert.Contains(restored.State.offers,"staff");
            Assert.IsTrue(restored.Buy("staff",2));Assert.AreEqual("staff",restored.State.employees[2]);
        }
        [TestCase(Enchantment.Coin,23,1)]
        [TestCase(Enchantment.Fans,3,4)]
        [TestCase(Enchantment.Arrow,6,1)]
        public void SingleEnchantmentMatchesProvidedRules(Enchantment enchantment,long chips,double multiplier)
        {
            var s=new GameState();s.slots[0]=new Card{id=1,rank=3};s.slots[0].AddEnchantment(enchantment);
            var score=Scoring.Evaluate(s,new Settings());Assert.AreEqual(chips,score.chips);Assert.AreEqual(multiplier,score.multiplier);
        }
        [Test] public void WildUsesOnlySameSuitFaceRanksAndX2OnlyCardMultiplier()
        {
            var s=new GameState();s.slots[0]=new Card{id=1,rank=3,suit=Suit.Hearts};s.slots[1]=new Card{id=2,rank=4,suit=Suit.Hearts};s.slots[2]=new Card{id=3,rank=5,suit=Suit.Clubs};
            s.slots[0].AddEnchantment(Enchantment.Wild);s.slots[0].AddEnchantment(Enchantment.Fans);s.slots[0].AddEnchantment(Enchantment.X2);
            var score=Scoring.Evaluate(s,new Settings());Assert.AreEqual(19,score.chips);Assert.AreEqual(7,score.multiplier);Assert.AreEqual(133,score.total);
        }
        [Test] public void FourEnchantmentLimitAndCopiesHaveIndependentSavedLists()
        {
            var g=new GameSession(new Settings(),1);var card=g.State.hand[0];
            foreach(var e in new[]{Enchantment.Coin,Enchantment.Fans,Enchantment.Wild,Enchantment.Arrow}) Assert.IsTrue(g.AddCardEnchantment(card.id,e));
            Assert.IsFalse(g.AddCardEnchantment(card.id,Enchantment.Copy));
            Assert.IsTrue(g.SetCardRank(card.id,7));Assert.IsTrue(g.SetCardSuit(card.id,Suit.Diamonds));
            var copy=card.Copy();copy.enchantments.RemoveAt(0);Assert.AreEqual(4,card.enchantments.Count);
            var restored=WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State));
            Assert.AreEqual(7,restored.hand[0].rank);Assert.AreEqual(Suit.Diamonds,restored.hand[0].suit);CollectionAssert.AreEqual(card.enchantments,restored.hand[0].enchantments);
            Assert.IsTrue(g.RemoveCardEnchantment(card.id,2));Assert.IsTrue(g.AddCardEnchantment(card.id,Enchantment.Copy));
        }
        [Test] public void UtilityEnchantmentsProduceIndependentVisualStepsWithoutMutatingCards()
        {
            var s=new GameState();var card=new Card{id=7,rank=3,suit=Suit.Hearts};s.slots[2]=card;
            card.AddEnchantment(Enchantment.Retry);card.AddEnchantment(Enchantment.Copy);card.AddEnchantment(Enchantment.Retry);
            int redrawsBefore=s.redraws;
            var score=Scoring.Evaluate(s,new Settings());
            Assert.AreEqual(2,score.extraRedraws);Assert.AreEqual(2,score.steps.Count(t=>t.extraRedrawDelta==1));
            Assert.IsTrue(score.steps.Where(t=>t.extraRedrawDelta!=0 || t.copiedCard!=null).All(t=>t.slot==2 && t.sourceSlot==2 && t.source==ScoreSource.Card));
            var copy=score.steps.Single(t=>t.copiedCard!=null).copiedCard;
            Assert.AreEqual(card.rank,copy.rank);Assert.AreEqual(card.suit,copy.suit);CollectionAssert.AreEqual(card.enchantments,copy.enchantments);
            Assert.AreNotSame(card.enchantments,copy.enchantments);Assert.AreEqual(1,score.copies.Count);
            Assert.AreEqual(redrawsBefore,s.redraws);Assert.AreEqual(7,card.id);
        }
        [Test] public void CopyRetryAndDeletedCardsLastOnlyUntilMonthlyReset()
        {
            var g=new GameSession(new Settings{firstTarget=1},7);var s=g.State;s.monthScore=1000;
            var card=s.hand[0];g.AddCardEnchantment(card.id,Enchantment.Copy);g.AddCardEnchantment(card.id,Enchantment.Retry);g.Place(card.id,0);
            int redraws=s.redraws;Assert.IsTrue(g.ScoreWeek());Assert.AreEqual(redraws+1,s.redraws);
            var copied=s.deck.Concat(s.hand).Single(c=>c.id!=card.id && c.enchantments.Contains(Enchantment.Copy));
            CollectionAssert.AreEqual(card.enchantments,copied.enchantments);Assert.AreNotSame(card.enchantments,copied.enchantments);
            Assert.AreEqual(49,s.deck.Count+s.discard.Count+s.hand.Count);
            Assert.IsTrue(g.DeleteCard(copied.id));Assert.IsTrue(g.DeleteCard(card.id));Assert.AreEqual(47,s.deck.Count+s.discard.Count+s.hand.Count);
            for(int i=0;i<3;i++) {g.Place(s.hand[0].id,0);Assert.IsTrue(g.ScoreWeek());}
            Assert.IsTrue(g.OpenShop());Assert.IsTrue(g.NextMonth());
            var all=s.deck.Concat(s.hand).ToArray();Assert.AreEqual(48,all.Length);Assert.AreEqual(48,all.Select(c=>c.id).Distinct().Count());Assert.IsTrue(all.All(c=>c.enchantments.Count==0));Assert.IsTrue(all.All(c=>c.rank>=1 && c.rank<=6));
        }
        [Test] public void ChangedFaceRanksAboveSixParticipateInStraight()
        {
            var cards=Cards(new[]{3,4,5,6,7});for(int i=0;i<cards.Length;i++)cards[i].suit=(Suit)(i%4);
            Assert.AreEqual(5,Scoring.BestPattern(cards).priority);
        }
        [TestCase(true)] [TestCase(false)]
        public void MovingBoardCardSwapsSlotsWithoutChangingHand(bool occupied)
        {
            var g=new GameSession(new Settings(),11);var s=g.State;
            int first=s.hand[0].id,second=s.hand[1].id;g.Place(first,0);if(occupied) g.Place(second,1);
            var hand=s.hand.Select(c=>c.id).ToArray();var source=s.slots[0];var target=s.slots[1];
            source.AddEnchantment(Enchantment.Coin);
            Assert.IsTrue(g.MoveCard(0,1));Assert.AreSame(source,s.slots[1]);Assert.AreSame(target,s.slots[0]);
            CollectionAssert.AreEqual(hand,s.hand.Select(c=>c.id));CollectionAssert.Contains(s.slots[1].enchantments,Enchantment.Coin);
            Assert.IsTrue(g.MoveCard(1,1));Assert.AreSame(source,s.slots[1]);
        }
        [Test] public void InvalidCardMoveDoesNotAlterBoardOrHand()
        {
            var g=new GameSession(new Settings(),11);g.Place(g.State.hand[0].id,0);var before=WorkWork.SaveCodec.Serialize(g.State);
            Assert.IsFalse(g.MoveCard(1,0));Assert.IsFalse(g.MoveCard(0,6));Assert.IsFalse(g.MoveCard(-1,0));
            Assert.AreEqual(before,WorkWork.SaveCodec.Serialize(g.State));g.State.phase=Phase.Shop;before=WorkWork.SaveCodec.Serialize(g.State);
            Assert.IsFalse(g.MoveCard(0,1));Assert.AreEqual(before,WorkWork.SaveCodec.Serialize(g.State));
        }
        [Test] public void CardInspectionListsEnchantmentsInOrderAndSkipsPlainCards()
        {
            var card=new Card{id=1,rank=4};Assert.AreEqual("",WorkWork.InspectionText.CardEffects(card));
            card.AddEnchantment(Enchantment.X2);card.AddEnchantment(Enchantment.Coin);card.AddEnchantment(Enchantment.X2);
            string text=WorkWork.InspectionText.CardEffects(card);
            Assert.IsTrue(text.StartsWith("1. "+WorkWork.InspectionText.EnchantmentEffect(Enchantment.X2)));
            Assert.IsTrue(text.IndexOf("2. "+WorkWork.InspectionText.EnchantmentEffect(Enchantment.Coin))>0);
            Assert.IsTrue(text.EndsWith("3. "+WorkWork.InspectionText.EnchantmentEffect(Enchantment.X2)));
            foreach(Enchantment e in System.Enum.GetValues(typeof(Enchantment))) Assert.IsFalse(string.IsNullOrEmpty(WorkWork.InspectionText.EnchantmentEffect(e)));
        }
        [Test] public void ShopShowsNextTargetAndClearsScoreWithoutPayingAgain()
        {
            var g=new GameSession(new Settings{firstTarget=100},17);var s=g.State;s.monthScore=1000;
            for(int i=0;i<4;i++) {g.Place(s.hand[0].id,0);g.ScoreWeek();}
            Assert.AreEqual(Phase.MonthResult,s.phase);Assert.AreEqual(100,s.target);Assert.Greater(s.monthScore,0);
            int cash=s.cash,income=s.lastIncome;string summary=s.monthSummary;
            Assert.IsTrue(g.OpenShop());Assert.AreEqual(130,s.target);Assert.AreEqual(0,s.monthScore);Assert.IsNull(s.lastScore);
            Assert.AreEqual(cash,s.cash);Assert.AreEqual(income,s.lastIncome);Assert.AreEqual(summary,s.monthSummary);
            Assert.IsFalse(g.OpenShop());Assert.AreEqual(130,s.target);
            var restored=new GameSession(g.Config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(s)));
            Assert.AreEqual(130,restored.State.target);Assert.AreEqual(0,restored.State.monthScore);
            Assert.IsTrue(restored.NextMonth());Assert.AreEqual(2,restored.State.month);Assert.AreEqual(130,restored.State.target);Assert.AreEqual(0,restored.State.monthScore);
        }
        [TestCase(1)] [TestCase(12)] [TestCase(24)] [TestCase(36)]
        public void LegacyShopRestoreAndNextMonthUseIdenticalTarget(int month)
        {
            var saved=new GameState{phase=Phase.Shop,month=month,target=1,monthScore=999,cash=20};
            var g=new GameSession(new Settings{firstTarget=100},1,saved);long target=g.State.target;
            Assert.AreEqual(0,g.State.monthScore);Assert.AreEqual(20,g.State.cash);
            Assert.IsTrue(g.NextMonth());Assert.AreEqual(month+1,g.State.month);Assert.AreEqual(target,g.State.target);
        }
        [TestCase(false,0)] [TestCase(true,0)] [TestCase(true,1)] [TestCase(true,2)]
        public void SoldContentReentersPoolAfterSaveAndCanBeBoughtAgain(bool item,int equipmentSlot)
        {
            var config=new Settings();config.content.Add(new Content{id="staff",price=5});config.content.Add(new Content{id="gear",item=true,price=5});
            var g=new GameSession(config,7);var s=g.State;s.phase=Phase.MonthResult;s.cash=100;g.OpenShop();
            Assert.IsTrue(g.Buy("staff",5));if(item) Assert.IsTrue(g.Buy("gear",5,equipmentSlot));
            string id=item?"gear":"staff";g.RefreshShop();Assert.AreEqual(item,s.offers.Contains(id));
            var offers=s.offers.ToArray();int cash=s.cash,slot=item?15+equipmentSlot:5;
            Assert.IsTrue(g.Sell(slot,item));Assert.AreEqual(cash+3,s.cash);CollectionAssert.DoesNotContain(s.acquired,id);
            CollectionAssert.AreEqual(offers,s.offers);Assert.IsFalse(g.Sell(slot,item));Assert.AreEqual(cash+3,s.cash);
            var restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(s)));
            Assert.IsTrue(restored.RefreshShop());CollectionAssert.Contains(restored.State.offers,id);
            Assert.IsTrue(restored.Buy(id,5,item?equipmentSlot:-1));Assert.IsTrue(restored.RefreshShop());Assert.AreEqual(item,restored.State.offers.Contains(id));
        }
        static Settings EnchanterConfig(Enchantment enchantment,int rank=-1,int suit=-1)
        {
            var config=new Settings{firstTarget=1};
            config.content.Add(new Content{id="enchanter",price=4,effects=new System.Collections.Generic.List<Effect>{
                new Effect{trigger=Trigger.WhileOwned,kind=EffectKind.AddEnchantment,enchantment=enchantment,rankFilter=rank,suitFilter=suit}}});
            return config;
        }
        static System.Collections.Generic.IEnumerable<Card> AllCards(GameState s)
            => s.hand.Concat(s.deck).Concat(s.discard).Concat(s.slots.Where(c=>c!=null));
        [TestCase(6,-1,8)] [TestCase(-1,2,12)] [TestCase(6,2,2)]
        public void BoughtEmployeeEnchantsMatchingCardsAcrossEveryPile(int rank,int suit,int expected)
        {
            var g=new GameSession(EnchanterConfig(Enchantment.Coin,rank,suit),19);var s=g.State;
            // Put matching cards into every zone to verify ownership is independent of placement.
            var all=AllCards(s).ToList();s.hand.Clear();s.deck.Clear();s.discard.Clear();
            for(int i=0;i<all.Count;i++)
            {if(i<6)s.hand.Add(all[i]);else if(i<12)s.discard.Add(all[i]);else if(i<18)s.slots[i-12]=all[i];else s.deck.Add(all[i]);}
            s.phase=Phase.MonthResult;s.cash=10;Assert.IsTrue(g.OpenShop());Assert.IsTrue(g.Buy("enchanter",0));
            Assert.AreEqual(expected,AllCards(s).Count(c=>c.enchantments.Contains(Enchantment.Coin)));
            foreach(var card in AllCards(s))
                Assert.AreEqual((rank<0 || card.rank==rank) && (suit<0 || (int)card.suit==suit),card.enchantments.Contains(Enchantment.Coin));
            var restored=new GameSession(g.Config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(s)));
            Assert.AreEqual(expected,AllCards(restored.State).Count(c=>c.enchantments.Contains(Enchantment.Coin)));
            Assert.IsTrue(restored.Sell(0,false));Assert.IsTrue(AllCards(restored.State).All(c=>c.enchantments.Count==0));
        }
        [TestCase(Enchantment.Coin)] [TestCase(Enchantment.Fans)] [TestCase(Enchantment.Wild)]
        [TestCase(Enchantment.Copy)] [TestCase(Enchantment.Retry)] [TestCase(Enchantment.Arrow)] [TestCase(Enchantment.X2)]
        public void OwnedEnchantmentsSurviveSaveAndReapplyAfterMonthReset(Enchantment enchantment)
        {
            var g=new GameSession(EnchanterConfig(enchantment,6),19);var s=g.State;s.phase=Phase.MonthResult;s.cash=10;
            Assert.IsTrue(g.OpenShop());Assert.IsTrue(g.Buy("enchanter",0));Assert.IsTrue(g.NextMonth());
            var card=AllCards(s).First(c=>c.rank==6);s.deck.Remove(card);s.hand.Remove(card);s.hand.Add(card);
            Assert.IsTrue(g.Place(card.id,0));Assert.IsTrue(g.ReturnCard(0));Assert.IsTrue(g.Place(card.id,1));
            CollectionAssert.AreEqual(new[]{enchantment},card.enchantments);
            string before=WorkWork.SaveCodec.Serialize(s);Scoring.Evaluate(s,g.Config);Scoring.Evaluate(s,g.Config);
            Assert.AreEqual(before,WorkWork.SaveCodec.Serialize(s));
            var restored=new GameSession(g.Config,1,WorkWork.SaveCodec.Deserialize(before));
            Assert.IsTrue(restored.ScoreWeek());
            if(enchantment==Enchantment.Retry) Assert.AreEqual(5,restored.State.redraws);
            if(enchantment==Enchantment.Copy)
            {
                var copy=AllCards(restored.State).Single(c=>c.id!=card.id && c.rank==6 && c.enchantmentSources.SequenceEqual(card.enchantmentSources) && c.enchantments.Contains(Enchantment.Copy) && !s.deck.Any(x=>x.id==c.id) && !s.hand.Any(x=>x.id==c.id));
                Assert.AreNotEqual(card.id,copy.id);
            }
            var sold=new GameSession(g.Config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(restored.State)));
            sold.State.phase=Phase.Shop;Assert.IsTrue(sold.Sell(0,false));
            Assert.IsTrue(AllCards(sold.State).All(c=>c.enchantments.Count==0),"Sale must remove inherited enchantments from copies too");
            restored.State.phase=Phase.Shop;Assert.IsTrue(restored.NextMonth());
            Assert.AreEqual(48,AllCards(restored.State).Count());
            Assert.AreEqual(8,AllCards(restored.State).Count(c=>c.enchantments.Contains(enchantment)));
            restored.State.phase=Phase.Shop;Assert.IsTrue(restored.Sell(0,false));
            Assert.IsTrue(AllCards(restored.State).All(c=>c.enchantments.Count==0));
        }
        [Test] public void SellingRemovesOnlyItsOwnSourceAndPreservesOtherIdenticalEnchantments()
        {
            var config=EnchanterConfig(Enchantment.Coin);
            config.content.Add(new Content{id="second",price=4,effects=new System.Collections.Generic.List<Effect>{
                new Effect{trigger=Trigger.WhileOwned,kind=EffectKind.AddEnchantment,enchantment=Enchantment.Coin}}});
            var g=new GameSession(config,19);var s=g.State;var card=s.hand[0];card.AddEnchantment(Enchantment.Coin);
            s.phase=Phase.MonthResult;s.cash=30;g.OpenShop();g.Buy("enchanter",0);g.Buy("second",1);
            Assert.AreEqual(3,card.enchantments.Count);
            var restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(s)));
            var savedCard=AllCards(restored.State).Single(c=>c.id==card.id);
            restored.Sell(0,false);Assert.AreEqual(2,savedCard.enchantments.Count);
            restored.Sell(1,false);CollectionAssert.AreEqual(new[]{Enchantment.Coin},savedCard.enchantments);
            Assert.AreEqual("",savedCard.enchantmentSources[0]);
        }
        [Test] public void OwnedEnchantmentsRespectCapacityAndFollowChangedFaces()
        {
            var g=new GameSession(EnchanterConfig(Enchantment.Coin,6,2),19);var s=g.State;
            var full=s.hand[0];full.rank=6;full.suit=Suit.Clubs;for(int i=0;i<Card.MaxEnchantments;i++)full.AddEnchantment(Enchantment.Arrow);
            s.phase=Phase.MonthResult;s.cash=10;g.OpenShop();g.Buy("enchanter",0);
            Assert.AreEqual(4,full.enchantments.Count);CollectionAssert.DoesNotContain(full.enchantments,Enchantment.Coin);
            s.phase=Phase.Playing;var card=s.hand[1];g.SetCardRank(card.id,6);g.SetCardSuit(card.id,Suit.Clubs);
            CollectionAssert.Contains(card.enchantments,Enchantment.Coin);
            g.SetCardSuit(card.id,Suit.Hearts);CollectionAssert.DoesNotContain(card.enchantments,Enchantment.Coin);
        }
        [Test] public void RepeatedItemsFillSeparateSlotsAndSurviveSellingAndSaving()
        {
            var config=new Settings();config.content.Add(new Content{id="staff",price=4});config.content.Add(new Content{id="gear",item=true,price=4});
            var g=new GameSession(config,9);var s=g.State;s.phase=Phase.MonthResult;s.cash=100;g.OpenShop();
            Assert.IsTrue(g.Buy("staff",0));
            for(int i=0;i<3;i++){if(i>0)Assert.IsTrue(g.RefreshShop());Assert.IsTrue(g.Buy("gear",0));}
            CollectionAssert.AreEqual(new[]{"gear","gear","gear"},s.items.Take(3));
            Assert.IsTrue(g.RefreshShop());Assert.IsFalse(g.Buy("gear",0));
            Assert.IsTrue(g.Sell(1,true));CollectionAssert.Contains(s.acquired,"gear");
            Assert.AreEqual("gear",s.items[0]);Assert.AreEqual("gear",s.items[2]);
            var restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(s)));
            Assert.IsTrue(restored.Buy("gear",0,1));Assert.AreEqual(3,restored.State.items.Count(id=>id=="gear"));
            for(int i=0;i<3;i++)Assert.IsTrue(restored.Sell(i,true));CollectionAssert.DoesNotContain(restored.State.acquired,"gear");
            Assert.IsFalse(restored.Buy("staff",1));
        }
        [Test] public void DuplicateEquipmentScoresIndependentlyAndEnchantSaleKeepsOtherCopy()
        {
            var config=new Settings();config.content.Add(new Content{id="staff",price=1});
            config.content.Add(new Content{id="gear",item=true,price=1,effects=new System.Collections.Generic.List<Effect>{
                new Effect{trigger=Trigger.CardScored,kind=EffectKind.AddChips,amount=7},
                new Effect{trigger=Trigger.WhileOwned,kind=EffectKind.AddEnchantment,enchantment=Enchantment.Coin}}});
            var g=new GameSession(config,9);var s=g.State;s.phase=Phase.MonthResult;s.cash=100;g.OpenShop();
            Assert.IsTrue(g.Buy("staff",0));Assert.IsTrue(g.Buy("gear",0,0));g.RefreshShop();Assert.IsTrue(g.Buy("gear",0,1));
            var card=s.hand[0];Assert.AreEqual(2,card.enchantments.Count);
            Assert.AreEqual(2,card.enchantmentSources.Distinct().Count());
            s.slots[0]=card;s.hand.Remove(card);var score=Scoring.Evaluate(s,config);
            Assert.AreEqual(2,score.steps.Count(step=>step.source==ScoreSource.Item && step.chipsDelta==7));
            var restored=new GameSession(config,1,WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(s)));
            Assert.AreEqual(2,restored.State.slots[0].enchantments.Count);
            Assert.IsTrue(restored.Sell(0,true));Assert.AreEqual(1,restored.State.slots[0].enchantments.Count);
            Assert.IsTrue(restored.Sell(1,true));Assert.AreEqual(0,restored.State.slots[0].enchantments.Count);
        }
        [Test] public void ShopEnforcesUniqueEmployeesAndEquipmentRequiresEmployee()
        {
            var config=new Settings(); config.content.Add(new Content{id="staff",price=4}); config.content.Add(new Content{id="item",item=true,price=4});
            var game=new GameSession(config,9); var s=game.State; s.phase=Phase.MonthResult; s.cash=100; game.OpenShop();
            Assert.IsFalse(game.Buy("item",0)); Assert.IsTrue(game.Buy("staff",0)); Assert.IsTrue(game.Buy("item",0));
            Assert.IsFalse(game.Sell(0,false)); Assert.IsTrue(game.Sell(0,true)); Assert.IsTrue(game.Sell(0,false));
            game.RefreshShop(); CollectionAssert.Contains(s.offers,"staff"); CollectionAssert.Contains(s.offers,"item");
            Assert.IsTrue(game.Buy("staff",0)); game.RefreshShop(); CollectionAssert.DoesNotContain(s.offers,"staff");
        }
    }
}


