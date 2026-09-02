local version="3.0"
local players=game:GetService("Players")
local replicatedstorage=game:GetService("ReplicatedStorage")
local workspace=game:GetService("Workspace")
local lp=players.LocalPlayer
local camera=workspace.CurrentCamera
local font=Drawing.Fonts.UI
local stud_to_meter=1/3.5714285714
local world_scan_interval,hud_update_interval,status_update_interval=1,0.1,0.25
local ring_fade_distance,ring_segments,crate_show_distance,max_tracked_objects=40,16,30,256
local toggle={esp=true,hud=true}
local keyheld={f1=false,f2=false,f3=false,f4=false}

local function clamp(value,minimum,maximum)return math.max(minimum,math.min(maximum,value))end
local function wait_for_child(parent,name,timeout)
    local started=tick()
    local child=parent:FindFirstChild(name)
    while not child do
        if timeout and tick()-started>=timeout then return nil end
        task.wait(0.1)
        child=parent:FindFirstChild(name)
    end
    return child
end
local function wait_for_camera(timeout)
    local started=tick()
    local cam=workspace.CurrentCamera
    while not cam do
        if timeout and tick()-started>=timeout then return nil end
        task.wait(0.1)
        cam=workspace.CurrentCamera
    end
    return cam
end
if not camera then camera=wait_for_camera(15)end
if not camera or not lp then return end
local timer_value=wait_for_child(replicatedstorage,"Timer",15)
local power_values=wait_for_child(replicatedstorage,"PowerValues",15)
if not timer_value or not power_values then return end

local function new_text(text,color,centered,visible,outline)
    local d=Drawing.new("Text")
    d.Text=text or "";d.Color=color or Color3.fromHex("#ffffff");d.Center=centered==true;d.Visible=visible==true;d.Outline=outline~=false;d.Font=font
    return d
end
local function new_square(color,transparency)
    local d=Drawing.new("Square")
    d.Color=color;d.Transparency=transparency;d.Filled=true;d.Visible=false;d.Position=Vector2.new(0,0);d.Size=Vector2.new(1,1)
    return d
end
local function new_line(color)
    local d=Drawing.new("Line")
    d.Color=color;d.Transparency=1;d.Visible=false;d.From=Vector2.new(0,0);d.To=Vector2.new(0,0);d.Thickness=2
    return d
end
local function remove_drawing(d)
    if not d then return end
    pcall(function()d.Visible=false;d:Remove()end)
end
local function hide_drawing(d)if d then d.Visible=false end end
local function anchors()
    local v=camera.ViewportSize
    return Vector2.new(v.X/2,v.Y-80),Vector2.new(v.X-200,v.Y-100)
end

local timer_text=new_text("0:00",Color3.fromHex("#ffffff"),true,true)
local scrap_text=new_text("0",Color3.fromHex("#ffffff"),true,true)
local target_text=new_text("none",Color3.fromHex("#ffffff"),true,true)
local timer_label=new_text("timer",Color3.fromHex("#ffffff"),true,true)
local scrap_label=new_text("scrap",Color3.fromHex("#fff89a"),true,true)
local target_label=new_text("target",Color3.fromHex("#ff9090"),true,true)
local power_label=new_text("power_activity",Color3.fromHex("#ffe0b8"),false,false)
local roof_label=new_text("roof",Color3.fromHex("#f5d3ff"),true,false)
local roof_health_text=new_text("",Color3.fromHex("#ebebeb"),true,false)
local power_entries={{valuename="UsingSHDoor",label="house_door_locked"},{valuename="UsingSHLight",label="house_lights_on"},{valuename="UsingTowerLight",label="tower_lights_on"},{valuename="UsingTowerRadar",label="tower_radar_on"}}
local power_lines={}
for i=1,#power_entries do power_lines[i]=new_text(power_entries[i].label,Color3.fromHex("#ffffff"),false,false)end
local hud_objects={timer_text,scrap_text,target_text,timer_label,scrap_label,target_label}

local function update_power_positions()
    local _,right=anchors()
    local x,y,n=right.X-50,right.Y,0
    power_label.Position=Vector2.new(x,y)
    for i=1,#power_lines do
        local line=power_lines[i]
        if line.Visible then n=n+1;line.Position=Vector2.new(x,y-n*18)end
    end
