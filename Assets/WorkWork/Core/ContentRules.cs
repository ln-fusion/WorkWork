using System;
using System.Collections.Generic;
using System.Linq;

namespace WorkWork.Core
{
    // Shared by command execution and isolated settlement previews. Never uses Unity's RNG.
    public static class ContentRules
    {
        public static IEnumerable<Card> AllCards(GameState s) => s.deck.Concat(s.discard).Concat(s.hand).Concat(s.slots.Where(c=>c!=null));
        public static int Next(GameState s,int max)
        {
            if(max<=0)throw new ArgumentOutOfRangeException(nameof(max));
            uint x=s.randomState==0?1u:s.randomState;x^=x<<13;x^=x>>17;x^=x<<5;s.randomState=x;return (int)(x%(uint)max);
        }
        public static Content Definition(Settings config,string id) => string.IsNullOrEmpty(id)?null:config.content.Find(c=>c.id==id);
        public static bool CanAcquire(GameState s,Content def) => def!=null &&
            (def.item && !def.unique || !s.employees.Concat(s.items).Contains(def.id));
        public static bool HasRule(GameState s,Settings config,string rule) => s.employees.Concat(s.items).Any(id=>Definition(config,id)?.rule==rule);
        public static void RefreshEnchantments(GameState s,Settings config)
        {
            var cards=AllCards(s).ToArray();
            var owned=s.employees.Concat(s.items).Where(id=>!string.IsNullOrEmpty(id)).Distinct().ToArray();
            var grants=new Dictionary<string,Effect>();
            var grantOrder=new List<string>();
            foreach(string id in s.acquired.Where(owned.Contains).Concat(owned).Distinct())
            {
                var def=Definition(config,id);if(def==null)continue;
                for(int i=0;i<def.effects.Count;i++)
                    if(def.effects[i].trigger==Trigger.WhileOwned && def.effects[i].kind==EffectKind.AddEnchantment)
                    {
                        string source="owned:"+id+":"+i;
                        grants.Add(source,def.effects[i]);grantOrder.Add(source);
                    }
            }
            foreach(var card in cards)
            {
                card.NormalizeEnchantmentSources();
                for(int i=card.enchantments.Count-1;i>=0;i--)
                {
                    var keep=Card.Sources(card.enchantmentSources[i]).Where(src=>
                    {
                        if(src.StartsWith("staff:"))return s.employees.Contains(src.Substring(6));
                        if(!src.StartsWith("owned:"))return true;
                        Effect effect;
                        return grants.TryGetValue(src,out effect) && effect.enchantment==card.enchantments[i] && Matches(card,effect,src);
                    }).ToArray();
                    if(keep.Length==0){card.enchantments.RemoveAt(i);card.enchantmentSources.RemoveAt(i);}
                    else card.enchantmentSources[i]=keep.Length==1 && keep[0]=="native"?"":string.Join(";",keep);
                }
            }
            // Preserve eligible existing enchantments; only fill free slots in acquisition order.
            foreach(string source in grantOrder)
                foreach(var card in cards)if(Matches(card,grants[source],source))card.AddEnchantment(grants[source].enchantment,source);
        }
        static bool Matches(Card card,Effect e,string source) => (e.rankFilter<0 || card.rank==e.rankFilter) &&
            (e.suitFilter<0 || (int)card.suit==e.suitFilter) && (e.enchantment!=Enchantment.Copy || !card.blockedCopySources.Contains(source));
        public static Card AddCard(GameState s,Settings config,Card card)
        {
            card.id=++s.nextCardId;s.deck.Insert(Next(s,s.deck.Count+1),card);s.weekAddedCards++;
            RefreshEnchantments(s,config);return card;
        }
        public static bool Delete(GameState s,int id)
        {
            bool found=s.deck.RemoveAll(c=>c.id==id)+s.discard.RemoveAll(c=>c.id==id)+s.hand.RemoveAll(c=>c.id==id)>0;
            for(int i=0;i<s.slots.Length;i++)if(s.slots[i]?.id==id){s.slots[i]=null;found=true;}
            return found;
        }
    }
}
