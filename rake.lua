local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local tList, tempObj = {}, {}

local workspace, Drawing, WorldToScreen, ipairs, pairs, task =
    workspace, Drawing, WorldToScreen, ipairs, pairs, task

local toggle = { esp = true, hud = true }
local keyHeld = { f1 = false, f2 = false }

local function newText(props)
    local t = Drawing.new("Text")
    for k, v in pairs(props) do
        t[k] = v
    end
    return t
end

local TimerValue = ReplicatedStorage:WaitForChild("Timer")

local pwrValue = ReplicatedStorage:WaitForChild("PowerValues")
local PPMS = pwrValue:WaitForChild("PPMS")
local pwrStatMap = {
    UsingSHDoor      = "House door is locked",
    UsingSHLight     = "House lights are on",
    UsingTowerDoor   = "Tower trapdoor is closed",
    UsingTowerLight  = "Tower lights are on",
    UsingTowerRadar  = "Tower radar is active"
}


local cam = workspace.CurrentCamera

local function getHudAnc()
    local vp = cam.ViewportSize
    return {
        bottomCenter = Vector2.new(vp.X / 2, vp.Y - 80),
        bottomLeft = Vector2.new(70, vp.Y - 240),
        bottomRight  = Vector2.new(vp.X - 200, vp.Y - 100)
    }
end

local timerText = newText{
    Center = true, Outline = true, Size = 21,
    Font = Drawing.Fonts.System,
    Color = Color3.fromHex("#ffffff"),
    Text = "0:00", Visible = true
}

local ppmsText = newText{
    Center = true, Outline = true, Size = 21,
    Font = Drawing.Fonts.System,
    Color = Color3.fromHex("#ffffff"),
    Text = "0.00", Visible = true
}

local targetPlayerText = newText{
    Center = true, Outline = true, Size = 19,
    Font = Drawing.Fonts.System,
    Color = Color3.fromHex("#ffffff"),
    Text = "None", Visible = true
}

local targetTitle = newText{
    Center = true, Outline = true, Size = 15,
    Font = Drawing.Fonts.System,
    Color = Color3.fromHex("#ff9f9f"),
    Text = "RAKE'S TARGET", Visible = true
}

local timerLabel = newText{
    Center = true, Outline = true, Size = 15,
    Font = Drawing.Fonts.System,
    Color = Color3.fromHex("#eeeeee"),
    Text = "TIMER", Visible = true
}

local ppmsLabel = newText{
    Center = true, Outline = true, Size = 15,
    Font = Drawing.Fonts.System,
    Color = Color3.fromHex("#d6bfa0"),
    Text = "PPMS", Visible = true
}

local powerTitle = newText{
    Center = center,
    Outline = true,
    Size = 20,
    Font = Drawing.Fonts.System,
    Color = Color3.fromHex("#d6bfa0"),
    Text = "PPMS ACTIVITY",
    Visible = true
}

local powerLines = {}
local powerLineHeight = 18

for boolName, displayText in pairs(pwrStatMap) do
    powerLines[boolName] = newText{
        Center = false,
        Outline = true,
        Size = 15,
        Font = Drawing.Fonts.System,
        Color = Color3.fromHex("#ffffff"),
        Text = displayText,
        Visible = false
    }
end

local RadioChannel = ReplicatedStorage:WaitForChild("RadioChannel")

local radioTitle = newText{
    Center = false, Outline = true, Size = 20,
    Font = Drawing.Fonts.System,
    Color = Color3.fromHex("#c6f1c8"),
    Text = "RADIO INTERFACE", Visible = true
}

local radLine = {}
local lineHeight = 20

for i = 1, 7 do
    radLine[i] = {
        name = newText{
            Center = false, Outline = true, Size = 13,
            Font = Drawing.Fonts.System,
            Color = Color3.fromHex("#dadada"),
            Text = "", Visible = true
        },
        msg = newText{
            Center = false, Outline = true, Size = 13,
            Font = Drawing.Fonts.System,
            Color = Color3.fromHex("#ffffff"),
            Text = "", Visible = true
        }
    }
