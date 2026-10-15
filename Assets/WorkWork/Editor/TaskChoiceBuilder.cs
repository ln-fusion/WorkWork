using TMPro;
using UnityEditor;
using UnityEditor.Events;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
namespace WorkWork.Editor
{
    public static class TaskChoiceBuilder
    {
        [MenuItem("WorkWork/Preview/Task Choice")]
        public static void Preview()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var g=Object.FindObjectOfType<GameController>();var panel=g.GetComponent<GameShell>().taskChoicePanel;
            panel.gameObject.SetActive(true);panel.transform.SetAsLastSibling();
            for(int i=0;i<4;i++)
            {
                var task=g.catalog.rules.tasks.Find(t=>t.reward==(i==0?1:i==3?3:2));
                panel.names[i].text=task.name;panel.rewards[i].text="奖金 "+VisualTheme.CurrencyIcon+task.reward;
                panel.deadlines[i].text=task.deadlineMonths>0?"期限 "+task.deadlineMonths+"个月":"不限期";
            }
            Canvas.ForceUpdateCanvases();UnityEditorInternal.InternalEditorUtility.RepaintAllViews();EditorApplication.QueuePlayerLoopUpdate();
        }
        [MenuItem("WorkWork/Configure Task Choice")]
        public static void Configure()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;
            var g=Object.FindObjectOfType<GameController>();var shell=g.GetComponent<GameShell>();
            if(shell.taskChoicePanel==null)
            {
                var root=new GameObject("Task Choice",typeof(RectTransform),typeof(ResponsiveUiFrame),typeof(TaskChoicePanel));root.transform.SetParent(g.canvas.transform,false);
                var panel=root.GetComponent<TaskChoicePanel>();panel.game=g;shell.taskChoicePanel=panel;
                TaskPanelBuilder.Image(root.transform,"Backdrop",0,0,1600,900,new Color(0,0,0,.6f));
                var phone=TaskPanelBuilder.Image(root.transform,"Phone Background",528,70,544,704,Color.white);phone.sprite=AssetDatabase.LoadAssetAtPath<Sprite>("Assets/Image/PhonePanel.png");phone.preserveAspect=true;
                TaskPanelBuilder.Text(root.transform,g,"Title","选择一项任务",610,180,380,48,32);
                panel.names=new TMP_Text[4];panel.rewards=new TMP_Text[4];panel.deadlines=new TMP_Text[4];
                for(int i=0;i<4;i++)
                {
                    var row=TaskPanelBuilder.Image(root.transform,"Option "+(i+1),610,245+i*90,380,80,new Color(1,.94f,.81f));
                    var button=row.gameObject.AddComponent<Button>();button.targetGraphic=row;ArtUiBuilder.ConfigureButtonTint(button);
                    switch(i) {case 0:UnityEventTools.AddIntPersistentListener(button.onClick,panel.Choose,0);break;case 1:UnityEventTools.AddIntPersistentListener(button.onClick,panel.Choose,1);break;case 2:UnityEventTools.AddIntPersistentListener(button.onClick,panel.Choose,2);break;case 3:UnityEventTools.AddIntPersistentListener(button.onClick,panel.Choose,3);break;}
                    panel.names[i]=TaskPanelBuilder.Text(row.transform,g,"Name","任务名称",10,4,360,34,24);panel.names[i].enableAutoSizing=true;panel.names[i].fontSizeMin=18;panel.names[i].fontSizeMax=24;
                    panel.rewards[i]=TaskPanelBuilder.Text(row.transform,g,"Reward","奖金 "+VisualTheme.CurrencyIcon+(i==0?1:i==3?3:2),10,42,170,28,20);
                    panel.deadlines[i]=TaskPanelBuilder.Text(row.transform,g,"Deadline","不限期",190,42,180,28,20);panel.deadlines[i].alignment=TextAlignmentOptions.MidlineRight;
                }
                root.SetActive(false);EditorUtility.SetDirty(panel);
            }
            EditorUtility.SetDirty(shell);EditorSceneManager.MarkSceneDirty(g.gameObject.scene);EditorSceneManager.SaveScene(g.gameObject.scene);
            Debug.Log("WORKWORK_TASK_CHOICE_READY");
        }
    }
}
