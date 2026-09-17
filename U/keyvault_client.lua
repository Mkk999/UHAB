--[[
    ═══════════════════════════════════════════════
    KeyVault Login Client
    ─────────────────────────────────────────────
    • KeyVault API
    • Login UI
    • กดปุ่ม LOGIN หรือ Enter ได้
    • ป้องกันการกดซ้ำระหว่างตรวจสอบ
    • Heartbeat
    • Auto-load Payload
    ═══════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════
-- CONFIG
-- ═══════════════════════════════════════════════

local CONFIG = {
    API_VALIDATE = "https://key-gate-manager-copy-515b28d5.base44.app/functions/validateKey",
    API_HEARTBEAT = "https://key-gate-manager-copy-515b28d5.base44.app/functions/heartbeat",
    HEARTBEAT_INTERVAL = 45,
}

-- ═══════════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════════

local STATE = {
    Token = nil,
    HWID = nil,
    IsValidated = false,
    Checking = false,
}

-- ═══════════════════════════════════════════════
-- HWID
-- ═══════════════════════════════════════════════

if not _G.XHUB_HWID then
    _G.XHUB_HWID = HttpService:GenerateGUID(false)
end

STATE.HWID = _G.XHUB_HWID

-- ═══════════════════════════════════════════════
-- REMOVE OLD GUI
-- ═══════════════════════════════════════════════

pcall(function()
    local old = PlayerGui:FindFirstChild("KeyVaultLogin")
    if old then
        old:Destroy()
    end
end)

-- ═══════════════════════════════════════════════
-- COLORS
-- ═══════════════════════════════════════════════

local UI = {
    Background = Color3.fromRGB(18, 19, 24),
    Card = Color3.fromRGB(26, 28, 35),
    Input = Color3.fromRGB(35, 37, 47),

    Stroke = Color3.fromRGB(55, 58, 72),

    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(155, 160, 175),

    Accent = Color3.fromRGB(100, 150, 255),
    Success = Color3.fromRGB(70, 220, 110),
    Error = Color3.fromRGB(255, 80, 80),
    Warning = Color3.fromRGB(255, 200, 80),
}

-- ═══════════════════════════════════════════════
-- SCREEN GUI
-- ═══════════════════════════════════════════════

local gui = Instance.new("ScreenGui")
gui.Name = "KeyVaultLogin"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = PlayerGui

-- ═══════════════════════════════════════════════
-- MAIN FRAME
-- ═══════════════════════════════════════════════

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 320, 0, 250)
frame.Position = UDim2.new(0.5, -160, 0.5, -125)
frame.BackgroundColor3 = UI.Background
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = UI.Stroke
frameStroke.Thickness = 1
frameStroke.Parent = frame

-- ═══════════════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════════════

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = UI.Card
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = UI.Card
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔐 KeyVault"
title.TextColor3 = UI.Text
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- ═══════════════════════════════════════════════
-- CLOSE BUTTON
-- ═══════════════════════════════════════════════

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 26, 0, 26)
close.Position = UDim2.new(1, -34, 0.5, -13)
close.BackgroundColor3 = UI.Error
close.BackgroundTransparency = 0.8
close.BorderSizePixel = 0
close.Text = "×"
close.TextColor3 = UI.Text
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.AutoButtonColor = false
close.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ═══════════════════════════════════════════════
-- ICON
-- ═══════════════════════════════════════════════

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(1, 0, 0, 42)
icon.Position = UDim2.new(0, 0, 0, 50)
icon.BackgroundTransparency = 1
icon.Text = "🔑"
icon.TextColor3 = UI.Accent
icon.Font = Enum.Font.GothamBold
icon.TextSize = 36
icon.Parent = frame

-- ═══════════════════════════════════════════════
-- SUBTITLE
-- ═══════════════════════════════════════════════

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -40, 0, 18)
subtitle.Position = UDim2.new(0, 20, 0, 91)
subtitle.BackgroundTransparency = 1
subtitle.Text = "ใส่คีย์เพื่อเข้าใช้งาน XHUB"
subtitle.TextColor3 = UI.SubText
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Center
subtitle.Parent = frame

-- ═══════════════════════════════════════════════
-- HWID
-- ═══════════════════════════════════════════════

local hwidLabel = Instance.new("TextLabel")
hwidLabel.Size = UDim2.new(1, -40, 0, 14)
hwidLabel.Position = UDim2.new(0, 20, 0, 108)
hwidLabel.BackgroundTransparency = 1
hwidLabel.Text = "HWID: " .. string.sub(STATE.HWID, 1, 16) .. "..."
hwidLabel.TextColor3 = Color3.fromRGB(95, 100, 115)
hwidLabel.Font = Enum.Font.Code
hwidLabel.TextSize = 9
hwidLabel.TextXAlignment = Enum.TextXAlignment.Center
hwidLabel.Parent = frame