end
local function update_hud_positions()
    local center=anchors()
    local y=center.Y-150
    timer_text.Position=Vector2.new(center.X-100,y)
    target_text.Position=Vector2.new(center.X,y)
    scrap_text.Position=Vector2.new(center.X+100,y)
    timer_label.Position=Vector2.new(timer_text.Position.X,y+18)
    target_label.Position=Vector2.new(target_text.Position.X,y+18)
    scrap_label.Position=Vector2.new(scrap_text.Position.X,y+18)
    update_power_positions()
end
update_hud_positions()

local crate_names={FirstAidKit="medkit",Vitamins="vitamin",UV_Lamp="uv_lamp",StunStick="stun",Vest="vest",Tracker="tracker"}
local crate_colors={FirstAidKit=Color3.fromHex("#dbffde"),Vitamins=Color3.fromHex("#d1d3ff"),UV_Lamp=Color3.fromHex("#e694ff"),StunStick=Color3.fromHex("#ffed9d"),Vest=Color3.fromHex("#9fd4ff"),Tracker=Color3.fromHex("#cdceff")}
local crate_text_color=Color3.fromHex("#ffffff")
local crate_bg_color=Color3.fromHex("#000000")
local crate_bg_transparency=0.3
local crate_col_spacing,crate_row_spacing,crate_y_offset=55,16,70
local crate_pad_x,crate_pad_y=28,10
local crate_bg_width=crate_col_spacing*2+crate_pad_x*2
local esp_config={
    FlareGunPickUp={rootname="FlareGun",text="flare",color=Color3.fromHex("#ff6b6b"),ringradius=2.2,ringyoffset=1},
    BaseCampMSG={directpart=true,text="base",color=Color3.fromHex("#ffffff"),noring=true},
    SafehouseMSG={directpart=true,text="home",color=Color3.fromHex("#ffffff"),textyoffset=25,noring=true},
    StationMSG={directpart=true,text="station",color=Color3.fromHex("#ffffff"),noring=true},
    ShopMSG={directpart=true,text="shop",color=Color3.fromHex("#ffffff"),noring=true},
    ObservationTowerMSG={directpart=true,text="tower",color=Color3.fromHex("#ffffff"),noring=true},
    Scrap1={rootname="Scrap",text="scrap_1",color=Color3.fromHex("#a79266"),ringradius=2.2,ringyoffset=1},
    Scrap2={rootname="Scrap",text="scrap_2",color=Color3.fromHex("#c9aa68"),ringradius=2.2,ringyoffset=1},
    Scrap3={rootname="Scrap",text="scrap_3",color=Color3.fromHex("#dfb65d"),ringradius=2.2,ringyoffset=1},
    Scrap4={rootname="Scrap",text="scrap_4",color=Color3.fromHex("#ecca30"),ringradius=2.2,ringyoffset=1},
    Scrap5={rootname="Scrap",text="scrap_5",color=Color3.fromHex("#ffd000"),ringradius=2.2,ringyoffset=1},
    RakeTrapModel={rootname="HitBox",text="trap",color=Color3.fromHex("#ffc6c6"),ringradius=2.2,ringyoffset=0},
    Box={rootname="HitBox",text="supply",color=Color3.fromHex("#e4c3ff"),ringradius=6,ringyoffset=3.2,crate=true},
    SupplyCrate={rootname="HitBox",text="supply",color=Color3.fromHex("#e4c3ff"),ringradius=6,ringyoffset=3.2,crate=true}
}
local tracked={}
local tracked_by_address={}

local function nearest_model(instance)
    local current=instance
    while current do if current:IsA("Model")then return current end;current=current.Parent end
end
local function find_descendant(parent,name)
    if not parent then return nil end
    local direct=parent:FindFirstChild(name)
    if direct then return direct end
    local descendants=parent:GetDescendants()
    for i=1,#descendants do if descendants[i].Name==name then return descendants[i]end end
end
local function find_class(parent,classname)
    if not parent then return nil end
    local direct=parent:FindFirstChildWhichIsA(classname)
    if direct then return direct end
    local descendants=parent:GetDescendants()
    for i=1,#descendants do if descendants[i]:IsA(classname)then return descendants[i]end end
end
local function scrap_config_name(modelname)
    local n=tonumber(string.match(tostring(modelname),"^Scrap(%d+)"))
    local name=n and "Scrap"..tostring(n) or nil
    return name and esp_config[name] and name or nil
