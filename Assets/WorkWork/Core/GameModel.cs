using System;
using System.Collections.Generic;
using System.Linq;

namespace WorkWork.Core
{
    public enum Suit { Spades, Hearts, Clubs, Diamonds }
    public enum Enchantment { Coin, Fans, Wild, Copy, Retry, Arrow, X2 }
    public enum Phase { Playing, MonthResult, Shop, Failed, TaskChoice }
    public enum EffectKind { AddChips, AddMultiplier, MultiplyMultiplier, SetRank, SetSuit, ExtraRedraw, CopyCard, AddEnchantment }
    public enum Trigger { BeforePattern, CardScored, WeekEnd, MonthEnd, WhileOwned }
    [Serializable] public class Card
    {
        public int id, rank;
        public Suit suit;
        public const int MaxEnchantments = 4;
        public List<Enchantment> enchantments = new List<Enchantment>();
        public List<string> enchantmentSources = new List<string>();
        public List<string> blockedCopySources = new List<string>(), monthlyGrants = new List<string>();
        public bool suitChangedThisMonth;
        public static string MergeSources(string a,string b) => string.Join(";",(a??"").Split(';').Concat((b??"").Split(';')).Select(s=>s==""?"native":s).Distinct());
        public static string[] Sources(string source) => (source??"").Split(';').Select(s=>s==""?"native":s).ToArray();
        public void NormalizeEnchantmentSources()
        {
            if(enchantments==null) enchantments=new List<Enchantment>();
            if(enchantmentSources==null) enchantmentSources=new List<string>();
            while(enchantmentSources.Count<enchantments.Count) enchantmentSources.Add("");
            if(enchantmentSources.Count>enchantments.Count) enchantmentSources.RemoveRange(enchantments.Count,enchantmentSources.Count-enchantments.Count);
            for(int i=0;i<enchantments.Count;i++)
                for(int j=enchantments.Count-1;j>i;j--) if(enchantments[i]==enchantments[j])
                {enchantmentSources[i]=MergeSources(enchantmentSources[i],enchantmentSources[j]);enchantments.RemoveAt(j);enchantmentSources.RemoveAt(j);}
            if(enchantments.Count>MaxEnchantments) {enchantments.RemoveRange(MaxEnchantments,enchantments.Count-MaxEnchantments);enchantmentSources.RemoveRange(MaxEnchantments,enchantmentSources.Count-MaxEnchantments);}
            if(blockedCopySources==null)blockedCopySources=new List<string>();
            if(monthlyGrants==null)monthlyGrants=new List<string>();
        }
        public bool AddEnchantment(Enchantment value,string source="")
        {
            if(!Enum.IsDefined(typeof(Enchantment),value)) return false;
            if(enchantments==null) enchantments=new List<Enchantment>();
            NormalizeEnchantmentSources();
            int index=enchantments.IndexOf(value);
            if(index>=0){if(!string.IsNullOrEmpty(source))enchantmentSources[index]=MergeSources(enchantmentSources[index],source);return false;}
            if(enchantments.Count>=MaxEnchantments) return false;
            enchantments.Add(value);enchantmentSources.Add(source??"");return true;
        }
        public Card Copy() => new Card { id = id, rank = rank, suit = suit,
            enchantments = enchantments==null ? new List<Enchantment>() : new List<Enchantment>(enchantments),
            enchantmentSources = enchantmentSources==null ? new List<string>() : new List<string>(enchantmentSources),
            blockedCopySources=blockedCopySources==null?new List<string>():new List<string>(blockedCopySources),
            monthlyGrants=monthlyGrants==null?new List<string>():new List<string>(monthlyGrants),suitChangedThisMonth=suitChangedThisMonth };
        public Card CopyForDeck()
        {
            var copy=Copy();copy.NormalizeEnchantmentSources();
            int index=copy.enchantments.IndexOf(Enchantment.Copy);
            if(index>=0){copy.blockedCopySources.AddRange(Sources(copy.enchantmentSources[index]));copy.enchantments.RemoveAt(index);copy.enchantmentSources.RemoveAt(index);}
            return copy;
        }
    }
    [Serializable] public class Effect
    {
        public Trigger trigger;
        public EffectKind kind;
        public int amount;
        public bool local = true;
        public int suitFilter = -1;
        public int rankFilter = -1;
        public Enchantment enchantment;
    }
    [Serializable] public class Content
    {
        public string id, name, description;
        public bool item;
        public int price;
        public List<Effect> effects = new List<Effect>();
        public string rule;
        public RuleValues values = new RuleValues();
        public bool locksEmployee;
        public int lifetimeMonths;
    }
    [Serializable] public class RuleValues
    {
        public int chips, multiplier, bonusChips, bonusMultiplier, count, threshold, limit, discount;
    }
    [Serializable] public class Settings
    {
        public long firstTarget = 600;
        public int initialCash = 5, redraws = 4;
        public int deckCopies = 2;
        public double firstYearGrowth=1.25, secondYearGrowth=1.4, thirdYearGrowth=1.6, laterGrowth=2;
        public int targetRounding=10;
        public List<Content> content = new List<Content>();
        public List<TaskDefinition> tasks = new List<TaskDefinition>();
    }
    [Serializable] public class TaskDefinition
    {
        public string id, name;
        public int target=2;
        public int reward=1;
        public int deadlineMonths;
        public List<int> patternPriorities=new List<int>();
        public TaskKind kind;
        public string description;
    }
    public enum TaskKind { Pattern, AllRed, AllBlack, MonthNoRedraw, AllHigh, DoubleTargetMonth, MonthNotFull, MonthDifferentPatterns, BuyShelfItems, NoTradeMonths, AllOtherPatterns, TenfoldMonth }
    [Serializable] public class TaskProgress
    {
        public string id;
        public int current;
        public bool rewarded;
        public int elapsedMonths;
        public bool expired;
        public int monthlyWeeks, consecutiveMonths;
        public bool monthInvalid;
        public List<int> patterns = new List<int>();
    }
    [Serializable] public class MonthlyCardGrant
    {
        public int month;
        public string employeeId;
    }
    [Serializable] public class GameState
    {
        public int month = 1, week = 1, cash, redraws, nextCardId, refreshes;
        public uint randomState;
        public long target, monthScore;
        public Phase phase;
        public bool openingShop;
        public List<Card> deck = new List<Card>(), discard = new List<Card>(), hand = new List<Card>();
        public Card[] slots = new Card[6];
        public string[] employees = new string[6], items = new string[18];
        public List<string> acquired = new List<string>(), offers = new List<string>();
        public ScoreResult lastScore;
        public string monthSummary = "";
        public int lastIncome,lastInterest,lastStaffIncome;
        public List<TaskProgress> tasks = new List<TaskProgress>();
        public List<TaskDefinition> acceptedTasks = new List<TaskDefinition>(), taskOffers = new List<TaskDefinition>();
        public int lastTaskOfferMonth;
        public int contentVersion, weekAddedCards, monthRedraws;
        public int previousPattern=-1;
        public int[] previousRanks = {-1,-1,-1,-1,-1,-1};
        public int[] itemBoughtMonths = new int[18];
        public int staffDiscountMonth, itemDiscountMonth, freeRefreshMonth;
        public int shelfBatch, shelfBoughtItems, shelfInitialItems;
        public List<int> achievedPatterns = new List<int>();
        public List<string> monthGrantRecords = new List<string>();
        public List<int> pendingSevenMonths = new List<int>();
        public List<MonthlyCardGrant> pendingMonthlyCards = new List<MonthlyCardGrant>();
        public GameState Copy()
        {
            var c=(GameState)MemberwiseClone();
            c.deck=deck.Select(x=>x.Copy()).ToList();c.discard=discard.Select(x=>x.Copy()).ToList();c.hand=hand.Select(x=>x.Copy()).ToList();
            c.slots=slots.Select(x=>x?.Copy()).ToArray();c.employees=(string[])employees.Clone();c.items=(string[])items.Clone();
            c.acquired=acquired.ToList();c.offers=offers.ToList();
            c.previousRanks=(int[])previousRanks.Clone();c.itemBoughtMonths=(int[])itemBoughtMonths.Clone();
            c.achievedPatterns=achievedPatterns.ToList();c.monthGrantRecords=monthGrantRecords.ToList();c.pendingSevenMonths=pendingSevenMonths.ToList();
            c.pendingMonthlyCards=(pendingMonthlyCards??new List<MonthlyCardGrant>()).Select(x=>new MonthlyCardGrant{month=x.month,employeeId=x.employeeId}).ToList();
            c.tasks=(tasks??new List<TaskProgress>()).Select(x=>new TaskProgress{id=x.id,current=x.current,rewarded=x.rewarded,elapsedMonths=x.elapsedMonths,expired=x.expired,
                monthlyWeeks=x.monthlyWeeks,consecutiveMonths=x.consecutiveMonths,monthInvalid=x.monthInvalid,patterns=(x.patterns??new List<int>()).ToList()}).ToList();
            c.acceptedTasks=(acceptedTasks??new List<TaskDefinition>()).Select(GameSession.CopyTask).ToList();c.taskOffers=(taskOffers??new List<TaskDefinition>()).Select(GameSession.CopyTask).ToList();
            return c;
        }
    }
    [Serializable] public class ScoreResult
    {
        public string pattern;
        public int patternPriority;
        public long chips, total;
        public double multiplier;
        public int extraRedraws;
        public List<Card> copies = new List<Card>();
        public List<string> events = new List<string>();
        public List<ScoreStep> steps = new List<ScoreStep>();
        [NonSerialized] public GameState resolvedState;
    }
    public enum ScoreSource { Pattern, Card, Employee, Item }
    [Serializable] public class EnchantmentChange
    {
        public int cardId;
        public List<Enchantment> before=new List<Enchantment>(),after=new List<Enchantment>();
    }
    [Serializable] public class CardFaceChange
    {
        public int cardId,beforeRank,afterRank;
        public Suit beforeSuit,afterSuit;
    }
    [Serializable] public class ScoreStep
    {
        public int slot;
        public string label;
        public long chips;
        public double multiplier;
        public ScoreSource source;
        public int sourceSlot, equipmentSlot;
        public long chipsDelta;
        public double multiplierDelta, multiplierOperand;
        public bool multipliesMultiplier;
        public int extraRedrawDelta;
        public Card copiedCard;
        public List<EnchantmentChange> enchantmentChanges=new List<EnchantmentChange>();
        public List<CardFaceChange> faceChanges=new List<CardFaceChange>();
        public List<Card> generatedCards=new List<Card>();
        public List<Card> deletedCards=new List<Card>();
        public List<int> linkedCardIds=new List<int>(),linkedEmployeeSlots=new List<int>(),linkedItemSlots=new List<int>(),linkedEmptySlots=new List<int>();
    }
    public class GeneratedCardBatch
    {
        public string employeeId;
        public List<Card> cards=new List<Card>();
    }
    public struct Pattern
    {
        public string name;
        public int priority, chips, mult;
        public Pattern(string name, int priority, int chips, int mult)
        { this.name = name; this.priority = priority; this.chips = chips; this.mult = mult; }
    }
}
