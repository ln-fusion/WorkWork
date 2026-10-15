using System;
using System.Linq;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class ResultUiVerification
    {
        [MenuItem("WorkWork/Verify Win Lose Result Groups")]
        public static void Verify() {Debug.Log(Run());}
        public static string Run()
        {
            var g=UnityEngine.Object.FindObjectOfType<GameController>();var shell=g.GetComponent<GameShell>();
            if(shell.winGroup==null || shell.loseGroup==null || shell.winGroup==shell.loseGroup) throw new Exception("Missing independent result groups");
            if(g.resultPanel.GetComponent<Image>()!=null) throw new Exception("Result container still paints a white background");
            foreach(var label in shell.winNumbers) if(!label.transform.IsChildOf(shell.winGroup.transform)) throw new Exception("Win text outside group");
            foreach(var label in shell.loseNumbers) if(!label.transform.IsChildOf(shell.loseGroup.transform)) throw new Exception("Lose text outside group");
            if(!g.resultButton.transform.IsChildOf(shell.winGroup.transform) || !shell.restart.transform.IsChildOf(shell.loseGroup.transform)) throw new Exception("Result buttons outside groups");
            var winImage=shell.winGroup.GetComponentsInChildren<Image>(true).First(i=>i.name=="Background Image");
            var loseImage=shell.loseGroup.GetComponentsInChildren<Image>(true).First(i=>i.name=="Background Image");
            if(winImage.sprite==null || loseImage.sprite==null || winImage.sprite==loseImage.sprite) throw new Exception("Independent result art not configured");
            bool winActive=shell.winGroup.activeSelf,loseActive=shell.loseGroup.activeSelf;
            var labels=g.GetComponentsInChildren<TMP_Text>(true);var text=labels.Select(t=>t.text).ToArray();
            try
            {
                var state=new GameState {target=100,monthScore=250,lastIncome=7,lastInterest=1,lastStaffIncome=0,phase=Phase.MonthResult};
                var score=new ScoreResult {multiplier=1};shell.Refresh(state,score);
                if(!shell.winGroup.activeSelf || shell.loseGroup.activeSelf || shell.winNumbers[0].text!="100" || shell.winNumbers[4].text!="7") throw new Exception("Win group display");
                state.phase=Phase.Failed;state.monthScore=50;shell.Refresh(state,score);
                if(shell.winGroup.activeSelf || !shell.loseGroup.activeSelf || shell.loseNumbers[1].text!="50") throw new Exception("Lose group display");
                state.phase=Phase.Shop;shell.Refresh(state,score);
                if(shell.winGroup.activeSelf || shell.loseGroup.activeSelf) throw new Exception("Groups visible outside result phase");
                return "PASS: independent win/lose art, editable groups and buttons, no root white Image, correct phase switching and result values. Existing editor text and visibility restored.";
            }
            finally
            {
                for(int i=0;i<labels.Length;i++) labels[i].text=text[i];
                shell.winGroup.SetActive(winActive);shell.loseGroup.SetActive(loseActive);
            }
        }
    }
}

