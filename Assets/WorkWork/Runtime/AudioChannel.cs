using UnityEngine;

namespace WorkWork
{
    [RequireComponent(typeof(AudioSource))]
    public class AudioChannel : MonoBehaviour
    {
        public bool isMusic;
        [Range(0,1)] public float baseVolume=1;
        void OnEnable() => Apply(PlayerPrefs.GetFloat("WorkWork.MusicVolume",1),PlayerPrefs.GetFloat("WorkWork.EffectsVolume",1));
        void OnValidate() => Apply(PlayerPrefs.GetFloat("WorkWork.MusicVolume",1),PlayerPrefs.GetFloat("WorkWork.EffectsVolume",1));
        public void Apply(float music,float effects) { GetComponent<AudioSource>().volume=baseVolume*(isMusic?music:effects); }
    }
}
