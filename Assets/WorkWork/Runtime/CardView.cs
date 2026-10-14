using TMPro;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    public class CardView : MonoBehaviour
    {
        public Image face, suitIcon;
        public Image[] enchantmentIcons;
        public TMP_Text rankText, suitText;
        public Button button;
        public DragToken drag;
        Card boundCard;
        public Card BoundCard => boundCard;
        VisualTheme boundTheme;
        bool boundSelected;
        int shownRank,shownSuit;
        string shownEnchantments;
        string EnchantmentSignature(Card card) => card.enchantments==null?"":string.Join(",",card.enchantments);
        void LateUpdate()
        {
            if(boundCard!=null && boundTheme!=null && (shownRank!=boundCard.rank || shownSuit!=(int)boundCard.suit || shownEnchantments!=EnchantmentSignature(boundCard))) Bind(boundCard,boundTheme,boundSelected);
        }
        public void Bind(Card card, VisualTheme theme, bool selected)
        {
            boundCard=card;boundTheme=theme;boundSelected=selected;shownRank=card.rank;shownSuit=(int)card.suit;shownEnchantments=EnchantmentSignature(card);
            face.sprite = theme.cardFace;
            face.color = selected ? theme.selectedColor : theme.cardColor;
            Color color = theme.suitColors[(int)card.suit];
            rankText.text = card.rank.ToString(); rankText.color = color;
            if(suitText!=null) suitText.gameObject.SetActive(false);
            var sprite = theme.suitIcons.Length > (int)card.suit ? theme.suitIcons[(int)card.suit] : null;
            suitIcon.sprite = sprite; suitIcon.gameObject.SetActive(sprite != null);
            rankText.font = theme.font;rankText.fontSharedMaterial=theme.font.material;
            if(enchantmentIcons!=null) for(int i=0;i<enchantmentIcons.Length;i++)
            {
                bool visible=card.enchantments!=null && i<card.enchantments.Count && i<Card.MaxEnchantments;
                var image=enchantmentIcons[i];image.sprite=visible?theme.EnchantmentIcon(card.enchantments[i]):null;
                image.gameObject.SetActive(visible && image.sprite!=null);
            }
        }
    }
}
