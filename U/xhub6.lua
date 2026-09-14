local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- =======================================
Library.Scheme.AccentColor = Color3.fromRGB(115, 60, 215)
Library.Scheme.BackgroundColor = Color3.fromRGB(8, 7, 13)
Library.Scheme.MainColor = Color3.fromRGB(16, 13, 26)
Library.Scheme.OutlineColor = Color3.fromRGB(65, 35, 115)
Library.Scheme.FontColor = Color3.fromRGB(235, 225, 255)
-- =======================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- =======================================
-- XHUB TOGGLE MENU (ปรับแต่งโทนสีม่วงตามรูปภาพ)
local function CreateXHUBToggleMenu(IconId)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XHUBToggle"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainButton = Instance.new("TextButton")
    MainButton.Name = "ToggleButton"
    MainButton.Text = ""
    MainButton.AutoButtonColor = false
    MainButton.Size = UDim2.fromOffset(38,38)
    MainButton.Position = UDim2.fromOffset(15,120)
    MainButton.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
    MainButton.BackgroundTransparency = 0.2
    MainButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1,0)
    Corner.Parent = MainButton

    local GlowStroke = Instance.new("UIStroke")
    GlowStroke.Name = "RotatingGlow"
    GlowStroke.Color = Color3.fromRGB(255, 255, 255)
    GlowStroke.Thickness = 2.0
    GlowStroke.Transparency = 0
    GlowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    GlowStroke.Parent = MainButton

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 60)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(115, 60, 215)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 30, 160)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(115, 60, 215)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 15, 60))
    })
    Gradient.Parent = GlowStroke

    task.spawn(function()
        local speed = 0.005
        while true do
            for i = 0, 1, speed do
                Gradient.Rotation = i * 360
                task.wait()
            end
        end
    end)

    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.fromScale(1,1)
    IconFrame.Position = UDim2.fromScale(0,0)
    IconFrame.BackgroundTransparency = 1
    IconFrame.Parent = MainButton

    local Icon = Library:GetCustomIcon(IconId)
    if Icon then
        local Image = Instance.new("ImageLabel")
        Image.BackgroundTransparency = 1
        Image.Image = Icon.Url
        Image.ImageRectOffset = Icon.ImageRectOffset
        Image.ImageRectSize = Icon.ImageRectSize
        Image.Size = UDim2.fromScale(1,1)
        Image.Parent = IconFrame

        local ImageCorner = Instance.new("UICorner")
        ImageCorner.CornerRadius = UDim.new(1, 0)
        ImageCorner.Parent = Image
    end

    MainButton.MouseButton1Click:Connect(function()
        game:GetService("TweenService"):Create(
            MainButton,
            TweenInfo.new(.08),
            { Size = UDim2.fromOffset(33, 33) }
        ):Play()
        task.wait(.08)
        game:GetService("TweenService"):Create(
            MainButton,
            TweenInfo.new(.08),
            { Size = UDim2.fromOffset(38, 38) }
        ):Play()
        Library:Toggle()
    end)

    Library:MakeDraggable(MainButton, MainButton, true)
    return MainButton, ScreenGui
end

CreateXHUBToggleMenu(117783588930400)
-- =======================================
-- WINDOW
-- =======================================
local Window = Library:CreateWindow({
    Title = "",
    Footer = "XHUB ",
    Icon = 117783588930400,
    IconSize = UDim2.fromOffset(40, 40),
    CornerRadius = 20,
    NotifySide = "Right",
    ShowCustomCursor = true,
    ShowMobileButtons = false,
    ToggleKeybind = Enum.KeyCode.LeftControl,
    Size = UDim2.fromOffset(400, 300),
    EnableSidebarResize = false,
    EnableCompacting = true,
    SidebarCompacted = true,
})

task.spawn(function()
    local windowFrame = nil
    while not windowFrame do
        task.wait(0.2)
        for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, desc in ipairs(gui:GetDescendants()) do
                    if desc:IsA("Frame") and desc.Size.X.Offset == 400 and desc.Size.Y.Offset == 300 then
                        windowFrame = desc
                        break
                    end
                end
            end
            if windowFrame then break end
        end
    end
    if windowFrame then
        local GlowStroke = Instance.new("UIStroke")
        GlowStroke.Name = "WindowGlowStroke"
        GlowStroke.Color = Color3.fromRGB(255, 255, 255)
        GlowStroke.Thickness = 2
        GlowStroke.Transparency = 0
        GlowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        GlowStroke.Parent = windowFrame

        local Gradient = Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 40, 160)),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(190, 120, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 210, 255)),
            ColorSequenceKeypoint.new(0.7, Color3.fromRGB(190, 120, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 40, 160))
        })
        Gradient.Parent = GlowStroke

        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            while true do
                local t1 = TweenService:Create(Gradient, tweenInfo, {Offset = Vector2.new(1, 0)})
                t1:Play()
                t1.Completed:Wait()
                task.wait(1)
                local t2 = TweenService:Create(Gradient, tweenInfo, {Offset = Vector2.new(-1, 0)})
                t2:Play()
                t2.Completed:Wait()
                task.wait(1)
            end
        end)
    end
end)

local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local Watermark = Library:AddDraggableLabel("XHUB")
local FPS = 0
local Frames = 0
local LastTick = tick()

RunService.RenderStepped:Connect(function()
    Frames += 1
    if tick() - LastTick >= 1 then
        FPS = Frames
        Frames = 0
        LastTick = tick()
        local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Watermark:SetText(string.format("XHUB|FPS:%d|PING:%d", FPS, Ping))
    end
end)

