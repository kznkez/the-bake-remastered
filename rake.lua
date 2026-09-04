local version="1.1"
local players=game:GetService("Players")
local rs=game:GetService("ReplicatedStorage")
local ws=game:GetService("Workspace")
local lp=players.LocalPlayer
local cam=ws.CurrentCamera
local font=Drawing.Fonts.UI
local stud2m=1/3.5714285714
local scanrate,hudrate,statusrate=1,0.1,0.25
local ringfade,ringseg,cratedist,maxtrack,espfade=40,64,30,256,350
local toggle={esp=true,hud=true}
local keyheld={f1=false,f2=false,f3=false,f4=false}
local function clamp(value,minv,maxv)return math.max(minv,math.min(maxv,value))end
local function waitchild(parent,name,timeout)
    local start=tick()
    local child=parent:FindFirstChild(name)
    while not child do
        if timeout and tick()-start>=timeout then return nil end
        task.wait(0.1)
        child=parent:FindFirstChild(name)
    end
    return child
end
local function waitcam(timeout)
    local start=tick()
    local cam=ws.CurrentCamera
    while not cam do
        if timeout and tick()-start>=timeout then return nil end
        task.wait(0.1)
        cam=ws.CurrentCamera
    end
    return cam
end
if not cam then cam=waitcam(15)end
if not cam or not lp then return end

local timerval=waitchild(rs,"Timer",15)
local powervals=waitchild(rs,"PowerValues",15)
if not timerval or not powervals then return end
local function newtext(text,color,center,visible,outline)
    local d=Drawing.new("Text")
    d.Text=text or "";d.Color=color or Color3.fromHex("#ffffff");d.Center=center==true;d.Visible=visible==true;d.Outline=outline~=false;d.Font=font
    return d
end
local function newsquare(color,alpha)
    local d=Drawing.new("Square")
    d.Color=color;d.Transparency=alpha;d.Filled=true;d.Visible=false;d.Position=Vector2.new(0,0);d.Size=Vector2.new(1,1)
    return d
end
local function newline(color)
    local d=Drawing.new("Line")
    d.Color=color;d.Transparency=1;d.Visible=false;d.From=Vector2.new(0,0);d.To=Vector2.new(0,0);d.Thickness=2
    return d
end
local function remove(d)
    if not d then return end
    pcall(function()d.Visible=false;d:Remove()end)
end
local function hide(d)if d then d.Visible=false end end
local function anchors()
    local v=cam.ViewportSize
    return Vector2.new(v.X/2,v.Y-80),Vector2.new(v.X-200,v.Y-100)
