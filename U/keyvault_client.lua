--[[KeyVault - Beautiful UI]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer

local CONFIG = {
    API_VALIDATE = "https://key-gate-manager-copy-515b28d5.base44.app/functions/validateKey",
    API_HEARTBEAT = "https://key-gate-manager-copy-515b28d5.base44.app/functions/heartbeat",
    HEARTBEAT_INTERVAL = 45,
}

local HWID_FILE = "xhub_hwid.txt"
local STATE = { Token = nil, HWID = nil, IsValidated = false }

local function getHWID()
    if isfile and isfile(HWID_FILE) then
        local saved = readfile(HWID_FILE)
        if saved and saved ~= "" then return saved end
    end
    local hwid = HttpService:GenerateGUID(false)
    if writefile then writefile(HWID_FILE, hwid) end
    return hwid
end

STATE.HWID = getHWID()

local function getGuiParent()
    local ok, result = pcall(function()
        local probe = Instance.new("Folder")
        probe.Name = "Probe"
        probe.Parent = CoreGui
        probe:Destroy()
        return CoreGui
    end)
    return ok and result or localPlayer:WaitForChild("PlayerGui")
end

local GUI_PARENT = getGuiParent()

local UI = {
    Bg = Color3.fromRGB(18, 19, 24),
    Card = Color3.fromRGB(26, 28, 35),
    Stroke = Color3.fromRGB(45, 48, 60),
    Text = Color3.fromRGB(255, 255, 255),
    TextSub = Color3.fromRGB(150, 155, 170),
    Accent = Color3.fromRGB(100, 150, 255),
    AccentGreen = Color3.fromRGB(50, 220, 100),
    Danger = Color3.fromRGB(255, 80, 80),
}

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = GUI_PARENT

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
mainFrame.BackgroundColor3 = UI.Bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = UI.Stroke
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = UI.Card
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = UI.Card
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔐 KeyVault"
titleLabel.TextColor3 = UI.Text
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -32, 0.5, -12)
closeBtn.BackgroundColor3 = UI.Danger
closeBtn.BackgroundTransparency = 0.85
closeBtn.Text = "×"
closeBtn.TextColor3 = UI.Text
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 0, 40)
iconLabel.Position = UDim2.new(0, 0, 0, 50)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "🔑"
iconLabel.TextColor3 = UI.Accent
iconLabel.Font = Enum.Font.GothamBold
iconLabel.TextSize = 36
iconLabel.Parent = mainFrame

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, 0, 0, 18)
subtitleLabel.Position = UDim2.new(0, 0, 0, 92)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "กรุณาใส่คีย์เพื่อเข้าใช้งาน"
subtitleLabel.TextColor3 = UI.TextSub
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 11
subtitleLabel.Parent = mainFrame

local hwidLabel = Instance.new("TextLabel")
hwidLabel.Size = UDim2.new(1, 0, 0, 12)
hwidLabel.Position = UDim2.new(0, 0, 0, 110)
hwidLabel.BackgroundTransparency = 1
hwidLabel.Text = "HWID: " .. STATE.HWID:sub(1, 16) .. "..."
hwidLabel.TextColor3 = Color3.fromRGB(100, 105, 120)
hwidLabel.Font = Enum.Font.GothamMonospace
hwidLabel.TextSize = 9
hwidLabel.TextXAlignment = Enum.TextXAlignment.Center
hwidLabel.Parent = mainFrame

local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -40, 0, 36)
inputFrame.Position = UDim2.new(0, 20, 0, 128)
inputFrame.BackgroundColor3 = UI.Card
inputFrame.BorderSizePixel = 0
inputFrame.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputFrame

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = UI.Stroke
inputStroke.Thickness = 1
inputStroke.Parent = inputFrame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -20, 1, 0)
inputBox.Position = UDim2.new(0, 10, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "ใส่คีย์ที่นี่..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 105, 120)
inputBox.TextColor3 = UI.Text
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 13
inputBox.Parent = inputFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 16)
statusLabel.Position = UDim2.new(0, 20, 0, 168)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = UI.TextSub
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = mainFrame

local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(1, -40, 0, 34)
loginBtn.Position = UDim2.new(0, 20, 0, 190)
loginBtn.BackgroundColor3 = UI.Accent
loginBtn.Text = "เข้าสู่ระบบ"
loginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 13
loginBtn.AutoButtonColor = false
loginBtn.Parent = mainFrame

