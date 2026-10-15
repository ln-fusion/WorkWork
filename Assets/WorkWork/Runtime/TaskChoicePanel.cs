using TMPro;
using UnityEngine;
namespace WorkWork
{
    public class TaskChoicePanel : MonoBehaviour
    {
        public GameController game;
        public TMP_Text[] names, rewards, deadlines;
        public void Choose(int index) => game.ChooseTask(index);
        public void Refresh()
        {
            if(game.Session==null) return;
            var offers=game.Session.State.taskOffers;
            for(int i=0;i<names.Length && i<offers.Count;i++)
            {
                var task=offers[i];names[i].text=task.name;
                rewards[i].text="奖金 "+VisualTheme.CurrencyIcon+task.reward;
                deadlines[i].text=task.deadlineMonths>0 ? "期限 "+task.deadlineMonths+"个月" : "不限期";
            }
        }
        void OnEnable() {transform.SetAsLastSibling();Refresh();}
    }
}
