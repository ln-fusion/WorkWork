using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class RulesTests
    {
        static Card[] Cards(int[] ranks, Suit suit = Suit.Spades) => ranks.Select((r,i) => new Card {id=i+1,rank=r,suit=suit}).ToArray();
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
        [Test] public void RedrawNeverMovesPlacedCardAndPreservesAll24Cards()
        {
            var game=new GameSession(new Settings(),71); int id=game.State.hand[0].id; game.Place(id,0);
            for(int i=0;i<4;i++) Assert.IsTrue(game.Redraw());
            Assert.IsFalse(game.Redraw()); Assert.AreEqual(id,game.State.slots[0].id);
            var all=game.State.deck.Concat(game.State.discard).Concat(game.State.hand).Concat(game.State.slots.Where(c=>c!=null)).ToArray();
            Assert.AreEqual(24,all.Length); Assert.AreEqual(24,all.Select(c=>c.id).Distinct().Count());
        }
        [Test] public void EmptyDeckReshufflesDiscardWithoutDuplicatingHand()
        {
            var game=new GameSession(new Settings(),12); var s=game.State;
            s.discard.AddRange(s.deck); s.deck.Clear(); int[] ids=s.hand.Select(c=>c.id).ToArray();
            Assert.IsTrue(game.Redraw()); Assert.AreEqual(6,s.hand.Count); Assert.AreEqual(0,s.discard.Count);
            Assert.AreEqual(24,s.deck.Concat(s.hand).Select(c=>c.id).Distinct().Count());
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
            var score=Scoring.Evaluate(s,config); Assert.AreEqual(10,score.multiplier); Assert.AreEqual(90,score.total);
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
        [Test] public void FiveEnchantmentLimitAndCopiesHaveIndependentSavedLists()
        {
            var g=new GameSession(new Settings(),1);var card=g.State.hand[0];
            foreach(var e in new[]{Enchantment.Coin,Enchantment.Fans,Enchantment.Wild,Enchantment.Arrow,Enchantment.X2}) Assert.IsTrue(g.AddCardEnchantment(card.id,e));
            Assert.IsFalse(g.AddCardEnchantment(card.id,Enchantment.Copy));
            Assert.IsTrue(g.SetCardRank(card.id,7));Assert.IsTrue(g.SetCardSuit(card.id,Suit.Diamonds));
            var copy=card.Copy();copy.enchantments.RemoveAt(0);Assert.AreEqual(5,card.enchantments.Count);
            var restored=WorkWork.SaveCodec.Deserialize(WorkWork.SaveCodec.Serialize(g.State));
            Assert.AreEqual(7,restored.hand[0].rank);Assert.AreEqual(Suit.Diamonds,restored.hand[0].suit);CollectionAssert.AreEqual(card.enchantments,restored.hand[0].enchantments);
            Assert.IsTrue(g.RemoveCardEnchantment(card.id,2));Assert.IsTrue(g.AddCardEnchantment(card.id,Enchantment.Copy));
        }
        [Test] public void CopyRetryAndDeletedCardsLastOnlyUntilMonthlyReset()
        {
            var g=new GameSession(new Settings{firstTarget=1},7);var s=g.State;s.monthScore=1000;
            var card=s.hand[0];g.AddCardEnchantment(card.id,Enchantment.Copy);g.AddCardEnchantment(card.id,Enchantment.Retry);g.Place(card.id,0);
            int redraws=s.redraws;Assert.IsTrue(g.ScoreWeek());Assert.AreEqual(redraws+1,s.redraws);
            var copied=s.deck.Concat(s.hand).Single(c=>c.id!=card.id && c.enchantments.Contains(Enchantment.Copy));
            CollectionAssert.AreEqual(card.enchantments,copied.enchantments);Assert.AreNotSame(card.enchantments,copied.enchantments);
            Assert.AreEqual(25,s.deck.Count+s.discard.Count+s.hand.Count);
            Assert.IsTrue(g.DeleteCard(copied.id));Assert.IsTrue(g.DeleteCard(card.id));Assert.AreEqual(23,s.deck.Count+s.discard.Count+s.hand.Count);
            for(int i=0;i<3;i++) {g.Place(s.hand[0].id,0);Assert.IsTrue(g.ScoreWeek());}
            Assert.IsTrue(g.OpenShop());Assert.IsTrue(g.NextMonth());
            var all=s.deck.Concat(s.hand).ToArray();Assert.AreEqual(24,all.Length);Assert.AreEqual(24,all.Select(c=>c.id).Distinct().Count());Assert.IsTrue(all.All(c=>c.enchantments.Count==0));Assert.IsTrue(all.All(c=>c.rank>=1 && c.rank<=6));
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
        [Test] public void ShopEnforcesUniqueContentAndEquipmentRequiresEmployee()
        {
            var config=new Settings(); config.content.Add(new Content{id="staff",price=4}); config.content.Add(new Content{id="item",item=true,price=4});
            var game=new GameSession(config,9); var s=game.State; s.phase=Phase.MonthResult; s.cash=100; game.OpenShop();
            Assert.IsFalse(game.Buy("item",0)); Assert.IsTrue(game.Buy("staff",0)); Assert.IsTrue(game.Buy("item",0));
            Assert.IsFalse(game.Sell(0,false)); Assert.IsTrue(game.Sell(0,true)); Assert.IsTrue(game.Sell(0,false));
            game.RefreshShop(); CollectionAssert.Contains(s.offers,"staff"); CollectionAssert.DoesNotContain(s.offers,"item");
            Assert.IsTrue(game.Buy("staff",0)); game.RefreshShop(); CollectionAssert.DoesNotContain(s.offers,"staff");
        }
    }
}

