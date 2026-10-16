// Rebuild the reviewable import source, never edits scenes or the live catalog.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..');
const read=p=>fs.readFileSync(path.join(root,p),'utf8');
const parse=(p,re)=>read(p).split(/\r?\n/).map(line=>line.match(re)).filter(Boolean);
const staff=parse('Document/employee-effects-v2.md',/^\| ([^|]+) \| (\d{2}) \| ([^|]+) \| (\d+) \|$/);
const tools=parse('Document/item-design.md',/^\| ([^|]+) \| ([A-Za-z0-9]+) \| ([^|]+) \| (\d+) \|$/);
const art=parse('Document/employee-art-mapping.md',/^\| (\d+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \|$/);
if(staff.length!==33 || tools.length!==37 || art.length!==33)throw Error('Unexpected design row counts');
const values=[null,
{multiplier:4},{chips:20},{chips:10},{chips:40},{chips:10},{multiplier:4},{count:6,chips:20},{multiplier:3},
{count:2,multiplier:2,limit:8},{chips:20,bonusChips:30,threshold:4,bonusMultiplier:5},{chips:10,discount:1},{multiplier:3,bonusChips:30},
{count:1,multiplier:3,threshold:3,bonusChips:40},{chips:10,discount:1},{threshold:5,multiplier:1,limit:6},{chips:80,count:6},{chips:50},
{count:4,multiplier:8},{multiplier:2},{chips:15},{multiplier:4},{chips:50,threshold:4},{chips:20,bonusMultiplier:4},
{threshold:21,multiplier:2,chips:40},{count:1,threshold:2,limit:12,multiplier:2},{multiplier:4,bonusMultiplier:8},{},
{threshold:2,chips:30,bonusChips:20},{chips:40},{chips:30,multiplier:2},{multiplier:6,bonusChips:60},
{count:1,chips:15,limit:120,bonusChips:10},{threshold:4,multiplier:3}];
const grants={1:[0,-1,1],3:[4,6,0],4:[3,1,0],8:[1,3,-1],15:[0,-1,3],17:[5,2,-1],19:[1,2,-1],20:[2,-1,0],32:[0,6,-1]};
const toolValues={BenZai:{chips:40},Farmer:{multiplier:4},C4:{},Rail:{chips:120},Potato:{count:1},Gun:{count:-1},HotPot:{chips:100},
Zhan:{chips:90},Spray:{chips:70},Log:{chips:120},Steam:{chips:70,threshold:3},TNT:{multiplier:16},Prince:{multiplier:8},RIPot:{multiplier:2},
Rubbish:{multiplier:10},'3men':{multiplier:2},Angle:{chips:20},Clock:{chips:80,count:2},NaiLong:{multiplier:8,count:2},FangSi:{},Tomato:{multiplier:10},
Fusion:{multiplier:2},Fangdan:{chips:20},CockTail:{chips:25},Hat:{chips:200,count:2},Candy:{chips:7},Bing:{multiplier:2}};
const files=fs.readdirSync(path.join(root,'Assets/Image/Tools'));
const content=[],images=[];
const visibleText=s=>s.replace(/<br>/g,'\n').replace(/≥/g,'不少于').replace(/≤/g,'不超过').replace(/＞/g,'大于').replace(/＜/g,'小于');
for(const row of staff){const [,name,n,effect,price]=row,i=Number(n),id='employee.'+n;
const image=art.find(a=>Number(a[1])===i)?.[3];if(!image || !fs.existsSync(path.join(root,'Assets/Image/Staff',image)))throw Error('Missing staff image: '+name);
const g=grants[i];content.push({id,name,description:visibleText(effect),item:false,price:Number(price),rule:id,values:values[i],
effects:g?[{trigger:4,kind:7,local:false,amount:1,enchantment:g[0],rankFilter:g[1],suitFilter:g[2]}]:[]});
images.push({id,path:'Assets/Image/Staff/'+image});}
for(const row of tools){const [,name,code,effect,price]=row,id='item.'+code;
const image=files.find(f=>f.toLowerCase()===(code+'.png').toLowerCase());if(!image)throw Error('Missing tool image: '+code);
let rule=id,v=toolValues[code];if(code.startsWith('Light')){rule='item.Light';v={chips:20,threshold:Number(code.slice(5))};}
if(code.startsWith('Book')){rule='item.Book';v={multiplier:2,threshold:[1,3,2,0][Number(code.slice(4))-1]};}
if(!v)throw Error('Missing mechanic: '+code);
content.push({id,name,description:visibleText(effect),item:true,price:Number(price),rule,values:v,effects:[],
locksEmployee:['HotPot','Zhan'].includes(code),lifetimeMonths:['Hat','Candy','Bing'].includes(code)?3:0});
images.push({id,path:'Assets/Image/Tools/'+image});}
const source=read('Document/task-design.md');
const taskRows=source.split(/\r?\n/).filter(l=>/^\|\d+\|/.test(l)).map(l=>l.split('|').slice(1,-1));
if(taskRows.length!==15)throw Error('Expected 15 task definitions');
const kinds=[0,1,2,3,4,5,6,7,8,9,0,0,10,11,0];
const names=['两对结算6次','全红结算3次','全黑结算3次','不重抽完成3个月','全场至少4点结算3次','双倍达标3个月','不摆满完成3个月','四周四种不同牌型','买空同批3件道具','连续3月不买卖','顺子结算6次','结算六张同花顺','集齐其余12种牌型','单月十倍达标','葫芦结算7次'];
const targets=[6,3,3,3,3,3,3,1,1,3,6,1,12,1,7],patterns={0:[2],10:[5],11:[13],14:[8]};
const tasks=taskRows.map((r,i)=>({id:'task.'+String(i+1).padStart(2,'0'),name:names[i],description:r[1],kind:kinds[i],target:targets[i],reward:Number(r[r.length-1]),
deadlineMonths:r.length===4?Number(r[2]):0,patternPriorities:patterns[i]||[]}));
const result={firstTarget:600,content,tasks,images};
fs.writeFileSync(path.join(root,'Assets/WorkWork/Config/ContentDefinitions.json'),JSON.stringify(result,null,2)+'\n');
console.log(JSON.stringify({employees:staff.length,items:tools.length,tasks:tasks.length,missingImages:0,rewards:tasks.reduce((a,t)=>(a[t.reward]=(a[t.reward]||0)+1,a),{})}));
