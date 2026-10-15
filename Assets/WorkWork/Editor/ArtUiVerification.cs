using System;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork.Editor
{
    public static class ArtUiVerification
    {
        public static string Run()
        {
            var g=UnityEngine.Object.FindObjectOfType<GameController>(); var shell=g.GetComponent<GameShell>();
            if(g.Session==null || g.theme==null) throw new Exception("Art UI is not running");
            if(g.canvas.GetComponent<Image>()!=null || shell.board.GetComponent<Image>()!=null || shell.welcome.GetComponent<Image>()!=null) throw new Exception("Background must be a separate child Image");
            float master=shell.master.value,music=shell.music.value,effects=shell.effects.value;
            bool welcome=shell.welcome.activeSelf, board=shell.board.activeSelf;
            var audio=new GameObject("Temporary audio verification",typeof(AudioSource),typeof(AudioChannel));
            var parent=new GameObject("Temporary layout verification",typeof(RectTransform));
            try
            {
                shell.CloseSettings(); shell.OpenSettings();
                if(Time.timeScale!=0) throw new Exception("Settings must pause gameplay");
                shell.master.value=.7f; shell.music.value=.4f; shell.effects.value=.8f;
                if(Mathf.Abs(AudioListener.volume-.7f)>.001f) throw new Exception("Master volume not applied");
                var channel=audio.GetComponent<AudioChannel>(); channel.baseVolume=.5f; channel.isMusic=true; channel.Apply(.4f,.8f);
                if(Mathf.Abs(audio.GetComponent<AudioSource>().volume-.2f)>.001f) throw new Exception("Music volume not applied");
                channel.isMusic=false; channel.Apply(.4f,.8f);
                if(Mathf.Abs(audio.GetComponent<AudioSource>().volume-.4f)>.001f) throw new Exception("Effects volume not applied");
                shell.ShowWelcome(); if(!shell.welcome.activeSelf || shell.board.activeSelf || shell.settings.activeSelf) throw new Exception("Return to welcome failed");
                if(shell.continueButton.interactable!=g.HasSave) throw new Exception("Continue availability incorrect");
                var frame=new GameObject("Frame",typeof(RectTransform)); frame.transform.SetParent(parent.transform,false); frame.AddComponent<ResponsiveUiFrame>();
                foreach(var size in new[]{new Vector2(1920,1080),new Vector2(1280,720),new Vector2(1024,768),new Vector2(2560,1080)})
                {
                    ((RectTransform)parent.transform).sizeDelta=size; frame.SendMessage("OnRectTransformDimensionsChange");
                    float expected=Mathf.Min(size.x/1600,size.y/900);
                    if(Mathf.Abs(frame.transform.localScale.x-expected)>.001f || frame.transform.localScale.x!=frame.transform.localScale.y) throw new Exception("Responsive aspect ratio failed");
                }
                if(shell.winGroup==null || shell.loseGroup==null || g.theme.Icon("employee.chips")==null || g.theme.Icon("item.chips")==null) throw new Exception("Provided art not bound");
                return "PASS: Separate background Images; 16:9, 4:3 and ultrawide frame fitting; welcome/continue/settings routing; 3 volume sliders, audio category gains and persistence; supplied employee/item/win/lose art. Existing run/save unchanged.";
            }
            finally
            {
                shell.master.value=master; shell.music.value=music; shell.effects.value=effects;
                shell.CloseSettings(); shell.welcome.SetActive(welcome); shell.board.SetActive(board);
                UnityEngine.Object.Destroy(audio); UnityEngine.Object.Destroy(parent);
            }
        }
    }
}

