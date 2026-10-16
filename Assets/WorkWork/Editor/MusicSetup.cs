using System;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace WorkWork.Editor
{
    public static class MusicSetup
    {
        [MenuItem("WorkWork/Configure Music")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) throw new InvalidOperationException("Stop Play mode before configuring music.");
            var shell=UnityEngine.Object.FindObjectOfType<GameShell>(true);
            if(shell==null) throw new InvalidOperationException("GameShell not found in the open scene.");
            shell.menuMusic=Source(shell,"Menu Music - Before","Assets/Sound/Music/Before_the_Rush_Menu_Loop.ogg");
            shell.gameMusic=Source(shell,"Game Music - Deadline","Assets/Sound/Music/DeadlineRush.ogg");
            ConfigureBang(shell);
            EditorUtility.SetDirty(shell);
            EditorSceneManager.MarkSceneDirty(shell.gameObject.scene);
            EditorSceneManager.SaveScene(shell.gameObject.scene);
            Debug.Log("WORKWORK_MUSIC_CONFIGURED: Before on welcome, Deadline during play/shop/results; loop enabled; adjust AudioChannel Base Volume in Inspector.");
        }
        public static void ConfigureBang(GameShell shell)
        {shell.bangMusic=Source(shell,"Bang Music - Yesterday","Assets/Sound/Music/Bang.mp3");}
        static AudioSource Source(GameShell shell,string name,string path)
        {
            var clip=AssetDatabase.LoadAssetAtPath<AudioClip>(path);
            if(clip==null) throw new InvalidOperationException("Missing music: "+path);
            var root=shell.transform.Find("Music");
            if(root==null) {root=new GameObject("Music").transform;root.SetParent(shell.transform,false);}
            var child=root.Find(name);
            if(child==null) {child=new GameObject(name,typeof(AudioSource),typeof(AudioChannel)).transform;child.SetParent(root,false);}
            var source=child.GetComponent<AudioSource>();
            var channel=child.GetComponent<AudioChannel>();
            source.clip=clip;source.loop=true;source.playOnAwake=false;source.spatialBlend=0;
            channel.isMusic=true;
            channel.Apply(PlayerPrefs.GetFloat("WorkWork.MusicVolume",1),PlayerPrefs.GetFloat("WorkWork.EffectsVolume",1));
            EditorUtility.SetDirty(source);EditorUtility.SetDirty(channel);
            return source;
        }
    }
}