-- ═══════════════════════════════════════════════
-- INPUT
-- ═══════════════════════════════════════════════

local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -40, 0, 38)
inputFrame.Position = UDim2.new(0, 20, 0, 128)
inputFrame.BackgroundColor3 = UI.Input
inputFrame.BorderSizePixel = 0
inputFrame.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputFrame

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = UI.Stroke
inputStroke.Thickness = 1
inputStroke.Parent = inputFrame

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 1, 0)
input.Position = UDim2.new(0, 10, 0, 0)
input.BackgroundTransparency = 1
input.ClearTextOnFocus = false
input.Text = ""
input.PlaceholderText = "ใส่คีย์ที่นี่..."
input.PlaceholderColor3 = Color3.fromRGB(105, 110, 125)
input.TextColor3 = UI.Text
input.Font = Enum.Font.Gotham
input.TextSize = 13
input.TextXAlignment = Enum.TextXAlignment.Left
input.Parent = inputFrame

-- ═══════════════════════════════════════════════
-- STATUS
-- ═══════════════════════════════════════════════

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 18)
status.Position = UDim2.new(0, 20, 0, 171)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = UI.SubText
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.TextXAlignment = Enum.TextXAlignment.Center
status.Parent = frame

-- ═══════════════════════════════════════════════
-- LOGIN BUTTON
-- ═══════════════════════════════════════════════

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -40, 0, 36)
btn.Position = UDim2.new(0, 20, 0, 199)
btn.BackgroundColor3 = UI.Accent
btn.BorderSizePixel = 0
btn.Text = "เข้าสู่ระบบ"
btn.TextColor3 = UI.Text
btn.Font = Enum.Font.GothamBold
btn.TextSize = 13
btn.AutoButtonColor = false
btn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btn

-- ═══════════════════════════════════════════════
-- STATUS HELPER
-- ═══════════════════════════════════════════════

local function setStatus(text, color)
    status.Text = text
    status.TextColor3 = color
end

-- ═══════════════════════════════════════════════
-- VALIDATE KEY
-- ═══════════════════════════════════════════════

local function validateKey(key)

    local body = HttpService:JSONEncode({
        key = key,
        hwid = STATE.HWID,
        username = LocalPlayer.Name
    })

    local ok, response = pcall(function()

        return HttpService:RequestAsync({
            Url = CONFIG.API_VALIDATE,
            Method = "POST",

            Headers = {
                ["Content-Type"] = "application/json"
            },

            Body = body
        })

    end)

    if not ok then
        warn("[KeyVault] HTTP Error:", response)
        return false, "❌ เชื่อมต่อเซิร์ฟเวอร์ไม่ได้"
    end

    if not response.Success then
        warn(
            "[KeyVault] API Error:",
            response.StatusCode,
            response.Body
        )

        return false,
            "❌ เซิร์ฟเวอร์ตอบกลับ " ..
            tostring(response.StatusCode)
    end

    local jsonOk, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not jsonOk then
        warn("[KeyVault] JSON Error:", response.Body)
        return false, "❌ รูปแบบข้อมูลจากเซิร์ฟเวอร์ผิด"
    end

    if data.success then

        STATE.Token = data.token
        STATE.IsValidated = true

        return true, data.payload

    end

    return false, data.message or "❌ คีย์ไม่ถูกต้อง"
end

-- ═══════════════════════════════════════════════
-- LOAD PAYLOAD
-- ═══════════════════════════════════════════════

local function loadPayload(code)

    if type(code) ~= "string" or code == "" then
        setStatus(
            "❌ ไม่พบ Payload",
            UI.Error
        )

        return false
    end

    setStatus(
        "⏳ กำลังโหลด XHUB...",
        UI.Warning
    )

    task.wait(0.4)

    local compileOk, fnOrError = pcall(function()
        return loadstring(code)
    end)

    if not compileOk or not fnOrError then

        warn(
            "[KeyVault] Payload Error:",
            fnOrError
        )

        setStatus(
            "❌ Payload ไม่สามารถโหลดได้",
            UI.Error
        )

        return false
    end

    local fn = fnOrError

    setStatus(
        "✓ Login สำเร็จ!",
        UI.Success
    )

    btn.Text = "✓ สำเร็จ"
    btn.BackgroundColor3 = UI.Success

    task.wait(0.8)

    -- ปิด UI
    gui:Destroy()

    task.wait(0.3)

    -- รัน Payload
    local runOk, runError = pcall(fn)

    if not runOk then
        warn(
            "[KeyVault] Payload Runtime Error:",
            runError
        )

        return false
    end

    return true
end

-- ═══════════════════════════════════════════════
-- LOGIN
-- ═══════════════════════════════════════════════

