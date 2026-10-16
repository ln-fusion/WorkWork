using System.Linq;
namespace WorkWork.Core
{
    public sealed partial class GameSession
    {
        public bool DeveloperAdd(string id,int slot,int equipment=-1)
        {
            if((State.phase!=Phase.Playing && State.phase!=Phase.Shop) || slot<0 || slot>=6)return false;
            var def=ContentRules.Definition(Config,id);if(!ContentRules.CanAcquire(State,def))return false;
            if(def.item)
            {
                if(string.IsNullOrEmpty(State.employees[slot]))return false;
                if(equipment<0)equipment=FirstEmptyEquipmentSlot(slot);
                if(equipment<0 || equipment>=3 || !string.IsNullOrEmpty(State.items[slot*3+equipment]))return false;
                State.items[slot*3+equipment]=id;State.itemBoughtMonths[slot*3+equipment]=EffectiveMonth;
            }
            else
            {
                if(!string.IsNullOrEmpty(State.employees[slot]))return false;
                State.employees[slot]=id;
                if(def.rule=="employee.16" || def.rule=="employee.18")QueueMonthlyCards(id,EffectiveMonth);
            }
            if(!State.acquired.Contains(id))State.acquired.Add(id);
            if(State.phase==Phase.Playing)ApplyMonthlyCards();
            RefreshOwnedEnchantments();return true;
        }
        public bool DeveloperRemove(int slot,bool item)
        {
            if((State.phase!=Phase.Playing && State.phase!=Phase.Shop) || slot<0 || slot>=(item?18:6))return false;
            var dest=item?State.items:State.employees;string id=dest[slot];
            if(string.IsNullOrEmpty(id) || (!item && State.items.Skip(slot*3).Take(3).Any(x=>!string.IsNullOrEmpty(x))))return false;
            dest[slot]=null;if(item)State.itemBoughtMonths[slot]=0;
            if(!State.employees.Concat(State.items).Contains(id))State.acquired.RemoveAll(x=>x==id);
            RefreshOwnedEnchantments();return true;
        }
        public bool DeveloperMove(int from,int to,bool item)
        {
            if(State.phase!=Phase.Playing && State.phase!=Phase.Shop)return false;
            var phase=State.phase;
            try{State.phase=Phase.Shop;return item?MoveItem(from,to):MoveEmployee(from,to);}
            finally{State.phase=phase;}
        }
    }
}
