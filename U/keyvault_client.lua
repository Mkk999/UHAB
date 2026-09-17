--[[
    ═══════════════════════════════════════════════
    KeyVault Login Client v1.0
    ─────────────────────────────────────────────
    · เชื่อม KeyVault API
    · Login UI สวย
    · Heartbeat loop ตรวจสอบ key
    · Auto-load XHUB
    ═══════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- ═══════════ Config ═══════════
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

-- ═══════════ HWID Generation (File-based) ═══════════
local HWID_FILE = "xhub_hwid.txt"

local function getHWID()
    -- ตรวจไฟล์มีหรือไม่
    if isfile and isfile(HWID_FILE) then
        local hwid = readfile(HWID_FILE)
        if hwid and hwid ~= "" then
            return hwid
        end
    end
    
    -- สร้าง HWID ใหม่
    local hwid = game:GetService("HttpService"):GenerateGUID(false)
    
    -- เก็บลงไฟล์
    if writefile then
        writefile(HWID_FILE, hwid)
    end
    
    return hwid
end

STATE.HWID = getHWID()

-- ═══════════ หา GUI Parent ═══════════
local function getGuiParent()
    local ok, result = pcall(function()
        local probe = Instance.new("Folder")
        probe.Name = "KeyVault_Probe"
        probe.Parent = CoreGui
        probe:Destroy()
        return CoreGui
    end)
    if ok and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GUI_PARENT = getGuiParent()

-- ═══════════ UI Colors ═══════════
local UI = {
    Bg = Color3.fromRGB(18, 19, 24),
    Card = Color3.fromRGB(26, 28, 35),
    Stroke = Color3.fromRGB(45, 48, 60),
    Text = Color3.fromRGB(255, 255, 255),
    TextSub = Color3.fromRGB(150, 155, 170),
    Accent = Color3.fromRGB(100, 150, 255),
    AccentGreen = Color3.fromRGB(50, 220, 100),
    Danger = Color3.fromRGB(255, 80, 80),
    Warning = Color3.fromRGB(255, 200, 80),
}

-- ═══════════ ScreenGui ═══════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyVaultLoginGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 99999
screenGui.IgnoreGuiInset = true
screenGui.Parent = GUI_PARENT

-- ═══════════ Main Frame ═══════════
local mainFrame = Instance.new("Frame")
mainFrame.Name = "LoginFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 290)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -145)
mainFrame.BackgroundColor3 = UI.Bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = UI.Stroke
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- ═══════════ Title Bar ═══════════
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = UI.Card
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = UI.Card
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔐 KeyVault Login"
titleLabel.TextColor3 = UI.Text
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
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

-- ═══════════ Icon ═══════════
local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 0, 44)
iconLabel.Position = UDim2.new(0, 0, 0, 54)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "🔑"
iconLabel.TextColor3 = UI.Accent
iconLabel.Font = Enum.Font.GothamBold
iconLabel.TextSize = 40
iconLabel.Parent = mainFrame

-- ═══════════ Subtitle ═══════════
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, 0, 0, 30)
subtitleLabel.Position = UDim2.new(0, 0, 0, 95)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "ใส่คีย์เพื่อเข้าใช้งาน XHUB"
subtitleLabel.TextColor3 = UI.TextSub
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 12
subtitleLabel.TextWrapped = true
subtitleLabel.Parent = mainFrame

-- ═══════════ HWID Info Label ═══════════
local hwidLabel = Instance.new("TextLabel")
hwidLabel.Size = UDim2.new(1, -48, 0, 14)
hwidLabel.Position = UDim2.new(0, 24, 0, 126)
hwidLabel.BackgroundTransparency = 1
hwidLabel.Text = "HWID: " .. STATE.HWID:sub(1, 12) .. "..."
hwidLabel.TextColor3 = Color3.fromRGB(120, 125, 140)
hwidLabel.Font = Enum.Font.GothamMonospace
hwidLabel.TextSize = 10
hwidLabel.TextXAlignment = Enum.TextXAlignment.Left
hwidLabel.Parent = mainFrame