-- ============================================================
-- MASTER HEARTBEAT LOOP
-- ============================================================
local MasterTasks = {}
local function RegisterTask(name, interval, fn)
    MasterTasks[#MasterTasks + 1] = { name = name, interval = interval, timer = 0, fn = fn }
end

RunService.Heartbeat:Connect(function(dt)
    for i = 1, #MasterTasks do
        local t = MasterTasks[i]
        t.timer = t.timer + dt
        if t.timer >= t.interval then
            t.timer = 0
            t.fn(dt)
        end
    end
end)

-- ============================================================
-- SILENT AIM SYSTEM (TWIST OF FATE) BACKEND
-- ============================================================
getgenv().SilentAimSettings = {
    Enabled = false,
    FovVisible = true,
    LaserEsp = false,
    TargetType = "Killer",
    FovRadius = 500,
    Prediction = true,
    Damping = true,
}
local SA_Settings = getgenv().SilentAimSettings

local STATE = {
    silentAimEnabled = false,
    silentAimFovVisible = true,
    laserEspEnabled = false,
    silentAimTarget = nil,
    silentAimLookVector = nil,
    silentAimPredictedPos = nil,
    silentAimTrackChar = nil,
    silentAimHistory = {},
    silentAimSmoothedVel = Vector3.new(0, 0, 0),
    silentAimTargetVel = Vector3.new(0, 0, 0),
    triggerLaser = false,
    currentMuzzlePos = nil,
    currentTargetPos = nil,
    FOVCircle = nil,
}

local ACCENT_COLOR = Color3.fromRGB(255, 255, 255)

local function getRole(player)
    if not player then return "survivor" end
    local ok, teamName = pcall(function()
        return player.Team and player.Team.Name:lower() or ""
    end)
    return (ok and teamName:find("killer")) and "killer" or "survivor"
end

local zombieCache = {}
local zombieCacheTime = 0

local function IsScpModelName(name)
    if type(name) ~= "string" or name == "" then return false end
    local low = name:lower()
    if low:find("zombie") then return true end
    if low == "scp" then return true end
    for i = 1, 9 do
        if low == ("scp" .. i) or low:find("^scp%-" .. i) then return true end
    end
    return false
end

local function GetScpModelRoot(model)
    local root = model.PrimaryPart
    if not root then
        local found = model:FindFirstChild("HumanoidRootPart")
        if found and found:IsA("BasePart") then root = found end
    end
    if not root then
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA("BasePart") then
                root = child
                break
            end
        end
    end
    return root
end

local function RefreshZombieCache()
    local playerChars = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then playerChars[plr.Character] = true end
    end
    local list = {}
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and not playerChars[model] and IsScpModelName(model.Name) then
            list[#list + 1] = model
        end
    end
    zombieCache = list
    zombieCacheTime = tick()
end

do
    local function CreateFOVCircle()
        local sg = Instance.new("ScreenGui")
        sg.Name = "SilentAimFOV"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 999999
        pcall(function()
            sg.Parent = (gethui and gethui() or CoreGui)
        end)
        if not sg.Parent then
            sg.Parent = localPlayer:WaitForChild("PlayerGui")
        end

        STATE.FOVCircle = Instance.new("Frame")
        STATE.FOVCircle.Size = UDim2.new(0, SA_Settings.FovRadius * 2, 0, SA_Settings.FovRadius * 2)
        STATE.FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
        STATE.FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        STATE.FOVCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        STATE.FOVCircle.BackgroundTransparency = 1
        STATE.FOVCircle.Visible = false
        STATE.FOVCircle.Parent = sg

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = STATE.FOVCircle

        local stroke = Instance.new("UIStroke")
        stroke.Color = ACCENT_COLOR
        stroke.Thickness = 2
        stroke.Transparency = 0.2
        stroke.Parent = STATE.FOVCircle
    end
    CreateFOVCircle()

    local function GetTorsoCenter(char)
        if not char then return nil end
        local upperTorso = char:FindFirstChild("UpperTorso")
        if upperTorso and upperTorso:IsA("BasePart") then return upperTorso.Position end
        local torso = char:FindFirstChild("Torso")
        if torso and torso:IsA("BasePart") then return torso.Position end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then return root.Position end
        return nil
    end

    local function GetGunMuzzlePosition()
        local char = localPlayer.Character
        if not char then return nil end
        local ok, gun = pcall(function()
            return char:FindFirstChild("Twist of Fate"):FindFirstChild("Right Arm"):FindFirstChild("gun"):FindFirstChild("gun")
        end)
        if ok and gun and gun:IsA("BasePart") then return gun.Position end
        local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
        if rArm then return rArm.Position end
        return nil
    end

    local TwistOfFateRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Items"):WaitForChild("Twist of Fate"):WaitForChild("Fire")
    local originalNamecall
    pcall(function()
        originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and rawequal(self, TwistOfFateRemote) then
                local args = table.pack(...)
                if STATE.silentAimEnabled and typeof(STATE.silentAimLookVector) == "Vector3" then
                    if args.n >= 3 and typeof(args[3]) == "Vector3" then
                        args[3] = STATE.silentAimLookVector
                        if STATE.laserEspEnabled then STATE.triggerLaser = true end
                    elseif args.n >= 2 and typeof(args[2]) == "Vector3" then
                        args[2] = STATE.silentAimLookVector
                        if STATE.laserEspEnabled then STATE.triggerLaser = true end
                    end
                end
                return originalNamecall(self, table.unpack(args, 1, args.n))
            end
            return originalNamecall(self, ...)
        end)
    end)

    RegisterTask("UpdateSilentAimTarget", 0.02, function()
        STATE.silentAimEnabled = SA_Settings.Enabled
        STATE.silentAimFovVisible = SA_Settings.Enabled and SA_Settings.FovVisible
        STATE.laserEspEnabled = SA_Settings.LaserEsp

        if STATE.FOVCircle then
            STATE.FOVCircle.Visible = STATE.silentAimFovVisible
            local targetSize = SA_Settings.FovRadius * 2
            if STATE.FOVCircle.Size.X.Offset ~= targetSize then
                STATE.FOVCircle.Size = UDim2.new(0, targetSize, 0, targetSize)
            end
        end

        if not STATE.silentAimEnabled then
            STATE.silentAimTarget = nil
            STATE.silentAimLookVector = nil
            STATE.silentAimPredictedPos = nil
            STATE.silentAimTrackChar = nil
            STATE.silentAimHistory = {}
            return
        end

        local myChar = localPlayer.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local camera = Workspace.CurrentCamera
        if not camera then return end

        local bestPos = nil
        local bestDist = math.huge
        local bestChar = nil
        local targetMode = SA_Settings.TargetType or "Killer"

        if targetMode == "Zombie" then
            if tick() - zombieCacheTime > 0.5 then RefreshZombieCache() end
            for i = 1, #zombieCache do
                local model = zombieCache[i]
                if model and model.Parent then
                    local root = GetScpModelRoot(model)
                    if root then
                        local pos = root.Position
                        local dist = (pos - myRoot.Position).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            bestPos = pos
                            bestChar = model
                        end
                    end
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    if targetMode == "Killer" and getRole(player) ~= "killer" then continue end
                    if targetMode == "Survivor" and getRole(player) ~= "survivor" then continue end
                    local pChar = player.Character
                    if pChar then
                        local pHum = pChar:FindFirstChildOfClass("Humanoid")
                        local pTorso = GetTorsoCenter(pChar)
                        if pHum and pHum.Health > 0 and typeof(pTorso) == "Vector3" then
                            local dist = (pTorso - myRoot.Position).Magnitude
                            if dist < bestDist then
                                bestDist = dist
                                bestPos = pTorso
                                bestChar = pChar
                            end
                        end
                    end
                end
            end
        end

        local now = tick()
        local smoothedVel = STATE.silentAimSmoothedVel
        if typeof(smoothedVel) ~= "Vector3" then smoothedVel = Vector3.new(0, 0, 0) end

        if typeof(bestPos) == "Vector3" then
            if STATE.silentAimTrackChar ~= bestChar then
                STATE.silentAimTrackChar = bestChar
                STATE.silentAimHistory = {}
                smoothedVel = Vector3.new(0, 0, 0)
            end
            local hist = STATE.silentAimHistory
            table.insert(hist, { pos = bestPos, t = now })
            while #hist > 1 and hist[1].t < now - 0.4 do
                table.remove(hist, 1)
            end
            if #hist >= 2 then
                local a = hist[#hist - 1]
                local b = hist[#hist]
                local dt = b.t - a.t
                if dt > 0.001 then
                    local dp = (b.pos - a.pos) / dt
                    local inst = Vector3.new(dp.X, 0, dp.Z)
                    local root = bestChar and bestChar:FindFirstChild("HumanoidRootPart")
                    if root and root:IsA("BasePart") then
                        local ok, av = pcall(function() return root.AssemblyLinearVelocity end)
                        if ok and typeof(av) == "Vector3" then
                            local ha = Vector3.new(av.X, 0, av.Z)
                            if ha.Magnitude > 0.5 and ha.Magnitude < 100 then
                                inst = inst:Lerp(ha, 0.5)
                            end
                        end
                    end
                    if inst.Magnitude > 65 then inst = inst.Unit * 65 end
                    if SA_Settings.Damping and smoothedVel.Magnitude > 2 and inst.Magnitude > 2 then
                        if smoothedVel:Dot(inst) / (smoothedVel.Magnitude * inst.Magnitude) < 0 then
                            inst = inst * 0.7
                        end
                    end
                    smoothedVel = smoothedVel:Lerp(inst, 0.45)
                end
            end
            local hvel = Vector3.new(smoothedVel.X, 0, smoothedVel.Z)
            if hvel.Magnitude > 65 then hvel = hvel.Unit * 65 end
            smoothedVel = hvel
        else
            STATE.silentAimTrackChar = nil
            STATE.silentAimHistory = {}
            smoothedVel = Vector3.new(0, 0, 0)
        end
        STATE.silentAimTargetVel = smoothedVel
        STATE.silentAimSmoothedVel = smoothedVel

        if typeof(bestPos) == "Vector3" then
            local kTorso = bestPos
            local inFov = true
            local screenPos, onScreen = camera:WorldToViewportPoint(kTorso)
            if onScreen then
                local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist2D > SA_Settings.FovRadius then inFov = false end
            else
                inFov = false
            end

            if inFov then
                local muzzlePos = GetGunMuzzlePosition()
                if typeof(muzzlePos) ~= "Vector3" then muzzlePos = camera.CFrame.Position end
                local aimBase = kTorso - Vector3.new(0, 1.2, 0)
                local rawVec = aimBase - muzzlePos
                local mag = rawVec.Magnitude
                if mag > 0.1 then
                    local aimPos = aimBase
                    if SA_Settings.Prediction then
                        local targetVel = STATE.silentAimSmoothedVel
                        local leadLag = 0.1
                        local tof = mag / 200 + leadLag
                        aimPos = aimBase + targetVel * tof
                        local predVec = aimPos - muzzlePos
                        if predVec.Magnitude > 0.1 then
                            tof = predVec.Magnitude / 200 + leadLag
                            aimPos = aimBase + targetVel * tof
                        end
                        STATE.silentAimPredictedPos = aimPos
                    else
                        STATE.silentAimPredictedPos = nil
                    end
                    local aimVec = aimPos - muzzlePos
                    local aimMag = aimVec.Magnitude
                    if aimMag > 0.1 then
                        STATE.silentAimTarget = kTorso
                        STATE.silentAimLookVector = Vector3.new(aimVec.X / aimMag, aimVec.Y / aimMag, aimVec.Z / aimMag)
                        STATE.currentMuzzlePos = muzzlePos
                        STATE.currentTargetPos = aimPos
                    else
                        STATE.silentAimTarget = nil
                        STATE.silentAimLookVector = nil
                    end
                else
                    STATE.silentAimTarget = nil
                    STATE.silentAimLookVector = nil
                end
            else
                STATE.silentAimTarget = nil
                STATE.silentAimLookVector = nil
            end
        else
            STATE.silentAimTarget = nil
            STATE.silentAimLookVector = nil
        end
    end)

    RegisterTask("DrawLaserESP", 0, function()
        if not STATE.triggerLaser then return end
        STATE.triggerLaser = false
        local startP = STATE.currentMuzzlePos
        local endP = STATE.currentTargetPos
        if typeof(startP) ~= "Vector3" or typeof(endP) ~= "Vector3" then return end
        local distance = (startP - endP).Magnitude
        if distance < 0.1 then return end

        local laser = Instance.new("Part")
        laser.Name = "SilentLaser"
        laser.Anchored = true
        laser.CanCollide = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(255, 0, 0)
        laser.Transparency = 0.3
        laser.Size = Vector3.new(0.15, 0.15, distance)
        laser.CFrame = CFrame.new(startP, endP) * CFrame.new(0, 0, -distance / 2)
        laser.Parent = Workspace

        task.delay(0.4, function()
            if laser then laser:Destroy() end
        end)
    end)
end

-- ============================================================
-- GRAPHICS & ZOOM OUT BACKEND CONFIG
-- ============================================================
local Visual = {
    Fullbright = false,
    NoShadow = false,
    Ambient = false,
    AmbientColor = Color3.fromRGB(255,255,255),
    ClockTimeEnabled = true,
    Brightness = 2,
    ClockTime = 14,
    LowGraphics = false,
    LowRender = false,
    NoFog = false,
    CleanSky = false,
    NoScreenEffects = false
}

local original = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows
}

local LastVisualState = { Fullbright = nil, NoShadow = nil, Ambient = nil, AmbientColor = nil, Brightness = nil, ClockTime = nil }

local function applyVisual(force)
    if force or LastVisualState.Fullbright ~= Visual.Fullbright then
        LastVisualState.Fullbright = Visual.Fullbright
        if Visual.Fullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(1,1,1)
            Lighting.OutdoorAmbient = Color3.new(1,1,1)
        else
            Lighting.Brightness = original.Brightness
            Lighting.ClockTime = original.ClockTime
            Lighting.Ambient = original.Ambient
            Lighting.OutdoorAmbient = original.OutdoorAmbient
        end
    end
    if force or LastVisualState.NoShadow ~= Visual.NoShadow then
        LastVisualState.NoShadow = Visual.NoShadow
        Lighting.GlobalShadows = not Visual.NoShadow
    end
end

local LastOptimizationState = { LowGraphics = nil, LowRender = nil, CleanSky = nil }
local function applyOptimization(force)
    if force or LastOptimizationState.LowGraphics ~= Visual.LowGraphics then
        LastOptimizationState.LowGraphics = Visual.LowGraphics
        pcall(function()
            if Visual.LowGraphics then
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            else
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end
        end)
    end
    if force or LastOptimizationState.CleanSky ~= Visual.CleanSky then
        LastOptimizationState.CleanSky = Visual.CleanSky
        if Visual.CleanSky then
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("Sky") then v:Destroy() end
            end
        end
    end
end

local ScreenEffectTypes = { "ColorCorrectionEffect", "DepthOfFieldEffect", "BlurEffect", "SunRaysEffect", "BloomEffect" }
local DisabledEffects = {}
local function applyNoScreenEffects()
    if Visual.NoScreenEffects then
        for _, v in pairs(Lighting:GetChildren()) do
            for _, t in pairs(ScreenEffectTypes) do
                if v:IsA(t) then
                    DisabledEffects[v] = v.Enabled
                    v.Enabled = false
                end
            end
        end
    else
        for obj, state in pairs(DisabledEffects) do
            if obj and obj.Parent then
                obj.Enabled = state
            end
        end
        DisabledEffects = {}
    end
end

Lighting.ChildAdded:Connect(function(v)
    if not Visual.NoScreenEffects then return end
    task.wait()
    for _, t in pairs(ScreenEffectTypes) do
        if v:IsA(t) then
            DisabledEffects[v] = v.Enabled
            v.Enabled = false
        end
    end
end)

local CameraZoom = { UnlimitedZoom = false, MaxDistance = 1000, MinDistance = 0, FOVEnabled = false, FOV = 70, DefaultFOV = Workspace.CurrentCamera.FieldOfView }
local function applyUnlimitedZoom()
    if CameraZoom.UnlimitedZoom then
        localPlayer.CameraMaxZoomDistance = CameraZoom.MaxDistance
        localPlayer.CameraMinZoomDistance = CameraZoom.MinDistance
    else
        localPlayer.CameraMaxZoomDistance = 128
        localPlayer.CameraMinZoomDistance = 0.5
    end
end

local function applyCameraFOV()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    if CameraZoom.FOVEnabled then
        cam.FieldOfView = CameraZoom.FOV
    else
        cam.FieldOfView = CameraZoom.DefaultFOV
    end
end

-- ============================================================
-- MASKED POWER SYSTEM BACKEND
-- ============================================================
local Masked = { Enabled = false, CurrentPower = "Cobra" }
local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

-- ============================================================
-- AUTO STALK SYSTEM BACKEND
-- ============================================================
local AutoStalk = { Enabled = true, Range = 1000 }
RegisterTask("AutoStalkMonitor", 0.15, function()
    if not AutoStalk.Enabled then return end
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local closestPlayer = nil
    local shortestDist = AutoStalk.Range
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Team and p.Team.Name == "Survivors" and p.Character then
            local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
            local pHum = p.Character:FindFirstChildOfClass("Humanoid")
            if pRoot and pHum and pHum.Health > 0 then
                local dist = (pRoot.Position - root.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestPlayer = p
                end
            end
        end
    end
    if closestPlayer then
        local StalkEvent = ReplicatedStorage:FindFirstChild("Remotes", true) and ReplicatedStorage.Remotes:FindFirstChild("Killers", true) and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true) and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
        if StalkEvent then
            pcall(function() StalkEvent:FireServer(closestPlayer) end)
        end
    end
end)

-- ============================================================
-- AUTO PARRY SYSTEM
-- ============================================================
getgenv().AutoParrySettings = { Enabled = false, RadiusEsp = false, Radius = 11 }
local AP_Settings = getgenv().AutoParrySettings
local lastParryTime = 0
local activeAttackers = {}
local toggleAutoParryESP

do
    local ATTACK_ANIMS = {
        [78432063483146] = true, [121216847022485] = true, [74968262036854] = true, [132817836308238] = true,
        [82666958311998] = true, [111920872708571] = true, [106871536134254] = true, [109402730355822] = true,
        [130593238885843] = true, [138720291317243] = true, [139369275981139] = true, [133963973694098] = true, [78935059863801] = true
    }
    local LUNGE_ANIMS = {
        [118907603246885] = true, [135002183282873] = true, [113255068724446] = true, [129784271201071] = true,
        [105374834496520] = true, [117070354890871] = true, [115244153053858] = true, [110355011987939] = true,
        [117042998468241] = true, [122812055447896] = true
    }
    local VALID_ANIM_IDS = {}
    for id, _ in pairs(ATTACK_ANIMS) do VALID_ANIM_IDS["rbxassetid://" .. id] = "attack" end
    for id, _ in pairs(LUNGE_ANIMS) do VALID_ANIM_IDS["rbxassetid://" .. id] = "lungehold" end

    local function getKillerName(player, char)
        if not player or not char then return nil end
        if player == localPlayer then
            local attr = localPlayer:GetAttribute("SelectedKiller")
            if attr then return attr end
        end
        local ok, values = pcall(function() return char:WaitForChild("Values", 2) end)
        if ok and values then
            local killerNameVal = values:FindFirstChild("KillerName")
            if killerNameVal and killerNameVal:IsA("StringValue") then return killerNameVal.Value end
        end
        local attr = player:GetAttribute("SelectedKiller")
        if attr then return attr end
        return nil
    end

    local function doParry()
        if not AP_Settings.Enabled then return end
        if tick() - lastParryTime < 0.15 then return end
        lastParryTime = tick()
        local char = localPlayer.Character
        if not char then return end
        local mobGui = PlayerGui:FindFirstChild("Survivor-mob")
        local controls = mobGui and mobGui:FindFirstChild("Controls")
        local btn = controls and controls:FindFirstChild("Gui-mob")
        if btn and btn:IsA("ImageButton") then
            firesignal(btn.MouseButton1Down)
            task.delay(0.05, function()
                if btn and btn.Parent then firesignal(btn.MouseButton1Up) end
            end)
        else
            local ok, fakeInput = pcall(function()
                local obj = Instance.new("InputObject")
                obj.UserInputType = Enum.UserInputType.MouseButton2
                obj.UserInputState = Enum.UserInputState.Begin
                return obj
            end)
            if ok and fakeInput then
                for _, conn in getconnections(UserInputService.InputBegan) do conn:Fire(fakeInput, false) end
            else
                VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            task.defer(function()
                pcall(function()
                    if CollectionService:HasTag(root, "doing action") then CollectionService:RemoveTag(root, "doing action") end
                end)
            end)
        end
    end

    local function validateAndParry(killerChar, killerName)
        local localChar = localPlayer.Character
        if not localChar then return end
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end
        local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
        if not killerRoot then return end
        local ping = Players.LocalPlayer:GetNetworkPing()
        local clampedPing = math.clamp(ping, 0, 0.5)
        local killerVel = killerRoot.AssemblyLinearVelocity
        local flatKillerVel = Vector3.new(killerVel.X, 0, killerVel.Z)
        local predictedKillerPos = killerRoot.Position + (flatKillerVel * clampedPing)
        local distVec = localRoot.Position - predictedKillerPos
        local distance = distVec.Magnitude
        local effectiveRadius = AP_Settings.Radius + 3
        if distance > effectiveRadius then return end
        local dirToPlayer = (localRoot.Position - killerRoot.Position).Unit
        if flatKillerVel.Magnitude > 8 then
            local velDot = flatKillerVel.Unit:Dot(dirToPlayer)
            if velDot < -0.1 then return end
        end
        if distance >= 15 then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {localChar, killerChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local hit = Workspace:Raycast(killerRoot.Position, distVec, rayParams)
            if hit and hit.Instance and not hit.Instance:IsDescendantOf(localChar) then return end
        end
        doParry()
    end

    local function OnParryCharacterAdded(player, char)
        if player == localPlayer then return end
        task.wait(0.5)
        if not char.Parent then return end
        local killerName = getKillerName(player, char)
        if killerName or (player.Team and player.Team.Name:lower():find("killer")) then
            local kName = killerName or "Unknown Killer"
            local humanoid = char:WaitForChild("Humanoid", 3)
            if humanoid then
                local animator = humanoid:WaitForChild("Animator", 3)
                if animator then
                    animator.AnimationPlayed:Connect(function(track)
                        if not AP_Settings.Enabled then return end
                        if track and track.Animation then
                            local animType = VALID_ANIM_IDS[track.Animation.AnimationId]
                            if animType then
                                activeAttackers[char] = { name = kName, track = track, type = animType }
                                if animType == "attack" then validateAndParry(char, kName) end
                                local conn
                                conn = track.Stopped:Connect(function()
                                    if conn then conn:Disconnect() end
                                    task.delay(0.3, function()
                                        if activeAttackers[char] and activeAttackers[char].track == track then activeAttackers[char] = nil end
                                    end)
                                end)
                            end
                        end
                    end)
                end
            end
        end
    end

    local function OnParryPlayerAdded(player)
        if player == localPlayer then return end
        if player.Character then
            task.spawn(function() OnParryCharacterAdded(player, player.Character) end)
        end
        player.CharacterAdded:Connect(function(char)
            task.spawn(function() OnParryCharacterAdded(player, char) end)
        end)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then OnParryPlayerAdded(player) end
    end
    Players.PlayerAdded:Connect(OnParryPlayerAdded)

    RegisterTask("AttackersMonitor", 0, function()
        if not AP_Settings.Enabled then return end
        if next(activeAttackers) == nil then return end
        for killerChar, data in pairs(activeAttackers) do
            if not killerChar or not killerChar.Parent or not data.track then
                activeAttackers[killerChar] = nil
            else
                if not data.track.IsPlaying then
                    activeAttackers[killerChar] = nil
                else
                    if data.type == "attack" then
                        if data.track.TimePosition < 0.35 then validateAndParry(killerChar, data.name) end
                    elseif data.type == "lungehold" then
                        local localChar = localPlayer.Character
                        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
                        local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
                        if localRoot and killerRoot then
                            local dist = (killerRoot.Position - localRoot.Position).Magnitude
                            if dist <= AP_Settings.Radius * 0.9 then validateAndParry(killerChar, data.name) end
                        end
                    end
                end
            end
        end
    end)

    local espRing = {}
    local espLoop = nil
    local espCache = {}
    local SEGMENTS = 32
    local lastRadius = -1
    local isEspActive = false

    local function buildRing()
        for _, p in ipairs(espRing) do if p and p.Parent then p:Destroy() end end
        espRing = {}
        espCache = {}
        local step = (2 * math.pi) / SEGMENTS
        for i = 1, SEGMENTS do
            local angle = step * (i - 1)
            local nextAngle = step * i
            espCache[i] = { cx = math.cos(angle), cz = math.sin(angle), nx = math.cos(nextAngle), nz = math.sin(nextAngle) }
            local seg = Instance.new("Part")
            seg.Shape = Enum.PartType.Block
            seg.Anchored = true
            seg.CanCollide = false
            seg.CanQuery = false
            seg.CastShadow = false
            seg.Material = Enum.Material.Neon
            seg.Color = Color3.fromRGB(255, 60, 60)
            seg.Transparency = 0.15
            seg.Size = Vector3.new(0.08, 0.08, 0.1)
            seg.Name = "BolongESP_Seg"
            seg.Parent = Workspace
            espRing[i] = seg
        end
    end

    local function updateSegmentSizes(radius)
        local arcLen = (2 * math.pi * radius) / SEGMENTS
        for _, seg in ipairs(espRing) do
            if seg and seg.Parent then seg.Size = Vector3.new(0.08, 0.08, arcLen + 0.02) end
        end
    end

    local function destroyRing()
        for _, p in ipairs(espRing) do if p and p.Parent then p:Destroy() end end
        espRing = {}
        espCache = {}
        lastRadius = -1
    end

    function toggleAutoParryESP(state)
        if state then
            buildRing()
            espLoop = RunService.RenderStepped:Connect(function()
                if not localPlayer.Character then return end
                local root = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local radius = AP_Settings.Radius
                if radius ~= lastRadius then
                    updateSegmentSizes(radius)
                    lastRadius = radius
                end
                local center = root.Position - Vector3.new(0, root.Size.Y / 2 + 1.5, 0)
                for i, seg in ipairs(espRing) do
                    if seg and seg.Parent then
                        local c = espCache[i]
                        local pos = center + Vector3.new(c.cx * radius, 0, c.cz * radius)
                        local nxt = center + Vector3.new(c.nx * radius, 0, c.nz * radius)
                        seg.CFrame = CFrame.lookAt(pos, nxt) * CFrame.new(0, 0, -seg.Size.Z / 2)
                    end
                end
            end)
        else
            if espLoop then espLoop:Disconnect() espLoop = nil end
            destroyRing()
        end
    end

    RegisterTask("EspMonitor", 0.5, function()
        if AP_Settings.RadiusEsp and not isEspActive then
            isEspActive = true
            toggleAutoParryESP(true)
        elseif not AP_Settings.RadiusEsp and isEspActive then
            isEspActive = false
            toggleAutoParryESP(false)
        end
    end)
end

-- ============================================================
-- AUTO SKILL CHECK SYSTEM
-- ============================================================
local Auto = { SkillCheck = false, SkillCheckMode = "แบบช้า" }
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"
local SkillHeartbeat = nil
local busy = false

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function GetActionTarget()
    local current = PlayerGui
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, game:GetService("GuiService"):GetGuiInset()
        local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
        end)
    end
end

local function startSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end
    local lastActiveTick = tick()
    SkillHeartbeat = RunService.RenderStepped:Connect(function()
        if not Auto.SkillCheck then return end
        if busy and (tick() - lastActiveTick > 1.0) then busy = false end
        if busy then return end
        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end
        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end
        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end
        local gr = goal.Rotation % 360
        if Auto.SkillCheckMode == "แบบเร็ว" then line.Rotation = gr + 108 end
        local lr = line.Rotation % 360
        local startRange = (gr + 102) % 360
        local endRange = (gr + 116) % 360
        local success = (startRange > endRange and (lr >= startRange or lr <= endRange)) or (lr >= startRange and lr <= endRange)
        if success then
            busy = true
            lastActiveTick = tick()
            task.spawn(function()
                pcall(function()
                    if UserInputService.TouchEnabled then TriggerMobileButton() else pressSpace() end
                end)
                task.wait(0.05)
                busy = false
            end)
        end
    end)
end
startSkillCheck()

-- ============================================================
-- AUTO CROUCH / SWING AVOID SYSTEM (เพิ่มเข้ามาใหม่)
-- ============================================================
getgenv().AutoCrouchSettings = {
    Enabled = false,
    TargetAnimId = "80411309607666",
    MaxDistance = 30,
}
local AC_Settings = getgenv().AutoCrouchSettings

local function getAutoCrouchPing()
    local success, ping = pcall(function()
        return localPlayer:GetNetworkPing()
    end)
    return success and ping or 0.05
end

local function triggerAutoCrouch()
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    local mobileGui = playerGui and playerGui:FindFirstChild("Survivor-mob")
    
    if mobileGui and mobileGui:FindFirstChild("Controls") and mobileGui.Controls:FindFirstChild("crouch") then
        local crouchBtn = mobileGui.Controls.crouch
        if firesignal then
            firesignal(crouchBtn.MouseButton1Click)
            firesignal(crouchBtn.Activated)
        else
            local pos = crouchBtn.AbsolutePosition
            local size = crouchBtn.AbsoluteSize
            local x = pos.X + (size.X / 2)
            local y = pos.Y + (size.Y / 2)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end
    else
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end
end

local function monitorKillerAnimation(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    if humanoid and rootPart then
        local animator = humanoid:WaitForChild("Animator", 5)
        if animator then
            animator.AnimationPlayed:Connect(function(animTrack)
                if not AC_Settings.Enabled then return end
                local anim = animTrack.Animation
                if anim and anim.AnimationId and string.find(anim.AnimationId, AC_Settings.TargetAnimId) then
                    local myChar = localPlayer.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    
                    if myRoot then
                        local distance = (myRoot.Position - rootPart.Position).Magnitude
                        local currentPing = getAutoCrouchPing()
                        local pingMs = math.floor(currentPing * 1000)
                        
                        if currentPing > 0.35 then
                            return
                        end
                        
                        local killerSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
                        local pingCompensation = killerSpeed * currentPing
                        local adjustedDistance = distance - pingCompensation
                        
                        if adjustedDistance <= AC_Settings.MaxDistance then
                            triggerAutoCrouch()
                        end
                    end
                end
            end)
        end
    end
end

for _, obj in ipairs(Workspace:GetChildren()) do
    if obj:IsA("Model") and obj ~= localPlayer.Character then
        monitorKillerAnimation(obj)
    end
end

Workspace.ChildAdded:Connect(function(obj)
    if obj:IsA("Model") then
        task.wait(1)
        if obj ~= localPlayer.Character then
            monitorKillerAnimation(obj)
        end
    end
end)

-- ============================================================
-- FLASHLIGHT INSTANT SNAP AIM LOCK
-- ============================================================
local FlashlightAim = { Enabled = false, Holding = false, AimPart = "Head", FOV = 350, Predict = true, PredictStrength = 0.12 }
local function getClosestKillerHead()
    local cam = Workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest = nil
    local shortest = FlashlightAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Team and p.Team.Name == "Killer" and p.Character then
            local head = p.Character:FindFirstChild(FlashlightAim.AimPart)
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local pos, visible = cam:WorldToViewportPoint(head.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest then shortest = dist closest = head end
                end
            end
        end
    end
    return closest
end

local FlashlightAimConn = nil
local function startFlashlightAim()
    if FlashlightAimConn then return end
    FlashlightAimConn = RunService.RenderStepped:Connect(function()
        if not FlashlightAim.Enabled or not FlashlightAim.Holding then return end
        local cam = Workspace.CurrentCamera
        local targetHead = getClosestKillerHead()
        if not targetHead then return end
        local targetPos = targetHead.Position
        if FlashlightAim.Predict and targetHead.Parent then
            local root = targetHead.Parent:FindFirstChild("HumanoidRootPart")
            if root then targetPos = targetPos + (root.AssemblyLinearVelocity * FlashlightAim.PredictStrength) end
        end
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos)
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not FlashlightAim.Enabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then FlashlightAim.Holding = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if not FlashlightAim.Enabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then FlashlightAim.Holding = false end
end)

task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            local mobControls = PlayerGui:FindFirstChild("Survivor-mob")
            if mobControls then
                local controls = mobControls:FindFirstChild("Controls")
                if controls then
                    for _, btn in ipairs(controls:GetDescendants()) do
                        if btn:IsA("GuiButton") and (btn.Name == "action" or btn.Name == "Gui-mob" or btn.Name:lower():find("item")) then
                            if not btn:FindFirstChild("FlashlightAimHooked") then
                                local marker = Instance.new("BoolValue")
                                marker.Name = "FlashlightAimHooked"
                                marker.Parent = btn
                                btn.MouseButton1Down:Connect(function() if FlashlightAim.Enabled then FlashlightAim.Holding = true end end)
                                btn.MouseButton1Up:Connect(function() FlashlightAim.Holding = false end)
                                btn.TouchStarted:Connect(function() if FlashlightAim.Enabled then FlashlightAim.Holding = true end end)
                                btn.TouchEnded:Connect(function() FlashlightAim.Holding = false end)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- CROSSHAIR SYSTEM
-- ============================================================
local Crosshair = { Enabled = false, Style = "จุด", Color = Color3.fromRGB(0, 255, 120), Size = 6, Thickness = 2, Gap = 4 }
local CrosshairScreenGui = Instance.new("ScreenGui")
CrosshairScreenGui.Name = "XHUB_Crosshair"
CrosshairScreenGui.ResetOnSpawn = false
CrosshairScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CrosshairScreenGui.IgnoreGuiInset = true
pcall(function()
    if gethui then CrosshairScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(CrosshairScreenGui) CrosshairScreenGui.Parent = CoreGui
    else CrosshairScreenGui.Parent = CoreGui end
end)
if not CrosshairScreenGui.Parent then CrosshairScreenGui.Parent = localPlayer:WaitForChild("PlayerGui") end

local CrosshairContainer = Instance.new("Frame")
CrosshairContainer.Name = "CrosshairContainer"
CrosshairContainer.Size = UDim2.new(0, 0, 0, 0)
CrosshairContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairContainer.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairContainer.BackgroundTransparency = 1
CrosshairContainer.Visible = false
CrosshairContainer.Parent = CrosshairScreenGui

local function ClearCrosshairElements()
    for _, child in ipairs(CrosshairContainer:GetChildren()) do child:Destroy() end
end

local function BuildCrosshair()
    ClearCrosshairElements()
    if not Crosshair.Enabled then CrosshairContainer.Visible = false return end
    CrosshairContainer.Visible = true
    if Crosshair.Style == "จุด" then
        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, Crosshair.Size, 0, Crosshair.Size)
        Dot.Position = UDim2.new(0, 0, 0, 0)
        Dot.AnchorPoint = Vector2.new(0.5, 0.5)
        Dot.BackgroundColor3 = Crosshair.Color
        Dot.BorderSizePixel = 0
        Dot.Parent = CrosshairContainer
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(1, 0)
        Corner.Parent = Dot
    elseif Crosshair.Style == "กากบาท" then
        local length = Crosshair.Size
        local thickness = Crosshair.Thickness
        local gap = Crosshair.Gap
        local Top = Instance.new("Frame")
        Top.Size = UDim2.new(0, thickness, 0, length)
        Top.Position = UDim2.new(0, 0, 0, -gap - (length / 2))
        Top.AnchorPoint = Vector2.new(0.5, 0.5)
        Top.BackgroundColor3 = Crosshair.Color
        Top.BorderSizePixel = 0
        Top.Parent = CrosshairContainer
        local Bottom = Instance.new("Frame")
        Bottom.Size = UDim2.new(0, thickness, 0, length)
        Bottom.Position = UDim2.new(0, 0, 0, gap + (length / 2))
        Bottom.AnchorPoint = Vector2.new(0.5, 0.5)
        Bottom.BackgroundColor3 = Crosshair.Color
        Bottom.BorderSizePixel = 0
        Bottom.Parent = CrosshairContainer
        local Left = Instance.new("Frame")
        Left.Size = UDim2.new(0, length, 0, thickness)
        Left.Position = UDim2.new(0, -gap - (length / 2), 0, 0)
        Left.AnchorPoint = Vector2.new(0.5, 0.5)
        Left.BackgroundColor3 = Crosshair.Color
        Left.BorderSizePixel = 0
        Left.Parent = CrosshairContainer
        local Right = Instance.new("Frame")
        Right.Size = UDim2.new(0, length, 0, thickness)
        Right.Position = UDim2.new(0, gap + (length / 2), 0, 0)
        Right.AnchorPoint = Vector2.new(0.5, 0.5)
        Right.BackgroundColor3 = Crosshair.Color
        Right.BorderSizePixel = 0
        Right.Parent = CrosshairContainer
    end
end

local function SetCrosshairState(state)
    Crosshair.Enabled = state
    BuildCrosshair()
end

local function UpdateCrosshairColor(newColor)
    Crosshair.Color = newColor
    BuildCrosshair()
end

localPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Crosshair.Enabled then BuildCrosshair() end
end)

-- ============================================================
-- FAST VAULT SYSTEM
-- ============================================================
local FastVault = { Enabled = false, Speed = 1.2, ReplaceMap = { ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779" } }
local VaultTracks = {}

local function normalizeId(id)
    local num = tostring(id):match("%d+")
    return num and ("rbxassetid://" .. num)
end

local function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not FastVault.Enabled then return end
        local anim = track.Animation
        if not anim or not anim.AnimationId then return end
        local id = normalizeId(anim.AnimationId)
        if not id then return end
        local replaceId = FastVault.ReplaceMap[id]
        if not replaceId then return end
        if VaultTracks[track] then return end
        VaultTracks[track] = true
        track:Stop()
        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = replaceId
        local newTrack = animator:LoadAnimation(newAnim)
        newTrack.Priority = Enum.AnimationPriority.Action
        newTrack:Play()
        newTrack:AdjustSpeed(FastVault.Speed)
        newTrack.Stopped:Connect(function() VaultTracks[track] = nil end)
    end)
end

localPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    hookVault(char)
end)
if localPlayer.Character then hookVault(localPlayer.Character) end

-- ============================================================
-- ESP WALLHACK SYSTEM
-- ============================================================
local ESP = { Survivor = false, Killer = false, Generator = false, Pallet = false, Window = false, SCP = false }
local TeamColors = { Killer = Color3.fromRGB(255, 60, 60), Survivor = Color3.fromRGB(60, 255, 120) }
local PalletColor = Color3.fromRGB(74, 255, 181)
local WindowColor = Color3.fromRGB(74, 255, 181)
local SCPColor = Color3.fromRGB(255, 0, 0)
local GeneratorColor = Color3.fromRGB(255, 170, 0)
local ESPObjects = {}
local CachedMapObjects = {}
local CachedGenerators = {}
local CachedSCP = {}

for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj.Name == "Window" or obj.Name == "Pallet" or obj.Name == "Palletwrong" then CachedMapObjects[obj] = true end
    if obj.Name == "Generator" then CachedGenerators[obj] = true end
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then CachedSCP[obj] = true end
end

Workspace.DescendantAdded:Connect(function(obj)
    if obj.Name == "Window" or obj.Name == "Pallet" or obj.Name == "Palletwrong" then CachedMapObjects[obj] = true end
    if obj.Name == "Generator" then CachedGenerators[obj] = true end
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then CachedSCP[obj] = true end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    CachedMapObjects[obj] = nil
    CachedGenerators[obj] = nil
    CachedSCP[obj] = nil
    if ESPObjects[obj] then ESPObjects[obj]:Destroy() ESPObjects[obj] = nil end
end)

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy() ESPObjects[obj] = nil end
end

local function createESP(obj, color)
    if not obj then return end
    if ESPObjects[obj] then
        ESPObjects[obj].FillColor = color
        ESPObjects[obj].OutlineColor = color
        return
    end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0.0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    ESPObjects[obj] = h
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then removeESP(obj) end
    end)
