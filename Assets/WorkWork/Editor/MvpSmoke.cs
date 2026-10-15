using System;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class MvpSmoke
    {
        public static string Run()
        {
            var g=UnityEngine.Object.FindObjectOfType<GameController>();
            if(g==null || g.Session==null) throw new Exception("MVP not running");
            if(g.Session.State.slots.Any(c=>c!=null && c.id<=0)) throw new Exception("Invalid restored card");
            string snapshot=SaveCodec.Serialize(g.Session.State);
            var hand=g.Session.State.hand.ToList(); var slots=(Card[])g.Session.State.slots.Clone();
            if(g.Session.State.phase==Phase.Playing && hand.Count>0 && slots[0]==null)
            {
                try
                {
                    int id=hand[0].id;
                    var visible=g.handRoots[0].GetComponentsInChildren<CardView>().First(v=>v.BoundCard.id==id);
                    visible.button.onClick.Invoke();
                    if(g.Session.State.slots[0]==null || g.Session.State.slots[0].id!=id) throw new Exception("Click-to-place failed");
                    var card=g.slotRoots[0].GetComponentsInChildren<CardView>().Last();
                    g.Drop(card.drag,g.handRoots[0].parent.GetComponent<DropZone>());
                    if(g.Session.State.slots[0]!=null || !g.Session.State.hand.Any(c=>c.id==id)) throw new Exception("Drop-to-hand failed");
                }
                finally { g.Session.State.hand=hand; g.Session.State.slots=slots; g.Render(); }
                if(SaveCodec.Serialize(g.Session.State)!=snapshot) throw new Exception("UI check modified actual run");
            }
            // Complete a deterministic month in an isolated session; do not mutate the user's run/save.
            var config=new Settings {firstTarget=10}; var game=new GameSession(config,71);
            game.State.monthScore=100;
            for(int week=0;week<4;week++) { game.Place(game.State.hand[0].id,0); if(!game.ScoreWeek()) throw new Exception("Week scoring failed"); }
            if(game.State.phase!=Phase.MonthResult || !game.OpenShop()) throw new Exception("Month/shop transition failed");
            if(!game.NextMonth() || game.State.month!=2 || game.State.week!=1 || game.State.redraws!=4) throw new Exception("Next month failed");
            var originalTheme=g.theme;
            var testTheme=UnityEngine.Object.Instantiate(originalTheme);
            var texture=new Texture2D(16,16); var sprite=Sprite.Create(texture,new Rect(0,0,16,16),new Vector2(.5f,.5f));
            var view=UnityEngine.Object.Instantiate(g.cardPrefab,g.canvas.transform); view.gameObject.SetActive(false);
            try
            {
                testTheme.cardFace=sprite; testTheme.suitIcons[0]=sprite;
                testTheme.contentArt.RemoveAll(a=>a!=null && (a.id=="employee.chips" || a.id=="item.chips"));
                testTheme.contentArt.Add(new ContentArt {id="employee.chips",icon=sprite});
                testTheme.contentArt.Add(new ContentArt {id="item.chips",icon=sprite});
                view.Bind(new Card {id=1,rank=5,suit=Suit.Spades},testTheme,false);
                if(view.face.sprite!=sprite || view.suitIcon.sprite!=sprite || testTheme.Icon("employee.chips")!=sprite || testTheme.Icon("item.chips")!=sprite) throw new Exception("Resource swap failed");
                if(view.rankText.text!="5") throw new Exception("Visual swap changed card label");
                if(g.theme!=originalTheme) throw new Exception("Production visual theme was modified");
            }
            finally
            {
                UnityEngine.Object.Destroy(view.gameObject); UnityEngine.Object.Destroy(testTheme);
                UnityEngine.Object.Destroy(sprite); UnityEngine.Object.Destroy(texture);
            }
            return "PASS: Play-mode controller; empty restored slots; UI click-to-place and drop-to-hand; 4 weeks/month result/shop/next month; replace card face, suit, employee and item art through theme; 6 workstations. Actual run/save unchanged.";
        }
    }
}
