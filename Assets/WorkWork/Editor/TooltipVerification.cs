using System;
using System.Linq;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class TooltipVerification
    {
        public static string Run()
        {
            var g=UnityEngine.Object.FindObjectOfType<GameController>();
            if(g==null || g.Session==null || g.detailsTooltip==null) throw new Exception("Tooltip not running");
            var original=g.Session;var setter=typeof(GameController).GetProperty("Session");
            var shell=g.GetComponent<GameShell>();bool board=shell.board.activeSelf,welcome=shell.welcome.activeSelf;
            string snapshot=SaveCodec.Serialize(original.State);
            var temp=new GameSession(g.catalog.rules,12);temp.NextMonth();setter.SetValue(g,temp);shell.BeginPlay();
            var e=new PointerEventData(EventSystem.current){button=PointerEventData.InputButton.Right,position=new Vector2(Screen.width-1,1)};
            try
            {
                var card=temp.State.hand[0];card.AddEnchantment(Enchantment.Coin);card.AddEnchantment(Enchantment.X2);card.AddEnchantment(Enchantment.Copy);g.Render();
                var view=g.handRoots[0].GetComponentsInChildren<CardView>().Last();
                Right(g,view.drag,e);var popup=g.detailsTooltip;
                if(!popup.IsVisible || popup.nameText.gameObject.activeSelf || popup.effectText.text!=InspectionText.CardEffects(card)) throw new Exception("Card effects/order");
                var corners=new Vector3[4];popup.panel.GetWorldCorners(corners);
                foreach(var corner in corners)
                {
                    var screen=RectTransformUtility.WorldToScreenPoint(null,corner);
                    if(screen.x<-.5f || screen.y<-.5f || screen.x>Screen.width+.5f || screen.y>Screen.height+.5f) throw new Exception("Tooltip escaped screen bounds");
                }
                if(popup.GetComponent<CanvasGroup>().blocksRaycasts || popup.GetComponentsInChildren<Graphic>(true).Any(c=>c.raycastTarget)) throw new Exception("Tooltip blocks input");
                view.drag.OnBeginDrag(e);if(DragToken.Current!=null || view.drag.Preview!=null) throw new Exception("Right click started drag");
                Right(g,g.handRoots[1].GetComponentsInChildren<CardView>().Last().drag,e);if(popup.IsVisible) throw new Exception("Plain card opened tooltip");
                temp.Place(card.id,0);g.Render();Right(g,g.slotRoots[0].GetComponentsInChildren<CardView>().Last().drag,e);
                if(!popup.IsVisible || popup.effectText.text!=InspectionText.CardEffects(card)) throw new Exception("Board card inspection");
                var employee=g.catalog.rules.content.First(c=>!c.item);var item=g.catalog.rules.content.First(c=>c.item);
                temp.State.employees[0]=employee.id;temp.State.items[0]=item.id;temp.State.acquired.Add(employee.id);temp.State.acquired.Add(item.id);g.Render();
                CheckContent(g,g.employeeButtons[0],employee,e);CheckContent(g,g.itemButtons[0],item,e);
                Right(g,g.employeeButtons[5].GetComponent<DragToken>(),e);if(popup.IsVisible) throw new Exception("Empty employee tooltip");
                CheckContent(g,g.employeeButtons[0],employee,e);Right(g,g.itemButtons[2].GetComponent<DragToken>(),e);if(popup.IsVisible) throw new Exception("Empty equipment tooltip");
                temp.State.phase=Phase.MonthResult;temp.OpenShop();g.Render();
                CheckContent(g,g.employeeButtons[0],employee,e);CheckContent(g,g.itemButtons[0],item,e);
                for(int i=0;i<temp.State.offers.Count;i++)
                {
                    string id=temp.State.offers[i];if(string.IsNullOrEmpty(id)) continue;
                    CheckContent(g,g.offerButtons[i],g.catalog.rules.content.Find(c=>c.id==id),e);
                }
                shell.ShowWelcome();if(popup.IsVisible) throw new Exception("Popup remains on welcome");
                return "PASS: right-click enchanted hand/board cards in order; plain cards and empty slots hide; separate name/effect texts for employee/tool in play and shop, and all shop offers; screen-edge clamp; no raycast blocking, purchases or right-button drag. Original run/save preserved.";
            }
            finally
            {
                setter.SetValue(g,original);g.Render();shell.board.SetActive(board);shell.welcome.SetActive(welcome);g.detailsTooltip.Hide();
                if(SaveCodec.Serialize(original.State)!=snapshot) throw new Exception("Original run changed");
            }
        }
        static void Right(GameController g,DragToken token,PointerEventData e)
        {
            string before=SaveCodec.Serialize(g.Session.State);token.OnPointerClick(e);
            if(SaveCodec.Serialize(g.Session.State)!=before) throw new Exception("Inspection changed game state");
        }
        static void CheckContent(GameController g,Button button,Content content,PointerEventData e)
        {
            string before=SaveCodec.Serialize(g.Session.State);button.OnPointerClick(e);Right(g,button.GetComponent<DragToken>(),e);
            var popup=g.detailsTooltip;
            if(!popup.IsVisible || !popup.nameText.gameObject.activeSelf || popup.nameText.text!=content.name || popup.effectText.text!=content.description || popup.nameText==popup.effectText) throw new Exception("Content name/effects incorrect: "+content.id);
            if(SaveCodec.Serialize(g.Session.State)!=before) throw new Exception("Right click purchased");
        }
    }
}

