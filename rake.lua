local players=game:GetService("Players")
local rs=game:GetService("ReplicatedStorage")
local ws=game:GetService("Workspace")
local http=game:GetService("HttpService")
local lp=players.LocalPlayer
local cam=ws.CurrentCamera
local mouse=lp and lp:GetMouse()or nil
local fontnames={"default","system","system bold","minecraft","monospace","pixel","fortnite"}
local fontvalues={Drawing.Fonts.UI,Drawing.Fonts.System,Drawing.Fonts.SystemBold,Drawing.Fonts.Minecraft,Drawing.Fonts.Monospace,Drawing.Fonts.Pixel,Drawing.Fonts.Fortnite}
local fontindex=1
local font=fontvalues[fontindex]
local stud2m=1/3.5714285714
local scanrate,hudrate,statusrate=0.5,0.05,0.1
local ringfade,ringseg,cratedist,maxtrack=40,100,30,256
local toggle={esp=true,hud=true,distance=false,distancefade=false,menu=false,watermark=true,guitextoutline=true,esptextoutline=true,barrgb=true,roof=false,distanceunit="meters",distanceposition="below",poweractivity=true,poweractivitymode="activity",hudstyle="container",scrapstyle="default",scrapteleport="value",supplylabel=true,supplyitems=true,ringenabled=true,ringshape="circle",ringsize=1,ringspin=false,ringspinspeed=1,rgbdirection="left",powerformat="percent",powerdecimal=true,timerformat="clock",timerwarning=15,timerwarningenabled=false,hudfontindex=1,teleportcooldown=false,cooldownseconds=30,cooldownuntil=0,cooldownremaining=0,teleporthistory={},ppms=true,ppmsstyle="voltmeter",ppmssquares=5,rakename=true,rakehealth=true,rakedistance=false,rakenamevalue="rake",rakenamey=0,rakehealthy=0,rakehealthformat="value",rakebarwidth=70,rakenamecapture=false,killaura=false,killaurarange=12,killauradelay=0.12,killauranext=0,killpartnames={"Head","Torso","UpperTorso","LowerTorso","HumanoidRootPart"},sellenabled=true,scrapteleportenabled=true,flareteleportenabled=true,hudelements={timer=true,target=true,scrap=true,power=true}}
toggle.hudlabels=true;toggle.distanceminimum=false;toggle.distancemin=20;toggle.healthbased=false;toggle.ppmslevel=0;toggle.poweravailable=true;toggle.ppmspowerblocked=false
toggle.client={noJumpCooldown=false,infiniteStamina=false,noFall=false}
toggle.clientlabels={noJumpCooldown="no jump cooldown",infiniteStamina="infinite stamina",noFall="no fall damage"}
toggle.clientgcnames={"vars","canMove","can_jump","can_jump2","lastJump","handlingSRegen","regeningS","stamina","MAX_STAMINA"}
toggle.clientgc={cache={},bykey={},valid=false,scanning=false,nextapply=0,nextscan=0,scanfailures=0,applyfailures=0,misses=0,recoveries=0,stableat=nil,lastscan=0,character=lp and lp.Character or nil,characterkey=nil,rescanat=nil,maxstamina=100}
toggle.nofall={size=Vector3.new(100000,100000,100000),originals=setmetatable({},{__mode="k"}),nextapply=0}
toggle.zoom={thirdperson=false,amount=10,min=0,max=0,originalmin=nil,originalmax=nil,memoryvalid=false,directvalid=false,nextapply=0,minoffset=0x36C,maxoffset=0x368}
toggle.shiftlockstate={offset=nil,active=false,nextapply=0}
toggle.instacrate=false;toggle.instacratestate={nextapply=0,lastbox=nil,lastopen=0,range=25,unlockoffset=nil,patched=setmetatable({},{__mode="k"})}
toggle.shop={
    items={{name="StunStick",label="stunstick",price=900},{name="UV_Lamp",label="uv lamp",price=700},{name="Vest",label="vest",price=450},{name="Monitor",label="monitor",price=300},{name="RakeTrap",label="trap",price=250},{name="Tracker",label="tracker",price=200},{name="Toolbox",label="toolbox",price=140},{name="Vitamins",label="vitamin",price=80},{name="FirstAidKit",label="medkit",price=70},{name="Voltmeter",label="voltmeter",price=60},{name="Watch",label="watch",price=45},{name="Compass",label="compass",price=30},{name="Map",label="map",price=20}},
    names={"stunstick","uv lamp","vest","monitor","trap","tracker","toolbox","vitamin","medkit","voltmeter","watch","compass","map"},
    lookup={},
    selected="Map",lastscan=0
}
toggle.borderradius=10
toggle.offseturl="https://offsets.ntgetwritewatch.workers.dev/offsets.hpp"
toggle.offsettext=nil;toggle.offsetloaded=false;toggle.offsetretry=0
toggle.white=Color3.fromHex("#ffffff");toggle.ringrgbcolor=Color3.fromHex("#d8d8d8");toggle.warningred=Color3.fromHex("#ff3b3b");toggle.infoorange=Color3.fromHex("#f2a93b");toggle.permissionblue=Color3.fromHex("#66ccff");toggle.permissionpink=Color3.fromHex("#ff76c8");toggle.ringunit={}
toggle.playerdisplayname=lp and(lp.DisplayName or lp.Name)or"player"
toggle.distancestyle={labelcolor=Color3.fromHex("#c9c9c9"),defaultcolor=Color3.fromHex("#c9c9c9"),rgb=false,defaultrgb=false}
toggle.cooldownstyle={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false}
toggle.cooldownvaluestyle={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false}
toggle.ppmslabelstyle={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false}
toggle.ppmsvaluestyle={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false}
toggle.voltmeterstyles={
    {labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false},
    {labelcolor=Color3.fromHex("#fffbe0"),defaultcolor=Color3.fromHex("#fffbe0"),rgb=false,defaultrgb=false},
    {labelcolor=Color3.fromHex("#fff6c1"),defaultcolor=Color3.fromHex("#fff6c1"),rgb=false,defaultrgb=false},
    {labelcolor=Color3.fromHex("#ffdda6"),defaultcolor=Color3.fromHex("#ffdda6"),rgb=false,defaultrgb=false},
    {labelcolor=Color3.fromHex("#ffb897"),defaultcolor=Color3.fromHex("#ffb897"),rgb=false,defaultrgb=false}
}
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
    power={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false},
    warning={labelcolor=Color3.fromHex("#fc8f8f"),defaultcolor=Color3.fromHex("#fc8f8f"),rgb=false,defaultrgb=false}
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
espgroups.items={BaseCampMSG=true,SafehouseMSG=true,StationMSG=true,ShopMSG=true,ObservationTowerMSG=true,Scrap1=true,Scrap2=true,Scrap3=true,Scrap4=true,Scrap5=true}
local espfontsize=13
local guiopacity=0.8
local espcfg={}
local roofstyle={labelcolor=Color3.fromHex("#f5d3ff"),defaultcolor=Color3.fromHex("#f5d3ff"),rgb=false,defaultrgb=false}
toggle.rakestyle={labelcolor=Color3.fromHex("#ff5252"),defaultcolor=Color3.fromHex("#ff5252"),rgb=false,defaultrgb=false}
toggle.rakehealthstyle={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false}
toggle.rakebarstyle={labelcolor=Color3.fromHex("#ff5252"),defaultcolor=Color3.fromHex("#ff5252"),rgb=false,defaultrgb=false}
local colorentries={
    {name="flare",cfgs={"FlareGunPickUp"}},{name="scrap 1",cfgs={"Scrap1"}},{name="scrap 2",cfgs={"Scrap2"}},{name="scrap 3",cfgs={"Scrap3"}},{name="scrap 4",cfgs={"Scrap4"}},{name="scrap 5",cfgs={"Scrap5"}},{name="trap",cfgs={"RakeTrapModel"}},{name="supply",cfgs={"Box","SupplyCrate"}},
    {name="base",cfgs={"BaseCampMSG"}},{name="house",cfgs={"SafehouseMSG"}},{name="station",cfgs={"StationMSG"}},{name="shop",cfgs={"ShopMSG"}},{name="tower",cfgs={"ObservationTowerMSG"}}
}
local defaultbinds={menu=0x43,esp=0,hud=0,scrap=0,flare=0,aura=0,sell=0}
local keybinds={menu=defaultbinds.menu,esp=defaultbinds.esp,hud=defaultbinds.hud,scrap=defaultbinds.scrap,flare=defaultbinds.flare,aura=defaultbinds.aura,sell=defaultbinds.sell}
local bindorder={"menu","esp","hud","scrap","flare","aura","sell"}
local bindlabels={menu="menu toggle",esp="esp toggle",hud="hud toggle",scrap="tp to scrap",flare="tp to flare",aura="stun aura",sell="tp to sell"}
local keyoptions,keynames,keywas={},{},{}
local function addkey(code,name)keyoptions[#keyoptions+1]={code=code,name=name};keynames[code]=name;keywas[code]=false end
addkey(0x08,"backspace");addkey(0x09,"tab");addkey(0x0D,"enter");addkey(0x10,"shift");addkey(0x11,"ctrl");addkey(0x12,"alt");addkey(0x1B,"escape");addkey(0x20,"space")
addkey(0x21,"page up");addkey(0x22,"page down");addkey(0x23,"end");addkey(0x24,"home");addkey(0x25,"left");addkey(0x26,"up");addkey(0x27,"right");addkey(0x28,"down");addkey(0x2D,"insert");addkey(0x2E,"delete")
for i=0x30,0x39 do addkey(i,string.char(i))end
for i=0x41,0x5A do addkey(i,string.char(i))end
for i=0,11 do addkey(0x70+i,"F"..tostring(i+1))end
addkey(0xBA,";");addkey(0xBB,"=");addkey(0xBC,",");addkey(0xBD,"-");addkey(0xBE,".");addkey(0xBF,"/");addkey(0xC0,"`");addkey(0xDB,"[");addkey(0xDC,"\\");addkey(0xDD,"]");addkey(0xDE,"'")
toggle.bindname=function(id)return keynames[keybinds[id]]or"none"end
toggle.bindinfo="bind selector: click to change; press backspace to remove"
local function clamp(value,minv,maxv)return math.max(minv,math.min(maxv,value))end
toggle.drawcolors=setmetatable({},{__mode="k"})
toggle.pixel=function(value)return math.floor((tonumber(value)or 0)+0.5)end
toggle.textwidth=function(d)return #(d.Text or"")*7 end
toggle.gradientinset=function()return math.max(3,math.ceil((toggle.borderradius or 0)*0.6))end
toggle.setpos=function(d,x,y)
    if not d then return end
    x=tonumber(x)or 0;y=tonumber(y)or 0;local p=d.Position
    if not p or math.abs(p.X-x)>=0.7 or math.abs(p.Y-y)>=0.7 then local px,py=toggle.pixel(x),toggle.pixel(y);if not p or p.X~=px or p.Y~=py then d.Position=Vector2.new(px,py)end end
end
toggle.setprop=function(d,key,value)if d then if d[key]~=value then d[key]=value end;if key=="Color"then toggle.drawcolors[d]=value end end end
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
if not cam or not lp or not mouse then return end

local timerval=waitchild(rs,"Timer",15)
local powervals=waitchild(rs,"PowerValues",15)
if not timerval or not powervals then return end
toggle.powerlevel=powervals:FindFirstChild("PowerLevel")
toggle.ppmsobject=powervals:FindFirstChild("PPMS")
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
toggle.offsetstructvalue=function(structname,name)
    local source=toggle.offsettext;if type(source)~="string"then return nil end
    local block=string.match(source,"struct%s+"..structname.."%s*:%s*[%w_:]+%s*{(.-)%s*};");if type(block)~="string"then return nil end
    local value=string.match(block,"%s"..name.."%s*=%s*(0x[%da-fA-F]+)");return value and tonumber(value)or nil
end
toggle.offsetvalue=function(name)return toggle.offsetstructvalue("Player",name)end
toggle.loadoffsets=function(force)
    local now=tick();if not force and toggle.offsetloaded and toggle.shiftlockstate.offset and toggle.instacratestate.unlockoffset then return true end;if not force and now<(toggle.offsetretry or 0)then return false end
    local ok,source=pcall(function()return game:HttpGet(toggle.offseturl)end)
    if not ok or type(source)~="string"or #source<100 then toggle.offsetretry=now+10;return false end
    toggle.offsettext=source
    local minimum=toggle.offsetvalue("CameraMinZoomDistance");local maximum=toggle.offsetvalue("CameraMaxZoomDistance");local shiftlock=toggle.offsetvalue("DevEnableMouseLock");local unlockvalue=toggle.offsetstructvalue("DoubleConstrainedValue","Value")
    local minimumok=type(minimum)=="number"and minimum>0 and minimum<0x10000;local maximumok=type(maximum)=="number"and maximum>0 and maximum<0x10000;local shiftlockok=type(shiftlock)=="number"and shiftlock>0 and shiftlock<0x10000;local unlockok=type(unlockvalue)=="number"and unlockvalue>0 and unlockvalue<0x10000
    if minimumok then toggle.zoom.minoffset=minimum end;if maximumok then toggle.zoom.maxoffset=maximum end;if shiftlockok then toggle.shiftlockstate.offset=shiftlock end;if unlockok then toggle.instacratestate.unlockoffset=unlockvalue end
    toggle.offsetloaded=minimumok and maximumok and shiftlockok and unlockok;toggle.offsetretry=toggle.offsetloaded and 0 or now+10
    return toggle.offsetloaded
end
toggle.applyshiftlock=function()
    local state=toggle.shiftlockstate;if not state.active then return false end;local now=tick();if now<(state.nextapply or 0)then return true end;state.nextapply=now+0.1;if not state.offset then toggle.loadoffsets(false)end
    local address=toggle.instanceaddress(lp);if not address or not state.offset then return false end
    return toggle.memorywrite("byte",address+state.offset,1)
end
toggle.fastcrateprompt=function(prompt)
    if not prompt then return false end
    local ok=pcall(function()
        if not prompt:IsA("ProximityPrompt")then assert(false,"bad prompt")end
        prompt.Enabled=true;prompt.HoldDuration=0;prompt.RequiresLineOfSight=false;prompt.ClickablePrompt=true;prompt.MaxActivationDistance=toggle.instacratestate.range
        prompt:SetAttribute("ODistance",toggle.instacratestate.range)
        prompt:SetAttribute("Busy",false);prompt:SetAttribute("Busy2",false);prompt:SetAttribute("Unavailable",false);prompt:SetAttribute("Unavailable2",false)
    end)
    return ok
end
toggle.findcrateprompt=function(root)
    if not root then return nil end
    local prompt=root:FindFirstChild("ProximityPrompt")or root:FindFirstChildWhichIsA("ProximityPrompt");if prompt then return prompt end
    local ok,descendants=pcall(function()return root:GetDescendants()end);if not ok or type(descendants)~="table"then return nil end
    for i=1,#descendants do local object=descendants[i];local isprompt=false;pcall(function()isprompt=object:IsA("ProximityPrompt")end);if isprompt then return object end end
end
toggle.writecrateunlock=function(unlock)
    if not unlock then return false end
    local direct=pcall(function()unlock.Value=100 end);local state=toggle.instacratestate
    if not state.unlockoffset then toggle.loadoffsets(false)end
    local address=toggle.instanceaddress(unlock);local offset=state.unlockoffset;if not address or not offset then return direct end
    local target=address+offset;local current=toggle.memoryread("double",target)
    if type(current)~="number"or current~=current or math.abs(current)>1000000000 then return direct end
    local wrote=true;if math.abs(current-100)>0.0001 then wrote=toggle.memorywrite("double",target,100)end
    if not wrote then return direct end
    local result=toggle.memoryread("double",target);return type(result)=="number"and math.abs(result-100)<0.0001 or direct
end
toggle.fastdrop=function(box)
    if not box then return nil end
    local gui=box:FindFirstChild("GUIPart");local prompt=toggle.findcrateprompt(gui);if not prompt then prompt=toggle.findcrateprompt(box)end
    local promptok=toggle.fastcrateprompt(prompt);local unlock=box:FindFirstChild("UnlockValue");local unlockok=toggle.writecrateunlock(unlock)
    return gui,prompt,promptok,unlockok
end
toggle.dropboxes=function(root)
    local boxes,seen={},{};if not root then return boxes end
    local function add(object)if object and not seen[object]and object.Name=="Box"then seen[object]=true;boxes[#boxes+1]=object end end
    add(root:FindFirstChild("Box"));local children=root:GetChildren();for i=1,#children do local child=children[i];add(child);if child.Name~="Box"then add(child:FindFirstChild("Box"))end end
    if #boxes==0 then local ok,descendants=pcall(function()return root:GetDescendants()end);if ok and type(descendants)=="table"then for i=1,#descendants do add(descendants[i])end end end
    return boxes
end
toggle.applyinstacrate=function(force)
    if not toggle.instacrate then return false end
    local state=toggle.instacratestate;local now=tick();if not force and now<(state.nextapply or 0)then return true end;state.nextapply=now+0.35
    local debris=ws:FindFirstChild("Debris");local crates=debris and(debris:FindFirstChild("SupplyCrates")or debris:FindFirstChild("SupplyCreates"));if not crates then return false end
    if not state.unlockoffset then toggle.loadoffsets(false)end
    local character=lp.Character;local root=character and character:FindFirstChild("HumanoidRootPart");if not root or not root:IsA("BasePart")then state.lastbox=nil;return false end
    local boxes=toggle.dropboxes(crates);local nearest,nearestdistance,nearestunlock=nil,math.huge,false
    for i=1,#boxes do
        local box=boxes[i];local gui,prompt,promptok,unlockok=toggle.fastdrop(box);state.patched[box]=promptok and unlockok
        local part=gui and gui:IsA("BasePart")and gui or box:FindFirstChildWhichIsA("BasePart")
        if part then local delta=part.Position-root.Position;local distance=math.sqrt(delta.X*delta.X+delta.Y*delta.Y+delta.Z*delta.Z);if distance<nearestdistance then nearest,nearestdistance,nearestunlock=box,distance,unlockok end end
    end
    if not nearest or nearestdistance>state.range then state.lastbox=nil;return false end
    if not nearestunlock then return false end
    if not force and state.lastbox==nearest and now-(state.lastopen or 0)<0.8 then return true end
    local remote;local remoteok=pcall(function()remote=game.ReplicatedStorage:FindFirstChild("SupplyClientEvent")end);if not remoteok or not remote then return false end
    local opened=pcall(function()game.ReplicatedStorage.SupplyClientEvent:FireServer("Open",true)end)
    if opened then state.lastbox=nearest;state.lastopen=now end
    return opened
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
    local state=toggle.zoom;local now=tick();if not force and now<(state.nextapply or 0)then return true end;state.nextapply=now+0.2
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
toggle.gethaystack=function()
    local filter=ws:FindFirstChild("Filter");local haystack=filter and filter:FindFirstChild("Haystack")or nil;local ok,ispart=pcall(function()return haystack and haystack:IsA("BasePart")end);return ok and ispart and haystack or nil
end
toggle.applynofall=function(enabled,force)
    local state=toggle.nofall;local now=tick();if enabled and not force and now<(state.nextapply or 0)then return true end;state.nextapply=now+0.5
    if enabled then
        local haystack=toggle.gethaystack();if not haystack then return false end
        if state.originals[haystack]==nil then local ok,size=pcall(function()return haystack.Size end);if ok and size then state.originals[haystack]=size end end
        return pcall(function()if haystack.Size~=state.size then haystack.Size=state.size end end)
    end
    local restored=false;for haystack,size in pairs(state.originals)do local ok=pcall(function()haystack.Size=size end);restored=ok or restored end;return restored
end
toggle.capturezoom()
toggle.indexclientgc=function(cache)
    local indexed={};for i=1,#cache do local entry=cache[i];if type(entry)=="table"and type(entry.key)=="string"then local list=indexed[entry.key];if not list then list={};indexed[entry.key]=list end;list[#list+1]=entry end end;toggle.clientgc.bykey=indexed
end
toggle.compactclientgc=function(cache)
    local compact={};for i=1,#cache do local entry=cache[i];if type(entry)=="table"and type(entry.key)=="string"then local keep=entry.key~="vars";if not keep and type(entry.value)=="table"then local vars=entry.value;keep=rawget(vars,"canMove")~=nil or rawget(vars,"can_jump")~=nil or rawget(vars,"can_jump2")~=nil or rawget(vars,"lastJump")~=nil or rawget(vars,"handlingSRegen")~=nil or rawget(vars,"regeningS")~=nil or rawget(vars,"stamina")~=nil or rawget(vars,"MAX_STAMINA")~=nil end;if keep then compact[#compact+1]=entry end end end;return #compact>0 and compact or cache
end
toggle.refreshclientgc=function(force)
    local state=toggle.clientgc;local now=tick();if state.valid and not force then return true end;if state.scanning then return false end;if type(getgc)~="function"then state.rescanat=nil;return false end;if now<(state.nextscan or 0)then return false end
    state.scanning=true;local ok,cache=pcall(getgc,toggle.clientgcnames);state.scanning=false
    if not ok or type(cache)~="table"then state.valid=false;state.scanfailures=(state.scanfailures or 0)+1;state.nextscan=now+math.min(2+state.scanfailures*2,10);state.rescanat=state.scanfailures<3 and state.nextscan or nil;return false end
    cache=toggle.compactclientgc(cache);state.cache=cache;toggle.indexclientgc(cache);state.valid=true;state.character=lp.Character;state.characterkey=toggle.instanceaddress(state.character)or state.character;state.rescanat=nil;state.nextscan=now+2;state.scanfailures=0;state.applyfailures=0;state.misses=0;state.stableat=nil;state.lastscan=now;state.nextapply=0;state.maxstamina=100
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
    if toggle.client.noFall then toggle.applynofall(true,rescan==true)end
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
local alltexts={}
local function newtext(text,color,center,visible,outline)
    local d=Drawing.new("Text")
    d.Text=text or "";d.Color=color or Color3.fromHex("#ffffff");d.Center=center==true;d.Visible=visible==true;d.Outline=outline~=false;d.Font=fontvalues[1]
    alltexts[#alltexts+1]=d
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
local function newborder(color,thickness)
    local d=Drawing.new("Square")
    d.Color=color;d.Transparency=1;d.Filled=false;d.Thickness=thickness or 1;d.Visible=false;d.Position=Vector2.new(0,0);d.Size=Vector2.new(1,1)
    return d
end
function setz(d,z)if d then pcall(function()d.ZIndex=z end)end;return d end
local function remove(d)
    if not d then return end
    pcall(function()d.Visible=false;d:Remove()end)
end
local function hide(d)if d and d.Visible then d.Visible=false end end
toggle.setvisible=function(d,value)if d and d.Visible~=(value==true)then d.Visible=value==true end end
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
toggle.powerdraw={value=newtext("0",Color3.fromHex("#ffffff"),true,true),label=newtext("power",Color3.fromHex("#aaaaaa"),true,true)}
toggle.cooldowndraw={value=newtext("0s",Color3.fromHex("#ffffff"),true,false),label=newtext("cooldown",Color3.fromHex("#aaaaaa"),true,false)}
toggle.ppmsdraw={value=newtext("0",Color3.fromHex("#ffffff"),true,false),label=newtext("voltmeter",Color3.fromHex("#aaaaaa"),true,false),squares={},borders={}}
for i=1,5 do toggle.ppmsdraw.squares[i]=newsquare(toggle.voltmeterstyles[i].labelcolor,1);toggle.ppmsdraw.borders[i]=newsquare(Color3.fromHex("#050505"),0.48)end
toggle.rakedraw={name=newtext("rake",toggle.rakestyle.labelcolor,true,false),health=newtext("400",toggle.rakehealthstyle.labelcolor,true,false),distance=newtext("0m",toggle.distancestyle.labelcolor,true,false),barbg=newsquare(Color3.fromHex("#090909"),0.78),barfill=newsquare(toggle.rakebarstyle.labelcolor,1),barborder=newborder(Color3.fromHex("#050505"),1)}
for i=1,24 do toggle.rakedraw["gradient"..i]=newsquare(toggle.rakebarstyle.labelcolor,1)end
local powerlabel=newtext("power activity",Color3.fromHex("#ffffff"),false,false)
local rooflabel=newtext("roof",Color3.fromHex("#f5d3ff"),true,false)
local roofhp=newtext("",Color3.fromHex("#ebebeb"),true,false)
local logtxt=newtext("",Color3.fromHex("#ffffff"),true,false)
logtxt.Size=13
local function bindlog(text)
    toggle.logid=(toggle.logid or 0)+1
    local id=toggle.logid
    local center=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
    logtxt.Text="[!] "..text
    logtxt.Color=Color3.fromHex("#ffffff")
    logtxt.Position=center
    logtxt.Transparency=1
    logtxt.Visible=true
    local w=math.max(110,#logtxt.Text*7)
    spawn(function()
        task.wait(0.5)
        if id==toggle.logid then
            logtxt.Visible=false
        end
    end)
end
local barseg,rgbwidth,rgbspeed,rgbspread=72,420,0.6,0.28
local function rgb(offset)
    offset=offset or 0
    local frame=toggle.gradientcache and toggle.gradientcache.frame or-1
    if offset==0 and toggle.rgbbaseframe==frame and toggle.rgbbase then return toggle.rgbbase end
    local value=Color3.fromHSV(((toggle.rgbphase or((tick()*rgbspeed)*(toggle.rgbdirection=="left"and 1 or-1)))+offset)%1,0.68,1)
    if offset==0 then toggle.rgbbaseframe=frame;toggle.rgbbase=value end
    return value
end
local rgbline={}
for i=1,barseg do rgbline[i]=newline(Color3.fromHSV((i-1)/barseg*rgbspread,0.68,1));rgbline[i].Thickness=2 end
local themes={
    {name="signal bruise",bg="#151426",top="#090812",side="#102b27",card="#25213c",hover="#393158",select="#574b7b",text="#f8efff",muted="#9a8db4",accent="#ff4fd8"},
    {name="monochrome",bg="#202020",top="#171717",side="#121212",card="#2b2b2b",hover="#363636",select="#4b4b4b",text="#eeeeee",muted="#858585",accent="#d4d4d4"},
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
local menustate={w=392,h=470,watermarkw=100,watermarkh=27,x=24,y=math.floor((cam.ViewportSize.Y-470)/2),tab=1,minimized=false,minimizeanim=0,menuanim=0,contentfade=1,maxitems=96,scroll={},scrolltarget={},scrollmax={},itemkinds={},hover={},toggleanim={},slideranim={},tabfade=1,tabslide=0,indicatorx=nil,indicatorw=nil,itemsdirty=true}
local tabnames={"main","visuals","misc"}
local menubg=newsquare(Color3.fromHex("#16161e"),0.98)
local menutop=newsquare(Color3.fromHex("#1a1b26"),1)
local menuside=newsquare(Color3.fromHex("#13131a"),1)
local menuchrome={border=newborder(Color3.fromHex("#343b46"),1),content=newborder(Color3.fromHex("#272c35"),1),divider=newline(Color3.fromHex("#272c35")),columns={newsquare(Color3.fromHex("#06090c"),1),newsquare(Color3.fromHex("#06090c"),1)},columnborders={newborder(Color3.fromHex("#272c35"),1),newborder(Color3.fromHex("#272c35"),1)},scrolltrack=newsquare(Color3.fromHex("#090b0e"),0.8),scrollthumb=newsquare(Color3.fromHex("#99C30B"),1),scrollborder=newborder(Color3.fromHex("#272c35"),1),tabindicator=newsquare(Color3.fromHex("#99C30B"),1)}
menuchrome.divider.Thickness=1
for _,entry in ipairs({{menubg,0},{menutop,0},{menuchrome.border,0},{menuchrome.columnborders[1],1},{menuchrome.columnborders[2],2}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end
toggle.menutitle=function()return"rake's saint"end
local menutitle=newtext(toggle.menutitle(),Color3.fromHex("#ffffff"),false,false)
menutitle.Size=13
menustate.watermarkw=math.min(menustate.w,math.max(100,#menutitle.Text*7+28))
local menuclose=newtext("-",Color3.fromHex("#787c99"),true,false)
for _,d in ipairs({menubg,menutop,menuside,menuchrome.content,menuchrome.divider,menuchrome.columns[1],menuchrome.columns[2]})do setz(d,100)end;setz(menuchrome.border,138);setz(menuchrome.columnborders[1],138);setz(menuchrome.columnborders[2],138);setz(menuchrome.scrolltrack,130);setz(menuchrome.scrollthumb,132);setz(menuchrome.scrollborder,131);setz(menuchrome.tabindicator,119);setz(menutitle,121);setz(menuclose,121)
local tabbg,tabtext,tabborder={},{},{}
for i=1,#tabnames do tabbg[i]=setz(newsquare(Color3.fromHex("#202330"),1),112);tabborder[i]=setz(newborder(Color3.fromHex("#272c35"),1),113);tabtext[i]=setz(newtext(tabnames[i],Color3.fromHex("#ffffff"),true,false),121);tabtext[i].Size=13 end
local itembg,itemlabel,itemvalue,itemmark,itemline,itemtrack,itemfill,itemborder,markborder,trackborder={},{},{},{},{},{},{},{},{},{}
toggle.menuinfo={items={},layouts={},bindlayouts={},tooltip={bg=setz(newsquare(Color3.fromHex("#16161e"),1),190),outer=setz(newborder(Color3.fromHex("#000000"),1),194),middle=setz(newborder(Color3.fromHex("#f2a93b"),1),193),inner=setz(newborder(Color3.fromHex("#000000"),1),192),badge=setz(newtext("(?)",Color3.fromHex("#f2a93b"),false,false),195),text=setz(newtext("",Color3.fromHex("#ffffff"),false,false),195)}}
toggle.inlinecolors={mark={},outer={},middle={},inner={}}
for i=1,menustate.maxitems do
    itembg[i]=setz(newsquare(Color3.fromHex("#202330"),1),110);itemborder[i]=setz(newborder(Color3.fromHex("#272c35"),1),111);itemlabel[i]=setz(newtext("",Color3.fromHex("#ffffff"),false,false),121);itemvalue[i]=setz(newtext("",Color3.fromHex("#ffffff"),false,false),121);toggle.menuinfo.items[i]=setz(newtext("?",Color3.fromHex("#f2a93b"),false,false),122);itemmark[i]=setz(newsquare(Color3.fromHex("#7aa2f7"),1),116);markborder[i]=setz(newborder(Color3.fromHex("#343b46"),1),114);itemline[i]=setz(newline(Color3.fromHex("#787c99")),112);itemline[i].Thickness=1;itemtrack[i]=setz(newsquare(Color3.fromHex("#343b58"),1),114);itemfill[i]=setz(newsquare(Color3.fromHex("#7aa2f7"),1),115);trackborder[i]=setz(newborder(Color3.fromHex("#343b46"),1),118);toggle.inlinecolors.mark[i]=setz(newsquare(Color3.fromHex("#ffffff"),1),116);toggle.inlinecolors.outer[i]=setz(newborder(Color3.fromHex("#000000"),1),114);toggle.inlinecolors.middle[i]=setz(newborder(Color3.fromHex("#343b46"),1),115);toggle.inlinecolors.inner[i]=setz(newborder(Color3.fromHex("#000000"),1),118)
end
local sectionframes={}
local function getsectionframe(index)
    if not sectionframes[index]then
        sectionframes[index]={topl=setz(newline(Color3.fromHex("#000000")),112),topr=setz(newline(Color3.fromHex("#000000")),112),left=setz(newline(Color3.fromHex("#000000")),112),right=setz(newline(Color3.fromHex("#000000")),112),bottom=setz(newline(Color3.fromHex("#000000")),112)};for _,d in pairs(sectionframes[index])do d.Thickness=1 end
    end
    return sectionframes[index]
end
local itemrgb,itemrgbcount={},12
local function getitemrgb(index)
    if not itemrgb[index]then itemrgb[index]={};for i=1,itemrgbcount do itemrgb[index][i]=setz(newsquare(Color3.fromHex("#ffffff"),1),117)end end;return itemrgb[index]
end
local dropdown={panel=newsquare(Color3.fromHex("#05070a"),1),border=newborder(Color3.fromHex("#28313d"),1),accent=newsquare(Color3.fromHex("#8da8c0"),1),scrolltrack=newsquare(Color3.fromHex("#090b0e"),1),scrollborder=newborder(Color3.fromHex("#28313d"),1),scrollthumb=newsquare(Color3.fromHex("#8da8c0"),1),bg={},text={},max=12,visiblemax=11,offset=0,scroll=0,scrollmax=0,layout=nil,anim=0,opened=false}
setz(dropdown.panel,200);setz(dropdown.border,201);setz(dropdown.accent,202);setz(dropdown.scrolltrack,205);setz(dropdown.scrollborder,206);setz(dropdown.scrollthumb,207);for i=1,dropdown.max do dropdown.bg[i]=setz(newsquare(Color3.fromHex("#202330"),1),203);dropdown.text[i]=setz(newtext("",Color3.fromHex("#ffffff"),false,false),204)end
local picker={
    bg=newsquare(Color3.fromHex("#08090c"),0.98),top=newsquare(Color3.fromHex("#161616"),1),panel=newsquare(Color3.fromHex("#050607"),1),accent=newsquare(Color3.fromHex("#65c8e8"),1),divider=newline(Color3.fromHex("#111111")),border=newborder(Color3.fromHex("#000000"),1),middleborder=newborder(Color3.fromHex("#555555"),1),innerborder=newborder(Color3.fromHex("#000000"),1),panelborder=newborder(Color3.fromHex("#111111"),1),title=newtext("color",Color3.fromHex("#ffffff"),false,false),
    preview=newsquare(Color3.fromHex("#ffffff"),1),previewrgb={},previewborder=newborder(Color3.fromHex("#ffffff"),1),squareborder=newborder(Color3.fromHex("#ffffff"),1),hueborder=newborder(Color3.fromHex("#ffffff"),1),grid={},hue={},cursor=nil,huecursor=nil,reveal=newsquare(Color3.fromHex("#202020"),1),
    rgbbg=newsquare(Color3.fromHex("#090b0e"),1),rgbborder=newborder(Color3.fromHex("#343b46"),1),rgbmark=newsquare(Color3.fromHex("#7aa2f7"),1),rgbmarkborder=newborder(Color3.fromHex("#343b46"),1),rgbtext=newtext("rgb",Color3.fromHex("#ffffff"),false,false),
    donebg=newsquare(Color3.fromHex("#20242b"),1),doneborder=newborder(Color3.fromHex("#343b46"),1),donetext=newtext("done",Color3.fromHex("#ffffff"),true,false),
    hexbg=newsquare(Color3.fromHex("#090b0e"),1),hexborder=newborder(Color3.fromHex("#343b46"),1),hexlabel=newtext("hex",Color3.fromHex("#ffffff"),false,false),hextext=newtext("#FFFFFF",Color3.fromHex("#ffffff"),false,false),
    recentlabel=newtext("recent",Color3.fromHex("#ffffff"),false,false),recent={},recentborder={},gradient={},ready=false,anim=0,opened=false,cursorx=nil,cursory=nil,huey=nil
}
picker.cols=72;picker.rows=52;picker.huesteps=96
picker.divider.Thickness=1
for _,d in ipairs({picker.bg,picker.top,picker.panel})do setz(d,220)end
for _,d in ipairs({picker.accent,picker.divider})do setz(d,221)end
for _,d in ipairs({picker.border,picker.middleborder,picker.innerborder,picker.panelborder,picker.preview,picker.previewborder,picker.squareborder,picker.hueborder,picker.rgbbg,picker.rgbborder,picker.donebg,picker.doneborder,picker.hexbg,picker.hexborder})do setz(d,222)end;setz(picker.rgbmark,223);setz(picker.rgbmarkborder,224)
for _,d in ipairs({picker.title,picker.rgbtext,picker.donetext,picker.hexlabel,picker.hextext,picker.recentlabel})do setz(d,225)end
setz(picker.reveal,224)
picker.cursor=setz(Drawing.new("Circle"),226);picker.cursor.Color=Color3.fromHex("#ffffff");picker.cursor.Radius=4;picker.cursor.NumSides=20;picker.cursor.Thickness=1;picker.cursor.Visible=false;picker.huecursor=setz(newborder(Color3.fromHex("#ffffff"),1),226)
picker.hexvalue="FFFFFF";picker.hexactive=false;picker.hexreplace=false;picker.recentcolors={Color3.fromHex("#a2ff00"),Color3.fromHex("#ffffff"),Color3.fromHex("#ff6b6b"),Color3.fromHex("#78b7e6"),Color3.fromHex("#b283d3"),Color3.fromHex("#000000")}
picker.baseobjects={picker.bg,picker.top,picker.panel,picker.divider,picker.border,picker.middleborder,picker.innerborder,picker.panelborder,picker.title,picker.preview,picker.previewborder,picker.squareborder,picker.hueborder,picker.cursor,picker.huecursor,picker.donebg,picker.doneborder,picker.donetext,picker.hexbg,picker.hexborder,picker.hexlabel,picker.hextext,picker.recentlabel};picker.rgbobjects={picker.rgbbg,picker.rgbborder,picker.rgbmark,picker.rgbmarkborder,picker.rgbtext}
for i=1,6 do picker.recent[i]=setz(newsquare(picker.recentcolors[i],1),224);picker.recentborder[i]=setz(newborder(Color3.fromHex("#343b46"),1),225)end
local menurgb={}
for i=1,barseg do menurgb[i]=setz(newline(Color3.fromHSV((i-1)/barseg*rgbspread,0.68,1)),137);menurgb[i].Thickness=2 end
local capture,pickerentry,dropdownkind,configcapture=nil,nil,nil,false
local configslots={"default"}
local configslot=1
local configname="default"
local menuitems,itemlayouts={},{}
local pickerlayouts,dropdownlayouts={},{}
local function color(name)
    if name=="accent"then return themes.accentstyle.labelcolor elseif name=="bg"or name=="side"then return toggle.themestyles.background.labelcolor elseif name=="top"then return toggle.themestyles.topbar.labelcolor elseif name=="select"then return toggle.themestyles.border.labelcolor elseif name=="outline"then return toggle.themestyles.outline.labelcolor elseif name=="text"then return toggle.themestyles.text.labelcolor end
    return toggle.themevisual[name]or themes[themeindex][name]
end
toggle.textbrightness=function(c)return c and math.max(c.R,c.G,c.B)or 1 end
toggle.outlineallowed=function(c,enabled,fade)return enabled==true and(fade or 1)>=0.3 and toggle.textbrightness(c)>=0.4 end
toggle.textoutline=function(c,fade)return toggle.outlineallowed(c,toggle.guitextoutline,fade)end
toggle.applytextoutline=function(d,fade,textcolor)
    if d then toggle.setprop(d,"Outline",toggle.textoutline(textcolor or toggle.drawcolors[d]or d.Color,fade))end
end
toggle.applyespoutline=function(d,fade,textcolor)if d then toggle.setprop(d,"Outline",toggle.outlineallowed(textcolor or toggle.drawcolors[d]or d.Color,toggle.esptextoutline,fade))end end
toggle.menuoutline=function(c,fade)return toggle.textoutline(c or color("text"),fade)end
toggle.ease=function(current,target,speed)
    current=current==nil and target or current
    if math.abs(target-current)<0.001 then return target end
    local frames=clamp((toggle.framedt or 1/60)*60,0.25,4);local adjusted=1-math.pow(1-speed,frames)
    return current+(target-current)*adjusted
end
toggle.colormix=function(a,b,amount)
    amount=clamp(amount,0,1);if amount<=0 then return a elseif amount>=1 then return b end;return Color3.new(a.R+(b.R-a.R)*amount,a.G+(b.G-a.G)*amount,a.B+(b.B-a.B)*amount)
end
toggle.sectioncolor=function()local base=color("bg");local light=base.R*0.2126+base.G*0.7152+base.B*0.0722;return toggle.colormix(base,Color3.new(0,0,0),light>0.58 and 0.08 or 0.14)end
toggle.accentvisual=function()
    if toggle.barrgb then return color("accent")end
    local base,foreground=color("accent"),color("text");local now=toggle.frametime or tick();if toggle.accentcachetime~=now or toggle.accentcachebase~=base or toggle.accentcachetext~=foreground then toggle.accentcachetime=now;toggle.accentcachebase=base;toggle.accentcachetext=foreground;toggle.accentcache=toggle.colormix(base,foreground,0.035+0.025*(math.sin(now*2.1)+1)/2)end;return toggle.accentcache
end
toggle.wraptooltip=function(value,limit)
    local lines,current={},"";for word in string.gmatch(value or"","%S+")do local candidate=current==""and word or current.." "..word;if #candidate>limit and current~=""then lines[#lines+1]=current;current=word else current=candidate end end;if current~=""then lines[#lines+1]=current end;local longest=0;for i=1,#lines do longest=math.max(longest,#lines[i])end;return table.concat(lines,"\n"),longest,math.max(1,#lines)
end
toggle.makegradient=function(count,z)
    local lines={};for i=1,count do lines[i]=setz(newline(Color3.fromHSV((i-1)/math.max(1,count-1)*rgbspread,0.68,1)),z);lines[i].Thickness=2 end;return lines
end
toggle.layoutgradient=function(lines,x,y,w)
    local step=w/#lines;for i=1,#lines do local d=lines[i];d.From=Vector2.new(x+(i-1)*step,y);d.To=Vector2.new(x+i*step,y)end
end
toggle.paintgradient=function(lines,on,alpha)
    local desired=on==true;if not desired and lines._paintvisible==false then return end;local visibilitychanged=lines._paintvisible~=desired;lines._paintvisible=desired
    local count=#lines;local colors=nil
    if on and toggle.barrgb then
        local state=toggle.gradientcache;local set=state.sets[count]
        if not set then set={frame=-1};state.sets[count]=set end
        if set.frame~=state.frame then for i=1,count do set[i]=rgb((i-1)/math.max(1,count-1)*rgbspread)end;set.frame=state.frame end
        colors=set
    end
    local accent=on and not toggle.barrgb and toggle.accentvisual()or nil
    for i=1,count do local d=lines[i];if desired then toggle.setprop(d,"Color",colors and colors[i]or accent);toggle.setprop(d,"Transparency",alpha or 1)end;if visibilitychanged then toggle.setvisible(d,desired)end end
end
toggle.gradientcache={frame=0,sets={}}
toggle.ensurepicker=function()
    if picker.ready then return end
    picker.gradient=toggle.makegradient(48,221);for y=1,picker.rows do for x=1,picker.cols do picker.grid[#picker.grid+1]=setz(newsquare(Color3.fromHex("#ffffff"),1),223)end end;for i=1,picker.huesteps do picker.hue[i]=setz(newsquare(Color3.fromHSV((i-1)/picker.huesteps,1,1),1),223)end;picker.ready=true;toggle.applyradius()
end
local function inside(px,py,x,y,w,h)return px>=x and px<=x+w and py>=y and py<=y+h end
toggle.tooltipupdate=function()
    local active=nil;local layouts=toggle.menuinfo.layouts;local binds=toggle.menuinfo.bindlayouts;if toggle.menu and not menustate.minimized and not pickerentry and not dropdownkind then for i=1,#menuitems do local info=binds[i];if info and info.visible and inside(mouse.X,mouse.Y,info.x,info.y,info.w,info.h)then active=info;break end;info=layouts[i];if info and info.visible and inside(mouse.X,mouse.Y,info.x,info.y,info.w,info.h)then active=info;break end end end
    local tip=toggle.menuinfo.tooltip;local visible=active~=nil;for _,d in pairs(tip)do toggle.setvisible(d,visible)end;if not visible then return end
    local unstable=active.unstable==true or active.warning==true;local permission=active.permission;local isbind=active.bind==true;local badge=(unstable or permission)and"(!)"or"(?)";local badgecolor=isbind and color("accent")or unstable and toggle.warningred or permission=="hybrid"and toggle.permissionpink or permission and toggle.permissionblue or toggle.infoorange;local textcolor=isbind and color("accent")or color("text");local shown,longest,lines=toggle.wraptooltip(active.text,34);local width=math.max(134,longest*7+16);local extra=14;local height=lines*14+13+extra;local x=clamp(mouse.X+13,2,math.max(2,cam.ViewportSize.X-width-2));local y=clamp(mouse.Y+16,2,math.max(2,cam.ViewportSize.Y-height-2));local tipopacity=0.65+0.35*guiopacity;tip.outer.Position=Vector2.new(x,y);tip.outer.Size=Vector2.new(width,height);tip.middle.Position=Vector2.new(x+1,y+1);tip.middle.Size=Vector2.new(width-2,height-2);tip.inner.Position=Vector2.new(x+2,y+2);tip.inner.Size=Vector2.new(width-4,height-4);tip.bg.Position=Vector2.new(x+3,y+3);tip.bg.Size=Vector2.new(width-6,height-6);tip.badge.Visible=true;tip.badge.Position=Vector2.new(x+8,y+6);tip.badge.Text=badge;tip.badge.Color=badgecolor;toggle.applytextoutline(tip.badge,1,badgecolor);tip.badge.Transparency=1;tip.text.Position=Vector2.new(x+8,y+6+extra);tip.text.Text=shown;tip.text.Color=textcolor;toggle.applytextoutline(tip.text,1,textcolor);tip.bg.Color=color("bg");tip.outer.Color=themes.borderblack;tip.middle.Color=badgecolor;tip.inner.Color=themes.borderblack;tip.bg.Transparency=tipopacity;tip.outer.Transparency=tipopacity;tip.middle.Transparency=math.max(0.75,0.85*tipopacity);tip.inner.Transparency=tipopacity;tip.text.Transparency=1
end
local function entrycfg(index)
    if index=="accent"then return themes.accentstyle elseif index=="themebg"then return toggle.themestyles.background elseif index=="themetop"then return toggle.themestyles.topbar elseif index=="themeborder"then return toggle.themestyles.border elseif index=="themeoutline"then return toggle.themestyles.outline elseif index=="themetext"then return toggle.themestyles.text elseif index=="distance"then return toggle.distancestyle elseif index=="rake"then return toggle.rakestyle elseif index=="rakehealth"or index=="rakebar"then return toggle.rakebarstyle elseif index=="roof"then return roofstyle elseif index=="hudtimer"then return toggle.hudstyles.timer elseif index=="hudtarget"then return toggle.hudstyles.target elseif index=="hudscrap"then return toggle.hudstyles.scrap elseif index=="hudpower"then return toggle.hudstyles.power elseif index=="cooldownlabel"then return toggle.cooldownstyle elseif index=="cooldownvalue"then return toggle.cooldownvaluestyle elseif index=="ppmslabel"then return toggle.ppmslabelstyle elseif index=="ppmsvalue"then return toggle.ppmsvaluestyle elseif index=="valuetimer"then return toggle.hudvalues.timer elseif index=="valuetarget"then return toggle.hudvalues.target elseif index=="valuescrap"then return toggle.hudvalues.scrap elseif index=="valuepower"then return toggle.hudvalues.power elseif index=="timerwarning"then return toggle.hudvalues.warning elseif type(index)=="string"and string.sub(index,1,6)=="crate_"then return toggle.cratestyles[string.sub(index,7)]end
    local entry=colorentries[index];return entry and espcfg[entry.cfgs[1]]or nil
end
toggle.colorname=function(index)
    if type(index)=="number"then return colorentries[index].name elseif type(index)=="string"and string.sub(index,1,6)=="crate_"then local cfg=toggle.cratestyles[string.sub(index,7)];return cfg and cfg.name or"supply item"end
    local names={accent="accent",themebg="background",themetop="top bar",themeborder="border",themeoutline="outline",themetext="text",distance="distance label",rake="rake name",rakehealth="rake health",rakebar="rake health bar",roof="roof HP",hudtimer="timer label",hudtarget="target label",hudscrap="scrap label",hudpower="power label",cooldownlabel="cooldown label",cooldownvalue="cooldown value",ppmslabel="voltmeter label",ppmsvalue="voltmeter value",valuetimer="timer value",valuetarget="target value",valuescrap="scrap value",valuepower="power value",timerwarning="timer warning"};return names[index]or"color"
end
local function channel(value)return math.floor(clamp(value*255,0,255)+0.5)end
toggle.hexof=function(value)return string.format("%02X%02X%02X",channel(value.R),channel(value.G),channel(value.B))end
toggle.pushrecent=function(value)
    local hex=toggle.hexof(value);local nextcolors={value}
    for i=1,#picker.recentcolors do if toggle.hexof(picker.recentcolors[i])~=hex and #nextcolors<6 then nextcolors[#nextcolors+1]=picker.recentcolors[i]end end
    picker.recentcolors=nextcolors
end
local function tohsv(c)
    local r,g,b=c.R,c.G,c.B;local maximum=math.max(r,g,b);local minimum=math.min(r,g,b);local delta=maximum-minimum;local h=0
    if delta>0 then
        if maximum==r then h=((g-b)/delta)%6 elseif maximum==g then h=(b-r)/delta+2 else h=(r-g)/delta+4 end
        h=h/6
    end
    return h,maximum==0 and 0 or delta/maximum,maximum
end
local function section(label,col)return {kind="section",label=label,col=col or 1}end
toggle.refreshshop=function(force)
    toggle.shop.lastscan=tick();for i=1,#toggle.shop.items do local item=toggle.shop.items[i];toggle.shop.lookup[item.label]=item;toggle.shop.lookup[item.name]=item end
end
toggle.shopitem=function()
    toggle.refreshshop(false);return toggle.shop.lookup[toggle.shop.selected]or toggle.shop.items[#toggle.shop.items]
end
toggle.shoplabel=function()local item=toggle.shopitem();return item and item.label or"map"end
toggle.shopindex=function()
    local selected=toggle.shopitem();if not selected then return 1 end;for i=1,#toggle.shop.names do if toggle.shop.names[i]==selected.label then return i end end;return 1
end
toggle.itemshown=function(item)
    if item.inlinebind and item.bind then return(capture==item.bind or(keybinds[item.bind]or 0)==0)and"[..]"or"["..toggle.bindname(item.bind).."]"end
    local shown=item.display or item.value and tostring(item.value)or""
    if item.kind=="dropdown"then if #shown>14 then shown=string.sub(shown,1,12)..".."end;return shown.." >"end
    if #shown>18 then shown=string.sub(shown,1,16)..".."end;return shown
end
local function currentitems()
    local teleportinfo="teleporting too often might kill you. enable tp safe cooldown if this happens often"
    if menustate.tab==1 then
        toggle.refreshshop(false)
        local items={
            section("master",1),{id="bindmenu",kind="bind",bind="menu",inlinebind=true,label="menu toggle",col=1},{id="watermark",kind="toggle",label="watermark state",on=toggle.watermark,col=1},{id="esp",kind="toggle",label="esp toggle",on=toggle.esp,bind="esp",inlinebind=true,col=1},{id="hud",kind="toggle",label="hud toggle",on=toggle.hud,bind="hud",inlinebind=true,col=1},
            section("shop",1),{id="shopitemselect",kind="dropdown",label="item",value=toggle.shoplabel(),col=1},{id="quickbuy",kind="action",label="quick buy",info="requires hybrid-mode, only works during daytime; teleports to the shop and purchases the selected item",permission="hybrid",col=1},{id="quicksell",kind="action",label="quick sell",info="requires hybrid-mode, only works during daytime; teleports to the shop and sells the selected item",permission="hybrid",col=1},
            section("teleports",2),{id="scrap",kind="toggle",label="tp to scrap",on=toggle.scrapteleportenabled,bind="scrap",inlinebind=true,info=teleportinfo,warning=true,unstable=true,col=2},{id="sell",kind="toggle",label="tp to sell",on=toggle.sellenabled,bind="sell",inlinebind=true,info="requires hybrid-mode, using the bind will teleport you to the shop and sell your scrap",permission="hybrid",col=2},{id="scrapteleportselect",kind="dropdown",label="sort by",value=toggle.scrapteleport,col=2},{id="flare",kind="toggle",label="tp to flare",on=toggle.flareteleportenabled,bind="flare",inlinebind=true,info=teleportinfo,warning=true,unstable=true,col=2},{id="teleportcooldown",kind="toggle",label="tp safe cooldown",on=toggle.teleportcooldown,col=2},
            section("combat",1),{id="killaura",kind="toggle",label="stun aura",on=toggle.killaura,bind="aura",inlinebind=true,info="requires hybrid-mode, doesn't use stamina, requires an equipped stun stick",permission="hybrid",col=1},{id="killaurarange",kind="slider",label="aura range",value=toggle.killaurarange,min=6,max=30,display=tostring(toggle.killaurarange).." studs",col=1},{id="killauradelay",kind="slider",label="aura delay",value=toggle.killauradelay,min=0.05,max=0.6,display=string.format("%.2fs",toggle.killauradelay),col=1},
            section("camera",2),{id="thirdperson",kind="toggle",label="third person",on=toggle.zoom.thirdperson,info="requires unsafe LuaU mode; equip an item after toggling to update the zoom",permission="unsafe",col=2},{id="zoomamount",kind="slider",label="zoom amount",value=toggle.zoom.amount,min=0.5,max=100,display=string.format("%.1f studs",toggle.zoom.amount),col=2},{id="shiftlock",kind="toggle",label="shift lock",on=toggle.shiftlockstate.active,info="requires unsafe LuaU mode; switch the movement mode in roblox settings until it works",permission="unsafe",col=2},
            section("client",1),{id="noFall",kind="toggle",label="no fall damage",on=toggle.client.noFall,col=1},{id="noJumpCooldown",kind="toggle",label="no jump cooldown",on=toggle.client.noJumpCooldown,info="unstable: may lag during the initial scan, may need to be re-enabled after respawning or state changes, and may still freeze as the game continues",warning=true,unstable=true,col=1},{id="infiniteStamina",kind="toggle",label="infinite stamina",on=toggle.client.infiniteStamina,info="unstable: may lag during the initial scan, may need to be re-enabled after respawning or state changes, and may still freeze as the game continues",warning=true,unstable=true,col=1},
            section("supply crates",2),{id="supplylabel",kind="toggle",label="crate esp",on=toggle.supplylabel,colorindex=8,col=2},{id="supplyitems",kind="toggle",label="supplies esp",on=toggle.supplyitems,info="shows the inventory of a supply crate in correct order, also shows whether an item has been taken or not",col=2},{id="instacrate",kind="toggle",label="instant crate",on=toggle.instacrate,info="requires hybrid mode, may not work with pre-existing crates",permission="hybrid",col=2},
            section("power usage",2),{id="hudpower",kind="toggle",label="power left",on=toggle.hudelements.power,info="requires unsafe LuaU mode enabled",permission="unsafe",col=2},{id="poweractivity",kind="toggle",label="activity panel",on=toggle.poweractivity,col=2},{id="poweractivitymodeselect",kind="dropdown",label="show when",value=toggle.poweractivitymode,col=2},{id="ppms",kind="toggle",label="voltmeter level",on=toggle.ppms,col=2},
            section("player hud",1),{id="hudtarget",kind="toggle",label="rake target",on=toggle.hudelements.target,col=1},{id="hudscrap",kind="toggle",label="scrap value",on=toggle.hudelements.scrap,col=1},
            section("distance esp",2),{id="distance",kind="toggle",label="distance",on=toggle.distance,colorindex="distance",col=2},{id="distancepositionselect",kind="dropdown",label="label position",value=toggle.distanceposition,col=2},{id="distanceminimum",kind="toggle",label="minimum distance",on=toggle.distanceminimum,col=2},{id="distancemin",kind="slider",label="show distance after",value=toggle.distancemin,min=0,max=100,display=tostring(toggle.distancemin).."m",col=2},
            section("rake esp",1),{id="rakename",kind="toggle",label="rake name",on=toggle.rakename,colorindex="rake",col=1},{id="rakenameinput",kind="text",stacked=true,label="custom name",value=toggle.rakenamecapture and toggle.rakenamevalue.."_"or toggle.rakenamevalue,col=1},{id="rakehealth",kind="toggle",label="rake health",on=toggle.rakehealth,colorindex="rakehealth",col=1},{id="rakedistance",kind="toggle",label="rake distance",on=toggle.rakedistance,col=1},{id="healthbased",kind="toggle",label="health-based color",on=toggle.healthbased,col=1},{id="rakehealthformatselect",kind="dropdown",label="health style",value=toggle.rakehealthformat,col=1},{id="rakenamey",kind="slider",label="name Y offset",value=toggle.rakenamey,min=-100,max=100,display=tostring(toggle.rakenamey).."px",col=1},{id="rakehealthy",kind="slider",label="health Y offset",value=toggle.rakehealthy,min=-100,max=100,display=tostring(toggle.rakehealthy).."px",col=1},{id="rakebarwidth",kind="slider",label="health bar width",value=toggle.rakebarwidth,min=30,max=200,display=tostring(toggle.rakebarwidth).."px",col=1},
            section("objects esp",2),{id="flares",kind="toggle",label="flare gun",on=espgroups.flares,colorindex=1,col=2},{id="traps",kind="toggle",label="rake trap",on=espgroups.traps,colorindex=7,col=2},
            section("scraps esp",1),{id="itemScrap1",kind="toggle",label="scrap 1",on=espgroups.items.Scrap1,itemkey="Scrap1",colorindex=2,col=1},{id="itemScrap2",kind="toggle",label="scrap 2",on=espgroups.items.Scrap2,itemkey="Scrap2",colorindex=3,col=1},{id="itemScrap3",kind="toggle",label="scrap 3",on=espgroups.items.Scrap3,itemkey="Scrap3",colorindex=4,col=1},{id="itemScrap4",kind="toggle",label="scrap 4",on=espgroups.items.Scrap4,itemkey="Scrap4",colorindex=5,col=1},{id="itemScrap5",kind="toggle",label="scrap 5",on=espgroups.items.Scrap5,itemkey="Scrap5",colorindex=6,col=1},{id="scrapstyleselect",kind="dropdown",label="scrap style",value=toggle.scrapstyle,col=1},
            section("timer",2),{id="hudtimer",kind="toggle",label="timer hud",on=toggle.hudelements.timer,col=2},{id="timerformatselect",kind="dropdown",label="timer style",value=toggle.timerformat,col=2},{id="timerwarningenabled",kind="toggle",label="timer warning",on=toggle.timerwarningenabled,colorindex="timerwarning",col=2},{id="timerwarning",kind="slider",label="warning time",value=toggle.timerwarning,min=10,max=45,display=tostring(toggle.timerwarning).."s",col=2}
        }
        items[#items+1]=section("location esp",2);items[#items+1]={id="roof",kind="toggle",label="roof HP",on=toggle.roof,colorindex="roof",col=2}
        for i=9,13 do local cfg=colorentries[i];items[#items+1]={id="item"..cfg.cfgs[1],kind="toggle",label=cfg.name,on=espgroups.items[cfg.cfgs[1]],itemkey=cfg.cfgs[1],colorindex=i,col=2}end
        return items
    elseif menustate.tab==2 then
        local items={}
        items[#items+1]=section("preferences",1);items[#items+1]={id="hudstyleselect",kind="dropdown",label="hud style",value=toggle.hudstyle,col=1};items[#items+1]={id="esptextoutline",kind="toggle",label="esp text outline",on=toggle.esptextoutline,col=1}
        items[#items+1]=section("hud values",1);items[#items+1]={id="valuetimercolor",kind="color",label="timer value",index="valuetimer",col=1};items[#items+1]={id="cooldownvaluecolor",kind="color",label="cooldown value",index="cooldownvalue",col=1};items[#items+1]={id="valuetargetcolor",kind="color",label="target value",index="valuetarget",col=1};items[#items+1]={id="valuescrapcolor",kind="color",label="scrap value",index="valuescrap",col=1};items[#items+1]={id="valuepowercolor",kind="color",label="power value",index="valuepower",col=1}
        items[#items+1]=section("hud labels",2);items[#items+1]={id="hudtimercolor",kind="color",label="timer label",index="hudtimer",col=2};items[#items+1]={id="cooldownlabelcolor",kind="color",label="cooldown label",index="cooldownlabel",col=2};items[#items+1]={id="hudtargetcolor",kind="color",label="target label",index="hudtarget",col=2};items[#items+1]={id="hudscrapcolor",kind="color",label="scrap label",index="hudscrap",col=2};items[#items+1]={id="hudpowercolor",kind="color",label="power label",index="hudpower",col=2};items[#items+1]={id="ppmslabelcolor",kind="color",label="voltmeter label",index="ppmslabel",col=2}
        items[#items+1]=section("crate",1);for _,entry in ipairs({{"FirstAidKit","medkit"},{"Vitamins","vitamin"},{"UV_Lamp","uv lamp"},{"StunStick","stun stick"},{"Vest","vest"},{"Tracker","tracker"}})do items[#items+1]={id="cratecolor"..entry[1],kind="color",label=entry[2],index="crate_"..entry[1],col=1}end
        items[#items+1]=section("world esp ring",2);items[#items+1]={id="ringenabled",kind="toggle",label="esp ring",on=toggle.ringenabled,col=2};items[#items+1]={id="ringshapeselect",kind="dropdown",label="shape",value=toggle.ringshape,col=2};items[#items+1]={id="ringfade",kind="slider",label="render distance",value=ringfade,min=10,max=150,display=tostring(math.floor(ringfade)).."m",col=2};items[#items+1]={id="ringsize",kind="slider",label="size multiplier",value=toggle.ringsize,min=0.5,max=3,display=string.format("%.1fx",toggle.ringsize),col=2};items[#items+1]={id="ringspin",kind="toggle",label="rotating ring",on=toggle.ringspin,col=2};items[#items+1]={id="ringspinspeed",kind="slider",label="rotation speed",value=toggle.ringspinspeed,min=0.1,max=3,display=string.format("%.1fx",toggle.ringspinspeed),col=2}
        return items
    elseif menustate.tab==3 then
        return {
            section("interface",1),{id="presetselect",kind="dropdown",label="preset",value=themes[themeindex].name,col=1},{id="opacity",kind="slider",label="opacity",value=guiopacity,min=0.2,max=1,display=tostring(math.floor(guiopacity*100+0.5)).."%",col=1},{id="borderradius",kind="slider",label="border radius",value=toggle.borderradius,min=0,max=10,display=tostring(toggle.borderradius).."px",col=1},{id="guitextoutline",kind="toggle",label="text outline",on=toggle.guitextoutline,col=1},
            section("theme colors",1),{id="accentcolor",kind="color",label="accent",index="accent",col=1},{id="themebgcolor",kind="color",label="background",index="themebg",col=1},{id="themetopcolor",kind="color",label="top bar",index="themetop",col=1},{id="themebordercolor",kind="color",label="border",index="themeborder",col=1},{id="themeoutlinecolor",kind="color",label="outline",index="themeoutline",col=1},{id="themetextcolor",kind="color",label="text",index="themetext",col=1},
            section("chroma",1),{id="barrgb",kind="toggle",label="rgb accent",on=toggle.barrgb,col=1},{id="rgbdirectionselect",kind="dropdown",label="rgb direction",value=toggle.rgbdirection,col=1},{id="rgbspeed",kind="slider",label="rgb speed",value=rgbspeed,min=0.5,max=2,display=string.format("%.2fx",rgbspeed),col=1},
            section("fonts",2),{id="espfontselect",kind="dropdown",label="esp font",value=fontnames[fontindex],col=2},{id="hudfontselect",kind="dropdown",label="hud font",value=fontnames[toggle.hudfontindex],col=2},{id="fontsize",kind="slider",label="font size",value=espfontsize,min=13,max=20,col=2},
            section("configuration",2),{id="configname",kind="text",stacked=true,label="config name",value=configcapture and configname.."_"or configname,col=2},{id="configselect",kind="dropdown",stacked=true,label="config list",value=configslots[configslot]or"none",col=2},{id="save",kind="action",label="save",col=2},{id="load",kind="action",label="load",col=2},
            section("reset",2),{id="resetcolors",kind="action",label="reset colors",col=2},{id="resettheme",kind="action",label="reset theme",col=2},{id="resettoggles",kind="action",label="reset toggles",col=2},{id="resetbinds",kind="action",label="reset binds",col=2},{id="reset",kind="action",label="reset all",col=2}
        }
    end
    return {}
end
toggle.rowheight=function(item)return item.stacked and 46 or item.kind=="section"and 22 or item.kind=="slider"and 35 or item.kind=="action"and 25 or item.kind=="dropdown"and 22 or 19 end
local function displaysize()local phase=clamp(((menustate.minimizeanim or 0)-0.42)/0.58,0,1);return math.floor(menustate.w+(menustate.watermarkw-menustate.w)*phase+0.5),math.floor(menustate.h+(menustate.watermarkh-menustate.h)*phase+0.5)end
toggle.applymenuradius=function()
    for _,entry in ipairs({{menubg,0},{menutop,0},{menuchrome.border,0},{menuchrome.columnborders[1],1},{menuchrome.columnborders[2],2}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end
end
local function clampmenu()
    local v=cam.ViewportSize;local w,h=displaysize()
    menustate.x=clamp(menustate.x,0,math.max(0,v.X-w));menustate.y=clamp(menustate.y,0,math.max(0,v.Y-h))
end
local function menupos()
    clampmenu();menustate.tabfade=toggle.ease(menustate.tabfade,1,0.26);menustate.tabslide=toggle.ease(menustate.tabslide,0,0.28);menustate.positionanimating=math.abs(menustate.tabfade-1)>0.001 or math.abs(menustate.tabslide)>0.001;local displayw,displayh=displaysize()
    menubg.Position=Vector2.new(menustate.x,menustate.y);menubg.Size=Vector2.new(displayw,displayh)
    menutop.Position=Vector2.new(menustate.x,menustate.y);menutop.Size=Vector2.new(displayw,menustate.minimized and menustate.watermarkh or 27)
    menuchrome.border.Position=Vector2.new(menustate.x,menustate.y);menuchrome.border.Size=Vector2.new(displayw,displayh);menuchrome.columnborders[1].Position=Vector2.new(menustate.x+1,menustate.y+1);menuchrome.columnborders[1].Size=Vector2.new(displayw-2,displayh-2);menuchrome.columnborders[2].Position=Vector2.new(menustate.x+2,menustate.y+2);menuchrome.columnborders[2].Size=Vector2.new(displayw-4,displayh-4)
    local titlecenter=menustate.x+(displayw-toggle.textwidth(menutitle))/2;local watermarkphase=clamp(((menustate.minimizeanim or 0)-0.42)/0.58,0,1);menutitle.Position=Vector2.new(math.floor(titlecenter+(menustate.x+8-titlecenter)*watermarkphase+0.5),menustate.y+8);menuclose.Position=Vector2.new(menustate.x+displayw-12,menustate.y+15)
    local navx,navy,navw,navh=menustate.x+4,menustate.y+29,menustate.w-8,18
    menuside.Position=Vector2.new(navx,navy);menuside.Size=Vector2.new(navw,navh)
    local tabw=navw/#tabnames
    for i=1,#tabnames do local x=math.floor(navx+(i-1)*tabw+0.5);local right=math.floor(navx+i*tabw+0.5);local w=right-x;local linew=#tabnames[i]*7+10;tabbg[i].Position=Vector2.new(x+math.floor((w-linew)/2),navy+navh-1);tabbg[i].Size=Vector2.new(linew,1);tabborder[i].Position=tabbg[i].Position;tabborder[i].Size=tabbg[i].Size;tabtext[i].Position=Vector2.new(x+math.floor(w/2),navy+8);if i==menustate.tab then local targetx=x+math.floor((w-linew)/2);menustate.indicatorx=toggle.ease(menustate.indicatorx,targetx,0.34);menustate.indicatorw=toggle.ease(menustate.indicatorw,linew,0.34);if math.abs(menustate.indicatorx-targetx)>0.001 or math.abs(menustate.indicatorw-linew)>0.001 then menustate.positionanimating=true end end end
    menuchrome.tabindicator.Position=Vector2.new(math.floor((menustate.indicatorx or navx)+0.5),navy+navh-2);menuchrome.tabindicator.Size=Vector2.new(math.max(1,math.floor((menustate.indicatorw or 1)+0.5)),2)
    menuchrome.content.Position=Vector2.new(menustate.x+6,menustate.y+52);menuchrome.content.Size=Vector2.new(menustate.w-12,menustate.h-56)
    if menustate.minimized and(menustate.contentfade or 0)<=0.001 then menuitems={};itemlayouts={} elseif menustate.itemsdirty or #menuitems==0 then menuitems=currentitems();menustate.itemsdirty=false;itemlayouts={}else itemlayouts={}end;toggle.menuinfo.layouts={};toggle.menuinfo.bindlayouts={}
    local left=menustate.x+12;local ystart=menustate.y+52;local cliptop=ystart;local clipbottom=math.max(cliptop,math.min(menustate.y+menustate.h-8,menustate.y+displayh-3));local gap=12;local w=(menustate.w-24-gap)/2;local natural={0,0}
    for i=1,2 do menuchrome.columns[i].Position=Vector2.new(0,0);menuchrome.columns[i].Size=Vector2.new(0,0)end
    menuchrome.divider.From=Vector2.new(0,0);menuchrome.divider.To=Vector2.new(0,0)
    local groupheights,rowadvances={},{}
    for i=1,#menuitems do
        local item=menuitems[i];local last=item.kind~="section"
        if last then for j=i+1,#menuitems do if(menuitems[j].col or 1)==(item.col or 1)then last=menuitems[j].kind=="section";break end end end
        rowadvances[i]=toggle.rowheight(item)+(last and 8 or 0)
    end
    for col=1,2 do local total=0;for i=#menuitems,1,-1 do local item=menuitems[i];if(item.col or 1)==col then total=total+rowadvances[i];if item.kind=="section"then groupheights[i]=total;total=0 end end end end
    for i=1,#menuitems do local item=menuitems[i];local col=item.col or 1;natural[col]=natural[col]+rowadvances[i]end
    local viewport=math.max(0,clipbottom-cliptop);local content=math.max(natural[1],natural[2]);menustate.scrollmax[menustate.tab]=math.max(0,content-viewport);menustate.scrolltarget[menustate.tab]=clamp(menustate.scrolltarget[menustate.tab]or 0,0,menustate.scrollmax[menustate.tab]);local oldscroll=menustate.scroll[menustate.tab]or menustate.scrolltarget[menustate.tab];local targetscroll=menustate.scrolltarget[menustate.tab];local scroll=toggle.ease(oldscroll,targetscroll,0.3);menustate.scroll[menustate.tab]=scroll;if math.abs(scroll-targetscroll)>0.001 then menustate.positionanimating=true end
    local renderscroll=math.floor(scroll+0.5);local ys={ystart-renderscroll,ystart-renderscroll}
    for i=1,#menuitems do
        local item=menuitems[i];local col=item.col or 1;local x=left+(col-1)*(w+gap)+math.floor(menustate.tabslide+0.5);local y=ys[col];local h=toggle.rowheight(item);local panelh=groupheights[i]or h
        if menustate.itemkinds[i]~=item.kind then menustate.itemkinds[i]=item.kind;setz(itembg[i],item.kind=="section"and 105 or 110)end
        local texty=y+(item.kind=="section"and 8 or item.kind=="action"and 12 or item.kind=="dropdown"and 7 or item.kind=="toggle"and 3 or 4);local valuey=item.kind=="text"and item.stacked and y+27 or item.stacked and y+30 or texty;local renderh=item.kind=="section"and panelh or h
        local overlap=math.min(y+renderh,clipbottom)-math.max(y,cliptop);local visible=overlap>0;local fade=(visible and clamp(math.min(y+renderh-cliptop,clipbottom-y)/14,0,1)or 0)*menustate.tabfade;local fieldtop=item.stacked and y+18 or y;local fieldbottom=y+h;local fieldoverlap=math.min(fieldbottom,clipbottom)-math.max(fieldtop,cliptop);local fieldvisible=fieldoverlap>0;local fieldfade=(fieldvisible and clamp(math.min(fieldbottom-cliptop,clipbottom-fieldtop)/14,0,1)or 0)*menustate.tabfade
        local textfade=(visible and math.min(scroll>0 and clamp((texty-cliptop)/12,0,1)or 1,scroll<menustate.scrollmax[menustate.tab]and clamp((clipbottom-texty-10)/12,0,1)or 1)or 0)*menustate.tabfade;local valuefade=item.stacked and(visible and math.min(scroll>0 and clamp((valuey-cliptop)/12,0,1)or 1,scroll<menustate.scrollmax[menustate.tab]and clamp((clipbottom-valuey-10)/12,0,1)or 1)or 0)*menustate.tabfade or textfade
        local liney=y+15;local linefade=(item.kind=="section"and visible and clamp(math.min(liney-cliptop,clipbottom-liney)/10,0,1)or fade)*menustate.tabfade;local sliderfade=(item.kind=="slider"and visible and clamp(math.min(y+17-cliptop,clipbottom-(y+32))/8,0,1)or fade)*menustate.tabfade
        itemlayouts[i]={x=x,y=y,w=w,h=h,panelh=panelh,item=item,visible=visible,fade=fade,fieldfade=fieldfade,fieldvisible=fieldvisible,linefade=linefade,sliderfade=sliderfade,textfade=textfade,valuefade=valuefade,textvisible=texty>=cliptop and texty+10<=clipbottom,valuevisible=valuey>=cliptop and valuey+10<=clipbottom,markvisible=fade>0.08,linevisible=linefade>0.01,trackvisible=sliderfade>0.01,hittop=math.max(y,cliptop),hitbottom=math.min(y+h,clipbottom),cliptop=cliptop,clipbottom=clipbottom};local shown=toggle.itemshown(item)
        if visible then
        if item.kind~="section"then local narrow=item.kind=="action"or item.kind=="text";local fieldx=narrow and x+7 or x;local fieldw=narrow and w-14 or w;itembg[i].Position=Vector2.new(fieldx,item.stacked and y+18 or y);itembg[i].Size=Vector2.new(fieldw,item.stacked and 27 or h-1)end;itemlabel[i].Position=Vector2.new(x+(item.kind=="section"and 12 or item.kind=="toggle"and 23 or 7),texty);itemvalue[i].Text=shown;itemvalue[i].Position=Vector2.new(item.stacked and x+15 or x+w-7-math.floor(#shown*7),valuey)
        itemlabel[i].Center=item.kind=="action";toggle.menuinfo.items[i].Center=item.kind=="action"and item.info~=nil;if item.kind=="action"then if item.info then local labelw=#item.label*7;local totalw=labelw+28;local startx=x+math.floor((w-totalw)/2);itemlabel[i].Position=Vector2.new(startx+labelw/2,texty);toggle.menuinfo.items[i].Position=Vector2.new(startx+labelw+17.5,texty);toggle.menuinfo.layouts[i]={x=startx+labelw+5,y=texty-2,w=25,h=14,text=item.info,warning=item.warning,unstable=item.unstable,permission=item.permission,visible=visible and texty>=cliptop and texty+10<=clipbottom}else itemlabel[i].Position=Vector2.new(x+w/2,texty)end elseif item.info then local infox=x+w-(item.colorindex and 57 or item.inlinebind and(#shown*7+35)or 24);toggle.menuinfo.items[i].Position=Vector2.new(infox,texty);toggle.menuinfo.layouts[i]={x=infox-2,y=texty-2,w=25,h=14,text=item.info,warning=item.warning,unstable=item.unstable,permission=item.permission,visible=visible and texty>=cliptop and texty+10<=clipbottom}end
        if item.inlinebind then itemlayouts[i].bindx=x+w-8-#shown*7;itemlayouts[i].bindy=valuey-2;itemlayouts[i].bindw=#shown*7+4;itemlayouts[i].bindh=14;toggle.menuinfo.bindlayouts[i]={x=itemlayouts[i].bindx,y=itemlayouts[i].bindy,w=itemlayouts[i].bindw,h=itemlayouts[i].bindh,text=toggle.bindinfo,bind=true,visible=visible and valuey>=cliptop and valuey+10<=clipbottom}end
        local markx,marky,markw,markh=item.kind=="toggle"and x+7 or x+w-16,y+4,9,9;if item.kind=="color"then markx,markw=x+w-31,24 end
        itemmark[i].Position=Vector2.new(markx+1,marky+1);itemmark[i].Size=Vector2.new(markw-2,markh-2)
        if item.colorindex then itemlayouts[i].colorx=x+w-33;itemlayouts[i].colory=marky-2;itemlayouts[i].colorw=28;itemlayouts[i].colorh=13;toggle.inlinecolors.mark[i].Position=Vector2.new(x+w-30,marky+1);toggle.inlinecolors.mark[i].Size=Vector2.new(22,7);toggle.inlinecolors.outer[i].Position=Vector2.new(x+w-33,marky-2);toggle.inlinecolors.outer[i].Size=Vector2.new(28,13);toggle.inlinecolors.middle[i].Position=Vector2.new(x+w-32,marky-1);toggle.inlinecolors.middle[i].Size=Vector2.new(26,11);toggle.inlinecolors.inner[i].Position=Vector2.new(x+w-31,marky);toggle.inlinecolors.inner[i].Size=Vector2.new(24,9)end
        local ratio=item.kind=="slider"and clamp((item.value-item.min)/(item.max-item.min),0,1)or 0;if item.kind=="slider"then local animkey=tostring(menustate.tab)..":"..item.id;local targetratio=ratio;menustate.slideranim[animkey]=toggle.ease(menustate.slideranim[animkey],targetratio,0.36);ratio=menustate.slideranim[animkey];if math.abs(ratio-targetratio)>0.001 then menustate.positionanimating=true end end
        if item.kind=="section"then
            local bgtop=math.max(cliptop,y+17);local bgbottom=math.min(clipbottom,y+panelh-4);itembg[i].Position=Vector2.new(x-2,bgtop);itembg[i].Size=Vector2.new(w+4,math.max(0,bgbottom-bgtop));local frame=getsectionframe(i);local titleend=math.min(x+w-12,x+12+#item.label*7)
            local topy=y+15;local leftx=x-2;local rightx=math.min(x+w+2,menustate.x+menustate.w-12);local bottomy=y+panelh-2;frame.topl.From=Vector2.new(leftx,topy);frame.topl.To=Vector2.new(x+8,topy);frame.topr.From=Vector2.new(titleend+5,topy);frame.topr.To=Vector2.new(rightx,topy);local sidetop=math.max(cliptop,topy);local sidebottom=math.min(clipbottom,bottomy);frame.left.From=Vector2.new(leftx,sidetop);frame.left.To=Vector2.new(leftx,sidebottom);frame.right.From=Vector2.new(rightx,sidetop);frame.right.To=Vector2.new(rightx,sidebottom);frame.bottom.From=Vector2.new(leftx,bottomy);frame.bottom.To=Vector2.new(rightx,bottomy)
        elseif item.kind=="slider"then itemtrack[i].Position=Vector2.new(x+10,y+20);itemtrack[i].Size=Vector2.new(w-20,9);itemfill[i].Position=itemtrack[i].Position;itemfill[i].Size=Vector2.new((w-20)*ratio,9);itemborder[i].Position=Vector2.new(x+7,y+17);itemborder[i].Size=Vector2.new(w-14,15);markborder[i].Position=Vector2.new(x+8,y+18);markborder[i].Size=Vector2.new(w-16,13);trackborder[i].Position=Vector2.new(x+9,y+19);trackborder[i].Size=Vector2.new(w-18,11)
        elseif item.kind=="toggle"or item.kind=="color"then itemborder[i].Position=Vector2.new(markx-2,marky-2);itemborder[i].Size=Vector2.new(markw+4,markh+4);markborder[i].Position=Vector2.new(markx-1,marky-1);markborder[i].Size=Vector2.new(markw+2,markh+2);trackborder[i].Position=Vector2.new(markx,marky);trackborder[i].Size=Vector2.new(markw,markh)
        elseif item.kind=="action"or item.kind=="text"then local px,py=itembg[i].Position.X,itembg[i].Position.Y;local pw,ph=itembg[i].Size.X,itembg[i].Size.Y;itemborder[i].Position=Vector2.new(px,py);itemborder[i].Size=Vector2.new(pw,ph);markborder[i].Position=Vector2.new(px+1,py+1);markborder[i].Size=Vector2.new(pw-2,ph-2);trackborder[i].Position=Vector2.new(px+2,py+2);trackborder[i].Size=Vector2.new(pw-4,ph-4);itembg[i].Position=Vector2.new(px+3,py+3);itembg[i].Size=Vector2.new(pw-6,ph-6)end
        local clipobjects=item.kind=="section"and{itembg[i]}or item.kind=="slider"and{itembg[i],itemmark[i],itemtrack[i],itemfill[i]}or{itembg[i],itemborder[i],itemmark[i],markborder[i],itemtrack[i],itemfill[i],trackborder[i]};if item.colorindex then clipobjects[#clipobjects+1]=toggle.inlinecolors.mark[i];clipobjects[#clipobjects+1]=toggle.inlinecolors.outer[i];clipobjects[#clipobjects+1]=toggle.inlinecolors.middle[i];clipobjects[#clipobjects+1]=toggle.inlinecolors.inner[i]end;for _,obj in ipairs(clipobjects)do local p=obj.Position;local size=obj.Size;local top=math.max(cliptop,p.Y);local bottom=math.min(clipbottom,p.Y+size.Y);if top~=p.Y or bottom~=p.Y+size.Y then obj.Position=Vector2.new(p.X,top);obj.Size=Vector2.new(size.X,math.max(0,bottom-top))end end
        end;ys[col]=y+rowadvances[i]
    end
    local trackx=menustate.x+menustate.w-10;menuchrome.scrolltrack.Position=Vector2.new(trackx,cliptop);menuchrome.scrolltrack.Size=Vector2.new(5,viewport);menuchrome.scrollborder.Position=menuchrome.scrolltrack.Position;menuchrome.scrollborder.Size=menuchrome.scrolltrack.Size;local thumbh=menustate.scrollmax[menustate.tab]>0 and math.max(28,viewport*viewport/math.max(viewport,content))or viewport;local thumby=math.floor(cliptop+(viewport-thumbh)*(menustate.scrollmax[menustate.tab]>0 and scroll/menustate.scrollmax[menustate.tab]or 0)+0.5);menuchrome.scrollthumb.Position=Vector2.new(trackx,thumby);menuchrome.scrollthumb.Size=Vector2.new(5,thumbh);menustate.scrollthumb={x=trackx-2,y=thumby,w=9,h=thumbh,tracky=cliptop,trackh=viewport,thumbh=thumbh}
    local barinset=toggle.gradientinset();toggle.layoutgradient(menurgb,menustate.x+barinset,menustate.y+3,math.max(1,displayw-barinset*2))
end
local function dropdownvalues()
    if dropdownkind=="espfont"or dropdownkind=="hudfont"then return fontnames
    elseif dropdownkind=="preset"then local values={};for i=1,#themes do values[i]=themes[i].name end;return values
    elseif dropdownkind=="distanceposition"then return {"below","above"}
    elseif dropdownkind=="scrapstyle"then return {"default","tiers","points","both"}
    elseif dropdownkind=="scrapteleport"then return {"nearest","value","random"}
    elseif dropdownkind=="ringshape"then return {"circle","square","triangle"}
    elseif dropdownkind=="rgbdirection"then return {"left","right"}
    elseif dropdownkind=="powerformat"then return {"percent","value"}
    elseif dropdownkind=="timerformat"then return {"clock","seconds"}
    elseif dropdownkind=="rakehealthformat"then return {"bar","value"}
    elseif dropdownkind=="hudstyle"then return {"container","minimal"}
    elseif dropdownkind=="poweractivitymode"then return {"activity","always"}
    elseif dropdownkind=="shopitem"then toggle.refreshshop(false);return toggle.shop.names
    elseif dropdownkind=="config"then return configslots end
    return {}
end
local function dropdownupdate(visible)
    local values=dropdownvalues();dropdownlayouts={};local rowid=dropdownkind=="espfont"and"espfontselect"or dropdownkind=="hudfont"and"hudfontselect"or dropdownkind=="preset"and"presetselect"or dropdownkind=="unit"and"distanceunitselect"or dropdownkind=="distanceposition"and"distancepositionselect"or dropdownkind=="scrapstyle"and"scrapstyleselect"or dropdownkind=="scrapteleport"and"scrapteleportselect"or dropdownkind=="ringshape"and"ringshapeselect"or dropdownkind=="rgbdirection"and"rgbdirectionselect"or dropdownkind=="powerformat"and"powerformatselect"or dropdownkind=="timerformat"and"timerformatselect"or dropdownkind=="ppmsstyle"and"ppmsstyleselect"or dropdownkind=="rakehealthformat"and"rakehealthformatselect"or dropdownkind=="hudstyle"and"hudstyleselect"or dropdownkind=="poweractivitymode"and"poweractivitymodeselect"or dropdownkind=="shopitem"and"shopitemselect"or"configselect";local source=nil
    for i=1,#itemlayouts do if itemlayouts[i].item.id==rowid and itemlayouts[i].visible then source=itemlayouts[i];break end end
    if not visible or not source then if not dropdown.opened then return end;dropdown.opened=false;dropdown.anim=0;dropdown.layout=nil;dropdown.scrollmax=0;toggle.setvisible(dropdown.panel,false);toggle.setvisible(dropdown.border,false);toggle.setvisible(dropdown.accent,false);toggle.setvisible(dropdown.scrolltrack,false);toggle.setvisible(dropdown.scrollborder,false);toggle.setvisible(dropdown.scrollthumb,false);for i=1,dropdown.max do toggle.setvisible(dropdown.bg[i],false);toggle.setvisible(dropdown.text[i],false)end;return end
    local count=math.min(#values,dropdown.visiblemax);dropdown.scrollmax=math.max(0,#values-count)
    if not dropdown.opened then local selectedindex=dropdownkind=="espfont"and fontindex or dropdownkind=="hudfont"and toggle.hudfontindex or dropdownkind=="preset"and themeindex or dropdownkind=="shopitem"and toggle.shopindex()or dropdownkind=="config"and math.max(1,configslot)or 1;dropdown.offset=clamp(selectedindex-math.ceil(count/2),0,dropdown.scrollmax);dropdown.scroll=dropdown.offset;dropdown.anim=0;dropdown.opened=true end
    dropdown.offset=clamp(dropdown.offset or 0,0,dropdown.scrollmax);dropdown.scroll=toggle.ease(dropdown.scroll,dropdown.offset,0.3);if math.abs(dropdown.scroll-dropdown.offset)<0.001 then dropdown.scroll=dropdown.offset end;dropdown.anim=toggle.ease(dropdown.anim,1,0.38)
    local w,rowh=source.item.stacked and source.w or 150,22;local x=source.x+source.w-w;local y=source.y+source.h+2;local panelh=count*rowh+7
    y=clamp(y,menustate.y+54,menustate.y+menustate.h-panelh)+math.floor((1-dropdown.anim)*6+0.5);dropdown.panel.Position=Vector2.new(x-3,y-4);dropdown.panel.Size=Vector2.new(w+6,panelh);dropdown.panel.Color=color("top");dropdown.panel.Transparency=dropdown.anim;toggle.setvisible(dropdown.panel,true);dropdown.border.Position=dropdown.panel.Position;dropdown.border.Size=dropdown.panel.Size;dropdown.border.Color=themes.borderblack;dropdown.border.Transparency=dropdown.anim;toggle.setvisible(dropdown.border,true);dropdown.accent.Position=Vector2.new(x-2,y-3);dropdown.accent.Size=Vector2.new(w+4,2);dropdown.accent.Color=toggle.accentvisual();dropdown.accent.Transparency=dropdown.anim;toggle.setvisible(dropdown.accent,true)
    local scrollable=dropdown.scrollmax>0;local trackx=x+w-12;local tracky=y+2;local trackw=11;local trackh=math.max(1,count*rowh-4);local thumbh=scrollable and math.max(24,math.floor(trackh*count/#values+0.5))or trackh;local travel=math.max(1,trackh-thumbh);local thumby=tracky+(scrollable and travel*dropdown.scroll/dropdown.scrollmax or 0);local roww=scrollable and w-15 or w
    dropdown.scrollborder.Position=Vector2.new(trackx,tracky);dropdown.scrollborder.Size=Vector2.new(trackw,trackh);dropdown.scrollborder.Color=themes.borderblack;dropdown.scrollborder.Transparency=dropdown.anim;dropdown.scrolltrack.Position=Vector2.new(trackx+1,tracky+1);dropdown.scrolltrack.Size=Vector2.new(trackw-2,trackh-2);dropdown.scrolltrack.Color=color("bg");dropdown.scrolltrack.Transparency=dropdown.anim;dropdown.scrollthumb.Position=Vector2.new(trackx+2,thumby+2);dropdown.scrollthumb.Size=Vector2.new(trackw-4,math.max(3,thumbh-4));dropdown.scrollthumb.Color=toggle.accentvisual();dropdown.scrollthumb.Transparency=dropdown.anim;toggle.setvisible(dropdown.scrollborder,scrollable);toggle.setvisible(dropdown.scrolltrack,scrollable);toggle.setvisible(dropdown.scrollthumb,scrollable);dropdown.layout={x=x-3,y=y-4,w=w+6,h=panelh,trackx=trackx,tracky=tracky,trackw=trackw,trackh=trackh,thumbx=trackx,thumby=thumby,thumbw=trackw,thumbh=thumbh,travel=travel,scrollable=scrollable}
    local first=math.floor(dropdown.scroll);local shift=(dropdown.scroll-first)*rowh;local listbottom=y+count*rowh
    for slot=1,dropdown.max do
        local index=first+slot;local iy=y+(slot-1)*rowh-shift;local rowtop=math.max(y,iy);local rowbottom=math.min(listbottom,iy+rowh-1);local on=slot<=count+1 and index<=#values and rowbottom>rowtop;toggle.setvisible(dropdown.bg[slot],on);toggle.setvisible(dropdown.text[slot],on and iy+7>=y and iy+17<=listbottom)
        if on then local value=values[index];local selected=(dropdownkind=="shopitem"and toggle.shopitem().label==value)or(dropdownkind=="espfont"and index==fontindex)or(dropdownkind=="hudfont"and index==toggle.hudfontindex)or(dropdownkind=="preset"and index==themeindex)or(dropdownkind=="unit"and value==toggle.distanceunit)or(dropdownkind=="distanceposition"and value==toggle.distanceposition)or(dropdownkind=="scrapstyle"and value==toggle.scrapstyle)or(dropdownkind=="scrapteleport"and value==toggle.scrapteleport)or(dropdownkind=="ringshape"and value==toggle.ringshape)or(dropdownkind=="rgbdirection"and value==toggle.rgbdirection)or(dropdownkind=="powerformat"and value==toggle.powerformat)or(dropdownkind=="timerformat"and value==toggle.timerformat)or(dropdownkind=="ppmsstyle"and value==toggle.ppmsstyle)or(dropdownkind=="rakehealthformat"and value==toggle.rakehealthformat)or(dropdownkind=="hudstyle"and value==toggle.hudstyle)or(dropdownkind=="poweractivitymode"and value==toggle.poweractivitymode)or(dropdownkind=="config"and index==configslot);local hover=inside(mouse.X,mouse.Y,x,rowtop,roww,rowbottom-rowtop);local textcolor=color(selected and"accent"or"text");dropdown.bg[slot].Position=Vector2.new(x,rowtop);dropdown.bg[slot].Size=Vector2.new(roww,rowbottom-rowtop);dropdown.bg[slot].Color=color(selected and"select"or hover and"hover"or"card");dropdown.bg[slot].Transparency=dropdown.anim;dropdown.text[slot].Position=Vector2.new(x+8,iy+7);dropdown.text[slot].Text=value;dropdown.text[slot].Color=textcolor;dropdown.text[slot].Transparency=dropdown.anim;toggle.applytextoutline(dropdown.text[slot],dropdown.anim,textcolor);dropdownlayouts[#dropdownlayouts+1]={x=x,y=rowtop,w=roww,h=rowbottom-rowtop,index=index,value=value}end
    end
end
local function pickerupdate(visible)
    local cfg=entrycfg(pickerentry);local on=visible and cfg~=nil
    local rgbvisible=on and(type(pickerentry)=="number"or type(pickerentry)=="string"and string.sub(pickerentry,1,6)=="crate_"or pickerentry=="distance"or pickerentry=="rake"or pickerentry=="rakehealth"or pickerentry=="rakebar"or pickerentry=="roof"or pickerentry=="hudtimer"or pickerentry=="hudtarget"or pickerentry=="hudscrap"or pickerentry=="hudpower"or pickerentry=="cooldownlabel"or pickerentry=="cooldownvalue"or pickerentry=="ppmslabel"or pickerentry=="ppmsvalue"or pickerentry=="valuetimer"or pickerentry=="valuetarget"or pickerentry=="valuescrap"or pickerentry=="valuepower"or pickerentry=="timerwarning")
    if on then toggle.ensurepicker()end;if on and not picker.opened then picker.anim=0;picker.cursorx=nil;picker.cursory=nil;picker.huey=nil;picker.opened=true elseif not on then picker.opened=false;picker.anim=0 end;if on then picker.anim=toggle.ease(picker.anim,1,0.32)elseif picker.wasvisible==false then pickerlayouts={};return end
    for i=1,#picker.baseobjects do toggle.setvisible(picker.baseobjects[i],on)end;toggle.setvisible(picker.reveal,on and picker.anim<0.999);for i=1,#picker.rgbobjects do toggle.setvisible(picker.rgbobjects[i],rgbvisible)end
    for i=1,#picker.previewrgb do toggle.setvisible(picker.previewrgb[i],false)end
    for i=1,6 do toggle.setvisible(picker.recent[i],on);toggle.setvisible(picker.recentborder[i],on)end
    if picker.wasvisible~=on then for i=1,#picker.grid do toggle.setvisible(picker.grid[i],on)end;for i=1,#picker.hue do toggle.setvisible(picker.hue[i],on)end;picker.wasvisible=on end
    toggle.setvisible(picker.accent,false);pickerlayouts={};if not on then toggle.paintgradient(picker.gradient,false);return end
    local pw,ph=280,312;local px=menustate.x+menustate.w+8;local py=clamp(menustate.y+55,2,math.max(2,cam.ViewportSize.Y-ph-2));if px+pw>cam.ViewportSize.X-2 then px=math.max(2,menustate.x-pw-8)end;local c=cfg.labelcolor;local h,s,v=tohsv(c);if not picker.hexactive then picker.hexvalue=toggle.hexof(c)end
    local alpha=picker.anim;picker.border.Position=Vector2.new(px,py);picker.border.Size=Vector2.new(pw,ph);picker.border.Color=themes.borderblack;picker.border.Transparency=alpha;picker.middleborder.Position=Vector2.new(px+1,py+1);picker.middleborder.Size=Vector2.new(pw-2,ph-2);picker.middleborder.Color=color("outline");picker.middleborder.Transparency=0.85*alpha;picker.innerborder.Position=Vector2.new(px+2,py+2);picker.innerborder.Size=Vector2.new(pw-4,ph-4);picker.innerborder.Color=themes.borderblack;picker.innerborder.Transparency=alpha
    picker.bg.Position=Vector2.new(px+3,py+3);picker.bg.Size=Vector2.new(pw-6,ph-6);picker.bg.Color=color("bg");picker.bg.Transparency=alpha;picker.top.Position=Vector2.new(px+3,py+3);picker.top.Size=Vector2.new(pw-6,25);picker.top.Color=color("top");picker.top.Transparency=alpha;local gradinset=toggle.gradientinset();toggle.layoutgradient(picker.gradient,px+gradinset,py+3,math.max(1,pw-gradinset*2));toggle.paintgradient(picker.gradient,true,alpha);picker.divider.From=Vector2.new(px+3,py+28);picker.divider.To=Vector2.new(px+pw-3,py+28);picker.divider.Color=color("select");picker.divider.Transparency=0.75*alpha
    picker.panel.Position=Vector2.new(px+7,py+34);picker.panel.Size=Vector2.new(pw-14,ph-41);picker.panel.Color=color("bg");picker.panel.Transparency=0.95*alpha;picker.panelborder.Position=picker.panel.Position;picker.panelborder.Size=picker.panel.Size;picker.panelborder.Color=color("select");picker.panelborder.Transparency=alpha
    local pickertitle=toggle.colorname(pickerentry)
    picker.title.Position=Vector2.new(px+10+math.floor((1-alpha)*7+0.5),py+9);picker.title.Text=pickertitle.." color";picker.title.Color=color("text");picker.title.Transparency=alpha
    local sx,sy,sw,sh=px+12,py+42,220,156;local cw,ch=sw/picker.cols,sh/picker.rows;local layoutkey=tostring(px)..":"..tostring(py)
    if picker.layoutkey~=layoutkey then for i=1,#picker.grid do local gx=(i-1)%picker.cols;local gy=math.floor((i-1)/picker.cols);local d=picker.grid[i];local x0=math.floor(gx*sw/picker.cols);local x1=math.ceil((gx+1)*sw/picker.cols);local y0=math.floor(gy*sh/picker.rows);local y1=math.ceil((gy+1)*sh/picker.rows);d.Position=Vector2.new(sx+x0,sy+y0);d.Size=Vector2.new(x1-x0,y1-y0);d.Color=Color3.fromHSV((gx+0.5)/picker.cols,1-(gy+0.5)/picker.rows,1);d.Transparency=1 end;picker.layoutkey=layoutkey end
    local cursorsample=Color3.fromHSV(h,s,1);local cursorlight=cursorsample.R*0.299+cursorsample.G*0.587+cursorsample.B*0.114
    picker.squareborder.Position=Vector2.new(sx-1,sy-1);picker.squareborder.Size=Vector2.new(sw+2,sh+2);picker.squareborder.Color=themes.borderblack;picker.squareborder.Transparency=alpha;local targetcursorx=sx+clamp(h*sw,2,sw-2);local targetcursory=sy+clamp((1-s)*sh,2,sh-2);picker.cursorx=toggle.ease(picker.cursorx,targetcursorx,0.36);picker.cursory=toggle.ease(picker.cursory,targetcursory,0.36);picker.cursor.Position=Vector2.new(picker.cursorx,picker.cursory);picker.cursor.Color=cursorlight>0.65 and Color3.fromHex("#101010")or Color3.fromHex("#ffffff");picker.cursor.Transparency=alpha
    local hx,hy,hw,hh=px+244,sy,22,sh;local hueh=hh/picker.huesteps
    if picker.huelayoutkey~=layoutkey or picker.cachedh~=h or picker.cacheds~=s then for i=1,#picker.hue do local d=picker.hue[i];d.Position=Vector2.new(hx,hy+(i-1)*hueh);d.Size=Vector2.new(hw,math.ceil(hueh+0.5));d.Color=Color3.fromHSV(h,s,1-(i-1)/(picker.huesteps-1));d.Transparency=1 end;picker.huelayoutkey=layoutkey;picker.cachedh=h;picker.cacheds=s end
    picker.hueborder.Position=Vector2.new(hx-1,hy-1);picker.hueborder.Size=Vector2.new(hw+2,hh+2);picker.hueborder.Color=themes.borderblack;picker.hueborder.Transparency=alpha;picker.huey=toggle.ease(picker.huey,hy+clamp((1-v)*hh,1,hh-3),0.36);picker.huecursor.Position=Vector2.new(hx-2,picker.huey);picker.huecursor.Size=Vector2.new(hw+4,4);picker.huecursor.Color=Color3.fromHex("#ffffff");picker.huecursor.Transparency=alpha;picker.reveal.Position=Vector2.new(sx,sy);picker.reveal.Size=Vector2.new(hx+hw-sx,sh);picker.reveal.Color=color("bg");picker.reveal.Transparency=1-alpha
    local fy=py+210;picker.previewborder.Position=Vector2.new(px+12,fy);picker.previewborder.Size=Vector2.new(78,27);picker.previewborder.Color=themes.borderblack;picker.previewborder.Transparency=alpha;picker.preview.Position=Vector2.new(px+14,fy+2);picker.preview.Size=Vector2.new(74,23);picker.preview.Color=cfg.rgb and rgb(0)or c;picker.preview.Transparency=alpha;toggle.setvisible(picker.preview,true)
    picker.rgbborder.Position=Vector2.new(px+98,fy);picker.rgbborder.Size=Vector2.new(72,27);picker.rgbborder.Color=themes.borderblack;picker.rgbborder.Transparency=alpha;picker.rgbbg.Position=Vector2.new(px+100,fy+2);picker.rgbbg.Size=Vector2.new(68,23);picker.rgbbg.Color=color("top");picker.rgbbg.Transparency=alpha;picker.rgbmarkborder.Position=Vector2.new(px+106,fy+8);picker.rgbmarkborder.Size=Vector2.new(11,11);picker.rgbmarkborder.Color=color("outline");picker.rgbmarkborder.Transparency=alpha;picker.rgbmark.Position=Vector2.new(px+108,fy+10);picker.rgbmark.Size=Vector2.new(7,7);picker.rgbmark.Color=cfg.rgb and toggle.accentvisual()or color("bg");picker.rgbmark.Transparency=alpha;picker.rgbtext.Position=Vector2.new(px+124,fy+8);picker.rgbtext.Color=color("text");picker.rgbtext.Transparency=alpha
    picker.doneborder.Position=Vector2.new(px+178,fy);picker.doneborder.Size=Vector2.new(88,27);picker.doneborder.Color=themes.borderblack;picker.doneborder.Transparency=alpha;picker.donebg.Position=Vector2.new(px+180,fy+2);picker.donebg.Size=Vector2.new(84,23);picker.donebg.Color=color(inside(mouse.X,mouse.Y,px+178,fy,88,27)and"hover"or"top");picker.donebg.Transparency=alpha;picker.donetext.Position=Vector2.new(px+222,fy+14);picker.donetext.Color=color("text");picker.donetext.Transparency=alpha
    local hexy=py+244;picker.hexlabel.Position=Vector2.new(px+12,hexy+6);picker.hexlabel.Color=color("muted");picker.hexlabel.Transparency=alpha;picker.hexborder.Position=Vector2.new(px+54,hexy);picker.hexborder.Size=Vector2.new(212,27);picker.hexborder.Color=picker.hexactive and toggle.accentvisual()or themes.borderblack;picker.hexborder.Transparency=alpha;picker.hexbg.Position=Vector2.new(px+56,hexy+2);picker.hexbg.Size=Vector2.new(208,23);picker.hexbg.Color=color("top");picker.hexbg.Transparency=alpha;picker.hextext.Position=Vector2.new(px+64,hexy+6);picker.hextext.Text="#"..picker.hexvalue..(picker.hexactive and"_"or"");picker.hextext.Color=color(picker.hexactive and"accent"or"text");picker.hextext.Transparency=alpha
    local recenty=py+278;picker.recentlabel.Position=Vector2.new(px+12,recenty+4);picker.recentlabel.Color=color("muted");picker.recentlabel.Transparency=alpha;pickerlayouts.recents={}
    for i=1,6 do local rx=px+64+(i-1)*34;picker.recentborder[i].Position=Vector2.new(rx,recenty);picker.recentborder[i].Size=Vector2.new(29,20);picker.recentborder[i].Color=toggle.hexof(picker.recentcolors[i])==toggle.hexof(c)and toggle.accentvisual()or themes.borderblack;picker.recentborder[i].Transparency=alpha;picker.recent[i].Position=Vector2.new(rx+2,recenty+2);picker.recent[i].Size=Vector2.new(25,16);picker.recent[i].Color=picker.recentcolors[i];picker.recent[i].Transparency=alpha;pickerlayouts.recents[i]={x=rx,y=recenty,w=29,h=20,index=i}end
    for _,d in ipairs({picker.title,picker.rgbtext,picker.donetext,picker.hexlabel,picker.hextext,picker.recentlabel})do toggle.applytextoutline(d,alpha,d.Color)end
    pickerlayouts.popup={x=px,y=py,w=pw,h=ph};pickerlayouts.square={x=sx,y=sy,w=sw,h=sh};pickerlayouts.hue={x=hx,y=hy,w=hw,h=hh};pickerlayouts.rgb=rgbvisible and{x=px+98,y=fy,w=72,h=27}or nil;pickerlayouts.done={x=px+178,y=fy,w=88,h=27};pickerlayouts.hex={x=px+54,y=hexy,w=212,h=27}
end
local function menuobjects(visible)
    local expanded=visible and(menustate.contentfade or 0)>0.01
    toggle.setvisible(menubg,visible);toggle.setvisible(menutop,visible);toggle.setvisible(menuchrome.border,visible);toggle.setvisible(menutitle,visible);toggle.setvisible(menuclose,visible);toggle.setvisible(menuside,false);toggle.setvisible(menuchrome.tabindicator,expanded);toggle.setvisible(menuchrome.content,false);toggle.setvisible(menuchrome.divider,false)
    local canscroll=expanded and(menustate.scrollmax[menustate.tab]or 0)>0;toggle.setvisible(menuchrome.scrolltrack,canscroll);toggle.setvisible(menuchrome.scrollthumb,canscroll);toggle.setvisible(menuchrome.scrollborder,canscroll)
    for i=1,2 do toggle.setvisible(menuchrome.columns[i],false);toggle.setvisible(menuchrome.columnborders[i],visible)end
    for i=1,#tabnames do toggle.setvisible(tabbg[i],expanded and i==menustate.tab);toggle.setvisible(tabborder[i],false);toggle.setvisible(tabtext[i],expanded)end
    local itemcount=math.max(#menuitems,menustate.lastitemcount or 0)
    for i=1,itemcount do
        local item=menuitems[i];local layout=itemlayouts[i];local on=expanded and item~=nil and layout and layout.visible;local sectionon=on and item.kind=="section";local slideron=on and item.kind=="slider";local markon=on and(item.kind=="toggle"or item.kind=="color");local markcfg=markon and item.kind=="color"and entrycfg(item.index)or nil;local rgbmarkon=false;local fieldon=on and(not item.stacked or layout.fieldvisible);local bordered=fieldon and(item.kind=="action"or item.kind=="text");local inlineon=on and item.colorindex~=nil and layout.markvisible
        local sliderframeon=slideron and layout.trackvisible;local markframeon=markon and layout.markvisible
        toggle.setvisible(itembg[i],item and item.kind=="section"and on or fieldon);toggle.setvisible(itemborder[i],sliderframeon or markframeon or bordered);toggle.setvisible(itemlabel[i],on and layout.textvisible);toggle.setvisible(toggle.menuinfo.items[i],on and item.info~=nil and layout.textvisible);toggle.setvisible(itemvalue[i],fieldon and layout.valuevisible and item.kind~="section"and(item.kind~="toggle"or item.inlinebind)and item.kind~="color");toggle.setvisible(itemmark[i],markframeon and not rgbmarkon);toggle.setvisible(markborder[i],sliderframeon or markframeon or bordered);toggle.setvisible(itemline[i],false);toggle.setvisible(itemtrack[i],sliderframeon);toggle.setvisible(itemfill[i],sliderframeon);toggle.setvisible(trackborder[i],sliderframeon or markframeon or bordered)
        toggle.setvisible(toggle.inlinecolors.mark[i],inlineon);toggle.setvisible(toggle.inlinecolors.outer[i],inlineon);toggle.setvisible(toggle.inlinecolors.middle[i],inlineon);toggle.setvisible(toggle.inlinecolors.inner[i],inlineon)
        local frame=sectionframes[i];if frame then local topy=layout and layout.y+15 or 0;local bottomy=layout and layout.y+layout.panelh-2 or 0;local topvisible=sectionon and topy>=layout.cliptop and topy<=layout.clipbottom;local sidevisible=sectionon and math.min(layout.clipbottom,bottomy)>math.max(layout.cliptop,topy);local bottomvisible=sectionon and bottomy>=layout.cliptop and bottomy<=layout.clipbottom;toggle.setvisible(frame.topl,topvisible);toggle.setvisible(frame.topr,topvisible);toggle.setvisible(frame.left,sidevisible);toggle.setvisible(frame.right,sidevisible);toggle.setvisible(frame.bottom,bottomvisible)end
        if itemrgb[i]then for s=1,itemrgbcount do toggle.setvisible(itemrgb[i][s],rgbmarkon)end end
    end
    menustate.lastitemcount=#menuitems
    dropdownupdate(expanded and dropdownkind~=nil and pickerentry==nil);pickerupdate(expanded and pickerentry~=nil)
end
local function menuupdate(animateonly)
    if toggle.uibatch then menustate.itemsdirty=true;return end
    if not animateonly then menustate.itemsdirty=true end
    local title=toggle.menutitle();if menutitle.Text~=title then menutitle.Text=title;menustate.watermarkw=math.min(menustate.w,math.max(100,#title*7+28))end
    local minimizetarget=menustate.minimized and 1 or 0;menustate.minimizeanim=toggle.ease(menustate.minimizeanim,minimizetarget,0.22);local transitioning=math.abs(menustate.minimizeanim-minimizetarget)>0.001;if not transitioning then menustate.minimizeanim=minimizetarget end;if toggle.watermark then menustate.menuanim=toggle.ease(menustate.menuanim,toggle.menu and 1 or 0,toggle.menu and 0.4 or 0.34)else menustate.menuanim=toggle.menu and 1 or 0 end;transitioning=transitioning or math.abs(menustate.menuanim-(toggle.menu and 1 or 0))>0.001;if math.abs(menustate.menuanim-(toggle.menu and 1 or 0))<=0.001 then menustate.menuanim=toggle.menu and 1 or 0 end;menustate.contentfade=clamp(1-menustate.minimizeanim/0.4,0,1)
    local targetscroll=menustate.scrolltarget[menustate.tab]or 0;local currentscroll=menustate.scroll[menustate.tab]or targetscroll;local moved=menustate.layoutx~=menustate.x or menustate.layouty~=menustate.y or menustate.layouttab~=menustate.tab or menustate.layoutminimized~=menustate.minimized;if not animateonly or menustate.itemsdirty or menustate.positionanimating or transitioning or math.abs(targetscroll-currentscroll)>0.001 or moved then menupos();menustate.layoutx=menustate.x;menustate.layouty=menustate.y;menustate.layouttab=menustate.tab;menustate.layoutminimized=menustate.minimized end;local mx,my=mouse.X,mouse.Y;local accentcolor=toggle.accentvisual();local contentfade=menustate.contentfade
    toggle.setprop(menubg,"Color",color("bg"));toggle.setprop(menutop,"Color",color("top"));toggle.setprop(menuside,"Color",color("side"));toggle.setprop(menutitle,"Color",color("text"));toggle.applytextoutline(menutitle,menustate.menuanim,color("text"));toggle.setprop(menuclose,"Color",color("muted"));toggle.applytextoutline(menuclose,menustate.menuanim,color("muted"));toggle.setprop(menuchrome.border,"Color",themes.borderblack);toggle.setprop(menuchrome.columnborders[1],"Color",color("outline"));toggle.setprop(menuchrome.columnborders[2],"Color",themes.borderblack);toggle.setprop(menuchrome.content,"Color",color("select"));toggle.setprop(menuchrome.divider,"Color",color("select"));toggle.setprop(menuchrome.scrolltrack,"Color",color("bg"));toggle.setprop(menuchrome.scrollthumb,"Color",accentcolor);toggle.setprop(menuchrome.scrollborder,"Color",color("select"));toggle.setprop(menuchrome.tabindicator,"Color",accentcolor);toggle.setprop(menubg,"Transparency",guiopacity);toggle.setprop(menutop,"Transparency",guiopacity*0.25);toggle.setprop(menutitle,"Transparency",1);toggle.setprop(menuclose,"Transparency",1);toggle.setprop(menuside,"Transparency",guiopacity*contentfade);toggle.setprop(menuchrome.border,"Transparency",guiopacity);toggle.setprop(menuchrome.columnborders[1],"Transparency",0.85*guiopacity);toggle.setprop(menuchrome.columnborders[2],"Transparency",guiopacity);toggle.setprop(menuchrome.content,"Transparency",guiopacity*contentfade);toggle.setprop(menuchrome.divider,"Transparency",0.7*guiopacity*contentfade);toggle.setprop(menuchrome.scrolltrack,"Transparency",0.75*guiopacity*contentfade);toggle.setprop(menuchrome.scrollthumb,"Transparency",guiopacity*contentfade);toggle.setprop(menuchrome.scrollborder,"Transparency",0.8*guiopacity*contentfade);toggle.setprop(menuchrome.tabindicator,"Transparency",guiopacity*contentfade);toggle.setprop(menuclose,"Text",menustate.minimized and"+"or"-")
    local navw=menustate.w-8;local tabw=navw/#tabnames
    for i=1,#tabnames do local tx=menustate.x+4+(i-1)*tabw;local hover=inside(mx,my,tx,menustate.y+27,tabw,25);local key="tab:"..tostring(i);menustate.hover[key]=toggle.ease(menustate.hover[key],hover and 1 or 0,0.28);local tabcolor=toggle.colormix(i==menustate.tab and accentcolor or color("text"),accentcolor,menustate.hover[key]);toggle.setprop(tabbg[i],"Color",accentcolor);toggle.setprop(tabbg[i],"Transparency",0);toggle.setprop(tabtext[i],"Color",tabcolor);toggle.applytextoutline(tabtext[i],contentfade*menustate.menuanim,tabcolor);toggle.setprop(tabtext[i],"Transparency",contentfade)end
    for i=1,#menuitems do
        local item=menuitems[i];local l=itemlayouts[i];if l.visible then local fade=item.stacked and(l.fieldfade or 0)or l.fade or 1;local borderfade=item.kind=="section"and(l.linefade or 0)or item.kind=="slider"and(l.sliderfade or 0)or fade;local hover=l.visible and item.kind~="section"and inside(mx,my,l.x,l.hittop,l.w,l.hitbottom-l.hittop);local shown=toggle.itemshown(item);local strong=item.kind=="dropdown"or item.kind=="action"or item.kind=="bind"or item.kind=="text";local animkey=tostring(menustate.tab)..":"..tostring(item.id or item.label or i);menustate.hover[animkey]=toggle.ease(menustate.hover[animkey],hover and 1 or 0,0.2);local basecolor=item.kind=="section"and"card"or strong and"top"or"card";local hovercolor=strong and"select"or"hover";toggle.setprop(itembg[i],"Color",item.kind=="section"and toggle.sectioncolor()or toggle.colormix(color(basecolor),color(hovercolor),menustate.hover[animkey]));toggle.setprop(itembg[i],"Transparency",((item.kind=="dropdown"or item.kind=="bind")and 0 or(item.kind=="section"and 0.72 or strong and(0.58+0.38*menustate.hover[animkey])or 0.13+0.25*menustate.hover[animkey])*guiopacity*fade));toggle.setprop(itemborder[i],"Color",themes.borderblack);toggle.setprop(itemborder[i],"Transparency",guiopacity*borderfade);toggle.setprop(markborder[i],"Color",color("outline"));toggle.setprop(markborder[i],"Transparency",0.9*guiopacity*borderfade);toggle.setprop(trackborder[i],"Color",themes.borderblack);toggle.setprop(trackborder[i],"Transparency",guiopacity*borderfade);toggle.setprop(itemlabel[i],"Text",item.label);toggle.setprop(itemlabel[i],"Color",color("text"));toggle.setprop(itemlabel[i],"Transparency",l.textfade);toggle.applytextoutline(itemlabel[i],l.textfade*contentfade*menustate.menuanim);toggle.setprop(toggle.menuinfo.items[i],"Text",(item.permission or item.warning)and"(!)"or"(?)");toggle.setprop(toggle.menuinfo.items[i],"Color",item.permission=="hybrid"and toggle.permissionpink or item.permission and toggle.permissionblue or item.warning and toggle.warningred or toggle.infoorange);toggle.setprop(toggle.menuinfo.items[i],"Transparency",l.textfade);toggle.applytextoutline(toggle.menuinfo.items[i],l.textfade*contentfade*menustate.menuanim);toggle.setprop(itemvalue[i],"Text",shown);toggle.setprop(itemvalue[i],"Color",color(item.stacked and"text"or"accent"));toggle.setprop(itemvalue[i],"Transparency",math.min(l.valuefade,fade));toggle.applytextoutline(itemvalue[i],math.min(l.valuefade,fade)*contentfade*menustate.menuanim);toggle.setprop(itemline[i],"Color",accentcolor);toggle.setprop(itemline[i],"Transparency",0.85*guiopacity*borderfade);toggle.setprop(itemtrack[i],"Color",color("bg"));toggle.setprop(itemtrack[i],"Transparency",guiopacity*(item.kind=="slider"and borderfade or fade));toggle.setprop(itemfill[i],"Color",accentcolor);toggle.setprop(itemfill[i],"Transparency",item.kind=="section"and borderfade or item.kind=="slider"and borderfade or fade)
        if item.kind=="toggle"then menustate.toggleanim[animkey]=toggle.ease(menustate.toggleanim[animkey],item.on and 1 or 0,0.34);toggle.setprop(itemmark[i],"Color",accentcolor);toggle.setprop(itemmark[i],"Transparency",menustate.toggleanim[animkey]*fade)
        elseif item.kind=="color"then
            local cfg=entrycfg(item.index);toggle.setprop(itemmark[i],"Color",cfg and(cfg.rgb and rgb(0)or cfg.labelcolor)or color("accent"));toggle.setprop(itemmark[i],"Transparency",fade);toggle.setprop(itemvalue[i],"Text",cfg and cfg.rgb and"RGB"or"")
        end
        if item.colorindex then local cfg=entrycfg(item.colorindex);toggle.setprop(toggle.inlinecolors.mark[i],"Color",cfg and(cfg.rgb and rgb(0)or cfg.labelcolor)or color("accent"));toggle.setprop(toggle.inlinecolors.mark[i],"Transparency",fade);toggle.setprop(toggle.inlinecolors.outer[i],"Color",themes.borderblack);toggle.setprop(toggle.inlinecolors.outer[i],"Transparency",guiopacity*borderfade);toggle.setprop(toggle.inlinecolors.middle[i],"Color",color("outline"));toggle.setprop(toggle.inlinecolors.middle[i],"Transparency",0.9*guiopacity*borderfade);toggle.setprop(toggle.inlinecolors.inner[i],"Color",themes.borderblack);toggle.setprop(toggle.inlinecolors.inner[i],"Transparency",guiopacity*borderfade)end
        local frame=sectionframes[i];if frame and item.kind=="section"then local bottomcenter=l.y+l.panelh-2;local bottomfade=clamp(math.min(bottomcenter-l.cliptop,l.clipbottom-bottomcenter)/10,0,1);toggle.setprop(frame.topl,"Color",accentcolor);toggle.setprop(frame.topr,"Color",accentcolor);toggle.setprop(frame.topl,"Transparency",guiopacity*(l.linefade or 0));toggle.setprop(frame.topr,"Transparency",guiopacity*(l.linefade or 0));toggle.setprop(frame.left,"Color",color("select"));toggle.setprop(frame.right,"Color",color("select"));toggle.setprop(frame.bottom,"Color",color("select"));toggle.setprop(frame.left,"Transparency",guiopacity*fade);toggle.setprop(frame.right,"Transparency",guiopacity*fade);toggle.setprop(frame.bottom,"Transparency",guiopacity*bottomfade)end
    end end
    if contentfade<0.999 or menustate.menuanim<0.999 then for i=1,#menuitems do for _,d in ipairs({itembg[i],itemborder[i],itemlabel[i],toggle.menuinfo.items[i],itemvalue[i],itemmark[i],markborder[i],itemline[i],itemtrack[i],itemfill[i],trackborder[i],toggle.inlinecolors.mark[i],toggle.inlinecolors.outer[i],toggle.inlinecolors.middle[i],toggle.inlinecolors.inner[i]})do if d then toggle.setprop(d,"Transparency",(d.Transparency or 1)*contentfade*menustate.menuanim)end end;local frame=sectionframes[i];if frame then for _,d in pairs(frame)do toggle.setprop(d,"Transparency",(d.Transparency or 1)*contentfade*menustate.menuanim)end end end end
    for _,d in ipairs({menubg,menutop,menutitle,menuclose,menuchrome.border,menuchrome.columnborders[1],menuchrome.columnborders[2],menuchrome.scrolltrack,menuchrome.scrollthumb,menuchrome.scrollborder,menuchrome.tabindicator})do toggle.setprop(d,"Transparency",(d.Transparency or 1)*menustate.menuanim)end;for i=1,#tabnames do toggle.setprop(tabbg[i],"Transparency",(tabbg[i].Transparency or 0)*menustate.menuanim);toggle.setprop(tabtext[i],"Transparency",(tabtext[i].Transparency or 1)*menustate.menuanim)end
    menuobjects((menustate.menuanim or 0)>0.001);toggle.tooltipupdate()
end
local function showmenu()menuupdate()end
local powercfg={{valuename="UsingSHDoor",label="house door locked",cells=3},{valuename="UsingSHLight",label="house lights on",cells=1},{valuename="UsingTowerLight",label="tower lights on",cells=3},{valuename="UsingTowerRadar",label="tower radar on",cells=1}}
local powerlines={}
for i=1,#powercfg do powerlines[i]=setz(newtext(powercfg[i].label,Color3.fromHex("#ffffff"),false,false),25)end
toggle.powerempty=setz(newtext("nothing is active",Color3.fromHex("#777777"),false,false),25)
setz(powerlabel,25)
toggle.powerpanel={x=math.max(2,cam.ViewportSize.X-225),y=math.max(2,cam.ViewportSize.Y-190),w=164,h=64,defaultoffsetx=225,defaultoffsety=190,anim=0,lineactive={},bg=setz(newsquare(Color3.fromHex("#262626"),0.95),20),top=setz(newsquare(Color3.fromHex("#363636"),0.95),21),outer=setz(newborder(Color3.fromHex("#000000"),1),24),middle=setz(newborder(Color3.fromHex("#555555"),1),24),inner=setz(newborder(Color3.fromHex("#000000"),1),24),accent=setz(newsquare(Color3.fromHex("#99c30b"),1),23),divider=setz(newline(Color3.fromHex("#111111")),23)}
toggle.powerpanel.divider.Thickness=1
toggle.powerpanel.gradient=toggle.makegradient(32,23);toggle.powerpanel.accent.Visible=false
toggle.huditems={{id="cooldown",value=toggle.cooldowndraw.value,label=toggle.cooldowndraw.label},{id="timer",value=timertxt,label=timerlabel},{id="target",value=targettxt,label=targetlabel},{id="scrap",value=scraptxt,label=scraplabel},{id="power",value=toggle.powerdraw.value,label=toggle.powerdraw.label}}
for i=1,#toggle.huditems do setz(toggle.huditems[i].value,18);setz(toggle.huditems[i].label,18);toggle.huditems[i].anim=toggle.hud and toggle.hudelements[toggle.huditems[i].id]==true and 1 or 0 end
for i=1,5 do setz(toggle.ppmsdraw.squares[i],26);setz(toggle.ppmsdraw.borders[i],27)end
toggle.ppmsdraw.value.Visible=false;toggle.ppmsdraw.label.Visible=false
toggle.makewidgetframe=function()
    return {bg=setz(newsquare(Color3.fromHex("#262626"),0.95),10),top=setz(newsquare(Color3.fromHex("#363636"),0.95),11),outer=setz(newborder(Color3.fromHex("#000000"),1),14),middle=setz(newborder(Color3.fromHex("#555555"),1),14),inner=setz(newborder(Color3.fromHex("#000000"),1),14),accent=setz(newsquare(Color3.fromHex("#99c30b"),1),13),gradient=toggle.makegradient(72,13)}
end
toggle.groupwidget=toggle.makewidgetframe();toggle.setvisible(toggle.groupwidget.accent,false);toggle.widgetgroup={x=nil,y=nil,w=0,h=0,dragged=false}
toggle.applyradius=function()
    toggle.applymenuradius();for _,frame in ipairs({toggle.groupwidget,toggle.powerpanel})do for _,entry in ipairs({{frame.outer,0},{frame.middle,1},{frame.inner,2},{frame.bg,3},{frame.top,3}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end end
    for _,entry in ipairs({{picker.border,0},{picker.middleborder,1},{picker.innerborder,2},{picker.bg,3},{picker.top,3}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end
    for _,d in ipairs({picker.panel,picker.panelborder,picker.previewborder,picker.preview,picker.rgbborder,picker.rgbbg,picker.doneborder,picker.donebg,picker.hexborder,picker.hexbg})do pcall(function()d.Corner=math.min(3,toggle.borderradius)end)end
    for _,d in ipairs({picker.squareborder,picker.hueborder,picker.huecursor,picker.rgbmarkborder,picker.rgbmark})do pcall(function()d.Corner=math.min(2,toggle.borderradius)end)end
    for i=1,6 do pcall(function()picker.recentborder[i].Corner=math.min(2,toggle.borderradius);picker.recent[i].Corner=math.min(1,toggle.borderradius)end)end
end
toggle.applyradius()
toggle.placewidget=function(frame,x,y,w,h)
    x=toggle.pixel(x);y=toggle.pixel(y);w=toggle.pixel(w);h=toggle.pixel(h);frame.x=x;frame.y=y;frame.w=w;frame.h=h
    frame.outer.Position=Vector2.new(x,y);frame.outer.Size=Vector2.new(w,h);frame.middle.Position=Vector2.new(x+1,y+1);frame.middle.Size=Vector2.new(w-2,h-2);frame.inner.Position=Vector2.new(x+2,y+2);frame.inner.Size=Vector2.new(w-4,h-4);frame.bg.Position=Vector2.new(x+3,y+3);frame.bg.Size=Vector2.new(w-6,h-6);frame.top.Position=Vector2.new(x+3,y+3);frame.top.Size=Vector2.new(w-6,7);toggle.setvisible(frame.accent,false);local inset=toggle.gradientinset();toggle.layoutgradient(frame.gradient,x+inset,y+3,math.max(1,w-inset*2))
end
toggle.paintwidget=function(frame,on,phaseoffset)
    toggle.setvisible(frame.accent,false);if not on then toggle.setvisible(frame.outer,false);toggle.setvisible(frame.middle,false);toggle.setvisible(frame.inner,false);toggle.setvisible(frame.bg,false);toggle.setvisible(frame.top,false);toggle.paintgradient(frame.gradient,false);return end
    phaseoffset=clamp(tonumber(phaseoffset)or 1,0,1);toggle.setprop(frame.outer,"Color",themes.borderblack);toggle.setprop(frame.outer,"Transparency",guiopacity*phaseoffset);toggle.setvisible(frame.outer,true);toggle.setprop(frame.middle,"Color",color("outline"));toggle.setprop(frame.middle,"Transparency",0.85*guiopacity*phaseoffset);toggle.setvisible(frame.middle,true);toggle.setprop(frame.inner,"Color",themes.borderblack);toggle.setprop(frame.inner,"Transparency",guiopacity*phaseoffset);toggle.setvisible(frame.inner,true);toggle.setprop(frame.bg,"Color",color("bg"));toggle.setprop(frame.bg,"Transparency",guiopacity*phaseoffset);toggle.setvisible(frame.bg,true);toggle.setprop(frame.top,"Color",color("top"));toggle.setprop(frame.top,"Transparency",0.25*guiopacity*phaseoffset);toggle.setvisible(frame.top,true);toggle.paintgradient(frame.gradient,true,guiopacity*phaseoffset)
end
toggle.hidewidgets=function()
    toggle.paintwidget(toggle.groupwidget,false)
end
toggle.hudbarvisible=function()return toggle.hudstyle=="minimal"and(toggle.hudalpha or 0)>0.01 and rgbwidth>0 end
toggle.hudvisible=function(id)
    if id=="cooldown"then return toggle.hud and toggle.teleportcooldown and toggle.cooldownremaining>0 end
    return toggle.hud and toggle.hudelements[id]==true
end
local function rgbpos()
    local center=anchors();local y=center.Y-8;local x=toggle.hudbarleft or center.X-rgbwidth/2;local w=rgbwidth/barseg
    for i=1,barseg do local d=rgbline[i];d.From=Vector2.new(x+(i-1)*w,y);d.To=Vector2.new(x+i*w,y) end
end
local function powerpos()
    if toggle.uibatch then toggle.huddirty=true;return end
    local p,n,mask=toggle.powerpanel,0,0
    for i=1,#powerlines do if p.lineactive[i]then n=n+1;mask=mask+2^(i-1)end end
    local showalways=toggle.poweractivitymode=="always";local hasactivity=n>0;local empty=toggle.poweractivity and showalways and not hasactivity;local rows=toggle.poweractivity and(empty and 1 or n)or 0;local volt=toggle.ppms and not toggle.ppmspowerblocked and(hasactivity or showalways);local shown=math.min(toggle.ppmslevel or 0,5);local contentw=toggle.textwidth(powerlabel);if empty then contentw=math.max(contentw,toggle.textwidth(toggle.powerempty))end;for i=1,#powerlines do if p.lineactive[i]then contentw=math.max(contentw,toggle.textwidth(powerlines[i]))end end;if volt and shown>0 then contentw=math.max(contentw,shown*12+(shown-1)*3)end;p.w=math.max(100,contentw+20);p.h=36+rows*17+(volt and 23 or 0);p.x=clamp(p.x,0,math.max(0,cam.ViewportSize.X-p.w));p.y=clamp(p.y,0,math.max(0,cam.ViewportSize.Y-p.h));local activityon=toggle.poweractivity and(hasactivity or showalways);local on=toggle.hud and(activityon or volt);p.anim=toggle.ease(p.anim,on and 1 or 0,on and 0.26 or 0.3);local drawon=p.anim>0.01;local drawy=p.y+math.floor((1-p.anim)*8+0.5);local alpha=guiopacity*p.anim;local contentalpha=p.anim
    local geometrychanged=p.lastx~=p.x or p.lastdrawy~=drawy or p.lastw~=p.w or p.lasth~=p.h or p.lastmask~=mask or p.lastrows~=rows or p.lastvolt~=volt or p.lastlevel~=shown or p.lastradius~=toggle.borderradius;p.lastx=p.x;p.lastdrawy=drawy;p.lastw=p.w;p.lasth=p.h;p.lastmask=mask;p.lastrows=rows;p.lastvolt=volt;p.lastlevel=shown;p.lastradius=toggle.borderradius
    n=0;for i=1,#powerlines do local line=powerlines[i];local lineon=drawon and toggle.poweractivity and p.lineactive[i]or false;toggle.setvisible(line,lineon);if lineon then n=n+1;if geometrychanged then line.Position=Vector2.new(p.x+10,drawy+29+(n-1)*17)end;toggle.setprop(line,"Color",color("text"));toggle.setprop(line,"Transparency",contentalpha);toggle.applytextoutline(line,contentalpha)end end
    if geometrychanged then toggle.powerempty.Position=Vector2.new(p.x+10,drawy+29)end;toggle.setprop(toggle.powerempty,"Color",color("muted"));toggle.setprop(toggle.powerempty,"Transparency",contentalpha);toggle.applytextoutline(toggle.powerempty,contentalpha);toggle.setvisible(toggle.powerempty,drawon and empty)
    if geometrychanged then local inset=toggle.gradientinset();p.outer.Position=Vector2.new(p.x,drawy);p.outer.Size=Vector2.new(p.w,p.h);p.middle.Position=Vector2.new(p.x+1,drawy+1);p.middle.Size=Vector2.new(p.w-2,p.h-2);p.inner.Position=Vector2.new(p.x+2,drawy+2);p.inner.Size=Vector2.new(p.w-4,p.h-4);p.bg.Position=Vector2.new(p.x+3,drawy+3);p.bg.Size=Vector2.new(p.w-6,p.h-6);p.top.Position=Vector2.new(p.x+3,drawy+3);p.top.Size=Vector2.new(p.w-6,22);p.accent.Visible=false;toggle.layoutgradient(p.gradient,p.x+inset,drawy+3,math.max(1,p.w-inset*2));powerlabel.Position=Vector2.new(p.x+10,drawy+9)end
    toggle.setprop(p.outer,"Color",themes.borderblack);toggle.setprop(p.outer,"Transparency",alpha);toggle.setvisible(p.outer,drawon);toggle.setprop(p.middle,"Color",color("outline"));toggle.setprop(p.middle,"Transparency",0.85*alpha);toggle.setvisible(p.middle,drawon);toggle.setprop(p.inner,"Color",themes.borderblack);toggle.setprop(p.inner,"Transparency",alpha);toggle.setvisible(p.inner,drawon);toggle.setprop(p.bg,"Color",color("bg"));toggle.setprop(p.bg,"Transparency",alpha);toggle.setvisible(p.bg,drawon);toggle.setprop(p.top,"Color",color("top"));toggle.setprop(p.top,"Transparency",0.25*alpha);toggle.setvisible(p.top,drawon);toggle.paintgradient(p.gradient,drawon,alpha);toggle.setvisible(p.divider,false);toggle.setprop(powerlabel,"Color",color("text"));toggle.setvisible(powerlabel,drawon);toggle.setprop(powerlabel,"Transparency",contentalpha);toggle.applytextoutline(powerlabel,contentalpha)
    local total=shown>0 and shown*12+(shown-1)*3 or 0;local startx=p.x+math.floor((p.w-total)/2);local celly=drawy+29+rows*17
    for i=1,5 do local cellon=drawon and volt and i<=shown;local square,border=toggle.ppmsdraw.squares[i],toggle.ppmsdraw.borders[i];if geometrychanged then local sx=startx+(i-1)*15;square.Position=Vector2.new(sx,celly);square.Size=Vector2.new(12,20);border.Position=Vector2.new(sx+9,celly);border.Size=Vector2.new(3,20)end;toggle.setprop(square,"Transparency",contentalpha);toggle.setprop(border,"Transparency",0.48*contentalpha);toggle.setvisible(square,cellon);toggle.setvisible(border,cellon)end
end
toggle.placehudcontent=function(item,x,valuey)
    local targety=valuey+(1-item.anim)*7;item.drawx=toggle.ease(item.drawx,x,0.24);item.drawy=toggle.ease(item.drawy,targety,0.24);if math.abs(item.drawx-x)>0.01 or math.abs(item.drawy-targety)>0.01 then toggle.hudanimating=true end;toggle.setpos(item.value,item.drawx,item.drawy);toggle.setpos(item.label,item.drawx,item.drawy+18);toggle.setprop(item.value,"Transparency",item.anim);toggle.setprop(item.label,"Transparency",item.anim);toggle.applytextoutline(item.value,item.anim);toggle.applytextoutline(item.label,item.anim);toggle.setvisible(item.value,item.anim>0.01);toggle.setvisible(item.label,item.anim>0.01)
end
local function hudpos()
    if toggle.uibatch then toggle.huddirty=true;return end
    toggle.hudanimating=false;local center=anchors();local y=center.Y-50;local active=toggle.hudactive or{};toggle.hudactive=active;for i=#active,1,-1 do active[i]=nil end;local hudalpha=0
    for i=1,#toggle.huditems do local item=toggle.huditems[i];local target=toggle.hudvisible(item.id);local targetalpha=target and 1 or 0;item.anim=toggle.ease(item.anim,targetalpha,target and 0.3 or 0.24);if math.abs(item.anim-targetalpha)<0.001 then item.anim=targetalpha else toggle.hudanimating=true end;hudalpha=math.max(hudalpha,item.anim);if target or item.anim>0.01 then active[#active+1]=item else toggle.setvisible(item.value,false);toggle.setvisible(item.label,false)end end;toggle.hudalpha=hudalpha
    local count=#active;local spacing=120;local start=center.X-(count-1)*spacing/2;toggle.hudcount=count
    if toggle.hudstyle=="container"then
        rgbwidth=0;toggle.hudbarleft=center.X
        if count>0 then local cellw,cellh=112,58;local w,h=count*cellw,cellh;local g=toggle.widgetgroup;if g.x==nil or not g.dragged then g.x=toggle.pixel((cam.ViewportSize.X-w)/2)end;if g.y==nil then g.y=center.Y-70 end;g.x=clamp(g.x,0,math.max(0,cam.ViewportSize.X-w));g.y=clamp(g.y,0,math.max(0,cam.ViewportSize.Y-h));g.w=w;g.h=h;g.drawx=toggle.ease(g.drawx,g.x,0.24);g.draww=toggle.ease(g.draww,w,0.24);if math.abs(g.drawx-g.x)>0.01 or math.abs(g.draww-w)>0.01 then toggle.hudanimating=true end;toggle.placewidget(toggle.groupwidget,g.drawx,g.y,g.draww,h);toggle.paintwidget(toggle.groupwidget,true,hudalpha);for i=1,count do local item=active[i];toggle.placehudcontent(item,g.x+(i-0.5)*cellw,g.y+25)end else toggle.paintwidget(toggle.groupwidget,false)end
    else
        toggle.hidewidgets();for i=1,count do local item=active[i];toggle.placehudcontent(item,start+(i-1)*spacing,y)end
        if count>0 then local first,last=active[1],active[count];local firstw=math.max(42,math.max(#first.value.Text,#first.label.Text)*7);local lastw=math.max(42,math.max(#last.value.Text,#last.label.Text)*7);local left=start-firstw/2-10;local right=start+(count-1)*spacing+lastw/2+10;rgbwidth=math.max(80,right-left);toggle.hudbarleft=rgbwidth==80 and center.X-40 or left else rgbwidth=0;toggle.hudbarleft=center.X end
    end
    rgbpos()
end
hudpos()
local cratenames={FirstAidKit="medkit",Vitamins="vitamin",UV_Lamp="uv_lamp",StunStick="stun",Vest="vest",Tracker="tracker"}
local cratetext=Color3.fromHex("#ffffff")
local cratebg=Color3.fromHex("#000000")
local cratecol,craterow,cratey=55,16,70
local cratepadx,cratepady=36,12
local cratewidth=cratecol*2+cratepadx*2
espcfg={
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
    RakeTrapModel={rootname="HitBox",text="trap",color=Color3.fromHex("#edd2f3"),ringradius=2.2,ringyoffset=0,group="traps"},
    Box={rootname="HitBox",text="supply",color=Color3.fromHex("#46ffbe"),ringradius=6,ringyoffset=3.2,crate=true,group="crates"},
    SupplyCrate={rootname="HitBox",text="supply",color=Color3.fromHex("#46ffbe"),ringradius=6,ringyoffset=3.2,crate=true,group="crates"}
}
for _,cfg in pairs(espcfg)do cfg.labelcolor=cfg.color;cfg.rgb=false;cfg.defaultcolor=cfg.color;cfg.defaultrgb=false end
local tracked={}
local byaddr={}
toggle.bysource=setmetatable({},{__mode="k"})
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
    rec.name=newtext(rec.cfg.text,rec.cfg.labelcolor,true,false,toggle.esptextoutline);rec.name.Size=espfontsize;rec.name.Font=font
    rec.distance=newtext("0m",toggle.distancestyle.labelcolor,true,false,toggle.esptextoutline);rec.distance.Size=espfontsize;rec.distance.Font=font
end
local function makering(rec)
    if rec.cfg.noring or rec.ring or not toggle.ringenabled then return end
    rec.ring={}
    for i=1,ringseg do rec.ring[i]=newline(rec.cfg.color)end
end
local function hidering(rec)if rec.ring then for i=1,#rec.ring do hide(rec.ring[i])end end end
local function makecrate(rec)
    if not rec.cfg.crate or rec.items then return end
    rec.bg=setz(newsquare(cratebg,guiopacity),4);rec.bgouter=setz(newborder(Color3.fromHex("#000000"),1),7);rec.bgmiddle=setz(newborder(Color3.fromHex("#555555"),1),7);rec.bginner=setz(newborder(Color3.fromHex("#000000"),1),7);rec.items={};rec.crateradius=toggle.borderradius
    for _,entry in ipairs({{rec.bgouter,0},{rec.bgmiddle,1},{rec.bginner,2},{rec.bg,3}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end
    for i=1,6 do rec.items[i]=setz(newtext("",cratetext,true,false,toggle.esptextoutline),8);rec.items[i].Font=font end
end
local function hiderec(rec)
    if rec.hidden then return end;rec.hidden=true
    hide(rec.name);hide(rec.distance);hidering(rec);hide(rec.bg);hide(rec.bgouter);hide(rec.bgmiddle);hide(rec.bginner)
    if rec.items then for i=1,#rec.items do hide(rec.items[i])end end
end
local function removerec(rec)
    remove(rec.name);remove(rec.distance)
    if rec.ring then for i=1,#rec.ring do remove(rec.ring[i])end end
    remove(rec.bg);remove(rec.bgouter);remove(rec.bgmiddle);remove(rec.bginner)
    if rec.items then for i=1,#rec.items do remove(rec.items[i])end end
end
local function track(inst)
    if not inst or toggle.bysource[inst]or #tracked>=maxtrack then return end
    local model=getmodel(inst)
    local cfgname,cfg=getcfg(inst,model)
    if not cfg then return end
    local part,rmodel=getpart(inst,model,cfgname,cfg)
    if not part then return end
    local source=rmodel or part
    local address=source.Address
    if not address or byaddr[address]then return end
    local rec={address=address,source=inst,object=part,model=rmodel or part.Parent,cfgname=cfgname,cfg=cfg,folder=cfg.crate and itemfolder(rmodel)or nil,hidden=true}
    byaddr[address]=rec;toggle.bysource[inst]=rec;tracked[#tracked+1]=rec
end
local function untrack(i)
    local rec=tracked[i]
    if not rec then return end
    removerec(rec);byaddr[rec.address]=nil;if rec.source then toggle.bysource[rec.source]=nil end;tracked[i]=tracked[#tracked];tracked[#tracked]=nil
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
        local crates=debris:FindFirstChild("SupplyCrates")or debris:FindFirstChild("SupplyCreates")
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
    if not toggle.supplyitems then hide(rec.bg);hide(rec.bgouter);hide(rec.bgmiddle);hide(rec.bginner);if rec.items then for i=1,#rec.items do hide(rec.items[i])end end;return end
    if not rec.folder or not rec.folder.Parent then rec.folder=itemfolder(rec.model)end
    if meters>cratedist or not rec.folder then
        hide(rec.bg);hide(rec.bgouter);hide(rec.bgmiddle);hide(rec.bginner);if rec.items then for i=1,#rec.items do hide(rec.items[i])end end;return
    end
    makecrate(rec)
    if rec.crateradius~=toggle.borderradius then rec.crateradius=toggle.borderradius;for _,entry in ipairs({{rec.bgouter,0},{rec.bgmiddle,1},{rec.bginner,2},{rec.bg,3}})do pcall(function()entry[1].Corner=math.max(0,toggle.borderradius-entry[2])end)end end
    local now=toggle.frametime or tick();if not rec.itemscache or now-(rec.itemcachetime or 0)>=0.1 then rec.itemscache=rec.folder:GetChildren();rec.itemcachetime=now end;local children=rec.itemscache
    local visible=math.min(#children,#rec.items)
    for i=1,#rec.items do
        local d,child=rec.items[i],children[i]
        if child then
            local n=i-1;local row=math.floor(n/3);local col=n%3
            local taken=child:FindFirstChild("Taken");local istaken=taken and taken:IsA("BoolValue")and taken.Value==true;toggle.setprop(d,"Text",istaken and"[taken]"or(cratenames[child.Name]or child.Name));local itemstyle=toggle.cratestyles[child.Name];local itemcolor=istaken and color("accent")or itemstyle and(itemstyle.rgb and rgb((i-1)/#rec.items)or itemstyle.labelcolor)or cratetext;toggle.setprop(d,"Color",itemcolor);toggle.applyespoutline(d,1,itemcolor)
            toggle.setpos(d,screen.X+(col-1)*cratecol,screen.Y-12+yoffset+row*craterow+cratey);toggle.setvisible(d,true)
        else toggle.setvisible(d,false)end
    end
    if visible>0 then
        local rows=math.max(1,math.ceil(visible/3));local firsty=screen.Y-12+yoffset+cratey;local miny=firsty-8-cratepady
        local height=(rows-1)*craterow+16+cratepady*2;local left=screen.X-cratewidth/2;toggle.setprop(rec.bgouter,"Size",Vector2.new(cratewidth,height));toggle.setpos(rec.bgouter,left,miny);toggle.setprop(rec.bgmiddle,"Size",Vector2.new(cratewidth-2,height-2));toggle.setpos(rec.bgmiddle,left+1,miny+1);toggle.setprop(rec.bginner,"Size",Vector2.new(cratewidth-4,height-4));toggle.setpos(rec.bginner,left+2,miny+2);toggle.setprop(rec.bg,"Size",Vector2.new(cratewidth-6,height-6));toggle.setpos(rec.bg,left+3,miny+3);toggle.setprop(rec.bgouter,"Color",themes.borderblack);toggle.setprop(rec.bgmiddle,"Color",color("outline"));toggle.setprop(rec.bginner,"Color",themes.borderblack);toggle.setprop(rec.bg,"Color",toggle.sectioncolor());toggle.setprop(rec.bgouter,"Transparency",guiopacity);toggle.setprop(rec.bgmiddle,"Transparency",0.85*guiopacity);toggle.setprop(rec.bginner,"Transparency",guiopacity);toggle.setprop(rec.bg,"Transparency",guiopacity);toggle.setvisible(rec.bgouter,true);toggle.setvisible(rec.bgmiddle,true);toggle.setvisible(rec.bginner,true);toggle.setvisible(rec.bg,true)
    else toggle.setvisible(rec.bg,false);toggle.setvisible(rec.bgouter,false);toggle.setvisible(rec.bgmiddle,false);toggle.setvisible(rec.bginner,false)end
end
toggle.ringpoint=function(world,y,radius,t,sides,angle)
    if sides==0 then local a=angle+2*math.pi*t;return Vector3.new(world.X+math.cos(a)*radius,y,world.Z+math.sin(a)*radius)end
    local scaled=t*sides;local side=math.floor(scaled)%sides;local blend=scaled-math.floor(scaled);local a=angle-math.pi/2+2*math.pi*side/sides;local b=angle-math.pi/2+2*math.pi*((side+1)%sides)/sides
    return Vector3.new(world.X+(math.cos(a)*(1-blend)+math.cos(b)*blend)*radius,y,world.Z+(math.sin(a)*(1-blend)+math.sin(b)*blend)*radius)
end
local function drawring(rec,world,meters)
    if rec.cfg.noring or not toggle.ringenabled or meters>=ringfade then hidering(rec);return end
    makering(rec);if not rec.ring then return end
    local y=world.Y-(rec.cfg.ringyoffset or 0);local radius=(rec.cfg.ringradius or 2)*toggle.ringsize;local alpha=clamp(1-meters/ringfade,0,1);local sides=toggle.ringshape=="triangle"and 3 or toggle.ringshape=="square"and 4 or 0;local angle=toggle.ringspin and(toggle.frametime or tick())*toggle.ringspinspeed or 0;local cachekey=tostring(sides)..":"..tostring(ringseg);local unit=toggle.ringunit[cachekey]
    if not unit then unit={};for n=0,ringseg do local point=toggle.ringpoint(Vector3.new(0,0,0),0,1,n/ringseg,sides,0);unit[n+1]=Vector2.new(point.X,point.Z)end;toggle.ringunit[cachekey]=unit end
    local cosa,sina=1,0;if angle~=0 then cosa,sina=math.cos(angle),math.sin(angle)end;local first=unit[1];local firstx=first.X*cosa-first.Y*sina;local firstz=first.X*sina+first.Y*cosa;local previous,previouson=WorldToScreen(Vector3.new(world.X+firstx*radius,y,world.Z+firstz*radius))
    for i=1,ringseg do
        local point=unit[i+1];local px=point.X*cosa-point.Y*sina;local pz=point.X*sina+point.Y*cosa;local current,currenton=WorldToScreen(Vector3.new(world.X+px*radius,y,world.Z+pz*radius));local line=rec.ring[i];local visible=toggle.esp and previouson and currenton
        if visible then line.From=previous;line.To=current;toggle.setprop(line,"Color",rec.cfg.rgb and toggle.ringrgbcolor or rec.cfg.labelcolor);toggle.setprop(line,"Transparency",alpha)end;toggle.setvisible(line,visible);previous,previouson=current,currenton
    end
end
local function drawrec(rec,viewer)
    local object=rec.object
    if not object or not object.Parent then return false end
    local group=rec.cfg.group
    if not espgroups[group]or espgroups.items[rec.cfgname]==false then hiderec(rec);return true end
    local world=object.Position
    local screen,on=WorldToScreen(world)
    if not on then hiderec(rec);return true end
    rec.hidden=false
    local meters=dist(viewer,world);local yoffset=rec.cfg.textyoffset or 0;local sx,sy=screen.X,screen.Y
    makelabels(rec)
    local alpha=1
    local labelvisible=toggle.esp and(not rec.cfg.crate or toggle.supplylabel);local topy=sy-espfontsize-2+yoffset;local bottomy=sy+2+yoffset;local labelcolor=rec.cfg.rgb and rgb(0)or rec.cfg.labelcolor;toggle.setprop(rec.name,"Text",rec.cfg.text);toggle.setpos(rec.name,sx,toggle.distanceposition=="above"and bottomy or topy);toggle.setprop(rec.name,"Transparency",alpha);toggle.setprop(rec.name,"Color",labelcolor);toggle.applyespoutline(rec.name,alpha);toggle.setprop(rec.name,"Size",espfontsize);toggle.setvisible(rec.name,labelvisible)
    toggle.setpos(rec.distance,sx,toggle.distanceposition=="above"and topy or bottomy);local distancetext=tostring(math.floor(meters)).."m";toggle.setprop(rec.distance,"Text",distancetext);local distancecolor=toggle.distancestyle.rgb and rgb(0)or toggle.distancestyle.labelcolor;toggle.setprop(rec.distance,"Color",distancecolor);toggle.setprop(rec.distance,"Transparency",1);toggle.applyespoutline(rec.distance,1);toggle.setprop(rec.distance,"Size",espfontsize);toggle.setvisible(rec.distance,labelvisible and toggle.distance and(not toggle.distanceminimum or meters>=toggle.distancemin))
    drawcrate(rec,Vector2.new(sx,sy),meters,yoffset);drawring(rec,world,meters)
    return true
end
local raketarget=nil
local rakeroof=nil
local rakehp=nil
local function rakeinfo()
    local rake=ws:FindFirstChild("Rake")
    raketarget=rake and rake:FindFirstChild("TargetVal")or nil
    toggle.rakehumanoid=rake and rake:FindFirstChild("Monster")or nil;if toggle.rakehumanoid and not toggle.rakehumanoid:IsA("Humanoid")then toggle.rakehumanoid=nil end;if not toggle.rakehumanoid and rake then toggle.rakehumanoid=findclass(rake,"Humanoid")end
    toggle.rakepart=rake and(rake:FindFirstChild("HumanoidRootPart")or rake:FindFirstChild("Torso")or findclass(rake,"BasePart"))or nil;if toggle.rakepart and not toggle.rakepart:IsA("BasePart")then toggle.rakepart=findclass(rake,"BasePart")end
    local map=ws:FindFirstChild("Map");local safehouse=map and map:FindFirstChild("SafeHouse");local rakebreak=safehouse and finddesc(safehouse,"RakeBreak");local breakmodel=rakebreak and finddesc(rakebreak,"BreakModel");local health=breakmodel and finddesc(breakmodel,"Health")
    if breakmodel and health and health:IsA("IntValue")then rakeroof=breakmodel;rakehp=health;toggle.roofpart=findclass(breakmodel,"BasePart");toggle.setprop(roofhp,"Text",tostring(health.Value).."/30")else rakeroof=nil;rakehp=nil;toggle.roofpart=nil end
end
local function getchar(part)
    local current=part
    while current do if current:FindFirstChild("Humanoid")then return current end;current=current.Parent end
end
local function drawroof()
    if not toggle.esp or not toggle.roof or not rakeroof or not rakehp then toggle.setvisible(rooflabel,false);toggle.setvisible(roofhp,false);return end
    local part=toggle.roofpart;if not part or not part.Parent then part=findclass(rakeroof,"BasePart");toggle.roofpart=part end
    if not part then toggle.setvisible(rooflabel,false);toggle.setvisible(roofhp,false);return end
    local screen,on=WorldToScreen(part.Position)
    if not on then toggle.setvisible(rooflabel,false);toggle.setvisible(roofhp,false);return end
    local roofcolor=roofstyle.rgb and rgb(0)or roofstyle.labelcolor
    local sx,sy=screen.X,screen.Y;local hptext=tostring(rakehp.Value).."/30";toggle.setprop(roofhp,"Text",hptext);toggle.setprop(roofhp,"Color",roofcolor);toggle.setprop(rooflabel,"Color",roofcolor);toggle.applyespoutline(rooflabel,1);toggle.applyespoutline(roofhp,1);toggle.setprop(rooflabel,"Size",espfontsize);toggle.setprop(roofhp,"Size",espfontsize);toggle.setpos(rooflabel,sx,sy-espfontsize-2);toggle.setpos(roofhp,sx,sy+2);toggle.setvisible(rooflabel,true);toggle.setvisible(roofhp,true)
end
toggle.drawrake=function(viewer)
    local d=toggle.rakedraw;local part=toggle.rakepart;local humanoid=toggle.rakehumanoid;local visible=toggle.esp and part and part.Parent and humanoid and humanoid.Parent and(toggle.rakename or toggle.rakehealth or toggle.rakedistance)
    if not visible then for _,entry in pairs(d)do toggle.setvisible(entry,false)end;return end
    local world=part.Position;local screen,on=WorldToScreen(Vector3.new(world.X,world.Y+4,world.Z));if not on then for _,entry in pairs(d)do toggle.setvisible(entry,false)end;return end
    local sx,sy=screen.X,screen.Y;local meters=dist(viewer,world);local alpha=1;local labelcolor=toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor;local healthcolor=toggle.rakebarstyle.rgb and rgb(0)or toggle.rakebarstyle.labelcolor;local health=tonumber(humanoid.Health)or 0;local maximum=tonumber(humanoid.MaxHealth)or 0;local bar=toggle.rakehealth and toggle.rakehealthformat=="bar";local ratio=maximum>0 and clamp(health/maximum,0,1)or 0
    local dynamic=Color3.fromHSV(ratio/3,0.9,1);if toggle.healthbased then healthcolor=dynamic end
    toggle.setprop(d.name,"Text",toggle.rakenamevalue);toggle.setpos(d.name,sx,sy-espfontsize-2+toggle.rakenamey);toggle.setprop(d.name,"Color",labelcolor);toggle.setprop(d.name,"Transparency",alpha);toggle.applyespoutline(d.name,alpha);toggle.setprop(d.name,"Size",espfontsize);toggle.setprop(d.name,"Font",font);toggle.setvisible(d.name,toggle.rakename)
    local healthtext=tostring(math.floor(health+0.5));toggle.setprop(d.health,"Text",healthtext);toggle.setpos(d.health,sx,sy+2+toggle.rakehealthy);toggle.setprop(d.health,"Color",healthcolor);toggle.setprop(d.health,"Transparency",alpha);toggle.applyespoutline(d.health,alpha);toggle.setprop(d.health,"Size",espfontsize);toggle.setprop(d.health,"Font",font);toggle.setvisible(d.health,toggle.rakehealth and not bar)
    toggle.setpos(d.barbg,sx-toggle.rakebarwidth/2,sy-5+toggle.rakehealthy);toggle.setprop(d.barbg,"Size",Vector2.new(toggle.rakebarwidth,7));toggle.setprop(d.barbg,"Transparency",alpha*0.78);toggle.setvisible(d.barbg,bar)
    toggle.setpos(d.barfill,d.barbg.Position.X+1,sy-4+toggle.rakehealthy);toggle.setprop(d.barfill,"Size",Vector2.new(math.max(0,toggle.pixel((toggle.rakebarwidth-2)*ratio)),5));toggle.setprop(d.barfill,"Color",toggle.healthbased and dynamic or toggle.rakebarstyle.labelcolor);toggle.setprop(d.barfill,"Transparency",alpha);toggle.setvisible(d.barfill,bar and ratio>0 and(toggle.healthbased or not toggle.rakebarstyle.rgb))
    for i=1,24 do local segment=d["gradient"..i];local a=(i-1)/24;local b=math.min(i/24,ratio);local segmenton=bar and toggle.rakebarstyle.rgb and not toggle.healthbased and b>a;if segmenton then toggle.setprop(segment,"Position",Vector2.new(d.barfill.Position.X+(toggle.rakebarwidth-2)*a,d.barfill.Position.Y));toggle.setprop(segment,"Size",Vector2.new((toggle.rakebarwidth-2)*(b-a),5));toggle.setprop(segment,"Color",rgb(a*rgbspread));toggle.setprop(segment,"Transparency",alpha)end;toggle.setvisible(segment,segmenton)end
    toggle.setprop(d.barborder,"Position",d.barbg.Position);toggle.setprop(d.barborder,"Size",d.barbg.Size);toggle.setprop(d.barborder,"Transparency",alpha);toggle.setvisible(d.barborder,bar)
    local distancetext=tostring(math.floor(meters)).."m";toggle.setprop(d.distance,"Text",distancetext);toggle.setpos(d.distance,sx,sy+espfontsize+10);toggle.setprop(d.distance,"Color",toggle.distancestyle.rgb and rgb(0)or toggle.distancestyle.labelcolor);toggle.setprop(d.distance,"Transparency",1);toggle.applyespoutline(d.distance,1);toggle.setprop(d.distance,"Size",espfontsize);toggle.setprop(d.distance,"Font",font);toggle.setvisible(d.distance,toggle.rakedistance)
end
local function powerhud()
    if toggle.uibatch then toggle.huddirty=true;return false end
    local activecells,activecount=0,0;local changed=false;local oldblocked=toggle.ppmspowerblocked
    for i=1,#powercfg do
        local entry=powercfg[i];if not entry.object or not entry.object.Parent then entry.object=powervals:FindFirstChild(entry.valuename)end;local active=entry.object and entry.object.Value==true or false
        if active then activecells=activecells+(entry.cells or 0);activecount=activecount+1 end;if toggle.powerpanel.lineactive[i]~=active then toggle.powerpanel.lineactive[i]=active;changed=true end
    end
    toggle.ppmspowerblocked=not toggle.poweravailable
    if not toggle.ppmsobject or not toggle.ppmsobject.Parent then toggle.ppmsobject=powervals:FindFirstChild("PPMS")end
    local oldtext,oldlevel=toggle.ppmsdraw.value.Text,toggle.ppmslevel;local ok,reading=pcall(function()return toggle.ppmsobject and toggle.ppmsobject.Value end);reading=ok and tonumber(reading)or nil
    toggle.ppmsdraw.value.Text=reading and tostring(reading)or"?";toggle.ppmslevel=toggle.poweravailable and clamp(1+activecells,1,activecount>=3 and 5 or 4)or 0
    toggle.setvisible(toggle.ppmsdraw.label,false);toggle.setvisible(toggle.ppmsdraw.value,false)
    changed=changed or oldlevel~=toggle.ppmslevel or oldtext~=toggle.ppmsdraw.value.Text;if oldblocked~=toggle.ppmspowerblocked then menustate.itemsdirty=true;changed=true end;if changed then powerpos()end;return changed
end
local function targethud()
    local target=raketarget and raketarget.Value or nil;local shown="none"
    if target and typeof(target)=="Instance"and target:IsA("BasePart")then
        local char=getchar(target);shown=char and char.Name or"unknown"
    end
    if targettxt.Text~=shown then targettxt.Text=shown;return true end;return false
end
local function scraphud()
    local oldscrap,oldpower=scraptxt.Text,toggle.powerdraw.value.Text
    local points=toggle.scrappoints;if not points or not points.Parent then local backpack=lp:FindFirstChild("Backpack")or lp:FindFirstChild("backpack");local folder=backpack and backpack:FindFirstChild("ScrapFolder");points=folder and folder:FindFirstChild("Points");toggle.scrappoints=points end
    scraptxt.Text=points and points:IsA("IntValue")and tostring(points.Value)or"0"
    if not toggle.powerlevel or not toggle.powerlevel.Parent then toggle.powerlevel=powervals:FindFirstChild("PowerLevel")end
    local level=toggle.powerlevel
    local ok,minimum,maximum,value=pcall(function()
        local address=level and level.Address
        if type(address)~="number"or address<=0 then return nil end
        return memory_read("uintptr_t",address+0xC0),memory_read("uintptr_t",address+0xB8),memory_read("uintptr_t",address+0xC8)
    end)
    if ok and type(minimum)=="number"and type(maximum)=="number"and type(value)=="number"and maximum>minimum and value>=minimum and value<=maximum then
        toggle.poweravailable=value>0
        local percent=(value-minimum)/(maximum-minimum)*100
        toggle.powerdraw.value.Text=string.format("%.1f%%",percent)
    else toggle.powerdraw.value.Text="?";toggle.poweravailable=true end
    return oldscrap~=scraptxt.Text or oldpower~=toggle.powerdraw.value.Text
end
local function timerhud()
    if toggle.uibatch then toggle.huddirty=true;return false end
    local changed=false;local timer=math.max(0,math.floor(tonumber(timerval.Value)or 0));local shown=toggle.timerformat=="seconds"and tostring(timer)or string.format("%d:%02d",math.floor(timer/60),timer%60);if timertxt.Text~=shown then timertxt.Text=shown;changed=true end;toggle.timerlow=toggle.timerwarningenabled and timer<=toggle.timerwarning
    local remaining=toggle.teleportcooldown and math.max(0,math.ceil((toggle.cooldownuntil or 0)-tick()))or 0
    if remaining~=toggle.cooldownremaining then toggle.cooldownremaining=remaining;toggle.cooldowndraw.value.Text=tostring(remaining).."s";toggle.setvisible(toggle.cooldowndraw.value,toggle.hudvisible("cooldown"));toggle.setvisible(toggle.cooldowndraw.label,toggle.hudvisible("cooldown"));changed=true end;return changed
end
local function showhud()
    if toggle.uibatch then toggle.huddirty=true;return end
    toggle.hudlabels=true;hudpos();toggle.setvisible(toggle.ppmsdraw.label,false);toggle.setvisible(toggle.ppmsdraw.value,false);powerpos()
end
local function drawrgb()
    if toggle.updatetheme()and toggle.menu then menuupdate(true)end
    toggle.setprop(timerlabel,"Color",toggle.hudstyles.timer.rgb and rgb(0)or toggle.hudstyles.timer.labelcolor);toggle.setprop(targetlabel,"Color",toggle.hudstyles.target.rgb and rgb(0)or toggle.hudstyles.target.labelcolor);toggle.setprop(scraplabel,"Color",toggle.hudstyles.scrap.rgb and rgb(0)or toggle.hudstyles.scrap.labelcolor);toggle.setprop(toggle.powerdraw.label,"Color",toggle.hudstyles.power.rgb and rgb(0)or toggle.hudstyles.power.labelcolor)
    local timerstyle=toggle.timerlow and toggle.hudvalues.warning or toggle.hudvalues.timer;toggle.setprop(timertxt,"Color",timerstyle.rgb and rgb(0)or timerstyle.labelcolor);toggle.setprop(targettxt,"Color",toggle.hudvalues.target.rgb and rgb(0)or toggle.hudvalues.target.labelcolor);toggle.setprop(scraptxt,"Color",toggle.hudvalues.scrap.rgb and rgb(0)or toggle.hudvalues.scrap.labelcolor);toggle.setprop(toggle.powerdraw.value,"Color",toggle.hudvalues.power.rgb and rgb(0)or toggle.hudvalues.power.labelcolor)
    toggle.setprop(powerlabel,"Color",color("text"));toggle.setprop(toggle.cooldowndraw.label,"Color",toggle.cooldownstyle.rgb and rgb(0)or toggle.cooldownstyle.labelcolor);toggle.setprop(toggle.cooldowndraw.value,"Color",toggle.cooldownvaluestyle.rgb and rgb(0)or toggle.cooldownvaluestyle.labelcolor);toggle.setprop(toggle.ppmsdraw.label,"Color",toggle.ppmslabelstyle.rgb and rgb(0)or toggle.ppmslabelstyle.labelcolor);for i=1,5 do local cfg=toggle.voltmeterstyles[i];toggle.setprop(toggle.ppmsdraw.squares[i],"Color",cfg.rgb and rgb((i-1)/5*rgbspread)or cfg.labelcolor)end;for i=1,#toggle.huditems do local item=toggle.huditems[i];toggle.applytextoutline(item.value,item.anim);toggle.applytextoutline(item.label,item.anim)end;toggle.applytextoutline(toggle.ppmsdraw.label,toggle.ppmsdraw.label.Transparency);toggle.applytextoutline(toggle.ppmsdraw.value,toggle.ppmsdraw.value.Transparency)
    if toggle.hudanimating then hudpos()end;toggle.paintgradient(rgbline,toggle.hudbarvisible(),toggle.hudalpha or 0);if toggle.hudstyle=="container"then toggle.paintwidget(toggle.groupwidget,(toggle.hudcount or 0)>0,toggle.hudalpha or 0)else toggle.hidewidgets()end
    if not toggle.menu and(menustate.menuanim or 0)>0.001 then menuupdate(true)end;toggle.paintgradient(menurgb,(menustate.menuanim or 0)>0.001,guiopacity*(menustate.menuanim or 0));toggle.paintgradient(picker.gradient,picker.opened and pickerentry~=nil and toggle.menu,picker.anim)
    powerpos()
end
local function tpscrap()
    local char=lp.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart")then return false end
    local candidates={}
    for i=1,#tracked do
        local rec=tracked[i]
        if rec.cfgname and string.match(rec.cfgname,"^Scrap%d+$")then
            local dest=rec.object and rec.object.Parent and rec.object or rec.model and findclass(rec.model,"BasePart")
            if dest then candidates[#candidates+1]={part=dest,tier=tonumber(string.match(rec.cfgname,"^Scrap(%d+)$"))or 0,distance=dist(root.Position,dest.Position)}end
        end
    end
    if #candidates==0 then return false end
    local chosen=candidates[1]
    if toggle.scrapteleport=="nearest"then
        for i=2,#candidates do if candidates[i].distance<chosen.distance then chosen=candidates[i]end end
    elseif toggle.scrapteleport=="value"then
        for i=2,#candidates do local candidate=candidates[i];if candidate.tier>chosen.tier or candidate.tier==chosen.tier and candidate.distance<chosen.distance then chosen=candidate end end
    else chosen=candidates[math.random(1,#candidates)]end
    root.Position=chosen.part.Position;return true
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
        if name=="Map"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Map")end)elseif name=="Compass"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Compass")end)elseif name=="Watch"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Watch")end)elseif name=="Voltmeter"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Voltmeter")end)elseif name=="FirstAidKit"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","FirstAidKit")end)elseif name=="Vitamins"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Vitamins")end)elseif name=="Toolbox"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Toolbox")end)elseif name=="Tracker"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Tracker")end)elseif name=="RakeTrap"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","RakeTrap")end)elseif name=="Monitor"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Monitor")end)elseif name=="Vest"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","Vest")end)elseif name=="UV_Lamp"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","UV_Lamp")end)elseif name=="StunStick"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("PurchaseItem","StunStick")end)end
    elseif action=="SellItem"then
        if name=="Map"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Map")end)elseif name=="Compass"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Compass")end)elseif name=="Watch"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Watch")end)elseif name=="Voltmeter"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Voltmeter")end)elseif name=="FirstAidKit"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","FirstAidKit")end)elseif name=="Vitamins"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Vitamins")end)elseif name=="Toolbox"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Toolbox")end)elseif name=="Tracker"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Tracker")end)elseif name=="RakeTrap"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","RakeTrap")end)elseif name=="Monitor"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Monitor")end)elseif name=="Vest"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","Vest")end)elseif name=="UV_Lamp"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","UV_Lamp")end)elseif name=="StunStick"then return pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellItem","StunStick")end)end
    end
    return false
end
toggle.shopaction=function(action)
    toggle.refreshshop(true);local selected=toggle.shopitem();if action~="SellScraps"and not selected then return false,"empty"end
    if not toggle.cooldownready()then return false,"cooldown"end;local night=rs:FindFirstChild("Night");if night then local ok,value=pcall(function()return night.Value end);if ok and value==true then return false,"night"end end
    local character=lp.Character;local root=character and character:FindFirstChild("HumanoidRootPart");if not root or not root:IsA("BasePart")then return false,"character"end;local destination=nil
    for i=1,#tracked do local rec=tracked[i];if rec.cfgname=="ShopMSG"then local object=rec.object and rec.object.Parent and rec.object or rec.model and findclass(rec.model,"BasePart");if object and object:IsA("BasePart")then destination=object;break end end end
    if not destination then local object=finddesc(ws,"ShopMSG");while object and object~=ws and not object:IsA("BasePart")do object=object.Parent end;if object and object:IsA("BasePart")then destination=object end end;if not destination then return false,"shop"end;if not rs:FindFirstChild("ShopEvent")then return false,"event"end
    local moved=pcall(function()root.CFrame=destination.CFrame+Vector3.new(0,3,0)end);if not moved then return false,"shop"end;task.wait(0.1);local fired=true
    for attempt=1,10 do if action=="SellScraps"then local ok=pcall(function()game.ReplicatedStorage.ShopEvent:FireServer("SellScraps","Scraps")end);if not ok then fired=false end elseif not toggle.fireshopitem(action,selected.name)then fired=false end;if attempt<10 then task.wait(0.14/9)end end
    if fired then toggle.startcooldown()end;return fired,fired and nil or"event",action=="SellScraps"and 0 or 1
end
toggle.sellscraps=function()return toggle.shopaction("SellScraps")end
local function setesp(value,quiet)
    toggle.esp=value==true
    if not toggle.esp then for i=1,#tracked do hiderec(tracked[i])end;rooflabel.Visible=false;roofhp.Visible=false;for _,entry in pairs(toggle.rakedraw)do entry.Visible=false end end
    menuupdate();if not quiet then bindlog(toggle.esp and "enabled esp"or"disabled esp")end
end
local function sethud(value,quiet)
    toggle.hud=value==true;hudpos();showhud();powerpos();menuupdate();if not quiet then bindlog(toggle.hud and "enabled hud"or"disabled hud")end
end
toggle.sethudstyle=function(value,quiet)
    toggle.hudstyle=value=="minimal"and"minimal"or"container";hudpos();showhud();menuupdate();if not quiet then bindlog("HUD style set to "..toggle.hudstyle)end
end
toggle.setclient=function(id,value,quiet)
    if toggle.client[id]==nil then return end;toggle.client[id]=value==true
    if id=="noFall"then toggle.applynofall(toggle.client[id],true)
    elseif toggle.client[id]and(id=="noJumpCooldown"or id=="infiniteStamina")then toggle.clientgc.nextapply=0;if not toggle.uibatch then toggle.applyclient(not toggle.clientgc.valid)end
    elseif not toggle.clientneedsgc()then toggle.releaseclientgc()end
    menuupdate();if not quiet then bindlog((toggle.client[id]and"enabled "or"disabled ")..(toggle.clientlabels[id]or id))end
end
toggle.setkillaura=function(value,quiet)
    toggle.killaura=value==true;toggle.killauranext=0;menuupdate();if not quiet then bindlog(toggle.killaura and"enabled stun aura"or"disabled stun aura")end
end
toggle.setkillaurarange=function(value,quiet)
    toggle.killaurarange=math.floor(clamp(tonumber(value)or toggle.killaurarange,6,30)+0.5);menuupdate();if not quiet then bindlog("stun aura range set to "..tostring(toggle.killaurarange).." studs")end
end
toggle.setkillauradelay=function(value,quiet)
    toggle.killauradelay=clamp(tonumber(value)or toggle.killauradelay,0.05,0.6);menuupdate();if not quiet then bindlog("stun aura delay set to "..string.format("%.2fs",toggle.killauradelay))end
end
toggle.findstunstick=function(parent)
    if not parent then return nil end;local children=parent:GetChildren();for i=1,#children do local child=children[i];local name=string.lower(child.Name or"");if child:IsA("Tool")and(name=="stunstick"or string.find(name,"stun",1,true)and string.find(name,"stick",1,true))then return child end end
end
toggle.applykillaura=function(force)
    if not toggle.killaura then return false end;local now=tick();if not force and now<(toggle.killauranext or 0)then return false end
    local character=lp.Character or ws:FindFirstChild(lp.Name);local root=character and character:FindFirstChild("HumanoidRootPart");local rake=ws:FindFirstChild("Rake");local rakeroot=rake and(rake:FindFirstChild("HumanoidRootPart")or finddesc(rake,"HumanoidRootPart")or rake:FindFirstChild("Torso")or rake:FindFirstChild("UpperTorso"));local rakehum=rake and(rake:FindFirstChild("Monster")or findclass(rake,"Humanoid"));if not root or not rakeroot or rakehum and rakehum.Health<=0 then return false end
    local delta=rakeroot.Position-root.Position;local distance=math.sqrt(delta.X*delta.X+delta.Y*delta.Y+delta.Z*delta.Z);if distance>toggle.killaurarange then return false end
    local stick=toggle.findstunstick(character);if not stick then return false end
    local event=stick:FindFirstChild("Event")or finddesc(stick,"Event");if not event then return false end;local hit,hitdistance=rakeroot,distance;for i=1,#toggle.killpartnames do local part=rake:FindFirstChild(toggle.killpartnames[i])or finddesc(rake,toggle.killpartnames[i]);if part and part:IsA("BasePart")then local diff=part.Position-root.Position;local candidate=math.sqrt(diff.X*diff.X+diff.Y*diff.Y+diff.Z*diff.Z);if candidate<hitdistance then hit,hitdistance=part,candidate end end end;if not hit or hitdistance>toggle.killaurarange then return false end;local hitpart=stick:FindFirstChild("HitPart")or finddesc(stick,"HitPart");if hitpart then pcall(function()hitpart.CanTouch=true;hitpart.CanQuery=true end)end
    local power=rs:FindFirstChild("StationPower");if power then local ok,value=pcall(function()return power.Value end);if ok and value~=true then return false end end
    toggle.killauranext=now+toggle.killauradelay;local swung=pcall(function()event:FireServer("S")end);if not swung then return false end;return pcall(function()event:FireServer("H",hit)end)
end
toggle.setzoomamount=function(value,quiet)
    toggle.zoom.amount=clamp(tonumber(value)or toggle.zoom.amount,0.5,100);if toggle.zoom.thirdperson then toggle.zoom.min=toggle.zoom.amount;toggle.zoom.max=10000;toggle.zoom.nextapply=0;toggle.applyzoom(true)end;menuupdate();if not quiet then bindlog("zoom amount set to "..string.format("%.1f",toggle.zoom.amount).." studs")end
end
toggle.setthirdperson=function(value,quiet)
    toggle.zoom.thirdperson=value==true;toggle.zoom.min=toggle.zoom.thirdperson and toggle.zoom.amount or 0;toggle.zoom.max=toggle.zoom.thirdperson and 10000 or 0;toggle.zoom.nextapply=0;toggle.applyzoom(true);menuupdate();if not quiet then bindlog(toggle.zoom.thirdperson and"enabled third person"or"disabled third person")end
end
toggle.setshiftlock=function(value,quiet)
    local state=toggle.shiftlockstate;state.active=value==true;state.nextapply=0;if not state.offset then toggle.loadoffsets(false)end;local address=toggle.instanceaddress(lp);local applied=address and state.offset and toggle.memorywrite("byte",address+state.offset,state.active and 1 or 0)or false;menuupdate();if not quiet then bindlog(applied and(state.active and"enabled shift lock"or"disabled shift lock")or"shift lock offset unavailable")end;return applied
end
toggle.setinstacrate=function(value,quiet)
    local state=toggle.instacratestate;toggle.instacrate=value==true;state.nextapply=0;state.lastbox=nil;state.lastopen=0;local opened=toggle.instacrate and toggle.applyinstacrate(true)or false;menuupdate();if not quiet then bindlog(toggle.instacrate and"enabled instant crate"or"disabled instant crate")end;return opened
end
toggle.sethudelement=function(id,value,quiet)
    if toggle.hudelements[id]==nil then return end;toggle.hudelements[id]=value==true;hudpos();showhud();menuupdate();if not quiet then bindlog((toggle.hudelements[id]and"enabled "or"disabled ")..id.." HUD")end
end
local function setbarrgb(value,quiet)
    toggle.barrgb=value==true;menuupdate();if not quiet then bindlog(toggle.barrgb and"enabled rainbow accent"or"disabled rainbow accent")end
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
    toggle.rakename=value==true;if not toggle.rakename then toggle.rakedraw.name.Visible=false end;menuupdate();if not quiet then bindlog(toggle.rakename and"enabled rake name"or"disabled rake name")end
end
toggle.setrakehealth=function(value,quiet)
    toggle.rakehealth=value==true;if not toggle.rakehealth then toggle.rakedraw.health.Visible=false;toggle.rakedraw.barbg.Visible=false;toggle.rakedraw.barfill.Visible=false;toggle.rakedraw.barborder.Visible=false;for i=1,24 do toggle.rakedraw["gradient"..i].Visible=false end end;menuupdate();if not quiet then bindlog(toggle.rakehealth and"enabled rake health"or"disabled rake health")end
end
toggle.setrakedistance=function(value,quiet)
    toggle.rakedistance=value==true;if not toggle.rakedistance then toggle.rakedraw.distance.Visible=false end;menuupdate();if not quiet then bindlog(toggle.rakedistance and"enabled rake distance"or"disabled rake distance")end
end
toggle.setrakehealthformat=function(value,quiet)
    toggle.rakehealthformat=value=="value"and"value"or"bar";menuupdate();if not quiet then bindlog("rake health style set to "..toggle.rakehealthformat)end
end
toggle.setrakenamey=function(value,quiet)
    toggle.rakenamey=math.floor(clamp(tonumber(value)or toggle.rakenamey,-100,100)+0.5);menuupdate();if not quiet then bindlog("rake name Y offset set to "..tostring(toggle.rakenamey).."px")end
end
toggle.setrakehealthy=function(value,quiet)
    toggle.rakehealthy=math.floor(clamp(tonumber(value)or toggle.rakehealthy,-100,100)+0.5);menuupdate();if not quiet then bindlog("rake health Y offset set to "..tostring(toggle.rakehealthy).."px")end
end
toggle.setrakebarwidth=function(value,quiet)
    toggle.rakebarwidth=math.floor(clamp(tonumber(value)or toggle.rakebarwidth,30,200)+0.5);menuupdate();if not quiet then bindlog("rake health bar width set to "..tostring(toggle.rakebarwidth).."px")end
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
toggle.setpoweractivitymode=function(value,quiet)
    toggle.poweractivitymode=value=="always"and"always"or"activity";powerpos();menuupdate();if not quiet then bindlog("activity panel set to "..toggle.poweractivitymode)end
end
toggle.setteleportcooldown=function(value,quiet)
    toggle.teleportcooldown=value==true;if not toggle.teleportcooldown then toggle.cooldownuntil=0;toggle.cooldownremaining=0;toggle.teleporthistory={};toggle.cooldowndraw.value.Visible=false;toggle.cooldowndraw.label.Visible=false end;hudpos();showhud();menuupdate();if not quiet then bindlog(toggle.teleportcooldown and"enabled tp safe cooldown"or"disabled tp safe cooldown")end
end
toggle.setcooldownseconds=function(value,quiet)
    toggle.cooldownseconds=30;menuupdate();if not quiet then bindlog("tp safe cooldown fixed at 30s")end
end
toggle.cooldownready=function()
    if not toggle.teleportcooldown then return true end;local now=tick();local recent={};for i=1,#toggle.teleporthistory do if now-toggle.teleporthistory[i]<30 then recent[#recent+1]=toggle.teleporthistory[i]end end;toggle.teleporthistory=recent;return now>=(toggle.cooldownuntil or 0)
end
toggle.startcooldown=function()
    if not toggle.teleportcooldown then return end;local now=tick();toggle.teleporthistory[#toggle.teleporthistory+1]=now;if #toggle.teleporthistory<4 then return end;toggle.teleporthistory={};toggle.cooldownuntil=now+30;toggle.cooldownremaining=30;toggle.cooldowndraw.value.Text="30s";toggle.cooldowndraw.value.Visible=toggle.hud;toggle.cooldowndraw.label.Visible=toggle.hud;hudpos()
end
toggle.setppms=function(value,quiet)
    toggle.ppms=value==true;powerhud();powerpos();showhud();menuupdate();if not quiet then bindlog(toggle.ppms and"enabled voltmeter level"or"disabled voltmeter level")end
end
toggle.setppmsstyle=function(value,quiet)
    toggle.ppmsstyle="voltmeter";powerpos();showhud();menuupdate();if not quiet then bindlog("voltmeter style selected")end
end
toggle.setppmssquares=function(value,quiet)
    toggle.ppmssquares=5;powerhud();powerpos();showhud();menuupdate();if not quiet then bindlog("voltmeter uses 5 cells")end
end
toggle.setscrapstyle=function(value,quiet)
    toggle.scrapstyle=value=="points"and"points"or value=="tiers"and"tiers"or value=="both"and"both"or"default";local points={12,15,19,23,27}
    for i=1,5 do local label=toggle.scrapstyle=="default"and"scrap"or toggle.scrapstyle=="tiers"and("scrap "..i)or toggle.scrapstyle=="points"and("scrap [+"..points[i].."]")or("scrap "..i.." [+"..points[i].."]");local cfg=espcfg["Scrap"..tostring(i)];if cfg then cfg.text=label end end;for i=1,#tracked do local rec=tracked[i];if rec.cfgname and string.match(rec.cfgname,"^Scrap%d$")and rec.name then rec.name.Text=rec.cfg.text end end
    menuupdate();if not quiet then bindlog("scrap display set to "..toggle.scrapstyle)end
end
toggle.setscrapteleport=function(value,quiet)
    toggle.scrapteleport=(value=="value"or value=="most value")and"value"or value=="nearest"and"nearest"or value=="random"and"random"or"value";menuupdate();if not quiet then bindlog("scrap teleport set to "..toggle.scrapteleport)end
end
toggle.setsupplylabel=function(value,quiet)
    toggle.supplylabel=value==true;if not toggle.supplylabel then for i=1,#tracked do local rec=tracked[i];if rec.cfg.crate then hide(rec.name);hide(rec.distance)end end end;menuupdate();if not quiet then bindlog(toggle.supplylabel and"enabled supply label"or"disabled supply label")end
end
toggle.setsupplyitems=function(value,quiet)
    toggle.supplyitems=value==true;if not toggle.supplyitems then for i=1,#tracked do local rec=tracked[i];if rec.cfg.crate then hide(rec.bg);hide(rec.bgouter);hide(rec.bgmiddle);hide(rec.bginner);if rec.items then for j=1,#rec.items do hide(rec.items[j])end end end end end;menuupdate();if not quiet then bindlog(toggle.supplyitems and"enabled item viewer"or"disabled item viewer")end
end
local function setfontindex(index,quiet)
    fontindex=((math.floor(index)-1)%#fontvalues)+1;font=fontvalues[fontindex]
    local texts={rooflabel,roofhp,toggle.rakedraw.name,toggle.rakedraw.health,toggle.rakedraw.distance}
    for i=1,#texts do texts[i].Font=font end
    for i=1,#tracked do local rec=tracked[i];if rec.name then rec.name.Font=font end;if rec.distance then rec.distance.Font=font end;if rec.items then for j=1,#rec.items do rec.items[j].Font=font end end end
    menuupdate();if not quiet then bindlog("esp font set to "..fontnames[fontindex])end
end
toggle.sethudfont=function(index,quiet)
    toggle.hudfontindex=((math.floor(index)-1)%#fontvalues)+1;local selected=fontvalues[toggle.hudfontindex];local texts={timertxt,scraptxt,targettxt,timerlabel,scraplabel,targetlabel,toggle.powerdraw.value,toggle.powerdraw.label,toggle.cooldowndraw.value,toggle.cooldowndraw.label,toggle.ppmsdraw.value,toggle.ppmsdraw.label,powerlabel,toggle.powerempty}
    for i=1,#texts do texts[i].Font=selected end;for i=1,#powerlines do powerlines[i].Font=selected end
    menuupdate();if not quiet then bindlog("hud font set to "..fontnames[toggle.hudfontindex])end
end
toggle.setguitextoutline=function(value,quiet)
    toggle.guitextoutline=value==true;hudpos();powerpos();menuupdate();if not quiet then bindlog(toggle.guitextoutline and"enabled GUI and HUD text outline"or"disabled GUI and HUD text outline")end
end
toggle.setguitextoutline(toggle.guitextoutline,true)
toggle.setesptextoutline=function(value,quiet)
    toggle.esptextoutline=value==true;for _,text in ipairs({rooflabel,roofhp,toggle.rakedraw.name,toggle.rakedraw.health,toggle.rakedraw.distance})do toggle.applyespoutline(text,text.Transparency)end;for i=1,#tracked do local rec=tracked[i];if rec.name then toggle.applyespoutline(rec.name,rec.name.Transparency)end;if rec.distance then toggle.applyespoutline(rec.distance,rec.distance.Transparency)end;if rec.items then for j=1,#rec.items do toggle.applyespoutline(rec.items[j],rec.items[j].Transparency)end end end;menuupdate();if not quiet then bindlog(toggle.esptextoutline and"enabled ESP text outline"or"disabled ESP text outline")end
end
toggle.themepalette=function(selected)
    local palette={};local monochrome=selected.name=="monochrome";local text,accent,muted=selected.text,selected.accent,selected.muted
    local function put(cfg,value)if cfg then palette[cfg]=monochrome and cfg.defaultcolor or value end end
    local light=selected.bg.R*0.2126+selected.bg.G*0.7152+selected.bg.B*0.0722;local hue,saturation=tohsv(accent);local value=light>0.58 and 0.68 or 1
    local function tone(offset,sat,blend)local vivid=Color3.fromHSV((hue+offset)%1,clamp(saturation*0.45+sat,0.38,0.96),value);return toggle.colormix(vivid,accent,blend or 0.28)end
    for i,name in ipairs({"BaseCampMSG","SafehouseMSG","StationMSG","ShopMSG","ObservationTowerMSG"})do put(espcfg[name],tone(-0.16+(i-1)*0.08,0.38+(i%2)*0.12,0.34))end
    for i=1,5 do local strength=(i-1)/4;put(espcfg["Scrap"..i],toggle.colormix(muted,tone(-0.1+strength*0.2,0.3+strength*0.42,0.22),0.22+strength*0.78))end
    put(espcfg.FlareGunPickUp,tone(-0.03,0.68,0.08));put(espcfg.RakeTrapModel,tone(0.15,0.56,0.22));put(espcfg.Box,tone(-0.15,0.62,0.18));put(espcfg.SupplyCrate,tone(-0.15,0.62,0.18))
    put(toggle.distancestyle,toggle.colormix(text,tone(-0.12,0.42,0.3),0.34));put(toggle.rakestyle,tone(0.04,0.68,0.12));put(toggle.rakehealthstyle,tone(-0.08,0.7,0.1));put(toggle.rakebarstyle,tone(-0.08,0.7,0.1));put(roofstyle,tone(0.2,0.5,0.28))
    for _,cfg in pairs(toggle.hudstyles)do put(cfg,text)end;for key,cfg in pairs(toggle.hudvalues)do put(cfg,key=="warning"and accent or text)end
    put(toggle.cooldownstyle,text);put(toggle.cooldownvaluestyle,text);put(toggle.ppmslabelstyle,text);put(toggle.ppmsvaluestyle,text)
    for _,rarity in ipairs({{"FirstAidKit",0.36,false},{"Vitamins",0.62,false},{"UV_Lamp",0.80,true},{"StunStick",0.13,true},{"Vest",0.54,true},{"Tracker",0.92,false}})do local vivid=rarity[3];local raritysaturation=vivid and 0.98 or(light>0.58 and 0.68 or 0.56);local rarityvalue=light>0.58 and(vivid and 0.76 or 0.6)or(vivid and 1 or 0.9);put(toggle.cratestyles[rarity[1]],toggle.colormix(Color3.fromHSV(rarity[2],raritysaturation,rarityvalue),accent,vivid and 0.04 or 0.12))end
    return palette
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
    espfontsize=math.floor(clamp(tonumber(value)or espfontsize,13,20)+0.5)
    rooflabel.Size=espfontsize;roofhp.Size=espfontsize;toggle.rakedraw.name.Size=espfontsize;toggle.rakedraw.health.Size=espfontsize;toggle.rakedraw.distance.Size=espfontsize;for i=1,#tracked do if tracked[i].name then tracked[i].name.Size=espfontsize end;if tracked[i].distance then tracked[i].distance.Size=espfontsize end end
    menuupdate();if not quiet then bindlog("ESP label size set to "..tostring(espfontsize))end
end
local function setguiopacity(value,quiet)
    guiopacity=clamp(tonumber(value)or guiopacity,0.2,1);menuupdate();if not quiet then bindlog("GUI opacity set to "..tostring(math.floor(guiopacity*100+0.5)).."%")end
end
toggle.setborderradius=function(value,quiet)
    toggle.borderradius=math.floor(clamp(tonumber(value)or toggle.borderradius,0,10)+0.5);toggle.applyradius();menupos();hudpos();powerpos();menuupdate();if not quiet then bindlog("border radius set to "..tostring(toggle.borderradius).."px")end
end
local function setlabelcolor(index,value)
    if type(index)=="string"then local cfg=entrycfg(index);if cfg then cfg.labelcolor=value end;if index=="themetext"then for _,style in pairs(toggle.hudstyles)do style.labelcolor=value end;for key,style in pairs(toggle.hudvalues)do if key~="warning"then style.labelcolor=value end end;toggle.cooldownstyle.labelcolor=value;toggle.cooldownvaluestyle.labelcolor=value;toggle.ppmslabelstyle.labelcolor=value;toggle.ppmsvaluestyle.labelcolor=value end;menuupdate();return end
    local entry=colorentries[index];if not entry then return end
    for i=1,#entry.cfgs do local cfg=espcfg[entry.cfgs[i]];if cfg then cfg.labelcolor=value;cfg.color=value end end
    menuupdate()
end
local function setlabelrgb(index,value,quiet)
    if index=="accent"then return end
    if type(index)=="string"then local cfg=entrycfg(index);if cfg then cfg.rgb=value==true end;menuupdate();if not quiet then bindlog((value and"enabled "or"disabled ").."RGB color")end;return end
    local entry=colorentries[index];if not entry then return end
    for i=1,#entry.cfgs do local cfg=espcfg[entry.cfgs[i]];if cfg then cfg.rgb=value==true end end
    menuupdate();if not quiet then bindlog((value and"enabled "or"disabled ").."RGB for "..entry.name)end
end
toggle.applypickerhex=function(quiet)
    local value=string.upper(string.gsub(tostring(picker.hexvalue or""),"[^%x]",""))
    if #value~=6 then if not quiet then bindlog("enter a 6-digit hex color")end;return false end
    local ok,result=pcall(function()return Color3.fromHex("#"..value)end)
    if not ok or not result then if not quiet then bindlog("invalid hex color")end;return false end
    picker.hexvalue=value;setlabelcolor(pickerentry,result);toggle.pushrecent(result);return true
end
local function setringsegments(value,quiet)
    local nextvalue=100
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
    toggle.ringshape=value=="square"and"square"or value=="triangle"and"triangle"or"circle";menuupdate();if not quiet then bindlog("ring shape set to "..toggle.ringshape)end
end
toggle.setringfade=function(value,quiet)
    ringfade=math.floor(clamp(tonumber(value)or ringfade,10,150)+0.5);menuupdate();if not quiet then bindlog("ring distance updated")end
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
    toggle.rgbdirection=value=="left"and"left"or"right";menuupdate();if not quiet then bindlog("rainbow direction set to "..toggle.rgbdirection)end
end
toggle.setrgbspeed=function(value,quiet)
    rgbspeed=clamp(tonumber(value)or rgbspeed,0.5,2);menuupdate();if not quiet then bindlog("rainbow speed updated")end
end
toggle.setpowerformat=function(value,quiet)
    toggle.powerformat="percent";menuupdate();if not quiet then bindlog("power format fixed to percent")end
end
toggle.setpowerdecimal=function(value,quiet)
    toggle.powerdecimal=true;menuupdate()
end
toggle.settimerformat=function(value,quiet)
    toggle.timerformat=value=="seconds"and"seconds"or"clock";timerhud();menuupdate();if not quiet then bindlog("timer format set to "..toggle.timerformat)end
end
toggle.settimerwarning=function(value,quiet)
    toggle.timerwarning=math.floor(clamp(tonumber(value)or toggle.timerwarning,10,45)+0.5);menuupdate();if not quiet then bindlog("timer warning set to "..tostring(toggle.timerwarning).."s")end
end
local function setbind(id,code)
    if code==0 then keybinds[id]=0;capture=nil;menuupdate();bindlog(string.lower(bindlabels[id]).." bind removed");return end
    if not keynames[code]then return end
    for i=1,#bindorder do local other=bindorder[i];if other~=id and keybinds[other]==code then capture=nil;menuupdate();bindlog("key already in use");return end end
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
    local colors={};local accent=themes.accentstyle.labelcolor;local special={};local themecolors={};local crateitemcolors={};local recentcolors={}
    for i=1,#colorentries do local cfg=entrycfg(i);local c=cfg.labelcolor;colors[i]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for _,id in ipairs({"distance","rake","rakehealth","rakebar","roof","hudtimer","hudtarget","hudscrap","hudpower","cooldownlabel","cooldownvalue","ppmslabel","ppmsvalue","valuetimer","valuetarget","valuescrap","valuepower","timerwarning"})do local cfg=entrycfg(id);local c=cfg.labelcolor;special[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for _,id in ipairs({"themebg","themetop","themeborder","themeoutline","themetext"})do local cfg=entrycfg(id);local c=cfg.labelcolor;themecolors[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B)}end
    themecolors.border_radius=toggle.borderradius
    for id,cfg in pairs(toggle.cratestyles)do local c=cfg.labelcolor;crateitemcolors[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for i=1,#picker.recentcolors do local c=picker.recentcolors[i];recentcolors[i]={r=channel(c.R),g=channel(c.G),b=channel(c.B)}end
    return {menu_default_version=5,gui_outline_default_version=3,hud_style_default_version=2,font=fontindex,esp_font=fontindex,hud_font=toggle.hudfontindex,font_size=espfontsize,preset=themeindex,preset_schema=4,theme_schema=5,rgb_defaults_schema=2,preset_name=themes[themeindex].name,accent={r=channel(accent.R),g=channel(accent.G),b=channel(accent.B)},theme_colors=themecolors,recent_colors=recentcolors,gui_opacity=guiopacity,gui_text_outline=toggle.guitextoutline,esp_text_outline=toggle.esptextoutline,watermark=toggle.watermark,client=toggle.client,action_toggles={sell=toggle.sellenabled,scrap=toggle.scrapteleportenabled,flare=toggle.flareteleportenabled},shop_item=toggle.shop.selected,kill_aura=toggle.killaura,kill_aura_range=toggle.killaurarange,kill_aura_delay=toggle.killauradelay,third_person=toggle.zoom.thirdperson,zoom_amount=toggle.zoom.amount,shift_lock=toggle.shiftlockstate.active,insta_crate=toggle.instacrate,hud_style=toggle.hudstyle,widget_group={x=toggle.widgetgroup.x,y=toggle.widgetgroup.y,dragged=toggle.widgetgroup.dragged},distance_minimum=toggle.distanceminimum,distance_min=toggle.distancemin,health_based=toggle.healthbased,ring_enabled=toggle.ringenabled,ring_shape=toggle.ringshape,ring_segments=100,ring_fade=ringfade,ring_size=toggle.ringsize,ring_spin=toggle.ringspin,ring_spin_speed=toggle.ringspinspeed,esp=toggle.esp,hud=toggle.hud,hud_elements=toggle.hudelements,power_activity=toggle.poweractivity,power_activity_mode=toggle.poweractivitymode,power_panel={x=toggle.powerpanel.x,y=toggle.powerpanel.y},roof_hp=toggle.roof,rake_name_enabled=toggle.rakename,rake_health_enabled=toggle.rakehealth,rake_distance_enabled=toggle.rakedistance,rake_name=toggle.rakenamevalue,rake_name_y=toggle.rakenamey,rake_health_y=toggle.rakehealthy,rake_health_format=toggle.rakehealthformat,rake_health_bar_width=toggle.rakebarwidth,bar_rgb=toggle.barrgb,rgb_direction=toggle.rgbdirection,rgb_speed=rgbspeed,power_format="percent",power_decimal=toggle.powerdecimal,timer_format=toggle.timerformat,timer_warning_enabled=toggle.timerwarningenabled,timer_warning=toggle.timerwarning,teleport_cooldown=toggle.teleportcooldown,ppms=toggle.ppms,distance=toggle.distance,distance_position=toggle.distanceposition,scrap_style=toggle.scrapstyle,scrap_teleport=toggle.scrapteleport,supply_label=toggle.supplylabel,supply_items=toggle.supplyitems,esp_groups=espgroups,esp_items=espgroups.items,colors=colors,special_colors=special,crate_item_colors=crateitemcolors,binds=keybinds,menu={x=menustate.x,y=menustate.y,minimized=menustate.minimized}}
end
local function saveconfig()
    configname=toggle.cleanconfig(configname);local ok=pcall(function()makefolder("therakesaint");writefile(configpath(),http:JSONEncode(configdata()))end);if ok then toggle.refreshconfigs(configname);menuupdate()end
    bindlog(ok and"saved "..configname or"failed to save config")
end
local function loadconfig(quiet)
    if not isfile(configpath())then if not quiet then bindlog("no saved config")end;return false end
    local ok,data=pcall(function()return http:JSONDecode(readfile(configpath()))end)
    if not ok or type(data)~="table"then if not quiet then bindlog("failed to load config")end;return false end
    toggle.uibatch=true
    if type(data.esp_font)=="number"then setfontindex(clamp(data.esp_font,1,#fontvalues),true)elseif type(data.font)=="number"then setfontindex(clamp(data.font,1,#fontvalues),true)end
    if type(data.hud_font)=="number"then toggle.sethudfont(clamp(data.hud_font,1,#fontvalues),true)elseif type(data.font)=="number"then toggle.sethudfont(clamp(data.font,1,#fontvalues),true)end
    if type(data.font_size)=="number"then setfontsize(data.font_size,true)end
    local savedpreset=data.preset or data.theme;local removedlight,removedgabe=false,false
    if(data.preset_schema==nil or data.preset_schema==1)and type(savedpreset)=="number"then removedlight=savedpreset==2 or savedpreset==6 or savedpreset==10;savedpreset=({1,1,2,3,4,4,5,6,7,7,8,9})[math.floor(savedpreset)]or 5 end
    if data.preset_schema==3 and type(savedpreset)=="number"then if savedpreset==10 then savedpreset=5;removedgabe=true elseif savedpreset>10 then savedpreset=savedpreset-1 end end
    if type(data.preset_name)=="string"then local wanted=({["catppuccin mocha"]="amethyst",dracula="blood moon",["tokyo night"]="midnight",["gruvbox dark"]="ember",nord="glacier",["solarized dark"]="deep sea",["one dark"]="graphite",["rose pine"]="rose noir",gabescripts="signal bruise",gamesense="signal bruise"})[data.preset_name]or data.preset_name;if data.preset_name=="gabescripts"or data.preset_name=="gamesense"then removedgabe=true end;for i=1,#themes do if themes[i].name==wanted then savedpreset=i;break end end end
    if type(savedpreset)=="number"then setthemeindex(clamp(savedpreset,1,#themes),true)end
    local legacygamesense=((data.theme_schema==nil or data.theme_schema==1)and savedpreset==5)or removedgabe
    if not removedlight and not legacygamesense and type(data.accent)=="table"and type(data.accent.r)=="number"and type(data.accent.g)=="number"and type(data.accent.b)=="number"then setlabelcolor("accent",Color3.fromRGB(clamp(data.accent.r,0,255),clamp(data.accent.g,0,255),clamp(data.accent.b,0,255)))end
    if not removedlight and not legacygamesense and type(data.theme_colors)=="table"then for _,id in ipairs({"themebg","themetop","themeborder","themeoutline","themetext"})do local saved=data.theme_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)))end end end
    if type(data.recent_colors)=="table"then
        local loaded={};local seen={}
        for i=1,math.min(6,#data.recent_colors)do local saved=data.recent_colors[i];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then local c=Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255));local hex=toggle.hexof(c);if not seen[hex]then seen[hex]=true;loaded[#loaded+1]=c end end end
        for i=1,#picker.recentcolors do local c=picker.recentcolors[i];local hex=toggle.hexof(c);if #loaded<6 and not seen[hex]then seen[hex]=true;loaded[#loaded+1]=c end end
        if #loaded==6 then picker.recentcolors=loaded end
    end
    toggle.hudlabels=true;for key,id in pairs({distance_minimum="distanceminimum",health_based="healthbased"})do if type(data[key])=="boolean"then toggle[id]=data[key]end end
    local savedjump=false;if type(data.client)=="table"and type(data.client.noJumpCooldown)=="boolean"then savedjump=data.client.noJumpCooldown elseif type(data.noJumpCooldown)=="boolean"then savedjump=data.noJumpCooldown end;toggle.setclient("noJumpCooldown",savedjump,true)
    local savedstamina=false;if type(data.client)=="table"and type(data.client.infiniteStamina)=="boolean"then savedstamina=data.client.infiniteStamina elseif type(data.infiniteStamina)=="boolean"then savedstamina=data.infiniteStamina end;toggle.setclient("infiniteStamina",savedstamina,true)
    local savedfall=false;if type(data.client)=="table"and type(data.client.noFall)=="boolean"then savedfall=data.client.noFall elseif type(data.noFall)=="boolean"then savedfall=data.noFall end;toggle.setclient("noFall",savedfall,true)
    local actions=type(data.action_toggles)=="table"and data.action_toggles or{};toggle.sellenabled=type(actions.sell)=="boolean"and actions.sell or true;toggle.scrapteleportenabled=type(actions.scrap)=="boolean"and actions.scrap or true;toggle.flareteleportenabled=type(actions.flare)=="boolean"and actions.flare or true
    toggle.refreshshop(true);toggle.shop.selected=type(data.shop_item)=="string"and toggle.shop.lookup[data.shop_item]and toggle.shop.lookup[data.shop_item].name or"Map"
    toggle.setkillaurarange(type(data.kill_aura_range)=="number"and data.kill_aura_range or 12,true);toggle.setkillauradelay(type(data.kill_aura_delay)=="number"and data.kill_aura_delay or 0.12,true);toggle.setkillaura(data.kill_aura==true,true)
    local zoomamount=type(data.zoom_amount)=="number"and data.zoom_amount or type(data.min_zoom)=="number"and data.min_zoom>=0.5 and data.min_zoom or type(data.minZoom)=="number"and data.minZoom>=0.5 and data.minZoom or 10;toggle.setzoomamount(zoomamount,true);local thirdperson=false;if type(data.third_person)=="boolean"then thirdperson=data.third_person elseif type(data.min_zoom)=="number"then thirdperson=data.min_zoom>=9.5 elseif type(data.minZoom)=="number"then thirdperson=data.minZoom>=9.5 end;toggle.setthirdperson(thirdperson,true);toggle.setshiftlock(data.shift_lock==true,true)
    toggle.setinstacrate(data.insta_crate==true,true)
    if tonumber(data.hud_style_default_version)==2 and data.hud_style=="minimal"then toggle.sethudstyle("minimal",true)else toggle.sethudstyle("container",true)end
    if tonumber(data.gui_outline_default_version)==3 and type(data.gui_text_outline)=="boolean"then toggle.setguitextoutline(data.gui_text_outline,true)else toggle.setguitextoutline(true,true)end;if type(data.esp_text_outline)=="boolean"then toggle.setesptextoutline(data.esp_text_outline,true)end
    if type(data.widget_group)=="table"and data.widget_group.dragged==true then toggle.widgetgroup.dragged=true;if type(data.widget_group.x)=="number"then toggle.widgetgroup.x=data.widget_group.x end;if type(data.widget_group.y)=="number"then toggle.widgetgroup.y=data.widget_group.y end else toggle.widgetgroup.dragged=false;toggle.widgetgroup.x=nil;if type(data.widget_group)=="table"and type(data.widget_group.y)=="number"then toggle.widgetgroup.y=data.widget_group.y end end
    if type(data.distance_min)=="number"then toggle.distancemin=math.floor(clamp(data.distance_min,0,100)+0.5)end
    if type(data.gui_opacity)=="number"then setguiopacity(data.gui_opacity,true)end
    if type(data.theme_colors)=="table"and type(data.theme_colors.border_radius)=="number"then toggle.setborderradius(data.theme_colors.border_radius,true)else toggle.setborderradius(10,true)end
    if type(data.ring_enabled)=="boolean"then toggle.setringenabled(data.ring_enabled,true)end
    if data.ring_shape=="circle"or data.ring_shape=="square"or data.ring_shape=="triangle"then toggle.setringshape(data.ring_shape,true)end
    setringsegments(100,true)
    if type(data.ring_fade)=="number"then toggle.setringfade(data.ring_fade,true)end
    if type(data.ring_size)=="number"then toggle.setringsize(data.ring_size,true)end
    if type(data.ring_spin)=="boolean"then toggle.setringspin(data.ring_spin,true)end
    if type(data.ring_spin_speed)=="number"then toggle.setringspinspeed(data.ring_spin_speed,true)end
    if type(data.esp)=="boolean"then setesp(data.esp,true)end
    if type(data.hud)=="boolean"then sethud(data.hud,true)end
    if type(data.hud_elements)=="table"then for _,id in ipairs({"timer","target","scrap","power"})do if type(data.hud_elements[id])=="boolean"then toggle.sethudelement(id,data.hud_elements[id],true)end end end
    if type(data.power_activity)=="boolean"then toggle.setpoweractivity(data.power_activity,true)end
    if data.power_activity_mode=="activity"or data.power_activity_mode=="always"then toggle.setpoweractivitymode(data.power_activity_mode,true)end
    if type(data.power_panel)=="table"then if type(data.power_panel.x)=="number"then toggle.powerpanel.x=data.power_panel.x end;if type(data.power_panel.y)=="number"then toggle.powerpanel.y=data.power_panel.y end end
    if type(data.roof_hp)=="boolean"then toggle.setroof(data.roof_hp,true)end
    if type(data.rake_name_enabled)=="boolean"then toggle.setrakename(data.rake_name_enabled,true)end
    if type(data.rake_health_enabled)=="boolean"then toggle.setrakehealth(data.rake_health_enabled,true)end
    if type(data.rake_distance_enabled)=="boolean"then toggle.setrakedistance(data.rake_distance_enabled,true)end
    if type(data.rake_name)=="string"then toggle.rakenamevalue=toggle.cleanrakename(data.rake_name);toggle.rakedraw.name.Text=toggle.rakenamevalue end
    if type(data.rake_name_y)=="number"then toggle.setrakenamey(data.rake_name_y,true)end
    if type(data.rake_health_y)=="number"then toggle.setrakehealthy(data.rake_health_y,true)end
    if data.rake_health_format=="value"or data.rake_health_format=="bar"then toggle.setrakehealthformat(data.rake_health_format,true)else toggle.setrakehealthformat("value",true)end
    if type(data.rake_health_bar_width)=="number"then toggle.setrakebarwidth(data.rake_health_bar_width,true)end
    if type(data.bar_rgb)=="boolean"then setbarrgb(data.bar_rgb,true)end
    if data.rgb_defaults_schema~=2 then toggle.setrgbdirection("left",true);toggle.setrgbspeed(0.6,true)else if data.rgb_direction=="left"or data.rgb_direction=="right"then toggle.setrgbdirection(data.rgb_direction,true)end;if type(data.rgb_speed)=="number"then toggle.setrgbspeed(data.rgb_speed,true)end end
    toggle.setpowerformat("percent",true);toggle.setpowerdecimal(true,true)
    if data.timer_format=="clock"or data.timer_format=="seconds"then toggle.settimerformat(data.timer_format,true)end
    if type(data.timer_warning_enabled)=="boolean"then toggle.timerwarningenabled=data.timer_warning_enabled end
    if type(data.timer_warning)=="number"then toggle.settimerwarning(data.timer_warning,true)end
    if type(data.teleport_cooldown)=="boolean"then toggle.setteleportcooldown(data.teleport_cooldown,true)end
    toggle.setcooldownseconds(30,true);toggle.setppmsstyle("voltmeter",true);toggle.setppmssquares(5,true)
    if type(data.ppms)=="boolean"then toggle.setppms(data.ppms,true)end
    local saveddistance=data.distance;if type(saveddistance)~="boolean"then saveddistance=data.meters end;if type(saveddistance)=="boolean"then setdistance(saveddistance,true)end
    toggle.setunit("meters",true)
    if data.distance_position=="under"or data.distance_position=="below"or data.distance_position=="above"then toggle.setdistanceposition(data.distance_position,true)end
    toggle.distancefade=false;if data.scrap_style=="none"then toggle.setscrapstyle("default",true)elseif data.scrap_style=="default"or data.scrap_style=="both"or data.scrap_style=="tiers"or data.scrap_style=="points"then toggle.setscrapstyle(data.scrap_style,true)else toggle.setscrapstyle("default",true)end;toggle.setscrapteleport(data.scrap_teleport,true)
    if type(data.supply_label)=="boolean"then toggle.setsupplylabel(data.supply_label,true)end;if type(data.supply_items)=="boolean"then toggle.setsupplyitems(data.supply_items,true)end
    espgroups.locations=true;espgroups.scraps=true;espgroups.crates=true;espgroups.rake=true;if type(data.esp_groups)=="table"then for _,id in ipairs({"traps","flares"})do if type(data.esp_groups[id])=="boolean"then setgroup(id,data.esp_groups[id],true)end end end
    if type(data.esp_items)=="table"then for id in pairs(espgroups.items)do if not string.match(id,"^Scrap%d$")and type(data.esp_items[id])=="boolean"then toggle.setitem(id,data.esp_items[id],true)end end end
    if type(data.colors)=="table"then
        for i=1,#colorentries do local saved=data.colors[i];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(i,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb(i,saved.rgb,true)end end end
    end
    if type(data.special_colors)=="table"then for _,id in ipairs({"distance","rake","rakehealth","rakebar","roof","hudtimer","hudtarget","hudscrap","hudpower","cooldownlabel","cooldownvalue","ppmslabel","ppmsvalue","valuetimer","valuetarget","valuescrap","valuepower","timerwarning"})do local saved=data.special_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb(id,saved.rgb,true)end end end end
    if type(data.crate_item_colors)=="table"then for id in pairs(toggle.cratestyles)do local saved=data.crate_item_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor("crate_"..id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb("crate_"..id,saved.rgb,true)end end end end
    if type(data.binds)=="table"then
        local used,nextbinds,valid={},{},true;local legacydefaults=(tonumber(data.menu_default_version)or 0)<5 and tonumber(data.binds.esp)==0x70 and tonumber(data.binds.hud)==0x71 and tonumber(data.binds.scrap)==0x72 and tonumber(data.binds.flare)==0x73
        for i=1,#bindorder do local id=bindorder[i];local code=tonumber(data.binds[id]);if code==nil then code=keybinds[id]end;if id=="menu"and data.menu_default_version==nil and code==0xBB then code=defaultbinds.menu end;if legacydefaults and id~="menu"then code=0 end;if code==0 then nextbinds[id]=0 elseif not keynames[code]or used[code]then valid=false else used[code]=true;nextbinds[id]=code end end
        if valid then keybinds=nextbinds end
    end
    if type(data.watermark)=="boolean"then toggle.watermark=data.watermark end;if type(data.menu)=="table"then if type(data.menu.x)=="number"then menustate.x=data.menu.x end;if type(data.menu.y)=="number"then menustate.y=data.menu.y end;if type(data.menu.minimized)=="boolean"and toggle.watermark then menustate.minimized=data.menu.minimized else menustate.minimized=false end end
    toggle.uibatch=false;toggle.huddirty=false;if toggle.anyclient()then toggle.applyclient(toggle.clientneedsgc()and not toggle.clientgc.valid)end;toggle.applyzoom(true);toggle.writelastconfig(configname);powerhud();timerhud();hudpos();showhud();powerpos();menuupdate();if not quiet then bindlog("loaded config")end;return true
end
toggle.resetcolors=function(quiet)
    for _,cfg in pairs(espcfg)do cfg.color=cfg.defaultcolor;cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    roofstyle.labelcolor=roofstyle.defaultcolor;roofstyle.rgb=roofstyle.defaultrgb;toggle.distancestyle.labelcolor=toggle.distancestyle.defaultcolor;toggle.distancestyle.rgb=toggle.distancestyle.defaultrgb;toggle.rakestyle.labelcolor=toggle.rakestyle.defaultcolor;toggle.rakestyle.rgb=toggle.rakestyle.defaultrgb;toggle.rakehealthstyle.labelcolor=toggle.rakehealthstyle.defaultcolor;toggle.rakehealthstyle.rgb=toggle.rakehealthstyle.defaultrgb;toggle.rakebarstyle.labelcolor=toggle.rakebarstyle.defaultcolor;toggle.rakebarstyle.rgb=toggle.rakebarstyle.defaultrgb;toggle.cooldownstyle.labelcolor=toggle.cooldownstyle.defaultcolor;toggle.cooldownstyle.rgb=toggle.cooldownstyle.defaultrgb;toggle.cooldownvaluestyle.labelcolor=toggle.cooldownvaluestyle.defaultcolor;toggle.cooldownvaluestyle.rgb=toggle.cooldownvaluestyle.defaultrgb;toggle.ppmslabelstyle.labelcolor=toggle.ppmslabelstyle.defaultcolor;toggle.ppmslabelstyle.rgb=toggle.ppmslabelstyle.defaultrgb;toggle.ppmsvaluestyle.labelcolor=toggle.ppmsvaluestyle.defaultcolor;toggle.ppmsvaluestyle.rgb=toggle.ppmsvaluestyle.defaultrgb
    for _,cfg in pairs(toggle.hudstyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    for _,cfg in pairs(toggle.hudvalues)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    for _,cfg in pairs(toggle.cratestyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=false end;for _,cfg in ipairs(toggle.voltmeterstyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    toggle.startpalette(themes[themeindex],true);themes.accentstyle.labelcolor=themes[themeindex].accent;themes.accentstyle.rgb=false;picker.recentcolors={Color3.fromHex("#a2ff00"),Color3.fromHex("#ffffff"),Color3.fromHex("#ff6b6b"),Color3.fromHex("#78b7e6"),Color3.fromHex("#b283d3"),Color3.fromHex("#000000")};menuupdate();if not quiet then bindlog("reset colors")end
end
toggle.resettheme=function(quiet)
    setthemeindex(toggle.defaultthemeindex,true);setguiopacity(0.8,true);toggle.setborderradius(10,true);menuupdate();if not quiet then bindlog("reset theme")end
end
toggle.resettoggles=function(quiet)
    setesp(true,true);sethud(true,true);for _,id in ipairs({"timer","target","scrap","power"})do toggle.sethudelement(id,true,true)end;toggle.watermark=true;toggle.hudlabels=true;toggle.sethudstyle("container",true);toggle.setguitextoutline(true,true);toggle.setesptextoutline(true,true);toggle.widgetgroup.x=nil;toggle.widgetgroup.y=nil;toggle.widgetgroup.dragged=false;toggle.distanceminimum=false;toggle.distancemin=20;toggle.healthbased=false;toggle.setpoweractivity(true,true);toggle.setpoweractivitymode("activity",true);toggle.cooldownuntil=0;toggle.cooldownremaining=0;toggle.teleporthistory={};toggle.setteleportcooldown(false,true);toggle.setcooldownseconds(30,true);toggle.setppms(true,true);toggle.setppmsstyle("voltmeter",true);toggle.setppmssquares(5,true);toggle.setroof(false,true);toggle.setrakename(true,true);toggle.setrakehealth(true,true);toggle.setrakedistance(false,true);toggle.rakenamevalue="rake";toggle.rakedraw.name.Text="rake";toggle.setrakenamey(0,true);toggle.setrakehealthy(0,true);toggle.setrakehealthformat("value",true);toggle.setrakebarwidth(70,true);setbarrgb(true,true);toggle.setrgbdirection("left",true);toggle.setrgbspeed(0.6,true);setdistance(false,true);toggle.distancefade=false;toggle.setunit("meters",true);toggle.setdistanceposition("below",true);toggle.setscrapstyle("default",true);toggle.setscrapteleport("value",true);toggle.setsupplylabel(true,true);toggle.setsupplyitems(true,true);toggle.setringenabled(true,true);toggle.setringshape("circle",true);toggle.setringfade(40,true);toggle.setringsize(1,true);toggle.setringspin(false,true);toggle.setringspinspeed(1,true);toggle.setpowerformat("percent",true);toggle.setpowerdecimal(true,true);toggle.settimerformat("clock",true);toggle.timerwarningenabled=false;toggle.settimerwarning(15,true)
    for _,id in ipairs({"noJumpCooldown","infiniteStamina","noFall"})do toggle.setclient(id,false,true)end;toggle.sellenabled=true;toggle.scrapteleportenabled=true;toggle.flareteleportenabled=true;toggle.shop.selected="Map";toggle.setkillaura(false,true);toggle.setkillaurarange(12,true);toggle.setkillauradelay(0.12,true);toggle.setzoomamount(10,true);toggle.setthirdperson(false,true);toggle.setshiftlock(false,true);toggle.setinstacrate(false,true)
    for _,id in ipairs({"locations","scraps","traps","flares","crates"})do setgroup(id,true,true)end;espgroups.rake=true;for id in pairs(espgroups.items)do toggle.setitem(id,true,true)end
    menuupdate();if not quiet then bindlog("reset toggles")end
end
toggle.resetbinds=function(quiet)
    keybinds={menu=defaultbinds.menu,esp=defaultbinds.esp,hud=defaultbinds.hud,scrap=defaultbinds.scrap,flare=defaultbinds.flare,aura=defaultbinds.aura,sell=defaultbinds.sell};capture=nil;menuupdate();if not quiet then bindlog("reset binds")end
end
local function resetsettings()
    toggle.uibatch=true
    toggle.resettheme(true);toggle.resetcolors(true);toggle.resettoggles(true);toggle.resetbinds(true);setfontindex(1,true);toggle.sethudfont(1,true);setfontsize(13,true);setringsegments(100,true)
    local v=cam.ViewportSize;menustate.x=24;menustate.y=math.floor((v.Y-menustate.h)/2);menustate.minimized=false;toggle.powerpanel.x=math.max(2,v.X-toggle.powerpanel.defaultoffsetx);toggle.powerpanel.y=math.max(2,v.Y-toggle.powerpanel.defaultoffsety);capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;configcapture=false;toggle.rakenamecapture=false
    toggle.uibatch=false;toggle.huddirty=false;powerhud();timerhud();hudpos();showhud();powerpos();menuupdate();bindlog("reset all settings")
end
local function runaction(id)
    if id=="menu"then if toggle.rakenamecapture then toggle.finishrakename(false)end;if toggle.watermark then if not toggle.menu then toggle.menu=true;menustate.minimized=false else menustate.minimized=not menustate.minimized end else toggle.menu=not toggle.menu;menustate.minimized=false end;capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;configcapture=false;showmenu();bindlog(not toggle.menu and"closed menu"or menustate.minimized and"watermark state"or"expanded menu")
    elseif id=="esp"then setesp(not toggle.esp)
    elseif id=="hud"then sethud(not toggle.hud)
    elseif id=="aura"then toggle.setkillaura(not toggle.killaura)
    elseif id=="sell"then
        if not toggle.sellenabled then return end;local ok,reason=toggle.sellscraps();bindlog(ok and"teleported to shop and sold scraps"or reason=="cooldown"and("tp safe cooldown: "..tostring(math.max(1,math.ceil(toggle.cooldownuntil-tick()))).."s")or reason=="night"and"sell scraps is unavailable at night"or"shop or sell event not found")
    elseif id=="scrap"or id=="flare"then
        if(id=="scrap"and not toggle.scrapteleportenabled)or(id=="flare"and not toggle.flareteleportenabled)then return end
        if not toggle.cooldownready()then bindlog("tp safe cooldown: "..tostring(math.max(1,math.ceil(toggle.cooldownuntil-tick()))).."s");return end
        local ok=false;if id=="scrap"then ok=tpscrap()else ok=tpflare()end;if ok then toggle.startcooldown()end;bindlog(ok and"teleported to "..id or id.." not found")
    end
end
local inputstate={dragging=false,sliding=nil,scrolling=nil,dropdownscrolling=false,powerdragging=false,groupdragging=false,mouseheld=false,dragx=0,dragy=0,powerdragx=0,powerdragy=0,groupdragx=0,groupdragy=0,scrolly=0,scrollstart=0,dropdownscrolly=0,dropdownscrollstart=0,wheel=0}
local function pickerapply(mx,my)
    local cfg=entrycfg(pickerentry);if not cfg then return nil end;local h,s,v=tohsv(cfg.labelcolor);local square=pickerlayouts.square;local hue=pickerlayouts.hue
    if square and inside(mx,my,square.x,square.y,square.w,square.h)then picker.hexactive=false;h=clamp((mx-square.x)/square.w,0,1);s=1-clamp((my-square.y)/square.h,0,1);setlabelcolor(pickerentry,Color3.fromHSV(h,s,v));return"pickersquare"end
    if hue and inside(mx,my,hue.x-3,hue.y,hue.w+6,hue.h)then picker.hexactive=false;v=1-clamp((my-hue.y)/hue.h,0,1);setlabelcolor(pickerentry,Color3.fromHSV(h,s,v));return"pickerhue"end
    return nil
end
local function sliderapply(mx,my,quiet)
    if inputstate.sliding=="pickersquare"or inputstate.sliding=="pickerhue"then pickerapply(mx,my);return end
    local layout=nil
    for i=1,#itemlayouts do if itemlayouts[i].item.id==inputstate.sliding and itemlayouts[i].visible then layout=itemlayouts[i];break end end
    if not layout then return end
    local item=layout.item;local ratio=clamp((mx-(layout.x+10))/(layout.w-20),0,1);local value=item.min+ratio*(item.max-item.min)
    if inputstate.sliding=="distancemin"then toggle.distancemin=math.floor(clamp(value,0,100)+0.5);menuupdate()
    elseif inputstate.sliding=="zoomamount"then toggle.setzoomamount(value,quiet)
    elseif inputstate.sliding=="fontsize"then setfontsize(value,quiet)
    elseif inputstate.sliding=="killaurarange"then toggle.setkillaurarange(value,quiet)
    elseif inputstate.sliding=="killauradelay"then toggle.setkillauradelay(value,quiet)
    elseif inputstate.sliding=="ringfade"then toggle.setringfade(value,quiet)
    elseif inputstate.sliding=="ringsize"then toggle.setringsize(value,quiet)
    elseif inputstate.sliding=="ringspinspeed"then toggle.setringspinspeed(value,quiet)
    elseif inputstate.sliding=="rgbspeed"then toggle.setrgbspeed(value,quiet)
    elseif inputstate.sliding=="timerwarning"then toggle.settimerwarning(value,quiet)
    elseif inputstate.sliding=="cooldownseconds"then toggle.setcooldownseconds(value,quiet)
    elseif inputstate.sliding=="ppmssquares"then toggle.setppmssquares(value,quiet)
    elseif inputstate.sliding=="rakenamey"then toggle.setrakenamey(value,quiet)
    elseif inputstate.sliding=="rakehealthy"then toggle.setrakehealthy(value,quiet)
    elseif inputstate.sliding=="rakebarwidth"then toggle.setrakebarwidth(value,quiet)
    elseif inputstate.sliding=="opacity"then setguiopacity(value,quiet)
    elseif inputstate.sliding=="borderradius"then toggle.setborderradius(value,quiet)end
end
local function clickmenu(mx,my)
    if pickerentry then
        if pickerlayouts.done and inside(mx,my,pickerlayouts.done.x,pickerlayouts.done.y,pickerlayouts.done.w,pickerlayouts.done.h)then if picker.hexactive then toggle.applypickerhex(true)end;local cfg=entrycfg(pickerentry);if cfg then toggle.pushrecent(cfg.labelcolor)end;picker.hexactive=false;picker.hexreplace=false;pickerentry=nil;inputstate.sliding=nil;menuupdate();return end
        if pickerlayouts.rgb and inside(mx,my,pickerlayouts.rgb.x,pickerlayouts.rgb.y,pickerlayouts.rgb.w,pickerlayouts.rgb.h)then local cfg=entrycfg(pickerentry);setlabelrgb(pickerentry,not cfg.rgb);return end
        if pickerlayouts.hex and inside(mx,my,pickerlayouts.hex.x,pickerlayouts.hex.y,pickerlayouts.hex.w,pickerlayouts.hex.h)then picker.hexactive=true;picker.hexreplace=true;picker.hexvalue=toggle.hexof(entrycfg(pickerentry).labelcolor);capture=nil;configcapture=false;menuupdate();return end
        if pickerlayouts.recents then for i=1,#pickerlayouts.recents do local layout=pickerlayouts.recents[i];if inside(mx,my,layout.x,layout.y,layout.w,layout.h)then picker.hexactive=false;setlabelcolor(pickerentry,picker.recentcolors[layout.index]);toggle.pushrecent(picker.recentcolors[layout.index]);menuupdate();return end end end
        local pickermode=pickerapply(mx,my);if pickermode then inputstate.sliding=pickermode;return end
        if not pickerlayouts.popup or not inside(mx,my,pickerlayouts.popup.x,pickerlayouts.popup.y,pickerlayouts.popup.w,pickerlayouts.popup.h)then if picker.hexactive then toggle.applypickerhex(true)end;local cfg=entrycfg(pickerentry);if cfg then toggle.pushrecent(cfg.labelcolor)end;picker.hexactive=false;picker.hexreplace=false;pickerentry=nil;inputstate.sliding=nil;menuupdate()end
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
                local kind=dropdownkind;dropdownkind=nil
                if kind=="espfont"then setfontindex(layout.index)
                elseif kind=="hudfont"then toggle.sethudfont(layout.index)
                elseif kind=="preset"then setthemeindex(layout.index)
                elseif kind=="shopitem"then local item=toggle.shop.lookup[layout.value];if item then toggle.shop.selected=item.name;bindlog("shop item set to "..item.label);menuupdate()end
                elseif kind=="unit"then toggle.setunit(layout.value)
                elseif kind=="distanceposition"then toggle.setdistanceposition(layout.value)
                elseif kind=="scrapstyle"then toggle.setscrapstyle(layout.value)
                elseif kind=="scrapteleport"then toggle.setscrapteleport(layout.value)
                elseif kind=="ringshape"then toggle.setringshape(layout.value)
                elseif kind=="rgbdirection"then toggle.setrgbdirection(layout.value)
                elseif kind=="powerformat"then toggle.setpowerformat(layout.value)
                elseif kind=="timerformat"then toggle.settimerformat(layout.value)
                elseif kind=="ppmsstyle"then toggle.setppmsstyle(layout.value)
                elseif kind=="rakehealthformat"then toggle.setrakehealthformat(layout.value)
                elseif kind=="hudstyle"then toggle.sethudstyle(layout.value)
                elseif kind=="poweractivitymode"then toggle.setpoweractivitymode(layout.value)
                elseif kind=="config"then configslot=layout.index;configname=layout.value;configcapture=false;menuupdate()end
                return
            end
        end
        dropdownkind=nil;menuupdate();return
    end
    local displayw=displaysize()
    if inside(mx,my,menustate.x+displayw-28,menustate.y,28,27)then if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end;if toggle.watermark then menustate.minimized=not menustate.minimized else toggle.menu=false;menustate.minimized=false end;capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;menupos();menuupdate();return end
    if menustate.minimized then return end
    local navw=menustate.w-8;local tabw=navw/#tabnames
    for i=1,#tabnames do
        if inside(mx,my,menustate.x+4+(i-1)*tabw,menustate.y+27,tabw,25)then if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end;if i~=menustate.tab then menustate.tabslide=i>menustate.tab and 10 or-10;menustate.tabfade=0 end;menustate.tab=i;capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;menuupdate();return end
    end
    for i=1,#itemlayouts do
        local layout=itemlayouts[i];local item=layout.item
        if layout.visible and item.kind~="section"and inside(mx,my,layout.x,layout.hittop,layout.w,layout.hitbottom-layout.hittop)then
            if item.colorindex and inside(mx,my,layout.colorx,layout.colory,layout.colorw,layout.colorh)then pickerentry=item.colorindex;picker.opened=false;picker.hexactive=false;picker.hexreplace=false;picker.hexvalue=toggle.hexof(entrycfg(pickerentry).labelcolor);capture=nil;dropdownkind=nil;menuupdate();return end
            if item.inlinebind and layout.bindx and inside(mx,my,layout.bindx,layout.bindy,layout.bindw,layout.bindh)then capture=item.bind;configcapture=false;dropdownkind=nil;menuupdate();return end
            if configcapture and item.id~="configname"then toggle.finishconfiginput(false)end
            if toggle.rakenamecapture and item.id~="rakenameinput"then toggle.finishrakename(false)end
            if item.kind=="toggle"then
                if item.id=="sell"then toggle.sellenabled=not toggle.sellenabled;menuupdate();bindlog(toggle.sellenabled and"armed tp to sell bind"or"disabled tp to sell bind")elseif item.id=="scrap"then toggle.scrapteleportenabled=not toggle.scrapteleportenabled;menuupdate();bindlog(toggle.scrapteleportenabled and"armed teleport to scrap bind"or"disabled teleport to scrap bind")elseif item.id=="flare"then toggle.flareteleportenabled=not toggle.flareteleportenabled;menuupdate();bindlog(toggle.flareteleportenabled and"armed teleport to flare bind"or"disabled teleport to flare bind")elseif item.id=="distanceminimum"or item.id=="healthbased"or item.id=="timerwarningenabled"then toggle[item.id]=not toggle[item.id];timerhud();showhud();menuupdate()elseif item.itemkey then toggle.setitem(item.itemkey,not espgroups.items[item.itemkey])elseif item.id=="esp"then setesp(not toggle.esp)elseif item.id=="hud"then sethud(not toggle.hud)elseif item.id=="hudtimer"then toggle.sethudelement("timer",not toggle.hudelements.timer)elseif item.id=="hudtarget"then toggle.sethudelement("target",not toggle.hudelements.target)elseif item.id=="hudscrap"then toggle.sethudelement("scrap",not toggle.hudelements.scrap)elseif item.id=="hudpower"then toggle.sethudelement("power",not toggle.hudelements.power)elseif item.id=="guitextoutline"then toggle.setguitextoutline(not toggle.guitextoutline)elseif item.id=="esptextoutline"then toggle.setesptextoutline(not toggle.esptextoutline)elseif item.id=="roof"then toggle.setroof(not toggle.roof)elseif item.id=="rakename"then toggle.setrakename(not toggle.rakename)elseif item.id=="rakehealth"then toggle.setrakehealth(not toggle.rakehealth)elseif item.id=="rakedistance"then toggle.setrakedistance(not toggle.rakedistance)elseif item.id=="thirdperson"then toggle.setthirdperson(not toggle.zoom.thirdperson)elseif item.id=="shiftlock"then toggle.setshiftlock(not toggle.shiftlockstate.active)elseif item.id=="killaura"then toggle.setkillaura(not toggle.killaura)elseif item.id=="instacrate"then toggle.setinstacrate(not toggle.instacrate)elseif item.id=="poweractivity"then toggle.setpoweractivity(not toggle.poweractivity)elseif item.id=="teleportcooldown"then toggle.setteleportcooldown(not toggle.teleportcooldown)elseif item.id=="ppms"then toggle.setppms(not toggle.ppms)elseif item.id=="watermark"then toggle.watermark=not toggle.watermark;if not toggle.watermark then menustate.minimized=false end;menuupdate();bindlog(toggle.watermark and"enabled watermark state"or"disabled watermark state")elseif item.id=="barrgb"then setbarrgb(not toggle.barrgb)elseif item.id=="distance"then setdistance(not toggle.distance)elseif item.id=="supplylabel"then toggle.setsupplylabel(not toggle.supplylabel)elseif item.id=="supplyitems"then toggle.setsupplyitems(not toggle.supplyitems)elseif item.id=="ringenabled"then toggle.setringenabled(not toggle.ringenabled)elseif item.id=="ringspin"then toggle.setringspin(not toggle.ringspin)elseif toggle.client[item.id]~=nil then toggle.setclient(item.id,not toggle.client[item.id])else setgroup(item.id,not espgroups[item.id])end
            elseif item.kind=="action"then
                if item.id=="quickbuy"or item.id=="quicksell"then local action=item.id=="quickbuy"and"PurchaseItem"or"SellItem";local ok,reason,count=toggle.shopaction(action);bindlog(ok and((action=="PurchaseItem"and"purchased "or"sold ")..tostring(count).." selected item"..(count==1 and""or"s"))or reason=="empty"and"select at least one shop item"or reason=="cooldown"and("tp safe cooldown: "..tostring(math.max(1,math.ceil(toggle.cooldownuntil-tick()))).."s")or reason=="night"and"shop actions are unavailable at night"or"shop action failed")elseif item.id=="save"then saveconfig()elseif item.id=="load"then loadconfig(false)elseif item.id=="resetcolors"then toggle.resetcolors(false)elseif item.id=="resettheme"then toggle.resettheme(false)elseif item.id=="resettoggles"then toggle.resettoggles(false)elseif item.id=="resetbinds"then toggle.resetbinds(false)elseif item.id=="reset"then resetsettings()end
            elseif item.kind=="dropdown"then
                dropdownkind=item.id=="espfontselect"and"espfont"or item.id=="hudfontselect"and"hudfont"or item.id=="presetselect"and"preset"or item.id=="distanceunitselect"and"unit"or item.id=="distancepositionselect"and"distanceposition"or item.id=="scrapstyleselect"and"scrapstyle"or item.id=="scrapteleportselect"and"scrapteleport"or item.id=="ringshapeselect"and"ringshape"or item.id=="rgbdirectionselect"and"rgbdirection"or item.id=="powerformatselect"and"powerformat"or item.id=="timerformatselect"and"timerformat"or item.id=="ppmsstyleselect"and"ppmsstyle"or item.id=="rakehealthformatselect"and"rakehealthformat"or item.id=="hudstyleselect"and"hudstyle"or item.id=="poweractivitymodeselect"and"poweractivitymode"or item.id=="shopitemselect"and"shopitem"or"config";dropdown.opened=false;capture=nil;menuupdate()
            elseif item.kind=="slider"then inputstate.sliding=item.id;sliderapply(mx,my,true)
            elseif item.kind=="bind"then capture=item.bind;configcapture=false;menuupdate()
            elseif item.kind=="text"then if item.id=="rakenameinput"then toggle.rakenamebackup=toggle.rakenamevalue;toggle.rakenamecapture=true;configcapture=false else toggle.configbackup=configname;configcapture=true;toggle.rakenamecapture=false end;capture=nil;dropdownkind=nil;menuupdate()
            elseif item.kind=="color"then pickerentry=item.index;picker.opened=false;picker.hexactive=false;picker.hexreplace=false;picker.hexvalue=toggle.hexof(entrycfg(pickerentry).labelcolor);dropdownkind=nil;menuupdate()end
            return
        end
    end
    if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end
end
local function mouseinput()
    local down=ismouse1pressed();local pressed=down and not inputstate.mouseheld;local mx,my=mouse.X,mouse.Y
    if toggle.menu then
        if inputstate.wheel~=0 then if dropdownkind and dropdown.layout and inside(mx,my,dropdown.layout.x,dropdown.layout.y,dropdown.layout.w,dropdown.layout.h)and dropdown.scrollmax>0 then dropdown.offset=clamp(dropdown.offset+inputstate.wheel,0,dropdown.scrollmax);menuupdate(true)elseif not menustate.minimized and inside(mx,my,menustate.x+6,menustate.y+53,menustate.w-12,menustate.h-57)then menustate.scrolltarget[menustate.tab]=clamp((menustate.scrolltarget[menustate.tab]or 0)+inputstate.wheel*42,0,menustate.scrollmax[menustate.tab]or 0);dropdownkind=nil end;inputstate.wheel=0 end
        if pressed then
            local displayw=displaysize()
            if pickerentry or dropdownkind then clickmenu(mx,my)
            elseif inside(mx,my,menustate.x,menustate.y,displayw,27)and not inside(mx,my,menustate.x+displayw-28,menustate.y,28,27)then if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end;inputstate.dragging=true;inputstate.dragx=mx-menustate.x;inputstate.dragy=my-menustate.y
            elseif not menustate.minimized and(menustate.scrollmax[menustate.tab]or 0)>0 and menustate.scrollthumb and inside(mx,my,menustate.scrollthumb.x,menustate.scrollthumb.y,menustate.scrollthumb.w,menustate.scrollthumb.h)then inputstate.scrolling="thumb";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]or 0
            elseif not menustate.minimized and(menustate.scrollmax[menustate.tab]or 0)>0 and menustate.scrollthumb and inside(mx,my,menustate.scrollthumb.x,menustate.scrollthumb.tracky,menustate.scrollthumb.w,menustate.scrollthumb.trackh)then local travel=menustate.scrollthumb.trackh-menustate.scrollthumb.thumbh;menustate.scrolltarget[menustate.tab]=clamp((my-menustate.scrollthumb.tracky-menustate.scrollthumb.thumbh/2)/math.max(1,travel)*(menustate.scrollmax[menustate.tab]or 0),0,menustate.scrollmax[menustate.tab]or 0);inputstate.scrolling="thumb";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]
            else local occupied=false;if not menustate.minimized then for i=1,#itemlayouts do local l=itemlayouts[i];if l.visible and l.item.kind~="section"and inside(mx,my,l.x,l.hittop,l.w,l.hitbottom-l.hittop)then occupied=true;break end end end;if not occupied and not menustate.minimized and inside(mx,my,menustate.x+6,menustate.y+53,menustate.w-12,menustate.h-57)and(menustate.scrollmax[menustate.tab]or 0)>0 then inputstate.scrolling="content";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]or 0 else clickmenu(mx,my)end end
        end
        if down and inputstate.dropdownscrolling and dropdownkind and dropdown.layout then local bar=dropdown.layout;dropdown.offset=clamp(inputstate.dropdownscrollstart+(my-inputstate.dropdownscrolly)/math.max(1,bar.travel)*dropdown.scrollmax,0,dropdown.scrollmax);menuupdate(true)end
        if down and inputstate.dragging then menustate.x=mx-inputstate.dragx;menustate.y=my-inputstate.dragy end
        if down and inputstate.scrolling then if inputstate.scrolling=="content"then menustate.scrolltarget[menustate.tab]=clamp(inputstate.scrollstart-(my-inputstate.scrolly),0,menustate.scrollmax[menustate.tab]or 0)else local thumb=menustate.scrollthumb;local travel=thumb and thumb.trackh-thumb.thumbh or 0;menustate.scrolltarget[menustate.tab]=clamp(inputstate.scrollstart+(my-inputstate.scrolly)/math.max(1,travel)*(menustate.scrollmax[menustate.tab]or 0),0,menustate.scrollmax[menustate.tab]or 0)end end
        if down and inputstate.sliding then sliderapply(mx,my,true)else menuupdate(true)end
    end
    local p=toggle.powerpanel;local mw,mh=displaysize();local panelblocked=pickerentry~=nil or dropdownkind~=nil or toggle.menu and inside(mx,my,menustate.x,menustate.y,mw,mh)
    if pressed and not panelblocked and toggle.hudstyle=="container"and toggle.groupwidget.bg.Visible and inside(mx,my,toggle.widgetgroup.x,toggle.widgetgroup.y,toggle.widgetgroup.w,toggle.widgetgroup.h)then inputstate.groupdragging=true;inputstate.groupdragx=mx-toggle.widgetgroup.x;inputstate.groupdragy=my-toggle.widgetgroup.y end
    if pressed and not panelblocked and not inputstate.groupdragging and p.bg.Visible and inside(mx,my,p.x,p.y,p.w,p.h)then inputstate.powerdragging=true;inputstate.powerdragx=mx-p.x;inputstate.powerdragy=my-p.y end
    if down and inputstate.groupdragging then toggle.widgetgroup.dragged=true;toggle.widgetgroup.x=mx-inputstate.groupdragx;toggle.widgetgroup.y=my-inputstate.groupdragy;hudpos();showhud()end
    if down and inputstate.powerdragging then p.x=mx-inputstate.powerdragx;p.y=my-inputstate.powerdragy;powerpos()end
    if not down then
        if inputstate.sliding=="zoomamount"then bindlog("zoom amount set to "..string.format("%.1f",toggle.zoom.amount).." studs")elseif inputstate.sliding=="fontsize"then bindlog("font size set to "..tostring(espfontsize))elseif inputstate.sliding=="killaurarange"then bindlog("stun aura range set to "..tostring(toggle.killaurarange).." studs")elseif inputstate.sliding=="killauradelay"then bindlog("stun aura delay set to "..string.format("%.2fs",toggle.killauradelay))elseif inputstate.sliding=="ringfade"then bindlog("ring distance updated")elseif inputstate.sliding=="ringsize"then bindlog("ring size set to "..string.format("%.1fx",toggle.ringsize))elseif inputstate.sliding=="ringspinspeed"then bindlog("ring spin speed updated")elseif inputstate.sliding=="rgbspeed"then bindlog("rainbow speed updated")elseif inputstate.sliding=="timerwarning"then bindlog("timer warning set to "..tostring(toggle.timerwarning).."s")elseif inputstate.sliding=="rakenamey"then bindlog("rake name Y offset set to "..tostring(toggle.rakenamey).."px")elseif inputstate.sliding=="rakehealthy"then bindlog("rake health Y offset set to "..tostring(toggle.rakehealthy).."px")elseif inputstate.sliding=="rakebarwidth"then bindlog("rake health bar width set to "..tostring(toggle.rakebarwidth).."px")elseif inputstate.sliding=="opacity"then bindlog("GUI opacity set to "..tostring(math.floor(guiopacity*100+0.5)).."%")elseif inputstate.sliding=="borderradius"then bindlog("border radius set to "..tostring(toggle.borderradius).."px")elseif(inputstate.sliding=="pickersquare"or inputstate.sliding=="pickerhue")and pickerentry then bindlog("updated "..toggle.colorname(pickerentry).." color")end
        inputstate.dragging=false;inputstate.sliding=nil;inputstate.scrolling=nil;inputstate.dropdownscrolling=false;inputstate.powerdragging=false;inputstate.groupdragging=false
    end
    inputstate.mouseheld=down
end
local function keys()
    local edges={}
    if pickerentry and picker.hexactive and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then local cfg=entrycfg(pickerentry);picker.hexvalue=cfg and toggle.hexof(cfg.labelcolor)or"FFFFFF";picker.hexactive=false;picker.hexreplace=false;menuupdate();return
        elseif edges[0x0D]then if toggle.applypickerhex(false)then picker.hexactive=false;picker.hexreplace=false;menuupdate()end;return
        elseif edges[0x08]then picker.hexvalue=picker.hexreplace and""or string.sub(picker.hexvalue,1,math.max(0,#picker.hexvalue-1));picker.hexreplace=false;menuupdate();return end
        local added=nil;for code=0x30,0x39 do if edges[code]then added=string.char(code);break end end;if not added then for code=0x41,0x46 do if edges[code]then added=string.char(code);break end end end
        if added then if picker.hexreplace then picker.hexvalue="";picker.hexreplace=false end;if #picker.hexvalue<6 then picker.hexvalue=picker.hexvalue..added;menuupdate()end end;return
    end
    if toggle.rakenamecapture and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then toggle.finishrakename(true);return elseif edges[0x0D]then toggle.finishrakename(false);return elseif edges[0x08]then toggle.rakenamevalue=string.sub(toggle.rakenamevalue,1,math.max(0,#toggle.rakenamevalue-1));menuupdate();return end
        local added=nil;for code=0x30,0x39 do if edges[code]then added=string.char(code);break end end;if not added then for code=0x41,0x5A do if edges[code]then added=iskeypressed(0x10)and string.char(code)or string.lower(string.char(code));break end end end;if not added and edges[0x20]then added=" "elseif not added and edges[0xBD]then added="-"end
        if added and #toggle.rakenamevalue<20 then toggle.rakenamevalue=toggle.rakenamevalue..added;toggle.rakedraw.name.Text=toggle.rakenamevalue;menuupdate()end;return
    end
    if configcapture and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then toggle.finishconfiginput(true);return elseif edges[0x0D]then toggle.finishconfiginput(false);return elseif edges[0x08]then configname=string.sub(configname,1,math.max(0,#configname-1));menuupdate();return end
        local added=nil;for code=0x30,0x39 do if edges[code]then added=string.char(code);break end end;if not added then for code=0x41,0x5A do if edges[code]then added=string.lower(string.char(code));break end end end;if not added and edges[0x20]then added=" "elseif not added and edges[0xBD]then added="-"end
        if added and #configname<18 then configname=configname..added;menuupdate()end;return
    end
    if capture and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then capture=nil;menuupdate();bindlog("cancelled keybind change");return elseif edges[0x08]then setbind(capture,0);return end
        for i=1,#keyoptions do local code=keyoptions[i].code;if edges[code]then setbind(capture,code);return end end
        return
    end
    for i=1,#bindorder do local code=keybinds[bindorder[i]];if code~=0 and edges[code]==nil then local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end end
    for i=1,#bindorder do local id=bindorder[i];local code=keybinds[id];if code~=0 and edges[code]then runaction(id)end end
end
toggle.drawesp=function()
    keys();mouseinput()
    if not toggle.esp then return end
    local viewer=viewpos();local i=#tracked
    while i>=1 do local rec=tracked[i];local ok,alive=pcall(drawrec,rec,viewer);if not ok or not alive then untrack(i)end;i=i-1 end
    drawroof();toggle.drawrake(viewer)
end
toggle.lastviewport=cam.ViewportSize
spawn(function()
    while true do
        local v=cam.ViewportSize
        if v.X~=toggle.lastviewport.X or v.Y~=toggle.lastviewport.Y then toggle.lastviewport=v;hudpos();menupos()end
        if timerhud()then hudpos()end;task.wait(hudrate)
    end
end)
spawn(function()while true do local changed=scraphud();if powerhud()then changed=true end;if targethud()then changed=true end;if changed then hudpos();showhud()end;task.wait(statusrate)end end)
spawn(function()
    local nextrake=0
    while true do
        pcall(scan);local now=tick();if now>=nextrake then pcall(rakeinfo);nextrake=now+1 end
        task.wait(scanrate)
    end
end)
spawn(function()
    while true do
        pcall(toggle.applyclient,false);pcall(toggle.applykillaura,false);pcall(toggle.applyzoom,false);pcall(toggle.applyshiftlock)
        task.wait(0.05)
    end
end)
spawn(function()
    while true do
        if toggle.instacrate then pcall(toggle.applyinstacrate,false)end
        task.wait(0.1)
    end
end)
spawn(function()
    local lastframe=tick()
    while true do
        local now=tick();toggle.frametime=now;toggle.framedt=clamp(now-lastframe,1/240,0.1);lastframe=now;toggle.rgbphase=((now*rgbspeed)*(toggle.rgbdirection=="left"and 1 or-1))%1
        toggle.gradientcache.frame=toggle.gradientcache.frame+1;pcall(toggle.drawesp);pcall(drawrgb)
        task.wait()
    end
end)
toggle.setscrapstyle(toggle.scrapstyle,true)
toggle.refreshconfigs(toggle.readlastconfig())
if not loadconfig(true)then pcall(function()makefolder("therakesaint");writefile(configpath(),http:JSONEncode(configdata()))end);toggle.refreshconfigs(configname)end
if toggle.watermark then toggle.menu=true;menustate.minimized=true;menustate.minimizeanim=1;menustate.menuanim=1;menustate.contentfade=0 else toggle.menu=false;menustate.minimized=false;menustate.minimizeanim=0;menustate.menuanim=0;menustate.contentfade=1 end
showhud();showmenu()
print("rake's saint")