end

local function GetGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child then
        local success, val = pcall(function() return child.Value end)
        if success then return val end
    end
    return nil
end

local function CreateBillboard(text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "GenESP"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard
    return billboard
end

local function UpdateMapESP(obj)
    if not obj then return end
    if obj.Name == "Window" then
        if ESP.Window then createESP(obj, WindowColor) else removeESP(obj) end
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if ESP.Pallet then createESP(obj, PalletColor) else removeESP(obj) end
    end
end

local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not ESP.Generator then
        local old = generator:FindFirstChild("GenESP")
        if old then old:Destroy() end
        removeESP(generator)
        return
    end
    local percent = GetGameValue(generator, "RepairProgress") or GetGameValue(generator, "Progress") or 0
    local billboard = generator:FindFirstChild("GenESP")
    if percent >= 100 then
        if billboard then billboard:Destroy() end
        removeESP(generator)
        return
    end
    local cp = math.clamp(percent, 0, 100)
    local color = GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
    local text = string.format("[%.0f%%]", percent)
    if not billboard then
        billboard = CreateBillboard(text, color)
        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
        end
    end
    createESP(generator, color)
end

local function UpdateSCPEsp()
    if not ESP.SCP then
        for obj in pairs(CachedSCP) do removeESP(obj) end
        return
    end
    for obj in pairs(CachedSCP) do
        if obj and obj.Parent then createESP(obj, SCPColor) end
    end
end

RegisterTask("PlayerESPThrottled", 0.1, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                        createESP(char, TeamColors.Survivor)
                    elseif ESP.Killer and p.Team and p.Team.Name == "Killer" then
                        createESP(char, TeamColors.Killer)
                    else
                        removeESP(char)
                    end
                else
                    removeESP(char)
                end
            else
                removeESP(char)
            end
        end
    end
end)

RegisterTask("MapESPThrottled", 0.15, function()
    for obj, _ in pairs(CachedMapObjects) do
        if obj and obj.Parent then UpdateMapESP(obj) end
    end
    for gen, _ in pairs(CachedGenerators) do
        if gen and gen.Parent then UpdateGenerator(gen) end
    end
    UpdateSCPEsp()
end)

-- =======================================
-- TABS SETUP
-- =======================================
-- ═══════════════════════════════════════════════
-- NOCLIP CONFIG
-- ═══════════════════════════════════════════════
local NoclipConfig = {
    Enabled = false,
    SavedCollide = {}
}

local noclipConn = nil

local function startNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    noclipConn = RunService.Stepped:Connect(function()
        if not NoclipConfig.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if NoclipConfig.SavedCollide[part] == nil then
                    NoclipConfig.SavedCollide[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    for part, collide in pairs(NoclipConfig.SavedCollide) do
        if part and part.Parent then
            pcall(function() part.CanCollide = collide end)
        end
    end
    NoclipConfig.SavedCollide = {}
end

-- ═══════════════════════════════════════════════
-- SPEED BOOST CONFIG (CFrame Motion)
-- ═══════════════════════════════════════════════
local SpeedBoostConfig = {
    Enabled = false,
    Speed = 50
}

local speedConn = nil

local function startSpeedBoost()
    if speedConn then
        speedConn:Disconnect()
        speedConn = nil
    end
    speedConn = RunService.RenderStepped:Connect(function(dt)
        if not SpeedBoostConfig.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0.01 then
            hrp.CFrame = hrp.CFrame + moveDir * SpeedBoostConfig.Speed * dt
        end
    end)
end

local function stopSpeedBoost()
    if speedConn then
        speedConn:Disconnect()
        speedConn = nil
    end
end

-- ═══════════════════════════════════════════════
-- TABS SETUP
-- ═══════════════════════════════════════════════

local Tabs = {
    Info = Window:AddTab("ข้อมูล", "info"),
    Parry = Window:AddTab("ฟังก์ชันหลัก", "user"),
    ESP = Window:AddTab("มองทะลุ", "eye"),
    Combat = Window:AddTab("การต่อสู้", "swords"),
    Movement = Window:AddTab("การเคลื่อนที่", "move"),
    Favorite = Window:AddTab("รายการโปรด", "star"),
    UISettings = Window:AddTab("ตั้งค่าเมนู", "settings-2")
}


local CreditsBox = Tabs.Info:AddRightGroupbox("เครดิต", "user")

-- PARRY TAB GROUPBOXES
local AutoParryBox = Tabs.Parry:AddLeftGroupbox("Auto Parry", "swords")
AutoParryBox:AddCheckbox("AutoParryEnabled", { Text = "เปิดใช้งานออโต้ปัดป้อง", Default = AP_Settings.Enabled, Callback = function(v) AP_Settings.Enabled = v if not v then activeAttackers = {} end end })
AutoParryBox:AddCheckbox("AutoParryESP", { Text = "เปิดแสดงวง", Default = AP_Settings.RadiusEsp, Callback = function(v) AP_Settings.RadiusEsp = v end })
AutoParryBox:AddSlider("AutoParryRadius", { Text = "ระยะวง", Default = AP_Settings.Radius, Min = 5, Max = 30, Rounding = 0, Callback = function(v) AP_Settings.Radius = v end })

-- SILENT AIM GROUPBOX (ICON USER placed below Auto Parry on Left Side)
local SilentAimBox = Tabs.Parry:AddLeftGroupbox("Silent Aim (ปืนพก)", "crosshair")
SilentAimBox:AddCheckbox("SilentAimEnabled", {
    Text = "Silent Aim",
    Default = SA_Settings.Enabled,
    Callback = function(v) SA_Settings.Enabled = v end
})
SilentAimBox:AddCheckbox("SilentAimLaserEsp", {
    Text = "ESP เลเซอร์",
    Default = SA_Settings.LaserEsp,
    Callback = function(v) SA_Settings.LaserEsp = v end
})
SilentAimBox:AddDropdown("SilentAimTargetType", {
    Values = { "Killer", "Survivor", "Zombie" },
    Default = SA_Settings.TargetType,
    Text = "ประเภทเป้าหมาย",
    Callback = function(v) SA_Settings.TargetType = v end
})

-- SURVIVOR & OTHER TOOLS (Right Side of Parry Tab)
local SkillCheckGroup = Tabs.Parry:AddRightGroupbox("Survivor", "user")
SkillCheckGroup:AddCheckbox("AutoSkillCheckEnabled", { Text = "เปิดใช้งานปั่นไฟออโต้", Default = Auto.SkillCheck, Callback = function(v) Auto.SkillCheck = v end })
SkillCheckGroup:AddDropdown("AutoSkillCheckMode", { Values = { "แบบช้า", "แบบเร็ว" }, Default = Auto.SkillCheckMode, Text = "รูปแบบการปั่นไฟ", Callback = function(v) Auto.SkillCheckMode = v end })
SkillCheckGroup:AddDivider()
SkillCheckGroup:AddCheckbox("FastVault", { Text = "ปีนข้ามไว", Default = FastVault.Enabled, Callback = function(v) FastVault.Enabled = v end })
SkillCheckGroup:AddSlider("VaultSpeed", { Text = "ความเร็วแอนิเมชันปีน", Default = FastVault.Speed, Min = 1, Max = 5, Rounding = 1, Callback = function(v) FastVault.Speed = v end })
SkillCheckGroup:AddDivider()
SkillCheckGroup:AddCheckbox("FlashlightAimEnabled", { Text = "ล็อกเป้าไฟฉายใส่หัวฆาตกร", Default = FlashlightAim.Enabled, Callback = function(v) FlashlightAim.Enabled = v if v then startFlashlightAim() else FlashlightAim.Holding = false end end })
SkillCheckGroup:AddCheckbox("AutoCrouchEnabled", { Text = "ย่อหลบดาบ", Default = AC_Settings.Enabled, Callback = function(v) AC_Settings.Enabled = v end })

-- CROSSHAIR GROUPBOX
local CrosshairBox = Tabs.Parry:AddRightGroupbox("Crosshair", "crosshair")
CrosshairBox:AddCheckbox("CrosshairToggle", { Text = "เปิด/ปิด เป้าเล็ง", Default = Crosshair.Enabled, Callback = function(v) SetCrosshairState(v) end }):AddColorPicker("CrosshairColor", { Default = Crosshair.Color, Title = "สีเป้าเล็ง", Callback = function(color) UpdateCrosshairColor(color) end })
CrosshairBox:AddDropdown("CrosshairStyle", { Values = { "จุด", "กากบาท" }, Default = 1, Text = "รูปแบบเป้าเล็ง", Callback = function(v) Crosshair.Style = v BuildCrosshair() end })
CrosshairBox:AddSlider("CrosshairSize", { Text = "ขนาดเป้าเล็ง", Default = Crosshair.Size, Min = 2, Max = 20, Rounding = 0, Callback = function(v) Crosshair.Size = v BuildCrosshair() end })
CrosshairBox:AddSlider("CrosshairThickness", { Text = "ความหนา", Default = Crosshair.Thickness, Min = 1, Max = 6, Rounding = 0, Callback = function(v) Crosshair.Thickness = v BuildCrosshair() end })
CrosshairBox:AddSlider("CrosshairGap", { Text = "ระยะห่างเป้ากากบาท", Default = Crosshair.Gap, Min = 0, Max = 15, Rounding = 0, Callback = function(v) Crosshair.Gap = v BuildCrosshair() end })

-- ═══════════════════════════════════════════════
-- MOVEMENT TAB: NOCLIP + SPEED BOOST
-- ═══════════════════════════════════════════════
local NoclipBox = Tabs.Movement:AddLeftGroupbox("ทะลุกำแพง", "wall")
NoclipBox:AddToggle("NoclipEnabled", {
    Text = "เปิดใช้งานทะลุ",
    Default = NoclipConfig.Enabled,
    Callback = function(v)
        NoclipConfig.Enabled = v
        if v then
            startNoclip()
            Library:Notify({ Title = "ทะลุกำแพง", Content = "เปิดใช้งานแล้ว", Duration = 2 })
        else
            stopNoclip()
            Library:Notify({ Title = "ทะลุกำแพง", Content = "ปิดใช้งานแล้ว", Duration = 2 })
        end
    end
})

local SpeedBoostBox = Tabs.Movement:AddRightGroupbox("วิ่งเร็ว", "zap")
SpeedBoostBox:AddToggle("SpeedBoostEnabled", {
    Text = "เปิดใช้งานวิ่งเร็ว",
    Default = SpeedBoostConfig.Enabled,
    Callback = function(v)
        SpeedBoostConfig.Enabled = v
        if v then
            startSpeedBoost()
            Library:Notify({ Title = "วิ่งเร็ว", Content = "เปิดใช้งานแล้ว", Duration = 2 })
        else
            stopSpeedBoost()
            Library:Notify({ Title = "วิ่งเร็ว", Content = "ปิดใช้งานแล้ว", Duration = 2 })
        end
    end
})

SpeedBoostBox:AddSlider("SpeedValue", {
    Text = "ความเร็ว",
    Default = SpeedBoostConfig.Speed,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(v)
        SpeedBoostConfig.Speed = v
    end
})

-- COMBAT TAB

local MaskedPowerBox = Tabs.Combat:AddLeftGroupbox("Masked Power", "swords")
MaskedPowerBox:AddDropdown("MaskedPowerSelect", { Text = "เลือกพลังพิเศษ", Values = MaskedPowers, Default = 1, Multi = false, Callback = function(val) Masked.CurrentPower = val end })
MaskedPowerBox:AddButton("เปิดใช้งานพลัง", function()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true) and ReplicatedStorage.Remotes:FindFirstChild("Killers", true) and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true) and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
    if Event then
        Event:FireServer(Masked.CurrentPower)
        Library:Notify({ Title = "พลังพิเศษ", Content = "เปิดใช้งาน: " .. Masked.CurrentPower, Duration = 2 })
    else
        Library:Notify({ Title = "พลังพิเศษ", Content = "ไม่พบช่องทางการเชื่อมต่อสำหรับเปิดใช้งาน", Duration = 2 })
    end
end)
MaskedPowerBox:AddButton("ปิดใช้งานพลัง", function()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true) and ReplicatedStorage.Remotes:FindFirstChild("Killers", true) and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true) and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
    if Event then
        Event:FireServer()
        Library:Notify({ Title = "พลังพิเศษ", Content = "ปิดใช้งานพลังแล้ว", Duration = 2 })
    else
        Library:Notify({ Title = "พลังพิเศษ", Content = "ไม่พบช่องทางการเชื่อมต่อสำหรับปิดใช้งาน", Duration = 2 })
    end
