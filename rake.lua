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
local scanrate,hudrate,statusrate=1,0.1,0.25
local ringfade,ringseg,cratedist,maxtrack=40,100,30,256
local toggle={esp=true,hud=true,distance=false,distancefade=false,menu=true,watermark=true,watermarkhint=true,barrgb=true,roof=false,distanceunit="meters",distanceposition="below",poweractivity=true,scrapstyle="none",supplylabel=true,supplyitems=true,ringenabled=true,ringshape="circle",ringsize=1,ringspin=false,ringspinspeed=1,rgbdirection="left",powerformat="percent",powerdecimal=true,timerformat="clock",timerwarning=15,timerwarningenabled=false,hudfontindex=1,teleportcooldown=false,cooldownseconds=30,cooldownuntil=0,cooldownremaining=0,teleporthistory={},ppms=false,ppmsstyle="voltmeter",ppmssquares=5,rakename=true,rakehealth=true,rakenamevalue="rake",rakenamey=0,rakehealthy=0,rakehealthformat="value",rakebarwidth=70,rakenamecapture=false,hudelements={timer=true,target=false,scrap=true,power=true}}
toggle.hudbar=true;toggle.hudlabels=true;toggle.distanceminimum=false;toggle.distancemin=20;toggle.healthbased=false;toggle.ppmslevel=0;toggle.poweravailable=true;toggle.ppmspowerblocked=false
 toggle.playerdisplayname=lp and lp.Name or"player"