end
local function get_config(instance,model)
    local config=esp_config[instance.Name]
    if config and config.directpart and instance:IsA("BasePart")then return instance.Name,config end
    if model then
        config=esp_config[model.Name]
        if config and not config.directpart then return model.Name,config end
        local name=scrap_config_name(model.Name)
        if name then return name,esp_config[name]end
    end
end
local function resolve_part(instance,model,configname,config)
    if config.directpart then return instance:IsA("BasePart")and instance or nil,model end
    local recordmodel=model
    if configname=="SupplyCrate" and recordmodel and not find_descendant(recordmodel,config.rootname)then
        local box=recordmodel:FindFirstChild("Box")
        if box and box:IsA("Model")then recordmodel=box end
    end
    local part=recordmodel and find_descendant(recordmodel,config.rootname)
    return part and part:IsA("BasePart")and part or nil,recordmodel
end
local function find_items(model)
    if not model then return nil end
    local box=model
    if box.Name~="Box" then local inner=box:FindFirstChild("Box");if inner and inner:IsA("Model")then box=inner end end
    return box:FindFirstChild("Items_Folder")
end
local function ensure_labels(record)
    if record.name and record.distance then return end
    record.name=new_text(record.config.text,record.config.color,true,false)
    record.distance=new_text("0m",Color3.fromHex("#c9c9c9"),true,false)
end
local function ensure_ring(record)
    if record.config.noring or record.ring then return end
    record.ring={}
    for i=1,ring_segments do record.ring[i]=new_line(record.config.color)end
end
local function hide_ring(record)if record.ring then for i=1,#record.ring do hide_drawing(record.ring[i])end end end
local function ensure_crate(record)
    if not record.config.crate or record.items then return end
    record.bg=new_square(crate_bg_color,crate_bg_transparency);record.items={}
    for i=1,6 do record.items[i]=new_text("",crate_text_color,true,false,false)end
end
local function hide_record(record)
    hide_drawing(record.name);hide_drawing(record.distance);hide_ring(record);hide_drawing(record.bg)
    if record.items then for i=1,#record.items do hide_drawing(record.items[i])end end
end
local function remove_record(record)
    remove_drawing(record.name);remove_drawing(record.distance)
    if record.ring then for i=1,#record.ring do remove_drawing(record.ring[i])end end
    remove_drawing(record.bg)
    if record.items then for i=1,#record.items do remove_drawing(record.items[i])end end
