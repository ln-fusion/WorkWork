using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork
{
    public class TaskPanel : MonoBehaviour
    {
        public GameController game;
        public GameObject[] rows;
        public TMP_Text[] names, counts, rewards;
        public Image[] fills;
        public GameObject empty;
        public void Refresh()
        {
            if(game==null || game.Session==null) return;
            var tasks=game.Session.ActiveTasks.ToArray();
            int count=tasks?.Length??0;
            empty.SetActive(count==0);
            for(int i=0;i<rows.Length;i++)
            {
                rows[i].SetActive(i<count);
                if(i>=count) continue;
                var task=tasks[i];
                var progress=game.Session.State.tasks?.Find(t=>t.id==task.id);
                int current=Mathf.Clamp(progress?.current??0,0,task.target);
                names[i].text=task.name;counts[i].text=current+"/"+task.target;
                rewards[i].text=current>=task.target ? "已获奖金 "+VisualTheme.CurrencyIcon+Mathf.Clamp(task.reward,1,3) : "奖金 "+VisualTheme.CurrencyIcon+Mathf.Clamp(task.reward,1,3);
                if(task.deadlineMonths>0 && current<task.target)
                    rewards[i].text+=" · 剩余"+Mathf.Max(0,task.deadlineMonths-(progress?.elapsedMonths??0))+"个月";
                fills[i].fillAmount=(float)current/task.target;
                fills[i].color=current>=task.target ? new Color(.28f,.57f,.32f) : new Color(.93f,.65f,.25f);
            }
        }
        void OnEnable() => Refresh();
    }
}
