using System;
using System.Collections;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using Object=UnityEngine.Object;

namespace WorkWork.Editor
{
    public static class LoadingTransitionSetup
    {
        [MenuItem("WorkWork/Configure Loading Transition")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)return;
            var game=Object.FindObjectOfType<GameController>();
            var sprites=new Sprite[2];
            for(int i=0;i<2;i++)
            {
                string path="Assets/Image/Loading/"+(i+1)+".png";
                AssetDatabase.ImportAsset(path);var importer=(TextureImporter)AssetImporter.GetAtPath(path);
                importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.alphaSource=TextureImporterAlphaSource.FromInput;importer.alphaIsTransparency=true;importer.mipmapEnabled=false;importer.SaveAndReimport();
                sprites[i]=AssetDatabase.LoadAssetAtPath<Sprite>(path);
            }
            if(game.loadingTransition==null)
            {
                var root=new GameObject("Loading Transition",typeof(RectTransform),typeof(CanvasGroup),typeof(LoadingTransition));root.transform.SetParent(game.canvas.transform,false);
                Stretch((RectTransform)root.transform,Vector2.zero,Vector2.one);
                var shade=new GameObject("Input Blocker",typeof(RectTransform),typeof(Image));shade.transform.SetParent(root.transform,false);Stretch((RectTransform)shade.transform,Vector2.zero,Vector2.one);shade.GetComponent<Image>().color=Color.clear;
                var face=new GameObject("Flipping Mask",typeof(RectTransform),typeof(Image));face.transform.SetParent(root.transform,false);Stretch((RectTransform)face.transform,new Vector2(.08f,.08f),new Vector2(.92f,.92f));
                var image=face.GetComponent<Image>();image.preserveAspect=true;image.raycastTarget=false;
                var transition=root.GetComponent<LoadingTransition>();transition.face=image;transition.group=root.GetComponent<CanvasGroup>();game.loadingTransition=transition;
                root.SetActive(false);
            }
            var blocker=game.loadingTransition.transform.Find("Background")??game.loadingTransition.transform.Find("Input Blocker");
            if(blocker!=null){blocker.name="Input Blocker";blocker.GetComponent<Image>().color=Color.clear;EditorUtility.SetDirty(blocker.GetComponent<Image>());}
            var mask=game.loadingTransition.face;
            var fit=mask.GetComponent<AspectRatioFitter>();if(fit==null)fit=Undo.AddComponent<AspectRatioFitter>(mask.gameObject);
            fit.aspectMode=AspectRatioFitter.AspectMode.EnvelopeParent;fit.aspectRatio=sprites[0].rect.width/sprites[0].rect.height;
            mask.preserveAspect=false;EditorUtility.SetDirty(mask);EditorUtility.SetDirty(fit);
            game.loadingTransition.front=sprites[0];game.loadingTransition.back=sprites[1];game.loadingTransition.face.sprite=sprites[0];
            EditorUtility.SetDirty(game);EditorUtility.SetDirty(game.loadingTransition);
            EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
        }
        static void Stretch(RectTransform rect,Vector2 min,Vector2 max)
        {rect.anchorMin=min;rect.anchorMax=max;rect.pivot=new Vector2(.5f,.5f);rect.offsetMin=rect.offsetMax=Vector2.zero;}
        [MenuItem("WorkWork/Verify Loading Transition")]
        public static void Verify()
        {
            if(!EditorApplication.isPlaying)return;
            var game=Object.FindObjectOfType<GameController>();game.StartCoroutine(Check(game));
        }
        static IEnumerator Check(GameController game)
        {
            var clone=Object.Instantiate(game.loadingTransition,game.canvas.transform);clone.gameObject.SetActive(false);
            clone.fadeInDuration=.03f;clone.frontHold=.03f;clone.flipDuration=.12f;clone.backHold=.02f;clone.fadeOutDuration=.03f;
            bool gate=false,done=false,revealed=false,revealBeforeFlip=false,failed=false;string report="FAIL";
            try
            {
                clone.Play(()=>Wait(()=>gate),()=>done=true,_=>failed=true,()=>{revealed=true;revealBeforeFlip=clone.face.sprite==clone.front && Quaternion.Angle(clone.face.rectTransform.localRotation,Quaternion.identity)<.001f;});
                bool blocked=!clone.Play(()=>null,()=>{}) && clone.group.blocksRaycasts;
                var blocker=clone.transform.Find("Input Blocker")?.GetComponent<Image>();
                bool transparent=blocker!=null && blocker.color.a==0 && clone.face.GetComponent<AspectRatioFitter>()?.aspectMode==AspectRatioFitter.AspectMode.EnvelopeParent;
                yield return new WaitForSecondsRealtime(.35f);
                bool waits=clone.IsPlaying && clone.face.sprite==clone.front && !done && !revealed && clone.group.alpha==1;
                gate=true;yield return new WaitForSecondsRealtime(.3f);
                bool finishes=done && revealed && !failed && !clone.IsPlaying && !clone.gameObject.activeSelf && !clone.group.blocksRaycasts;
                clone.Play(Fail,()=>{},_=>failed=true);yield return new WaitForSecondsRealtime(.4f);
                bool error=failed && !clone.IsPlaying && !clone.gameObject.activeSelf;
                clone.Play(()=>Wait(()=>false),()=>done=false);yield return null;clone.Cancel();
                bool cancelled=!clone.IsPlaying && !clone.gameObject.activeSelf && clone.face.rectTransform.localRotation==Quaternion.identity;
                report=blocked&&transparent&&waits&&revealBeforeFlip&&finishes&&error&&cancelled?"PASS: transparent blocker/fullscreen aspect fit, waits on front for readiness, game reveal before flip begins, duplicate/input lock, finish after flip/fade, failure and cancellation cleanup":$"FAIL blocked={blocked} transparent={transparent} waits={waits} revealBeforeFlip={revealBeforeFlip} finishes={finishes} error={error} cancelled={cancelled}";
            }
            finally {Object.Destroy(clone.gameObject);System.IO.File.WriteAllText("Document/loading-transition-verification.txt",report);Debug.Log("WORKWORK_LOADING_TRANSITION "+report);}
        }
        static IEnumerator Wait(Func<bool> ready){while(!ready())yield return null;}
        static IEnumerator Fail(){yield return null;throw new InvalidOperationException("Expected isolated loading failure");}
    }
}
