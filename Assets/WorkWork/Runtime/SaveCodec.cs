using System.Linq;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork
{
    public static class SaveCodec
    {
        public static string Serialize(GameState s)
        {
            var snapshot=s.Copy();
            // JsonUtility needs explicit empty sentinels for missing class-array elements.
            snapshot.slots=snapshot.slots.Select(c=>c??new Card()).ToArray();
            return JsonUtility.ToJson(snapshot);
        }
        public static GameState Deserialize(string json) => JsonUtility.FromJson<GameState>(json);
    }
}