end)

local AutoStalkBox = Tabs.Combat:AddRightGroupbox("แอบมอง (ไมเคิล)", "eye")
AutoStalkBox:AddCheckbox("AutoStalkEnabled", { Text = "เปิดใช้งานติดตามอัตโนมัติ", Default = AutoStalk.Enabled, Callback = function(v) AutoStalk.Enabled = v end })
AutoStalkBox:AddSlider("AutoStalkRange", { Text = "ระยะตรวจจับการติดตาม", Default = AutoStalk.Range, Min = 10, Max = 1000, Rounding = 0, Callback = function(v) AutoStalk.Range = v end })

-- FAVORITE TAB (Graphics & Zoom Out)
local VisualBox = Tabs.Favorite:AddLeftGroupbox("Graphics", "sun")
local ZoomBox = Tabs.Favorite:AddRightGroupbox("Zoom Out", "fullscreen")
VisualBox:AddCheckbox("Fullbright", { Text = "เร่งความสว่างสูงสุด", Default = false, Callback = function(v) Visual.Fullbright = v applyVisual() end })
VisualBox:AddCheckbox("NoShadow", { Text = "ปิดเงา", Default = false, Callback = function(v) Visual.NoShadow = v end })
VisualBox:AddCheckbox("LowGraphics", { Text = "กราฟิกต่ำ", Default = false, Callback = function(v) Visual.LowGraphics = v applyOptimization() end })
VisualBox:AddCheckbox("NoScreenEffects", { Text = "ปิดเอฟเฟกต์หน้าจอ", Default = false, Callback = function(v) Visual.NoScreenEffects = v applyNoScreenEffects() end })
VisualBox:AddCheckbox("CleanSky", { Text = "ท้องฟ้าโล่ง", Default = false, Callback = function(v) Visual.CleanSky = v applyOptimization() end })
ZoomBox:AddToggle("UnlimitedZoom", { Text = "ซูมออกไม่จำกัด", Default = false, Callback = function(v) CameraZoom.UnlimitedZoom = v applyUnlimitedZoom() end })
ZoomBox:AddSlider("MaxZoomDistance", { Text = "ระยะซูมสูงสุด", Default = 1000, Min = 100, Max = 5000, Rounding = 0, Callback = function(v) CameraZoom.MaxDistance = v if CameraZoom.UnlimitedZoom then applyUnlimitedZoom() end end })
ZoomBox:AddToggle("CustomFOV", { Text = "ปรับแต่งมุมมองภาพ", Default = false, Callback = function(Value) CameraZoom.FOVEnabled = Value applyCameraFOV() end })
ZoomBox:AddSlider("CameraFOV", { Text = "มุมมองภาพกล้อง", Default = 70, Min = 40, Max = 120, Rounding = 0, Callback = function(Value) CameraZoom.FOV = Value if CameraZoom.FOVEnabled then applyCameraFOV() end end })

