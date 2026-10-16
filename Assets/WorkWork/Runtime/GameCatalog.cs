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
        [Tooltip("正式规则、员工、道具和任务配置；数值与美术资源独立。")]
        public Settings rules = new Settings();
    }
}
