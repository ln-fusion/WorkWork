using System;
using System.Collections.Generic;
using System.Linq;

namespace WorkWork.Core
{
    public sealed partial class GameSession
    {
        int EffectiveMonth => State.phase==Phase.Shop && !State.openingShop?State.month+1:State.month;
        bool HasRule(string rule)=>ContentRules.HasRule(State,Config,rule);
        public int PurchasePrice(string id)
        {
            var def=ContentRules.Definition(Config,id);if(def==null)return int.MaxValue;
            int discount=0;
            if(def.item && HasRule("employee.14") && State.itemDiscountMonth!=EffectiveMonth)
                discount=Config.content.First(c=>c.rule=="employee.14").values.discount;
            if(!def.item && def.rule!="employee.11" && HasRule("employee.11") && State.staffDiscountMonth!=EffectiveMonth)
                discount=Config.content.First(c=>c.rule=="employee.11").values.discount;
            return Math.Max(def.price==0?0:1,def.price-discount);
        }
        public int RefreshPrice => HasRule("employee.29") && State.freeRefreshMonth!=EffectiveMonth?0:3+State.refreshes;
        bool EmployeeLocked(int slot)=>State.items.Skip(slot*3).Take(3).Any(id=>ContentRules.Definition(Config,id)?.locksEmployee==true);
        void NormalizeContentState()
        {
            if(State.previousRanks==null || State.previousRanks.Length!=6)State.previousRanks=new[]{-1,-1,-1,-1,-1,-1};
            if(State.itemBoughtMonths==null || State.itemBoughtMonths.Length!=18)State.itemBoughtMonths=new int[18];
            if(State.achievedPatterns==null)State.achievedPatterns=new List<int>();
            if(State.monthGrantRecords==null)State.monthGrantRecords=new List<string>();
            if(State.pendingSevenMonths==null)State.pendingSevenMonths=new List<int>();
            if(State.pendingMonthlyCards==null)State.pendingMonthlyCards=new List<MonthlyCardGrant>();
            foreach(int month in State.pendingSevenMonths)
                if(!State.pendingMonthlyCards.Any(g=>g.month==month && g.employeeId=="employee.18"))
                    State.pendingMonthlyCards.Add(new MonthlyCardGrant{month=month,employeeId="employee.18"});
            State.pendingSevenMonths.Clear();
            if(State.tasks==null)State.tasks=new List<TaskProgress>();
            foreach(var task in State.tasks)if(task.patterns==null)task.patterns=new List<int>();
            if(State.acceptedTasks==null)State.acceptedTasks=new List<TaskDefinition>();
            if(State.taskOffers==null)State.taskOffers=new List<TaskDefinition>();
            State.nextCardId=Math.Max(State.nextCardId,ContentRules.AllCards(State).Select(c=>c.id).DefaultIfEmpty(0).Max());
            if(State.contentVersion<1 && Config.content.Any(c=>c.id=="employee.01"))
            {
                var old=new[]{"employee.chips","employee.mult","employee.redraw","employee.enchant.coin","employee.enchant.fans","employee.enchant.wild","employee.enchant.copy","employee.enchant.retry","employee.enchant.arrow","employee.enchant.x2","item.chips","item.mult","item.double"};
                var replacement=new[]{"employee.01","employee.11","employee.16","employee.15","employee.07","employee.20","employee.04","employee.03","employee.05","employee.06","item.BenZai","item.Farmer","item.Bing"};
                Func<string,string> map=id=>Array.IndexOf(old,id)>=0?replacement[Array.IndexOf(old,id)]:id;
                State.employees=State.employees.Select(map).ToArray();State.items=State.items.Select(map).ToArray();State.offers=State.offers.Select(map).ToList();State.acquired=State.acquired.Select(map).Distinct().ToList();
                var seen=new HashSet<string>();for(int i=0;i<6;i++)if(!string.IsNullOrEmpty(State.employees[i]) && !seen.Add(State.employees[i]))State.employees[i]=null;
                State.contentVersion=1;
            }
        }
        void QueueMonthlyCards(string employeeId,int month)
        {
            string record=month+":"+employeeId;
            if(State.monthGrantRecords.Contains(record))return;
            State.monthGrantRecords.Add(record);State.pendingMonthlyCards.Add(new MonthlyCardGrant{month=month,employeeId=employeeId});
        }
        void ApplyMonthlyCards()
        {
            foreach(string id in State.employees.Where(id=>!string.IsNullOrEmpty(id)))
                if(new[]{"employee.16","employee.18"}.Contains(ContentRules.Definition(Config,id)?.rule))QueueMonthlyCards(id,State.month);
            foreach(var grant in State.pendingMonthlyCards.Where(g=>g.month==State.month).ToArray())
            {
                var def=ContentRules.Definition(Config,grant.employeeId);if(def==null)continue;
                var batch=new GeneratedCardBatch{employeeId=grant.employeeId};
                for(int i=0;i<def.values.count;i++)batch.cards.Add(ContentRules.AddCard(State,Config,new Card{
                    rank=def.rule=="employee.18"?7:0,suit=def.rule=="employee.18"?(Suit)(i%4):(Suit)ContentRules.Next(State,4)}).Copy());
                if(batch.cards.Count>0)MonthlyGeneratedCards.Add(batch);
            }
            State.pendingMonthlyCards.RemoveAll(g=>g.month<=State.month);
        }
        int MatureItems()
        {
            int before=State.cash,fees=0;
            for(int i=0;i<18;i++)
            {
                var def=ContentRules.Definition(Config,State.items[i]);if(def==null)continue;
                if(State.itemBoughtMonths[i]<=0)State.itemBoughtMonths[i]=State.month;
                bool due=def.lifetimeMonths>0 && State.month-State.itemBoughtMonths[i]+1>=def.lifetimeMonths;
                if(def.rule=="item.Hat")fees+=def.values.count;
                if(due)
                {
                    if(def.rule=="item.Candy")State.cash+=def.values.chips;
                    State.items[i]=null;State.itemBoughtMonths[i]=0;
                    if(!State.items.Contains(def.id))State.acquired.Remove(def.id);
                }
            }
            State.cash=Math.Max(0,State.cash-fees);RefreshOwnedEnchantments();return State.cash-before;
        }
    }
}
