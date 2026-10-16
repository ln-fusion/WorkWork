using System;
using System.Collections.Generic;
using System.Linq;

namespace WorkWork.Core
{
    public sealed partial class GameSession
    {
        TaskProgress Progress(TaskDefinition task)
        {
            var p=State.tasks.Find(x=>x.id==task.id);
            if(p==null){p=new TaskProgress{id=task.id};State.tasks.Add(p);}return p;
        }
        void PayTask(TaskDefinition task,TaskProgress p,ScoreResult score=null)
        {
            if(p.rewarded || p.expired || p.current<task.target)return;
            int reward=Math.Max(1,Math.Min(3,task.reward));State.cash+=reward;p.rewarded=true;
            score?.events.Add($"任务完成：{task.name}，奖金 +{reward}");
        }
        void RecordTrade()
        {
            foreach(var task in ActiveTasks.Where(t=>t.kind==TaskKind.NoTradeMonths).ToArray())Progress(task).monthInvalid=true;
        }
        void CompleteShelfTasks()
        {
            foreach(var task in ActiveTasks.Where(t=>t.kind==TaskKind.BuyShelfItems).ToArray())
            {var p=Progress(task);p.current=Math.Min(task.target,p.current+1);PayTask(task,p);}
        }
        void AdvanceSettlementTasks(ScoreResult score,Card[] initialBoard)
        {
            var cards=initialBoard.Where(c=>c!=null).ToArray();
            foreach(var task in ActiveTasks.ToArray())
            {
                bool match=task.patternPriorities?.Contains(score.patternPriority)==true;
                if(task.kind==TaskKind.Pattern && !match && task.deadlineMonths<=0 && !State.tasks.Any(p=>p.id==task.id))continue;
                var p=Progress(task);if(p.expired || p.rewarded)continue;
                bool increment=false;
                switch(task.kind)
                {
                    case TaskKind.Pattern:increment=match;break;
                    case TaskKind.AllRed:increment=cards.Length>0 && cards.All(c=>c.suit==Suit.Hearts || c.suit==Suit.Diamonds);break;
                    case TaskKind.AllBlack:increment=cards.Length>0 && cards.All(c=>c.suit==Suit.Spades || c.suit==Suit.Clubs);break;
                    case TaskKind.AllHigh:increment=cards.Length>0 && cards.All(c=>c.rank>=4);break;
                    case TaskKind.MonthNoRedraw:p.monthlyWeeks++;if(State.monthRedraws>0)p.monthInvalid=true;increment=State.week==4 && p.monthlyWeeks==4 && !p.monthInvalid;break;
                    case TaskKind.MonthNotFull:p.monthlyWeeks++;if(cards.Length==6)p.monthInvalid=true;increment=State.week==4 && p.monthlyWeeks==4 && !p.monthInvalid;break;
                    case TaskKind.MonthDifferentPatterns:
                        p.monthlyWeeks++;if(score.patternPriority<=0 || p.patterns.Contains(score.patternPriority))p.monthInvalid=true;
                        p.patterns.Add(score.patternPriority);increment=State.week==4 && p.monthlyWeeks==4 && !p.monthInvalid;break;
                    case TaskKind.DoubleTargetMonth:increment=State.week==4 && (decimal)State.monthScore>=2m*State.target;break;
                    case TaskKind.TenfoldMonth:increment=State.week==4 && (decimal)State.monthScore>=10m*State.target;break;
                    case TaskKind.AllOtherPatterns:
                        if(score.patternPriority>0 && score.patternPriority<13 && !p.patterns.Contains(score.patternPriority))p.patterns.Add(score.patternPriority);
                        p.current=p.patterns.Distinct().Count();break;
                    case TaskKind.NoTradeMonths:
                        p.monthlyWeeks++;
                        if(State.week==4){p.consecutiveMonths=p.monthlyWeeks==4 && !p.monthInvalid?p.consecutiveMonths+1:0;p.current=p.consecutiveMonths;}break;
                }
                if(increment)p.current=Math.Min(task.target,p.current+1);
                PayTask(task,p,score);
                if(State.week==4)
                {
                    if(!p.rewarded && task.deadlineMonths>0 && ++p.elapsedMonths>=task.deadlineMonths)
                    {p.expired=true;score.events.Add($"任务到期：{task.name}");}
                    p.monthlyWeeks=0;p.monthInvalid=false;
                    if(task.kind==TaskKind.MonthDifferentPatterns)p.patterns.Clear();
                }
            }
        }
    }
}
