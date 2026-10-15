using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace WorkWork
{
    // UI-space circle collisions keep the effect independent of scene physics/cameras.
    public class VictoryFlowers : MonoBehaviour
    {
        public Sprite flower;
        public Vector2 flowerSize=new Vector2(50,75);
        [Min(.03f)] public float emissionInterval=.22f;
        [Range(2,100)] public int maxFlowers=48;
        [Range(0,100)] public int prewarmCount=32;
        [Range(0,1)] public float centerSprayChance=.12f;
        [Min(.1f)] public float lifetime=3;
        public Vector2 horizontalSpeed=new Vector2(70,150),verticalSpeed=new Vector2(700,1050);
        [Min(0)] public float gravity=750;
        [Range(0,1)] public float restitution=.55f;
        public int CollisionCount {get;private set;}
        public int LiveCount=>particles.Count;
        public int CreatedCount {get;private set;}
        public int ReusedCount {get;private set;}
        class Flower
        {
            public RectTransform rect;public Image image;
            public Vector2 position,velocity;public float radius,spin,age;
        }
        readonly List<Flower> particles=new List<Flower>();
        readonly Stack<Flower> pool=new Stack<Flower>();
        readonly System.Random random=new System.Random();
        RectTransform layer,frame;
        float elapsed;
        float Range(float min,float max)=>Mathf.Lerp(min,max,(float)random.NextDouble());
        void OnEnable()
        {
            if(!Application.isPlaying || flower==null)return;
            var canvas=GetComponentInParent<Canvas>();if(canvas==null)return;
            frame=(RectTransform)canvas.transform;
            if(layer==null)
            {
                var obj=new GameObject("Victory Flower Pool",typeof(RectTransform));
                layer=(RectTransform)obj.transform;layer.SetParent(frame,false);
                layer.anchorMin=Vector2.zero;layer.anchorMax=Vector2.one;layer.offsetMin=layer.offsetMax=Vector2.zero;
                layer.pivot=frame.pivot;
                for(int i=0;i<Mathf.Min(prewarmCount,maxFlowers);i++)pool.Push(Create());
            }
            layer.gameObject.SetActive(true);layer.SetAsLastSibling();elapsed=0;CollisionCount=0;
            EmitPair();
        }
        Flower Create()
        {
            var obj=new GameObject("Sakura",typeof(RectTransform),typeof(Image));obj.transform.SetParent(layer,false);
            var rect=(RectTransform)obj.transform;rect.anchorMin=rect.anchorMax=frame.pivot;
            var image=obj.GetComponent<Image>();image.preserveAspect=true;image.raycastTarget=false;
            obj.SetActive(false);CreatedCount++;
            return new Flower{rect=rect,image=image};
        }
        void Recycle(Flower particle)
        {
            particle.rect.gameObject.SetActive(false);pool.Push(particle);
        }
        void EmitPair()
        {
            for(int side=0;side<2;side++)
            {
                if(particles.Count>=maxFlowers || (pool.Count==0 && CreatedCount>=maxFlowers))break;
                float size=Range(flowerSize.x,flowerSize.y);
                Flower particle;
                if(pool.Count>0){particle=pool.Pop();ReusedCount++;}else particle=Create();
                var rect=particle.rect;
                rect.sizeDelta=new Vector2(size,size);
                particle.image.sprite=flower;particle.image.color=Color.white;
                particle.radius=size*.38f;particle.age=0;
                particle.position=new Vector2(side==0?frame.rect.xMin+size:frame.rect.xMax-size,frame.rect.yMin+frame.rect.height*.22f+Range(-20,20));
                float speed=Range(horizontalSpeed.x,horizontalSpeed.y);
                if(random.NextDouble()<centerSprayChance)speed=Range(300,450);
                particle.velocity=new Vector2((side==0?1:-1)*speed,Range(verticalSpeed.x,verticalSpeed.y));particle.spin=Range(-240,240);
                rect.anchoredPosition=particle.position;rect.localRotation=Quaternion.Euler(0,0,Range(0,360));rect.gameObject.SetActive(true);particles.Add(particle);
            }
        }
        void Update()
        {
            if(layer==null)return;
            float dt=Mathf.Min(Time.deltaTime,.066f);elapsed+=dt;
            if(elapsed>=Mathf.Max(.03f,emissionInterval)){elapsed=0;EmitPair();}
            int steps=Mathf.Max(1,Mathf.CeilToInt(dt*120));float step=dt/steps;
            for(int sub=0;sub<steps;sub++)Simulate(step);
            for(int i=particles.Count-1;i>=0;i--)
            {
                var p=particles[i];p.age+=dt;
                if(p.age>=lifetime || p.position.y<frame.rect.yMin-p.radius*2){Recycle(p);particles.RemoveAt(i);continue;}
                p.rect.anchoredPosition=p.position;p.rect.Rotate(0,0,p.spin*dt);
                float edge=Mathf.Abs(p.position.x-frame.rect.center.x)/(frame.rect.width*.5f);
                var color=p.image.color;color.a=Mathf.Clamp01((lifetime-p.age)/.5f)*Mathf.Lerp(.2f,1,Mathf.SmoothStep(0,1,Mathf.InverseLerp(.25f,.65f,edge)));p.image.color=color;
            }
        }
        void Simulate(float dt)
        {
            foreach(var p in particles){p.velocity.y-=gravity*dt;p.position+=p.velocity*dt;}
            for(int i=0;i<particles.Count;i++)for(int j=i+1;j<particles.Count;j++)
            {
                var a=particles[i];var b=particles[j];var delta=b.position-a.position;
                float radius=a.radius+b.radius,distance=delta.magnitude;
                if(distance>=radius)continue;
                var normal=distance>.001f?delta/distance:Vector2.right;
                var correction=normal*((radius-distance)*.5f);a.position-=correction;b.position+=correction;
                float speed=Vector2.Dot(b.velocity-a.velocity,normal);
                if(speed<0)
                {
                    var impulse=normal*(-(1+restitution)*speed*.5f);a.velocity-=impulse;b.velocity+=impulse;CollisionCount++;
                }
            }
        }
        void OnDisable()
        {
            foreach(var p in particles)Recycle(p);
            particles.Clear();if(layer!=null)layer.gameObject.SetActive(false);
        }
        void OnDestroy()
        {
            if(layer!=null)Destroy(layer.gameObject);
            layer=null;particles.Clear();pool.Clear();
        }
    }
}
