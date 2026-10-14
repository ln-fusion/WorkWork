using System;
using System.Collections.Generic;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork
{
    [Serializable] public class ContentArt
    {
        public string id;
        public Sprite icon;
    }
    [CreateAssetMenu(menuName = "WorkWork/Game Catalog")]
    public class GameCatalog : ScriptableObject
    {
        [Tooltip("Rules and test content; change balance here, independently of visual assets.")]
        public Settings rules = new Settings();
    }
}
