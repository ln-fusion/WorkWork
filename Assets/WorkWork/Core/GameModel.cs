using System;
using System.Collections.Generic;

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
        public void NormalizeEnchantmentSources()
        {
            if(enchantments==null) enchantments=new List<Enchantment>();
            if(enchantmentSources==null) enchantmentSources=new List<string>();
            while(enchantmentSources.Count<enchantments.Count) enchantmentSources.Add("");
            if(enchantmentSources.Count>enchantments.Count) enchantmentSources.RemoveRange(enchantments.Count,enchantmentSources.Count-enchantments.Count);
            if(enchantments.Count>MaxEnchantments)
            {
                enchantments.RemoveRange(MaxEnchantments,enchantments.Count-MaxEnchantments);
                enchantmentSources.RemoveRange(MaxEnchantments,enchantmentSources.Count-MaxEnchantments);
            }
        }
        public bool AddEnchantment(Enchantment value,string source="")
        {
            if(!Enum.IsDefined(typeof(Enchantment),value)) return false;
            if(enchantments==null) enchantments=new List<Enchantment>();
            if(enchantments.Count>=MaxEnchantments) return false;
            NormalizeEnchantmentSources();
            enchantments.Add(value);enchantmentSources.Add(source??"");return true;
        }
        public Card Copy() => new Card { id = id, rank = rank, suit = suit,
            enchantments = enchantments==null ? new List<Enchantment>() : new List<Enchantment>(enchantments),
            enchantmentSources = enchantmentSources==null ? new List<string>() : new List<string>(enchantmentSources) };
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
    }
    [Serializable] public class Settings
    {
        public long firstTarget = 800;
        public int initialCash = 5, redraws = 4;
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
    }
    [Serializable] public class TaskProgress
    {
        public string id;
        public int current;
        public bool rewarded;
        public int elapsedMonths;
        public bool expired;
    }
    [Serializable] public class GameState
    {
        public int month = 1, week = 1, cash, redraws, nextCardId, refreshes;
        public uint randomState;
        public long target, monthScore;
        public Phase phase;
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
    }
    public struct Pattern
    {
        public string name;
        public int priority, chips, mult;
        public Pattern(string name, int priority, int chips, int mult)
        { this.name = name; this.priority = priority; this.chips = chips; this.mult = mult; }
    }
}
