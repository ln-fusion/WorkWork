using System;
using System.Collections.Generic;
using System.Linq;

namespace WorkWork.Core
{
    public static class Scoring
    {
        public static IReadOnlyList<Pattern> Rewards { get; } = Array.AsReadOnly(new[]
        {
            new Pattern("无牌型", 0, 0, 0),
            new Pattern("一对", 1, 5, 1),
            new Pattern("两对", 2, 8, 1),
            new Pattern("三条", 3, 10, 2),
            new Pattern("三对", 4, 12, 2),
            new Pattern("顺子", 5, 14, 2),
            new Pattern("六顺", 6, 16, 3),
            new Pattern("同花", 7, 16, 3),
            new Pattern("葫芦", 8, 18, 3),
            new Pattern("双三条", 9, 22, 4),
            new Pattern("四条", 10, 24, 5),
            new Pattern("四带对", 11, 28, 6),
            new Pattern("同花顺", 12, 36, 8),
            new Pattern("六张同花顺", 13, 50, 12)
        });
        public static Pattern BestPattern(IEnumerable<Card> source)
        {
            var cards = source.Where(c => c != null).ToList();
            var groups = cards.GroupBy(c => c.rank).Select(g => g.Count()).OrderByDescending(n => n).ToArray();
            bool straight = HasStraight(cards, 5), six = HasStraight(cards, 6);
            bool flush = cards.GroupBy(c => c.suit).Any(g => g.Count() >= 5);
            bool sf = cards.GroupBy(c => c.suit).Any(g => HasStraight(g, 5));
            bool sixsf = cards.Count == 6 && cards.GroupBy(c => c.suit).Any(g => HasStraight(g, 6));
            int top = groups.Length == 0 ? 0 : groups[0];
            int pairs = groups.Count(n => n >= 2);
            // 5/6 of a kind have no row in the design: provisional fallback to four of a kind.
            if (sixsf) return Rewards[13];
            if (sf) return Rewards[12];
            if (groups.SequenceEqual(new[] {4, 2})) return Rewards[11];
            if (top >= 4) return Rewards[10];
            if (groups.SequenceEqual(new[] {3, 3})) return Rewards[9];
            if (top >= 3 && pairs >= 2) return Rewards[8];
            if (flush) return Rewards[7];
            if (six && cards.Count == 6) return Rewards[6];
            if (straight) return Rewards[5];
            if (groups.SequenceEqual(new[] {2, 2, 2})) return Rewards[4];
            if (top >= 3) return Rewards[3];
            if (pairs >= 2) return Rewards[2];
            if (top >= 2) return Rewards[1];
            return Rewards[0];
        }
        static bool HasStraight(IEnumerable<Card> cards, int count)
        {
            int run=0,previous=int.MinValue;
            foreach(int rank in cards.Select(c=>c.rank).Distinct().OrderBy(r=>r))
            {
                run=run>0 && rank==previous+1 ? run+1 : 1; previous=rank;
                if(run>=count) return true;
            }
            return false;
        }
        class EffectOrigin
        {
            public Effect effect;
            public int slot, equipment;
        }
        static IEnumerable<EffectOrigin> EffectSources(GameState s, Settings config, int slot)
        {
            var ids=new[] {s.employees[slot], s.items[slot*3], s.items[slot*3+1], s.items[slot*3+2]};
            for(int index=0;index<ids.Length;index++)
            {
                string id=ids[index];
                var def = config.content.Find(c => c.id == id);
                if (def != null) foreach (var effect in def.effects) yield return new EffectOrigin{effect=effect,slot=slot,equipment=index-1};
            }
        }
        static IEnumerable<Effect> Effects(GameState s,Settings config,int slot) => EffectSources(s,config,slot).Select(e=>e.effect);
        static Card[] PrepareCards(GameState state, Settings settings)
        {
            var cards = state.slots.Select(c => c?.Copy()).ToArray();
            for (int owner = 0; owner < 6; owner++)
                foreach (var e in Effects(state, settings, owner).Where(e => e.trigger == Trigger.BeforePattern))
                    for (int slot = 0; slot < 6; slot++)
                        if (cards[slot] != null && (!e.local || owner == slot) && (e.suitFilter < 0 || (int)cards[slot].suit == e.suitFilter))
                        {
                            if (e.kind == EffectKind.SetRank) cards[slot].rank = Math.Max(1, e.amount);
                            if (e.kind == EffectKind.SetSuit) cards[slot].suit = (Suit)Math.Max(0, Math.Min(3, e.amount));
                        }
            return cards;
        }
        public static ScoreResult Preview(GameState state,Settings settings)
        {
            var pattern=BestPattern(PrepareCards(state,settings));
            return new ScoreResult{pattern=pattern.name,patternPriority=pattern.priority,chips=pattern.chips,multiplier=1+pattern.mult};
        }
        static void Step(ScoreResult result,decimal mult,int slot,string label)
        {result.steps.Add(new ScoreStep{slot=slot,label=label,chips=result.chips,multiplier=(double)mult});}
        public static ScoreResult Evaluate(GameState state, Settings settings)
        {
            var cards=PrepareCards(state,settings);
            var result=new ScoreResult();
            var p = BestPattern(cards);
            result.pattern = p.name;
            result.patternPriority = p.priority;
            result.chips = p.chips;
            decimal mult = 1 + p.mult;
            result.events.Add("基础倍率：1");
            result.events.Add($"牌型：{p.name}，基础分 +{p.chips}，倍率 +{p.mult}");
            Step(result,mult,-1,"牌型奖励");
            for (int slot = 0; slot < 6; slot++)
            {
                var card = cards[slot];
                if (card == null) continue;
                var enchants=(card.enchantments ?? new List<Enchantment>()).Take(Card.MaxEnchantments).ToArray();
                long points=card.rank;
                foreach(var enchant in enchants.Where(e=>e==Enchantment.Arrow)) points=checked(points*2);
                long bonus=20L*enchants.Count(e=>e==Enchantment.Coin);
                // Wild uses face ranks of the scoring board, including this card.
                long sameSuit=cards.Where(c=>c!=null && c.suit==card.suit).Sum(c=>(long)c.rank);
                bonus=checked(bonus+sameSuit*enchants.Count(e=>e==Enchantment.Wild));
                decimal cardMult=(decimal)card.rank*enchants.Count(e=>e==Enchantment.Fans);
                foreach(var enchant in enchants.Where(e=>e==Enchantment.X2)) cardMult*=2;
                result.chips=checked(result.chips+points+bonus);mult+=cardMult;
                result.events.Add($"工位 {slot + 1}：卡牌基础分 +{points}，附魔基础分 +{bonus}，附魔倍率 +{cardMult}");
                Step(result,mult,slot,$"工位 {slot+1}：卡牌与附魔");
                var cardStep=result.steps[result.steps.Count-1];cardStep.source=ScoreSource.Card;cardStep.sourceSlot=slot;
                cardStep.chipsDelta=points+bonus;cardStep.multiplierDelta=(double)cardMult;
                foreach(var enchant in enchants.Where(e=>e==Enchantment.Retry || e==Enchantment.Copy))
                {
                    Step(result,mult,slot,$"工位 {slot+1}：{(enchant==Enchantment.Retry?"重抽 +1":"复制卡牌")}");
                    var triggerStep=result.steps[result.steps.Count-1];triggerStep.source=ScoreSource.Card;triggerStep.sourceSlot=slot;
                    if(enchant==Enchantment.Retry){result.extraRedraws++;triggerStep.extraRedrawDelta=1;}
                    else {result.copies.Add(card.Copy());triggerStep.copiedCard=card.Copy();}
                }
                // Preserve workstation, employee, equipment slot and configured effect order.
                var effects = new List<EffectOrigin>();
                for (int owner = 0; owner < 6; owner++)
                    effects.AddRange(EffectSources(state, settings, owner).Where(o => o.effect.trigger == Trigger.CardScored && (!o.effect.local || owner == slot) && (o.effect.suitFilter < 0 || (int)card.suit == o.effect.suitFilter)));
                foreach (var origin in effects) ApplySource(origin,result,ref mult,card,slot);
            }
            for (int owner = 0; owner < 6; owner++)
                foreach (var origin in EffectSources(state, settings, owner).Where(o => o.effect.trigger == Trigger.WeekEnd))
                    ApplySource(origin,result,ref mult,null,owner);
            result.multiplier = (double)mult;
            result.total = checked((long)decimal.Floor(result.chips * mult));
            result.events.Add($"本周合计：{result.chips} × {mult} = {result.total}");
            return result;
        }
        static void ApplySource(EffectOrigin origin,ScoreResult result,ref decimal mult,Card card,int slot)
        {
            long before=result.chips;decimal beforeMult=mult;int redraws=result.extraRedraws,copies=result.copies.Count;var e=origin.effect;
            Apply(e,result,ref mult,card,$"工位 {slot+1}");
            Step(result,mult,slot,$"工位 {slot+1}：{e.kind}");
            var step=result.steps[result.steps.Count-1];step.source=origin.equipment<0?ScoreSource.Employee:ScoreSource.Item;
            step.sourceSlot=origin.slot;step.equipmentSlot=origin.equipment;step.chipsDelta=result.chips-before;
            step.multiplierDelta=(double)(mult-beforeMult);step.multipliesMultiplier=e.kind==EffectKind.MultiplyMultiplier;
            step.multiplierOperand=e.amount;
            step.extraRedrawDelta=result.extraRedraws-redraws;
            if(result.copies.Count>copies)step.copiedCard=result.copies[result.copies.Count-1].Copy();
        }
        static void Apply(Effect e, ScoreResult result, ref decimal mult, Card card, string label)
        {
            switch (e.kind)
            {
                case EffectKind.AddChips: result.chips += e.amount; result.events.Add($"{label}效果：基础分 +{e.amount}"); break;
                case EffectKind.AddMultiplier: mult += e.amount; result.events.Add($"{label}效果：倍率 +{e.amount}"); break;
                case EffectKind.MultiplyMultiplier: mult *= e.amount; result.events.Add($"{label}效果：倍率 ×{e.amount}"); break;
                case EffectKind.ExtraRedraw: result.extraRedraws += e.amount; break;
                case EffectKind.CopyCard: if (card != null) result.copies.Add(card.Copy()); break;
            }
        }
    }
}