end
local function add_object(instance)
    if not instance or #tracked>=max_tracked_objects then return end
    local model=nearest_model(instance)
    local configname,config=get_config(instance,model)
    if not config then return end
    local part,recordmodel=resolve_part(instance,model,configname,config)
    if not part then return end
    local source=recordmodel or part
    local address=source.Address
    if not address or tracked_by_address[address]then return end
    local record={address=address,object=part,model=recordmodel or part.Parent,configname=configname,config=config,folder=config.crate and find_items(recordmodel)or nil}
    tracked_by_address[address]=record;tracked[#tracked+1]=record
end
local function remove_tracked(i)
    local record=tracked[i]
    if not record then return end
    remove_record(record);tracked_by_address[record.address]=nil;tracked[i]=tracked[#tracked];tracked[#tracked]=nil
end

local function scan_world()
    local filter=workspace:FindFirstChild("Filter")
    if filter then
        local spawns=filter:FindFirstChild("ScrapSpawns")
        if spawns then
            local spawnchildren=spawns:GetChildren()
            for i=1,#spawnchildren do
                local spawnpoint=spawnchildren[i]
                if string.match(spawnpoint.Name,"ItemSpawn")then local children=spawnpoint:GetChildren();for j=1,#children do add_object(children[j])end end
            end
        end
        local points=filter:FindFirstChild("LocationPoints")
        if points then local children=points:GetChildren();for i=1,#children do add_object(children[i])end end
    end
    local children=workspace:GetChildren()
    for i=1,#children do if children[i].Name=="FlareGunPickUp"then add_object(children[i])end end
    local debris=workspace:FindFirstChild("Debris")
    if debris then
        local traps=debris:FindFirstChild("Traps")
        if traps then local c=traps:GetChildren();for i=1,#c do add_object(c[i])end end
        local crates=debris:FindFirstChild("SupplyCrates")
        if crates then local c=crates:GetChildren();for i=1,#c do add_object(c[i])end end
    end
end
local function viewer_position()
    local character=lp.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    return root and root:IsA("BasePart")and root.Position or camera.Position
end
local function distance_meters(a,b)
    local x,y,z=b.X-a.X,b.Y-a.Y,b.Z-a.Z
    return math.sqrt(x*x+y*y+z*z)*stud_to_meter
end
local function update_crate(record,screen,meters,yoffset)
    if not record.config.crate then return end
    if not record.folder then record.folder=find_items(record.model)end
    if meters>crate_show_distance or not record.folder then
        hide_drawing(record.bg);if record.items then for i=1,#record.items do hide_drawing(record.items[i])end end;return
    end
    ensure_crate(record)
    local children=record.folder:GetChildren()
    local visible=math.min(#children,#record.items)
    for i=1,#record.items do
        local d,child=record.items[i],children[i]
        if child then
            local n=i-1;local row=math.floor(n/3);local col=n%3
            d.Text=crate_names[child.Name]or child.Name;d.Color=crate_colors[child.Name]or crate_text_color
            d.Position=Vector2.new(screen.X+(col-1)*crate_col_spacing,screen.Y-12+yoffset+row*crate_row_spacing+crate_y_offset);d.Visible=true
        else d.Visible=false end
    end
    if visible>0 then
        local rows=math.max(1,math.ceil(visible/3));local firsty=screen.Y-12+yoffset+crate_y_offset;local miny=firsty-8-crate_pad_y
        record.bg.Size=Vector2.new(crate_bg_width,(rows-1)*crate_row_spacing+16+crate_pad_y*2);record.bg.Position=Vector2.new(screen.X-crate_bg_width/2,miny);record.bg.Visible=true
    else record.bg.Visible=false end
end
local function update_ring(record,world,meters)
    if record.config.noring then return end
    if meters>=ring_fade_distance then hide_ring(record);return end
    ensure_ring(record)
    local y=world.Y-(record.config.ringyoffset or 0);local radius=record.config.ringradius or 2;local alpha=clamp(1-meters/ring_fade_distance,0,1);local step=2*math.pi/ring_segments
    for i=1,ring_segments do
        local a=(i-1)*step;local b=i*step
        local sa,ona=WorldToScreen(Vector3.new(world.X+math.cos(a)*radius,y,world.Z+math.sin(a)*radius))
        local sb,onb=WorldToScreen(Vector3.new(world.X+math.cos(b)*radius,y,world.Z+math.sin(b)*radius))
        local line=record.ring[i]
        if toggle.esp and ona and onb then line.From=sa;line.To=sb;line.Color=record.config.color;line.Transparency=alpha;line.Visible=true else line.Visible=false end
    end
end
local function render_record(record,viewer)
    local object=record.object
    if not object or not object.Parent then return false end
    local world=object.Position
    local screen,on=WorldToScreen(world)
    if not on then hide_record(record);return true end
    local meters=distance_meters(viewer,world);local yoffset=record.config.textyoffset or 0
    ensure_labels(record)
    record.name.Position=Vector2.new(screen.X,screen.Y-12+yoffset);record.name.Visible=toggle.esp
    record.distance.Position=Vector2.new(screen.X,screen.Y+0.7+yoffset);record.distance.Text=tostring(math.floor(meters)).."m";record.distance.Visible=toggle.esp
    update_crate(record,screen,meters,yoffset);update_ring(record,world,meters)
    return true
end

local rake_target=nil
local rake_roof=nil
local rake_health=nil
local function refresh_rake()
    local rake=workspace:FindFirstChild("Rake")
    rake_target=rake and rake:FindFirstChild("TargetVal")or nil
    local map=workspace:FindFirstChild("Map");local safehouse=map and map:FindFirstChild("SafeHouse");local rakebreak=safehouse and find_descendant(safehouse,"RakeBreak");local breakmodel=rakebreak and find_descendant(rakebreak,"BreakModel");local health=breakmodel and find_descendant(breakmodel,"Health")
    if breakmodel and health and health:IsA("IntValue")then rake_roof=breakmodel;rake_health=health;roof_health_text.Text=tostring(health.Value).."/30" else rake_roof=nil;rake_health=nil end
end
local function character_from_part(part)
    local current=part
    while current do if current:FindFirstChild("Humanoid")then return current end;current=current.Parent end
end
local function update_roof()
    if not toggle.esp or not rake_roof or not rake_health then roof_label.Visible=false;roof_health_text.Visible=false;return end
    local part=find_class(rake_roof,"BasePart")
    if not part then roof_label.Visible=false;roof_health_text.Visible=false;return end
    local screen,on=WorldToScreen(part.Position)
    if not on then roof_label.Visible=false;roof_health_text.Visible=false;return end
    roof_health_text.Text=tostring(rake_health.Value).."/30";roof_label.Position=Vector2.new(screen.X,screen.Y-15);roof_health_text.Position=Vector2.new(screen.X,screen.Y-3);roof_label.Visible=true;roof_health_text.Visible=true
end
local function update_power()
    local any=false
    for i=1,#power_entries do
        local entry=power_entries[i];local value=power_values:FindFirstChild(entry.valuename);local active=value and value.Value==true
        power_lines[i].Visible=toggle.hud and active or false;if power_lines[i].Visible then any=true end
    end
    power_label.Visible=toggle.hud and any;update_power_positions()
end
local function update_target()
    local target=rake_target and rake_target.Value or nil
    if target and typeof(target)=="Instance"and target:IsA("BasePart")then local character=character_from_part(target);target_text.Text=character and character.Name or "unknown" else target_text.Text="none" end
end
local function update_scrap()
    local backpack=lp:FindFirstChild("Backpack")or lp:FindFirstChild("backpack");local folder=backpack and backpack:FindFirstChild("ScrapFolder");local points=folder and folder:FindFirstChild("Points")
    scrap_text.Text=points and points:IsA("IntValue")and tostring(points.Value)or"0"
end
local function update_timer()
    local timer=math.max(0,math.floor(tonumber(timer_value.Value)or 0));timer_text.Text=string.format("%d:%02d",math.floor(timer/60),timer%60);timer_text.Color=timer<=15 and Color3.fromHex("#fc8f8f")or Color3.fromHex("#ffffff")
end
local function update_hud_visibility()
    for i=1,#hud_objects do hud_objects[i].Visible=toggle.hud end
    update_power()
end
local function teleport_scrap()
    local character=lp.Character;local root=character and character:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart")then return end
    for i=1,#tracked do local record=tracked[i];if record.configname and string.match(record.configname,"^Scrap%d+$")then local destination=record.model and find_class(record.model,"BasePart");if destination then root.Position=destination.Position;return end end end
end
local function teleport_flare()
    local character=lp.Character;local root=character and character:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart")then return end
    for i=1,#tracked do local record=tracked[i];if record.configname=="FlareGunPickUp"then root.Position=record.object.Position;return end end
end
local function update_keys()
    local f1,f2,f3,f4=iskeypressed(0x70),iskeypressed(0x71),iskeypressed(0x72),iskeypressed(0x73)
    if f1 and not keyheld.f1 then toggle.esp=not toggle.esp;if not toggle.esp then for i=1,#tracked do hide_record(tracked[i])end;roof_label.Visible=false;roof_health_text.Visible=false end end
    if f2 and not keyheld.f2 then toggle.hud=not toggle.hud;update_hud_visibility()end
    if f3 and not keyheld.f3 then teleport_scrap()end
    if f4 and not keyheld.f4 then teleport_flare()end
    keyheld.f1,keyheld.f2,keyheld.f3,keyheld.f4=f1,f2,f3,f4
end
local function render_esp()
    update_keys()
    if not toggle.esp then return end
    local viewer=viewer_position();local i=#tracked
    while i>=1 do local record=tracked[i];local ok,alive=pcall(function()return render_record(record,viewer)end);if not ok or not alive then remove_tracked(i)end;i=i-1 end
    update_roof()
end

local last_x,last_y=camera.ViewportSize.X,camera.ViewportSize.Y
spawn(function()
    while true do
        local v=camera.ViewportSize
        if v.X~=last_x or v.Y~=last_y then last_x,last_y=v.X,v.Y;update_hud_positions()end
        update_timer();task.wait(hud_update_interval)
    end
end)
spawn(function()while true do update_scrap();update_power();update_target();task.wait(status_update_interval)end end)
spawn(function()
    while true do
        pcall(function()scan_world();refresh_rake()end)
        task.wait(world_scan_interval)
    end
end)
spawn(function()
    while true do
        pcall(render_esp)
        task.wait()
    end
end)
print("binds are on thread | version "..version)
