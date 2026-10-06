local players=game:GetService("Players")
local rs=game:GetService("ReplicatedStorage")
local ws=game:GetService("Workspace")
local http=game:GetService("HttpService")
local lp=players.LocalPlayer
local cam=ws.CurrentCamera
local mouse=lp and lp:GetMouse()or nil
local fontnames={"San Francisco","Proggy","Pixelated","JetBrains","Minecraft","Fortnite"}
local fontvalues={Drawing.Fonts.System,Drawing.Fonts.UI,Drawing.Fonts.Pixel,Drawing.Fonts.Monospace,Drawing.Fonts.Minecraft,Drawing.Fonts.Fortnite}
local fontindex=1
local font=fontvalues[fontindex]
local stud2m=1/3.5714285714
local scanrate,hudrate,statusrate=0.25,0.033,0.05
local ringfade,ringseg,cratedist,maxtrack=40,64,30,256
local toggle={esp=true,hud=true,distance=false,distancefade=false,menu=false,watermark=true,hybridmode=true,unsafeluau=true,esptextoutline=true,barrgb=false,roof=true,distanceunit="meters",distanceposition="below",poweractivity=true,poweractivitymode="activity",autopower=false,autopowerrequiretoolbox=true,autopowernext=0,hudstyle="modern",containerstyle="modern",scrapstyle="default",scrapteleport="value",supplylabel=true,supplyitems=true,crateinventorydistance=10,ringenabled=true,ringshape="circle",ringsize=1,ringspin=false,ringspinspeed=1,rgbdirection="right",powerformat="percent",powerdecimal=true,timerformat="clock",hudfontindex=1,teleportcooldown=false,cooldownseconds=10,cooldownuntil=0,cooldownremaining=0,rakename=true,rakehealth=true,rakedistance=true,rakenamevalue="rake",rakenamey=0,rakenamecapture=false,killaura=false,killaurarange=16,killauradelay=0.05,killauranext=0,killpartnames={"Head","Torso","UpperTorso","LowerTorso","HumanoidRootPart"},sellenabled=true,scrapteleportenabled=true,flareteleportenabled=true,hudelements={timer=true,target=true,scrap=true,power=true}}
toggle.rakehealthcoloring=false;toggle.ringopacity=0.6;toggle.autoheal=false;toggle.autohealth=50;toggle.autohealnext=0
toggle.running=true;toggle.retireaware=true;toggle.wait=function(seconds)task.wait(seconds);assert(toggle.running and not toggle.replacing,"drawing session retired")end;toggle.spawn=function(callback)if toggle.running and not toggle.replacing then spawn(function()pcall(callback)end)end end;toggle.starting=true;toggle.uibatch=true;toggle.hybridfeatures=false;toggle.drawregistry=setmetatable({},{__mode="k"});toggle.shopbusy=false;toggle.chromaspeed=0.6;toggle.chromasaturation=0.3
toggle.workererrors=0;toggle.worker=function(callback)toggle.spawn(function()local failures=0;while toggle.running and not toggle.replacing do local ok=pcall(callback);if not toggle.running or toggle.replacing then return end;if ok then return end;failures=math.min(4,failures+1);toggle.workererrors=toggle.workererrors+1;toggle.wait(math.min(2,0.25*2^(failures-1)))end end)end
toggle.eventstates=setmetatable({},{__mode="k"})
toggle.fireevent=function(remote,...)
    if toggle.running==false or toggle.replacing or type(_G)=="table"and _G.__therakeDrawingSession and _G.__therakeDrawingSession~=toggle then return false end;local ok,alive=pcall(function()return remote and remote.Parent~=nil and remote:IsA("RemoteEvent")end);if not ok or not alive then return false end
    local state=toggle.eventstates[remote];if not state then state={busy=false,failures=0,next=0};toggle.eventstates[remote]=state end;local now=tick();if state.busy or now<state.next then return false end;state.busy=true
    local sent,called=pcall(function(...)if not toggle.running or toggle.replacing or type(_G)=="table"and _G.__therakeDrawingSession~=toggle or not remote.Parent then return false end;remote:FireServer(...);return true end,...);state.busy=false;sent=sent and called==true
    if sent then state.failures=0;state.next=0 else state.failures=math.min(4,state.failures+1);state.next=now+math.min(2,0.25*2^(state.failures-1))end;return sent
end
toggle.targetnight=false;toggle.hudlabels=true;toggle.distanceminimum=true;toggle.distancemin=0;toggle.poweravailable=true;toggle.powerhudavailable=false;toggle.startedat=tick()
toggle.client={noJumpCooldown=false,infiniteStamina=false,noFall=false,towerBarriers=false,antiCollide=false,doorNoCollide=false,preventIdle=false};toggle.autoradio=false;toggle.autoradionext=0
toggle.worldinfo={scraps=0,points=0,flare=false,traps=0,crates=0,power=false};toggle.worldpanel=false;toggle.keybindpanel=false;toggle.worldpanelitems={scraps=true,flare=true,traps=true,crates=true,power=true}
toggle.notifysettings={position="bottom right",duration=4,rakedistance=30,types={supply=true,flare=true,rake=true,scrap=true,trap=true,teleports=true,watch=true,menu=true}}
toggle.notifications={items={},ready=false,rakenear=false,targeted=false,raketeleporting=false,bloodturning=false,bloodhour=false,max=4}
toggle.scanid=0;toggle.scanning=false;toggle.nextpowerread=0;toggle.nextpanelrefresh=0;toggle.voltmeterlevel=nil;toggle.nextvoltmeterscan=0
toggle.scrapvalues={12,15,19,23,27};toggle.scrapedit=1;toggle.locationedit=1;toggle.scrapelements={};for i=1,5 do toggle.scrapelements["Scrap"..i]={tiers=false,points=false}end
toggle.idle={nextsample=0,lastactive=0,busy=false};toggle.tracers={order={"rake","flare","crates","scraps","traps","players","locations"},selected={},records={},count=0,frame=0,segments=48,opacity=0.8,speed=1,phase=0}
toggle.clientlabels={noJumpCooldown="no jump cooldown",infiniteStamina="infinite stamina",noFall="no fall damage",towerBarriers="no tower push",antiCollide="player no-collide",doorNoCollide="Door No-Collide",preventIdle="Prevent Idle Timeout"}
toggle.clientgcnames={"vars","canMove","can_jump","can_jump2","lastJump","handlingSRegen","regeningS","stamina","MAX_STAMINA"}
toggle.clientgc={cache={},bykey={},valid=false,scanning=false,nextapply=0,nextscan=0,scanfailures=0,applyfailures=0,misses=0,recoveries=0,stableat=nil,lastscan=0,character=lp and lp.Character or nil,characterkey=nil,rescanat=nil,maxstamina=100}
toggle.nofall={size=Vector3.new(100000,100000,100000),originals={},nextapply=0}
toggle.towerbarriers={originals={},nextapply=0,applied=false,inv=nil,generation=0}
toggle.zoom={thirdperson=false,amount=8,min=0,max=0,originalmin=nil,originalmax=nil,memoryvalid=false,directvalid=false,nextapply=0,minoffset=0x35C,maxoffset=0x358}
toggle.shiftlockstate={offset=0x3B6,active=false,nextapply=0}
toggle.instacrate=false;toggle.instacratestate={active=nil,distance=math.huge,collecting=false,collectuntil=0,range=30,patched=setmetatable({},{__mode="k"})};toggle.inventorycache={next=0,items={}}
toggle.autocollect={enabled=false,selected={},order={{name="StunStick",label="stun"},{name="UV_Lamp",label="uv"},{name="Vest",label="vest"},{name="Tracker",label="tracker"},{name="FirstAidKit",label="medkit"},{name="Vitamins",label="vitamin"}}}
toggle.prompts=false;toggle.promptsettings={master=false,housedoor=true,houselights=true,houseknock=true,trapdoor=true,forceopen=true,radar=true,towerlights=true};toggle.promptorder={{id="house",label="house controls"},{id="trapdoor",label="tower trapdoor"},{id="release",label="tower release"},{id="radar",label="radar"},{id="towerlights",label="lights"}};toggle.promptoptionorder={{id="housedoor",label="house door",panel="house"},{id="houselights",label="house lights",panel="house"},{id="houseknock",label="house knock",panel="house"},{id="trapdoor",label="tower trapdoor",panel="trapdoor"},{id="forceopen",label="release",panel="release"},{id="radar",label="tower radar",panel="radar"},{id="towerlights",label="tower lights",panel="towerlights"}};toggle.promptstate={records={},active=nil,distance=math.huge,nextresolve=0}
toggle.accentbars={menu=true,activity=false,keybinds=true,hud=true,world=false};toggle.accentbarorder={{id="menu",label="menu"},{id="activity",label="activity"},{id="keybinds",label="keybinds"},{id="hud",label="container"},{id="world",label="world"}}
toggle.resetselected={theme=false,features=false,positions=false};toggle.resetorder={{id="theme",label="theme"},{id="features",label="features"},{id="positions",label="positions"}}
toggle.notifyorder={"supply","flare","rake","scrap","trap","teleports","watch","menu"}
toggle.hudselectionorder={{id="target",label="rake target"},{id="scrap",label="scrap amount"},{id="power",label="power left"},{id="timer",label="timer"}}
toggle.hudselectionlabel=function()local values={};for _,entry in ipairs(toggle.hudselectionorder)do if toggle.hudelements[entry.id]then values[#values+1]=entry.label end end;return #values>0 and table.concat(values,", ")or"none"end
toggle.worldorder={{label="flare spawned",id="flare"},{label="scraps spawned",id="scraps"},{label="trap count",id="traps"},{label="crate count",id="crates"},{label="power",id="power"}}
toggle.locationorder={{label="shop",id="ShopMSG",color=12},{label="station",id="StationMSG",color=11},{label="house",id="SafehouseMSG",color=10},{label="tower",id="ObservationTowerMSG",color=13},{label="base",id="BaseCampMSG",color=9},{label="cave",id="RakeSpawnPart",color=14}}
toggle.scraporder={{label="scrap 1",id="Scrap1",color=2},{label="scrap 2",id="Scrap2",color=3},{label="scrap 3",id="Scrap3",color=4},{label="scrap 4",id="Scrap4",color=5},{label="scrap 5",id="Scrap5",color=6}}
toggle.shop={
    items={{name="StunStick",label="stunstick",price=900},{name="UV_Lamp",label="uv lamp",price=700},{name="Vest",label="vest",price=450},{name="Monitor",label="monitor",price=300},{name="RakeTrap",label="trap",price=250},{name="Tracker",label="tracker",price=200},{name="Toolbox",label="toolbox",price=140},{name="Vitamins",label="vitamin",price=80},{name="FirstAidKit",label="medkit",price=70},{name="Voltmeter",label="voltmeter",price=60},{name="Watch",label="watch",price=45},{name="Compass",label="compass",price=30},{name="Map",label="map",price=20}},
    names={"stunstick","uv lamp","vest","monitor","trap","tracker","toolbox","vitamin","medkit","voltmeter","watch","compass","map"},
    lookup={},
    selected="RakeTrap",lastscan=0,part=nil
}
toggle.playeresp={stacking=true,stackanim=0,enabled=true,distance=150,healthcoloring=false,nextscan=0,nextroster=0,nextdraw=0,scanid=0,scancursor=1,selectedcount=5,showusername=true,showhealth=true,showdistance=false,background=true,style="modern",selected={FlareGun=true,StunStick=true,UV_Lamp=true,FirstAidKit=true,Vest=true},order={{name="FlareGun",label="flare"},{name="StunStick",label="stun"},{name="UV_Lamp",label="uv"},{name="Vest",label="vest"},{name="Monitor",label="monitor"},{name="RakeTrap",label="trap"},{name="Tracker",label="tracker"},{name="Toolbox",label="toolbox"},{name="Vitamins",label="vitamin"},{name="FirstAidKit",label="medkit"},{name="Voltmeter",label="voltmeter"},{name="Watch",label="watch"},{name="Compass",label="compass"},{name="Map",label="map"}},names={"flare","stun","uv","vest","monitor","trap","tracker","toolbox","vitamin","medkit","voltmeter","watch","compass","map"},records={},scanlist={},visible={}}
toggle.autorecover=false;toggle.autorecovernext=0;toggle.autorecoverfolder=nil;toggle.recovervalue=0;toggle.recovervaluenext=0;toggle.autosellscrap=false;toggle.autosellnext=0;toggle.autobuyitems={selected={},next=0};toggle.autosellitems={selected={},next=0}
toggle.borderradius=10
toggle.offseturl="https://offsets.imtheo.lol/version-2366ba214ec740ca/offsets.hpp"
toggle.offsettext=nil;toggle.offsetloaded=false;toggle.offsetretry=0
toggle.white=Color3.fromHex("#ffffff");toggle.ringrgbcolor=Color3.fromHex("#d8d8d8");toggle.warningred=Color3.fromHex("#f2c94c");toggle.infoorange=Color3.fromHex("#ffffff");toggle.permissionblue=Color3.fromHex("#ffffff");toggle.permissionpink=Color3.fromHex("#66ccff");toggle.ringunit={}
toggle.playerdisplayname=lp and(lp.DisplayName or lp.Name)or"player"
toggle.distancestyle={labelcolor=Color3.fromHex("#c9c9c9"),defaultcolor=Color3.fromHex("#c9c9c9"),rgb=false,defaultrgb=false}
toggle.cooldownstyle={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false}
toggle.cooldownvaluestyle={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false}
toggle.hudstyles={
    timer={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false},
    target={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false},
    scrap={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false},
    power={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false}
}
toggle.hudvalues={
    timer={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false},
    target={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false},
    scrap={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false},
    power={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false}
}
toggle.cratestyles={
    FirstAidKit={name="medkit",labelcolor=Color3.fromHex("#dbffde"),defaultcolor=Color3.fromHex("#dbffde"),rgb=false},
    Vitamins={name="vitamin",labelcolor=Color3.fromHex("#d1d3ff"),defaultcolor=Color3.fromHex("#d1d3ff"),rgb=false},
    UV_Lamp={name="UV lamp",labelcolor=Color3.fromHex("#e694ff"),defaultcolor=Color3.fromHex("#e694ff"),rgb=false},
    StunStick={name="stun stick",labelcolor=Color3.fromHex("#ffed9d"),defaultcolor=Color3.fromHex("#ffed9d"),rgb=false},
    Vest={name="vest",labelcolor=Color3.fromHex("#9fd4ff"),defaultcolor=Color3.fromHex("#9fd4ff"),rgb=false},
    Tracker={name="tracker",labelcolor=Color3.fromHex("#cdceff"),defaultcolor=Color3.fromHex("#cdceff"),rgb=false}
}
local espgroups={locations=true,scraps=true,traps=true,flares=true,crates=true,rake=true}
espgroups.items={BaseCampMSG=true,SafehouseMSG=true,StationMSG=true,ShopMSG=true,ObservationTowerMSG=true,RakeSpawnPart=false,Scrap1=true,Scrap2=true,Scrap3=true,Scrap4=true,Scrap5=true}
local espfontsize=13
local guiopacity=0.9
local espcfg={}
local roofstyle={labelcolor=Color3.fromHex("#f5d3ff"),defaultcolor=Color3.fromHex("#f5d3ff"),rgb=false,defaultrgb=false}
toggle.rakestyle={labelcolor=Color3.fromHex("#ff5252"),defaultcolor=Color3.fromHex("#ff5252"),rgb=false,defaultrgb=false}
toggle.rakehealthstyle={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false}
local colorentries={
    {name="flare",cfgs={"FlareGunPickUp"}},{name="scrap 1",cfgs={"Scrap1"}},{name="scrap 2",cfgs={"Scrap2"}},{name="scrap 3",cfgs={"Scrap3"}},{name="scrap 4",cfgs={"Scrap4"}},{name="scrap 5",cfgs={"Scrap5"}},{name="trap",cfgs={"RakeTrapModel"}},{name="supply",cfgs={"Box","SupplyCrate"}},
    {name="base",cfgs={"BaseCampMSG"}},{name="house",cfgs={"SafehouseMSG"}},{name="station",cfgs={"StationMSG"}},{name="shop",cfgs={"ShopMSG"}},{name="tower",cfgs={"ObservationTowerMSG"}},{name="cave",cfgs={"RakeSpawnPart"}}
}
local defaultbinds={menu=0x43,esp=0,hud=0,scrap=0,flare=0,aura=0,sell=0,thirdperson=0,crate=0x46,prompt=0x46,collide=0,door=0}
local keybinds={menu=defaultbinds.menu,esp=defaultbinds.esp,hud=defaultbinds.hud,scrap=defaultbinds.scrap,flare=defaultbinds.flare,aura=defaultbinds.aura,sell=defaultbinds.sell,thirdperson=defaultbinds.thirdperson,crate=defaultbinds.crate,prompt=defaultbinds.prompt,collide=defaultbinds.collide,door=defaultbinds.door}
local bindorder={"menu","esp","hud","scrap","flare","aura","sell","thirdperson","collide","door","crate","prompt"}
local bindlabels={menu="menu toggle",esp="esp switch",hud="hud switch",scrap="tp scrap",flare="tp flare",aura="stun aura",sell="tp sell scrap",thirdperson="third person",crate="instant crate",prompt="prompt toggle",collide="player no-collide",door="door no-collide"}
local keyoptions,keynames,keywas={},{},{}
local function addkey(code,name)keyoptions[#keyoptions+1]={code=code,name=name};keynames[code]=name;keywas[code]=false end
addkey(0x08,"backspace");addkey(0x09,"tab");addkey(0x0D,"enter");addkey(0x10,"shift");addkey(0x11,"ctrl");addkey(0x12,"alt");addkey(0x1B,"escape");addkey(0x20,"space")
addkey(0x21,"page up");addkey(0x22,"page down");addkey(0x23,"end");addkey(0x24,"home");addkey(0x25,"left");addkey(0x26,"up");addkey(0x27,"right");addkey(0x28,"down");addkey(0x2D,"insert");addkey(0x2E,"delete")
for i=0x30,0x39 do addkey(i,string.char(i))end
for i=0x41,0x5A do addkey(i,string.char(i))end
for i=0,11 do addkey(0x70+i,"F"..tostring(i+1))end
addkey(0xBA,";");addkey(0xBB,"=");addkey(0xBC,",");addkey(0xBD,"-");addkey(0xBE,".");addkey(0xBF,"/");addkey(0xC0,"`");addkey(0xDB,"[");addkey(0xDC,"\\");addkey(0xDD,"]");addkey(0xDE,"'")
toggle.bindshort={backspace="bsp",space="spc",shift="sft",ctrl="ctl",enter="ent",escape="esc",insert="ins",delete="del",home="hom",left="lft",right="rgt",down="dwn",["page up"]="pgu",["page down"]="pgd"}
toggle.bindname=function(id)local name=keynames[keybinds[id]]or"none";return toggle.bindshort[name]or #name<=3 and name or string.sub(string.gsub(string.lower(name)," ",""),1,3)end
toggle.bindinfo="bind selector: click to change; press backspace to remove"
local function clamp(value,minv,maxv)return math.max(minv,math.min(maxv,value))end
toggle.textroles=setmetatable({},{__mode="k"});toggle.fontmetrics={cache={},order={},cursor=0};toggle.drawcolors=setmetatable({},{__mode="k"});toggle.removeddraw=setmetatable({},{__mode="k"})
toggle.pixel=function(value)return math.floor((tonumber(value)or 0)+0.5)end
toggle.fontvalue=function(role)return role=="esp"and font or fontvalues[toggle.hudfontindex]end
toggle.fontprofiles={
    [Drawing.Fonts.System]={width=0.86,height=13},
    [Drawing.Fonts.UI]={width=1,height=13},
    [Drawing.Fonts.Pixel]={width=0.75,height=13},
    [Drawing.Fonts.Monospace]={width=0.875,height=15},
    [Drawing.Fonts.Minecraft]={width=1,height=16,baseline=3},
    [Drawing.Fonts.Fortnite]={width=0.82,height=13}
}
toggle.measuretext=function(text,selected,size)
    text=tostring(text or"");size=tonumber(size)or 13;selected=selected or toggle.fontvalue("hud");local metrics=toggle.fontmetrics;local key=tostring(selected)..":"..size..":"..text;local cached=metrics.cache[key];if cached then return cached[1],cached[2]end
    local width,height=#text*7*size/13,size
    -- Matcha fonts are measured consistently before their first rendered frame.
    -- A shared mutable TextBounds probe can still return the previous string/font.
    local fixed=selected==Drawing.Fonts.UI or selected==Drawing.Fonts.Monospace or selected==Drawing.Fonts.Pixel or selected==Drawing.Fonts.Minecraft;local total=0
    for i=1,#text do local c=text:sub(i,i);total=total+(fixed and(selected==Drawing.Fonts.UI and 7 or 8)or c==" "and 4 or c:find("[ilI.,:;!|]")and 3.5 or c:find("[mwMW@]")and 10 or c:find("[A-Z]")and 8 or 7)end
    local profile=toggle.fontprofiles[selected];width=total*(profile and profile.width or 1)*size/13;height=(profile and profile.height or 13)*size/13
    local slot=metrics.cursor%1024+1;metrics.cursor=slot;local old=metrics.order[slot];if old then metrics.cache[old]=nil end;metrics.order[slot]=key;metrics.cache[key]={width,height};return width,height
end
toggle.textwidth=function(d)local meta=toggle.textroles[d];return toggle.measuretext(d.Text,meta and(meta.preview or toggle.fontvalue(meta.role))or font,meta and meta.size or espfontsize)end
toggle.espwidth=function(text)return toggle.measuretext(text,font,espfontsize)end
toggle.esplineheight=13;toggle.hudlineheight=13;toggle.menulineheight=13
toggle.textoffset=function(d)local meta=toggle.textroles[d];if not meta then return 0 end;local _,height=toggle.measuretext("Ag",meta.preview or toggle.fontvalue(meta.role),meta.size);local line=meta.role=="esp"and math.max(meta.size or 13,toggle.esplineheight or 13)or(meta.size or 13);local profile=toggle.fontprofiles[meta.preview or toggle.fontvalue(meta.role)];return(line-height)/2+(profile and profile.baseline or 0)*(meta.size or 13)/13 end
toggle.settextrole=function(d,role)if d then local meta=toggle.textroles[d]or{size=13};meta.role=role;if role=="esp"then meta.size=espfontsize;d.Size=espfontsize end;meta.preview=nil;toggle.textroles[d]=meta;d.Font=toggle.fontvalue(role)end;return d end
toggle.gradientinset=function()return math.max(3,math.ceil((toggle.borderradius or 0)*0.6))end
toggle.setpos=function(d,x,y)
    if not d or toggle.removeddraw[d]then return end
    x=tonumber(x)or 0;y=(tonumber(y)or 0)+toggle.textoffset(d);if x~=x or y~=y or math.abs(x)>1000000 or math.abs(y)>1000000 then return end;local p=d.Position;local px,py=math.floor(x*4+0.5)/4,math.floor(y*4+0.5)/4
    if not p or math.abs(p.X-px)>=0.08 or math.abs(p.Y-py)>=0.08 then d.Position=Vector2.new(px,py)end
end
toggle.setprop=function(d,key,value)if d and not toggle.removeddraw[d]then local meta=toggle.textroles[d];if meta then if key=="Font"then value=meta.preview or toggle.fontvalue(meta.role)elseif key=="Size"and type(value)=="number"then meta.size=value end end;if key=="Position"and meta then value=Vector2.new(value.X,value.Y+toggle.textoffset(d))end;local old=d[key];local same=old==value;if not same and old and value then if key=="Color"then same=math.abs(old.R-value.R)<0.0001 and math.abs(old.G-value.G)<0.0001 and math.abs(old.B-value.B)<0.0001 elseif(key=="Position"or key=="Size")and typeof(old)=="Vector2"and typeof(value)=="Vector2"then same=old.X==value.X and old.Y==value.Y end end;if not same then d[key]=value end;if key=="Color"then toggle.drawcolors[d]=value end end end
toggle.centertext=function(d,x,cy)
    if not d or toggle.removeddraw[d]then return end
    -- Matcha's native Center anchor centers both axes using the active font.
    -- Centered text must not receive the top-left text-offset correction.
    x=tonumber(x);cy=tonumber(cy);if not x or not cy or x~=x or cy~=cy or math.abs(x)>1000000 or math.abs(cy)>1000000 then return end
    toggle.setprop(d,"Center",true);local p=d.Position;local px,py=math.floor(x*4+0.5)/4,math.floor(cy*4+0.5)/4
    if not p or math.abs(p.X-px)>=0.08 or math.abs(p.Y-py)>=0.08 then d.Position=Vector2.new(px,py)end
end
local function waitchild(parent,name,timeout)
    local start=tick()
    local child=parent:FindFirstChild(name)
    while not child do
        if timeout and tick()-start>=timeout then return nil end
        toggle.wait(0.1)
        child=parent:FindFirstChild(name)
    end
    return child
end
local function waitcam(timeout)
    local start=tick()
    local cam=ws.CurrentCamera
    while not cam do
        if timeout and tick()-start>=timeout then return nil end
        toggle.wait(0.1)
        cam=ws.CurrentCamera
    end
    return cam
end
if not cam then cam=waitcam(15)end
if not cam or not lp or not mouse then return end
if type(_G)=="table"then
    local previous=_G.__therakeDrawingSession
    if type(previous)=="table"then
        previous.replacing=true
        if previous.promptstate then previous.promptstate.queue={};previous.promptstate.holding=false;previous.promptstate.holdid=nil end
        if previous.instacratestate then local state=previous.instacratestate;state.collectid=(state.collectid or 0)+1;state.request=nil;state.worker=false;state.collecting=false end
        previous.running=false
        -- Drain already-yielded jobs before disposing their native drawings.
        task.wait(0.1)
        if type(previous.cleanup)=="function"then if not previous.retireaware then previous.running=true end;pcall(previous.cleanup)end;previous.running=false
    end
    _G.__therakeDrawingSession=toggle
end

local timerval=waitchild(rs,"Timer",15)
local powervals=waitchild(rs,"PowerValues",15)
if not timerval or not powervals then return end
toggle.powerlevel=powervals:FindFirstChild("PowerLevel")
toggle.powerdrainobject=powervals:FindFirstChild("PPMS")
toggle.stationpower=rs:FindFirstChild("StationPower")
toggle.anyclient=function()for _,value in pairs(toggle.client)do if value then return true end end;return false end
toggle.clientneedsgc=function()return toggle.client.noJumpCooldown or toggle.client.infiniteStamina end
toggle.memoryread=function(kind,address)
    if type(address)~="number"or address<=0 or type(memory_read)~="function"then return nil end
    local ok,value=pcall(memory_read,kind,address);return ok and value or nil
end
toggle.memorywrite=function(kind,address,value)
    if type(address)~="number"or address<=0 or type(memory_write)~="function"then return false end
    return pcall(memory_write,kind,address,value)
end
toggle.instanceaddress=function(object)
    local ok,address=pcall(function()return object and object.Address end);return ok and type(address)=="number"and address>0 and address or nil
end
-- Live JSON offsets are separate from the existing camera offset provider.
toggle.visuals={url="https://offsets.imtheo.lol/Offsets.json",retry=0,loading=false,nextapply=0,nextscan=0,nextfooter=0,effects={},records={},grasslength=0.5,lengthedited=false,
    water={labelcolor=Color3.fromRGB(12,84,91),rgb=false,edited=false}}
toggle.visualfinite=function(value,low,high)return type(value)=="number"and value==value and value>=low and value<=high end
toggle.visualpointer=function(value)return toggle.visualfinite(value,10000,281474976710655)and value%8==0 end
toggle.visualoffset=function(group,key)
    local offsets=toggle.visuals.offsets;local section=offsets and offsets[group];local value=type(section)=="table"and section[key]
    return toggle.visualfinite(value,1,8191)and value%1==0 and value or nil
end
toggle.visualprocesskey=function()
    local address=toggle.instanceaddress(game);local base=0;if type(getbase)=="function"then local ok,value=pcall(getbase);if ok and type(value)=="number"then base=value end end
    return address and tostring(base)..":"..tostring(address)or nil
end
toggle.loadvisualoffsets=function()
    local state=toggle.visuals;if state.loading or state.offsets or tick()<state.retry then return end
    local key=toggle.visualprocesskey();local cached=type(_G)=="table"and _G.__therakeLiveVisualOffsets
    if key and type(cached)=="table"and cached.key==key and cached.url==state.url and type(cached.groups)=="table"then state.offsets=cached.groups;return end
    state.loading=true;state.retry=tick()+15
    toggle.spawn(function()
        local ok,raw=pcall(function()return game:HttpGet(state.url)end);if not toggle.running or toggle.replacing then state.loading=false;return end
        local parsed,data=false,nil;if ok and type(raw)=="string"and #raw<262144 then parsed,data=pcall(function()return http:JSONDecode(raw)end)end
        local groups=parsed and type(data)=="table"and(data.Offsets or data);if type(groups)=="table"and type(groups.Terrain)=="table"and type(groups.Humanoid)=="table"then state.offsets=groups;state.nextapply=0;state.nextscan=0;if key and type(_G)=="table"then _G.__therakeLiveVisualOffsets={key=key,url=state.url,groups=groups}end end;state.loading=false
    end)
end
toggle.visuallive=function(object,address,class)
    local ok,alive=pcall(function()return object and object.Parent and object.ClassName==class and toggle.instanceaddress(object)==address end);return ok and alive==true
end
toggle.visualreadcolor=function(kind,address)
    local step=kind=="byte"and 1 or 4;local max=kind=="byte"and 255 or 1;local values={}
    for i=1,3 do local value=toggle.memoryread(kind,address+(i-1)*step);if not toggle.visualfinite(value,0,max)then return nil end;values[i]=value end;return values
end
toggle.visualwritecolor=function(kind,address,values)
    local current=toggle.visualreadcolor(kind,address);if not current then return false end;local step=kind=="byte"and 1 or 4;local ok=true
    for i=1,3 do if math.abs(current[i]-values[i])>0.0001 then if not toggle.memorywrite(kind,address+(i-1)*step,values[i])then ok=false end end end;return ok
end
toggle.restoreterrain=function()
    local state=toggle.visuals;local rec=state.terrain;if not rec then return end
    if toggle.visuallive(rec.object,rec.address,"Terrain")then
        if rec.touched.water then toggle.visualwritecolor("float",rec.address+rec.wateroffset,rec.originalwater)end
        if rec.touched.length then toggle.memorywrite("float",rec.address+rec.lengthoffset,rec.originallength)end
    end;state.terrain=nil
end
toggle.captureterrain=function()
    local state=toggle.visuals;local terrain=ws:FindFirstChild("Terrain");local address=toggle.instanceaddress(terrain)
    if state.terrain and state.terrain.address==address and toggle.visuallive(terrain,address,"Terrain")then state.terrain.object=terrain;return state.terrain end
    toggle.restoreterrain();if not toggle.visualpointer(address)or not toggle.visuallive(terrain,address,"Terrain")then return nil end
    local rec={object=terrain,address=address,touched={}}
    rec.wateroffset=toggle.visualoffset("Terrain","WaterColor");if rec.wateroffset and rec.wateroffset%4==0 then rec.originalwater=toggle.visualreadcolor("float",address+rec.wateroffset)end
    rec.lengthoffset=toggle.visualoffset("Terrain","GrassLength");if rec.lengthoffset and rec.lengthoffset%4==0 then local value=toggle.memoryread("float",address+rec.lengthoffset);if toggle.visualfinite(value,-1,1)then rec.originallength=value end end
    state.terrain=rec
    if rec.originalwater and not state.water.edited then local c=rec.originalwater;state.water.labelcolor=Color3.new(c[1],c[2],c[3])end
    if rec.originallength and not state.lengthedited then state.grasslength=clamp(rec.originallength,-0.5,1) end
    if toggle.refreshvisualui then toggle.refreshvisualui()end;return rec
end
toggle.applyterrain=function()
    local state=toggle.visuals;local rec=toggle.captureterrain();if not rec then return end
    if state.water.edited and not state.water.rgb and rec.originalwater then local c=state.water.rgb and Color3.fromHSV(toggle.chromaphase or 0,toggle.chromasaturation,1)or state.water.labelcolor;rec.touched.water=true;toggle.visualwritecolor("float",rec.address+rec.wateroffset,{c.R,c.G,c.B})end
    if state.lengthedited and rec.originallength then rec.touched.length=true;local value=toggle.memoryread("float",rec.address+rec.lengthoffset);if toggle.visualfinite(value,-1,1)and math.abs(value-state.grasslength)>0.0001 then rec.touched.length=true;toggle.memorywrite("float",rec.address+rec.lengthoffset,state.grasslength)end end
end
toggle.applywaterchroma=function(now)
    local state=toggle.visuals;local cfg=state.water;local rec=state.terrain
    if not cfg.edited or not cfg.rgb or not rec or not rec.originalwater then state.waterblend=nil;state.waterlast=nil;return end
    now=now or tick();if now<(state.nextwaterframe or 0)then return end;state.nextwaterframe=(state.nextwaterframe or now)+1/60;if state.nextwaterframe<now then state.nextwaterframe=now+1/60 end
    if not toggle.visuallive(rec.object,rec.address,"Terrain")then return end
    local wanted=Color3.fromHSV((now*toggle.chromaspeed)%1,toggle.chromasaturation,1)
    local previous=state.waterblend;if not previous or state.wateraddress~=rec.address then local c=toggle.visualreadcolor("float",rec.address+rec.wateroffset);if not c then return end;previous=Color3.new(c[1],c[2],c[3])end
    local dt=math.min(0.1,math.max(0,now-(state.waterlast or now-1/60)));local amount=1-math.exp(-dt*24)
    local c=Color3.new(previous.R+(wanted.R-previous.R)*amount,previous.G+(wanted.G-previous.G)*amount,previous.B+(wanted.B-previous.B)*amount)
    rec.touched.water=true;if toggle.visualwritecolor("float",rec.address+rec.wateroffset,{c.R,c.G,c.B})then state.waterblend=c;state.wateraddress=rec.address;state.waterlast=now end
end
toggle.posteffectorder={
    {id="postbloom",class="BloomEffect",label="Bloom",fields={{key="Intensity",id="bloomintensity",label="Intensity",min=0,max=10,default=1},{key="Size",id="bloomsize",label="Size",min=0,max=56,default=24},{key="Threshold",id="bloomthreshold",label="Threshold",min=0,max=1,default=0.95}}},
    {id="postdepth",class="DepthOfFieldEffect",label="Depth Of Field",fields={{key="FocusDistance",id="depthfocus",label="Focus Distance",min=0,max=500,default=10},{key="FarIntensity",id="depthfar",label="Far Intensity",min=0,max=1,default=0.75},{key="NearIntensity",id="depthnear",label="Near Intensity",min=0,max=1,default=0.75},{key="InFocusRadius",id="depthradius",label="In-Focus Radius",min=0,max=500,default=10}}},
    {id="postcorrection",class="ColorCorrectionEffect",label="Color Correction",fields={{key="Brightness",id="correctionbrightness",label="Brightness",min=-0.04,max=0.13,uimin=1,uimax=10,default=0},{key="Contrast",id="correctioncontrast",label="Contrast",min=-1,max=1,default=0}},color="TintColor"},
    {id="postblur",class="BlurEffect",label="Blur",fields={{key="Size",id="blursize",label="Size",min=0,max=56,default=24}}}
}
toggle.visuals.effectdefs={};toggle.visuals.effectfields={};toggle.visuals.revision=0
toggle.visuals.correction={labelcolor=Color3.new(1,1,1),rgb=false,edited=false}
for _,entry in ipairs(toggle.posteffectorder)do
    toggle.visuals.effectdefs[entry.class]=entry;toggle.visuals.effects[entry.class]=false;entry.values={};entry.edited={}
    for _,field in ipairs(entry.fields)do entry.values[field.key]=field.default;toggle.visuals.effectfields[field.id]={effect=entry,field=field}end
end
toggle.visualchanged=function()
    toggle.visuals.revision=toggle.visuals.revision+1;toggle.visuals.nextapply=0
end
toggle.captureeffect=function(object,address,definition)
    local state=toggle.visuals;local rec=state.records[address]
    if rec and rec.class==definition.class then rec.object=object;return rec end
    local offset=toggle.visualoffset(definition.class,"Enabled");if not offset then return nil end
    local enabled=toggle.memoryread("byte",address+offset);if enabled~=0 and enabled~=1 then return nil end
    rec={object=object,address=address,class=definition.class,definition=definition,offset=offset,original=enabled,values={},offsets={},touched={},nextcheck=0}
    for _,field in ipairs(definition.fields)do local relative=toggle.visualoffset(definition.class,field.key)
        if relative and relative%4==0 then local value=toggle.memoryread("float",address+relative);if toggle.visualfinite(value,math.min(field.min,-10000),math.max(field.max,10000))then rec.values[field.key]=value;rec.offsets[field.key]=relative
            if not definition.captured and not definition.edited[field.key]then definition.values[field.key]=clamp(value,field.min,field.max)end
        end end
    end
    if definition.color then local relative=toggle.visualoffset(definition.class,definition.color);if relative and relative%4==0 then rec.originalcolor=toggle.visualreadcolor("float",address+relative);rec.coloroffset=relative;if rec.originalcolor and not definition.captured and not state.correction.edited then local c=rec.originalcolor;state.correction.labelcolor=Color3.new(c[1],c[2],c[3])end end end
    definition.captured=true;state.records[address]=rec;return rec
end
toggle.restoreeffect=function(rec)
    if not next(rec.touched)then return true end;if not toggle.visuallive(rec.object,rec.address,rec.class)then rec.touched={};return true end
    local restored=true
    for key in pairs(rec.touched)do local ok
        if key=="Enabled"then ok=toggle.memorywrite("byte",rec.address+rec.offset,rec.original)
        elseif key=="TintColor"then ok=toggle.visualwritecolor("float",rec.address+rec.coloroffset,rec.originalcolor)
        else ok=toggle.memorywrite("float",rec.address+rec.offsets[key],rec.values[key])end
        if ok then rec.touched[key]=nil else restored=false end
    end;return restored
end
toggle.scanposteffects=function()
    local state=toggle.visuals;local found={};local roots={}
    if not state.lighting then local ok,lighting=pcall(function()return game:GetService("Lighting")end);if ok then state.lighting=lighting end end
    if state.lighting then roots[#roots+1]=state.lighting end;local camera=ws.CurrentCamera or ws:FindFirstChildOfClass("Camera");if camera then roots[#roots+1]=camera end
    local function inspect(object)
        local class=object.ClassName;local definition=state.effectdefs[class];if not definition then return end;local address=toggle.instanceaddress(object);if not toggle.visualpointer(address)then return end
        if toggle.captureeffect(object,address,definition)then found[address]=true end
    end
    for _,root in ipairs(roots)do local children=root:GetChildren();for i=1,math.min(#children,128)do inspect(children[i])end end
    for address,rec in pairs(state.records)do if not found[address]then toggle.restoreeffect(rec);state.records[address]=nil end end
end
toggle.applyposteffects=function(force)
    local state=toggle.visuals;local now=tick()
    for _,rec in pairs(state.records)do
        if not state.effects[rec.class]then if next(rec.touched)then toggle.restoreeffect(rec)end
        elseif toggle.visuallive(rec.object,rec.address,rec.class)and(force or rec.revision~=state.revision or now>=rec.nextcheck or rec.class=="ColorCorrectionEffect"and state.correction.rgb)then
            rec.nextcheck=now+0.5;rec.revision=state.revision;local enabled=toggle.memoryread("byte",rec.address+rec.offset);rec.touched.Enabled=true;if enabled==0 then toggle.memorywrite("byte",rec.address+rec.offset,1)end
            for _,field in ipairs(rec.definition.fields)do local relative=rec.offsets[field.key];if relative then local current=toggle.memoryread("float",rec.address+relative);local wanted=rec.definition.values[field.key];rec.touched[field.key]=true;if toggle.visualfinite(current,-10000,10000)and toggle.visualfinite(wanted,field.min,field.max)and math.abs(current-wanted)>0.0001 then rec.touched[field.key]=true;toggle.memorywrite("float",rec.address+relative,wanted)end end end
            if rec.originalcolor then local cfg=state.correction;local c=cfg.rgb and Color3.fromHSV(toggle.chromaphase or 0,toggle.chromasaturation,1)or cfg.labelcolor;rec.touched.TintColor=true;toggle.visualwritecolor("float",rec.address+rec.coloroffset,{c.R,c.G,c.B})end
        end
    end
end
toggle.seteffect=function(class,on)
    local state=toggle.visuals;if not state.effectdefs[class]then return end;state.effects[class]=on==true;toggle.visualchanged()
    if not on then for _,rec in pairs(state.records)do if rec.class==class then toggle.restoreeffect(rec)end end end
end

toggle.readfootername=function()
    local ok,name=pcall(function()return lp.DisplayName end);if ok and type(name)=="string"and #name>0 then return name end
    local offset=toggle.visualoffset("Player","DisplayName");local address=toggle.instanceaddress(lp);if offset and toggle.visualpointer(address)then local slot=address+offset;local length=toggle.memoryread("int",slot+16);local capacity=toggle.memoryread("int",slot+24)
        if toggle.visualfinite(length,1,128)and toggle.visualfinite(capacity,length,4096)then local data=capacity>=16 and toggle.memoryread("uintptr_t",slot)or slot;if toggle.visualfinite(data,10000,281474976710655)then local value=toggle.memoryread("string",data);if type(value)=="string"and #value==length then return value end end end
    end;return lp.Name or"Player"
end
toggle.applyvisuals=function(force)
    if not toggle.running or toggle.replacing then return end;local state=toggle.visuals;local now=tick();if not force and now<state.nextapply then return end;state.nextapply=now+0.1
    local needed=force or state.water.edited or state.lengthedited or toggle.visualmenuopen and toggle.visualmenuopen()
    if not needed then for _,enabled in pairs(state.effects)do if enabled then needed=true;break end end end
    if needed then toggle.loadvisualoffsets()end
    if now>=state.nextfooter then state.nextfooter=now+1;local name=toggle.readfootername();toggle.playerdisplayname=name;if toggle.footer then toggle.setprop(toggle.footer.username,"Text",name)end end
    if not state.offsets then return end;toggle.applyterrain();if force or now>=state.nextscan then state.nextscan=now+1;local first=not state.discovered;toggle.scanposteffects();state.discovered=true;if first and toggle.refreshvisualui then toggle.refreshvisualui()end end;toggle.applyposteffects(force)
end
toggle.restorevisuals=function()
    toggle.restoreterrain();for _,rec in pairs(toggle.visuals.records)do toggle.restoreeffect(rec)end;toggle.visuals.records={}
end
toggle.visualconfig=function()
    local state=toggle.visuals;local out={schema=2,effect_controls={}}
    for _,entry in ipairs(toggle.posteffectorder)do local saved={enabled=state.effects[entry.class],values={}};for _,field in ipairs(entry.fields)do if entry.edited[field.key]then saved.values[field.key]=entry.values[field.key]end end;out.effect_controls[entry.class]=saved end
    for _,id in ipairs({"water","correction"})do local cfg=state[id];if cfg.edited then local c=cfg.labelcolor;out[id]={r=math.floor(c.R*255+0.5),g=math.floor(c.G*255+0.5),b=math.floor(c.B*255+0.5),rgb=cfg.rgb==true}end end;if state.lengthedited then out.grass_length=state.grasslength end;return out
end
toggle.effectuivalue=function(field,value)
    if field.uimin then return field.uimin+(clamp(value,field.min,field.max)-field.min)/(field.max-field.min)*(field.uimax-field.uimin)end;return value
end
toggle.effectrawvalue=function(field,value)
    if field.uimin then return field.min+(clamp(value,field.uimin,field.uimax)-field.uimin)/(field.uimax-field.uimin)*(field.max-field.min)end
    return math.floor(clamp(value,field.min,field.max)*100+0.5)/100
end
toggle.offsetstructvalue=function(structname,name)
    local source=toggle.offsettext;if type(source)~="string"then return nil end
    local block=string.match(source,"namespace%s+"..structname.."%s*{(.-)%s*}")or string.match(source,"struct%s+"..structname.."%s*:%s*[%w_:]+%s*{(.-)%s*};");if type(block)~="string"then return nil end
    local value=string.match(block,"%s"..name.."%s*=%s*(0x[%da-fA-F]+)");return value and tonumber(value)or nil
end
toggle.offsetvalue=function(name)return toggle.offsetstructvalue("Player",name)end
toggle.loadoffsets=function(force)
    local now=tick();if toggle.offsetloading then return false end;if not force and toggle.offsetloaded then return true end;if not force and now<(toggle.offsetretry or 0)then return false end;toggle.offsetloading=true;toggle.offsetretry=now+10
    local processkey=toggle.visualprocesskey();local cached=type(_G)=="table"and _G.__therakeCameraOffsetText;local ok,source=false,nil
    if not force and processkey and type(cached)=="table"and cached.key==processkey and cached.url==toggle.offseturl then ok,source=true,cached.text else ok,source=pcall(function()return game:HttpGet(toggle.offseturl)end)end;toggle.offsetloading=false
    if not ok or type(source)~="string"or #source<100 then toggle.offsetretry=now+10;return false end
    toggle.offsettext=source;if processkey and type(_G)=="table"then _G.__therakeCameraOffsetText={key=processkey,url=toggle.offseturl,text=source}end
    local minimum=toggle.offsetvalue("MinZoomDistance")or toggle.offsetvalue("CameraMinZoomDistance");local maximum=toggle.offsetvalue("MaxZoomDistance")or toggle.offsetvalue("CameraMaxZoomDistance");local shiftlock=toggle.offsetvalue("DevEnableMouseLock")or toggle.shiftlockstate.offset;local unlockvalue=toggle.offsetstructvalue("DoubleConstrainedValue","Value")or toggle.offsetstructvalue("Misc","Value")or toggle.instacratestate.unlockoffset
    local minimumok=type(minimum)=="number"and minimum>0 and minimum<0x10000;local maximumok=type(maximum)=="number"and maximum>0 and maximum<0x10000;local shiftlockok=type(shiftlock)=="number"and shiftlock>0 and shiftlock<0x10000;local unlockok=type(unlockvalue)=="number"and unlockvalue>0 and unlockvalue<0x10000
    if minimumok then toggle.zoom.minoffset=minimum end;if maximumok then toggle.zoom.maxoffset=maximum end;if shiftlockok then toggle.shiftlockstate.offset=shiftlock end;if unlockok then toggle.instacratestate.unlockoffset=unlockvalue end
    toggle.offsetloaded=minimumok and maximumok and shiftlockok;toggle.offsetretry=toggle.offsetloaded and 0 or now+10
    return toggle.offsetloaded
end
toggle.requestoffsets=function()
    if toggle.offsetloading or toggle.offsetqueued or toggle.offsetloaded or tick()<(toggle.offsetretry or 0)then return false end;toggle.offsetqueued=true
    toggle.spawn(function()pcall(toggle.loadoffsets,false);toggle.offsetqueued=false end);return true
end
toggle.applyshiftlock=function()
    local state=toggle.shiftlockstate;if not state.active then return false end;local now=tick();if now<(state.nextapply or 0)then return true end;state.nextapply=now+0.1;if not state.offset then toggle.requestoffsets()end
    local address=toggle.instanceaddress(lp);if not address or not state.offset then return false end
    return toggle.memorywrite("byte",address+state.offset,1)
end
toggle.clientgc.characterkey=toggle.instanceaddress(toggle.clientgc.character)or toggle.clientgc.character
toggle.validzoom=function(minimum,maximum)
    return type(minimum)=="number"and minimum==minimum and minimum>=0 and minimum<=100000 and type(maximum)=="number"and maximum==maximum and maximum>=minimum and maximum<=100000
end
toggle.capturezoom=function()
    local directmin,directmax;pcall(function()directmin=lp.CameraMinZoomDistance;directmax=lp.CameraMaxZoomDistance end)
    toggle.zoom.directvalid=toggle.validzoom(directmin,directmax)
    local address=toggle.instanceaddress(lp);local memorymin=address and toggle.memoryread("float",address+toggle.zoom.minoffset)or nil;local memorymax=address and toggle.memoryread("float",address+toggle.zoom.maxoffset)or nil
    toggle.zoom.memoryvalid=address~=nil and toggle.validzoom(memorymin,memorymax)
    local minimum,maximum=toggle.zoom.memoryvalid and memorymin or directmin,toggle.zoom.memoryvalid and memorymax or directmax
    if toggle.validzoom(minimum,maximum)then toggle.zoom.originalmin=minimum;toggle.zoom.originalmax=maximum end;toggle.zoom.min=0;toggle.zoom.max=0
end
toggle.applyzoom=function(force)
    local state=toggle.zoom;local now=tick();if not force and now<(state.nextapply or 0)then return true end;state.nextapply=now+(state.thirdperson and 0.2 or 0.5)
    local minimum=clamp(tonumber(state.min)or 0,0,10000);local maximum=clamp(tonumber(state.max)or 0,minimum,10000);state.min=minimum;state.max=maximum
    local applied=false
    if state.directvalid then
        local ok,currentmin,currentmax=pcall(function()return lp.CameraMinZoomDistance,lp.CameraMaxZoomDistance end)
        if ok then
            local wrote=pcall(function()
                if minimum>(tonumber(currentmax)or 0)then
                    if currentmax~=maximum then lp.CameraMaxZoomDistance=maximum end
                    if currentmin~=minimum then lp.CameraMinZoomDistance=minimum end
                else
                    if currentmin~=minimum then lp.CameraMinZoomDistance=minimum end
                    if currentmax~=maximum then lp.CameraMaxZoomDistance=maximum end
                end
            end)
            applied=wrote or applied
        else state.directvalid=false end
    end
    if state.memoryvalid then
        local address=toggle.instanceaddress(lp);local currentmin=address and toggle.memoryread("float",address+state.minoffset)or nil;local currentmax=address and toggle.memoryread("float",address+state.maxoffset)or nil
        if not address or not toggle.validzoom(currentmin,currentmax)then state.memoryvalid=false;return applied end
        local function changed(a,b)return math.abs(a-b)>0.001 end
        if minimum>currentmax then if changed(currentmax,maximum)then applied=toggle.memorywrite("float",address+state.maxoffset,maximum)or applied end;if changed(currentmin,minimum)then applied=toggle.memorywrite("float",address+state.minoffset,minimum)or applied end
        elseif maximum<currentmin then if changed(currentmin,minimum)then applied=toggle.memorywrite("float",address+state.minoffset,minimum)or applied end;if changed(currentmax,maximum)then applied=toggle.memorywrite("float",address+state.maxoffset,maximum)or applied end
        else if changed(currentmin,minimum)then applied=toggle.memorywrite("float",address+state.minoffset,minimum)or applied end;if changed(currentmax,maximum)then applied=toggle.memorywrite("float",address+state.maxoffset,maximum)or applied end end
    end
    return applied
end
toggle.collisions={records={},list={},cursor=1,nextroster=0,nextapply=0,generation=0}
toggle.restorecolliderecord=function(rec)
    local pending=false
    for i=#rec.parts,1,-1 do local entry=rec.parts[i];local ok,done=pcall(function()local part=entry.part;if not part or not part.Parent then return true end;if part.CanCollide~=entry.original then part.CanCollide=entry.original end;return part.CanCollide==entry.original end)
        if ok and done then rec.byid[entry.id]=nil;rec.parts[i]=rec.parts[#rec.parts];rec.parts[#rec.parts]=nil else pending=true end
    end
    rec.queue=nil;rec.queued=nil;rec.scanchildren=nil;rec.childcursor=nil;rec.rootpending=nil;rec.branches={};rec.branchids={};rec.nodes={};rec.nodeids={};return not pending
end
toggle.forgetcollidenode=function(rec,node,id)
    id=id or toggle.instanceaddress(node)or node
    for _,names in ipairs({{"nodes","nodeids"},{"branches","branchids"}})do local list,map=rec[names[1]],rec[names[2]];local index=map[id];map[id]=nil;if type(index)=="number"and index<=#list then local last=list[#list];list[index]=last;list[#list]=nil;if index<=#list then map[toggle.instanceaddress(last)or last]=index end end end
end
toggle.restorecollisions=function()
    local state=toggle.collisions;for key,rec in pairs(state.records)do if toggle.restorecolliderecord(rec)then state.records[key]=nil end end;state.list={};state.cursor=1;state.nextroster=0;state.nextapply=0
end
toggle.applycollisions=function(force)
    local state=toggle.collisions;local now=tick();if not toggle.client.antiCollide and not next(state.records)then return end;if not force and now<state.nextapply then return end;state.nextapply=now+0.1
    if not toggle.client.antiCollide then toggle.restorecollisions();state.nextapply=now+0.25;return end
    if now>=state.nextroster then
        state.nextroster=now+1;local ok,roster=pcall(function()return players:GetPlayers()end);if ok and type(roster)=="table"then
            state.generation=state.generation+1;local generation=state.generation;local list=state.list;local count=0
            for i=1,#roster do local player=roster[i];local safe,key,character=pcall(function()local name=player.Name;return name,ws:FindFirstChild(name)or player.Character end)
                if safe and key and key~=lp.Name then
                    local rec=state.records[key];if not rec then rec={parts={},byid={},partcursor=1,branches={},branchids={},nodes={},nodeids={}};state.records[key]=rec end;rec.seen=generation;local charid=toggle.instanceaddress(character)or character
                    if charid~=rec.charid then if toggle.restorecolliderecord(rec)then rec.character=character;rec.charid=charid;rec.nextscan=0;rec.nextfullscan=now+20;rec.partcursor=1;rec.hotuntil=now+6 else character=nil end end
                    if character then rec.character=character;count=count+1;list[count]=rec end
                end
            end
            for i=#list,count+1,-1 do list[i]=nil end;for key,rec in pairs(state.records)do if rec.seen~=generation and toggle.restorecolliderecord(rec)then state.records[key]=nil end end;state.cursor=math.min(state.cursor,math.max(1,count))
        end
    end
    local nodesleft,childrenleft,partsleft=2,8,8;local busy=false
    for visit=1,math.min(2,#state.list)do
        local rec=state.list[state.cursor];state.cursor=state.cursor%#state.list+1;local visitnodes=#state.list>1 and 1 or 2;local visitchildren=#state.list>1 and 4 or 8;local visitparts=#state.list>1 and 4 or 8
        local safe,alive=pcall(function()return rec.character and rec.character.Parent~=nil end)
        if safe and alive then
            if not rec.queue and now>=(rec.nextscan or 0)then
                local full=now>=(rec.nextfullscan or math.huge);local source=full and rec.nodes or rec.branches;rec.queue={rec.character};rec.rootpending=true;rec.queued={[rec.charid]=true};rec.nodecursor=1
                for i=1,#source do local node=source[i];local id=toggle.instanceaddress(node)or node;if not rec.queued[id]then rec.queue[#rec.queue+1]=node;rec.queued[id]=true end end
                if full then rec.nextfullscan=now+20 end;rec.nextscan=now+(now<(rec.hotuntil or 0)and 1.2 or 4)
            end
            if rec.queue and not rec.scanchildren and not rec.rootpending and now>=(rec.nextrootpoll or 0)then table.insert(rec.queue,rec.nodecursor,rec.character);rec.rootpending=true end
            local examined=0
            while rec.queue and rec.nodecursor<=#rec.queue and childrenleft>0 and visitchildren>0 and examined<32 do
                if not rec.scanchildren then
                    if nodesleft<=0 or visitnodes<=0 then break end;nodesleft=nodesleft-1;visitnodes=visitnodes-1;local node=rec.queue[rec.nodecursor];local ok,children=pcall(function()return node and node.Parent and node:GetChildren()end)
                    if ok and type(children)=="table"then rec.scanchildren=children;rec.childcursor=1;local id=toggle.instanceaddress(node)or node;if #children>0 and not rec.branchids[id]then rec.branches[#rec.branches+1]=node;rec.branchids[id]=#rec.branches end else if ok then toggle.forgetcollidenode(rec,node)end;rec.nodecursor=rec.nodecursor+1 end
                end
                if rec.scanchildren then
                    while rec.childcursor<=#rec.scanchildren and childrenleft>0 and visitchildren>0 and examined<32 do
                        local part=rec.scanchildren[rec.childcursor];rec.childcursor=rec.childcursor+1;examined=examined+1;local id=toggle.instanceaddress(part)or part
                        if not rec.nodeids[id]then
                            childrenleft=childrenleft-1;visitchildren=visitchildren-1;rec.nodeids[id]=true;if #rec.nodes<512 then rec.nodes[#rec.nodes+1]=part;rec.nodeids[id]=#rec.nodes;if #rec.queue<512 and not rec.queued[id]then rec.queue[#rec.queue+1]=part;rec.queued[id]=true end end
                            local ok,ispart,original=pcall(function()local ispart=part:IsA("BasePart");return ispart,ispart and part.CanCollide end)
                            if ok and ispart and type(original)=="boolean"and not rec.byid[id]then local entry={id=id,part=part,original=original,nextcheck=now+(original and 0.35 or 3)};rec.byid[id]=entry;rec.parts[#rec.parts+1]=entry;if original then pcall(function()part.CanCollide=false end)end end
                        end
                    end
                    if rec.childcursor>#rec.scanchildren then if (toggle.instanceaddress(rec.queue[rec.nodecursor])or rec.queue[rec.nodecursor])==rec.charid then rec.rootpending=false;rec.nextrootpoll=now+1.5 end;rec.scanchildren=nil;rec.nodecursor=rec.nodecursor+1 end
                end
            end
            if rec.queue and rec.nodecursor>#rec.queue then rec.queue=nil;rec.queued=nil;rec.scanchildren=nil end;if rec.queue then busy=true end
            local visits=math.min(#rec.parts,16)
            for j=1,visits do
                if #rec.parts==0 or partsleft<=0 or visitparts<=0 then break end;rec.partcursor=math.min(rec.partcursor,#rec.parts);local index=rec.partcursor;local entry=rec.parts[index];rec.partcursor=index%#rec.parts+1
                if now>=(entry.nextcheck or 0)then partsleft=partsleft-1;visitparts=visitparts-1;entry.nextcheck=now+(entry.original and 0.35 or 3);local ok,alive=pcall(function()local part=entry.part;if not part or not part.Parent then return false end;if part.CanCollide then part.CanCollide=false end;return true end)
                    if ok and not alive then rec.byid[entry.id]=nil;toggle.forgetcollidenode(rec,entry.part,entry.id);rec.parts[index]=rec.parts[#rec.parts];rec.parts[#rec.parts]=nil;rec.partcursor=math.min(index,math.max(1,#rec.parts))end
                end
            end
        elseif safe then toggle.restorecolliderecord(rec);rec.character=nil;rec.charid=nil;rec.scanchildren=nil end
    end
    if busy then state.nextapply=now+0.05 end
end
toggle.gethaystack=function()
    local filter=ws:FindFirstChild("Filter");local haystack=filter and filter:FindFirstChild("Haystack")or nil;local ok,ispart=pcall(function()return haystack and haystack:IsA("BasePart")end);return ok and ispart and haystack or nil
end
toggle.applynofall=function(enabled,force)
    local state=toggle.nofall;local now=tick();if not force and now<(state.nextapply or 0)then return true end;state.nextapply=now+(enabled and 0.5 or 0.15)
    if enabled then
        local haystack=toggle.gethaystack();if not haystack then return false end
        return pcall(function()local id=haystack.Address;if type(id)~="number"or id<=0 then assert(false,"invalid haystack")end;local size=haystack.Size;if not state.originals[id]then state.originals[id]={part=haystack,size=Vector3.new(size.X,size.Y,size.Z)}end;local wanted=state.size;if size.X~=wanted.X or size.Y~=wanted.Y or size.Z~=wanted.Z then haystack.Size=wanted end end)
    end
    local restored=false;for id,entry in pairs(state.originals)do local ok,done=pcall(function()local part=entry.part;if not part.Parent then return true end;local size=entry.size;part.Size=Vector3.new(size.X,size.Y,size.Z);local value=part.Size;return math.abs(value.X-size.X)<0.01 and math.abs(value.Y-size.Y)<0.01 and math.abs(value.Z-size.Z)<0.01 end);if ok and done then state.originals[id]=nil;restored=true end end;return restored
end
toggle.applytowerbarriers=function(enabled,force)
    local state=toggle.towerbarriers;local now=tick();if enabled and state.applied and state.inv and state.inv.Parent then return true end;if state.applied then state.applied=false;state.nextapply=0 end;if enabled and not force and now<(state.nextapply or 0)then return false end
    if enabled then
        local map=ws:FindFirstChild("Map");local tower=map and map:FindFirstChild("ObservationTower");local inv=tower and tower:FindFirstChild("INV");if not inv then state.nextapply=now+0.5;return false end;state.generation=(state.generation or 0)+1;local applied=false;local children=inv:GetDescendants()
        for i=1,#children do local part=children[i];if part.Name=="CONV_INVIS"and part:IsA("BasePart")then if state.originals[part]==nil then local ok,velocity=pcall(function()return part.AssemblyLinearVelocity end);if ok then state.originals[part]=velocity end end;local ok=pcall(function()part.AssemblyLinearVelocity=Vector3.new(0,0,0)end);applied=ok or applied end end;state.applied=applied;state.inv=inv;state.nextapply=applied and math.huge or now+0.5;return applied
    end
    state.generation=(state.generation or 0)+1;local generation=state.generation;local originals=state.originals;local restored=false;for part,velocity in pairs(originals)do if part and part.Parent then local ok=pcall(function()part.AssemblyLinearVelocity=velocity end);restored=ok or restored end end;state.originals={};state.applied=false;state.inv=nil;state.nextapply=0
    toggle.spawn(function()for attempt=1,3 do toggle.wait(0.05);if state.generation~=generation or toggle.client.towerBarriers then return end;for part,velocity in pairs(originals)do if part and part.Parent then pcall(function()part.AssemblyLinearVelocity=velocity end)end end end end);return restored
end
toggle.capturezoom()
toggle.indexclientgc=function(cache)
    local indexed={};for i=1,#cache do if i%128==0 then toggle.wait()end;local entry=cache[i];if type(entry)=="table"and type(entry.key)=="string"then local list=indexed[entry.key];if not list then list={};indexed[entry.key]=list end;list[#list+1]=entry end end;toggle.clientgc.bykey=indexed
end
toggle.compactclientgc=function(cache)
    local compact={};for i=1,#cache do if i%128==0 then toggle.wait()end;local entry=cache[i];if type(entry)=="table"and type(entry.key)=="string"then local keep=entry.key~="vars";if not keep and type(entry.value)=="table"then local vars=entry.value;keep=rawget(vars,"canMove")~=nil or rawget(vars,"can_jump")~=nil or rawget(vars,"can_jump2")~=nil or rawget(vars,"lastJump")~=nil or rawget(vars,"handlingSRegen")~=nil or rawget(vars,"regeningS")~=nil or rawget(vars,"stamina")~=nil or rawget(vars,"MAX_STAMINA")~=nil end;if keep then compact[#compact+1]=entry end end end;return #compact>0 and compact or cache
end
toggle.refreshclientgc=function(force)
    local state=toggle.clientgc;local now=tick();if state.valid and not force then return true end;if state.scanning then return false end;if type(getgc)~="function"then state.rescanat=nil;return false end;if now<(state.nextscan or 0)then return false end
    state.scanning=true;local ok,cache=pcall(getgc,toggle.clientgcnames)
    if not ok or type(cache)~="table"then state.scanning=false;state.valid=false;state.scanfailures=(state.scanfailures or 0)+1;state.nextscan=now+math.min(2+state.scanfailures*2,10);state.rescanat=state.scanfailures<3 and state.nextscan or nil;return false end
    local processed,compact=pcall(toggle.compactclientgc,cache);if not processed then state.scanning=false;state.valid=false;state.rescanat=nil;return false end;cache=compact;state.cache=cache;local indexed=pcall(toggle.indexclientgc,cache);state.scanning=false;if not indexed then state.valid=false;state.rescanat=nil;return false end;state.valid=true;state.character=lp.Character;state.characterkey=toggle.instanceaddress(state.character)or state.character;state.rescanat=nil;state.nextscan=now+2;state.scanfailures=0;state.applyfailures=0;state.misses=0;state.stableat=nil;state.lastscan=now;state.nextapply=0;state.maxstamina=100
    local maximum=state.bykey.MAX_STAMINA or{};for i=1,#maximum do local value=maximum[i].value;if type(value)=="number"and value>0 then state.maxstamina=value;break end end
    return true
end
toggle.recoverclientgc=function(now)
    local state=toggle.clientgc;state.valid=false;state.cache={};state.bykey={};state.misses=0;state.applyfailures=0;state.stableat=nil;state.recoveries=(state.recoveries or 0)+1;state.rescanat=state.recoveries<=3 and now+math.min(2+state.recoveries*2,8)or nil
end
toggle.clientgcapply=function(values)
    if type(applygc)~="function"or not toggle.clientgc.valid then return false end
    local state=toggle.clientgc;local now=tick();if #state.cache==0 then toggle.recoverclientgc(now);return false end;local ok,count=pcall(applygc,state.cache,values)
    if not ok then state.applyfailures=(state.applyfailures or 0)+1;if state.applyfailures>=3 then toggle.recoverclientgc(now)end;return false end
    state.applyfailures=0;local wrote=type(count)~="number"or count>0;local expected=false;for key in pairs(values)do local entries=state.bykey[key];if entries and #entries>0 then expected=true;break end end
    if expected and not wrote then state.misses=(state.misses or 0)+1;if state.misses>=8 and now-(state.lastscan or 0)>=1 then toggle.recoverclientgc(now)end
    else state.misses=0;if wrote then if not state.stableat then state.stableat=now elseif now-state.stableat>=15 then state.recoveries=0;state.stableat=now end end end
    return wrote
end
toggle.releaseclientgc=function()
    local state=toggle.clientgc;state.cache={};state.bykey={};state.valid=false;state.scanning=false;state.rescanat=nil;state.nextapply=0;state.nextscan=0;state.scanfailures=0;state.applyfailures=0;state.misses=0;state.recoveries=0;state.stableat=nil;state.lastscan=0
end
toggle.applyclient=function(rescan)
    if not toggle.anyclient()then return false end
    if toggle.client.noFall or next(toggle.nofall.originals)then toggle.applynofall(toggle.client.noFall,rescan==true)end
    if toggle.client.towerBarriers then toggle.applytowerbarriers(true,rescan==true)end
    if not toggle.clientneedsgc()then return true end
    local state=toggle.clientgc;local now=tick();local character=lp.Character;local characterkey=toggle.instanceaddress(character)or character
    if characterkey~=state.characterkey then state.character=character;state.characterkey=characterkey;state.cache={};state.bykey={};state.valid=false;state.scanfailures=0;state.applyfailures=0;state.misses=0;state.recoveries=0;state.stableat=nil;state.rescanat=character and math.max(now+1,state.nextscan or 0)or nil end
    if not rescan and now<(state.nextapply or 0)then return true end;state.nextapply=now+0.05
    if rescan==true then if not toggle.refreshclientgc(true)then return false end
    elseif not state.valid then if state.rescanat and character and now>=state.rescanat then if not toggle.refreshclientgc(true)then return false end else return true end end
    local values={}
    if toggle.client.noJumpCooldown then values.canMove=true;values.can_jump=true;values.can_jump2=true;values.lastJump=0;values.handlingSRegen=false;values.regeningS=false end
    if toggle.client.infiniteStamina then values.stamina=state.maxstamina end
    if next(values)~=nil then toggle.clientgcapply(values)end
    local variables=state.bykey.vars or{};for i=1,#variables do local vars=variables[i].value;if type(vars)=="table"then pcall(function()
        if toggle.client.noJumpCooldown then vars.canMove=true;vars.can_jump=true;vars.can_jump2=true;vars.lastJump=0;vars.handlingSRegen=false;vars.regeningS=false end
        if toggle.client.infiniteStamina then vars.stamina=state.maxstamina end
    end)end end
    return true
end
toggle.newdrawing=function(kind)if not toggle.running then assert(false,"drawing session stopped")end;local d=Drawing.new(kind);toggle.drawregistry[d]=true;if kind=="Text"then toggle.textroles[d]={role="hud",size=13}end;return d end
local function newtext(text,color,center,visible,outline)
    local d=toggle.newdrawing("Text")
    d.Text=text or "";d.Color=color or Color3.fromHex("#ffffff");d.Center=center==true;d.Visible=visible==true;d.Outline=false;d.Font=fontvalues[toggle.hudfontindex];d.Size=13
    return d
end
toggle.esptext=function(...)return toggle.settextrole(newtext(...),"esp")end
toggle.uiwidth=function(text,size)return toggle.measuretext(text,toggle.fontvalue("hud"),size or 13)end
toggle.uititles={};toggle.uititleorder={};toggle.uititlecursor=0;toggle.uititle=function(value)
    local text=tostring(value or "");local cached=toggle.uititles[text];if cached then return cached end
    local acronyms={tp="TP",esp="ESP",hud="HUD",gui="GUI",uv="UV",hp="HP",rgb="RGB",fps="FPS",ppms="PPMS",luau="Luau",uv_lamp="UV Lamp"}
    local result=text:gsub("[%a_]+",function(word)local key=string.lower(word);return acronyms[key]or(string.upper(string.sub(word,1,1))..string.lower(string.sub(word,2)))end)
    result=result:gsub("(%d)P%f[%W]","%1p"):gsub("(%d)M%f[%W]","%1m");local slot=toggle.uititlecursor%512+1;toggle.uititlecursor=slot;local expired=toggle.uititleorder[slot];if expired then toggle.uititles[expired]=nil end;toggle.uititleorder[slot]=text;toggle.uititles[text]=result;return result
end
toggle.uiprosetext=function(value)
    local text=tostring(value or""):gsub("%f[%a]tp%f[%A]","TP"):gsub("%f[%a]esp%f[%A]","ESP"):gsub("%f[%a]hud%f[%A]","HUD"):gsub("%f[%a]gui%f[%A]","GUI"):gsub("%f[%a]hp%f[%A]","HP")
    return text:gsub("^(%l)",string.upper):gsub("\n(%l)",function(c)return "\n"..string.upper(c)end)
end
local function newsquare(color,alpha)
    local d=toggle.newdrawing("Square")
    d.Color=color;d.Transparency=alpha;d.Filled=true;d.Visible=false;toggle.setpos(d,0,0);d.Size=Vector2.new(1,1)
    return d
end
local function newline(color)
    local d=toggle.newdrawing("Line")
    d.Color=color;d.Transparency=1;d.Visible=false;d.From=Vector2.new(0,0);d.To=Vector2.new(0,0);d.Thickness=2
    return d
end
local function newborder(color,thickness)
    local d=toggle.newdrawing("Square")
    d.Color=color;d.Transparency=1;d.Filled=false;d.Thickness=thickness or 1;d.Visible=false;toggle.setpos(d,0,0);d.Size=Vector2.new(1,1)
    return d
end
function setz(d,z)if d then pcall(function()d.ZIndex=math.floor(z*256+0.5)end)end;return d end
toggle.iconart={
    resizedown="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEAAAAAAAAAAAAAAAAAAAEBAAAAAAADAAADAAAAAAAAAAAAAAAAAwAAAgAAAAAAEBAAAgAAAAAAAAAAAAACAA8SAAAAAABj6OljAAQAAAAAAAAAAAQAYObqZwAAAAD7////ZwAEAAAAAAAABABm////9QAAAADw//v8/2YABQAAAAAEAGj//Pr/2wAAAABQ+f/8/P9lAAQAAAQAaP/8/P/wOwAAAAAATvz+/P3/ZAAFBABq//z8//Q9AAAAAAAFAFH7/vz9/2MAAGv//fz/9UEABAAAAAAABABR+/78/f9ZYv/8/P/2QwAEAAAAAAAAAAUAUvz+/f////78//hGAAUAAAAAAAAAAAAFAFL9/v3//v3/+EgABQAAAAAAAAAAAAAABQBT/P78/P75SwAEAAAAAAAAAAAAAAAAAAQAVP3///tOAAUAAAAAAAAAAAAAAAAAAAAEAE7U2EwABAAAAAAAAAAAAAAAAAAAAAAAAwABAwACAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    resizeup="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAgAQEQACAAAAAAAAAAAAAAAAAAAAAAAEAGXo6mIABAAAAAAAAAAAAAAAAAAAAAQAaf////9jAAUAAAAAAAAAAAAAAAAABABp//z8/Pz/YQAFAAAAAAAAAAAAAAAEAGj//P3///39/14ABQAAAAAAAAAAAAQAZ//8/P/6/P/8/f9bAAQAAAAAAAAABABn//38//pETf7+/P3+WAAFAAAAAAAEAGf//Pz++k4AAFX9/vz+/lUABQAAAAAAZP/9/P77TwAEBQBU/P78/v1RAAAAAABk//38/vtPAAQAAAUAU/z+/P76TQAAAAD4/fv++1AABQAAAAAFAFL7/vr+5QAAAADz///8UQAEAAAAAAAABABR/P//7gAAAABP1tdNAAQAAAAAAAAAAAQAStPZUwAAAAAAAgIAAgAAAAAAAAAAAAADAAEDAAAAAAADAAADAAAAAAAAAAAAAAAAAwAAAgAAAAAAAQEAAAAAAAAAAAAAAAAAAAEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    house="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAACAAAAAAAAAAAAAAAAAAAAAAAEAAZ7fggABAAAAAAAAAAAAAAAAAAAAQMAL8v//88zAAICAAAAAAAAAAAAAAADAABq9f/6+v/3bwAAAwAAAAAAAAAAAQQAF6v///z///z//68ZAAQBAAAAAAACAQBJ4f/7/v/////++//kTQAAAwAAAAAABIn///v///////////z//40GAAAAAAAwxf/9/f/////////////9/f/INAAAAADn//v///////////////////v/7QAAAAAmpv/8/////////////////P+rJwAAAAAAmP/7/////fv7+/v9////+/+eAAAAAAACnP/7////////////////+/+iAgAAAAAAm//7//3/zI2Pj43J//3/+/+hAAAAAAAAm//7//v/WAAAAABQ//z/+/+hAAAAAAAAm//7//v/YAUJCQVZ//z/+/+hAAAAAAAAmv36//v/XgAEBABX//z/+v2gAAAAAAAAoP/8/fj7WQAAAABS+/n9/P+nAAAAAAAASuP7////9+fo6Of2/////ORPAAAAAAAAAAklP1RmeYWJiYV5ZlU/JgoAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    sun="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAwComgADAAAAAgAAAAAAAAAAAAAAAgAAAgDYyAADAAABAAAAAAAAAAAAAAopAAAAAgCZjQADAQAAKwMAAAAAAAADAD7/bAIDAwIAAAMDAgWS/x0AAgAAAAAAAgWW/xUCAAAKCAAAAjX/cAICAAAAAAAAAAAAJgMAVbvi369AAAklAAAAAAAAAAAAAAABAACO////////agAAAgAAAAAAAAADAwMEAlv/+vz+/fv9/zYCAwMDAwAAAAAAAAABAs/9/P/////7/6YAAwAAAAAAAACju4MAF/L//v/////9/tUBA5S7kQAAAACyzI8AGPP//v/////9/9YAA6HMnwAAAAAAAAABAtH9/P/////7/qkAAwAAAAAAAAADAgIEAWD/+vz+/vv8/zoCAwMCAwAAAAAAAAABAACW////////cgAAAgAAAAAAAAAAAAAAHgIAXcPp5rhHAAgdAAAAAAAAAAAAAgOM/BUBAAAQDgAAAjX/ZwECAAAAAAADAD3/dgIDBAEAAAIDAgec/x0AAgAAAAABAA0zAAAAAgCPgwADAQAANQUAAAAAAAAAAAAAAgAAAgDYyAADAAAAAAAAAAAAAAAAAAEDAAAAAwCyowADAAABAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    image="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+kpmZmpqampqampqampqamZmSPgAAAAD4+ubo5+jo5+fn5+fn5+fn6Ob6+AAAAAD/awAAAAAAAAAAAAAAAAAAAABr/wAAAAD+cAAEAAcAAAAAAAAAAAAABABw/gAAAAD/cAACR96vDAIBAQQFAQAABABw/wAAAAD/cAAArP//MQADAgAAAAEABABw/wAAAAD/cAABOc2cBwIEAFZ4BwACBABw/wAAAAD/cAAFAAAAAAUAdP//ugkABgBw/wAAAAD/cAEGAAMCBQBz//v4/7oIAwFw/wAAAAD/cgAABQAEAHH//P7/+/+5CQBz/wAAAAD/agCm3mIAcf/8/v////v/uwBq/wAAAAD/dKH///+q//7+///////6/6R0/wAAAAD/8v/8/f///v///////////f/z/wAAAAD///3////8//////////////3//wAAAAD+/v/////////////////////+/gAAAAD/+/v7+/v7+/v7+/v7+/v7+/v7/wAAAAD9/////////////////////////AAAAABJmpydnZ2dnZ2dnZ2dnZ2dnZyaSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    eye="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgMAAAAAAAAAAAMCAAAAAAAAAAAAAAADAAAVTXeNjXdNFQAAAwAAAAAAAAAAAAMAHZft////////7ZcdAAMAAAAAAAAAAwBK6f///Pr4+Pr8///pSgADAAAAAAADAEr9//v+/P/////8/vv//UoAAwAAAAABHvH+/P/9/+y/vev//v/8//EeAQAAAAAAqf/7//3/fw8AABSJ//3/+/+pAAAAAAA1/f3//P+BPMRxAwAAjP/8//39NQAAAACe//z+/+wI2v/6DAIDDez//vz/ngAAAADr//78/74AeOiSAgICALz//P7/6wAAAADt//78/7oAAA8AAAACALr//P7/7QAAAACj//z+/+kKBAABAAIDCun//vz/owAAAAA6/v3//P+EAAEDAwAAhP/8//3+OgAAAAAAsP/7//3/fg0AAA1+//3/+/+wAAAAAAABI/X+/f/+/+OysuP//v/9/vUjAQAAAAADAFP///v+/P/////8/vv//1MAAwAAAAAAAwBT7////Pn4+Pn8///vUwADAAAAAAAAAAMAJKP0////////9KMkAAMAAAAAAAAAAAADAAAdWIOamoNYHQAAAwAAAAAAAAAAAAAAAgMAAAAAAAAAAAMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    grid="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACZ////////////////////////igAAAAD/y4mNi4r03IqMjIrk7YqLjYnT/AAAAAD+gQAAAADkrQAAAADA1AAAAACU/wAAAAD/jAQJBATmtAQHBwTF2AQFCASe/wAAAAD/igEGAQHmswEEBAHE1wECBQGc/wAAAAD/hgAAAADlsAAAAADC1gAAAACZ/wAAAAD/7dfZ2Nj789fY2Nf2+dfY2Nfw9QAAAAD/5MTFxMT57cTFxcTx9sTExcTo9gAAAAD/gwAAAADlrwAAAADB1QAAAACW/wAAAAD/iwMIAwPmtAMGBgPF1wMEBwOd/wAAAAD/jAMIAwPmtAMGBgPF2AMEBwOd/wAAAAD/ggAAAADkrgAAAADA1AAAAACW/wAAAAD/3bO2tLT46bO1tbPu87S0tbPi9wAAAAD/8+bm5ub99+bm5ub5++bm5ub19AAAAAD/iAABAADmsgAAAADD1gAAAACa/wAAAAD/igAFAADmswADAwDE1wABBACc/wAAAAD/jAUJBQXmtAUICAXF2AUGCQWe/wAAAAD+gQAAAADkrQAAAADA1AAAAACU/wAAAAD/y4qNi4v03YqNjIrk7YuMjYrT/AAAAACZ////////////////////////igAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    gear="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAgECCMPv7roEAgECAwAAAAAAAAAAAAEAAAUAR/////86AAUAAAEAAAAAAAABAQBKHwAOu/37+/6xCgAjSQABAAAAAAACAI3/9L7e//7///7/2sD2/4EAAwAAAAAAW//6/////v37+/3+////+/9QAAAAAAAAtv77/vz9/P/////9/fz++/+pAAAAAAAAN/z9///9/9iWmNv//f/+/vgtAAAAAAADAKv//P3/kQcAAAma//37/54ABAAAAAADALb/+f/IAAAFBQAA0v/5/6kABAAAAAAAb/n9+v9wAQUAAAUAff/6/fZoAAAAAAC5////+/9lAgQAAAQCcv/7////rwAAAAD//P7//P+qAAYDBAUAt//8//78/AAAAADc/vr8//39VgAAAABg//3//Pr+0AAAAACQ/////v7+/5xRU6D//v7+////ggAAAAAJNlay//3///////////3/qVM0BwAAAAAAAAAG1v79/vv7+/v//f/NAQAAAAAAAAABAgYAu/78//3///3//P6uAAYCAQAAAAAAAAAB4v/6/f/3+P/9+v/XAQEAAAAAAAAAAAIBg/f//6gbHrH///V7AAIAAAAAAAAAAAABADGjnAAAAAOjoC0AAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    target="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAADbyAAAAAMAAAAAAAAAAAAAAAAAAgAHQYT/+3o7AgADAAAAAAAAAAAAAAEBAF3U///9////zFAAAgAAAAAAAAAAAQMCnP//3Kf/+qXk//+JAAMBAAAAAAAAAwCc//h2CwDo1gARhP//hAADAAAAAAADAFb/9ksAAAIZFQMAAGD8/z8AAwAAAAACBtf/eAAGAQIAAAEBBgCS/78BAwAAAAAAO//gBQQBAAAAAAAAAgMT8P0kAAAAAAAAff6gCQABAReZkRABAQALuv9lAAAAAADJ+P7z6lEBAKf//5EAAWns9P32swAAAADc//76+lsAAK///5oAAHX8+v3/xQAAAAAFiP6kFwABAR+rpBYBAQAYvP9wAgAAAAAAPv/aAAQBAAAAAAAAAgMM7P4mAAAAAAACCNz/cQAGAQEAAAEBBgCL/8UCAwAAAAAEAF3/80UAAQRdUwQAAFn6/0UAAwAAAAAAAwCi//ZxCQj/9QAPf/3/igADAAAAAAAAAQIEof//26X69KPi//+OAAMBAAAAAAAAAAEBAGDU///+////zFMAAgAAAAAAAAAAAAABAgAHQYT/+3o7AgACAAAAAAAAAAAAAAAAAAMAAADbyAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    sword="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABACY8vL08/PscwAAAAAAAAAAAAAAAAAEAHH/////////6QAAAAAAAAAAAAAAAAMARf/8/v////7+6AAAAAAAAAAAAAAAAgAf6/79//////7/6AAAAAAAAAAAAAABAwbK//z///////7/6AAAAAAAAAAAAAAEAJ7/+/z+//////7/5gAAAAAAAAAAAAQAbf/6/v////////3+7wAAAAAAAQMAAwBA/fr9/6no//7//f//gwAAAAAAAAABARvo/fr/awC4//z8//lhAAAAAAAAKbEPAMf/+f9sAID+/fv/4DoAAwAAAAAASv9ci//4/24Aff/8+/+9GQAEAAAAAAACC77///z/cAB7//n+/5IDAAMAAAAAAAACAg7C//lmAHj/+P/6ZgABAgAAAAAAAAAAAAAFv/9Zav/3/+I9AAQBAAAAAAAAAAAAOKsqBMT///3/wRsABAAAAAAAAAAAAACf///lJgTA//iJAAADAAAAAAAAAAAAAAD9/vn/5C0MwP9bGAQBAAAAAAAAAAAAAABx//35/7EADLz/uQADAAAAAAAAAAAAAAAAbv///zgBAARGKAABAAAAAAAAAAAAAAAEAHLtoQECAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    skull="AAAAAAAAAAEDAwAAAAADAwEAAAAAAAAAAAAAAAAAAgAAAAEODgEAAAACAAAAAAAAAAAAAAADAABMn9Xx8dWfTAAAAwAAAAAAAAAAAAMAL7/////09f///74vAAMAAAAAAAAAAwBG8f/cdDASEzB03P/wRgADAAAAAAACACzy/54PAAAAAAAAEJ7/8isAAgAAAAACA8T/nwAABAIBAQIEAACf/8MCAgAAAAMASf/dCwEDAQAAAAABAwEM3v9IAAMAAAMAof5yAAcAAAIAAAIAAAYAc/6gAAMAAQAD1/8tAQAGBgAAAAAGBgABLv/WAwABAQAO8PYWAFPc3FMAAFLc3FQAFvbvDgABAQAO8PcRBOf//+cGB+f//+cEEvfvDgABAQAD1v8rBOj//+YHB+b//+gELP/WAwABAAMAof51AFTb3FMAAFHb3FYAdv6gAAMAAAMASP/eDAAHBgACAgAGBwAM3/9IAAMAAAACAsP/oQYBAAfCwgcAAQai/8ICAgAAAAACACrq/18BAWH//2EBAV//6ikAAgAAAAABAAXh+S0AAFLo6FIAAC364AUAAQAAAAABAAzs+D8BAgAPDwACAUD46wwAAQAAAAAAAwCP//+4AgAAAAACuP//jgADAAAAAAAAAQEHk/32IA8REQ8g9v2SBwEBAAAAAAAAAAEAAOb/8/T09PTz/+UAAAEAAAAAAAAAAAADAlHZ7O7v7+7s2VACAwAAAAAAAAAAAAAAAQAHERAQEBARBwABAAAAAAAA",
    minus="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEBAQEBAQEBAQEBAQEBAQEBAAAAAAADAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAAABA0MDAwMDAwMDAwMDAwMDA0EAAAAAABc2Ofm5+fn5+fn5+fn5+fn5ufYXAAAAAD7////////////////////////+wAAAADt////////////////////////7QAAAAA+uMfIycnJycnJycnJycnJyMe4PgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAgEBAQEBAQEBAQEBAQEBAQECAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    plus="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACADjZ1DEBAgAAAAAAAAAAAAAAAAAAAAADALf//6oAAwAAAAAAAAAAAAAAAAAAAAACAMX+/roAAgAAAAAAAAAAAAAAAAAAAAACAML//7cAAgAAAAAAAAAAAAAAAAAAAAACAMP//7gAAgAAAAAAAAAAAAAAAAAAAAACAMP//7gAAgAAAAAAAAAAAAACAwICAgIEAsT//7kCBAICAgIDAgAAAAAAAAAAAAAAAMD//7UAAAAAAAAAAAAAAAA+rbu6urq7uu///+y6u7q6ubynKgAAAADw////////////////////////zwAAAAD1////////////////////////1AAAAABFt8LDw8PEw/H//+7DxMPDwsKwMAAAAAAAAAAAAAAAAMH//7UAAAAAAAAAAAAAAAADAgICAgIEAsP//7kCBAICAgIDAgAAAAAAAAAAAAACAMP//7gAAgAAAAAAAAAAAAAAAAAAAAACAMP//7gAAgAAAAAAAAAAAAAAAAAAAAACAML//7cAAgAAAAAAAAAAAAAAAAAAAAACAMT+/rkAAgAAAAAAAAAAAAAAAAAAAAADALz//7AAAwAAAAAAAAAAAAAAAAAAAAADAEbt6j4AAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    target="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAADbyAAAAAMAAAAAAAAAAAAAAAAAAgAHQYT/+3o7AgADAAAAAAAAAAAAAAEBAF3U///9////zFAAAgAAAAAAAAAAAQMCnP//3Kf/+qXk//+JAAMBAAAAAAAAAwCc//h2CwDo1gARhP//hAADAAAAAAADAFb/9ksAAAIZFQMAAGD8/z8AAwAAAAACBtf/eAAGAQIAAAEBBgCS/78BAwAAAAAAO//gBQQBAAAAAAAAAgMT8P0kAAAAAAAAff6gCQABAReZkRABAQALuv9lAAAAAADJ+P7z6lEBAKf//5EAAWns9P32swAAAADc//76+lsAAK///5oAAHX8+v3/xQAAAAAFiP6kFwABAR+rpBYBAQAYvP9wAgAAAAAAPv/aAAQBAAAAAAAAAgMM7P4mAAAAAAACCNz/cQAGAQEAAAEBBgCL/8UCAwAAAAAEAF3/80UAAQRdUwQAAFn6/0UAAwAAAAAAAwCi//ZxCQj/9QAPf/3/igADAAAAAAAAAQIEof//26X69KPi//+OAAMBAAAAAAAAAAEBAGDU///+////zFMAAgAAAAAAAAAAAAABAgAHQYT/+3o7AgACAAAAAAAAAAAAAAAAAAMAAADbyAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    heart="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQIAAAAAAAADAwAAAAAAAAIBAAAAAAABAAAycot9TQoAAApNfYtyMgAAAQAAAAAADKP//////91RUd3//////6MMAAAAAAAFuf/9+/v7/P/////8+/v7/f+5BQAAAABz//r///////3+/v3///////r/cwAAAADb/f3///////////////////392wAAAAD7////////////////////////+wAAAAD6////////////////////////+QAAAADY/v3///////////////////3+2AAAAACI//z///////////////////z/iAAAAAAc8P3+/////////////////v3wHAAAAAAAcf/6////////////////+v9xAAAAAAADAbb/+v/////////////6/7YBAwAAAAABAQ7L//r///////////r/yw4BAQAAAAAAAgATxv/6/v/////++v/GEwACAAAAAAAAAAIAC6r//vz///z+/6oLAAIAAAAAAAAAAAACAAB4+//7+//7eAAAAgAAAAAAAAAAAAAAAQIAOcr//8o5AAIBAAAAAAAAAAAAAAAAAAADAANkZAMAAwAAAAAAAAAAAAAAAAAAAAAAAwAAAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    person="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAfO/EfzwKAAAAAAAAAAAAAAAAAAAAAQAL6/////3dcgECAAAAAAAAAAAAAAAAAwA8//39/P7/8woAAQAAAAAAAAAAAAAABAB9//v///z9wwEBAAAAAAAAAAAAAAAAAgC+/vz///v/ggAEAAAAAAAAAAAAAAABAAry//v7/fz+QQADAAAAAAAAAAAAAAAAAgKF7v/////zDgABAAAAAAAAAAAAAAAAAAMAGU+QzfGGAwUAAAAAAAAAAAAAAAAAAgAAAAAAAAMAAAACAAAAAAAAAAAAAAACADmTp6qsqKOokzkAAgAAAAAAAAAAAAMAWf7///////////5ZAAMAAAAAAAAAAQEL6f/5+/v7+/v7+f/pCwEBAAAAAAAAAwA4//3///////////3/OAADAAAAAAAABABr/vv///////////v+bAAEAAAAAAAAAwCi//v///////////v/owADAAAAAAAAAQHU//3///////////3/1AEBAAAAAAACAB/1/v7///////////7+9R8AAgAAAAADAEL//vz9/v/////+/fz+/0IAAwAAAAABAQ2i/f/////////////9og0BAQAAAAAAAAAAOo3F5fb+/vblxY06AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    search="AAAAAAAAAAMEAAAAAAQDAAAAAAAAAAAAAAAAAAACAAAAAA0NAAAAAAIAAAAAAAAAAAAAAAMAAEqe0+/v055KAAADAAAAAAAAAAAAAwAtvf////b2////vi0AAwAAAAAAAAADAETv/911MRQUMXXd/+9EAAMAAAAAAAIAKvH/nxAAAAAAAAAQoP/xKQACAAAAAAICwv+hAAAEAgEBAgQAAKH/wQICAAAAAwBI/94MAQMAAAAAAAADAQze/0cAAwAABACg/nMABAAAAAAAAAAABAB0/p8ABAAAAALW/y4BAwAAAAAAAAAAAwEu/9UCAAEAAA3v9xQAAQAAAAAAAAAAAQAU9+4NAAEAAA3v9xQAAQAAAAAAAAAAAQAU9+4NAAEAAALW/y4BAwAAAAAAAAAAAwEu/9UCAAEABACg/nMABAAAAAAAAAAABAB0/p8ABAAAAwBH/98MAQMAAAAAAAADAQzg/0cAAwAAAAICwv+hAAAEAgEBAgQAAKT/vQQCAAAAAAIAKvH/oBEAAAAAAAARov/6PQAFAAAAAAADAETu/952MRQUMXbf////yBcAAwAAAAAAAwAsvP////b2////vEfK/80XAAEAAAAAAAMAAEmc0u7u0pxKAAAXzP/NFgACAAAAAAACAQAAAA0NAAAAAAQAFsz/zQYBAAAAAAAAAAMDAAAAAAMDAAADABbJxQYBAAAAAAAAAAAAAQEBAQAAAAAAAgABAQABAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAA",
    zap="AAAAAAAAAAAAAAACAAARAAAAAAAAAAAAAAAAAAAAAAAAAAMAJbnquiMAAgAAAAAAAAAAAAAAAAAABAAn4f/8/8ICAgAAAAAAAAAAAAAAAAAEACff/68v+PMNAAEAAAAAAAAAAAAAAAQAJ9//vAZF/8QCAQAAAAAAAAAAAAAABAAn3/+6DACs/24ABAAAAAAAAAAAAAAEACff/7kKABfx+SEBAwAAAAAAAAAAAAQAJ9//uQoCAV7/tQAAAAECAAAAAAAAAwAn3/+5CgAFAbb9aRATEAAAAAAAAAACACff/7kKAAMADPT/8vPy8b4kAAIAAAIBJuH/ugsBAwACAYfr8PP09P/BAgIAAAICwP+xBgAAAAIAAAAPEBINK/byDgABAQAO8/YrDRIQDwAAAAIAAAAGsf++AgIAAAICwv/09PPw7IgBAgADAQu6/+EmAQIAAAIAJL3x8vPy//UMAAMACrn/3ycAAgAAAAAAAAAQExBo/bYBBQAJuP/gKAADAAAAAAAAAgEAAAC0/14BAgm4/+AoAAQAAAAAAAAAAAADASH58RcACbj/4CgABAAAAAAAAAAAAAAEAG3/rAALuP/gKAAEAAAAAAAAAAAAAAABAsT/RAa7/98oAAQAAAAAAAAAAAAAAAEADvP3L6//3ycABAAAAAAAAAAAAAAAAAACAsL//P/hJwAEAAAAAAAAAAAAAAAAAAACACO66bckAAMAAAAAAAAAAAAAAAAAAAAAAAAAEQAAAgAAAAAAAAAAAAAA",
    circlealert="AAAAAAABBAAAAAMODgMAAAAEAQAAAAAAAAAAAAIAABljqNTq6tSrZhkAAAIAAAAAAAAAAgAJgez////39////+2BCQACAAAAAAACACPK//+wWyoUFCtbsP//yiQAAgAAAAIAIuD/zj4AAAAAAAAAAD3O/+EjAAIAAQMKzf+4DgADAwIAAAIDAwAOuP/NCgMBAwCB/9AMAAQAAAACAgAAAAQADNH/gAADABfw+zkABAABAQXBwQUBAQAEADn78BcAAGf/sgADAAABABD8/BAAAQAAAwCz/2cAAKz+WAEEAAABAA/x8Q8AAQAABAFZ/qwABNb/KAACAAABAA/x8Q8AAQAAAgAo/9YEDur4EwABAAABABD8/BAAAQAAAQAU+OoODur4EwABAAABAQXBwQUBAQAAAQAU+OoOBNb/KAACAAAAAAABAQAAAAAAAgAo/9YEAKz+WAEEAAAAAAAAAAAAAAAABAFZ/qwAAGf/swADAAABAQbJywYBAQAAAwCz/2YAABfw+zoABAABAQbJywYBAQAEADr78BcAAwCA/9ENAAQAAAABAQAAAAQADdH/gAADAQMKzf+4DwADAwIAAAIDAwAOuP/NCQMBAAIAIuD/zz4AAAAAAAAAAD7O/+AiAAIAAAACACPK//+xXCsUFCtcsP//ySMAAgAAAAAAAgAJgOz////39////+2ACQACAAAAAAAAAAIAABljqNTq6tSqZhkAAAIAAAAAAAAAAAABBAAAAAMODgMAAAAEAQAAAAAA",
    trianglealert="AAAAAAAAAAAAAQMAAAMBAAAAAAAAAAAAAAAAAAAAAAAAAAAMDAAAAAAAAAAAAAAAAAAAAAAAAAECCJTp6ZEHAgEAAAAAAAAAAAAAAAAAAAMAl//+//+SAAMAAAAAAAAAAAAAAAAAAwAz+/MzOPT6LwADAAAAAAAAAAAAAAAAAwC8/4gAAI3/uAADAAAAAAAAAAAAAAADAFL/5BECAhTn/04AAwAAAAAAAAAAAAECCdj/ZAAGBgBp/9UIAgEAAAAAAAAAAAMAdv/MBQjBwQcGz/9xAAQAAAAAAAAAAgEa7f5DABP7+xMAR//rGAECAAAAAAAAAwCa/6wAAA/x8Q8BALD/lgADAAAAAAADADP69SYBAA/x8Q8AASn2+TAAAwAAAAADALz/iAAFABD8/BAABACN/7gAAwAAAAMAUv/kEQICAQXBwQUBAgIT5/9OAAMAAQIJ2P9kAAMAAAABAQAAAAQAaP/VCAIBAwB2/8sEAgEAAAAAAAAAAAECBc//cgADABru/kIAAwABAQbJywYBAQADAEb/7BgBAJT/rQAEAQECAgfKzAgCAgEBBACy/5AADun5HwAAAAAAAAAAAAAAAAAAAAAk++QLDur2PRARDw8PDxAODhAPDw8PERBB+eYLAJH///Pz8/Pz8/Pz8/Pz8/Pz8/P//4sAAQiT5PLz9PT09PT09PT09PT08/LjkAcBAAAACQ8PDw8PDw8PDw8PDw8PDw8JAAAAAAEDAAAAAAAAAAAAAAAAAAAAAAAAAwEA",
    minimize="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMDAAAAAAAAAwMAAAAAAAAAAAAAAAEBBcLCBQEBAQEFwsIFAQEAAAAAAAAAAAEAEPv7EAABAQAQ+/sQAAEAAAAAAAABAQIBEfHxDwABAQAP8fERAQIBAQAAAAAAAAAABvL0EAABAQAQ9PIGAAAAAAAAAQAADxEPQ/jqCQABAQAK6vhDDxEPAAABAQfD8/Hz//+PAAMAAAMAj///8/HzwwcBAQfD8/Dx448HAQEAAAEBB4/j8fDzwwcBAQAADw8PCQAAAAAAAAAAAAAJDw8PAAABAAAAAAAAAAMBAAAAAAAAAQMAAAAAAAAAAAABAQEBAQAAAAAAAAAAAAABAQEBAQAAAAABAQEBAQAAAAAAAAAAAAABAQEBAQAAAAAAAAAAAAMBAAAAAAAAAQMAAAAAAAAAAQAADw8PCQAAAAAAAAAAAAAJDw8PAAABAQfD8/Dx448HAQEAAAEBB5Dj8fDzwwcBAQfD8/Hz//+PAAMAAAMAkP//8/HzwwcBAQAADxEPQ/jqCgABAQAK6vhCDxEPAAABAAAAAAAABvL0EAABAQAQ8/IGAAAAAAAAAAABAQIBEfHxDwABAQAP8fERAQIBAQAAAAAAAAEAEPv7EAABAQAQ+/sQAAEAAAAAAAAAAAEBBcLCBQEBAQEFwsIFAQEAAAAAAAAAAAAAAAMDAAAAAAAAAwMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    maximize="AAABAwAAAAAAAAAAAAAAAAAAAAADAQAAAAAAAAkPDw8AAAAAAAAAAA8PDwkAAAAAAQEHkeTy8fTDBwEBAQEHw/Tx8uSQBwEBAwCR///z8fPCBwEBAQEHwvPx8///kAADAArr+EIPEQ8AAAEAAAEAAA8RD0P46woAABD08gYAAAAAAAAAAAAAAAAAAAby9RAAAA/y8REBAgEBAAAAAAAAAQECARHx8g8AABD8+xAAAQAAAAAAAAAAAAABABD7/BAAAQXCwQUBAQAAAAAAAAAAAAABAQXBwgUBAAADAwAAAAAAAAAAAAAAAAAAAAADAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQAAAAAAAAAAAAAAAAAAAAABAQAAAAABAQAAAAAAAAAAAAAAAAAAAAABAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAwAAAAAAAAAAAAAAAAAAAAADAwAAAQXCwQUBAQAAAAAAAAAAAAABAQXBwgUBABD8+xAAAQAAAAAAAAAAAAABABD7/BAAAA/y8REBAgEBAAAAAAAAAQECARHx8g8AABD08gYAAAAAAAAAAAAAAAAAAAby9BAAAArr+EMPEQ8AAAEAAAEAAA8RD0P46wkAAwCQ///z8fPCBwEBAQEHwvPx8///jwADAQEHj+Ty8fTDBwEBAQEHw/Tx8uSPBwEBAAAAAAkPDw8AAAAAAAAAAA8PDwkAAAAAAAABAwAAAAAAAAAAAAAAAAAAAAADAQAA",
    moon="AAAAAAAAAAEEAwAAAgAAAAAAAAAAAAAAAAAAAAAAAwAAAAQNAAAAAAAAAAAAAAAAAAAAAAACAAxcp9fqhwECAAAAAAAAAAAAAAAAAQEAXNr/////9wwAAQAAAAAAAAAAAAABAwCT///FXKD+pQEDAAAAAAAAAAAAAAADAJP/9GUAAMj/OwADAAAAAAAAAAAAAAMAWP/xQQAAEfD3FAABAAAAAAAAAAAAAQEM4P9jAAcADe73FAABAAAAAAAAAAAABABc/8cABAEBAc7/OwIEAAAAAAABAAAAAwCr/mIABAAEAIX/qgAEAwEBAwIAAgAAAATb/ykAAgACAB7x/3UAAAAAAAAOAAAAAA7x9RIAAQAAAgBb//+oQhYXQqbqhwECAA7y9RIAAQAAAAMAXO3///f3////8wwAAATb/ykAAgAAAAADAB6Cyu3uxp/+2AQAAwCr/mEABAAAAAAAAwAAAA0RAFT+qQADBABc/8cABAEAAAAAAAIEAAAAAcz/WgAEAQEM4P9kAAYAAAAAAAAAAQcAZv/fCwEBAAMAV//xQgACBAIBAQIEAgBD8v9WAAMAAAADAJP/9WUAAAAAAAAAAGb1/5EAAwAAAAABAwCS///DZS0TEy1lxP//kQADAQAAAAAAAQEAW9r////19f///9laAAIBAAAAAAAAAAACAAxbptfx8demWwwAAgAAAAAAAAAAAAAAAwAAAAIODgIAAAADAAAAAAAAAAAAAAAAAAEEAwAAAAADBAEAAAAAAAAA"
}
toggle.iconart.circlequestion="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAARSotTq6c+aRwAAAwAAAAAAAAAAAAIATMz//////////8E9AAMAAAAAAAABAwCG///9/Pv6+vr8/v//cQAEAAAAAAADAIn/+/3//f///////vz9/28AAwAAAAAAT//6/v///8SAdKX4//7+/P83AAAAAAAK2/79//32aAAAAAA88v7+/P/EAgAAAABf//3//v7sHS/E0EgAqf/7//3/QgAAAAC4/vz///7/7+///50Anf/7//z/mQAAAADo//7////+////1h0O4v79//3/zwAAAAD8////////+/3QFA7C//3///7/5gAAAAD9/////////f8jANb//P////7/5wAAAADr//7////+//5iiv/7//////3/0gAAAAC+/v3///////////3///////z+oAAAAABp//3////+/+8tU//+//////3/SwAAAAAP5P39///+/+sFMv/+/////P7PBQAAAAAAXv/6//////7t8P/////++/9EAAAAAAADAJz/+v3///////////37/4MAAwAAAAABAgGc///8/f7+/v79/f//hgADAAAAAAAAAQEAYd3//////////9NRAAMAAAAAAAAAAAECABFqu+n8++WzYAkAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
toggle.iconart.giftbox="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAbKtZaqxaAAEAAAAAAAAAAAACBAQEBgB2//f///f/WAAHBAQEAQAAAAAAAAAAAAHa0gDmuwDvuAEAAAAAAAAAAAAga29xUgCd/63v4LH/ewBgcW9pGQAAAADg////+RkRoP////+QBy3/////0QAAAAD/+/v4/7cAaP+Vq/9LANH9+Pv79wAAAAD//v/9/uYAWIUAAJBDBPj+/v/+9QAAAADz//////9uAABbSgAAiP//////5QAAAAAeIyAhICElAAA2LQAAJyEhISAkHAAAAAAAPklISEhIUlMAC1NRR0hIR0k3AAAAAABG//////////8mSP//////////KQAAAABL/fv8/Pz8+/wiQfz5/Pz8/Pz7LgAAAABK//7//////v8iQv/8///////8LQAAAABK//7//////v8iQv/8///////8LQAAAABK//7//////v8iQv/8///////8LQAAAABK//7//////v8iQv/8///////8LQAAAABJ/v7//////v8iQv/8///////6LQAAAABN//39/Pz8+/wiQfz5/Pz8/f7/LgAAAAAc3P////////8kRf/////////IDQAAAAAAFkpieYyapKsXLayimIp2X0YOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
toggle.iconart.ellipsis="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAwQDAQAAAAMDBAIAAAACAwQDAQAAAAAAAAAAAAEAAAAAAAABAAAAAAAAAAAAAAAMlJxWGAACAGynaCsAAgA8qn07AwAAAABg////6iwAHP////1lAQDG////sgAAAACo+vj6/0gAV/z49/+QABvv+/n+5AAAAADu//r76hEAmP/6+f9KAE7//vj8mgAAAACK7f//swABSd////MTAR3G/P//TQAAAAAAFEt2IAACAAk3c0IAAgAAKGhjAwAAAAACAAAAAAAAAgAAAAABAAEAAAAAAAAAAAAAAQMEAgAAAAEDBAMAAAAAAgQEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
toggle.iconmasks={};toggle.iconcache={};toggle.iconcacheorder={};toggle.iconcachecursor=0;toggle.iconstates=setmetatable({},{__mode="k"})
toggle.iconbase64=function(s)
    if base64decode then local ok,out=pcall(base64decode,s);if ok and type(out)=="string"and#out>0 then return out end end
    local map=toggle.iconb64;if not map then map={};local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";for i=1,64 do map[string.byte(chars,i)]=i-1 end;toggle.iconb64=map end
    s=string.gsub(s,"[^%w+/=]","");local out={}
    for i=1,#s,4 do
        local a,b,c,d=string.byte(s,i,i+3);a,b,c,d=map[a],map[b],map[c],map[d]
        if a and b then local first=a*4+math.floor(b/16);if c then local second=(b%16)*16+math.floor(c/4);out[#out+1]=d and string.char(first,second,(c%4)*64+d)or string.char(first,second)else out[#out+1]=string.char(first)end end
    end
    return table.concat(out)
end
toggle.iconpng=function(w,h,pixels)
    local crc=toggle.iconcrc;if not crc then crc={};for i=0,255 do local c=i;for _=1,8 do c=bit32.band(c,1)==1 and bit32.bxor(0xEDB88320,bit32.rshift(c,1))or bit32.rshift(c,1)end;crc[i]=c end;toggle.iconcrc=crc end
    local function be32(n)return string.char(math.floor(n/16777216)%256,math.floor(n/65536)%256,math.floor(n/256)%256,n%256)end
    local function sum(s)local c=0xFFFFFFFF;for i=1,#s do c=bit32.bxor(bit32.rshift(c,8),crc[bit32.band(bit32.bxor(c,string.byte(s,i)),255)])end;return bit32.bxor(c,0xFFFFFFFF)end
    local function chunk(tag,data)return be32(#data)..tag..data..be32(sum(tag..data))end
    local a,b=1,0;for i=1,#pixels do a=(a+string.byte(pixels,i))%65521;b=(b+a)%65521 end
    local blocks,at={},1;while at<=#pixels do local length=math.min(65535,#pixels-at+1);local remaining=65535-length;blocks[#blocks+1]=string.char(at+length>#pixels and 1 or 0,length%256,math.floor(length/256)%256,remaining%256,math.floor(remaining/256)%256)..string.sub(pixels,at,at+length-1);at=at+length end;local packed=string.char(120,1)..table.concat(blocks)..be32(b*65536+a)
    return string.char(137,80,78,71,13,10,26,10)..chunk("IHDR",be32(w)..be32(h)..string.char(8,6,0,0,0))..chunk("IDAT",packed)..chunk("IEND","")
end
toggle.icondata=function(name,c)
    local r=math.floor(clamp(c.R,0,1)*31+0.5);local g=math.floor(clamp(c.G,0,1)*31+0.5);local b=math.floor(clamp(c.B,0,1)*31+0.5);local key=name..":"..r..":"..g..":"..b
    local cached=toggle.iconcache[key];if cached then return cached,key end
    local mask=toggle.iconmasks[name];if not mask then mask=toggle.iconbase64(toggle.iconart[name]or"");toggle.iconmasks[name]=mask end
    r=math.floor(r*255/31+0.5);g=math.floor(g*255/31+0.5);b=math.floor(b*255/31+0.5)
    local rows,at={},0;for _=1,24 do local line={string.char(0)};for x=1,24 do at=at+1;line[#line+1]=string.char(r,g,b,string.byte(mask,at)or 0)end;rows[#rows+1]=table.concat(line)end
    local data=toggle.iconpng(24,24,table.concat(rows));local slot=toggle.iconcachecursor%384+1;toggle.iconcachecursor=slot;local old=toggle.iconcacheorder[slot];if old then toggle.iconcache[old]=nil end;toggle.iconcacheorder[slot]=key;toggle.iconcache[key]=data;return data,key
end
toggle.newicon=function(z)local d=toggle.newdrawing("Image");d.Visible=false;toggle.setpos(d,0,0);d.Size=Vector2.new(1,1);d.Transparency=1;setz(d,z);return d end
toggle.seticon=function(d,name,x,y,size,c,a,on)
    if not d or toggle.removeddraw[d]then return end;if not on or not name then toggle.setvisible(d,false);return end
    local state=toggle.iconstates[d]or{};local now=toggle.frametime or tick();local key=name..":"..math.floor(clamp(c.R,0,1)*31+0.5)..":"..math.floor(clamp(c.G,0,1)*31+0.5)..":"..math.floor(clamp(c.B,0,1)*31+0.5)
    if toggle.iconframe~=now then toggle.iconframe=now;toggle.iconuploads=0 end
    if(state.key~=key or state.revision~=(toggle.iconrevision or 0))and(toggle.iconuploads or 0)<6 and(state.name~=name or now>=(state.nextcolor or 0))then
        local data,colorkey=toggle.icondata(name,c);d.Data=data;state.key=colorkey;state.name=name;state.revision=toggle.iconrevision or 0;state.nextcolor=now+0.08;toggle.iconuploads=(toggle.iconuploads or 0)+1
    end
    local px,py=math.floor((tonumber(x)or 0)*2+0.5)/2,math.floor((tonumber(y)or 0)*2+0.5)/2
    if state.x~=px or state.y~=py then toggle.setpos(d,px,py);state.x=px;state.y=py end;if state.size~=size then d.Size=Vector2.new(size,size);state.size=size end;if state.alpha~=a then d.Transparency=a;state.alpha=a end
    toggle.iconstates[d]=state;toggle.setvisible(d,state.key~=nil)
end
local function remove(d)
    if not d or toggle.removeddraw[d]then return end
    toggle.removeddraw[d]=true;toggle.drawregistry[d]=nil;toggle.iconstates[d]=nil;toggle.drawcolors[d]=nil;toggle.textroles[d]=nil;if toggle.playerprops then toggle.playerprops[d]=nil end;pcall(function()d.Visible=false;d:Remove()end)
end
local function hide(d)if d and not toggle.removeddraw[d]and d.Visible then d.Visible=false end end
toggle.setvisible=function(d,value)if d and not toggle.removeddraw[d]and d.Visible~=(value==true)then d.Visible=value==true end end
local function anchors()
    local v=cam.ViewportSize
    return Vector2.new(v.X/2,v.Y-80),Vector2.new(v.X-200,v.Y-100)
end
local timertxt=newtext("0:00",Color3.fromHex("#ffffff"),true,true)
local scraptxt=newtext("0",Color3.fromHex("#ffffff"),true,true)
local targettxt=newtext("none",Color3.fromHex("#ffffff"),true,true)
local timerlabel=newtext("Timer",Color3.fromHex("#aaaaaa"),true,true)
local scraplabel=newtext("Scrap",Color3.fromHex("#aaaaaa"),true,true)
local targetlabel=newtext("Target",Color3.fromHex("#aaaaaa"),true,true)
toggle.powerdraw={value=newtext("0",Color3.fromHex("#ffffff"),true,true),label=newtext("Power",Color3.fromHex("#aaaaaa"),true,true)}
toggle.cooldowndraw={value=newtext("0s",Color3.fromHex("#ffffff"),true,false),label=newtext("Cooldown",Color3.fromHex("#aaaaaa"),true,false)}
toggle.hudvaluedraws={timertxt,targettxt,scraptxt,toggle.powerdraw.value,toggle.cooldowndraw.value};toggle.hudlabeldraws={timerlabel,targetlabel,scraplabel,toggle.powerdraw.label,toggle.cooldowndraw.label}
toggle.rakedraw={name=toggle.esptext("rake",toggle.rakestyle.labelcolor,true,false),health=toggle.esptext("400",toggle.rakehealthstyle.labelcolor,true,false),distance=toggle.esptext("0m",toggle.distancestyle.labelcolor,true,false)}
for _,d in pairs(toggle.rakedraw)do setz(d,8)end

local powerlabel=newtext("Activity",Color3.fromHex("#ffffff"),false,false)
local rooflabel=toggle.esptext("roof",Color3.fromHex("#f5d3ff"),true,false)
local roofhp=toggle.esptext("",Color3.fromHex("#ebebeb"),true,false)
setz(rooflabel,8);setz(roofhp,8)
toggle.notify=function(text,tint)
    local raw=tostring(text or""):gsub("^enabled (.+)$","%1 enabled"):gsub("^disabled (.+)$","%1 disabled"):gsub("^armed (.+) bind$","%1 ready"):gsub("^rake is ","rake "):gsub("^player already owns ","already own "):gsub("^teleported to ","at ");raw=toggle.uititle(raw):gsub("(%d)P%f[%W]","%1p"):gsub("(%d)M%f[%W]","%1m");local state=toggle.notifications;local now=tick();for i=1,#state.items do local item=state.items[i];if item.base==raw then item.count=(item.count or 1)+1;item.started=now;item.duration=toggle.notifysettings.duration;item.color=tint;local repeated=raw.." x"..tostring(item.count);local shown,longest,lines=repeated,#repeated,1;if toggle.wraptooltip then shown,longest,lines=toggle.wraptooltip(repeated,38)end;item.text=shown;item.lines=lines;item.width=math.max(240,math.min(340,longest*7+36));item.height=math.max(64,lines*(toggle.menulineheight+3)+42);return end end
    local shown,longest,lines=raw,#raw,1;if toggle.wraptooltip then shown,longest,lines=toggle.wraptooltip(raw,38)end;state.items[#state.items+1]={base=raw,count=1,text=shown,lines=lines,color=tint,width=math.max(240,math.min(340,longest*7+36)),height=math.max(64,lines*(toggle.menulineheight+3)+42),started=now,duration=toggle.notifysettings.duration,anim=0,x=nil,y=nil}
    while #state.items>state.max do table.remove(state.items,1)end
end
toggle.notifyevent=function(kind,text,tint)if toggle.notifysettings.types[kind]then toggle.notify(text,tint)end end
local function bindlog(text,kind)
    toggle.notifyevent(kind or"menu",text)
end
local barseg,rgbwidth,rgbspeed,rgbspread=144,420,0.6,0.28
local function rgb(offset)
    offset=offset or 0
    local frame=toggle.gradientcache and toggle.gradientcache.frame or-1
    if offset==0 and toggle.rgbbaseframe==frame and toggle.rgbbase then return toggle.rgbbase end
    local value=Color3.fromHSV(((toggle.chromaphase or(tick()*toggle.chromaspeed))+offset)%1,toggle.chromasaturation,1)
    if offset==0 then toggle.rgbbaseframe=frame;toggle.rgbbase=value end
    return value
end
local rgbline={_count=barseg,_z=13}
local themes={
    {name="signal bruise",bg="#151426",top="#090812",side="#102b27",card="#25213c",hover="#393158",select="#574b7b",text="#f8efff",muted="#9a8db4",accent="#ff4fd8"},
    {name="monochrome",bg="#191919",top="#151515",side="#151515",card="#242424",hover="#303030",select="#434343",text="#EEEEEE",muted="#969696",accent="#fe9af4"},
    {name="acid arcade",bg="#100b1b",top="#07040d",side="#160629",card="#23103a",hover="#3b1260",select="#641d8c",text="#f4ffbd",muted="#9a72b8",accent="#b7ff00"},
    {name="mango circuit",bg="#201407",top="#120a03",side="#291006",card="#38220b",hover="#56330c",select="#7f4b0d",text="#fff4cf",muted="#c29352",accent="#ff9d00"},
    {name="ice pop",bg="#071c2e",top="#03101d",side="#07152a",card="#0d304a",hover="#124765",select="#176983",text="#e8fbff",muted="#69a7bd",accent="#00eaff"},
    {name="alien bloom",bg="#10180b",top="#080d05",side="#171023",card="#1c2b10",hover="#2e4715",select="#486b1d",text="#efffda",muted="#87a869",accent="#79ff38"},
    {name="infrared",bg="#24070c",top="#100205",side="#31060c",card="#3b0c14",hover="#5c101c",select="#8c1728",text="#ffe9ed",muted="#c16272",accent="#ff224d"},
    {name="bubblegum void",bg="#160d24",top="#0b0612",side="#0b1830",card="#28123d",hover="#42175c",select="#66307c",text="#fff0ff",muted="#b67ec5",accent="#ff57dc"},
    {name="porcelain",bg="#e8e1d4",top="#cfc4b3",side="#ddd4c5",card="#f5efe5",hover="#fffaf2",select="#aa9275",text="#2b2118",muted="#766553",accent="#d9485f",light=true},
    {name="poolside",bg="#c9f4ef",top="#92dacf",side="#b3ebe3",card="#e4fffb",hover="#f3fffd",select="#4aa99f",text="#123936",muted="#487c76",accent="#ff4f8b",light=true},
    {name="hazard",bg="#17170b",top="#090905",side="#24220a",card="#29280d",hover="#414014",select="#68641a",text="#fffbd1",muted="#aaa35e",accent="#fff200"},
    {name="royal ink",bg="#0d102c",top="#060714",side="#190b35",card="#171b49",hover="#252a70",select="#3e439c",text="#f0efff",muted="#8586ca",accent="#8f7cff"},
    {name="cotton candy",bg="#ffd7ef",top="#ff9fd2",side="#bfe9ff",card="#fff0f8",hover="#ffffff",select="#a85e93",text="#461838",muted="#9b5782",accent="#24bfff"},
    {name="vapor koi",bg="#241038",top="#10051c",side="#092b3d",card="#3b1652",hover="#5b2075",select="#8d369c",text="#fff1fb",muted="#c277bf",accent="#ff7a35"},
    {name="radioactive grape",bg="#200b2c",top="#0d0413",side="#171f08",card="#351044",hover="#521665",select="#79238c",text="#f8ffd8",muted="#aa76ba",accent="#d7ff00"},
    {name="lava lamp",bg="#2d0b16",top="#130309",side="#39130a",card="#48101e",hover="#6e1529",select="#a5263c",text="#fff0d9",muted="#d06e71",accent="#ff7b00"},
    {name="coral reef",bg="#062a35",top="#02141b",side="#08383b",card="#0b4250",hover="#105d6c",select="#17818d",text="#e9fffb",muted="#6cb8b4",accent="#ff7468"},
    {name="ultraviolet milk",bg="#eee8ff",top="#c9b9ff",side="#e2d6ff",card="#faf7ff",hover="#ffffff",select="#7252b5",text="#251448",muted="#735f99",accent="#7b2cff"},
    {name="mint chocolate",bg="#10241e",top="#07120f",side="#25140e",card="#19372e",hover="#244f42",select="#34715e",text="#e8fff6",muted="#76aa98",accent="#ff9b62"},
    {name="peach static",bg="#3a1719",top="#18090a",side="#442311",card="#582326",hover="#793035",select="#a9484d",text="#fff0df",muted="#d28b7d",accent="#ffd166"},
    {name="toxic lagoon",bg="#03262b",top="#011316",side="#112d08",card="#064047",hover="#075c65",select="#0a8189",text="#e8fff5",muted="#68b8a7",accent="#a6ff00"},
    {name="cherry cola",bg="#260b12",top="#100408",side="#32130d",card="#3e111d",hover="#5a192a",select="#83273c",text="#fff0f2",muted="#c87582",accent="#ff3158"},
    {name="electric banana",bg="#20200a",top="#0d0d03",side="#282207",card="#37370d",hover="#525214",select="#76761d",text="#fffedc",muted="#bbb45b",accent="#ffe600"},
    {name="lunar carnival",bg="#111533",top="#070817",side="#251035",card="#1c2252",hover="#2b3378",select="#444ca4",text="#f5f0ff",muted="#9192cd",accent="#ff4fc8"},
    {name="plasma orchid",bg="#270d31",top="#100514",side="#35113f",card="#40154d",hover="#5e1d6d",select="#872c98",text="#fff0ff",muted="#c477c8",accent="#ff46f6"},
    {name="ocean rust",bg="#08252b",top="#031114",side="#35180c",card="#0d3b43",hover="#12535d",select="#1b737c",text="#eaffff",muted="#72adb0",accent="#ff713d"},
    {name="raspberry steel",bg="#25101e",top="#10070d",side="#182536",card="#3b182e",hover="#572244",select="#79345f",text="#fff0f8",muted="#bd7a9d",accent="#ff3e91"},
    {name="copper cyanide",bg="#1f160d",top="#0d0905",side="#06262a",card="#382517",hover="#523723",select="#795237",text="#fff3df",muted="#be9370",accent="#00e4dc"},
    {name="watermelon crt",bg="#10251b",top="#07110c",side="#34101a",card="#183d2a",hover="#23583d",select="#347d58",text="#eefff4",muted="#80b895",accent="#ff416c"},
    {name="blue raspberry",bg="#071c38",top="#020d1a",side="#251040",card="#0d2e57",hover="#124379",select="#1e62a3",text="#edf8ff",muted="#72a6d0",accent="#42f5ff"},
    {name="solar punk",bg="#1b2609",top="#0b1103",side="#2e2008",card="#2d3d0d",hover="#425816",select="#617c25",text="#f6ffdc",muted="#a7bb63",accent="#ffcf21"},
    {name="witch tonic",bg="#161027",top="#080611",side="#0d2b24",card="#261943",hover="#38245f",select="#513584",text="#f5edff",muted="#9781b6",accent="#66ffb3"},
    {name="tangerine dream",bg="#2b1308",top="#120803",side="#31102a",card="#47200d",hover="#672e13",select="#93451f",text="#fff2df",muted="#d28b64",accent="#ff8a00"},
    {name="deep fried",bg="#2b0904",top="#110301",side="#322005",card="#461008",hover="#68180c",select="#962515",text="#fff4d8",muted="#d67e55",accent="#ffc400"},
    {name="neon fossil",bg="#182017",top="#0a0e0a",side="#252014",card="#293627",hover="#3b4e38",select="#566e50",text="#f2ffe8",muted="#9bad87",accent="#d9ff79"},
    {name="velvet lime",bg="#230d25",top="#0f0510",side="#172507",card="#39143d",hover="#541e59",select="#782d7c",text="#fff0ff",muted="#bd79bc",accent="#aaff22"},
    {name="cosmic melon",bg="#1a1135",top="#0a0717",side="#351522",card="#2b1a54",hover="#402578",select="#5e3ba2",text="#fff1fb",muted="#a986c8",accent="#ff8c6b"},
    {name="arctic cherry",bg="#dff8ff",top="#a8e1ef",side="#ffd6e2",card="#f4fdff",hover="#ffffff",select="#5aa6b8",text="#163642",muted="#5d8390",accent="#f03468"},
    {name="haunted candy",bg="#171028",top="#080510",side="#2b0d21",card="#271942",hover="#3a255f",select="#563885",text="#fbf0ff",muted="#9c81b5",accent="#59ff9b"},
    {name="digital sunset",bg="#22102a",top="#0e0612",side="#2f1709",card="#391745",hover="#552164",select="#79318b",text="#fff2e9",muted="#c07d9f",accent="#ff7a1a"},
    {name="prism dust",bg="#ece7ff",top="#c7bbf0",side="#d6f5ef",card="#faf8ff",hover="#ffffff",select="#7765a6",text="#29203e",muted="#756b8d",accent="#00bfae"},
    {name="blacklight peach",bg="#1d0b2b",top="#0a0410",side="#30100c",card="#311047",hover="#4b1767",select="#70258e",text="#fff0e7",muted="#b975a6",accent="#ff9a55"},
    {name="chromatic fog",bg="#25213a",top="#100e1c",side="#153638",card="#38304f",hover="#50436d",select="#746198",text="#f5f2ff",muted="#aaa0c3",accent="#62ffe1"},
    {name="radio coral",bg="#36111a",top="#16070b",side="#122a3e",card="#501a25",hover="#702535",select="#9b354a",text="#fff1e8",muted="#d18d8b",accent="#28d7ff"},
    {name="liquid chrome",bg="#d7dde1",top="#9aa6ad",side="#bfc9ce",card="#edf1f3",hover="#ffffff",select="#63747d",text="#152127",muted="#596970",accent="#ff3ec8",light=true},
    {name="toxic sakura",bg="#241024",top="#0e060e",side="#19300c",card="#3c193b",hover="#572454",select="#7d3778",text="#fff0fb",muted="#c17daf",accent="#a8ff28"},
    {name="amber ice",bg="#0b2632",top="#041116",side="#38210a",card="#123d4d",hover="#19576b",select="#24778e",text="#ecfbff",muted="#75aebb",accent="#ffad21"},
    {name="ghost signal",bg="#e8f0eb",top="#b9cbc1",side="#dce5ff",card="#f7fbf8",hover="#ffffff",select="#738e80",text="#1c2b23",muted="#6b7c72",accent="#7d3cff",light=true},
    {name="circuit bloom",bg="#08241c",top="#03100c",side="#32152c",card="#0e3c2e",hover="#145643",select="#1d795e",text="#ebfff7",muted="#71b19a",accent="#ff4fbd"},
    {name="violet warning",bg="#24142f",top="#0f0814",side="#392006",card="#3b204c",hover="#562e6b",select="#7c4594",text="#fff2d9",muted="#c08daf",accent="#ff9f0a"}
}
for i=1,#themes do for _,key in ipairs({"bg","top","side","card","hover","select","text","muted","accent"})do themes[i][key]=Color3.fromHex(themes[i][key])end end
themes.borderblack=Color3.fromHex("#000000")
local themeindex=1
for i=1,#themes do if themes[i].name=="monochrome"then themeindex=i;break end end
toggle.defaultthemeindex=themeindex
themes.accentstyle={labelcolor=themes[themeindex].accent,rgb=false}
toggle.themestyles={background={labelcolor=themes[themeindex].bg,rgb=false},topbar={labelcolor=themes[themeindex].top,rgb=false},border={labelcolor=themes[themeindex].select,rgb=false},outline={labelcolor=themes[themeindex].muted,rgb=false},text={labelcolor=themes[themeindex].text,rgb=false}}
toggle.themevisual={card=themes[themeindex].card,hover=themes[themeindex].hover,muted=themes[themeindex].muted}
local menustate={w=math.min(564,math.max(340,cam.ViewportSize.X-36)),h=math.min(660,math.max(340,cam.ViewportSize.Y-36)),watermarkw=156,watermarkh=32,x=24,y=18,tab=1,minimized=false,minimizeanim=0,menuanim=0,contentfade=1,maxitems=104,dragsensitivity=1.85,scroll={},scrolltarget={},scrollmax={},itemkinds={},hover={},toggleanim={},slideranim={},tabfade=1,tabslide=0,indicatorx=nil,indicatorw=nil,itemsdirty=true}
menustate.widgetclosed={}
toggle.bindvisible=function(id)return id~="menu"and id~="crate"and id~="prompt"and(keybinds[id]or 0)~=0 end
toggle.bindactive=function(id)return id=="menu"and toggle.menu and not menustate.minimized or id=="esp"and toggle.esp or id=="hud"and toggle.hud or id=="aura"and toggle.killaura or id=="thirdperson"and toggle.zoom.thirdperson or id=="collide"and toggle.client.antiCollide or id=="door"and toggle.client.doorNoCollide or false end
local tabnames={"main","visuals","interface","settings"}
toggle.tabiconnames={"house","eye","sun","gear"};toggle.tablabelanim={};toggle.tabicons={};toggle.heartcolor=Color3.fromHex("#FF8398")
for i=1,4 do toggle.tabicons[i]=toggle.newicon(121)end
local menubg=newsquare(Color3.fromHex("#16161e"),0.98)
local menutop=newsquare(Color3.fromHex("#1a1b26"),1)
local menuside=newsquare(Color3.fromHex("#13131a"),1)
local menuchrome={border=newborder(Color3.fromHex("#343b46"),1),content=newborder(Color3.fromHex("#272c35"),1),divider=newline(Color3.fromHex("#272c35")),columns={newsquare(Color3.fromHex("#06090c"),1),newsquare(Color3.fromHex("#06090c"),1)},columnborders={newborder(Color3.fromHex("#272c35"),1),newborder(Color3.fromHex("#272c35"),1)},scrolltrack=newsquare(Color3.fromHex("#090b0e"),0.8),scrollthumb=newsquare(Color3.fromHex("#99C30B"),1),scrollborder=newborder(Color3.fromHex("#272c35"),1),tabindicator=newsquare(Color3.fromHex("#99C30B"),1)}
menuchrome.divider.Thickness=1
toggle.footer={bg=setz(newsquare(Color3.fromHex("#16161e"),1),135),line=setz(newline(Color3.fromHex("#343b46")),136),username=setz(newtext(toggle.playerdisplayname or"Player",Color3.fromHex("#ffffff"),false,false),137),avatar=toggle.newicon(137),image=setz(toggle.newdrawing("Image"),137),button=setz(newsquare(Color3.fromHex("#343b46"),1),136),up=toggle.newicon(137),down=toggle.newicon(137)}
toggle.footer.line.Thickness=1;toggle.footer.image.Visible=false;toggle.setpos(toggle.footer.image,0,0);toggle.footer.image.Size=Vector2.new(26,26);pcall(function()toggle.footer.image.Rounding=13 end)

for _,entry in ipairs({{menubg,0},{menutop,0},{menuchrome.border,0},{menuchrome.columnborders[1],1},{menuchrome.columnborders[2],2}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end
toggle.menutitle=function()return"The Rake"end
local menutitle=newtext(toggle.menutitle(),Color3.fromHex("#ffffff"),false,false)
menutitle.Size=13
menustate.watermarkw=110;menustate.footerheight=64
local menuclose=toggle.newicon(121)
for _,d in ipairs({menubg,menutop,menuside,menuchrome.content,menuchrome.divider,menuchrome.columns[1],menuchrome.columns[2]})do setz(d,100)end;setz(menuchrome.border,138);setz(menuchrome.columnborders[1],138);setz(menuchrome.columnborders[2],138);setz(menuchrome.scrolltrack,130);setz(menuchrome.scrollthumb,132);setz(menuchrome.scrollborder,131);setz(menuchrome.tabindicator,119);setz(menutitle,121);setz(menuclose,121)
toggle.search={open=false,active=false,query="",results={},layouts={},max=7,w=276,rowh=44,aliases={grasslength="terrain grass blades length",terrainwater="terrain water color",postbloom="post effects bloom lighting",postdepth="post effects depth of field",postcorrection="post effects color correction",correctiontint="post effects color correction tint",postblur="post effects blur",scrapeditsselect="scrap junk metal tier edit",scrapedittoggle="scrap junk metal esp visibility color",locationeditselect="location structure shop station house tower cave edit",locationedittoggle="location structure esp visibility color",playerstacking="player nametag stack overlap layout",espfontselect="font family esp typeface",hudfontselect="font family hud menu typeface",doorNoCollide="door no collide collision house tower walk through",preventIdle="anti afk idle timeout disconnect kick",tracersselect="tracer traces line cursor mouse esp",supplylabel="crate supply box container esp",supplyitems="crate inventory supply box items",instacrate="instant crate collect take open supply box",autocollect="automatic collect loot supply crate",autocollectselect="automatic collect loot items supply crate",flares="flare gun weapon pickup",scrapstyleselect="scrap label display",scrapteleportselect="scrap teleport sort value nearest random",worldpanel="world information statistics hud panel",worldstatsselect="world information stats scrap points flare trap crate power",keybindpanel="keybind hotkey shortcut panel",autoradio="radio walkie talkie safehouse automatic take collect",autorecover="shop recover reclaim collection point items",autobuyitemsselect="shop automatically buy selected items",autosellitemsselect="shop automatically sell selected owned items",autosellscrap="shop automatic sell scraps collection point",quickbuy="shop purchase item",quicksell="shop sell item",sell="shop teleport sell scraps",killaura="stun aura combat rake attack",killaurarange="stun aura combat distance range",killauradelay="stun aura combat speed delay",thirdperson="camera zoom third person",shiftlock="camera mouse lock shift lock",noFall="client fall damage",towerBarriers="tower barriers observation tower conveyor slip fence",noJumpCooldown="client jump cooldown",infiniteStamina="client stamina energy",poweractivity="power electricity usage activity panel",poweractivitymodeselect="power activity visibility mode",playeritemsselect="player inventory items flare stun uv vest equipment",playerdistance="player esp render range distance",distance="esp range meters distance",rakenotifydistance="rake alert warning nearby distance",traps="rake trap esp",roof="house roof health hp",notificationtypeselect="notification toast alert types",notificationpositionselect="notification toast alert position",notificationduration="notification toast alert time duration",presetselect="theme preset colors style",containerstyleselect="hud style modern legacy",opacity="interface transparency opacity",borderradius="interface corners radius",esptextoutline="esp font text outline",barrgb="rgb chroma rainbow accent",rgbdirectionselect="accent animation direction",rgbspeed="accent animation speed",espfontselect="esp typeface font",hudfontselect="hud typeface font",fontsize="esp text font size",configname="configuration config name",configselect="configuration config list",deleteconfig="configuration delete remove file",ringenabled="world esp ring circle",ringshapeselect="world esp ring circle square triangle hexagon",ringfade="world esp ring render distance",ringsize="world esp ring size",ringspin="world esp ring rotating ring",ringspinspeed="world esp ring rotation speed",resetselect="reset theme features binds toggles positions",startreset="reset selected settings"},ui={outer=setz(newborder(Color3.fromHex("#000000"),1),154),middle=setz(newborder(Color3.fromHex("#555555"),1),154),inner=setz(newborder(Color3.fromHex("#000000"),1),154),bg=setz(newsquare(Color3.fromHex("#202020"),1),150),top=setz(newsquare(Color3.fromHex("#171717"),1),151),title=setz(newtext("search",Color3.fromHex("#ffffff"),false,false),156),fieldborder=setz(newborder(Color3.fromHex("#000000"),1),154),fieldbg=setz(newsquare(Color3.fromHex("#171717"),1),152),fieldtext=setz(newtext("search features...",Color3.fromHex("#858585"),false,false),156),status=setz(newtext("type to search",Color3.fromHex("#858585"),true,false),156),icon=toggle.newicon(156),rows={}}}
for i=1,toggle.search.max do toggle.search.ui.rows[i]={bg=setz(newsquare(Color3.fromHex("#2b2b2b"),1),151),label=setz(newtext("",Color3.fromHex("#ffffff"),false,false),156),context=setz(newtext("",Color3.fromHex("#858585"),false,false),156)}end
local tabbg,tabtext,tabborder={},{},{}
for i=1,#tabnames do tabbg[i]=setz(newsquare(Color3.fromHex("#202330"),1),112);tabborder[i]=setz(newborder(Color3.fromHex("#272c35"),1),113);tabtext[i]=setz(newtext(tabnames[i],Color3.fromHex("#ffffff"),true,false),121);tabtext[i].Size=13 end
local itembg,itemlabel,itemvalue,itemmark,itemtrack,itemfill,itemborder,markborder,itemarrow={},{},{},{},{},{},{},{},{}
toggle.menuinfo={layouts={},bindlayouts={},icons={},tooltip={bg=setz(newsquare(Color3.fromHex("#16161e"),1),190),outer=setz(newborder(Color3.fromHex("#000000"),1),194),middle=setz(newborder(Color3.fromHex("#f2a93b"),1),193),inner=setz(newborder(Color3.fromHex("#000000"),1),192),badge=setz(newtext("",Color3.fromHex("#f2a93b"),false,false),195),text=setz(newtext("",Color3.fromHex("#ffffff"),false,false),195)}}
toggle.newtooltipicon=function(z)return toggle.newicon(z)end
toggle.settooltipicon=function(icon,kind,x,y,c,a,on)
    toggle.seticon(icon,kind=="hybrid"and"zap"or kind=="unsafe"and"moon"or kind=="warning"and"trianglealert"or"circlequestion",x,y,16,c,a,on)
end
toggle.menuinfo.tooltipicon=toggle.newtooltipicon(196)
toggle.inlinecolors={mark={}};toggle.bindbgs={}
toggle.ensuremenurow=function(i)
    if itembg[i]then return end
    itembg[i]=setz(newsquare(Color3.fromHex("#202330"),1),110);itemborder[i]=setz(newborder(Color3.fromHex("#272c35"),1),111)
    itemlabel[i]=setz(newtext("",toggle.white,false,false),121);itemvalue[i]=setz(newtext("",toggle.white,false,false),121);toggle.bindbgs[i]=setz(newsquare(Color3.fromHex("#080b10"),1),119)
    itemmark[i]=setz(newsquare(toggle.white,1),116);markborder[i]=setz(newborder(toggle.white,1),114)
    itemarrow[i]=setz(toggle.newdrawing("Triangle"),122);itemarrow[i].Filled=true;itemarrow[i].Thickness=1;itemarrow[i].Color=toggle.white;itemarrow[i].Transparency=1;itemarrow[i].Visible=false
    itemtrack[i]=setz(newsquare(toggle.white,1),114);itemfill[i]=setz(newsquare(toggle.white,1),115);toggle.inlinecolors.mark[i]=setz(newsquare(toggle.white,1),116)
    local r=math.min(10,toggle.borderradius);for _,d in ipairs({itembg[i],itemborder[i]})do pcall(function()d.Corner=math.min(5,r)end)end
    for _,d in ipairs({itemmark[i],markborder[i],itemtrack[i],itemfill[i],toggle.inlinecolors.mark[i]})do pcall(function()d.Corner=math.min(5,r)end)end
end
local dropdown={panel=newsquare(Color3.fromHex("#05070a"),1),border=newborder(Color3.fromHex("#28313d"),1),accent=newsquare(Color3.fromHex("#8da8c0"),1),scrolltrack=newsquare(Color3.fromHex("#090b0e"),1),scrollborder=newborder(Color3.fromHex("#28313d"),1),scrollthumb=newsquare(Color3.fromHex("#8da8c0"),1),bg={},text={},max=12,visiblemax=9,offset=0,scroll=0,scrollmax=0,layout=nil,anim=0,opened=false}
setz(dropdown.panel,200);setz(dropdown.border,201);setz(dropdown.accent,202);setz(dropdown.scrolltrack,205);setz(dropdown.scrollborder,206);setz(dropdown.scrollthumb,207);for i=1,dropdown.max do dropdown.bg[i]=setz(newsquare(Color3.fromHex("#202330"),1),203);dropdown.text[i]=setz(newtext("",Color3.fromHex("#ffffff"),false,false),204)end
local picker={
    bg=newsquare(Color3.fromHex("#08090c"),0.98),top=newsquare(Color3.fromHex("#161616"),1),panel=newsquare(Color3.fromHex("#050607"),1),accent=newsquare(Color3.fromHex("#65c8e8"),1),divider=newline(Color3.fromHex("#111111")),border=newborder(Color3.fromHex("#000000"),1),middleborder=newborder(Color3.fromHex("#555555"),1),innerborder=newborder(Color3.fromHex("#000000"),1),panelborder=newborder(Color3.fromHex("#111111"),1),title=newtext("color",Color3.fromHex("#ffffff"),false,false),
    preview=newsquare(Color3.fromHex("#ffffff"),1),previewborder=newborder(Color3.fromHex("#ffffff"),1),squareborder=newborder(Color3.fromHex("#ffffff"),1),hueborder=newborder(Color3.fromHex("#ffffff"),1),huebase=setz(newsquare(Color3.new(1,0,0),1),222),colorbase=toggle.newicon(223),valueimage=toggle.newicon(223.5),squaredim=newsquare(Color3.fromHex("#202020"),0),huedim=newsquare(Color3.fromHex("#202020"),0),hue={},cursor=nil,huecursor=nil,reveal=newsquare(Color3.fromHex("#202020"),1),
    rgbbg=newsquare(Color3.fromHex("#090b0e"),1),rgbborder=newborder(Color3.fromHex("#343b46"),1),rgbmark=newsquare(Color3.fromHex("#7aa2f7"),1),rgbmarkborder=newborder(Color3.fromHex("#343b46"),1),rgbtext=newtext("chroma",Color3.fromHex("#ffffff"),true,false),
    hexbg=newsquare(Color3.fromHex("#090b0e"),1),hexborder=newborder(Color3.fromHex("#343b46"),1),hexlabel=newtext("hex",Color3.fromHex("#ffffff"),false,false),hextext=newtext("#FFFFFF",Color3.fromHex("#ffffff"),false,false),gradient={},ready=false,anim=0,opened=false,cursorx=nil,cursory=nil,huey=nil,rgbhover=0,donehover=0,previewcolor=nil,chromadim=0
}
picker.cols=128;picker.rows=128;picker.huesteps=96
picker.divider.Thickness=1
for _,d in ipairs({picker.bg,picker.top,picker.panel})do setz(d,220)end
for _,d in ipairs({picker.accent,picker.divider})do setz(d,221)end
for _,d in ipairs({picker.border,picker.middleborder,picker.innerborder,picker.panelborder,picker.preview,picker.previewborder,picker.squareborder,picker.hueborder,picker.rgbbg,picker.rgbborder,picker.hexbg,picker.hexborder})do setz(d,222)end;setz(picker.rgbborder,224);setz(picker.rgbmark,223);setz(picker.rgbmarkborder,224);setz(picker.squaredim,224);setz(picker.huedim,224)
for _,d in ipairs({picker.title,picker.rgbtext,picker.hexlabel,picker.hextext})do setz(d,225)end
setz(picker.reveal,225)
picker.cursor=setz(toggle.newdrawing("Circle"),226);picker.cursor.Color=Color3.fromHex("#ffffff");picker.cursor.Radius=4;picker.cursor.NumSides=20;picker.cursor.Thickness=1;picker.cursor.Visible=false;picker.huecursor=setz(newborder(Color3.fromHex("#ffffff"),1),226)
picker.hexvalue="FFFFFF";picker.hexactive=false;picker.hexreplace=false
picker.baseobjects={picker.bg,picker.top,picker.border,picker.middleborder,picker.innerborder,picker.title,picker.preview,picker.squareborder,picker.hueborder,picker.huebase,picker.colorbase,picker.valueimage,picker.squaredim,picker.huedim,picker.cursor,picker.huecursor,picker.hexbg,picker.hextext};picker.rgbobjects={picker.rgbbg,picker.rgbtext}
local menurgb={_count=barseg,_z=137}
local capture,pickerentry,dropdownkind,configcapture=nil,nil,nil,false
local configslots={"default"}
local configslot=1
local configname="Default"
local menuitems,itemlayouts={},{}
local pickerlayouts,dropdownlayouts={},{}
local function color(name)
    if name=="accent"then return themes.accentstyle.labelcolor elseif name=="bg"or name=="side"then return toggle.themestyles.background.labelcolor elseif name=="top"then return toggle.themestyles.topbar.labelcolor elseif name=="select"then return toggle.themestyles.border.labelcolor elseif name=="outline"then return toggle.themestyles.outline.labelcolor elseif name=="text"then return toggle.themestyles.text.labelcolor end
    return toggle.themevisual[name]or themes[themeindex][name]
end
toggle.textbrightness=function(c)return c and math.max(c.R,c.G,c.B)or 1 end
toggle.uioutline=function(d,a,c)toggle.setprop(d,"Outline",false)end
toggle.outlineallowed=function(c,enabled,fade)return enabled==true and(fade or 1)>=0.92 and toggle.textbrightness(c)>=0.4 end
toggle.textoutline=function(c,fade)return false end
toggle.applytextoutline=function(d,fade,textcolor)
    if d and not toggle.removeddraw[d]then toggle.setprop(d,"Outline",toggle.textoutline(textcolor or toggle.drawcolors[d]or d.Color,fade))end
end
toggle.applyespoutline=function(d,fade,textcolor)if d and not toggle.removeddraw[d]then toggle.setprop(d,"Outline",toggle.outlineallowed(textcolor or toggle.drawcolors[d]or d.Color,toggle.esptextoutline,fade))end end
toggle.ease=function(current,target,speed)
    current=current==nil and target or current
    if math.abs(target-current)<0.001 then return target end
    local frames=clamp((toggle.framedt or 1/60)*60,0.25,6);local adjusted=1-math.pow(1-speed,frames)
    return current+(target-current)*adjusted
end
toggle.colormix=function(a,b,amount)
    amount=clamp(amount,0,1);if amount<=0 then return a elseif amount>=1 then return b end;return Color3.new(a.R+(b.R-a.R)*amount,a.G+(b.G-a.G)*amount,a.B+(b.B-a.B)*amount)
end
toggle.hudtextcolor=function(c)
    if toggle.hudstyle~="legacy"or toggle.textbrightness(c)>=0.46 then return c end
    local level=toggle.textbrightness(c);return toggle.colormix(c,toggle.white,clamp((0.46-level)/math.max(0.01,1-level),0,1))
end
toggle.accentvisual=function()
    if toggle.barrgb then return color("accent")end
    local base,foreground=color("accent"),color("text");local now=toggle.frametime or tick();if toggle.accentcachetime~=now or toggle.accentcachebase~=base or toggle.accentcachetext~=foreground then toggle.accentcachetime=now;toggle.accentcachebase=base;toggle.accentcachetext=foreground;toggle.accentcache=toggle.colormix(base,foreground,0.035+0.025*(math.sin(now*2.1)+1)/2)end;return toggle.accentcache
end
toggle.wraptooltip=function(value,limit)
    local lines,current={},"";local maxwidth=math.max(7,limit*7);local function flush()if current~=""then lines[#lines+1]=current;current=""end end
    for paragraph in string.gmatch((value or"").."\n","([^\n]*)\n")do
        for token in string.gmatch(paragraph,"%S+")do
            local word=token;while #word>1 and toggle.uiwidth(word)>maxwidth do flush();local at=#word;while at>1 and toggle.uiwidth(string.sub(word,1,at))>maxwidth do at=at-1 end;lines[#lines+1]=word:sub(1,at);word=word:sub(at+1)end
            if word~=""then local candidate=current==""and word or current.." "..word;if toggle.uiwidth(candidate)>maxwidth then flush();current=word else current=candidate end end
        end;flush()
    end
    local longest=0;for i=1,#lines do longest=math.max(longest,toggle.uiwidth(lines[i])/7)end;return table.concat(lines,"\n"),longest,math.max(1,#lines)
end
toggle.makegradient=function(count,z)return {_count=count,_z=z}end
toggle.uimodern={buttons={setz(newsquare(Color3.fromHex("#ffffff"),0),118),setz(newsquare(Color3.fromHex("#ffffff"),0),118)}}
toggle.search.ui.gradient=toggle.makegradient(128,153)
toggle.layoutgradient=function(lines,x,y,w)
    local count=math.max(1,math.min(lines._count or 144,math.floor(w)));if lines._x==x and lines._y==y and lines._w==w and lines._layoutcount==count and lines._allocated==#lines then return end
    lines._x=x;lines._y=y;lines._w=w;lines._layoutcount=count;lines._allocated=#lines;lines._paintframe=nil;lines._edges=lines._edges or{};local fade=math.min(0.16,14/math.max(1,w));local edgepixels=math.min(14,math.floor(count/4),math.floor(w/4))
    local function boundary(n)if n<=edgepixels then return n elseif n>=count-edgepixels then return w-(count-n)else return edgepixels+(n-edgepixels)*(w-edgepixels*2)/math.max(1,count-edgepixels*2)end end
    for i=1,#lines do local d=lines[i];if i<=count then
        local left=math.floor(x+boundary(i-1)+0.5);local right=math.floor(x+boundary(i)+0.5);local position=((left+right)/2-x)/math.max(1,w);local edge=clamp(math.min(position,1-position)/math.max(0.001,fade),0,1);lines._edges[i]=edge*edge*(3-2*edge);toggle.setprop(d,"Position",Vector2.new(left,y));toggle.setprop(d,"Size",Vector2.new(math.max(0,right-left),2))else toggle.setvisible(d,false)end end
end
toggle.paintgradient=function(lines,on,alpha)
    local desired=on==true;if not desired and lines._paintvisible==false then return end
    if desired and #lines==0 and lines._count then
        for i=1,lines._count do lines[i]=setz(newsquare(toggle.white,1),lines._z)end
        toggle.layoutgradient(lines,lines._x or 0,lines._y or 0,lines._w or 1)
    end
    local visibilitychanged=lines._paintvisible~=desired;lines._paintvisible=desired;local count=math.min(#lines,lines._layoutcount or #lines);local colors=nil
    if desired then
        local state=toggle.gradientcache;local opacity=alpha or 1
        if not visibilitychanged and lines._paintframe==state.frame and lines._paintalpha==opacity then return end
        lines._paintframe=state.frame;lines._paintalpha=opacity
        local cachekey=(toggle.barrgb and"rgb"or"swoosh")..tostring(count);local set=state.sets[cachekey]
        if not set then set={frame=-1};state.sets[cachekey]=set end
        if set.frame~=state.frame then
            if toggle.barrgb then for i=1,count do set[i]=Color3.fromHSV(((toggle.rgbphase or 0)+(i-1)/math.max(1,count-1)*rgbspread)%1,toggle.chromasaturation,1)end
            else local base=color("accent");local phase=(1-(toggle.rgbphase or((tick()*rgbspeed)*(toggle.rgbdirection=="left"and 1 or-1))%1))%1;set.alpha=set.alpha or{};for i=1,count do local position=(i-1)/math.max(1,count-1);local delta=(position-phase+0.5)%1-0.5;local width=delta<0 and rgbspread or rgbspread*0.35;local distance=math.abs(delta)/width;set[i]=base;set.alpha[i]=distance<1 and(0.5+0.5*math.cos(math.pi*distance))or 0 end end
            set.frame=state.frame
        end
        colors=set
    else lines._paintframe=nil end
    for i=1,count do local d=lines[i];if desired then toggle.setprop(d,"Color",colors[i]);toggle.setprop(d,"Transparency",(alpha or 1)*(lines._edges and lines._edges[i]or 1)*(toggle.barrgb and 1 or colors.alpha[i]or 0))end;if visibilitychanged or d.Visible~=desired then toggle.setvisible(d,desired)end end;for i=count+1,#lines do toggle.setvisible(lines[i],false)end
end
toggle.gradientcache={frame=0,nextframe=0,sets={}}
toggle.toastframes={}
for i=1,toggle.notifications.max do
    local z=300+i*10;toggle.toastframes[i]={outer=setz(newborder(Color3.fromHex("#000000"),1),z+6),middle=setz(newborder(Color3.fromHex("#555555"),1),z+5),inner=setz(newborder(Color3.fromHex("#000000"),1),z+4),bg=setz(newsquare(Color3.fromHex("#16161e"),1),z),top=setz(newsquare(Color3.fromHex("#1a1b26"),1),z+1),text=setz(newtext("",Color3.fromHex("#ffffff"),false,false),z+7),progressbg=setz(newsquare(Color3.fromHex("#090b0e"),1),z+2),progress=setz(newsquare(Color3.fromHex("#ffffff"),1),z+3),gradient=toggle.makegradient(32,z+3)}
    toggle.toastframes[i].text.Size=13
end
toggle.drawnotifications=function()
    local state,settings,now=toggle.notifications,toggle.notifysettings,toggle.frametime or tick()
    for i=#state.items,1,-1 do local item=state.items[i];local open=now<item.started+item.duration;item.anim=toggle.ease(item.anim,open and 1 or 0,open and 0.30 or 0.24);if not open and item.anim<=0.01 then table.remove(state.items,i)end end
    local left=string.find(settings.position,"left",1,true)~=nil;local middle=string.find(settings.position,"middle",1,true)~=nil;local total=0
    if middle then for i=1,math.min(#state.items,state.max)do total=total+state.items[i].height+(i>1 and 8 or 0)end end
    local offset=0
    for i=1,state.max do
        local item,frame=state.items[i],toggle.toastframes[i]
        if item then
            local w,h=item.width,item.height;local tx=left and 18 or cam.ViewportSize.X-w-18;local ty=middle and math.floor((cam.ViewportSize.Y-total)/2+offset)or cam.ViewportSize.Y-18-h-offset;local entryx=left and tx-38 or tx+38;item.x=toggle.ease(item.x or entryx,tx,0.24);item.y=toggle.ease(item.y or ty+8,ty,0.26);offset=offset+h+8
            local x,y=toggle.pixel(item.x),toggle.pixel(item.y);local alpha=item.anim;local shell=guiopacity*alpha;local eventcolor=item.color~=nil;local tint=item.color or color("accent");local modern=toggle.hudstyle=="modern";toggle.setpos(frame.outer,x,y);frame.outer.Size=Vector2.new(w,h);toggle.setpos(frame.middle,x+1,y+1);frame.middle.Size=Vector2.new(w-2,h-2);toggle.setpos(frame.inner,x+2,y+2);frame.inner.Size=Vector2.new(w-4,h-4);toggle.setpos(frame.bg,x+1,y+1);frame.bg.Size=Vector2.new(w-2,h-2);toggle.setpos(frame.top,x+3,y+3);frame.top.Size=Vector2.new(w-6,3);toggle.setpos(frame.text,x+18,y+18);frame.text.Text=item.text
            local ratio=clamp((item.started+item.duration-now)/math.max(0.01,item.duration),0,1);toggle.setpos(frame.progressbg,x+18,y+h-14);frame.progressbg.Size=Vector2.new(w-36,2);frame.progress.Position=frame.progressbg.Position;frame.progress.Size=Vector2.new(math.max(0,(w-36)*ratio),2);toggle.layoutgradient(frame.gradient,x+toggle.gradientinset(),y+3,math.max(1,w-toggle.gradientinset()*2))
            local textcolor=eventcolor and toggle.colormix(color("text"),tint,0.3)or color("text");textcolor=modern and textcolor or toggle.hudtextcolor(tint);toggle.setprop(frame.outer,"Color",themes.borderblack);toggle.setprop(frame.middle,"Color",eventcolor and tint or color("outline"));toggle.setprop(frame.inner,"Color",themes.borderblack);toggle.setprop(frame.bg,"Color",eventcolor and toggle.colormix(color("bg"),tint,0.10)or color("bg"));toggle.setprop(frame.top,"Color",tint);toggle.setprop(frame.text,"Color",textcolor);toggle.setprop(frame.progressbg,"Color",color("bg"));toggle.setprop(frame.progress,"Color",tint);toggle.setprop(frame.outer,"Transparency",shell);toggle.setprop(frame.middle,"Transparency",0.24*shell);toggle.setprop(frame.inner,"Transparency",shell);toggle.setprop(frame.bg,"Transparency",shell);toggle.setprop(frame.top,"Transparency",0);toggle.setprop(frame.text,"Transparency",alpha);toggle.setprop(frame.progressbg,"Transparency",0.8*shell);toggle.setprop(frame.progress,"Transparency",alpha);toggle.applytextoutline(frame.text,alpha,textcolor);toggle.setvisible(frame.outer,false);toggle.setvisible(frame.inner,false);toggle.setvisible(frame.middle,modern);toggle.setvisible(frame.bg,modern);toggle.setvisible(frame.top,false);toggle.setvisible(frame.text,true);toggle.setvisible(frame.progressbg,modern);toggle.setvisible(frame.progress,true);toggle.paintgradient(frame.gradient,false)
        else
            for _,d in ipairs({frame.outer,frame.middle,frame.inner,frame.bg,frame.top,frame.text,frame.progressbg,frame.progress})do toggle.setvisible(d,false)end;toggle.paintgradient(frame.gradient,false)
        end
    end
end
toggle.ensurepicker=function()
    if picker.ready then return end
    toggle.preparepickerimages()
    picker.gradient=toggle.makegradient(144,221);for i=1,picker.huesteps do picker.hue[i]=setz(newsquare(Color3.fromHSV((i-1)/picker.huesteps,1,1),1),223)end;picker.ready=true;toggle.applyradius()
end
toggle.pickerassets={"iVBORw0KGgoAAAANSUhEUgAAAPwAAAD8CAYAAABTq8lnAAACPElEQVR42u3TwQkAIBADwWj/NRvLELkZ8C052NW2SV6+8/h/2+0es30HGEPwIHhA8IDgAcEDggcEDwgeEDwgeEDwgOBB8IDgAcEDggcEDwgeEDwgeEDwgOABwYPgAcEDggcEDwgeEDwgeEDwgOABwQOCB8EDggcEDwgeEDwgeEDwgOABwQOCBwQPggcEDwgeEDwgeEDwgOABwQOCBwQPCB4QPAgeEDwgeEDwgOABwQOCBwQPCB4QPCB4EDwgeEDwgOABwQOCBwQPCB4QPCB4QPAgeEDwgOABwQOCBwQPCB4QPCB4QPCA4EHwgOABwQOCBwQPCB4QPCB4QPCA4AHBg+CdAAQPCB4QPCB4QPCA4AHBA4IHBA8IHhA8CB4QPCB4QPCA4AHBA4IHBA8IHhA8IHgQPCB4QPCA4AHBA4IHBA8IHhA8IHhA8CB4QPCA4AHBA4IHBA8IHhA8IHhA8IDgQfCA4AHBA4IHBA8IHhA8IHhA8IDgAcEDggfBA4IHBA8IHhA8IHhA8IDgAcEDggcED4IHBA8IHhA8IHhA8IDgAcEDggcEDwgeBA8IHhA8IHhA8IDgAcEDggcEDwgeEDwIHhA8IHhA8IDgAcEDggcEDwgeEDwgeBA8IHhA8IDgAcEDggcEDwgeEDwgeEDwgOBB8IDgAcEDggcEDwgeEDwgeEDwgOABwYPgAcEDggcEDwgeEDwgeEDwgOABwQOCB8EDggcEDwgeEDwgeEDwgOABwQOCBwQPggcEDwge+NUFNekABCM4zc0AAAAASUVORK5CYII=","iVBORw0KGgoAAAANSUhEUgAAAPwAAAD8CAYAAABTq8lnAAACSUlEQVR42u3VsQkAMQwEwbP4/lu2E1fwIBxoBtTAwaIEGGPdAwb4BA+CBwQPCB4QPCB4QPCA4AHBA4IHBA8IHgQPCB4QPCB4QPCA4AHBA4IHBA8IHhA8CB4QPCB4QPCA4AHBA4IHmoIvM4APDwgeEDwgeEDwgOABwQOCBwQPCB4QPAgeEDwgeEDwgOABwQOCBwQPCB4QPCB4EDwgeEDwgOABwQOCBwQPCB4QPCB4QPAgeEDwgOABwQOCBwQPCB4QPCB4QPCA4EHwgOABwQOCBwQPCB4QPCB4QPCA4AHBg+AFD4IHBA8IHhA8IHhA8EB/8GUG8OEBwQOCBwQPCB4QPCB4QPCA4AHBA4IHwQOCBwQPCB4QPCB4QPCA4AHBA4IHBA+CBwQPCB4QPCB4QPCA4AHBA4IHBA8IHgQPCB4QPCB4QPCA4AHBA4IHBA8IHhA8CB4QPCB4QPCA4AHBA4IHBA8IHhA8IHgQvOBB8IDgAcEDggcEDzwLvswAPjwgeEDwgOABwQOCBwQPCB4QPCB4QPAgeEDwgOABwQOCBwQPCB4QPCB4QPCA4EHwgOABwQOCBwQPCB4QPCB4QPCA4AHBg+ABwQOCBwQPCB4QPCB4QPCA4AHBA4IHwQOCBwQPCB4QPCB4QPCA4AHBA4IHBA+CFzwIHhA8IHhA8IDgAcED/cGXGcCHBwQPCB4QPCB4QPCA4AHBA4IHBA8IHgQPCB4QPCB4QPCA4AHBA4IHBA8IHhA8CB4QPCB4QPCA4AHBA4IHBA/8tZJsM8AMBwalBeQE5oCAAAAAAElFTkSuQmCC"}
toggle.preparepickerimages=function()
    if picker.maskready then return end
    local cached=type(_G)=="table"and _G.__therakePickerMasks
    if not cached or cached.source~=toggle.pickerassets[1]or cached.valuesource~=toggle.pickerassets[2]then cached={source=toggle.pickerassets[1],valuesource=toggle.pickerassets[2],images={toggle.iconbase64(toggle.pickerassets[1]),toggle.iconbase64(toggle.pickerassets[2])}};if type(_G)=="table"then _G.__therakePickerMasks=cached end end
    picker.colorbase.Data=cached.images[1];picker.valueimage.Data=cached.images[2];picker.maskready=true;if type(_G)=="table"then _G.__therakePickerAssets=nil end
end
toggle.warmpicker=function()
    toggle.wait();while toggle.running and toggle.starting do toggle.wait()end
    if toggle.running then toggle.preparepickerimages()end
end
local function inside(px,py,x,y,w,h)return px>=x and px<=x+w and py>=y and py<=y+h end
toggle.avatarload=function()
    local function picture(bytes)return type(bytes)=="string"and#bytes>=24 and(string.byte(bytes,1)==137 and string.byte(bytes,2)==80 or string.byte(bytes,1)==255 and string.byte(bytes,2)==216)end
    local function get(url)local ok,reply=pcall(function()return httpget and httpget(url)or game:HttpGet(url)end);return ok and type(reply)=="string"and reply or nil end
    local userid;for attempt=1,12 do local ok,id=pcall(function()return lp and lp.UserId end);if ok and type(id)=="number"and id>0 then userid=id;break end;toggle.wait(0.15)end
    if not userid and httppost and lp then local ok,reply=pcall(function()return httppost("https://users.roblox.com/v1/usernames/users",http:JSONEncode({usernames={lp.Name},excludeBannedUsers=false}))end);if ok and type(reply)=="string"then userid=tonumber(reply:match('"id"%s*:%s*(%d+)'))end end;if not userid then return end
    local cache="therakesaint/avatar_"..tostring(userid)..".dat";local ok,bytes=pcall(function()return isfile(cache)and readfile(cache)end)
    if not ok or not picture(bytes)then bytes=nil;for attempt=1,3 do for _,host in ipairs({"thumbnails.roblox.com","thumbnails.roproxy.com"})do local reply=get("https://"..host.."/v1/users/avatar-headshot?userIds="..tostring(userid).."&size=150x150&format=Png&isCircular=false");local url=reply and reply:match('"imageUrl"%s*:%s*"([^"]+)"');if url then local candidate=get(url:gsub("\\/","/"));if picture(candidate)then bytes=candidate;break end end end;if bytes then break end;toggle.wait(0.7)end;if bytes then pcall(function()makefolder("therakesaint");writefile(cache,bytes)end)end end
    while toggle.running and(toggle.starting)do toggle.wait(0.1)end
    if toggle.running and picture(bytes)then local loaded=pcall(function()toggle.footer.image.Data=bytes end);toggle.footer.ready=loaded end
end
toggle.footerupdate=function()
    local f=toggle.footer;local alpha=(menustate.menuanim or 0)*(menustate.contentfade or 0);local on=alpha>0.01 and not menustate.minimized;local height=menustate.footerheight or 52;local y=menustate.y+menustate.h-height;local right=menustate.x+menustate.w-18;local cy=y+height/2;menustate.resizehit={x=right-28,y=cy-14,w=28,h=28};menustate.contentbottom=y-8
    toggle.setpos(f.bg,menustate.x+8,y);toggle.setprop(f.bg,"Size",Vector2.new(menustate.w-16,height-8));toggle.setprop(f.bg,"Color",color("bg"));toggle.setprop(f.bg,"Transparency",guiopacity*alpha);toggle.setprop(f.bg,"Corner",math.min(8,toggle.borderradius));toggle.setvisible(f.bg,false)
    toggle.setprop(f.line,"From",Vector2.new(menustate.x+18,y));toggle.setprop(f.line,"To",Vector2.new(right,y));toggle.setprop(f.line,"Color",color("outline"));toggle.setprop(f.line,"Transparency",0.18*guiopacity*alpha);toggle.setvisible(f.line,false)
    local ax,ay=menustate.x+18,cy-16;toggle.setpos(f.image,ax,ay);toggle.setprop(f.image,"Size",Vector2.new(32,32));toggle.setprop(f.image,"Rounding",16);toggle.setprop(f.image,"Transparency",alpha);toggle.setvisible(f.image,on and f.ready==true);toggle.seticon(f.avatar,"person",ax+4,ay+4,24,color("muted"),alpha,on and not f.ready)
    toggle.setpos(f.username,ax+42,cy-6.5);toggle.setprop(f.username,"Color",color("text"));toggle.setprop(f.username,"Transparency",alpha);toggle.setprop(f.username,"Outline",false);toggle.setvisible(f.username,on)
    local hover=false;f.hover=toggle.ease(f.hover,hover and 1 or 0,0.2);toggle.setpos(f.button,right-28,cy-14);toggle.setprop(f.button,"Size",Vector2.new(28,28));toggle.setprop(f.button,"Corner",math.min(6,toggle.borderradius));toggle.setprop(f.button,"Color",color("text"));toggle.setprop(f.button,"Transparency",0.08*f.hover*alpha);toggle.setvisible(f.button,false)
    toggle.seticon(f.up,"ellipsis",right-22,cy-8,16,color("muted"),alpha,on);toggle.setvisible(f.down,false)
end
toggle.edgefade=function(top,bottom,cliptop,clipbottom)return clamp(math.min(top-cliptop+4,clipbottom-bottom+4)/16,0,1)end
toggle.tooltipupdate=function()
    local active=nil
    if toggle.menu and not menustate.minimized and not pickerentry and not dropdownkind then
        for i=1,#menuitems do
            local bind=toggle.menuinfo.bindlayouts[i];local info=toggle.menuinfo.layouts[i]
            if bind and bind.visible and inside(mouse.X,mouse.Y,bind.x,bind.y,bind.w,bind.h)then active=bind;break end
            if info and info.visible and inside(mouse.X,mouse.Y,info.x,info.y,info.w,info.h)then active=info;break end
        end
    end
    local state=toggle.menuinfo;local tip=state.tooltip;local id=active and(active.text..":"..tostring(active.bind))or nil
    if state.tipid~=id then state.tipid=id;state.tipstart=toggle.frametime or tick();state.tipanim=0 end
    local visible=active~=nil and(toggle.frametime or tick())-(state.tipstart or 0)>=0.12
    for _,d in pairs(tip)do toggle.setvisible(d,visible)end
    if not visible then toggle.settooltipicon(state.tooltipicon,nil,0,0,toggle.white,0,false);return end
    state.tipanim=toggle.ease(state.tipanim,1,0.23);local a=state.tipanim;local unstable=active.unstable==true or active.warning==true;local permission=active.permission;local bind=active.bind==true
    local kind=permission=="hybrid"and"hybrid"or permission and"unsafe"or unstable and"warning"or"info";local title=bind and"Keybind"or permission=="hybrid"and"Hybrid Mode"or permission and"Unsafe Luau"or unstable and"Experimental"or"Instruction"
    local tint=bind and color("accent")or unstable and toggle.warningred or permission=="hybrid"and toggle.permissionpink or permission and toggle.permissionblue or toggle.infoorange
    local maxwidth=math.min(352,math.max(120,cam.ViewportSize.X-16));local padding=16;local limit=math.max(8,math.floor((maxwidth-padding*2)/7))
    local description=toggle.uiprosetext(active.text);if not string.find(description,"[.!?]$")then description=description.."."end;local text,longest,lines=toggle.wraptooltip(description,limit);local width=math.min(maxwidth,math.max(math.min(208,maxwidth),longest*7+padding*2,toggle.uiwidth(title)+padding*2+26));local height=padding*2+20+8+lines*(toggle.menulineheight+1)
    local x=active.x+active.w+10;if x+width>cam.ViewportSize.X-8 then x=active.x-width-10 end;x=clamp(x,8,math.max(8,cam.ViewportSize.X-width-8))
    local y=clamp(active.y-8,8,math.max(8,cam.ViewportSize.Y-height-8))+(1-a)*3
    toggle.setpos(tip.bg,x,y);tip.bg.Size=Vector2.new(width,height);tip.middle.Position=tip.bg.Position;tip.middle.Size=tip.bg.Size
    toggle.setpos(tip.badge,x+padding+26,y+padding+2);tip.badge.Text=title;tip.badge.Color=tint;tip.badge.Transparency=a;toggle.uioutline(tip.badge,a,tint)
    toggle.settooltipicon(state.tooltipicon,kind,x+padding,y+padding,tint,a,true);toggle.setpos(tip.text,x+padding,y+padding+28);tip.text.Text=text;tip.text.Color=bind and color("accent")or color("text");tip.text.Transparency=a;toggle.uioutline(tip.text,a,tip.text.Color)
    tip.bg.Color=color("bg");tip.bg.Transparency=(0.78+0.22*guiopacity)*a;tip.middle.Color=color("outline");tip.middle.Transparency=0.3*a;toggle.setvisible(tip.outer,false);toggle.setvisible(tip.inner,false)
end
local function entrycfg(index)
    if index=="terrainwater"then return toggle.visuals.water elseif index=="correctiontint"then return toggle.visuals.correction end
    if index=="accent"then return themes.accentstyle elseif index=="themebg"then return toggle.themestyles.background elseif index=="themetop"then return toggle.themestyles.topbar elseif index=="themeborder"then return toggle.themestyles.border elseif index=="themeoutline"then return toggle.themestyles.outline elseif index=="themetext"then return toggle.themestyles.text elseif index=="distance"then return toggle.distancestyle elseif index=="rake"then return toggle.rakestyle elseif index=="rakehealth"then return toggle.rakehealthstyle elseif index=="roof"then return roofstyle elseif index=="hudtimer"then return toggle.hudstyles.timer elseif index=="hudtarget"then return toggle.hudstyles.target elseif index=="hudscrap"then return toggle.hudstyles.scrap elseif index=="hudpower"then return toggle.hudstyles.power elseif index=="cooldownlabel"then return toggle.cooldownstyle elseif index=="cooldownvalue"then return toggle.cooldownvaluestyle elseif index=="valuetimer"then return toggle.hudvalues.timer elseif index=="valuetarget"then return toggle.hudvalues.target elseif index=="valuescrap"then return toggle.hudvalues.scrap elseif index=="valuepower"then return toggle.hudvalues.power elseif type(index)=="string"and string.sub(index,1,6)=="crate_"then return toggle.cratestyles[string.sub(index,7)]end
    local entry=colorentries[index];return entry and espcfg[entry.cfgs[1]]or nil
end
toggle.colorname=function(index)
    if type(index)=="number"then return index==1 and"flare esp"or index==7 and"trap esp"or index==8 and"crate esp"or colorentries[index]and colorentries[index].name or"color" elseif type(index)=="string"and string.sub(index,1,6)=="crate_"then local cfg=toggle.cratestyles[string.sub(index,7)];return cfg and cfg.name or"supply item"end
    local names={terrainwater="water",correctiontint="tint color",accent="accent",themebg="background",themetop="top bar",themeborder="border",themeoutline="outline",themetext="text",distance="distance label",rake="rake name",rakehealth="rake health",roof="house roof hp",hudtimer="timer label",hudtarget="target label",hudscrap="scrap label",hudpower="power label",cooldownlabel="cooldown label",cooldownvalue="cooldown value",valuetimer="timer value",valuetarget="target value",valuescrap="scrap value",valuepower="power value"};return names[index]or"color"
end
local function channel(value)return math.floor(clamp(value*255,0,255)+0.5)end
toggle.hexof=function(value)return string.format("%02X%02X%02X",channel(value.R),channel(value.G),channel(value.B))end
local function tohsv(c)
    local r,g,b=c.R,c.G,c.B;local maximum=math.max(r,g,b);local minimum=math.min(r,g,b);local delta=maximum-minimum;local h=0
    if delta>0 then
        if maximum==r then h=((g-b)/delta)%6 elseif maximum==g then h=(b-r)/delta+2 else h=(r-g)/delta+4 end
        h=h/6
    end
    return h,maximum==0 and 0 or delta/maximum,maximum
end
local function section(label,col,info,permission)return {kind="section",label=label,widgetid=label,col=col or 1,info=info,permission=permission}end
toggle.refreshshop=function(force)
    if toggle.shop.ready and not force then return end;toggle.shop.lastscan=tick();for i=1,#toggle.shop.items do local item=toggle.shop.items[i];toggle.shop.lookup[item.label]=item;toggle.shop.lookup[item.name]=item end;toggle.shop.ready=true
end
toggle.shopitem=function()
    toggle.refreshshop(false);return toggle.shop.lookup[toggle.shop.selected]or toggle.shop.items[#toggle.shop.items]
end
toggle.shoplabel=function()local item=toggle.shopitem();return item and item.label or"map"end
toggle.shopindex=function()
    local selected=toggle.shopitem();if not selected then return 1 end;for i=1,#toggle.shop.names do if toggle.shop.names[i]==selected.label then return i end end;return 1
end
toggle.autosellitemslabel=function()return toggle.multilabel(toggle.shop.items,toggle.autosellitems.selected,"name")end
toggle.autobuyitemslabel=function()return toggle.multilabel(toggle.shop.items,toggle.autobuyitems.selected,"name")end
toggle.espelementslabel=function(rake)
    local labels={};if rake then if toggle.rakehealth then labels[#labels+1]="health"end;if toggle.rakedistance then labels[#labels+1]="distance"end;if toggle.rakestatus then labels[#labels+1]="status"end else local state=toggle.playeresp;if state.showusername then labels[#labels+1]="username"end;if state.showhealth then labels[#labels+1]="health"end;if state.showdistance then labels[#labels+1]="distance"end end;return #labels>0 and table.concat(labels,", ")or"none"
end
toggle.playeritemslabel=function()return toggle.multilabel(toggle.playeresp.order,toggle.playeresp.selected,"name")end
toggle.recoverfolder=function()
    local userid=tostring(lp.UserId);local folder=toggle.autorecoverfolder;if folder and folder.Parent and folder.Name==userid then return folder end;local collection=rs:FindFirstChild("CollectionPoint");folder=collection and collection:FindFirstChild(userid)or nil;toggle.autorecoverfolder=folder;return folder
end
toggle.hudautocolor=function()
    local base,background=color("accent"),color("bg");if toggle.hudcolorbase==base and toggle.hudcolorbackground==background and toggle.hudcolorcache then return toggle.hudcolorcache end;toggle.hudcolorbase=base;toggle.hudcolorbackground=background;toggle.hudcolorcache=toggle.textbrightness(background)<0.4 and toggle.colormix(base,toggle.white,0.82)or toggle.colormix(base,Color3.new(0,0,0),0.82);return toggle.hudcolorcache
end
toggle.autocollectname=function(label)for i=1,#toggle.autocollect.order do local entry=toggle.autocollect.order[i];if entry.label==label then return entry.name end end end
toggle.autocollectlabel=function()local labels={};for i=1,#toggle.autocollect.order do local entry=toggle.autocollect.order[i];if toggle.autocollect.selected[entry.name]then labels[#labels+1]=entry.label end end;return #labels>0 and table.concat(labels,", ")or"none"end
toggle.multilabel=function(order,selected,key)local labels={};for i=1,#order do local entry=order[i];local id=type(entry)=="table"and entry[key or"id"]or entry;if selected[id]then labels[#labels+1]=type(entry)=="table"and entry.label or entry end end;return #labels>0 and table.concat(labels,", ")or"none"end
toggle.notificationlabel=function()return toggle.multilabel(toggle.notifyorder,toggle.notifysettings.types)end
toggle.worldlabel=function()return toggle.multilabel(toggle.worldorder,toggle.worldpanelitems)end
toggle.promptlabel=function()return toggle.multilabel(toggle.promptoptionorder,toggle.promptsettings)end
toggle.accentbarlabel=function()return toggle.multilabel(toggle.accentbarorder,toggle.accentbars)end
toggle.resetlabel=function()return toggle.multilabel(toggle.resetorder,toggle.resetselected)end
toggle.multientry=function(order,label)for i=1,#order do local entry=order[i];if entry.label==label then return entry end end end
toggle.inputcursor=function(active)return active and((tick()%0.65)<0.34 and"|"or" ")or""end
toggle.itemshown=function(item,available)
    if item.id=="configname"then return (string.lower(configname)=="default"and"Default"or configname)..toggle.inputcursor(configcapture)elseif item.id=="rakenameinput"then return toggle.rakenamevalue..toggle.inputcursor(toggle.rakenamecapture)end
    if item.inlinebind and item.bind then if capture==item.bind then return"..."elseif(keybinds[item.bind]or 0)==0 then return"-"else return toggle.bindname(item.bind)end end
    local shown=item.display or item.value and tostring(item.value)or"";if item.id=="configselect"and string.lower(shown)=="default"then shown="Default"end;if item.kind=="dropdown"and item.id~="configselect"and item.id~="espfontselect"and item.id~="hudfontselect"then shown=toggle.uititle(shown)end
    if item.kind=="dropdown"then local maxwidth=math.max(0,available or((menustate.w-60)/2-68));if toggle.uiwidth(shown,13)>maxwidth then while #shown>1 and toggle.uiwidth(shown.."..",13)>maxwidth do shown=string.sub(shown,1,-2)end;shown=shown..".."end;return shown end
    if #shown>18 then shown=string.sub(shown,1,16)..".."end;return shown
end
toggle.dropdownkindof=function(id)
    return id=="scrapeditsselect"and"scrapedit"or id=="locationeditselect"and"locationedit"or id=="tracersselect"and"tracers"or id=="hudelementsselect"and"hudelements"or id=="playerelementsselect"and"playerelements"or id=="playerstyleselect"and"playerstyle"or id=="rakestyleselect"and"rakestyle"or id=="rakeelementsselect"and"rakeelements"or id=="espfontselect"and"espfont"or id=="hudfontselect"and"hudfont"or id=="presetselect"and"preset"or id=="distanceunitselect"and"unit"or id=="distancepositionselect"and"distanceposition"or id=="scrapstyleselect"and"scrapstyle"or id=="scrapteleportselect"and"scrapteleport"or id=="ringshapeselect"and"ringshape"or id=="rgbdirectionselect"and"rgbdirection"or id=="containerstyleselect"and"containerstyle"or id=="poweractivitymodeselect"and"poweractivitymode"or id=="notificationpositionselect"and"notificationposition"or id=="notificationtypeselect"and"notificationtypes"or id=="worldstatsselect"and"worldstats"or id=="autocollectselect"and"autocollect"or id=="playeritemsselect"and"playeritems"or id=="promptsselect"and"prompts"or id=="accentbarsselect"and"accentbars"or id=="resetselect"and"resets"or id=="shopitemselect"and"shopitem"or id=="autobuyitemsselect"and"autobuyitems"or id=="autosellitemsselect"and"autosellitems"or id=="configselect"and"config"or nil
end
toggle.itemvaluecolor=function(item)
    if item.inlinebind and item.bind then if capture==item.bind then return toggle.colormix(toggle.accentvisual(),color("bg"),0.55)elseif(keybinds[item.bind]or 0)==0 then return color("muted")else return toggle.accentvisual()end end
    if item.worldkey then return color("text")end
    if item.darkaccent then return toggle.colormix(color("accent"),Color3.new(0,0,0),0.35)end
    if item.kind=="info"then return color(item.subtle and"muted"or"accent")end
    return color((item.stacked or item.kind=="dropdown")and"text"or"accent")
end
toggle.featurecatalog=function(tab)
    local teleportinfo="spaces out teleports to reduce teleport-related deaths"
    local scrap=toggle.scraporder[toggle.scrapedit];local elements=toggle.scrapelements.Scrap1;local location=toggle.locationorder[toggle.locationedit]
    if tab==1 then
        toggle.refreshshop(false)
        local items={
            section("master",1),{id="hybridfeatures",kind="toggle",label="hybrid features",on=toggle.hybridfeatures,info="shows Hybrid Mode sections and options",col=1},{id="bindmenu",kind="bind",bind="menu",inlinebind=true,label="menu toggle",col=1},{id="watermark",kind="toggle",label="watermark state",on=toggle.watermark,col=1},{id="esp",kind="toggle",label="esp switch",on=toggle.esp,bind="esp",inlinebind=true,col=1},{id="hud",kind="toggle",label="hud switch",on=toggle.hud,bind="hud",inlinebind=true,col=1},{id="keybindpanel",kind="toggle",label="keybind panel",on=toggle.keybindpanel,col=1},{id="worldpanel",kind="toggle",label="world stats panel",on=toggle.worldpanel,col=1},{id="worldstatsselect",kind="dropdown",label="world stats",value=toggle.worldlabel(),col=1},
            section("shop",1,"quick actions teleport to trade; nearby automation buys, sells, and recovers selected items","hybrid"),{id="autorecover",kind="toggle",label="auto-recover items",on=toggle.autorecover,info="claims stored items while you are near the shop",col=1},{id="autobuyitemsselect",kind="dropdown",label="items to auto-buy",value=toggle.autobuyitemslabel(),col=1},{id="autosellitemsselect",kind="dropdown",label="items to auto-sell",value=toggle.autosellitemslabel(),col=1},{id="autosellscrap",kind="toggle",label="auto-sell scrap",on=toggle.autosellscrap,info="sells your scraps while you are near the shop until none remain",col=1},{id="sell",kind="toggle",label="tp sell scrap",on=toggle.sellenabled,bind="sell",inlinebind=true,col=1},{id="shopitemselect",kind="dropdown",label="items for quick tp",value=toggle.shoplabel(),col=1},{id="quickbuy",kind="action",label="quick tp buy",col=1},{id="quicksell",kind="action",label="quick tp sell",col=1},
            section("teleports",2),{id="scrap",kind="toggle",label="tp scrap",on=toggle.scrapteleportenabled,bind="scrap",inlinebind=true,col=2},{id="flare",kind="toggle",label="tp flare",on=toggle.flareteleportenabled,bind="flare",inlinebind=true,col=2},{id="scrapteleportselect",kind="dropdown",label="sort scrap by",value=toggle.scrapteleport,col=2},{id="teleportcooldown",kind="toggle",label="tp safe cooldown",on=toggle.teleportcooldown,info=teleportinfo,col=2},{id="cooldownseconds",kind="slider",label="cooldown time",value=toggle.cooldownseconds,min=10,max=30,display=tostring(toggle.cooldownseconds).."s",col=2},
            section("prompts",1,"shows interactive controls over supported house and tower mechanisms","hybrid"),{id="promptmaster",kind="toggle",label="bypass prompts",on=toggle.prompts,info="use the prompt bind near a mechanism; left or right click switches actions",col=1},{id="promptsselect",kind="dropdown",label="prompt panels",value=toggle.promptlabel(),col=1},{id="bindprompt",kind="bind",bind="prompt",inlinebind=true,label="prompt toggle bind",col=1},
            section("combat",1,"uses supported combat remote actions","hybrid"),{id="killaura",kind="toggle",label="stun aura",on=toggle.killaura,bind="aura",inlinebind=true,info="uses an equipped stun stick without consuming stamina",col=1},{id="killaurarange",kind="slider",label="stun range",value=toggle.killaurarange,min=6,max=30,display=tostring(toggle.killaurarange).." studs",col=1},{id="killauradelay",kind="slider",label="stun delay",value=toggle.killauradelay,min=0.05,max=0.6,display=string.format("%.2fs",toggle.killauradelay),col=1},{id="autoheal",kind="toggle",label="auto-heal",on=toggle.autoheal,info="uses an equipped first aid kit when your health drops below the selected amount",col=1},{id="autohealth",kind="slider",label="heal below",value=toggle.autohealth,min=20,max=70,display=tostring(toggle.autohealth).." hp",col=1},
            section("camera",2,"equip an item after enabling third person; change shift lock in Roblox movement settings","unsafe"),{id="thirdperson",kind="toggle",label="third person",on=toggle.zoom.thirdperson,bind="thirdperson",inlinebind=true,col=2},{id="zoomamount",kind="slider",label="zoom amount",value=toggle.zoom.amount,min=0.5,max=100,display=string.format("%.1f studs",toggle.zoom.amount),col=2},{id="shiftlock",kind="toggle",label="shift lock",on=toggle.shiftlockstate.active,col=2},
            section("supply",2),{id="supplylabel",kind="toggle",label="crate esp",on=toggle.supplylabel,colorindex=8,col=2},{id="flares",kind="toggle",label="flare esp",on=espgroups.flares,colorindex=1,col=2},{id="supplyitems",kind="toggle",label="crate inventory",on=toggle.supplyitems,disabled=toggle.instacrate,info="shows crate contents and taken items; locked on while instant crate is enabled",col=2},{id="instacrate",kind="toggle",label="instant crate",on=toggle.instacrate,info="left click selects the next item; right click selects the previous item",permission="hybrid",col=2},{id="bindcrate",kind="bind",label="take item bind",bind="crate",bindinfo="takes the selected crate item; click to change this required bind",inlinebind=true,col=2},{id="autocollect",kind="toggle",label="auto-collect",on=toggle.autocollect.enabled,disabled=not toggle.instacrate,col=2},{id="autocollectselect",kind="dropdown",label="auto-collect items",value=toggle.autocollectlabel(),disabled=not toggle.instacrate,col=2},
            section("client",2),{id="antiCollide",kind="toggle",label="player no-collide",on=toggle.client.antiCollide,bind="collide",inlinebind=true,info="disables collisions with other players; restores them when switched off",col=2},{id="doorNoCollide",kind="toggle",label="Door No-Collide",on=toggle.client.doorNoCollide,bind="door",inlinebind=true,info="walk through the house and tower doors; restores collisions to match their open state when disabled",col=2},{id="preventIdle",kind="toggle",label="Prevent Idle Timeout",on=toggle.client.preventIdle,info="prevents idle kicks; has not been tested",warning=true,unstable=true,col=2},{id="noFall",kind="toggle",label="no fall damage",on=toggle.client.noFall,col=2},{id="towerBarriers",kind="toggle",label="no tower push",on=toggle.client.towerBarriers,info="disables conveyors that push you off the tower fences",col=2},{id="autoradio",kind="toggle",label="auto-take radio",on=toggle.autoradio,info="instantly takes the radio when you are close to its prompt range",permission="hybrid",col=2},{id="noJumpCooldown",kind="toggle",label="no jump cooldown",on=toggle.client.noJumpCooldown,info="may freeze over time; re-enable if needed",warning=true,unstable=true,col=2},{id="infiniteStamina",kind="toggle",label="infinite stamina",on=toggle.client.infiniteStamina,info="may freeze over time; re-enable if needed",warning=true,unstable=true,col=2},
            section("power usage",2),{id="hudpower",kind="toggle",label="power left",on=toggle.hudelements.power,info="reads an existing voltmeter in any player's inventory",col=2},{id="autopower",kind="toggle",label="auto-power station",on=toggle.autopower,info="automatically starts the station while you remain within 4 meters of it",permission="hybrid",col=2},{id="autopowertoolbox",kind="toggle",label="require toolbox",on=toggle.autopowerrequiretoolbox,info="only lets auto-power run while a toolbox is equipped",col=2},{id="poweractivity",kind="toggle",label="activity panel",on=toggle.poweractivity,col=2},{id="poweractivitymodeselect",kind="dropdown",label="show panel when",value=toggle.poweractivitymode,col=2},
            section("players",2),{id="playerelementsselect",kind="dropdown",label="display elements",value=toggle.espelementslabel(false),col=2},{id="playeritemsselect",kind="dropdown",label="show player items",value=toggle.playeritemslabel(),col=2},{id="playerstyleselect",kind="dropdown",label="player esp style",value=toggle.playeresp.style,col=2},{id="playerstacking",kind="toggle",label="Stacking Elements",on=toggle.playeresp.stacking,info="stacks nearby player panels to reduce overlap",col=2},{id="playerdistance",kind="slider",label="render distance",value=toggle.playeresp.distance,min=10,max=150,display=tostring(toggle.playeresp.distance).."m",col=2},
            section("tracers",2),{id="tracersselect",kind="dropdown",label="Show Tracers",value=toggle.multilabel(toggle.tracers.order,toggle.tracers.selected),col=2},{id="traceropacity",kind="slider",label="Tracer Opacity",value=toggle.tracers.opacity,min=0.1,max=1,display=tostring(math.floor(toggle.tracers.opacity*100+0.5)).."%",col=2},{id="tracerspeed",kind="slider",label="Tracer Speed",value=toggle.tracers.speed,min=0.5,max=2,display=string.format("%.2f",toggle.tracers.speed),col=2},section("distance esp",2),{id="distance",kind="toggle",label="distance",on=toggle.distance,colorindex="distance",col=2},{id="distancepositionselect",kind="dropdown",label="label position",value=toggle.distanceposition,col=2},{id="distancemin",kind="slider",label="show distance after",value=toggle.distancemin,min=0,max=100,display=tostring(toggle.distancemin).."m",col=2},
            section("rake",1),{id="hudtarget",kind="toggle",label="show target hud",on=toggle.hudelements.target,col=1},{id="rakenotifydistance",kind="slider",label="warn distance",value=toggle.notifysettings.rakedistance,min=5,max=100,display=tostring(toggle.notifysettings.rakedistance).."m",col=1},{id="rakestyleselect",kind="dropdown",label="rake esp style",value=toggle.rakeespstyle,col=1},{id="rakeelementsselect",kind="dropdown",label="display elements",value=toggle.espelementslabel(true),col=1},{id="rakerenderdistance",kind="slider",label="render distance",value=toggle.rakerenderdistance,min=10,max=150,display=tostring(toggle.rakerenderdistance).."m",col=1},{id="traps",kind="toggle",label="trap esp",on=espgroups.traps,colorindex=7,col=1},
            section("scraps",1),{id="hudscrap",kind="toggle",label="scrap amount hud",on=toggle.hudelements.scrap,col=1},{id="scrapeditsselect",kind="dropdown",label="Choose Tier To Edit",value=scrap.label,col=1},{id="scrapedittoggle",kind="toggle",label=scrap.label.." ESP",on=espgroups.items[scrap.id],itemkey=scrap.id,colorindex=scrap.color,col=1},{id="scrapstyleselect",kind="dropdown",label="Display Scrap Elements",value=toggle.multilabel({"tiers","points"},elements),col=1},
            section("timer",2),{id="powerlevelinfo",kind="info",label="Power Level",info="a player in this server needs a voltmeter in their inventory for the power reading to work",col=1},{id="hudelementsselect",kind="dropdown",label="display elements",value=toggle.hudselectionlabel(),col=1},{id="rakehealthcoloring",kind="toggle",label="health-based coloring",on=toggle.rakehealthcoloring,col=1},{id="playerhealthcoloring",kind="toggle",label="health-based coloring",on=toggle.playeresp.healthcoloring,col=1},{id="hudtimer",kind="toggle",label="timer hud",on=toggle.hudelements.timer,col=2}
        }
        items[#items+1]=section("locations",2);items[#items+1]={id="locationeditselect",kind="dropdown",label="Choose Location To Edit",value=location.label,col=2};items[#items+1]={id="locationedittoggle",kind="toggle",label=location.label.." ESP",on=espgroups.items[location.id],itemkey=location.id,colorindex=location.color,col=2}
        if location.id=="SafehouseMSG"then items[#items+1]={id="roof",kind="toggle",label="Roof Health",on=toggle.roof,col=2}end
        items[#items+1]=section("terrain",1,"changes grass length and water color","unsafe")
        items[#items+1]={id="grasslength",kind="slider",label="Grass Length",value=toggle.visuals.grasslength,min=-0.5,max=1,display=string.format("%.2f",toggle.visuals.grasslength),col=1}
        items[#items+1]={id="terrainwater",kind="color",label="Water",index="terrainwater",col=1}
        for _,entry in ipairs(toggle.posteffectorder)do
            items[#items+1]=section(string.lower(entry.label),1,"customize this effect; switching it off restores its original settings","unsafe")
            items[#items+1]={id=entry.id,kind="toggle",label="Enabled",on=toggle.visuals.effects[entry.class],effectclass=entry.class,col=1}
            for _,field in ipairs(entry.fields)do local value=toggle.effectuivalue(field,entry.values[field.key]);items[#items+1]={id=field.id,kind="slider",label=field.label,value=value,min=field.uimin or field.min,max=field.uimax or field.max,display=string.format("%.2f",value),col=1}end
            if entry.color then items[#items+1]={id="correctiontint",kind="color",label="Tint Color",index="correctiontint",col=1}end
        end
        return items
    elseif tab==2 then
        return {
            section("preferences",1),{id="presetselect",kind="dropdown",label="preset",value=themes[themeindex].name,col=1},{id="containerstyleselect",kind="dropdown",label="container style",value=toggle.containerstyle,col=1},{id="accentbarsselect",kind="dropdown",label="accent bars",value=toggle.accentbarlabel(),col=1},{id="rgbdirectionselect",kind="dropdown",label="accent direction",value=toggle.rgbdirection,col=1},{id="rgbspeed",kind="slider",label="accent bar speed",value=rgbspeed,min=0.5,max=2,display=string.format("%.2fx",rgbspeed),col=1},{id="barrgb",kind="toggle",label="chroma accent",on=toggle.barrgb,col=1},{id="chromasaturation",kind="slider",label="Chroma Saturation",value=toggle.chromasaturation,min=0.2,max=1,display=tostring(math.floor(toggle.chromasaturation*100+0.5)).."%",col=1},{id="chromaspeed",kind="slider",label="chroma speed",value=toggle.chromaspeed,min=0.5,max=2,display=string.format("%.2fx",toggle.chromaspeed),col=1},{id="opacity",kind="slider",label="opacity",value=guiopacity,min=0.5,max=1,display=tostring(math.floor(guiopacity*100+0.5)).."%",col=1},{id="borderradius",kind="slider",label="border radius",value=toggle.borderradius,min=0,max=10,display=tostring(toggle.borderradius).."px",col=1},{id="esptextoutline",kind="toggle",label="esp text outline",on=toggle.esptextoutline,col=1},{id="fontsize",kind="slider",label="text size",value=espfontsize,min=13,max=20,col=1},
            section("custom preset",1),{id="accentcolor",kind="color",label="accent",index="accent",col=1},{id="themebgcolor",kind="color",label="background",index="themebg",col=1},{id="themetopcolor",kind="color",label="top bar",index="themetop",col=1},{id="themebordercolor",kind="color",label="border",index="themeborder",col=1},{id="themeoutlinecolor",kind="color",label="outline",index="themeoutline",col=1},{id="themetextcolor",kind="color",label="text",index="themetext",col=1},
            section("fonts",1),{id="hudfontselect",kind="dropdown",label="HUD Font",value=fontnames[toggle.hudfontindex],col=1},{id="espfontselect",kind="dropdown",label="ESP Font",value=fontnames[fontindex],col=1},
            section("notification",1),{id="notificationtypeselect",kind="dropdown",label="types",value=toggle.notificationlabel(),col=1},{id="notificationpositionselect",kind="dropdown",label="position",value=toggle.notifysettings.position,col=1},{id="notificationduration",kind="slider",label="time",value=toggle.notifysettings.duration,min=1,max=10,display=string.format("%.1fs",toggle.notifysettings.duration),col=1},
            section("configuration",2),{id="configname",kind="text",stacked=true,label="config name",value=configname,col=2},{id="configselect",kind="dropdown",stacked=true,label="config list",value=configslots[configslot]or"none",col=2},{id="save",kind="action",label="save",col=2},{id="load",kind="action",label="load",col=2},{id="deleteconfig",kind="action",label="delete",col=2},
            section("world esp rings",2),{id="ringenabled",kind="toggle",label="esp ring",on=toggle.ringenabled,col=2},{id="ringshapeselect",kind="dropdown",label="shape",value=toggle.ringshape,col=2},{id="ringfade",kind="slider",label="render distance",value=ringfade,min=10,max=150,display=tostring(math.floor(ringfade)).."m",col=2},{id="ringopacity",kind="slider",label="opacity",value=toggle.ringopacity,min=0.1,max=1,display=tostring(math.floor(toggle.ringopacity*100+0.5)).."%",col=2},{id="ringsize",kind="slider",label="size multiplier",value=toggle.ringsize,min=0.5,max=3,display=string.format("%.1fx",toggle.ringsize),col=2},{id="ringspin",kind="toggle",label="rotating ring",on=toggle.ringspin,col=2},{id="ringspinspeed",kind="slider",label="rotation speed",value=toggle.ringspinspeed,min=0.1,max=3,display=string.format("%.1fx",toggle.ringspinspeed),col=2},
            section("reset",2),{id="resetselect",kind="dropdown",label="elements to reset",value=toggle.resetlabel(),col=2},{id="startreset",kind="action",label="start reset",col=2}
        }
    end
    return {}
end
toggle.tabgroups={
    {{"rake",1,{"rakestyleselect","rakeelementsselect","rakehealthcoloring","rakerenderdistance","traps"}},{"players",1,{"playerelementsselect","playerhealthcoloring","playeritemsselect","playerstyleselect","playerstacking","playerdistance"}},{"locations",1,{"locationeditselect","locationedittoggle","roof"}},
     {"display",2,{"esp","esptextoutline"}},{"supply",2,{"supplylabel","flares","supplyitems"}},{"scraps",2,{"scrapstyleselect","scrapeditsselect","scrapedittoggle"}},{"distance esp",2,{"distance","distancepositionselect","distancemin"}},{"tracers",2,{"tracersselect","traceropacity","tracerspeed"}}},
    {{"display",1,{"hud","containerstyleselect"}},{"container",1,{"hudelementsselect","powerlevelinfo"}},{"rake",1,{"rakenotifydistance"}},
     {"world",2,{"worldpanel","worldstatsselect"}},{"activity",2,{"poweractivity","poweractivitymodeselect"}},{"keybinds",2,{"keybindpanel"}}},
    {{"master",1,{"bindmenu","watermark"}},{"client",1,{"noFall","antiCollide","doorNoCollide","towerBarriers","autoradio","preventIdle","noJumpCooldown","infiniteStamina"}},{"combat",1,{"killaura","killaurarange","killauradelay","autoheal","autohealth"}},{"camera",1,{"thirdperson","zoomamount","shiftlock"}},{"world esp rings",1,{"ringenabled","ringshapeselect","ringfade","ringopacity","ringsize","ringspin","ringspinspeed"}},
     {"shop",2,{"autorecover","autobuyitemsselect","autosellitemsselect","autosellscrap","sell","shopitemselect","quickbuy","quicksell"}},{"teleports",2,{"scrap","flare","scrapteleportselect","teleportcooldown","cooldownseconds"}},{"prompts",2,{"promptmaster","promptsselect","bindprompt"}},{"supply",2,{"instacrate","bindcrate","autocollect","autocollectselect"}},{"power station",1,{"autopower","autopowertoolbox"}}},
    {{"preferences",1,{"presetselect","opacity","borderradius","fontsize"}},{"custom preset",1,{"accentcolor","themebgcolor","themetopcolor","themebordercolor","themeoutlinecolor","themetextcolor"}},{"fonts",1,{"hudfontselect","espfontselect"}},{"notifications",1,{"notificationtypeselect","notificationpositionselect","notificationduration"}},
     {"configuration",2,{"configname","configselect","save","load","deleteconfig"}},{"accent bars",2,{"accentbarsselect","rgbdirectionselect","rgbspeed","barrgb","chromasaturation","chromaspeed"}},{"reset",2,{"resetselect","startreset"}}}
}
toggle.tabgroups={toggle.tabgroups[3],toggle.tabgroups[1],toggle.tabgroups[2],toggle.tabgroups[4]}
toggle.tabgroups[1][1][3]={"esp","hud","hybridfeatures"}
for tab=1,4 do
    for i=#toggle.tabgroups[tab],1,-1 do local group=toggle.tabgroups[tab][i]
        if group[1]=="display"then table.remove(toggle.tabgroups[tab],i)
        elseif group[1]=="world esp rings"then table.remove(toggle.tabgroups[tab],i);group[2]=2;toggle.tabgroups[2][#toggle.tabgroups[2]+1]=group
        elseif group[1]=="notifications"then table.remove(toggle.tabgroups[tab],i);group[2]=1;toggle.tabgroups[3][#toggle.tabgroups[3]+1]=group
        elseif group[1]=="container"then group[3]={"hudelementsselect","containerstyleselect","powerlevelinfo"}end
    end
end
for _,group in ipairs({
    {"terrain",1,{"grasslength","terrainwater"}},
    {"depth of field",1,{"postdepth","depthfocus","depthfar","depthnear","depthradius"}},
    {"blur",1,{"postblur","blursize"}},
    {"bloom",2,{"postbloom","bloomintensity","bloomsize","bloomthreshold"}},
    {"color correction",2,{"postcorrection","correctionbrightness","correctioncontrast","correctiontint"}}
})do toggle.tabgroups[2][#toggle.tabgroups[2]+1]=group end
toggle.tabgroups[4][1][3]={"bindmenu","watermark","presetselect","opacity","borderradius","esptextoutline","fontsize"}
local function currentitems(tab)
    tab=tab or menustate.tab
    local lookup,sections,colors={},{},{};for tab=1,2 do local source=toggle.featurecatalog(tab);for i=1,#source do local item=source[i];if item.kind=="section"then sections[item.label]=item elseif item.id then lookup[item.id]=item;if item.kind=="color"then colors[#colors+1]=item end end end end
    local result={};for _,group in ipairs(toggle.tabgroups[tab]or{})do
        local name,col,ids,prefix=group[1],group[2],group[3],group[4];local original=sections[name];local permission=name=="supply"and tab==1 and"hybrid"or original and original.permission
        local hidden=not toggle.hybridfeatures and(permission=="hybrid"or name=="power station")
        if not hidden then
            result[#result+1]=section(name,col,name=="supply"and tab==1 and"interact with crate contents before the crate unlocks; auto-collect chooses available items"or original and original.info,permission)
            for _,id in ipairs(ids)do local item=lookup[id];if item and(toggle.hybridfeatures or item.permission~="hybrid")then item.col=col
                if name=="supply"and tab==1 and item.permission=="hybrid"then item.permission=nil;item.info=nil end
                if item.id=="scrap"or item.id=="flare"or item.id=="sell"then item.kind="bind";item.on=nil;item.bindinfo="press this key to teleport; click to change or remove the bind"elseif id=="barrgb"then item.label="chroma accent bar"elseif id=="bindmenu"then item.bindinfo="opens or closes the menu; click to change this required bind"end
                result[#result+1]=item
            end end
            if prefix then for _,item in ipairs(colors)do if string.sub(item.id,1,#prefix)==prefix then item.col=col;result[#result+1]=item end end end
        end
    end;return result
end
toggle.searchdistance=function(a,b)
    if a==b then return 0 end;if #a==0 then return #b elseif #b==0 then return #a end
    local previous,current={},{};for j=0,#b do previous[j]=j end
    for i=1,#a do current[0]=i;for j=1,#b do local cost=string.sub(a,i,i)==string.sub(b,j,j)and 0 or 1;current[j]=math.min(current[j-1]+1,previous[j]+1,previous[j-1]+cost)end;previous,current=current,previous end
    return previous[#b]
end
toggle.searchcatalog=function()
    local saved=menustate.tab;local catalog={}
    for tab=1,#tabnames do
        menustate.tab=tab;local items=currentitems();local sections={}
        for i=1,#items do local item=items[i];local col=item.col or 1;if item.kind=="section"then sections[col]=item.label elseif item.id and item.label then local aliases=toggle.search.aliases[item.id]or"";catalog[#catalog+1]={id=item.id,label=item.label,tab=tab,tabname=tabnames[tab],section=sections[col]or tabnames[tab],hay=string.lower(item.label.." "..item.id.." "..(sections[col]or"").." "..tabnames[tab].." "..aliases)}end end
    end
    menustate.tab=saved;return catalog
end
toggle.searchscore=function(entry,query)
    query=string.lower(string.gsub(query,"[^%w%s]"," "));query=string.gsub(query,"%s+"," "):gsub("^ ",""):gsub(" $","");if query==""then return nil end
    local direct=string.find(entry.hay,query,1,true);if direct then return direct-1 end
    local words={};for word in string.gmatch(entry.hay,"%w+")do words[#words+1]=word end;local score=20
    for wanted in string.gmatch(query,"%w+")do local best=99;for i=1,#words do local word=words[i];if string.find(word,wanted,1,true)==1 or string.find(wanted,word,1,true)==1 then best=math.min(best,0.5)else best=math.min(best,toggle.searchdistance(wanted,word))end end;local tolerance=math.max(1,math.floor(#wanted/3));if best>tolerance then return nil end;score=score+best end
    return score
end
toggle.rebuildsearch=function()
    local search=toggle.search;search.results={};if search.query==""then return end;local catalog=toggle.searchcatalog()
    for i=1,#catalog do local entry=catalog[i];local score=toggle.searchscore(entry,search.query);if score then entry.score=score;search.results[#search.results+1]=entry end end
    table.sort(search.results,function(a,b)return a.score==b.score and a.label<b.label or a.score<b.score end)
end
toggle.searchselect=function(index)
    local entry=toggle.search.results[index];if not entry then return end;if entry.tab~=menustate.tab then menustate.tabslide=entry.tab>menustate.tab and 4 or-4;menustate.tabfade=0.82 end;menustate.tab=entry.tab;menustate.widgetclosed[entry.tab]=menustate.widgetclosed[entry.tab]or{};menustate.widgetclosed[entry.tab][entry.section]=false;menustate.itemsdirty=true;menustate.searchtarget=entry.id;menustate.searchtab=entry.tab;menustate.searchhighlight=entry.id;menustate.searchhighlightuntil=tick()+2.8;toggle.search.active=false;capture=nil;pickerentry=nil;dropdownkind=nil;configcapture=false;toggle.rakenamecapture=false
end
toggle.rowheight=function(item)return(item.stacked or item.kind=="dropdown")and 64 or item.kind=="section"and 38 or item.kind=="slider"and 50 or item.kind=="action"and 42 or item.kind=="info"and 26 or item.kind=="toggle"and 36 or 32 end
local function displaysize()local phase=clamp(((menustate.minimizeanim or 0)-0.42)/0.58,0,1);return math.floor(menustate.w+(menustate.watermarkw-menustate.w)*phase+0.5),math.floor(menustate.h+(menustate.watermarkh-menustate.h)*phase+0.5)end
toggle.searchupdate=function()
    local search,ui=toggle.search,toggle.search.ui;local expanded=toggle.menu and not menustate.minimized and(menustate.contentfade or 0)>0.01 and(menustate.menuanim or 0)>0.01
    local displayw=displaysize();local iconx,icony=menustate.x+displayw-60,menustate.y+16;toggle.seticon(ui.icon,"search",iconx,icony,14,color("text"),menustate.menuanim or 0,expanded);search.layouts.icon={x=iconx-6,y=menustate.y+9,w=26,h=30}
    search.anim=toggle.ease(search.anim or 0,expanded and not pickerentry and search.open and 1 or 0,search.open and 0.28 or 0.30);local on=search.anim>0.01
    if not on then for _,d in ipairs({ui.outer,ui.middle,ui.inner,ui.bg,ui.top,ui.title,ui.fieldborder,ui.fieldbg,ui.fieldtext,ui.status})do toggle.setvisible(d,false)end;for i=1,search.max do for _,d in pairs(ui.rows[i])do toggle.setvisible(d,false)end end;toggle.paintgradient(ui.gradient,false);search.layouts.panel=nil;return end
    local count=math.min(#search.results,search.max);local targeth=108+math.max(1,count)*search.rowh;search.drawh=toggle.ease(search.drawh,targeth,0.20)
    local w,h=search.w,search.drawh;local px=menustate.x+menustate.w+12;if px+w>cam.ViewportSize.X then px=menustate.x-w-12 end;px=clamp(px,8,math.max(8,cam.ViewportSize.X-w-8))
    local py=clamp(menustate.y,8,math.max(8,cam.ViewportSize.Y-h-8));px=px+(1-search.anim)*10*(px>menustate.x and-1 or 1);local a=search.anim;local shell=guiopacity*a
    search.layouts.panel={x=px,y=py,w=w,h=h};search.layouts.field={x=px+14,y=py+47,w=w-28,h=36}
    toggle.setpos(ui.bg,px,py);ui.bg.Size=Vector2.new(w,h);ui.middle.Position=ui.bg.Position;ui.middle.Size=ui.bg.Size;toggle.setpos(ui.title,px+16,py+17)
    toggle.setpos(ui.fieldbg,px+14,py+47);ui.fieldbg.Size=Vector2.new(w-28,36);ui.fieldborder.Position=ui.fieldbg.Position;ui.fieldborder.Size=ui.fieldbg.Size
    toggle.setpos(ui.fieldtext,px+25,py+60);ui.fieldtext.Text=search.query~=""and(search.query..toggle.inputcursor(search.active))or(search.active and toggle.inputcursor(true)or"Search features...")
    ui.title.Text="Search"
    toggle.setprop(ui.bg,"Color",color("bg"));toggle.setprop(ui.bg,"Transparency",shell);toggle.setprop(ui.middle,"Color",color("outline"));toggle.setprop(ui.middle,"Transparency",0.25*shell)
    toggle.setprop(ui.fieldbg,"Color",toggle.colormix(color("bg"),color("text"),0.06));toggle.setprop(ui.fieldbg,"Transparency",shell);toggle.setprop(ui.fieldborder,"Color",search.active and toggle.accentvisual()or color("outline"));toggle.setprop(ui.fieldborder,"Transparency",(search.active and 0.55 or 0.20)*shell)
    toggle.setprop(ui.title,"Color",color("text"));toggle.setprop(ui.title,"Transparency",a);toggle.setprop(ui.fieldtext,"Color",(search.query~=""or search.active)and color("text")or color("muted"));toggle.setprop(ui.fieldtext,"Transparency",a)
    for _,d in ipairs({ui.bg,ui.middle,ui.title,ui.fieldbg,ui.fieldborder,ui.fieldtext})do toggle.setvisible(d,true)end;for _,d in ipairs({ui.outer,ui.inner,ui.top})do toggle.setvisible(d,false)end;toggle.uioutline(ui.title,a,ui.title.Color);toggle.uioutline(ui.fieldtext,a,ui.fieldtext.Color)
    toggle.layoutgradient(ui.gradient,px+toggle.gradientinset(),py+3,math.max(1,w-toggle.gradientinset()*2));toggle.paintgradient(ui.gradient,false)
    toggle.setpos(ui.status,px+w/2,py+112);ui.status.Text=search.query==""and"Find any feature"or"No matching features";toggle.setprop(ui.status,"Color",color("muted"));toggle.setprop(ui.status,"Transparency",a);toggle.setvisible(ui.status,search.query==""or count==0);toggle.uioutline(ui.status,a,ui.status.Color);search.layouts.rows={}
    for i=1,search.max do
        local row,entry=ui.rows[i],search.results[i];local y=py+96+(i-1)*search.rowh;local visible=i<=count and y+search.rowh<=py+h-8;local hover=visible and inside(mouse.X,mouse.Y,px+12,y,w-24,search.rowh-2)
        local key="search:"..i;menustate.hover[key]=toggle.ease(menustate.hover[key],hover and 1 or 0,0.18);toggle.setpos(row.bg,px+12,y);row.bg.Size=Vector2.new(w-24,search.rowh-2)
        toggle.setpos(row.label,px+23,y+6);toggle.setpos(row.context,px+23,y+24);if entry then row.label.Text=toggle.uititle(entry.label);row.context.Text=toggle.uititle(entry.tabname.." / "..entry.section) end
        toggle.setprop(row.bg,"Color",toggle.colormix(color("bg"),toggle.accentvisual(),0.06+0.08*menustate.hover[key]));toggle.setprop(row.bg,"Transparency",shell*(0.35+0.65*menustate.hover[key]))
        toggle.setprop(row.label,"Color",hover and toggle.accentvisual()or color("text"));toggle.setprop(row.context,"Color",color("muted"));toggle.uioutline(row.label,a,row.label.Color);toggle.uioutline(row.context,a,row.context.Color)
        for _,d in pairs(row)do toggle.setvisible(d,visible);if d~=row.bg then toggle.setprop(d,"Transparency",a)end end
        if visible then search.layouts.rows[i]={x=px+12,y=y,w=w-24,h=search.rowh-2}end
    end
end
toggle.searchiconhit=function(x,y)local l=toggle.search.layouts.icon;return l and toggle.search.ui.icon.Visible and not menustate.minimized and inside(x,y,l.x,l.y,l.w,l.h)end
toggle.searchpanelhit=function(x,y)local l=toggle.search.layouts.panel;return toggle.search.open and l and inside(x,y,l.x,l.y,l.w,l.h)end
toggle.searchclick=function(x,y)
    local search=toggle.search;if toggle.searchiconhit(x,y)then if configcapture and toggle.finishconfiginput then toggle.finishconfiginput(false)end;if toggle.rakenamecapture and toggle.finishrakename then toggle.finishrakename(false)end;search.open=not search.open;search.active=search.open;if search.open then toggle.rebuildsearch()end;capture=nil;pickerentry=nil;dropdownkind=nil;return true end
    if not search.open then return false end;local field=search.layouts.field;if field and inside(x,y,field.x,field.y,field.w,field.h)then search.active=true;return true end
    for i=1,#(search.layouts.rows or{})do local row=search.layouts.rows[i];if row and inside(x,y,row.x,row.y,row.w,row.h)then toggle.searchselect(i);return true end end
    if toggle.searchpanelhit(x,y)then search.active=false;return true end;search.active=false;search.open=false;return false
end
toggle.applymenuradius=function()
    local r=math.min(10,toggle.borderradius)
    for _,d in ipairs({menubg,menuchrome.border,toggle.search.ui.bg,toggle.search.ui.middle,toggle.menuinfo.tooltip.bg,toggle.menuinfo.tooltip.middle})do pcall(function()d.Corner=r end)end
    for _,d in ipairs({menuside,menuchrome.tabindicator,menuchrome.scrolltrack,menuchrome.scrollthumb,toggle.search.ui.fieldbg,toggle.search.ui.fieldborder,toggle.uimodern.buttons[1],toggle.uimodern.buttons[2]})do pcall(function()d.Corner=math.min(7,r)end)end
    for i=1,#tabnames do pcall(function()tabbg[i].Corner=math.min(7,r)end)end
    for i in pairs(itembg)do
        for _,d in ipairs({itembg[i],itemborder[i]})do pcall(function()d.Corner=math.min(5,r)end)end
        for _,d in ipairs({itemmark[i],markborder[i],itemtrack[i],itemfill[i],toggle.inlinecolors.mark[i]})do pcall(function()d.Corner=math.min(5,r)end)end
    end
    for i=1,toggle.search.max do pcall(function()toggle.search.ui.rows[i].bg.Corner=math.min(7,r)end)end
    pcall(function()dropdown.panel.Corner=math.max(0,math.min(8,r)-1);dropdown.border.Corner=math.min(8,r);dropdown.scrollthumb.Corner=2 end)
end
local function clampmenu()
    menustate.h=clamp(menustate.h,math.min(340,cam.ViewportSize.Y-36),math.max(1,cam.ViewportSize.Y-36))
    local v=cam.ViewportSize;local w,h=displaysize()
    menustate.x=clamp(menustate.x,0,math.max(0,v.X-w));menustate.y=clamp(menustate.y,0,math.max(0,v.Y-h))
end
local function menupos()
    if toggle.uibatch then menustate.itemsdirty=true;return end
    menustate.watermarkw=toggle.fontvalue("hud")==Drawing.Fonts.Minecraft and 110 or math.ceil(toggle.uiwidth(toggle.menutitle(),13)+46)
    menustate.w=math.max(180,math.min(564,cam.ViewportSize.X-36));menustate.h=clamp(menustate.h or 660,math.min(340,cam.ViewportSize.Y-36),math.max(1,cam.ViewportSize.Y-36))
    clampmenu();menustate.tabfade=toggle.ease(menustate.tabfade,1,0.38);menustate.tabslide=toggle.ease(menustate.tabslide,0,0.36)
    menustate.positionanimating=math.abs(menustate.tabfade-1)>0.001 or math.abs(menustate.tabslide)>0.001
    local displayw,displayh=displaysize();local expanded=1-(menustate.minimizeanim or 0)
    toggle.setpos(menubg,menustate.x,menustate.y);menubg.Size=Vector2.new(displayw,displayh)
    toggle.setpos(menutop,menustate.x+1,menustate.y+1);menutop.Size=Vector2.new(math.max(1,displayw-2),menustate.minimized and menustate.watermarkh-2 or 46)
    menuchrome.border.Position=menubg.Position;menuchrome.border.Size=menubg.Size
    toggle.setpos(menutitle,menustate.x+18-6*(1-expanded),menustate.y+15-5*(1-expanded));toggle.setpos(menuclose,menustate.x+displayw-28+6*(1-expanded),menustate.y+18-7*(1-expanded));menuclose.Size=Vector2.new(10,10)
    menustate.headerh=32+8*expanded;menustate.bodytop=90
    menustate.nav={x=menustate.x+18,y=menustate.y+42,w=menustate.w-36,h=34}
    local nav=menustate.nav;local tabw=nav.w/#tabnames
    for i=1,#tabnames do
        local x=nav.x+(i-1)*tabw;toggle.setpos(tabbg[i],x,nav.y);tabbg[i].Size=Vector2.new(tabw,nav.h)
        if i==menustate.tab then menustate.indicatorx=toggle.ease(menustate.indicatorx,x,0.30);menustate.indicatorw=toggle.ease(menustate.indicatorw,tabw,0.30);if math.abs(menustate.indicatorx-x)>0.001 then menustate.positionanimating=true end end
    end
    toggle.setpos(menuchrome.tabindicator,menustate.indicatorx or nav.x,nav.y);menuchrome.tabindicator.Size=Vector2.new(menustate.indicatorw or tabw,nav.h)
    if menustate.itemsdirty or not menustate.rawitems then menustate.rawitems=currentitems();menustate.itemsdirty=false end
    menuitems=toggle.preparewidgets(menustate.rawitems);itemlayouts={};toggle.menuinfo.layouts={};toggle.menuinfo.bindlayouts={}
    if menustate.widgetanimating then menustate.positionanimating=true end
    local left=menustate.x+18;local ystart=menustate.y+menustate.bodytop;local cliptop=ystart;local clipbottom=math.max(cliptop,math.min(menustate.y+menustate.h-(menustate.footerheight or 44),menustate.y+displayh-(menustate.footerheight or 44)));local gap=16;local w=(menustate.w-44-gap)/2
    local buffers=menustate.layoutbuffers;if not buffers then buffers={advances={},groups={},natural={0,0},nextkind={}};menustate.layoutbuffers=buffers end;local advances,groups,natural=buffers.advances,buffers.groups,buffers.natural;natural[1],natural[2]=0,0;for i in pairs(groups)do groups[i]=nil end;local nextkind=buffers.nextkind;nextkind[1],nextkind[2]=nil,nil;local sectiongap,sectionpadding=14,10
    for i=#menuitems,1,-1 do
        local item=menuitems[i];local col=item.col or 1;local last=nextkind[col]==nil or nextkind[col]=="section";nextkind[col]=item.kind
        advances[i]=toggle.rowheight(item)*(item.widgetphase or 1)+(last and sectiongap+sectionpadding*(item.kind=="section"and(item.openphase or 1)or(item.widgetphase or 1))or 0);natural[item.col or 1]=natural[item.col or 1]+advances[i]
    end
    for col=1,2 do local total=0;for i=#menuitems,1,-1 do if(menuitems[i].col or 1)==col then total=total+advances[i];if menuitems[i].kind=="section"then groups[i]=total;total=0 end end end end
    local viewport=math.max(0,clipbottom-cliptop);local content=math.max(natural[1],natural[2]);local maxscroll=math.max(0,content-viewport)
    menustate.scrollmax[menustate.tab]=maxscroll;menustate.scrolltarget[menustate.tab]=clamp(menustate.scrolltarget[menustate.tab]or 0,0,maxscroll)
    local targetscroll=menustate.scrolltarget[menustate.tab];local scroll=toggle.ease(menustate.scroll[menustate.tab]or targetscroll,targetscroll,0.40);menustate.scroll[menustate.tab]=scroll
    if math.abs(scroll-targetscroll)>0.001 then menustate.positionanimating=true end
    local renderscroll=math.floor(scroll*2+0.5)/2;local ys={ystart-renderscroll,ystart-renderscroll};local groupbottom={clipbottom,clipbottom}
    for i=1,#menuitems do
        local item=menuitems[i];local col=item.col or 1;local x=left+(col-1)*(w+gap)+menustate.tabslide;local y=ys[col];local h=toggle.rowheight(item);local panelh=groups[i]or h;local stacked=item.stacked or item.kind=="dropdown"
        if item.kind=="section"then groupbottom[col]=math.min(clipbottom,y+panelh-sectiongap)end
        local rowclip=item.kind=="section"and clipbottom or groupbottom[col];local phase=item.widgetphase or 1;local texty=y+(item.kind=="section"and 12 or item.kind=="action"and 11 or stacked and 6 or 10);local valuey=stacked and y+35 or texty
        local renderh=item.kind=="section"and panelh-sectiongap or h;local overlap=math.min(y+renderh,rowclip)-math.max(y,cliptop);local visible=overlap>4 and phase>0.015 and(menustate.menuanim or 0)>0.001
        local fade=(visible and(item.kind=="section"and 1 or toggle.edgefade(texty,texty+16,cliptop,clipbottom))or 0)*menustate.tabfade*phase
        local fieldtop=stacked and y+25 or y;local fieldbottom=stacked and y+57 or y+h-(item.kind=="action"and 7 or 3);local fieldvisible=visible and math.min(fieldbottom,rowclip)-math.max(fieldtop,cliptop)>4
        local fieldfade=(fieldvisible and toggle.edgefade(math.max(fieldtop,cliptop),math.min(fieldbottom,rowclip),cliptop,clipbottom)or 0)*menustate.tabfade*phase
        local textvisible=visible and texty>=cliptop and texty+16<=rowclip;local valuevisible=visible and valuey>=cliptop and valuey+16<=rowclip
        local textfade=textvisible and toggle.edgefade(texty,texty+16,cliptop,clipbottom)*menustate.tabfade*phase or 0;local valuefade=valuevisible and toggle.edgefade(valuey,valuey+16,cliptop,clipbottom)*menustate.tabfade*phase or 0
        local l={x=x,y=y,w=w,h=h,panelh=panelh,item=item,visible=visible,fade=fade,fieldfade=fieldfade,fieldvisible=fieldvisible,linefade=textfade,sliderfade=fade,textfade=textfade,valuefade=valuefade,textvisible=textvisible,valuevisible=valuevisible,markvisible=textvisible,linevisible=textvisible,trackvisible=y+38<=rowclip and y+27>=cliptop,hittop=math.max(y,cliptop),hitbottom=math.min(y+h*phase,rowclip),cliptop=cliptop,clipbottom=rowclip};itemlayouts[i]=l
        l.controlx=x+8;l.controly=fieldtop;l.controlw=w-16;l.controlh=math.max(0,fieldbottom-fieldtop)
        if visible then
            toggle.ensuremenurow(i);menustate.itemkinds[i]=item.kind;setz(itembg[i],item.kind=="section"and 105 or 110)
            l.valuebudget=item.kind=="dropdown"and math.max(0,l.controlw-56)or nil;local shown=toggle.itemshown(item,l.valuebudget);local valuewidth=toggle.uiwidth(shown,13);itemvalue[i].Text=shown;toggle.setprop(itemvalue[i],"Size",13);if not item.inlinebind then toggle.setprop(itemvalue[i],"Center",false)end
            toggle.setpos(itemlabel[i],x+(item.kind=="toggle"and 48 or 12),texty);itemlabel[i].Center=false
            if not item.inlinebind then toggle.setpos(itemvalue[i],stacked and x+23 or x+w-12-valuewidth,valuey)end
            toggle.setpos(itembg[i],x+8,fieldtop);itembg[i].Size=Vector2.new(w-16,math.max(0,fieldbottom-fieldtop));itemborder[i].Position=itembg[i].Position;itemborder[i].Size=itembg[i].Size
            if item.kind=="section"then
                local top=math.max(y,cliptop);local bottom=math.min(y+renderh,clipbottom);toggle.setpos(itembg[i],x,top);itembg[i].Size=Vector2.new(w,math.max(0,bottom-top));local ax,ay=x+w-17,y+18;local angle=(1-(item.openphase or 1))*math.pi/2
                for key,p in pairs({PointA={-3,-2},PointB={3,-2},PointC={0,2}})do local dx=p[1]*math.cos(angle)+p[2]*math.sin(angle);local dy=-p[1]*math.sin(angle)+p[2]*math.cos(angle);itemarrow[i][key]=Vector2.new(ax+dx,ay+dy)end
                l.collapsex=ax-12;l.collapsey=ay-12;l.collapsew=24;l.collapseh=24
            elseif item.kind=="dropdown"then
                local ax,ay=x+w-22,y+41;local opened=toggle.dropdownkindof(item.id)==dropdownkind;local angle=opened and math.pi/2 or 0
                for key,p in pairs({PointA={-3.5,-2},PointB={3.5,-2},PointC={0,2.5}})do itemarrow[i][key]=Vector2.new(ax+p[1]*math.cos(angle)+p[2]*math.sin(angle),ay-p[1]*math.sin(angle)+p[2]*math.cos(angle))end
            elseif item.kind=="action"then toggle.setpos(itemlabel[i],x+(w-toggle.uiwidth(toggle.uititle(item.label)))/2,texty)
            elseif item.kind=="slider"then
                local key=tostring(menustate.tab)..":"..item.id;local target=clamp((item.value-item.min)/(item.max-item.min),0,1);local ratio=toggle.ease(menustate.slideranim[key],target,0.24);menustate.slideranim[key]=ratio;if math.abs(ratio-target)>0.001 then menustate.positionanimating=true end
                toggle.setpos(itemtrack[i],x+12,y+31);itemtrack[i].Size=Vector2.new(w-24,4);itemfill[i].Position=itemtrack[i].Position;itemfill[i].Size=Vector2.new((w-24)*ratio,4);toggle.setpos(itemmark[i],x+8+(w-24)*ratio,y+28);itemmark[i].Size=Vector2.new(10,10)
            elseif item.kind=="toggle"then
                l.togglex=x+8;l.toggley=y+3;l.togglew=38;l.toggleh=26;l.markvisible=y+7>=cliptop and y+25<=rowclip
            elseif item.kind=="color"then
                toggle.setpos(itemmark[i],x+w-34,y+7);itemmark[i].Size=Vector2.new(22,14)
            end
            if item.info then
                local infox=item.kind=="section"and x+19+toggle.uiwidth(toggle.uititle(item.label),13)or item.colorindex and x+w-59 or item.inlinebind and x+w-30 or x+w-30
                if item.kind=="action"then infox=x+w-32 end
                toggle.menuinfo.layouts[i]={x=infox-2,y=texty-2,w=22,h=20,text=item.info,warning=item.warning,unstable=item.unstable,permission=item.permission,visible=textvisible}
            end
            if item.inlinebind then l.bindw=math.max(26,valuewidth+14);l.bindx=x+w-12-(item.info and 24 or 0)-l.bindw;l.bindh=math.max(22,toggle.menulineheight+8);l.bindy=texty-(l.bindh-13)/2;toggle.setpos(toggle.bindbgs[i],l.bindx,l.bindy);toggle.setprop(toggle.bindbgs[i],"Size",Vector2.new(l.bindw,l.bindh));toggle.centertext(itemvalue[i],l.bindx+l.bindw/2,l.bindy+l.bindh/2);toggle.menuinfo.bindlayouts[i]={x=l.bindx,y=l.bindy,w=l.bindw,h=l.bindh,text=item.bindinfo or toggle.bindinfo,bind=true,visible=valuevisible}end
            if item.colorindex then l.colorx=x+w-35;l.colory=y+6;l.colorw=24;l.colorh=16;toggle.setpos(toggle.inlinecolors.mark[i],l.colorx,l.colory);toggle.inlinecolors.mark[i].Size=Vector2.new(l.colorw,l.colorh)end
            for _,d in ipairs(item.kind=="toggle"and{itembg[i],itemborder[i],itemtrack[i],itemfill[i],toggle.inlinecolors.mark[i]}or{itembg[i],itemborder[i],markborder[i],itemmark[i],itemtrack[i],itemfill[i],toggle.inlinecolors.mark[i]})do local p,size=d.Position,d.Size;local top=math.max(cliptop,p.Y);local bottom=math.min(rowclip,p.Y+size.Y);if top~=p.Y or bottom~=p.Y+size.Y then toggle.setpos(d,p.X,top);d.Size=Vector2.new(size.X,math.max(0,bottom-top))end end
        end
        ys[col]=y+advances[i]
    end
    if menustate.searchtarget and menustate.searchtab==menustate.tab then for i=1,#itemlayouts do local l=itemlayouts[i];if l.item.id==menustate.searchtarget then menustate.scrolltarget[menustate.tab]=clamp(l.y+renderscroll-ystart-18,0,maxscroll);menustate.searchtarget=nil;menustate.searchtab=nil;menustate.positionanimating=true;break end end end
    local trackx=menustate.x+menustate.w-12;local thumbh=maxscroll>0 and math.max(32,viewport*viewport/math.max(viewport,content))or viewport;local thumby=cliptop+(viewport-thumbh)*(maxscroll>0 and scroll/maxscroll or 0)
    toggle.setpos(menuchrome.scrolltrack,trackx,cliptop);menuchrome.scrolltrack.Size=Vector2.new(3,viewport);toggle.setpos(menuchrome.scrollthumb,trackx,thumby);menuchrome.scrollthumb.Size=Vector2.new(3,thumbh)
    menustate.scrollthumb={x=trackx-9,y=thumby,w=20,h=thumbh,tracky=cliptop,trackh=viewport,thumbh=thumbh}
    toggle.layoutgradient(menurgb,menustate.x+toggle.gradientinset(),menustate.y+3,math.max(1,displayw-toggle.gradientinset()*2))
end
local function dropdownvalues()
    if dropdownkind=="scrapedit"then local values={};for i=1,#toggle.scraporder do values[i]=toggle.scraporder[i].label end;return values
    elseif dropdownkind=="locationedit"then local values={};for i=1,#toggle.locationorder do values[i]=toggle.locationorder[i].label end;return values
    elseif dropdownkind=="playerstyle"or dropdownkind=="rakestyle"then return {"modern","legacy"}
    elseif dropdownkind=="hudelements"then local values={};for _,entry in ipairs(toggle.hudselectionorder)do values[#values+1]=entry.label end;return values
    elseif dropdownkind=="rakeelements"then return {"health","distance","status"}
    elseif dropdownkind=="playerelements"then return {"username","health","distance"}
    elseif dropdownkind=="espfont"or dropdownkind=="hudfont"then return fontnames
    elseif dropdownkind=="preset"then local values={};for i=1,#themes do values[i]=themes[i].name end;return values
    elseif dropdownkind=="distanceposition"then return {"below","above"}
    elseif dropdownkind=="scrapstyle"then return {"tiers","points"}
    elseif dropdownkind=="scrapteleport"then return {"nearest","value","random"}
    elseif dropdownkind=="ringshape"then return {"circle","square","triangle","hexagon"}
    elseif dropdownkind=="rgbdirection"then return {"left","right"}
    elseif dropdownkind=="containerstyle"then return {"modern","legacy"}
    elseif dropdownkind=="poweractivitymode"then return {"activity","always"}
    elseif dropdownkind=="notificationposition"then return {"bottom left","bottom right","middle left","middle right"}
    elseif dropdownkind=="tracers"then return toggle.tracers.order
    elseif dropdownkind=="notificationtypes"then return toggle.notifyorder
    elseif dropdownkind=="worldstats"then local values={};for i=1,#toggle.worldorder do values[i]=toggle.worldorder[i].label end;return values
    elseif dropdownkind=="autocollect"then local values={};for i=1,#toggle.autocollect.order do values[i]=toggle.autocollect.order[i].label end;return values
    elseif dropdownkind=="prompts"then local values={};for i=1,#toggle.promptoptionorder do values[i]=toggle.promptoptionorder[i].label end;return values
    elseif dropdownkind=="accentbars"then local values={};for i=1,#toggle.accentbarorder do values[i]=toggle.accentbarorder[i].label end;return values
    elseif dropdownkind=="resets"then local values={};for i=1,#toggle.resetorder do values[i]=toggle.resetorder[i].label end;return values
    elseif dropdownkind=="playeritems"then return toggle.playeresp.names
    elseif dropdownkind=="shopitem"or dropdownkind=="autobuyitems"or dropdownkind=="autosellitems"then toggle.refreshshop(false);return toggle.shop.names
    elseif dropdownkind=="config"then return configslots end
    return {}
end
local function dropdownupdate(visible)
    local values=dropdownvalues();dropdownlayouts={};local rowid=dropdownkind=="scrapedit"and"scrapeditsselect"or dropdownkind=="locationedit"and"locationeditselect"or dropdownkind=="tracers"and"tracersselect"or dropdownkind=="hudelements"and"hudelementsselect"or dropdownkind=="playerelements"and"playerelementsselect"or dropdownkind=="playerstyle"and"playerstyleselect"or dropdownkind=="rakestyle"and"rakestyleselect"or dropdownkind=="rakeelements"and"rakeelementsselect"or dropdownkind=="espfont"and"espfontselect"or dropdownkind=="hudfont"and"hudfontselect"or dropdownkind=="preset"and"presetselect"or dropdownkind=="unit"and"distanceunitselect"or dropdownkind=="distanceposition"and"distancepositionselect"or dropdownkind=="scrapstyle"and"scrapstyleselect"or dropdownkind=="scrapteleport"and"scrapteleportselect"or dropdownkind=="ringshape"and"ringshapeselect"or dropdownkind=="rgbdirection"and"rgbdirectionselect"or dropdownkind=="containerstyle"and"containerstyleselect"or dropdownkind=="poweractivitymode"and"poweractivitymodeselect"or dropdownkind=="notificationposition"and"notificationpositionselect"or dropdownkind=="notificationtypes"and"notificationtypeselect"or dropdownkind=="worldstats"and"worldstatsselect"or dropdownkind=="autocollect"and"autocollectselect"or dropdownkind=="playeritems"and"playeritemsselect"or dropdownkind=="prompts"and"promptsselect"or dropdownkind=="accentbars"and"accentbarsselect"or dropdownkind=="resets"and"resetselect"or dropdownkind=="shopitem"and"shopitemselect"or dropdownkind=="autobuyitems"and"autobuyitemsselect"or dropdownkind=="autosellitems"and"autosellitemsselect"or"configselect";local source=nil
    for i=1,#itemlayouts do if itemlayouts[i].item.id==rowid and itemlayouts[i].visible then source=itemlayouts[i];break end end
    if not visible or not source then if not dropdown.opened then return end;dropdown.opened=false;dropdown.anim=0;dropdown.layout=nil;dropdown.scrollmax=0;toggle.setvisible(dropdown.panel,false);toggle.setvisible(dropdown.border,false);toggle.setvisible(dropdown.accent,false);toggle.setvisible(dropdown.scrolltrack,false);toggle.setvisible(dropdown.scrollborder,false);toggle.setvisible(dropdown.scrollthumb,false);for i=1,dropdown.max do toggle.setvisible(dropdown.bg[i],false);toggle.setvisible(dropdown.text[i],false)end;return end
    local count=math.min(#values,dropdown.visiblemax,math.max(1,math.floor((menustate.h-(menustate.bodytop or 100)-(menustate.footerheight or 52)-20)/30)));dropdown.scrollmax=math.max(0,#values-count)
    if not dropdown.opened then local selectedindex=dropdownkind=="scrapedit"and toggle.scrapedit or dropdownkind=="locationedit"and toggle.locationedit or dropdownkind=="espfont"and fontindex or dropdownkind=="hudfont"and toggle.hudfontindex or dropdownkind=="preset"and themeindex or dropdownkind=="shopitem"and toggle.shopindex()or dropdownkind=="config"and math.max(1,configslot)or 1;dropdown.offset=clamp(selectedindex-math.ceil(count/2),0,dropdown.scrollmax);dropdown.scroll=dropdown.offset;dropdown.anim=0;dropdown.opened=true end
    dropdown.offset=clamp(dropdown.offset or 0,0,dropdown.scrollmax);dropdown.scroll=toggle.ease(dropdown.scroll,dropdown.offset,0.3);if math.abs(dropdown.scroll-dropdown.offset)<0.001 then dropdown.scroll=dropdown.offset end;dropdown.anim=toggle.ease(dropdown.anim,1,0.38)
    local w,rowh=source.w-16,30;local x=source.x+8;local y=source.y+source.h-3;local panelh=count*rowh+7
    y=clamp(y,menustate.y+(menustate.bodytop or 100),math.max(menustate.y+(menustate.bodytop or 100),menustate.y+menustate.h-(menustate.footerheight or 52)-8-panelh))+math.floor((1-dropdown.anim)*6+0.5);toggle.setpos(dropdown.panel,x-2,y-3);dropdown.panel.Size=Vector2.new(w+4,panelh-2);dropdown.panel.Color=color("bg");dropdown.panel.Transparency=(0.80+guiopacity*0.20)*dropdown.anim;toggle.setvisible(dropdown.panel,true);toggle.setpos(dropdown.border,x-3,y-4);dropdown.border.Size=Vector2.new(w+6,panelh);dropdown.border.Color=color("outline");dropdown.border.Transparency=0.30*dropdown.anim;toggle.setvisible(dropdown.border,true);toggle.setpos(dropdown.accent,x-2,y-3);dropdown.accent.Size=Vector2.new(w+4,2);dropdown.accent.Color=toggle.accentvisual();dropdown.accent.Transparency=dropdown.anim;toggle.setvisible(dropdown.accent,false)
    local scrollable=dropdown.scrollmax>0;local trackx=x+w-12;local tracky=y+2;local trackw=4;local trackh=math.max(1,count*rowh-4);local thumbh=scrollable and math.max(24,math.floor(trackh*count/#values+0.5))or trackh;local travel=math.max(1,trackh-thumbh);local thumby=tracky+(scrollable and travel*dropdown.scroll/dropdown.scrollmax or 0);local roww=scrollable and w-12 or w
    toggle.setpos(dropdown.scrollborder,trackx,tracky);dropdown.scrollborder.Size=Vector2.new(trackw,trackh);dropdown.scrollborder.Color=color("select");dropdown.scrollborder.Transparency=dropdown.anim;toggle.setpos(dropdown.scrolltrack,trackx,tracky);dropdown.scrolltrack.Size=Vector2.new(trackw,trackh);dropdown.scrolltrack.Color=color("bg");dropdown.scrolltrack.Transparency=dropdown.anim;toggle.setpos(dropdown.scrollthumb,trackx,thumby+1);dropdown.scrollthumb.Size=Vector2.new(trackw,math.max(3,thumbh-2));dropdown.scrollthumb.Color=toggle.accentvisual();dropdown.scrollthumb.Transparency=dropdown.anim;toggle.setvisible(dropdown.scrollborder,false);toggle.setvisible(dropdown.scrolltrack,scrollable);toggle.setvisible(dropdown.scrollthumb,scrollable);dropdown.layout={x=x-3,y=y-4,w=w+6,h=panelh,trackx=trackx,tracky=tracky,trackw=trackw,trackh=trackh,thumbx=trackx,thumby=thumby,thumbw=trackw,thumbh=thumbh,travel=travel,scrollable=scrollable}
    local first=math.floor(dropdown.scroll);local shift=(dropdown.scroll-first)*rowh;local listbottom=y+count*rowh
    for slot=1,dropdown.max do
        local index=first+slot;local iy=y+(slot-1)*rowh-shift;local rowtop=math.max(y,iy);local rowbottom=math.min(listbottom,iy+rowh);local on=slot<=count+1 and index<=#values and rowbottom>rowtop;toggle.setvisible(dropdown.bg[slot],on);toggle.setvisible(dropdown.text[slot],on and iy+7>=y and iy+23<=listbottom)
        if on then local value=values[index];local world=toggle.multientry(toggle.worldorder,value);local prompt=toggle.multientry(toggle.promptoptionorder,value);local accentbar=toggle.multientry(toggle.accentbarorder,value);local reset=toggle.multientry(toggle.resetorder,value);local shop=toggle.shop.lookup[value];local playeritem=toggle.multientry(toggle.playeresp.order,value);local hudentry=toggle.multientry(toggle.hudselectionorder,value);local selected=(dropdownkind=="tracers"and toggle.tracers.selected[value]==true)or(dropdownkind=="hudelements"and hudentry and toggle.hudelements[hudentry.id]==true)or(dropdownkind=="playerelements"and(value=="username"and toggle.playeresp.showusername or value=="health"and toggle.playeresp.showhealth or value=="distance"and toggle.playeresp.showdistance))or(dropdownkind=="playerstyle"and value==toggle.playeresp.style)or(dropdownkind=="rakestyle"and value==toggle.rakeespstyle)or(dropdownkind=="rakeelements"and(value=="health"and toggle.rakehealth or value=="distance"and toggle.rakedistance or value=="status"and toggle.rakestatus))or(dropdownkind=="autocollect"and toggle.autocollect.selected[toggle.autocollectname(value)]==true)or(dropdownkind=="playeritems"and playeritem and toggle.playeresp.selected[playeritem.name]==true)or(dropdownkind=="autobuyitems"and shop and toggle.autobuyitems.selected[shop.name]==true)or(dropdownkind=="autosellitems"and shop and toggle.autosellitems.selected[shop.name]==true)or(dropdownkind=="notificationtypes"and toggle.notifysettings.types[value]==true)or(dropdownkind=="worldstats"and world and toggle.worldpanelitems[world.id]==true)or(dropdownkind=="prompts"and prompt and toggle.promptsettings[prompt.id]==true)or(dropdownkind=="accentbars"and accentbar and toggle.accentbars[accentbar.id]==true)or(dropdownkind=="resets"and reset and toggle.resetselected[reset.id]==true)or(dropdownkind=="shopitem"and toggle.shopitem().label==value)or(dropdownkind=="espfont"and index==fontindex)or(dropdownkind=="hudfont"and index==toggle.hudfontindex)or(dropdownkind=="preset"and index==themeindex)or(dropdownkind=="unit"and value==toggle.distanceunit)or(dropdownkind=="distanceposition"and value==toggle.distanceposition)or(dropdownkind=="scrapstyle"and toggle.scrapelements.Scrap1[value]==true)or(dropdownkind=="scrapedit"and index==toggle.scrapedit)or(dropdownkind=="locationedit"and index==toggle.locationedit)or(dropdownkind=="scrapteleport"and value==toggle.scrapteleport)or(dropdownkind=="ringshape"and value==toggle.ringshape)or(dropdownkind=="rgbdirection"and value==toggle.rgbdirection)or(dropdownkind=="containerstyle"and value==toggle.containerstyle)or(dropdownkind=="poweractivitymode"and value==toggle.poweractivitymode)or(dropdownkind=="notificationposition"and value==toggle.notifysettings.position)or(dropdownkind=="config"and index==configslot);local hover=inside(mouse.X,mouse.Y,x,rowtop,roww,rowbottom-rowtop);local textcolor=color(selected and"accent"or"text");toggle.setprop(dropdown.bg[slot],"Corner",0);toggle.setpos(dropdown.bg[slot],x,rowtop);dropdown.bg[slot].Size=Vector2.new(roww,rowbottom-rowtop);dropdown.bg[slot].Color=toggle.colormix(color("bg"),selected and color("accent")or color("text"),selected and 0.12 or hover and 0.07 or 0);dropdown.bg[slot].Transparency=dropdown.anim;local meta=toggle.textroles[dropdown.text[slot]];meta.preview=(dropdownkind=="espfont"or dropdownkind=="hudfont")and fontvalues[index]or nil;dropdown.text[slot].Font=meta.preview or toggle.fontvalue("hud");toggle.setpos(dropdown.text[slot],x+10,iy+8);dropdown.text[slot].Text=dropdownkind=="config"and(string.lower(value)=="default"and"Default"or value)or(dropdownkind=="espfont"or dropdownkind=="hudfont")and value or toggle.uititle(value);dropdown.text[slot].Color=textcolor;dropdown.text[slot].Transparency=dropdown.anim;toggle.uioutline(dropdown.text[slot],dropdown.anim,textcolor);dropdownlayouts[#dropdownlayouts+1]={x=x,y=rowtop,w=roww,h=rowbottom-rowtop,index=index,value=value}end
    end
end
local function pickerupdate(visible)
    local cfg=entrycfg(pickerentry);local on=visible and cfg~=nil
    local rgbvisible=on and(pickerentry=="terrainwater"or type(pickerentry)=="number"or type(pickerentry)=="string"and string.sub(pickerentry,1,6)=="crate_"or pickerentry=="distance"or pickerentry=="rake"or pickerentry=="rakehealth"or pickerentry=="roof"or pickerentry=="hudtimer"or pickerentry=="hudtarget"or pickerentry=="hudscrap"or pickerentry=="hudpower"or pickerentry=="cooldownlabel"or pickerentry=="cooldownvalue"or pickerentry=="valuetimer"or pickerentry=="valuetarget"or pickerentry=="valuescrap"or pickerentry=="valuepower")
    local opening=on and(not picker.opened or picker.openentry~=pickerentry);if on then toggle.ensurepicker()end;if opening then picker.openentry=pickerentry;picker.chromadim=cfg.rgb and 1 or 0;picker.anim=0;picker.cursorx=nil;picker.cursory=nil;picker.huey=nil;picker.previewcolor=nil;picker.opened=true elseif not on then picker.opened=false;picker.anim=0 end;if on then picker.anim=toggle.ease(picker.anim,1,0.30)elseif picker.wasvisible==false then pickerlayouts={};return end
    if not on or opening then for i=1,#picker.baseobjects do toggle.setvisible(picker.baseobjects[i],false)end end;toggle.setvisible(picker.reveal,on and picker.anim<0.999);for i=1,#picker.rgbobjects do toggle.setvisible(picker.rgbobjects[i],not opening and rgbvisible)end
    if picker.wasvisible~=on then for i=1,#picker.hue do toggle.setvisible(picker.hue[i],on)end;picker.wasvisible=on end
    toggle.setvisible(picker.accent,false);toggle.setvisible(picker.panel,false);toggle.setvisible(picker.panelborder,false);toggle.setvisible(picker.divider,false);toggle.setvisible(picker.previewborder,false);toggle.setvisible(picker.rgbmark,false);toggle.setvisible(picker.rgbmarkborder,false);toggle.setvisible(picker.hexborder,false);toggle.setvisible(picker.hexlabel,false);pickerlayouts={};if not on then toggle.setvisible(picker.rgbborder,false);toggle.paintgradient(picker.gradient,false);return end
    local pw,ph=320,368;local px=menustate.x+menustate.w+8;local py=clamp(menustate.y+55,2,math.max(2,cam.ViewportSize.Y-ph-2));if px+pw>cam.ViewportSize.X-2 then px=math.max(2,menustate.x-pw-8)end;py=py+math.floor((1-picker.anim)*8+0.5);local c=cfg.labelcolor;local h,s,v=tohsv(c)
    local alpha=picker.anim;local shell=guiopacity*alpha;toggle.setpos(picker.border,px,py);picker.border.Size=Vector2.new(pw,ph);picker.border.Color=color("outline");picker.border.Transparency=0.24*shell;toggle.setpos(picker.middleborder,px+1,py+1);picker.middleborder.Size=Vector2.new(pw-2,ph-2);picker.middleborder.Color=color("outline");picker.middleborder.Transparency=0;toggle.setpos(picker.innerborder,px+2,py+2);picker.innerborder.Size=Vector2.new(pw-4,ph-4);picker.innerborder.Color=themes.borderblack;picker.innerborder.Transparency=0
    toggle.setpos(picker.bg,px+1,py+1);picker.bg.Size=Vector2.new(pw-2,ph-2);picker.bg.Color=color("bg");picker.bg.Transparency=shell;toggle.setpos(picker.top,px+3,py+3);picker.top.Size=Vector2.new(pw-6,25);picker.top.Color=color("top");picker.top.Transparency=0;local gradinset=toggle.gradientinset();toggle.layoutgradient(picker.gradient,px+gradinset,py+3,math.max(1,pw-gradinset*2));toggle.paintgradient(picker.gradient,false)
    local pickertitle=picker.label or toggle.colorname(pickerentry)
    toggle.setpos(picker.title,px+18+math.floor((1-alpha)*6+0.5),py+17);picker.title.Text=toggle.uititle(pickertitle).." Color";toggle.setprop(picker.title,"Color",color("text"));picker.title.Transparency=alpha
    local sx,sy,sw,sh=px+18,py+48,252,252;local layoutkey=tostring(px)..":"..tostring(py);toggle.setprop(picker.huebase,"Color",Color3.fromHSV(h,1,1));for _,d in ipairs({picker.huebase,picker.colorbase,picker.valueimage})do toggle.setpos(d,sx,sy);toggle.setprop(d,"Size",Vector2.new(sw,sh));toggle.setprop(d,"Transparency",1)end
    local cursorlight=c.R*0.299+c.G*0.587+c.B*0.114
    toggle.setpos(picker.squareborder,sx-1,sy-1);picker.squareborder.Size=Vector2.new(sw+2,sh+2);picker.squareborder.Color=color("outline");picker.squareborder.Transparency=0;local targetcursorx=sx+clamp(s*sw,2,sw-2);local targetcursory=sy+clamp((1-v)*sh,2,sh-2);picker.cursorx=toggle.ease(picker.cursorx,targetcursorx,0.3);picker.cursory=toggle.ease(picker.cursory,targetcursory,0.3);toggle.setpos(picker.cursor,picker.cursorx,picker.cursory);picker.cursor.Color=cursorlight>0.65 and Color3.fromHex("#101010")or Color3.fromHex("#ffffff");picker.cursor.Transparency=alpha
    local hx,hy,hw,hh=px+286,sy,12,sh
    if picker.huelayoutkey~=layoutkey then for i=1,#picker.hue do local d=picker.hue[i];local y0=math.floor((i-1)*hh/picker.huesteps+0.5);local y1=math.floor(i*hh/picker.huesteps+0.5);toggle.setpos(d,hx,hy+y0);d.Size=Vector2.new(hw,math.max(1,y1-y0));d.Color=Color3.fromHSV((i-1)/(picker.huesteps-1),1,1);d.Transparency=1 end;picker.huelayoutkey=layoutkey end
    toggle.setpos(picker.hueborder,hx-1,hy-1);picker.hueborder.Size=Vector2.new(hw+2,hh+2);picker.hueborder.Color=color("outline");picker.hueborder.Transparency=0;picker.huey=toggle.ease(picker.huey,hy+clamp(h*hh,1,hh-3),0.3);toggle.setpos(picker.huecursor,hx-2,picker.huey);picker.huecursor.Size=Vector2.new(hw+4,4);picker.huecursor.Color=Color3.fromHex("#ffffff");picker.huecursor.Transparency=alpha;picker.chromadim=toggle.ease(picker.chromadim,cfg.rgb and 1 or 0,cfg.rgb and 0.13 or 0.18);toggle.setpos(picker.squaredim,sx,sy);picker.squaredim.Size=Vector2.new(sw,sh);picker.squaredim.Color=Color3.fromHex("#202020");picker.squaredim.Transparency=0.52*picker.chromadim*alpha;toggle.setpos(picker.huedim,hx,hy);picker.huedim.Size=Vector2.new(hw,hh);picker.huedim.Color=Color3.fromHex("#202020");picker.huedim.Transparency=0.52*picker.chromadim*alpha;toggle.setpos(picker.reveal,sx,sy);picker.reveal.Size=Vector2.new(hx+hw-sx,sh);picker.reveal.Color=color("bg");picker.reveal.Transparency=1-alpha
    local fy=py+316;picker.rgbhover=toggle.ease(picker.rgbhover,inside(mouse.X,mouse.Y,px+92,fy,90,32)and 1 or 0,0.2);picker.donehover=toggle.ease(picker.donehover,inside(mouse.X,mouse.Y,px+192,fy,90,32)and 1 or 0,0.2);picker.previewcolor=picker.previewcolor and toggle.colormix(picker.previewcolor,cfg.rgb and rgb(0)or c,0.3)or(cfg.rgb and rgb(0)or c);toggle.setpos(picker.preview,px+18,fy);picker.preview.Size=Vector2.new(64,32);picker.preview.Color=picker.previewcolor;picker.preview.Transparency=alpha;toggle.setvisible(picker.preview,true)
    toggle.setpos(picker.rgbborder,px+92,fy);picker.rgbborder.Size=Vector2.new(90,32);picker.rgbborder.Color=rgb(0);picker.rgbborder.Transparency=0.95*shell;toggle.setvisible(picker.rgbborder,rgbvisible and cfg.rgb);toggle.setpos(picker.rgbbg,px+92,fy);picker.rgbbg.Size=Vector2.new(90,32);picker.rgbbg.Color=toggle.colormix(color("top"),color("hover"),picker.rgbhover);picker.rgbbg.Transparency=shell;picker.rgbtext.Center=false;picker.rgbtext.Text="Chroma";toggle.setpos(picker.rgbtext,px+137-toggle.uiwidth("Chroma")/2,fy+9);toggle.setprop(picker.rgbtext,"Color",color("text"));picker.rgbtext.Transparency=alpha
    if not picker.hexactive then picker.hexvalue=toggle.hexof(c)end;toggle.setpos(picker.hexbg,px+192,fy);picker.hexbg.Size=Vector2.new(108,32);picker.hexbg.Color=toggle.colormix(color("top"),color("hover"),picker.hexactive and 1 or picker.donehover);picker.hexbg.Transparency=shell
    picker.hextext.Center=false;picker.hextext.Text="#"..picker.hexvalue..toggle.inputcursor(picker.hexactive);toggle.setpos(picker.hextext,px+246-toggle.uiwidth(picker.hextext.Text)/2,fy+9);toggle.setprop(picker.hextext,"Color",color("text"));picker.hextext.Transparency=alpha
    for _,d in ipairs({picker.bg,picker.border,picker.title,picker.preview,picker.huebase,picker.colorbase,picker.valueimage,picker.squaredim,picker.huedim,picker.cursor,picker.huecursor,picker.hexbg,picker.hextext})do toggle.setvisible(d,true)end
    for i=1,#picker.rgbobjects do toggle.setvisible(picker.rgbobjects[i],rgbvisible)end
    for _,d in ipairs({picker.title,picker.rgbtext,picker.hextext})do toggle.uioutline(d,alpha,d.Color)end
    pickerlayouts.popup={x=px,y=py,w=pw,h=ph};pickerlayouts.square={x=sx,y=sy,w=sw,h=sh};pickerlayouts.hue={x=hx,y=hy,w=hw,h=hh};pickerlayouts.rgb=rgbvisible and{x=px+92,y=fy,w=90,h=32}or nil;pickerlayouts.hex={x=px+192,y=fy,w=108,h=32}

end
toggle.preparewidgets=function(raw)
    local tab=menustate.tab;local closed=menustate.widgetclosed[tab];if type(closed)~="table"then closed={};menustate.widgetclosed[tab]=closed end
    menustate.widgetanim=menustate.widgetanim or{};menustate.widgetanim[tab]=menustate.widgetanim[tab]or{};local anim=menustate.widgetanim[tab];menustate.widgetanimating=false
    local current={};local items=menustate.widgetitems or{};menustate.widgetitems=items;for i=#items,1,-1 do items[i]=nil end
    for i=1,#raw do local item=raw[i];local col=item.col or 1
        if item.kind=="section"then local id=item.widgetid or item.label;current[col]=id;item.widgetid=id;local target=closed[id]and 0 or 1;anim[id]=toggle.ease(anim[id],target,0.28);if math.abs(anim[id]-target)>0.001 then menustate.widgetanimating=true else anim[id]=target end;item.openphase=anim[id];item.widgetphase=1;items[#items+1]=item
        else local id=current[col];item.widgetid=id;item.widgetphase=anim[id]or 1;if item.widgetphase>0.001 then items[#items+1]=item end end
    end
    return items
end
local function menuobjects(visible)
    local expanded=visible and(menustate.contentfade or 0)>0.01
    toggle.setvisible(menubg,visible);toggle.setvisible(menutop,false);toggle.setvisible(menuchrome.border,visible);toggle.setvisible(menutitle,visible);toggle.setvisible(menuclose,visible)
    toggle.setvisible(menuside,false);toggle.setvisible(menuchrome.tabindicator,expanded);toggle.setvisible(menuchrome.content,false);toggle.setvisible(menuchrome.divider,false)
    local canscroll=expanded and(menustate.scrollmax[menustate.tab]or 0)>0
    toggle.setvisible(menuchrome.scrolltrack,canscroll);toggle.setvisible(menuchrome.scrollthumb,canscroll);toggle.setvisible(menuchrome.scrollborder,false)
    for i=1,2 do toggle.setvisible(menuchrome.columns[i],false);toggle.setvisible(menuchrome.columnborders[i],false);toggle.setvisible(toggle.uimodern.buttons[i],visible and(i==2 or expanded))end
    for i=1,#tabnames do toggle.setvisible(tabbg[i],expanded and i~=menustate.tab);toggle.setvisible(tabborder[i],false);toggle.setvisible(tabtext[i],expanded and(toggle.tablabelanim[i]or 0)>0.01);toggle.setvisible(toggle.tabicons[i],expanded)end
    for i=1,math.max(#menuitems,menustate.lastitemcount or 0)do
        local item,l=menuitems[i],itemlayouts[i];local on=expanded and item~=nil and l and l.visible;local kind=item and item.kind
        local sectionon=on and kind=="section";local slideron=on and kind=="slider"and l.trackvisible;local toggleon=on and kind=="toggle"and l.markvisible;local coloron=on and kind=="color"and l.markvisible
        local fieldon=on and(not(item.stacked or kind=="dropdown")or l.fieldvisible);local bordered=fieldon and(kind=="action"or kind=="text"or kind=="dropdown")
        toggle.setvisible(itembg[i],on and(kind=="section"or fieldon));toggle.setvisible(itemborder[i],bordered);toggle.setvisible(itemlabel[i],on and l.textvisible)
        toggle.setvisible(toggle.bindbgs[i],on and item.inlinebind and l.valuevisible);toggle.setvisible(itemvalue[i],on and l.valuevisible and kind~="section"and kind~="color"and(kind~="toggle"or item.inlinebind or item.worldkey))
        toggle.setvisible(itemmark[i],toggleon or coloron or slideron);toggle.setvisible(markborder[i],toggleon)
        toggle.setvisible(itemarrow[i],on and(kind=="dropdown"and l.valuevisible or kind=="section"and l.textvisible));toggle.setvisible(itemtrack[i],slideron);toggle.setvisible(itemfill[i],slideron)
        toggle.setvisible(toggle.inlinecolors.mark[i],on and item.colorindex~=nil and l.markvisible)
        local info=toggle.menuinfo.layouts[i];local iconon=on and item.info~=nil and info and info.visible
        if iconon and not toggle.menuinfo.icons[i]then toggle.menuinfo.icons[i]=toggle.newtooltipicon(123)end
        if toggle.menuinfo.icons[i]then
            local k=item and(item.permission=="hybrid"and"hybrid"or item.permission and"unsafe"or(item.unstable or item.warning)and"warning"or"info")or"info"
            local c=item and(item.disabled and color("muted")or item.permission=="hybrid"and toggle.permissionpink or item.permission and toggle.permissionblue or(item.unstable or item.warning)and toggle.warningred or toggle.infoorange)or toggle.white
            toggle.settooltipicon(toggle.menuinfo.icons[i],k,info and info.x+2 or 0,info and info.y+0.5 or 0,c,l and l.textfade*(menustate.contentfade or 0)*(menustate.menuanim or 0)or 0,iconon)
        end
    end
    menustate.lastitemcount=#menuitems
    dropdownupdate(expanded and dropdownkind~=nil and pickerentry==nil);pickerupdate(expanded and pickerentry~=nil)
end
local function menuupdate(animateonly)
    if toggle.uibatch then menustate.itemsdirty=true;return end
    if not animateonly then menustate.itemsdirty=true elseif toggle.frametime and menustate.renderframe==toggle.frametime and not menustate.itemsdirty then return end;menustate.renderframe=toggle.frametime
    local mt=menustate.minimized and 1 or 0;menustate.minimizeanim=toggle.ease(menustate.minimizeanim,mt,mt==1 and 0.22 or 0.105);if math.abs(menustate.minimizeanim-mt)<0.001 then menustate.minimizeanim=mt end
    menustate.menuanim=toggle.ease(menustate.menuanim,toggle.menu and 1 or 0,0.22);if math.abs(menustate.menuanim-(toggle.menu and 1 or 0))<0.001 then menustate.menuanim=toggle.menu and 1 or 0 end;menustate.contentfade=clamp(1-menustate.minimizeanim,0,1)
    if menustate.resizeheighttarget then local target=clamp(menustate.resizeheighttarget,math.min(340,cam.ViewportSize.Y-36),math.max(340,cam.ViewportSize.Y-menustate.y-18));menustate.h=toggle.ease(menustate.h,target,0.24);if math.abs(menustate.h-target)<0.1 then menustate.h=target;menustate.resizeheighttarget=nil end end
    local moved=menustate.layouth~=menustate.h or menustate.layoutx~=menustate.x or menustate.layouty~=menustate.y or menustate.layouttab~=menustate.tab or menustate.layoutminimized~=menustate.minimized or menustate.layoutphase~=menustate.minimizeanim or menustate.layoutviewportx~=cam.ViewportSize.X or menustate.layoutviewporty~=cam.ViewportSize.Y
    local transitioning=math.abs(menustate.minimizeanim-mt)>0.001 or math.abs(menustate.menuanim-(toggle.menu and 1 or 0))>0.001
    if not animateonly or menustate.itemsdirty or menustate.positionanimating or transitioning or moved or math.abs((menustate.scrolltarget[menustate.tab]or 0)-(menustate.scroll[menustate.tab]or 0))>0.001 then menupos();menustate.layouth=menustate.h;menustate.layoutx=menustate.x;menustate.layouty=menustate.y;menustate.layouttab=menustate.tab;menustate.layoutminimized=menustate.minimized;menustate.layoutphase=menustate.minimizeanim;menustate.layoutviewportx=cam.ViewportSize.X;menustate.layoutviewporty=cam.ViewportSize.Y end

    toggle.footerupdate();local mx,my=mouse.X,mouse.Y;local accent=toggle.accentvisual();local shell=guiopacity*menustate.menuanim;local alpha=menustate.menuanim*menustate.contentfade;local bright=toggle.textbrightness(color("bg"))>0.58
    local surface=toggle.colormix(color("bg"),color("text"),bright and 0.04 or 0.055);local field=toggle.colormix(color("bg"),color("text"),bright and 0.055 or 0.095)
    toggle.setprop(menubg,"Color",color("bg"));toggle.setprop(menubg,"Transparency",shell);toggle.setprop(menuchrome.border,"Color",color("outline"));toggle.setprop(menuchrome.border,"Transparency",0.24*shell)
    toggle.setprop(menutitle,"Text",toggle.menutitle());toggle.setprop(menutitle,"Color",color("text"));toggle.setprop(menutitle,"Transparency",menustate.menuanim);toggle.uioutline(menutitle,menustate.menuanim,color("text"))
    toggle.seticon(menuclose,menustate.minimized and"plus"or"minus",menuclose.Position.X,menuclose.Position.Y,10,color("text"),menustate.menuanim,true)
    local dw=displaysize();local nav=menustate.nav or{x=menustate.x+18,y=menustate.y+42,w=menustate.w-36,h=34};toggle.setpos(menuside,nav.x,nav.y);menuside.Size=Vector2.new(nav.w,nav.h)
    toggle.setprop(menuside,"Color",surface);toggle.setprop(menuside,"Transparency",0.6*shell*menustate.contentfade);toggle.setprop(menuchrome.tabindicator,"Color",toggle.colormix(surface,accent,0.18));toggle.setprop(menuchrome.tabindicator,"Transparency",shell*menustate.contentfade)
    for i=1,2 do local d=toggle.uimodern.buttons[i];local mini=menustate.minimizeanim or 0;local x=menustate.x+dw-(i==1 and 67 or 37);local y=menustate.y+9-4*mini;local height=30-8*mini;local h=inside(mx,my,x,y,26,height);local key="header:"..i;menustate.hover[key]=toggle.ease(menustate.hover[key],h and 1 or 0,0.18);toggle.setprop(d,"Position",Vector2.new(x,y));toggle.setprop(d,"Size",Vector2.new(26,height));toggle.setprop(d,"Color",surface);toggle.setprop(d,"Transparency",0.55*menustate.hover[key]*shell)end
    for _,d in ipairs({menuchrome.scrolltrack,menuchrome.scrollthumb})do toggle.setprop(d,"Color",color("muted"));toggle.setprop(d,"Transparency",(d==menuchrome.scrollthumb and 0.6 or 0.12)*shell*menustate.contentfade)end
    local tabw=nav.w/#tabnames
    for i=1,#tabnames do
        local key="tab:"..i;local hover=inside(mx,my,nav.x+(i-1)*tabw,nav.y,tabw,nav.h)and menustate.contentfade>0.01
        menustate.hover[key]=toggle.ease(menustate.hover[key],hover and 1 or 0,0.18);local phase=toggle.ease(toggle.tablabelanim[i]or 0,hover and 1 or 0,hover and 0.18 or 0.3);toggle.tablabelanim[i]=phase
        local label=toggle.uititle(tabnames[i]);local textw=toggle.uiwidth(label);local groupw=18+(7+textw)*phase;local center=nav.x+(i-0.5)*tabw;local iconx=center-groupw/2
        toggle.setprop(tabbg[i],"Color",accent);toggle.setprop(tabbg[i],"Transparency",i~=menustate.tab and 0.08*menustate.hover[key]*shell*menustate.contentfade or 0)
        local tint=i==menustate.tab and accent or color("muted");toggle.setprop(tabtext[i],"Text",label);toggle.setprop(tabtext[i],"Center",false);toggle.setprop(tabtext[i],"Position",Vector2.new(iconx+25+(1-phase)*8,nav.y+(nav.h-13)/2));toggle.setprop(tabtext[i],"Color",tint);toggle.setprop(tabtext[i],"Transparency",alpha*phase);toggle.setprop(tabtext[i],"Outline",false)
        toggle.seticon(toggle.tabicons[i],toggle.tabiconnames[i],iconx,nav.y+8,18,tint,alpha,menustate.contentfade>0.01 and menustate.menuanim>0.001)
    end
    for i=1,#menuitems do
        local item,l=menuitems[i],itemlayouts[i]
        if l and l.visible then
            local key=tostring(menustate.tab)..":"..tostring(item.id or item.label or i);local hover=not item.disabled and item.kind~="section"and toggle.controlhit and toggle.controlhit(l,mx,my)
            menustate.hover[key]=toggle.ease(menustate.hover[key],hover and 1 or 0,0.18);local ha=menustate.hover[key];local fade=l.fade*alpha;local ff=item.kind=="section"and alpha or(item.stacked or item.kind=="dropdown")and l.fieldfade*alpha or fade;local strong=item.kind=="dropdown"or item.kind=="action"or item.kind=="text"
            local focus=item.kind=="text"and(item.id=="configname"and configcapture or item.id=="rakenameinput"and toggle.rakenamecapture)or item.kind=="dropdown"and toggle.dropdownkindof(item.id)==dropdownkind
            local highlighted=menustate.searchhighlight==item.id and tick()<(menustate.searchhighlightuntil or 0);l.searchhighlight=highlighted
            if menustate.searchhighlight==item.id and not highlighted then menustate.searchhighlight=nil end
            local pulse=highlighted and 0.14+0.14*(math.sin((toggle.frametime or tick())*5.4)+1)/2 or 0
            toggle.setprop(itembg[i],"Color",item.kind=="section"and surface or toggle.colormix(strong and field or surface,accent,ha*0.06+pulse))
            toggle.setprop(itembg[i],"Transparency",(item.kind=="section"and 0.88 or strong and 0.98 or highlighted and 0.8 or ha*0.20)*guiopacity*ff)
            toggle.setprop(itemborder[i],"Color",focus and accent or color("outline"));toggle.setprop(itemborder[i],"Transparency",(focus and 0.65 or 0.20+ha*0.12)*guiopacity*ff)
            
            local lc=item.disabled and color("muted")or(item.kind=="info"or item.kind=="dropdown"or item.kind=="text"or item.worldkey)and color("muted")or color("text")
            local vc=item.disabled and color("muted")or toggle.itemvaluecolor(item)
            toggle.setprop(itemlabel[i],"Text",toggle.uititle(item.label));toggle.setprop(itemlabel[i],"Color",lc);toggle.setprop(itemlabel[i],"Transparency",l.textfade*alpha*(item.disabled and 0.6 or 1));toggle.uioutline(itemlabel[i],l.textfade*alpha,lc)
            if item.inlinebind then toggle.setprop(toggle.bindbgs[i],"Color",toggle.colormix(color("bg"),themes.borderblack,0.45));toggle.setprop(toggle.bindbgs[i],"Transparency",guiopacity*0.85*l.valuefade*alpha);toggle.setprop(toggle.bindbgs[i],"Corner",math.min(5,toggle.borderradius))end;toggle.setprop(itemvalue[i],"Text",toggle.itemshown(item,l.valuebudget));toggle.setprop(itemvalue[i],"Color",vc);toggle.setprop(itemvalue[i],"Transparency",l.valuefade*alpha);toggle.uioutline(itemvalue[i],l.valuefade*alpha,vc)
            toggle.setprop(itemarrow[i],"Color",item.kind=="section"and accent or focus and accent or color("muted"));toggle.setprop(itemarrow[i],"Transparency",(item.kind=="section"and l.textfade or l.valuefade)*alpha)
            toggle.setprop(itemtrack[i],"Color",toggle.colormix(field,color("muted"),0.15));toggle.setprop(itemtrack[i],"Transparency",guiopacity*fade);toggle.setprop(itemfill[i],"Color",accent);toggle.setprop(itemfill[i],"Transparency",fade)
            if item.kind=="toggle"then
                local ta=toggle.ease(menustate.toggleanim[key],item.on and 1 or 0,0.26);menustate.toggleanim[key]=ta
                toggle.setprop(markborder[i],"Color",toggle.colormix(toggle.colormix(surface,color("muted"),0.26),accent,ta));toggle.setprop(markborder[i],"Transparency",(item.disabled and 0.45 or 1)*guiopacity*fade)
                toggle.setprop(markborder[i],"Position",Vector2.new(l.x+12,l.y+7));toggle.setprop(markborder[i],"Size",Vector2.new(30,18));toggle.setprop(markborder[i],"Filled",true);toggle.setprop(itemmark[i],"Size",Vector2.new(12,12));toggle.setprop(itemmark[i],"Position",Vector2.new(l.x+15+12*ta,l.y+10));toggle.setprop(itemmark[i],"Color",color("text"));toggle.setprop(itemmark[i],"Transparency",l.textfade*alpha*(item.disabled and 0.5 or 1))
            elseif item.kind=="slider"then toggle.setprop(itemmark[i],"Color",accent);toggle.setprop(itemmark[i],"Transparency",fade)
            elseif item.kind=="color"then local cfg=entrycfg(item.index);toggle.setprop(itemmark[i],"Color",cfg and(cfg.rgb and rgb(0)or cfg.labelcolor)or accent);toggle.setprop(itemmark[i],"Transparency",fade)end
            if item.colorindex then local cfg=entrycfg(item.colorindex);toggle.setprop(toggle.inlinecolors.mark[i],"Color",cfg and(cfg.rgb and rgb(0)or cfg.labelcolor)or accent);toggle.setprop(toggle.inlinecolors.mark[i],"Transparency",fade)end
        end
    end
    menuobjects(menustate.menuanim>0.001);toggle.searchupdate();toggle.tooltipupdate()
end
toggle.warmmenu=function()
    toggle.wait();while toggle.starting and toggle.running do toggle.wait()end;if not toggle.running then return end
    -- Load original visual values in the background before the first Visuals visit.
    pcall(toggle.applyvisuals,true)
    local viewport=math.max(100,menustate.h-140);local warmed=0
    for _,tab in ipairs({2,1,3,4})do
        local rows=currentitems(tab);local heights={0,0}
        for i,item in ipairs(rows)do
            if not toggle.running or toggle.replacing then return end;local col=item.col or 1
            if heights[col]<viewport then
                toggle.ensuremenurow(i)
                if item.info and not toggle.menuinfo.icons[i]then toggle.menuinfo.icons[i]=toggle.newtooltipicon(123)end
                if item.info then local tint=item.permission=="hybrid"and toggle.permissionpink or item.permission and toggle.permissionblue or item.unstable and toggle.warningred or toggle.infoorange;local kind=item.permission=="hybrid"and"zap"or item.permission and"moon"or item.unstable and"trianglealert"or"circlequestion";toggle.icondata(kind,tint)end
                warmed=warmed+1;if warmed%2==0 then toggle.wait()end
            end;heights[col]=heights[col]+toggle.rowheight(item)
        end
        toggle.wait()
    end
    for _,name in ipairs({"plus","minus","search","sun","eye","house","gear"})do if not toggle.running then return end;toggle.icondata(name,color("text"));toggle.wait()end
end
local function showmenu()menuupdate()end
local powercfg={{valuename="UsingSHDoor",label="house door",cells=3},{valuename="UsingSHLight",label="house lights",cells=1},{valuename="UsingSHDoor",label="tower door",cells=3},{valuename="UsingTowerLight",label="tower lights",cells=3},{valuename="UsingTowerRadar",label="tower radar",cells=1}}
local powerlines={}
toggle.powervalues={}
for i=1,#powercfg do powerlines[i]=setz(newtext(toggle.uititle(powercfg[i].label),Color3.fromHex("#888888"),false,false),45);toggle.powervalues[i]=setz(newtext("On",Color3.fromHex("#ffffff"),false,false),45)end
toggle.powerempty=setz(newtext("Nothing is active",Color3.fromHex("#777777"),false,false),45)
setz(powerlabel,45)
toggle.powerpanel={x=math.max(2,cam.ViewportSize.X-182),y=math.max(2,math.floor(cam.ViewportSize.Y/2-32)),w=164,h=64,dragged=false,anim=0,lineactive={},bg=setz(newsquare(Color3.fromHex("#262626"),0.95),40),top=setz(newsquare(Color3.fromHex("#363636"),0.95),41),outer=setz(newborder(Color3.fromHex("#000000"),1),44),middle=setz(newborder(Color3.fromHex("#555555"),1),44),inner=setz(newborder(Color3.fromHex("#000000"),1),44),accent=setz(newsquare(Color3.fromHex("#99c30b"),1),43),divider=setz(newline(Color3.fromHex("#111111")),43)}
toggle.powerpanel.divider.Thickness=1
toggle.powerpanel.gradient=toggle.makegradient(64,43);toggle.powerpanel.accent.Visible=false
toggle.huditems={{id="cooldown",value=toggle.cooldowndraw.value,label=toggle.cooldowndraw.label},{id="timer",value=timertxt,label=timerlabel},{id="target",value=targettxt,label=targetlabel},{id="scrap",value=scraptxt,label=scraplabel},{id="power",value=toggle.powerdraw.value,label=toggle.powerdraw.label}}
for i=1,#toggle.huditems do setz(toggle.huditems[i].value,18);setz(toggle.huditems[i].label,18);toggle.huditems[i].anim=toggle.hud and toggle.hudelements[toggle.huditems[i].id]==true and 1 or 0 end
toggle.makewidgetframe=function(z,count)
    z=z or 10;return {bg=setz(newsquare(Color3.fromHex("#262626"),0.95),z),top=setz(newsquare(Color3.fromHex("#363636"),0.95),z+1),outer=setz(newborder(Color3.fromHex("#000000"),1),z+4),middle=setz(newborder(Color3.fromHex("#555555"),1),z+4),inner=setz(newborder(Color3.fromHex("#000000"),1),z+4),accent=setz(newsquare(Color3.fromHex("#99c30b"),1),z+3),gradient=toggle.makegradient(count or 72,z+3)}
end
toggle.groupwidget=toggle.makewidgetframe(10,144);toggle.setvisible(toggle.groupwidget.accent,false);toggle.widgetgroup={x=nil,y=nil,w=0,h=0,dragged=false}
toggle.worldframe=toggle.makewidgetframe(20,72);toggle.worldframe.topheight=24;toggle.setvisible(toggle.worldframe.accent,false);toggle.worldpanelstate={x=18,y=math.max(2,cam.ViewportSize.Y-194),w=176,h=176,dragged=false,anim=0};toggle.worldtitle=setz(newtext("World",Color3.fromHex("#ffffff"),false,false),25);toggle.worldlines={};toggle.worldvalues={}
for i=1,#toggle.worldorder do toggle.worldlines[i]=setz(newtext("",Color3.fromHex("#888888"),false,false),25);toggle.worldvalues[i]=setz(newtext("",Color3.fromHex("#ffffff"),false,false),25)end
toggle.keybindframe=toggle.makewidgetframe(30,72);toggle.keybindframe.topheight=24;toggle.setvisible(toggle.keybindframe.accent,false);toggle.keybindpanelstate={x=18,y=math.max(2,math.floor(cam.ViewportSize.Y/2-96)),w=164,h=193,dragged=false,anim=0};toggle.keybindtitle=setz(newtext("Keybinds",Color3.fromHex("#ffffff"),false,false),35);toggle.keybindlines={};toggle.keybindvalues={}
for i=1,#bindorder do toggle.keybindlines[i]=setz(newtext(toggle.uititle(bindlabels[bindorder[i]]),Color3.fromHex("#888888"),false,false),35);toggle.keybindvalues[i]=setz(newtext("[-]",Color3.fromHex("#ffffff"),false,false),35)end
toggle.keybindtier=setz(newtext("",toggle.white,false,false),35);toggle.keybindstates={}
toggle.keybindrowcount=function()local count=0;for i=1,#bindorder do if toggle.bindvisible(bindorder[i])then count=count+1 end end;return count end
toggle.applyradius=function()
    toggle.applymenuradius();for _,frame in ipairs({toggle.groupwidget,toggle.powerpanel,toggle.worldframe,toggle.keybindframe})do for _,entry in ipairs({{frame.outer,0},{frame.middle,1},{frame.inner,2},{frame.bg,1},{frame.top,1}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end end
    for _,frame in ipairs(toggle.toastframes)do for _,entry in ipairs({{frame.outer,0},{frame.middle,1},{frame.inner,2},{frame.bg,1},{frame.top,1}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end;pcall(function()frame.progressbg.Corner=math.min(2,toggle.borderradius);frame.progress.Corner=math.min(2,toggle.borderradius)end)end
    for _,entry in ipairs({{picker.border,0},{picker.middleborder,1},{picker.innerborder,2},{picker.bg,1},{picker.top,1}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end
    for _,d in ipairs({picker.panel,picker.panelborder,picker.previewborder,picker.preview,picker.rgbborder,picker.rgbbg,picker.hexborder,picker.hexbg})do pcall(function()d.Corner=math.min(3,toggle.borderradius)end)end
    for _,d in ipairs({picker.squareborder,picker.hueborder,picker.huecursor,picker.rgbmarkborder,picker.rgbmark})do pcall(function()d.Corner=math.min(2,toggle.borderradius)end)end
end
toggle.applyradius()
toggle.placewidget=function(frame,x,y,w,h)
    x=toggle.pixel(x);y=toggle.pixel(y);w=toggle.pixel(w);h=toggle.pixel(h);frame.x=x;frame.y=y;frame.w=w;frame.h=h
    toggle.setpos(frame.outer,x,y);frame.outer.Size=Vector2.new(w,h);toggle.setpos(frame.middle,x+1,y+1);frame.middle.Size=Vector2.new(w-2,h-2);toggle.setpos(frame.inner,x+2,y+2);frame.inner.Size=Vector2.new(w-4,h-4);toggle.setpos(frame.bg,x+1,y+1);frame.bg.Size=Vector2.new(w-2,h-2);toggle.setpos(frame.top,x+3,y+3);frame.top.Size=Vector2.new(w-6,frame.topheight or 7);toggle.setvisible(frame.accent,false);local inset=toggle.gradientinset();toggle.layoutgradient(frame.gradient,x+inset,y+3,math.max(1,w-inset*2))
end
toggle.paintwidget=function(frame,on,phaseoffset,baron)
    toggle.setvisible(frame.accent,false);toggle.setvisible(frame.outer,false);toggle.setvisible(frame.inner,false);toggle.setvisible(frame.top,false)
    if not on then toggle.setvisible(frame.middle,false);toggle.setvisible(frame.bg,false);toggle.paintgradient(frame.gradient,false);return end
    local a=guiopacity*clamp(tonumber(phaseoffset)or 1,0,1);toggle.setprop(frame.middle,"Color",color("outline"));toggle.setprop(frame.middle,"Transparency",0.24*a);toggle.setvisible(frame.middle,true)
    toggle.setprop(frame.bg,"Color",color("bg"));toggle.setprop(frame.bg,"Transparency",a);toggle.setvisible(frame.bg,true);toggle.paintgradient(frame.gradient,baron~=false,a)
end
toggle.hidewidgets=function()
    toggle.paintwidget(toggle.groupwidget,false)
end
toggle.hudbarvisible=function()return toggle.containerstyle=="legacy"and(toggle.hudalpha or 0)>0.01 and rgbwidth>0 end
toggle.hudvisible=function(id)
    if id=="cooldown"then return toggle.hud and toggle.teleportcooldown and toggle.cooldownremaining>0 end
    if id=="target"then return toggle.hud and toggle.hudelements.target==true and toggle.targetnight end
    if id=="power"then return toggle.hud and toggle.hudelements.power==true and toggle.powerhudavailable end
    return toggle.hud and toggle.hudelements[id]==true
end
local function rgbpos()
    local center=anchors();local y=center.Y-8;local x=toggle.hudbarleft or center.X-rgbwidth/2
    toggle.layoutgradient(rgbline,x,y,math.max(1,rgbwidth))
end
local function powerpos()
    if toggle.uibatch then toggle.huddirty=true;return end
    if(not toggle.hud or not toggle.poweractivity)and(toggle.powerpanel.anim or 0)<=0.001 then toggle.powerpanel.target=0;toggle.powerpanel.rowanimating=false;return end
    local p,n,mask=toggle.powerpanel,0,0;p.rowanim=p.rowanim or{};p.rowanimating=false;local animatedrows=0;local modern=toggle.hudstyle=="modern";local contenttop=(modern and 48 or 32)+(espfontsize-13)
    for i=1,#powerlines do local target=toggle.poweractivity and p.lineactive[i]and 1 or 0;local a=toggle.ease(p.rowanim[i]or 0,target,target==1 and 0.24 or 0.20);p.rowanim[i]=a;animatedrows=animatedrows+a;if math.abs(a-target)>0.001 then p.rowanimating=true end;if a>0.01 then n=n+1;mask=mask+2^(i-1)end end
    local showalways=toggle.poweractivitymode=="always";local hasactivity=n>0;local empty=toggle.poweractivity and showalways and not hasactivity;local rows=toggle.poweractivity and(empty and 1 or n)or 0;local contentw=toggle.textwidth(powerlabel);if empty then contentw=math.max(contentw,toggle.textwidth(toggle.powerempty))end;for i=1,#powerlines do if(p.rowanim[i]or 0)>0.01 then contentw=math.max(contentw,toggle.textwidth(powerlines[i])+18+toggle.textwidth(toggle.powervalues[i]))end end;p.w=math.max(190,contentw+36);p.h=(modern and 56 or 40)+(espfontsize-13)+rows*(toggle.hudlineheight+11);if not p.dragged then p.x=cam.ViewportSize.X-p.w-18;p.y=math.floor(cam.ViewportSize.Y/2-12-p.h)end;p.x=clamp(p.x,0,math.max(0,cam.ViewportSize.X-p.w));p.y=clamp(p.y,0,math.max(0,cam.ViewportSize.Y-p.h));local activityon=toggle.poweractivity and(hasactivity or showalways);local on=toggle.hud and activityon;p.target=on and 1 or 0;p.anim=toggle.ease(p.anim,p.target,on and 0.26 or 0.3);local drawon=p.anim>0.01;local drawy=p.y+math.floor((1-p.anim)*8+0.5);local alpha=guiopacity*p.anim;local contentalpha=p.anim
    local geometrychanged=p.lastx~=p.x or p.lastdrawy~=drawy or p.lastw~=p.w or p.lasth~=p.h or p.lastmask~=mask or p.lastrows~=rows or p.lastradius~=toggle.borderradius or p.rowanimating;p.lastx=p.x;p.lastdrawy=drawy;p.lastw=p.w;p.lasth=p.h;p.lastmask=mask;p.lastrows=rows;p.lastradius=toggle.borderradius
    n=0;local rowoffset=0;for i=1,#powerlines do local line,value=powerlines[i],toggle.powervalues[i];local lineon=drawon and(p.rowanim[i]or 0)>0.01 or false;toggle.setvisible(line,lineon);toggle.setvisible(value,lineon);if lineon then n=n+1;if geometrychanged then local y=drawy+contenttop+rowoffset+(1-p.rowanim[i])*5;toggle.setpos(line,p.x+18,y);toggle.setpos(value,p.x+p.w-18-toggle.textwidth(value),y)end;local linecolor=toggle.hudtextcolor(color("muted"));local valuecolor=toggle.hudtextcolor(color("text"));toggle.setprop(line,"Color",linecolor);toggle.setprop(value,"Color",valuecolor);local rowalpha=contentalpha*(p.rowanim[i]or 0);toggle.setprop(line,"Transparency",rowalpha);toggle.setprop(value,"Transparency",rowalpha);toggle.applytextoutline(line,contentalpha,linecolor);toggle.applytextoutline(value,rowalpha,valuecolor);rowoffset=rowoffset+(toggle.hudlineheight+11)end end
    if geometrychanged then toggle.setpos(toggle.powerempty,p.x+18,drawy+contenttop)end;local emptycolor=toggle.hudtextcolor(color("muted"));toggle.setprop(toggle.powerempty,"Color",emptycolor);toggle.setprop(toggle.powerempty,"Transparency",contentalpha);toggle.applytextoutline(toggle.powerempty,contentalpha,emptycolor);toggle.setvisible(toggle.powerempty,drawon and empty)
    if geometrychanged then local inset=toggle.gradientinset();toggle.setpos(p.outer,p.x,drawy);p.outer.Size=Vector2.new(p.w,p.h);toggle.setpos(p.middle,p.x+1,drawy+1);p.middle.Size=Vector2.new(p.w-2,p.h-2);toggle.setpos(p.inner,p.x+2,drawy+2);p.inner.Size=Vector2.new(p.w-4,p.h-4);toggle.setpos(p.bg,p.x+1,drawy+1);p.bg.Size=Vector2.new(p.w-2,p.h-2);toggle.setpos(p.top,p.x+3,drawy+3);p.top.Size=Vector2.new(p.w-6,24);p.accent.Visible=false;toggle.layoutgradient(p.gradient,p.x+inset,drawy+3,math.max(1,p.w-inset*2));toggle.setpos(powerlabel,p.x+18,drawy+17)end
    toggle.setprop(p.outer,"Color",themes.borderblack);toggle.setprop(p.outer,"Transparency",0);toggle.setvisible(p.outer,false);toggle.setprop(p.middle,"Color",color("outline"));toggle.setprop(p.middle,"Transparency",0.24*alpha);toggle.setvisible(p.middle,drawon and modern);toggle.setprop(p.inner,"Color",themes.borderblack);toggle.setprop(p.inner,"Transparency",0);toggle.setvisible(p.inner,false);toggle.setprop(p.bg,"Color",color("bg"));toggle.setprop(p.bg,"Transparency",alpha);toggle.setvisible(p.bg,drawon and modern);toggle.setprop(p.top,"Color",color("top"));toggle.setprop(p.top,"Transparency",0);toggle.setvisible(p.top,false);toggle.paintgradient(p.gradient,drawon and modern and toggle.accentbars.activity,alpha);toggle.setvisible(p.divider,false);local titlecolor=toggle.hudtextcolor(color("text"));toggle.setprop(powerlabel,"Color",titlecolor);toggle.setvisible(powerlabel,drawon);toggle.setprop(powerlabel,"Transparency",contentalpha);toggle.applytextoutline(powerlabel,contentalpha,titlecolor)
end
toggle.placehudcontent=function(item,x,valuey,labely)
    local targety=valuey+(1-item.anim)*7;item.drawx=toggle.ease(item.drawx,x,0.24);item.drawy=toggle.ease(item.drawy,targety,0.24)
    if math.abs(item.drawx-x)>0.01 or math.abs(item.drawy-targety)>0.01 then toggle.hudanimating=true end
    toggle.centertext(item.value,item.drawx,item.drawy);toggle.centertext(item.label,item.drawx,item.drawy+(labely and labely-valuey or toggle.hudlineheight+12))
    toggle.setprop(item.value,"Transparency",item.anim);toggle.setprop(item.label,"Transparency",item.anim);toggle.applytextoutline(item.value,item.anim);toggle.applytextoutline(item.label,item.anim);toggle.setvisible(item.value,item.anim>0.01);toggle.setvisible(item.label,item.anim>0.01)
end
local function hudpos()
    if toggle.uibatch then toggle.huddirty=true;return end
    toggle.hudanimating=false;local center=anchors();local y=center.Y-50;local active=toggle.hudactive or{};toggle.hudactive=active;for i=#active,1,-1 do active[i]=nil end;local hudalpha=0
    for i=1,#toggle.huditems do local item=toggle.huditems[i];local target=toggle.hudvisible(item.id);local targetalpha=target and 1 or 0;item.anim=toggle.ease(item.anim,targetalpha,target and 0.3 or 0.24);if math.abs(item.anim-targetalpha)<0.001 then item.anim=targetalpha else toggle.hudanimating=true end;hudalpha=math.max(hudalpha,item.anim);if target or item.anim>0.01 then active[#active+1]=item else toggle.setvisible(item.value,false);toggle.setvisible(item.label,false)end end;toggle.hudalpha=hudalpha
    local count=#active;local spacing=120;local start=center.X-(count-1)*spacing/2;toggle.hudcount=count
    if toggle.containerstyle=="modern"then
        rgbwidth=0;toggle.hudbarleft=center.X
        if count>0 then local cellw,cellh=math.max(126,126*espfontsize/13),74+(toggle.hudlineheight-13)*2;for i=1,count do cellw=math.max(cellw,toggle.textwidth(active[i].value)+36,toggle.textwidth(active[i].label)+36)end;local w,h=count*cellw,cellh;local g=toggle.widgetgroup;if g.x==nil or not g.dragged then g.x=toggle.pixel((cam.ViewportSize.X-w)/2)end;if g.y==nil then g.y=center.Y-70 end;g.x=clamp(g.x,0,math.max(0,cam.ViewportSize.X-w));g.y=clamp(g.y,0,math.max(0,cam.ViewportSize.Y-h));g.w=w;g.h=h;g.drawx=toggle.ease(g.drawx,g.x,0.24);g.draww=toggle.ease(g.draww,w,0.24);if math.abs(g.drawx-g.x)>0.01 or math.abs(g.draww-w)>0.01 then toggle.hudanimating=true end;toggle.placewidget(toggle.groupwidget,g.drawx,g.y,g.draww,h);toggle.paintwidget(toggle.groupwidget,true,hudalpha,toggle.accentbars.hud);for i=1,count do local item=active[i];toggle.placehudcontent(item,g.drawx+(i-0.5)*g.draww/count,g.y+(h-(toggle.hudlineheight*2+12))/2+toggle.hudlineheight/2,g.y+(h-(toggle.hudlineheight*2+12))/2+toggle.hudlineheight*1.5+12)end else toggle.paintwidget(toggle.groupwidget,false)end
    else
        toggle.hidewidgets();for i=1,count do local item=active[i];toggle.placehudcontent(item,start+(i-1)*spacing,y)end
        if count>0 then local first,last=active[1],active[count];local firstw=math.max(42,math.max(toggle.textwidth(first.value),toggle.textwidth(first.label)));local lastw=math.max(42,math.max(toggle.textwidth(last.value),toggle.textwidth(last.label)));local left=start-firstw/2-10;local right=start+(count-1)*spacing+lastw/2+10;rgbwidth=math.max(80,right-left);toggle.hudbarleft=rgbwidth==80 and center.X-40 or left else rgbwidth=0;toggle.hudbarleft=center.X end
    end
    rgbpos()
end
hudpos()
local cratenames={FirstAidKit="medkit",Vitamins="vitamin",UV_Lamp="uv_lamp",StunStick="stun",Vest="vest",Tracker="tracker"}
local cratetext=Color3.fromHex("#ffffff")
local cratebg=Color3.fromHex("#000000")
local cratecol,craterow,cratey=84,40,70
local cratepadx,cratepady=36,12
local cratewidth=cratecol*2+cratepadx*2
toggle.crateitemkey=function(child)if type(child)=="table"and rawget(child,"crateitem")then return child.key end;return toggle.instanceaddress(child)or child end
toggle.cratetaken=function(child)
    if type(child)=="table"and rawget(child,"crateitem")then return child.taken end;local taken=child and child:FindFirstChild("Taken");return taken and taken:IsA("BoolValue")and taken.Value==true or false
end
toggle.worldstatuswidths={Yes=18,No=13,On=13,Off=17}
toggle.worldvaluewidth=function(d)
    local meta=toggle.textroles[d];local family=meta and toggle.fontvalue(meta.role)or toggle.fontvalue("hud")
    -- Fortnite uses condensed status glyphs, unlike its numeric value advances.
    local status=family==Drawing.Fonts.Fortnite and toggle.worldstatuswidths[d.Text]
    return status and status*(meta and meta.size or 13)/13 or toggle.textwidth(d)
end
local function worldpos()
    if toggle.uibatch then toggle.huddirty=true;return end
    if(not toggle.hud or not toggle.worldpanel)and(toggle.worldpanelstate.anim or 0)<=0.001 then toggle.worldpanelstate.target=0;return end
    local p=toggle.worldpanelstate;local modern=toggle.hudstyle=="modern";local info=toggle.worldinfo;local shown={info.flare and"Yes"or"No",tostring(info.scraps),tostring(info.traps),tostring(info.crates),info.power and"On"or"Off"};local points=tostring(info.points).."p";local enabled=toggle.worldpanelitems;local rows,contentw=0,toggle.textwidth(toggle.worldtitle)
    if not toggle.worldpoints then toggle.worldpoints=setz(newtext("",color("text"),false,false),25)end;toggle.setprop(toggle.worldpoints,"Text",points);toggle.setprop(toggle.worldpoints,"Size",espfontsize)
    for i,entry in ipairs(toggle.worldorder)do toggle.setprop(toggle.worldlines[i],"Text",toggle.uititle(entry.label));toggle.setprop(toggle.worldvalues[i],"Text",shown[i]);if enabled[entry.id]then rows=rows+1;local extra=entry.id=="scraps"and toggle.textwidth(toggle.worldpoints)+10 or 0;contentw=math.max(contentw,toggle.textwidth(toggle.worldlines[i])+22+toggle.worldvaluewidth(toggle.worldvalues[i])+extra)end end
    p.w=math.max(210,contentw+36);local top=(modern and 48 or 32)+(espfontsize-13);p.h=top+rows*(toggle.hudlineheight+11)+8;if not p.dragged then p.x=18;p.y=cam.ViewportSize.Y-p.h-18 end;p.x=clamp(p.x,0,math.max(0,cam.ViewportSize.X-p.w));p.y=clamp(p.y,0,math.max(0,cam.ViewportSize.Y-p.h));local on=toggle.hud and toggle.worldpanel and rows>0;p.target=on and 1 or 0;p.anim=toggle.ease(p.anim,p.target,on and 0.26 or 0.22);local drawon=p.anim>0.01;local y=p.y+math.floor((1-p.anim)*8+0.5)
    toggle.placewidget(toggle.worldframe,p.x,y,p.w,p.h);toggle.paintwidget(toggle.worldframe,drawon and modern,p.anim,toggle.accentbars.world);toggle.setpos(toggle.worldtitle,p.x+18,y+17);toggle.setprop(toggle.worldtitle,"Color",color("text"));toggle.setprop(toggle.worldtitle,"Transparency",p.anim);toggle.applytextoutline(toggle.worldtitle,p.anim);toggle.setvisible(toggle.worldtitle,drawon)
    local row=0;local pointsvisible=false;for i,entry in ipairs(toggle.worldorder)do local label,value=toggle.worldlines[i],toggle.worldvalues[i];local visible=drawon and enabled[entry.id];if visible then row=row+1;local ry=y+top+(row-1)*(toggle.hudlineheight+11);local right=p.x+p.w-18;local extra=entry.id=="scraps"and toggle.textwidth(toggle.worldpoints)+10 or 0;toggle.setpos(label,p.x+18,ry);toggle.setpos(value,right-toggle.worldvaluewidth(value),ry);local tint=entry.id=="flare"and info.flare and espcfg.FlareGunPickUp or nil;toggle.setprop(label,"Color",color("muted"));toggle.setprop(value,"Color",tint and(tint.rgb and rgb(0)or tint.labelcolor)or color((entry.id=="flare"and not info.flare or entry.id=="power"and not info.power)and"muted"or"text"));for _,d in ipairs({label,value})do toggle.setprop(d,"Transparency",p.anim);toggle.applytextoutline(d,p.anim)end;if entry.id=="scraps"then local _,tier=toggle.choosescrap(false);local cfg=espcfg["Scrap"..tostring(tier or 1)]or espcfg.Scrap1;toggle.setpos(toggle.worldpoints,right-toggle.worldvaluewidth(value)-10-toggle.textwidth(toggle.worldpoints),ry);toggle.setprop(toggle.worldpoints,"Color",cfg.rgb and rgb(0)or cfg.labelcolor);toggle.setprop(toggle.worldpoints,"Transparency",p.anim);toggle.applytextoutline(toggle.worldpoints,p.anim);pointsvisible=true end end;toggle.setvisible(label,visible);toggle.setvisible(value,visible)end;toggle.setvisible(toggle.worldpoints,pointsvisible)
end
toggle.keybindpos=function()
    if toggle.uibatch then toggle.huddirty=true;return end
    if(not toggle.hud or not toggle.keybindpanel)and(toggle.keybindpanelstate.anim or 0)<=0.001 then toggle.keybindpanelstate.target=0;toggle.keybindpanelstate.rowanimating=false;return end
    local p=toggle.keybindpanelstate;local modern=toggle.hudstyle=="modern";local rows=toggle.keybindrowcount();local contentw=toggle.textwidth(toggle.keybindtitle);local tier
    if toggle.bindvisible("scrap")and toggle.choosescrap then local _,selected=toggle.choosescrap(false);tier=selected end
    local keyw=26;local tierw=0;toggle.setprop(toggle.keybindtier,"Size",espfontsize);toggle.setprop(toggle.keybindtier,"Text",tier and"Tier "..tier or"")
    if tier then tierw=toggle.textwidth(toggle.keybindtier)+8 end
    for i=1,#bindorder do local id=bindorder[i];if toggle.bindvisible(id)then local value=toggle.keybindvalues[i];local label=toggle.keybindlines[i];toggle.setprop(value,"Size",espfontsize);toggle.setprop(label,"Size",espfontsize);toggle.setprop(value,"Text",toggle.bindname(id));toggle.setprop(label,"Text",toggle.uititle(bindlabels[id]));keyw=math.max(keyw,toggle.textwidth(value)+8)end end
    for i=1,#bindorder do local id=bindorder[i];if toggle.bindvisible(id)then contentw=math.max(contentw,toggle.textwidth(toggle.keybindlines[i])+22+keyw+(id=="scrap"and tier and tierw+8 or 0))end end
    p.rowanimating=false;p.w=math.max(190,contentw+36);p.h=(modern and 56 or 40)+(espfontsize-13)+rows*(toggle.hudlineheight+11)
    if not p.dragged then p.x=cam.ViewportSize.X-p.w-18;p.y=math.floor(cam.ViewportSize.Y/2+12)end
    p.x=clamp(p.x,0,math.max(0,cam.ViewportSize.X-p.w));p.y=clamp(p.y,0,math.max(0,cam.ViewportSize.Y-p.h));local on=toggle.hud and toggle.keybindpanel;p.target=on and 1 or 0;p.anim=toggle.ease(p.anim,p.target,on and 0.26 or 0.22)
    local drawon=p.anim>0.01;local drawy=p.y+math.floor((1-p.anim)*8+0.5);local contenttop=(modern and 48 or 32)+(espfontsize-13)
    toggle.placewidget(toggle.keybindframe,p.x,drawy,p.w,p.h);toggle.keybindframe.top.Size=Vector2.new(p.w-6,24);toggle.paintwidget(toggle.keybindframe,drawon and modern,p.anim,toggle.accentbars.keybinds)
    toggle.setpos(toggle.keybindtitle,p.x+18,drawy+17);local titlecolor=toggle.hudtextcolor(color("text"));toggle.setprop(toggle.keybindtitle,"Color",titlecolor);toggle.setprop(toggle.keybindtitle,"Transparency",p.anim);toggle.applytextoutline(toggle.keybindtitle,p.anim,titlecolor);toggle.setvisible(toggle.keybindtitle,drawon)
    local row=0;local tiervisible=false
    for i=1,#bindorder do local id=bindorder[i];local label,value=toggle.keybindlines[i],toggle.keybindvalues[i];local visible=drawon and toggle.bindvisible(id)
        if visible then row=row+1;local y=drawy+contenttop+(row-1)*(toggle.hudlineheight+11);local cy=y+espfontsize/2;local right=p.x+p.w-18
            local active=toggle.bindactive(id)and 1 or 0;local phase=toggle.ease(toggle.keybindstates[id]or 0,active,0.16);toggle.keybindstates[id]=phase;if math.abs(phase-active)>0.002 then p.rowanimating=true end
            local labelcolor=toggle.hudtextcolor(toggle.colormix(color("muted"),color("text"),phase));local valuecolor=toggle.hudtextcolor(color("text"));toggle.setprop(label,"Center",false);toggle.setpos(label,p.x+18,y);toggle.centertext(value,right-keyw/2,cy)
            toggle.setprop(label,"Color",labelcolor);toggle.setprop(value,"Color",valuecolor);toggle.setprop(label,"Transparency",p.anim);toggle.setprop(value,"Transparency",p.anim);toggle.applytextoutline(label,p.anim,labelcolor);toggle.applytextoutline(value,p.anim,valuecolor)
            if id=="scrap"and tier then local tiercolor=espcfg["Scrap"..tier].labelcolor;toggle.centertext(toggle.keybindtier,right-keyw-8-tierw/2,cy);toggle.setprop(toggle.keybindtier,"Color",tiercolor);toggle.setprop(toggle.keybindtier,"Transparency",p.anim);toggle.applytextoutline(toggle.keybindtier,p.anim,tiercolor);tiervisible=true end
        end
        toggle.setvisible(label,visible);toggle.setvisible(value,visible)
    end
    toggle.setvisible(toggle.keybindtier,tiervisible)
end
toggle.refreshinventory=function(force)
    local state=toggle.inventorycache;local now=toggle.frametime or tick();if not force and now<(state.next or 0)then return state.items end;state.next=now+0.08;local items=state.items;for name in pairs(items)do items[name]=nil end;local backpack=lp:FindFirstChild("Backpack")or lp:FindFirstChild("backpack");local character=lp.Character;if backpack then local children=backpack:GetChildren();for i=1,#children do items[children[i].Name]=true end end;if character then local children=character:GetChildren();for i=1,#children do local child=children[i];items[child.Name]=true;if child.Name=="VestModel"and child:IsA("MeshPart")then items.Vest=true end end end;return items
end
toggle.hascrateitem=function(name,force)
    return toggle.refreshinventory(force)[name]==true
end
toggle.refreshcrateitems=function(rec,now)
    local ok,children=pcall(function()return rec.folder and rec.folder.Parent and rec.folder:GetChildren()end)
    if not ok or type(children)~="table"then rec.itemscache={};return end
    local cached=rec.itemscache or{};local count=0
    for i=1,math.min(6,#children)do
        local valid,name,key,taken=pcall(function()local child=children[i];return child.Name,toggle.instanceaddress(child),toggle.cratetaken(child)end)
        if valid and type(name)=="string"and key then
            count=count+1;local item=cached[count];if type(item)~="table"or not rawget(item,"crateitem")or item.key~=key then item={crateitem=true,key=key};cached[count]=item end
            item.Name=name;item.taken=taken==true
        end
    end
    for i=#cached,count+1,-1 do cached[i]=nil end;rec.itemscache=cached;rec.itemcachetime=now
end
toggle.crateunavailable=function(rec,child)
    if not child or toggle.cratetaken(child)then return true end;if rec and rec.cratecollected and rec.cratecollected[toggle.crateitemkey(child)]then return true end;return toggle.hascrateitem(child.Name)
end
toggle.nextcrateitem=function(rec,start,step)
    local children=rec and rec.itemscache or{};local count=math.min(#children,6);if count==0 then return nil end
    for n=1,count do local index=((start-1+step*n)%count)+1;if not toggle.crateunavailable(rec,children[index])then return index end end
end
toggle.crateselect=function(step)
    local rec=toggle.instacratestate.active;if not toggle.instacrate or not rec then return false end
    if rec.crateused then rec.crateselected=nil;return false end
    rec.crateselected=toggle.nextcrateitem(rec,rec.crateselected or(step>0 and 0 or 1),step);return rec.crateselected~=nil
end
toggle.autocollectindex=function(rec)
    if not rec or rec.crateused then return nil end
    local children=rec and rec.itemscache or{}
    for i=1,#toggle.autocollect.order do
        local wanted=toggle.autocollect.order[i]
        if toggle.autocollect.selected[wanted.name]then for j=1,math.min(#children,6)do local child=children[j];if child and child.Name==wanted.name and not toggle.crateunavailable(rec,child)then return j end end end
    end
end
toggle.finishcratecollect=function(request,received,notify)
    local state=toggle.instacratestate;if state.request~=request then return end
    state.request=nil;state.worker=false;state.collecting=false;state.collectuntil=0
    if state.collectid~=request.id or not toggle.running then return end
    state.nextcollect=tick()+(received and 0 or 0.25)
    local rec=request.rec
    if received and rec.active and not rec.crateused then
        rec.cratecollected=rec.cratecollected or{};rec.cratecollected[request.childkey]=true;rec.crateused=true;rec.crateselected=nil
        if state.active==rec then state.active=nil;state.distance=math.huge end
        pcall(bindlog,"collected "..(cratenames[request.name]or request.name),"supply")
    elseif notify and not request.automatic then pcall(bindlog,"item was not added to inventory","supply")end
end
toggle.collectcrate=function(automatic)
    local state=toggle.instacratestate;local rec=state.active;local now=tick()
    if not toggle.instacrate then return false,"disabled"end;if not rec or not rec.itemscache then return false end
    if rec.crateused then rec.crateselected=nil;return false end
    local distance=state.distance or math.huge;if distance>1.8 then return false,distance<=3.5 and"move closer to crate"or nil end
    if state.request or state.collecting or state.worker or now<(state.nextcollect or 0)then return false end
    local child=rec.itemscache[rec.crateselected or 0]
    if toggle.crateunavailable(rec,child)then rec.crateselected=toggle.nextcrateitem(rec,rec.crateselected or 0,1);child=rec.itemscache[rec.crateselected or 0]end
    if not child then return false,"no item available"end
    local character=lp.Character;if not character then return false end
    state.collectid=(state.collectid or 0)+1;state.collecting=true;state.worker=true;state.collectuntil=now+0.65
    state.request={id=state.collectid,rec=rec,name=child.Name,childkey=toggle.crateitemkey(child),characterkey=toggle.instanceaddress(character)or character,automatic=automatic==true,phase="open",attempts=0,next=now+0.01,deadline=now+0.6}
    return true
end
toggle.runcratequeue=function()
    local state=toggle.instacratestate;local request=state.request;if not request then return end;local now=tick();if now<request.next then return end
    local rec=request.rec;local character=lp.Character
    if not toggle.running or not toggle.instacrate or state.collectid~=request.id or not character or(toggle.instanceaddress(character)or character)~=request.characterkey or not rec.active or not rec.object or not rec.object.Parent then toggle.finishcratecollect(request,false,false);return end
    if request.attempts>0 and toggle.hascrateitem(request.name,true)then toggle.finishcratecollect(request,true,false);return end
    if now>=request.deadline then toggle.finishcratecollect(request,false,true);return end
    if request.phase=="wait"then
        if now>=request.retryat and request.attempts<3 then request.phase="open"else request.next=now+0.015;return end
    end
    -- Native remote work runs on one worker, never inside drawing/input callbacks.
    local root=character:FindFirstChild("HumanoidRootPart")or character:FindFirstChild("Torso")
    if not root or not root.Parent or not root:IsA("BasePart")then toggle.finishcratecollect(request,false,false);return end;local delta=root.Position-rec.object.Position;if math.sqrt(delta.X*delta.X+delta.Y*delta.Y+delta.Z*delta.Z)*stud2m>1.8 then toggle.finishcratecollect(request,false,false);return end
    local remote=rs:FindFirstChild("SupplyClientEvent");if not remote or not remote.Parent or not remote:IsA("RemoteEvent")then toggle.finishcratecollect(request,false,true);return end
    if request.phase=="open"then
        if not toggle.fireevent(remote,"Open",true)then toggle.finishcratecollect(request,false,true);return end
        request.phase="collect";request.next=now+0.015
    else
        if not toggle.fireevent(remote,"Collect",request.name)then toggle.finishcratecollect(request,false,true);return end
        request.attempts=request.attempts+1;request.phase="wait";request.retryat=now+0.12;request.next=now+0.015
    end
end
toggle.tryautocollect=function()
    local state=toggle.instacratestate;if state.collecting and not state.worker and tick()>=(state.collectuntil or 0)then state.collecting=false end;local rec=state.active;if not toggle.autocollect.enabled or not toggle.instacrate or state.collecting or state.worker or tick()<(state.nextcollect or 0)or not rec or rec.crateused or(state.distance or math.huge)>1.8 then return end
    local index=toggle.autocollectindex(rec);if index then rec.crateselected=index;toggle.collectcrate(true)end
end
espcfg={
    RakeSpawnPart={directpart=true,text="cave",color=Color3.fromHex("#ffffff"),noring=true,group="locations"},
    FlareGunPickUp={rootname="FlareGun",text="flare",color=Color3.fromHex("#ff6b6b"),ringradius=2.2,ringyoffset=1,group="flares"},
    BaseCampMSG={directpart=true,text="base",color=Color3.fromHex("#ffffff"),noring=true,group="locations"},
    SafehouseMSG={directpart=true,text="house",color=Color3.fromHex("#ffffff"),textyoffset=25,noring=true,group="locations"},
    StationMSG={directpart=true,text="station",color=Color3.fromHex("#ffffff"),noring=true,group="locations"},
    ShopMSG={directpart=true,text="shop",color=Color3.fromHex("#ffffff"),noring=true,group="locations"},
    ObservationTowerMSG={directpart=true,text="tower",color=Color3.fromHex("#ffffff"),noring=true,group="locations"},
    Scrap1={rootname="Scrap",text="scrap 1",color=Color3.fromHex("#a79266"),ringradius=2.2,ringyoffset=1,group="scraps"},
    Scrap2={rootname="Scrap",text="scrap 2",color=Color3.fromHex("#c9aa68"),ringradius=2.2,ringyoffset=1,group="scraps"},
    Scrap3={rootname="Scrap",text="scrap 3",color=Color3.fromHex("#dfb65d"),ringradius=2.2,ringyoffset=1,group="scraps"},
    Scrap4={rootname="Scrap",text="scrap 4",color=Color3.fromHex("#ecca30"),ringradius=2.2,ringyoffset=1,group="scraps"},
    Scrap5={rootname="Scrap",text="scrap 5",color=Color3.fromHex("#ffd000"),ringradius=2.2,ringyoffset=1,group="scraps"},
    RakeTrapModel={rootname="HitBox",text="trap",color=Color3.fromHex("#edd2f3"),ringradius=2.2,ringyoffset=0,textyoffset=-5,group="traps"},
    Box={rootname="HitBox",text="crate",color=Color3.fromHex("#9EE2FF"),ringradius=6,ringyoffset=3.2,crate=true,group="crates"},
    SupplyCrate={rootname="HitBox",text="crate",color=Color3.fromHex("#9EE2FF"),ringradius=6,ringyoffset=3.2,crate=true,group="crates"}
}
for _,cfg in pairs(espcfg)do cfg.labelcolor=cfg.color;cfg.rgb=false;cfg.defaultcolor=cfg.color;cfg.defaultrgb=false end
local tracked={}
local byaddr={}
toggle.bysource=setmetatable({},{__mode="k"})
local function getmodel(inst)
    local current=inst;local seen={}
    for _=1,32 do if not current then return nil end;local key=toggle.instanceaddress(current)or current;if seen[key]then return nil end;seen[key]=true;if current:IsA("Model")then return current end;current=current.Parent end
end
local function finddesc(parent,name)
    if not parent then return nil end
    local direct=parent:FindFirstChild(name)
    if direct then return direct end
    local desc=parent:GetDescendants()
    for i=1,#desc do if desc[i].Name==name then return desc[i]end end
end
local function findclass(parent,classname)
    if not parent then return nil end
    local direct=parent:FindFirstChildWhichIsA(classname)
    if direct then return direct end
    local desc=parent:GetDescendants()
    for i=1,#desc do if desc[i]:IsA(classname)then return desc[i]end end
end
local function scrapcfg(modelname)
    local n=tonumber(string.match(tostring(modelname),"^Scrap(%d+)"))
    local name=n and "Scrap"..tostring(n) or nil
    return name and espcfg[name] and name or nil
end
local function getcfg(inst,model)
    local cfg=espcfg[inst.Name]
    if cfg and cfg.directpart and inst:IsA("BasePart")then return inst.Name,cfg end
    if model then
        cfg=espcfg[model.Name]
        if cfg and not cfg.directpart then return model.Name,cfg end
        local name=scrapcfg(model.Name)
        if name then return name,espcfg[name]end
    end
end
local function getpart(inst,model,cfgname,cfg)
    if cfg.directpart then return inst:IsA("BasePart")and inst or nil,model end
    local rmodel=model
    if cfgname=="SupplyCrate" and rmodel and not finddesc(rmodel,cfg.rootname)then
        local box=rmodel:FindFirstChild("Box")
        if box and box:IsA("Model")then rmodel=box end
    end
    local part=rmodel and finddesc(rmodel,cfg.rootname)
    return part and part:IsA("BasePart")and part or nil,rmodel
end
local function itemfolder(model)
    if not model then return nil end
    local box=model
    if box.Name~="Box" then local inner=box:FindFirstChild("Box");if inner and inner:IsA("Model")then box=inner end end
    return box:FindFirstChild("Items_Folder")
end
toggle.drawdistance=function(text,icon,value,cx,y,c,a,on)
    if not on then toggle.setvisible(text,false);return end
    toggle.setprop(text,"Text",value);toggle.setpos(text,cx,y);toggle.setprop(text,"Color",c);toggle.setprop(text,"Transparency",a);toggle.applyespoutline(text,a,c);toggle.setprop(text,"Size",espfontsize);toggle.setprop(text,"Font",font);toggle.setvisible(text,on)
end
local function makelabels(rec)
    if rec.name and rec.distance then return end
    rec.name=toggle.esptext(rec.cfg.text,rec.cfg.labelcolor,true,false,toggle.esptextoutline);toggle.setprop(rec.name,"Size",espfontsize);rec.name.Font=font
    rec.distance=toggle.esptext("0m",toggle.distancestyle.labelcolor,true,false,toggle.esptextoutline);toggle.setprop(rec.distance,"Size",espfontsize);rec.distance.Font=font
    setz(rec.name,rec.cfg.crate and 10 or 8);setz(rec.distance,rec.cfg.crate and 10 or 8)
end
local function makering(rec,count)
    if rec.cfg.noring or not toggle.ringenabled then return end
    if not rec.ring or rec.ring[1]and toggle.removeddraw[rec.ring[1]]then rec.ring={};rec.ringpoints={};rec.ringvisible=false;rec.ringactivecount=0 end
    for i=#rec.ring+1,count do rec.ring[i]=newline(rec.cfg.labelcolor or toggle.white)end
end
local function hidering(rec)if(rec.ringanim or 0)>0.01 then return end;if rec.ring and rec.ringvisible~=false then for i=1,#rec.ring do hide(rec.ring[i])end;rec.ringvisible=false;rec.ringactivecount=0 end end
local function makecrate(rec)
    if not rec.cfg.crate then return end;local intact=rec.items and rec.bg and rec.take and rec.takekey and rec.cratetitle and not toggle.removeddraw[rec.bg]and not toggle.removeddraw[rec.take]and not toggle.removeddraw[rec.takekey]and not toggle.removeddraw[rec.cratetitle];if intact then for i=1,#rec.items do if toggle.removeddraw[rec.items[i]]or toggle.removeddraw[rec.status[i]]then intact=false;break end end end;if intact then return end
    for _,d in pairs({rec.bg,rec.bgouter,rec.bgmiddle,rec.bginner,rec.take,rec.crateheadbg,rec.crateheadborder,rec.cratetitle,rec.crategift,rec.takekey})do remove(d)end;if rec.items then for i=1,#rec.items do remove(rec.items[i]);remove(rec.status and rec.status[i])end end
    rec.crateheadbg=setz(newsquare(cratebg,guiopacity),7);rec.crateheadborder=setz(newborder(color("outline"),1),7.1);rec.cratetitle=setz(toggle.esptext("Crate Supplies",color("text"),false,false),9);rec.crategift=toggle.newicon(9);rec.craterows={};rec.takeanim=0;rec.bg=setz(newsquare(cratebg,guiopacity),7);rec.bgouter=setz(newborder(Color3.fromHex("#000000"),1),7);rec.bgmiddle=setz(newborder(Color3.fromHex("#555555"),1),7);rec.bginner=setz(newborder(Color3.fromHex("#000000"),1),7);rec.items={};rec.status={};rec.take=setz(toggle.esptext("Take",color("text"),false,false,false),9);rec.take.Font=font;rec.takekey=setz(toggle.esptext("",color("accent"),false,false,false),9);rec.takekey.Font=font;rec.crateradius=toggle.borderradius
    for _,entry in ipairs({{rec.bgouter,0},{rec.bgmiddle,1},{rec.bginner,2},{rec.bg,1}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end
    for i=1,6 do rec.items[i]=setz(toggle.esptext("",cratetext,true,false,toggle.esptextoutline),8);rec.items[i].Font=font;rec.status[i]=setz(toggle.esptext("",color("muted"),true,false,toggle.esptextoutline),9);rec.status[i].Font=font end
end
local function hiderec(rec)
    if rec.hidden then return end;rec.hidden=true;rec.inventoryvisible=false
    hide(rec.name);hide(rec.distance);hidering(rec);hide(rec.bg);hide(rec.bgouter);hide(rec.bgmiddle);hide(rec.bginner);hide(rec.take);hide(rec.crateheadbg);hide(rec.crateheadborder);hide(rec.cratetitle);hide(rec.crategift);hide(rec.takekey)
    if rec.items then for i=1,#rec.items do hide(rec.items[i]);hide(rec.status and rec.status[i])end end
end
local function removerec(rec)
    remove(rec.name);remove(rec.distance);
    if rec.ring then for i=1,#rec.ring do remove(rec.ring[i])end end
    remove(rec.bg);remove(rec.bgouter);remove(rec.bgmiddle);remove(rec.bginner);remove(rec.take);remove(rec.crateheadbg);remove(rec.crateheadborder);remove(rec.cratetitle);remove(rec.crategift);remove(rec.takekey)
    if rec.items then for i=1,#rec.items do remove(rec.items[i]);remove(rec.status and rec.status[i])end end
end
local function track(inst)
    if not inst then return end
    local existing=toggle.bysource[inst];if existing then local ok,alive=pcall(function()return existing.object and existing.object.Parent~=nil end);if ok and alive then existing.seen=toggle.scanid;return end;toggle.bysource[inst]=nil end
    if #tracked>=maxtrack then return end
    local model=getmodel(inst)
    local cfgname,cfg=getcfg(inst,model)
    if not cfg then return end
    local part,rmodel=getpart(inst,model,cfgname,cfg)
    if not part then return end
    local source=rmodel or part
    local address=source.Address
    if not address then return end
    existing=byaddr[address];if existing then existing.seen=toggle.scanid;existing.object=part;existing.model=rmodel or part.Parent;existing.source=inst;existing.active=true;existing.folder=nil;existing.itemscache=nil;toggle.bysource[inst]=existing;return end
    local rec={address=address,source=inst,object=part,model=rmodel or part.Parent,cfgname=cfgname,cfg=cfg,folder=cfg.crate and itemfolder(rmodel)or nil,hidden=true,seen=toggle.scanid,active=true}
    byaddr[address]=rec;toggle.bysource[inst]=rec;tracked[#tracked+1]=rec
    if toggle.notifications.ready then local tier=tonumber(string.match(cfgname or"","^Scrap(%d+)$"));local tint=cfg.rgb and rgb(0)or cfg.labelcolor;if tier then toggle.notifyevent("scrap","scrap "..tostring(tier).." spawned [+"..tostring(toggle.scrapvalues[tier]or 0).."p]",tint)elseif cfgname=="FlareGunPickUp"then toggle.notifyevent("flare","flare gun spawned",tint)elseif cfg.group=="traps"then toggle.notifyevent("trap","rake trap spawned",tint)elseif cfg.group=="crates"then toggle.notifyevent("supply","supply crate spawned",tint)end end
end
local function untrack(i)
    local rec=tracked[i]
    if not rec then return end
    rec.active=false;if toggle.instacratestate.active==rec then toggle.instacratestate.active=nil;toggle.instacratestate.distance=math.huge end;removerec(rec);byaddr[rec.address]=nil;if rec.source then toggle.bysource[rec.source]=nil end;tracked[i]=tracked[#tracked];tracked[#tracked]=nil
end
local function scan()
    local work=0;local function slice()work=work+1;if work>=16 then work=0;toggle.wait()end end
    for i=#tracked,1,-1 do slice();local rec=tracked[i];local ok,alive=pcall(function()return rec.object and rec.object.Parent~=nil end);if not ok or not alive then if(rec.ringanim or 0)>0.01 then rec.active=false else untrack(i)end end end
    toggle.scanid=toggle.scanid+1
    local filter=ws:FindFirstChild("Filter")
    if filter then
        local spawns=filter:FindFirstChild("ScrapSpawns")
        if spawns then
            local spawnchildren=spawns:GetChildren()
            for i=1,#spawnchildren do
                slice();local spawnpoint=spawnchildren[i]
                if string.match(spawnpoint.Name,"ItemSpawn")then local children=spawnpoint:GetChildren();for j=1,#children do pcall(track,children[j]);slice()end end
            end
        end
        local cave=filter:FindFirstChild("RakeSpawnPart");if cave then pcall(track,cave)end
        local points=filter:FindFirstChild("LocationPoints")
        if points then local children=points:GetChildren();for i=1,#children do pcall(track,children[i]);slice()end end
    end
    local flare=ws:FindFirstChild("FlareGunPickUp");if flare then pcall(track,flare)end
    local debris=ws:FindFirstChild("Debris")
    if debris then
        local traps=debris:FindFirstChild("Traps")
        if traps then local c=traps:GetChildren();for i=1,#c do pcall(track,c[i]);slice()end end
        local crates=debris:FindFirstChild("SupplyCrates")or debris:FindFirstChild("SupplyCreates")
        if crates then local c=crates:GetChildren();for i=1,#c do pcall(track,c[i]);slice()end end
    end
    for i=1,#tracked do slice();local rec=tracked[i];local present=rec.object~=nil and rec.object.Parent~=nil;if rec.seen==toggle.scanid and present then rec.active=true;rec.missed=0 else rec.missed=(rec.missed or 0)+1;rec.active=present and rec.missed<2 end end
    local scraps,points,flare,traps,crates=0,0,false,0,0
    for i=1,#tracked do slice();local rec=tracked[i];if rec.active then local tier=rec.cfgname and tonumber(string.match(rec.cfgname,"^Scrap(%d+)$"));if tier then scraps=scraps+1;points=points+(toggle.scrapvalues[tier]or 0)elseif rec.cfgname=="FlareGunPickUp"then flare=true elseif rec.cfg.group=="traps"then traps=traps+1 elseif rec.cfg.group=="crates"then crates=crates+1 end end end
    local info=toggle.worldinfo;if info.scraps~=scraps or info.points~=points or info.flare~=flare or info.traps~=traps or info.crates~=crates then info.scraps,info.points,info.flare,info.traps,info.crates=scraps,points,flare,traps,crates;worldpos()end;toggle.notifications.ready=true
end
local function viewpos()
    local ok,position=pcall(function()local char=lp.Character;local root=toggle.localroot;if toggle.localcharacter~=char or not root or not root.Parent then toggle.localcharacter=char;root=char and char:FindFirstChild("HumanoidRootPart");toggle.localroot=root end;return root and root:IsA("BasePart")and root.Position or cam.Position end)
    if ok and position then return position end;toggle.localroot=nil;local safe,fallback=pcall(function()return cam.Position end);return safe and fallback or Vector3.new(0,0,0)
end
local function dist(a,b)
    local x,y,z=b.X-a.X,b.Y-a.Y,b.Z-a.Z
    return math.sqrt(x*x+y*y+z*z)*stud2m
end
toggle.makepromptrecord=function(id,options,commands)
    local state=toggle.promptstate;local rec=state.records[id];if not rec then rec={id=id,options={},commands={},selected=1,anim=0,shutter=0,selectanim={},bg=setz(newsquare(Color3.fromHex("#000000"),guiopacity),41),shutterdraw=setz(newsquare(Color3.fromHex("#000000"),0),43),outer=setz(newborder(Color3.fromHex("#000000"),1),44),middle=setz(newborder(Color3.fromHex("#555555"),1),44),inner=setz(newborder(Color3.fromHex("#000000"),1),44),texts={},actionkey=setz(toggle.esptext("F",color("accent"),false,false,false),46),action=setz(toggle.esptext("Toggle",color("text"),false,false,false),46)};rec.action.Font=font;rec.actionkey.Font=font;state.records[id]=rec end
    rec.options=options;rec.commands=commands;rec.selected=clamp(rec.selected or 1,1,math.max(1,#options));for i=#rec.texts+1,#options do rec.texts[i]=setz(toggle.esptext(options[i],color("text"),true,false,toggle.esptextoutline),46);rec.texts[i].Font=font end;for i=1,#options do rec.texts[i].Text=options[i]end;return rec
end
toggle.hideprompt=function(rec)
    if not rec then return end;for _,d in ipairs({rec.bg,rec.shutterdraw,rec.outer,rec.middle,rec.inner,rec.action,rec.actionkey})do toggle.setvisible(d,false)end;for i=1,#rec.texts do toggle.setvisible(rec.texts[i],false)end
end
toggle.promptrange=function(rec)return rec and rec.id=="house"and 4 or rec and rec.id=="trapdoor"and 2.9 or rec and rec.id=="release"and 3 or 2 end
toggle.resolveprompts=function(force)
    local state=toggle.promptstate;local now=toggle.frametime or tick();if not force and now<(state.nextresolve or 0)then return end;state.nextresolve=now+0.5;local map=ws:FindFirstChild("Map");local house=map and map:FindFirstChild("SafeHouse");local housedoor=house and house:FindFirstChild("Door");local tower=map and map:FindFirstChild("ObservationTower");local towerdoor=tower and tower:FindFirstChild("Door");local towerlights=tower and tower:FindFirstChild("Lights");local radar=tower and tower:FindFirstChild("Radar")
    local options,commands={},{};if toggle.promptsettings.housedoor then options[#options+1]="door";commands[#commands+1]="door"end;if toggle.promptsettings.houselights then options[#options+1]="lights";commands[#commands+1]="light"end;if toggle.promptsettings.houseknock then options[#options+1]="knock";commands[#commands+1]="knock"end;local houseprompt=toggle.makepromptrecord("house",options,commands);houseprompt.part=housedoor and housedoor:FindFirstChild("DoorButton");houseprompt.remote=housedoor and housedoor:FindFirstChild("RemoteEvent")
    options=toggle.promptsettings.trapdoor and{"trapdoor"}or{};commands=toggle.promptsettings.trapdoor and{"trapdoor"}or{};local trap=toggle.makepromptrecord("trapdoor",options,commands);local doorlever=towerdoor and towerdoor:FindFirstChild("DoorLever");trap.part=doorlever and doorlever:FindFirstChild("DoorGUIPart");trap.rangepart=trap.part;trap.remote=towerlights and towerlights:FindFirstChild("RemoteEvent");trap.value=towerdoor and towerdoor:FindFirstChild("DoorOpen")
    options=toggle.promptsettings.forceopen and{"release"}or{};commands=toggle.promptsettings.forceopen and{"forceopen"}or{};local release=toggle.makepromptrecord("release",options,commands);local doorlever2=towerdoor and towerdoor:FindFirstChild("DoorLever2");release.part=tower and tower:FindFirstChild("LadderPart");release.rangepart=doorlever2 and doorlever2:FindFirstChild("DoorGUIPart2");release.remote=towerlights and towerlights:FindFirstChild("RemoteEvent")
    options=toggle.promptsettings.radar and{"radar"}or{};commands=toggle.promptsettings.radar and{"radar"}or{};local radarrec=toggle.makepromptrecord("radar",options,commands);local lever=radar and radar:FindFirstChild("Lever");radarrec.part=lever and lever:FindFirstChild("RadarGUIPart");radarrec.remote=towerlights and towerlights:FindFirstChild("RemoteEvent")
    options=toggle.promptsettings.towerlights and{"lights"}or{};commands=toggle.promptsettings.towerlights and{"towerlights"}or{};local lightrec=toggle.makepromptrecord("towerlights",options,commands);local lightlever=towerlights and towerlights:FindFirstChild("LightLever");lightrec.part=lightlever and lightlever:FindFirstChild("LightGUIPart");lightrec.remote=towerlights and towerlights:FindFirstChild("RemoteEvent")
end
toggle.setpromptmaster=function(value,quiet)
    toggle.prompts=value==true;toggle.promptsettings.master=toggle.prompts;if not toggle.prompts and toggle.promptstate.holdid then toggle.holdprompt(false)end;menuupdate();if not quiet then bindlog(toggle.prompts and"enabled bypass prompts"or"disabled bypass prompts")end
end
toggle.paintprompt=function(rec)
    if not rec.screen then rec.anim=0;toggle.hideprompt(rec);return end
    local target=rec.target==true;rec.anim=toggle.ease(rec.anim or 0,target and 1 or 0,target and 0.24 or 0.22)
    if not target and rec.anim<=0.01 then toggle.hideprompt(rec);return end
    local count=#rec.options;if count==0 then toggle.hideprompt(rec);return end
    local active=target and toggle.promptstate.active==rec and(keybinds.prompt or 0)~=0
    if active and rec.actionindex~=rec.selected then rec.actionindex=rec.selected;rec.taganim=0 end
    rec.taganim=toggle.ease(rec.taganim or 0,active and 1 or 0,0.22);local tagindex=clamp(rec.actionindex or rec.selected,1,count)
    if rec.shutterin then rec.shutter=toggle.ease(rec.shutter or 0,1,0.52);if rec.shutter>=0.94 then rec.shutterin=false end else rec.shutter=toggle.ease(rec.shutter or 0,0,0.34)end
    local holding=rec.commands[tagindex]=="trapdoor";local key=toggle.bindname("prompt");local action=holding and"Hold"or"Toggle";local charw=espfontsize*7/13;local keyw,actionw=toggle.espwidth(key),toggle.espwidth(action);local tagw=keyw+7+actionw
    local pad=cratepady;local cellw=(cratewidth-24)/3;for j=1,count do cellw=math.max(cellw,toggle.espwidth(toggle.uititle(rec.options[j]))+16)end;cellw=math.max(cellw,keyw+7+toggle.espwidth("Toggle")+16)
    local width=count*cellw+pad*2;local rowheight=toggle.esplineheight*3+6;local height=rowheight+pad*2
    local x=toggle.pixel(rec.screen.X-width/2);local y=toggle.pixel(rec.screen.Y-height-16+(1-rec.anim)*7);local alpha=rec.anim;local bg=color("bg")
    for _,entry in ipairs({{rec.bg,x+1,y+1,width-2,height-2},{rec.middle,x,y,width,height},{rec.shutterdraw,x+1,y+1,width-2,height-2}})do local d=entry[1];toggle.setpos(d,entry[2],entry[3]);toggle.setprop(d,"Size",Vector2.new(entry[4],entry[5]));toggle.setprop(d,"Corner",math.max(0,toggle.borderradius-1))end
    toggle.setprop(rec.bg,"Color",bg);toggle.setprop(rec.bg,"Transparency",guiopacity*alpha);toggle.setprop(rec.middle,"Color",color("outline"));toggle.setprop(rec.middle,"Transparency",0.24*guiopacity*alpha);toggle.setprop(rec.shutterdraw,"Color",toggle.textbrightness(bg)<0.5 and toggle.white or Color3.new(0,0,0));toggle.setprop(rec.shutterdraw,"Transparency",0.6*alpha*rec.shutter)
    toggle.setvisible(rec.outer,false);toggle.setvisible(rec.inner,false);toggle.setvisible(rec.bg,true);toggle.setvisible(rec.middle,true);toggle.setvisible(rec.shutterdraw,rec.shutter>0.01)
    local tagy=y+pad;for j=1,#rec.texts do local text=rec.texts[j];local visible=j<=count;if visible then
        local label=toggle.uititle(rec.options[j]);local tagged=j==tagindex;local blockheight=toggle.esplineheight*2+3;local top=y+pad+(rowheight-blockheight)/2;local center=x+pad+(j-0.5)*cellw
        rec.selectanim[j]=toggle.ease(rec.selectanim[j]or 0,rec.selected==j and 1 or 0,0.22);local dim=toggle.colormix(color("text"),bg,0.58);local selectedcolor=toggle.colormix(color("text"),color("accent"),0.25);local tint=toggle.colormix(dim,selectedcolor,rec.selectanim[j]);toggle.setprop(text,"Text",label);toggle.setprop(text,"Center",false);toggle.setpos(text,center-toggle.espwidth(label)/2,top);toggle.setprop(text,"Color",tint);toggle.setprop(text,"Transparency",alpha);toggle.setprop(text,"Outline",false);toggle.setprop(text,"Size",espfontsize);toggle.setprop(text,"Font",font)
        if tagged then tagy=top+toggle.esplineheight+3+(1-rec.taganim)*3 end
    end;toggle.setvisible(text,visible)end
    local center=x+pad+(tagindex-0.5)*cellw;local tagx=center-tagw/2;local tagalpha=alpha*rec.taganim;local tagon=tagalpha>0.01 and tagy+toggle.esplineheight<=y+height-1
    for _,entry in ipairs({{rec.actionkey,key,tagx,color("accent")},{rec.action,action,tagx+keyw+7,color("text")}})do local d=entry[1];toggle.setprop(d,"Text",entry[2]);toggle.setprop(d,"Center",false);toggle.setpos(d,entry[3],tagy);toggle.setprop(d,"Size",espfontsize);toggle.setprop(d,"Font",font);toggle.setprop(d,"Color",entry[4]);toggle.setprop(d,"Transparency",tagalpha);toggle.setprop(d,"Outline",false);toggle.setvisible(d,tagon)end
end
toggle.discardprompt=function(rec)
    if not rec then return end;toggle.hideprompt(rec);for _,d in pairs({rec.bg,rec.shutterdraw,rec.outer,rec.middle,rec.inner,rec.action,rec.actionkey})do remove(d)end;for i=1,#rec.texts do remove(rec.texts[i])end;toggle.promptstate.records[rec.id]=nil;toggle.promptstate.nextresolve=0
end
toggle.drawprompts=function(viewer)
    local state=toggle.promptstate;if not toggle.prompts then state.active=nil;state.distance=math.huge;local fading=false;for _,rec in pairs(state.records)do if(rec.anim or 0)>0.01 then fading=true;break end end;if not fading then return end end;if toggle.prompts and not pcall(toggle.resolveprompts,false)then state.nextresolve=0 end;state.active=nil;state.distance=math.huge;state.priority=math.huge
    for i=1,#toggle.promptorder do local rec=state.records[toggle.promptorder[i].id];if rec then rec.target=false
        local ok=pcall(function()local part=rec.part;local rangeobject=rec.rangepart or part;if toggle.prompts and(toggle.worldinfo.power or rec.id=="trapdoor"or rec.id=="release")and #rec.options>0 and part and part.Parent and part:IsA("BasePart")and rangeobject and rangeobject.Parent and rangeobject:IsA("BasePart")and rec.remote and rec.remote.Parent and rec.remote:IsA("RemoteEvent")then local meters=dist(viewer,rangeobject.Position);local screen,on=WorldToScreen(part.Position);rec.meters=meters;rec.target=on and meters<=toggle.promptrange(rec);if rec.target then rec.screen=screen;local dx,dy=screen.X-cam.ViewportSize.X/2,screen.Y-cam.ViewportSize.Y/2;local priority=dx*dx+dy*dy;if priority<state.priority then state.active=rec;state.distance=meters;state.priority=priority end end end end)
        if not ok then rec.part=nil;rec.remote=nil;state.nextresolve=0 end
    end end
    for i=1,#toggle.promptorder do local rec=state.records[toggle.promptorder[i].id];if rec then local ok,err=pcall(toggle.paintprompt,rec);if not ok then rec.drawerror=err;if state.active==rec then state.active=nil end;pcall(toggle.discardprompt,rec)end end end
end
toggle.promptselect=function(step)
    local rec=toggle.promptstate.active;if not rec or #rec.options<2 then return false end;rec.selected=((rec.selected-1+step)%#rec.options)+1;return true
end
toggle.enqueueprompt=function(id,command,down)
    local state=toggle.promptstate;local queue=state.queue or{};state.queue=queue
    if #queue>=8 then if down==false then table.remove(queue,#queue)else return false end end;local now=tick();if down~=false and now<(state.nextaction or 0)then return false end
    if down~=false then state.nextaction=now+0.12 end;queue[#queue+1]={id=id,command=command,down=down,created=now};return true
end
toggle.useprompt=function()
    local state=toggle.promptstate;local rec=state.active;if not toggle.prompts or not rec or not rec.target or(state.distance or math.huge)>toggle.promptrange(rec)then return false end
    local option=rec.commands[rec.selected]or rec.commands[1];if option=="trapdoor"then return toggle.holdprompt(true)end
    local queued=toggle.enqueueprompt(rec.id,option,nil);if queued then rec.shutter=0;rec.shutterin=true end;return queued
end
toggle.holdprompt=function(down)
    local state=toggle.promptstate;if not down then if state.holdid then local id=state.holdid;local queued=toggle.enqueueprompt(id,"trapdoor",false);if queued then state.holdid=nil end;return queued end;return false end
    local rec=state.active;if state.holdid or not toggle.prompts or not rec or rec.commands[rec.selected]~="trapdoor"or(state.distance or math.huge)>toggle.promptrange(rec)then return false end
    if toggle.enqueueprompt(rec.id,"trapdoor",true)then state.holdid=rec.id;rec.shutter=0;rec.shutterin=true;return true end;return false
end
toggle.runpromptqueue=function()
    local state=toggle.promptstate;if state.busy then return false end;if state.holding and state.holdid then local code=keybinds.prompt or 0;local ok,down=pcall(function()return toggle.prompts and code~=0 and iskeypressed(code)end);if ok and not down then toggle.holdprompt(false)end end;if not state.queue or #state.queue==0 then return false end;local job=table.remove(state.queue,1);state.busy=true
    local ok,fired=pcall(function()
        local releasing=job.command=="trapdoor"and job.down==false;if not releasing and(not toggle.prompts or tick()-job.created>0.5)then return false end
        local setting=job.command=="door"and"housedoor"or job.command=="light"and"houselights"or job.command=="knock"and"houseknock"or job.command;if not releasing and toggle.promptsettings[setting]~=true then return false end
        local map=ws:FindFirstChild("Map");local tower=map and map:FindFirstChild("ObservationTower");local lights=tower and tower:FindFirstChild("Lights");local remote,part,argument=nil,nil,nil
        if job.id=="house"then local house=map and map:FindFirstChild("SafeHouse");local door=house and house:FindFirstChild("Door");remote=door and door:FindFirstChild("RemoteEvent");part=door and door:FindFirstChild("DoorButton");argument=job.command=="door"and"Door"or job.command=="light"and"Light"or job.command=="knock"and"Knock"or nil
        else remote=lights and lights:FindFirstChild("RemoteEvent");local door=tower and tower:FindFirstChild("Door");if job.id=="trapdoor"or job.id=="release"then local lever=door and door:FindFirstChild(job.id=="trapdoor"and"DoorLever"or"DoorLever2");part=lever and lever:FindFirstChild(job.id=="trapdoor"and"DoorGUIPart"or"DoorGUIPart2");argument=job.id=="trapdoor"and"Door"or"Door2"
            elseif job.id=="radar"then local radar=tower and tower:FindFirstChild("Radar");local lever=radar and radar:FindFirstChild("Lever");part=lever and lever:FindFirstChild("RadarGUIPart");argument="Radar"
            elseif job.id=="towerlights"then local lever=lights and lights:FindFirstChild("LightLever");part=lever and lever:FindFirstChild("LightGUIPart");argument="Light"end end
        if not remote or not remote.Parent or not remote:IsA("RemoteEvent")or not argument then return false end
        if not releasing then local character=lp.Character or ws:FindFirstChild(lp.Name);local root=character and character:FindFirstChild("HumanoidRootPart");local hum=character and character:FindFirstChildOfClass("Humanoid");if not root or not root.Parent or not root:IsA("BasePart")or not hum or hum.Health<=0 or not part or not part.Parent or not part:IsA("BasePart")then return false end;local meters=dist(root.Position,part.Position);if meters~=meters or meters>toggle.promptrange({id=job.id})then return false end
            if job.id~="trapdoor"and job.id~="release"then local power=rs:FindFirstChild("StationPower");if not power or not power.Parent or power.Value~=true then return false end end end
        if job.command=="trapdoor"then return toggle.fireevent(remote,argument,job.down==true)end;return toggle.fireevent(remote,argument)
    end)
    state.busy=false;if job.command=="trapdoor"then if job.down==true and ok and fired then state.holding=true elseif job.down==false then state.holding=false elseif state.holdid==job.id then state.holdid=nil end end
    if ok and fired and job.command~="trapdoor"then bindlog("toggled "..job.command,"menu")end;return ok and fired==true
end

toggle.refreshworldstats=function()
    local info=toggle.worldinfo;local object=toggle.stationpower;if not object or not object.Parent then object=rs:FindFirstChild("StationPower");toggle.stationpower=object end;local on=false;if object then local ok,value=pcall(function()return object.Value end);on=ok and value==true end
    if info.power~=on then info.power=on;worldpos();return true end;return false
end
local function drawcrate(rec,screen,meters,yoffset)
    if not rec.cfg.crate then return end
    if not rec.folder or not rec.folder.Parent then rec.folder=itemfolder(rec.model)end
    local target=toggle.supplyitems and meters<=10 and rec.folder~=nil
    rec.crateanim=toggle.ease(rec.crateanim or 0,target and 1 or 0,target and 0.24 or 0.22);if math.abs(rec.crateanim-(target and 1 or 0))<0.005 then rec.crateanim=target and 1 or 0 end
    local anim=rec.crateanim;rec.inventoryvisible=anim>0.01 and rec.itemscache and #rec.itemscache>0 or false
    if not target and anim<=0.01 then
        for _,d in pairs({rec.bg,rec.bgouter,rec.bgmiddle,rec.bginner,rec.take,rec.crateheadbg,rec.crateheadborder,rec.cratetitle,rec.crategift,rec.takekey})do hide(d)end
        if rec.items then for i=1,#rec.items do hide(rec.items[i]);hide(rec.status[i])end end;return
    end
    makecrate(rec);local modern=toggle.hudstyle=="modern";local now=toggle.frametime or tick()
    if target and(not rec.itemscache or now-(rec.itemcachetime or 0)>=0.2)then toggle.refreshcrateitems(rec,now)end
    local children=rec.itemscache or{};local count=math.min(#children,#rec.items);local active=toggle.instacrate and not rec.crateused and toggle.instacratestate.active==rec
    rec.inventoryvisible=anim>0.01 and count>0
    if active and(not rec.crateselected or toggle.crateunavailable(rec,children[rec.crateselected]))then rec.crateselected=toggle.nextcrateitem(rec,rec.crateselected or 0,1)end
    local basey=screen.Y-12+yoffset+cratey+(rec.cratestack or 0)+(1-anim)*7;local owneditems=toggle.refreshinventory(false);local takeindex=nil;local cellw=(cratewidth-24)/3;local rowheight=toggle.esplineheight*3+6;local rowspans={rowheight,rowheight}
    for i=1,#rec.items do
        local d,status,child=rec.items[i],rec.status[i],children[i];local safe,alive=pcall(function()return child and(type(child)=="table"and rawget(child,"crateitem")and type(child.Name)=="string"or child.Parent~=nil)end)
        local state=rec.craterows[i]or{phase=0,statusphase=0};rec.craterows[i]=state;state.alive=safe and alive
        if state.alive then
            local taken=toggle.cratetaken(child)or rec.cratecollected and rec.cratecollected[toggle.crateitemkey(child)];local owned=owneditems[child.Name]==true;local unavailable=taken or owned
            local selected=active and meters<=1.8 and rec.crateselected==i and not unavailable;local auto=toggle.autocollect.enabled and toggle.autocollect.selected[child.Name]and not unavailable
            state.phase=toggle.ease(state.phase,selected and 1 or 0,0.22);local itemstyle=toggle.cratestyles[child.Name];local full=itemstyle and(itemstyle.rgb and rgb((i-1)/#rec.items)or itemstyle.labelcolor)or cratetext
            local normal=unavailable and color("muted")or toggle.colormix(toggle.colormix(full,color("bg"),0.58),full,state.phase);if not state.tint then state.tint=normal end;state.tint=toggle.colormix(state.tint,normal,1-(1-0.24)^((toggle.framedt or 1/60)*60))
            local itemcolor=toggle.hudtextcolor(state.tint);toggle.setprop(d,"Text",toggle.uititle(cratenames[child.Name]or child.Name));toggle.setprop(d,"Center",false);toggle.setprop(d,"Size",espfontsize);toggle.setprop(d,"Color",itemcolor);toggle.setprop(d,"Transparency",anim);toggle.setprop(d,"Outline",false);toggle.setvisible(d,anim>0.01)
            local text=taken and"Taken"or owned and"Owned"or auto and"[auto]"or"";if text~=state.status then state.status=text;state.statusphase=0 end;state.statusphase=toggle.ease(state.statusphase,text~=""and 1 or 0,0.2)
            local statuscolor=unavailable and toggle.colormix(itemcolor,themes.borderblack,0.28)or color("accent");toggle.setprop(status,"Center",false);toggle.setprop(status,"Size",espfontsize);toggle.setprop(status,"Text",text);toggle.setprop(status,"Color",statuscolor);toggle.setprop(status,"Transparency",anim*state.statusphase);toggle.setprop(status,"Outline",false);toggle.setvisible(status,text~=""and state.statusphase>0.01 and anim>0.01)
            state.blockheight=toggle.esplineheight+(text~=""and toggle.esplineheight+3 or 0);local row=math.floor((i-1)/3)+1;rowspans[row]=math.max(rowspans[row],state.blockheight);if selected then takeindex=i end
        else toggle.setvisible(d,false);toggle.setvisible(status,false)end
    end
    if takeindex and takeindex~=rec.takeindex then rec.takeindex=takeindex;rec.takeanim=0 end;rec.takeanim=toggle.ease(rec.takeanim or 0,takeindex and 1 or 0,0.22)
    if rec.takeindex and rec.takeanim>0.01 then local index=rec.takeindex;local row=math.floor((index-1)/3)+1;local state=rec.craterows[index];if state and state.alive then state.blockheight=(state.blockheight or toggle.esplineheight)+toggle.esplineheight+3;rowspans[row]=math.max(rowspans[row],state.blockheight)end end
    local rows=2;local rowtops={0,rowspans[1]+10};local contents=rowspans[1]+10+rowspans[2]
    for i=1,#rec.items do local state=rec.craterows[i];if state and state.alive then local row=math.floor((i-1)/3)+1;local col=(i-1)%3;local center=screen.X+(col-1)*cellw;local y=basey+rowtops[row]+(rowspans[row]-(state.blockheight or toggle.esplineheight))/2;toggle.setpos(rec.items[i],center-toggle.textwidth(rec.items[i])/2,y);toggle.setpos(rec.status[i],center-toggle.textwidth(rec.status[i])/2,y+toggle.esplineheight+3+(1-state.statusphase)*3)end end
    if rec.takeindex then
        local index=rec.takeindex;local row=math.floor((index-1)/3)+1;local col=(index-1)%3;local center=screen.X+(col-1)*cellw;local y=rec.items[index].Position.Y+toggle.esplineheight+3+(rec.status[index].Text~=""and espfontsize+3 or 0)+(1-rec.takeanim)*3
        local key=toggle.bindname("crate");toggle.setprop(rec.takekey,"Text",key);toggle.setprop(rec.takekey,"Size",espfontsize);toggle.setprop(rec.takekey,"Center",false);toggle.setprop(rec.takekey,"Color",color("accent"));toggle.setprop(rec.takekey,"Transparency",anim*rec.takeanim);toggle.setprop(rec.takekey,"Outline",false)
        toggle.setprop(rec.take,"Text","Take");toggle.setprop(rec.take,"Size",espfontsize);toggle.setprop(rec.take,"Center",false);toggle.setprop(rec.take,"Color",color("text"));toggle.setprop(rec.take,"Transparency",anim*rec.takeanim);toggle.setprop(rec.take,"Outline",false)
        local width=toggle.textwidth(rec.takekey)+7+toggle.textwidth(rec.take);toggle.setpos(rec.takekey,center-width/2,y);toggle.setpos(rec.take,center-width/2+toggle.textwidth(rec.takekey)+7,y)
    end
    local takeon=rec.takeindex~=nil and rec.takeanim>0.01 and anim>0.01;toggle.setvisible(rec.take,takeon);toggle.setvisible(rec.takekey,takeon)
    local miny=basey-cratepady;local height=contents+cratepady*2;local left=screen.X-cratewidth/2;local titlewidth=toggle.textwidth(rec.cratetitle);local headwidth=16+18+10+titlewidth+18;local headleft=screen.X-headwidth/2;local headheight=toggle.esplineheight+22;local heady=miny-headheight-4
    rec.crateheight=count>0 and height+headheight+4 or 0;local panelon=modern and anim>0.01 and count>0
    for _,entry in ipairs({{rec.bg,left+1,miny+1,cratewidth-2,height-2},{rec.bgmiddle,left,miny,cratewidth,height},{rec.crateheadbg,headleft+1,heady+1,headwidth-2,headheight-2},{rec.crateheadborder,headleft,heady,headwidth,headheight}})do local d=entry[1];toggle.setpos(d,entry[2],entry[3]);toggle.setprop(d,"Size",Vector2.new(entry[4],entry[5]));toggle.setprop(d,"Corner",math.max(0,toggle.borderradius-1));toggle.setprop(d,"Color",(d==rec.bgmiddle or d==rec.crateheadborder)and color("outline")or color("bg"));toggle.setprop(d,"Transparency",anim*guiopacity*((d==rec.bgmiddle or d==rec.crateheadborder)and 0.24 or 1));toggle.setvisible(d,panelon)end
    toggle.setvisible(rec.bgouter,false);toggle.setvisible(rec.bginner,false);local tint=color("text");local texty=heady+(headheight-toggle.esplineheight)/2
    toggle.setpos(rec.cratetitle,headleft+44,texty);toggle.setprop(rec.cratetitle,"Center",false);toggle.setprop(rec.cratetitle,"Size",espfontsize);toggle.setprop(rec.cratetitle,"Color",tint);toggle.setprop(rec.cratetitle,"Transparency",anim);toggle.setprop(rec.cratetitle,"Outline",false);toggle.setvisible(rec.cratetitle,count>0 and anim>0.01);toggle.seticon(rec.crategift,"giftbox",headleft+16,heady+(headheight-18)/2,18,tint,anim,count>0 and anim>0.01)
end
toggle.ringpoint=function(world,y,radius,t,sides,angle)
    if sides==0 then local a=angle+2*math.pi*t;return Vector3.new(world.X+math.cos(a)*radius,y,world.Z+math.sin(a)*radius)end
    local scaled=t*sides;local side=math.floor(scaled)%sides;local blend=scaled-math.floor(scaled);local a=angle-math.pi/2+2*math.pi*side/sides;local b=angle-math.pi/2+2*math.pi*((side+1)%sides)/sides
    return Vector3.new(world.X+(math.cos(a)*(1-blend)+math.cos(b)*blend)*radius,y,world.Z+(math.sin(a)*(1-blend)+math.sin(b)*blend)*radius)
end
-- A perspective transform projects every point on the ring's ground plane.
-- Four corner projections replace 33-65 native calls without changing its shape.
toggle.ringprojection=function(world,y,radius)
    if radius<0.01 then return nil end
    local p0,o0=WorldToScreen(Vector3.new(world.X-radius,y,world.Z-radius));local p1,o1=WorldToScreen(Vector3.new(world.X+radius,y,world.Z-radius))
    local p2,o2=WorldToScreen(Vector3.new(world.X+radius,y,world.Z+radius));local p3,o3=WorldToScreen(Vector3.new(world.X-radius,y,world.Z+radius))
    if not(o0 and o1 and o2 and o3)then return nil end
    local dx1,dx2,dx3=p1.X-p2.X,p3.X-p2.X,p0.X-p1.X+p2.X-p3.X
    local dy1,dy2,dy3=p1.Y-p2.Y,p3.Y-p2.Y,p0.Y-p1.Y+p2.Y-p3.Y
    local g,h=0,0
    if math.abs(dx3)+math.abs(dy3)>0.0001 then local determinant=dx1*dy2-dx2*dy1;if math.abs(determinant)<0.000001 then return nil end;g=(dx3*dy2-dx2*dy3)/determinant;h=(dx1*dy3-dx3*dy1)/determinant end
    return{a=p1.X-p0.X+g*p1.X,b=p3.X-p0.X+h*p3.X,c=p0.X,d=p1.Y-p0.Y+g*p1.Y,e=p3.Y-p0.Y+h*p3.Y,f=p0.Y,g=g,h=h}
end
toggle.projectring=function(matrix,world,y,radius,x,z)
    if not matrix then return WorldToScreen(Vector3.new(world.X+x*radius,y,world.Z+z*radius))end
    local u,v=(x+1)/2,(z+1)/2;local denominator=matrix.g*u+matrix.h*v+1
    if math.abs(denominator)<0.000001 then return Vector2.new(0,0),false end
    local sx,sy=(matrix.a*u+matrix.b*v+matrix.c)/denominator,(matrix.d*u+matrix.e*v+matrix.f)/denominator
    local viewport=cam.ViewportSize;return Vector2.new(sx,sy),sx>=0 and sy>=0 and sx<=viewport.X and sy<=viewport.Y
end

local function drawring(rec,world,meters,wanted)
    if not world then hidering(rec);return end
    local on=wanted~=false and toggle.esp and(not rec.cfg.crate or toggle.supplylabel and not rec.inventoryvisible)and not rec.cfg.noring and toggle.ringenabled and meters<ringfade;rec.ringanim=toggle.ease(rec.ringanim or 0,on and 1 or 0,on and 0.22 or 0.18)
    if rec.ringanim<=0.01 then rec.ringanim=0;hidering(rec);return end
    local sides=toggle.ringshape=="triangle"and 3 or toggle.ringshape=="square"and 4 or toggle.ringshape=="hexagon"and 6 or 0;local segments=sides>0 and sides or meters>40 and 32 or meters>20 and 48 or 64;if on then makering(rec,segments)end;if not rec.ring then return end;segments=math.min(segments,#rec.ring);local y=world.Y-(rec.cfg.ringyoffset or 0);local radius=(rec.cfg.ringradius or 2)*toggle.ringsize*rec.ringanim;local alpha=clamp(1-meters/ringfade,0,1)*toggle.ringopacity*rec.ringanim;local angle=toggle.ringspin and(toggle.frametime or tick())*toggle.ringspinspeed or 0;local cachekey=tostring(sides)..":"..tostring(segments);local unit=toggle.ringunit[cachekey]
    if not unit then unit={};for n=0,segments do local point=toggle.ringpoint(Vector3.new(0,0,0),0,1,n/segments,sides,0);unit[n+1]=Vector2.new(point.X,point.Z)end;toggle.ringunit[cachekey]=unit end
    local cosa,sina=1,0;if angle~=0 then cosa,sina=math.cos(angle),math.sin(angle)end;local ringcolor=rec.cfg.rgb and toggle.ringrgbcolor or rec.cfg.labelcolor;local matrix=segments>16 and toggle.ringprojection(world,y,radius)or nil;local first=unit[1];local firstx=first.X*cosa-first.Y*sina;local firstz=first.X*sina+first.Y*cosa;local previous,previouson=toggle.projectring(matrix,world,y,radius,firstx,firstz)
    for i=1,segments do
        local point=unit[i+1];local px=point.X*cosa-point.Y*sina;local pz=point.X*sina+point.Y*cosa;local current,currenton=toggle.projectring(matrix,world,y,radius,px,pz);local line=rec.ring[i];local visible=previouson and currenton
        if visible then local points=rec.ringpoints[i];if not points then points={};rec.ringpoints[i]=points end;if points.fx~=previous.X or points.fy~=previous.Y then line.From=previous;points.fx,points.fy=previous.X,previous.Y end;if points.tx~=current.X or points.ty~=current.Y then line.To=current;points.tx,points.ty=current.X,current.Y end;toggle.setprop(line,"Color",ringcolor);toggle.setprop(line,"Transparency",alpha)end;toggle.setvisible(line,visible);previous,previouson=current,currenton
    end;if(rec.ringactivecount or 0)>segments then for i=segments+1,rec.ringactivecount do toggle.setvisible(rec.ring[i],false)end end;rec.ringactivecount=segments;rec.ringvisible=true
end
toggle.cleartracers=function()
    local state=toggle.tracers;for key,rec in pairs(state.records)do for _,line in ipairs(rec.lines or{})do remove(line)end;state.records[key]=nil end;state.count=0
end
toggle.touchtracer=function(kind,key,x,y,tint,alpha)
    local state=toggle.tracers;if not state.selected[kind]or not x or not y or x~=x or y~=y or math.abs(x)>1000000 or math.abs(y)>1000000 then return end
    local rec=state.records[key];if not rec then if state.count>=maxtrack+65 then return end;rec={kind=kind,anim=0,lines={}};state.records[key]=rec;state.count=state.count+1 end
    rec.seen=state.frame;rec.x=x;rec.y=y;rec.tint=tint;rec.alpha=alpha or 1
end
toggle.tracerpart=function(kind,key,part,tint,viewer,range)
    if not part or not part.Parent then return end;local world=part.Position;if range and dist(viewer,world)>range then return end;local screen,on=WorldToScreen(world);if on then toggle.touchtracer(kind,key,screen.X,screen.Y,tint,1)end
end
toggle.updatetracertargets=function(viewer)
    local state=toggle.tracers;local selected=state.selected;if not next(selected)then return end
    for i=1,#tracked do local rec=tracked[i];local kind=rec.cfg.group=="flares"and"flare"or rec.cfg.group;if selected[kind]and rec.active~=false then pcall(toggle.tracerpart,kind,rec,rec.object,rec.cfg.rgb and rgb(0)or rec.cfg.labelcolor,viewer)end end
    if selected.rake then pcall(toggle.tracerpart,"rake",toggle.rakepanel,toggle.rakepart,toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor,viewer,toggle.rakerenderdistance)end
    if selected.players then
        local now=toggle.frametime or tick();state.players=state.players or{};if now>=(state.nextplayers or 0)then state.nextplayers=now+0.5;local present={};local source=players:GetPlayers()
            for i=1,math.min(#source,65)do local player=source[i];if player.Name~=lp.Name then local name=player.Name;present[name]=true;local rec=state.players[name]or{};state.players[name]=rec;local character=player.Character or ws:FindFirstChild(name);rec.root=character and(character:FindFirstChild("HumanoidRootPart")or character:FindFirstChild("Torso"))end end
            for name in pairs(state.players)do if not present[name]then state.players[name]=nil end end
        end
        for name,rec in pairs(state.players)do local tint=name==toggle.targetplayername and toggle.colormix(toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor,toggle.white,0.35)or toggle.hudtextcolor(color("text"));pcall(toggle.tracerpart,"players",rec,rec.root,tint,viewer,toggle.playeresp.distance)end
    end
end
toggle.drawtracers=function()
    local state=toggle.tracers;if state.count==0 then return end;local now=toggle.frametime or tick();local mx,my=mouse.X,mouse.Y;state.phase=((state.phase or 0)+(toggle.framedt or 1/60)*0.65*state.speed)%1;local samples=state.samples or{};state.samples=samples;for i=1,state.segments do local sample=samples[i];if not sample then local u=i/state.segments;sample={u=u,bend=2*u*(1-u)};samples[i]=sample end;local phase=((i-0.5)/state.segments-state.phase)*math.pi*2;sample.alpha=0.55+math.exp((math.cos(phase)-1)*5)*0.35 end
    for key,rec in pairs(state.records)do
        local on=state.selected[rec.kind]and rec.seen==state.frame;rec.anim=toggle.ease(rec.anim,on and 1 or 0,on and 0.10 or 0.13)
        if not on and rec.anim<=0.01 then for _,line in ipairs(rec.lines)do remove(line)end;state.records[key]=nil;state.count=state.count-1
        else
            rec.drawx=rec.x;rec.drawy=rec.y
            local dx,dy=rec.drawx-mx,rec.drawy-my;local length=math.sqrt(dx*dx+dy*dy);local bend=math.min(75,length*0.13);local last=Vector2.new(mx,my)
            for i=1,state.segments do
                local sample=samples[i];local point=Vector2.new(mx+dx*sample.u,my+dy*sample.u-bend*sample.bend)
                local line=rec.lines[i];if not line then line=setz(newline(rec.tint),0.5);rec.lines[i]=line end
                toggle.setprop(line,"From",last);toggle.setprop(line,"To",point);toggle.setprop(line,"Color",rec.tint);toggle.setprop(line,"Thickness",1.5);toggle.setprop(line,"Transparency",rec.anim*rec.alpha*state.opacity*sample.alpha);toggle.setvisible(line,length>3 and rec.anim>0.01);last=point
            end
        end
    end
end
local function drawrec(rec,viewer)
    local object=rec.object
    if rec.active==false or not object or not object.Parent then hiderec(rec);if rec.lastworld and(rec.ringanim or 0)>0.01 then drawring(rec,rec.lastworld,rec.lastmeters or 0,false);return true end;return false end
    local group=rec.cfg.group
    local world=object.Position;local meters=dist(viewer,world);rec.lastworld=world;rec.lastmeters=meters;local crateinventory=rec.cfg.crate and toggle.supplyitems;if(not espgroups[group]or espgroups.items[rec.cfgname]==false)and not crateinventory then hiderec(rec);drawring(rec,world,meters,false);return true end
    if not toggle.esp and not(rec.cfg.crate and toggle.instacrate and toggle.supplyitems)then hiderec(rec);drawring(rec,world,meters,false);return true end
    meters=rec.cfg.crate and rec.cratelayouttime==toggle.frametime and rec.cratemeters or meters
    local screen,on;if rec.cfg.crate and rec.cratelayouttime==toggle.frametime then screen,on=rec.cratescreen,rec.crateonscreen else screen,on=WorldToScreen(world)end
    if not on then hiderec(rec);drawring(rec,world,meters,false);return true end
    rec.hidden=false
    local yoffset=rec.cfg.textyoffset or 0;local crateok=true;if rec.cfg.crate then crateok=pcall(drawcrate,rec,screen,meters,yoffset)end;local sx,sy=screen.X,screen.Y
    makelabels(rec)
    local alpha=1
    local labelvisible=toggle.esp and(not rec.cfg.crate or toggle.supplylabel and not rec.inventoryvisible);local topy=sy-espfontsize-2+yoffset;local bottomy=sy+2+yoffset;local labelcolor=rec.cfg.rgb and rgb(0)or rec.cfg.labelcolor;toggle.setprop(rec.name,"Text",toggle.uititle(rec.cfg.text));toggle.setpos(rec.name,sx,bottomy);toggle.setprop(rec.name,"Transparency",alpha);toggle.setprop(rec.name,"Color",labelcolor);toggle.applyespoutline(rec.name,alpha);toggle.setprop(rec.name,"Size",espfontsize);toggle.setvisible(rec.name,labelvisible)
    local distancevisible=labelvisible and toggle.distance and meters>=toggle.distancemin;local distancecolor=toggle.distancestyle.rgb and rgb(0)or toggle.distancestyle.labelcolor;toggle.drawdistance(rec.distance,nil,tostring(math.floor(meters)).."m",sx,toggle.distanceposition=="above"and topy or bottomy+espfontsize+4,distancecolor,1,distancevisible)
    if not crateok then rec.inventoryvisible=false; rec.folder=nil;rec.itemscache=nil;for _,d in pairs({rec.bg,rec.bgouter,rec.bgmiddle,rec.bginner,rec.take,rec.crateheadbg,rec.crateheadborder,rec.cratetitle,rec.crategift,rec.takekey})do hide(d)end;if rec.items then for i=1,#rec.items do hide(rec.items[i]);hide(rec.status[i])end end end
    if not pcall(drawring,rec,world,meters)then if rec.ring then for i=1,#rec.ring do remove(rec.ring[i])end end;rec.ring=nil end
    return true
end
toggle.healthtint=function(ratio,above)return above and Color3.fromHex("#9ccfff")or Color3.fromHSV(clamp(ratio,0,1)/3,0.45,1)end
toggle.playerprops=setmetatable({},{__mode="k"})
toggle.playerprop=function(d,key,value)
    if not d or toggle.removeddraw[d]then return end;local meta=toggle.textroles[d];if meta then if key=="Font"then value=meta.preview or toggle.fontvalue(meta.role)elseif key=="Size"and type(value)=="number"then meta.size=value end end;local props=toggle.playerprops[d];if not props then props={};toggle.playerprops[d]=props end;local old=props[key];local same=old==value
    if not same and old and value then if key=="Color"then same=math.abs(old.R-value.R)<0.00001 and math.abs(old.G-value.G)<0.00001 and math.abs(old.B-value.B)<0.00001 elseif key=="Position"or key=="Size"and typeof(value)=="Vector2"then same=typeof(old)=="Vector2"and old.X==value.X and old.Y==value.Y end end
    if not same then d[key]=value;props[key]=value end;if key=="Color"then toggle.drawcolors[d]=value end
end
toggle.playerpos=function(d,x,y)
    if x~=x or y~=y or math.abs(x)==math.huge or math.abs(y)==math.huge then return end;toggle.playerprop(d,"Position",Vector2.new(math.floor(x*4+0.5)/4,math.floor((y+toggle.textoffset(d))*4+0.5)/4))
end
toggle.playeroutline=function(d,fade,c)toggle.playerprop(d,"Outline",toggle.outlineallowed(c,toggle.esptextoutline,fade))end
toggle.playerkey=function(player)return tostring(player.Name)end
toggle.hideplayerrecord=function(rec)
    if not rec then return end;rec.anim=0;if rec.texts then for i=1,#rec.texts do toggle.playerprop(rec.texts[i],"Visible",false)end end
    if rec.draws then for i=1,#rec.draws do toggle.playerprop(rec.draws[i],"Visible",false)end end
end
toggle.removeplayerrecord=function(rec)
    if not rec then return end;if rec.texts then for i=1,#rec.texts do remove(rec.texts[i])end end;if rec.draws then for i=1,#rec.draws do remove(rec.draws[i])end end;rec.frames=nil;rec.draws=nil;rec.layercount=nil;rec.healthpane=nil;rec.distancepane=nil;rec.detailbg=nil;rec.detailtop=nil;rec.detailouter=nil;rec.detailmiddle=nil;rec.detailinner=nil;rec.itemnodes=nil;rec.nodelookup=nil;rec.texts={}
end
toggle.makeplayerpanel=function(rec)
    if rec.draws then local valid=true;for i=1,#rec.draws do if toggle.removeddraw[rec.draws[i]]then valid=false;break end end;if valid then if(rec.detailanim or 0)>0.01 then toggle.makeplayerdetails(rec)end;return end;for i=1,#rec.draws do remove(rec.draws[i])end end
    rec.bg=setz(newsquare(color("bg"),guiopacity),1);rec.top=setz(newsquare(color("top"),0.25*guiopacity),2);rec.outer=setz(newborder(themes.borderblack,1),3);rec.middle=setz(newborder(color("outline"),1),3);rec.inner=setz(newborder(themes.borderblack,1),3)
    rec.title=setz(toggle.esptext(rec.shortname or"player",color("text"),false,false,toggle.esptextoutline),3);rec.person=toggle.newicon(3);rec.healthtext=setz(toggle.esptext("",toggle.white,false,false,toggle.esptextoutline),3);rec.heart=toggle.newicon(3);rec.distancetext=setz(toggle.esptext("",toggle.white,false,false,toggle.esptextoutline),3);rec.distanceicon=toggle.newicon(3)
    rec.draws={rec.outer,rec.middle,rec.inner,rec.bg,rec.top,rec.title,rec.person,rec.healthtext,rec.heart,rec.distancetext,rec.distanceicon};rec.frames={{rec.outer,0},{rec.middle,1},{rec.inner,2},{rec.bg,3},{rec.top,3}};if rec.rake then rec.statustext=setz(toggle.esptext("",color("text"),false,false,toggle.esptextoutline),3);rec.draws[#rec.draws+1]=rec.statustext end;rec.radius=-1
    for _,kind in ipairs({"health","distance"})do local pane={};rec[kind.."pane"]=pane;pane.bg=setz(newsquare(color("bg"),guiopacity),1);pane.top=setz(newsquare(color("top"),guiopacity*0.25),2);pane.outer=setz(newborder(themes.borderblack,1),3);pane.middle=setz(newborder(color("outline"),1),3);pane.inner=setz(newborder(themes.borderblack,1),3);for _,entry in ipairs({{pane.outer,0,false,kind},{pane.middle,1,false,kind},{pane.inner,2,false,kind},{pane.bg,3,false,kind},{pane.top,3,false,kind}})do rec.frames[#rec.frames+1]=entry;rec.draws[#rec.draws+1]=entry[1]end end
    if(rec.detailanim or 0)>0.01 then toggle.makeplayerdetails(rec)end
end
toggle.makeplayerdetails=function(rec)
    if rec.detailbg and not toggle.removeddraw[rec.detailbg]then return end
    rec.detailbg=setz(newsquare(color("bg"),guiopacity),1);rec.detailtop=setz(newsquare(color("top"),0.25*guiopacity),2);rec.detailouter=setz(newborder(themes.borderblack,1),3);rec.detailmiddle=setz(newborder(color("outline"),1),3);rec.detailinner=setz(newborder(themes.borderblack,1),3)
    for _,entry in ipairs({{rec.detailouter,0,true},{rec.detailmiddle,1,true},{rec.detailinner,2,true},{rec.detailbg,3,true},{rec.detailtop,3,true}})do rec.frames[#rec.frames+1]=entry;rec.draws[#rec.draws+1]=entry[1]end;rec.radius=-1
end
toggle.playerrecord=function(player)
    local key=toggle.playerkey(player);local rec=toggle.playeresp.records[key];if rec then rec.player=player;return rec end
    rec={id=key,player=player,username=player.Name,shortname=string.sub(player.Name,1,10)..(#player.Name>10 and".."or""),texts={},items={},anim=0,stackoffset=0,stackx=0,targetoffset=0,targetx=0};toggle.playeresp.records[key]=rec;return rec
end
toggle.refreshplayerselection=function()
    local state=toggle.playeresp;local count=0;for i=1,#state.order do if state.selected[state.order[i].name]==true then count=count+1 end end;state.selectedcount=count;state.enabled=true;state.nextroster=0;state.nextscan=0;state.nextlayout=0;state.scancursor=1
    for _,rec in pairs(state.records)do rec.layoutkey=nil end
end
toggle.layoutplayeritems=function(rec)
    rec.itemnodes=rec.itemnodes or{};rec.nodelookup=rec.nodelookup or{}
    for i=1,#rec.itemnodes do rec.itemnodes[i].active=false end
    for i=1,#rec.items do local item=rec.items[i];local node=rec.nodelookup[item.name]
        if not node then local text=setz(toggle.esptext(item.label,toggle.white,true,false,toggle.esptextoutline),3);local rank=99;for index=1,#toggle.playeresp.order do if toggle.playeresp.order[index].name==item.name then rank=index;break end end;node={item=item,text=text,anim=0,rank=rank};rec.nodelookup[item.name]=node;rec.itemnodes[#rec.itemnodes+1]=node;rec.texts[#rec.texts+1]=text end;node.label=toggle.uititle(item.label)..(item.name=="FlareGun"and(rec.flarecount or 0)>1 and" x"..rec.flarecount or"");node.active=true
    end
    table.sort(rec.itemnodes,function(a,b)return a.rank<b.rank end)
end

toggle.scanplayer=function(player,rec,viewer)
    local character=ws:FindFirstChild(player.Name)or player.Character;local characterkey=toggle.instanceaddress(character)or character;if characterkey~=rec.characterkey then rec.characterkey=characterkey;rec.stackoffset=0;rec.stackx=0;rec.nexthealth=0; end;rec.character=character;rec.root=character and(character:FindFirstChild("HumanoidRootPart")or character:FindFirstChild("Torso"));rec.humanoid=character and(character:FindFirstChild("Humanoid")or character:FindFirstChildOfClass("Humanoid"));if rec.root and rec.root:IsA("BasePart")then rec.footheight=rec.root.Size.Y/2+2.4 end
    local count=0;local itemschanged=false;if rec.root and rec.root:IsA("BasePart")and dist(viewer,rec.root.Position)<=math.min(25,toggle.playeresp.distance) and toggle.playeresp.selectedcount>0 then
        local owned={};local flarecount=0;for _,parent in pairs({backpack=player:FindFirstChild("Backpack"),character=character})do local children=parent:GetChildren();for i=1,#children do local child=children[i];local name=child.Name;owned[name]=child;if name=="FlareGun"or name=="FlareGunPickUp"or name=="FlareGunTool"then flarecount=flarecount+1 end end end;if rec.flarecount~=flarecount then rec.flarecount=flarecount;itemschanged=true end
        for i=1,#toggle.playeresp.order do local entry=toggle.playeresp.order[i];if toggle.playeresp.selected[entry.name]==true then local item=owned[entry.name];if entry.name=="FlareGun"then item=item or owned.FlareGunPickUp or owned.FlareGunTool elseif entry.name=="Vest"then local vest=owned.VestModel;item=item or vest and vest:IsA("MeshPart")end;if item then count=count+1;if rec.items[count]~=entry then itemschanged=true;rec.items[count]=entry end end end end
    end
    toggle.sampleplayerhealth(rec,toggle.frametime or tick());if #rec.items~=count then itemschanged=true end;for i=#rec.items,count+1,-1 do rec.items[i]=nil end;if itemschanged then toggle.layoutplayeritems(rec)end
end
toggle.playeritemstyle=function(name)return toggle.cratestyles[name]or name=="FlareGun"and espcfg.FlareGunPickUp or name=="RakeTrap"and espcfg.RakeTrapModel or themes.accentstyle end
toggle.refreshplayers=function(now,viewer)
    local state=toggle.playeresp
    if now>=(state.nextroster or 0)then state.nextroster=now+0.75;state.scanid=(state.scanid or 0)+1;local source=players:GetPlayers();local list=state.scanlist;local count=0
        for i=1,#source do local player=source[i];if player.Name~=lp.Name then count=count+1;list[count]=player;local rec=toggle.playerrecord(player);rec.seen=state.scanid end end
        for i=#list,count+1,-1 do list[i]=nil end;for key,rec in pairs(state.records)do if rec.seen~=state.scanid then toggle.removeplayerrecord(rec);state.records[key]=nil end end;state.scancursor=clamp(state.scancursor or 1,1,math.max(1,count))
    end
    local list=state.scanlist;if now>=(state.nextscan or 0)and #list>0 then local cursor=state.scancursor or 1;if cursor>#list then cursor=1 end;local player=list[cursor];local rec=player and state.records[toggle.playerkey(player)];if rec then local ok=pcall(toggle.scanplayer,player,rec,viewer);if not ok then rec.root=nil;rec.humanoid=nil;toggle.hideplayerrecord(rec)end end;state.scancursor=cursor%#list+1;state.nextscan=now+0.025 end
end
toggle.playersort=function(a,b)local ad,bd=a.rec.meters or math.huge,b.rec.meters or math.huge;if ad~=bd then return ad<bd end;return a.id<b.id end
toggle.layoutnametag=function(rec)
    local charw=espfontsize*7/13;local gap=rec.style=="legacy"and 4 or 2
    rec.namew=(toggle.espwidth(rec.shortname)*(font==Drawing.Fonts.Minecraft and 0.78 or 1)+39+(font==Drawing.Fonts.Pixel and 8*espfontsize/13 or 0))*(rec.nameanim or 0);rec.healthw=(toggle.espwidth(rec.healthlabel or"")+37)*(rec.healthanim or 0);rec.distancepanelw=(toggle.espwidth(rec.distancelabel or"")+37)*(rec.distanceanim or 0)
    local d,n,h=rec.distanceanim or 0,rec.nameanim or 0,rec.healthanim or 0;rec.namex=rec.distancepanelw+gap*math.min(d,math.min(1,n+h));rec.healthx=rec.namex+rec.namew+gap*math.min(n,h);rec.headerw=rec.healthx+rec.healthw;rec.headerwidth=rec.headerw
end
toggle.nametagoutline=function(d,fade,c,rec)
    if rec and rec.style=="modern"then toggle.playerprop(d,"Outline",false)else toggle.playeroutline(d,fade,c)end
end
toggle.sampleplayerhealth=function(rec,now)
    if now<(rec.nexthealth or 0)then return end;rec.nexthealth=now+0.1
    local ok,hp=pcall(function()local hum=rec.humanoid;return hum and hum.Parent and hum:IsA("Humanoid")and hum.Health end);rec.health=ok and tonumber(hp)or nil
end
toggle.playerheader=function(rec,now)
    local state=toggle.playeresp;local legacy=state.style=="legacy";rec.style=state.style;rec.background=true;rec.headertop=0;local charw=espfontsize*7/13;local rowh=toggle.esplineheight+(legacy and 1 or 3);rec.targeted=toggle.targetplayername==rec.username;rec.far=(rec.meters or 0)>25;rec.faranim=toggle.ease(rec.faranim or 0,rec.far and 1 or 0,0.2)
    toggle.sampleplayerhealth(rec,now)
    rec.healthlabel=rec.health and rec.health>0 and(state.showhealth or(rec.healthanim or 0)>0.01)and tostring(math.floor(rec.health+0.5))or""
    local nameon=state.showusername;rec.nameanim=toggle.ease(rec.nameanim or 0,nameon and 1 or 0,0.2);local healthon=not rec.far and state.showhealth and rec.health and rec.health>0;rec.healthanim=toggle.ease(rec.healthanim or 0,healthon and 1 or 0,0.2);if rec.far then rec.healthanim=0 end;if not rec.health or rec.health<=0 or rec.healthanim<=0.01 then rec.healthlabel=""end
    rec.headerwidth=(toggle.espwidth(rec.shortname)+19)*rec.nameanim+(rec.healthlabel~=""and toggle.espwidth(rec.healthlabel)+17+8*rec.nameanim or 0)*rec.healthanim
    rec.itemy=10+(rowh+3)*math.min(1,rec.nameanim+rec.healthanim);local count=0;local rowalphas=rec.rowalphas or{};rec.rowalphas=rowalphas;for i=#rowalphas,1,-1 do rowalphas[i]=nil end;local nodes=rec.itemnodes or{};local widest=0
    for i=1,#nodes do local node=nodes[i];local desired=not rec.far and node.active and state.selected[node.item.name]==true and not(rec.health~=nil and rec.health<=0);node.anim=toggle.ease(node.anim or 0,desired and 1 or 0,0.22);if node.anim>0.01 then count=count+1;node.slot=count;local row=math.floor((count-1)/3)+1;rowalphas[row]=math.max(rowalphas[row]or 0,node.anim)else node.slot=nil;toggle.playerprop(node.text,"Visible",false)end end
    local offset=0;for row=1,math.ceil(count/3)do local width=0;for i=1,#nodes do local node=nodes[i];if node.slot and math.floor((node.slot-1)/3)+1==row then width=width+toggle.espwidth(node.label)*node.anim+8*node.anim end end;width=math.max(0,width-8);widest=math.max(widest,width);local cursor=-width/2
        for i=1,#nodes do local node=nodes[i];if node.slot and math.floor((node.slot-1)/3)+1==row then local w=toggle.espwidth(node.label)*node.anim;node.x=cursor+w/2;node.y=offset;cursor=cursor+w+8*node.anim end end;offset=offset+rowh*(rowalphas[row]or 0)
    end
    rec.itemrows=math.ceil(count/3);rec.itemwidth=widest;rec.headery=legacy and 0 or 9
    local itemalpha=0;for row=1,#rowalphas do itemalpha=math.max(itemalpha,rowalphas[row])end;rec.headeranim=math.min(1,rec.nameanim+rec.healthanim);rec.distanceanim=rec.health~=nil and rec.health<=0 and 0 or toggle.ease(rec.distanceanim or 0,state.showdistance and not(rec.health~=nil and rec.health<=0)and 1 or 0,0.2);rec.distancelabel=tostring(math.floor(rec.meters or 0)).."m";rec.distancewidth=(toggle.espwidth(rec.distancelabel)+17)*rec.distanceanim;rec.headeranim=math.min(1,rec.nameanim+rec.healthanim+rec.distanceanim);rec.distancegap=8*rec.distanceanim*math.min(1,rec.nameanim+rec.healthanim);rec.headerwidth=rec.headerwidth+rec.distancewidth+rec.distancegap;rec.detailanim=itemalpha;if rec.health~=nil and rec.health<=0 then rec.detailanim=0 end
    local lineheight=toggle.esplineheight+(legacy and 2 or 18);rec.headerh=toggle.ease(rec.headerh,lineheight*rec.headeranim,0.24);local gap=(legacy and 0 or 2)*math.min(rec.headeranim,rec.detailanim);rec.detaily=rec.headerh+gap;rec.itemy=rec.detaily+rec.headery;rec.footery=rec.itemy+(count>0 and offset+(legacy and 0 or 3)or 0)
    local extrarows=count>0 and math.max(0,offset-rowh*(rowalphas[rec.itemrows]or 0))or 0
    rec.distancey=rec.headery;local detailheight=(lineheight+extrarows)*rec.detailanim;rec.detailh=toggle.ease(rec.detailh,detailheight,0.24)
    toggle.layoutnametag(rec);rec.detailw=toggle.ease(rec.detailw,math.max(40,widest+20),0.24)
    rec.panelh=rec.headerh+gap+rec.detailh;rec.panelw=math.max(rec.headerw,rec.detailanim>0.01 and rec.detailw or 0)

end
toggle.playertext=function(d,text,x,y,c,a,on,rec)
    toggle.playerprop(d,"Text",text);toggle.playerprop(d,"Font",font);toggle.playerprop(d,"Size",espfontsize);toggle.playerprop(d,"Color",c);toggle.playerprop(d,"Transparency",a);toggle.playerpos(d,x,y);toggle.nametagoutline(d,a,c,rec);toggle.playerprop(d,"Visible",on and a>0.01)
end
toggle.paintplayer=function(entry)
    local rec=entry.rec;toggle.makeplayerpanel(rec);local x=toggle.pixel(entry.basex+(rec.stackx or 0));local y=toggle.pixel(entry.basey+(rec.stackoffset or 0));local w,h=entry.w,entry.h;local alpha=rec.anim;local panelalpha=alpha*(1-0.28*(rec.rake and 0 or(rec.faranim or 0)));local palette=rec.palette or toggle.playeresp.palette;rec.targetanim=toggle.ease(rec.targetanim or 0,rec.targeted and 1 or 0,0.12);local targetmix=rec.targetanim;local namecolor=rec.rake and palette.target or toggle.colormix(palette.title,palette.target,targetmix);if not rec.rake and(rec.faranim or 0)>0 then namecolor=toggle.colormix(namecolor,Color3.new(0,0,0),rec.faranim*0.28)end;local statuscolor=toggle.colormix(palette.title,palette.target,rec.statusanim or 0);local darktarget=toggle.colormix(toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor,Color3.new(0,0,0),0.75);local panelcolor=toggle.colormix(palette.bg,darktarget,targetmix*0.65);local topcolor=toggle.colormix(palette.top,darktarget,targetmix*0.65);local bordertint=toggle.colormix(palette.outline,darktarget,targetmix*0.65);local statusmix=rec.rake and(rec.statusanim or 0)*0.65 or 0;local statusbg=statusmix>0 and toggle.colormix(palette.bg,darktarget,statusmix)or palette.bg;local statustop=statusmix>0 and toggle.colormix(palette.top,darktarget,statusmix)or palette.top;local statusborder=statusmix>0 and toggle.colormix(palette.outline,darktarget,statusmix)or palette.outline;rec.panelbgcolor=panelcolor;rec.statusbgcolor=statusbg
    if rec.radius~=toggle.borderradius then rec.radius=toggle.borderradius;for i=1,#rec.frames do local frame=rec.frames[i];pcall(function()frame[1].Corner=math.max(0,toggle.borderradius-1)end)end end
    for i=1,#rec.frames do local entry=rec.frames[i];local d,inset,detail,kind=entry[1],entry[2],entry[3],entry[4];local pane=kind and rec[kind.."pane"];local framew=detail and rec.detailw or kind=="health"and rec.healthw or kind=="distance"and rec.distancepanelw or rec.namew;local groupx=x+(w-rec.headerw)/2;local framex=detail and(rec.rake and groupx+rec.namex+(rec.namew-framew)/2 or x+(w-framew)/2)or groupx+(kind=="health"and rec.healthx or kind=="distance"and 0 or rec.namex);local framey=y+(detail and rec.detaily or(rec.headertop or 0));local frameh=detail and rec.detailh or rec.headerh;local framealpha=panelalpha*(detail and rec.detailanim or kind=="health"and rec.healthanim or kind=="distance"and rec.distanceanim or rec.nameanim)
        local isbg=d==rec.bg or d==rec.detailbg or pane and d==pane.bg;local istop=d==rec.top or d==rec.detailtop or pane and d==pane.top;local isborder=d==rec.middle or d==rec.detailmiddle or pane and d==pane.middle;local bg=kind and palette.bg or detail and statusbg or panelcolor;local top=kind and palette.top or detail and statustop or topcolor;local border=kind and palette.outline or detail and statusborder or bordertint
        if(isbg or isborder)and rec.style=="modern"then toggle.playerpos(d,framex+1,framey+1);toggle.playerprop(d,"Size",Vector2.new(math.max(1,framew-2),math.max(1,frameh-2)));local tint=isbg and bg or istop and top or isborder and border or themes.borderblack;toggle.playerprop(d,"Color",tint);toggle.playerprop(d,"Transparency",guiopacity*framealpha*(isborder and 0.24 or 1));toggle.playerprop(d,"Visible",rec.style=="modern"and(isbg or isborder)and framealpha>0.01 and frameh>2 and framew>2)else toggle.playerprop(d,"Visible",false)end
    end
    local hx=x+(w-rec.headerw)/2+rec.namex+10;local hy=y+(rec.headertop or 0)+rec.headery;local username=(rec.nameanim or 0)>0.01;local namealpha=alpha*(rec.nameanim or 0);local healthalpha=alpha*(rec.healthanim or 0)
    toggle.seticon(rec.person,rec.rake and"skull"or rec.health~=nil and rec.health<=0 and"skull"or"person",hx,hy+(toggle.esplineheight-14)/2,14,namecolor,namealpha,username and namealpha>0.01);toggle.playerprop(rec.person,"Visible",username and namealpha>0.01);toggle.playertext(rec.title,rec.shortname,hx+19,hy+(1-(rec.nameanim or 0))*3,namecolor,namealpha,username,rec);hx=x+(w-rec.headerw)/2+rec.healthx+10
    local hp=rec.health or 0;if rec.tinthealth~=hp then rec.tinthealth=hp;rec.healthcolor=toggle.healthtint(hp/(rec.rake and 400 or 100),not rec.rake and hp>100)end;toggle.seticon(rec.heart,"heart",hx,hy+(toggle.esplineheight-13)/2,13,toggle.heartcolor,healthalpha,rec.healthlabel~=""and healthalpha>0.01);toggle.playerprop(rec.heart,"Visible",rec.healthlabel~=""and healthalpha>0.01);toggle.playertext(rec.healthtext,rec.healthlabel,hx+17,hy+(1-(rec.healthanim or 0))*3,(rec.rake and toggle.rakehealthcoloring or not rec.rake and toggle.playeresp.healthcoloring)and rec.healthcolor or palette.title,healthalpha,rec.healthlabel~="",rec)
    for j=1,#(rec.itemnodes or{})do local node=rec.itemnodes[j];local text=node.text;local itemalpha=alpha*node.anim;if rec.far or rec.health~=nil and rec.health<=0 then itemalpha=0 end;if node.slot then local style=toggle.playeritemstyle(node.item.name);local itemcolor=toggle.hudtextcolor(style.rgb and rgb((j-1)/math.max(1,#rec.itemnodes))or style.labelcolor);toggle.playerprop(text,"Text",node.label);toggle.playerprop(text,"Font",font);toggle.playerprop(text,"Size",espfontsize);toggle.playerprop(text,"Color",itemcolor);toggle.playerprop(text,"Transparency",itemalpha);toggle.nametagoutline(text,itemalpha,itemcolor,rec);toggle.playerprop(text,"Center",false);toggle.playerpos(text,x+w/2+node.x-toggle.espwidth(node.label)/2,y+rec.itemy+node.y+(1-node.anim)*3);toggle.playerprop(text,"Visible",itemalpha>0.01)else toggle.playerprop(text,"Visible",false)end end
    if rec.rake then local tagx=x+(w-rec.headerw)/2+rec.namex+(rec.namew-rec.footerwidth)/2;local tagy=y+rec.footery;toggle.playertext(rec.statustext,toggle.uititle(rec.statuslabel or""),tagx,tagy+(1-(rec.statuslabelanim or 0))*3,statuscolor,alpha*(rec.statuslabelanim or 0),(rec.statuslabelanim or 0)>0.01,rec)end
    local da=alpha*(rec.distanceanim or 0);local distanceon=da>0.01;local dx=x+(w-rec.headerw)/2+10;local distancecolor=toggle.colormix(palette.title,Color3.new(0,0,0),0.18);local dy=y+(rec.distancey or 0);toggle.seticon(rec.distanceicon,"target",dx,dy+(toggle.esplineheight-13)/2,13,distancecolor,da,distanceon);toggle.playerprop(rec.distanceicon,"Visible",distanceon);toggle.playertext(rec.distancetext,rec.distancelabel or"",dx+17,dy,distancecolor,da,distanceon,rec)


end
toggle.stackplayersort=function(a,b)
    local ad,bd=a.rec.sortmeters or 0,b.rec.sortmeters or 0;if ad~=bd then return ad<bd end;return a.id<b.id
end
toggle.stackysort=function(a,b)if a.y~=b.y then return a.y<b.y end;return a.id<b.id end
toggle.placeplayerpanels=function(list)
    local state=toggle.playeresp;local order=state.stacklist or{};state.stacklist=order;local obstacles=state.stackobstacles or{};state.stackobstacles=obstacles
    for i=1,#list do order[i]=list[i]end;for i=#order,#list+1,-1 do order[i]=nil end;table.sort(order,toggle.stackplayersort)
    for i=1,#order do
        local entry=order[i];local rec=entry.rec;local x,y=entry.basex,entry.basey
        if state.stacking then
            for column=1,2 do
                local count=0;for j=1,i-1 do local previous=order[j];if x<previous.x+previous.w+4 and x+entry.w+4>previous.x then count=count+1;obstacles[count]=previous end end;for j=#obstacles,count+1,-1 do obstacles[j]=nil end;table.sort(obstacles,toggle.stackysort)
                for j=1,count do local previous=obstacles[j];if y<previous.y+previous.h+4 and y+entry.h+4>previous.y then y=previous.y+previous.h+4 end end
                if y+entry.h<=cam.ViewportSize.Y-8 or column==2 then break end;x=clamp(entry.basex+entry.w+8,8,math.max(8,cam.ViewportSize.X-entry.w-8));y=entry.basey
            end
        end
        entry.x=x;entry.y=y;rec.targetx=x-entry.basex;rec.targetoffset=y-entry.basey
    end
end
toggle.drawplayers=function(viewer)
    local state=toggle.playeresp;local enabled=toggle.esp and(state.selectedcount>0 or state.showusername or state.showdistance or state.showhealth);local now=toggle.frametime or tick();if enabled then toggle.refreshplayers(now,viewer)end
    local list=state.visible;local count=0;local layoutchanged=false
    for _,rec in pairs(state.records)do
        local ok,screen,on=pcall(function()local root=rec.root;if not root or not root.Parent or not root:IsA("BasePart")then return nil,false end;local position=root.Position;rec.meters=dist(viewer,position);if not enabled or rec.meters~=rec.meters or rec.meters==math.huge or rec.meters>state.distance or rec.meters>25 and not(state.showusername or state.showdistance)then return nil,false end;if not rec.sortmeters or math.abs(rec.meters-rec.sortmeters)>5 then rec.sortmeters=math.floor(rec.meters/5+0.5)*5 end;toggle.playerheader(rec,now);local show=enabled and((rec.nameanim or 0)>0.01 or(rec.healthanim or 0)>0.01 or(rec.distanceanim or 0)>0.01 or rec.detailanim>0.01)and rec.meters<=state.distance;if not show then return nil,false end;return WorldToScreen(position-Vector3.new(0,rec.footheight or 3.4,0))end)
        if ok and on then rec.anim=toggle.ease(rec.anim or 0,1,0.24);count=count+1;local entry=rec.renderentry or{};rec.renderentry=entry;if not rec.wasvisible or math.abs((entry.layoutw or 0)-(rec.panelw or 0))>=1 or math.abs((entry.layouth or 0)-(rec.panelh or 0))>=1 or entry.sortmeters~=rec.sortmeters then layoutchanged=true end;rec.wasvisible=true;entry.rec=rec;entry.id=rec.id;entry.sortmeters=rec.sortmeters;entry.w=rec.panelw or 96;entry.h=rec.panelh or 29;entry.basex=screen.X-entry.w/2;entry.basey=screen.Y+4;entry.x=entry.basex+(rec.targetx or 0);entry.y=entry.basey+(rec.targetoffset or 0);list[count]=entry
        else if rec.wasvisible then layoutchanged=true end;rec.wasvisible=false;toggle.hideplayerrecord(rec);rec.stackoffset=0;rec.stackx=0;rec.targetoffset=0;rec.targetx=0;if not ok then rec.root=nil;rec.nexthealth=0;state.nextscan=0 end end
    end
    if #list~=count then layoutchanged=true end;for i=#list,count+1,-1 do list[i]=nil end;table.sort(list,toggle.playersort)
    if count==0 then return end;if layoutchanged or now>=(state.nextlayout or 0)then toggle.placeplayerpanels(list);for i=1,count do local entry=list[i];entry.layoutw=entry.w;entry.layouth=entry.h end;state.nextlayout=now+0.05 end
    local palette=state.palette or{};state.palette=palette;palette.bg=color("bg");palette.top=color("top");palette.outline=color("outline");palette.title=toggle.hudtextcolor(color("text"));palette.muted=toggle.hudtextcolor(color("muted"));palette.target=toggle.colormix(toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor,toggle.white,0.35)
    for i=1,count do local entry=list[i];local rec=entry.rec;rec.stackx=toggle.ease(rec.stackx or 0,rec.targetx or 0,0.20);rec.stackoffset=toggle.ease(rec.stackoffset or 0,rec.targetoffset or 0,0.20);if not pcall(toggle.paintplayer,entry)then toggle.hideplayerrecord(rec);toggle.removeplayerrecord(rec);rec.bg=nil;rec.layoutkey=nil;state.nextscan=0 else
        local layer=math.max(0,4*256-4-(i-1)*3);if rec.zlayer~=layer or rec.layercount~=#rec.draws or rec.layertextcount~=#rec.texts then rec.zlayer=layer;rec.layercount=#rec.draws;rec.layertextcount=#rec.texts;for j=1,#rec.draws do setz(rec.draws[j],(layer+2)/256)end;for j=1,#rec.texts do setz(rec.texts[j],(layer+2)/256)end;for j=1,#rec.frames do local frame=rec.frames[j];local bg=frame[1]==rec.bg or frame[1]==rec.detailbg or frame[4]and frame[1]==rec[frame[4].."pane"].bg;setz(frame[1],(layer+(bg and 0 or 1))/256)end end
    end end
end

toggle.rakeespstyle="modern";toggle.rakestatus=true;toggle.rakerenderdistance=150;toggle.rakepanel={rake=true,shortname="rake",texts={},itemnodes={},anim=0,background=true}
toggle.raketarget=nil;toggle.rakeroof=nil;toggle.rakehp=nil
local function rakeinfo()
    local rake=ws:FindFirstChild("Rake")
    toggle.raketarget=rake and rake:FindFirstChild("TargetVal")or nil
    toggle.rakehumanoid=rake and rake:FindFirstChild("Monster")or nil;if toggle.rakehumanoid and not toggle.rakehumanoid:IsA("Humanoid")then toggle.rakehumanoid=nil end;if not toggle.rakehumanoid and rake then toggle.rakehumanoid=findclass(rake,"Humanoid")end
    toggle.rakepart=rake and(rake:FindFirstChild("HumanoidRootPart")or rake:FindFirstChild("Torso")or findclass(rake,"BasePart"))or nil;if toggle.rakepart and not toggle.rakepart:IsA("BasePart")then toggle.rakepart=findclass(rake,"BasePart")end
    local breakmodel=toggle.rakeroof;local health=toggle.rakehp;if not breakmodel or not breakmodel.Parent or not health or not health.Parent then local map=ws:FindFirstChild("Map");local safehouse=map and map:FindFirstChild("SafeHouse");local rakebreak=safehouse and finddesc(safehouse,"RakeBreak");breakmodel=rakebreak and finddesc(rakebreak,"BreakModel");health=breakmodel and finddesc(breakmodel,"Health")end
    if breakmodel and health and health:IsA("IntValue")then toggle.rakeroof=breakmodel;toggle.rakehp=health;toggle.roofpart=findclass(breakmodel,"BasePart");toggle.setprop(roofhp,"Text",health.Value<=0 and"Broken"or tostring(health.Value).."/30")else toggle.rakeroof=nil;toggle.rakehp=nil;toggle.roofpart=nil end
    local state=toggle.notifications;local turning=rake and rake:FindFirstChild("BloodTurning");local hour=rake and rake:FindFirstChild("BloodHourMode");local turningon=turning and turning.Value==true or false;local houron=hour and hour.Value==true or false;local tint=toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor
    if state.ready and turningon and not state.bloodturning then toggle.notifyevent("rake","rake is entering blood hour",tint)end
    if state.ready and houron and not state.bloodhour then toggle.notifyevent("rake","blood hour started",tint)end
    state.bloodturning=turningon;state.bloodhour=houron
end
local function getchar(part)
    local current=part
    for depth=1,64 do if not current then break end;if current:FindFirstChild("Humanoid")then return current end;local parent=current.Parent;if parent==current then break end;current=parent end
end
local function drawroof()
    if not toggle.roofpanel then toggle.roofpanel={bg=setz(newsquare(color("bg"),1),6),border=setz(newborder(color("outline"),1),7),anim=0}end;local frame=toggle.roofpanel;local on=toggle.esp and toggle.roof and toggle.rakeroof and toggle.rakehp;local part=toggle.roofpart;if on and(not part or not part.Parent)then part=findclass(toggle.rakeroof,"BasePart");toggle.roofpart=part end;local screen,visible;if part and part.Parent then screen,visible=WorldToScreen(part.Position);on=on and dist(viewpos(),part.Position)<=12 and visible end
    frame.anim=toggle.ease(frame.anim or 0,on and 1 or 0,on and 0.24 or 0.22);if visible then frame.screen=screen end;screen=visible and screen or frame.screen;local alpha=frame.anim;if not screen or alpha<=0.01 then for _,d in ipairs({frame.bg,frame.border,rooflabel,roofhp})do toggle.setvisible(d,false)end;return end
    if on then frame.hp=tonumber(toggle.rakehp.Value)or 0 end;local hp=frame.hp or 0;local text=hp<=0 and"Broken"or tostring(hp).."/30";local titlecolor=color("text");local valuecolor=titlecolor;toggle.setprop(rooflabel,"Text","Roof");toggle.setprop(roofhp,"Text",text);toggle.setprop(rooflabel,"Size",espfontsize);toggle.setprop(roofhp,"Size",espfontsize);local width=toggle.textwidth(rooflabel)+toggle.textwidth(roofhp)+38;local height=toggle.esplineheight+16;local x,y=screen.X-width/2,screen.Y-height/2+(1-alpha)*4;local modern=toggle.hudstyle=="modern"
    toggle.setpos(frame.bg,x,y);toggle.setprop(frame.bg,"Size",Vector2.new(width,height));toggle.setprop(frame.bg,"Color",color("bg"));toggle.setprop(frame.bg,"Transparency",guiopacity*alpha);toggle.setpos(frame.border,x,y);toggle.setprop(frame.border,"Size",Vector2.new(width,height));toggle.setprop(frame.border,"Color",color("outline"));toggle.setprop(frame.border,"Transparency",guiopacity*0.24*alpha);toggle.setprop(frame.bg,"Corner",toggle.borderradius);toggle.setprop(frame.border,"Corner",toggle.borderradius);toggle.setvisible(frame.bg,modern);toggle.setvisible(frame.border,modern)
    for _,d in ipairs({rooflabel,roofhp})do toggle.setprop(d,"Center",false);toggle.setprop(d,"Transparency",alpha);toggle.setvisible(d,true);if modern then toggle.setprop(d,"Outline",false)else toggle.applyespoutline(d,alpha)end end;toggle.setpos(rooflabel,x+12,y+8);toggle.setpos(roofhp,x+width-12-toggle.textwidth(roofhp),y+8);toggle.setprop(rooflabel,"Color",titlecolor);toggle.setprop(roofhp,"Color",valuecolor)
end
toggle.drawrake=function(viewer)
    local rec=toggle.rakepanel;local part=toggle.rakepart;local hum=toggle.rakehumanoid
    if not toggle.esp or not part or not part.Parent or not hum or not hum.Parent then toggle.hideplayerrecord(rec);return end
    local world=part.Position;local meters=dist(viewer,world);if meters~=meters or meters>toggle.rakerenderdistance then toggle.hideplayerrecord(rec);return end;local screen,on=WorldToScreen(Vector3.new(world.X,world.Y+4,world.Z));if not on then toggle.hideplayerrecord(rec);return end
    local legacy=toggle.rakeespstyle=="legacy";local charw=espfontsize*7/13;rec.style=toggle.rakeespstyle;rec.background=true;rec.shortname=toggle.rakenamevalue=="rake"and"Rake"or toggle.rakenamevalue;rec.targeted=false;rec.far=meters>25;rec.faranim=toggle.ease(rec.faranim or 0,rec.far and 1 or 0,0.2);rec.nameanim=1;rec.headeranim=1;rec.headerwidth=toggle.espwidth(rec.shortname)+19;rec.headery=legacy and 0 or 9
    local has=toggle.targetplayername~=nil;local now=toggle.frametime or tick();if rec.hastarget~=has then rec.hastarget=has;rec.nextsample=0 end;if rec.samplehumanoid~=hum or now>=(rec.nextsample or 0)then rec.samplehumanoid=hum;rec.nextsample=now+0.08;local ok,hp=pcall(function()return hum.Health end);rec.health=ok and tonumber(hp)or 0;if toggle.rakestatus then local chased,chasing=false,false;if has then chased,chasing=pcall(function()return hum:GetAttribute("CHZNG")end)end;rec.statuslabel=has and(chased and chasing==true and"chasing"or"stalking")or nil end end
    rec.anim=toggle.ease(rec.anim or 0,1,0.24);rec.healthanim=toggle.ease(rec.healthanim or 0,toggle.rakehealth and rec.health>0 and 1 or 0,0.2);rec.healthlabel=rec.health>0 and tostring(math.floor(rec.health+0.5))or"";rec.headerwidth=rec.headerwidth+(toggle.espwidth(rec.healthlabel)+25)*rec.healthanim
    rec.distanceanim=toggle.ease(rec.distanceanim or 0,toggle.rakedistance and 1 or 0,0.2);rec.distancelabel=tostring(math.floor(meters)).."m";rec.distancewidth=(toggle.espwidth(rec.distancelabel)+17)*rec.distanceanim;rec.distancegap=8*rec.distanceanim;rec.headerwidth=rec.headerwidth+rec.distancewidth+rec.distancegap;rec.distancey=rec.headery
    rec.statuslabelanim=has and toggle.ease(rec.statuslabelanim or 0,toggle.rakestatus and 1 or 0,0.2)or 0;rec.statusanim=toggle.ease(rec.statusanim or 0,has and 1 or 0,0.12);rec.detailanim=rec.statuslabelanim;rec.footerwidth=toggle.espwidth(toggle.uititle(rec.statuslabel or""));local lineheight=toggle.esplineheight+(legacy and 2 or 18);rec.headerh=toggle.ease(rec.headerh,lineheight,0.24);toggle.layoutnametag(rec);local gap=(legacy and 0 or 2)*rec.detailanim;rec.detaily=0;rec.footery=rec.headery;rec.detailh=toggle.ease(rec.detailh,lineheight*rec.detailanim,0.24);rec.headertop=rec.detailh+gap;rec.distancey=rec.headertop+rec.headery;rec.detailw=toggle.ease(rec.detailw,rec.footerwidth+20,0.24);rec.panelw=math.max(rec.headerw,rec.detailanim>0.01 and rec.detailw or 0);rec.panelh=rec.headerh+gap+rec.detailh;rec.stackx=0;rec.stackoffset=0
    local palette=rec.palette or{};rec.palette=palette;palette.bg=color("bg");palette.top=color("top");palette.outline=color("outline");palette.title=toggle.hudtextcolor(color("text"));palette.target=toggle.colormix(toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor,toggle.white,0.35)
    local entry=rec.renderentry or{};rec.renderentry=entry;entry.rec=rec;entry.basex=screen.X-rec.panelw/2;entry.basey=screen.Y-toggle.esplineheight+4-rec.headerh-rec.headertop;entry.w=rec.panelw;entry.h=rec.panelh;toggle.paintplayer(entry);if rec.layercount~=#rec.draws then rec.layercount=#rec.draws;for i=1,#rec.draws do setz(rec.draws[i],8)end;for i=1,#rec.frames do local f=rec.frames[i];if f[2]==3 then setz(f[1],(f[1]==rec.top or f[1]==rec.detailtop or f[4]and f[1]==rec[f[4].."pane"].top)and 7 or 6)end end end
end

local function powerhud()
    if toggle.uibatch then toggle.huddirty=true;return false end
    local changed=false
    for i=1,#powercfg do
        local entry=powercfg[i];if not entry.object or not entry.object.Parent then entry.object=powervals:FindFirstChild(entry.valuename)end;local active=entry.object and entry.object.Value==true or false
        if toggle.powerpanel.lineactive[i]~=active then toggle.powerpanel.lineactive[i]=active;changed=true end
    end
    if changed then powerpos()end;return changed
end
local function targethud()
    local rake=ws:FindFirstChild("Rake");if not toggle.raketarget or not toggle.raketarget.Parent then toggle.raketarget=rake and rake:FindFirstChild("TargetVal")or nil end;if not toggle.rakepart or not toggle.rakepart.Parent then toggle.rakepart=rake and(rake:FindFirstChild("HumanoidRootPart")or rake:FindFirstChild("Torso")or findclass(rake,"BasePart"))or nil end
    local target=toggle.raketarget and toggle.raketarget.Value or nil;local shown="None";local char=nil
    if target and typeof(target)=="Instance"then
        if target:IsA("BasePart")then char=getchar(target)elseif target:IsA("Model")then char=target elseif target:IsA("Player")then char=target.Character end;local player=char and players:FindFirstChild(char.Name);if player then shown=player.Name==lp.Name and"You"or player.Name else char=nil end
    end
    toggle.targetplayername=char and char.Name or nil;local state=toggle.notifications;local raketint=toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor;local targeted=char and char.Name==lp.Name or false;if targeted and not state.targeted then toggle.notifyevent("rake","rake is targeting you",raketint)end;state.targeted=targeted
    local present=toggle.rakepart and toggle.rakepart.Parent;local meters=present and dist(viewpos(),toggle.rakepart.Position)or nil;if meters then local teleporting=meters>=800;if teleporting and not state.raketeleporting then toggle.notifyevent("rake","rake is teleporting",raketint)elseif not teleporting and state.raketeleporting then toggle.notifyevent("rake","rake finished teleporting ["..tostring(math.floor(meters)).."m]",raketint)end;state.raketeleporting=teleporting;if meters<=toggle.notifysettings.rakedistance and not state.rakenear then state.rakenear=true;toggle.notifyevent("rake","rake is nearby ["..tostring(math.floor(meters)).."m]",raketint)elseif meters>toggle.notifysettings.rakedistance+5 then state.rakenear=false end else state.rakenear=false end
    local night=rs:FindFirstChild("Night");local safe,nighton=pcall(function()return night and night.Value==true end);nighton=safe and nighton==true;local nightchanged=toggle.targetnight~=nighton;toggle.targetnight=nighton;local worldchanged=toggle.refreshworldstats();if targettxt.Text~=shown then targettxt.Text=shown;return true end;return worldchanged or nightchanged
end
toggle.readvoltmeter=function()
    local now=tick();if now<(toggle.nextvoltmeterscan or 0)then return toggle.voltmetervalue end;toggle.nextvoltmeterscan=now+0.2;toggle.voltmetervalue=nil;toggle.voltmeterlevel=nil
    local ok,list=pcall(function()return players:GetPlayers()end);if not ok then return nil end;local samples=toggle.voltmetersamples or{};local current={};toggle.voltmetersamples=current;local best,besttime=nil,-1
    for pass=1,2 do for i=1,#list do
        local read,value=pcall(function()
            local player=list[i];if not player or not player.Parent then return nil end
            local parent=pass==1 and(player.Character or ws:FindFirstChild(player.Name))or(player:FindFirstChild("Backpack")or player:FindFirstChild("backpack"));local tool=parent and parent:FindFirstChild("Voltmeter");if not tool or not tool.Parent then return nil end
            local handle=tool:FindFirstChild("Handle");local glass=handle and handle:FindFirstChild("Glass");local surface=glass and glass:FindFirstChild("SurfaceGui");local main=surface and surface:FindFirstChild("MainFrame");local frame=main and main:FindFirstChild("Frame");local level=frame and frame:FindFirstChild("Level");if not level or not level.Parent or not level:IsA("TextLabel")then return nil end
            local text=level.Text;local number=type(text)=="string"and tonumber(string.match(text,"(%d+%.?%d*)%%"))or nil;return number and number==number and number>=0 and number<=100 and number or nil
        end)
        if read and value~=nil then
            local key=tostring(list[i].Name)..":"..pass;local previous=samples[key];local changed=previous and previous.value~=value;local updated=changed and now or previous and previous.updated or 0;current[key]={value=value,updated=updated}
            if best==nil or updated>besttime then best=value;besttime=updated end
        end
    end end
    toggle.voltmetervalue=best;return best
end
toggle.scrapamount=function()
    local points=toggle.scrappoints;if not points or not points.Parent then local backpack=lp:FindFirstChild("Backpack")or lp:FindFirstChild("backpack");local folder=backpack and backpack:FindFirstChild("ScrapFolder");points=folder and folder:FindFirstChild("Points");toggle.scrappoints=points end;local ok,value=pcall(function()return points and tonumber(points.Value)or 0 end);return ok and value or 0
end
local function scraphud()
    local oldscrap,oldpower=scraptxt.Text,toggle.powerdraw.value.Text;local availabilitychanged=false
    scraptxt.Text=tostring(toggle.scrapamount())
    local now=tick();if now>=toggle.nextpowerread then
        toggle.nextpowerread=now+0.1;local value=toggle.readvoltmeter();local available=value~=nil;if toggle.powerhudavailable~=available then toggle.powerhudavailable=available;availabilitychanged=true;menustate.itemsdirty=true end;local station=rs:FindFirstChild("StationPower");local stationon=true;if station then local ok,result=pcall(function()return station.Value end);if ok then stationon=result==true end end;toggle.poweravailable=stationon;if available then value=stationon and clamp(value,0,100)or 0;toggle.powerdraw.value.Text=string.format("%g%%",value)else toggle.powerdraw.value.Text="?"end
    end
    return availabilitychanged or oldscrap~=scraptxt.Text or oldpower~=toggle.powerdraw.value.Text
end
local function timerhud()
    if toggle.uibatch then toggle.huddirty=true;return false end
    local changed=false;local timer=math.max(0,math.floor(tonumber(timerval.Value)or 0));local shown=string.format("%d:%02d",math.floor(timer/60),timer%60);if timertxt.Text~=shown then timertxt.Text=shown;changed=true end
    local remaining=toggle.teleportcooldown and math.max(0,math.ceil((toggle.cooldownuntil or 0)-tick()))or 0
    if remaining~=toggle.cooldownremaining then toggle.cooldownremaining=remaining;toggle.cooldowndraw.value.Text=tostring(remaining).."s";toggle.setvisible(toggle.cooldowndraw.value,toggle.hudvisible("cooldown"));toggle.setvisible(toggle.cooldowndraw.label,toggle.hudvisible("cooldown"));changed=true end;return changed
end
local function showhud()
    if toggle.uibatch then toggle.huddirty=true;return end
    toggle.hudlabels=true;hudpos();powerpos();toggle.keybindpos();worldpos()
end
local function drawrgb()
    local themechanged=toggle.updatetheme();if themechanged and toggle.menu then menuupdate(true)end;local now=toggle.frametime or tick();local periodic=now>=(toggle.nextpanelrefresh or 0);if periodic then toggle.nextpanelrefresh=now+0.1 end
    if themechanged or periodic then local hudcolor=toggle.hudtextcolor(toggle.hudautocolor());local hudlabelcolor=toggle.hudtextcolor(color("muted"));for i=1,#toggle.hudvaluedraws do toggle.setprop(toggle.hudvaluedraws[i],"Color",hudcolor)end;for i=1,#toggle.hudlabeldraws do toggle.setprop(toggle.hudlabeldraws[i],"Color",hudlabelcolor)end;toggle.setprop(powerlabel,"Color",hudcolor);for i=1,#toggle.huditems do local item=toggle.huditems[i];toggle.applytextoutline(item.value,item.anim,hudcolor);toggle.applytextoutline(item.label,item.anim,hudlabelcolor)end end
    if toggle.hudanimating then hudpos()end;toggle.paintgradient(rgbline,toggle.accentbars.hud and toggle.hudbarvisible(),toggle.hudalpha or 0);if toggle.containerstyle=="modern"then toggle.paintwidget(toggle.groupwidget,(toggle.hudcount or 0)>0,toggle.hudalpha or 0,toggle.accentbars.hud)else toggle.hidewidgets()end
    if not toggle.menu and(menustate.menuanim or 0)>0.001 then menuupdate(true)end;toggle.paintgradient(menurgb,toggle.accentbars.menu and(menustate.menuanim or 0)>0.001,guiopacity*(menustate.menuanim or 0));toggle.paintgradient(picker.gradient,false)
    local p=toggle.powerpanel;if themechanged or periodic or p.rowanimating or math.abs((p.anim or 0)-(p.target or 0))>0.001 then powerpos()else toggle.paintgradient(p.gradient,toggle.hudstyle=="modern"and p.anim>0.01 and toggle.accentbars.activity,guiopacity*(p.anim or 0))end;local k=toggle.keybindpanelstate;if themechanged or periodic or k.rowanimating or math.abs((k.anim or 0)-(k.target or 0))>0.001 then toggle.keybindpos()else toggle.paintgradient(toggle.keybindframe.gradient,toggle.hudstyle=="modern"and k.anim>0.01 and toggle.accentbars.keybinds,guiopacity*(k.anim or 0))end;local w=toggle.worldpanelstate;if themechanged or periodic or math.abs((w.anim or 0)-(w.target or 0))>0.001 then worldpos()else toggle.paintgradient(toggle.worldframe.gradient,toggle.hudstyle=="modern"and w.anim>0.01 and toggle.accentbars.world,guiopacity*(w.anim or 0))end;toggle.drawnotifications()
end
toggle.choosescrap=function(force)
    local now=toggle.frametime or tick();local state=toggle.scrapchoice or{};toggle.scrapchoice=state
    local current=state.rec;if not force and now<(state.next or 0)and state.sort==toggle.scrapteleport and current and current.active and current.object and current.object.Parent then return current,state.tier end
    if not force and state.sort=="random"and toggle.scrapteleport=="random"and current and current.active and current.object and current.object.Parent then state.next=now+0.25;return current,state.tier end
    state.next=now+0.25;state.sort=toggle.scrapteleport;local root=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart");local chosen,besttier,bestdistance,count=nil,0,math.huge,0
    if root then for i=1,#tracked do local rec=tracked[i];local tier=rec.active and tonumber(string.match(rec.cfgname or"","^Scrap(%d+)$"));local part=rec.object
        if tier and part and part.Parent then local meters=dist(root.Position,part.Position);count=count+1
            if not chosen or toggle.scrapteleport=="nearest"and meters<bestdistance or toggle.scrapteleport=="value"and(tier>besttier or tier==besttier and meters<bestdistance)or toggle.scrapteleport=="random"and math.random(count)==1 then chosen,besttier,bestdistance=rec,tier,meters end
        end
    end end;state.rec=chosen;state.tier=chosen and besttier or nil;return chosen,state.tier
end
local function tpscrap()
    local root=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart");if not root or not root:IsA("BasePart")then return false end
    local chosen=toggle.choosescrap(false);if not chosen or not chosen.object or not chosen.object.Parent then return false end;root.Position=chosen.object.Position;if toggle.scrapchoice then toggle.scrapchoice.rec=nil;toggle.scrapchoice.next=0 end;return true
end
local function tpflare()
    local char=lp.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart")then return false end
    for i=1,#tracked do
        local rec=tracked[i]
        if rec.cfgname=="FlareGunPickUp"then root.Position=rec.object.Position;return true end
    end
    return false
end
toggle.fireshopitem=function(action,name)
    if action=="PurchaseItem"then
        if name=="Map"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Map")elseif name=="Compass"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Compass")elseif name=="Watch"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Watch")elseif name=="Voltmeter"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Voltmeter")elseif name=="FirstAidKit"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","FirstAidKit")elseif name=="Vitamins"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Vitamins")elseif name=="Toolbox"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Toolbox")elseif name=="Tracker"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Tracker")elseif name=="RakeTrap"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","RakeTrap")elseif name=="Monitor"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Monitor")elseif name=="Vest"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","Vest")elseif name=="UV_Lamp"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","UV_Lamp")elseif name=="StunStick"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"PurchaseItem","StunStick")end
    elseif action=="SellItem"then
        if name=="Map"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Map")elseif name=="Compass"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Compass")elseif name=="Watch"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Watch")elseif name=="Voltmeter"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Voltmeter")elseif name=="FirstAidKit"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","FirstAidKit")elseif name=="Vitamins"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Vitamins")elseif name=="Toolbox"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Toolbox")elseif name=="Tracker"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Tracker")elseif name=="RakeTrap"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","RakeTrap")elseif name=="Monitor"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Monitor")elseif name=="Vest"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","Vest")elseif name=="UV_Lamp"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","UV_Lamp")elseif name=="StunStick"then return toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellItem","StunStick")end
    end
    return false
end
toggle.shopmarker=function()
    local cached=toggle.shop.part;if cached and cached.Parent and cached:IsA("BasePart")then return cached end
    for i=1,#tracked do local rec=tracked[i];if rec.cfgname=="ShopMSG"then local object=rec.object and rec.object.Parent and rec.object or rec.model and findclass(rec.model,"BasePart");if object and object:IsA("BasePart")then toggle.shop.part=object;return object end end end
    local object=finddesc(ws,"ShopMSG");for depth=1,64 do if not object or object==ws or object:IsA("BasePart")then break end;local parent=object.Parent;if parent==object then object=nil;break end;object=parent end;if object and object:IsA("BasePart")then toggle.shop.part=object;return object end
end
toggle.nearshop=function()
    local character=lp.Character;local root=character and character:FindFirstChild("HumanoidRootPart");local map=ws:FindFirstChild("Map");local shack=map and map:FindFirstChild("Shack");local shop=shack and shack:FindFirstChild("ShopPart");return root and root:IsA("BasePart")and shop and shop:IsA("BasePart")and dist(root.Position,shop.Position)<=2
end
toggle.applyautorecover=function(force)
    if not toggle.autorecover then return false end;local now=toggle.frametime or tick();if not force and now<(toggle.autorecovernext or 0)then return false end
    if not toggle.nearshop()then toggle.autorecovernext=now+0.25;return false end;local event=rs:FindFirstChild("ShopEvent");local folder=toggle.recoverfolder();if not event or not folder then toggle.autorecovernext=now+0.5;return false end
    local children=folder:GetChildren();local fired=false;for i=1,#children do local item=children[i];if item.Name~="ScrapAmount"and item.Name~="Timer"and item:IsA("BoolValue")then local ok=toggle.fireevent(event,"ClaimItem",item.Name);fired=ok or fired end end;toggle.recovervaluenext=0;toggle.autorecovernext=now+(fired and 0.12 or 0.3);return fired
end
toggle.setautorecover=function(value,quiet)
    toggle.autorecover=value==true;toggle.autorecovernext=0;toggle.recovervaluenext=0;if toggle.autorecover and not toggle.uibatch then toggle.applyautorecover(true)end;menuupdate();if not quiet then bindlog(toggle.autorecover and"enabled auto-recover items"or"disabled auto-recover items")end
end
toggle.applyautosellscrap=function(force)
    if not toggle.autosellscrap then return false end;local now=toggle.frametime or tick();if not force and now<(toggle.autosellnext or 0)then return false end;if not toggle.nearshop()then toggle.autosellnext=now+0.25;return false end
    local amount=toggle.scrapamount();local event=rs:FindFirstChild("ShopEvent");if amount<=0 or not event then toggle.autosellnext=now+0.1;return false end;toggle.autosellnext=now+0.08;local fired=false;for attempt=1,3 do local sent=toggle.fireevent(event,"SellScraps","Scraps");fired=sent or fired end;return fired
end
toggle.setautosellscrap=function(value,quiet)
    toggle.autosellscrap=value==true;toggle.autosellnext=0;if toggle.autosellscrap and not toggle.uibatch then toggle.applyautosellscrap(true)end;menuupdate();if not quiet then bindlog(toggle.autosellscrap and"enabled auto-sell scrap"or"disabled auto-sell scrap")end
end
toggle.applyautobuyitems=function(force)
    local selected=toggle.autobuyitems.selected;if not next(selected)then return false end;local now=toggle.frametime or tick();if not force and now<(toggle.autobuyitems.next or 0)then return false end;if not toggle.nearshop()then toggle.autobuyitems.next=now+0.25;return false end
    local owned=toggle.refreshinventory(true);local fired=false;for i=1,#toggle.shop.items do local item=toggle.shop.items[i];if selected[item.name]and not owned[item.name]then for attempt=1,3 do fired=toggle.fireshopitem("PurchaseItem",item.name)or fired end end end;toggle.autobuyitems.next=now+(fired and 0.08 or 0.2);return fired
end
toggle.applyautosellitems=function(force)
    local selected=toggle.autosellitems.selected;if not next(selected)then return false end;local now=toggle.frametime or tick();if not force and now<(toggle.autosellitems.next or 0)then return false end;if not toggle.nearshop()then toggle.autosellitems.next=now+0.25;return false end
    local owned=toggle.refreshinventory(true);local fired=false;for i=1,#toggle.shop.items do local item=toggle.shop.items[i];if selected[item.name]and owned[item.name]then for attempt=1,3 do fired=toggle.fireshopitem("SellItem",item.name)or fired end end end;toggle.autosellitems.next=now+(fired and 0.08 or 0.2);return fired
end
toggle.shopaction=function(action)
    toggle.refreshshop(true);local selected=toggle.shopitem();if action~="SellScraps"and not selected then return false,"empty"end
    if not toggle.cooldownready()then return false,"cooldown"end;local night=rs:FindFirstChild("Night");if night then local ok,value=pcall(function()return night.Value end);if ok and value==true then return false,"night"end end
    local character=lp.Character;local root=character and character:FindFirstChild("HumanoidRootPart");if not root or not root:IsA("BasePart")then return false,"character"end;local destination=toggle.shopmarker();if not destination then return false,"shop"end;if not rs:FindFirstChild("ShopEvent")then return false,"event"end
    local moved=pcall(function()root.CFrame=destination.CFrame+Vector3.new(0,3,0)end);if not moved then return false,"shop"end;toggle.startcooldown();toggle.wait(0.1);local fired=true
    for attempt=1,10 do if action=="SellScraps"then local ok=toggle.fireevent(rs:FindFirstChild("ShopEvent"),"SellScraps","Scraps");if not ok then fired=false end elseif not toggle.fireshopitem(action,selected.name)then fired=false end;if attempt<10 then toggle.wait(0.14/9)end end
    return fired,fired and nil or"event",action=="SellScraps"and 0 or 1
end
toggle.queueshopaction=function(action)
    if toggle.shopbusy then return false end;toggle.shopbusy=true
    toggle.spawn(function()
        local safe,ok,reason,count=pcall(toggle.shopaction,action);toggle.shopbusy=false
        local message;if not safe then message="shop action failed"elseif ok then if action=="SellScraps"then message="teleported to shop and sold scraps"else message=(action=="PurchaseItem"and"purchased "or"sold ")..tostring(count or 1).." selected item"end
        elseif reason=="empty"then message="select a shop item"elseif reason=="cooldown"then message="tp safe cooldown"elseif reason=="night"then message="shop actions are unavailable at night"else message="shop action failed"end;pcall(bindlog,message,"teleports")
    end);return true
end
toggle.applyautoradio=function(force)
    if not toggle.autoradio or toggle.hascrateitem("Radio")or toggle.hascrateitem("WalkieTalkie")then return false end;local now=toggle.frametime or tick();if not force and now<(toggle.autoradionext or 0)then return false end;local map=ws:FindFirstChild("Map");local safe=map and map:FindFirstChild("SafeHouse");local giver=safe and safe:FindFirstChild("Giver");local radio=giver and giver:FindFirstChild("WalkieTalkie");if radio and not radio:IsA("BasePart")then radio=radio:FindFirstChildWhichIsA("BasePart")end;local character=lp.Character;local root=character and character:FindFirstChild("HumanoidRootPart");local event=rs:FindFirstChild("WalkieEvent");if not radio or not radio:IsA("BasePart")or not root or not root:IsA("BasePart")or not event or dist(root.Position,radio.Position)>3 then return false end;toggle.autoradionext=now+0.08;return toggle.fireevent(event)
end
toggle.setautoradio=function(value,quiet)
    toggle.autoradio=value==true;toggle.autoradionext=0;if toggle.autoradio and not toggle.uibatch then toggle.applyautoradio(true)end;menuupdate();if not quiet then bindlog(toggle.autoradio and"enabled auto-take radio"or"disabled auto-take radio")end
end
local function setesp(value,quiet)
    toggle.esp=value==true
    if not toggle.esp then for i=1,#tracked do hiderec(tracked[i])end;for _,rec in pairs(toggle.playeresp.records)do toggle.hideplayerrecord(rec)end;rooflabel.Visible=false;roofhp.Visible=false;if toggle.rakepanel then toggle.hideplayerrecord(toggle.rakepanel)end;for _,entry in pairs(toggle.rakedraw)do entry.Visible=false end end
    menuupdate();if not quiet then bindlog(toggle.esp and "enabled esp"or"disabled esp")end
end
local function sethud(value,quiet)
    toggle.hud=value==true;hudpos();showhud();powerpos();toggle.keybindpos();worldpos();menuupdate();if not quiet then bindlog(toggle.hud and "enabled hud"or"disabled hud")end
end
toggle.setcontainerstyle=function(value,quiet)
    toggle.containerstyle=(value=="legacy"or value=="minimal")and"legacy"or"modern";hudpos();showhud();menuupdate();if not quiet then bindlog("container style set to "..toggle.containerstyle)end
end
toggle.setworldpanel=function(value,quiet)
    toggle.worldpanel=value==true;worldpos();menuupdate();if not quiet then bindlog(toggle.worldpanel and"enabled world panel"or"disabled world panel")end
end
toggle.setkeybindpanel=function(value,quiet)
    toggle.keybindpanel=value==true;toggle.keybindpos();menuupdate();if not quiet then bindlog(toggle.keybindpanel and"enabled keybind panel"or"disabled keybind panel")end
end
toggle.restoreidle=function()
    local state=toggle.idle;local root=state.root
    if root and state.original and state.moved then pcall(function()if root.Parent and lp.Character==state.character and (root.Position-state.moved.Position).Magnitude<0.2 then root.CFrame=state.original end end)end
    state.root=nil;state.original=nil;state.moved=nil;state.busy=false
end
toggle.applyidle=function()
    local state=toggle.idle;local now=toggle.frametime or tick();if not toggle.client.preventIdle or state.busy or now<state.nextsample then return end;state.nextsample=now+1
    local character=lp.Character;local root=character and character:FindFirstChild("HumanoidRootPart");if not root or not root.Parent or not root:IsA("BasePart")then state.lastactive=now;return end
    local position=root.Position;local mx,my=mouse.X,mouse.Y;local active=state.character~=character or not state.position or (position-state.position).Magnitude>0.1 or state.mx~=mx or state.my~=my
    if not active then for _,key in ipairs({0x57,0x41,0x53,0x44,0x20})do if iskeypressed(key)then active=true;break end end end
    state.character=character;state.position=position;state.mx=mx;state.my=my;if active then state.lastactive=now;return end;if now-state.lastactive<60 then return end;state.lastactive=now;state.busy=true
    toggle.spawn(function()
        if not toggle.running or not toggle.client.preventIdle or lp.Character~=character or not root.Parent then state.busy=false;return end
        local ok=pcall(function()state.root=root;state.original=root.CFrame;state.moved=state.original*CFrame.new(0,0,1);root.CFrame=state.moved end)
        if ok then toggle.wait(0.1)end;toggle.restoreidle();state.position=nil
    end)
end
toggle.doors={entries={},touched=setmetatable({},{__mode="k"}),nextresolve=0,nextapply=0}
toggle.restoredoors=function()
    local state=toggle.doors;for part,data in pairs(state.touched)do pcall(function()if part.Parent then local desired=data.original;if data.open and data.open.Parent then desired=data.open.Value~=true end;if part.CanCollide~=desired then part.CanCollide=desired end end end);state.touched[part]=nil end;state.entries={};state.nextresolve=0;state.nextapply=0
end
toggle.applydoors=function(force)
    if not toggle.client.doorNoCollide then return end;local state=toggle.doors;local now=tick();if not force and now<state.nextapply then return end;state.nextapply=now+0.1
    if force or now>=state.nextresolve then state.nextresolve=now+1;local map=ws:FindFirstChild("Map");local house=map and map:FindFirstChild("SafeHouse");local hd=house and house:FindFirstChild("Door");local tower=map and map:FindFirstChild("ObservationTower");local td=tower and tower:FindFirstChild("Door");local model=td and td:FindFirstChild("DoorModel");state.entries[1]={part=hd and hd:FindFirstChild("Door"),open=hd and hd:FindFirstChild("DoorOpen")};local towerpart=model and model:FindFirstChild("Door");local toweropen=td and td:FindFirstChild("DoorOpen");state.entries[2]={part=towerpart,open=toweropen};state.entries[3]={part=towerpart and towerpart:FindFirstChild("DoorHitbox"),open=toweropen}end
    for i=1,3 do local entry=state.entries[i];if entry then local part=entry.part;pcall(function()if part and part.Parent and part:IsA("BasePart")then local data=state.touched[part];if not data then data={original=part.CanCollide};state.touched[part]=data end;data.open=entry.open;if part.CanCollide then part.CanCollide=false end end end)end end
end
toggle.setclient=function(id,value,quiet)
    if toggle.client[id]==nil then return end;toggle.client[id]=value==true
    if id=="preventIdle"then toggle.restoreidle();toggle.idle.lastactive=tick();toggle.idle.nextsample=0
    elseif id=="doorNoCollide"then if toggle.client[id]then toggle.doors.nextresolve=0;toggle.doors.nextapply=0;toggle.applydoors(true)else toggle.restoredoors()end
    elseif id=="noFall"then toggle.applynofall(toggle.client[id],true)
    elseif id=="towerBarriers"then toggle.applytowerbarriers(toggle.client[id],true)
    elseif id=="antiCollide"then if toggle.client[id]then toggle.collisions.nextroster=0;toggle.collisions.nextapply=0;toggle.applycollisions(true)else toggle.restorecollisions()end
    elseif toggle.client[id]and(id=="noJumpCooldown"or id=="infiniteStamina")then toggle.clientgc.nextapply=0;if not toggle.uibatch then toggle.applyclient(not toggle.clientgc.valid)end
    elseif not toggle.clientneedsgc()then toggle.releaseclientgc()end
    menuupdate();if not quiet then bindlog((toggle.client[id]and"enabled "or"disabled ")..(toggle.clientlabels[id]or id))end
end
toggle.setkillaura=function(value,quiet)
    toggle.killaura=value==true;toggle.killauranext=0;toggle.aurastate.nextresolve=0;menuupdate();if not quiet then bindlog(toggle.killaura and"enabled stun aura"or"disabled stun aura")end
end
toggle.setkillaurarange=function(value,quiet)
    toggle.killaurarange=math.floor(clamp(tonumber(value)or toggle.killaurarange,6,30)+0.5);menuupdate();if not quiet then bindlog("stun aura range set to "..tostring(toggle.killaurarange).." studs")end
end
toggle.setkillauradelay=function(value,quiet)
    toggle.killauradelay=clamp(tonumber(value)or toggle.killauradelay,0.05,0.6);menuupdate();if not quiet then bindlog("stun aura delay set to "..string.format("%.2fs",toggle.killauradelay))end
end
toggle.findstunstick=function(parent)
    if not parent then return nil end;local direct=parent:FindFirstChild("StunStick");if direct and direct:IsA("Tool")then return direct end
    local children=parent:GetChildren();for i=1,math.min(#children,64)do local child=children[i];local name=string.lower(child.Name or"");if child:IsA("Tool")and(name=="stunstick"or string.find(name,"stun",1,true)and string.find(name,"stick",1,true))then return child end end
end
toggle.aurastate={nextresolve=0,busy=false,parts={}}
toggle.applykillaura=function(force)
    local state=toggle.aurastate;local now=tick();if not toggle.running or not toggle.killaura or state.busy or now<(toggle.killauranext or 0)then return false end
    toggle.killauranext=now+math.max(0.05,toggle.killauradelay);state.busy=true
    local ok,fired=pcall(function()
        local character=lp.Character or ws:FindFirstChild(lp.Name);local rake=ws:FindFirstChild("Rake");local root=character and character:FindFirstChild("HumanoidRootPart");local hum=character and character:FindFirstChildOfClass("Humanoid")
        if not character or not root or not root.Parent or not root:IsA("BasePart")or not hum or hum.Health<=0 or not rake or not rake.Parent then return false end
        local power=rs:FindFirstChild("StationPower");if power and power.Value~=true then return false end
        if state.character~=character or state.rake~=rake or now>=(state.nextresolve or 0)or not state.stick or not state.stick.Parent or not state.remote or not state.remote.Parent then
            state.character=character;state.rake=rake;state.nextresolve=now+0.25;state.stick=toggle.findstunstick(character);state.remote=nil;state.humanoid=rake:FindFirstChild("Monster")or rake:FindFirstChildOfClass("Humanoid");state.parts={}
            for i=1,#toggle.killpartnames do local part=rake:FindFirstChild(toggle.killpartnames[i]);if part and part:IsA("BasePart")then state.parts[#state.parts+1]=part end end
            if state.stick then local direct=state.stick:FindFirstChild("Event");if direct and direct:IsA("RemoteEvent")then state.remote=direct else
                local queue={state.stick};local cursor,examined=1,0;while cursor<=#queue and cursor<=24 and examined<128 and not state.remote do local children=queue[cursor]:GetChildren();for j=1,math.min(#children,128-examined)do local child=children[j];examined=examined+1;if child.Name=="Event"and child:IsA("RemoteEvent")then state.remote=child;break end;if #queue<24 then queue[#queue+1]=child end end;cursor=cursor+1 end
            end end
        end
        local stick,event=state.stick,state.remote;if not stick or not stick.Parent or stick.Parent~=character or not stick:IsA("Tool")or not event or not event.Parent or not event:IsA("RemoteEvent")or not state.humanoid or not state.humanoid.Parent or not state.humanoid:IsA("Humanoid")or state.humanoid.Health<=0 then return false end
        local origin=root.Position;local hit,nearest=nil,toggle.killaurarange^2;for i=1,#state.parts do local part=state.parts[i];if part and part.Parent==rake and part:IsA("BasePart")then local p=part.Position;local dx,dy,dz=p.X-origin.X,p.Y-origin.Y,p.Z-origin.Z;local square=dx*dx+dy*dy+dz*dz;if square==square and square<=nearest then nearest=square;hit=part end end end
        if not hit then return false end;if not toggle.fireevent(event,"S")then return false end
        if not toggle.running or not toggle.killaura or (lp.Character or ws:FindFirstChild(lp.Name))~=character or not stick.Parent or stick.Parent~=character or not hit.Parent or not event.Parent then return false end
        return toggle.fireevent(event,"H",hit)
    end)
    state.busy=false;if not ok then state.nextresolve=0;state.stick=nil;state.remote=nil;toggle.killauranext=now+0.3 end;return ok and fired==true
end
toggle.setautoheal=function(value,quiet)
    toggle.autoheal=value==true;toggle.autohealnext=0;menuupdate();if not quiet then bindlog(toggle.autoheal and"enabled auto-heal"or"disabled auto-heal")end
end
toggle.setautohealth=function(value,quiet)
    toggle.autohealth=math.floor(clamp(tonumber(value)or toggle.autohealth,20,70)+0.5);menuupdate();if not quiet then bindlog("auto-heal threshold set to "..tostring(toggle.autohealth).." hp")end
end
toggle.applyautoheal=function(force)
    if not toggle.autoheal then return false end;local now=toggle.frametime or tick();if not force and now<(toggle.autohealnext or 0)then return false end;toggle.autohealnext=now+0.08
    local character=lp.Character or ws:FindFirstChild(lp.Name);local humanoid=character and character:FindFirstChildOfClass("Humanoid");if not humanoid or humanoid.Health<=0 or humanoid.Health>toggle.autohealth then return false end
    local kit=character:FindFirstChild("FirstAidKit");local remote=kit and kit:FindFirstChild("RemoteEvent");if not kit or not kit:IsA("Tool")or not remote then return false end;local ok=toggle.fireevent(remote,"YourselfStart");if ok then toggle.autohealnext=now+0.25 end;return ok
end
toggle.setzoomamount=function(value,quiet)
    toggle.zoom.amount=clamp(tonumber(value)or toggle.zoom.amount,0.5,100);if toggle.zoom.thirdperson then toggle.zoom.min=toggle.zoom.amount;toggle.zoom.max=10000;toggle.zoom.nextapply=0;toggle.applyzoom(true)end;menuupdate();if not quiet then bindlog("zoom amount set to "..string.format("%.1f",toggle.zoom.amount).." studs")end
end
toggle.setthirdperson=function(value,quiet)
    toggle.zoom.thirdperson=value==true;toggle.zoom.min=toggle.zoom.thirdperson and toggle.zoom.amount or 0;toggle.zoom.max=toggle.zoom.thirdperson and 10000 or 0;toggle.zoom.nextapply=0;toggle.applyzoom(true);menuupdate();if not quiet then bindlog(toggle.zoom.thirdperson and"enabled third person"or"disabled third person")end
end
toggle.setshiftlock=function(value,quiet)
    local state=toggle.shiftlockstate;state.active=value==true;state.nextapply=0;if not state.offset then toggle.requestoffsets()end;local address=toggle.instanceaddress(lp);local applied=address and state.offset and toggle.memorywrite("byte",address+state.offset,state.active and 1 or 0)or false;menuupdate();if not quiet then bindlog(applied and(state.active and"enabled shift lock"or"disabled shift lock")or"shift lock offset unavailable")end;return applied
end
toggle.setinstacrate=function(value,quiet)
    toggle.instacrate=value==true;if toggle.instacrate then toggle.supplyitems=true else toggle.instacratestate.collectid=(toggle.instacratestate.collectid or 0)+1;toggle.instacratestate.active=nil;toggle.instacratestate.distance=math.huge;toggle.instacratestate.collecting=false;toggle.instacratestate.worker=false;toggle.instacratestate.request=nil;toggle.instacratestate.nextcollect=0;toggle.autocollect.enabled=false end;menuupdate();if not quiet then bindlog(toggle.instacrate and"enabled instant crate"or"disabled instant crate")end;return toggle.instacrate
end
toggle.sethudelement=function(id,value,quiet)
    if toggle.hudelements[id]==nil then return end;toggle.hudelements[id]=value==true;hudpos();showhud();menuupdate();if not quiet then bindlog((toggle.hudelements[id]and"enabled "or"disabled ")..id.." HUD")end
end
local function setbarrgb(value,quiet)
    toggle.barrgb=value==true;menuupdate();if not quiet then bindlog(toggle.barrgb and"enabled chroma accent"or"disabled chroma accent")end
end
local function setdistance(value,quiet)
    toggle.distance=value==true
    if not toggle.distance then for i=1,#tracked do hide(tracked[i].distance)end end
    menuupdate();if not quiet then bindlog(toggle.distance and "enabled distance label"or"disabled distance label")end
end
local function setgroup(id,value,quiet)
    espgroups[id]=value==true
    if id=="scraps"then for i=1,5 do espgroups.items["Scrap"..tostring(i)]=value==true end end
    if not espgroups[id]then for i=1,#tracked do local rec=tracked[i];if rec.cfg.group==id then hiderec(rec)end end;if id=="rake"then for _,entry in pairs(toggle.rakedraw)do entry.Visible=false end end end
    menuupdate();if not quiet then bindlog((espgroups[id]and"enabled "or"disabled ")..id)end
end
toggle.setitem=function(id,value,quiet)
    espgroups.items[id]=value==true
    if not espgroups.items[id]then for i=1,#tracked do if tracked[i].cfgname==id then hiderec(tracked[i])end end end
    menuupdate();if not quiet then local cfg=espcfg[id];bindlog((value and"enabled "or"disabled ")..(cfg and cfg.text or id))end
end
toggle.setroof=function(value,quiet)
    toggle.roof=value==true;if not toggle.roof then rooflabel.Visible=false;roofhp.Visible=false end
    menuupdate();if not quiet then bindlog(toggle.roof and"enabled roof HP"or"disabled roof HP")end
end
toggle.setrakename=function(value,quiet)
    toggle.rakename=true;menuupdate();if not quiet then bindlog(toggle.rakename and"enabled rake name"or"disabled rake name")end
end
toggle.setrakehealth=function(value,quiet)
    toggle.rakehealth=value==true;menuupdate();if not quiet then bindlog(toggle.rakehealth and"enabled rake health"or"disabled rake health")end
end
toggle.setrakedistance=function(value,quiet)
    toggle.rakedistance=value==true;if not toggle.rakedistance then toggle.rakedraw.distance.Visible=false end;menuupdate();if not quiet then bindlog(toggle.rakedistance and"enabled rake distance"or"disabled rake distance")end
end
toggle.setrakenamey=function(value,quiet)
    toggle.rakenamey=math.floor(clamp(tonumber(value)or toggle.rakenamey,-100,100)+0.5);menuupdate();if not quiet then bindlog("rake name Y offset set to "..tostring(toggle.rakenamey).."px")end
end
toggle.setunit=function(value,quiet)
    toggle.distanceunit="meters";menuupdate();if not quiet then bindlog("distance unit set to meters")end
end
toggle.setdistanceposition=function(value,quiet)
    toggle.distanceposition=value=="above"and"above"or"below";menuupdate();if not quiet then bindlog("distance label set "..toggle.distanceposition)end
end
toggle.setpoweractivity=function(value,quiet)
    toggle.poweractivity=value==true;powerhud();powerpos();menuupdate();if not quiet then bindlog(toggle.poweractivity and"enabled power activity"or"disabled power activity")end
end
toggle.setautopower=function(value,quiet)
    toggle.autopower=value==true;toggle.autopowernext=0;menuupdate();if not quiet then bindlog(toggle.autopower and"enabled auto-power station"or"disabled auto-power station")end
end
toggle.setautopowertoolbox=function(value,quiet)
    toggle.autopowerrequiretoolbox=value==true;toggle.autopowernext=0;menuupdate();if not quiet then bindlog(toggle.autopowerrequiretoolbox and"auto-power now requires a toolbox"or"auto-power no longer requires a toolbox")end
end
toggle.applyautopower=function(force)
    if not toggle.autopower or toggle.autopowerbusy then return false end;local now=tick();if now<(toggle.autopowernext or 0)then return false end
    toggle.autopowernext=now+0.75;toggle.autopowerbusy=true
    local success,result=pcall(function()
        local power=rs:FindFirstChild("StationPower");if not power or not power.Parent or not power:IsA("BoolValue")or power.Value~=false then return false end
        local character=lp.Character or ws:FindFirstChild(lp.Name);local root=character and character:FindFirstChild("HumanoidRootPart");local humanoid=character and character:FindFirstChildOfClass("Humanoid");if not character or not character.Parent or not root or not root.Parent or not root:IsA("BasePart")or not humanoid or humanoid.Health<=0 then return false end
        if toggle.autopowerrequiretoolbox then local toolbox=character:FindFirstChild("Toolbox");if not toolbox or not toolbox.Parent or not toolbox:IsA("Tool")then return false end end
        local map=ws:FindFirstChild("Map");local station=map and map:FindFirstChild("PowerStation");local folder=station and station:FindFirstChild("StationFolder");local part=folder and folder:FindFirstChild("StationGUIPart");local remote=folder and folder:FindFirstChild("RemoteEvent");if not part or not part.Parent or not part:IsA("BasePart")or not remote or not remote.Parent or not remote:IsA("RemoteEvent")then return false end
        local meters=dist(root.Position,part.Position);if meters~=meters or meters>4 then return false end
        return toggle.fireevent(remote,"StationStart",true)
    end)
    toggle.autopowerbusy=false;return success and result==true
end
toggle.setpoweractivitymode=function(value,quiet)
    toggle.poweractivitymode=value=="always"and"always"or"activity";powerpos();menuupdate();if not quiet then bindlog("activity panel set to "..toggle.poweractivitymode)end
end
toggle.setnotificationposition=function(value,quiet)
    local valid={['bottom left']=true,['bottom right']=true,['middle left']=true,['middle right']=true};toggle.notifysettings.position=valid[value]and value or"bottom right";menuupdate();if not quiet then bindlog("notification position set to "..toggle.notifysettings.position)end
end
toggle.setnotificationduration=function(value,quiet)
    toggle.notifysettings.duration=math.floor(clamp(tonumber(value)or toggle.notifysettings.duration,1,10)*2+0.5)/2;menuupdate();if not quiet then bindlog("notification time set to "..string.format("%.1fs",toggle.notifysettings.duration))end
end
toggle.setrakenotifydistance=function(value,quiet)
    toggle.notifysettings.rakedistance=math.floor(clamp(tonumber(value)or toggle.notifysettings.rakedistance,5,100)+0.5);menuupdate();if not quiet then bindlog("rake warning distance set to "..tostring(toggle.notifysettings.rakedistance).."m")end
end
toggle.setteleportcooldown=function(value,quiet)
    toggle.teleportcooldown=value==true;if not toggle.teleportcooldown then toggle.cooldownuntil=0;toggle.cooldownremaining=0;toggle.cooldowndraw.value.Visible=false;toggle.cooldowndraw.label.Visible=false end;hudpos();showhud();menuupdate();if not quiet then bindlog(toggle.teleportcooldown and"enabled tp safe cooldown"or"disabled tp safe cooldown")end
end
toggle.setcooldownseconds=function(value,quiet)
    toggle.cooldownseconds=math.floor(clamp(tonumber(value)or toggle.cooldownseconds,10,30)+0.5);menuupdate();if not quiet then bindlog("tp safe cooldown set to "..tostring(toggle.cooldownseconds).."s")end
end
toggle.cooldownready=function()
    return not toggle.teleportcooldown or tick()>=(toggle.cooldownuntil or 0)
end
toggle.startcooldown=function()
    if not toggle.teleportcooldown then return end;toggle.cooldownuntil=tick()+toggle.cooldownseconds;toggle.cooldownremaining=toggle.cooldownseconds;toggle.cooldowndraw.value.Text=tostring(toggle.cooldownseconds).."s";toggle.cooldowndraw.value.Visible=toggle.hud;toggle.cooldowndraw.label.Visible=toggle.hud;hudpos()
end
toggle.updatescraplabels=function()
    for i=1,5 do local cfg=espcfg["Scrap"..i];local elements=toggle.scrapelements["Scrap"..i]or{};if cfg then cfg.text="Scrap"..(elements.tiers and" "..i or"")..(elements.points and" [+"..toggle.scrapvalues[i].."p]"or"")end end
    for i=1,#tracked do local rec=tracked[i];if rec.cfg.group=="scraps"and rec.name then rec.name.Text=rec.cfg.text end end
end
toggle.setscrapstyle=function(value,quiet)
    toggle.scrapstyle=value=="points"and"points"or value=="tiers"and"tiers"or value=="both"and"both"or"default"
    for i=1,5 do toggle.scrapelements["Scrap"..i]={tiers=value=="tiers"or value=="both",points=value=="points"or value=="both"}end;toggle.updatescraplabels();menuupdate();if not quiet then bindlog("scrap display updated")end
end
toggle.setscrapteleport=function(value,quiet)
    toggle.scrapteleport=(value=="value"or value=="most value")and"value"or value=="nearest"and"nearest"or value=="random"and"random"or"value";menuupdate();if not quiet then bindlog("scrap teleport set to "..toggle.scrapteleport)end
end
toggle.setsupplylabel=function(value,quiet)
    toggle.supplylabel=value==true;if not toggle.supplylabel then for i=1,#tracked do local rec=tracked[i];if rec.cfg.crate then hide(rec.name);hide(rec.distance);hidering(rec)end end end;menuupdate();if not quiet then bindlog(toggle.supplylabel and"enabled supply label"or"disabled supply label")end
end
toggle.setsupplyitems=function(value,quiet)
    toggle.supplyitems=toggle.instacrate or value==true;menuupdate();if not quiet then bindlog(toggle.supplyitems and"enabled item viewer"or"disabled item viewer")end
end
toggle.setplayersesp=function(value,quiet)
    toggle.playeresp.enabled=true;toggle.refreshplayerselection();menuupdate()
end
toggle.setplayerdistance=function(value,quiet)
    toggle.playeresp.distance=math.floor(clamp(tonumber(value)or toggle.playeresp.distance,10,150)+0.5);menuupdate();if not quiet then bindlog("player ESP distance set to "..tostring(toggle.playeresp.distance).."m")end
end
toggle.refreshfonts=function()
    if toggle.uibatch then toggle.fontrefreshpending=true;menustate.itemsdirty=true;return end;toggle.fontrefreshpending=false
    for d,meta in pairs(toggle.textroles)do if not toggle.removeddraw[d]and not meta.preview then toggle.setprop(d,"Font",toggle.fontvalue(meta.role));toggle.setprop(d,"Size",meta.size or 13)end end
    toggle.fontmetrics.cache={};toggle.fontmetrics.order={};toggle.fontmetrics.cursor=0;local _,eh=toggle.measuretext("Ag",font,espfontsize);local _,hh=toggle.measuretext("Ag",toggle.fontvalue("hud"),espfontsize);toggle.esplineheight=math.max(espfontsize,eh);toggle.hudlineheight=math.max(espfontsize,hh);local _,mh=toggle.measuretext("Ag",toggle.fontvalue("hud"),13);toggle.menulineheight=math.max(13,mh)
    menustate.itemsdirty=true;toggle.playeresp.nextlayout=0;for _,rec in pairs(toggle.playeresp.records)do rec.layoutkey=nil end
    hudpos();powerpos();worldpos();toggle.keybindpos();menuupdate()
end
local function setfontindex(index,quiet)
    fontindex=clamp(math.floor(tonumber(index)or 1),1,#fontvalues);font=fontvalues[fontindex]
    for _,d in ipairs({rooflabel,roofhp,toggle.rakedraw.name,toggle.rakedraw.health,toggle.rakedraw.distance})do toggle.settextrole(d,"esp")end
    toggle.refreshfonts();if not quiet then bindlog("ESP font set to "..fontnames[fontindex])end
end
toggle.savedfontindex=function(name,index,schema)
    local aliases={ProggyClean="Proggy",Pixel="Pixelated",["SF Bold"]="San Francisco"};name=aliases[name]or name
    if type(name)=="string"then for i=1,#fontnames do if fontnames[i]==name then return i end end end
    if index==nil then return 1 end;index=math.floor(tonumber(index)or 1)
    if schema~=2 then return({2,1,1,5,4,3,6})[index]or 1 end
    return clamp(index,1,#fontnames)
end
toggle.sethudfont=function(index,quiet)
    toggle.hudfontindex=clamp(math.floor(tonumber(index)or 1),1,#fontvalues);toggle.refreshfonts();if not quiet then bindlog("HUD font set to "..fontnames[toggle.hudfontindex])end
end
toggle.setesptextoutline=function(value,quiet)
    toggle.esptextoutline=value==true;for _,text in ipairs({rooflabel,roofhp,toggle.rakedraw.name,toggle.rakedraw.health,toggle.rakedraw.distance})do toggle.applyespoutline(text,text.Transparency)end;for i=1,#tracked do local rec=tracked[i];if rec.name then toggle.applyespoutline(rec.name,rec.name.Transparency)end;if rec.distance then toggle.applyespoutline(rec.distance,rec.distance.Transparency)end;for _,text in pairs({rec.take,rec.takekey,rec.cratetitle})do toggle.setprop(text,"Outline",false)end;if rec.items then for j=1,#rec.items do toggle.setprop(rec.items[j],"Outline",false);if rec.status and rec.status[j]then toggle.setprop(rec.status[j],"Outline",false)end end end end;for _,rec in pairs(toggle.promptstate.records)do toggle.applyespoutline(rec.action,rec.action.Transparency);for i=1,#rec.texts do toggle.applyespoutline(rec.texts[i],rec.texts[i].Transparency)end end;menuupdate();if not quiet then bindlog(toggle.esptextoutline and"enabled ESP text outline"or"disabled ESP text outline")end
end
toggle.themepalette=function(selected)
    local target={};local shift=selected.name=="monochrome"and 0 or select(1,tohsv(selected.accent))
    local function shifted(cfg)if not cfg or not cfg.defaultcolor then return end;local h,s,v=tohsv(cfg.defaultcolor);target[cfg]=Color3.fromHSV((h+shift)%1,s,v)end
    for _,cfg in pairs(espcfg)do shifted(cfg)end;shifted(roofstyle);shifted(toggle.distancestyle);shifted(toggle.rakestyle);shifted(toggle.rakehealthstyle);for _,cfg in pairs(toggle.cratestyles)do shifted(cfg)end
    return target
end
toggle.startpalette=function(selected,quiet)
    local target=toggle.themepalette(selected);toggle.palettefrom={};toggle.palettetarget=target
    for cfg,value in pairs(target)do cfg.rgb=false;if quiet then cfg.labelcolor=value;if cfg.color~=nil then cfg.color=value end else toggle.palettefrom[cfg]=cfg.labelcolor end end
    if quiet then toggle.palettefrom=nil;toggle.palettetarget=nil end
end
local function setthemeindex(index,quiet)
    themeindex=((math.floor(index)-1)%#themes)+1;local selected=themes[themeindex];themes.accentstyle.rgb=false
    toggle.startpalette(selected,quiet)
    if quiet then themes.accentstyle.labelcolor=selected.accent;toggle.themestyles.background.labelcolor=selected.bg;toggle.themestyles.topbar.labelcolor=selected.top;toggle.themestyles.border.labelcolor=selected.select;toggle.themestyles.outline.labelcolor=selected.muted;toggle.themestyles.text.labelcolor=selected.text;toggle.themevisual.card=selected.card;toggle.themevisual.hover=selected.hover;toggle.themevisual.muted=selected.muted;toggle.themeanimating=false
    else toggle.themefrom={accent=themes.accentstyle.labelcolor,bg=toggle.themestyles.background.labelcolor,top=toggle.themestyles.topbar.labelcolor,select=toggle.themestyles.border.labelcolor,outline=toggle.themestyles.outline.labelcolor,text=toggle.themestyles.text.labelcolor,card=toggle.themevisual.card,hover=toggle.themevisual.hover,muted=toggle.themevisual.muted};toggle.themetarget=selected;toggle.themetransition=0;toggle.themeanimating=true end
    menuupdate();if not quiet then bindlog("preset set to "..selected.name)end
end
toggle.updatetheme=function()
    if not toggle.themeanimating or not toggle.themetarget or not toggle.themefrom then return false end
    local t=math.min(1,(toggle.themetransition or 0)+(toggle.framedt or 1/60)*3.2);toggle.themetransition=t;local amount=t*t*(3-2*t);local source,target=toggle.themefrom,toggle.themetarget
    themes.accentstyle.labelcolor=toggle.colormix(source.accent,target.accent,amount);toggle.themestyles.background.labelcolor=toggle.colormix(source.bg,target.bg,amount);toggle.themestyles.topbar.labelcolor=toggle.colormix(source.top,target.top,amount);toggle.themestyles.border.labelcolor=toggle.colormix(source.select,target.select,amount);toggle.themestyles.outline.labelcolor=toggle.colormix(source.outline,target.muted,amount);toggle.themestyles.text.labelcolor=toggle.colormix(source.text,target.text,amount);toggle.themevisual.card=toggle.colormix(source.card,target.card,amount);toggle.themevisual.hover=toggle.colormix(source.hover,target.hover,amount);toggle.themevisual.muted=toggle.colormix(source.muted,target.muted,amount)
    if toggle.palettefrom and toggle.palettetarget then for cfg,value in pairs(toggle.palettetarget)do cfg.labelcolor=toggle.colormix(toggle.palettefrom[cfg],value,amount);if cfg.color~=nil then cfg.color=cfg.labelcolor end end end
    if t>=1 then toggle.themeanimating=false;toggle.themefrom=nil;toggle.themetarget=nil;toggle.palettefrom=nil;toggle.palettetarget=nil end;return true
end
local function setfontsize(value,quiet)
    espfontsize=math.floor(clamp(tonumber(value)or espfontsize,13,20)+0.5);toggle.fontmetrics.cache={};toggle.fontmetrics.order={};toggle.fontmetrics.cursor=0;local _,eh=toggle.measuretext("Ag",font,espfontsize);local _,hh=toggle.measuretext("Ag",toggle.fontvalue("hud"),espfontsize);toggle.esplineheight=math.max(espfontsize,eh);toggle.hudlineheight=math.max(espfontsize,hh);local _,mh=toggle.measuretext("Ag",toggle.fontvalue("hud"),13);toggle.menulineheight=math.max(13,mh)
    toggle.setprop(rooflabel,"Size",espfontsize);toggle.setprop(roofhp,"Size",espfontsize);toggle.setprop(toggle.rakedraw.name,"Size",espfontsize);toggle.setprop(toggle.rakedraw.health,"Size",espfontsize);toggle.setprop(toggle.rakedraw.distance,"Size",espfontsize);for i=1,#tracked do if tracked[i].name then toggle.setprop(tracked[i].name,"Size",espfontsize) end;if tracked[i].distance then toggle.setprop(tracked[i].distance,"Size",espfontsize) end end
    for _,d in ipairs({timertxt,scraptxt,targettxt,timerlabel,scraplabel,targetlabel,toggle.powerdraw.value,toggle.powerdraw.label,powerlabel,toggle.powerempty,toggle.worldtitle,toggle.keybindtitle})do toggle.setprop(d,"Size",espfontsize) end
    for _,list in ipairs({powerlines,toggle.powervalues,toggle.worldlines,toggle.worldvalues,toggle.keybindlines,toggle.keybindvalues})do for i=1,#list do toggle.setprop(list[i],"Size",espfontsize) end end
    menustate.itemsdirty=true;menuupdate();if not quiet then bindlog("text size set to "..tostring(espfontsize))end
end
local function setguiopacity(value,quiet)
    guiopacity=clamp(tonumber(value)or guiopacity,0.5,1);menuupdate();if not quiet then bindlog("GUI opacity set to "..tostring(math.floor(guiopacity*100+0.5)).."%")end
end
toggle.setborderradius=function(value,quiet)
    toggle.borderradius=math.floor(clamp(tonumber(value)or toggle.borderradius,0,10)+0.5);toggle.applyradius();menupos();hudpos();powerpos();menuupdate();if not quiet then bindlog("border radius set to "..tostring(toggle.borderradius).."px")end
end
toggle.refreshvisualui=function()if menustate.tab==2 then menustate.itemsdirty=true end end
toggle.visualmenuopen=function()return toggle.menu and not menustate.minimized and menustate.tab==2 end
toggle.resetterrain=function()
    toggle.restoreterrain();local state=toggle.visuals;state.water.edited=false;state.water.rgb=false;state.lengthedited=false;state.nextapply=0
end
toggle.resetposteffects=function()
    local state=toggle.visuals;for _,entry in ipairs(toggle.posteffectorder)do toggle.seteffect(entry.class,false);entry.captured=false;entry.edited={};for _,field in ipairs(entry.fields)do entry.values[field.key]=field.default end end
    for _,rec in pairs(state.records)do toggle.restoreeffect(rec)end;state.records={};state.correction.edited=false;state.correction.rgb=false
    state.nextscan=0;state.discovered=false;toggle.visualchanged()
end
toggle.loadvisualconfig=function(data)
    toggle.resetterrain();toggle.resetposteffects();if type(data)~="table"then return end;local state=toggle.visuals
    for _,id in ipairs({"water","correction"})do local saved=data[id];if type(saved)=="table"and toggle.visualfinite(saved.r,0,255)and toggle.visualfinite(saved.g,0,255)and toggle.visualfinite(saved.b,0,255)then local cfg=state[id];cfg.labelcolor=Color3.fromRGB(saved.r,saved.g,saved.b);cfg.rgb=saved.rgb==true;cfg.edited=true end end
    if toggle.visualfinite(data.grass_length,-1,1)then state.grasslength=clamp(data.grass_length,-0.5,1);state.lengthedited=true end
    if data.schema==2 and type(data.effect_controls)=="table"then for _,entry in ipairs(toggle.posteffectorder)do local saved=data.effect_controls[entry.class];if type(saved)=="table"then state.effects[entry.class]=saved.enabled==true;if type(saved.values)=="table"then for _,field in ipairs(entry.fields)do local value=saved.values[field.key];if toggle.visualfinite(value,field.min,field.max)or field.uimin and toggle.visualfinite(value,-10000,10000)then entry.values[field.key]=clamp(value,field.min,field.max);entry.edited[field.key]=true end end end end end end
    toggle.visualchanged()
end
local function setlabelcolor(index,value,fast)
    if index=="terrainwater"or index=="correctiontint"then local cfg=entrycfg(index);cfg.edited=true;toggle.visualchanged()end
    if type(index)=="string"then local cfg=entrycfg(index);if cfg then cfg.labelcolor=value end;if index=="themetext"then for _,style in pairs(toggle.hudstyles)do style.labelcolor=value end;for _,style in pairs(toggle.hudvalues)do style.labelcolor=value end;toggle.cooldownstyle.labelcolor=value;toggle.cooldownvaluestyle.labelcolor=value end;menuupdate(fast==true);return end
    local entry=colorentries[index];if not entry then return end
    for i=1,#entry.cfgs do local cfg=espcfg[entry.cfgs[i]];if cfg then cfg.labelcolor=value;cfg.color=value end end
    menuupdate(fast==true)
end
local function setlabelrgb(index,value,quiet)
    if index=="accent"then return end
    if type(index)=="string"then local cfg=entrycfg(index);if cfg then cfg.rgb=value==true;if index=="terrainwater"or index=="correctiontint"then cfg.edited=true;toggle.visualchanged()end end;menuupdate();if not quiet then bindlog((value and"enabled "or"disabled ").."chroma color")end;return end
    local entry=colorentries[index];if not entry then return end
    for i=1,#entry.cfgs do local cfg=espcfg[entry.cfgs[i]];if cfg then cfg.rgb=value==true end end
    menuupdate();if not quiet then bindlog((value and"enabled "or"disabled ").."chroma for "..entry.name)end
end
toggle.applypickerhex=function(quiet)
    local value=string.upper(string.gsub(tostring(picker.hexvalue or""),"[^%x]",""))
    if #value~=6 then if not quiet then bindlog("enter a 6-digit hex color")end;return false end
    local ok,result=pcall(function()return Color3.fromHex("#"..value)end)
    if not ok or not result then if not quiet then bindlog("invalid hex color")end;return false end
    picker.hexvalue=value;setlabelcolor(pickerentry,result);return true
end
local function setringsegments(value,quiet)
    local nextvalue=64
    if nextvalue~=ringseg then
        ringseg=nextvalue
        for i=1,#tracked do local rec=tracked[i];if rec.ring then for j=1,#rec.ring do remove(rec.ring[j])end;rec.ring=nil end end
    end
    menuupdate();if not quiet then bindlog("ring segments set to "..tostring(ringseg))end
end
toggle.setringenabled=function(value,quiet)
    toggle.ringenabled=value==true;if not toggle.ringenabled then for i=1,#tracked do hidering(tracked[i])end end;menuupdate();if not quiet then bindlog(toggle.ringenabled and"enabled rings"or"disabled rings")end
end
toggle.setringshape=function(value,quiet)
    toggle.ringshape=value=="square"and"square"or value=="triangle"and"triangle"or value=="hexagon"and"hexagon"or"circle";menuupdate();if not quiet then bindlog("ring shape set to "..toggle.ringshape)end
end
toggle.setringfade=function(value,quiet)
    ringfade=math.floor(clamp(tonumber(value)or ringfade,10,150)+0.5);menuupdate();if not quiet then bindlog("ring distance updated")end
end
toggle.setringopacity=function(value,quiet)
    toggle.ringopacity=clamp(tonumber(value)or toggle.ringopacity,0.1,1);menuupdate();if not quiet then bindlog("ring opacity set to "..tostring(math.floor(toggle.ringopacity*100+0.5)).."%")end
end
toggle.setringsize=function(value,quiet)
    toggle.ringsize=clamp(tonumber(value)or toggle.ringsize,0.5,3);menuupdate();if not quiet then bindlog("ring size set to "..string.format("%.1fx",toggle.ringsize))end
end
toggle.setringspin=function(value,quiet)
    toggle.ringspin=value==true;menuupdate();if not quiet then bindlog(toggle.ringspin and"enabled ring spin"or"disabled ring spin")end
end
toggle.setringspinspeed=function(value,quiet)
    toggle.ringspinspeed=clamp(tonumber(value)or toggle.ringspinspeed,0.1,3);menuupdate();if not quiet then bindlog("ring spin speed updated")end
end
toggle.setrgbdirection=function(value,quiet)
    toggle.rgbdirection=value=="left"and"left"or"right";menuupdate();if not quiet then bindlog("accent direction set to "..toggle.rgbdirection)end
end
toggle.setrgbspeed=function(value,quiet)
    rgbspeed=clamp(tonumber(value)or rgbspeed,0.5,2);menuupdate();if not quiet then bindlog("accent bar speed updated")end
end
toggle.setchromasaturation=function(value,quiet)
    toggle.chromasaturation=math.floor(clamp(tonumber(value)or toggle.chromasaturation,0.2,1)*100+0.5)/100;toggle.rgbbaseframe=nil;if toggle.gradientcache then toggle.gradientcache.frame=toggle.gradientcache.frame+1 end;menuupdate();if not quiet then bindlog("chroma saturation updated")end
end
toggle.setchromaspeed=function(value,quiet)
    toggle.chromaspeed=clamp(tonumber(value)or toggle.chromaspeed,0.5,2);toggle.rgbbaseframe=nil;menuupdate();if not quiet then bindlog("chroma speed updated")end
end
local function setbind(id,code)
    if(id=="crate"or id=="menu")and code==0 then capture=nil;menuupdate();bindlog(id=="crate"and"take item bind is required"or"menu toggle bind is required");return end
    if code==0 then keybinds[id]=0;capture=nil;menuupdate();bindlog(string.lower(bindlabels[id]).." bind removed");return end
    if not keynames[code]then return end
    for i=1,#bindorder do local other=bindorder[i];if other~=id and keybinds[other]==code and not(id=="prompt"and other=="crate"or id=="crate"and other=="prompt")then capture=nil;menuupdate();bindlog("key already in use");return end end
    keybinds[id]=code;capture=nil;menuupdate();bindlog(string.lower(bindlabels[id]).." bound to "..keynames[code])
end
toggle.cleanrakename=function(value)
    local cleaned=tostring(value or"");cleaned=string.gsub(cleaned,"[^%w _%-]","");cleaned=string.gsub(cleaned,"^%s+","");cleaned=string.gsub(cleaned,"%s+$","");cleaned=string.gsub(cleaned,"%s+"," ");if cleaned==""then cleaned="rake"end;return string.sub(cleaned,1,20)
end
toggle.finishrakename=function(cancel)
    toggle.rakenamevalue=cancel and(toggle.rakenamebackup or"rake")or toggle.cleanrakename(toggle.rakenamevalue);toggle.rakenamecapture=false;toggle.rakedraw.name.Text=toggle.rakenamevalue;menuupdate()
end
toggle.cleanconfig=function(value)
    local cleaned=string.lower(tostring(value or""));cleaned=string.gsub(cleaned,"[^%w _%-]","");cleaned=string.gsub(cleaned,"^%s+","");cleaned=string.gsub(cleaned,"%s+$","");cleaned=string.gsub(cleaned,"%s+"," ");if cleaned==""then cleaned="default"end;return string.sub(cleaned,1,18)
end
toggle.lastconfigpath="therakesaint/autoload.txt"
toggle.readlastconfig=function()
    local ok,value=pcall(function()if isfile(toggle.lastconfigpath)then return readfile(toggle.lastconfigpath)end end)
    if ok and type(value)=="string"and value~=""then return toggle.cleanconfig(value)end;return"default"
end
toggle.writelastconfig=function(value)
    pcall(function()makefolder("therakesaint");writefile(toggle.lastconfigpath,toggle.cleanconfig(value))end)
end
toggle.refreshconfigs=function(selected)
    pcall(function()makefolder("therakesaint")end);local names={"default"};local seen={default=true};local ok,files=pcall(function()return listfiles("therakesaint")end)
    if ok and type(files)=="table"then for i=1,#files do local name=string.match(files[i],"([^/\\]+)%.json$");if name and not seen[name]then seen[name]=true;names[#names+1]=name end end end
    table.sort(names);configslots=names;local wanted=toggle.cleanconfig(selected or configname);configslot=0;for i=1,#configslots do if configslots[i]==wanted then configslot=i;break end end;configname=wanted
end
toggle.finishconfiginput=function(cancel)
    configname=cancel and(toggle.configbackup or"default")or toggle.cleanconfig(configname);configcapture=false;configslot=0;for i=1,#configslots do if configslots[i]==configname then configslot=i;break end end;menuupdate()
end
local function configpath()return "therakesaint/"..toggle.cleanconfig(configname)..".json" end
local function configdata()
    local colors={};local accent=themes.accentstyle.labelcolor;local special={};local themecolors={};local crateitemcolors={}
    for i=1,#colorentries do local cfg=entrycfg(i);local c=cfg.labelcolor;colors[i]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for _,id in ipairs({"distance","rake","rakehealth","roof","hudtimer","hudtarget","hudscrap","hudpower","cooldownlabel","cooldownvalue","valuetimer","valuetarget","valuescrap","valuepower"})do local cfg=entrycfg(id);local c=cfg.labelcolor;special[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for _,id in ipairs({"themebg","themetop","themeborder","themeoutline","themetext"})do local cfg=entrycfg(id);local c=cfg.labelcolor;themecolors[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B)}end
    themecolors.border_radius=toggle.borderradius
    for id,cfg in pairs(toggle.cratestyles)do local c=cfg.labelcolor;crateitemcolors[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    return {custom_visuals=toggle.visualconfig(),tracer_opacity=toggle.tracers.opacity,tracer_speed=toggle.tracers.speed,show_tracers=toggle.tracers.selected,nametag_defaults_version=2,interface_design_schema=1,crate_label_version=2,menu_default_version=5,gui_outline_default_version=3,hud_style_default_version=4,font=fontindex,esp_font=fontindex,hud_font=toggle.hudfontindex,font_schema=2,esp_font_name=fontnames[fontindex],hud_font_name=fontnames[toggle.hudfontindex],font_size=espfontsize,preset=themeindex,preset_schema=4,theme_schema=6,rgb_defaults_schema=2,preset_name=themes[themeindex].name,accent={r=channel(accent.R),g=channel(accent.G),b=channel(accent.B)},theme_colors=themecolors,gui_opacity=guiopacity,esp_text_outline=toggle.esptextoutline,watermark=toggle.watermark,hybrid_mode=true,hybrid_features=toggle.hybridfeatures,unsafe_luau=true,client=toggle.client,auto_radio=toggle.autoradio,auto_recover=toggle.autorecover,auto_buy_items=toggle.autobuyitems.selected,auto_sell_scrap=toggle.autosellscrap,auto_sell_items=toggle.autosellitems.selected,action_toggles={sell=toggle.sellenabled,scrap=toggle.scrapteleportenabled,flare=toggle.flareteleportenabled},shop_item=toggle.shop.selected,kill_aura=toggle.killaura,kill_aura_range=toggle.killaurarange,kill_aura_delay=toggle.killauradelay,auto_heal=toggle.autoheal,auto_heal_health=toggle.autohealth,auto_power=toggle.autopower,auto_power_require_toolbox=toggle.autopowerrequiretoolbox,player_esp=true,player_stacking=toggle.playeresp.stacking,player_stacking_defaults_schema=1,player_layout_schema=3,player_item_defaults_schema=2,player_health_coloring=toggle.playeresp.healthcoloring,rake_health_coloring=toggle.rakehealthcoloring,player_show_username=toggle.playeresp.showusername,player_show_health=toggle.playeresp.showhealth,player_show_distance=toggle.playeresp.showdistance,player_show_background=toggle.playeresp.background,player_esp_style=toggle.playeresp.style,rake_esp_style=toggle.rakeespstyle,rake_status=toggle.rakestatus,rake_render_distance=toggle.rakerenderdistance,player_esp_distance=toggle.playeresp.distance,player_esp_items=toggle.playeresp.selected,third_person=toggle.zoom.thirdperson,zoom_amount=toggle.zoom.amount,shift_lock=toggle.shiftlockstate.active,insta_crate=toggle.instacrate,auto_collect={enabled=toggle.autocollect.enabled,selected=toggle.autocollect.selected},prompts=toggle.promptsettings,container_style=toggle.containerstyle,widget_group={x=toggle.widgetgroup.x,y=toggle.widgetgroup.y,dragged=toggle.widgetgroup.dragged},distance_minimum=toggle.distanceminimum,distance_min=toggle.distancemin,ring_enabled=toggle.ringenabled,ring_shape=toggle.ringshape,ring_segments=ringseg,ring_fade=ringfade,ring_opacity=toggle.ringopacity,ring_size=toggle.ringsize,ring_spin=toggle.ringspin,ring_spin_speed=toggle.ringspinspeed,esp=toggle.esp,hud=toggle.hud,hud_elements=toggle.hudelements,power_activity=toggle.poweractivity,power_activity_mode=toggle.poweractivitymode,power_panel={x=toggle.powerpanel.x,y=toggle.powerpanel.y,dragged=toggle.powerpanel.dragged},keybind_panel={enabled=toggle.keybindpanel,x=toggle.keybindpanelstate.x,y=toggle.keybindpanelstate.y,dragged=toggle.keybindpanelstate.dragged},world_panel={enabled=toggle.worldpanel,x=toggle.worldpanelstate.x,y=toggle.worldpanelstate.y,dragged=toggle.worldpanelstate.dragged,items=toggle.worldpanelitems},roof_hp=toggle.roof,rake_name_enabled=toggle.rakename,rake_health_enabled=toggle.rakehealth,rake_distance_enabled=toggle.rakedistance,rake_name=toggle.rakenamevalue,rake_name_y=toggle.rakenamey,bar_rgb=toggle.barrgb,accent_bars=toggle.accentbars,accent_direction=toggle.rgbdirection,accent_speed=rgbspeed,accent_bar_speed=rgbspeed,chroma_saturation=toggle.chromasaturation,chroma_speed=toggle.chromaspeed,rgb_direction=toggle.rgbdirection,rgb_speed=rgbspeed,power_format="percent",power_decimal=toggle.powerdecimal,teleport_cooldown=toggle.teleportcooldown,teleport_cooldown_seconds=toggle.cooldownseconds,notifications={position=toggle.notifysettings.position,duration=toggle.notifysettings.duration,rakedistance=toggle.notifysettings.rakedistance,types=toggle.notifysettings.types},distance=toggle.distance,distance_position=toggle.distanceposition,scrap_style=toggle.scrapstyle,scrap_elements=toggle.scrapelements,scrap_edit=toggle.scrapedit,location_edit=toggle.locationedit,scrap_teleport=toggle.scrapteleport,supply_label=toggle.supplylabel,supply_items=toggle.supplyitems,esp_groups=espgroups,esp_items=espgroups.items,colors=colors,special_colors=special,crate_item_colors=crateitemcolors,binds=keybinds,menu={x=menustate.x,y=menustate.y,height=menustate.h,minimized=menustate.minimized}}
end
toggle.configsnapshot=function(value,ancestors)
    local kind=type(value);if kind=="boolean"or kind=="string"then return value elseif kind=="number"then return value==value and math.abs(value)~=math.huge and value or nil elseif kind~="table"then return nil end
    ancestors=ancestors or{};if ancestors[value]then return nil end;ancestors[value]=true;local out={};local n,count,array=#value,0,true;for key in pairs(value)do count=count+1;if type(key)~="number"or key%1~=0 or key<1 or key>n then array=false end end;array=array and count==n
    for key,item in pairs(value)do local copy=toggle.configsnapshot(item,ancestors);if copy~=nil then out[array and key or tostring(key)]=copy end end;ancestors[value]=nil;return out
end
toggle.readconfigdata=function(path)
    local ok,data=pcall(function()if not isfile(path)then return nil end;local raw=readfile(path);if type(raw)~="string"or raw==""then return nil end;return http:JSONDecode(raw)end);return ok and type(data)=="table"and data or nil
end
toggle.writeconfigdata=function(path,data)
    local ok,payload=pcall(function()return http:JSONEncode(toggle.configsnapshot(data))end);if not ok or type(payload)~="string"or payload==""then toggle.configsaveerror="encode";return false end
    pcall(makefolder,"therakesaint");local previous=nil;local readok,raw=pcall(readfile,path);if readok and type(raw)=="string"and toggle.readconfigdata(path)then previous=raw;pcall(writefile,path..".backup.cfg",raw)end
    for attempt=1,3 do local wrote=pcall(writefile,path,payload);if wrote then local verified,stored=pcall(readfile,path);if verified and stored==payload then toggle.configsaveerror=nil;return true end end end
    if previous then pcall(writefile,path,previous)end;toggle.configsaveerror="write verification";return false
end
local function saveconfig()
    configname=toggle.cleanconfig(configname);configcapture=false;local ok,saved=pcall(function()local data=configdata();data.menu_widgets={closed=menustate.widgetclosed};return toggle.writeconfigdata(configpath(),data)end);ok=ok and saved==true
    if ok then toggle.writelastconfig(configname);toggle.refreshconfigs(configname);menuupdate()end;bindlog(ok and"saved "..configname or"failed to save config: "..tostring(toggle.configsaveerror or"snapshot"));return ok
end
local function loadconfig(quiet)
    menustate.resizeheighttarget=nil;local data=toggle.readconfigdata(configpath());local backup=false;if not data then data=toggle.readconfigdata(configpath()..".backup.cfg");backup=data~=nil end
    if not data then if not quiet then bindlog("no readable saved config")end;return false end
    toggle.uibatch=true
    if type(data.menu_widgets)=="table"and type(data.menu_widgets.closed)=="table"then menustate.widgetclosed={};for key,closed in pairs(data.menu_widgets.closed)do local tab=tonumber(key);if tab and type(closed)=="table"then menustate.widgetclosed[tab]=closed end end;menustate.itemsdirty=true end
    toggle.hybridmode=true;toggle.unsafeluau=true;toggle.hybridfeatures=data.hybrid_features==true
    setfontindex(toggle.savedfontindex(data.esp_font_name,data.esp_font or data.font,data.font_schema),true);toggle.sethudfont(toggle.savedfontindex(data.hud_font_name,data.hud_font,data.font_schema),true)
    if type(data.font_size)=="number"then setfontsize(data.font_size,true)end
    local savedpreset=data.preset or data.theme;local removedlight,removedgabe=false,false
    if(data.preset_schema==nil or data.preset_schema==1)and type(savedpreset)=="number"then removedlight=savedpreset==2 or savedpreset==6 or savedpreset==10;savedpreset=({1,1,2,3,4,4,5,6,7,7,8,9})[math.floor(savedpreset)]or 5 end
    if data.preset_schema==3 and type(savedpreset)=="number"then if savedpreset==10 then savedpreset=5;removedgabe=true elseif savedpreset>10 then savedpreset=savedpreset-1 end end
    if type(data.preset_name)=="string"then local wanted=({["catppuccin mocha"]="amethyst",dracula="blood moon",["tokyo night"]="midnight",["gruvbox dark"]="ember",nord="glacier",["solarized dark"]="deep sea",["one dark"]="graphite",["rose pine"]="rose noir",gabescripts="signal bruise",gamesense="signal bruise"})[data.preset_name]or data.preset_name;if data.preset_name=="gabescripts"or data.preset_name=="gamesense"then removedgabe=true end;for i=1,#themes do if themes[i].name==wanted then savedpreset=i;break end end end
    if type(savedpreset)=="number"then setthemeindex(clamp(savedpreset,1,#themes),true)end
    if themes[themeindex].name=="monochrome"and(data.theme_schema or 0)<6 then
        local previous={accent="#9EE2FF",themebg="#171A21",themetop="#14171D",themeborder="#3D4552",themeoutline="#8691A2",themetext="#E9EDF4"}
        for id,hex in pairs(previous)do local saved=id=="accent"and data.accent or type(data.theme_colors)=="table"and data.theme_colors[id];local old=Color3.fromHex(hex);if type(saved)=="table"and saved.r==math.floor(old.R*255+0.5)and saved.g==math.floor(old.G*255+0.5)and saved.b==math.floor(old.B*255+0.5)then if id=="accent"then data.accent=nil else data.theme_colors[id]=nil end end end
    end
    local legacygamesense=((data.theme_schema==nil or data.theme_schema==1)and savedpreset==5)or removedgabe
    if not removedlight and not legacygamesense and type(data.accent)=="table"and type(data.accent.r)=="number"and type(data.accent.g)=="number"and type(data.accent.b)=="number"then setlabelcolor("accent",Color3.fromRGB(clamp(data.accent.r,0,255),clamp(data.accent.g,0,255),clamp(data.accent.b,0,255)))end
    if not removedlight and not legacygamesense and type(data.theme_colors)=="table"then for _,id in ipairs({"themebg","themetop","themeborder","themeoutline","themetext"})do local saved=data.theme_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)))end end end
    toggle.targetnight=false;toggle.hudlabels=true;toggle.distanceminimum=true
    local savedjump=false;if type(data.client)=="table"and type(data.client.noJumpCooldown)=="boolean"then savedjump=data.client.noJumpCooldown elseif type(data.noJumpCooldown)=="boolean"then savedjump=data.noJumpCooldown end;toggle.setclient("noJumpCooldown",savedjump,true)
    local savedstamina=false;if type(data.client)=="table"and type(data.client.infiniteStamina)=="boolean"then savedstamina=data.client.infiniteStamina elseif type(data.infiniteStamina)=="boolean"then savedstamina=data.infiniteStamina end;toggle.setclient("infiniteStamina",savedstamina,true)
    toggle.tracers.opacity=clamp(tonumber(data.tracer_opacity)or 0.8,0.1,1);toggle.tracers.speed=clamp(tonumber(data.tracer_speed)or 1,0.5,2);toggle.tracers.selected={};if type(data.show_tracers)=="table"then for _,kind in ipairs(toggle.tracers.order)do if data.show_tracers[kind]==true then toggle.tracers.selected[kind]=true end end end
    toggle.loadvisualconfig(data.custom_visuals)
    local savedfall=false;if type(data.client)=="table"and type(data.client.noFall)=="boolean"then savedfall=data.client.noFall elseif type(data.noFall)=="boolean"then savedfall=data.noFall end;toggle.setclient("noFall",savedfall,true);toggle.setclient("antiCollide",type(data.client)=="table"and data.client.antiCollide==true,true);toggle.setclient("doorNoCollide",type(data.client)=="table"and data.client.doorNoCollide==true,true);toggle.setclient("preventIdle",type(data.client)=="table"and data.client.preventIdle==true,true);local savedbarriers=type(data.client)=="table"and data.client.towerBarriers==true;toggle.setclient("towerBarriers",savedbarriers,true);toggle.setautoradio(data.auto_radio==true,true);toggle.setautorecover(data.auto_recover==true,true);toggle.setautosellscrap(data.auto_sell_scrap==true,true)
    toggle.sellenabled=true;toggle.scrapteleportenabled=true;toggle.flareteleportenabled=true
    toggle.refreshshop(true);toggle.shop.selected=type(data.shop_item)=="string"and toggle.shop.lookup[data.shop_item]and toggle.shop.lookup[data.shop_item].name or"RakeTrap";toggle.autobuyitems.selected={};toggle.autosellitems.selected={};if type(data.auto_buy_items)=="table"then for i=1,#toggle.shop.items do local name=toggle.shop.items[i].name;if data.auto_buy_items[name]==true then toggle.autobuyitems.selected[name]=true end end end;if type(data.auto_sell_items)=="table"then for i=1,#toggle.shop.items do local name=toggle.shop.items[i].name;if data.auto_sell_items[name]==true then toggle.autosellitems.selected[name]=true end end end;toggle.autobuyitems.next=0;toggle.autosellitems.next=0
    toggle.setkillaurarange(type(data.kill_aura_range)=="number"and data.kill_aura_range or 16,true);toggle.setkillauradelay(type(data.kill_aura_delay)=="number"and data.kill_aura_delay or 0.05,true);toggle.setkillaura(data.kill_aura==true,true);toggle.setautohealth(type(data.auto_heal_health)=="number"and data.auto_heal_health or 50,true);toggle.setautoheal(data.auto_heal==true,true);toggle.setautopower(data.auto_power==true,true);toggle.setautopowertoolbox(data.auto_power_require_toolbox~=false,true)
    toggle.playeresp.selected={};if type(data.player_esp_items)=="table"then for i=1,#toggle.playeresp.order do local name=toggle.playeresp.order[i].name;if data.player_esp_items[name]==true then toggle.playeresp.selected[name]=true end end else toggle.playeresp.selected.FlareGun=true;toggle.playeresp.selected.StunStick=true;toggle.playeresp.selected.UV_Lamp=true;toggle.playeresp.selected.FirstAidKit=true;toggle.playeresp.selected.Vest=true end;if data.player_item_defaults_schema~=2 then toggle.playeresp.selected.FirstAidKit=true;toggle.playeresp.selected.Vest=true end;toggle.playeresp.stacking=data.player_stacking_defaults_schema~=1 or data.player_stacking~=false;toggle.playeresp.nextlayout=0;toggle.playeresp.showusername=data.player_show_username~=false;toggle.playeresp.showhealth=data.player_show_health~=false;toggle.playeresp.healthcoloring=data.player_health_coloring==true;toggle.rakehealthcoloring=data.rake_health_coloring==true;toggle.playeresp.showdistance=data.player_show_distance==true;toggle.playeresp.background=true;toggle.playeresp.style=data.player_esp_style=="legacy"and"legacy"or"modern";toggle.rakeespstyle=data.rake_esp_style=="legacy"and"legacy"or"modern";toggle.rakestatus=data.rake_status~=false;toggle.rakerenderdistance=math.floor(clamp(tonumber(data.rake_render_distance)or 150,10,150));toggle.rakepanel.nextsample=0;toggle.setplayerdistance(type(data.player_esp_distance)=="number"and data.player_esp_distance or 150,true);toggle.setplayersesp(true,true)
    local zoomamount=type(data.zoom_amount)=="number"and data.zoom_amount or type(data.min_zoom)=="number"and data.min_zoom>=0.5 and data.min_zoom or type(data.minZoom)=="number"and data.minZoom>=0.5 and data.minZoom or 8;toggle.setzoomamount(zoomamount,true);local thirdperson=false;if type(data.third_person)=="boolean"then thirdperson=data.third_person elseif type(data.min_zoom)=="number"then thirdperson=data.min_zoom>=9.5 elseif type(data.minZoom)=="number"then thirdperson=data.minZoom>=9.5 end;toggle.setthirdperson(thirdperson,true);toggle.setshiftlock(data.shift_lock==true,true)
    toggle.setinstacrate(data.insta_crate==true,true)
    toggle.autocollect.selected={};local savedauto=type(data.auto_collect)=="table"and data.auto_collect or{};local selected=type(savedauto.selected)=="table"and savedauto.selected or{};for i=1,#toggle.autocollect.order do local name=toggle.autocollect.order[i].name;if selected[name]==true then toggle.autocollect.selected[name]=true end end;toggle.autocollect.enabled=toggle.instacrate and savedauto.enabled==true
    for i=1,#toggle.promptoptionorder do local entry=toggle.promptoptionorder[i];local saved=type(data.prompts)=="table"and data.prompts[entry.id];if type(saved)~="boolean"and type(data.prompts)=="table"then saved=data.prompts[entry.panel]end;toggle.promptsettings[entry.id]=type(saved)=="boolean"and saved or true end;toggle.setpromptmaster(type(data.prompts)=="table"and data.prompts.master==true,true)
    toggle.setcontainerstyle(data.container_style or data.hud_style or "modern",true)
    if type(data.esp_text_outline)=="boolean"then toggle.setesptextoutline(data.esp_text_outline,true)end
    if type(data.widget_group)=="table"and data.widget_group.dragged==true then toggle.widgetgroup.dragged=true;if type(data.widget_group.x)=="number"then toggle.widgetgroup.x=data.widget_group.x end;if type(data.widget_group.y)=="number"then toggle.widgetgroup.y=data.widget_group.y end else toggle.widgetgroup.dragged=false;toggle.widgetgroup.x=nil;if type(data.widget_group)=="table"and type(data.widget_group.y)=="number"then toggle.widgetgroup.y=data.widget_group.y end end
    if type(data.distance_min)=="number"then toggle.distancemin=math.floor(clamp(data.distance_min,0,100)+0.5)else toggle.distancemin=0 end
    if type(data.gui_opacity)=="number"then setguiopacity(data.gui_opacity,true)end
    if type(data.theme_colors)=="table"and type(data.theme_colors.border_radius)=="number"then toggle.setborderradius(data.theme_colors.border_radius,true)else toggle.setborderradius(10,true)end
    if type(data.ring_enabled)=="boolean"then toggle.setringenabled(data.ring_enabled,true)end
    if data.ring_shape=="circle"or data.ring_shape=="square"or data.ring_shape=="triangle"or data.ring_shape=="hexagon"then toggle.setringshape(data.ring_shape,true)end
    setringsegments(64,true)
    if type(data.ring_fade)=="number"then toggle.setringfade(data.ring_fade,true)end;toggle.setringopacity(type(data.ring_opacity)=="number"and data.ring_opacity or 0.6,true)
    if type(data.ring_size)=="number"then toggle.setringsize(data.ring_size,true)end
    if type(data.ring_spin)=="boolean"then toggle.setringspin(data.ring_spin,true)end
    if type(data.ring_spin_speed)=="number"then toggle.setringspinspeed(data.ring_spin_speed,true)end
    if type(data.esp)=="boolean"then setesp(data.esp,true)end
    if type(data.hud)=="boolean"then sethud(data.hud,true)end
    if type(data.hud_elements)=="table"then for _,id in ipairs({"timer","target","scrap","power"})do if type(data.hud_elements[id])=="boolean"then toggle.sethudelement(id,data.hud_elements[id],true)end end end
    if type(data.power_activity)=="boolean"then toggle.setpoweractivity(data.power_activity,true)end
    if data.power_activity_mode=="activity"or data.power_activity_mode=="always"then toggle.setpoweractivitymode(data.power_activity_mode,true)end
    if type(data.power_panel)=="table"then toggle.powerpanel.dragged=data.power_panel.dragged==true;if toggle.powerpanel.dragged and type(data.power_panel.x)=="number"then toggle.powerpanel.x=data.power_panel.x end;if toggle.powerpanel.dragged and type(data.power_panel.y)=="number"then toggle.powerpanel.y=data.power_panel.y end end
    if type(data.keybind_panel)=="table"then local k=data.keybind_panel;toggle.keybindpanel=k.enabled==true;toggle.keybindpanelstate.dragged=k.dragged==true;if toggle.keybindpanelstate.dragged and type(k.x)=="number"then toggle.keybindpanelstate.x=k.x end;if toggle.keybindpanelstate.dragged and type(k.y)=="number"then toggle.keybindpanelstate.y=k.y end else toggle.keybindpanel=false;toggle.keybindpanelstate.dragged=false end
    if type(data.world_panel)=="table"then local w=data.world_panel;toggle.worldpanel=w.enabled==true;toggle.worldpanelstate.dragged=w.dragged==true;if toggle.worldpanelstate.dragged and type(w.x)=="number"then toggle.worldpanelstate.x=w.x end;if toggle.worldpanelstate.dragged and type(w.y)=="number"then toggle.worldpanelstate.y=w.y end;if type(w.items)=="table"then for _,entry in ipairs(toggle.worldorder)do if type(w.items[entry.id])=="boolean"then toggle.worldpanelitems[entry.id]=w.items[entry.id]end end end else toggle.worldpanel=false;toggle.worldpanelstate.dragged=false end
    if type(data.roof_hp)=="boolean"then toggle.setroof(data.roof_hp,true)end
    if type(data.rake_name_enabled)=="boolean"then toggle.setrakename(data.rake_name_enabled,true)end
    if type(data.rake_health_enabled)=="boolean"then toggle.setrakehealth(data.rake_health_enabled,true)end
    if string.lower(configname)=="default"and data.nametag_defaults_version~=2 then toggle.playeresp.showhealth=true;toggle.setplayerdistance(150,true);data.rake_distance_enabled=true end
    toggle.setrakedistance(type(data.rake_distance_enabled)~="boolean"or data.rake_distance_enabled,true)
    if type(data.rake_name)=="string"then toggle.rakenamevalue=toggle.cleanrakename(data.rake_name);toggle.rakedraw.name.Text=toggle.rakenamevalue end
    toggle.setrakenamey(0,true)
    if type(data.bar_rgb)=="boolean"then setbarrgb(data.bar_rgb,true)else setbarrgb(false,true)end;for _,entry in ipairs(toggle.accentbarorder)do if type(data.accent_bars)=="table"and type(data.accent_bars[entry.id])=="boolean"then toggle.accentbars[entry.id]=data.accent_bars[entry.id]else toggle.accentbars[entry.id]=entry.id=="menu"or entry.id=="hud"or entry.id=="keybinds"end end
    toggle.setchromasaturation(type(data.chroma_saturation)=="number"and data.chroma_saturation or 0.3,true);toggle.setchromaspeed(type(data.chroma_speed)=="number"and data.chroma_speed or 0.6,true)
    if data.rgb_defaults_schema~=2 then toggle.setrgbdirection("right",true);toggle.setrgbspeed(0.6,true)else local direction=data.accent_direction or data.rgb_direction;local speed=data.accent_bar_speed or data.accent_speed or data.rgb_speed;if direction=="left"or direction=="right"then toggle.setrgbdirection(direction,true)end;if type(speed)=="number"then toggle.setrgbspeed(speed,true)end end
    toggle.timerformat="clock"
    if type(data.teleport_cooldown)=="boolean"then toggle.setteleportcooldown(data.teleport_cooldown,true)end
    toggle.setcooldownseconds(type(data.teleport_cooldown_seconds)=="number"and data.teleport_cooldown_seconds or 10,true)
    for _,id in ipairs(toggle.notifyorder)do toggle.notifysettings.types[id]=true end;if type(data.notifications)=="table"then local n=data.notifications;toggle.setnotificationposition(n.position,true);toggle.setnotificationduration(n.duration,true);toggle.setrakenotifydistance(n.rakedistance,true);if type(n.types)=="table"then for _,id in ipairs(toggle.notifyorder)do if type(n.types[id])=="boolean"then toggle.notifysettings.types[id]=n.types[id]end end else toggle.notifysettings.types.supply=n.crate==true;toggle.notifysettings.types.flare=n.flare==true;toggle.notifysettings.types.rake=n.rakeclose~=false;toggle.notifysettings.types.scrap=n.scrap==true;toggle.notifysettings.types.trap=n.trap==true end end
    local saveddistance=data.distance;if type(saveddistance)~="boolean"then saveddistance=data.meters end;setdistance(type(saveddistance)=="boolean"and saveddistance or false,true)
    toggle.setunit("meters",true)
    if data.distance_position=="under"or data.distance_position=="below"or data.distance_position=="above"then toggle.setdistanceposition(data.distance_position,true)end
    toggle.distancefade=false;if data.scrap_style=="none"then toggle.setscrapstyle("default",true)elseif data.scrap_style=="default"or data.scrap_style=="both"or data.scrap_style=="tiers"or data.scrap_style=="points"then toggle.setscrapstyle(data.scrap_style,true)else toggle.setscrapstyle("default",true)end;if type(data.scrap_elements)=="table"then for i=1,5 do local key="Scrap"..i;local saved=data.scrap_elements.Scrap1 or data.scrap_elements[key];if type(saved)=="table"then toggle.scrapelements[key]={tiers=saved.tiers==true,points=saved.points==true}end end;toggle.updatescraplabels()end;toggle.scrapedit=clamp(math.floor(tonumber(data.scrap_edit)or 1),1,5);toggle.locationedit=clamp(math.floor(tonumber(data.location_edit)or 1),1,#toggle.locationorder);toggle.setscrapteleport(data.scrap_teleport,true)
    if type(data.supply_label)=="boolean"then toggle.setsupplylabel(data.supply_label,true)end;if type(data.supply_items)=="boolean"then toggle.setsupplyitems(data.supply_items,true)end;toggle.crateinventorydistance=10
    espgroups.locations=true;espgroups.scraps=true;espgroups.crates=true;espgroups.rake=true;if type(data.esp_groups)=="table"then for _,id in ipairs({"traps","flares"})do if type(data.esp_groups[id])=="boolean"then setgroup(id,data.esp_groups[id],true)end end end
    if type(data.esp_items)=="table"then for id in pairs(espgroups.items)do if type(data.esp_items[id])=="boolean"then toggle.setitem(id,data.esp_items[id],true)end end end
    if type(data.colors)=="table"then
        for i=1,#colorentries do local saved=data.colors[i];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(i,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb(i,saved.rgb,true)end end end
    end
    if data.crate_label_version~=2 then local cfg=espcfg.Box;local c=cfg.labelcolor;if math.abs(c.R-70/255)<0.01 and math.abs(c.G-1)<0.01 and math.abs(c.B-190/255)<0.01 then setlabelcolor(8,Color3.fromHex("#9EE2FF"))end end
    if type(data.special_colors)=="table"then for _,id in ipairs({"distance","rake","rakehealth","roof","hudtimer","hudtarget","hudscrap","hudpower","cooldownlabel","cooldownvalue","valuetimer","valuetarget","valuescrap","valuepower"})do local saved=data.special_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb(id,saved.rgb,true)end end end end
    if type(data.crate_item_colors)=="table"then for id in pairs(toggle.cratestyles)do local saved=data.crate_item_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor("crate_"..id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb("crate_"..id,saved.rgb,true)end end end end
    if type(data.binds)=="table"then
        local used,nextbinds,valid={},{},true;local legacydefaults=(tonumber(data.menu_default_version)or 0)<5 and tonumber(data.binds.esp)==0x70 and tonumber(data.binds.hud)==0x71 and tonumber(data.binds.scrap)==0x72 and tonumber(data.binds.flare)==0x73
        for i=1,#bindorder do local id=bindorder[i];local code=tonumber(data.binds[id]);if code==nil then code=defaultbinds[id]or 0 end;if id=="menu"and data.menu_default_version==nil and code==0xBB then code=defaultbinds.menu end;if legacydefaults and id~="menu"and id~="prompt"then code=0 end;if(id=="crate"or id=="menu")and code==0 then code=defaultbinds[id]end;local conflict=used[code];if code==0 then nextbinds[id]=0 elseif not keynames[code]or conflict and not(id=="prompt"and conflict=="crate"or id=="crate"and conflict=="prompt")then valid=false else used[code]=id;nextbinds[id]=code end end
        if valid then keybinds=nextbinds end
    end
    if type(data.watermark)=="boolean"then toggle.watermark=data.watermark end;if type(data.menu)=="table"then if type(data.menu.height)=="number"then menustate.h=clamp(data.menu.height,340,math.max(340,cam.ViewportSize.Y-36))end;if type(data.menu.x)=="number"then menustate.x=data.menu.x end;if type(data.menu.y)=="number"then menustate.y=data.menu.y end;if type(data.menu.minimized)=="boolean"and toggle.watermark then menustate.minimized=data.menu.minimized else menustate.minimized=false end end
    toggle.uibatch=toggle.starting==true;toggle.huddirty=false;if toggle.anyclient()then toggle.applyclient(toggle.clientneedsgc()and not toggle.clientgc.valid)end;toggle.applyzoom(true);toggle.writelastconfig(configname);powerhud();timerhud();hudpos();showhud();powerpos();menuupdate();if not quiet then bindlog(backup and"loaded backup config"or"loaded config")end;return true
end
toggle.deleteconfig=function()
    local name=toggle.cleanconfig(configname);local path=configpath();if not isfile(path)then bindlog("config file not found");return false end
    local ok,deleted=pcall(function()return delfile(path)end);if ok and deleted then if toggle.readlastconfig()==name then toggle.writelastconfig("default")end;toggle.refreshconfigs("default");configslot=1;configname=configslots[configslot]or"default";configcapture=false;menuupdate();bindlog("deleted "..name);return true end
    bindlog("failed to delete config");return false
end
toggle.resetcolors=function(quiet)
    toggle.resetterrain()
    for _,cfg in pairs(espcfg)do cfg.color=cfg.defaultcolor;cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    roofstyle.labelcolor=roofstyle.defaultcolor;roofstyle.rgb=roofstyle.defaultrgb;toggle.distancestyle.labelcolor=toggle.distancestyle.defaultcolor;toggle.distancestyle.rgb=toggle.distancestyle.defaultrgb;toggle.rakestyle.labelcolor=toggle.rakestyle.defaultcolor;toggle.rakestyle.rgb=toggle.rakestyle.defaultrgb;toggle.rakehealthstyle.labelcolor=toggle.rakehealthstyle.defaultcolor;toggle.rakehealthstyle.rgb=toggle.rakehealthstyle.defaultrgb;toggle.cooldownstyle.labelcolor=toggle.cooldownstyle.defaultcolor;toggle.cooldownstyle.rgb=toggle.cooldownstyle.defaultrgb;toggle.cooldownvaluestyle.labelcolor=toggle.cooldownvaluestyle.defaultcolor;toggle.cooldownvaluestyle.rgb=toggle.cooldownvaluestyle.defaultrgb
    for _,cfg in pairs(toggle.hudstyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    for _,cfg in pairs(toggle.hudvalues)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    for _,cfg in pairs(toggle.cratestyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=false end
    toggle.startpalette(themes[themeindex],true);themes.accentstyle.labelcolor=themes[themeindex].accent;themes.accentstyle.rgb=false;menuupdate();if not quiet then bindlog("reset colors")end
end
toggle.resettheme=function(quiet)
    setfontindex(1,true);toggle.sethudfont(1,true);setthemeindex(toggle.defaultthemeindex,true);toggle.setchromasaturation(0.3,true);setguiopacity(0.9,true);toggle.setborderradius(10,true);menuupdate();if not quiet then bindlog("reset theme")end
end
toggle.resettoggles=function(quiet)
    toggle.resetposteffects()
    setesp(true,true);sethud(true,true);for _,id in ipairs({"timer","target","scrap"})do toggle.sethudelement(id,true,true)end;toggle.sethudelement("power",false,true);toggle.watermark=true;toggle.hybridfeatures=false;toggle.hybridmode=true;toggle.unsafeluau=true;toggle.hudlabels=true;toggle.setcontainerstyle("modern",true);toggle.setesptextoutline(true,true);toggle.distanceminimum=true;toggle.distancemin=0;toggle.setpoweractivity(true,true);toggle.setpoweractivitymode("activity",true);toggle.cooldownuntil=0;toggle.cooldownremaining=0;toggle.setteleportcooldown(false,true);toggle.setcooldownseconds(10,true);toggle.setnotificationposition("bottom right",true);toggle.setkeybindpanel(false,true);toggle.setworldpanel(false,true);for _,entry in ipairs(toggle.worldorder)do toggle.worldpanelitems[entry.id]=true end;toggle.setnotificationduration(4,true);toggle.setrakenotifydistance(30,true);for _,id in ipairs(toggle.notifyorder)do toggle.notifysettings.types[id]=true end;toggle.setroof(true,true);toggle.setrakename(true,true);toggle.setrakehealth(true,true);toggle.setrakedistance(true,true);toggle.rakenamevalue="rake";toggle.rakedraw.name.Text="rake";toggle.setrakenamey(0,true);setbarrgb(false,true);toggle.setrgbdirection("right",true);toggle.setrgbspeed(0.6,true);toggle.setchromaspeed(0.6,true);setdistance(false,true);toggle.distancefade=false;toggle.setunit("meters",true);toggle.setdistanceposition("below",true);toggle.setscrapstyle("default",true);toggle.setscrapteleport("value",true);toggle.setsupplylabel(true,true);toggle.setsupplyitems(true,true);toggle.setringenabled(true,true);toggle.setringshape("circle",true);toggle.setringfade(40,true);toggle.setringopacity(0.6,true);toggle.setringsize(1,true);toggle.setringspin(false,true);toggle.setringspinspeed(1,true);
    toggle.sethudelement("power",true,true)
    for _,id in ipairs({"noJumpCooldown","infiniteStamina","noFall","towerBarriers","antiCollide","doorNoCollide","preventIdle"})do toggle.setclient(id,false,true)end;toggle.setautoradio(false,true);toggle.setautorecover(false,true);toggle.setautosellscrap(false,true);toggle.tracers.selected={};toggle.tracers.opacity=0.8;toggle.tracers.speed=1;toggle.autobuyitems.selected={};toggle.autobuyitems.next=0;toggle.autosellitems.selected={};toggle.autosellitems.next=0;toggle.sellenabled=true;toggle.scrapteleportenabled=true;toggle.flareteleportenabled=true;toggle.shop.selected="RakeTrap";toggle.setkillaura(false,true);toggle.setkillaurarange(16,true);toggle.setkillauradelay(0.05,true);toggle.setautoheal(false,true);toggle.setautohealth(50,true);toggle.setautopower(false,true);toggle.setautopowertoolbox(true,true);toggle.playeresp.selected={FlareGun=true,StunStick=true,UV_Lamp=true,FirstAidKit=true,Vest=true};toggle.playeresp.stacking=true;toggle.playeresp.nextlayout=0;toggle.playeresp.showusername=true;toggle.playeresp.showhealth=true;toggle.playeresp.showdistance=false;toggle.playeresp.background=true;toggle.playeresp.style="modern";toggle.rakeespstyle="modern";toggle.rakestatus=true;toggle.rakerenderdistance=150;toggle.rakehealthcoloring=false;toggle.playeresp.healthcoloring=false;toggle.setplayerdistance(150,true);toggle.setplayersesp(true,true);toggle.setzoomamount(8,true);toggle.setthirdperson(false,true);toggle.setshiftlock(false,true);toggle.setinstacrate(false,true);toggle.autocollect.selected={};for i=1,#toggle.promptoptionorder do toggle.promptsettings[toggle.promptoptionorder[i].id]=true end;toggle.setpromptmaster(false,true);for _,entry in ipairs(toggle.accentbarorder)do toggle.accentbars[entry.id]=entry.id=="menu"or entry.id=="hud"or entry.id=="keybinds"end
    for _,id in ipairs({"locations","scraps","traps","flares","crates"})do setgroup(id,true,true)end;espgroups.rake=true;for id in pairs(espgroups.items)do toggle.setitem(id,id~="RakeSpawnPart",true)end
    menuupdate();if not quiet then bindlog("reset toggles")end
end
toggle.resetbinds=function(quiet)
    keybinds={menu=defaultbinds.menu,esp=defaultbinds.esp,hud=defaultbinds.hud,scrap=defaultbinds.scrap,flare=defaultbinds.flare,aura=defaultbinds.aura,sell=defaultbinds.sell,thirdperson=defaultbinds.thirdperson,crate=defaultbinds.crate,prompt=defaultbinds.prompt,collide=defaultbinds.collide,door=defaultbinds.door};capture=nil;menuupdate();if not quiet then bindlog("reset binds")end
end
toggle.resetpositions=function(quiet)
    local v=cam.ViewportSize;menustate.resizeheighttarget=nil;menustate.h=math.min(660,math.max(340,v.Y-36));menustate.x=24;menustate.y=math.floor((v.Y-menustate.h)/2);menustate.widgetclosed={};menustate.widgetanim={};menustate.itemsdirty=true;toggle.widgetgroup.x=nil;toggle.widgetgroup.y=nil;toggle.widgetgroup.dragged=false;toggle.powerpanel.dragged=false;toggle.powerpanel.x=math.max(2,v.X-toggle.powerpanel.w-18);toggle.powerpanel.y=math.floor(v.Y/2-(toggle.powerpanel.h+16+toggle.keybindpanelstate.h)/2);toggle.keybindpanelstate.dragged=false;toggle.keybindpanelstate.x=math.max(2,v.X-toggle.keybindpanelstate.w-18);toggle.keybindpanelstate.y=toggle.powerpanel.y+toggle.powerpanel.h+16;toggle.worldpanelstate.dragged=false;toggle.worldpanelstate.x=18;toggle.worldpanelstate.y=math.max(2,v.Y-toggle.worldpanelstate.h-18);menupos();hudpos();showhud();powerpos();toggle.keybindpos();worldpos();menuupdate();if not quiet then bindlog("reset positions")end
end
toggle.startreset=function()
    local selected=toggle.resetselected;if not selected.theme and not selected.features and not selected.positions then bindlog("select at least one reset option");return false end;toggle.uibatch=true;if selected.theme then toggle.resettheme(true);toggle.resetcolors(true)end;if selected.features then toggle.resettoggles(true);toggle.resetbinds(true)end;if selected.positions then toggle.resetpositions(true)end;toggle.uibatch=false;toggle.huddirty=false;powerhud();timerhud();hudpos();showhud();powerpos();toggle.keybindpos();worldpos();menupos();menuupdate();bindlog("reset selected settings");return true
end
local function runaction(id)
    if id=="menu"then if toggle.rakenamecapture then toggle.finishrakename(false)end;if toggle.watermark then if not toggle.menu then toggle.menu=true;menustate.minimized=false else menustate.minimized=not menustate.minimized end else toggle.menu=not toggle.menu;menustate.minimized=false end;capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;configcapture=false;showmenu();bindlog(not toggle.menu and"closed menu"or menustate.minimized and"watermark state"or"expanded menu")
    elseif id=="esp"then setesp(not toggle.esp)
    elseif id=="hud"then sethud(not toggle.hud)
    elseif id=="collide"then toggle.setclient("antiCollide",not toggle.client.antiCollide)
    elseif id=="door"then toggle.setclient("doorNoCollide",not toggle.client.doorNoCollide)
    elseif id=="thirdperson"then toggle.setthirdperson(not toggle.zoom.thirdperson)
    elseif id=="aura"then toggle.setkillaura(not toggle.killaura)
    elseif id=="sell"then
        if not toggle.sellenabled then return end;toggle.queueshopaction("SellScraps")
    elseif id=="scrap"or id=="flare"then
        if(id=="scrap"and not toggle.scrapteleportenabled)or(id=="flare"and not toggle.flareteleportenabled)then return end
        if not toggle.cooldownready()then bindlog("tp safe cooldown","teleports");return end
        local ok=false;if id=="scrap"then ok=tpscrap()else ok=tpflare()end;if ok then toggle.startcooldown()end;bindlog(ok and"teleported to "..id or id.." not found","teleports")
    elseif id=="crate"then
        local ok,result=toggle.collectcrate();if not ok and result then bindlog(result,"supply")end
    end
end
local inputstate={dragging=false,sliding=nil,scrolling=nil,dropdownscrolling=false,powerdragging=false,worlddragging=false,keybinddragging=false,groupdragging=false,widgetpending=nil,mouseheld=false,rightheld=false,dragx=0,dragy=0,powerdragx=0,powerdragy=0,worlddragx=0,worlddragy=0,keybinddragx=0,keybinddragy=0,groupdragx=0,groupdragy=0,scrolly=0,scrollstart=0,dropdownscrolly=0,dropdownscrollstart=0,wheel=0}
local function pickerapply(mx,my)
    local cfg=entrycfg(pickerentry);if not cfg then return nil end;local h,s,v=tohsv(cfg.labelcolor);local square=pickerlayouts.square;local hue=pickerlayouts.hue
    if inputstate.sliding=="pickerhue"and hue then picker.hexactive=false;h=clamp((my-hue.y)/hue.h,0,1);local key=tostring(pickerentry)..":h:"..tostring(math.floor(h*1000+0.5));if picker.dragkey~=key then picker.dragkey=key;setlabelcolor(pickerentry,Color3.fromHSV(h,s,v),true)end;return"pickerhue"end
    if square and inside(mx,my,square.x,square.y,square.w,square.h)then picker.hexactive=false;s=clamp((mx-square.x)/square.w,0,1);v=1-clamp((my-square.y)/square.h,0,1);local key=tostring(pickerentry)..":s:"..tostring(math.floor(s*1000+0.5))..":"..tostring(math.floor(v*1000+0.5));if picker.dragkey~=key then picker.dragkey=key;setlabelcolor(pickerentry,Color3.fromHSV(h,s,v),true)end;return"pickersquare"end
    if hue and inside(mx,my,hue.x-3,hue.y,hue.w+6,hue.h)then picker.hexactive=false;h=clamp((my-hue.y)/hue.h,0,1);local key=tostring(pickerentry)..":h:"..tostring(math.floor(h*1000+0.5));if picker.dragkey~=key then picker.dragkey=key;setlabelcolor(pickerentry,Color3.fromHSV(h,s,v),true)end;return"pickerhue"end
    return nil
end
local function sliderapply(mx,my,quiet)
    if inputstate.sliding=="pickersquare"or inputstate.sliding=="pickerhue"then pickerapply(mx,my);return end
    local layout=nil
    for i=1,#itemlayouts do if itemlayouts[i].item.id==inputstate.sliding and itemlayouts[i].visible then layout=itemlayouts[i];break end end
    if not layout then return end
    local item=layout.item;local ratio=clamp((mx-(layout.x+12))/(layout.w-24),0,1);local value=item.min+ratio*(item.max-item.min)
    if inputstate.sliding=="grasslength"then toggle.visuals.grasslength=math.floor(clamp(value,-0.5,1)*100+0.5)/100;toggle.visuals.lengthedited=true;toggle.visualchanged();menuupdate()
    elseif toggle.visuals.effectfields[inputstate.sliding]then local entry=toggle.visuals.effectfields[inputstate.sliding];entry.effect.values[entry.field.key]=toggle.effectrawvalue(entry.field,value);entry.effect.edited[entry.field.key]=true;toggle.visualchanged();menuupdate()
    elseif inputstate.sliding=="distancemin"then toggle.distancemin=math.floor(clamp(value,0,100)+0.5);menuupdate()
    elseif inputstate.sliding=="traceropacity"then toggle.tracers.opacity=math.floor(clamp(value,0.1,1)*100+0.5)/100;menuupdate()
    elseif inputstate.sliding=="tracerspeed"then toggle.tracers.speed=math.floor(clamp(value,0.5,2)*100+0.5)/100;menuupdate()
    elseif inputstate.sliding=="zoomamount"then toggle.setzoomamount(value,quiet)
    elseif inputstate.sliding=="fontsize"then setfontsize(value,quiet)
    elseif inputstate.sliding=="killaurarange"then toggle.setkillaurarange(value,quiet)
    elseif inputstate.sliding=="killauradelay"then toggle.setkillauradelay(value,quiet)
    elseif inputstate.sliding=="autohealth"then toggle.setautohealth(value,quiet)
    elseif inputstate.sliding=="ringfade"then toggle.setringfade(value,quiet)
    elseif inputstate.sliding=="ringopacity"then toggle.setringopacity(value,quiet)
    elseif inputstate.sliding=="rakerenderdistance"then toggle.rakerenderdistance=math.floor(clamp(value,10,150)+0.5);menuupdate()
    elseif inputstate.sliding=="playerdistance"then toggle.setplayerdistance(value,quiet)
    elseif inputstate.sliding=="ringsize"then toggle.setringsize(value,quiet)
    elseif inputstate.sliding=="ringspinspeed"then toggle.setringspinspeed(value,quiet)
    elseif inputstate.sliding=="rgbspeed"then toggle.setrgbspeed(value,quiet)
    elseif inputstate.sliding=="chromasaturation"then toggle.setchromasaturation(value,quiet)
    elseif inputstate.sliding=="chromaspeed"then toggle.setchromaspeed(value,quiet)
    elseif inputstate.sliding=="cooldownseconds"then toggle.setcooldownseconds(value,quiet)
    elseif inputstate.sliding=="notificationduration"then toggle.setnotificationduration(value,quiet)
    elseif inputstate.sliding=="rakenotifydistance"then toggle.setrakenotifydistance(value,quiet)
    elseif inputstate.sliding=="rakenamey"then toggle.setrakenamey(value,quiet)
    elseif inputstate.sliding=="opacity"then setguiopacity(value,quiet)
    elseif inputstate.sliding=="borderradius"then toggle.setborderradius(value,quiet)end
end
toggle.controlhit=function(l,mx,my)
    if not l or not l.visible or my<l.hittop or my>l.hitbottom then return false end
    if l.item.inlinebind and l.bindx and inside(mx,my,l.bindx,l.bindy,l.bindw,l.bindh)then return true end
    if l.item.colorindex and l.colorx and inside(mx,my,l.colorx,l.colory,l.colorw,l.colorh)then return true end
    local kind=l.item.kind
    if kind=="toggle"then return inside(mx,my,l.togglex,l.toggley,l.togglew,l.toggleh)
    elseif kind=="slider"then return l.trackvisible and inside(mx,my,l.x+6,l.y+24,l.w-12,18)
    elseif kind=="color"then return inside(mx,my,l.x+l.w-38,l.y+3,30,22)
    elseif kind=="bind"then return l.bindx and inside(mx,my,l.bindx,l.bindy,l.bindw,l.bindh)
    elseif kind=="action"or kind=="dropdown"or kind=="text"then return inside(mx,my,l.controlx,l.controly,l.controlw,l.controlh)
    end;return false
end
local function clickmenu(mx,my)
    if pickerentry then
        if pickerlayouts.rgb and inside(mx,my,pickerlayouts.rgb.x,pickerlayouts.rgb.y,pickerlayouts.rgb.w,pickerlayouts.rgb.h)then local cfg=entrycfg(pickerentry);setlabelrgb(pickerentry,not cfg.rgb);return end
        if pickerlayouts.hex and inside(mx,my,pickerlayouts.hex.x,pickerlayouts.hex.y,pickerlayouts.hex.w,pickerlayouts.hex.h)then picker.hexactive=true;picker.hexreplace=true;picker.hexvalue=toggle.hexof(entrycfg(pickerentry).labelcolor);capture=nil;configcapture=false;menuupdate();return end
        local pickermode=pickerapply(mx,my);if pickermode then inputstate.sliding=pickermode;return end
        if not pickerlayouts.popup or not inside(mx,my,pickerlayouts.popup.x,pickerlayouts.popup.y,pickerlayouts.popup.w,pickerlayouts.popup.h)then if picker.hexactive then toggle.applypickerhex(true)end;picker.hexactive=false;picker.hexreplace=false;pickerentry=nil;inputstate.sliding=nil;menuupdate()end
        return
    end
    if dropdownkind then
        local bar=dropdown.layout
        if bar and bar.scrollable and inside(mx,my,bar.trackx,bar.tracky,bar.trackw,bar.trackh)then
            if not inside(mx,my,bar.thumbx,bar.thumby,bar.thumbw,bar.thumbh)then dropdown.offset=clamp((my-bar.tracky-bar.thumbh/2)/math.max(1,bar.travel)*dropdown.scrollmax,0,dropdown.scrollmax);dropdownupdate(true);bar=dropdown.layout end
            inputstate.dropdownscrolling=true;inputstate.dropdownscrolly=my;inputstate.dropdownscrollstart=dropdown.offset;return
        end
        for i=1,#dropdownlayouts do
            local layout=dropdownlayouts[i]
            if inside(mx,my,layout.x,layout.y,layout.w,layout.h)then
                local kind=dropdownkind;if kind~="scrapstyle"and kind~="tracers"and kind~="hudelements"and kind~="playerelements"and kind~="rakeelements"and kind~="autocollect"and kind~="playeritems"and kind~="autobuyitems"and kind~="autosellitems"and kind~="notificationtypes"and kind~="worldstats"and kind~="locations"and kind~="scraptiers"and kind~="prompts"and kind~="resets"then dropdownkind=nil end
                if kind=="scrapedit"then toggle.scrapedit=layout.index;menuupdate()
                elseif kind=="locationedit"then toggle.locationedit=layout.index;menuupdate()
                elseif kind=="playerstyle"then toggle.playeresp.style=layout.value;toggle.playeresp.nextlayout=0;menuupdate()
                elseif kind=="rakestyle"then toggle.rakeespstyle=layout.value;menuupdate()
                elseif kind=="hudelements"then local entry=toggle.multientry(toggle.hudselectionorder,layout.value);if entry then toggle.sethudelement(entry.id,not toggle.hudelements[entry.id]);dropdownkind="hudelements";menuupdate()end
                elseif kind=="rakeelements"then if layout.value=="health"then toggle.setrakehealth(not toggle.rakehealth)elseif layout.value=="distance"then toggle.setrakedistance(not toggle.rakedistance)else toggle.rakestatus=not toggle.rakestatus end;dropdownkind="rakeelements";menuupdate()
                elseif kind=="playerelements"then local state=toggle.playeresp;local key=layout.value=="username"and"showusername"or layout.value=="health"and"showhealth"or"showdistance";state[key]=not state[key];state.nextlayout=0;for _,rec in pairs(state.records)do rec.nexthealth=0 end;dropdownkind="playerelements";menuupdate()
                elseif kind=="espfont"then setfontindex(layout.index)
                elseif kind=="hudfont"then toggle.sethudfont(layout.index)
                elseif kind=="preset"then setthemeindex(layout.index)
                elseif kind=="shopitem"then local item=toggle.shop.lookup[layout.value];if item then toggle.shop.selected=item.name;bindlog("shop item set to "..item.label);menuupdate()end
                elseif kind=="unit"then toggle.setunit(layout.value)
                elseif kind=="distanceposition"then toggle.setdistanceposition(layout.value)
                elseif kind=="scrapstyle"then local enabled=not toggle.scrapelements.Scrap1[layout.value];for i=1,5 do toggle.scrapelements["Scrap"..i][layout.value]=enabled end;toggle.updatescraplabels();dropdownkind="scrapstyle";menuupdate()
                elseif kind=="scrapteleport"then toggle.setscrapteleport(layout.value)
                elseif kind=="ringshape"then toggle.setringshape(layout.value)
                elseif kind=="rgbdirection"then toggle.setrgbdirection(layout.value)
                elseif kind=="containerstyle"then toggle.setcontainerstyle(layout.value)
                elseif kind=="poweractivitymode"then toggle.setpoweractivitymode(layout.value)
                elseif kind=="notificationposition"then toggle.setnotificationposition(layout.value)
                elseif kind=="autocollect"then local name=toggle.autocollectname(layout.value);if name then toggle.autocollect.selected[name]=not toggle.autocollect.selected[name];dropdownkind="autocollect";menuupdate()end
                elseif kind=="playeritems"then local entry=toggle.multientry(toggle.playeresp.order,layout.value);if entry then local enabled=toggle.playeresp.selected[entry.name]~=true;toggle.playeresp.selected[entry.name]=enabled;toggle.refreshplayerselection();dropdownkind="playeritems";menuupdate();bindlog((enabled and"enabled "or"disabled ")..entry.label.." player scan")end
                elseif kind=="tracers"then if toggle.tracers.selected[layout.value]then toggle.tracers.selected[layout.value]=nil else toggle.tracers.selected[layout.value]=true end;dropdownkind="tracers";menuupdate();bindlog((toggle.tracers.selected[layout.value]and"enabled "or"disabled ")..layout.value.." tracers")
                elseif kind=="autobuyitems"then local entry=toggle.shop.lookup[layout.value];if entry then if toggle.autobuyitems.selected[entry.name]then toggle.autobuyitems.selected[entry.name]=nil else toggle.autobuyitems.selected[entry.name]=true end;toggle.autobuyitems.next=0;dropdownkind="autobuyitems";menuupdate();bindlog((toggle.autobuyitems.selected[entry.name]and"enabled "or"disabled ")..entry.label.." auto-buy")end
                elseif kind=="autosellitems"then local entry=toggle.shop.lookup[layout.value];if entry then if toggle.autosellitems.selected[entry.name]then toggle.autosellitems.selected[entry.name]=nil else toggle.autosellitems.selected[entry.name]=true end;toggle.autosellitems.next=0;dropdownkind="autosellitems";menuupdate();bindlog((toggle.autosellitems.selected[entry.name]and"enabled "or"disabled ")..entry.label.." auto-sell")end
                elseif kind=="notificationtypes"then toggle.notifysettings.types[layout.value]=not toggle.notifysettings.types[layout.value];dropdownkind="notificationtypes";menuupdate();bindlog((toggle.notifysettings.types[layout.value]and"enabled "or"disabled ")..layout.value.." notifications")
                elseif kind=="worldstats"then local entry=toggle.multientry(toggle.worldorder,layout.value);if entry then toggle.worldpanelitems[entry.id]=not toggle.worldpanelitems[entry.id];worldpos();dropdownkind="worldstats";menuupdate();bindlog((toggle.worldpanelitems[entry.id]and"enabled "or"disabled ")..entry.label.." world stat")end
                elseif kind=="prompts"then local entry=toggle.multientry(toggle.promptoptionorder,layout.value);if entry then toggle.promptsettings[entry.id]=not toggle.promptsettings[entry.id];toggle.resolveprompts(true);dropdownkind="prompts";menuupdate();bindlog((toggle.promptsettings[entry.id]and"enabled "or"disabled ")..entry.label.." prompt")end
                elseif kind=="accentbars"then local entry=toggle.multientry(toggle.accentbarorder,layout.value);if entry then toggle.accentbars[entry.id]=not toggle.accentbars[entry.id];dropdownkind="accentbars";menuupdate();bindlog((toggle.accentbars[entry.id]and"enabled "or"disabled ")..entry.label.." accent bar")end
                elseif kind=="resets"then local entry=toggle.multientry(toggle.resetorder,layout.value);if entry then toggle.resetselected[entry.id]=not toggle.resetselected[entry.id];dropdownkind="resets";menuupdate()end
                elseif kind=="config"then configslot=layout.index;configname=layout.value;configcapture=false;menuupdate()end
                return
            end
        end
        dropdownkind=nil;menuupdate();return
    end
    local displayw=displaysize()
    if inside(mx,my,menustate.x+displayw-39,menustate.y+4,32,menustate.headerh or 48)then if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end;if toggle.watermark then menustate.minimized=not menustate.minimized else toggle.menu=false;menustate.minimized=false end;capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;menupos();menuupdate();return end
    if menustate.minimized then return end
    local nav=menustate.nav or{x=menustate.x+18,y=menustate.y+42,w=menustate.w-36,h=34};local tabw=nav.w/#tabnames
    for i=1,#tabnames do
        if inside(mx,my,nav.x+(i-1)*tabw,nav.y,tabw,nav.h)then if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end;if i~=menustate.tab then menustate.tabslide=i>menustate.tab and 4 or-4;menustate.tabfade=0.82 end;menustate.tab=i;capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;menuupdate();return end
    end
    for i=1,#itemlayouts do
        local layout=itemlayouts[i];local item=layout.item
        if item.kind~="section"and toggle.controlhit(layout,mx,my)then
            if item.disabled then return end
            if item.colorindex and inside(mx,my,layout.colorx,layout.colory,layout.colorw,layout.colorh)then toggle.search.open=false;toggle.search.active=false;pickerentry=item.colorindex;picker.label=item.label;picker.opened=false;picker.hexactive=false;picker.hexreplace=false;picker.hexvalue=toggle.hexof(entrycfg(pickerentry).labelcolor);capture=nil;dropdownkind=nil;menuupdate();return end
            if item.inlinebind and layout.bindx and inside(mx,my,layout.bindx,layout.bindy,layout.bindw,layout.bindh)then capture=item.bind;configcapture=false;dropdownkind=nil;menuupdate();return end
            if configcapture and item.id~="configname"then toggle.finishconfiginput(false)end
            if toggle.rakenamecapture and item.id~="rakenameinput"then toggle.finishrakename(false)end
            if item.kind=="toggle"then
                if not inside(mx,my,layout.togglex,layout.toggley,layout.togglew,layout.toggleh)then return end
                if item.effectclass then toggle.seteffect(item.effectclass,not toggle.visuals.effects[item.effectclass]);menuupdate();bindlog((toggle.visuals.effects[item.effectclass]and"enabled "or"disabled ")..item.label)elseif item.id=="hybridfeatures"then toggle.hybridfeatures=not toggle.hybridfeatures;menustate.itemsdirty=true;dropdownkind=nil;menustate.scroll={};menustate.scrolltarget={};toggle.rebuildsearch();menuupdate();bindlog(toggle.hybridfeatures and"showing hybrid features"or"hiding hybrid features")elseif item.id=="sell"then toggle.sellenabled=not toggle.sellenabled;menuupdate();bindlog(toggle.sellenabled and"armed tp sell scrap bind"or"disabled tp sell scrap bind")elseif item.id=="scrap"then toggle.scrapteleportenabled=not toggle.scrapteleportenabled;menuupdate();bindlog(toggle.scrapteleportenabled and"armed teleport to scrap bind"or"disabled teleport to scrap bind")elseif item.id=="flare"then toggle.flareteleportenabled=not toggle.flareteleportenabled;menuupdate();bindlog(toggle.flareteleportenabled and"armed teleport to flare bind"or"disabled teleport to flare bind")elseif item.id=="autocollect"then toggle.autocollect.enabled=not toggle.autocollect.enabled;menuupdate();bindlog(toggle.autocollect.enabled and"enabled auto collect"or"disabled auto collect")elseif item.id=="autorecover"then toggle.setautorecover(not toggle.autorecover)elseif item.id=="autosellscrap"then toggle.setautosellscrap(not toggle.autosellscrap)elseif item.id=="autoradio"then toggle.setautoradio(not toggle.autoradio)elseif item.id=="playerstacking"then toggle.playeresp.stacking=not toggle.playeresp.stacking;toggle.playeresp.nextlayout=0;menuupdate()elseif item.id=="playersesp"then toggle.setplayersesp(not toggle.playeresp.enabled)elseif item.id=="playerbackground"then toggle.playeresp.background=not toggle.playeresp.background;menuupdate()elseif item.id=="playershowdistance"then toggle.playeresp.showdistance=not toggle.playeresp.showdistance;menuupdate()elseif item.id=="rakehealthcoloring"then toggle.rakehealthcoloring=not toggle.rakehealthcoloring;menuupdate()elseif item.id=="playerhealthcoloring"then toggle.playeresp.healthcoloring=not toggle.playeresp.healthcoloring;menuupdate()elseif item.id=="playershowusername"then toggle.playeresp.showusername=not toggle.playeresp.showusername;toggle.playeresp.nextlayout=0;menuupdate()elseif item.id=="playershowhealth"then toggle.playeresp.showhealth=not toggle.playeresp.showhealth;for _,rec in pairs(toggle.playeresp.records)do rec.nexthealth=0 end;menuupdate()elseif item.itemkey then toggle.setitem(item.itemkey,not espgroups.items[item.itemkey])elseif item.id=="esp"then setesp(not toggle.esp)elseif item.id=="hud"then sethud(not toggle.hud)elseif item.id=="hudtimer"then toggle.sethudelement("timer",not toggle.hudelements.timer)elseif item.id=="hudtarget"then toggle.sethudelement("target",not toggle.hudelements.target)elseif item.id=="hudscrap"then toggle.sethudelement("scrap",not toggle.hudelements.scrap)elseif item.id=="hudpower"then toggle.sethudelement("power",not toggle.hudelements.power)elseif item.id=="esptextoutline"then toggle.setesptextoutline(not toggle.esptextoutline)elseif item.id=="roof"then toggle.setroof(not toggle.roof)elseif item.id=="rakename"then toggle.setrakename(not toggle.rakename)elseif item.id=="rakehealth"then toggle.setrakehealth(not toggle.rakehealth)elseif item.id=="rakedistance"then toggle.setrakedistance(not toggle.rakedistance)elseif item.id=="thirdperson"then toggle.setthirdperson(not toggle.zoom.thirdperson)elseif item.id=="shiftlock"then toggle.setshiftlock(not toggle.shiftlockstate.active)elseif item.id=="killaura"then toggle.setkillaura(not toggle.killaura)elseif item.id=="autoheal"then toggle.setautoheal(not toggle.autoheal)elseif item.id=="autopower"then toggle.setautopower(not toggle.autopower)elseif item.id=="autopowertoolbox"then toggle.setautopowertoolbox(not toggle.autopowerrequiretoolbox)elseif item.id=="promptmaster"then toggle.setpromptmaster(not toggle.prompts)elseif item.id=="instacrate"then toggle.setinstacrate(not toggle.instacrate)elseif item.id=="keybindpanel"then toggle.setkeybindpanel(not toggle.keybindpanel)elseif item.id=="worldpanel"then toggle.setworldpanel(not toggle.worldpanel)elseif item.id=="poweractivity"then toggle.setpoweractivity(not toggle.poweractivity)elseif item.id=="teleportcooldown"then toggle.setteleportcooldown(not toggle.teleportcooldown)elseif item.id=="watermark"then toggle.watermark=not toggle.watermark;if not toggle.watermark then menustate.minimized=false end;menuupdate();bindlog(toggle.watermark and"enabled watermark state"or"disabled watermark state")elseif item.id=="barrgb"then setbarrgb(not toggle.barrgb)elseif item.id=="distance"then setdistance(not toggle.distance)elseif item.id=="supplylabel"then toggle.setsupplylabel(not toggle.supplylabel)elseif item.id=="supplyitems"then toggle.setsupplyitems(not toggle.supplyitems)elseif item.id=="ringenabled"then toggle.setringenabled(not toggle.ringenabled)elseif item.id=="ringspin"then toggle.setringspin(not toggle.ringspin)elseif toggle.client[item.id]~=nil then toggle.setclient(item.id,not toggle.client[item.id])else setgroup(item.id,not espgroups[item.id])end
            elseif item.kind=="action"then
                if item.id=="quickbuy"or item.id=="quicksell"then local action=item.id=="quickbuy"and"PurchaseItem"or"SellItem";toggle.queueshopaction(action)elseif item.id=="save"then saveconfig()elseif item.id=="load"then loadconfig(false)elseif item.id=="deleteconfig"then toggle.deleteconfig()elseif item.id=="startreset"then toggle.startreset()end
            elseif item.kind=="dropdown"then
                dropdownkind=toggle.dropdownkindof(item.id);dropdown.opened=false;capture=nil;menuupdate()
            elseif item.kind=="slider"then inputstate.sliding=item.id;sliderapply(mx,my,true)
            elseif item.kind=="bind"then capture=item.bind;configcapture=false;menuupdate()
            elseif item.kind=="text"then if item.id=="rakenameinput"then toggle.rakenamebackup=toggle.rakenamevalue;toggle.rakenamecapture=true;configcapture=false else toggle.configbackup=configname;configcapture=true;toggle.rakenamecapture=false end;capture=nil;dropdownkind=nil;menuupdate()
            elseif item.kind=="color"then toggle.search.open=false;toggle.search.active=false;pickerentry=item.index;picker.label=item.label;picker.opened=false;picker.hexactive=false;picker.hexreplace=false;picker.hexvalue=toggle.hexof(entrycfg(pickerentry).labelcolor);dropdownkind=nil;menuupdate()end
            return
        end
    end
    if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end
end
local function mouseinput()
    local down=ismouse1pressed();local rightdown=ismouse2pressed();local pressed=down and not inputstate.mouseheld;local rightpressed=rightdown and not inputstate.rightheld;local mx,my=mouse.X,mouse.Y
    if toggle.menu then
        local widgethit=nil;if not menustate.minimized and not pickerentry and not dropdownkind then for i=1,#itemlayouts do local layout=itemlayouts[i];if layout.textvisible and layout.item.kind=="section"and layout.collapsex and inside(mx,my,layout.collapsex,layout.collapsey,layout.collapsew,layout.collapseh or 24)then widgethit=layout;break end end end
        if inputstate.wheel~=0 then if dropdownkind and dropdown.layout and inside(mx,my,dropdown.layout.x,dropdown.layout.y,dropdown.layout.w,dropdown.layout.h)and dropdown.scrollmax>0 then dropdown.offset=clamp(dropdown.offset+inputstate.wheel,0,dropdown.scrollmax);menuupdate(true)elseif not menustate.minimized and inside(mx,my,menustate.x+12,menustate.y+(menustate.bodytop or 100),menustate.w-24,menustate.h-(menustate.bodytop or 100)-(menustate.footerheight or 52)-8)then menustate.scrolltarget[menustate.tab]=clamp((menustate.scrolltarget[menustate.tab]or 0)+inputstate.wheel*58,0,menustate.scrollmax[menustate.tab]or 0);dropdownkind=nil end;inputstate.wheel=0 end
        if pressed then
            local displayw=displaysize()
            if not menustate.minimized and menustate.resizehit and not pickerentry and not dropdownkind and inside(mx,my,menustate.resizehit.x,menustate.resizehit.y,menustate.resizehit.w,menustate.resizehit.h)then inputstate.resizing=true;inputstate.resizey=my;inputstate.resizeh=menustate.h;menustate.resizeheighttarget=menustate.h
            elseif toggle.searchclick(mx,my)then
            elseif pickerentry or dropdownkind then clickmenu(mx,my)
            elseif inside(mx,my,menustate.x,menustate.y,displayw,menustate.headerh or 48)and not inside(mx,my,menustate.x+displayw-39,menustate.y+4,32,menustate.headerh or 48)then if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end;inputstate.dragging=true;inputstate.dragx=mx-menustate.x;inputstate.dragy=my-menustate.y
            elseif widgethit then inputstate.widgetpending={id=widgethit.item.widgetid,tab=menustate.tab,x=widgethit.collapsex,y=widgethit.collapsey,w=widgethit.collapsew,h=widgethit.collapseh or 24}
            elseif not menustate.minimized and(menustate.scrollmax[menustate.tab]or 0)>0 and menustate.scrollthumb and inside(mx,my,menustate.scrollthumb.x,menustate.scrollthumb.y,menustate.scrollthumb.w,menustate.scrollthumb.h)then inputstate.scrolling="thumb";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]or 0
            elseif not menustate.minimized and(menustate.scrollmax[menustate.tab]or 0)>0 and menustate.scrollthumb and inside(mx,my,menustate.scrollthumb.x,menustate.scrollthumb.tracky,menustate.scrollthumb.w,menustate.scrollthumb.trackh)then local travel=menustate.scrollthumb.trackh-menustate.scrollthumb.thumbh;menustate.scrolltarget[menustate.tab]=clamp((my-menustate.scrollthumb.tracky-menustate.scrollthumb.thumbh/2)/math.max(1,travel)*(menustate.scrollmax[menustate.tab]or 0),0,menustate.scrollmax[menustate.tab]or 0);inputstate.scrolling="thumb";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]
            else local occupied=false;if not menustate.minimized then for i=1,#itemlayouts do local l=itemlayouts[i];if toggle.controlhit(l,mx,my)then occupied=true;break end end end;if not occupied and not menustate.minimized and inside(mx,my,menustate.x+12,menustate.y+(menustate.bodytop or 100),menustate.w-24,menustate.h-(menustate.bodytop or 100)-(menustate.footerheight or 52)-8)and(menustate.scrollmax[menustate.tab]or 0)>0 then inputstate.scrolling="content";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]or 0 else clickmenu(mx,my)end end
        end
        if down and inputstate.dropdownscrolling and dropdownkind and dropdown.layout then local bar=dropdown.layout;dropdown.offset=clamp(inputstate.dropdownscrollstart+(my-inputstate.dropdownscrolly)/math.max(1,bar.travel)*dropdown.scrollmax,0,dropdown.scrollmax);menuupdate(true)end


        if down and inputstate.resizing then menustate.resizeheighttarget=clamp(inputstate.resizeh+my-inputstate.resizey,math.min(340,cam.ViewportSize.Y-36),math.max(340,cam.ViewportSize.Y-menustate.y-18));dropdownkind=nil end
        if down and inputstate.dragging then menustate.x=mx-inputstate.dragx;menustate.y=my-inputstate.dragy end
        if down and inputstate.scrolling then if inputstate.scrolling=="content"then menustate.scrolltarget[menustate.tab]=clamp(inputstate.scrollstart-(my-inputstate.scrolly)*menustate.dragsensitivity,0,menustate.scrollmax[menustate.tab]or 0)else local thumb=menustate.scrollthumb;local travel=thumb and thumb.trackh-thumb.thumbh or 0;menustate.scrolltarget[menustate.tab]=clamp(inputstate.scrollstart+(my-inputstate.scrolly)*menustate.dragsensitivity/math.max(1,travel)*(menustate.scrollmax[menustate.tab]or 0),0,menustate.scrollmax[menustate.tab]or 0)end end
        if down and inputstate.sliding then sliderapply(mx,my,true)else menuupdate(true)end
    end
    local p=toggle.powerpanel;local wp=toggle.worldpanelstate;local kp=toggle.keybindpanelstate;local mw,mh=displaysize();local panelblocked=pickerentry~=nil or dropdownkind~=nil or toggle.searchpanelhit(mx,my)or toggle.menu and inside(mx,my,menustate.x,menustate.y,mw,mh)
    if pressed and not panelblocked and toggle.containerstyle=="modern"and toggle.groupwidget.bg.Visible and inside(mx,my,toggle.widgetgroup.x,toggle.widgetgroup.y,toggle.widgetgroup.w,toggle.widgetgroup.h)then inputstate.groupdragging=true;inputstate.groupdragx=mx-toggle.widgetgroup.x;inputstate.groupdragy=my-toggle.widgetgroup.y end
    if pressed and not panelblocked and not inputstate.groupdragging and(wp.anim or 0)>0.01 and inside(mx,my,wp.x,wp.y,wp.w,wp.h)then inputstate.worlddragging=true;inputstate.worlddragx=mx-wp.x;inputstate.worlddragy=my-wp.y end
    if pressed and not panelblocked and not inputstate.groupdragging and not inputstate.worlddragging and(kp.anim or 0)>0.01 and inside(mx,my,kp.x,kp.y,kp.w,kp.h)then inputstate.keybinddragging=true;inputstate.keybinddragx=mx-kp.x;inputstate.keybinddragy=my-kp.y end
    if pressed and not panelblocked and not inputstate.groupdragging and not inputstate.worlddragging and not inputstate.keybinddragging and(p.anim or 0)>0.01 and inside(mx,my,p.x,p.y,p.w,p.h)then inputstate.powerdragging=true;inputstate.powerdragx=mx-p.x;inputstate.powerdragy=my-p.y end
    if not panelblocked and toggle.promptstate.active and not inputstate.groupdragging and not inputstate.worlddragging and not inputstate.keybinddragging and not inputstate.powerdragging then if pressed then toggle.promptselect(1)elseif rightpressed then toggle.promptselect(-1)end
    elseif not panelblocked and toggle.instacrate and not inputstate.groupdragging and not inputstate.worlddragging and not inputstate.keybinddragging and not inputstate.powerdragging then if pressed then toggle.crateselect(1)elseif rightpressed then toggle.crateselect(-1)end end
    if down and inputstate.groupdragging then toggle.widgetgroup.dragged=true;toggle.widgetgroup.x=mx-inputstate.groupdragx;toggle.widgetgroup.y=my-inputstate.groupdragy;hudpos();showhud()end
    if down and inputstate.worlddragging then wp.dragged=true;wp.x=mx-inputstate.worlddragx;wp.y=my-inputstate.worlddragy;worldpos()end
    if down and inputstate.keybinddragging then kp.dragged=true;kp.x=mx-inputstate.keybinddragx;kp.y=my-inputstate.keybinddragy;toggle.keybindpos()end
    if down and inputstate.powerdragging then p.dragged=true;p.x=mx-inputstate.powerdragx;p.y=my-inputstate.powerdragy;powerpos()end
    if not down then
        if inputstate.widgetpending then local pending=inputstate.widgetpending;inputstate.widgetpending=nil;if toggle.menu and pending.tab==menustate.tab and inside(mx,my,pending.x,pending.y,pending.w,pending.h or 24)then local closed=menustate.widgetclosed[pending.tab]or{};menustate.widgetclosed[pending.tab]=closed;closed[pending.id]=not closed[pending.id];menustate.itemsdirty=true;menuupdate()end end
        if inputstate.sliding=="chromasaturation"then bindlog("chroma saturation updated")elseif inputstate.sliding=="traceropacity"then bindlog("tracer opacity updated")elseif inputstate.sliding=="tracerspeed"then bindlog("tracer speed updated")elseif inputstate.sliding=="zoomamount"then bindlog("zoom amount set to "..string.format("%.1f",toggle.zoom.amount).." studs")elseif inputstate.sliding=="fontsize"then bindlog("font size set to "..tostring(espfontsize))elseif inputstate.sliding=="killaurarange"then bindlog("stun aura range set to "..tostring(toggle.killaurarange).." studs")elseif inputstate.sliding=="killauradelay"then bindlog("stun aura delay set to "..string.format("%.2fs",toggle.killauradelay))elseif inputstate.sliding=="ringfade"then bindlog("ring distance updated")elseif inputstate.sliding=="crateinventorydistance"then bindlog("crate inventory distance set to "..tostring(toggle.crateinventorydistance).."m")elseif inputstate.sliding=="playerdistance"then bindlog("player ESP distance set to "..tostring(toggle.playeresp.distance).."m")elseif inputstate.sliding=="ringsize"then bindlog("ring size set to "..string.format("%.1fx",toggle.ringsize))elseif inputstate.sliding=="ringspinspeed"then bindlog("ring spin speed updated")elseif inputstate.sliding=="rgbspeed"then bindlog("accent bar speed updated")elseif inputstate.sliding=="cooldownseconds"then bindlog("tp safe cooldown set to "..tostring(toggle.cooldownseconds).."s")elseif inputstate.sliding=="notificationduration"then bindlog("notification time set to "..string.format("%.1fs",toggle.notifysettings.duration))elseif inputstate.sliding=="rakenotifydistance"then bindlog("rake warning distance set to "..tostring(toggle.notifysettings.rakedistance).."m")elseif inputstate.sliding=="rakenamey"then bindlog("rake name Y offset set to "..tostring(toggle.rakenamey).."px")elseif inputstate.sliding=="opacity"then bindlog("GUI opacity set to "..tostring(math.floor(guiopacity*100+0.5)).."%")elseif inputstate.sliding=="borderradius"then bindlog("border radius set to "..tostring(toggle.borderradius).."px")elseif(inputstate.sliding=="pickersquare"or inputstate.sliding=="pickerhue")and pickerentry then bindlog("updated "..toggle.colorname(pickerentry).." color")end
        inputstate.dragging=false;inputstate.resizing=false;inputstate.sliding=nil;picker.dragkey=nil;inputstate.scrolling=nil;inputstate.dropdownscrolling=false;inputstate.powerdragging=false;inputstate.worlddragging=false;inputstate.keybinddragging=false;inputstate.groupdragging=false
    end
    inputstate.mouseheld=down;inputstate.rightheld=rightdown
end
toggle.cleanup=function()
    if toggle.cleanupdone then return end;toggle.cleanupdone=true
    -- Retire the Lua session before touching any native objects. Never flush remotes here.
    toggle.running=false;toggle.replacing=true
    toggle.promptstate.queue={};toggle.promptstate.holding=false;toggle.promptstate.holdid=nil;toggle.promptstate.busy=false
    local state=toggle.instacratestate;state.collectid=(state.collectid or 0)+1;state.request=nil;state.worker=false;state.collecting=false
    toggle.eventstates=setmetatable({},{__mode="k"});toggle.aurastate.parts={};toggle.aurastate.stick=nil;toggle.aurastate.remote=nil;toggle.aurastate.character=nil;toggle.aurastate.rake=nil
    pcall(toggle.restorevisuals);pcall(toggle.restoreidle);pcall(toggle.cleartracers);pcall(toggle.restoredoors);pcall(toggle.restorecollisions);pcall(toggle.applynofall,false,true);pcall(toggle.applytowerbarriers,false,true)
    for d in pairs(toggle.drawregistry)do remove(d)end
end
toggle.spawn(function()toggle.wait();while toggle.running and(toggle.starting)do toggle.wait(0.1)end;if toggle.running then pcall(toggle.avatarload)end end)
toggle.backspaceheld=function(edge)
    local down=iskeypressed(0x08);local now=tick();if not down then toggle.backspacenext=0;return false end;if edge then toggle.backspacenext=now+0.32;return true end;if now>=(toggle.backspacenext or 0)then toggle.backspacenext=now+0.045;return true end;return false
end
local function keys()
    local edges={}
    if toggle.search.active and toggle.menu and not menustate.minimized then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then toggle.search.active=false;toggle.search.open=false;menuupdate();return elseif edges[0x0D]then toggle.searchselect(1);menuupdate();return elseif toggle.backspaceheld(edges[0x08])then toggle.search.query=string.sub(toggle.search.query,1,math.max(0,#toggle.search.query-1));toggle.rebuildsearch();menuupdate();return end
        local added=nil;for code=0x30,0x39 do if edges[code]then added=string.char(code);break end end;if not added then for code=0x41,0x5A do if edges[code]then added=string.lower(string.char(code));break end end end;if not added and edges[0x20]then added=" "elseif not added and edges[0xBD]then added="-"end
        if added and #toggle.search.query<20 then toggle.search.query=toggle.search.query..added;toggle.rebuildsearch();menuupdate()end;return
    end
    if pickerentry and picker.hexactive and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then local cfg=entrycfg(pickerentry);picker.hexvalue=cfg and toggle.hexof(cfg.labelcolor)or"FFFFFF";picker.hexactive=false;picker.hexreplace=false;menuupdate();return
        elseif edges[0x0D]then if toggle.applypickerhex(false)then picker.hexactive=false;picker.hexreplace=false;menuupdate()end;return
        elseif toggle.backspaceheld(edges[0x08])then picker.hexvalue=picker.hexreplace and""or string.sub(picker.hexvalue,1,math.max(0,#picker.hexvalue-1));picker.hexreplace=false;menuupdate();return end
        local added=nil;for code=0x30,0x39 do if edges[code]then added=string.char(code);break end end;if not added then for code=0x41,0x46 do if edges[code]then added=string.char(code);break end end end
        if added then if picker.hexreplace then picker.hexvalue="";picker.hexreplace=false end;if #picker.hexvalue<6 then picker.hexvalue=picker.hexvalue..added;menuupdate()end end;return
    end
    if toggle.rakenamecapture and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then toggle.finishrakename(true);return elseif edges[0x0D]then toggle.finishrakename(false);return elseif toggle.backspaceheld(edges[0x08])then toggle.rakenamevalue=string.sub(toggle.rakenamevalue,1,math.max(0,#toggle.rakenamevalue-1));menuupdate();return end
        local added=nil;for code=0x30,0x39 do if edges[code]then added=string.char(code);break end end;if not added then for code=0x41,0x5A do if edges[code]then added=iskeypressed(0x10)and string.char(code)or string.lower(string.char(code));break end end end;if not added and edges[0x20]then added=" "elseif not added and edges[0xBD]then added="-"end
        if added and #toggle.rakenamevalue<20 then toggle.rakenamevalue=toggle.rakenamevalue..added;toggle.rakedraw.name.Text=toggle.rakenamevalue;menuupdate()end;return
    end
    if configcapture and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then toggle.finishconfiginput(true);return elseif edges[0x0D]then toggle.finishconfiginput(false);return elseif toggle.backspaceheld(edges[0x08])then configname=string.sub(configname,1,math.max(0,#configname-1));menuupdate();return end
        local added=nil;for code=0x30,0x39 do if edges[code]then added=string.char(code);break end end;if not added then for code=0x41,0x5A do if edges[code]then added=string.lower(string.char(code));break end end end;if not added and edges[0x20]then added=" "elseif not added and edges[0xBD]then added="-"end
        if added and #configname<18 then configname=configname..added;menuupdate()end;return
    end
    if capture and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then capture=nil;menuupdate();bindlog("cancelled keybind change");return elseif edges[0x08]then setbind(capture,0);return end
        for i=1,#keyoptions do local code=keyoptions[i].code;if edges[code]then setbind(capture,code);return end end
        return
    end
    for i=1,#bindorder do local code=keybinds[bindorder[i]];if code~=0 and edges[code]==nil then local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end end;local promptcode=keybinds.prompt or 0;local promptdown=promptcode~=0 and iskeypressed(promptcode);if toggle.promptstate.holdid and(not promptdown or not toggle.prompts)then toggle.holdprompt(false)end;if toggle.prompts and promptcode~=0 and edges[promptcode]and toggle.promptstate.active then toggle.useprompt();return end
    for i=1,#bindorder do local id=bindorder[i];local code=keybinds[id];if code~=0 and edges[code]then runaction(id)end end
end
toggle.cratesort=function(a,b)return a.distance<b.distance end
toggle.layoutcrates=function(viewer)
    local list=toggle.cratelayout or{};toggle.cratelayout=list;local count=0;local state=toggle.instacratestate;local cratebypass=toggle.instacrate and toggle.supplyitems;if not toggle.supplyitems then for i=#list,1,-1 do list[i]=nil end;return end
    for i=1,#tracked do local rec=tracked[i];rec.cratestack=0;if rec.active and rec.cfg.crate and rec.object and rec.object.Parent then local meters=dist(viewer,rec.object.Position);if cratebypass and not rec.crateused and meters<=cratedist and meters<state.distance then state.active=rec;state.distance=meters end;if toggle.supplyitems and meters<=toggle.crateinventorydistance then local screen,on=WorldToScreen(rec.object.Position);rec.cratelayouttime=toggle.frametime;rec.cratescreen=screen;rec.crateonscreen=on;rec.cratemeters=meters;if on then count=count+1;local entry=list[count]or{};entry.rec=rec;entry.screen=screen;entry.distance=meters;entry.offset=0;list[count]=entry end end end end
    local active=state.active;if active then if not active.folder or not active.folder.Parent then active.folder=itemfolder(active.model)end;local now=toggle.frametime or tick();if active.folder and(not active.itemscache or now-(active.itemcachetime or 0)>=0.08)then toggle.refreshcrateitems(active,now)end;if active.itemscache and(not active.crateselected or toggle.crateunavailable(active,active.itemscache[active.crateselected]))then active.crateselected=toggle.nextcrateitem(active,active.crateselected or 0,1)end end
    for i=#list,count+1,-1 do list[i]=nil end
    table.sort(list,toggle.cratesort)
    for i=1,#list do local entry=list[i];local offset=0;local height=entry.rec.crateheight or 92;for j=1,i-1 do local previous=list[j];local previousheight=previous.rec.crateheight or 92;if math.abs(entry.screen.X-previous.screen.X)<cratewidth and math.abs((entry.screen.Y+offset)-(previous.screen.Y+previous.offset))<math.max(height,previousheight)+8 then offset=math.max(offset,previous.screen.Y+previous.offset+previousheight+6-entry.screen.Y)end end;entry.offset=offset;entry.rec.cratestack=offset end
end
toggle.drawesp=function()
    toggle.tracers.frame=toggle.tracers.frame+1
    local viewer=viewpos();local state=toggle.instacratestate;local cratebypass=toggle.instacrate and toggle.supplyitems;state.active=nil;state.distance=math.huge
    if toggle.esp or cratebypass then pcall(toggle.layoutcrates,viewer)end
    if not pcall(toggle.drawprompts,viewer)then toggle.promptstate.active=nil;for _,rec in pairs(toggle.promptstate.records)do pcall(toggle.hideprompt,rec)end end
    pcall(keys);pcall(mouseinput)
    local i=#tracked
    while i>=1 do local rec=tracked[i];local remove=not toggle.scanning and rec.active==false and(rec.ringanim or 0)<=0.01
        if not remove then local ok,alive=pcall(drawrec,rec,viewer);if ok then rec.drawfail=0;remove=not toggle.scanning and not alive else rec.drawfail=(rec.drawfail or 0)+1;pcall(hiderec,rec);remove=not toggle.scanning and rec.drawfail>=3 end end
        if remove then pcall(untrack,i)end;i=i-1
    end
    pcall(toggle.tryautocollect);if not pcall(toggle.drawplayers,viewer)then for _,rec in pairs(toggle.playeresp.records)do pcall(toggle.hideplayerrecord,rec)end end
    if not pcall(drawroof)then pcall(function()rooflabel.Visible=false;roofhp.Visible=false;if toggle.roofpanel then toggle.roofpanel.bg.Visible=false;toggle.roofpanel.border.Visible=false end end)end
    if not pcall(toggle.drawrake,viewer)then toggle.hideplayerrecord(toggle.rakepanel);for _,entry in pairs(toggle.rakedraw)do pcall(function()entry.Visible=false end)end end
    pcall(toggle.updatetracertargets,viewer);if not pcall(toggle.drawtracers)then toggle.cleartracers()end
end
toggle.updateviewport=function()
    -- Keep the pre-focus-handler update model. Window focus never suspends workers.
    local ok,current,v=pcall(function()local camera=ws.CurrentCamera;return camera,camera and camera.ViewportSize end)
    if not ok or not current or not v or type(v.X)~="number"or type(v.Y)~="number"or v.X~=v.X or v.Y~=v.Y or v.X<64 or v.Y<64 or v.X>16384 or v.Y>16384 then return false end
    local resized=current~=cam or not toggle.lastviewport or v.X~=toggle.lastviewport.X or v.Y~=toggle.lastviewport.Y;cam=current;toggle.lastviewport=v
    if resized then pcall(hudpos);pcall(worldpos);pcall(powerpos);pcall(toggle.keybindpos);pcall(menupos);menustate.positionanimating=true end;return true
end
toggle.lastviewport=cam.ViewportSize
toggle.worker(function()
    while toggle.starting and toggle.running do toggle.wait()end;if not toggle.running then return end
    while toggle.running do
        pcall(toggle.updateviewport);local ok,changed=pcall(timerhud);if ok and changed then pcall(hudpos)end;toggle.wait(hudrate)
    end
end)
toggle.worker(function()while toggle.starting and toggle.running do toggle.wait()end;if not toggle.running then return end;local updates={scraphud,powerhud,targethud};while toggle.running do
    local changed=false;for _,update in ipairs(updates)do local ok,result=pcall(update);if ok and result then changed=true end end
    if changed then pcall(hudpos);pcall(showhud)end;toggle.wait(statusrate)
end end)

toggle.worker(function()
    while toggle.starting and toggle.running do toggle.wait()end;if not toggle.running then return end
    local nextrake=0
    while toggle.running do
        toggle.scanning=true;pcall(scan);toggle.scanning=false;if not toggle.running or toggle.replacing then break end;local now=tick();if now>=nextrake then pcall(rakeinfo);nextrake=now+1 end
        toggle.wait(scanrate)
    end
end)
toggle.worker(function()
    while toggle.starting and toggle.running do toggle.wait()end;if not toggle.running then return end
    while toggle.running do
        toggle.wait(0.01)
        if toggle.instacratestate.request then
            local request=toggle.instacratestate.request;local ok=pcall(toggle.runcratequeue)
            if not ok then toggle.finishcratecollect(request,false,true)end
        end
    end
end)
toggle.worker(function()
    while toggle.starting and toggle.running do toggle.wait()end;if not toggle.running then return end
    local jobs={toggle.runpromptqueue,toggle.applyidle,toggle.applydoors,toggle.applycollisions,toggle.applyclient,toggle.applykillaura,toggle.applyautoheal,toggle.applyautopower,toggle.applyautoradio,toggle.applyautorecover,toggle.applyautobuyitems,toggle.applyautosellscrap,toggle.applyautosellitems,toggle.applyzoom,toggle.applyshiftlock,toggle.applyvisuals}
    while toggle.running do
        local started=tick();local budgetstart=started;local work=0
        for i=1,#jobs do if not toggle.running then break end;pcall(jobs[i],false);work=work+1;if work>=4 or tick()-budgetstart>=0.002 then toggle.wait();budgetstart=tick();work=0 end end
        toggle.wait(math.max(0.001,0.05-(tick()-started)))
    end
end)
toggle.spawn(function()toggle.wait();if toggle.running and(toggle.zoom.thirdperson or toggle.shiftlockstate.active)then pcall(toggle.loadoffsets,false)end end)
toggle.worker(function()
    while toggle.starting and toggle.running do toggle.wait()end;if not toggle.running then return end
    local lastframe=tick()
    while toggle.running do
        local now=tick();local renderstart=now;toggle.frametime=now;toggle.framedt=clamp(now-lastframe,1/240,0.1);lastframe=now;toggle.rgbphase=((now*rgbspeed)*(toggle.rgbdirection=="left"and 1 or-1))%1;toggle.chromaphase=(now*toggle.chromaspeed)%1
        if now>=(toggle.gradientcache.nextframe or 0)then toggle.gradientcache.frame=toggle.gradientcache.frame+1;toggle.gradientcache.nextframe=now+1/60 end;pcall(toggle.applywaterchroma,now);pcall(toggle.drawesp);if not toggle.running or toggle.replacing then break end;pcall(drawrgb)
        toggle.wait(math.max(0.001,1/144-(tick()-renderstart)))
    end
end)
toggle.updatescraplabels()
toggle.refreshconfigs(toggle.readlastconfig())
if not loadconfig(true)then pcall(function()toggle.writeconfigdata(configpath(),configdata())end);toggle.refreshconfigs(configname)end
if toggle.watermark then toggle.menu=true;menustate.minimized=true;menustate.minimizeanim=1;menustate.menuanim=1;menustate.contentfade=0 else toggle.menu=false;menustate.minimized=false;menustate.minimizeanim=0;menustate.menuanim=0;menustate.contentfade=1 end
powerhud();timerhud();toggle.uibatch=false;toggle.refreshfonts();showhud();toggle.starting=false
toggle.spawn(function()if toggle.running then pcall(toggle.warmmenu);pcall(toggle.warmpicker)end end)
print("The Rake by Saint\nLeave a star if you liked it!")
