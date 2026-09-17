--[[
    ═══════════════════════════════════════════════
    KeyVault Login Client v2.0
    ─────────────────────────────────────────────
    · File-based persistent HWID
    · Device-based key validation
    · Clean UI
    · Full ไทย support
    ═══════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ═══════════ CONFIG ═══════════
local CONFIG = {
    API_VALIDATE = "https://key-gate-manager-copy-515b28d5.base44.app/functions/validateKey",
    API_HEARTBEAT = "https://key-gate-manager-copy-515b28d5.base44.app/functions/heartbeat",
    HEARTBEAT_INTERVAL = 45,
}

local STATE = {
    Token = nil,
    HWID = nil,
    IsValidated = false,
}

-- ═══════════ HWID (File-Based) ═══════════
local HWID_FILE = "xhub_hwid.txt"

local function getHWID()
    if isfile and isfile(HWID_FILE) then
        local saved = readfile(HWID_FILE)
        if saved and saved ~= "" then
            return saved
        end
    end
    
    local hwid = HttpService:GenerateGUID(false)
    if writefile then
        writefile(HWID_FILE, hwid)
    end
    return hwid
end

STATE.HWID = getHWID()

-- ═══════════ UI Setup ═══════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyVaultLogin"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 99999
screenGui.IgnoreGuiInset = true

local ok, parent = pcall(function() return CoreGui end)
screenGui.Parent = ok and parent or LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════ Main Frame ═══════════
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 280)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(45, 48, 60)
stroke.Thickness = 1
stroke.Parent = mainFrame

-- ═══════════ Title Bar ═══════════
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(26, 28, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(26, 28, 35)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔐 KeyVault"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -33, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 0.8
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ═══════════ Content Container ═══════════
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 1, -50)
content.Position = UDim2.new(0, 15, 0, 45)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- ═══════════ Icon ═══════════
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(1, 0, 0, 40)
icon.Position = UDim2.new(0, 0, 0, 0)
icon.BackgroundTransparency = 1
icon.Text = "🔑"
icon.TextSize = 32
icon.Font = Enum.Font.GothamBold
icon.TextColor3 = Color3.fromRGB(100, 150, 255)
icon.Parent = content

-- ═══════════ Subtitle ═══════════
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 26)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "ใส่คีย์เพื่อเข้าใช้งาน"
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextColor3 = Color3.fromRGB(150, 155, 170)
subtitle.TextWrapped = true
subtitle.Parent = content

-- ═══════════ HWID Display ═══════════
local hwidLabel = Instance.new("TextLabel")
hwidLabel.Size = UDim2.new(1, 0, 0, 12)
hwidLabel.Position = UDim2.new(0, 0, 0, 72)
hwidLabel.BackgroundTransparency = 1
hwidLabel.Text = "HWID: " .. STATE.HWID:sub(1, 16) .. "..."
hwidLabel.TextSize = 9
hwidLabel.Font = Enum.Font.GothamMonospace
hwidLabel.TextColor3 = Color3.fromRGB(100, 105, 120)
hwidLabel.TextXAlignment = Enum.TextXAlignment.Center
hwidLabel.Parent = content

-- ═══════════ Input Box ═══════════
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 0, 36)
inputBox.Position = UDim2.new(0, 0, 0, 90)
inputBox.BackgroundColor3 = Color3.fromRGB(26, 28, 35)
inputBox.BorderSizePixel = 0
inputBox.Text = ""
inputBox.PlaceholderText = "ใส่คีย์ที่นี่..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 105, 120)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 13
inputBox.TextXAlignment = Enum.TextXAlignment.Center
inputBox.Parent = content

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputBox

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(45, 48, 60)
inputStroke.Thickness = 1
inputStroke.Parent = inputBox

-- ═══════════ Status Label ═══════════
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 16)
statusLabel.Position = UDim2.new(0, 0, 0, 130)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.TextWrapped = true
statusLabel.Parent = content