end

local hudObjects = {
    timerText, ppmsText, timerLabel, ppmsLabel,
    radioTitle, targetTitle, targetPlayerText
}

for i = 1, 7 do
    hudObjects[#hudObjects + 1] = radLine[i].name
    hudObjects[#hudObjects + 1] = radLine[i].msg
end

local function updHudPos()
    local a = getHudAnc()

    timerText.Position = a.bottomCenter + Vector2.new(-140, -30)
    ppmsText.Position  = a.bottomCenter + Vector2.new(140, -30)
    targetPlayerText.Position = a.bottomCenter + Vector2.new(0, -30)

    timerLabel.Position = timerText.Position + Vector2.new(0, 18)
    ppmsLabel.Position  = ppmsText.Position + Vector2.new(0, 18)
    targetTitle.Position = targetPlayerText.Position + Vector2.new(0, 18)

    radioTitle.Position = a.bottomLeft + Vector2.new(-1, 140)

    for i = 1, 7 do
        local y = a.bottomLeft.Y + (i - 1) * lineHeight
        radLine[i].name.Position = Vector2.new(a.bottomLeft.X, y)
        radLine[i].msg.Position  = Vector2.new(a.bottomLeft.X + 60, y)
    end
end

updHudPos()

local function updPowerHudPos()
    local a = getHudAnc()

    powerTitle.Position = a.bottomRight

    local offset = 0
    for _, line in pairs(powerLines) do
        if line.Visible then
            offset += 1
            line.Position = powerTitle.Position - Vector2.new(0, offset * powerLineHeight)
        end
    end
end

updPowerHudPos()

spawn(function()
    local last = cam.ViewportSize
    while true do
        if cam.ViewportSize ~= last then
            last = cam.ViewportSize
            updHudPos()
        end
        task.wait(0.2)
    end
end)

local function formatTime(seconds)
    seconds = math.max(0, math.floor(seconds))
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    return string.format("%d:%02d", m, s)
end

local espObj = {
    FlareGunPickUp = {Type="Model",Root="FlareGun",Text="Flare",Color=Color3.fromHex("#f05757")},
    Rake = {Type="Model",Root="Head",Text="Rake",Color=Color3.fromHex("#e63a3a"),offY=75},

    BaseCampMSG = {Type="BasePart",Text="Camp",Color=Color3.fromHex("#c6f1c8")},
    SafehouseMSG = {Type="BasePart",Text="Home",Color=Color3.fromHex("#c6f1c8")},
    StationMSG = {Type="BasePart",Text="Power",Color=Color3.fromHex("#c6f1c8")},
    ShopMSG = {Type="BasePart",Text="Shop",Color=Color3.fromHex("#c6f1c8")},
    ObservationTowerMSG = {Type="BasePart",Text="Tower",Color=Color3.fromHex("#c6f1c8")},

    Scrap1 = {Type="Model",Root="Scrap",Text="Scrap 1",Color=Color3.fromHex("#aa8d4e")},
    Scrap2 = {Type="Model",Root="Scrap",Text="Scrap 2",Color=Color3.fromHex("#cca248")},
    Scrap3 = {Type="Model",Root="Scrap",Text="Scrap 3",Color=Color3.fromHex("#e2ae3c")},
    Scrap4 = {Type="Model",Root="Scrap",Text="Scrap 4",Color=Color3.fromHex("#ecca30")},
    Scrap5 = {Type="Model",Root="Scrap",Text="Scrap 5",Color=Color3.fromHex("#ffd000")},

    RakeTrapModel = {Type="Model",Root="HitBox",Text="Trap",Color=Color3.fromHex("#ffcbcb")},
    Box = {Type="Model",Root="HitBox",Text="Crate",Color=Color3.fromHex("#6560ff")},
    SupplyCrate = {Type="Model",Root="HitBox",Text="Crate",Color=Color3.fromHex("#8682ff")}
}

local function updPos()
    if not toggle.esp then
        for _, v in ipairs(tList) do
            if v.name then v.name.Visible = false end
            if v.dist then v.dist.Visible = false end
            if v.hp then v.hp.Visible = false end
        end
        return
    end

    local rx, ry, rz
    local char = lp.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local p = hrp.Position
            rx, ry, rz = p.X, p.Y, p.Z
        end
    end

    for i = #tList, 1, -1 do
        local v = tList[i]
        local o = v.object

        if not o or not o.Parent then
            if v.name then v.name:Remove() end
            if v.dist then v.dist:Remove() end
            if v.hp then v.hp:Remove() end
            tList[i] = tList[#tList]
            tList[#tList] = nil
            tempObj[v.Address] = nil
        else
            local pos3 = o.Position
            local screenPos, onScreen = WorldToScreen(pos3)

            if onScreen then
                local studsDist = 0
                if rx then
                    studsDist = math.sqrt(
                        (pos3.X - rx)^2 +
                        (pos3.Y - ry)^2 +
                        (pos3.Z - rz)^2
                    )
                end

                local studs = math.floor(studsDist)
                local yOffset = 0

                if v.model then
                    local d = espObj[v.model.Name]
                    if d and d.offY then yOffset = d.offY end
                end

                v.name.Position = Vector2.new(screenPos.X, screenPos.Y - 12 + yOffset)
                v.name.Visible = true

                v.dist.Position = Vector2.new(screenPos.X, screenPos.Y + 2 + yOffset)
                v.dist.Text = studs .. " studs"
                v.dist.Visible = true

                if v.hp and v.model then
                    local hum = v.model:FindFirstChildOfClass("Humanoid")
                    if hum then
                        v.hp.Text = math.floor(hum.Health) .. " HP"
                        v.hp.Position = Vector2.new(screenPos.X, screenPos.Y + 17 + yOffset)
                        v.hp.Visible = true
                    else
                        v.hp.Visible = false
                    end
                end
            else
                v.name.Visible = false
                v.dist.Visible = false
                if v.hp then v.hp.Visible = false end
            end
        end
    end
end

local function addObj(v)
    local d = espObj[v.Name]
    if not d or tempObj[v.Address] or not v:IsA(d.Type) then return end

    local r
    if d.Type == "BasePart" then
        r = v
    elseif v.Name:find("Scrap") then
        for _, c in pairs(v:GetDescendants()) do
            if c:IsA("BasePart") and c.Name == d.Root then
                r = c
                break
            end
        end
    else
        r = v:FindFirstChild(d.Root)
    end
    if not r then return end

    local name = newText{
        Text = d.Text,
        Color = d.Color,
        Outline = true,
        Center = true,
        Size = 14,
        Font = Drawing.Fonts.System,
        Visible = false
    }

    local dist = newText{
        Text = "0 studs",
        Color = Color3.fromHex("#dadada"),
        Outline = true,
        Center = true,
        Size = 12,
        Font = Drawing.Fonts.System,
        Visible = false
    }

    local hp = nil
    if v.Name == "Rake" then
        hp = newText{
            Text = "400 HP",
            Color = Color3.fromHex("#fc5555"),
            Outline = true,
            Center = true,
            Size = 15,
            Font = Drawing.Fonts.System,
            Visible = false
        }
    end

    tempObj[v.Address] = true
    tList[#tList + 1] = {
        object = r,
        model = v,
        name = name,
        dist = dist,
        hp = hp,
        Address = v.Address
    }
end

local function updObj()
    local f = workspace:FindFirstChild("Filter")
    if f then
        local s = f:FindFirstChild("ScrapSpawns")
        if s then
            for _, i in pairs(s:GetChildren()) do
                if i.Name:match("ItemSpawn") then
                    for _, v in pairs(i:GetChildren()) do
                        addObj(v)
                    end
                end
            end
        end

        local l = f:FindFirstChild("LocationPoints")
        if l then
            for _, p in pairs(l:GetChildren()) do
                addObj(p)
            end
        end
    end

    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "FlareGunPickUp" or v.Name == "Rake" then
            addObj(v)
        end
    end

    local d = workspace:FindFirstChild("Debris")
    if d then
        local t = d:FindFirstChild("Traps")
        if t then
            for _, v in pairs(t:GetChildren()) do
                addObj(v)
            end
        end
        local c = d:FindFirstChild("SupplyCrates")
        if c then
            for _, v in pairs(c:GetChildren()) do
                addObj(v)
            end
        end
    end
end

spawn(function()
    while true do
        for displayIndex = 1, 7 do
            local folder = RadioChannel:FindFirstChild("Line" .. displayIndex)

            local nameText, msgText = "", ""

            if folder then
                local n = folder:FindFirstChild("Name")
                local m = folder:FindFirstChild("Msg")
                if n then
    local rawName = n.Value
    if #rawName > 10 then
        nameText = string.sub(rawName, 1, 10)
    else
        nameText = rawName
    end
end

                if m then
    local text = m.Value
    if #text > 70 then
        msgText = string.sub(text, 1, 70) .. "..."
    else
        msgText = text
    end
end
            end

            radLine[displayIndex].name.Text = nameText
            radLine[displayIndex].msg.Text = msgText
        end
        task.wait(0.1)
    end
end)

spawn(function()
    while true do
        timerText.Text = formatTime(TimerValue.Value)
        ppmsText.Text = string.format("%.2f", PPMS.Value)

        timerLabel.Position = timerText.Position + Vector2.new(0, 18)
        ppmsLabel.Position = ppmsText.Position + Vector2.new(0, 18)

        task.wait(0.2)
    end
end)

spawn(function()
    while true do
        local activeCount = 0

        for boolName, line in pairs(powerLines) do
            local boolVal = pwrValue:FindFirstChild(boolName)

            if boolVal and boolVal.Value == true then
                line.Visible = toggle.hud
                activeCount += 1
            else
                line.Visible = false
            end
        end

        powerTitle.Visible = toggle.hud and activeCount > 0
        updPowerHudPos()

        task.wait(0.1)
    end
end)


spawn(function()
    while true do
        updObj()
        task.wait(0.5)
    end
end)

spawn(function()
    while true do
        updPos()
        task.wait()
    end
end)

spawn(function()
    while true do
        if iskeypressed(0x70) then
            if not keyHeld.f1 then
                keyHeld.f1 = true
                toggle.esp = not toggle.esp

                for _, v in ipairs(tList) do
                    if v.name then v.name.Visible = false end
                    if v.dist then v.dist.Visible = false end
                    if v.hp then v.hp.Visible = false end
                end
            end
        else
            keyHeld.f1 = false
        end

        if iskeypressed(0x71) then
            if not keyHeld.f2 then
                keyHeld.f2 = true
                toggle.hud = not toggle.hud

                for _, obj in ipairs(hudObjects) do
                    obj.Visible = toggle.hud
                end
            end
        else
            keyHeld.f2 = false
        end

        task.wait()
    end
end)


local RakeModel = workspace:WaitForChild("Rake")
local TargetVal = RakeModel:WaitForChild("TargetVal")

local function getCharacterFromPart(part)
    local current = part
    while current do
        if current.ClassName == "Model" then
            return current
        end
        current = current.Parent
    end
    return nil
end

spawn(function()
    while true do
        local hrp = TargetVal.Value

        if hrp and hrp.ClassName == "Part" then
            local character = getCharacterFromPart(hrp)

            if character then
                targetPlayerText.Text = character.Name
            else
                targetPlayerText.Text = "Unknown"
            end
        else
            targetPlayerText.Text = "None"
        end

        task.wait(0.1)
    end
end)


local vs = "2.1"
print(("F1 to toggle | Version %s"):format(vs))