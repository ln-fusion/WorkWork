using System.Linq;
using NUnit.Framework;
using UnityEngine;
using WorkWork.Core;
namespace WorkWork.Tests
{
    public class SoundFeedbackTests
    {
        [TestCase(1,0)] [TestCase(6,5)] [TestCase(7,5)] [TestCase(40,5)]
        public void ScoreClipSaturatesAtSix(int ordinal,int index)
        {Assert.AreEqual(index,WorkWork.SoundFeedback.ScoreIndex(ordinal));}
        [Test] public void UtilityStepsDoNotAdvanceCardSequenceAndNewSettlementResetsIt()
        {
            var s=new GameState();var card=new Card{id=1,rank=6,suit=Suit.Spades};card.AddEnchantment(Enchantment.Copy);card.AddEnchantment(Enchantment.Retry);s.slots[0]=card;
            var result=Scoring.Evaluate(s,new Settings());Assert.AreEqual(1,result.steps.Count(x=>x.cardSettlement));
            var root=new GameObject("Sound test");
            try
            {
                var sound=root.AddComponent<WorkWork.SoundFeedback>();sound.BeginSettlement();
                foreach(var step in result.steps)sound.Score(step);Assert.AreEqual(1,sound.ScoredCount);
                sound.BeginSettlement();Assert.AreEqual(0,sound.ScoredCount);
            }
            finally{Object.DestroyImmediate(root);}
        }
        [Test] public void RescoringCardByNightLightAdvancesSequenceAgain()
        {
            var config=new Settings();config.content.Add(new Content{id="light",item=true,rule="item.C4",name="小夜灯"});
            var s=new GameState();s.slots[0]=new Card{id=1,rank=2};s.items[0]="light";
            Assert.AreEqual(2,Scoring.Evaluate(s,config).steps.Count(x=>x.cardSettlement));
        }
    }
}