-- ═══════════ Input Box ═══════════
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -48, 0, 40)
inputFrame.Position = UDim2.new(0, 24, 0, 148)
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
inputBox.ClearTextOnFocus = false
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.Parent = inputFrame

-- ═══════════ Status Label ═══════════
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -48, 0, 20)
statusLabel.Position = UDim2.new(0, 24, 0, 196)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = UI.TextSub
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

-- ═══════════ Login Button ═══════════
local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(1, -48, 0, 36)
loginBtn.Position = UDim2.new(0, 24, 0, 220)
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
        print("[KeyVault] API Error:", res.StatusCode, res.Body)
        
        -- ตรวจ error message จากเซิร์ฟเวอร์
        local errorMsg = "❌ เซิร์ฟเวอร์ไม่ตอบสนอง"
        if res.Body then
            if res.Body:find("Max devices") or res.Body:find("เครื่องเต็ม") then
                errorMsg = "❌ เครื่องเต็มแล้ว (max devices)"
            elseif res.Body:find("Invalid key") or res.Body:find("ไม่ถูกต้อง") then
                errorMsg = "❌ คีย์ไม่ถูกต้อง"
            elseif res.Body:find("HWID") then
                errorMsg = "❌ HWID ไม่ตรง"
            end
        end
        return false, errorMsg
    end
    
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(res.Body)
    end)
    
    if not ok2 then
        print("[KeyVault] JSON Decode Error:", data)
        return false, "❌ ข้อผิดพลาดการทำงาน"
    end
    
    if data.success then
        STATE.Token = data.token
        STATE.IsValidated = true
        print("[KeyVault] ✓ Validation สำเร็จ - HWID:", STATE.HWID)
        return true, data.payload
    else
        local errorMsg = data.message or "❌ คีย์ไม่ถูกต้อง"
        
        -- Parse error message
        if errorMsg:find("Max devices") or errorMsg:find("เครื่องเต็ม") then
            errorMsg = "❌ เครื่องเต็มแล้ว (max devices)"
        elseif errorMsg:find("HWID") then
            errorMsg = "❌ HWID ไม่ตรง หรือบัญชีต่างเครื่อง"
        end
        
        print("[KeyVault] Validation failed:", errorMsg)
        return false, errorMsg
    end
end

