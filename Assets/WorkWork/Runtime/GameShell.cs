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
        [Min(.01f)] public float resultRollDuration=.45f;
        [Min(0)] public float resultRevealDelay=.15f;
        [Min(.01f)] public float resultRollInterval=.035f;
        [Min(.1f)] public float shopHintPulsePeriod=1.6f;
        [Range(0,1)] public float shopHintMinAlpha=.35f;
        CanvasGroup shopHintGroup;
        float shopHintElapsed;
        public bool IsResultRevealing {get;private set;}
        Coroutine resultRoutine;
        int revealedMonth=-1;
        readonly System.Random resultRandom=new System.Random();
        public Button restart;
        public GameObject patternHelp;
        public TMP_Text[] patternNames, patternChips, patternMultipliers;
        public AudioSource menuMusic, gameMusic, bangMusic;
        public bool IsInGame => board!=null && board.activeSelf && (welcome==null || !welcome.activeSelf);
        public bool HasBang => game!=null && game.Session!=null && ContentRules.HasRule(game.Session.State,game.catalog.rules,"item.Bang");
        public void RefreshMusic() {PlayMusic(IsInGame);}
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
            if(IsResultRevealing || game.IsEntering)return;
            game.CancelScoring();
            CloseTasks();
            ClosePatternHelp();game.detailsTooltip?.Hide();CloseSettings(); board.SetActive(false); welcome.SetActive(true);
            continueButton.interactable=game.HasSave;
            PlayMusic(false);
        }
        void PlayMusic(bool inGame)
        {
            var active=inGame?(HasBang && bangMusic!=null && bangMusic.clip!=null?bangMusic:gameMusic):menuMusic;
            foreach(var source in new[]{menuMusic,gameMusic,bangMusic})
                if(source!=null && source!=active && source.isPlaying)source.Stop();
            if(active!=null && active.clip!=null && !active.isPlaying) active.Play();
        }
        public void OpenSettings()
        {
            if(IsResultRevealing || game.IsEntering)return;
            CloseTasks();
            game.detailsTooltip?.Hide();
            ClosePatternHelp();previousTimeScale=Time.timeScale; Time.timeScale=0;
            settings.SetActive(true); settings.transform.SetAsLastSibling();
        }
        public void CloseSettings() { settings.SetActive(false); Time.timeScale=previousTimeScale; }
        void OnDisable() { if(settings!=null && settings.activeSelf) Time.timeScale=previousTimeScale; CancelResultReveal();revealedMonth=-1;ResetShopHint(); }
        void ResetShopHint()
        {
            shopHintElapsed=0;
            if(shopHintGroup!=null)shopHintGroup.alpha=1;
        }
        void PulseShopHint()
        {
            if(game==null || game.resultButton==null || !game.resultButton.gameObject.activeInHierarchy || !game.resultButton.interactable || IsResultRevealing)
            {ResetShopHint();return;}
            if(shopHintGroup==null)
            {
                var label=game.resultButton.GetComponentInChildren<TMP_Text>(true);
                if(label==null)return;
                shopHintGroup=label.GetComponent<CanvasGroup>();
                if(shopHintGroup==null)shopHintGroup=label.gameObject.AddComponent<CanvasGroup>();
            }
            shopHintElapsed+=Time.deltaTime;
            float wave=(1+Mathf.Cos(shopHintElapsed*Mathf.PI*2/Mathf.Max(.1f,shopHintPulsePeriod)))*.5f;
            shopHintGroup.alpha=Mathf.Lerp(shopHintMinAlpha,1,wave);
        }
        void Update()
        {
            PulseShopHint();
            if(initialized && taskChoicePanel!=null)
            {
                bool show=!game.IsBusy && game.Session.State.phase==Phase.TaskChoice && !welcome.activeSelf && !settings.activeSelf;
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
                if(game.IsEntering)
                {
                    foreach(var label in winNumbers)label.text="";
                    game.resultButton.gameObject.SetActive(false);game.resultButton.interactable=false;return;
                }
                int bonus=GameSession.ExcessReward(state.monthScore,state.target);
                long[] values={state.lastIncome-bonus-state.lastInterest-state.lastStaffIncome,bonus,state.lastInterest,state.lastStaffIncome,state.lastIncome};
                if(Application.isPlaying && revealedMonth!=state.month)
                {
                    CancelResultReveal();revealedMonth=state.month;
                    resultRoutine=StartCoroutine(RevealResult(values));
                }
                else if(!IsResultRevealing)for(int i=0;i<5;i++)winNumbers[i].text=values[i].ToString("N0");
                game.resultButton.gameObject.SetActive(!IsResultRevealing);
                game.resultButton.interactable=!IsResultRevealing;
            }
            else { CancelResultReveal();revealedMonth=-1;loseNumbers[0].text=state.target.ToString("N0"); loseNumbers[1].text=state.monthScore.ToString("N0"); }
        }
        void CancelResultReveal()
        {
            if(resultRoutine!=null)StopCoroutine(resultRoutine);
            resultRoutine=null;IsResultRevealing=false;
        }
        System.Collections.IEnumerator RevealResult(long[] values)
        {
            IsResultRevealing=true;
            game.resultButton.interactable=false;game.resultButton.gameObject.SetActive(false);
            foreach(var label in winNumbers)label.text="";
            var entrance=winGroup!=null?winGroup.GetComponent<FailureReveal>():null;
            while(entrance!=null && entrance.IsPlaying)yield return null;
            for(int i=0;i<values.Length;i++)
            {
                if(resultRevealDelay>0)yield return new WaitForSeconds(resultRevealDelay);
                string targetValue=values[i].ToString("N0");float nextTick=0;
                float duration=Mathf.Max(.01f,resultRollDuration);
                for(float elapsed=0;elapsed<duration;elapsed+=Time.deltaTime)
                {
                    if(elapsed>=nextTick)
                    {
                        var digits=targetValue.ToCharArray();
                        for(int j=0;j<digits.Length;j++)if(char.IsDigit(digits[j]))digits[j]=(char)('0'+resultRandom.Next(10));
                        winNumbers[i].text=new string(digits);
                        nextTick=elapsed+Mathf.Max(.01f,resultRollInterval)*(1+elapsed/duration*2);
                    }
                    yield return null;
                }
                winNumbers[i].text=targetValue;
            }
            IsResultRevealing=false;resultRoutine=null;
            game.resultButton.gameObject.SetActive(true);game.resultButton.interactable=true;
        }
        public void ShowScoreStep(ScoreStep step)
        {chips.text=step.chips.ToString("N0");multiplier.text=step.multiplier.ToString("0.##");}
    }
}



