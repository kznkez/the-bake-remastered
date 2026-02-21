local Players,ReplicatedStorage=game:GetService("Players"),game:GetService("ReplicatedStorage")
local lp=Players.LocalPlayer; local vs="2.0.0"
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

local pSM={
 UsingSHDoor="House door is locked",
 UsingSHLight="House lights are on",
 UsingTowerDoor="Tower trapdoor is closed",
 UsingTowerLight="Tower floodlights are on",
 UsingTowerRadar="Tower radar is active"
}

local cam=workspace.CurrentCamera
local function anc() local v=cam.ViewportSize; return Vector2.new(v.X/2,v.Y-80),Vector2.new(70,v.Y-240),Vector2.new(v.X-200,v.Y-100) end

local timerText=T{Center=true,Size=21,Color=Color3.fromHex("#ffffff"),Text="0:00",Visible=true}
local ppmsText=T{Center=true,Size=21,Color=Color3.fromHex("#ffffff"),Text="0.00",Visible=true}
local targetPlayerText=T{Center=true,Size=19,Color=Color3.fromHex("#ffffff"),Text="None",Visible=true}
local targetTitle=T{Center=true,Size=15,Color=Color3.fromHex("#c44b4b"),Text="RAKE'S TARGET",Visible=true}
local timerLabel=T{Center=true,Size=15,Color=Color3.fromHex("#eeeeee"),Text="TIME LEFT",Visible=true}
local ppmsLabel=T{Center=true,Size=15,Color=Color3.fromHex("#ffce8f"),Text="POWER USE",Visible=true}
local powerTitle=T{Center=false,Size=22,Color=Color3.fromHex("#ffce8f"),Text="POWER ACTIVITY",Visible=false}
local powerLines,POWER_LINE_H={},18
for k,v in pairs(pSM)do powerLines[k]=T{Center=false,Size=15,Color=Color3.fromHex("#ffffff"),Text=v,Visible=false} end

local radioTitle=T{Center=false,Size=22,Color=Color3.fromHex("#cbffcf"),Text="RADIO ACTIVITY",Visible=true}
local radLine={}; local LINE_H=20
for i=1,7 do radLine[i]={name=T{Center=false,Size=13,Color=Color3.fromHex("#b6b6b6"),Text="",Visible=true},msg=T{Center=false,Size=13,Color=Color3.fromHex("#ffffff"),Text="",Visible=true}} end