-- ═══════════ Login Button ═══════════
local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(1, 0, 0, 36)
loginBtn.Position = UDim2.new(0, 0, 0, 150)
loginBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
loginBtn.BorderSizePixel = 0
loginBtn.Text = "เข้าสู่ระบบ"
loginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 13
loginBtn.AutoButtonColor = false
loginBtn.Parent = content

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = loginBtn

-- ═══════════ API: Validate Key ═══════════
local function validateKey(key)
    local body = HttpService:JSONEncode({
        key = key,
        hwid = STATE.HWID,
        username = LocalPlayer.Name
    })
    
    local ok, res = pcall(function()
        return HttpService:RequestAsync({
            Url = CONFIG.API_VALIDATE,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)
    
    if not ok then
        print("[KeyVault] HTTP Error:", res)
        return false, "❌ ข้อผิดพลาดเครือข่าย"
    end
    
    if not res.Success then
        print("[KeyVault] API Error:", res.StatusCode)
        
        local errorMsg = "❌ เซิร์ฟเวอร์ไม่ตอบสนอง"
        if res.Body and (res.Body:find("Max devices") or res.Body:find("เครื่องเต็ม")) then
            errorMsg = "❌ เครื่องเต็มแล้ว"
        end
        return false, errorMsg
    end
    
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(res.Body)
    end)
    
    if not ok2 then
        return false, "❌ ข้อผิดพลาดการทำงาน"
    end
    
    if data.success then
        STATE.Token = data.token
        STATE.IsValidated = true
        return true, data.payload
    else
        local msg = data.message or "❌ คีย์ไม่ถูกต้อง"
        if msg:find("Max devices") or msg:find("เครื่องเต็ม") then
            msg = "❌ เครื่องเต็มแล้ว"
        end
        return false, msg
    end
end

-- ═══════════ Load Payload ═══════════
local function loadPayload(code)
    statusLabel.Text = "⏳ กำลังโหลด..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
    
    task.wait(0.5)
    
    local fn, err = loadstring(code)
    if not fn then
        statusLabel.Text = "✗ ข้อผิดพลาด"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    statusLabel.Text = "✓ สำเร็จ!"
    statusLabel.TextColor3 = Color3.fromRGB(50, 220, 100)
    loginBtn.Text = "✓"
    loginBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
    
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

-- ═══════════ Check Key ═══════════
local function checkKey()
    local input = inputBox.Text:gsub("^%s*(.-)%s*$", "%1")
    
    if input == "" then
        statusLabel.Text = "⚠ กรุณาใส่คีย์"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
        return
    end
    
    statusLabel.Text = "⏳ ตรวจสอบ..."
    statusLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
    loginBtn.Interactable = false
    
    print("[KeyVault] Key:", input, "| HWID:", STATE.HWID)
    
    task.wait(0.3)
    
    local success, result = validateKey(input)
    
    if success then
        loadPayload(result)
    else
        statusLabel.Text = result
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        loginBtn.Text = "ลองอีกครั้ง"
        loginBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        
        task.wait(2)
        
        loginBtn.Text = "เข้าสู่ระบบ"
        loginBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        statusLabel.Text = ""
        loginBtn.Interactable = true
    end
end

-- ═══════════ Events ═══════════
loginBtn.MouseButton1Click:Connect(checkKey)

inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkKey()
    end
end)

inputBox.Focused:Connect(function()
    inputStroke.Color = Color3.fromRGB(100, 150, 255)
    inputStroke.Thickness = 1.5
end)

inputBox.FocusLost:Connect(function()
    inputStroke.Color = Color3.fromRGB(45, 48, 60)
    inputStroke.Thickness = 1
end)

-- ═══════════ Heartbeat Loop ═══════════
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

-- ═══════════ Global Functions ═══════════
_G.ResetKeyVaultHWID = function()
    if isfile and isfile(HWID_FILE) then
        if delfile then delfile(HWID_FILE) else writefile(HWID_FILE, "") end
        print("[KeyVault] ✓ HWID reset")
        return true
    end
    return false
end

print("[KeyVault] ✓ KeyVault Client loaded")
print("[KeyVault] HWID:", STATE.HWID)
print("[KeyVault] Reset: _G.ResetKeyVaultHWID()")
