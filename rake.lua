local Players,ReplicatedStorage=game:GetService("Players"),game:GetService("ReplicatedStorage")
local lp=Players.LocalPlayer; local vs="2.2.3 [02/21]"
local workspace,Drawing,WorldToScreen,ipairs,pairs,task=workspace,Drawing,WorldToScreen,ipairs,pairs,task
local toggle={esp=true,hud=true}; local keyHeld={f1=false,f2=false}
local function newText(p)local t=Drawing.new("Text");for k,v in pairs(p)do t[k]=v end;return t end
local FONT=Drawing.Fonts.System
local function T(p)p.Font=FONT; p.Outline=true; return newText(p) end

local TimerValue=ReplicatedStorage:WaitForChild("Timer")
local pwrValue=ReplicatedStorage:WaitForChild("PowerValues")
local PPMS=pwrValue:WaitForChild("PPMS")
local RadioChannel=ReplicatedStorage:WaitForChild("RadioChannel")
local StationPower=ReplicatedStorage:WaitForChild("StationPower")

local pSM={UsingSHDoor="House door is locked",UsingSHLight="House lights are on",UsingTowerLight="Tower floodlights are on",UsingTowerRadar="Tower radar is active"}

local cam=workspace.CurrentCamera
local function anc() local v=cam.ViewportSize; return Vector2.new(v.X/2,v.Y-80),Vector2.new(70,v.Y-240),Vector2.new(v.X-200,v.Y-100) end

local timerText=T{Center=true,Size=21,Color=Color3.fromHex("#ffffff"),Text="0:00",Visible=true}
local ppmsText=T{Center=true,Size=21,Color=Color3.fromHex("#ffffff"),Text="0.00",Visible=true}
local targetPlayerText=T{Center=true,Size=19,Color=Color3.fromHex("#ffffff"),Text="None",Visible=true}
local targetTitle=T{Center=true,Size=15,Color=Color3.fromHex("#c44b4b"),Text="RAKE'S TARGET",Visible=true}
local timerLabel=T{Center=true,Size=15,Color=Color3.fromHex("#eeeeee"),Text="TIME LEFT",Visible=true}
local ppmsLabel=T{Center=true,Size=15,Color=Color3.fromHex("#ffce8f"),Text="POWER USE",Visible=true}
local pwrLabel=T{Center=false,Size=22,Color=Color3.fromHex("#ffce8f"),Text="POWER ACTIVITY",Visible=false}
local powerLines,pwrLH={},18
for k,v in pairs(pSM)do powerLines[k]=T{Center=false,Size=15,Color=Color3.fromHex("#ffffff"),Text=v,Visible=false} end

local radioTitle=T{Center=false,Size=22,Color=Color3.fromHex("#cbffcf"),Text="RADIO ACTIVITY",Visible=true}
local radLine={}; local LINE_H=20
for i=1,7 do radLine[i]={name=T{Center=false,Size=13,Color=Color3.fromHex("#b6b6b6"),Text="",Visible=true},msg=T{Center=false,Size=13,Color=Color3.fromHex("#ffffff"),Text="",Visible=true}} end

