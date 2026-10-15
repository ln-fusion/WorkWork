using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.TextCore;

namespace WorkWork.Editor
{
    public static class CurrencyIconSetup
    {
        [MenuItem("WorkWork/Configure Currency Icon")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            const string imagePath="Assets/Image/ShopPoint.png", assetPath="Assets/WorkWork/Config/CurrencySprites.asset";
            var importer=(TextureImporter)AssetImporter.GetAtPath(imagePath);
            if(importer.textureType!=TextureImporterType.Sprite || importer.spriteImportMode!=SpriteImportMode.Single)
            {importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.mipmapEnabled=false;importer.SaveAndReimport();}
            var sprite=AssetDatabase.LoadAssetAtPath<Sprite>(imagePath);var texture=sprite.texture;
            var asset=AssetDatabase.LoadAssetAtPath<TMP_SpriteAsset>(assetPath);
            if(asset==null) {asset=ScriptableObject.CreateInstance<TMP_SpriteAsset>();asset.name="CurrencySprites";AssetDatabase.CreateAsset(asset,assetPath);}
            asset.spriteSheet=texture;
            var serialized=new SerializedObject(asset);serialized.FindProperty("m_Version").stringValue="1.1.0";serialized.ApplyModifiedPropertiesWithoutUndo();
            if(asset.material==null)
            {asset.material=new Material(Shader.Find("TextMeshPro/Sprite")){name="CurrencySprites Material"};AssetDatabase.AddObjectToAsset(asset.material,asset);}
            asset.material.mainTexture=texture;
            float height=24,width=height*sprite.rect.width/sprite.rect.height;
            var glyph=new TMP_SpriteGlyph(0,new GlyphMetrics(width,height,0,20,width+3),new GlyphRect((int)sprite.rect.x,(int)sprite.rect.y,(int)sprite.rect.width,(int)sprite.rect.height),1,0,sprite);
            asset.spriteGlyphTable.Clear();asset.spriteGlyphTable.Add(glyph);
            asset.spriteCharacterTable.Clear();asset.spriteCharacterTable.Add(new TMP_SpriteCharacter(0xE000,asset,glyph){name="ShopPoint",scale=1});
            asset.UpdateLookupTables();EditorUtility.SetDirty(asset);EditorUtility.SetDirty(asset.material);
            var game=Object.FindObjectOfType<GameController>();game.theme.currencySprites=asset;EditorUtility.SetDirty(game.theme);
            foreach(var text in game.GetComponentsInChildren<TMP_Text>(true))
            {text.spriteAsset=asset;text.text=text.text.Replace("¥",VisualTheme.CurrencyIcon).Replace("￥",VisualTheme.CurrencyIcon);EditorUtility.SetDirty(text);}
            AssetDatabase.SaveAssets();EditorSceneManager.MarkSceneDirty(game.gameObject.scene);EditorSceneManager.SaveScene(game.gameObject.scene);
            Debug.Log("WORKWORK_CURRENCY_ICON_READY");
        }
    }
}
