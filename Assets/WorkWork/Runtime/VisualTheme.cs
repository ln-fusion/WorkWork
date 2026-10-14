using System.Collections.Generic;
using UnityEngine;

namespace WorkWork
{
    [CreateAssetMenu(menuName = "WorkWork/Visual Theme")]
    public class VisualTheme : ScriptableObject
    {
        public TMPro.TMP_FontAsset font;
        public Sprite cardFace, cardBack, officeBackground;
        public Sprite[] suitIcons = new Sprite[4];
        public Sprite[] enchantmentIcons = new Sprite[7];
        public Sprite EnchantmentIcon(WorkWork.Core.Enchantment value) => enchantmentIcons!=null && (int)value>=0 && (int)value<enchantmentIcons.Length ? enchantmentIcons[(int)value] : null;
        public List<ContentArt> contentArt = new List<ContentArt>();
        public Color[] suitColors = { new Color(.17f,.26f,.37f), new Color(.78f,.22f,.3f), new Color(.17f,.26f,.37f), new Color(.78f,.22f,.3f) };
        public Color cardColor = new Color(.96f,.94f,.89f), selectedColor = new Color(.97f,.73f,.3f);
        public Sprite Icon(string id) => contentArt?.Find(a => a!=null && a.id == id)?.icon;
    }
}
