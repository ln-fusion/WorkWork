using UnityEngine;
using UnityEngine.UI;
using WorkWork.Core;

namespace WorkWork
{
    // Changes portrait mesh only, so settlement jumps, drag positions and hand-tuned layout still compose.
    public class BangFeedback : MonoBehaviour
    {
        public GameController game;
        [Min(1)] public float beatsPerMinute=130;
        [Tooltip("相对音乐起点的拍子偏移，单位秒。")]
        public float beatOffset=.2f;
        [Range(0,.5f)] public float compression=.16f;
        [Range(0,.25f)] public float stretch=.04f;
        [Min(0)] public float jumpHeight=7;
        GameShell shell;
        public bool IsDancing => isActiveAndEnabled && game!=null && game.Session!=null &&
            (shell==null || shell.IsInGame) && ContentRules.HasRule(game.Session.State,game.catalog.rules,"item.Bang");
        public void Refresh(GameController controller)
        {
            game=controller;shell=game.GetComponent<GameShell>();
            foreach(var image in game.employeeIcons)Bind(image);
            for(int i=0;i<game.offerIcons.Length;i++)
            {
                var image=game.offerIcons[i];
                bool staff=i<game.Session.State.offers.Count && ContentRules.Definition(game.catalog.rules,game.Session.State.offers[i])?.item==false;
                if(staff)Bind(image);
                else if(image!=null && image.GetComponent<BangPortraitMotion>()!=null)image.GetComponent<BangPortraitMotion>().owner=null;
            }
            shell?.RefreshMusic();
        }
        public void Bind(Image image)
        {
            if(image==null)return;
            var motion=image.GetComponent<BangPortraitMotion>();
            if(motion==null)motion=image.gameObject.AddComponent<BangPortraitMotion>();
            motion.owner=this;image.SetVerticesDirty();
        }
        public void EvaluateAt(float seconds,out float scaleY,out float lift)
        {
            float phase=Mathf.Repeat((seconds-beatOffset)*Mathf.Max(1,beatsPerMinute)/60,1);
            float squash=Mathf.Pow(Mathf.Max(0,Mathf.Cos(phase*Mathf.PI*2)),4);
            float flight=phase>.08f && phase<.92f?Mathf.Pow(Mathf.Sin((phase-.08f)/.84f*Mathf.PI),2):0;
            scaleY=1-compression*squash+stretch*flight;lift=jumpHeight*flight;
        }
        public void Pose(out float scaleY,out float lift)
        {
            if(!IsDancing){scaleY=1;lift=0;return;}
            float seconds=shell!=null && shell.bangMusic!=null && shell.bangMusic.isPlaying?shell.bangMusic.time:Time.unscaledTime;
            EvaluateAt(seconds,out scaleY,out lift);
        }
    }
}