-- ESP TAB
local ESPPlayerBox = Tabs.ESP:AddLeftGroupbox("ESP ตัวละคร", "user")
local ESPMapBox = Tabs.ESP:AddRightGroupbox("ESP แมพและวัตถุ", "map")
local SurvivorESP = ESPPlayerBox:AddCheckbox("SurvivorESP", { Text = "ESP Survivor", Default = false, Callback = function(v) ESP.Survivor = v end })
SurvivorESP:AddColorPicker("SurvivorESPColor", { Default = TeamColors.Survivor, Title = "สีผู้รอดชีวิต", Callback = function(color) TeamColors.Survivor = color end })
local KillerESP = ESPPlayerBox:AddCheckbox("KillerESP", { Text = "ESP Killer", Default = false, Callback = function(v) ESP.Killer = v end })
KillerESP:AddColorPicker("KillerESPColor", { Default = TeamColors.Killer, Title = "สีฆาตกร", Callback = function(color) TeamColors.Killer = color end })
local ESPSCPToggle = ESPPlayerBox:AddCheckbox("ESPSCP", { Text = "ESP SCP", Default = false, Callback = function(v) ESP.SCP = v end })
ESPSCPToggle:AddColorPicker("SCPColor", { Default = SCPColor, Title = "สี SCP", Callback = function(v) SCPColor = v end })
local ESPGenToggle = ESPMapBox:AddCheckbox("ESPGenerator", { Text = "มองทะลุเครื่องปั่นไฟ", Default = false, Callback = function(v) ESP.Generator = v end })
ESPGenToggle:AddColorPicker("GeneratorColor", { Default = GeneratorColor, Title = "สีเครื่องปั่นไฟ", Callback = function(v) GeneratorColor = v end })
local ESPWindowToggle = ESPMapBox:AddCheckbox("ESPWindow", { Text = "มองทะลุหน้าต่าง", Default = false, Callback = function(v) ESP.Window = v end })
ESPWindowToggle:AddColorPicker("WindowColor", { Default = WindowColor, Title = "สีหน้าต่าง", Callback = function(v) WindowColor = v end })
local ESPPalletToggle = ESPMapBox:AddCheckbox("ESPPallet", { Text = "มองทะลุไม้กระดาน", Default = false, Callback = function(v) ESP.Pallet = v end })
ESPPalletToggle:AddColorPicker("PalletColor", { Default = PalletColor, Title = "สีไม้กระดาน", Callback = function(v) PalletColor = v end })

