using System;
using System.IO;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    public class GameController : MonoBehaviour
    {
        public GameCatalog catalog;
        public VisualTheme theme;
        public Canvas canvas;
        public CardView cardPrefab;
        public DetailsTooltip tooltipPrefab,detailsTooltip;
        public float cardHeight=150;
        public Vector2 CardSize
        {
            get
            {
                var prefabRect=(RectTransform)cardPrefab.transform;
                float aspect=prefabRect.rect.width/prefabRect.rect.height;
                float height=cardHeight;
                foreach(var root in handRoots.Concat(slotRoots)) height=Mathf.Min(height,root.rect.height,root.rect.width/aspect);
                return new Vector2(height*aspect,height);
            }
        }
        public TMP_Text header, totals, preview, status, history, resultText, shopTitle;
        public RectTransform[] handRoots, slotRoots;
        public Button[] slotButtons, employeeButtons, itemButtons, offerButtons;
        public TMP_Text[] itemTexts, offerTexts, offerPrices;
        public Image[] employeeIcons, itemIcons, offerIcons;
        public GameObject shopPanel, resultPanel;
        public Button redrawButton, scoreButton, refreshButton, nextMonthButton, resultButton;
        public Image officeBackground;
        public GameSession Session { get; private set; }
        int selectedSlot, selectedEmployee = -1;
        string message = "点击手牌自动放入空工位，也可直接拖入；点击工位上的牌可收回。";
        string SavePath => Path.Combine(Application.persistentDataPath, "workwork-mvp.json");
        public bool HasSave => File.Exists(SavePath);
        void Start()
        {
            Application.runInBackground=true;
            if (catalog == null || theme == null) { Debug.LogError("Missing MVP catalog/theme"); enabled = false; return; }
            if(tooltipPrefab!=null) {detailsTooltip=Instantiate(tooltipPrefab,canvas.transform);detailsTooltip.Initialize(this);}
            if(officeBackground!=null)
            {
                officeBackground.sprite=theme.officeBackground;
                if(theme.officeBackground!=null) officeBackground.color=Color.white;
            }
            foreach (var text in GetComponentsInChildren<TMP_Text>(true)) {text.font = theme.font;text.spriteAsset=theme.currencySprites;}
            for (int i = 0; i < 6; i++)
            {
                int slot = i;
                slotButtons[i].onClick.AddListener(() => ClickSlot(slot));
                employeeButtons[i].onClick.AddListener(() => ClickEmployee(slot));

                // Purchase is exclusively handled by a valid drop target.
                offerButtons[i].onClick=new Button.ButtonClickedEvent();
            }
            for(int i=0;i<itemButtons.Length;i++) { int owner=i/3; itemButtons[i].onClick.AddListener(()=>{selectedSlot=owner; Render();}); }
            redrawButton.onClick.AddListener(() => Act(Session.Redraw(), "已重抽未放置的手牌。"));
            scoreButton.onClick.AddListener(() => { if (Session.ScoreWeek()) { SaveCheckpoint(); message = "本周已结算，记录见左侧。"; Render(); } });
            refreshButton.onClick.AddListener(() => Act(Session.RefreshShop(), "商店已刷新。"));
            nextMonthButton.onClick.AddListener(() => { if (Session.NextMonth()) { SaveCheckpoint(); message = "新月份开始。"; Render(); } });
            resultButton.onClick.AddListener(() => { if (Session.OpenShop()) { SaveCheckpoint(); Render(); } });
            Session = new GameSession(catalog.rules, (uint)Environment.TickCount);
            var shell=GetComponent<GameShell>();
            if(shell!=null) { Render(); shell.Initialize(this); }
            else if (File.Exists(SavePath)) ContinueGame();
            else { SaveCheckpoint(); Render(); }
        }
        public void NewGame()
        {
            Session = new GameSession(catalog.rules, (uint)Environment.TickCount);
            selectedEmployee = -1; selectedSlot = 0;
            SaveCheckpoint(); Render();
            GetComponent<GameShell>()?.BeginPlay();
        }
        public void ContinueGame()
        {
            try
            {
                if (!File.Exists(SavePath)) { message = "暂无存档。"; Render(); return; }
                var state = SaveCodec.Deserialize(File.ReadAllText(SavePath));
                if (state == null || state.slots == null || state.slots.Length != 6) throw new InvalidDataException("存档格式不正确");
                Session = new GameSession(catalog.rules, state.randomState, state);
                message = "已回到本周或商店开始时。"; Render();
                GetComponent<GameShell>()?.BeginPlay();
            }
            catch (Exception ex) { Debug.LogException(ex); message = "读取存档失败。"; Render(); }
        }
        void SaveCheckpoint()
        {
            string checkpoint = SaveCodec.Serialize(Session.State);
            // In-game Continue always restores the beginning of a week/shop, not partial drags.
            try { File.WriteAllText(SavePath, checkpoint); } catch (IOException ex) { Debug.LogWarning(ex.Message); }
        }
        void Act(bool success, string text)
        { message = success ? text : "当前操作无法完成，请检查阶段、现金或空位。"; Render(); }
        public void ChooseTask(int index)
        {
            if(!Session.ChooseTask(index)) return;
            SaveCheckpoint();Render();
        }
        void ClickHandCard(int cardId)
        {
            int slot=Array.FindIndex(Session.State.slots,card=>card==null);
            if(slot<0) {message="工位已满，可拖拽换牌或点击场上卡牌收回。";Render();return;}
            Act(Session.Place(cardId,slot),"已自动放入空工位。");
        }
        void ClickSlot(int slot)
        {
            selectedSlot = slot;
            Act(Session.ReturnCard(slot), "已将卡牌收回手牌。");
        }
        void ClickEmployee(int slot)
        {
            selectedSlot = slot;
            if (selectedEmployee >= 0 && selectedEmployee != slot) { Act(Session.MoveEmployee(selectedEmployee, slot), "员工位置已交换。"); selectedEmployee = -1; }
            else { selectedEmployee = slot; message = $"选中工位 {slot + 1}；可点击其他员工工位交换，或拖入商品购买。"; Render(); }
        }
        public bool TryGetInspection(DragToken token,out string title,out string effects)
        {
            title=effects="";
            if(token==null || token.controller!=this || Session==null) return false;
            if(token.kind==TokenKind.HandCard || token.kind==TokenKind.SlotCard)
            {
                effects=InspectionText.CardEffects(token.GetComponent<CardView>()?.BoundCard);
                return !string.IsNullOrEmpty(effects);
            }
            var state=Session.State;string id=null;
            if(token.kind==TokenKind.Employee && token.value>=0 && token.value<6) id=state.employees[token.value];
            if(token.kind==TokenKind.Item && token.value>=0 && token.value<18) id=state.items[token.value];
            if(token.kind==TokenKind.Offer && token.value>=0 && token.value<state.offers.Count) id=state.offers[token.value];
            if(string.IsNullOrEmpty(id)) return false;
            var content=catalog.rules.content.Find(c=>c.id==id);if(content==null) return false;
            title=content.name;effects=string.IsNullOrWhiteSpace(content.description)?"暂无效果说明。":content.description;
            return true;
        }
        public void ShowInspection(DragToken token,Vector2 position)
        {
            if(detailsTooltip==null) return;
            if(TryGetInspection(token,out var title,out var effects)) detailsTooltip.Show(token,title,effects,position);
            else detailsTooltip.Hide();
        }
        public void Drop(DragToken token, DropZone zone)
        {
            bool ok = false;
            if (zone.hand && token.kind == TokenKind.SlotCard) ok = Session.ReturnCard(token.value);
            else if (zone.shop && (token.kind == TokenKind.Employee || token.kind == TokenKind.Item)) ok = Session.Sell(token.value, token.kind == TokenKind.Item);
            else if (zone.slot >= 0)
            {
                selectedSlot = zone.slot;
                if (token.kind == TokenKind.HandCard) ok = Session.Place(token.value, zone.slot);
                else if (token.kind == TokenKind.Offer) ok = Session.Buy(token.contentId, zone.slot, zone.equipmentSlot);
                else if (token.kind == TokenKind.Employee) ok = Session.MoveEmployee(token.value, zone.slot);
                else if (token.kind == TokenKind.SlotCard) ok = Session.MoveCard(token.value,zone.slot);
                else if (token.kind == TokenKind.Item && (zone.equipmentSlot>=0 || Session.FirstEmptyEquipmentSlot(zone.slot)>=0)) ok = Session.MoveItem(token.value, zone.slot*3+(zone.equipmentSlot>=0?zone.equipmentSlot:Session.FirstEmptyEquipmentSlot(zone.slot)));
            }
            Act(ok, "操作完成。");
        }
        public void Render()
        {
            detailsTooltip?.Hide();
            var s = Session.State;
            if(header!=null) header.text = $"第 {s.month:00} 月   /   第 {s.week} 周";
            if(totals!=null) totals.text = $"月度指标   {s.target:N0}\n累计绩效   {s.monthScore:N0}\n\n可用资金   {VisualTheme.CurrencyIcon} {s.cash}\n剩余重抽   {s.redraws}";
            var p = Scoring.Evaluate(s, catalog.rules);
            if(preview!=null) preview.text = $"{p.pattern}    ·    {p.chips:N0} × {p.multiplier:0.##} = {p.total:N0}";
            if(status!=null) status.text = message;
            if(history!=null) history.text = s.lastScore == null ? "尚未结算\n\n把牌放在员工对应的工位上。\n只有最强牌型获得奖励。\n基础倍率为 1。" : string.Join("\n", s.lastScore.events);
            for (int i = 0; i < 6; i++)
            {
                foreach (Transform child in handRoots[i]) Destroy(child.gameObject);
                foreach (Transform child in slotRoots[i]) Destroy(child.gameObject);
                if (i < s.hand.Count) AddCard(s.hand[i], handRoots[i], TokenKind.HandCard, s.hand[i].id);
                if (s.slots[i] != null) AddCard(s.slots[i], slotRoots[i], TokenKind.SlotCard, i);
                // 工位名称在右键详情中显示。
                BindContent(s.employees[i], null, employeeIcons[i], "空工位", i);

                SetToken(employeeButtons[i], TokenKind.Employee, i, s.employees[i]);

                bool offer = i < s.offers.Count && !string.IsNullOrEmpty(s.offers[i]);
                offerButtons[i].gameObject.SetActive(offer);
                if (offer)
                {
                    var def = catalog.rules.content.Find(c => c.id == s.offers[i]);
                    offerTexts[i].text = def.name;
                    if(offerPrices!=null && i<offerPrices.Length) offerPrices[i].text=def.price.ToString();
                    offerIcons[i].sprite = theme.Icon(def.id); offerIcons[i].gameObject.SetActive(offerIcons[i].sprite != null);
                    SetToken(offerButtons[i], TokenKind.Offer, i, def.id);
                }
            }
            for(int i=0;i<18;i++) { BindContent(s.items[i],itemTexts[i],itemIcons[i],"",-1); SetToken(itemButtons[i],TokenKind.Item,i,s.items[i]); }
            redrawButton.interactable = s.phase == Phase.Playing && s.redraws > 0 && s.hand.Count > 0;
            scoreButton.interactable = s.phase == Phase.Playing && s.slots.Any(c => c != null);
            shopPanel.SetActive(s.phase == Phase.Shop);
            resultPanel.SetActive(s.phase == Phase.MonthResult || s.phase == Phase.Failed);
            if(resultText!=null) resultText.text = $"{(s.phase == Phase.Failed ? "月度验收未通过" : "月度验收通过")}\n\n{s.monthScore:N0} / {s.target:N0}\n\n{s.monthSummary}";
            resultButton.gameObject.SetActive(s.phase == Phase.MonthResult);
            if(shopTitle!=null) shopTitle.text = $"月末商店   ·   {VisualTheme.CurrencyIcon}{s.cash}   ·   目标工位 {selectedSlot + 1}   ·   拖入工位购入 / 拖入商店出售";
            refreshButton.GetComponentInChildren<TMP_Text>().text = (3+s.refreshes).ToString();
            refreshButton.interactable = s.refreshes < 5 && s.cash >= 3 + s.refreshes;
            GetComponent<GameShell>()?.Refresh(s,p);
        }
        void BindContent(string id, TMP_Text text, Image icon, string empty, int slot)
        {
            var def = catalog.rules.content.Find(c => c.id == id);
            if (text != null)
            {
                text.text = def == null ? empty : def.name;
                if (slot >= 0) text.text = $"{slot + 1:00}  {text.text}";
            }
            icon.sprite = theme.Icon(id); icon.gameObject.SetActive(icon.sprite != null);
        }
        void SetToken(Button button, TokenKind kind, int value, string id)
        { var token = button.GetComponent<DragToken>(); token.controller = this; token.kind = kind; token.value = value; token.contentId = id; }
        void AddCard(Card card, RectTransform parent, TokenKind kind, int value)
        {
            var view = Instantiate(cardPrefab, parent); var rect = (RectTransform)view.transform;
            rect.anchorMin=rect.anchorMax=rect.pivot=new Vector2(.5f,.5f);rect.anchoredPosition=Vector2.zero;
            rect.sizeDelta=CardSize;
            view.Bind(card, theme, false);
            view.drag.controller = this; view.drag.kind = kind; view.drag.value = value;
            if (kind == TokenKind.HandCard) view.button.onClick.AddListener(() => ClickHandCard(card.id));
            else view.button.onClick.AddListener(() => ClickSlot(value));
            var zone = view.gameObject.AddComponent<DropZone>(); zone.controller = this; zone.slot = kind == TokenKind.SlotCard ? value : -1; zone.hand = kind == TokenKind.HandCard;
        }
    }
}


