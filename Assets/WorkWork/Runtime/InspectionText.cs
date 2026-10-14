using System.Linq;
using WorkWork.Core;

namespace WorkWork
{
    public static class InspectionText
    {
        public static string EnchantmentEffect(Enchantment enchantment)
        {
            switch(enchantment)
            {
                case Enchantment.Coin:return "金币（coin）：该牌结算时，基础分 +20。";
                case Enchantment.Fans:return "粉丝（fans）：该牌结算时，增加等于牌面点数的额外倍率。";
                case Enchantment.Wild:return "同花加分（wild）：额外增加场上同花色卡牌的点数总和，包括自身。";
                case Enchantment.Copy:return "复制（copy）：该牌结算时，复制一份加入牌库，保留点数、花色与附魔；本月有效。";
                case Enchantment.Retry:return "重抽（retry）：该牌结算时，重抽次数 +1。";
                case Enchantment.Arrow:return "双倍点数（arrow）：该牌计入基础分的点数翻倍，不改变牌面与牌型。";
                case Enchantment.X2:return "双倍倍率（x2）：该牌提供的额外倍率 ×2，不翻倍已累计的总倍率。";
                default:return "";
            }
        }
        public static string CardEffects(Card card)
        {
            if(card?.enchantments==null) return "";
            return string.Join("\n\n",card.enchantments.Take(Card.MaxEnchantments).Select((e,i)=>(i+1)+". "+EnchantmentEffect(e)));
        }
    }
}