pcall(function()
    local address=lp and lp.Address;local value=type(address)=="number"and address>0 and memory_read("string",address+0x138)or nil
    if type(value)=="string"and #value>0 and #value<=64 and not string.find(value,"[%c]")then toggle.hudbar=true;toggle.hudlabels=true;toggle.distanceminimum=false;toggle.distancemin=20;toggle.healthbased=false
 toggle.playerdisplayname=value end
end)
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
local guiopacity=0.95
local espcfg={}
local roofstyle={labelcolor=Color3.fromHex("#f5d3ff"),defaultcolor=Color3.fromHex("#f5d3ff"),rgb=false,defaultrgb=false}
toggle.rakestyle={labelcolor=Color3.fromHex("#ff5252"),defaultcolor=Color3.fromHex("#ff5252"),rgb=false,defaultrgb=false}
toggle.rakehealthstyle={labelcolor=Color3.fromHex("#ffffff"),defaultcolor=Color3.fromHex("#ffffff"),rgb=false,defaultrgb=false}
toggle.rakebarstyle={labelcolor=Color3.fromHex("#ff5252"),defaultcolor=Color3.fromHex("#ff5252"),rgb=false,defaultrgb=false}
local colorentries={
    {name="flare",cfgs={"FlareGunPickUp"}},{name="scrap 1",cfgs={"Scrap1"}},{name="scrap 2",cfgs={"Scrap2"}},{name="scrap 3",cfgs={"Scrap3"}},{name="scrap 4",cfgs={"Scrap4"}},{name="scrap 5",cfgs={"Scrap5"}},{name="trap",cfgs={"RakeTrapModel"}},{name="supply",cfgs={"Box","SupplyCrate"}},
    {name="base",cfgs={"BaseCampMSG"}},{name="house",cfgs={"SafehouseMSG"}},{name="station",cfgs={"StationMSG"}},{name="shop",cfgs={"ShopMSG"}},{name="tower",cfgs={"ObservationTowerMSG"}}
}
local defaultbinds={menu=0x43,esp=0x70,hud=0x71,scrap=0x72,flare=0x73}
local keybinds={menu=defaultbinds.menu,esp=defaultbinds.esp,hud=defaultbinds.hud,scrap=defaultbinds.scrap,flare=defaultbinds.flare}
local bindorder={"menu","esp","hud","scrap","flare"}
local bindlabels={menu="menu",esp="esp toggle",hud="hud toggle",scrap="tp to scrap",flare="tp to flare"}
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
toggle.ppmsobject=powervals:FindFirstChild("PPMS")
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
local function rgb(offset)return Color3.fromHSV((((tick()*rgbspeed)*(toggle.rgbdirection=="left"and 1 or-1))+(offset or 0))%1,0.68,1)end
local rgbline={}
for i=1,barseg do rgbline[i]=newline(Color3.fromHSV((i-1)/barseg*rgbspread,0.68,1));rgbline[i].Thickness=2 end
local themes={
    {name="amethyst",bg="#1d1b29",top="#17151f",side="#121019",card="#292638",hover="#353148",select="#4a435f",text="#e8e2f4",muted="#89809b",accent="#c39bea"},
    {name="blood moon",bg="#251d24",top="#1c161c",side="#171217",card="#322630",hover="#41303c",select="#58404f",text="#f1e8ee",muted="#967789",accent="#db7093"},
    {name="midnight",bg="#171b28",top="#111522",side="#10131d",card="#22283a",hover="#2b3349",select="#3c4762",text="#d7e0f2",muted="#687794",accent="#769cf1"},
    {name="ember",bg="#25221f",top="#1b1917",side="#171513",card="#302b26",hover="#3d352e",select="#56483b",text="#eee5db",muted="#988675",accent="#e6a45e"},
    {name="gamesense",bg="#262626",top="#363636",side="#262626",card="#262626",hover="#303030",select="#111111",text="#ffffff",muted="#555555",accent="#99C30B"},
    {name="glacier",bg="#20262d",top="#181e24",side="#171c22",card="#2b333d",hover="#36414c",select="#4a5866",text="#e4edf2",muted="#7d8d99",accent="#75c5de"},
    {name="deep sea",bg="#102326",top="#0b1b1e",side="#091719",card="#173034",hover="#1e3d42",select="#2c555b",text="#d7eeec",muted="#698d8d",accent="#49c6b7"},
    {name="graphite",bg="#202226",top="#181a1d",side="#151619",card="#2b2e33",hover="#35393f",select="#484d55",text="#e1e3e7",muted="#7d828b",accent="#79a9dc"},
    {name="rose noir",bg="#211b22",top="#19141a",side="#151116",card="#2d242f",hover="#392d3b",select="#503e52",text="#eee5ed",muted="#90788f",accent="#d58bbd"},
    {name="terminal",bg="#151a17",top="#101411",side="#0d110e",card="#202722",hover="#29322c",select="#3b493f",text="#d9e6dc",muted="#718078",accent="#72d68c"},
    {name="ultraviolet",bg="#1c1926",top="#15121d",side="#111016",card="#272235",hover="#322b43",select="#493d5f",text="#e8e2f0",muted="#877b94",accent="#9f7aea"}
}
for i=1,#themes do for _,key in ipairs({"bg","top","side","card","hover","select","text","muted","accent"})do themes[i][key]=Color3.fromHex(themes[i][key])end end
themes.borderblack=Color3.fromHex("#000000")
local themeindex=5
themes.accentstyle={labelcolor=themes[themeindex].accent,rgb=false}
toggle.themestyles={background={labelcolor=themes[themeindex].bg,rgb=false},topbar={labelcolor=themes[themeindex].top,rgb=false},border={labelcolor=themes[themeindex].select,rgb=false},outline={labelcolor=themes[themeindex].muted,rgb=false},text={labelcolor=themes[themeindex].text,rgb=false}}
local menustate={w=390,h=470,watermarkw=100,watermarkh=27,x=24,y=math.floor((cam.ViewportSize.Y-470)/2),tab=1,minimized=false,maxitems=64,scroll={},scrolltarget={},scrollmax={},itemkinds={},hover={},toggleanim={},slideranim={},tabfade=1,tabslide=0,indicatorx=nil,indicatorw=nil}
local tabnames={"main","colors","misc"}
local menubg=newsquare(Color3.fromHex("#16161e"),0.98)
local menutop=newsquare(Color3.fromHex("#1a1b26"),1)
local menuside=newsquare(Color3.fromHex("#13131a"),1)
local menuchrome={border=newborder(Color3.fromHex("#343b46"),1),content=newborder(Color3.fromHex("#272c35"),1),divider=newline(Color3.fromHex("#272c35")),columns={newsquare(Color3.fromHex("#06090c"),1),newsquare(Color3.fromHex("#06090c"),1)},columnborders={newborder(Color3.fromHex("#272c35"),1),newborder(Color3.fromHex("#272c35"),1)},scrolltrack=newsquare(Color3.fromHex("#090b0e"),0.8),scrollthumb=newsquare(Color3.fromHex("#99C30B"),1),scrollborder=newborder(Color3.fromHex("#272c35"),1),tabindicator=newsquare(Color3.fromHex("#99C30B"),1)}
menuchrome.divider.Thickness=1
toggle.menutitle=function()return"rake's saint"..(toggle.watermarkhint and" ["..(keynames[keybinds.menu]or tostring(keybinds.menu)).." to open]"or"")end
local menutitle=newtext(toggle.menutitle(),Color3.fromHex("#ffffff"),false,false)
menutitle.Size=13
menustate.watermarkw=math.min(menustate.w,math.max(100,#menutitle.Text*7+28))
local menuclose=newtext("-",Color3.fromHex("#787c99"),true,false)
for _,d in ipairs({menubg,menutop,menuside,menuchrome.content,menuchrome.divider,menuchrome.columns[1],menuchrome.columns[2]})do setz(d,100)end;setz(menuchrome.border,138);setz(menuchrome.columnborders[1],138);setz(menuchrome.columnborders[2],138);setz(menuchrome.scrolltrack,130);setz(menuchrome.scrollthumb,132);setz(menuchrome.scrollborder,131);setz(menuchrome.tabindicator,119);setz(menutitle,121);setz(menuclose,121)
local tabbg,tabtext,tabborder={},{},{}
for i=1,#tabnames do tabbg[i]=setz(newsquare(Color3.fromHex("#202330"),1),112);tabborder[i]=setz(newborder(Color3.fromHex("#272c35"),1),113);tabtext[i]=setz(newtext(tabnames[i],Color3.fromHex("#ffffff"),true,false),121);tabtext[i].Size=13 end
local itembg,itemlabel,itemvalue,itemmark,itemline,itemtrack,itemfill,itemborder,markborder,trackborder={},{},{},{},{},{},{},{},{},{}
for i=1,menustate.maxitems do
    itembg[i]=setz(newsquare(Color3.fromHex("#202330"),1),110);itemborder[i]=setz(newborder(Color3.fromHex("#272c35"),1),111);itemlabel[i]=setz(newtext("",Color3.fromHex("#ffffff"),false,false),121);itemvalue[i]=setz(newtext("",Color3.fromHex("#ffffff"),false,false),121);itemmark[i]=setz(newsquare(Color3.fromHex("#7aa2f7"),1),116);markborder[i]=setz(newborder(Color3.fromHex("#343b46"),1),114);itemline[i]=setz(newline(Color3.fromHex("#787c99")),112);itemline[i].Thickness=1;itemtrack[i]=setz(newsquare(Color3.fromHex("#343b58"),1),114);itemfill[i]=setz(newsquare(Color3.fromHex("#7aa2f7"),1),115);trackborder[i]=setz(newborder(Color3.fromHex("#343b46"),1),118)
end
local sectionframes={}
local function getsectionframe(index)
    if not sectionframes[index]then
        sectionframes[index]={topl=setz(newline(Color3.fromHex("#000000")),112),topr=setz(newline(Color3.fromHex("#000000")),112),left=setz(newline(Color3.fromHex("#000000")),112),right=setz(newline(Color3.fromHex("#000000")),112),bottom=setz(newline(Color3.fromHex("#000000")),112)};for _,d in pairs(sectionframes[index])do d.Thickness=1 end
    end
    return sectionframes[index]
end
-- Build these before either popup. This preserves popup-over-panel ordering even
-- on Drawing implementations that ignore ZIndex.
for i=1,menustate.maxitems do getsectionframe(i)end
local itemrgb,itemrgbcount={},12
local function getitemrgb(index)
    if not itemrgb[index]then itemrgb[index]={};for i=1,itemrgbcount do itemrgb[index][i]=setz(newsquare(Color3.fromHex("#ffffff"),1),117)end end;return itemrgb[index]
end
local dropdown={panel=newsquare(Color3.fromHex("#05070a"),1),border=newborder(Color3.fromHex("#28313d"),1),accent=newsquare(Color3.fromHex("#8da8c0"),1),bg={},text={},max=12,anim=0,opened=false}
setz(dropdown.panel,200);setz(dropdown.border,201);setz(dropdown.accent,202);for i=1,dropdown.max do dropdown.bg[i]=setz(newsquare(Color3.fromHex("#202330"),1),203);dropdown.text[i]=setz(newtext("",Color3.fromHex("#ffffff"),false,false),204)end
local picker={
    bg=newsquare(Color3.fromHex("#08090c"),0.98),top=newsquare(Color3.fromHex("#161616"),1),panel=newsquare(Color3.fromHex("#050607"),1),accent=newsquare(Color3.fromHex("#65c8e8"),1),divider=newline(Color3.fromHex("#111111")),border=newborder(Color3.fromHex("#000000"),1),middleborder=newborder(Color3.fromHex("#555555"),1),innerborder=newborder(Color3.fromHex("#000000"),1),panelborder=newborder(Color3.fromHex("#111111"),1),title=newtext("color",Color3.fromHex("#ffffff"),false,false),
    preview=newsquare(Color3.fromHex("#ffffff"),1),previewrgb={},previewborder=newborder(Color3.fromHex("#ffffff"),1),squareborder=newborder(Color3.fromHex("#ffffff"),1),hueborder=newborder(Color3.fromHex("#ffffff"),1),grid={},hue={},cursor=nil,huecursor=nil,reveal=newsquare(Color3.fromHex("#202020"),1),
    rgbbg=newsquare(Color3.fromHex("#090b0e"),1),rgbborder=newborder(Color3.fromHex("#343b46"),1),rgbmark=newsquare(Color3.fromHex("#7aa2f7"),1),rgbmarkborder=newborder(Color3.fromHex("#343b46"),1),rgbtext=newtext("RGB",Color3.fromHex("#ffffff"),false,false),
    donebg=newsquare(Color3.fromHex("#20242b"),1),doneborder=newborder(Color3.fromHex("#343b46"),1),donetext=newtext("done",Color3.fromHex("#ffffff"),true,false),
    hexbg=newsquare(Color3.fromHex("#090b0e"),1),hexborder=newborder(Color3.fromHex("#343b46"),1),hexlabel=newtext("hex",Color3.fromHex("#ffffff"),false,false),hextext=newtext("#FFFFFF",Color3.fromHex("#ffffff"),false,false),
    recentlabel=newtext("recent",Color3.fromHex("#ffffff"),false,false),recent={},recentborder={},anim=0,opened=false,cursorx=nil,cursory=nil,huey=nil
}
picker.cols=48;picker.rows=36;picker.huesteps=64
picker.divider.Thickness=1
for _,d in ipairs({picker.bg,picker.top,picker.panel})do setz(d,220)end
for _,d in ipairs({picker.accent,picker.divider})do setz(d,221)end
for _,d in ipairs({picker.border,picker.middleborder,picker.innerborder,picker.panelborder,picker.preview,picker.previewborder,picker.squareborder,picker.hueborder,picker.rgbbg,picker.rgbborder,picker.donebg,picker.doneborder,picker.hexbg,picker.hexborder})do setz(d,222)end;setz(picker.rgbmark,223);setz(picker.rgbmarkborder,224)
for _,d in ipairs({picker.title,picker.rgbtext,picker.donetext,picker.hexlabel,picker.hextext,picker.recentlabel})do setz(d,225)end
for y=1,picker.rows do for x=1,picker.cols do picker.grid[#picker.grid+1]=setz(newsquare(Color3.fromHex("#ffffff"),1),223)end end
for i=1,picker.huesteps do picker.hue[i]=setz(newsquare(Color3.fromHSV((i-1)/picker.huesteps,1,1),1),223)end
for i=1,24 do picker.previewrgb[i]=setz(newsquare(Color3.fromHex("#ffffff"),1),224)end
setz(picker.reveal,224)
picker.cursor=setz(Drawing.new("Circle"),226);picker.cursor.Color=Color3.fromHex("#ffffff");picker.cursor.Radius=4;picker.cursor.NumSides=20;picker.cursor.Thickness=1;picker.cursor.Visible=false;picker.huecursor=setz(newborder(Color3.fromHex("#ffffff"),1),226)
picker.hexvalue="FFFFFF";picker.hexactive=false;picker.hexreplace=false;picker.recentcolors={Color3.fromHex("#a2ff00"),Color3.fromHex("#ffffff"),Color3.fromHex("#ff6b6b"),Color3.fromHex("#78b7e6"),Color3.fromHex("#b283d3"),Color3.fromHex("#000000")}
for i=1,6 do picker.recent[i]=setz(newsquare(picker.recentcolors[i],1),224);picker.recentborder[i]=setz(newborder(Color3.fromHex("#343b46"),1),225)end
local menurgb={}
for i=1,barseg do menurgb[i]=setz(newline(Color3.fromHSV((i-1)/barseg*rgbspread,0.68,1)),140);menurgb[i].Thickness=2 end
local capture,pickerentry,dropdownkind,configcapture=nil,nil,nil,false
local configslots={"default"}
local configslot=1
local configname="default"
local menuitems,itemlayouts={},{}
local pickerlayouts,dropdownlayouts={},{}
local function color(name)
    if name=="accent"then return themes.accentstyle.labelcolor elseif name=="bg"or name=="side"then return toggle.themestyles.background.labelcolor elseif name=="top"then return toggle.themestyles.topbar.labelcolor elseif name=="select"then return toggle.themestyles.border.labelcolor elseif name=="outline"then return toggle.themestyles.outline.labelcolor elseif name=="text"then return toggle.themestyles.text.labelcolor end
    return themes[themeindex][name]
end
toggle.ease=function(current,target,speed)
    current=current==nil and target or current
    if math.abs(target-current)<0.001 then return target end
    return current+(target-current)*speed
end
toggle.colormix=function(a,b,amount)
    amount=clamp(amount,0,1);return Color3.new(a.R+(b.R-a.R)*amount,a.G+(b.G-a.G)*amount,a.B+(b.B-a.B)*amount)
end
toggle.accentvisual=function()
    if toggle.barrgb then return color("accent")end
    return toggle.colormix(color("accent"),color("text"),0.035+0.025*(math.sin(tick()*2.1)+1)/2)
end
local function inside(px,py,x,y,w,h)return px>=x and px<=x+w and py>=y and py<=y+h end
local function entrycfg(index)
    if index=="accent"then return themes.accentstyle elseif index=="themebg"then return toggle.themestyles.background elseif index=="themetop"then return toggle.themestyles.topbar elseif index=="themeborder"then return toggle.themestyles.border elseif index=="themeoutline"then return toggle.themestyles.outline elseif index=="themetext"then return toggle.themestyles.text elseif index=="distance"then return toggle.distancestyle elseif index=="rake"then return toggle.rakestyle elseif index=="rakehealth"then return toggle.rakehealthstyle elseif index=="rakebar"then return toggle.rakebarstyle elseif index=="roof"then return roofstyle elseif index=="hudtimer"then return toggle.hudstyles.timer elseif index=="hudtarget"then return toggle.hudstyles.target elseif index=="hudscrap"then return toggle.hudstyles.scrap elseif index=="hudpower"then return toggle.hudstyles.power elseif index=="cooldownlabel"then return toggle.cooldownstyle elseif index=="cooldownvalue"then return toggle.cooldownvaluestyle elseif index=="ppmslabel"then return toggle.ppmslabelstyle elseif index=="ppmsvalue"then return toggle.ppmsvaluestyle elseif index=="valuetimer"then return toggle.hudvalues.timer elseif index=="valuetarget"then return toggle.hudvalues.target elseif index=="valuescrap"then return toggle.hudvalues.scrap elseif index=="valuepower"then return toggle.hudvalues.power elseif index=="timerwarning"then return toggle.hudvalues.warning elseif type(index)=="string"and string.match(index,"^volt%d$")then return toggle.voltmeterstyles[tonumber(string.sub(index,5))] elseif type(index)=="string"and string.sub(index,1,6)=="crate_"then return toggle.cratestyles[string.sub(index,7)]end
    local entry=colorentries[index];return entry and espcfg[entry.cfgs[1]]or nil
end
toggle.colorname=function(index)
    if type(index)=="number"then return colorentries[index].name elseif type(index)=="string"and string.match(index,"^volt%d$")then return"voltmeter "..string.sub(index,5) elseif type(index)=="string"and string.sub(index,1,6)=="crate_"then local cfg=toggle.cratestyles[string.sub(index,7)];return cfg and cfg.name or"supply item"end
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
toggle.itemshown=function(item)
    local shown=item.display or item.value and tostring(item.value)or""
    if item.kind=="dropdown"then if #shown>14 then shown=string.sub(shown,1,12)..".."end;return shown.." >"end
    if #shown>18 then shown=string.sub(shown,1,16)..".."end;return shown
end
local function currentitems()
    if menustate.tab==1 then
        local items={
            section("overlay",1),{id="esp",kind="toggle",label="esp toggle",on=toggle.esp,col=1},{id="hud",kind="toggle",label="hud toggle",on=toggle.hud,col=1},
            section("hud",1),{id="hudbar",kind="toggle",label="accent bar",on=toggle.hudbar,col=1},{id="hudlabels",kind="toggle",label="hud labels",on=toggle.hudlabels,col=1},
            section("scraps",1),{id="scraps",kind="toggle",label="scraps esp",on=espgroups.scraps,col=1},{id="scrapstyleselect",kind="dropdown",label="scrap style",value=toggle.scrapstyle,col=1},
            section("distance",1),{id="distance",kind="toggle",label="distance",on=toggle.distance,col=1},{id="distancepositionselect",kind="dropdown",label="label position",value=toggle.distanceposition,col=1},{id="distanceminimum",kind="toggle",label="minimum distance",on=toggle.distanceminimum,col=1},{id="distancemin",kind="slider",label="show distance after",value=toggle.distancemin,min=0,max=100,display=tostring(toggle.distancemin).."m",col=1},
            section("rings",1),{id="ringenabled",kind="toggle",label="esp rings",on=toggle.ringenabled,col=1},{id="ringshapeselect",kind="dropdown",label="shape",value=toggle.ringshape,col=1},{id="ring",kind="slider",label="ring quality",value=ringseg,min=10,max=100,col=1},{id="ringfade",kind="slider",label="render distance",value=ringfade,min=10,max=150,display=tostring(math.floor(ringfade)).."m",col=1},{id="ringsize",kind="slider",label="size multiplier",value=toggle.ringsize,min=0.5,max=3,display=string.format("%.1fx",toggle.ringsize),col=1},{id="ringspin",kind="toggle",label="rotating ring",on=toggle.ringspin,col=1},{id="ringspinspeed",kind="slider",label="rotation speed",value=toggle.ringspinspeed,min=0.1,max=3,display=string.format("%.1fx",toggle.ringspinspeed),col=1},
            section("timer",1),{id="hudtimer",kind="toggle",label="timer counter",on=toggle.hudelements.timer,col=1},{id="timerformatselect",kind="dropdown",label="timer style",value=toggle.timerformat,col=1},{id="timerwarningenabled",kind="toggle",label="timer warning",on=toggle.timerwarningenabled,col=1},{id="timerwarning",kind="slider",label="warning time",value=toggle.timerwarning,min=10,max=45,display=tostring(toggle.timerwarning).."s",col=1},
            section("players",2),{id="hudtarget",kind="toggle",label="targetted player",on=toggle.hudelements.target,col=2},{id="hudscrap",kind="toggle",label="scrap amount",on=toggle.hudelements.scrap,col=2},
            section("world",2),{id="flares",kind="toggle",label="flare gun",on=espgroups.flares,col=2},{id="traps",kind="toggle",label="rake trap",on=espgroups.traps,col=2},{id="supplylabel",kind="toggle",label="supply crate",on=toggle.supplylabel,col=2},{id="supplyitems",kind="toggle",label="crate inventory",on=toggle.supplyitems,col=2},
            section("rake",2),{id="rake",kind="toggle",label="rake esp",on=espgroups.rake,col=2},{id="rakename",kind="toggle",label="rake name",on=toggle.rakename,col=2},{id="rakehealth",kind="toggle",label="rake health",on=toggle.rakehealth,col=2},{id="rakenameinput",kind="text",label="custom name",value=toggle.rakenamecapture and toggle.rakenamevalue.."_"or toggle.rakenamevalue,col=2},{id="healthbased",kind="toggle",label="health-based color",on=toggle.healthbased,col=2},{id="rakehealthformatselect",kind="dropdown",label="health style",value=toggle.rakehealthformat,col=2},{id="rakenamey",kind="slider",label="name Y offset",value=toggle.rakenamey,min=-100,max=100,display=tostring(toggle.rakenamey).."px",col=2},{id="rakehealthy",kind="slider",label="health Y offset",value=toggle.rakehealthy,min=-100,max=100,display=tostring(toggle.rakehealthy).."px",col=2},{id="rakebarwidth",kind="slider",label="health bar width",value=toggle.rakebarwidth,min=30,max=200,display=tostring(toggle.rakebarwidth).."px",col=2},
            section("power",2),{id="hudpower",kind="toggle",label="power left",on=toggle.hudelements.power,col=2},{id="powerformatselect",kind="dropdown",label="power style",value=toggle.powerformat,col=2},{id="powerdecimal",kind="toggle",label="decimal",on=toggle.powerdecimal,col=2},
            section("pwr usage",2),{id="poweractivity",kind="toggle",label="power activity",on=toggle.poweractivity,col=2},{id="ppms",kind="toggle",label="voltmeter",on=toggle.ppms and not toggle.ppmspowerblocked,col=2},
            section("locations",2),{id="roof",kind="toggle",label="roof HP",on=toggle.roof,col=2}
        }
        for i=9,13 do local cfg=colorentries[i];items[#items+1]={id="item"..cfg.cfgs[1],kind="toggle",label=cfg.name,on=espgroups.items[cfg.cfgs[1]],itemkey=cfg.cfgs[1],col=2}end
        return items
    elseif menustate.tab==2 then
        local items={section("locations",1)}
        for i=9,13 do items[#items+1]={id="labelcolor"..tostring(i),kind="color",label=colorentries[i].name,index=i,col=1}end
        items[#items+1]=section("scraps",1)
        for i=2,6 do items[#items+1]={id="labelcolor"..tostring(i),kind="color",label=colorentries[i].name,index=i,col=1}end
        items[#items+1]=section("world",1)
        for _,i in ipairs({1,7,8})do items[#items+1]={id="labelcolor"..tostring(i),kind="color",label=colorentries[i].name,index=i,col=1}end;items[#items+1]=section("rake",1);items[#items+1]={id="rakecolor",kind="color",label="name",index="rake",col=1};items[#items+1]={id="rakehealthcolor",kind="color",label="health",index="rakehealth",col=1};items[#items+1]={id="rakebarcolor",kind="color",label="health bar",index="rakebar",col=1}
        items[#items+1]=section("misc",1);items[#items+1]={id="distancecolor",kind="color",label="distance label",index="distance",col=1};items[#items+1]={id="roofcolor",kind="color",label="roof HP",index="roof",col=1};items[#items+1]=section("voltmeter",1);for i=1,5 do items[#items+1]={id="voltcolor"..tostring(i),kind="color",label="cell "..tostring(i),index="volt"..tostring(i),col=1}end
        items[#items+1]=section("hud labels",2);items[#items+1]={id="hudtimercolor",kind="color",label="timer label",index="hudtimer",col=2};items[#items+1]={id="cooldownlabelcolor",kind="color",label="cooldown label",index="cooldownlabel",col=2};items[#items+1]={id="hudtargetcolor",kind="color",label="target label",index="hudtarget",col=2};items[#items+1]={id="hudscrapcolor",kind="color",label="scrap label",index="hudscrap",col=2};items[#items+1]={id="hudpowercolor",kind="color",label="power label",index="hudpower",col=2};items[#items+1]={id="ppmslabelcolor",kind="color",label="voltmeter label",index="ppmslabel",col=2}
        items[#items+1]=section("hud values",2);items[#items+1]={id="valuetimercolor",kind="color",label="timer value",index="valuetimer",col=2};items[#items+1]={id="cooldownvaluecolor",kind="color",label="cooldown value",index="cooldownvalue",col=2};items[#items+1]={id="valuetargetcolor",kind="color",label="target value",index="valuetarget",col=2};items[#items+1]={id="valuescrapcolor",kind="color",label="scrap value",index="valuescrap",col=2};items[#items+1]={id="valuepowercolor",kind="color",label="power value",index="valuepower",col=2};items[#items+1]={id="timerwarningcolor",kind="color",label="timer warning",index="timerwarning",col=2}
        items[#items+1]=section("crate",2);for _,entry in ipairs({{"FirstAidKit","medkit"},{"Vitamins","vitamin"},{"UV_Lamp","uv lamp"},{"StunStick","stun stick"},{"Vest","vest"},{"Tracker","tracker"}})do items[#items+1]={id="cratecolor"..entry[1],kind="color",label=entry[2],index="crate_"..entry[1],col=2}end
        return items
    elseif menustate.tab==3 then
        return {section("interface",1),{id="presetselect",kind="dropdown",label="preset",value=themes[themeindex].name,col=1},{id="opacity",kind="slider",label="opacity",value=guiopacity,min=0.2,max=1,display=tostring(math.floor(guiopacity*100+0.5)).."%",col=1},{id="watermark",kind="toggle",label="watermark state",on=toggle.watermark,col=1},{id="watermarkhint",kind="toggle",label="watermark hint",on=toggle.watermarkhint,col=1},section("theme colors",1),{id="accentcolor",kind="color",label="accent",index="accent",col=1},{id="themebgcolor",kind="color",label="background",index="themebg",col=1},{id="themetopcolor",kind="color",label="top bar",index="themetop",col=1},{id="themebordercolor",kind="color",label="border",index="themeborder",col=1},{id="themeoutlinecolor",kind="color",label="outline",index="themeoutline",col=1},{id="themetextcolor",kind="color",label="text",index="themetext",col=1},section("rgb accent",1),{id="barrgb",kind="toggle",label="rgb accent",on=toggle.barrgb,col=1},{id="rgbdirectionselect",kind="dropdown",label="rgb direction",value=toggle.rgbdirection,col=1},{id="rgbspeed",kind="slider",label="rgb speed",value=rgbspeed,min=0.5,max=2,display=string.format("%.2fx",rgbspeed),col=1},section("teleports",1),{id="scrap",kind="action",label="teleport to scrap",col=1},{id="flare",kind="action",label="teleport to flare",col=1},{id="teleportcooldown",kind="toggle",label="tp safety cooldown",on=toggle.teleportcooldown,col=1},section("configuration",2),{id="configname",kind="text",stacked=true,label="config name",value=configcapture and configname.."_"or configname,col=2},{id="configselect",kind="dropdown",stacked=true,label="config list",value=configslots[configslot]or"none",col=2},{id="save",kind="action",label="save",col=2},{id="load",kind="action",label="load",col=2},section("fonts",2),{id="espfontselect",kind="dropdown",label="esp font",value=fontnames[fontindex],col=2},{id="hudfontselect",kind="dropdown",label="hud font",value=fontnames[toggle.hudfontindex],col=2},{id="fontsize",kind="slider",label="font size",value=espfontsize,min=13,max=20,col=2},section("keybinds",2),{id="bindmenu",kind="bind",bind="menu",label=bindlabels.menu,value=capture=="menu"and"press a key..."or"["..(keynames[keybinds.menu]or tostring(keybinds.menu)).."]",col=2},{id="bindesp",kind="bind",bind="esp",label=bindlabels.esp,value=capture=="esp"and"press a key..."or"["..(keynames[keybinds.esp]or tostring(keybinds.esp)).."]",col=2},{id="bindhud",kind="bind",bind="hud",label=bindlabels.hud,value=capture=="hud"and"press a key..."or"["..(keynames[keybinds.hud]or tostring(keybinds.hud)).."]",col=2},section("teleport binds",2),{id="bindscrap",kind="bind",bind="scrap",label=bindlabels.scrap,value=capture=="scrap"and"press a key..."or"["..(keynames[keybinds.scrap]or tostring(keybinds.scrap)).."]",col=2},{id="bindflare",kind="bind",bind="flare",label=bindlabels.flare,value=capture=="flare"and"press a key..."or"["..(keynames[keybinds.flare]or tostring(keybinds.flare)).."]",col=2},section("reset",2),{id="resetcolors",kind="action",label="reset colors",col=2},{id="resettheme",kind="action",label="reset theme",col=2},{id="resettoggles",kind="action",label="reset toggles",col=2},{id="resetbinds",kind="action",label="reset binds",col=2},{id="reset",kind="action",label="reset all",col=2}}
    end
    return {}
end
toggle.rowheight=function(item)return item.stacked and 46 or item.kind=="section"and 22 or item.kind=="slider"and 35 or item.kind=="action"and 25 or item.kind=="dropdown"and 22 or 19 end
local function displaysize()return menustate.minimized and menustate.watermarkw or menustate.w,menustate.minimized and menustate.watermarkh or menustate.h end
local function clampmenu()
    local v=cam.ViewportSize;local w,h=displaysize()
    menustate.x=clamp(menustate.x,0,math.max(0,v.X-w));menustate.y=clamp(menustate.y,0,math.max(0,v.Y-h))
end
local function menupos()
    clampmenu();menustate.tabfade=toggle.ease(menustate.tabfade,1,0.2);menustate.tabslide=toggle.ease(menustate.tabslide,0,0.22);local displayw,displayh=displaysize()
    menubg.Position=Vector2.new(menustate.x,menustate.y);menubg.Size=Vector2.new(displayw,displayh)
    menutop.Position=Vector2.new(menustate.x,menustate.y);menutop.Size=Vector2.new(displayw,menustate.minimized and menustate.watermarkh or 27)
    menuchrome.border.Position=Vector2.new(menustate.x,menustate.y);menuchrome.border.Size=Vector2.new(displayw,displayh);menuchrome.columnborders[1].Position=Vector2.new(menustate.x+1,menustate.y+1);menuchrome.columnborders[1].Size=Vector2.new(displayw-2,displayh-2);menuchrome.columnborders[2].Position=Vector2.new(menustate.x+2,menustate.y+2);menuchrome.columnborders[2].Size=Vector2.new(displayw-4,displayh-4)
    menutitle.Position=Vector2.new(menustate.x+8,menustate.y+8);menuclose.Position=Vector2.new(menustate.x+displayw-12,menustate.y+6)
    local navx,navy,navw,navh=menustate.x+4,menustate.y+29,menustate.w-8,18
    menuside.Position=Vector2.new(navx,navy);menuside.Size=Vector2.new(navw,navh)
    local tabw=navw/#tabnames
    for i=1,#tabnames do local x=math.floor(navx+(i-1)*tabw+0.5);local right=math.floor(navx+i*tabw+0.5);local w=right-x;local linew=#tabnames[i]*7+10;tabbg[i].Position=Vector2.new(x+math.floor((w-linew)/2),navy+navh-1);tabbg[i].Size=Vector2.new(linew,1);tabborder[i].Position=tabbg[i].Position;tabborder[i].Size=tabbg[i].Size;tabtext[i].Position=Vector2.new(x+math.floor(w/2),navy+8);if i==menustate.tab then local targetx=x+math.floor((w-linew)/2);menustate.indicatorx=toggle.ease(menustate.indicatorx,targetx,0.28);menustate.indicatorw=toggle.ease(menustate.indicatorw,linew,0.28)end end
    menuchrome.tabindicator.Position=Vector2.new(math.floor((menustate.indicatorx or navx)+0.5),navy+navh-2);menuchrome.tabindicator.Size=Vector2.new(math.max(1,math.floor((menustate.indicatorw or 1)+0.5)),2)
    menuchrome.content.Position=Vector2.new(menustate.x+6,menustate.y+52);menuchrome.content.Size=Vector2.new(menustate.w-12,menustate.h-56)
    if menustate.minimized then menuitems={};itemlayouts={} else menuitems=currentitems();itemlayouts={} end
    local left=menustate.x+12;local ystart=menustate.y+58;local cliptop,clipbottom=ystart,menustate.y+menustate.h-8;local gap=12;local w=(menustate.w-24-gap)/2;local natural={0,0}
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
    local viewport=clipbottom-cliptop;local content=math.max(natural[1],natural[2]);menustate.scrollmax[menustate.tab]=math.max(0,content-viewport);menustate.scrolltarget[menustate.tab]=clamp(menustate.scrolltarget[menustate.tab]or 0,0,menustate.scrollmax[menustate.tab]);local oldscroll=menustate.scroll[menustate.tab]or menustate.scrolltarget[menustate.tab];local targetscroll=menustate.scrolltarget[menustate.tab];local scroll=math.abs(targetscroll-oldscroll)<0.2 and targetscroll or oldscroll+(targetscroll-oldscroll)*0.24;menustate.scroll[menustate.tab]=scroll
    local renderscroll=math.floor(scroll+0.5);local ys={ystart-renderscroll,ystart-renderscroll}
    for i=1,#menuitems do
        local item=menuitems[i];local col=item.col or 1;local x=left+(col-1)*(w+gap)+math.floor(menustate.tabslide+0.5);local y=ys[col];local h=toggle.rowheight(item);local panelh=groupheights[i]or h
        if menustate.itemkinds[i]~=item.kind then menustate.itemkinds[i]=item.kind;setz(itembg[i],item.kind=="section"and 105 or 110)end
        local texty=y+(item.kind=="section"and 8 or item.kind=="action"and 11 or item.kind=="dropdown"and 7 or 4);local valuey=item.stacked and y+30 or texty;local renderh=item.kind=="section"and panelh or h
        local overlap=math.min(y+renderh,clipbottom)-math.max(y,cliptop);local visible=overlap>0;local fade=(visible and clamp(math.min(y+renderh-cliptop,clipbottom-y)/14,0,1)or 0)*menustate.tabfade
        local textfade=(visible and math.min(scroll>0 and clamp((texty-cliptop)/12,0,1)or 1,scroll<menustate.scrollmax[menustate.tab]and clamp((clipbottom-texty-10)/12,0,1)or 1)or 0)*menustate.tabfade;local valuefade=item.stacked and(visible and math.min(scroll>0 and clamp((valuey-cliptop)/12,0,1)or 1,scroll<menustate.scrollmax[menustate.tab]and clamp((clipbottom-valuey-10)/12,0,1)or 1)or 0)*menustate.tabfade or textfade
        local liney=y+15;local linefade=(item.kind=="section"and visible and clamp(math.min(liney-cliptop,clipbottom-liney)/10,0,1)or fade)*menustate.tabfade;local sliderfade=(item.kind=="slider"and visible and clamp(math.min(y+17-cliptop,clipbottom-(y+32))/8,0,1)or fade)*menustate.tabfade
        itemlayouts[i]={x=x,y=y,w=w,h=h,panelh=panelh,item=item,visible=visible,fade=fade,linefade=linefade,sliderfade=sliderfade,textfade=textfade,valuefade=valuefade,textvisible=texty>=cliptop and texty+10<=clipbottom,valuevisible=valuey>=cliptop and valuey+10<=clipbottom,markvisible=fade>0.08,linevisible=linefade>0.01,trackvisible=sliderfade>0.01,hittop=math.max(y,cliptop),hitbottom=math.min(y+h,clipbottom),cliptop=cliptop,clipbottom=clipbottom};local shown=toggle.itemshown(item)
        if visible then
        if item.kind~="section"then itembg[i].Position=Vector2.new(x,item.stacked and y+18 or y);itembg[i].Size=Vector2.new(w,item.stacked and 27 or h-1)end;itemlabel[i].Position=Vector2.new(x+(item.kind=="section"and 12 or 7),texty);itemvalue[i].Text=shown;itemvalue[i].Position=Vector2.new(item.stacked and x+8 or x+w-7-math.floor(#shown*7),valuey)
        itemlabel[i].Center=item.kind=="action";if item.kind=="action"then itemlabel[i].Position=Vector2.new(x+w/2,texty)end
        local markx,marky,markw,markh=x+w-16,y+4,9,9;if item.kind=="color"then markx,markw=x+w-31,24 end
        itemmark[i].Position=Vector2.new(markx+1,marky+1);itemmark[i].Size=Vector2.new(markw-2,markh-2)
        local ratio=item.kind=="slider"and clamp((item.value-item.min)/(item.max-item.min),0,1)or 0;if item.kind=="slider"then local animkey=tostring(menustate.tab)..":"..item.id;menustate.slideranim[animkey]=toggle.ease(menustate.slideranim[animkey],ratio,0.28);ratio=menustate.slideranim[animkey]end
        if item.kind=="section"then
            local bgtop=math.max(cliptop,y+17);local bgbottom=math.min(clipbottom,y+panelh-4);itembg[i].Position=Vector2.new(x-2,bgtop);itembg[i].Size=Vector2.new(w+4,math.max(0,bgbottom-bgtop));local frame=getsectionframe(i);local titleend=math.min(x+w-12,x+12+#item.label*7)
            local topy=y+15;local leftx=x-2;local rightx=math.min(x+w+2,menustate.x+menustate.w-12);local bottomy=y+panelh-2;frame.topl.From=Vector2.new(leftx,topy);frame.topl.To=Vector2.new(x+8,topy);frame.topr.From=Vector2.new(titleend+5,topy);frame.topr.To=Vector2.new(rightx,topy);local sidetop=math.max(cliptop,topy);local sidebottom=math.min(clipbottom,bottomy);frame.left.From=Vector2.new(leftx,sidetop);frame.left.To=Vector2.new(leftx,sidebottom);frame.right.From=Vector2.new(rightx,sidetop);frame.right.To=Vector2.new(rightx,sidebottom);frame.bottom.From=Vector2.new(leftx,bottomy);frame.bottom.To=Vector2.new(rightx,bottomy)
        elseif item.kind=="slider"then itemtrack[i].Position=Vector2.new(x+10,y+20);itemtrack[i].Size=Vector2.new(w-20,9);itemfill[i].Position=itemtrack[i].Position;itemfill[i].Size=Vector2.new((w-20)*ratio,9);itemborder[i].Position=Vector2.new(x+7,y+17);itemborder[i].Size=Vector2.new(w-14,15);markborder[i].Position=Vector2.new(x+8,y+18);markborder[i].Size=Vector2.new(w-16,13);trackborder[i].Position=Vector2.new(x+9,y+19);trackborder[i].Size=Vector2.new(w-18,11)
        elseif item.kind=="toggle"or item.kind=="color"then itemborder[i].Position=Vector2.new(markx-2,marky-2);itemborder[i].Size=Vector2.new(markw+4,markh+4);markborder[i].Position=Vector2.new(markx-1,marky-1);markborder[i].Size=Vector2.new(markw+2,markh+2);trackborder[i].Position=Vector2.new(markx,marky);trackborder[i].Size=Vector2.new(markw,markh)
        elseif item.kind=="action"or item.kind=="text"and item.id~="rakenameinput"then local px,py=itembg[i].Position.X,itembg[i].Position.Y;local pw,ph=itembg[i].Size.X,itembg[i].Size.Y;itemborder[i].Position=Vector2.new(px,py);itemborder[i].Size=Vector2.new(pw,ph);markborder[i].Position=Vector2.new(px+1,py+1);markborder[i].Size=Vector2.new(pw-2,ph-2);trackborder[i].Position=Vector2.new(px+2,py+2);trackborder[i].Size=Vector2.new(pw-4,ph-4);itembg[i].Position=Vector2.new(px+3,py+3);itembg[i].Size=Vector2.new(pw-6,ph-6)end
        local clipobjects=item.kind=="section"and{itembg[i]}or item.kind=="slider"and{itembg[i],itemmark[i],itemtrack[i],itemfill[i]}or{itembg[i],itemborder[i],itemmark[i],markborder[i],itemtrack[i],itemfill[i],trackborder[i]};for _,obj in ipairs(clipobjects)do local p=obj.Position;local size=obj.Size;local top=math.max(cliptop,p.Y);local bottom=math.min(clipbottom,p.Y+size.Y);if top~=p.Y or bottom~=p.Y+size.Y then obj.Position=Vector2.new(p.X,top);obj.Size=Vector2.new(size.X,math.max(0,bottom-top))end end
        end;ys[col]=y+rowadvances[i]
    end
    local trackx=menustate.x+menustate.w-8;menuchrome.scrolltrack.Position=Vector2.new(trackx,cliptop);menuchrome.scrolltrack.Size=Vector2.new(3,viewport);menuchrome.scrollborder.Position=menuchrome.scrolltrack.Position;menuchrome.scrollborder.Size=menuchrome.scrolltrack.Size;local thumbh=menustate.scrollmax[menustate.tab]>0 and math.max(28,viewport*viewport/math.max(viewport,content))or viewport;local thumby=math.floor(cliptop+(viewport-thumbh)*(menustate.scrollmax[menustate.tab]>0 and scroll/menustate.scrollmax[menustate.tab]or 0)+0.5);menuchrome.scrollthumb.Position=Vector2.new(trackx,thumby);menuchrome.scrollthumb.Size=Vector2.new(3,thumbh);menustate.scrollthumb={x=trackx-3,y=thumby,w=9,h=thumbh,tracky=cliptop,trackh=viewport,thumbh=thumbh}
    local barleft=menustate.x+1;local barwidth=displayw-2;local segw=barwidth/barseg
    for i=1,#menurgb do menurgb[i].From=Vector2.new(barleft+(i-1)*segw,menustate.y+1);menurgb[i].To=Vector2.new(barleft+i*segw,menustate.y+1)end
end
local function dropdownvalues()
    if dropdownkind=="espfont"or dropdownkind=="hudfont"then return fontnames
    elseif dropdownkind=="preset"then local values={};for i=1,#themes do values[i]=themes[i].name end;return values
    elseif dropdownkind=="distanceposition"then return {"below","above"}
    elseif dropdownkind=="scrapstyle"then return {"none","both","tiers","points"}
    elseif dropdownkind=="ringshape"then return {"circle","square","triangle"}
    elseif dropdownkind=="rgbdirection"then return {"left","right"}
    elseif dropdownkind=="powerformat"then return {"percent","value"}
    elseif dropdownkind=="timerformat"then return {"clock","seconds"}
    elseif dropdownkind=="rakehealthformat"then return {"bar","value"}
    elseif dropdownkind=="config"then return configslots end
    return {}
end
local function dropdownupdate(visible)
    local values=dropdownvalues();dropdownlayouts={};local rowid=dropdownkind=="espfont"and"espfontselect"or dropdownkind=="hudfont"and"hudfontselect"or dropdownkind=="preset"and"presetselect"or dropdownkind=="unit"and"distanceunitselect"or dropdownkind=="distanceposition"and"distancepositionselect"or dropdownkind=="scrapstyle"and"scrapstyleselect"or dropdownkind=="ringshape"and"ringshapeselect"or dropdownkind=="rgbdirection"and"rgbdirectionselect"or dropdownkind=="powerformat"and"powerformatselect"or dropdownkind=="timerformat"and"timerformatselect"or dropdownkind=="ppmsstyle"and"ppmsstyleselect"or dropdownkind=="rakehealthformat"and"rakehealthformatselect"or"configselect";local source=nil
    for i=1,#itemlayouts do if itemlayouts[i].item.id==rowid and itemlayouts[i].visible then source=itemlayouts[i];break end end
    if not visible or not source then dropdown.opened=false;dropdown.anim=0;dropdown.panel.Visible=false;dropdown.border.Visible=false;dropdown.accent.Visible=false;for i=1,dropdown.max do dropdown.bg[i].Visible=false;dropdown.text[i].Visible=false end;return end
    if not dropdown.opened then dropdown.anim=0;dropdown.opened=true end;dropdown.anim=toggle.ease(dropdown.anim,1,0.3)
    local w,rowh=source.item.stacked and source.w or 150,22;local x=source.x+source.w-w;local y=source.y+source.h+2;local count=math.min(#values,dropdown.max)
    y=clamp(y,menustate.y+54,menustate.y+menustate.h-count*rowh-7)+math.floor((1-dropdown.anim)*6+0.5);dropdown.panel.Position=Vector2.new(x-3,y-4);dropdown.panel.Size=Vector2.new(w+6,count*rowh+7);dropdown.panel.Color=color("top");dropdown.panel.Transparency=dropdown.anim;dropdown.panel.Visible=true;dropdown.border.Position=dropdown.panel.Position;dropdown.border.Size=dropdown.panel.Size;dropdown.border.Color=themes.borderblack;dropdown.border.Transparency=dropdown.anim;dropdown.border.Visible=true;dropdown.accent.Position=Vector2.new(x-2,y-3);dropdown.accent.Size=Vector2.new(w+4,2);dropdown.accent.Color=toggle.accentvisual();dropdown.accent.Transparency=dropdown.anim;dropdown.accent.Visible=true
    for i=1,dropdown.max do
        local on=i<=#values;dropdown.bg[i].Visible=on;dropdown.text[i].Visible=on
        if on then local selected=(dropdownkind=="espfont"and i==fontindex)or(dropdownkind=="hudfont"and i==toggle.hudfontindex)or(dropdownkind=="preset"and i==themeindex)or(dropdownkind=="unit"and values[i]==toggle.distanceunit)or(dropdownkind=="distanceposition"and values[i]==toggle.distanceposition)or(dropdownkind=="scrapstyle"and values[i]==toggle.scrapstyle)or(dropdownkind=="ringshape"and values[i]==toggle.ringshape)or(dropdownkind=="rgbdirection"and values[i]==toggle.rgbdirection)or(dropdownkind=="powerformat"and values[i]==toggle.powerformat)or(dropdownkind=="timerformat"and values[i]==toggle.timerformat)or(dropdownkind=="ppmsstyle"and values[i]==toggle.ppmsstyle)or(dropdownkind=="rakehealthformat"and values[i]==toggle.rakehealthformat)or(dropdownkind=="config"and i==configslot);local iy=y+(i-1)*rowh;local hover=inside(mouse.X,mouse.Y,x,iy,w,rowh);dropdown.bg[i].Position=Vector2.new(x,iy);dropdown.bg[i].Size=Vector2.new(w,rowh-1);dropdown.bg[i].Color=color(selected and"select"or hover and"hover"or"card");dropdown.bg[i].Transparency=dropdown.anim;dropdown.text[i].Position=Vector2.new(x+8,iy+7);dropdown.text[i].Text=values[i];dropdown.text[i].Color=color(selected and"accent"or"text");dropdown.text[i].Transparency=dropdown.anim;dropdown.text[i].Outline=themes[themeindex].light~=true;dropdownlayouts[i]={x=x,y=iy,w=w,h=rowh,index=i,value=values[i]}end
    end
end
local function pickerupdate(visible)
    local cfg=entrycfg(pickerentry);local on=visible and cfg~=nil
    local rgbvisible=on and(type(pickerentry)=="number"or type(pickerentry)=="string"and(string.match(pickerentry,"^volt%d$")or string.sub(pickerentry,1,6)=="crate_")or pickerentry=="distance"or pickerentry=="rake"or pickerentry=="rakehealth"or pickerentry=="rakebar"or pickerentry=="roof"or pickerentry=="hudtimer"or pickerentry=="hudtarget"or pickerentry=="hudscrap"or pickerentry=="hudpower"or pickerentry=="cooldownlabel"or pickerentry=="cooldownvalue"or pickerentry=="ppmslabel"or pickerentry=="ppmsvalue"or pickerentry=="valuetimer"or pickerentry=="valuetarget"or pickerentry=="valuescrap"or pickerentry=="valuepower"or pickerentry=="timerwarning")
    if on and not picker.opened then picker.anim=0;picker.cursorx=nil;picker.cursory=nil;picker.huey=nil;picker.opened=true elseif not on then picker.opened=false;picker.anim=0 end;if on then picker.anim=toggle.ease(picker.anim,1,0.24)end
    picker.bg.Visible=on;picker.top.Visible=on;picker.panel.Visible=on;picker.accent.Visible=on;picker.divider.Visible=on;picker.border.Visible=on;picker.middleborder.Visible=on;picker.innerborder.Visible=on;picker.panelborder.Visible=on;picker.title.Visible=on;picker.preview.Visible=on;picker.previewborder.Visible=on;picker.squareborder.Visible=on;picker.hueborder.Visible=on;picker.cursor.Visible=on;picker.huecursor.Visible=on;picker.reveal.Visible=on and picker.anim<0.999;picker.rgbbg.Visible=rgbvisible;picker.rgbborder.Visible=rgbvisible;picker.rgbmark.Visible=rgbvisible;picker.rgbmarkborder.Visible=rgbvisible;picker.rgbtext.Visible=rgbvisible;picker.donebg.Visible=on;picker.doneborder.Visible=on;picker.donetext.Visible=on;picker.hexbg.Visible=on;picker.hexborder.Visible=on;picker.hexlabel.Visible=on;picker.hextext.Visible=on;picker.recentlabel.Visible=on
    for i=1,#picker.previewrgb do picker.previewrgb[i].Visible=false end
    for i=1,6 do picker.recent[i].Visible=on;picker.recentborder[i].Visible=on end
    if picker.wasvisible~=on then for i=1,#picker.grid do picker.grid[i].Visible=on end;for i=1,#picker.hue do picker.hue[i].Visible=on end;picker.wasvisible=on end
    for _,d in ipairs({picker.title,picker.rgbtext,picker.donetext,picker.hexlabel,picker.hextext,picker.recentlabel})do d.Outline=themes[themeindex].light~=true end;pickerlayouts={};if not on then return end
    local pw,ph=280,312;local px=menustate.x+menustate.w+8;local py=clamp(menustate.y+55,2,math.max(2,cam.ViewportSize.Y-ph-2));if px+pw>cam.ViewportSize.X-2 then px=math.max(2,menustate.x-pw-8)end;local c=cfg.labelcolor;local h,s,v=tohsv(c);if not picker.hexactive then picker.hexvalue=toggle.hexof(c)end
    local alpha=picker.anim;picker.border.Position=Vector2.new(px,py);picker.border.Size=Vector2.new(pw,ph);picker.border.Color=themes.borderblack;picker.border.Transparency=alpha;picker.middleborder.Position=Vector2.new(px+1,py+1);picker.middleborder.Size=Vector2.new(pw-2,ph-2);picker.middleborder.Color=color("outline");picker.middleborder.Transparency=0.85*alpha;picker.innerborder.Position=Vector2.new(px+2,py+2);picker.innerborder.Size=Vector2.new(pw-4,ph-4);picker.innerborder.Color=themes.borderblack;picker.innerborder.Transparency=alpha
    picker.bg.Position=Vector2.new(px+3,py+3);picker.bg.Size=Vector2.new(pw-6,ph-6);picker.bg.Color=color("bg");picker.bg.Transparency=alpha;picker.top.Position=Vector2.new(px+3,py+3);picker.top.Size=Vector2.new(pw-6,25);picker.top.Color=color("top");picker.top.Transparency=alpha;picker.accent.Position=Vector2.new(px+3,py+3);picker.accent.Size=Vector2.new(pw-6,2);picker.accent.Color=toggle.barrgb and rgb(0)or toggle.accentvisual();picker.accent.Transparency=alpha;picker.divider.From=Vector2.new(px+3,py+28);picker.divider.To=Vector2.new(px+pw-3,py+28);picker.divider.Color=color("select");picker.divider.Transparency=0.75*alpha
    picker.panel.Position=Vector2.new(px+7,py+34);picker.panel.Size=Vector2.new(pw-14,ph-41);picker.panel.Color=color("card");picker.panel.Transparency=0.95*alpha;picker.panelborder.Position=picker.panel.Position;picker.panelborder.Size=picker.panel.Size;picker.panelborder.Color=color("select");picker.panelborder.Transparency=alpha
    local pickertitle=toggle.colorname(pickerentry)
    picker.title.Position=Vector2.new(px+10+math.floor((1-alpha)*7+0.5),py+9);picker.title.Text=pickertitle.." color";picker.title.Color=color("text");picker.title.Transparency=alpha
    local sx,sy,sw,sh=px+12,py+42,220,156;local cw,ch=sw/picker.cols,sh/picker.rows;local layoutkey=tostring(px)..":"..tostring(py)
    if picker.layoutkey~=layoutkey then for i=1,#picker.grid do local gx=(i-1)%picker.cols;local gy=math.floor((i-1)/picker.cols);local d=picker.grid[i];d.Position=Vector2.new(sx+gx*cw,sy+gy*ch);d.Size=Vector2.new(math.ceil(cw+0.5),math.ceil(ch+0.5));d.Color=Color3.fromHSV(gx/(picker.cols-1),1-gy/(picker.rows-1),1);d.Transparency=1 end;picker.layoutkey=layoutkey end
    local cursorsample=Color3.fromHSV(h,s,1);local cursorlight=cursorsample.R*0.299+cursorsample.G*0.587+cursorsample.B*0.114
    picker.squareborder.Position=Vector2.new(sx-1,sy-1);picker.squareborder.Size=Vector2.new(sw+2,sh+2);picker.squareborder.Color=themes.borderblack;picker.squareborder.Transparency=alpha;local targetcursorx=sx+clamp(h*sw,2,sw-2);local targetcursory=sy+clamp((1-s)*sh,2,sh-2);picker.cursorx=toggle.ease(picker.cursorx,targetcursorx,0.36);picker.cursory=toggle.ease(picker.cursory,targetcursory,0.36);picker.cursor.Position=Vector2.new(picker.cursorx,picker.cursory);picker.cursor.Color=cursorlight>0.65 and Color3.fromHex("#101010")or Color3.fromHex("#ffffff");picker.cursor.Transparency=alpha
    local hx,hy,hw,hh=px+244,sy,22,sh;local hueh=hh/picker.huesteps
    for i=1,#picker.hue do local d=picker.hue[i];d.Position=Vector2.new(hx,hy+(i-1)*hueh);d.Size=Vector2.new(hw,math.ceil(hueh+0.5));d.Color=Color3.fromHSV(h,s,1-(i-1)/(picker.huesteps-1));d.Transparency=1 end
    picker.hueborder.Position=Vector2.new(hx-1,hy-1);picker.hueborder.Size=Vector2.new(hw+2,hh+2);picker.hueborder.Color=themes.borderblack;picker.hueborder.Transparency=alpha;picker.huey=toggle.ease(picker.huey,hy+clamp((1-v)*hh,1,hh-3),0.36);picker.huecursor.Position=Vector2.new(hx-2,picker.huey);picker.huecursor.Size=Vector2.new(hw+4,4);picker.huecursor.Color=Color3.fromHex("#ffffff");picker.huecursor.Transparency=alpha;picker.reveal.Position=Vector2.new(sx,sy);picker.reveal.Size=Vector2.new(hx+hw-sx,sh);picker.reveal.Color=color("card");picker.reveal.Transparency=1-alpha
    local fy=py+210;picker.previewborder.Position=Vector2.new(px+12,fy);picker.previewborder.Size=Vector2.new(78,27);picker.previewborder.Color=themes.borderblack;picker.previewborder.Transparency=alpha;picker.preview.Position=Vector2.new(px+14,fy+2);picker.preview.Size=Vector2.new(74,23);picker.preview.Color=cfg.rgb and rgb(0)or c;picker.preview.Transparency=alpha;picker.preview.Visible=true
    picker.rgbborder.Position=Vector2.new(px+98,fy);picker.rgbborder.Size=Vector2.new(72,27);picker.rgbborder.Color=themes.borderblack;picker.rgbborder.Transparency=alpha;picker.rgbbg.Position=Vector2.new(px+100,fy+2);picker.rgbbg.Size=Vector2.new(68,23);picker.rgbbg.Color=color("top");picker.rgbbg.Transparency=alpha;picker.rgbmarkborder.Position=Vector2.new(px+106,fy+8);picker.rgbmarkborder.Size=Vector2.new(11,11);picker.rgbmarkborder.Color=color("outline");picker.rgbmarkborder.Transparency=alpha;picker.rgbmark.Position=Vector2.new(px+108,fy+10);picker.rgbmark.Size=Vector2.new(7,7);picker.rgbmark.Color=cfg.rgb and toggle.accentvisual()or color("bg");picker.rgbmark.Transparency=alpha;picker.rgbtext.Position=Vector2.new(px+124,fy+6);picker.rgbtext.Color=color("text");picker.rgbtext.Transparency=alpha
    picker.doneborder.Position=Vector2.new(px+178,fy);picker.doneborder.Size=Vector2.new(88,27);picker.doneborder.Color=themes.borderblack;picker.doneborder.Transparency=alpha;picker.donebg.Position=Vector2.new(px+180,fy+2);picker.donebg.Size=Vector2.new(84,23);picker.donebg.Color=color(inside(mouse.X,mouse.Y,px+178,fy,88,27)and"hover"or"top");picker.donebg.Transparency=alpha;picker.donetext.Position=Vector2.new(px+222,fy+12);picker.donetext.Color=color("text");picker.donetext.Transparency=alpha
    local hexy=py+244;picker.hexlabel.Position=Vector2.new(px+12,hexy+6);picker.hexlabel.Color=color("muted");picker.hexlabel.Transparency=alpha;picker.hexborder.Position=Vector2.new(px+54,hexy);picker.hexborder.Size=Vector2.new(212,27);picker.hexborder.Color=picker.hexactive and toggle.accentvisual()or themes.borderblack;picker.hexborder.Transparency=alpha;picker.hexbg.Position=Vector2.new(px+56,hexy+2);picker.hexbg.Size=Vector2.new(208,23);picker.hexbg.Color=color("top");picker.hexbg.Transparency=alpha;picker.hextext.Position=Vector2.new(px+64,hexy+6);picker.hextext.Text="#"..picker.hexvalue..(picker.hexactive and"_"or"");picker.hextext.Color=color(picker.hexactive and"accent"or"text");picker.hextext.Transparency=alpha
    local recenty=py+278;picker.recentlabel.Position=Vector2.new(px+12,recenty+4);picker.recentlabel.Color=color("muted");picker.recentlabel.Transparency=alpha;pickerlayouts.recents={}
    for i=1,6 do local rx=px+64+(i-1)*34;picker.recentborder[i].Position=Vector2.new(rx,recenty);picker.recentborder[i].Size=Vector2.new(29,20);picker.recentborder[i].Color=toggle.hexof(picker.recentcolors[i])==toggle.hexof(c)and toggle.accentvisual()or themes.borderblack;picker.recentborder[i].Transparency=alpha;picker.recent[i].Position=Vector2.new(rx+2,recenty+2);picker.recent[i].Size=Vector2.new(25,16);picker.recent[i].Color=picker.recentcolors[i];picker.recent[i].Transparency=alpha;pickerlayouts.recents[i]={x=rx,y=recenty,w=29,h=20,index=i}end
    pickerlayouts.popup={x=px,y=py,w=pw,h=ph};pickerlayouts.square={x=sx,y=sy,w=sw,h=sh};pickerlayouts.hue={x=hx,y=hy,w=hw,h=hh};pickerlayouts.rgb=rgbvisible and{x=px+98,y=fy,w=72,h=27}or nil;pickerlayouts.done={x=px+178,y=fy,w=88,h=27};pickerlayouts.hex={x=px+54,y=hexy,w=212,h=27}
end
local function menuobjects(visible)
    local expanded=visible and not menustate.minimized
    menubg.Visible=visible;menutop.Visible=visible;menuchrome.border.Visible=visible;menutitle.Visible=visible;menuclose.Visible=visible;menuside.Visible=expanded;menuchrome.tabindicator.Visible=expanded;menuchrome.content.Visible=false;menuchrome.divider.Visible=false
    local canscroll=expanded and(menustate.scrollmax[menustate.tab]or 0)>0;menuchrome.scrolltrack.Visible=canscroll;menuchrome.scrollthumb.Visible=canscroll;menuchrome.scrollborder.Visible=canscroll
    for i=1,2 do menuchrome.columns[i].Visible=false;menuchrome.columnborders[i].Visible=visible end
    for i=1,#tabnames do tabbg[i].Visible=expanded and i==menustate.tab;tabborder[i].Visible=false;tabtext[i].Visible=expanded end
    for i=1,menustate.maxitems do
        local item=menuitems[i];local layout=itemlayouts[i];local on=expanded and item~=nil and layout and layout.visible;local sectionon=on and item.kind=="section";local slideron=on and item.kind=="slider";local markon=on and(item.kind=="toggle"or item.kind=="color");local markcfg=markon and item.kind=="color"and entrycfg(item.index)or nil;local rgbmarkon=false;local bordered=on and(item.kind=="action"or item.kind=="text"and item.id~="rakenameinput")
        local sliderframeon=slideron and layout.trackvisible;local markframeon=markon and layout.markvisible
        itembg[i].Visible=on;itemborder[i].Visible=sliderframeon or markframeon or bordered;itemlabel[i].Visible=on and layout.textvisible;itemvalue[i].Visible=on and layout.valuevisible and item.kind~="section"and item.kind~="toggle"and item.kind~="color";itemmark[i].Visible=markframeon and not rgbmarkon;markborder[i].Visible=sliderframeon or markframeon or bordered;itemline[i].Visible=false;itemtrack[i].Visible=sliderframeon;itemfill[i].Visible=sliderframeon;trackborder[i].Visible=sliderframeon or markframeon or bordered
        local frame=sectionframes[i];if frame then local topy=layout and layout.y+15 or 0;local bottomy=layout and layout.y+layout.panelh-2 or 0;local topvisible=sectionon and topy>=layout.cliptop and topy<=layout.clipbottom;local sidevisible=sectionon and math.min(layout.clipbottom,bottomy)>math.max(layout.cliptop,topy);local bottomvisible=sectionon and bottomy>=layout.cliptop and bottomy<=layout.clipbottom;frame.topl.Visible=topvisible;frame.topr.Visible=topvisible;frame.left.Visible=sidevisible;frame.right.Visible=sidevisible;frame.bottom.Visible=bottomvisible end
        if itemrgb[i]then for s=1,itemrgbcount do itemrgb[i][s].Visible=rgbmarkon end end
    end
    for i=1,#menurgb do menurgb[i].Visible=visible end
    dropdownupdate(expanded and dropdownkind~=nil and pickerentry==nil);pickerupdate(expanded and pickerentry~=nil)
end
local function menuupdate()
    local title=toggle.menutitle();if menutitle.Text~=title then menutitle.Text=title;menustate.watermarkw=math.min(menustate.w,math.max(100,#title*7+28))end
    menupos();local mx,my=mouse.X,mouse.Y;local menuoutline=themes[themeindex].light~=true
    menubg.Color=color("bg");menutop.Color=color("top");menuside.Color=color("side");menutitle.Color=color("text");menutitle.Outline=menuoutline;menuclose.Color=color("muted");menuclose.Outline=menuoutline;menuchrome.border.Color=themes.borderblack;menuchrome.columnborders[1].Color=color("outline");menuchrome.columnborders[2].Color=themes.borderblack;menuchrome.content.Color=color("select");menuchrome.divider.Color=color("select");menuchrome.scrolltrack.Color=color("bg");menuchrome.scrollthumb.Color=toggle.accentvisual();menuchrome.scrollborder.Color=color("select");menuchrome.tabindicator.Color=toggle.accentvisual();menubg.Transparency=guiopacity;menutop.Transparency=guiopacity;menuside.Transparency=guiopacity;menuchrome.border.Transparency=guiopacity;menuchrome.columnborders[1].Transparency=0.85*guiopacity;menuchrome.columnborders[2].Transparency=guiopacity;menuchrome.content.Transparency=guiopacity;menuchrome.divider.Transparency=0.7*guiopacity;menuchrome.scrolltrack.Transparency=0.75*guiopacity;menuchrome.scrollthumb.Transparency=guiopacity;menuchrome.scrollborder.Transparency=0.8*guiopacity;menuchrome.tabindicator.Transparency=guiopacity;menuclose.Text=menustate.minimized and"+"or"-"
    local navw=menustate.w-8;local tabw=navw/#tabnames
    for i=1,#tabnames do local tx=menustate.x+4+(i-1)*tabw;local hover=inside(mx,my,tx,menustate.y+29,tabw,18);local key="tab:"..tostring(i);menustate.hover[key]=toggle.ease(menustate.hover[key],hover and 1 or 0,0.2);tabbg[i].Color=toggle.accentvisual();tabbg[i].Transparency=0;tabtext[i].Color=toggle.colormix(i==menustate.tab and toggle.accentvisual()or color("text"),toggle.accentvisual(),menustate.hover[key]);tabtext[i].Outline=menuoutline end
    for i=1,#menuitems do
        local item=menuitems[i];local l=itemlayouts[i];if l.visible then local fade=l.fade or 1;local borderfade=item.kind=="section"and(l.linefade or 0)or item.kind=="slider"and(l.sliderfade or 0)or fade;local hover=l.visible and item.kind~="section"and inside(mx,my,l.x,l.hittop,l.w,l.hitbottom-l.hittop);local shown=toggle.itemshown(item);local strong=item.kind=="dropdown"or item.kind=="action"or item.kind=="bind"or item.kind=="text";local animkey=tostring(menustate.tab)..":"..tostring(item.id or item.label or i);menustate.hover[animkey]=toggle.ease(menustate.hover[animkey],hover and 1 or 0,0.2);local basecolor=item.kind=="section"and"top"or strong and"top"or"card";local hovercolor=strong and"select"or"hover";itembg[i].Color=toggle.colormix(color(basecolor),color(hovercolor),menustate.hover[animkey]);itembg[i].Transparency=(item.kind=="section"and 0.72 or strong and(0.58+0.38*menustate.hover[animkey])or 0.13+0.25*menustate.hover[animkey])*guiopacity*fade;itemborder[i].Color=themes.borderblack;itemborder[i].Transparency=guiopacity*borderfade;markborder[i].Color=color("outline");markborder[i].Transparency=0.9*guiopacity*borderfade;trackborder[i].Color=themes.borderblack;trackborder[i].Transparency=guiopacity*borderfade;itemlabel[i].Text=item.label;itemlabel[i].Color=color("text");itemlabel[i].Transparency=l.textfade;itemlabel[i].Outline=menuoutline;itemvalue[i].Text=shown;itemvalue[i].Color=color(item.stacked and"text"or"accent");itemvalue[i].Transparency=l.valuefade;itemvalue[i].Outline=menuoutline;itemline[i].Color=toggle.accentvisual();itemline[i].Transparency=0.85*guiopacity*borderfade;itemtrack[i].Color=color("bg");itemtrack[i].Transparency=item.kind=="slider"and borderfade or fade;itemfill[i].Color=toggle.accentvisual();itemfill[i].Transparency=item.kind=="section"and borderfade or item.kind=="slider"and borderfade or fade
        if item.kind=="toggle"then menustate.toggleanim[animkey]=toggle.ease(menustate.toggleanim[animkey],item.on and 1 or 0,0.26);itemmark[i].Color=toggle.accentvisual();itemmark[i].Transparency=menustate.toggleanim[animkey]*fade
        elseif item.kind=="color"then
            local cfg=entrycfg(item.index);itemmark[i].Color=cfg and(cfg.rgb and rgb(0)or cfg.labelcolor)or color("accent");itemmark[i].Transparency=fade;itemvalue[i].Text=cfg and cfg.rgb and"RGB"or""
        end
        local frame=sectionframes[i];if frame and item.kind=="section"then local bottomcenter=l.y+l.panelh-2;local bottomfade=clamp(math.min(bottomcenter-l.cliptop,l.clipbottom-bottomcenter)/10,0,1);frame.topl.Color=toggle.accentvisual();frame.topr.Color=toggle.accentvisual();frame.topl.Transparency=guiopacity*(l.linefade or 0);frame.topr.Transparency=guiopacity*(l.linefade or 0);frame.left.Color=color("select");frame.right.Color=color("select");frame.bottom.Color=color("select");frame.left.Transparency=guiopacity*fade;frame.right.Transparency=guiopacity*fade;frame.bottom.Transparency=guiopacity*bottomfade end
    end end
    menuobjects(toggle.menu)
end
local function showmenu()menuupdate();menuobjects(toggle.menu)end
local powercfg={{valuename="UsingSHDoor",label="house door locked",cells=3},{valuename="UsingSHLight",label="house lights on",cells=1},{valuename="UsingTowerLight",label="tower lights on",cells=3},{valuename="UsingTowerRadar",label="tower radar on",cells=1}}
local powerlines={}
for i=1,#powercfg do powerlines[i]=setz(newtext(powercfg[i].label,Color3.fromHex("#ffffff"),false,false),25)end
setz(powerlabel,25)
toggle.powerpanel={x=math.max(2,cam.ViewportSize.X-190),y=math.max(2,cam.ViewportSize.Y-190),w=164,h=64,defaultoffsetx=190,defaultoffsety=190,anim=0,lineactive={},bg=setz(newsquare(Color3.fromHex("#262626"),0.95),20),top=setz(newsquare(Color3.fromHex("#363636"),0.95),21),outer=setz(newborder(Color3.fromHex("#000000"),1),22),middle=setz(newborder(Color3.fromHex("#555555"),1),22),inner=setz(newborder(Color3.fromHex("#000000"),1),22),accent=setz(newsquare(Color3.fromHex("#99c30b"),1),23),divider=setz(newline(Color3.fromHex("#111111")),23)}
toggle.powerpanel.divider.Thickness=1
toggle.huditems={{id="cooldown",value=toggle.cooldowndraw.value,label=toggle.cooldowndraw.label},{id="timer",value=timertxt,label=timerlabel},{id="target",value=targettxt,label=targetlabel},{id="scrap",value=scraptxt,label=scraplabel},{id="power",value=toggle.powerdraw.value,label=toggle.powerdraw.label},{id="ppms",value=toggle.ppmsdraw.value,label=toggle.ppmsdraw.label}}
toggle.hudvisible=function(id)
    if id=="cooldown"then return toggle.hud and toggle.teleportcooldown and toggle.cooldownremaining>0 elseif id=="ppms"then return toggle.hud and toggle.ppms and not toggle.ppmspowerblocked end
    return toggle.hud and toggle.hudelements[id]==true
end
local function rgbpos()
    local center=anchors();local y=center.Y-8;local x=toggle.hudbarleft or center.X-rgbwidth/2;local w=rgbwidth/barseg
    for i=1,barseg do local d=rgbline[i];d.From=Vector2.new(x+(i-1)*w,y);d.To=Vector2.new(x+i*w,y) end
end
local function powerpos()
    local p,n=toggle.powerpanel,0
    for i=1,#powerlines do if p.lineactive[i]then n=n+1 end end
    p.h=36+n*17;p.x=clamp(p.x,0,math.max(0,cam.ViewportSize.X-p.w));p.y=clamp(p.y,0,math.max(0,cam.ViewportSize.Y-p.h));local on=toggle.hud and toggle.poweractivity and n>0;p.anim=toggle.ease(p.anim,on and 1 or 0,on and 0.18 or 0.22);local drawon=p.anim>0.01;local drawy=p.y+math.floor((1-p.anim)*8+0.5);local alpha=guiopacity*p.anim
    n=0;for i=1,#powerlines do local line=powerlines[i];line.Visible=drawon and p.lineactive[i]or false;if line.Visible then n=n+1;line.Position=Vector2.new(p.x+10,drawy+29+(n-1)*17);line.Color=color("text");line.Transparency=alpha end end
    p.outer.Position=Vector2.new(p.x,drawy);p.outer.Size=Vector2.new(p.w,p.h);p.outer.Color=themes.borderblack;p.outer.Transparency=alpha;p.outer.Visible=drawon
    p.middle.Position=Vector2.new(p.x+1,drawy+1);p.middle.Size=Vector2.new(p.w-2,p.h-2);p.middle.Color=color("outline");p.middle.Transparency=0.85*alpha;p.middle.Visible=drawon
    p.inner.Position=Vector2.new(p.x+2,drawy+2);p.inner.Size=Vector2.new(p.w-4,p.h-4);p.inner.Color=themes.borderblack;p.inner.Transparency=alpha;p.inner.Visible=drawon
    p.bg.Position=Vector2.new(p.x+3,drawy+3);p.bg.Size=Vector2.new(p.w-6,p.h-6);p.bg.Color=color("bg");p.bg.Transparency=alpha;p.bg.Visible=drawon
    p.top.Position=Vector2.new(p.x+3,drawy+3);p.top.Size=Vector2.new(p.w-6,21);p.top.Color=color("top");p.top.Transparency=alpha;p.top.Visible=drawon
    p.accent.Position=Vector2.new(p.x+3,drawy+3);p.accent.Size=Vector2.new(p.w-6,2);p.accent.Color=toggle.barrgb and rgb(0)or toggle.accentvisual();p.accent.Transparency=alpha;p.accent.Visible=drawon
    p.divider.From=Vector2.new(p.x+3,drawy+24);p.divider.To=Vector2.new(p.x+p.w-3,drawy+24);p.divider.Color=color("select");p.divider.Transparency=0.7*alpha;p.divider.Visible=drawon
    powerlabel.Position=Vector2.new(p.x+10,drawy+9);powerlabel.Color=Color3.fromHex("#ffffff");powerlabel.Visible=drawon and toggle.hudlabels;powerlabel.Transparency=alpha
end
local function hudpos()
    local center=anchors();local y=center.Y-50;local active={}
    for i=1,#toggle.huditems do local item=toggle.huditems[i];if toggle.hudvisible(item.id)then active[#active+1]=item end end
    local count=#active;local spacing=120;local start=center.X-(count-1)*spacing/2;toggle.hudcount=count
    for i=1,count do
        local item=active[i];local x=start+(i-1)*spacing;item.value.Position=Vector2.new(x,y);item.label.Position=Vector2.new(x,y+18)
        if item.id=="ppms"then local shown=math.min(toggle.ppmslevel or 0,5);local total=shown>0 and shown*12+(shown-1)*3 or 0;toggle.ppmswidth=math.max(total,#item.label.Text*7);for j=1,5 do local sx=x-total/2+(j-1)*15;toggle.ppmsdraw.squares[j].Position=Vector2.new(sx,y-10);toggle.ppmsdraw.squares[j].Size=Vector2.new(12,20);toggle.ppmsdraw.borders[j].Position=Vector2.new(sx+9,y-10);toggle.ppmsdraw.borders[j].Size=Vector2.new(3,20)end end
    end
    if count>0 then local first,last=active[1],active[count];local firstw=first.id=="ppms"and(toggle.ppmswidth or 62)or math.max(42,math.max(#first.value.Text,#first.label.Text)*7);local lastw=last.id=="ppms"and(toggle.ppmswidth or 62)or math.max(42,math.max(#last.value.Text,#last.label.Text)*7);local left=start-firstw/2-10;local right=start+(count-1)*spacing+lastw/2+10;rgbwidth=math.max(80,right-left);toggle.hudbarleft=rgbwidth==80 and center.X-40 or left else rgbwidth=0;toggle.hudbarleft=center.X end
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
    Box={rootname="HitBox",text="supply",color=Color3.fromHex("#46ffbe"),ringradius=6,ringyoffset=3.2,crate=true,group="crates"},
    SupplyCrate={rootname="HitBox",text="supply",color=Color3.fromHex("#46ffbe"),ringradius=6,ringyoffset=3.2,crate=true,group="crates"}
}
for _,cfg in pairs(espcfg)do cfg.labelcolor=cfg.color;cfg.rgb=false;cfg.defaultcolor=cfg.color;cfg.defaultrgb=false end
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
    rec.name=newtext(rec.cfg.text,rec.cfg.labelcolor,true,false);rec.name.Size=espfontsize;rec.name.Font=font
    rec.distance=newtext("0m",toggle.distancestyle.labelcolor,true,false);rec.distance.Size=espfontsize;rec.distance.Font=font
end
local function makering(rec)
    if rec.cfg.noring or rec.ring or not toggle.ringenabled then return end
    rec.ring={}
    for i=1,ringseg do rec.ring[i]=newline(rec.cfg.color)end
end
local function hidering(rec)if rec.ring then for i=1,#rec.ring do hide(rec.ring[i])end end end
local function makecrate(rec)
    if not rec.cfg.crate or rec.items then return end
    rec.bg=newsquare(cratebg,cratealpha);rec.items={}
    for i=1,6 do rec.items[i]=newtext("",cratetext,true,false,false);rec.items[i].Font=font end
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
            d.Text=cratenames[child.Name]or child.Name;local itemstyle=toggle.cratestyles[child.Name];d.Color=itemstyle and(itemstyle.rgb and rgb((i-1)/#rec.items)or itemstyle.labelcolor)or cratetext
            d.Position=Vector2.new(screen.X+(col-1)*cratecol,screen.Y-12+yoffset+row*craterow+cratey);d.Visible=true
        else d.Visible=false end
    end
    if visible>0 then
        local rows=math.max(1,math.ceil(visible/3));local firsty=screen.Y-12+yoffset+cratey;local miny=firsty-8-cratepady
        rec.bg.Size=Vector2.new(cratewidth,(rows-1)*craterow+16+cratepady*2);rec.bg.Position=Vector2.new(screen.X-cratewidth/2,miny);rec.bg.Visible=true
    else rec.bg.Visible=false end
end
toggle.ringpoint=function(world,y,radius,t,sides,angle)
    if sides==0 then local a=angle+2*math.pi*t;return Vector3.new(world.X+math.cos(a)*radius,y,world.Z+math.sin(a)*radius)end
    local scaled=t*sides;local side=math.floor(scaled)%sides;local blend=scaled-math.floor(scaled);local a=angle-math.pi/2+2*math.pi*side/sides;local b=angle-math.pi/2+2*math.pi*((side+1)%sides)/sides
    return Vector3.new(world.X+(math.cos(a)*(1-blend)+math.cos(b)*blend)*radius,y,world.Z+(math.sin(a)*(1-blend)+math.sin(b)*blend)*radius)
end
local function drawring(rec,world,meters)
    if rec.cfg.noring or not toggle.ringenabled or meters>=ringfade then hidering(rec);return end
    makering(rec);if not rec.ring then return end
    local y=world.Y-(rec.cfg.ringyoffset or 0);local radius=(rec.cfg.ringradius or 2)*toggle.ringsize;local alpha=clamp(1-meters/ringfade,0,1);local sides=toggle.ringshape=="triangle"and 3 or toggle.ringshape=="square"and 4 or 0;local angle=toggle.ringspin and tick()*toggle.ringspinspeed or 0
    for i=1,ringseg do
        local sa,ona=WorldToScreen(toggle.ringpoint(world,y,radius,(i-1)/ringseg,sides,angle));local sb,onb=WorldToScreen(toggle.ringpoint(world,y,radius,i/ringseg,sides,angle));local line=rec.ring[i]
        if toggle.esp and ona and onb then line.From=sa;line.To=sb;line.Color=rec.cfg.rgb and Color3.fromHex("#d8d8d8")or rec.cfg.labelcolor;line.Transparency=alpha;line.Visible=true else line.Visible=false end
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
    local alpha=1
    local labelvisible=toggle.esp and(not rec.cfg.crate or toggle.supplylabel);local topy=screen.Y-espfontsize-2+yoffset;local bottomy=screen.Y+2+yoffset;local labelcolor=rec.cfg.rgb and rgb(0)or rec.cfg.labelcolor;rec.name.Text=rec.cfg.text;rec.name.Position=Vector2.new(screen.X,toggle.distanceposition=="above"and bottomy or topy);rec.name.Transparency=alpha;rec.name.Color=labelcolor;rec.name.Size=espfontsize;rec.name.Visible=labelvisible
    rec.distance.Position=Vector2.new(screen.X,toggle.distanceposition=="above"and topy or bottomy);rec.distance.Text=tostring(math.floor(meters)).."m";local distancecolor=toggle.distancestyle.rgb and rgb(0)or toggle.distancestyle.labelcolor;rec.distance.Color=distancecolor;rec.distance.Transparency=1;rec.distance.Size=espfontsize;rec.distance.Visible=labelvisible and toggle.distance and (not toggle.distanceminimum or meters>=toggle.distancemin)
    drawcrate(rec,screen,meters,yoffset);drawring(rec,world,meters)
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
toggle.drawrake=function(viewer)
    local d=toggle.rakedraw;local part=toggle.rakepart;local humanoid=toggle.rakehumanoid;local visible=toggle.esp and espgroups.rake and part and part.Parent and humanoid and humanoid.Parent
    if not visible then for _,entry in pairs(d)do entry.Visible=false end;return end
    local world=part.Position;local screen,on=WorldToScreen(Vector3.new(world.X,world.Y+4,world.Z));if not on then for _,entry in pairs(d)do entry.Visible=false end;return end
    local meters=dist(viewer,world);local alpha=1;local labelcolor=toggle.rakestyle.rgb and rgb(0)or toggle.rakestyle.labelcolor;local healthcolor=toggle.rakehealthstyle.rgb and rgb(0)or toggle.rakehealthstyle.labelcolor;local health=tonumber(humanoid.Health)or 0;local maximum=tonumber(humanoid.MaxHealth)or 0;local bar=toggle.rakehealth and toggle.rakehealthformat=="bar";local ratio=maximum>0 and clamp(health/maximum,0,1)or 0
    local dynamic=Color3.fromHSV(ratio/3,0.9,1);if toggle.healthbased then healthcolor=dynamic end
    d.name.Text=toggle.rakenamevalue;d.name.Position=Vector2.new(screen.X,screen.Y-espfontsize-2+toggle.rakenamey);d.name.Color=labelcolor;d.name.Transparency=alpha;d.name.Size=espfontsize;d.name.Font=font;d.name.Visible=toggle.rakename
    d.health.Text=tostring(math.floor(health+0.5));d.health.Position=Vector2.new(screen.X,screen.Y+2+toggle.rakehealthy);d.health.Color=healthcolor;d.health.Transparency=alpha;d.health.Size=espfontsize;d.health.Font=font;d.health.Visible=toggle.rakehealth and not bar
    d.barbg.Position=Vector2.new(screen.X-toggle.rakebarwidth/2,screen.Y-5+toggle.rakehealthy);d.barbg.Size=Vector2.new(toggle.rakebarwidth,7);d.barbg.Transparency=alpha*0.78;d.barbg.Visible=bar
    d.barfill.Position=Vector2.new(screen.X-toggle.rakebarwidth/2+1,screen.Y-4+toggle.rakehealthy);d.barfill.Size=Vector2.new(math.max(0,(toggle.rakebarwidth-2)*ratio),5);d.barfill.Color=toggle.healthbased and dynamic or toggle.rakebarstyle.labelcolor;d.barfill.Transparency=alpha;d.barfill.Visible=bar and ratio>0 and(toggle.healthbased or not toggle.rakebarstyle.rgb)
    for i=1,24 do local segment=d["gradient"..i];local a=(i-1)/24;local b=math.min(i/24,ratio);segment.Visible=bar and toggle.rakebarstyle.rgb and not toggle.healthbased and b>a;if segment.Visible then segment.Position=Vector2.new(d.barfill.Position.X+(toggle.rakebarwidth-2)*a,d.barfill.Position.Y);segment.Size=Vector2.new((toggle.rakebarwidth-2)*(b-a),5);segment.Color=rgb(a*rgbspread);segment.Transparency=alpha end end
    d.barborder.Position=d.barbg.Position;d.barborder.Size=d.barbg.Size;d.barborder.Transparency=alpha;d.barborder.Visible=bar
    d.distance.Text=tostring(math.floor(meters)).."m";d.distance.Position=Vector2.new(screen.X,screen.Y+espfontsize+6);d.distance.Color=toggle.distancestyle.rgb and rgb(0)or toggle.distancestyle.labelcolor;d.distance.Transparency=1;d.distance.Size=espfontsize;d.distance.Font=font;d.distance.Visible=toggle.distance and (not toggle.distanceminimum or meters>=toggle.distancemin)
end
local function powerhud()
    local any=false;local activecells,activecount=0,0
    for i=1,#powercfg do
        local entry=powercfg[i];local value=powervals:FindFirstChild(entry.valuename);local active=value and value.Value==true
        if active then activecells=activecells+(entry.cells or 0);activecount=activecount+1 end;toggle.powerpanel.lineactive[i]=active;if active then any=true end
    end
    toggle.ppmspowerblocked=not toggle.poweravailable
    if not toggle.ppmsobject or not toggle.ppmsobject.Parent then toggle.ppmsobject=powervals:FindFirstChild("PPMS")end
    local oldtext,oldlevel=toggle.ppmsdraw.value.Text,toggle.ppmslevel;local ok,reading=pcall(function()return toggle.ppmsobject and toggle.ppmsobject.Value end);reading=ok and tonumber(reading)or nil
    toggle.ppmsdraw.value.Text=reading and tostring(reading)or"?";toggle.ppmslevel=toggle.poweravailable and clamp(1+activecells,1,activecount>=3 and 5 or 4)or 0
    local visible=toggle.hudvisible("ppms");toggle.ppmsdraw.label.Visible=visible and toggle.hudlabels;toggle.ppmsdraw.value.Visible=false
    for i=1,5 do local squareon=visible and i<=toggle.ppmslevel;toggle.ppmsdraw.squares[i].Visible=squareon;toggle.ppmsdraw.borders[i].Visible=squareon;toggle.ppmsdraw.squares[i].Transparency=1;toggle.ppmsdraw.borders[i].Transparency=0.48 end
    if oldlevel~=toggle.ppmslevel or oldtext~=toggle.ppmsdraw.value.Text then hudpos();menuupdate()else powerpos()end
end
local function targethud()
    local target=raketarget and raketarget.Value or nil;local shown="none"
    if target and typeof(target)=="Instance"and target:IsA("BasePart")then
        local char=getchar(target);shown=char and char.Name or"unknown"
    end
    if targettxt.Text~=shown then targettxt.Text=shown;hudpos()end
end
local function scraphud()
    local oldscrap,oldpower=scraptxt.Text,toggle.powerdraw.value.Text
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
        toggle.poweravailable=value>0
        local percent=(value-minimum)/(maximum-minimum)*100
        if toggle.powerformat=="value"then toggle.powerdraw.value.Text=tostring(math.floor(value+0.5))elseif toggle.powerdecimal then toggle.powerdraw.value.Text=string.format("%.1f%%",percent)else toggle.powerdraw.value.Text=tostring(math.floor(percent+0.5)).."%"end
    else toggle.powerdraw.value.Text="?";toggle.poweravailable=true end
    if oldscrap~=scraptxt.Text or oldpower~=toggle.powerdraw.value.Text then hudpos()end
end
local function timerhud()
    local timer=math.max(0,math.floor(tonumber(timerval.Value)or 0));local shown=toggle.timerformat=="seconds"and tostring(timer)or string.format("%d:%02d",math.floor(timer/60),timer%60);if timertxt.Text~=shown then timertxt.Text=shown;hudpos()end;toggle.timerlow=toggle.timerwarningenabled and timer<=toggle.timerwarning
    local remaining=toggle.teleportcooldown and math.max(0,math.ceil((toggle.cooldownuntil or 0)-tick()))or 0
    if remaining~=toggle.cooldownremaining then toggle.cooldownremaining=remaining;toggle.cooldowndraw.value.Text=tostring(remaining).."s";toggle.cooldowndraw.value.Visible=toggle.hudvisible("cooldown");toggle.cooldowndraw.label.Visible=toggle.hudvisible("cooldown")and toggle.hudlabels;hudpos()end
end
local function showhud()
    for i=1,#toggle.huditems do local item=toggle.huditems[i];local visible=toggle.hudvisible(item.id);item.value.Visible=visible and item.id~="ppms";item.label.Visible=visible and toggle.hudlabels end
    for i=1,5 do local visible=toggle.hudvisible("ppms")and i<=toggle.ppmslevel;toggle.ppmsdraw.squares[i].Visible=visible;toggle.ppmsdraw.borders[i].Visible=visible end
    for i=1,#rgbline do rgbline[i].Visible=toggle.hud and toggle.hudbar and(toggle.hudcount or 0)>0 end
    powerhud()
end
local function drawrgb()
    local phase=((tick()*rgbspeed)*(toggle.rgbdirection=="left"and 1 or-1))%1
    timerlabel.Color=toggle.hudstyles.timer.rgb and rgb(0)or toggle.hudstyles.timer.labelcolor;targetlabel.Color=toggle.hudstyles.target.rgb and rgb(0)or toggle.hudstyles.target.labelcolor;scraplabel.Color=toggle.hudstyles.scrap.rgb and rgb(0)or toggle.hudstyles.scrap.labelcolor;toggle.powerdraw.label.Color=toggle.hudstyles.power.rgb and rgb(0)or toggle.hudstyles.power.labelcolor
    local timerstyle=toggle.timerlow and toggle.hudvalues.warning or toggle.hudvalues.timer;timertxt.Color=timerstyle.rgb and rgb(0)or timerstyle.labelcolor;targettxt.Color=toggle.hudvalues.target.rgb and rgb(0)or toggle.hudvalues.target.labelcolor;scraptxt.Color=toggle.hudvalues.scrap.rgb and rgb(0)or toggle.hudvalues.scrap.labelcolor;toggle.powerdraw.value.Color=toggle.hudvalues.power.rgb and rgb(0)or toggle.hudvalues.power.labelcolor
    powerlabel.Color=Color3.fromHex("#ffffff");toggle.cooldowndraw.label.Color=toggle.cooldownstyle.rgb and rgb(0)or toggle.cooldownstyle.labelcolor;toggle.cooldowndraw.value.Color=toggle.cooldownvaluestyle.rgb and rgb(0)or toggle.cooldownvaluestyle.labelcolor;toggle.ppmsdraw.label.Color=toggle.ppmslabelstyle.rgb and rgb(0)or toggle.ppmslabelstyle.labelcolor;for i=1,5 do local cfg=toggle.voltmeterstyles[i];toggle.ppmsdraw.squares[i].Color=cfg.rgb and rgb((i-1)/5*rgbspread)or cfg.labelcolor end
    if toggle.hud and toggle.hudbar and(toggle.hudcount or 0)>0 then for i=1,#rgbline do local d=rgbline[i];d.Color=toggle.barrgb and Color3.fromHSV((phase+(i-1)/barseg*rgbspread)%1,0.68,1)or toggle.accentvisual();d.Visible=true end else for i=1,#rgbline do rgbline[i].Visible=false end end
    if toggle.menu then for i=1,#menurgb do local d=menurgb[i];d.Color=toggle.barrgb and Color3.fromHSV((phase+(i-1)/barseg*rgbspread)%1,0.68,1)or toggle.accentvisual();d.Visible=true end end
    toggle.powerpanel.accent.Color=toggle.barrgb and Color3.fromHSV(phase,0.68,1)or toggle.accentvisual()
    powerpos()
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
    if not toggle.esp then for i=1,#tracked do hiderec(tracked[i])end;rooflabel.Visible=false;roofhp.Visible=false;for _,entry in pairs(toggle.rakedraw)do entry.Visible=false end end
    menuupdate();if not quiet then bindlog(toggle.esp and "enabled esp"or"disabled esp")end
end
local function sethud(value,quiet)
    toggle.hud=value==true;showhud();menuupdate();if not quiet then bindlog(toggle.hud and "enabled hud"or"disabled hud")end
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
    toggle.poweractivity=value==true;powerhud();menuupdate();if not quiet then bindlog(toggle.poweractivity and"enabled power activity"or"disabled power activity")end
end
toggle.setteleportcooldown=function(value,quiet)
    toggle.teleportcooldown=value==true;if not toggle.teleportcooldown then toggle.cooldownuntil=0;toggle.cooldownremaining=0;toggle.teleporthistory={};toggle.cooldowndraw.value.Visible=false;toggle.cooldowndraw.label.Visible=false end;hudpos();showhud();menuupdate();if not quiet then bindlog(toggle.teleportcooldown and"enabled 4 TP safety cooldown"or"disabled teleport cooldown")end
end
toggle.setcooldownseconds=function(value,quiet)
    toggle.cooldownseconds=30;menuupdate();if not quiet then bindlog("teleport cooldown fixed at 30s")end
end
toggle.cooldownready=function()
    if not toggle.teleportcooldown then return true end;local now=tick();local recent={};for i=1,#toggle.teleporthistory do if now-toggle.teleporthistory[i]<30 then recent[#recent+1]=toggle.teleporthistory[i]end end;toggle.teleporthistory=recent;return now>=(toggle.cooldownuntil or 0)
end
toggle.startcooldown=function()
    if not toggle.teleportcooldown then return end;local now=tick();toggle.teleporthistory[#toggle.teleporthistory+1]=now;if #toggle.teleporthistory<4 then return end;toggle.teleporthistory={};toggle.cooldownuntil=now+30;toggle.cooldownremaining=30;toggle.cooldowndraw.value.Text="30s";toggle.cooldowndraw.value.Visible=toggle.hud;toggle.cooldowndraw.label.Visible=toggle.hud and toggle.hudlabels;hudpos()
end
toggle.setppms=function(value,quiet)
    toggle.ppms=value==true;hudpos();showhud();menuupdate();if not quiet then bindlog(toggle.ppms and"enabled power/ms indicator"or"disabled power/ms indicator")end
end
toggle.setppmsstyle=function(value,quiet)
    toggle.ppmsstyle="voltmeter";hudpos();showhud();menuupdate();if not quiet then bindlog("voltmeter style selected")end
end
toggle.setppmssquares=function(value,quiet)
    toggle.ppmssquares=5;powerhud();hudpos();showhud();menuupdate();if not quiet then bindlog("voltmeter uses 5 cells")end
end
toggle.setscrapstyle=function(value,quiet)
    toggle.scrapstyle=value=="points"and"points"or value=="tiers"and"tiers"or value=="both"and"both"or"none";local points={12,15,19,23,27}
    for i=1,5 do local label=toggle.scrapstyle=="none"and"scrap"or toggle.scrapstyle=="tiers"and("scrap "..i)or toggle.scrapstyle=="points"and("scrap [+"..points[i].."]")or("scrap "..i.." [+"..points[i].."]");local cfg=espcfg["Scrap"..tostring(i)];if cfg then cfg.text=label end end;for i=1,#tracked do local rec=tracked[i];if rec.cfgname and string.match(rec.cfgname,"^Scrap%d$")and rec.name then rec.name.Text=rec.cfg.text end end
    menuupdate();if not quiet then bindlog("scrap display set to "..toggle.scrapstyle)end
end
toggle.setsupplylabel=function(value,quiet)
    toggle.supplylabel=value==true;if not toggle.supplylabel then for i=1,#tracked do local rec=tracked[i];if rec.cfg.crate then hide(rec.name);hide(rec.distance)end end end;menuupdate();if not quiet then bindlog(toggle.supplylabel and"enabled supply label"or"disabled supply label")end
end
toggle.setsupplyitems=function(value,quiet)
    toggle.supplyitems=value==true;if not toggle.supplyitems then for i=1,#tracked do local rec=tracked[i];if rec.cfg.crate then hide(rec.bg);if rec.items then for j=1,#rec.items do hide(rec.items[j])end end end end end;menuupdate();if not quiet then bindlog(toggle.supplyitems and"enabled item viewer"or"disabled item viewer")end
end
local function setfontindex(index,quiet)
    fontindex=((math.floor(index)-1)%#fontvalues)+1;font=fontvalues[fontindex]
    local texts={rooflabel,roofhp,toggle.rakedraw.name,toggle.rakedraw.health,toggle.rakedraw.distance}
    for i=1,#texts do texts[i].Font=font end
    for i=1,#tracked do local rec=tracked[i];if rec.name then rec.name.Font=font end;if rec.distance then rec.distance.Font=font end;if rec.items then for j=1,#rec.items do rec.items[j].Font=font end end end
    menuupdate();if not quiet then bindlog("esp font set to "..fontnames[fontindex])end
end
toggle.sethudfont=function(index,quiet)
    toggle.hudfontindex=((math.floor(index)-1)%#fontvalues)+1;local selected=fontvalues[toggle.hudfontindex];local texts={timertxt,scraptxt,targettxt,timerlabel,scraplabel,targetlabel,toggle.powerdraw.value,toggle.powerdraw.label,toggle.cooldowndraw.value,toggle.cooldowndraw.label,toggle.ppmsdraw.value,toggle.ppmsdraw.label,powerlabel}
    for i=1,#texts do texts[i].Font=selected end;for i=1,#powerlines do powerlines[i].Font=selected end
    menuupdate();if not quiet then bindlog("hud font set to "..fontnames[toggle.hudfontindex])end
end
local function setthemeindex(index,quiet)
    themeindex=((math.floor(index)-1)%#themes)+1;local selected=themes[themeindex];themes.accentstyle.labelcolor=selected.accent;themes.accentstyle.rgb=false;toggle.themestyles.background.labelcolor=selected.bg;toggle.themestyles.topbar.labelcolor=selected.top;toggle.themestyles.border.labelcolor=selected.select;toggle.themestyles.outline.labelcolor=selected.muted;toggle.themestyles.text.labelcolor=selected.text;menuupdate();if not quiet then bindlog("preset set to "..selected.name)end
end
local function setfontsize(value,quiet)
    espfontsize=math.floor(clamp(tonumber(value)or espfontsize,13,20)+0.5)
    rooflabel.Size=espfontsize;roofhp.Size=espfontsize;toggle.rakedraw.name.Size=espfontsize;toggle.rakedraw.health.Size=espfontsize;toggle.rakedraw.distance.Size=espfontsize;for i=1,#tracked do if tracked[i].name then tracked[i].name.Size=espfontsize end;if tracked[i].distance then tracked[i].distance.Size=espfontsize end end
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
toggle.applypickerhex=function(quiet)
    local value=string.upper(string.gsub(tostring(picker.hexvalue or""),"[^%x]",""))
    if #value~=6 then if not quiet then bindlog("enter a 6-digit hex color")end;return false end
    local ok,result=pcall(function()return Color3.fromHex("#"..value)end)
    if not ok or not result then if not quiet then bindlog("invalid hex color")end;return false end
    picker.hexvalue=value;setlabelcolor(pickerentry,result);toggle.pushrecent(result);return true
end
local function setringsegments(value,quiet)
    local nextvalue=math.floor(clamp(tonumber(value)or ringseg,10,100)+0.5)
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
    toggle.powerformat=(value=="value"or value=="full")and"value"or"percent";menuupdate();if not quiet then bindlog("power format set to "..toggle.powerformat)end
end
toggle.setpowerdecimal=function(value,quiet)
    toggle.powerdecimal=value==true;menuupdate();if not quiet then bindlog(toggle.powerdecimal and"enabled decimal power"or"disabled decimal power")end
end
toggle.settimerformat=function(value,quiet)
    toggle.timerformat=value=="seconds"and"seconds"or"clock";timerhud();menuupdate();if not quiet then bindlog("timer format set to "..toggle.timerformat)end
end
toggle.settimerwarning=function(value,quiet)
    toggle.timerwarning=math.floor(clamp(tonumber(value)or toggle.timerwarning,10,45)+0.5);menuupdate();if not quiet then bindlog("timer warning set to "..tostring(toggle.timerwarning).."s")end
end
local function setbind(id,code)
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
    local colors={};local accent=themes.accentstyle.labelcolor;local special={};local themecolors={};local crateitemcolors={};local recentcolors={};local voltmetercolors={}
    for i=1,#colorentries do local cfg=entrycfg(i);local c=cfg.labelcolor;colors[i]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for _,id in ipairs({"distance","rake","rakehealth","rakebar","roof","hudtimer","hudtarget","hudscrap","hudpower","cooldownlabel","cooldownvalue","ppmslabel","ppmsvalue","valuetimer","valuetarget","valuescrap","valuepower","timerwarning"})do local cfg=entrycfg(id);local c=cfg.labelcolor;special[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for _,id in ipairs({"themebg","themetop","themeborder","themeoutline","themetext"})do local cfg=entrycfg(id);local c=cfg.labelcolor;themecolors[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B)}end
    for id,cfg in pairs(toggle.cratestyles)do local c=cfg.labelcolor;crateitemcolors[id]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for i=1,5 do local cfg=toggle.voltmeterstyles[i];local c=cfg.labelcolor;voltmetercolors[i]={r=channel(c.R),g=channel(c.G),b=channel(c.B),rgb=cfg.rgb==true}end
    for i=1,#picker.recentcolors do local c=picker.recentcolors[i];recentcolors[i]={r=channel(c.R),g=channel(c.G),b=channel(c.B)}end
    return {menu_default_version=4,font=fontindex,esp_font=fontindex,hud_font=toggle.hudfontindex,font_size=espfontsize,preset=themeindex,preset_schema=4,theme_schema=4,rgb_defaults_schema=2,preset_name=themes[themeindex].name,accent={r=channel(accent.R),g=channel(accent.G),b=channel(accent.B)},theme_colors=themecolors,recent_colors=recentcolors,gui_opacity=guiopacity,watermark=toggle.watermark,watermark_hint=toggle.watermarkhint,hud_bar=toggle.hudbar,hud_labels=toggle.hudlabels,distance_minimum=toggle.distanceminimum,distance_min=toggle.distancemin,health_based=toggle.healthbased,ring_enabled=toggle.ringenabled,ring_shape=toggle.ringshape,ring_segments=ringseg,ring_fade=ringfade,ring_size=toggle.ringsize,ring_spin=toggle.ringspin,ring_spin_speed=toggle.ringspinspeed,esp=toggle.esp,hud=toggle.hud,hud_elements=toggle.hudelements,power_activity=toggle.poweractivity,power_panel={x=toggle.powerpanel.x,y=toggle.powerpanel.y},roof_hp=toggle.roof,rake_name_enabled=toggle.rakename,rake_health_enabled=toggle.rakehealth,rake_name=toggle.rakenamevalue,rake_name_y=toggle.rakenamey,rake_health_y=toggle.rakehealthy,rake_health_format=toggle.rakehealthformat,rake_health_bar_width=toggle.rakebarwidth,bar_rgb=toggle.barrgb,rgb_direction=toggle.rgbdirection,rgb_speed=rgbspeed,power_format=toggle.powerformat,power_decimal=toggle.powerdecimal,timer_format=toggle.timerformat,timer_warning_enabled=toggle.timerwarningenabled,timer_warning=toggle.timerwarning,teleport_cooldown=toggle.teleportcooldown,ppms=toggle.ppms,voltmeter_colors=voltmetercolors,distance=toggle.distance,distance_position=toggle.distanceposition,scrap_style=toggle.scrapstyle,supply_label=toggle.supplylabel,supply_items=toggle.supplyitems,esp_groups=espgroups,esp_items=espgroups.items,colors=colors,special_colors=special,crate_item_colors=crateitemcolors,binds=keybinds,menu={x=menustate.x,y=menustate.y,minimized=menustate.minimized}}
end
local function saveconfig()
    configname=toggle.cleanconfig(configname);local ok=pcall(function()makefolder("therakesaint");writefile(configpath(),http:JSONEncode(configdata()))end);if ok then toggle.refreshconfigs(configname);menuupdate()end
    bindlog(ok and"saved "..configname or"failed to save config")
end
local function loadconfig(quiet)
    if not isfile(configpath())then if not quiet then bindlog("no saved config")end;return false end
    local ok,data=pcall(function()return http:JSONDecode(readfile(configpath()))end)
    if not ok or type(data)~="table"then if not quiet then bindlog("failed to load config")end;return false end
    if type(data.esp_font)=="number"then setfontindex(clamp(data.esp_font,1,#fontvalues),true)elseif type(data.font)=="number"then setfontindex(clamp(data.font,1,#fontvalues),true)end
    if type(data.hud_font)=="number"then toggle.sethudfont(clamp(data.hud_font,1,#fontvalues),true)elseif type(data.font)=="number"then toggle.sethudfont(clamp(data.font,1,#fontvalues),true)end
    if type(data.font_size)=="number"then setfontsize(data.font_size,true)end
    local savedpreset=data.preset or data.theme;local removedlight,removedgabe=false,false
    if(data.preset_schema==nil or data.preset_schema==1)and type(savedpreset)=="number"then removedlight=savedpreset==2 or savedpreset==6 or savedpreset==10;savedpreset=({1,1,2,3,4,4,5,6,7,7,8,9})[math.floor(savedpreset)]or 5 end
    if data.preset_schema==3 and type(savedpreset)=="number"then if savedpreset==10 then savedpreset=5;removedgabe=true elseif savedpreset>10 then savedpreset=savedpreset-1 end end
    if type(data.preset_name)=="string"then local wanted=({["catppuccin mocha"]="amethyst",dracula="blood moon",["tokyo night"]="midnight",["gruvbox dark"]="ember",nord="glacier",["solarized dark"]="deep sea",["one dark"]="graphite",["rose pine"]="rose noir",gabescripts="gamesense"})[data.preset_name]or data.preset_name;if data.preset_name=="gabescripts"then removedgabe=true end;for i=1,#themes do if themes[i].name==wanted then savedpreset=i;break end end end
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
    for key,id in pairs({hud_bar="hudbar",hud_labels="hudlabels",distance_minimum="distanceminimum",health_based="healthbased"})do if type(data[key])=="boolean"then toggle[id]=data[key]end end
    if type(data.distance_min)=="number"then toggle.distancemin=math.floor(clamp(data.distance_min,0,100)+0.5)end
    if type(data.gui_opacity)=="number"then setguiopacity(data.gui_opacity,true)end
    if type(data.ring_enabled)=="boolean"then toggle.setringenabled(data.ring_enabled,true)end
    if data.ring_shape=="circle"or data.ring_shape=="square"or data.ring_shape=="triangle"then toggle.setringshape(data.ring_shape,true)end
    if type(data.ring_segments)=="number"then setringsegments(data.ring_segments,true)end
    if type(data.ring_fade)=="number"then toggle.setringfade(data.ring_fade,true)end
    if type(data.ring_size)=="number"then toggle.setringsize(data.ring_size,true)end
    if type(data.ring_spin)=="boolean"then toggle.setringspin(data.ring_spin,true)end
    if type(data.ring_spin_speed)=="number"then toggle.setringspinspeed(data.ring_spin_speed,true)end
    if type(data.esp)=="boolean"then setesp(data.esp,true)end
    if type(data.hud)=="boolean"then sethud(data.hud,true)end
    if type(data.hud_elements)=="table"then for _,id in ipairs({"timer","target","scrap","power"})do if type(data.hud_elements[id])=="boolean"then toggle.sethudelement(id,data.hud_elements[id],true)end end end
    if type(data.power_activity)=="boolean"then toggle.setpoweractivity(data.power_activity,true)end
    if type(data.power_panel)=="table"then if type(data.power_panel.x)=="number"then toggle.powerpanel.x=data.power_panel.x end;if type(data.power_panel.y)=="number"then toggle.powerpanel.y=data.power_panel.y end end
    if type(data.roof_hp)=="boolean"then toggle.setroof(data.roof_hp,true)end
    if type(data.rake_name_enabled)=="boolean"then toggle.setrakename(data.rake_name_enabled,true)end
    if type(data.rake_health_enabled)=="boolean"then toggle.setrakehealth(data.rake_health_enabled,true)end
    if type(data.rake_name)=="string"then toggle.rakenamevalue=toggle.cleanrakename(data.rake_name);toggle.rakedraw.name.Text=toggle.rakenamevalue end
    if type(data.rake_name_y)=="number"then toggle.setrakenamey(data.rake_name_y,true)end
    if type(data.rake_health_y)=="number"then toggle.setrakehealthy(data.rake_health_y,true)end
    if data.rake_health_format=="value"or data.rake_health_format=="bar"then toggle.setrakehealthformat(data.rake_health_format,true)else toggle.setrakehealthformat("value",true)end
    if type(data.rake_health_bar_width)=="number"then toggle.setrakebarwidth(data.rake_health_bar_width,true)end
    if type(data.bar_rgb)=="boolean"then setbarrgb(data.bar_rgb,true)end
    if data.rgb_defaults_schema~=2 then toggle.setrgbdirection("left",true);toggle.setrgbspeed(0.6,true)else if data.rgb_direction=="left"or data.rgb_direction=="right"then toggle.setrgbdirection(data.rgb_direction,true)end;if type(data.rgb_speed)=="number"then toggle.setrgbspeed(data.rgb_speed,true)end end
    if data.power_format=="decimal"then
        toggle.setpowerformat("percent",true);if type(data.power_decimal)=="boolean"then toggle.setpowerdecimal(data.power_decimal,true)else toggle.setpowerdecimal(true,true)end
    elseif data.power_format=="percent"then
        toggle.setpowerformat("percent",true);if type(data.power_decimal)=="boolean"then toggle.setpowerdecimal(data.power_decimal,true)else toggle.setpowerdecimal(false,true)end
    elseif data.power_format=="full"or data.power_format=="value"then
        toggle.setpowerformat("value",true);if type(data.power_decimal)=="boolean"then toggle.setpowerdecimal(data.power_decimal,true)end
    elseif type(data.power_decimal)=="boolean"then toggle.setpowerdecimal(data.power_decimal,true)end
    if data.timer_format=="clock"or data.timer_format=="seconds"then toggle.settimerformat(data.timer_format,true)end
    if type(data.timer_warning_enabled)=="boolean"then toggle.timerwarningenabled=data.timer_warning_enabled end
    if type(data.timer_warning)=="number"then toggle.settimerwarning(data.timer_warning,true)end
    if type(data.teleport_cooldown)=="boolean"then toggle.setteleportcooldown(data.teleport_cooldown,true)end
    toggle.setcooldownseconds(30,true);toggle.setppmsstyle("voltmeter",true);toggle.setppmssquares(5,true)
    if type(data.ppms)=="boolean"then toggle.setppms(data.ppms,true)end
    local saveddistance=data.distance;if type(saveddistance)~="boolean"then saveddistance=data.meters end;if type(saveddistance)=="boolean"then setdistance(saveddistance,true)end
    toggle.setunit("meters",true)
    if data.distance_position=="under"or data.distance_position=="below"or data.distance_position=="above"then toggle.setdistanceposition(data.distance_position,true)end
    toggle.distancefade=false;if data.scrap_style=="none"or data.scrap_style=="both"or data.scrap_style=="tiers"or data.scrap_style=="points"then toggle.setscrapstyle(data.scrap_style,true)else toggle.setscrapstyle("none",true)end
    if type(data.supply_label)=="boolean"then toggle.setsupplylabel(data.supply_label,true)end;if type(data.supply_items)=="boolean"then toggle.setsupplyitems(data.supply_items,true)end
    espgroups.locations=true;espgroups.crates=true;if type(data.esp_groups)=="table"then for _,id in ipairs({"scraps","traps","flares","rake"})do if type(data.esp_groups[id])=="boolean"then setgroup(id,data.esp_groups[id],true)end end end
    if type(data.esp_items)=="table"then for id in pairs(espgroups.items)do if not string.match(id,"^Scrap%d$")and type(data.esp_items[id])=="boolean"then toggle.setitem(id,data.esp_items[id],true)end end end
    if type(data.colors)=="table"then
        for i=1,#colorentries do local saved=data.colors[i];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(i,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb(i,saved.rgb,true)end end end
    end
    if type(data.special_colors)=="table"then for _,id in ipairs({"distance","rake","rakehealth","rakebar","roof","hudtimer","hudtarget","hudscrap","hudpower","cooldownlabel","cooldownvalue","ppmslabel","ppmsvalue","valuetimer","valuetarget","valuescrap","valuepower","timerwarning"})do local saved=data.special_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor(id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb(id,saved.rgb,true)end end end end
    if type(data.crate_item_colors)=="table"then for id in pairs(toggle.cratestyles)do local saved=data.crate_item_colors[id];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor("crate_"..id,Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb("crate_"..id,saved.rgb,true)end end end end
    if type(data.voltmeter_colors)=="table"then for i=1,5 do local saved=data.voltmeter_colors[i];if type(saved)=="table"and type(saved.r)=="number"and type(saved.g)=="number"and type(saved.b)=="number"then setlabelcolor("volt"..tostring(i),Color3.fromRGB(clamp(saved.r,0,255),clamp(saved.g,0,255),clamp(saved.b,0,255)));if type(saved.rgb)=="boolean"then setlabelrgb("volt"..tostring(i),saved.rgb,true)end end end end
    if type(data.binds)=="table"then
        local used,nextbinds,valid={},{},true
        for i=1,#bindorder do local id=bindorder[i];local code=tonumber(data.binds[id])or keybinds[id];if id=="menu"and data.menu_default_version==nil and code==0xBB then code=defaultbinds.menu end;if not keynames[code]or used[code]then valid=false else used[code]=true;nextbinds[id]=code end end
        if valid then keybinds=nextbinds end
    end
    if type(data.watermark)=="boolean"then toggle.watermark=data.watermark end;if type(data.watermark_hint)=="boolean"then toggle.watermarkhint=data.watermark_hint end;if type(data.menu)=="table"then if type(data.menu.x)=="number"then menustate.x=data.menu.x end;if type(data.menu.y)=="number"then menustate.y=data.menu.y end;if type(data.menu.minimized)=="boolean"and toggle.watermark then menustate.minimized=data.menu.minimized else menustate.minimized=false end end
    powerpos();menupos();menuupdate();if not quiet then bindlog("loaded config")end;return true
end
toggle.resetcolors=function(quiet)
    for _,cfg in pairs(espcfg)do cfg.color=cfg.defaultcolor;cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    roofstyle.labelcolor=roofstyle.defaultcolor;roofstyle.rgb=roofstyle.defaultrgb;toggle.distancestyle.labelcolor=toggle.distancestyle.defaultcolor;toggle.distancestyle.rgb=toggle.distancestyle.defaultrgb;toggle.rakestyle.labelcolor=toggle.rakestyle.defaultcolor;toggle.rakestyle.rgb=toggle.rakestyle.defaultrgb;toggle.rakehealthstyle.labelcolor=toggle.rakehealthstyle.defaultcolor;toggle.rakehealthstyle.rgb=toggle.rakehealthstyle.defaultrgb;toggle.rakebarstyle.labelcolor=toggle.rakebarstyle.defaultcolor;toggle.rakebarstyle.rgb=toggle.rakebarstyle.defaultrgb;toggle.cooldownstyle.labelcolor=toggle.cooldownstyle.defaultcolor;toggle.cooldownstyle.rgb=toggle.cooldownstyle.defaultrgb;toggle.cooldownvaluestyle.labelcolor=toggle.cooldownvaluestyle.defaultcolor;toggle.cooldownvaluestyle.rgb=toggle.cooldownvaluestyle.defaultrgb;toggle.ppmslabelstyle.labelcolor=toggle.ppmslabelstyle.defaultcolor;toggle.ppmslabelstyle.rgb=toggle.ppmslabelstyle.defaultrgb;toggle.ppmsvaluestyle.labelcolor=toggle.ppmsvaluestyle.defaultcolor;toggle.ppmsvaluestyle.rgb=toggle.ppmsvaluestyle.defaultrgb
    for _,cfg in pairs(toggle.hudstyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    for _,cfg in pairs(toggle.hudvalues)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    for _,cfg in pairs(toggle.cratestyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=false end;for _,cfg in ipairs(toggle.voltmeterstyles)do cfg.labelcolor=cfg.defaultcolor;cfg.rgb=cfg.defaultrgb end
    themes.accentstyle.labelcolor=themes[themeindex].accent;themes.accentstyle.rgb=false;picker.recentcolors={Color3.fromHex("#a2ff00"),Color3.fromHex("#ffffff"),Color3.fromHex("#ff6b6b"),Color3.fromHex("#78b7e6"),Color3.fromHex("#b283d3"),Color3.fromHex("#000000")};menuupdate();if not quiet then bindlog("reset colors")end
end
toggle.resettheme=function(quiet)
    setthemeindex(5,true);setguiopacity(0.95,true);menuupdate();if not quiet then bindlog("reset theme")end
end
toggle.resettoggles=function(quiet)
    setesp(true,true);sethud(true,true);for _,id in ipairs({"timer","scrap","power"})do toggle.sethudelement(id,true,true)end;toggle.sethudelement("target",false,true);toggle.watermark=true;toggle.watermarkhint=true;toggle.hudbar=true;toggle.hudlabels=true;toggle.distanceminimum=false;toggle.distancemin=20;toggle.healthbased=false;toggle.setpoweractivity(true,true);toggle.cooldownuntil=0;toggle.cooldownremaining=0;toggle.teleporthistory={};toggle.setteleportcooldown(false,true);toggle.setcooldownseconds(30,true);toggle.setppms(false,true);toggle.setppmsstyle("voltmeter",true);toggle.setppmssquares(5,true);toggle.setroof(false,true);toggle.setrakename(true,true);toggle.setrakehealth(true,true);toggle.rakenamevalue="rake";toggle.rakedraw.name.Text="rake";toggle.setrakenamey(0,true);toggle.setrakehealthy(0,true);toggle.setrakehealthformat("value",true);toggle.setrakebarwidth(70,true);setbarrgb(true,true);toggle.setrgbdirection("left",true);toggle.setrgbspeed(0.6,true);setdistance(false,true);toggle.distancefade=false;toggle.setunit("meters",true);toggle.setdistanceposition("below",true);toggle.setscrapstyle("none",true);toggle.setsupplylabel(true,true);toggle.setsupplyitems(true,true);toggle.setringenabled(true,true);toggle.setringshape("circle",true);toggle.setringfade(40,true);toggle.setringsize(1,true);toggle.setringspin(false,true);toggle.setringspinspeed(1,true);toggle.setpowerformat("percent",true);toggle.setpowerdecimal(true,true);toggle.settimerformat("clock",true);toggle.timerwarningenabled=false;toggle.settimerwarning(15,true)
    for _,id in ipairs({"locations","scraps","traps","flares","crates","rake"})do setgroup(id,true,true)end;for id in pairs(espgroups.items)do toggle.setitem(id,true,true)end
    menuupdate();if not quiet then bindlog("reset toggles")end
end
toggle.resetbinds=function(quiet)
    keybinds={menu=defaultbinds.menu,esp=defaultbinds.esp,hud=defaultbinds.hud,scrap=defaultbinds.scrap,flare=defaultbinds.flare};capture=nil;menuupdate();if not quiet then bindlog("reset binds")end
end
local function resetsettings()
    toggle.resettheme(true);toggle.resetcolors(true);toggle.resettoggles(true);toggle.resetbinds(true);setfontindex(1,true);toggle.sethudfont(1,true);setfontsize(13,true);setringsegments(100,true)
    local v=cam.ViewportSize;menustate.x=24;menustate.y=math.floor((v.Y-menustate.h)/2);menustate.minimized=false;toggle.powerpanel.x=math.max(2,v.X-toggle.powerpanel.defaultoffsetx);toggle.powerpanel.y=math.max(2,v.Y-toggle.powerpanel.defaultoffsety);capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;configcapture=false;toggle.rakenamecapture=false
    powerpos();menupos();menuupdate();bindlog("reset all settings")
end
local function runaction(id)
    if id=="menu"then if toggle.rakenamecapture then toggle.finishrakename(false)end;if toggle.watermark then toggle.menu=true;menustate.minimized=not menustate.minimized else toggle.menu=not toggle.menu;menustate.minimized=false end;capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;configcapture=false;showmenu();bindlog(not toggle.menu and"closed menu"or menustate.minimized and"watermark state"or"expanded menu")
    elseif id=="esp"then setesp(not toggle.esp)
    elseif id=="hud"then sethud(not toggle.hud)
    elseif id=="scrap"or id=="flare"then
        if not toggle.cooldownready()then bindlog("teleport cooldown: "..tostring(math.max(1,math.ceil(toggle.cooldownuntil-tick()))).."s");return end
        local ok=false;if id=="scrap"then ok=tpscrap()else ok=tpflare()end;if ok then toggle.startcooldown()end;bindlog(ok and"teleported to "..id or id.." not found")
    end
end
local inputstate={dragging=false,sliding=nil,scrolling=nil,powerdragging=false,mouseheld=false,dragx=0,dragy=0,powerdragx=0,powerdragy=0,scrolly=0,scrollstart=0,wheel=0}
pcall(function()mouse.WheelForward:Connect(function()inputstate.wheel=inputstate.wheel-1 end);mouse.WheelBackward:Connect(function()inputstate.wheel=inputstate.wheel+1 end)end)
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
    elseif inputstate.sliding=="ring"then setringsegments(value,quiet)
    elseif inputstate.sliding=="fontsize"then setfontsize(value,quiet)
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
    elseif inputstate.sliding=="opacity"then setguiopacity(value,quiet)end
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
        for i=1,#dropdownlayouts do
            local layout=dropdownlayouts[i]
            if inside(mx,my,layout.x,layout.y,layout.w,layout.h)then
                local kind=dropdownkind;dropdownkind=nil
                if kind=="espfont"then setfontindex(layout.index)
                elseif kind=="hudfont"then toggle.sethudfont(layout.index)
                elseif kind=="preset"then setthemeindex(layout.index)
                elseif kind=="unit"then toggle.setunit(layout.value)
                elseif kind=="distanceposition"then toggle.setdistanceposition(layout.value)
                elseif kind=="scrapstyle"then toggle.setscrapstyle(layout.value)
                elseif kind=="ringshape"then toggle.setringshape(layout.value)
                elseif kind=="rgbdirection"then toggle.setrgbdirection(layout.value)
                elseif kind=="powerformat"then toggle.setpowerformat(layout.value)
                elseif kind=="timerformat"then toggle.settimerformat(layout.value)
                elseif kind=="ppmsstyle"then toggle.setppmsstyle(layout.value)
                elseif kind=="rakehealthformat"then toggle.setrakehealthformat(layout.value)
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
        if inside(mx,my,menustate.x+4+(i-1)*tabw,menustate.y+29,tabw,18)then if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end;if i~=menustate.tab then menustate.tabslide=i>menustate.tab and 10 or-10;menustate.tabfade=0 end;menustate.tab=i;capture=nil;pickerentry=nil;picker.hexactive=false;dropdownkind=nil;menuupdate();return end
    end
    for i=1,#itemlayouts do
        local layout=itemlayouts[i];local item=layout.item
        if layout.visible and item.kind~="section"and inside(mx,my,layout.x,layout.hittop,layout.w,layout.hitbottom-layout.hittop)then
            if configcapture and item.id~="configname"then toggle.finishconfiginput(false)end
            if toggle.rakenamecapture and item.id~="rakenameinput"then toggle.finishrakename(false)end
            if item.kind=="toggle"then
                if item.id=="hudbar"or item.id=="hudlabels"or item.id=="distanceminimum"or item.id=="healthbased"or item.id=="timerwarningenabled"or item.id=="watermarkhint"then toggle[item.id]=not toggle[item.id];timerhud();showhud();menuupdate()elseif item.itemkey then toggle.setitem(item.itemkey,not espgroups.items[item.itemkey])elseif item.id=="esp"then setesp(not toggle.esp)elseif item.id=="hud"then sethud(not toggle.hud)elseif item.id=="hudtimer"then toggle.sethudelement("timer",not toggle.hudelements.timer)elseif item.id=="hudtarget"then toggle.sethudelement("target",not toggle.hudelements.target)elseif item.id=="hudscrap"then toggle.sethudelement("scrap",not toggle.hudelements.scrap)elseif item.id=="hudpower"then toggle.sethudelement("power",not toggle.hudelements.power)elseif item.id=="roof"then toggle.setroof(not toggle.roof)elseif item.id=="rakename"then toggle.setrakename(not toggle.rakename)elseif item.id=="rakehealth"then toggle.setrakehealth(not toggle.rakehealth)elseif item.id=="powerdecimal"then toggle.setpowerdecimal(not toggle.powerdecimal)elseif item.id=="poweractivity"then toggle.setpoweractivity(not toggle.poweractivity)elseif item.id=="teleportcooldown"then toggle.setteleportcooldown(not toggle.teleportcooldown)elseif item.id=="ppms"then toggle.setppms(not toggle.ppms)elseif item.id=="watermark"then toggle.watermark=not toggle.watermark;if not toggle.watermark then menustate.minimized=false end;menuupdate();bindlog(toggle.watermark and"enabled watermark state"or"disabled watermark state")elseif item.id=="barrgb"then setbarrgb(not toggle.barrgb)elseif item.id=="distance"then setdistance(not toggle.distance)elseif item.id=="supplylabel"then toggle.setsupplylabel(not toggle.supplylabel)elseif item.id=="supplyitems"then toggle.setsupplyitems(not toggle.supplyitems)elseif item.id=="ringenabled"then toggle.setringenabled(not toggle.ringenabled)elseif item.id=="ringspin"then toggle.setringspin(not toggle.ringspin)else setgroup(item.id,not espgroups[item.id])end
            elseif item.kind=="action"then
                if item.id=="scrap"or item.id=="flare"then runaction(item.id)elseif item.id=="save"then saveconfig()elseif item.id=="load"then loadconfig(false)elseif item.id=="resetcolors"then toggle.resetcolors(false)elseif item.id=="resettheme"then toggle.resettheme(false)elseif item.id=="resettoggles"then toggle.resettoggles(false)elseif item.id=="resetbinds"then toggle.resetbinds(false)elseif item.id=="reset"then resetsettings()end
            elseif item.kind=="dropdown"then
                dropdownkind=item.id=="espfontselect"and"espfont"or item.id=="hudfontselect"and"hudfont"or item.id=="presetselect"and"preset"or item.id=="distanceunitselect"and"unit"or item.id=="distancepositionselect"and"distanceposition"or item.id=="scrapstyleselect"and"scrapstyle"or item.id=="ringshapeselect"and"ringshape"or item.id=="rgbdirectionselect"and"rgbdirection"or item.id=="powerformatselect"and"powerformat"or item.id=="timerformatselect"and"timerformat"or item.id=="ppmsstyleselect"and"ppmsstyle"or item.id=="rakehealthformatselect"and"rakehealthformat"or"config";dropdown.opened=false;capture=nil;menuupdate()
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
        if inputstate.wheel~=0 then if not menustate.minimized and inside(mx,my,menustate.x+6,menustate.y+52,menustate.w-12,menustate.h-56)then menustate.scrolltarget[menustate.tab]=clamp((menustate.scrolltarget[menustate.tab]or 0)+inputstate.wheel*42,0,menustate.scrollmax[menustate.tab]or 0);dropdownkind=nil end;inputstate.wheel=0 end
        if pressed then
            local displayw=displaysize()
            if pickerentry or dropdownkind then clickmenu(mx,my)
            elseif inside(mx,my,menustate.x,menustate.y,displayw,27)and not inside(mx,my,menustate.x+displayw-28,menustate.y,28,27)then if configcapture then toggle.finishconfiginput(false)end;if toggle.rakenamecapture then toggle.finishrakename(false)end;inputstate.dragging=true;inputstate.dragx=mx-menustate.x;inputstate.dragy=my-menustate.y
            elseif not menustate.minimized and(menustate.scrollmax[menustate.tab]or 0)>0 and menustate.scrollthumb and inside(mx,my,menustate.scrollthumb.x,menustate.scrollthumb.y,menustate.scrollthumb.w,menustate.scrollthumb.h)then inputstate.scrolling="thumb";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]or 0
            elseif not menustate.minimized and(menustate.scrollmax[menustate.tab]or 0)>0 and menustate.scrollthumb and inside(mx,my,menustate.scrollthumb.x,menustate.scrollthumb.tracky,menustate.scrollthumb.w,menustate.scrollthumb.trackh)then local travel=menustate.scrollthumb.trackh-menustate.scrollthumb.thumbh;menustate.scrolltarget[menustate.tab]=clamp((my-menustate.scrollthumb.tracky-menustate.scrollthumb.thumbh/2)/math.max(1,travel)*(menustate.scrollmax[menustate.tab]or 0),0,menustate.scrollmax[menustate.tab]or 0);inputstate.scrolling="thumb";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]
            else local occupied=false;if not menustate.minimized then for i=1,#itemlayouts do local l=itemlayouts[i];if l.visible and l.item.kind~="section"and inside(mx,my,l.x,l.hittop,l.w,l.hitbottom-l.hittop)then occupied=true;break end end end;if not occupied and not menustate.minimized and inside(mx,my,menustate.x+6,menustate.y+52,menustate.w-12,menustate.h-56)and(menustate.scrollmax[menustate.tab]or 0)>0 then inputstate.scrolling="content";inputstate.scrolly=my;inputstate.scrollstart=menustate.scrolltarget[menustate.tab]or 0 else clickmenu(mx,my)end end
        end
        if down and inputstate.dragging then menustate.x=mx-inputstate.dragx;menustate.y=my-inputstate.dragy;menupos()end
        if down and inputstate.scrolling then if inputstate.scrolling=="content"then menustate.scrolltarget[menustate.tab]=clamp(inputstate.scrollstart-(my-inputstate.scrolly),0,menustate.scrollmax[menustate.tab]or 0)else local thumb=menustate.scrollthumb;local travel=thumb and thumb.trackh-thumb.thumbh or 0;menustate.scrolltarget[menustate.tab]=clamp(inputstate.scrollstart+(my-inputstate.scrolly)/math.max(1,travel)*(menustate.scrollmax[menustate.tab]or 0),0,menustate.scrollmax[menustate.tab]or 0)end end
        if down and inputstate.sliding then sliderapply(mx,my,true)end
        menuupdate()
    end
    local p=toggle.powerpanel;local mw,mh=displaysize();local panelblocked=pickerentry~=nil or dropdownkind~=nil or toggle.menu and inside(mx,my,menustate.x,menustate.y,mw,mh)
    if pressed and not panelblocked and p.bg.Visible and inside(mx,my,p.x,p.y,p.w,24)then inputstate.powerdragging=true;inputstate.powerdragx=mx-p.x;inputstate.powerdragy=my-p.y end
    if down and inputstate.powerdragging then p.x=mx-inputstate.powerdragx;p.y=my-inputstate.powerdragy;powerpos()end
    if not down then
        if inputstate.sliding=="ring"then bindlog("ring quality set to "..tostring(ringseg))elseif inputstate.sliding=="fontsize"then bindlog("font size set to "..tostring(espfontsize))elseif inputstate.sliding=="ringfade"then bindlog("ring distance updated")elseif inputstate.sliding=="ringsize"then bindlog("ring size set to "..string.format("%.1fx",toggle.ringsize))elseif inputstate.sliding=="ringspinspeed"then bindlog("ring spin speed updated")elseif inputstate.sliding=="rgbspeed"then bindlog("rainbow speed updated")elseif inputstate.sliding=="timerwarning"then bindlog("timer warning set to "..tostring(toggle.timerwarning).."s")elseif inputstate.sliding=="rakenamey"then bindlog("rake name Y offset set to "..tostring(toggle.rakenamey).."px")elseif inputstate.sliding=="rakehealthy"then bindlog("rake health Y offset set to "..tostring(toggle.rakehealthy).."px")elseif inputstate.sliding=="rakebarwidth"then bindlog("rake health bar width set to "..tostring(toggle.rakebarwidth).."px")elseif inputstate.sliding=="opacity"then bindlog("GUI opacity set to "..tostring(math.floor(guiopacity*100+0.5)).."%")elseif(inputstate.sliding=="pickersquare"or inputstate.sliding=="pickerhue")and pickerentry then bindlog("updated "..toggle.colorname(pickerentry).." color")end
        inputstate.dragging=false;inputstate.sliding=nil;inputstate.scrolling=nil;inputstate.powerdragging=false
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
    drawroof();toggle.drawrake(viewer)
end
toggle.lastviewport=cam.ViewportSize
spawn(function()
    while true do
        local v=cam.ViewportSize
        if v.X~=toggle.lastviewport.X or v.Y~=toggle.lastviewport.Y then toggle.lastviewport=v;hudpos();menupos()end
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
toggle.setscrapstyle(toggle.scrapstyle,true)
toggle.refreshconfigs("default")
if not loadconfig(true)then pcall(function()makefolder("therakesaint");writefile(configpath(),http:JSONEncode(configdata()))end);toggle.refreshconfigs(configname)end
showhud();showmenu()
print("rake's saint")