-- ═══════════ API: Heartbeat ═══════════
local function sendHeartbeat()
    if not STATE.Token then return end
    
    local body = HttpService:JSONEncode({
        token = STATE.Token,
        hwid = STATE.HWID
    })
    
    local ok, res = pcall(function()
        return HttpService:RequestAsync({
            Url = CONFIG.API_HEARTBEAT,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)
    
    if not ok then
        print("[KeyVault] Heartbeat ล้มเหลว:", res)
        return
    end
    
    if not res.Success then
        print("[KeyVault] Heartbeat ข้อผิดพลาด:", res.StatusCode)
        STATE.IsValidated = false
        return
    end
    
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(res.Body)
    end)
    
    if ok2 and data.success then
        print("[KeyVault] Heartbeat ส่งสำเร็จ")
    else
        print("[KeyVault] Token ยกเลิก - ปิดสคริปต์")
        STATE.IsValidated = false
    end
end

-- ═══════════ Load Payload ═══════════
local function loadPayload(payloadCode)
    statusLabel.Text = "⏳ กำลังโหลด XHUB..."
    statusLabel.TextColor3 = UI.Warning
    
    task.wait(0.5)
    
    local fn, err = loadstring(payloadCode)
    if not fn then
        statusLabel.Text = "✗ ข้อผิดพลาดโหลด"
        statusLabel.TextColor3 = UI.Danger
        print("[KeyVault] Payload error:", err)
        return
    end
    
    statusLabel.Text = "✓ Login สำเร็จ!"
    statusLabel.TextColor3 = UI.AccentGreen
    loginBtn.Text = "✓ สำเร็จ"
    loginBtn.BackgroundColor3 = UI.AccentGreen
    
    task.wait(1)
    
    -- ปิด UI
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()
    
    task.wait(0.3)
    screenGui:Destroy()
    
    -- โหลด payload
    task.wait(0.5)
    pcall(fn)
end

-- ═══════════ Check Key Function ═══════════
local function checkKey()
    local input = inputBox.Text:gsub("^%s*(.-)%s*$", "%1")
    
    if input == "" then
        statusLabel.Text = "⚠ กรุณาใส่คีย์"
        statusLabel.TextColor3 = UI.Warning
        return
    end
    
    statusLabel.Text = "⏳ ตรวจสอบคีย์..."
    statusLabel.TextColor3 = UI.Accent
    loginBtn.Interactable = false
    
    print("[KeyVault] ตรวจสอบ Key:", input)
    print("[KeyVault] HWID ที่ส่ง:", STATE.HWID)
    
    task.wait(0.3)
    
    local success, result = validateKey(input)
    
    if success then
        print("[KeyVault] ✓ Validation สำเร็จ:", input)
        -- result คือ payload code
        loadPayload(result)
    else
        print("[KeyVault] ✗ Validation ล้มเหลว:", result)
        statusLabel.Text = result
        statusLabel.TextColor3 = UI.Danger
        loginBtn.Text = "ลองอีกครั้ง"
        loginBtn.BackgroundColor3 = UI.Danger
        
        -- Shake animation
        local origPos = mainFrame.Position
        for i = 1, 4 do
            TweenService:Create(mainFrame, TweenInfo.new(0.05), {
                Position = origPos + UDim2.new(0, 8, 0, 0)
            }):Play()
            task.wait(0.05)
            TweenService:Create(mainFrame, TweenInfo.new(0.05), {
                Position = origPos - UDim2.new(0, 8, 0, 0)
            }):Play()
            task.wait(0.05)
        end
        TweenService:Create(mainFrame, TweenInfo.new(0.1), {
            Position = origPos
        }):Play()
        
        task.delay(1.5, function()
            if loginBtn.Text == "ลองอีกครั้ง" then
                loginBtn.Text = "เข้าสู่ระบบ"
                loginBtn.BackgroundColor3 = UI.Accent
                statusLabel.Text = ""
                loginBtn.Interactable = true
            end
        end)
    end
end

-- ═══════════ Events ═══════════
loginBtn.MouseButton1Click:Connect(checkKey)

inputBox.Focused:Connect(function()
    inputStroke.Color = UI.Accent
    TweenService:Create(inputStroke, TweenInfo.new(0.15), {Thickness = 1.5}):Play()
end)

inputBox.FocusLost:Connect(function(enterPressed)
    inputStroke.Color = UI.Stroke
    TweenService:Create(inputStroke, TweenInfo.new(0.15), {Thickness = 1}):Play()
    if enterPressed then
        checkKey()
    end
end)

-- ═══════════ Heartbeat Loop ═══════════
task.spawn(function()
    task.wait(CONFIG.HEARTBEAT_INTERVAL)
    while STATE.IsValidated do
        sendHeartbeat()
        task.wait(CONFIG.HEARTBEAT_INTERVAL)
    end
end)

-- ═══════════ Animation เปิด UI ═══════════
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 340, 0, 290),
    Position = UDim2.new(0.5, -170, 0.5, -145),
}):Play()

-- ═══════════ Cleanup & Utilities ═══════════
_G.KeyVaultCleanup = function()
    if screenGui then screenGui:Destroy() end
end

_G.ResetKeyVaultHWID = function()
    if isfile and isfile(HWID_FILE) then
        if delfile then
            delfile(HWID_FILE)
        else
            writefile(HWID_FILE, "")
        end
        print("[KeyVault] ✓ HWID reset - ใช้ได้กับเครื่องใหม่")
        return true
    end
    print("[KeyVault] ℹ ไม่มีไฟล์ HWID ให้ลบ")
    return false
end

print("[KeyVault] ✓ KeyVault Client โหลดสำเร็จ")
print("[KeyVault] HWID (persistent):", STATE.HWID)
print("[KeyVault] File location:", HWID_FILE)
print("[KeyVault] Reset HWID: _G.ResetKeyVaultHWID()")
