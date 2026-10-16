using TMPro;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;
namespace WorkWork
{
    public class DeveloperPanel : MonoBehaviour
    {
        public GameController game;
        public GameObject panel;
        public Button toggle,close;
        CanvasGroup shopGroup;
        float previousAlpha;bool previousBlocks;
        void Start(){toggle.onClick.AddListener(Toggle);close.onClick.AddListener(Hide);}
        public void Toggle()
        {
            if(panel.activeSelf){Hide();return;}
            if(game.IsBusy || game.Session==null || (game.Session.State.phase!=Phase.Playing && game.Session.State.phase!=Phase.Shop))return;
            shopGroup=game.shopPanel.GetComponent<CanvasGroup>();if(shopGroup==null)shopGroup=game.shopPanel.AddComponent<CanvasGroup>();
            previousAlpha=shopGroup.alpha;previousBlocks=shopGroup.blocksRaycasts;shopGroup.alpha=0;shopGroup.blocksRaycasts=false;
            panel.SetActive(true);panel.transform.SetAsLastSibling();game.detailsTooltip?.Hide();
        }
        public void Hide()
        {
            if(panel==null || !panel.activeSelf)return;
            panel.SetActive(false);if(shopGroup!=null){shopGroup.alpha=previousAlpha;shopGroup.blocksRaycasts=previousBlocks;}
            game.HideDropHints();
        }
        public void Refresh()
        {
            if(panel.activeSelf && game.Session.State.phase!=Phase.Playing && game.Session.State.phase!=Phase.Shop)Hide();
        }
        void Update()
        {
            var shell=game.GetComponent<GameShell>();
            if(shell!=null && !shell.IsInGame)Hide();
        }
        void OnDisable(){Hide();}
    }
}
