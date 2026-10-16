using NUnit.Framework;
using WorkWork.Core;

namespace WorkWork.Tests
{
    internal static class SessionFixture
    {
        // Rule tests enter the first playing week without buying opening stock.
        // Saved states keep their original phase, including either kind of shop.
        public static GameSession Playing(Settings config,uint seed,GameState saved=null)
        {
            var game=new GameSession(config,seed,saved);
            if(saved==null)Assert.IsTrue(game.NextMonth());
            return game;
        }
    }
}
