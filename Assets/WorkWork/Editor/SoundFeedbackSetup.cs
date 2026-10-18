using System;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
namespace WorkWork.Editor
{
    public static class SoundFeedbackSetup
    {
        static AudioClip Clip(string name)
        {var clip=AssetDatabase.LoadAssetAtPath<AudioClip>("Assets/Sound/SFX/"+name);if(clip==null)throw new InvalidOperationException("缺音效："+name);return clip;}
        [MenuItem("WorkWork/Configure Sound Effects")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var clips=Enumerable.Range(1,6).Select(i=>Clip(i+".mp3")).ToArray();
            var g=UnityEngine.Object.FindObjectOfType<GameController>(true);if(g==null)return;
            var sound=g.GetComponent<SoundFeedback>();if(sound==null)sound=g.gameObject.AddComponent<SoundFeedback>();
            sound.cardScores=clips;sound.trade=Clip("购入&售出.mp3");sound.deal=Clip("卡牌发放.mp3");sound.place=Clip("卡牌放置.mp3");sound.select=Clip("卡牌选中.MP3");
            sound.win=Clip("胜利.mp3");sound.lose=Clip("失败.mp3");sound.functionButton=Clip("通用功能按钮.mp3");
            var source=sound.GetComponent<AudioSource>();source.playOnAwake=false;source.loop=false;source.spatialBlend=0;
            var channel=sound.GetComponent<AudioChannel>();channel.isMusic=false;channel.Apply(PlayerPrefs.GetFloat("WorkWork.MusicVolume",1),PlayerPrefs.GetFloat("WorkWork.EffectsVolume",1));
            g.sounds=sound;EditorUtility.SetDirty(g);EditorUtility.SetDirty(sound);EditorUtility.SetDirty(source);EditorUtility.SetDirty(channel);
            EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene);
        }
    }
}
