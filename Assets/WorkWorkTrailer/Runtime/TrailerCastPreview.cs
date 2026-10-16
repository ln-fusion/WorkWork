using System.Collections;
using System.Linq;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Trailer
{
    // Only seeds the existing game UI. No replacement canvas, camera, or automatic movie.
    [DefaultExecutionOrder(1000)]
    public sealed class TrailerCastPreview : MonoBehaviour
    {
        public GameController game;
        [Range(0,2)] public int castPage;
        public bool startOnRun=true;
        public int startingCash=100;
        public long demoTarget=20000;
        public string[] employeeIds;
        public string[] itemIds;
        IEnumerator Start()
        {
            if(gameObject.scene.name!="WorkWorkMvp 1") {enabled=false;yield break;}
            if(startOnRun){yield return null;ApplyCast();}
        }
        void Update()
        {
            if(Input.GetKeyDown(KeyCode.F1)){castPage=0;ApplyCast();}
            if(Input.GetKeyDown(KeyCode.F2)){castPage=1;ApplyCast();}
            if(Input.GetKeyDown(KeyCode.F3)){castPage=2;ApplyCast();}
        }
        [ContextMenu("Apply Selected Cast (Play Mode)")]
        public void ApplyCast()
        {
            if(!Application.isPlaying || game==null || game.Session==null)return;
            game.CancelScoring();
            var s=game.Session.State;
            s.month=1;s.week=1;s.phase=Phase.Playing;s.monthScore=0;s.target=demoTarget;s.cash=startingCash;s.redraws=4;
            s.lastScore=null;s.monthSummary="";s.lastIncome=s.lastInterest=s.lastStaffIncome=0;
            s.tasks.Clear();s.acceptedTasks.Clear();s.taskOffers.Clear();s.offers.Clear();s.acquired.Clear();
            s.deck.Clear();s.hand.Clear();s.discard.Clear();
            System.Array.Clear(s.slots,0,6);System.Array.Clear(s.employees,0,6);System.Array.Clear(s.items,0,18);
            for(int i=0;i<6;i++)
            {
                s.employees[i]=employeeIds[(castPage*6+i)%employeeIds.Length];
                s.acquired.Add(s.employees[i]);
                for(int j=0;j<3;j++)
                {
                    var id=itemIds[(castPage*18+i*3+j)%itemIds.Length];
                    s.items[i*3+j]=id;if(!s.acquired.Contains(id))s.acquired.Add(id);
                }
            }
            // A complete, legal two-copy deck. Six clubs in hand make effects easy to inspect.
            for(int copy=0;copy<2;copy++)for(int suit=0;suit<4;suit++)for(int rank=1;rank<=6;rank++)
            {
                var c=new Card{id=++s.nextCardId,rank=rank,suit=(Suit)suit};
                if(copy==0 && suit==2)s.hand.Add(c);else s.deck.Add(c);
            }
            // Reuse actual owned-enchantment application, with the same live state object.
            new GameSession(game.catalog.rules,12345,s);
            game.GetComponent<GameShell>().BeginPlay();
            game.Render();
        }
    }
}