local hudObjects={timerText,ppmsText,timerLabel,ppmsLabel,radioTitle,targetTitle,targetPlayerText,powerTitle}
for i=1,7 do hudObjects[#hudObjects+1]=radLine[i].name; hudObjects[#hudObjects+1]=radLine[i].msg end

local function updHudPos()
 local c,l,r=anc()
 timerText.Position=c+Vector2.new(-140,-30); ppmsText.Position=c+Vector2.new(140,-30); targetPlayerText.Position=c+Vector2.new(0,-30)
 timerLabel.Position=timerText.Position+Vector2.new(0,18); ppmsLabel.Position=ppmsText.Position+Vector2.new(0,18); targetTitle.Position=targetPlayerText.Position+Vector2.new(0,18)
 radioTitle.Position=l+Vector2.new(-1,140)
 for i=1,7 do local y=l.Y+(i-1)*LINE_H; radLine[i].name.Position=Vector2.new(l.X,y); radLine[i].msg.Position=Vector2.new(l.X+60,y) end
end
local function upPwrPos()
 local _,_,r=anc(); powerTitle.Position=r-Vector2.new(50,0)
 local off=0
 for _,line in pairs(powerLines)do if line.Visible then off=off+1; line.Position=powerTitle.Position-Vector2.new(0,off*POWER_LINE_H) end end
end

updHudPos(); upPwrPos()

local tList,tempObj={},{}
local espObj={
 FlareGunPickUp={Type="Model",Root="FlareGun",Text="Flare",Color=Color3.fromHex("#f05757")},
 Rake={Type="Model",Root="Head",Text="Rake",Color=Color3.fromHex("#e63a3a"),offY=75},
 BaseCampMSG={Type="BasePart",Text="Camp",Color=Color3.fromHex("#c6f1c8")},
 SafehouseMSG={Type="BasePart",Text="Home",Color=Color3.fromHex("#c6f1c8")},
 StationMSG={Type="BasePart",Text="Power",Color=Color3.fromHex("#c6f1c8")},
 ShopMSG={Type="BasePart",Text="Shop",Color=Color3.fromHex("#c6f1c8")},
 ObservationTowerMSG={Type="BasePart",Text="Tower",Color=Color3.fromHex("#c6f1c8")},
 Scrap1={Type="Model",Root="Scrap",Text="Scrap 1",Color=Color3.fromHex("#aa8d4e")},
 Scrap2={Type="Model",Root="Scrap",Text="Scrap 2",Color=Color3.fromHex("#cca248")},
 Scrap3={Type="Model",Root="Scrap",Text="Scrap 3",Color=Color3.fromHex("#e2ae3c")},
 Scrap4={Type="Model",Root="Scrap",Text="Scrap 4",Color=Color3.fromHex("#ecca30")},
 Scrap5={Type="Model",Root="Scrap",Text="Scrap 5",Color=Color3.fromHex("#ffd000")},
 RakeTrapModel={Type="Model",Root="HitBox",Text="Trap",Color=Color3.fromHex("#ffb3b3")},
 Box={Type="Model",Root="HitBox",Text="Crate",Color=Color3.fromHex("#85e2ff")}
}

local function fmt(s) s=math.max(0,math.floor(s)); return ("%d:%02d"):format(math.floor(s/60),s%60) end

local function getModelFromInstance(inst)
 if not inst then return nil end
 if inst:IsA("Model") then return inst end
 if inst:IsA("BasePart") and inst.Parent and inst.Parent:IsA("Model") then return inst.Parent end
 return nil
end

local function safeAddress(inst)
 if not inst then return nil end
 if inst.Address then return inst.Address end
 if inst:IsA("Instance") then return tostring(inst) end
 return nil
end

local function addObj(v)
 if not v then return end
 local model = getModelFromInstance(v)
 local addrKey = (model and safeAddress(model)) or safeAddress(v)
 if addrKey and tempObj[addrKey] then return end
 local entry=nil
 local object=nil
 local modelForRecord=model
 if model and espObj[model.Name] then entry=espObj[model.Name] end
 if not entry then
  for name,e in pairs(espObj) do
   if e.Type=="BasePart" and v:IsA("BasePart") and name==v.Name then entry=e; object=v; if not modelForRecord and v.Parent and v.Parent:IsA("Model") then modelForRecord=v.Parent end; break end
   if e.Root then
    if model then
     local found = model:FindFirstChild(e.Root, true)
     if found and found:IsA("BasePart") then entry=e; object=found; break end
    else
     if v:IsA("BasePart") and v.Parent and v.Parent:IsA("Model") then
      local found = v.Parent:FindFirstChild(e.Root, true)
      if found and found:IsA("BasePart") then entry=e; object=found; modelForRecord=v.Parent; break end
     end
    end
   end
  end
 end
 if not entry then return end
 if not object then
  if entry.Type=="BasePart" then
   if v:IsA("BasePart") then object=v end
  else
   if modelForRecord then object = modelForRecord:FindFirstChild(entry.Root, true) end
  end
 end
 if not object then return end
 local recordAddr = (modelForRecord and safeAddress(modelForRecord)) or safeAddress(object)
 if not recordAddr or tempObj[recordAddr] then return end
 local name=newText{Text=entry.Text,Color=entry.Color,Outline=true,Center=true,Size=14,Font=FONT,Visible=false}
 local dist=newText{Text="0 studs",Color=Color3.fromHex("#969696"),Outline=true,Center=true,Size=12,Font=FONT,Visible=false}
 tempObj[recordAddr]=true
 tList[#tList+1]={object=object,model=modelForRecord or object.Parent,name=name,dist=dist,Address=recordAddr}
end

local function updObj()
 local f=workspace:FindFirstChild("Filter")
 if f then local s=f:FindFirstChild("ScrapSpawns") if s then for _,spawn in pairs(s:GetChildren()) do if spawn.Name:match("ItemSpawn") then for _,v in pairs(spawn:GetChildren())do addObj(v) end end end end
 local l=f:FindFirstChild("LocationPoints") if l then for _,p in pairs(l:GetChildren())do addObj(p) end end end
 for _,v in pairs(workspace:GetChildren()) do if v.Name=="FlareGunPickUp" or v.Name=="Rake" then addObj(v) end end
 local d=workspace:FindFirstChild("Debris") if d then local t=d:FindFirstChild("Traps") if t then for _,v in pairs(t:GetChildren())do addObj(v) end end local c=d:FindFirstChild("SupplyCrates") if c then for _,v in pairs(c:GetChildren())do addObj(v) end end end
end

if workspace and workspace.DescendantAdded and type(workspace.DescendantAdded.Connect)=="function" then
 workspace.DescendantAdded:Connect(function(desc)
  pcall(function()
   if not desc then return end
   addObj(desc)
   if desc.Parent then addObj(desc.Parent) end
  end)
 end)
end

local function updPos()
 if not toggle.esp then for _,v in ipairs(tList) do if v.name then v.name.Visible=false end; if v.dist then v.dist.Visible=false end end return end
 local rx,ry,rz
 local char=lp.Character if char then local hrp=char:FindFirstChild("HumanoidRootPart") if hrp then local p=hrp.Position; rx,ry,rz=p.X,p.Y,p.Z end end
 for i=#tList,1,-1 do local v=tList[i]; local o=v.object if not o or not o.Parent then if v.name then v.name:Remove() end; if v.dist then v.dist:Remove() end; if v.Address then tempObj[v.Address]=nil end; tList[i]=tList[#tList]; tList[#tList]=nil else local pos3=o.Position; local screenPos,onScreen=WorldToScreen(pos3) if onScreen then local studsDist=0 if rx then studsDist=math.sqrt((pos3.X-rx)^2+(pos3.Y-ry)^2+(pos3.Z-rz)^2) end local studs=math.floor(studsDist) local yOffset=0 if v.model and v.model.Name and espObj[v.model.Name] then yOffset=espObj[v.model.Name].offY or 0 end v.name.Position=Vector2.new(screenPos.X,screenPos.Y-12+yOffset); v.name.Visible=true v.dist.Position=Vector2.new(screenPos.X,screenPos.Y+2+yOffset); v.dist.Text=studs.." studs"; v.dist.Visible=true else v.name.Visible=false; v.dist.Visible=false end end end
end

local function getCharacterFromPart(p) local cur=p while cur do if cur.ClassName=="Model" then return cur end; cur=cur.Parent end return nil end

local RakeModel=workspace:FindFirstChild("Rake"); local TargetVal=nil
if RakeModel then TargetVal=RakeModel:FindFirstChild("TargetVal") end

local function safeConnectChildAdded(inst,fn) if inst and inst.ChildAdded and type(inst.ChildAdded.Connect)=="function" then pcall(function() inst.ChildAdded:Connect(fn) end) return true end return false end

if workspace and workspace.ChildAdded and type(workspace.ChildAdded.Connect)=="function" then workspace.ChildAdded:Connect(function(child) if not child then return end if child.Name=="Rake" then RakeModel=child TargetVal=RakeModel:FindFirstChild("TargetVal") safeConnectChildAdded(RakeModel,function(c) if c and c.Name=="TargetVal" then TargetVal=c end end) end end) end

spawn(function() while not TargetVal do RakeModel=RakeModel or workspace:FindFirstChild("Rake") if RakeModel and not TargetVal then TargetVal=RakeModel:FindFirstChild("TargetVal") safeConnectChildAdded(RakeModel,function(c) if c and c.Name=="TargetVal" then TargetVal=c end end) end task.wait(0.5) end end)

spawn(function()
 local last=cam.ViewportSize
 while true do
  if cam.ViewportSize~=last then last=cam.ViewportSize; updHudPos() end
  local t=TimerValue.Value
  timerText.Text=fmt(t)
  if t<=15 then timerText.Color=Color3.fromHex("#c44b4b") else timerText.Color=Color3.fromHex("#ffffff") end
  if StationPower and typeof(StationPower.Value)=="boolean" and not StationPower.Value then
   ppmsText.Text="NO POWER"
   ppmsText.Color=Color3.fromHex("#c44b4b")
  else
   ppmsText.Text=string.format("%.2f",PPMS.Value)
   ppmsText.Color=Color3.fromHex("#ffffff")
  end
  timerLabel.Position=timerText.Position+Vector2.new(0,18)
  ppmsLabel.Position=ppmsText.Position+Vector2.new(0,18)
  task.wait(0.2)
 end
end)

spawn(function()
 while true do
  for i=1,7 do local folder=RadioChannel:FindFirstChild("Line"..i); local nameText,msgText="","" if folder then local n,m=folder:FindFirstChild("Name"),folder:FindFirstChild("Msg") if n and typeof(n.Value)=="string" then local rn=n.Value; nameText=#rn>10 and string.sub(rn,1,10) or rn end if m and typeof(m.Value)=="string" then local tx=m.Value; msgText=#tx>70 and string.sub(tx,1,70).."..." or tx end end radLine[i].name.Text=nameText; radLine[i].msg.Text=msgText; radLine[i].name.Visible=toggle.hud; radLine[i].msg.Visible=toggle.hud end

  local active=0
  for bn,line in pairs(powerLines)do local bv=pwrValue:FindFirstChild(bn) if bv and bv.Value then line.Visible=toggle.hud active=active+1 else line.Visible=false end end
  powerTitle.Visible=toggle.hud and active>0; upPwrPos()

  local hrp=TargetVal and TargetVal.Value or nil
  if hrp and typeof(hrp)=="Instance" and hrp.ClassName=="Part" then local char=getCharacterFromPart(hrp); targetPlayerText.Text=char and char.Name or "Unknown" else targetPlayerText.Text="None" end

  task.wait(0.1)
 end
end)

spawn(function() while true do updObj(); task.wait(0.5) end end)

spawn(function()
 while true do
  updPos()
  if iskeypressed(0x70) then if not keyHeld.f1 then keyHeld.f1=true; toggle.esp=not toggle.esp; for _,v in ipairs(tList)do if v.name then v.name.Visible=false end; if v.dist then v.dist.Visible=false end end end else keyHeld.f1=false end
  if iskeypressed(0x71) then if not keyHeld.f2 then keyHeld.f2=true; toggle.hud=not toggle.hud; for _,o in ipairs(hudObjects)do o.Visible=toggle.hud end end else keyHeld.f2=false end
  task.wait()
 end
end)

spawn(function() while true do updObj(); task.wait(0.5) end end)

print(("saint | version %s"):format(vs))
print("last updated: 02/20/2026. star this so i can put changelogs on the thread :)")
print("F1 to toggle ESP, F2 to toggle HUD.")
