using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace WorkWork.Editor
{
    public static class ProjectAudit
    {
        [MenuItem("WorkWork/Audit Project References")]
        public static void Run()
        {
            var issues=new List<string>();int objects=0,components=0;
            foreach(var scene in Enumerable.Range(0,UnityEngine.SceneManagement.SceneManager.sceneCount).Select(UnityEngine.SceneManagement.SceneManager.GetSceneAt))
                foreach(var root in scene.GetRootGameObjects()) Check(root,issues,ref objects,ref components);
            foreach(var path in AssetDatabase.FindAssets("t:Prefab",new[]{"Assets/WorkWork/Prefabs"}).Select(AssetDatabase.GUIDToAssetPath))
            {
                var root=PrefabUtility.LoadPrefabContents(path);
                try {Check(root,issues,ref objects,ref components);}finally {PrefabUtility.UnloadPrefabContents(root);}
            }
            var g=Object.FindObjectOfType<GameController>(true);
            if(g==null) issues.Add("GameController missing");
            else
            {
                foreach(var name in new[]{"handRoots","slotRoots","slotButtons","employeeButtons","itemButtons","offerButtons","employeeIcons","itemIcons","offerIcons"})
                {
                    var array=(System.Array)typeof(GameController).GetField(name).GetValue(g);
                    if(array==null || array.Length==0 || array.Cast<Object>().Any(value=>value==null)) issues.Add("Required array contains missing reference: "+name);
                }
                var shell=g.GetComponent<GameShell>();
                if(shell==null || shell.taskPanel==null || shell.taskChoicePanel==null || shell.menuMusic==null || shell.gameMusic==null) issues.Add("GameShell feature reference missing");
                foreach(var name in new[]{"scoreFeedback","cardMotion","shopReveal","actionFeedback","dropHints","deploymentTilt","loadingTransition"})
                    if((Object)typeof(GameController).GetField(name).GetValue(g)==null)issues.Add("Presentation reference missing: "+name);
                if(g.actionFeedback!=null && g.actionFeedback.taskPhone==null)issues.Add("Action feedback phone missing");
                if(g.dropHints!=null && g.dropHints.game!=g)issues.Add("Drop hints controller mismatch");
                if(g.deploymentTilt!=null && (g.deploymentTilt.game!=g || g.deploymentTilt.board==null))issues.Add("Deployment tilt reference missing/mismatch");
                if(g.loadingTransition!=null)
                {
                    var entry=g.loadingTransition;
                    if(entry.front==null || entry.back==null || entry.face==null || entry.group==null)issues.Add("Loading transition art/face/group missing");
                    var blocker=entry.transform.Find("Input Blocker")?.GetComponent<UnityEngine.UI.Image>();
                    if(blocker==null || blocker.color.a!=0)issues.Add("Loading blocker must be transparent");
                }
                if(shell!=null)
                {
                    foreach(var panel in new[]{shell.taskPanel?.gameObject,shell.taskChoicePanel?.gameObject})
                    {
                        var pickup=panel!=null?panel.GetComponent<PhonePickup>():null;
                        if(pickup==null || pickup.sourcePhone==null || pickup.phoneGraphic==null || pickup.backdrop==null)issues.Add("Phone pickup reference missing");
                    }
                    if(shell.winGroup==null || shell.winGroup.GetComponent<FailureReveal>()==null || shell.loseGroup==null || shell.loseGroup.GetComponent<FailureReveal>()==null)issues.Add("Result entrance missing");
                    var flowers=shell.winGroup!=null?shell.winGroup.GetComponent<VictoryFlowers>():null;
                    if(flowers==null || flowers.flower==null)issues.Add("Victory flower sprite/component missing");
                }
                var pool=g.catalog.rules.tasks;
                if(pool.Count(t=>t.reward==1)<1 || pool.Count(t=>t.reward==2)<2 || pool.Count(t=>t.reward==3)<1)issues.Add("Task pool cannot supply 1/2/2/3 rewards");
            }
            issues.Insert(0,"Objects: "+objects+"; Components: "+components+"; Issues: "+issues.Count);
            File.WriteAllLines("Document/project-audit-results.txt",issues);Debug.Log("WORKWORK_PROJECT_AUDIT "+issues[0]);
        }
        static void Check(GameObject root,List<string> issues,ref int objects,ref int components)
        {
            foreach(var transform in root.GetComponentsInChildren<Transform>(true))
            {
                objects++;
                if(GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(transform.gameObject)>0)issues.Add("Missing script: "+transform.name);
                foreach(var component in transform.GetComponents<Component>())
                {
                    if(component==null)continue;components++;
                    var iterator=new SerializedObject(component).GetIterator();
                    while(iterator.NextVisible(true))
                        if(iterator.propertyType==SerializedPropertyType.ObjectReference && iterator.objectReferenceValue==null && iterator.objectReferenceInstanceIDValue!=0)
                            issues.Add("Broken reference: "+transform.name+"/"+component.GetType().Name+"."+iterator.propertyPath);
                }
            }
        }
    }
}
