using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class BangSetup
    {
        [Serializable] class Source {public List<Content> content;}
        [MenuItem("WorkWork/Configure Yesterday Wine")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)throw new InvalidOperationException("请先退出运行模式。");
            var game=UnityEngine.Object.FindObjectOfType<GameController>(true);
            if(game==null)throw new InvalidOperationException("找不到游戏控制器。");
            var shell=game.GetComponent<GameShell>();
            var source=JsonUtility.FromJson<Source>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json"));
            var def=source.content.Single(c=>c.id=="item.Bang");
            var sprite=AssetDatabase.LoadAssetAtPath<Sprite>("Assets/Image/Tools/Bang.png");
            if(shell==null || sprite==null || AssetDatabase.LoadAssetAtPath<AudioClip>("Assets/Sound/Music/Bang.mp3")==null)
                throw new InvalidOperationException("昨日的酒缺少图片、音乐或GameShell。");
            int index=game.catalog.rules.content.FindIndex(c=>c.id==def.id);
            if(index<0)game.catalog.rules.content.Add(def);else game.catalog.rules.content[index]=def;
            var art=game.theme.contentArt.Find(a=>a.id==def.id);
            if(art==null)game.theme.contentArt.Add(new ContentArt{id=def.id,icon=sprite});else art.icon=sprite;
            MusicSetup.ConfigureBang(shell);
            var feedback=game.GetComponent<BangFeedback>();if(feedback==null)feedback=game.gameObject.AddComponent<BangFeedback>();
            feedback.game=game;game.bangFeedback=feedback;
            EditorUtility.SetDirty(game.catalog);EditorUtility.SetDirty(game.theme);EditorUtility.SetDirty(game);EditorUtility.SetDirty(shell);EditorUtility.SetDirty(feedback);
            AssetDatabase.SaveAssets();EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
            Debug.Log("昨日的酒已配置：唯一道具，4费，+50基础分；持有切换Bang并使员工图像跳动。其他目录配置和UI布局保留。");
        }
    }
}
