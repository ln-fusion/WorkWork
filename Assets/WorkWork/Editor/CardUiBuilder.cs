using System.Linq;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork.Editor
{
    public static class CardUiBuilder
    {
        [MenuItem("WorkWork/Apply Card Art UI")]
        public static void Apply()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            ApplyAssets();
            var g=Object.FindObjectOfType<GameController>();
            if(g!=null) { g.cardPrefab=AssetDatabase.LoadAssetAtPath<CardView>("Assets/WorkWork/Prefabs/Card.prefab");EditorUtility.SetDirty(g);EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene); }
        }
        public static void ApplyAssets()
        {
            const string folder="Assets/Image/Effect/";
            var names=new[]{"Card","Spades","Heart","Club","Diamonds","coin","fans","wild","copy","retry","arrow","x2"};
            foreach(string name in names)
            {
                var importer=AssetImporter.GetAtPath(folder+name+".png") as TextureImporter;
                if(importer==null) { AssetDatabase.ImportAsset(folder+name+".png");importer=AssetImporter.GetAtPath(folder+name+".png") as TextureImporter; }
                if(importer==null) throw new System.Exception("Missing card art: "+name);
                if(importer.textureType!=TextureImporterType.Sprite || (name=="Card" && importer.spriteImportMode!=SpriteImportMode.Single) || importer.mipmapEnabled || !importer.alphaIsTransparency)
                { importer.textureType=TextureImporterType.Sprite;if(name=="Card") importer.spriteImportMode=SpriteImportMode.Single;importer.mipmapEnabled=false;importer.alphaIsTransparency=true;importer.SaveAndReimport(); }
            }
            // Keep source PNGs intact; trim only the imported sprite's transparent canvas.
            foreach(string name in names.Where(n=>n!="Card")) TrimSprite(folder+name+".png",name);
            var theme=AssetDatabase.LoadAssetAtPath<VisualTheme>("Assets/WorkWork/Config/VisualTheme.asset");
            theme.cardFace=Sprite(folder+"Card.png");theme.cardColor=Color.white;
            theme.suitIcons=new[]{Sprite(folder+"Spades.png"),Sprite(folder+"Heart.png"),Sprite(folder+"Club.png"),Sprite(folder+"Diamonds.png")};
            theme.enchantmentIcons=new[]{"coin","fans","wild","copy","retry","arrow","x2"}.Select(n=>Sprite(folder+n+".png")).ToArray();
            theme.suitColors=new[]{new Color(.16f,.19f,.18f),new Color(.81f,.36f,.38f),new Color(.16f,.19f,.18f),new Color(.81f,.36f,.38f)};
            EditorUtility.SetDirty(theme);
            const string path="Assets/WorkWork/Prefabs/Card.prefab";
            var root=PrefabUtility.LoadPrefabContents(path);
            try
            {
                var view=root.GetComponent<CardView>();((RectTransform)root.transform).sizeDelta=new Vector2(130,200);
                view.face.sprite=theme.cardFace;view.face.color=Color.white;
                var outline=root.GetComponent<Outline>();if(outline!=null) Object.DestroyImmediate(outline);
                view.suitIcon.preserveAspect=true;Layout(view.suitIcon.rectTransform,.04f,.03f,.25f,.17f);
                view.suitIcon.sprite=theme.suitIcons[0];view.suitIcon.gameObject.SetActive(true);
                Layout((RectTransform)view.rankText.transform,.06f,.28f,.70f,.53f);
                view.rankText.font=theme.font;view.rankText.fontSharedMaterial=theme.font.material;view.rankText.fontSize=72;view.rankText.enableAutoSizing=true;view.rankText.fontSizeMin=20;view.rankText.fontSizeMax=72;
                view.rankText.alignment=TextAlignmentOptions.Center;view.rankText.color=theme.suitColors[0];
                view.suitText.gameObject.SetActive(false);
                if(view.enchantmentIcons==null || view.enchantmentIcons.Length!=WorkWork.Core.Card.MaxEnchantments)
                {
                    var old=root.transform.Find("Enchantments");if(old!=null) Object.DestroyImmediate(old.gameObject);
                    var container=new GameObject("Enchantments",typeof(RectTransform));container.transform.SetParent(root.transform,false);
                    Layout((RectTransform)container.transform,0,0,1,1);view.enchantmentIcons=new Image[WorkWork.Core.Card.MaxEnchantments];
                    for(int i=0;i<view.enchantmentIcons.Length;i++)
                    {
                        var icon=new GameObject("Enchantment "+(i+1),typeof(RectTransform),typeof(Image));icon.transform.SetParent(container.transform,false);
                        view.enchantmentIcons[i]=icon.GetComponent<Image>();
                    }
                }
                for(int i=0;i<view.enchantmentIcons.Length;i++)
                {
                    var icon=view.enchantmentIcons[i];Layout(icon.rectTransform,.70f,.02f+i*.22f,.30f,.195f);icon.preserveAspect=true;icon.raycastTarget=false;icon.color=Color.white;icon.gameObject.SetActive(false);
                }
                PrefabUtility.SaveAsPrefabAsset(root,path);
            }
            finally { PrefabUtility.UnloadPrefabContents(root); }
            AssetDatabase.SaveAssets();
        }
        static Sprite Sprite(string path) => AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().FirstOrDefault();
        [MenuItem("WorkWork/Resize Enchantment Icons")]
        public static void ResizeEnchantmentIcons()
        {
            const string path="Assets/WorkWork/Prefabs/Card.prefab";
            var root=PrefabUtility.LoadPrefabContents(path);
            try
            {
                var view=root.GetComponent<CardView>();
                foreach(var extra in view.enchantmentIcons.Skip(WorkWork.Core.Card.MaxEnchantments))
                    if(extra!=null) Object.DestroyImmediate(extra.gameObject);
                view.enchantmentIcons=view.enchantmentIcons.Take(WorkWork.Core.Card.MaxEnchantments).ToArray();
                for(int i=0;i<view.enchantmentIcons.Length;i++)
                    Layout(view.enchantmentIcons[i].rectTransform,.70f,.02f+i*.22f,.30f,.195f);
                PrefabUtility.SaveAsPrefabAsset(root,path);
            }
            finally {PrefabUtility.UnloadPrefabContents(root);}
        }
        static void TrimSprite(string path,string name)
        {
            var texture=new Texture2D(2,2,TextureFormat.RGBA32,false);
            Rect rect;
            try
            {
                if(!texture.LoadImage(System.IO.File.ReadAllBytes(path))) throw new System.Exception("Cannot read "+path);
                var pixels=texture.GetPixels32();int minX=texture.width,minY=texture.height,maxX=-1,maxY=-1;
                for(int y=0;y<texture.height;y++)for(int x=0;x<texture.width;x++)if(pixels[y*texture.width+x].a>0)
                {minX=System.Math.Min(minX,x);maxX=System.Math.Max(maxX,x);minY=System.Math.Min(minY,y);maxY=System.Math.Max(maxY,y);}
                if(maxX<minX) throw new System.Exception("Empty card icon: "+path);
                rect=new Rect(minX,minY,maxX-minX+1,maxY-minY+1);
            }
            finally { Object.DestroyImmediate(texture); }
            var importer=(TextureImporter)AssetImporter.GetAtPath(path);
#pragma warning disable 618
            var sprites=importer.spritesheet;
            if(importer.spriteImportMode==SpriteImportMode.Multiple && sprites.Length==1 && sprites[0].rect==rect) return;
            importer.spriteImportMode=SpriteImportMode.Multiple;
            importer.spritesheet=new[]{new SpriteMetaData{name=name,rect=rect,alignment=(int)SpriteAlignment.Center,pivot=new Vector2(.5f,.5f)}};
#pragma warning restore 618
            importer.SaveAndReimport();
        }
        static void Layout(RectTransform rect,float x,float y,float width,float height)
        {
            rect.anchorMin=new Vector2(x,1-y-height);rect.anchorMax=new Vector2(x+width,1-y);rect.pivot=new Vector2(.5f,.5f);rect.offsetMin=rect.offsetMax=Vector2.zero;
        }
    }
}