local hudObjects={timerText,ppmsText,timerLabel,ppmsLabel,radioTitle,targetTitle,targetPlayerText}
for i=1,7 do hudObjects[#hudObjects+1]=radLine[i].name; hudObjects[#hudObjects+1]=radLine[i].msg end

function upPwrPos() local _,_,r=anc(); pwrLabel.Position=r-Vector2.new(50,0); local off=0; for _,line in pairs(powerLines)do if line.Visible then off=off+1; line.Position=pwrLabel.Position-Vector2.new(0,off*pwrLH) end end end

local modLH=18
local modList={"Aitareis","Mr68Moth","ZZZXIIIXZZZ","TZZV","RlFLEM4N","FelixVenue","DeliverCreations","z_papermoon","r3shape","ARRYvvv"}
local modLabel=T{Center=false,Size=22,Color=Color3.fromHex("#ff97f6"),Text="STAFF DETECTED",Visible=false}
local modLines={} for i=1,#modList do modLines[i]=T{Center=false,Size=18,Color=Color3.fromHex("#ffffff"),Text="",Visible=false} end
function upStaffPos() local _,_,r=anc(); modLabel.Position=r-Vector2.new(50,120); local off=0; for i=1,#modLines do local line=modLines[i]; if line.Visible then off=off+1; line.Position=modLabel.Position-Vector2.new(0,off*modLH) end end end

local function updHudPos() local c,l,r=anc(); timerText.Position=c+Vector2.new(-140,-30); ppmsText.Position=c+Vector2.new(140,-30); targetPlayerText.Position=c+Vector2.new(0,-30); timerLabel.Position=timerText.Position+Vector2.new(0,18); ppmsLabel.Position=ppmsText.Position+Vector2.new(0,18); targetTitle.Position=targetPlayerText.Position+Vector2.new(0,18); radioTitle.Position=l+Vector2.new(-1,140); for i=1,7 do local y=l.Y+(i-1)*LINE_H; radLine[i].name.Position=Vector2.new(l.X,y); radLine[i].msg.Position=Vector2.new(l.X+70,y) end upPwrPos(); upStaffPos() end

updHudPos(); upPwrPos(); upStaffPos()

local tList,tempObj={},{}
local espObj={
 FlareGunPickUp={Type="Model",Root="FlareGun",Text="Flare Gun",Color=Color3.fromHex("#f05757"),ExactName=true},
 Rake={Type="Model",Root="Head",Text="The Rake",Color=Color3.fromHex("#e63a3a"),offY=75},
 BaseCampMSG={Type="BasePart",Text="Camp",Color=Color3.fromHex("#c6f1c8")},
 SafehouseMSG={Type="BasePart",Text="House",Color=Color3.fromHex("#c6f1c8")},
 StationMSG={Type="BasePart",Text="Power",Color=Color3.fromHex("#c6f1c8")},
 ShopMSG={Type="BasePart",Text="Shop",Color=Color3.fromHex("#c6f1c8")},
 ObservationTowerMSG={Type="BasePart",Text="Tower",Color=Color3.fromHex("#c6f1c8")},
 Scrap1={Type="Model",Root="Scrap",Text="Scrap 1",Color=Color3.fromHex("#aa8d4e")},
 Scrap2={Type="Model",Root="Scrap",Text="Scrap 2",Color=Color3.fromHex("#cca248")},
 Scrap3={Type="Model",Root="Scrap",Text="Scrap 3",Color=Color3.fromHex("#e2ae3c")},
 Scrap4={Type="Model",Root="Scrap",Text="Scrap 4",Color=Color3.fromHex("#ecca30")},
 Scrap5={Type="Model",Root="Scrap",Text="Scrap 5",Color=Color3.fromHex("#ffd000")},
 RakeTrapModel={Type="Model",Root="HitBox",Text="Trap",Color=Color3.fromHex("#ffd2d2")},
 Box={Type="Model",Root="HitBox",Text="Crate",Color=Color3.fromHex("#85e2ff")},
 SupplyCrate={Type="Model",Root="HitBox",Text="Crate",Color=Color3.fromHex("#85e2ff")}
}

local function fmt(s) s=math.max(0,math.floor(s)); return ("%d:%02d"):format(math.floor(s/60),s%60) end
local function getModelFromInstance(i) if not i then return end if i:IsA("Model") then return i end if i:IsA("BasePart") and i.Parent and i.Parent:IsA("Model") then return i.Parent end end
local function safeAddress(i) if not i then return end if i.Address then return i.Address end return tostring(i) end

local function addObj(v)
 if not v then return end
 local model=getModelFromInstance(v)
 local addr=(model and safeAddress(model)) or safeAddress(v)
 if addr and tempObj[addr] then return end
 local entry,object,modelRec=nil,nil,model
 if model and espObj[model.Name] then local e=espObj[model.Name]; if not e.ExactName or model.Name=="FlareGunPickUp" then entry=e end end
 if not entry and model then local scrapIdx=tostring(model.Name):match("^Scrap(%d+)") if scrapIdx then local key="Scrap"..tostring(tonumber(scrapIdx)) if espObj[key] then entry=espObj[key] end end end
 if not entry then
  for name,e in pairs(espObj) do
   if e.Root then
    local src=model or (v.Parent and v.Parent:IsA("Model") and v.Parent)
    if src then
     if name=="FlareGunPickUp" then
      if src.Name=="FlareGunPickUp" then local f=src:FindFirstChild(e.Root,true) if f and f:IsA("BasePart") then entry=e; object=f; modelRec=src; break end end
     else
      local f=src:FindFirstChild(e.Root,true)
      if f and f:IsA("BasePart") then entry=e; object=f; modelRec=src; break end end end end end end
 if not entry then return end
 if model and model.Name=="SupplyCrate" then if not model:FindFirstChild(entry.Root,true) then local inner=model:FindFirstChild("Box") if inner and inner:IsA("Model") then modelRec=inner end end end
 object=object or (entry.Type=="BasePart" and v:IsA("BasePart") and v) or (modelRec and modelRec:FindFirstChild(entry.Root,true))
 if not object then return end
 local recAddr=safeAddress(modelRec or object)
 if not recAddr or tempObj[recAddr] then return end
 local name=newText{Text=entry.Text,Color=entry.Color,Outline=true,Center=true,Size=14,Font=FONT,Visible=false}
 local dist=newText{Text="0 studs",Color=Color3.fromHex("#969696"),Outline=true,Center=true,Size=12,Font=FONT,Visible=false}
 tempObj[recAddr]=true
 tList[#tList+1]={object=object,model=modelRec or object.Parent,name=name,dist=dist,Address=recAddr}
end

local function updObj()
 local f=workspace:FindFirstChild("Filter")
 if f then local s=f:FindFirstChild("ScrapSpawns") if s then for _,sp in pairs(s:GetChildren())do if sp.Name:match("ItemSpawn")then for _,v in pairs(sp:GetChildren())do addObj(v) end end end end local l=f:FindFirstChild("LocationPoints") if l then for _,p in pairs(l:GetChildren())do addObj(p) end end end
 for _,v in pairs(workspace:GetChildren())do if v.Name=="FlareGunPickUp" or v.Name=="Rake" then addObj(v) end end
 local d=workspace:FindFirstChild("Debris") if d then local t=d:FindFirstChild("Traps") if t then for _,v in pairs(t:GetChildren())do addObj(v) end end local c=d:FindFirstChild("SupplyCrates") if c then for _,v in pairs(c:GetChildren())do addObj(v) end end end
end

local function updPos()
 if not toggle.esp then for _,v in ipairs(tList)do v.name.Visible=false; v.dist.Visible=false end return end
 local rx,ry,rz; local ch=lp.Character; if ch then local h=ch:FindFirstChild("HumanoidRootPart"); if h then rx,ry,rz=h.Position.X,h.Position.Y,h.Position.Z end end
 for i=#tList,1,-1 do local v=tList[i]; local o=v.object if not o or not o.Parent then v.name:Remove(); v.dist:Remove(); tempObj[v.Address]=nil; tList[i]=tList[#tList]; tList[#tList]=nil else local p=o.Position; local s,on=WorldToScreen(p) if on then local d=rx and math.floor(((p.X-rx)^2+(p.Y-ry)^2+(p.Z-rz)^2)^0.5) or 0 local y=(v.model and espObj[v.model.Name] and espObj[v.model.Name].offY) or 0 v.name.Position=Vector2.new(s.X,s.Y-12+y); v.name.Visible=true v.dist.Position=Vector2.new(s.X,s.Y+2+y); v.dist.Text=d.." studs"; v.dist.Visible=true else v.name.Visible=false; v.dist.Visible=false end end end
end

local function getCharacterFromPart(p) while p do if p:FindFirstChild("Humanoid") then return p end p=p.Parent end return nil end

local RakeModel,TargetVal=nil,nil
spawn(function() while true do local r=workspace:FindFirstChild("Rake",true) if r~=RakeModel then RakeModel=r; TargetVal=r and r:FindFirstChild("TargetVal") or nil elseif r then local tv=r:FindFirstChild("TargetVal"); if tv~=TargetVal then TargetVal=tv end end task.wait(0.5) end end)

spawn(function()
 local last=cam.ViewportSize
 while true do
  if cam.ViewportSize~=last then last=cam.ViewportSize; updHudPos() end
  local t=TimerValue.Value; timerText.Text=fmt(t); timerText.Color=t<=15 and Color3.fromHex("#c44b4b") or Color3.fromHex("#ffffff")
  if StationPower and StationPower.Value==false then ppmsText.Text="BLACKOUT"; ppmsText.Color=Color3.fromHex("#ffe7c7") else ppmsText.Text=string.format("%.2f",PPMS.Value); ppmsText.Color=Color3.fromHex("#ffffff") end
  timerLabel.Position=timerText.Position+Vector2.new(0,18); ppmsLabel.Position=ppmsText.Position+Vector2.new(0,18)
  task.wait(0.2)
 end
end)

spawn(function()
 while true do
  for i=1,7 do local f=RadioChannel:FindFirstChild("Line"..i); local n,m="" if f then local nv,mg=f:FindFirstChild("Name"),f:FindFirstChild("Msg") if nv and typeof(nv.Value)=="string" then n=#nv.Value>10 and nv.Value:sub(1,10) or nv.Value end if mg and typeof(mg.Value)=="string" then m=#mg.Value>70 and mg.Value:sub(1,70).."..." or mg.Value end end radLine[i].name.Text=n; radLine[i].msg.Text=m; radLine[i].name.Visible=toggle.hud; radLine[i].msg.Visible=toggle.hud end
  local a=0
  for bn,l in pairs(powerLines)do local v=pwrValue:FindFirstChild(bn); l.Visible=v and v.Value and toggle.hud or false; if l.Visible then a=a+1 end end
  pwrLabel.Visible=toggle.hud and a>0; upPwrPos()
  local count=0
  for i,entry in ipairs(modList) do local p=nil if entry then p=Players:FindFirstChild(entry) end if p then count=count+1; modLines[i].Text=p.Name; modLines[i].Visible=toggle.hud else modLines[i].Visible=false end end
  modLabel.Visible=toggle.hud and count>0; upStaffPos()
  local h=TargetVal and TargetVal.Value if h and h:IsA("Part") then local c=getCharacterFromPart(h); targetPlayerText.Text=c and c.Name or "Unknown" else targetPlayerText.Text="None" end
  task.wait(0.5)
 end
end)

spawn(function() while true do updObj(); task.wait(0.5) end end)
spawn(function() while true do updPos() if iskeypressed(0x70) then if not keyHeld.f1 then keyHeld.f1=true; toggle.esp=not toggle.esp; for _,v in ipairs(tList)do v.name.Visible=false; v.dist.Visible=false end end else keyHeld.f1=false end if iskeypressed(0x71) then if not keyHeld.f2 then keyHeld.f2=true; toggle.hud=not toggle.hud; for _,o in ipairs(hudObjects)do o.Visible=toggle.hud end local aa=0 for bn,l in pairs(powerLines)do local vv=pwrValue:FindFirstChild(bn); l.Visible=toggle.hud and vv and vv.Value or false; if l.Visible then aa=aa+1 end end pwrLabel.Visible=toggle.hud and aa>0; upPwrPos() local cc=0 for i,entry in ipairs(modList)do local p=Players:FindFirstChild(entry) if p then cc=cc+1; modLines[i].Text=p.Name; modLines[i].Visible=toggle.hud else modLines[i].Visible=false end end modLabel.Visible=toggle.hud and cc>0; upStaffPos() end else keyHeld.f2=false end task.wait() end end)

print(("saint | version %s"):format(vs))
print("F1 to toggle ESP, F2 to toggle HUD.")
