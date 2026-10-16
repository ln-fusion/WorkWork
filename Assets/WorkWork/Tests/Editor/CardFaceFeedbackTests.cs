using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEngine;
using UnityEditor;
using WorkWork.Core;

namespace WorkWork.Tests
{
    public class CardFaceFeedbackTests
    {
        [Serializable] class Source {public List<Content> content;}
        static Settings Config()=>new Settings{content=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json")).content};
        static GameState Board(string employee,Suit suit=Suit.Hearts,int rank=4)
        {var s=new GameState{randomState=19};s.employees[0]=employee;s.slots[0]=new Card{id=1,rank=rank,suit=suit};return s;}
        [Test] public void RecolorEventTargetsTheOriginalCardAndDoesNotChangeRealStateOnPreview()
        {
            var s=Board("employee.02");var r=Scoring.Evaluate(s,Config());var change=r.steps.Single(x=>x.faceChanges.Count>0).faceChanges.Single();
            Assert.AreEqual(1,change.cardId);Assert.AreEqual(Suit.Hearts,change.beforeSuit);Assert.AreEqual(Suit.Clubs,change.afterSuit);
            Assert.AreEqual(4,change.beforeRank);Assert.AreEqual(4,change.afterRank);Assert.AreEqual(Suit.Hearts,s.slots[0].suit);
        }
        [Test] public void SameSuitAssignmentDoesNotAnimate()
        {var r=Scoring.Evaluate(Board("employee.02",Suit.Clubs),Config());Assert.IsFalse(r.steps.Any(x=>x.faceChanges.Count>0));}
        [Test] public void CombinedEngineChangesProduceOneCardEventWithBothNewValues()
        {
            var r=Scoring.Evaluate(Board("employee.30"),Config());var changes=r.steps.SelectMany(x=>x.faceChanges).ToArray();
            Assert.AreEqual(1,changes.Length);Assert.AreEqual(4,changes[0].beforeRank);Assert.AreEqual(5,changes[0].afterRank);Assert.AreEqual(Suit.Clubs,changes[0].afterSuit);
        }
        [Test] public void ConsecutiveToolsRecordSeparateBeforeAndAfterValuesInSlotOrder()
        {
            var s=Board(null);s.slots[1]=new Card{id=2,rank=2,suit=Suit.Spades};s.items[0]="item.Potato";s.items[1]="item.Gun";
            var steps=Scoring.Evaluate(s,Config()).steps.Where(x=>x.faceChanges.Count>0).ToArray();Assert.AreEqual(2,steps.Length);
            Assert.AreEqual(0,steps[0].equipmentSlot);Assert.AreEqual(2,steps[0].faceChanges[0].beforeRank);Assert.AreEqual(3,steps[0].faceChanges[0].afterRank);
            Assert.AreEqual(1,steps[1].equipmentSlot);Assert.AreEqual(3,steps[1].faceChanges[0].beforeRank);Assert.AreEqual(2,steps[1].faceChanges[0].afterRank);
            Assert.IsTrue(steps.All(x=>x.faceChanges[0].cardId==2));
        }
        [Test] public void RankFloorDoesNotCreateFalseChangeAndSevenPointsAreSupported()
        {
            var s=Board(null);s.items[0]="item.Gun";s.slots[1]=new Card{id=2,rank=0};Assert.IsFalse(Scoring.Evaluate(s,Config()).steps.Any(x=>x.faceChanges.Count>0));
            var r=Scoring.Evaluate(Board("employee.21",Suit.Spades,6),Config());Assert.AreEqual(7,r.steps.SelectMany(x=>x.faceChanges).Single().afterRank);
        }
        [Test] public void FaceAndEnchantmentChangesShareCorrectEmployeeStep()
        {
            var s=Board("employee.33");s.employees[1]="employee.01";ContentRules.RefreshEnchantments(s,Config());
            var r=Scoring.Evaluate(s,Config());var step=r.steps.Single(x=>x.faceChanges.Count>0);
            Assert.AreEqual(ScoreSource.Employee,step.source);Assert.AreEqual(0,step.sourceSlot);Assert.AreEqual(1,step.enchantmentChanges.Count);
            CollectionAssert.AreEqual(new[]{Enchantment.Coin},step.enchantmentChanges[0].before);CollectionAssert.AreEqual(new[]{Enchantment.Fans},step.enchantmentChanges[0].after);
        }
        [Test] public void FacePresentationUsesThemeAndResetRestoresModelWithoutChangingIt()
        {
            var prefab=AssetDatabase.LoadAssetAtPath<CardView>("Assets/WorkWork/Prefabs/Card.prefab");var view=UnityEngine.Object.Instantiate(prefab);
            var theme=AssetDatabase.LoadAssetAtPath<VisualTheme>("Assets/WorkWork/Config/VisualTheme.asset");var card=new Card{id=1,rank=6,suit=Suit.Hearts};
            try
            {
                view.Bind(card,theme,false);view.PresentFace(7,Suit.Clubs);Assert.AreEqual("7",view.rankText.text);Assert.AreEqual(theme.suitColors[(int)Suit.Clubs],view.rankText.color);
                Assert.AreEqual(theme.suitIcons[(int)Suit.Clubs],view.suitIcon.sprite);Assert.AreEqual(6,card.rank);Assert.AreEqual(Suit.Hearts,card.suit);
                view.ResetPresentedFace();Assert.AreEqual("6",view.rankText.text);Assert.AreEqual(theme.suitColors[(int)Suit.Hearts],view.rankText.color);
            }
            finally{UnityEngine.Object.DestroyImmediate(view.gameObject);}
        }
    }
}