-- UI SETTINGS TAB
local SettingBox = Tabs.UISettings:AddLeftGroupbox("จัดการเมนู", "wrench")
InfoBox:AddLabel("สคริปต์: XHUB")
InfoBox:AddLabel("เวอร์ชัน: 1.6.3 (Twist of Fate Optimized)")
InfoBox:AddLabel("เกม: Violence District")
InfoBox:AddDivider()

CreditsBox:AddLabel("ผู้พัฒนา: i am")
CreditsBox:AddLabel("เซิร์ฟเวอร์: XHUB")
CreditsBox:AddLabel("ระบบหน้าต่าง Obsidian")

SettingBox:AddToggle("ShowCustomCursor", { Text = "เคอร์เซอร์เมาส์กำหนดเอง", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end })
SettingBox:AddDropdown("NotificationSide", { Values = { "ซ้าย", "ขวา" }, Default = "ขวา", Text = "ตำแหน่งการแจ้งเตือน", Callback = function(Value) local notifMapping = { ["ซ้าย"] = "Left", ["ขวา"] = "Right" } Library:SetNotifySide(notifMapping[Value] or "Right") end })
SettingBox:AddDropdown("DPIDropdown", { Values = { "50%", "75%", "85%", "100%", "125%", "150%" }, Default = "85%", Text = "ขนาดสเกลหน้า UI", Callback = function(Value) Value = Value:gsub("%%", "") local DPI = tonumber(Value) Library:SetDPIScale(DPI) end })
SettingBox:AddSlider("UICornerSlider", { Text = "ความโค้งมุมหน้าต่าง", Default = Library.CornerRadius, Min = 0, Max = 20, Rounding = 0, Callback = function(value) Window:SetCornerRadius(value) end })
SettingBox:AddToggle("WatermarkToggle", { Text = "แสดงแถบข้อมูลสถานะ", Default = true, Callback = function(Value) Watermark.Visible = Value end })
SettingBox:AddDivider()
SettingBox:AddButton("ปิดใช้งานสคริปต์", function() Library:Unload() end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("XHUB")
SaveManager:SetFolder("XHUB/configs")
SaveManager:BuildConfigSection(Tabs.UISettings)

-- ═══════════════════════════════════════════════
-- NOCLIP + SPEED BOOST EVENT LISTENERS
-- ═══════════════════════════════════════════════
LocalPlayer.CharacterAdded:Connect(function()
    NoclipConfig.SavedCollide = {}
    task.wait(1)
    if NoclipConfig.Enabled then
        startNoclip()
    end
    if SpeedBoostConfig.Enabled then
        startSpeedBoost()
    end
end)

print("อัปเดตระบบ Silent Aim และเพิ่มระบบออโต้กดย่อหลบดาบเรียบร้อยแล้ว!")
