using System.Linq;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
namespace WorkWork.Editor
{
    public static class VictoryRevealSetup
    {
        [MenuItem("WorkWork/Configure Continuous Victory Flowers")]
        public static void Continuous()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var burst=Object.FindObjectOfType<GameShell>().winGroup.GetComponent<VictoryFlowers>();
            burst.horizontalSpeed=new Vector2(70,150);
            burst.emissionInterval=.22f;burst.maxFlowers=48;burst.prewarmCount=32;burst.centerSprayChance=.12f;
            EditorUtility.SetDirty(burst);EditorSceneManager.MarkSceneDirty(burst.gameObject.scene);EditorSceneManager.SaveScene(burst.gameObject.scene);
        }
        [MenuItem("WorkWork/Configure Victory Reveal")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            const string path="Assets/Image/sakura.png";
            var importer=(TextureImporter)AssetImporter.GetAtPath(path);
            importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.alphaIsTransparency=true;importer.SaveAndReimport();
            var panel=Object.FindObjectOfType<GameShell>().winGroup;
            if(panel.GetComponent<FailureReveal>()==null)Undo.AddComponent<FailureReveal>(panel);
            var burst=panel.GetComponent<VictoryFlowers>();if(burst==null)burst=Undo.AddComponent<VictoryFlowers>(panel);
            burst.flower=AssetDatabase.LoadAssetAtPath<Sprite>(path);EditorUtility.SetDirty(burst);
            EditorSceneManager.MarkSceneDirty(panel.scene);EditorSceneManager.SaveScene(panel.scene);
        }
        [MenuItem("WorkWork/Verify Victory Reveal")]
        public static void Verify()
        {
            if(!EditorApplication.isPlaying)return;
            var game=Object.FindObjectOfType<GameController>();game.StartCoroutine(Check(game));
        }
        static System.Collections.IEnumerator Check(GameController live)
        {
            var original=live.GetComponent<GameShell>().winGroup;
            var root=new GameObject("Temporary Victory Check");
            var game=root.AddComponent<GameController>();game.enabled=false;
            var shell=root.AddComponent<GameShell>();shell.game=game;shell.resultRollDuration=.08f;shell.resultRevealDelay=.02f;
            var panel=Object.Instantiate(original,live.canvas.transform);panel.SetActive(false);shell.winGroup=panel;
            shell.winNumbers=panel.GetComponentsInChildren<TMP_Text>(true).Take(5).ToArray();
            game.resultButton=panel.GetComponentInChildren<Button>(true);
            var entrance=panel.GetComponent<FailureReveal>();var burst=panel.GetComponent<VictoryFlowers>();
            string report="FAIL";
            try
            {
                panel.SetActive(true);
                var method=typeof(GameShell).GetMethod("RevealResult",System.Reflection.BindingFlags.NonPublic|System.Reflection.BindingFlags.Instance);
                shell.StartCoroutine((System.Collections.IEnumerator)method.Invoke(shell,new object[]{new long[]{4,2,1,0,7}}));
                yield return null;
                bool start=entrance.IsPlaying && burst.LiveCount>=2 && shell.IsResultRevealing && shell.winNumbers.All(t=>t.text=="");
                yield return new WaitForSeconds(.5f);
                bool waiting=entrance.IsPlaying && shell.winNumbers.All(t=>t.text=="");
                yield return new WaitForSeconds(1.3f);
                bool complete=!entrance.IsPlaying && !shell.IsResultRevealing && shell.winNumbers.Select(t=>t.text).SequenceEqual(new[]{"4","2","1","0","7"});
                bool collision=burst.CollisionCount>0;
                int created=burst.CreatedCount,reused=burst.ReusedCount;
                yield return new WaitForSeconds(3.5f);
                bool continuous=burst.LiveCount>0 && burst.CreatedCount<=burst.maxFlowers && burst.CreatedCount==created && burst.ReusedCount>reused;
                panel.SetActive(false);yield return null;
                bool cleanup=burst.LiveCount==0;
                panel.SetActive(true);yield return null;
                bool reopened=burst.LiveCount>0 && burst.CreatedCount==created;
                report=start&&waiting&&complete&&collision&&continuous&&cleanup&&reopened?"PASS: entrance then rewards, continuous bilateral flowers, collisions, bounded pool reuse, disable recycling and reuse on reopen":$"FAIL start={start} waiting={waiting} complete={complete} collision={collision} continuous={continuous} cleanup={cleanup} reopened={reopened}";
            }
            finally {Object.Destroy(panel);Object.Destroy(root);System.IO.File.WriteAllText("Document/victory-reveal-verification.txt",report);Debug.Log("WORKWORK_VICTORY_REVEAL "+report);}
        }
    }
}
