using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    public class GameShell : MonoBehaviour
    {
        public GameController game;
        public GameObject board, welcome, settings;
        public Button continueButton;
        public Slider master, music, effects;
        public TMP_Text[] volumeLabels;
        public TMP_Text chips, multiplier, target, cash, shopCash, pattern, plays, redraws;
        public TMP_Text[] dateNumbers;
        public GameObject winGroup, loseGroup;
        public TMP_Text[] winNumbers;
        public TMP_Text[] loseNumbers;
        public Button restart;
        public GameObject patternHelp;
        public TMP_Text[] patternNames, patternChips, patternMultipliers;
        public AudioSource menuMusic, gameMusic;
        public TaskPanel taskPanel;
        public TaskChoicePanel taskChoicePanel;
        public void OpenTasks()
        {
            ClosePatternHelp();game.detailsTooltip?.Hide();
            if(taskPanel!=null) {taskPanel.gameObject.SetActive(true);taskPanel.transform.SetAsLastSibling();taskPanel.Refresh();}
        }
        public void CloseTasks() {if(taskPanel!=null) taskPanel.gameObject.SetActive(false);}
        bool initialized;
        float previousTimeScale = 1;
        public void Initialize(GameController controller)
        {
            game = controller;
            master.value = PlayerPrefs.GetFloat("WorkWork.MasterVolume",1);
            music.value = PlayerPrefs.GetFloat("WorkWork.MusicVolume",1);
            effects.value = PlayerPrefs.GetFloat("WorkWork.EffectsVolume",1);
            master.onValueChanged.AddListener(_=>ApplyVolume());
            music.onValueChanged.AddListener(_=>ApplyVolume());
            effects.onValueChanged.AddListener(_=>ApplyVolume());
            initialized=true; ApplyVolume(); ShowWelcome();
        }
        public void OpenPatternHelp()
        {
            CloseTasks();
            game.detailsTooltip?.Hide();
            for(int i=0;i<Scoring.Rewards.Count;i++)
            {
                var reward=Scoring.Rewards[Scoring.Rewards.Count-1-i];
                patternNames[i].text=reward.name;patternChips[i].text="+"+reward.chips;patternMultipliers[i].text="+"+reward.mult;
            }
            patternHelp.SetActive(true);patternHelp.transform.SetAsLastSibling();
        }
        public void ClosePatternHelp() {if(patternHelp!=null) patternHelp.SetActive(false);}
        public void BeginPlay() { CloseTasks();ClosePatternHelp();game.detailsTooltip?.Hide(); CloseSettings(); welcome.SetActive(false); board.SetActive(true); PlayMusic(true); }
        public void ShowWelcome()
        {
            CloseTasks();
            ClosePatternHelp();game.detailsTooltip?.Hide();CloseSettings(); board.SetActive(false); welcome.SetActive(true);
            continueButton.interactable=game.HasSave;
            PlayMusic(false);
        }
        void PlayMusic(bool inGame)
        {
            var active=inGame?gameMusic:menuMusic;
            var other=inGame?menuMusic:gameMusic;
            if(other!=null) other.Stop();
            if(active!=null && active.clip!=null && !active.isPlaying) active.Play();
        }
        public void OpenSettings()
        {
            CloseTasks();
            game.detailsTooltip?.Hide();
            ClosePatternHelp();previousTimeScale=Time.timeScale; Time.timeScale=0;
            settings.SetActive(true); settings.transform.SetAsLastSibling();
        }
        public void CloseSettings() { settings.SetActive(false); Time.timeScale=previousTimeScale; }
        void OnDisable() { if(settings!=null && settings.activeSelf) Time.timeScale=previousTimeScale; }
        void Update()
        {
            if(initialized && taskChoicePanel!=null)
            {
                bool show=game.Session.State.phase==Phase.TaskChoice && !welcome.activeSelf && !settings.activeSelf;
                if(taskChoicePanel.gameObject.activeSelf!=show) taskChoicePanel.gameObject.SetActive(show);
            }
            if(initialized && Input.GetKeyDown(KeyCode.Escape)) { if(taskPanel!=null && taskPanel.gameObject.activeSelf) {CloseTasks();return;} if(patternHelp!=null && patternHelp.activeSelf) {ClosePatternHelp();return;} if(game.detailsTooltip!=null && game.detailsTooltip.IsVisible) {game.detailsTooltip.Hide();return;} if(settings.activeSelf) CloseSettings(); else OpenSettings(); }
        }
        void ApplyVolume()
        {
            AudioListener.volume=master.value;
            PlayerPrefs.SetFloat("WorkWork.MasterVolume",master.value);
            PlayerPrefs.SetFloat("WorkWork.MusicVolume",music.value);
            PlayerPrefs.SetFloat("WorkWork.EffectsVolume",effects.value);
            PlayerPrefs.Save();
            float[] values={master.value,music.value,effects.value};
            for(int i=0;i<3;i++) volumeLabels[i].text=$"{values[i]*100:0}%";
            foreach(var channel in FindObjectsOfType<AudioChannel>(true)) channel.Apply(music.value,effects.value);
        }
        public void Quit()
        {
            PlayerPrefs.Save();
#if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying=false;
#else
            Application.Quit();
#endif
        }
        public void Refresh(GameState state,ScoreResult score)
        {
            if(taskPanel!=null && taskPanel.gameObject.activeSelf) taskPanel.Refresh();
            chips.text=score.chips.ToString("N0"); multiplier.text=score.multiplier.ToString("0.##");
            target.text=state.target.ToString("N0"); cash.text=state.monthScore.ToString("N0");
            if(shopCash!=null) shopCash.text=state.cash.ToString();
            pattern.text=score.pattern; plays.text=(5-state.week).ToString(); redraws.text=state.redraws.ToString();
            if(game.header!=null) game.header.text=$"第 {(state.month-1)/12+1} 年 {((state.month-1)%12)+1} 月\n第 {state.week} 周";
            dateNumbers[0].text=(((state.month-1)/12)+1).ToString(); dateNumbers[1].text=(((state.month-1)%12)+1).ToString(); dateNumbers[2].text=state.week.ToString();
            bool won=state.phase==Phase.MonthResult;
            winGroup.SetActive(won);
            loseGroup.SetActive(state.phase==Phase.Failed);
            if(won)
            {
                // Summary freezes reward components before money is credited.
                winNumbers[0].text=state.target.ToString("N0");
                winNumbers[1].text=Math.Max(0,state.monthScore-state.target).ToString("N0");
                winNumbers[2].text=state.lastInterest.ToString(); winNumbers[3].text=state.lastStaffIncome.ToString();
                winNumbers[4].text=state.lastIncome.ToString();
            }
            else { loseNumbers[0].text=state.target.ToString("N0"); loseNumbers[1].text=state.monthScore.ToString("N0"); }
        }
    }
}



