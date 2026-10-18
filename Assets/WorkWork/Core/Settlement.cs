using System;
using System.Collections.Generic;
using System.Linq;

namespace WorkWork.Core
{
    // Evaluate on a snapshot, then commit that exact outcome after presentation finishes.
    internal sealed class Settlement
    {
        readonly GameState s;
        readonly Settings config;
        readonly ScoreResult result=new ScoreResult();
        long chips, mult;
        int deleted;
        readonly List<Card> pendingGenerated=new List<Card>();
        readonly List<Card> pendingDeleted=new List<Card>();
        readonly HashSet<int> linkedCards=new HashSet<int>(),linkedEmployees=new HashSet<int>(),linkedItems=new HashSet<int>(),linkedEmpty=new HashSet<int>();
        readonly List<Card> initialBoard=new List<Card>();
        void Link(IEnumerable<Card> cards){foreach(var card in cards)if(card!=null)linkedCards.Add(card.id);}
        void Link(Card card){if(card!=null)linkedCards.Add(card.id);}
        void LinkStaff(){for(int i=0;i<6;i++)if(!string.IsNullOrEmpty(s.employees[i]))linkedEmployees.Add(i);}
        void LinkGear(int slot){for(int i=slot*3;i<slot*3+3;i++)if(!string.IsNullOrEmpty(s.items[i]))linkedItems.Add(i);}
        readonly Dictionary<int,List<Enchantment>> displayedEnchantments=new Dictionary<int,List<Enchantment>>();
        readonly Dictionary<int,Card> displayedFaces=new Dictionary<int,Card>();
        Settlement(GameState state,Settings settings){s=state.Copy();config=settings;s.nextCardId=Math.Max(s.nextCardId,ContentRules.AllCards(s).Select(c=>c.id).DefaultIfEmpty(0).Max());
            foreach(var card in s.hand.Concat(s.slots.Where(c=>c!=null))){displayedEnchantments[card.id]=card.enchantments.Distinct().ToList();displayedFaces[card.id]=card.Copy();}}
        IEnumerable<Card> Board => s.slots.Where(c=>c!=null);
        static bool Black(Card c) => c!=null && (c.suit==Suit.Spades || c.suit==Suit.Clubs);
        int BaseSize => Math.Max(1,config.deckCopies)*24;
        Content Def(string id)=>ContentRules.Definition(config,id);
        void Add(long points=0,long multiplier=0){chips=checked(chips+points);mult=checked(mult+multiplier);}
        void Step(int slot,ScoreSource source,string label,long before,long beforeMult,int equipment=-1,bool multiply=false,int operand=0)
        {
            var step=new ScoreStep{slot=slot,sourceSlot=slot,source=source,equipmentSlot=equipment,label=label,chips=chips,multiplier=mult,
                chipsDelta=chips-before,multiplierDelta=mult-beforeMult,multipliesMultiplier=multiply,multiplierOperand=operand};
            result.steps.Add(step);
            if(chips!=before || mult!=beforeMult)
            {step.linkedCardIds.AddRange(linkedCards.OrderBy(i=>i));step.linkedEmployeeSlots.AddRange(linkedEmployees.OrderBy(i=>i));step.linkedItemSlots.AddRange(linkedItems.OrderBy(i=>i));step.linkedEmptySlots.AddRange(linkedEmpty.OrderBy(i=>i));}
            linkedCards.Clear();linkedEmployees.Clear();linkedItems.Clear();linkedEmpty.Clear();
            step.generatedCards.AddRange(pendingGenerated.Select(c=>c.Copy()));pendingGenerated.Clear();
            step.deletedCards.AddRange(pendingDeleted.Select(c=>c.Copy()));pendingDeleted.Clear();
            foreach(var card in s.hand.Concat(s.slots.Where(c=>c!=null)))
            {
                List<Enchantment> previous;
                if(!displayedEnchantments.TryGetValue(card.id,out previous))continue;
                var current=card.enchantments.Distinct().ToList();
                if(!previous.SequenceEqual(current))step.enchantmentChanges.Add(new EnchantmentChange{cardId=card.id,before=previous,after=current});
                displayedEnchantments[card.id]=current;
                var face=displayedFaces[card.id];
                if(face.rank!=card.rank || face.suit!=card.suit)step.faceChanges.Add(new CardFaceChange{cardId=card.id,beforeRank=face.rank,afterRank=card.rank,beforeSuit=face.suit,afterSuit=card.suit});
                face.rank=card.rank;face.suit=card.suit;
            }
        }
        void ChangeRank(Card card,int rank){card.rank=Math.Max(0,rank);ContentRules.RefreshEnchantments(s,config);}
        void ChangeSuit(Card card,Suit suit){if(card.suit!=suit){card.suit=suit;card.suitChangedThisMonth=true;}ContentRules.RefreshEnchantments(s,config);}
        void GenerateCard(Card card){pendingGenerated.Add(ContentRules.AddCard(s,config,card).Copy());}
        void Generate(int count,int rank){for(int i=0;i<count;i++)GenerateCard(new Card{rank=rank,suit=(Suit)ContentRules.Next(s,4)});}
        void Grant(Card card,Content def,Enchantment enchantment)
        {
            card.AddEnchantment(enchantment,"staff:"+def.id);
        }
        void TurnBlack(Card card)
        {
            if(card.suit==Suit.Hearts)ChangeSuit(card,Suit.Clubs);
            else if(card.suit==Suit.Diamonds)ChangeSuit(card,Suit.Spades);
        }
        void ScoreCard(Card card,int slot,bool utility=true,bool onlyWild=false)
        {
            card.NormalizeEnchantmentSources();var es=card.enchantments.ToArray();
            long before=chips,bm=mult;
            if(onlyWild){if(es.Contains(Enchantment.Wild))Add(Board.Where(c=>c.suit==card.suit).Sum(c=>(long)c.rank));}
            else
            {
                long points=card.rank*(es.Contains(Enchantment.Arrow)?2L:1L),bonus=es.Contains(Enchantment.Coin)?20:0;
                if(es.Contains(Enchantment.Wild))bonus+=Board.Where(c=>c.suit==card.suit).Sum(c=>(long)c.rank);
                long extra=es.Contains(Enchantment.Fans)?card.rank:0;if(es.Contains(Enchantment.X2))extra=checked(extra*2);
                Add(checked(points+bonus),extra);
            }
            if(es.Contains(Enchantment.Wild) && Board.Where(c=>c.suit==card.suit).Sum(c=>(long)c.rank)>0)Link(Board.Where(c=>c.suit==card.suit));
            Step(slot,ScoreSource.Card,onlyWild?"“同花加分”额外结算":"卡牌与附魔",before,bm);
            result.steps[result.steps.Count-1].cardSettlement=true;
            var manager=Def(s.employees[slot]);
            if(!onlyWild && es.Contains(Enchantment.Coin) && manager?.rule=="employee.32")
            {long cb=chips,mb=mult;Link(card);Add(manager.values.bonusChips);Step(slot,ScoreSource.Employee,manager.name,cb,mb);}
            if(onlyWild || !utility)return;
            foreach(var e in es.Where(e=>e==Enchantment.Retry || e==Enchantment.Copy))
            {
                Step(slot,ScoreSource.Card,e==Enchantment.Retry?"重抽 +1":"复制卡牌",chips,mult);
                var step=result.steps[result.steps.Count-1];
                if(e==Enchantment.Retry){result.extraRedraws++;step.extraRedrawDelta=1;}
                else {var copy=ContentRules.AddCard(s,config,card.CopyForDeck());result.copies.Add(copy.Copy());step.copiedCard=copy.Copy();}
            }
        }
        void DeleteBoard(int slot,bool rescore,int owner=-1,int equipment=-1,string label=null)
        {
            var card=s.slots[slot];if(card==null)return;
            // Keep the target on the scoring board for Wild, then remove this entity once.
            if(rescore)ScoreCard(card,slot);
            var snapshot=card.Copy();
            if(ContentRules.Delete(s,card.id)){deleted++;pendingDeleted.Add(snapshot);}
            if(rescore && owner>=0)Step(owner,ScoreSource.Item,label+" 删牌",chips,mult,equipment);
        }
        void Generic(Content def,int owner,int slot,Trigger trigger,Card card,int equipment)
        {
            foreach(var e in def.effects.Where(e=>e.trigger==trigger && (!e.local || owner==slot) &&
                (e.suitFilter<0 || card!=null && (int)card.suit==e.suitFilter) && (e.rankFilter<0 || card!=null && card.rank==e.rankFilter)))
            {
                long b=chips,bm=mult;
                switch(e.kind)
                {
                    case EffectKind.AddChips:Add(e.amount);break;
                    case EffectKind.AddMultiplier:Add(0,e.amount);break;
                    case EffectKind.MultiplyMultiplier:mult=checked(mult*e.amount);break;
                    case EffectKind.ExtraRedraw:result.extraRedraws+=e.amount;break;
                    case EffectKind.CopyCard:if(card!=null){var copy=ContentRules.AddCard(s,config,card.CopyForDeck());result.copies.Add(copy.Copy());}break;
                }
                Step(owner,equipment<0?ScoreSource.Employee:ScoreSource.Item,def.name??def.id,b,bm,equipment,e.kind==EffectKind.MultiplyMultiplier,e.amount);
                result.steps.Last().slot=slot;
                if(e.kind==EffectKind.ExtraRedraw)result.steps.Last().extraRedrawDelta=e.amount;
                if(e.kind==EffectKind.CopyCard && card!=null)result.steps.Last().copiedCard=result.copies.Last().Copy();
            }
        }
        void Special(Content def,int slot,int equipment)
        {
            if(def==null || string.IsNullOrEmpty(def.rule))return;
            var v=def.values;var c=s.slots[slot];long b=chips,bm=mult;bool multiply=false;int operand=0;
            int same=c==null?0:Board.Count(x=>x.rank==c.rank);
            switch(def.rule)
            {
                case "employee.01":Link(Board.Where(x=>x.suit==Suit.Hearts));Add(0,Board.Count(x=>x.suit==Suit.Hearts)*v.multiplier);break;
                case "employee.02":if(c!=null)ChangeSuit(c,Suit.Clubs);Link(Board.Where(x=>x.suit==Suit.Clubs));Add(Board.Count(x=>x.suit==Suit.Clubs)*v.chips);break;
                case "employee.03":Add((long)s.monthRedraws*v.chips);break;
                case "employee.04":if(c?.rank==1){Link(c);Add(v.chips);}break;
                case "employee.05":if(c!=null && c.rank%2==0){ChangeSuit(c,Suit.Diamonds);Link(c);Add((long)c.rank*v.chips);}break;
                case "employee.06":
                    if(c!=null){Grant(c,def,Enchantment.Wild);
                        Step(slot,ScoreSource.Employee,def.name,b,bm);
                        if(c.enchantments.Contains(Enchantment.Wild))ScoreCard(c,slot,false,true);
                        b=chips;bm=mult;
                        if(new[]{slot-1,slot+1}.Any(i=>i>=0 && i<6 && s.slots[i]!=null && Black(s.slots[i])==Black(c))){Link(c);Link(new[]{slot-1,slot+1}.Where(i=>i>=0 && i<6 && s.slots[i]!=null && Black(s.slots[i])==Black(c)).Select(i=>s.slots[i]));Add(0,v.multiplier);}
                    }break;
                case "employee.07":Generate(v.count,0);Link(Board.Where(x=>x.rank==0));Add(Board.Count(x=>x.rank==0)*v.chips);break;
                case "employee.08":if(c!=null && c.suit==Suit.Hearts && c.rank%2==1){Link(c);Add(0,v.multiplier);}break;
                case "employee.09":
                    var victims=s.deck.Concat(s.discard).Where(x=>x.rank>=0 && x.rank<=2 && x.enchantments.Count==0).OrderBy(x=>ContentRules.Next(s,int.MaxValue)).Take(v.count).ToArray();
                    foreach(var victim in victims)if(ContentRules.Delete(s,victim.id)){deleted++;pendingDeleted.Add(victim.Copy());}
                    Add(0,Math.Min(v.limit,deleted*v.multiplier));break;
                case "employee.10":
                    if(c!=null && c.rank>=0 && c.rank<=2)DeleteBoard(slot,false);
                    for(int i=0;i<6;i++)if(s.slots[i]==null)linkedEmpty.Add(i);
                    Add(s.slots.Count(x=>x==null)*v.chips+(s.slots[slot]==null?v.bonusChips:0),ContentRules.AllCards(s).Count()<=BaseSize-v.threshold?v.bonusMultiplier:0);break;
                case "employee.11":for(int i=0;i<6;i++)if(!string.IsNullOrEmpty(s.employees[i]) && s.employees[i]!=def.id)linkedEmployees.Add(i);Add(s.employees.Count(x=>!string.IsNullOrEmpty(x) && x!=def.id)*v.chips);break;
                case "employee.12":if(c!=null){var neighbor=slot>0?s.slots[slot-1]:null;if(neighbor==null && slot<5)neighbor=s.slots[slot+1];if(neighbor!=null)ChangeSuit(c,neighbor.suit);
                    var matches=new[]{slot-1,slot+1}.Where(i=>i>=0 && i<6 && s.slots[i]!=null && Black(s.slots[i])==Black(c)).Select(i=>s.slots[i]).ToArray();int count=matches.Length;if(count>0){Link(c);Link(matches);}Add(count==2?v.bonusChips:0,count*v.multiplier);}break;
                case "employee.13":if(c!=null){
                    for(int i=0;i<v.count;i++){var copy=ContentRules.AddCard(s,config,c.CopyForDeck());result.copies.Add(copy.Copy());
                        Step(slot,ScoreSource.Employee,def.name,b,bm);result.steps.Last().copiedCard=copy.Copy();b=chips;bm=mult;}
                    if(same>1)Link(Board.Where(x=>x.rank==c.rank));Add(same>=v.threshold?v.bonusChips:0,(same-1)*v.multiplier);}break;
                case "employee.14":LinkGear(slot);Add(s.items.Skip(slot*3).Take(3).Count(x=>!string.IsNullOrEmpty(x))*v.chips);break;
                case "employee.15":Add(0,Math.Min(v.limit,s.cash/Math.Max(1,v.threshold))*v.multiplier);break;
                case "employee.16":if(c!=null){if(c.rank==0)ChangeRank(c,1);if(c.rank==1){Link(c);Add(v.chips);}}break;
                case "employee.17":if(c!=null && (c.rank==2 || c.rank==4)){Link(c);Add(v.chips);}break;
                case "employee.18":if(s.previousPattern>=0 && s.previousPattern!=result.patternPriority)Add(0,v.multiplier);break;
                case "employee.19":Link(Board.Where(x=>x.enchantments.Contains(Enchantment.Fans)));Add(0,Board.Count(x=>x.enchantments.Contains(Enchantment.Fans))*v.multiplier);break;
                case "employee.20":Link(Board.Where(x=>x.enchantments.Contains(Enchantment.Wild)));Add(Board.Count(x=>x.enchantments.Contains(Enchantment.Wild))*v.chips);break;
                case "employee.21":if(c!=null){ChangeRank(c,checked(c.rank+1));if(Board.Any(x=>x.id!=c.id && x.rank==c.rank)){Link(Board.Where(x=>x.rank==c.rank));Add(0,v.multiplier);}}break;
                case "employee.22":if(c!=null){TurnBlack(c);if(Black(c) && c.rank>=v.threshold){Link(c);Add(v.chips);}}break;
                case "employee.23":if(c!=null){
                    var missing=new[]{Enchantment.Coin,Enchantment.Fans,Enchantment.Wild,Enchantment.Arrow,Enchantment.X2}.Where(e=>!c.enchantments.Contains(e)).ToArray();
                    if(c.enchantments.Count<Card.MaxEnchantments && missing.Length>0)Grant(c,def,missing[ContentRules.Next(s,missing.Length)]);
                    Link(c);Add(c.enchantments.Count*v.chips,c.enchantments.Count==Card.MaxEnchantments?v.bonusMultiplier:0);}break;
                case "employee.24":{long sum=Board.Sum(x=>(long)x.rank);if(sum==v.threshold){Link(Board);mult=checked(mult*v.multiplier);multiply=true;operand=v.multiplier;}else if(sum<v.threshold){Link(Board);Add(v.chips);}}break;
                case "employee.25":
                    if(c!=null)for(int i=0;i<v.count;i++)GenerateCard(new Card{rank=1,suit=c.suit});
                    Add(0,Math.Min(v.limit,Math.Max(0,ContentRules.AllCards(s).Count()-BaseSize)/Math.Max(1,v.threshold)));
                    var gear=s.items.Skip(slot*3).Take(3).ToArray();if(gear.All(x=>!string.IsNullOrEmpty(x)))
                    {Step(slot,ScoreSource.Employee,def.name,b,bm);b=chips;bm=mult;LinkGear(slot);mult=checked(mult*v.multiplier);multiply=true;operand=v.multiplier;}break;
                case "employee.26":
                    if(c!=null && Board.Any(x=>x.id!=c.id && x.suit==c.suit)){
                        var missingSuits=new[]{Suit.Hearts,Suit.Diamonds,Suit.Clubs,Suit.Spades}.Where(suit=>!Board.Any(x=>x.suit==suit)).ToArray();
                        if(missingSuits.Length>0)ChangeSuit(c,missingSuits[0]);}
                    int suits=Board.Select(x=>x.suit).Distinct().Count();Link(Board.GroupBy(x=>x.suit).Select(g=>g.First()));Add(0,suits*v.multiplier+(suits==4?v.bonusMultiplier:0));break;
                case "employee.27":if(c!=null){Grant(c,def,Enchantment.Arrow);Step(slot,ScoreSource.Employee,def.name,b,bm);ScoreCard(c,slot,false);return;}break;
                case "employee.28":if(c!=null){Link(c);if(c.rank<=v.threshold){DeleteBoard(slot,false);Add(v.chips);}else Add(v.bonusChips);}break;
                case "employee.29":if(slot==5)Add(v.chips);break;
                case "employee.30":if(c!=null){TurnBlack(c);ChangeRank(c,checked(c.rank+1));if(Board.All(x=>x.id==c.id || x.rank<c.rank)){Link(Board);mult=checked(mult*v.multiplier);multiply=true;operand=v.multiplier;}else {Link(c);Add(v.chips);}}break;
                case "employee.31":if(c!=null && (c.rank==1 || c.rank==6)){Link(c);Add(0,v.multiplier);}if(Board.Any(x=>x.rank==1) && Board.Any(x=>x.rank==6)){Link(Board.Where(x=>x.rank==1 || x.rank==6));Add(v.bonusChips);}break;
                case "employee.32":Generate(v.count,6);Add(Math.Min(v.limit,s.weekAddedCards*v.chips));break;
                case "employee.33":if(c!=null){TurnBlack(c);if(c.suitChangedThisMonth)Grant(c,def,Enchantment.Fans);
                    if(c.enchantments.Contains(Enchantment.Fans) && c.rank>=v.threshold){Link(c);Add(0,v.multiplier);}}break;
                case "item.BenZai":case "item.Hat":case "item.Bang":Add(v.chips);break;
                case "item.Farmer":case "item.NaiLong":Add(0,v.multiplier);if(v.count>0)Generate(v.count,0);break;
                case "item.C4":
                    Step(slot,ScoreSource.Item,def.name,b,bm,equipment);
                    for(int i=Math.Max(0,slot-1);i<=Math.Min(5,slot+1);i++)DeleteBoard(i,true,slot,equipment,def.name);return;
                case "item.Rail":if(Board.Any() && Board.All(x=>x.rank%2==0)){Link(Board);Add(v.chips);}break;
                case "item.Potato":case "item.Gun":if(slot<5 && s.slots[slot+1]!=null)ChangeRank(s.slots[slot+1],checked(s.slots[slot+1].rank+v.count));break;
                case "item.HotPot":if(c!=null && same==1){Link(c);Add(v.chips);}break;
                case "item.Zhan":if(c!=null && Board.All(x=>x.rank<=c.rank)){Link(Board);Add(v.chips);}break;
                case "item.Spray":if(c!=null && s.previousRanks[slot]>=0 && c.rank==s.previousRanks[slot]){Link(c);Add(v.chips);}break;
                case "item.Log":if(Board.Any() && Board.All(x=>x.rank%2==1)){Link(Board);Add(v.chips);}break;
                case "item.Steam":if(!Board.Any(x=>x.rank==v.threshold)){Link(Board);Add(v.chips);}break;
                case "item.TNT":if(result.patternPriority==10 || result.patternPriority==11){Link(result.patternPriority==11?initialBoard:initialBoard.GroupBy(x=>x.rank).Where(g=>g.Count()>=4).SelectMany(g=>g));Add(0,v.multiplier);}break;
                case "item.Prince":if(Board.Count()==6){Link(Board);Add(0,v.multiplier);}break;
                case "item.RIPot":LinkStaff();Add(0,s.employees.Count(x=>!string.IsNullOrEmpty(x))*v.multiplier);break;
                case "item.Rubbish":if(Board.Any() && Board.All(Black)){Link(Board);Add(0,v.multiplier);}break;
                case "item.3men":int old=deleted;for(int i=Math.Max(0,slot-1);i<=Math.Min(5,slot+1);i++)DeleteBoard(i,false);Add(0,(deleted-old)*v.multiplier);break;
                case "item.Angle":LinkStaff();Add(s.employees.Count(x=>!string.IsNullOrEmpty(x))*v.chips);break;
                case "item.Clock":Add(v.chips);Generate(v.count,0);break;
                case "item.FangSi":int[] options={10,20,50,80,120};Add(options[ContentRules.Next(s,options.Length)]);break;
                case "item.Tomato":if(Board.Any() && Board.All(x=>!Black(x))){Link(Board);Add(0,v.multiplier);}break;
                case "item.Light":Link(Board.Where(x=>x.rank==v.threshold));Add(Board.Count(x=>x.rank==v.threshold)*v.chips);break;
                case "item.Book":Link(Board.Where(x=>(int)x.suit==v.threshold));Add(0,Board.Count(x=>(int)x.suit==v.threshold)*v.multiplier);break;
                case "item.Fusion":Add(0,s.achievedPatterns.Count*v.multiplier);break;
                case "item.Fangdan":Add(s.achievedPatterns.Count*v.chips);break;
                case "item.CockTail":if(c!=null){Link(Board.Where(x=>x.rank==c.rank));Add(same*v.chips);}break;
                case "item.Bing":mult=checked(mult*v.multiplier);multiply=true;operand=v.multiplier;break;
            }
            Step(slot,equipment<0?ScoreSource.Employee:ScoreSource.Item,def.name,b,bm,equipment,multiply,operand);
        }
        ScoreResult Run()
        {
            ContentRules.RefreshEnchantments(s,config);
            for(int owner=0;owner<6;owner++)foreach(string id in new[]{s.employees[owner],s.items[owner*3],s.items[owner*3+1],s.items[owner*3+2]})
                foreach(var e in Def(id)?.effects??new List<Effect>())if(e.trigger==Trigger.BeforePattern)
                    for(int i=0;i<6;i++)if(s.slots[i]!=null && (!e.local || owner==i) && (e.suitFilter<0 || (int)s.slots[i].suit==e.suitFilter))
                    {if(e.kind==EffectKind.SetRank)s.slots[i].rank=Math.Max(0,e.amount);if(e.kind==EffectKind.SetSuit)s.slots[i].suit=(Suit)Math.Max(0,Math.Min(3,e.amount));}
            initialBoard.AddRange(Board.Select(c=>c.Copy()));
            var p=Scoring.BestPattern(s.slots);result.pattern=p.name;result.patternPriority=p.priority;chips=p.chips;mult=1+p.mult;
            if(p.priority>0 && !s.achievedPatterns.Contains(p.priority))s.achievedPatterns.Add(p.priority);
            Step(-1,ScoreSource.Pattern,"牌型奖励",0,0);
            var normalRanks=new[]{-1,-1,-1,-1,-1,-1};
            for(int slot=0;slot<6;slot++)
            {
                var card=s.slots[slot];if(card!=null){normalRanks[slot]=card.rank;ScoreCard(card,slot);}
                // Existing generic global card effects retain their per-card trigger contract.
                if(card!=null)for(int owner=0;owner<6;owner++)
                    foreach(var entry in new[]{Def(s.employees[owner]),Def(s.items[owner*3]),Def(s.items[owner*3+1]),Def(s.items[owner*3+2])}.Select((d,i)=>new{d,i}))
                        if(entry.d!=null)Generic(entry.d,owner,slot,Trigger.CardScored,card,entry.i-1);
                Special(Def(s.employees[slot]),slot,-1);
                for(int equipment=0;equipment<3;equipment++)Special(Def(s.items[slot*3+equipment]),slot,equipment);
            }
            for(int slot=0;slot<6;slot++)foreach(var entry in new[]{Def(s.employees[slot]),Def(s.items[slot*3]),Def(s.items[slot*3+1]),Def(s.items[slot*3+2])}.Select((d,i)=>new{d,i}))
                if(entry.d!=null)Generic(entry.d,slot,slot,Trigger.WeekEnd,null,entry.i-1);
            s.previousRanks=normalRanks;s.previousPattern=p.priority;
            result.chips=chips;result.multiplier=mult;result.total=checked(chips*mult);result.resolvedState=s;
            result.events.AddRange(result.steps.Select(x=>$"{x.label}：{x.chips} × {x.multiplier}"));
            return result;
        }
        public static ScoreResult Evaluate(GameState state,Settings config)=>new Settlement(state,config).Run();
    }
}
