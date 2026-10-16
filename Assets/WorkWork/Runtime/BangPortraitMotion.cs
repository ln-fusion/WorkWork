using UnityEngine;
using UnityEngine.UI;

namespace WorkWork
{
    [RequireComponent(typeof(Image))]
    public class BangPortraitMotion : BaseMeshEffect
    {
        public BangFeedback owner;
        bool wasDancing;
        void LateUpdate()
        {
            bool dancing=owner!=null && owner.IsDancing;
            if((dancing || wasDancing) && graphic!=null)graphic.SetVerticesDirty();
            wasDancing=dancing;
        }
        public override void ModifyMesh(VertexHelper mesh)
        {
            if(!IsActive() || owner==null || !owner.IsDancing || mesh.currentVertCount==0)return;
            float scale,lift;owner.Pose(out scale,out lift);
            var vertex=new UIVertex();float bottom=float.MaxValue;
            for(int i=0;i<mesh.currentVertCount;i++){mesh.PopulateUIVertex(ref vertex,i);bottom=Mathf.Min(bottom,vertex.position.y);}
            for(int i=0;i<mesh.currentVertCount;i++)
            {
                mesh.PopulateUIVertex(ref vertex,i);var position=vertex.position;
                position.y=bottom+(position.y-bottom)*scale+lift;vertex.position=position;mesh.SetUIVertex(vertex,i);
            }
        }
    }
}
