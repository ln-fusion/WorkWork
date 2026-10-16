using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using WorkWork.Core;

namespace WorkWork.Editor
{
    public static class FinalContentSetup
    {
        [Serializable] class ImageEntry {public string id,path;}
        [Serializable] class ImportSource {public long firstTarget;public List<Content> content;public List<TaskDefinition> tasks;public List<ImageEntry> images;}
        [MenuItem("WorkWork/Apply Employee Revision")]
        public static void ApplyEmployees()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)throw new InvalidOperationException("请退出运行模式后配置员工。");
            var source=JsonUtility.FromJson<ImportSource>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json"));
            var employees=source.content.Where(c=>!c.item).ToList();
            var catalog=AssetDatabase.LoadAssetAtPath<GameCatalog>("Assets/WorkWork/Config/GameCatalog.asset");
            if(catalog==null || employees.Count!=33 || employees.Select(c=>c.id).Distinct().Count()!=33)
                throw new InvalidDataException("员工目录或编号无效。");
            foreach(var employee in employees)
            {
                var image=source.images.Single(i=>i.id==employee.id);
                if(!File.Exists(image.path))throw new FileNotFoundException("缺少员工图片",image.path);
                foreach(var effect in employee.effects)
                    if((effect.enchantment==Enchantment.Copy || effect.enchantment==Enchantment.Retry) && (effect.rankFilter<0 || effect.suitFilter<0))
                        throw new InvalidDataException("复制和重抽必须同时限定花色与点数："+employee.id);
            }
            Undo.RecordObject(catalog,"更新员工第二版");
            catalog.rules.content=employees.Concat(catalog.rules.content.Where(c=>c.item)).ToList();
            EditorUtility.SetDirty(catalog);Undo.FlushUndoRecordObjects();AssetDatabase.SaveAssets();
            AssetDatabase.ImportAsset("Assets/WorkWork/Config/GameCatalog.asset",ImportAssetOptions.ForceUpdate);
            Debug.Log("员工第二版已配置：33员工；保留当前目标、牌组、道具、任务与美术配置。");
        }
        [MenuItem("WorkWork/Apply Final Content")]
        public static void Apply()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode)throw new InvalidOperationException("请退出运行模式后配置正式内容。");
            var source=JsonUtility.FromJson<ImportSource>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json"));
            var catalog=AssetDatabase.LoadAssetAtPath<GameCatalog>("Assets/WorkWork/Config/GameCatalog.asset");
            var theme=AssetDatabase.LoadAssetAtPath<VisualTheme>("Assets/WorkWork/Config/VisualTheme.asset");
            if(catalog==null || theme==null)throw new InvalidOperationException("缺少目录或视觉主题。");
            if(source.content.Count!=71 || source.tasks.Count!=15 || source.content.Select(c=>c.id).Distinct().Count()!=71)throw new InvalidDataException("正式内容数量或编号无效。");
            // Validate every reference before changing either live asset.
            foreach(var image in source.images)if(!File.Exists(image.path))throw new FileNotFoundException("缺少素材",image.path);
            foreach(var def in source.content)foreach(var effect in def.effects)
                if((effect.enchantment==Enchantment.Copy || effect.enchantment==Enchantment.Retry) && (effect.rankFilter<0 || effect.suitFilter<0))throw new InvalidDataException("复制和重抽必须同时限定花色与点数："+def.id);
            var art=new List<ContentArt>();
            foreach(var image in source.images)
            {
                var importer=AssetImporter.GetAtPath(image.path) as TextureImporter;
                if(importer!=null && importer.textureType!=TextureImporterType.Sprite){importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.alphaIsTransparency=true;importer.SaveAndReimport();}
                var sprite=AssetDatabase.LoadAssetAtPath<Sprite>(image.path)??AssetDatabase.LoadAllAssetsAtPath(image.path).OfType<Sprite>().FirstOrDefault();
                if(sprite==null)throw new InvalidDataException("无法读取图片为精灵："+image.path);
                art.Add(new ContentArt{id=image.id,icon=sprite});
            }
            Undo.RecordObjects(new UnityEngine.Object[]{catalog,theme},"配置正式员工道具与任务");
            catalog.rules.firstTarget=source.firstTarget;catalog.rules.content=source.content;catalog.rules.tasks=source.tasks;
            catalog.rules.firstYearGrowth=1.25;catalog.rules.secondYearGrowth=1.4;catalog.rules.thirdYearGrowth=1.6;catalog.rules.laterGrowth=2;catalog.rules.targetRounding=10;
            theme.contentArt=art;
            EditorUtility.SetDirty(catalog);EditorUtility.SetDirty(theme);Undo.FlushUndoRecordObjects();AssetDatabase.SaveAssets();
            AssetDatabase.ImportAsset("Assets/WorkWork/Config/GameCatalog.asset",ImportAssetOptions.ForceUpdate);
            AssetDatabase.ImportAsset("Assets/WorkWork/Config/VisualTheme.asset",ImportAssetOptions.ForceUpdate);
            Debug.Log("正式内容已配置：33员工、38道具、15任务，首月600，71项图片引用完整；场景和预制体布局未重建。");
        }
        public static void BindArt(VisualTheme theme)
        {
            var source=JsonUtility.FromJson<ImportSource>(File.ReadAllText("Assets/WorkWork/Config/ContentDefinitions.json"));
            theme.contentArt=source.images.Select(image=>new ContentArt{id=image.id,icon=AssetDatabase.LoadAssetAtPath<Sprite>(image.path)??AssetDatabase.LoadAllAssetsAtPath(image.path).OfType<Sprite>().FirstOrDefault()}).ToList();
            EditorUtility.SetDirty(theme);
        }
    }
}