end
local timertxt=newtext("0:00",Color3.fromHex("#ffffff"),true,true)
local scraptxt=newtext("0",Color3.fromHex("#ffffff"),true,true)
local targettxt=newtext("none",Color3.fromHex("#ffffff"),true,true)
local timerlabel=newtext("timer",Color3.fromHex("#aaaaaa"),true,true)
local scraplabel=newtext("scrap",Color3.fromHex("#aaaaaa"),true,true)
local targetlabel=newtext("target",Color3.fromHex("#aaaaaa"),true,true)
local powerlabel=newtext("power_activity",Color3.fromHex("#ffe0b8"),false,false)
local rooflabel=newtext("roof",Color3.fromHex("#f5d3ff"),true,false)
local roofhp=newtext("",Color3.fromHex("#ebebeb"),true,false)
local logtxt=newtext("",Color3.fromHex("#ffffff"),true,false)
logtxt.Size=13
local logid=0
local function bindlog(text)
    logid=logid+1
    local id=logid
    local center=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
    logtxt.Text="[!] "..text
    logtxt.Color=Color3.fromHex("#ffffff")
    logtxt.Position=center
    logtxt.Transparency=1
    logtxt.Visible=true
    local w=math.max(110,#logtxt.Text*7)
    spawn(function()
        task.wait(0.5)
        if id==logid then
            logtxt.Visible=false
        end
    end)
end
local rgbseg,rgbwidth,rgbspeed=70,280,0.4
local huddown=100
local function rgb(offset)return Color3.fromHSV(((tick()*rgbspeed)+(offset or 0))%1,0.72,1)end
local rgbline={}
for i=1,rgbseg do rgbline[i]=newline(Color3.fromHSV((i-1)/rgbseg,0.7,1));rgbline[i].Thickness=1 end
local powercfg={{valuename="UsingSHDoor",label="house_door_locked"},{valuename="UsingSHLight",label="house_lights_on"},{valuename="UsingTowerLight",label="tower_lights_on"},{valuename="UsingTowerRadar",label="tower_radar_on"}}
local powerlines={}
for i=1,#powercfg do powerlines[i]=newtext(powercfg[i].label,Color3.fromHex("#ffffff"),false,false)end
local hud={timertxt,scraptxt,targettxt,timerlabel,scraplabel,targetlabel}
local function rgbpos()
    local center=anchors();local y=center.Y-108+huddown;local x=center.X-rgbwidth/2;local w=rgbwidth/rgbseg
    for i=1,rgbseg do local d=rgbline[i];d.From=Vector2.new(x+(i-1)*w,y);d.To=Vector2.new(x+i*w+0.5,y) end
end
local function powerpos()
    local _,right=anchors()
    local x,y,n=right.X-50,right.Y,0
    powerlabel.Position=Vector2.new(x,y)
    for i=1,#powerlines do
        local line=powerlines[i]
        if line.Visible then n=n+1;line.Position=Vector2.new(x,y-n*18)end
    end
end
local function hudpos()
    local center=anchors()
    local y=center.Y-150+huddown
    timertxt.Position=Vector2.new(center.X-100,y)
    targettxt.Position=Vector2.new(center.X,y)
    scraptxt.Position=Vector2.new(center.X+100,y)
    timerlabel.Position=Vector2.new(timertxt.Position.X,y+18)
    targetlabel.Position=Vector2.new(targettxt.Position.X,y+18)
    scraplabel.Position=Vector2.new(scraptxt.Position.X,y+18)
    rgbpos();powerpos()
end
hudpos()
local cratenames={FirstAidKit="medkit",Vitamins="vitamin",UV_Lamp="uv_lamp",StunStick="stun",Vest="vest",Tracker="tracker"}
local cratecolors={FirstAidKit=Color3.fromHex("#dbffde"),Vitamins=Color3.fromHex("#d1d3ff"),UV_Lamp=Color3.fromHex("#e694ff"),StunStick=Color3.fromHex("#ffed9d"),Vest=Color3.fromHex("#9fd4ff"),Tracker=Color3.fromHex("#cdceff")}
local cratetext=Color3.fromHex("#ffffff")
local cratebg=Color3.fromHex("#000000")
local cratealpha=0.3
local cratecol,craterow,cratey=55,16,70
local cratepadx,cratepady=28,10
local cratewidth=cratecol*2+cratepadx*2
local espcfg={
    FlareGunPickUp={rootname="FlareGun",text="flare",color=Color3.fromHex("#ff6b6b"),ringradius=2.2,ringyoffset=1},
    BaseCampMSG={directpart=true,text="base",color=Color3.fromHex("#ffffff"),noring=true},
    SafehouseMSG={directpart=true,text="home",color=Color3.fromHex("#ffffff"),textyoffset=25,noring=true},
    StationMSG={directpart=true,text="station",color=Color3.fromHex("#ffffff"),noring=true},
    ShopMSG={directpart=true,text="shop",color=Color3.fromHex("#ffffff"),noring=true},
    ObservationTowerMSG={directpart=true,text="tower",color=Color3.fromHex("#ffffff"),noring=true},
    Scrap1={rootname="Scrap",text="scrap 1",color=Color3.fromHex("#a79266"),ringradius=2.2,ringyoffset=1},
    Scrap2={rootname="Scrap",text="scrap 2",color=Color3.fromHex("#c9aa68"),ringradius=2.2,ringyoffset=1},
    Scrap3={rootname="Scrap",text="scrap 3",color=Color3.fromHex("#dfb65d"),ringradius=2.2,ringyoffset=1},
    Scrap4={rootname="Scrap",text="scrap 4",color=Color3.fromHex("#ecca30"),ringradius=2.2,ringyoffset=1},
    Scrap5={rootname="Scrap",text="scrap 5",color=Color3.fromHex("#ffd000"),ringradius=2.2,ringyoffset=1},
    RakeTrapModel={rootname="HitBox",text="trap",color=Color3.fromHex("#edd2f3"),ringradius=2.2,ringyoffset=0},
    Box={rootname="HitBox",text="supply",color=Color3.fromHex("#e4c3ff"),ringradius=6,ringyoffset=3.2,crate=true},
    SupplyCrate={rootname="HitBox",text="supply",color=Color3.fromHex("#e4c3ff"),ringradius=6,ringyoffset=3.2,crate=true}
}
local tracked={}
local byaddr={}
local function getmodel(inst)
    local current=inst
    while current do if current:IsA("Model")then return current end;current=current.Parent end
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
local function makelabels(rec)
    if rec.name and rec.distance then return end
    rec.name=newtext(rec.cfg.text,rec.cfg.color,true,false)
    rec.distance=newtext("0m",Color3.fromHex("#c9c9c9"),true,false)
end
local function makering(rec)
    if rec.cfg.noring or rec.ring then return end
    rec.ring={}
    for i=1,ringseg do rec.ring[i]=newline(rec.cfg.color)end
end
local function hidering(rec)if rec.ring then for i=1,#rec.ring do hide(rec.ring[i])end end end
local function makecrate(rec)
    if not rec.cfg.crate or rec.items then return end
    rec.bg=newsquare(cratebg,cratealpha);rec.items={}
    for i=1,6 do rec.items[i]=newtext("",cratetext,true,false,false)end
end
local function hiderec(rec)
    hide(rec.name);hide(rec.distance);hidering(rec);hide(rec.bg)
    if rec.items then for i=1,#rec.items do hide(rec.items[i])end end
end
local function removerec(rec)
    remove(rec.name);remove(rec.distance)
    if rec.ring then for i=1,#rec.ring do remove(rec.ring[i])end end
    remove(rec.bg)
    if rec.items then for i=1,#rec.items do remove(rec.items[i])end end
end
local function track(inst)
    if not inst or #tracked>=maxtrack then return end
    local model=getmodel(inst)
    local cfgname,cfg=getcfg(inst,model)
    if not cfg then return end
    local part,rmodel=getpart(inst,model,cfgname,cfg)
    if not part then return end
    local source=rmodel or part
    local address=source.Address
    if not address or byaddr[address]then return end
    local rec={address=address,object=part,model=rmodel or part.Parent,cfgname=cfgname,cfg=cfg,folder=cfg.crate and itemfolder(rmodel)or nil}
    byaddr[address]=rec;tracked[#tracked+1]=rec
end
local function untrack(i)
    local rec=tracked[i]
    if not rec then return end
    removerec(rec);byaddr[rec.address]=nil;tracked[i]=tracked[#tracked];tracked[#tracked]=nil
end
local function scan()
    local filter=ws:FindFirstChild("Filter")
    if filter then
        local spawns=filter:FindFirstChild("ScrapSpawns")
        if spawns then
            local spawnchildren=spawns:GetChildren()
            for i=1,#spawnchildren do
                local spawnpoint=spawnchildren[i]
                if string.match(spawnpoint.Name,"ItemSpawn")then local children=spawnpoint:GetChildren();for j=1,#children do track(children[j])end end
            end
        end
        local points=filter:FindFirstChild("LocationPoints")
        if points then local children=points:GetChildren();for i=1,#children do track(children[i])end end
    end
    local children=ws:GetChildren()
    for i=1,#children do if children[i].Name=="FlareGunPickUp"then track(children[i])end end
    local debris=ws:FindFirstChild("Debris")
    if debris then
        local traps=debris:FindFirstChild("Traps")
        if traps then local c=traps:GetChildren();for i=1,#c do track(c[i])end end
        local crates=debris:FindFirstChild("SupplyCrates")
        if crates then local c=crates:GetChildren();for i=1,#c do track(c[i])end end
    end
end
local function viewpos()
    local char=lp.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return root and root:IsA("BasePart")and root.Position or cam.Position
end
local function dist(a,b)
    local x,y,z=b.X-a.X,b.Y-a.Y,b.Z-a.Z
    return math.sqrt(x*x+y*y+z*z)*stud2m
end
local function drawcrate(rec,screen,meters,yoffset)
    if not rec.cfg.crate then return end
    if not rec.folder then rec.folder=itemfolder(rec.model)end
    if meters>cratedist or not rec.folder then
        hide(rec.bg);if rec.items then for i=1,#rec.items do hide(rec.items[i])end end;return
    end
    makecrate(rec)
    local children=rec.folder:GetChildren()
    local visible=math.min(#children,#rec.items)
    for i=1,#rec.items do
        local d,child=rec.items[i],children[i]
        if child then
            local n=i-1;local row=math.floor(n/3);local col=n%3
            d.Text=cratenames[child.Name]or child.Name;d.Color=cratecolors[child.Name]or cratetext
            d.Position=Vector2.new(screen.X+(col-1)*cratecol,screen.Y-12+yoffset+row*craterow+cratey);d.Visible=true
        else d.Visible=false end
    end
    if visible>0 then
        local rows=math.max(1,math.ceil(visible/3));local firsty=screen.Y-12+yoffset+cratey;local miny=firsty-8-cratepady
        rec.bg.Size=Vector2.new(cratewidth,(rows-1)*craterow+16+cratepady*2);rec.bg.Position=Vector2.new(screen.X-cratewidth/2,miny);rec.bg.Visible=true
    else rec.bg.Visible=false end
end
local function drawring(rec,world,meters)
    if rec.cfg.noring then return end
    if meters>=ringfade then hidering(rec);return end
    makering(rec)
    local y=world.Y-(rec.cfg.ringyoffset or 0);local radius=rec.cfg.ringradius or 2;local alpha=clamp(1-meters/ringfade,0,1);local step=2*math.pi/ringseg
    for i=1,ringseg do
        local a=(i-1)*step;local b=i*step
        local sa,ona=WorldToScreen(Vector3.new(world.X+math.cos(a)*radius,y,world.Z+math.sin(a)*radius))
        local sb,onb=WorldToScreen(Vector3.new(world.X+math.cos(b)*radius,y,world.Z+math.sin(b)*radius))
        local line=rec.ring[i]
        if toggle.esp and ona and onb then line.From=sa;line.To=sb;line.Color=rec.cfg.crate and Color3.fromHex("#8f8f8f")or rec.cfg.color;line.Transparency=alpha;line.Visible=true else line.Visible=false end
    end
end
local function drawrec(rec,viewer)
    local object=rec.object
    if not object or not object.Parent then return false end
    local world=object.Position
    local screen,on=WorldToScreen(world)
    if not on then hiderec(rec);return true end
    local meters=dist(viewer,world);local yoffset=rec.cfg.textyoffset or 0
    makelabels(rec)
    local alpha=clamp(1-meters/espfade,0.15,1)
    rec.name.Position=Vector2.new(screen.X,screen.Y-12+yoffset);rec.name.Transparency=alpha;rec.name.Color=rec.cfg.crate and rgb(0)or rec.cfg.color;rec.name.Visible=toggle.esp
    rec.distance.Position=Vector2.new(screen.X,screen.Y+0.7+yoffset);rec.distance.Text=tostring(math.floor(meters)).."m";rec.distance.Transparency=alpha*0.85;rec.distance.Visible=toggle.esp and meters>=20
    drawcrate(rec,screen,meters,yoffset);drawring(rec,world,meters)
    return true
end
local raketarget=nil
local rakeroof=nil
local rakehp=nil
local function rakeinfo()
    local rake=ws:FindFirstChild("Rake")
    raketarget=rake and rake:FindFirstChild("TargetVal")or nil
    local map=ws:FindFirstChild("Map");local safehouse=map and map:FindFirstChild("SafeHouse");local rakebreak=safehouse and finddesc(safehouse,"RakeBreak");local breakmodel=rakebreak and finddesc(rakebreak,"BreakModel");local health=breakmodel and finddesc(breakmodel,"Health")
    if breakmodel and health and health:IsA("IntValue")then rakeroof=breakmodel;rakehp=health;roofhp.Text=tostring(health.Value).."/30" else rakeroof=nil;rakehp=nil end
end
local function getchar(part)
    local current=part
    while current do if current:FindFirstChild("Humanoid")then return current end;current=current.Parent end
end
local function drawroof()
    if not toggle.esp or not rakeroof or not rakehp then rooflabel.Visible=false;roofhp.Visible=false;return end
    local part=findclass(rakeroof,"BasePart")
    if not part then rooflabel.Visible=false;roofhp.Visible=false;return end
    local screen,on=WorldToScreen(part.Position)
    if not on then rooflabel.Visible=false;roofhp.Visible=false;return end
    roofhp.Text=tostring(rakehp.Value).."/30";roofhp.Color=Color3.fromHex("#ebebeb");rooflabel.Position=Vector2.new(screen.X,screen.Y-15);roofhp.Position=Vector2.new(screen.X,screen.Y-3);rooflabel.Visible=true;roofhp.Visible=true
end
local function powerhud()
    local any=false
    for i=1,#powercfg do
        local entry=powercfg[i];local value=powervals:FindFirstChild(entry.valuename);local active=value and value.Value==true
        powerlines[i].Visible=toggle.hud and active or false;if powerlines[i].Visible then any=true end
    end
    powerlabel.Visible=toggle.hud and any;powerpos()
end
local function targethud()
    local target=raketarget and raketarget.Value or nil
    if target and typeof(target)=="Instance"and target:IsA("BasePart")then local char=getchar(target);targettxt.Text=char and char.Name or "unknown" else targettxt.Text="none" end
end
local function scraphud()
    local backpack=lp:FindFirstChild("Backpack")or lp:FindFirstChild("backpack");local folder=backpack and backpack:FindFirstChild("ScrapFolder");local points=folder and folder:FindFirstChild("Points")
    scraptxt.Text=points and points:IsA("IntValue")and tostring(points.Value)or"0"
end
local function timerhud()
    local timer=math.max(0,math.floor(tonumber(timerval.Value)or 0));timertxt.Text=string.format("%d:%02d",math.floor(timer/60),timer%60);timertxt.Color=timer<=15 and Color3.fromHex("#fc8f8f")or Color3.fromHex("#ffffff")
end
local function showhud()
    for i=1,#hud do hud[i].Visible=toggle.hud end
    for i=1,#rgbline do rgbline[i].Visible=toggle.hud end
    powerhud()
end
local function drawrgb()
    for i=1,#rgbline do local d=rgbline[i];d.Color=rgb((i-1)/rgbseg);d.Visible=toggle.hud end
end
local function tpscrap()
    local char=lp.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart")then return false end
    for i=1,#tracked do
        local rec=tracked[i]
        if rec.cfgname and string.match(rec.cfgname,"^Scrap%d+$")then
            local dest=rec.model and findclass(rec.model,"BasePart")
            if dest then root.Position=dest.Position;return true end
        end
    end
    return false
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
local function keys()
    local f1,f2,f3,f4=iskeypressed(0x70),iskeypressed(0x71),iskeypressed(0x72),iskeypressed(0x73)
    if f1 and not keyheld.f1 then
        toggle.esp=not toggle.esp
        if not toggle.esp then
            for i=1,#tracked do hiderec(tracked[i])end
            rooflabel.Visible=false;roofhp.Visible=false
        end
        bindlog(toggle.esp and "enabled esp"or"disabled esp")
    end
    if f2 and not keyheld.f2 then
        toggle.hud=not toggle.hud;showhud()
        bindlog(toggle.hud and "enabled hud"or"disabled hud")
    end
    if f3 and not keyheld.f3 then
        local ok=tpscrap()
        bindlog(ok and "teleported to scrap"or"scrap not found")
    end
    if f4 and not keyheld.f4 then
        local ok=tpflare()
        bindlog(ok and "teleported to flare"or"flare not found")
    end
    keyheld.f1,keyheld.f2,keyheld.f3,keyheld.f4=f1,f2,f3,f4
end
local function drawesp()
    keys()
    if not toggle.esp then return end
    local viewer=viewpos();local i=#tracked
    while i>=1 do local rec=tracked[i];local ok,alive=pcall(function()return drawrec(rec,viewer)end);if not ok or not alive then untrack(i)end;i=i-1 end
    drawroof()
end
local lastx,lasty=cam.ViewportSize.X,cam.ViewportSize.Y
spawn(function()
    while true do
        local v=cam.ViewportSize
        if v.X~=lastx or v.Y~=lasty then lastx,lasty=v.X,v.Y;hudpos()end
        timerhud();task.wait(hudrate)
    end
end)
spawn(function()while true do scraphud();powerhud();targethud();task.wait(statusrate)end end)
spawn(function()
    while true do
        pcall(function()scan();rakeinfo()end)
        task.wait(scanrate)
    end
end)
spawn(function()
    while true do
        pcall(drawesp);pcall(drawrgb)
        task.wait()
    end
end)
print("view post for keybinds, version "..version)
