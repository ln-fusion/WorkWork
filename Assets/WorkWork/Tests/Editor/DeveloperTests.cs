using NUnit.Framework;
using WorkWork.Core;
namespace WorkWork.Tests
{
    public class DeveloperTests
    {
        static GameSession Game()
        {var c=new Settings{initialCash=0};c.content.Add(new Content{id="staff",price=9});c.content.Add(new Content{id="tool",item=true,price=9});c.content.Add(new Content{id="unique",item=true,unique=true,price=9});return new GameSession(c,19);}
        [Test] public void DeveloperCommandsIgnoreFundsKeepStockAndRespectOwnership()
        {
            var g=Game();var s=g.State;var stock=s.offers.ToArray();
            Assert.IsTrue(g.DeveloperAdd("staff",0));Assert.IsFalse(g.DeveloperAdd("staff",1));
            Assert.IsTrue(g.DeveloperAdd("tool",0));Assert.IsTrue(g.DeveloperAdd("tool",0));
            Assert.IsTrue(g.DeveloperAdd("unique",0));Assert.IsFalse(g.DeveloperAdd("unique",0));
            Assert.AreEqual(0,s.cash);CollectionAssert.AreEqual(stock,s.offers);Assert.IsFalse(g.DeveloperRemove(0,false));
            for(int i=0;i<3;i++)Assert.IsTrue(g.DeveloperRemove(i,true));
            Assert.IsTrue(g.DeveloperRemove(0,false));Assert.AreEqual(0,s.cash);
            Assert.IsTrue(g.DeveloperAdd("staff",1));Assert.IsTrue(g.DeveloperAdd("unique",1));
        }
        [Test] public void PlayingCommandsMoveEquipmentWithoutChangingPhaseOrCash()
        {
            var g=Game();g.NextMonth();g.DeveloperAdd("staff",0);g.DeveloperAdd("tool",0);
            Assert.IsTrue(g.DeveloperMove(0,1,false));Assert.AreEqual("staff",g.State.employees[1]);Assert.AreEqual("tool",g.State.items[3]);
            Assert.IsTrue(g.DeveloperMove(3,4,true));Assert.IsTrue(g.DeveloperRemove(4,true));
            Assert.AreEqual(Phase.Playing,g.State.phase);Assert.AreEqual(0,g.State.cash);
            g.State.phase=Phase.MonthResult;Assert.IsFalse(g.DeveloperAdd("tool",1));Assert.IsFalse(g.DeveloperRemove(1,false));
        }
    }
}
