using TMPro;
using System.Collections.Generic;
using System.Linq;
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
        List<Enchantment> presentedEnchantments;
        int? presentedRank;
        Suit? presentedSuit;
        public int DisplayedRank => presentedRank??boundCard.rank;
        public Suit DisplayedSuit => presentedSuit??boundCard.suit;
        public void PresentFace(int rank,Suit suit){presentedRank=rank;presentedSuit=suit;RefreshFace();}
        public void ResetPresentedFace(){presentedRank=null;presentedSuit=null;RefreshFace();}
        public IReadOnlyList<Enchantment> DisplayedEnchantments => presentedEnchantments??boundCard?.enchantments;
        public void PresentEnchantments(IEnumerable<Enchantment> values)
        {
            presentedEnchantments=values.Distinct().Take(Card.MaxEnchantments).ToList();RefreshEnchantmentIcons();
        }
        public void ResetPresentedEnchantments(){presentedEnchantments=null;RefreshEnchantmentIcons();}
        public void HideEnchantmentIcons()
        {
            if(enchantmentIcons!=null)foreach(var icon in enchantmentIcons)if(icon!=null)icon.gameObject.SetActive(false);
        }
        string EnchantmentSignature(Card card) => card.enchantments==null?"":string.Join(",",card.enchantments);
        void LateUpdate()
        {
            if(boundCard!=null && boundTheme!=null && (shownRank!=boundCard.rank || shownSuit!=(int)boundCard.suit || shownEnchantments!=EnchantmentSignature(boundCard))) Bind(boundCard,boundTheme,boundSelected);
        }
        public void Bind(Card card, VisualTheme theme, bool selected)
        {
            if(boundCard!=card){presentedEnchantments=null;presentedRank=null;presentedSuit=null;}
            boundCard=card;boundTheme=theme;boundSelected=selected;shownRank=card.rank;shownSuit=(int)card.suit;shownEnchantments=EnchantmentSignature(card);
            face.sprite = theme.cardFace;
            face.color = selected ? theme.selectedColor : theme.cardColor;
            RefreshFace();
            if(suitText!=null) suitText.gameObject.SetActive(false);
            rankText.font = theme.font;rankText.fontSharedMaterial=theme.font.material;
            RefreshEnchantmentIcons();
        }
        void RefreshFace()
        {
            if(boundCard==null || boundTheme==null)return;
            rankText.text=DisplayedRank.ToString();rankText.color=boundTheme.suitColors[(int)DisplayedSuit];
            var sprite=boundTheme.suitIcons.Length>(int)DisplayedSuit?boundTheme.suitIcons[(int)DisplayedSuit]:null;
            suitIcon.sprite=sprite;suitIcon.gameObject.SetActive(sprite!=null);
        }
        void RefreshEnchantmentIcons()
        {
            if(boundCard==null || boundTheme==null)return;
            var values=DisplayedEnchantments;
            if(enchantmentIcons!=null) for(int i=0;i<enchantmentIcons.Length;i++)
            {
                bool visible=values!=null && i<values.Count && i<Card.MaxEnchantments;
                var image=enchantmentIcons[i];image.sprite=visible?boundTheme.EnchantmentIcon(values[i]):null;
                image.gameObject.SetActive(visible && image.sprite!=null);
            }
        }
    }
}
