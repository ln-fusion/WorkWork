using System.Linq;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork
{
    public static class SaveCodec
    {
        public static string Serialize(GameState s)
        {
            // Unity's serializer can materialize null class-array elements. Serialize an
            // isolated snapshot with explicit empty sentinels, never the live board.
            var snapshot = new GameState {
                month=s.month,week=s.week,cash=s.cash,redraws=s.redraws,nextCardId=s.nextCardId,refreshes=s.refreshes,
                randomState=s.randomState,target=s.target,monthScore=s.monthScore,phase=s.phase,
                deck=s.deck.Select(c=>c.Copy()).ToList(),discard=s.discard.Select(c=>c.Copy()).ToList(),hand=s.hand.Select(c=>c.Copy()).ToList(),
                slots=s.slots.Select(c=>c?.Copy() ?? new Card()).ToArray(),
                employees=(string[])s.employees.Clone(),items=(string[])s.items.Clone(),
                acquired=s.acquired.ToList(),offers=s.offers.ToList(),lastScore=s.lastScore,monthSummary=s.monthSummary,
                lastIncome=s.lastIncome,lastInterest=s.lastInterest,lastStaffIncome=s.lastStaffIncome
            };
            return JsonUtility.ToJson(snapshot);
        }
        public static GameState Deserialize(string json) => JsonUtility.FromJson<GameState>(json);
    }
}
