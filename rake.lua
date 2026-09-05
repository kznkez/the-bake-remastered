local version = "2.0"
local players=game:GetService("Players")
local rs=game:GetService("ReplicatedStorage")
local ws=game:GetService("Workspace")
local http=game:GetService("HttpService")
local lp=players.LocalPlayer
local cam=ws.CurrentCamera
local mouse=lp and lp:GetMouse()or nil
local fontnames={"UI","system","system bold","minecraft","monospace","pixel","fortnite"}
local fontvalues={Drawing.Fonts.UI,Drawing.Fonts.System,Drawing.Fonts.SystemBold,Drawing.Fonts.Minecraft,Drawing.Fonts.Monospace,Drawing.Fonts.Pixel,Drawing.Fonts.Fortnite}
local fontindex=1
local font=fontvalues[fontindex]
local stud2m=1/3.5714285714
local scanrate,hudrate,statusrate=1,0.1,0.25
local ringfade,ringseg,cratedist,maxtrack,espfade=40,64,30,256,350
local toggle={esp=true,hud=true,distance=true,distancefade=true,menu=false,barrgb=true,roof=true,distanceunit="meters",scrapstyle="numbers",supplylabel=true,supplyitems=true}
toggle.distancestyle={labelcolor=Color3.fromHex("#c9c9c9"),defaultcolor=Color3.fromHex("#c9c9c9"),rgb=false,defaultrgb=false}
toggle.hudstyles={
    timer={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false},
    target={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false},
    scrap={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false},
    power={labelcolor=Color3.fromHex("#aaaaaa"),defaultcolor=Color3.fromHex("#aaaaaa"),rgb=false,defaultrgb=false}
}
toggle.cratestyles={
    FirstAidKit={name="medkit",labelcolor=Color3.fromHex("#dbffde"),defaultcolor=Color3.fromHex("#dbffde"),rgb=false},
    Vitamins={name="vitamin",labelcolor=Color3.fromHex("#d1d3ff"),defaultcolor=Color3.fromHex("#d1d3ff"),rgb=false},
    UV_Lamp={name="UV lamp",labelcolor=Color3.fromHex("#e694ff"),defaultcolor=Color3.fromHex("#e694ff"),rgb=false},
    StunStick={name="stun stick",labelcolor=Color3.fromHex("#ffed9d"),defaultcolor=Color3.fromHex("#ffed9d"),rgb=false},
    Vest={name="vest",labelcolor=Color3.fromHex("#9fd4ff"),defaultcolor=Color3.fromHex("#9fd4ff"),rgb=false},
    Tracker={name="tracker",labelcolor=Color3.fromHex("#cdceff"),defaultcolor=Color3.fromHex("#cdceff"),rgb=false}
}
local espgroups={locations=true,scraps=true,traps=true,flares=true,crates=true}
espgroups.items={BaseCampMSG=true,SafehouseMSG=true,StationMSG=true,ShopMSG=true,ObservationTowerMSG=true,Scrap1=true,Scrap2=true,Scrap3=true,Scrap4=true,Scrap5=true}
local espfontsize=13
local guiopacity=0.95
local espcfg={}
local roofstyle={labelcolor=Color3.fromHex("#f5d3ff"),defaultcolor=Color3.fromHex("#f5d3ff"),rgb=false,defaultrgb=false}
local colorentries={
    {name="flare",cfgs={"FlareGunPickUp"}},{name="scrap 1",cfgs={"Scrap1"}},{name="scrap 2",cfgs={"Scrap2"}},{name="scrap 3",cfgs={"Scrap3"}},{name="scrap 4",cfgs={"Scrap4"}},{name="scrap 5",cfgs={"Scrap5"}},{name="trap",cfgs={"RakeTrapModel"}},{name="supply",cfgs={"Box","SupplyCrate"}},
    {name="base",cfgs={"BaseCampMSG"}},{name="house",cfgs={"SafehouseMSG"}},{name="station",cfgs={"StationMSG"}},{name="shop",cfgs={"ShopMSG"}},{name="tower",cfgs={"ObservationTowerMSG"}}
}
local defaultbinds={menu=0xBB,esp=0x70,hud=0x71,scrap=0x72,flare=0x73}
local keybinds={menu=defaultbinds.menu,esp=defaultbinds.esp,hud=defaultbinds.hud,scrap=defaultbinds.scrap,flare=defaultbinds.flare}
local bindorder={"menu","esp","hud","scrap","flare"}
local bindlabels={menu="menu",esp="ESP toggle",hud="HUD toggle",scrap="scrap teleport",flare="flare teleport"}
local keyoptions,keynames,keywas={},{},{}
local function addkey(code,name)keyoptions[#keyoptions+1]={code=code,name=name};keynames[code]=name;keywas[code]=false end
addkey(0x08,"backspace");addkey(0x09,"tab");addkey(0x0D,"enter");addkey(0x10,"shift");addkey(0x11,"ctrl");addkey(0x12,"alt");addkey(0x1B,"escape");addkey(0x20,"space")
addkey(0x21,"page up");addkey(0x22,"page down");addkey(0x23,"end");addkey(0x24,"home");addkey(0x25,"left");addkey(0x26,"up");addkey(0x27,"right");addkey(0x28,"down");addkey(0x2D,"insert");addkey(0x2E,"delete")
for i=0x30,0x39 do addkey(i,string.char(i))end
for i=0x41,0x5A do addkey(i,string.char(i))end
for i=0,11 do addkey(0x70+i,"F"..tostring(i+1))end
addkey(0xBA,";");addkey(0xBB,"=");addkey(0xBC,",");addkey(0xBD,"-");addkey(0xBE,".");addkey(0xBF,"/");addkey(0xC0,"`");addkey(0xDB,"[");addkey(0xDC,"\\");addkey(0xDD,"]");addkey(0xDE,"'")
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
if not cam or not lp or not mouse then return end

local timerval=waitchild(rs,"Timer",15)
local powervals=waitchild(rs,"PowerValues",15)
if not timerval or not powervals then return end
toggle.powerlevel=powervals:FindFirstChild("PowerLevel")
local alltexts={}
local function newtext(text,color,center,visible,outline)
    local d=Drawing.new("Text")
    d.Text=text or "";d.Color=color or Color3.fromHex("#ffffff");d.Center=center==true;d.Visible=visible==true;d.Outline=outline~=false;d.Font=font
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
toggle.powerdraw={value=newtext("0",Color3.fromHex("#ffffff"),true,true),label=newtext("power",Color3.fromHex("#aaaaaa"),true,true)}
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
local barseg,rgbwidth,rgbspeed=240,360,0.4
local huddown=100
local function rgb(offset)return Color3.fromHSV(((tick()*rgbspeed)+(offset or 0))%1,0.68,1)end
local rgbline={}
for i=1,barseg do rgbline[i]=newline(Color3.fromHSV((i-1)/barseg,0.68,1));rgbline[i].Thickness=1 end
local themes={
    {name="cold oled",bg="#010203",top="#030507",side="#020304",card="#06090c",hover="#0a0f14",select="#121b24",text="#e6edf3",muted="#56636e",accent="#78b7e6"},
    {name="ember glass",bg="#030101",top="#060303",side="#040202",card="#090505",hover="#100808",select="#1a0e0e",text="#f0e7e5",muted="#705b59",accent="#df7868"},
    {name="deep navy",bg="#010204",top="#020509",side="#010306",card="#050a12",hover="#08111d",select="#0e1b29",text="#e4edf5",muted="#536574",accent="#62b4dc"},
    {name="plum void",bg="#020103",top="#050207",side="#030104",card="#08040b",hover="#0e0713",select="#180d20",text="#eee7f2",muted="#69576f",accent="#b283d3"},
    {name="evergreen",bg="#010302",top="#020604",side="#010402",card="#050a07",hover="#08110c",select="#0e1c14",text="#e4eee7",muted="#52675a",accent="#6db989"},
    {name="soft ash",bg="#030405",top="#050709",side="#040506",card="#080b0e",hover="#0c1116",select="#151b22",text="#e6e8eb",muted="#606a75",accent="#a2b0c3"},
    {name="dim oled",bg="#010101",top="#020303",side="#010202",card="#050607",hover="#080a0c",select="#101419",text="#e8ebed",muted="#555e64",accent="#8da8c0"},
    {name="carbon dusk",bg="#020203",top="#040405",side="#030304",card="#070709",hover="#0b0b0f",select="#14141b",text="#e9e7ed",muted="#5d5963",accent="#a78ec4"}
}
local themekeys={"bg","top","side","card","hover","select","text","muted","accent"}
for i=1,#themes do for j=1,#themekeys do local key=themekeys[j];themes[i][key]=Color3.fromHex(themes[i][key])end end
local themeindex=7
themes.accentstyle={labelcolor=themes[themeindex].accent,rgb=false}
toggle.themestyles={background={labelcolor=themes[themeindex].bg,rgb=false},topbar={labelcolor=themes[themeindex].top,rgb=false},surface={labelcolor=themes[themeindex].card,rgb=false},border={labelcolor=themes[themeindex].select,rgb=false},text={labelcolor=themes[themeindex].text,rgb=false}}
local menustate={w=340,h=386,watermarkw=100,watermarkh=27,x=24,y=math.floor((cam.ViewportSize.Y-386)/2),tab=1,minimized=false,maxitems=32}
local tabnames={"toggles","colors","misc","binds","config"}
local menubg=newsquare(Color3.fromHex("#16161e"),0.98)
local menutop=newsquare(Color3.fromHex("#1a1b26"),1)
local menuside=newsquare(Color3.fromHex("#13131a"),1)
local menuchrome={border=newborder(Color3.fromHex("#343b46"),1),content=newborder(Color3.fromHex("#272c35"),1),divider=newline(Color3.fromHex("#272c35"))}
menuchrome.divider.Thickness=1
local menutitle=newtext("the saint's rake",Color3.fromHex("#ffffff"),false,false)
menutitle.Size=13
menustate.watermarkw=math.min(menustate.w,math.max(100,#menutitle.Text*7+28))
local menuclose=newtext("-",Color3.fromHex("#787c99"),true,false)
local tabbg,tabtext={},{}
for i=1,#tabnames do tabbg[i]=newsquare(Color3.fromHex("#202330"),1);tabtext[i]=newtext(tabnames[i],Color3.fromHex("#ffffff"),true,false);tabtext[i].Size=13 end
local itembg,itemlabel,itemvalue,itemmark,itemline,itemtrack,itemfill={},{},{},{},{},{},{}
for i=1,menustate.maxitems do
    itembg[i]=newsquare(Color3.fromHex("#202330"),1);itemlabel[i]=newtext("",Color3.fromHex("#ffffff"),false,false);itemvalue[i]=newtext("",Color3.fromHex("#ffffff"),false,false);itemmark[i]=newsquare(Color3.fromHex("#7aa2f7"),1);itemline[i]=newline(Color3.fromHex("#787c99"));itemline[i].Thickness=1;itemtrack[i]=newsquare(Color3.fromHex("#343b58"),1);itemfill[i]=newsquare(Color3.fromHex("#7aa2f7"),1)
end
local dropdown={bg={},text={},max=12}
for i=1,dropdown.max do dropdown.bg[i]=newsquare(Color3.fromHex("#202330"),1);dropdown.text[i]=newtext("",Color3.fromHex("#ffffff"),false,false)end
local picker={
    bg=newsquare(Color3.fromHex("#08090c"),0.98),border=newborder(Color3.fromHex("#343b46"),1),title=newtext("color",Color3.fromHex("#ffffff"),false,false),
    preview=newsquare(Color3.fromHex("#ffffff"),1),previewborder=newborder(Color3.fromHex("#ffffff"),1),grid={},hue={},cursor=nil,huecursor=nil,
    rgbmark=newsquare(Color3.fromHex("#7aa2f7"),1),rgbtext=newtext("RGB",Color3.fromHex("#ffffff"),false,false),
    donebg=newsquare(Color3.fromHex("#20242b"),1),donetext=newtext("done",Color3.fromHex("#ffffff"),true,false)
}
picker.cols=24;picker.rows=18;picker.huesteps=72
for y=1,picker.rows do for x=1,picker.cols do picker.grid[#picker.grid+1]=newsquare(Color3.fromHex("#ffffff"),1)end end
for i=1,picker.huesteps do picker.hue[i]=newsquare(Color3.fromHSV((i-1)/picker.huesteps,1,1),1)end
picker.cursor=newborder(Color3.fromHex("#ffffff"),1);picker.huecursor=newborder(Color3.fromHex("#ffffff"),1)
local menurgb={}
for i=1,barseg do menurgb[i]=newline(Color3.fromHSV((i-1)/barseg,0.68,1));menurgb[i].Thickness=1 end
local capture,pickerentry,dropdownkind,configcapture=nil,nil,nil,false
local configslots={"default"}
local configslot=1
local configname="default"
local menuitems,itemlayouts={},{}
local pickerlayouts,dropdownlayouts={},{}
local function color(name)
    if name=="accent"then return themes.accentstyle.labelcolor elseif name=="bg"or name=="side"then return toggle.themestyles.background.labelcolor elseif name=="top"then return toggle.themestyles.topbar.labelcolor elseif name=="card"or name=="hover"then return toggle.themestyles.surface.labelcolor elseif name=="select"then return toggle.themestyles.border.labelcolor elseif name=="text"then return toggle.themestyles.text.labelcolor end
    return themes[themeindex][name]
end
local function inside(px,py,x,y,w,h)return px>=x and px<=x+w and py>=y and py<=y+h end
local function entrycfg(index)
    if index=="accent"then return themes.accentstyle elseif index=="themebg"then return toggle.themestyles.background elseif index=="themetop"then return toggle.themestyles.topbar elseif index=="themesurface"then return toggle.themestyles.surface elseif index=="themeborder"then return toggle.themestyles.border elseif index=="themetext"then return toggle.themestyles.text elseif index=="distance"then return toggle.distancestyle elseif index=="roof"then return roofstyle elseif index=="hudtimer"then return toggle.hudstyles.timer elseif index=="hudtarget"then return toggle.hudstyles.target elseif index=="hudscrap"then return toggle.hudstyles.scrap elseif index=="hudpower"then return toggle.hudstyles.power elseif type(index)=="string"and string.sub(index,1,6)=="crate_"then return toggle.cratestyles[string.sub(index,7)]end
    local entry=colorentries[index];return entry and espcfg[entry.cfgs[1]]or nil
end
toggle.colorname=function(index)
    if type(index)=="number"then return colorentries[index].name elseif type(index)=="string"and string.sub(index,1,6)=="crate_"then local cfg=toggle.cratestyles[string.sub(index,7)];return cfg and cfg.name or"supply item"end
    local names={accent="accent",themebg="background",themetop="top bar",themesurface="surface",themeborder="border",themetext="text",distance="distance label",roof="roof HP",hudtimer="timer label",hudtarget="target label",hudscrap="scrap label",hudpower="power label"};return names[index]or"color"
end
local function channel(value)return math.floor(clamp(value*255,0,255)+0.5)end
local function tohsv(c)
    local r,g,b=c.R,c.G,c.B;local maximum=math.max(r,g,b);local minimum=math.min(r,g,b);local delta=maximum-minimum;local h=0
    if delta>0 then
        if maximum==r then h=((g-b)/delta)%6 elseif maximum==g then h=(b-r)/delta+2 else h=(r-g)/delta+4 end
        h=h/6
    end
    return h,maximum==0 and 0 or delta/maximum,maximum
end
local function section(label,col)return {kind="section",label=label,col=col or 1}end
toggle.itemshown=function(item)
    local shown=item.display or item.value and tostring(item.value)or item.kind=="action"and"run"or"";if item.kind=="dropdown"then shown=shown.." >"end;if #shown>18 then shown=string.sub(shown,1,16)..".."end;return shown
end
local function currentitems()
    if menustate.tab==1 then
        local fadevalue=toggle.distanceunit=="studs"and math.floor(espfade/stud2m)or math.floor(espfade);local fadesuffix=toggle.distanceunit=="studs"and"s"or"m"
        local items={section("overlay",1),{id="esp",kind="toggle",label="esp toggle",on=toggle.esp,col=1},{id="hud",kind="toggle",label="hud toggle",on=toggle.hud,col=1},section("distance",1),{id="distance",kind="toggle",label="distance",on=toggle.distance,col=1},{id="distanceunitselect",kind="dropdown",label="unit",value=toggle.distanceunit,col=1},{id="distancefade",kind="toggle",label="fade-out",on=toggle.distancefade,col=1},{id="espfade",kind="slider",label="fade radius",value=espfade,min=50,max=750,display=tostring(fadevalue)..fadesuffix,col=1},section("world items",1),{id="flares",kind="toggle",label="flare",on=espgroups.flares,col=1},{id="traps",kind="toggle",label="trap",on=espgroups.traps,col=1},{id="supplylabel",kind="toggle",label="crate",on=toggle.supplylabel,col=1},{id="supplyitems",kind="toggle",label="crate inventory",on=toggle.supplyitems,col=1},section("locations",2),{id="roof",kind="toggle",label="roof HP",on=toggle.roof,col=2}}
        for i=9,13 do local cfg=colorentries[i];items[#items+1]={id="item"..cfg.cfgs[1],kind="toggle",label=cfg.name,on=espgroups.items[cfg.cfgs[1]],itemkey=cfg.cfgs[1],col=2}end
        items[#items+1]=section("scraps",2);items[#items+1]={id="scrapstyleselect",kind="dropdown",label="tier style",value=toggle.scrapstyle,col=2}
        for i=2,6 do local cfg=colorentries[i];items[#items+1]={id="item"..cfg.cfgs[1],kind="toggle",label=cfg.name,on=espgroups.items[cfg.cfgs[1]],itemkey=cfg.cfgs[1],col=2}end
        return items
    elseif menustate.tab==2 then
        local items={section("locations",1)}
        for i=9,13 do items[#items+1]={id="labelcolor"..tostring(i),kind="color",label=colorentries[i].name,index=i,col=1}end
        items[#items+1]=section("scraps",1)
        for i=2,6 do items[#items+1]={id="labelcolor"..tostring(i),kind="color",label=colorentries[i].name,index=i,col=1}end
        items[#items+1]=section("hud",1);items[#items+1]={id="hudtimercolor",kind="color",label="timer label",index="hudtimer",col=1};items[#items+1]={id="hudtargetcolor",kind="color",label="target label",index="hudtarget",col=1};items[#items+1]={id="hudscrapcolor",kind="color",label="scrap label",index="hudscrap",col=1};items[#items+1]={id="hudpowercolor",kind="color",label="power",index="hudpower",col=1}
        items[#items+1]=section("world",2)
        for _,i in ipairs({1,7,8})do items[#items+1]={id="labelcolor"..tostring(i),kind="color",label=colorentries[i].name,index=i,col=2}end
        items[#items+1]=section("crate",2);for _,entry in ipairs({{"FirstAidKit","medkit"},{"Vitamins","vitamin"},{"UV_Lamp","uv lamp"},{"StunStick","stun stick"},{"Vest","vest"},{"Tracker","tracker"}})do items[#items+1]={id="cratecolor"..entry[1],kind="color",label=entry[2],index="crate_"..entry[1],col=2}end
        items[#items+1]=section("misc",2);items[#items+1]={id="distancecolor",kind="color",label="distance label",index="distance",col=2};items[#items+1]={id="roofcolor",kind="color",label="roof HP",index="roof",col=2};return items
    elseif menustate.tab==3 then return {section("interface",1),{id="presetselect",kind="dropdown",label="preset",value=themes[themeindex].name,col=1},{id="opacity",kind="slider",label="opacity",value=guiopacity,min=0.2,max=1,display=tostring(math.floor(guiopacity*100+0.5)).."%",col=1},{id="barrgb",kind="toggle",label="rainbow accent",on=toggle.barrgb,col=1},section("theme colors",1),{id="accentcolor",kind="color",label="accent",index="accent",col=1},{id="themebgcolor",kind="color",label="background",index="themebg",col=1},{id="themetopcolor",kind="color",label="top bar",index="themetop",col=1},{id="themesurfacecolor",kind="color",label="surface",index="themesurface",col=1},{id="themebordercolor",kind="color",label="border",index="themeborder",col=1},{id="themetextcolor",kind="color",label="text",index="themetext",col=1},section("overlay style",2),{id="fontselect",kind="dropdown",label="font",value=fontnames[fontindex],col=2},{id="fontsize",kind="slider",label="font size",value=espfontsize,min=12,max=18,col=2},{id="ring",kind="slider",label="ring quality",value=ringseg,min=8,max=128,col=2},section("teleports",2),{id="scrap",kind="action",label="scrap",col=2},{id="flare",kind="action",label="flare",col=2}}
    elseif menustate.tab==4 then return {section("interface",1),{id="bindmenu",kind="bind",bind="menu",label=bindlabels.menu,value=capture=="menu"and"press a key..."or"["..(keynames[keybinds.menu]or tostring(keybinds.menu)).."]",col=1},{id="bindesp",kind="bind",bind="esp",label=bindlabels.esp,value=capture=="esp"and"press a key..."or"["..(keynames[keybinds.esp]or tostring(keybinds.esp)).."]",col=1},{id="bindhud",kind="bind",bind="hud",label=bindlabels.hud,value=capture=="hud"and"press a key..."or"["..(keynames[keybinds.hud]or tostring(keybinds.hud)).."]",col=1},section("teleports",2),{id="bindscrap",kind="bind",bind="scrap",label=bindlabels.scrap,value=capture=="scrap"and"press a key..."or"["..(keynames[keybinds.scrap]or tostring(keybinds.scrap)).."]",col=2},{id="bindflare",kind="bind",bind="flare",label=bindlabels.flare,value=capture=="flare"and"press a key..."or"["..(keynames[keybinds.flare]or tostring(keybinds.flare)).."]",col=2}}
    end
    return {section("profiles",1),{id="configname",kind="text",label="name",value=configcapture and configname.."_"or configname,col=1},{id="configselect",kind="dropdown",label="saved cfg",value=configslots[configslot]or"none",col=1},{id="save",kind="action",label="save cfg",col=1},{id="load",kind="action",label="load cfg",col=1},section("reset",2),{id="resetcolors",kind="action",label="reset colors",col=2},{id="resettheme",kind="action",label="reset theme",col=2},{id="resettoggles",kind="action",label="reset toggles",col=2},{id="resetbinds",kind="action",label="reset binds",col=2},{id="reset",kind="action",label="reset all",col=2}}
end
local function displaysize()return menustate.minimized and menustate.watermarkw or menustate.w,menustate.minimized and menustate.watermarkh or menustate.h end
local function clampmenu()
    local v=cam.ViewportSize;local w,h=displaysize()
    menustate.x=clamp(menustate.x,0,math.max(0,v.X-w));menustate.y=clamp(menustate.y,0,math.max(0,v.Y-h))
end
local function menupos()
    clampmenu();local displayw,displayh=displaysize()
    menubg.Position=Vector2.new(menustate.x,menustate.y);menubg.Size=Vector2.new(displayw,displayh)
    menutop.Position=Vector2.new(menustate.x,menustate.y);menutop.Size=Vector2.new(displayw,menustate.minimized and menustate.watermarkh or 27)
    menuchrome.border.Position=Vector2.new(menustate.x,menustate.y);menuchrome.border.Size=Vector2.new(displayw,displayh)
    menutitle.Position=Vector2.new(menustate.x+8,menustate.y+9);menuclose.Position=Vector2.new(menustate.x+displayw-12,menustate.y+9)
    local navx,navy,navw,navh=menustate.x+4,menustate.y+29,menustate.w-8,22
    menuside.Position=Vector2.new(navx,navy);menuside.Size=Vector2.new(navw,navh)
    local tabw=navw/#tabnames
    for i=1,#tabnames do local x=math.floor(navx+(i-1)*tabw+0.5);local right=math.floor(navx+i*tabw+0.5);local w=right-x;tabbg[i].Position=Vector2.new(x,navy);tabbg[i].Size=Vector2.new(w,navh);tabtext[i].Position=Vector2.new(x+math.floor(w/2),navy+math.floor((navh-tabtext[i].Size)/2)+1)end
    menuchrome.content.Position=Vector2.new(menustate.x+6,menustate.y+56);menuchrome.content.Size=Vector2.new(menustate.w-12,menustate.h-60)
    if menustate.minimized then menuitems={};itemlayouts={} else menuitems=currentitems();itemlayouts={} end
    local left=menustate.x+11;local ystart=menustate.y+62;local gap=8;local w=(menustate.w-22-gap)/2;local ys={ystart,ystart}
    menuchrome.divider.From=Vector2.new(menustate.x+menustate.w/2,menustate.y+61);menuchrome.divider.To=Vector2.new(menustate.x+menustate.w/2,menustate.y+menustate.h-7)
    for i=1,#menuitems do
        local item=menuitems[i];local col=item.col or 1;local x=left+(col-1)*(w+gap);local y=ys[col];local h=item.kind=="section"and 16 or item.kind=="slider"and 27 or 19;itemlayouts[i]={x=x,y=y,w=w,h=h,item=item};local shown=toggle.itemshown(item)
        itembg[i].Position=Vector2.new(x,y);itembg[i].Size=Vector2.new(w,h-1);itemlabel[i].Position=Vector2.new(x+7,y+(item.kind=="section"and 2 or 4));itemvalue[i].Text=shown;itemvalue[i].Position=Vector2.new(x+w-7-math.floor(#shown*6),y+4)
        if item.kind=="color"then itemmark[i].Position=Vector2.new(x+w-29,y+5);itemmark[i].Size=Vector2.new(23,8)else itemmark[i].Position=Vector2.new(x+w-12,y+5);itemmark[i].Size=Vector2.new(6,6)end
        itemline[i].From=Vector2.new(x+64,y+9);itemline[i].To=Vector2.new(x+w,y+9);itemtrack[i].Position=Vector2.new(x+7,y+19);itemtrack[i].Size=Vector2.new(w-14,3);local ratio=item.kind=="slider"and clamp((item.value-item.min)/(item.max-item.min),0,1)or 0;itemfill[i].Position=Vector2.new(x+7,y+19);itemfill[i].Size=Vector2.new((w-14)*ratio,3);ys[col]=y+h
    end
    local barleft=menustate.x+1;local barwidth=displayw-2;local segw=barwidth/barseg
    for i=1,#menurgb do menurgb[i].From=Vector2.new(barleft+(i-1)*segw,menustate.y+1);menurgb[i].To=Vector2.new(barleft+i*segw,menustate.y+1)end
end
local function dropdownvalues()
    if dropdownkind=="font"then return fontnames
    elseif dropdownkind=="preset"then local values={};for i=1,#themes do values[i]=themes[i].name end;return values
    elseif dropdownkind=="unit"then return {"meters","studs"}
    elseif dropdownkind=="scrapstyle"then return {"numbers","roman","points"}
    elseif dropdownkind=="config"then return configslots end
    return {}
end
local function dropdownupdate(visible)
    local values=dropdownvalues();dropdownlayouts={};local rowid=dropdownkind=="font"and"fontselect"or dropdownkind=="preset"and"presetselect"or dropdownkind=="unit"and"distanceunitselect"or dropdownkind=="scrapstyle"and"scrapstyleselect"or"configselect";local source=nil
    for i=1,#itemlayouts do if itemlayouts[i].item.id==rowid then source=itemlayouts[i];break end end
    if not visible or not source then for i=1,dropdown.max do dropdown.bg[i].Visible=false;dropdown.text[i].Visible=false end;return end
    local w=136;local x=source.x+source.w-w;local y=source.y+source.h;local count=math.min(#values,dropdown.max)
    y=clamp(y,menustate.y+55,menustate.y+menustate.h-count*20-4)
    for i=1,dropdown.max do
        local on=i<=#values;dropdown.bg[i].Visible=on;dropdown.text[i].Visible=on
        if on then local selected=(dropdownkind=="font"and i==fontindex)or(dropdownkind=="preset"and i==themeindex)or(dropdownkind=="unit"and values[i]==toggle.distanceunit)or(dropdownkind=="scrapstyle"and values[i]==toggle.scrapstyle)or(dropdownkind=="config"and i==configslot);dropdown.bg[i].Position=Vector2.new(x,y+(i-1)*20);dropdown.bg[i].Size=Vector2.new(w,19);dropdown.bg[i].Color=color(selected and"select"or"card");dropdown.bg[i].Transparency=1;dropdown.text[i].Position=Vector2.new(x+7,y+(i-1)*20+3);dropdown.text[i].Text=values[i];dropdown.text[i].Color=color(selected and"accent"or"text");dropdownlayouts[i]={x=x,y=y+(i-1)*20,w=w,h=20,index=i,value=values[i]}end
    end
end
local function pickerupdate(visible)
    local cfg=entrycfg(pickerentry);local on=visible and cfg~=nil
    local rgbvisible=on and(type(pickerentry)=="number"or pickerentry=="distance"or pickerentry=="roof"or pickerentry=="hudtimer"or pickerentry=="hudtarget"or pickerentry=="hudscrap"or pickerentry=="hudpower")
    picker.bg.Visible=on;picker.border.Visible=on;picker.title.Visible=on;picker.preview.Visible=on;picker.previewborder.Visible=on;picker.cursor.Visible=on;picker.huecursor.Visible=on;picker.rgbmark.Visible=rgbvisible;picker.rgbtext.Visible=rgbvisible;picker.donebg.Visible=on;picker.donetext.Visible=on
    for i=1,#picker.grid do picker.grid[i].Visible=on end;for i=1,#picker.hue do picker.hue[i].Visible=on end
    pickerlayouts={};if not on then return end
    local pw,ph=232,190;local px=menustate.x+menustate.w+8;local py=clamp(menustate.y+55,2,math.max(2,cam.ViewportSize.Y-ph-2));if px+pw>cam.ViewportSize.X-2 then px=math.max(2,menustate.x-pw-8)end;local c=cfg.labelcolor;local h,s,v=tohsv(c)
    picker.bg.Position=Vector2.new(px,py);picker.bg.Size=Vector2.new(pw,ph);picker.bg.Color=color("bg");picker.bg.Transparency=guiopacity
    picker.border.Position=Vector2.new(px,py);picker.border.Size=Vector2.new(pw,ph);picker.border.Color=color("select");picker.border.Transparency=1
    local pickertitle=toggle.colorname(pickerentry)
    picker.title.Position=Vector2.new(px+9,py+9);picker.title.Text=pickertitle.." color";picker.title.Color=color("text")
    local sx,sy,sw,sh=px+10,py+32,112,94;local cw,ch=sw/picker.cols,sh/picker.rows
    for i=1,#picker.grid do
        local gx=(i-1)%picker.cols;local gy=math.floor((i-1)/picker.cols);local d=picker.grid[i];d.Position=Vector2.new(sx+gx*cw,sy+gy*ch);d.Size=Vector2.new(math.ceil(cw+0.5),math.ceil(ch+0.5));d.Color=Color3.fromHSV(h,gx/(picker.cols-1),1-gy/(picker.rows-1));d.Transparency=1
    end
    picker.cursor.Position=Vector2.new(sx+s*sw-3,sy+(1-v)*sh-3);picker.cursor.Size=Vector2.new(6,6);picker.cursor.Color=Color3.fromHex("#ffffff");picker.cursor.Transparency=1
    local hx,hy,hw,hh=sx,py+137,sw,10;local huew=hw/picker.huesteps
    for i=1,#picker.hue do local d=picker.hue[i];d.Position=Vector2.new(hx+(i-1)*huew,hy);d.Size=Vector2.new(math.ceil(huew+0.5),hh);d.Color=Color3.fromHSV((i-1)/picker.huesteps,1,1);d.Transparency=1 end
    picker.huecursor.Position=Vector2.new(hx+h*hw-2,hy-2);picker.huecursor.Size=Vector2.new(4,hh+4);picker.huecursor.Color=Color3.fromHex("#ffffff");picker.huecursor.Transparency=1
    picker.preview.Position=Vector2.new(px+140,py+34);picker.preview.Size=Vector2.new(72,25);picker.preview.Color=cfg.rgb and rgb(0)or c;picker.preview.Transparency=1
    picker.previewborder.Position=Vector2.new(px+140,py+34);picker.previewborder.Size=Vector2.new(72,25);picker.previewborder.Color=color("select");picker.previewborder.Transparency=1
    picker.rgbmark.Position=Vector2.new(px+142,py+79);picker.rgbmark.Size=Vector2.new(7,7);picker.rgbmark.Color=cfg.rgb and color("accent")or color("select");picker.rgbmark.Transparency=cfg.rgb and 1 or 0.55;picker.rgbtext.Position=Vector2.new(px+156,py+78);picker.rgbtext.Color=color("text")
    picker.donebg.Position=Vector2.new(px+140,py+142);picker.donebg.Size=Vector2.new(72,28);picker.donebg.Color=color("card");picker.donebg.Transparency=guiopacity;picker.donetext.Position=Vector2.new(px+176,py+151);picker.donetext.Color=color("text")
    pickerlayouts.popup={x=px,y=py,w=pw,h=ph};pickerlayouts.square={x=sx,y=sy,w=sw,h=sh};pickerlayouts.hue={x=hx,y=hy,w=hw,h=hh};pickerlayouts.rgb=rgbvisible and{x=px+135,y=py+69,w=80,h=28}or nil;pickerlayouts.done={x=px+140,y=py+142,w=72,h=28}
end
local function menuobjects(visible)
    local expanded=visible and not menustate.minimized
    menubg.Visible=visible;menutop.Visible=visible;menuchrome.border.Visible=visible;menutitle.Visible=visible;menuclose.Visible=visible;menuside.Visible=expanded;menuchrome.content.Visible=expanded;menuchrome.divider.Visible=expanded
    for i=1,#tabnames do tabbg[i].Visible=expanded;tabtext[i].Visible=expanded end
    for i=1,menustate.maxitems do
        local item=menuitems[i];local on=expanded and item~=nil;local sectionon=on and item.kind=="section";local slideron=on and item.kind=="slider";local markon=on and(item.kind=="toggle"or item.kind=="color")
        itembg[i].Visible=on and not sectionon;itemlabel[i].Visible=on;itemvalue[i].Visible=on and not sectionon and item.kind~="toggle"and item.kind~="color";itemmark[i].Visible=markon;itemline[i].Visible=sectionon;itemtrack[i].Visible=slideron;itemfill[i].Visible=slideron
    end
    for i=1,#menurgb do menurgb[i].Visible=visible end
    dropdownupdate(expanded and dropdownkind~=nil and pickerentry==nil);pickerupdate(expanded and pickerentry~=nil)
end
local function menuupdate()
    menupos();local mx,my=mouse.X,mouse.Y
    menubg.Color=color("bg");menutop.Color=color("top");menuside.Color=color("side");menutitle.Color=color("text");menuclose.Color=color("muted");menuchrome.border.Color=color("select");menuchrome.content.Color=color("select");menuchrome.divider.Color=color("select");menubg.Transparency=guiopacity;menutop.Transparency=guiopacity;menuside.Transparency=guiopacity;menuchrome.border.Transparency=guiopacity;menuchrome.content.Transparency=guiopacity;menuchrome.divider.Transparency=0.55*guiopacity;menuclose.Text=menustate.minimized and"+"or"-"
    local navw=menustate.w-8;local tabw=navw/#tabnames
    for i=1,#tabnames do local tx=menustate.x+4+(i-1)*tabw;local hover=inside(mx,my,tx,menustate.y+29,tabw,22);tabbg[i].Color=color(i==menustate.tab and"select"or hover and"hover"or"side");tabbg[i].Transparency=(i==menustate.tab and 0.72 or hover and 0.42 or 0)*guiopacity;tabtext[i].Color=color(i==menustate.tab and"accent"or"text")end
    for i=1,#menuitems do
        local item=menuitems[i];local l=itemlayouts[i];local hover=inside(mx,my,l.x,l.y,l.w,l.h);local shown=toggle.itemshown(item);itembg[i].Color=color(hover and"hover"or"card");itembg[i].Transparency=(hover and 0.32 or 0.08)*guiopacity;itemlabel[i].Text=item.label;itemlabel[i].Color=color(item.kind=="section"and"muted"or"text");itemvalue[i].Text=shown;itemvalue[i].Position=Vector2.new(l.x+l.w-7-math.floor(#shown*6),l.y+4);itemvalue[i].Color=color("accent");itemline[i].Color=color("muted");itemline[i].Transparency=0.35*guiopacity;itemtrack[i].Color=color("select");itemfill[i].Color=color("accent")
        if item.kind=="toggle"then itemmark[i].Color=item.on and color("accent")or color("select");itemmark[i].Transparency=item.on and 1 or 0.55
        elseif item.kind=="color"then local cfg=entrycfg(item.index);itemmark[i].Color=cfg and(cfg.rgb and rgb(0)or cfg.labelcolor)or color("accent");itemmark[i].Transparency=1;itemvalue[i].Text=cfg and cfg.rgb and"RGB"or""end
    end
    menuobjects(toggle.menu)
end
local function showmenu()menuupdate();menuobjects(toggle.menu)end
local powercfg={{valuename="UsingSHDoor",label="house_door_locked"},{valuename="UsingSHLight",label="house_lights_on"},{valuename="UsingTowerLight",label="tower_lights_on"},{valuename="UsingTowerRadar",label="tower_radar_on"}}
local powerlines={}
for i=1,#powercfg do powerlines[i]=newtext(powercfg[i].label,Color3.fromHex("#ffffff"),false,false)end
local hud={timertxt,scraptxt,targettxt,timerlabel,scraplabel,targetlabel,toggle.powerdraw.value,toggle.powerdraw.label}
local function rgbpos()
    local center=anchors();local y=center.Y-108+huddown;local x=center.X-rgbwidth/2;local w=rgbwidth/barseg
    for i=1,barseg do local d=rgbline[i];d.From=Vector2.new(x+(i-1)*w,y);d.To=Vector2.new(x+i*w,y) end
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
    timertxt.Position=Vector2.new(center.X-150,y)
    targettxt.Position=Vector2.new(center.X-50,y)
    scraptxt.Position=Vector2.new(center.X+50,y)
    toggle.powerdraw.value.Position=Vector2.new(center.X+150,y)
    timerlabel.Position=Vector2.new(timertxt.Position.X,y+18)
    targetlabel.Position=Vector2.new(targettxt.Position.X,y+18)
    scraplabel.Position=Vector2.new(scraptxt.Position.X,y+18)
    toggle.powerdraw.label.Position=Vector2.new(toggle.powerdraw.value.Position.X,y+18)
    rgbpos();powerpos()
end
hudpos()
local cratenames={FirstAidKit="medkit",Vitamins="vitamin",UV_Lamp="uv_lamp",StunStick="stun",Vest="vest",Tracker="tracker"}
local cratetext=Color3.fromHex("#ffffff")
local cratebg=Color3.fromHex("#000000")
local cratealpha=0.3
local cratecol,craterow,cratey=55,16,70
local cratepadx,cratepady=28,10
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
    Box={rootname="HitBox",text="supply",color=Color3.fromHex("#e4c3ff"),ringradius=6,ringyoffset=3.2,crate=true,group="crates"},
    SupplyCrate={rootname="HitBox",text="supply",color=Color3.fromHex("#e4c3ff"),ringradius=6,ringyoffset=3.2,crate=true,group="crates"}
}
for _,cfg in pairs(espcfg)do cfg.labelcolor=cfg.color;cfg.rgb=cfg.crate==true;cfg.defaultcolor=cfg.color;cfg.defaultrgb=cfg.rgb end
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
    rec.name=newtext(rec.cfg.text,rec.cfg.labelcolor,true,false);rec.name.Size=espfontsize
    rec.distance=newtext("0m",toggle.distancestyle.labelcolor,true,false);rec.distance.Size=espfontsize
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
    if not toggle.supplyitems then hide(rec.bg);if rec.items then for i=1,#rec.items do hide(rec.items[i])end end;return end
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
            d.Text=cratenames[child.Name]or child.Name;local itemstyle=toggle.cratestyles[child.Name];d.Color=itemstyle and itemstyle.labelcolor or cratetext
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
    local y=world.Y-(rec.cfg.ringyoffset or 0);local radius=rec.cfg.ringradius or 2;local alpha=toggle.distancefade and clamp(1-meters/ringfade,0,1)or 1;local step=2*math.pi/ringseg
    for i=1,ringseg do
        local a=(i-1)*step;local b=i*step
        local sa,ona=WorldToScreen(Vector3.new(world.X+math.cos(a)*radius,y,world.Z+math.sin(a)*radius))
        local sb,onb=WorldToScreen(Vector3.new(world.X+math.cos(b)*radius,y,world.Z+math.sin(b)*radius))
        local line=rec.ring[i]
        if toggle.esp and ona and onb then line.From=sa;line.To=sb;line.Color=rec.cfg.rgb and Color3.fromHex("#bdbdbd")or rec.cfg.color;line.Transparency=alpha;line.Visible=true else line.Visible=false end
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
    local meters=dist(viewer,world);local yoffset=rec.cfg.textyoffset or 0
    makelabels(rec)
    local alpha=toggle.distancefade and clamp(1-meters/espfade,0.15,1)or 1
    local labelvisible=toggle.esp and(not rec.cfg.crate or toggle.supplylabel);rec.name.Text=rec.cfg.text;rec.name.Position=Vector2.new(screen.X,screen.Y-espfontsize-2+yoffset);rec.name.Transparency=alpha;rec.name.Color=rec.cfg.rgb and rgb(0)or rec.cfg.labelcolor;rec.name.Size=espfontsize;rec.name.Visible=labelvisible
    local shown=toggle.distanceunit=="studs"and meters/stud2m or meters;local suffix=toggle.distanceunit=="studs"and"s"or"m"
    rec.distance.Position=Vector2.new(screen.X,screen.Y+2+yoffset);rec.distance.Text=tostring(math.floor(shown))..suffix;rec.distance.Color=toggle.distancestyle.rgb and rgb(0)or toggle.distancestyle.labelcolor;rec.distance.Transparency=toggle.distancefade and alpha*0.85 or 1;rec.distance.Size=espfontsize;rec.distance.Visible=labelvisible and toggle.distance and meters>=20
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
    if not toggle.esp or not toggle.roof or not rakeroof or not rakehp then rooflabel.Visible=false;roofhp.Visible=false;return end
    local part=findclass(rakeroof,"BasePart")
    if not part then rooflabel.Visible=false;roofhp.Visible=false;return end
    local screen,on=WorldToScreen(part.Position)
    if not on then rooflabel.Visible=false;roofhp.Visible=false;return end
    local roofcolor=roofstyle.rgb and rgb(0)or roofstyle.labelcolor
    roofhp.Text=tostring(rakehp.Value).."/30";roofhp.Color=roofcolor;rooflabel.Color=roofcolor;rooflabel.Size=espfontsize;roofhp.Size=espfontsize;rooflabel.Position=Vector2.new(screen.X,screen.Y-espfontsize-2);roofhp.Position=Vector2.new(screen.X,screen.Y+2);rooflabel.Visible=true;roofhp.Visible=true
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
    if not toggle.powerlevel or not toggle.powerlevel.Parent then toggle.powerlevel=powervals:FindFirstChild("PowerLevel")end
    local level=toggle.powerlevel
    local ok,minimum,maximum,value=pcall(function()
        local address=level and level.Address
        if type(address)~="number"or address<=0 then return nil end
        return memory_read("uintptr_t",address+0xC0),memory_read("uintptr_t",address+0xB8),memory_read("uintptr_t",address+0xC8)
    end)
    if ok and type(minimum)=="number"and type(maximum)=="number"and type(value)=="number"and maximum>minimum and value>=minimum and value<=maximum then
        toggle.powerdraw.value.Text=string.format("%.1f%%",(value-minimum)/(maximum-minimum)*100)
    else toggle.powerdraw.value.Text="?"end
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
    local phase=(tick()*rgbspeed)%1
    timerlabel.Color=toggle.hudstyles.timer.rgb and rgb(0)or toggle.hudstyles.timer.labelcolor;targetlabel.Color=toggle.hudstyles.target.rgb and rgb(0)or toggle.hudstyles.target.labelcolor;scraplabel.Color=toggle.hudstyles.scrap.rgb and rgb(0)or toggle.hudstyles.scrap.labelcolor;toggle.powerdraw.label.Color=toggle.hudstyles.power.rgb and rgb(0)or toggle.hudstyles.power.labelcolor
    if toggle.hud then for i=1,#rgbline do local d=rgbline[i];d.Color=toggle.barrgb and Color3.fromHSV((phase+(i-1)/barseg)%1,0.68,1)or color("accent");d.Visible=true end end
    if toggle.menu then for i=1,#menurgb do local d=menurgb[i];d.Color=toggle.barrgb and Color3.fromHSV((phase+(i-1)/barseg)%1,0.68,1)or color("accent");d.Visible=true end end
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
local function setesp(value,quiet)
    toggle.esp=value==true
    if not toggle.esp then for i=1,#tracked do hiderec(tracked[i])end;rooflabel.Visible=false;roofhp.Visible=false end
    menuupdate();if not quiet then bindlog(toggle.esp and "enabled esp"or"disabled esp")end
end
local function sethud(value,quiet)
    toggle.hud=value==true;showhud();menuupdate();if not quiet then bindlog(toggle.hud and "enabled hud"or"disabled hud")end
end
local function setbarrgb(value,quiet)
    toggle.barrgb=value==true;menuupdate();if not quiet then bindlog(toggle.barrgb and"enabled rainbow accent"or"disabled rainbow accent")end
end
local function setdistance(value,quiet)
    toggle.distance=value==true
    if not toggle.distance then for i=1,#tracked do hide(tracked[i].distance)end end
    menuupdate();if not quiet then bindlog(toggle.distance and "enabled distance label"or"disabled distance label")end
end
local function setdistancefade(value,quiet)
    toggle.distancefade=value==true;menuupdate();if not quiet then bindlog(toggle.distancefade and "enabled distance opacity"or"disabled distance opacity")end
end
local function setgroup(id,value,quiet)
    espgroups[id]=value==true
    if not espgroups[id]then for i=1,#tracked do local rec=tracked[i];if rec.cfg.group==id then hiderec(rec)end end end
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
toggle.setunit=function(value,quiet)
    toggle.distanceunit=value=="studs"and"studs"or"meters";menuupdate();if not quiet then bindlog("distance unit set to "..toggle.distanceunit)end
end
toggle.setscrapstyle=function(value,quiet)
    toggle.scrapstyle=value=="roman"and"roman"or value=="points"and"points"or"numbers";local suffixes=toggle.scrapstyle=="roman"and{"I","II","III","IV","V"}or toggle.scrapstyle=="points"and{"12","15","19","23","27"}or{"1","2","3","4","5"}
    for i=1,5 do local cfg=espcfg["Scrap"..tostring(i)];if cfg then cfg.text="scrap "..suffixes[i]end end;for i=1,#tracked do local rec=tracked[i];if rec.cfgname and string.match(rec.cfgname,"^Scrap%d$")and rec.name then rec.name.Text=rec.cfg.text end end
    menuupdate();if not quiet then bindlog("scrap display set to "..toggle.scrapstyle)end
end
toggle.setsupplylabel=function(value,quiet)
    toggle.supplylabel=value==true;if not toggle.supplylabel then for i=1,#tracked do local rec=tracked[i];if rec.cfg.crate then hide(rec.name);hide(rec.distance)end end end;menuupdate();if not quiet then bindlog(toggle.supplylabel and"enabled supply label"or"disabled supply label")end
end
toggle.setsupplyitems=function(value,quiet)
    toggle.supplyitems=value==true;if not toggle.supplyitems then for i=1,#tracked do local rec=tracked[i];if rec.cfg.crate then hide(rec.bg);if rec.items then for j=1,#rec.items do hide(rec.items[j])end end end end end;menuupdate();if not quiet then bindlog(toggle.supplyitems and"enabled item viewer"or"disabled item viewer")end
end
toggle.setfade=function(value,quiet)
    espfade=math.floor(clamp(tonumber(value)or espfade,50,750)+0.5);menuupdate();if not quiet then bindlog("fade radius updated")end
end
local function setfontindex(index,quiet)
    fontindex=((math.floor(index)-1)%#fontvalues)+1;font=fontvalues[fontindex]
    local texts={timertxt,scraptxt,targettxt,timerlabel,scraplabel,targetlabel,toggle.powerdraw.value,toggle.powerdraw.label,powerlabel,rooflabel,roofhp}
    for i=1,#texts do texts[i].Font=font end
    for i=1,#powerlines do powerlines[i].Font=font end
    for i=1,#tracked do local rec=tracked[i];if rec.name then rec.name.Font=font end;if rec.distance then rec.distance.Font=font end;if rec.items then for j=1,#rec.items do rec.items[j].Font=font end end end
    menuupdate();if not quiet then bindlog("font set to "..fontnames[fontindex])end
end
local function setthemeindex(index,quiet)
    themeindex=((math.floor(index)-1)%#themes)+1;local selected=themes[themeindex];themes.accentstyle.labelcolor=selected.accent;themes.accentstyle.rgb=false;toggle.themestyles.background.labelcolor=selected.bg;toggle.themestyles.topbar.labelcolor=selected.top;toggle.themestyles.surface.labelcolor=selected.card;toggle.themestyles.border.labelcolor=selected.select;toggle.themestyles.text.labelcolor=selected.text;menuupdate();if not quiet then bindlog("preset set to "..selected.name)end
end
local function setfontsize(value,quiet)
    espfontsize=math.floor(clamp(tonumber(value)or espfontsize,12,18)+0.5)
    rooflabel.Size=espfontsize;roofhp.Size=espfontsize;for i=1,#tracked do if tracked[i].name then tracked[i].name.Size=espfontsize end;if tracked[i].distance then tracked[i].distance.Size=espfontsize end end
    menuupdate();if not quiet then bindlog("ESP label size set to "..tostring(espfontsize))end
end
local function setguiopacity(value,quiet)
    guiopacity=clamp(tonumber(value)or guiopacity,0.2,1);menuupdate();if not quiet then bindlog("GUI opacity set to "..tostring(math.floor(guiopacity*100+0.5)).."%")end
end
local function setlabelcolor(index,value)
    if type(index)=="string"then local cfg=entrycfg(index);if cfg then cfg.labelcolor=value end;menuupdate();return end
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
local function setringsegments(value,quiet)
    local nextvalue=math.floor(clamp(tonumber(value)or ringseg,8,128)+0.5)
    if nextvalue~=ringseg then
        ringseg=nextvalue
        for i=1,#tracked do local rec=tracked[i];if rec.ring then for j=1,#rec.ring do remove(rec.ring[j])end;rec.ring=nil end end
    end
    menuupdate();if not quiet then bindlog("ring segments set to "..tostring(ringseg))end
end
local function setbind(id,code)
    if not keynames[code]then return end
    for i=1,#bindorder do local other=bindorder[i];if other~=id and keybinds[other]==code then capture=nil;menuupdate();bindlog("key already in use");return end end
    keybinds[id]=code;capture=nil;menuupdate();bindlog(string.lower(bindlabels[id]).." bound to "..keynames[code])
end
toggle.cleanconfig=function(value)
    local cleaned=string.lower(tostring(value or""));cleaned=string.gsub(cleaned,"[^%w _%-]","");cleaned=string.gsub(cleaned,"^%s+","");cleaned=string.gsub(cleaned,"%s+$","");cleaned=string.gsub(cleaned,"%s+"," ");if cleaned==""then cleaned="default"end;return string.sub(cleaned,1,18)
end
toggle.refreshconfigs=function(selected)
    pcall(function()makefolder("therakesaint")end);local names={"default"};local seen={default=true};local ok,files=pcall(function()return listfiles("therakesaint")end)
    if ok and type(files)=="table"then for i=1,#files do local name=string.match(files[i],"([^/\\]+)%.json$");if name and not seen[name]and #names<dropdown.max then seen[name]=true;names[#names+1]=name end end end
    table.sort(names);configslots=names;local wanted=toggle.cleanconfig(selected or configname);configslot=0;for i=1,#configslots do if configslots[i]==wanted then configslot=i;break end end;configname=wanted
end
toggle.finishconfiginput=function(cancel)
    configname=cancel and(toggle.configbackup or"default")or toggle.cleanconfig(configname);configcapture=false;configslot=0;for i=1,#configslots do if configslots[i]==configname then configslot=i;break end end;menuupdate()
end
local function configpath()return "therakesaint/"..toggle.cleanconfig(configname)..".json" end
local function configdata()
    local colors={};local accent=themes.accentstyle.labelcolor;local special={};local themecolors={};local crateitemcolors={}
    for i=1,#colorentries do local cfg=entrycfg(i);local c=cfg.labelcolor;colors[i]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for _,id in ipairs({"distance","roof","hudtimer","hudtarget","hudscrap","hudpower"})do local cfg=entrycfg(id);local c=cfg.labelcolor;special[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for _,id in ipairs({"themebg","themetop","themesurface","themeborder","themetext"})do local cfg=entrycfg(id);local c=cfg.labelcolor;themecolors[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B)}end
    for id,cfg in pairs(toggle.cratestyles)do local c=cfg.labelcolor;crateitemcolors[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B)}end
    return {font=fontindex,font_size=espfontsize,preset=themeindex,accent={r=channel(accent.R),g=channel(accent.G),b=channel(accent.B)},theme_colors=themecolors,gui_opacity=guiopacity,ring_segments=ringseg,fade_radius=espfade,esp=toggle.esp,hud=toggle.hud,roof_hp=toggle.roof,bar_rgb=toggle.barrgb,distance=toggle.distance,distance_unit=toggle.distanceunit,distance_opacity=toggle.distancefade,scrap_style=toggle.scrapstyle,supply_label=toggle.supplylabel,supply_items=toggle.supplyitems,esp_groups=espgroups,esp_items=espgroups.items,colors=colors,special_colors=special,crate_item_colors=crateitemcolors,binds=keybinds,menu={x=menustate.x,y=menustate.y,minimized=menustate.minimized}}
end
local function saveconfig()
    configname=toggle.cleanconfig(configname);local ok=pcall(function()makefolder("therakesaint");writefile(configpath(),http:JSONEncode(configdata()))end);if ok then toggle.refreshconfigs(configname);menuupdate()end
    bindlog(ok and"saved "..configname or"failed to save config")
end
local function loadconfig(quiet)
    if not isfile(configpath())then if not quiet then bindlog("no saved config")end;return false end
    local ok,data=pcall(function()return http:JSONDecode(readfile(configpath()))end)
    if not ok or type(data)~="table"then if not quiet then bindlog("failed to load config")end;return false end
    if type(data.font)=="number"then setfontindex(clamp(data.font,1,#fontvalues),true)end
    if type(data.font_size)=="number"then setfontsize(data.font_size,true)end
    local savedpreset=data.preset or data.theme;if type(savedpreset)=="number"then setthemeindex(clamp(savedpreset,1,#themes),true)end
    if type(data.accent)=="table"and type(data.accent.r)=="number"and type(data.accent.g)=="number"and type(data.accent.b)=="number"then setlabelcolor("accent",Color3.fromRGB(clamp(data.accent.r,0,255),clamp(data.accent.g,0,255),clamp(data.accent.b,0,255)))end
    if type(data.theme_colors)=="table"then for _,id in ipairs({"themebg","themetop","themesurface","themeborder","themetext"})do local saved=data.theme_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)))end end end
    if type(data.gui_opacity)=="number"then setguiopacity(data.gui_opacity,true)end
    if type(data.ring_segments)=="number"then setringsegments(data.ring_segments,true)end
    if type(data.fade_radius)=="number"then toggle.setfade(data.fade_radius,true)end
    if type(data.esp)=="boolean"then setesp(data.esp,true)end
    if type(data.hud)=="boolean"then sethud(data.hud,true)end
    if type(data.roof_hp)=="boolean"then toggle.setroof(data.roof_hp,true)end
    if type(data.bar_rgb)=="boolean"then setbarrgb(data.bar_rgb,true)end
    local saveddistance=data.distance;if type(saveddistance)~="boolean"then saveddistance=data.meters end;if type(saveddistance)=="boolean"then setdistance(saveddistance,true)end
    if data.distance_unit=="meters"or data.distance_unit=="studs"then toggle.setunit(data.distance_unit,true)end
    if type(data.distance_opacity)=="boolean"then setdistancefade(data.distance_opacity,true)end
    if data.scrap_style=="numbers"or data.scrap_style=="roman"or data.scrap_style=="points"then toggle.setscrapstyle(data.scrap_style,true)end
    if type(data.supply_label)=="boolean"then toggle.setsupplylabel(data.supply_label,true)end;if type(data.supply_items)=="boolean"then toggle.setsupplyitems(data.supply_items,true)end
    espgroups.locations=true;espgroups.scraps=true;espgroups.crates=true;if type(data.esp_groups)=="table"then for _,id in ipairs({"traps","flares"})do if type(data.esp_groups[id])=="boolean"then setgroup(id,data.esp_groups[id],true)end end end
    if type(data.esp_items)=="table"then for id in pairs(espgroups.items)do if type(data.esp_items[id])=="boolean"then toggle.setitem(id,data.esp_items[id],true)end end end
    if type(data.colors)=="table"then
        for i=1,#colorentries do local saved=data.colors[i];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(i,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb(i,saved.rgb,true)end end end
    end
    if type(data.special_colors)=="table"then for _,id in ipairs({"distance","roof","hudtimer","hudtarget","hudscrap","hudpower"})do local saved=data.special_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb(id,saved.rgb,true)end end end end
    if type(data.crate_item_colors)=="table"then for id in pairs(toggle.cratestyles)do local saved=data.crate_item_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor("crate_"..id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)))end end end
    if type(data.binds)=="table"then
        local used,nextbinds,valid={},{},true
        for i=1,#bindorder do local id=bindorder[i];local code=tonumber(data.binds[id])or keybinds[id];if not keynames[code]or used[code]then valid=false else used[code]=true;nextbinds[id]=code end end
        if valid then keybinds=nextbinds end
    end
    if type(data.menu)=="table"then if type(data.menu.x)=="number"then menustate.x=data.menu.x end;if type(data.menu.y)=="number"then menustate.y=data.menu.y end;if type(data.menu.minimized)=="boolean"then menustate.minimized=data.menu.minimized end end
    menupos();menuupdate();if not quiet then bindlog("loaded config")end;return true
end
toggle.resetcolors=function(quiet)
    for _,cfg in pairs(espcfg)do cfg.color=cfg.defaultcolor;cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    roofstyle.labelcolor=roofstyle.defaultcolor;roofstyle.rgb=roofstyle.defaultrgb;toggle.distancestyle.labelcolor=toggle.distancestyle.defaultcolor;toggle.distancestyle.rgb=toggle.distancestyle.defaultrgb
    for _,cfg in pairs(toggle.hudstyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    for _,cfg in pairs(toggle.cratestyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=false end
    themes.accentstyle.labelcolor=themes[themeindex].accent;themes.accentstyle.rgb=false;menuupdate();if not quiet then bindlog("reset colors")end
end
toggle.resettheme=function(quiet)
    setthemeindex(7,true);setguiopacity(0.95,true);menuupdate();if not quiet then bindlog("reset theme")end
end
toggle.resettoggles=function(quiet)
    setesp(true,true);sethud(true,true);toggle.setroof(true,true);setbarrgb(true,true);setdistance(true,true);setdistancefade(true,true);toggle.setunit("meters",true);toggle.setfade(350,true);toggle.setscrapstyle("numbers",true);toggle.setsupplylabel(true,true);toggle.setsupplyitems(true,true)
    for _,id in ipairs({"locations","scraps","traps","flares","crates"})do setgroup(id,true,true)end;for id in pairs(espgroups.items)do toggle.setitem(id,true,true)end
    menuupdate();if not quiet then bindlog("reset toggles")end
end
toggle.resetbinds=function(quiet)
    keybinds={menu=defaultbinds.menu,esp=defaultbinds.esp,hud=defaultbinds.hud,scrap=defaultbinds.scrap,flare=defaultbinds.flare};capture=nil;menuupdate();if not quiet then bindlog("reset binds")end
end
local function resetsettings()
    toggle.resettheme(true);toggle.resetcolors(true);toggle.resettoggles(true);toggle.resetbinds(true);setfontindex(1,true);setfontsize(13,true);setringsegments(64,true)
    local v=cam.ViewportSize;menustate.x=24;menustate.y=math.floor((v.Y-menustate.h)/2);menustate.minimized=false;capture=nil;pickerentry=nil;dropdownkind=nil;configcapture=false
    menupos();menuupdate();bindlog("reset all settings")
end
local function runaction(id)
    if id=="menu"then toggle.menu=not toggle.menu;capture=nil;pickerentry=nil;dropdownkind=nil;configcapture=false;showmenu();bindlog(toggle.menu and "opened menu"or"closed menu")
    elseif id=="esp"then setesp(not toggle.esp)
    elseif id=="hud"then sethud(not toggle.hud)
    elseif id=="scrap"then local ok=tpscrap();bindlog(ok and "teleported to scrap"or"scrap not found")
    elseif id=="flare"then local ok=tpflare();bindlog(ok and "teleported to flare"or"flare not found")end
end
local inputstate={dragging=false,sliding=nil,mouseheld=false,dragx=0,dragy=0}
local function pickerapply(mx,my)
    local cfg=entrycfg(pickerentry);if not cfg then return nil end;local h,s,v=tohsv(cfg.labelcolor);local square=pickerlayouts.square;local hue=pickerlayouts.hue
    if square and inside(mx,my,square.x,square.y,square.w,square.h)then s=clamp((mx-square.x)/square.w,0,1);v=1-clamp((my-square.y)/square.h,0,1);setlabelcolor(pickerentry,Color3.fromHSV(h,s,v));return"pickersquare"end
    if hue and inside(mx,my,hue.x,hue.y-3,hue.w,hue.h+6)then h=clamp((mx-hue.x)/hue.w,0,1);setlabelcolor(pickerentry,Color3.fromHSV(h,s,v));return"pickerhue"end
    return nil
end
local function sliderapply(mx,my,quiet)
    if inputstate.sliding=="pickersquare"or inputstate.sliding=="pickerhue"then pickerapply(mx,my);return end
    local layout=nil
    for i=1,#itemlayouts do if itemlayouts[i].item.id==inputstate.sliding then layout=itemlayouts[i];break end end
    if not layout then return end
    local item=layout.item;local ratio=clamp((mx-(layout.x+7))/(layout.w-14),0,1);local value=item.min+ratio*(item.max-item.min)
    if inputstate.sliding=="ring"then setringsegments(value,quiet)
    elseif inputstate.sliding=="fontsize"then setfontsize(value,quiet)
    elseif inputstate.sliding=="espfade"then toggle.setfade(value,quiet)
    elseif inputstate.sliding=="opacity"then setguiopacity(value,quiet)end
end
local function clickmenu(mx,my)
    if pickerentry then
        if pickerlayouts.done and inside(mx,my,pickerlayouts.done.x,pickerlayouts.done.y,pickerlayouts.done.w,pickerlayouts.done.h)then pickerentry=nil;inputstate.sliding=nil;menuupdate();return end
        if pickerlayouts.rgb and inside(mx,my,pickerlayouts.rgb.x,pickerlayouts.rgb.y,pickerlayouts.rgb.w,pickerlayouts.rgb.h)then local cfg=entrycfg(pickerentry);setlabelrgb(pickerentry,not cfg.rgb);return end
        local pickermode=pickerapply(mx,my);if pickermode then inputstate.sliding=pickermode;return end
        if not pickerlayouts.popup or not inside(mx,my,pickerlayouts.popup.x,pickerlayouts.popup.y,pickerlayouts.popup.w,pickerlayouts.popup.h)then pickerentry=nil;inputstate.sliding=nil;menuupdate()end
        return
    end
    if dropdownkind then
        for i=1,#dropdownlayouts do
            local layout=dropdownlayouts[i]
            if inside(mx,my,layout.x,layout.y,layout.w,layout.h)then
                local kind=dropdownkind;dropdownkind=nil
                if kind=="font"then setfontindex(layout.index)
                elseif kind=="preset"then setthemeindex(layout.index)
                elseif kind=="unit"then toggle.setunit(layout.value)
                elseif kind=="scrapstyle"then toggle.setscrapstyle(layout.value)
                elseif kind=="config"then configslot=layout.index;configname=layout.value;configcapture=false;menuupdate()end
                return
            end
        end
        dropdownkind=nil;menuupdate();return
    end
    local displayw=displaysize()
    if inside(mx,my,menustate.x+displayw-28,menustate.y,28,27)then if configcapture then toggle.finishconfiginput(false)end;menustate.minimized=not menustate.minimized;capture=nil;pickerentry=nil;dropdownkind=nil;menupos();menuupdate();return end
    if menustate.minimized then return end
    local navw=menustate.w-8;local tabw=navw/#tabnames
    for i=1,#tabnames do
        if inside(mx,my,menustate.x+4+(i-1)*tabw,menustate.y+29,tabw,22)then if configcapture then toggle.finishconfiginput(false)end;menustate.tab=i;capture=nil;pickerentry=nil;dropdownkind=nil;menuupdate();return end
    end
    for i=1,#itemlayouts do
        local layout=itemlayouts[i];local item=layout.item
        if item.kind~="section"and inside(mx,my,layout.x,layout.y,layout.w,layout.h)then
            if configcapture and item.id~="configname"then toggle.finishconfiginput(false)end
            if item.kind=="toggle"then
                if item.itemkey then toggle.setitem(item.itemkey,not espgroups.items[item.itemkey])elseif item.id=="esp"then setesp(not toggle.esp)elseif item.id=="hud"then sethud(not toggle.hud)elseif item.id=="roof"then toggle.setroof(not toggle.roof)elseif item.id=="barrgb"then setbarrgb(not toggle.barrgb)elseif item.id=="distance"then setdistance(not toggle.distance)elseif item.id=="distancefade"then setdistancefade(not toggle.distancefade)elseif item.id=="supplylabel"then toggle.setsupplylabel(not toggle.supplylabel)elseif item.id=="supplyitems"then toggle.setsupplyitems(not toggle.supplyitems)else setgroup(item.id,not espgroups[item.id])end
            elseif item.kind=="action"then
                if item.id=="scrap"or item.id=="flare"then runaction(item.id)elseif item.id=="save"then saveconfig()elseif item.id=="load"then loadconfig(false)elseif item.id=="resetcolors"then toggle.resetcolors(false)elseif item.id=="resettheme"then toggle.resettheme(false)elseif item.id=="resettoggles"then toggle.resettoggles(false)elseif item.id=="resetbinds"then toggle.resetbinds(false)elseif item.id=="reset"then resetsettings()end
            elseif item.kind=="dropdown"then
                dropdownkind=item.id=="fontselect"and"font"or item.id=="presetselect"and"preset"or item.id=="distanceunitselect"and"unit"or item.id=="scrapstyleselect"and"scrapstyle"or"config";capture=nil;menuupdate()
            elseif item.kind=="slider"then inputstate.sliding=item.id;sliderapply(mx,my,true)
            elseif item.kind=="bind"then capture=item.bind;configcapture=false;menuupdate()
            elseif item.kind=="text"then toggle.configbackup=configname;configcapture=true;capture=nil;dropdownkind=nil;menuupdate()
            elseif item.kind=="color"then pickerentry=item.index;dropdownkind=nil;menuupdate()end
            return
        end
    end
    if configcapture then toggle.finishconfiginput(false)end
end
local function mouseinput()
    local down=ismouse1pressed();local pressed=down and not inputstate.mouseheld;local mx,my=mouse.X,mouse.Y
    if toggle.menu then
        if pressed then
            local displayw=displaysize()
            if pickerentry then clickmenu(mx,my)
            elseif inside(mx,my,menustate.x,menustate.y,displayw,27)and not inside(mx,my,menustate.x+displayw-28,menustate.y,28,27)then if configcapture then toggle.finishconfiginput(false)end;inputstate.dragging=true;inputstate.dragx=mx-menustate.x;inputstate.dragy=my-menustate.y
            else clickmenu(mx,my)end
        end
        if down and inputstate.dragging then menustate.x=mx-inputstate.dragx;menustate.y=my-inputstate.dragy;menupos()end
        if down and inputstate.sliding then sliderapply(mx,my,true)end
        menuupdate()
    end
    if not down then
        if inputstate.sliding=="ring"then bindlog("ring segments set to "..tostring(ringseg))elseif inputstate.sliding=="fontsize"then bindlog("ESP label size set to "..tostring(espfontsize))elseif inputstate.sliding=="espfade"then bindlog("fade radius updated")elseif inputstate.sliding=="opacity"then bindlog("GUI opacity set to "..tostring(math.floor(guiopacity*100+0.5)).."%")elseif(inputstate.sliding=="pickersquare"or inputstate.sliding=="pickerhue")and pickerentry then bindlog("updated "..toggle.colorname(pickerentry).." color")end
        inputstate.dragging=false;inputstate.sliding=nil
    end
    inputstate.mouseheld=down
end
local function keys()
    local edges={}
    if configcapture and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then toggle.finishconfiginput(true);return elseif edges[0x0D]then toggle.finishconfiginput(false);return elseif edges[0x08]then configname=string.sub(configname,1,math.max(0,#configname-1));menuupdate();return end
        local added=nil;for code=0x30,0x39 do if edges[code]then added=string.char(code);break end end;if not added then for code=0x41,0x5A do if edges[code]then added=string.lower(string.char(code));break end end end;if not added and edges[0x20]then added=" "elseif not added and edges[0xBD]then added="-"end
        if added and #configname<18 then configname=configname..added;menuupdate()end;return
    end
    if capture and toggle.menu then
        for i=1,#keyoptions do local code=keyoptions[i].code;local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end
        if edges[0x1B]then capture=nil;menuupdate();bindlog("cancelled keybind change");return end
        for i=1,#keyoptions do local code=keyoptions[i].code;if edges[code]then setbind(capture,code);return end end
        return
    end
    for i=1,#bindorder do local code=keybinds[bindorder[i]];if edges[code]==nil then local down=iskeypressed(code);edges[code]=down and not keywas[code];keywas[code]=down end end
    for i=1,#bindorder do local id=bindorder[i];if edges[keybinds[id]]then runaction(id)end end
end
local function drawesp()
    keys();mouseinput()
    if not toggle.esp then return end
    local viewer=viewpos();local i=#tracked
    while i>=1 do local rec=tracked[i];local ok,alive=pcall(function()return drawrec(rec,viewer)end);if not ok or not alive then untrack(i)end;i=i-1 end
    drawroof()
end
local lastx,lasty=cam.ViewportSize.X,cam.ViewportSize.Y
spawn(function()
    while true do
        local v=cam.ViewportSize
        if v.X~=lastx or v.Y~=lasty then lastx,lasty=v.X,v.Y;hudpos();menupos()end
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
toggle.refreshconfigs("default")
if not loadconfig(true)then pcall(function()makefolder("therakesaint");writefile(configpath(),http:JSONEncode(configdata()))end);toggle.refreshconfigs(configname)end
showhud();showmenu()
print("view thread for keybinds, version "..version)