local function doLogin()

    if STATE.Checking then
        return
    end

    if STATE.IsValidated then
        return
    end

    local key = input.Text:gsub(
        "^%s*(.-)%s*$",
        "%1"
    )

    if key == "" then

        setStatus(
            "⚠ กรุณาใส่คีย์ก่อน",
            UI.Warning
        )

        input:CaptureFocus()

        return
    end

    STATE.Checking = true

    btn.Interactable = false
    btn.Text = "กำลังตรวจสอบ..."
    btn.BackgroundColor3 = Color3.fromRGB(75, 110, 180)

    setStatus(
        "⏳ กำลังตรวจสอบคีย์...",
        UI.Accent
    )

    local success, result = validateKey(key)

    if success then

        print("[KeyVault] Key Valid")
        print("[KeyVault] User:", LocalPlayer.Name)

        loadPayload(result)

        STATE.Checking = false

        return
    end

    -- Login Failed

    STATE.Checking = false
    STATE.IsValidated = false

    warn("[KeyVault] Key Failed:", result)

    setStatus(
        result,
        UI.Error
    )

    btn.Text = "ลองอีกครั้ง"
    btn.BackgroundColor3 = UI.Error
    btn.Interactable = true

    -- Shake
    local original = frame.Position

    for i = 1, 3 do

        TweenService:Create(
            frame,
            TweenInfo.new(0.05),
            {
                Position =
                    original +
                    UDim2.new(0, 7, 0, 0)
            }
        ):Play()

        task.wait(0.05)

        TweenService:Create(
            frame,
            TweenInfo.new(0.05),
            {
                Position =
                    original -
                    UDim2.new(0, 7, 0, 0)
            }
        ):Play()

        task.wait(0.05)
    end

    TweenService:Create(
        frame,
        TweenInfo.new(0.1),
        {
            Position = original
        }
    ):Play()

    task.delay(1.5, function()

        if not gui.Parent then
            return
        end

        if not STATE.Checking then

            btn.Text = "เข้าสู่ระบบ"
            btn.BackgroundColor3 = UI.Accent

            if status.Text == result then
                status.Text = ""
            end

        end

    end)
end

-- ═══════════════════════════════════════════════
-- BUTTON CLICK
-- ═══════════════════════════════════════════════

btn.MouseButton1Click:Connect(function()
    doLogin()
end)

-- ═══════════════════════════════════════════════
-- ENTER KEY
-- ═══════════════════════════════════════════════

input.FocusLost:Connect(function(enterPressed)

    inputStroke.Color = UI.Stroke

    TweenService:Create(
        inputStroke,
        TweenInfo.new(0.15),
        {
            Thickness = 1
        }
    ):Play()

    if enterPressed then
        doLogin()
    end
end)

-- ═══════════════════════════════════════════════
-- INPUT FOCUS
-- ═══════════════════════════════════════════════

input.Focused:Connect(function()

    inputStroke.Color = UI.Accent

    TweenService:Create(
        inputStroke,
        TweenInfo.new(0.15),
        {
            Thickness = 1.5
        }
    ):Play()

end)

-- ═══════════════════════════════════════════════
-- HEARTBEAT
-- ═══════════════════════════════════════════════

task.spawn(function()

    while gui.Parent do

        task.wait(CONFIG.HEARTBEAT_INTERVAL)

        if STATE.IsValidated and STATE.Token then

            local body = HttpService:JSONEncode({
                token = STATE.Token,
                hwid = STATE.HWID
            })

            local ok, response = pcall(function()

                return HttpService:RequestAsync({
                    Url = CONFIG.API_HEARTBEAT,
                    Method = "POST",

                    Headers = {
                        ["Content-Type"] = "application/json"
                    },

                    Body = body
                })

            end)

            if not ok then

                warn(
                    "[KeyVault] Heartbeat Error:",
                    response
                )

            elseif not response.Success then

                warn(
                    "[KeyVault] Heartbeat Failed:",
                    response.StatusCode
                )

                STATE.IsValidated = false

            else

                local jsonOk, data =
                    pcall(function()
                        return HttpService:JSONDecode(
                            response.Body
                        )
                    end)

                if jsonOk and data.success then

                    print(
                        "[KeyVault] Heartbeat OK"
                    )

                else

                    warn(
                        "[KeyVault] Heartbeat Invalid"
                    )

                    STATE.IsValidated = false
                end
            end
        end
    end
end)

-- ═══════════════════════════════════════════════
-- OPEN ANIMATION
-- ═══════════════════════════════════════════════

frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(
    frame,
    TweenInfo.new(
        0.4,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ),
    {
        Size = UDim2.new(0, 320, 0, 250),
        Position = UDim2.new(
            0.5,
            -160,
            0.5,
            -125
        )
    }
):Play()

-- ═══════════════════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════════════════

_G.KeyVaultCleanup = function()

    STATE.IsValidated = false
    STATE.Checking = false

    if gui and gui.Parent then
        gui:Destroy()
    end

end

print("[KeyVault] Ready")
print("[KeyVault] HWID:", STATE.HWID)