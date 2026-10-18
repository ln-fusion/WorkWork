using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;
namespace WorkWork
{
    [RequireComponent(typeof(AudioSource),typeof(AudioChannel))]
    public class SoundFeedback : MonoBehaviour
    {
        public AudioClip[] cardScores=new AudioClip[6];
        public AudioClip deal,select,place,trade,win,lose,functionButton;
        AudioSource source;
        Phase? previousPhase;
        int scored;
        public int ScoredCount=>scored;
        void Awake(){source=GetComponent<AudioSource>();source.playOnAwake=false;source.loop=false;source.spatialBlend=0;GetComponent<AudioChannel>().isMusic=false;}
        public void Play(AudioClip clip){if(clip==null)return;if(source==null)source=GetComponent<AudioSource>();source.PlayOneShot(clip);}
        public void BeginSettlement(){scored=0;}
        public static int ScoreIndex(int ordinal)=>Mathf.Clamp(ordinal-1,0,5);
        public void Score(ScoreStep step)
        {if(!step.cardSettlement)return;int index=ScoreIndex(++scored);if(cardScores!=null && index<cardScores.Length)Play(cardScores[index]);}
        public void Observe(Phase phase)
        {if(previousPhase!=phase){if(phase==Phase.MonthResult)Play(win);else if(phase==Phase.Failed)Play(lose);previousPhase=phase;}}
        void Start()
        {
            foreach(var button in GetComponent<GameController>().canvas.GetComponentsInChildren<Button>(true))
                if(button.GetComponent<DragToken>()==null)button.onClick.AddListener(()=>Play(functionButton));
        }
    }
}
