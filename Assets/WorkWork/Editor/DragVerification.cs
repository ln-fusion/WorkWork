using System;
using System.Linq;
using UnityEngine;
using UnityEngine.EventSystems;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class DragVerification
    {
        public static string Run()
        {
            var g=UnityEngine.Object.FindObjectOfType<GameController>();
            if(g==null || g.Session==null) throw new Exception("Game must be running");
            var shell=g.GetComponent<GameShell>();bool board=shell.board.activeSelf,welcome=shell.welcome.activeSelf;
            shell.BeginPlay();
            var original=g.Session;var setter=typeof(GameController).GetProperty("Session");
            string originalJson=SaveCodec.Serialize(original.State);
            var temporary=new GameSession(g.catalog.rules,27);
            temporary.NextMonth();
            setter.SetValue(g,temporary);
            var e=new PointerEventData(EventSystem.current){position=new Vector2(Screen.width/2,Screen.height/2),eligibleForClick=true};
            DragToken active=null;
            try
            {
                var s=temporary.State;s.hand[0].AddEnchantment(Enchantment.Coin);s.hand[0].AddEnchantment(Enchantment.Copy);
                temporary.Place(s.hand[0].id,0);temporary.Place(s.hand[0].id,1);g.Render();Canvas.ForceUpdateCanvases();
                var source=g.slotRoots[0].GetComponentsInChildren<CardView>().Last();
                var target=g.slotRoots[1].GetComponentsInChildren<CardView>().Last();
                var hand=g.handRoots[0].GetComponentsInChildren<CardView>().Last();
                if(((RectTransform)source.transform).rect.size!=((RectTransform)hand.transform).rect.size) throw new Exception("Hand/board sizes differ");
                int a=s.slots[0].id,b=s.slots[1].id;int[] handIds=s.hand.Select(c=>c.id).ToArray();
                e.position=RectTransformUtility.WorldToScreenPoint(null,source.transform.position);
                active=source.drag;active.OnBeginDrag(e);e.position=RectTransformUtility.WorldToScreenPoint(null,target.transform.position);active.OnDrag(e);
                var preview=active.Preview.GetComponent<CardView>();
                if(preview==null || preview.face.color!=source.face.color || preview.rankText.text!=source.rankText.text || preview.suitIcon.sprite!=source.suitIcon.sprite || preview.enchantmentIcons[0].sprite!=source.enchantmentIcons[0].sprite) throw new Exception("Drag card art differs");
                if(active.Preview.GetComponent<CanvasGroup>().blocksRaycasts || source.GetComponent<CanvasGroup>().alpha!=0 || e.eligibleForClick) throw new Exception("Drag raycast/visibility/click setup");
                target.GetComponent<DropZone>().OnDrop(e);active.OnEndDrag(e);active=null;
                if(s.slots[0].id!=b || s.slots[1].id!=a || !handIds.SequenceEqual(s.hand.Select(c=>c.id))) throw new Exception("Board drag did not swap");
                // An invalid/outside drop restores the card without changing game state.
                source=g.slotRoots[1].GetComponentsInChildren<CardView>().Last();string before=SaveCodec.Serialize(s);
                active=source.drag;active.OnBeginDrag(e);active.OnEndDrag(e);active=null;
                if(source.GetComponent<CanvasGroup>().alpha!=1 || SaveCodec.Serialize(s)!=before || DragToken.Current!=null) throw new Exception("Cancel drag failed");
                s.phase=Phase.MonthResult;s.cash=100;temporary.OpenShop();g.Render();
                int offer=s.offers.FindIndex(id=>!string.IsNullOrEmpty(id) && !g.catalog.rules.content.Find(c=>c.id==id).item);
                before=SaveCodec.Serialize(s);g.offerButtons[offer].onClick.Invoke();
                if(SaveCodec.Serialize(s)!=before) throw new Exception("Shop click purchased");
                string id=s.offers[offer];int cash=s.cash;active=g.offerButtons[offer].GetComponent<DragToken>();active.OnBeginDrag(e);
                if(active.Preview==null || active.Preview.GetComponent<UnityEngine.UI.Image>().sprite!=g.theme.Icon(id)) throw new Exception("Offer drag art missing");
                g.employeeButtons[0].GetComponent<DropZone>().OnDrop(e);active.OnEndDrag(e);active=null;
                if(s.employees[0]!=id || s.cash!=cash-g.catalog.rules.content.Find(c=>c.id==id).price || !string.IsNullOrEmpty(s.offers[offer])) throw new Exception("Drop purchase failed");
                for(int j=0;j<3;j++)
                {
                    int itemOffer=s.offers.FindIndex(item=>!string.IsNullOrEmpty(item) && g.catalog.rules.content.Find(c=>c.id==item).item);
                    if(itemOffer<0) throw new Exception("Verification needs three equipment offers");
                    string itemId=s.offers[itemOffer];before=SaveCodec.Serialize(s);g.offerButtons[itemOffer].onClick.Invoke();
                    if(SaveCodec.Serialize(s)!=before) throw new Exception("Item click purchased");
                    active=g.offerButtons[itemOffer].GetComponent<DragToken>();active.OnBeginDrag(e);
                    g.itemButtons[j].GetComponent<DropZone>().OnDrop(e);active.OnEndDrag(e);active=null;
                    if(s.items[j]!=itemId) throw new Exception("Equipment drop did not use exact slot");
                }
                return "PASS: shared hand/board card size; full face/suit/enchantment drag preview; non-blocking preview and hidden source; occupied slots swap without altering hand; cancel restores source; click does not buy; drag buys into target and each of three exact equipment slots. Original run/save preserved.";
            }
            finally
            {
                if(active!=null) active.OnEndDrag(e);
                setter.SetValue(g,original);g.Render();shell.board.SetActive(board);shell.welcome.SetActive(welcome);
                if(SaveCodec.Serialize(original.State)!=originalJson) throw new Exception("Verification modified original run");
            }
        }
    }
}
