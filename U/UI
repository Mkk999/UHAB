--[[
    ═══════════════════════════════════════════════
    Simple Key Login UI
    ─────────────────────────────────────────────
    - คีย์: ABC (ตัวเล็ก/ใหญ่ก็ได้)
    - UI เรียบง่าย สร้างเอง 100%
    - ไม่พึ่ง library ภายนอก
    ═══════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer

-- ═══════════ Config ═══════════
local CONFIG = {
    CorrectKey = "ABC",
    CaseSensitive = false,
}

-- ═══════════ หา GUI Parent ═══════════
local function getGuiParent()
    local ok, result = pcall(function()
        local probe = Instance.new("Folder")
        probe.Name = "KeyUI_Probe"
        probe.Parent = CoreGui
        probe:Destroy()
        return CoreGui
    end)
    if ok and result then return result end
    return localPlayer:WaitForChild("PlayerGui")
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
}

-- ═══════════ ScreenGui ═══════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyLoginGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 99999
screenGui.IgnoreGuiInset = true
screenGui.Parent = GUI_PARENT

-- ═══════════ Main Frame ═══════════
local mainFrame = Instance.new("Frame")
mainFrame.Name = "LoginFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
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

-- ═══════════ Title Bar ═══════════
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
titleLabel.Text = "🔐 Key Login"
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

-- ═══════════ Icon ═══════════
local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 0, 40)
iconLabel.Position = UDim2.new(0, 0, 0, 50)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "🔑"
iconLabel.TextColor3 = UI.Accent
iconLabel.Font = Enum.Font.GothamBold
iconLabel.TextSize = 36
iconLabel.Parent = mainFrame

-- ═══════════ Subtitle ═══════════
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, 0, 0, 18)
subtitleLabel.Position = UDim2.new(0, 0, 0, 92)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "กรุณาใส่คีย์เพื่อเข้าใช้งาน"
subtitleLabel.TextColor3 = UI.TextSub
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 11
subtitleLabel.Parent = mainFrame

-- ═══════════ Input Box ═══════════
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -40, 0, 36)
inputFrame.Position = UDim2.new(0, 20, 0, 118)
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
statusLabel.Size = UDim2.new(1, -40, 0, 16)
statusLabel.Position = UDim2.new(0, 20, 0, 158)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = UI.TextSub
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = mainFrame

-- ═══════════ Login Button ═══════════
local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(1, -40, 0, 34)
loginBtn.Position = UDim2.new(0, 20, 0, 178)
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

-- ═══════════ ฟังก์ชันตรวจสอบคีย์ ═══════════
local function checkKey()
    local input = inputBox.Text:gsub("^%s*(.-)%s*$", "%1")
    
    if input == "" then
        statusLabel.Text = "⚠ กรุณาใส่คีย์"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
        return
    end
    
    local correct = CONFIG.CorrectKey
    local matched = false
    
    if CONFIG.CaseSensitive then
        matched = (input == correct)
    else
        matched = (input:lower() == correct:lower())
    end
    
    if matched then
        statusLabel.Text = "✓ Login สำเร็จ!"
        statusLabel.TextColor3 = UI.AccentGreen
        loginBtn.Text = "✓ สำเร็จ"
        loginBtn.BackgroundColor3 = UI.AccentGreen
        
        task.delay(1, function()
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
            }):Play()
            task.wait(0.3)
            screenGui:Destroy()
        end)
        
        print("[Key Login] ✓ Login สำเร็จ! คีย์: " .. input)
    else
        statusLabel.Text = "✗ คีย์ไม่ถูกต้อง"
        statusLabel.TextColor3 = UI.Danger
        loginBtn.Text = "ลองอีกครั้ง"
        loginBtn.BackgroundColor3 = UI.Danger
        
        -- สั่น UI
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
            end
        end)
        
        print("[Key Login] ✗ คีย์ไม่ถูกต้อง: " .. input)
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

-- ═══════════ Animation เปิด UI ═══════════
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 320, 0, 220),
    Position = UDim2.new(0.5, -160, 0.5, -110),
}):Play()

-- ═══════════ Cleanup ═══════════
_G.KeyLoginCleanup = function()
    if screenGui then screenGui:Destroy() end
end

print("[Key Login] UI โหลดแล้ว! ใส่คีย์ ABC เพื่อเข้าใช้งาน")
