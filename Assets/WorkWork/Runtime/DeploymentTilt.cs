using UnityEngine;

namespace WorkWork
{
    public class DeploymentTilt : MonoBehaviour
    {
        public GameController game;
        public RectTransform board;
        public Vector3 tiltAngles=new Vector3(28,-6,-3);
        [Min(.01f)] public float enterDuration=.2f,returnDuration=.18f;
        Quaternion home;
        bool captured,dragging;
        float weight;
        public bool IsTilted=>captured;
        public void Begin(DragToken token)
        {
            if(game==null || board==null || token==null || token.controller!=game || game.IsBusy)return;
            bool staff=token.kind==TokenKind.Employee;
            if(token.kind==TokenKind.Offer)
            {
                var def=game.catalog.rules.content.Find(c=>c.id==token.contentId);
                staff=def!=null && !def.item;
            }
            if(!staff)return;
            if(!captured){home=board.localRotation;captured=true;weight=0;}
            dragging=true;
        }
        public void End() {dragging=false;}
        void LateUpdate()
        {
            if(!captured)return;
            if(board==null || !board.gameObject.activeInHierarchy){ResetPose();return;}
            float duration=Mathf.Max(.01f,dragging?enterDuration:returnDuration);
            weight=Mathf.MoveTowards(weight,dragging?1:0,Time.deltaTime/duration);
            board.localRotation=home*Quaternion.Slerp(Quaternion.identity,Quaternion.Euler(tiltAngles),Mathf.SmoothStep(0,1,weight));
            if(!dragging && weight==0)ResetPose();
        }
        public void ResetPose()
        {
            if(captured && board!=null)board.localRotation=home;
            captured=false;dragging=false;weight=0;
        }
        void OnDisable()=>ResetPose();
    }
}