local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 8)
loginCorner.Parent = loginBtn

local function validateKey(key)
    local body = HttpService:JSONEncode({
        key = key,
        hwid = STATE.HWID,
        username = localPlayer.Name
    })
    
    local ok, res = pcall(function()
        return HttpService:RequestAsync({
            Url = CONFIG.API_VALIDATE,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)
    
    if not ok then return false, "❌ ข้อผิดพลาดเครือข่าย" end
    if not res.Success then return false, "❌ เซิร์ฟเวอร์ไม่ตอบสนอง" end
    
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(res.Body)
    end)
    
    if not ok2 then return false, "❌ ข้อผิดพลาด" end
    
    if data.success then
        STATE.Token = data.token
        STATE.IsValidated = true
        return true, data.payload
    else
        return false, data.message or "❌ คีย์ไม่ถูกต้อง"
    end
end

local function loadPayload(code)
    statusLabel.Text = "⏳ กำลังโหลด..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
    
    task.wait(0.5)
    
    local fn = loadstring(code)
    if not fn then
        statusLabel.Text = "✗ ข้อผิดพลาด"
        statusLabel.TextColor3 = UI.Danger
        return
    end
    
    statusLabel.Text = "✓ สำเร็จ!"
    statusLabel.TextColor3 = UI.AccentGreen
    loginBtn.Text = "✓"
    loginBtn.BackgroundColor3 = UI.AccentGreen
    
    task.wait(1)
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()
    
    task.wait(0.3)
    screenGui:Destroy()
    task.wait(0.5)
    pcall(fn)
end

local function checkKey()
    local input = inputBox.Text:gsub("^%s*(.-)%s*$", "%1")
    
    if input == "" then
        statusLabel.Text = "⚠ ใส่คีย์"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
        return
    end
    
    statusLabel.Text = "⏳ ตรวจสอบ..."
    statusLabel.TextColor3 = UI.Accent
    loginBtn.Interactable = false
    
    task.wait(0.3)
    
    local success, result = validateKey(input)
    
    if success then
        loadPayload(result)
    else
        statusLabel.Text = result
        statusLabel.TextColor3 = UI.Danger
        loginBtn.Text = "ลองอีก"
        loginBtn.BackgroundColor3 = UI.Danger
        
        local origPos = mainFrame.Position
        for i = 1, 4 do
            TweenService:Create(mainFrame, TweenInfo.new(0.05), {Position = origPos + UDim2.new(0, 8, 0, 0)}):Play()
            task.wait(0.05)
            TweenService:Create(mainFrame, TweenInfo.new(0.05), {Position = origPos - UDim2.new(0, 8, 0, 0)}):Play()
            task.wait(0.05)
        end
        TweenService:Create(mainFrame, TweenInfo.new(0.1), {Position = origPos}):Play()
        
        task.delay(1.5, function()
            loginBtn.Text = "เข้าสู่ระบบ"
            loginBtn.BackgroundColor3 = UI.Accent
            statusLabel.Text = ""
            loginBtn.Interactable = true
        end)
    end
end

loginBtn.MouseButton1Click:Connect(checkKey)

inputBox.Focused:Connect(function()
    inputStroke.Color = UI.Accent
    TweenService:Create(inputStroke, TweenInfo.new(0.15), {Thickness = 1.5}):Play()
end)

inputBox.FocusLost:Connect(function(enterPressed)
    inputStroke.Color = UI.Stroke
    TweenService:Create(inputStroke, TweenInfo.new(0.15), {Thickness = 1}):Play()
    if enterPressed then checkKey() end
end)

mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 320, 0, 260),
    Position = UDim2.new(0.5, -160, 0.5, -130),
}):Play()

task.spawn(function()
    task.wait(CONFIG.HEARTBEAT_INTERVAL)
    while STATE.IsValidated do
        local body = HttpService:JSONEncode({ token = STATE.Token, hwid = STATE.HWID })
        pcall(function()
            HttpService:RequestAsync({
                Url = CONFIG.API_HEARTBEAT,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body
            })
        end)
        task.wait(CONFIG.HEARTBEAT_INTERVAL)
    end
end)

_G.ResetKeyVaultHWID = function()
    if isfile and isfile(HWID_FILE) then
        if delfile then delfile(HWID_FILE) else writefile(HWID_FILE, "") end
        return true
    end
end

print("[KeyVault] Ready - HWID:", STATE.HWID)