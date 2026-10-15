using System;
using System.Collections.Generic;
using System.Linq;

namespace WorkWork.Core
{
    // This is the command boundary a future authoritative LAN host can reuse.
    public sealed class GameSession
    {
        public GameState State { get; }
        public Settings Config { get; }
        public GameSession(Settings settings, uint seed, GameState saved = null)
        {
            Config = settings;
            State = saved ?? new GameState { cash = settings.initialCash, randomState = seed == 0 ? 1u : seed };
            // JsonUtility serializes null elements as empty objects in class arrays.
            // An empty workstation must never turn into a rank-0 scoring card on Continue.
            if (saved != null)
            {
                for (int i = 0; i < State.slots.Length; i++)
                    if (State.slots[i] != null && State.slots[i].id <= 0) State.slots[i] = null;
                if (State.lastScore != null && (State.lastScore.events == null || State.lastScore.events.Count == 0)) State.lastScore = null;
            }
            if (State.items == null || State.items.Length != 18)
            {
                var old = State.items; State.items = new string[18];
                if(old != null) for(int i=0;i<Math.Min(6,old.Length);i++) State.items[i*3]=old[i];
            }
            for(int i=0;i<State.items.Length;i++) if(string.IsNullOrEmpty(State.items[i])) State.items[i]=null;
            if(saved != null && State.offers.Count != 6 && State.phase == Phase.Shop)
            {
                var old = State.offers.ToArray(); State.offers.Clear();
                foreach(bool item in new[]{false,true})
                {
                    var ids=old.Where(id=>Config.content.Any(c=>c.id==id && c.item==item)).ToArray();
                    for(int i=0;i<3;i++) State.offers.Add(i<ids.Length?ids[i]:null);
                }
            }
            if(saved!=null && State.phase==Phase.Shop) PrepareShopScore();
            if (saved == null) BeginMonth();
            else RefreshOwnedEnchantments();
        }
        int Next(int max)
        {
            uint x = State.randomState;
            x ^= x << 13; x ^= x >> 17; x ^= x << 5;
            State.randomState = x;
            return (int)(x % (uint)max);
        }
        void Shuffle<T>(List<T> list)
        {
            for (int i = list.Count - 1; i > 0; i--) { int j = Next(i + 1); T t = list[i]; list[i] = list[j]; list[j] = t; }
        }
        void BeginMonth()
        {
            State.week = 1; State.redraws = Config.redraws; State.monthScore = 0;
            State.phase = Phase.Playing; State.deck.Clear(); State.discard.Clear(); State.hand.Clear();
            Array.Clear(State.slots, 0, 6);
            // Each copy contains 24 faces; every physical card has an independent ID.
            for(int copy=0;copy<Math.Max(1,Config.deckCopies);copy++)
            for (int suit = 0; suit < 4; suit++) for (int rank = 1; rank <= 6; rank++)
                State.deck.Add(new Card { id = ++State.nextCardId, suit = (Suit)suit, rank = rank });
            Shuffle(State.deck);
            State.target = TargetForMonth(State.month);
            RefreshOwnedEnchantments();
            Draw(6);
            CreateTaskOffers();
        }
        public static TaskDefinition CopyTask(TaskDefinition task) => new TaskDefinition{id=task.id,name=task.name,target=task.target,reward=task.reward,deadlineMonths=task.deadlineMonths,
            patternPriorities=task.patternPriorities==null ? new List<int>() : new List<int>(task.patternPriorities)};
        public IEnumerable<TaskDefinition> ActiveTasks => (State.acceptedTasks??new List<TaskDefinition>()).Where(t=>t!=null && State.tasks?.Any(p=>p.id==t.id && (p.expired||p.rewarded))!=true).Take(3);
        void CreateTaskOffers()
        {
            if(State.month<4 || (State.month-4)%3!=0 || State.lastTaskOfferMonth==State.month) return;
            State.lastTaskOfferMonth=State.month;
            if(ActiveTasks.Count()>=3) return;
            var pool=(Config.tasks??new List<TaskDefinition>()).Where(t=>t!=null && !string.IsNullOrEmpty(t.id) && t.target>0).GroupBy(t=>t.id).Select(g=>g.First()).ToList();
            if(pool.Count(t=>t.reward==1)<1 || pool.Count(t=>t.reward==2)<2 || pool.Count(t=>t.reward==3)<1) return;
            State.taskOffers=new List<TaskDefinition>();
            foreach(int reward in new[]{1,2,2,3})
            {
                var candidates=pool.Where(t=>t.reward==reward).ToList();var chosen=candidates[Next(candidates.Count)];pool.Remove(chosen);
                var offer=CopyTask(chosen);offer.id=chosen.id+"@"+State.month;State.taskOffers.Add(offer);
            }
            State.phase=Phase.TaskChoice;
        }
        public bool ChooseTask(int index)
        {
            if(State.phase!=Phase.TaskChoice || State.taskOffers==null || index<0 || index>=State.taskOffers.Count || ActiveTasks.Count()>=3) return false;
            if(State.acceptedTasks==null) State.acceptedTasks=new List<TaskDefinition>();
            State.acceptedTasks.Add(CopyTask(State.taskOffers[index]));State.taskOffers.Clear();State.phase=Phase.Playing;return true;
        }
        long TargetForMonth(int month)
        {
            decimal target=Config.firstTarget;
            for(int m=2;m<=month;m++) target*=m<=12?1.25m:m<=24?1.4m:m<=36?1.6m:2m;
            return checked((long)(decimal.Ceiling(target/10m)*10m));
        }
        void PrepareShopScore()
        {
            State.target=TargetForMonth(State.month+1);
            State.monthScore=0;
            State.lastScore=null;
        }
        void Draw(int count)
        {
            while (count-- > 0)
            {
                if (State.deck.Count == 0)
                {
                    State.deck.AddRange(State.discard); State.discard.Clear(); Shuffle(State.deck);
                }
                if (State.deck.Count == 0) break;
                var card = State.deck[State.deck.Count - 1];
                State.deck.RemoveAt(State.deck.Count - 1); State.hand.Add(card);
            }
        }
        Card FindCard(int id) => State.hand.Concat(State.deck).Concat(State.discard).Concat(State.slots.Where(c=>c!=null)).FirstOrDefault(c=>c.id==id);
        public bool SetCardRank(int id,int rank)
        {
            var card=FindCard(id);if(State.phase!=Phase.Playing || card==null || rank<1) return false;
            card.rank=rank;RefreshOwnedEnchantments();return true;
        }
        public bool SetCardSuit(int id,Suit suit)
        {
            var card=FindCard(id);if(State.phase!=Phase.Playing || card==null || !Enum.IsDefined(typeof(Suit),suit)) return false;
            card.suit=suit;RefreshOwnedEnchantments();return true;
        }
        public bool AddCardEnchantment(int id,Enchantment enchantment)
        {
            var card=FindCard(id);return State.phase==Phase.Playing && card!=null && card.AddEnchantment(enchantment);
        }
        public bool RemoveCardEnchantment(int id,int index)
        {
            var card=FindCard(id);if(State.phase!=Phase.Playing || card?.enchantments==null || index<0 || index>=card.enchantments.Count) return false;
            card.NormalizeEnchantmentSources();
            card.enchantments.RemoveAt(index);card.enchantmentSources.RemoveAt(index);return true;
        }
        public bool DeleteCard(int id)
        {
            if(State.phase!=Phase.Playing || FindCard(id)==null) return false;
            State.hand.RemoveAll(c=>c.id==id);State.deck.RemoveAll(c=>c.id==id);State.discard.RemoveAll(c=>c.id==id);
            for(int i=0;i<6;i++) if(State.slots[i]?.id==id) State.slots[i]=null;
            return true;
        }
        public bool Place(int cardId, int slot)
        {
            if (State.phase != Phase.Playing || slot < 0 || slot >= 6) return false;
            int index = State.hand.FindIndex(c => c.id == cardId);
            if (index < 0) return false;
            var card = State.hand[index]; State.hand.RemoveAt(index);
            if (State.slots[slot] != null) State.hand.Add(State.slots[slot]);
            State.slots[slot] = card;
            return true;
        }
        public bool MoveCard(int from,int to)
        {
            if(State.phase!=Phase.Playing || from<0 || from>=6 || to<0 || to>=6 || State.slots[from]==null) return false;
            if(from==to) return true;
            var card=State.slots[from];State.slots[from]=State.slots[to];State.slots[to]=card;
            return true;
        }
        void RefreshOwnedEnchantments()
        {
            var cards=State.hand.Concat(State.deck).Concat(State.discard).Concat(State.slots.Where(c=>c!=null)).ToArray();
            foreach(var card in cards)
            {
                card.NormalizeEnchantmentSources();
                for(int i=card.enchantments.Count-1;i>=0;i--)
                    if((card.enchantmentSources[i]??"").StartsWith("owned:"))
                    {card.enchantments.RemoveAt(i);card.enchantmentSources.RemoveAt(i);}
            }
            var owned=State.employees.Concat(State.items).Where(id=>!string.IsNullOrEmpty(id)).Distinct().ToArray();
            // Acquisition order keeps the four available enchantment slots stable when employees move.
            var ordered=State.acquired.Where(id=>owned.Contains(id)).Concat(owned).Distinct();
            foreach(string id in ordered)
                {
                    var def=Config.content.Find(c=>c.id==id);
                    if(def==null) continue;
                    for(int effectIndex=0;effectIndex<def.effects.Count;effectIndex++)
                    {
                        var effect=def.effects[effectIndex];
                        if(effect.trigger!=Trigger.WhileOwned || effect.kind!=EffectKind.AddEnchantment) continue;
                        foreach(var card in cards)
                        if((effect.rankFilter<0 || effect.rankFilter==card.rank) &&
                           (effect.suitFilter<0 || effect.suitFilter==(int)card.suit) &&
                           card.enchantments.Count<Card.MaxEnchantments)
                            card.AddEnchantment(effect.enchantment,"owned:"+id+":"+effectIndex);
                    }
                }
        }
        public bool ReturnCard(int slot)
        {
            if (State.phase != Phase.Playing || slot < 0 || slot >= 6 || State.slots[slot] == null) return false;
            State.hand.Add(State.slots[slot]); State.slots[slot] = null; return true;
        }
        public bool Redraw()
        {
            if (State.phase != Phase.Playing || State.redraws <= 0 || State.hand.Count == 0) return false;
            int count = State.hand.Count;
            State.discard.AddRange(State.hand); State.hand.Clear(); State.redraws--; Draw(count); return true;
        }
        public bool ScoreWeek()
        {
            if (State.phase != Phase.Playing || State.slots.All(c => c == null)) return false;
            var score = Scoring.Evaluate(State, Config); State.lastScore = score;
            if(State.tasks==null) State.tasks=new List<TaskProgress>();
            foreach(var task in ActiveTasks.ToArray())
            {
                bool matches=task.patternPriorities!=null && task.patternPriorities.Contains(score.patternPriority);
                var progress=State.tasks.Find(t=>t.id==task.id);
                if(progress==null && !matches && task.deadlineMonths<=0) continue;
                if(progress==null) {progress=new TaskProgress{id=task.id};State.tasks.Add(progress);}
                if(progress.expired || progress.rewarded) continue;
                if(matches) progress.current=Math.Min(task.target,progress.current+1);
                if(progress.current>=task.target && !progress.rewarded)
                {
                    State.cash+=Math.Max(1,Math.Min(3,task.reward));
                    progress.rewarded=true;
                    score.events.Add($"任务完成：{task.name}，奖金 +{Math.Max(1,Math.Min(3,task.reward))}");
                }
                else if(task.deadlineMonths>0 && State.week==4)
                {
                    progress.elapsedMonths++;
                    if(progress.elapsedMonths>=task.deadlineMonths)
                    {progress.expired=true;score.events.Add($"任务到期：{task.name}");}
                }
            }
            State.monthScore = checked(State.monthScore + score.total); State.redraws += score.extraRedraws;
            foreach (var c in score.copies) { c.id = ++State.nextCardId; State.deck.Add(c); }
            foreach (var c in State.slots) if (c != null) State.discard.Add(c);
            Array.Clear(State.slots, 0, 6);
            if (State.week < 4) { State.week++; Draw(6 - State.hand.Count); }
            else FinishMonth();
            return true;
        }
        public static int ExcessReward(long score, long target)
        {
            if (target <= 0) throw new ArgumentOutOfRangeException(nameof(target));
            return (decimal)score >= 2m * target ? 2 : (decimal)score * 2m >= 3m * target ? 1 : 0;
        }
        void FinishMonth()
        {
            if (State.monthScore < State.target)
            {
                State.phase = Phase.Failed; State.monthSummary = "本月未达标，公司经营结束。"; return;
            }
            int interest = State.cash / 10, bonus = ExcessReward(State.monthScore, State.target), staff = 0;
            foreach (string id in State.employees.Concat(State.items))
            {
                var def = Config.content.Find(c => c.id == id);
                if (def != null) foreach (var e in def.effects)
                    if (e.trigger == Trigger.MonthEnd && e.kind == EffectKind.AddChips) staff += e.amount;
            }
            State.cash += 4 + bonus + interest + staff;
            State.lastIncome=4+bonus+interest+staff; State.lastInterest=interest; State.lastStaffIncome=staff;
            State.monthSummary = $"验收成功：固定 4 + 超额 {bonus} + 利息 {interest} + 员工收入 {staff} = {4 + bonus + interest + staff} 元";
            State.phase = Phase.MonthResult;
        }
        public bool OpenShop()
        {
            if (State.phase != Phase.MonthResult) return false;
            PrepareShopScore();
            State.phase = Phase.Shop; State.refreshes = 0; RollOffers(); return true;
        }
        void RollOffers()
        {
            State.offers.Clear();
            foreach (bool item in new[] {false, true})
            {
                var candidates = Config.content.Where(c => c.item == item && !State.acquired.Contains(c.id)).Select(c => c.id).ToList();
                Shuffle(candidates); for(int i=0;i<3;i++) State.offers.Add(i<candidates.Count?candidates[i]:null);
            }
        }
        public bool RefreshShop()
        {
            int cost = 3 + State.refreshes;
            if (State.phase != Phase.Shop || State.refreshes >= 5 || State.cash < cost) return false;
            State.cash -= cost; State.refreshes++; RollOffers(); return true;
        }
        public int FirstEmptyEquipmentSlot(int employee)
        {
            if(employee<0 || employee>=6) return -1;
            for(int i=0;i<3;i++) if(string.IsNullOrEmpty(State.items[employee*3+i])) return i;
            return -1;
        }
        public bool Buy(string id, int slot, int equipmentSlot = -1)
        {
            if (State.phase != Phase.Shop || slot < 0 || slot >= 6 || string.IsNullOrEmpty(id) || !State.offers.Contains(id)) return false;
            var def = Config.content.Find(c => c.id == id);
            if (def == null || State.cash < def.price || State.acquired.Contains(id)) return false;
            var dest = def.item ? State.items : State.employees;
            int index=slot;
            if(def.item)
            {
                if(string.IsNullOrEmpty(State.employees[slot])) return false;
                if(equipmentSlot<0) equipmentSlot=FirstEmptyEquipmentSlot(slot);
                if(equipmentSlot<0 || equipmentSlot>=3) return false;
                index=slot*3+equipmentSlot;
            }
            if (!string.IsNullOrEmpty(dest[index])) return false;
            dest[index] = id; State.cash -= def.price; State.acquired.Add(id);
            RefreshOwnedEnchantments();
            State.offers[State.offers.IndexOf(id)]=null; return true;
        }
        public bool Sell(int slot, bool item)
        {
            if (State.phase != Phase.Shop || slot < 0 || slot >= (item?18:6)) return false;
            var dest = item ? State.items : State.employees;
            var def = Config.content.Find(c => c.id == dest[slot]);
            if (def == null || (!item && Enumerable.Range(slot*3,3).Any(i=>!string.IsNullOrEmpty(State.items[i])))) return false;
            State.cash += def.price * 60 / 100; dest[slot] = null;
            // Sold content returns to the pool; owned content remains unique.
            State.acquired.RemoveAll(id=>id==def.id);
            RefreshOwnedEnchantments();
            return true;
        }
        public bool MoveEmployee(int from, int to)
        {
            if ((State.phase != Phase.Playing && State.phase != Phase.Shop) || from < 0 || from >= 6 || to < 0 || to >= 6) return false;
            string e = State.employees[from]; State.employees[from] = State.employees[to]; State.employees[to] = e;
            for(int j=0;j<3;j++) { string id=State.items[from*3+j]; State.items[from*3+j]=State.items[to*3+j]; State.items[to*3+j]=id; }
            return true;
        }
        public bool MoveItem(int from, int to)
        {
            if (State.phase != Phase.Shop || from < 0 || from >= 18 || to < 0 || to >= 18 || string.IsNullOrEmpty(State.employees[to/3]) || string.IsNullOrEmpty(State.items[from])) return false;
            if (!string.IsNullOrEmpty(State.items[to]) && string.IsNullOrEmpty(State.employees[from/3])) return false;
            string item = State.items[from]; State.items[from] = State.items[to]; State.items[to] = item; return true;
        }
        public bool NextMonth()
        {
            if (State.phase != Phase.Shop) return false;
            State.month++; BeginMonth(); return true;
        }
    }
}


