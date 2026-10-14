using System;
using System.Collections.Generic;

namespace WorkWork.Core
{
    public enum Suit { Spades, Hearts, Clubs, Diamonds }
    public enum Enchantment { Coin, Fans, Wild, Copy, Retry, Arrow, X2 }
    public enum Phase { Playing, MonthResult, Shop, Failed }
    public enum EffectKind { AddChips, AddMultiplier, MultiplyMultiplier, SetRank, SetSuit, ExtraRedraw, CopyCard }
    public enum Trigger { BeforePattern, CardScored, WeekEnd, MonthEnd }
    [Serializable] public class Card
    {
        public int id, rank;
        public Suit suit;
        public const int MaxEnchantments = 5;
        public List<Enchantment> enchantments = new List<Enchantment>();
        public bool AddEnchantment(Enchantment value)
        {
            if(!Enum.IsDefined(typeof(Enchantment),value)) return false;
            if(enchantments==null) enchantments=new List<Enchantment>();
            if(enchantments.Count>=MaxEnchantments) return false;
            enchantments.Add(value);return true;
        }
        public Card Copy() => new Card { id = id, rank = rank, suit = suit,
            enchantments = enchantments==null ? new List<Enchantment>() : new List<Enchantment>(enchantments) };
    }
    [Serializable] public class Effect
    {
        public Trigger trigger;
        public EffectKind kind;
        public int amount;
        public bool local = true;
        public int suitFilter = -1;
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
    }
    [Serializable] public class ScoreResult
    {
        public string pattern;
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
