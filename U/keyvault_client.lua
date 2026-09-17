--[[
    ═══════════════════════════════════════════════
    KeyVault Login Client
    ─────────────────────────────────────────────
    • Client ID จาก Roblox
    • บันทึก HWID ลง xhub_hwid.txt
    • Login UI
    • ปุ่ม Login / Enter
    • Validate Key
    • Heartbeat
    • Auto-load Payload
    • แสดง API Error สำหรับ Debug
    ═══════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════
-- CONFIG
-- ═══════════════════════════════════════════════

local CONFIG = {
    API_VALIDATE =
        "https://key-gate-manager-copy-515b28d5.base44.app/functions/validateKey",

    API_HEARTBEAT =
        "https://key-gate-manager-copy-515b28d5.base44.app/functions/heartbeat",

    HEARTBEAT_INTERVAL = 45,

    HWID_FILE = "xhub_hwid.txt"
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

local function getHWID()

    local clientId

    local ok, result = pcall(function()
        return RbxAnalyticsService:GetClientId()
    end)

    if not ok or not result or result == "" then
        warn("[KeyVault] Cannot get Roblox ClientId")
        return nil
    end

    clientId = result

    -- มีไฟล์เดิม
    if isfile and isfile(CONFIG.HWID_FILE) then

        local okRead, saved = pcall(function()
            return readfile(CONFIG.HWID_FILE)
        end)

        if okRead and saved and saved ~= "" then

            saved = saved:gsub("^%s*(.-)%s*$", "%1")

            if saved ~= "" then
                print("[KeyVault] Using saved HWID")
                return saved
            end
        end
    end

    -- ยังไม่มีไฟล์
    if writefile then

        pcall(function()
            writefile(CONFIG.HWID_FILE, clientId)
        end)

        print("[KeyVault] HWID file created")

    else

        warn("[KeyVault] writefile is not available")

    end

    return clientId
end

STATE.HWID = getHWID()

if STATE.HWID then
    print("[KeyVault] HWID loaded")
else
    warn("[KeyVault] HWID unavailable")
end

-- ═══════════════════════════════════════════════
-- REMOVE OLD GUI
-- ═══════════════════════════════════════════════

pcall(function()

    local oldGui =
        PlayerGui:FindFirstChild("KeyVaultLogin")

    if oldGui then
        oldGui:Destroy()
    end

end)

-- ═══════════════════════════════════════════════
-- COLORS
-- ═══════════════════════════════════════════════

local UI = {

    Bg = Color3.fromRGB(18, 19, 24),

    Card = Color3.fromRGB(26, 28, 35),

    Input = Color3.fromRGB(35, 37, 47),

    Stroke = Color3.fromRGB(55, 58, 72),

    Text = Color3.fromRGB(255, 255, 255),

    SubText = Color3.fromRGB(150, 155, 170),

    Accent = Color3.fromRGB(100, 150, 255),

    Success = Color3.fromRGB(60, 220, 100),

    Danger = Color3.fromRGB(255, 80, 80),

    Warning = Color3.fromRGB(255, 200, 80),
}

-- ═══════════════════════════════════════════════
-- SCREEN GUI
-- ═══════════════════════════════════════════════

local gui = Instance.new("ScreenGui")

gui.Name = "KeyVaultLogin"

gui.ResetOnSpawn = false

gui.IgnoreGuiInset = true

gui.DisplayOrder = 99999

gui.Parent = PlayerGui

-- ═══════════════════════════════════════════════
-- MAIN
-- ═══════════════════════════════════════════════

local main = Instance.new("Frame")

main.Name = "Main"

main.Size =
    UDim2.new(0, 320, 0, 250)

main.Position =
    UDim2.new(0.5, -160, 0.5, -125)

main.BackgroundColor3 = UI.Bg

main.BorderSizePixel = 0

main.Active = true

main.Draggable = true

main.Parent = gui

local mainCorner = Instance.new("UICorner")

mainCorner.CornerRadius =
    UDim.new(0, 14)

mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")

mainStroke.Color = UI.Stroke

mainStroke.Thickness = 1

mainStroke.Parent = main

-- ═══════════════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════════════

local titleBar = Instance.new("Frame")

titleBar.Size =
    UDim2.new(1, 0, 0, 40)

titleBar.BackgroundColor3 = UI.Card

titleBar.BorderSizePixel = 0

titleBar.Parent = main

local titleCorner = Instance.new("UICorner")

titleCorner.CornerRadius =
    UDim.new(0, 14)

titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")

titleFix.Size =
    UDim2.new(1, 0, 0, 14)

titleFix.Position =
    UDim2.new(0, 0, 1, -14)

titleFix.BackgroundColor3 = UI.Card

titleFix.BorderSizePixel = 0

titleFix.Parent = titleBar

local title = Instance.new("TextLabel")

title.Size =
    UDim2.new(1, -60, 1, 0)

title.Position =
    UDim2.new(0, 15, 0, 0)

title.BackgroundTransparency = 1

title.Text = "🔐 KeyVault"

title.TextColor3 = UI.Text

title.Font = Enum.Font.GothamBold

title.TextSize = 14

title.TextXAlignment =
    Enum.TextXAlignment.Left

title.Parent = titleBar

-- ═══════════════════════════════════════════════
-- CLOSE
-- ═══════════════════════════════════════════════

local close = Instance.new("TextButton")

close.Size =
    UDim2.new(0, 26, 0, 26)

close.Position =
    UDim2.new(1, -34, 0.5, -13)

close.BackgroundColor3 = UI.Danger

close.BackgroundTransparency = 0.8

close.BorderSizePixel = 0

close.Text = "×"

close.TextColor3 = UI.Text

close.Font = Enum.Font.GothamBold

close.TextSize = 18

close.AutoButtonColor = false

close.Parent = titleBar

local closeCorner = Instance.new("UICorner")

closeCorner.CornerRadius =
    UDim.new(0, 7)

closeCorner.Parent = close

close.MouseButton1Click:Connect(function()

    gui:Destroy()

end)

-- ═══════════════════════════════════════════════
-- ICON
-- ═══════════════════════════════════════════════

local icon = Instance.new("TextLabel")

icon.Size =
    UDim2.new(1, 0, 0, 42)

icon.Position =
    UDim2.new(0, 0, 0, 49)

icon.BackgroundTransparency = 1

icon.Text = "🔑"

icon.TextColor3 = UI.Accent

icon.Font = Enum.Font.GothamBold

icon.TextSize = 36

icon.Parent = main

-- ═══════════════════════════════════════════════
-- SUBTITLE
-- ═══════════════════════════════════════════════

local subtitle = Instance.new("TextLabel")

subtitle.Size =
    UDim2.new(1, -40, 0, 18)

subtitle.Position =
    UDim2.new(0, 20, 0, 90)

subtitle.BackgroundTransparency = 1

subtitle.Text =
    "ใส่คีย์เพื่อเข้าใช้งาน XHUB"

subtitle.TextColor3 = UI.SubText

subtitle.Font = Enum.Font.Gotham

subtitle.TextSize = 11

subtitle.TextXAlignment =
    Enum.TextXAlignment.Center

subtitle.Parent = main

-- ═══════════════════════════════════════════════
-- HWID DISPLAY
-- ═══════════════════════════════════════════════

local hwidText = "HWID: ไม่พบ"

if STATE.HWID then

    hwidText =
        "HWID: " ..
        string.sub(STATE.HWID, 1, 12) ..
        "..."

end

local hwidLabel = Instance.new("TextLabel")

hwidLabel.Size =
    UDim2.new(1, -40, 0, 14)

hwidLabel.Position =
    UDim2.new(0, 20, 0, 108)

hwidLabel.BackgroundTransparency = 1

hwidLabel.Text = hwidText

hwidLabel.TextColor3 =
    Color3.fromRGB(95, 100, 115)

hwidLabel.Font = Enum.Font.Code

hwidLabel.TextSize = 9

hwidLabel.TextXAlignment =
    Enum.TextXAlignment.Center

hwidLabel.Parent = main

-- ═══════════════════════════════════════════════
-- INPUT FRAME
-- ═══════════════════════════════════════════════

local inputFrame = Instance.new("Frame")

inputFrame.Size =
    UDim2.new(1, -40, 0, 38)

inputFrame.Position =
    UDim2.new(0, 20, 0, 128)

inputFrame.BackgroundColor3 = UI.Input

inputFrame.BorderSizePixel = 0

inputFrame.Parent = main

local inputCorner = Instance.new("UICorner")

inputCorner.CornerRadius =
    UDim.new(0, 8)

inputCorner.Parent = inputFrame

local inputStroke = Instance.new("UIStroke")

inputStroke.Color = UI.Stroke

inputStroke.Thickness = 1

inputStroke.Parent = inputFrame

-- ═══════════════════════════════════════════════
-- INPUT
-- ═══════════════════════════════════════════════

local input = Instance.new("TextBox")

input.Size =
    UDim2.new(1, -20, 1, 0)

input.Position =
    UDim2.new(0, 10, 0, 0)

input.BackgroundTransparency = 1

input.BorderSizePixel = 0

input.ClearTextOnFocus = false

input.Text = ""

input.PlaceholderText =
    "ใส่คีย์ที่นี่..."

input.PlaceholderColor3 =
    Color3.fromRGB(100, 105, 120)

input.TextColor3 = UI.Text

input.Font = Enum.Font.Gotham

input.TextSize = 13

input.TextXAlignment =
    Enum.TextXAlignment.Left

input.Parent = inputFrame

-- ═══════════════════════════════════════════════
-- STATUS
-- ═══════════════════════════════════════════════

local status = Instance.new("TextLabel")

status.Size =
    UDim2.new(1, -40, 0, 18)

status.Position =
    UDim2.new(0, 20, 0, 171)

status.BackgroundTransparency = 1

status.Text = ""

status.TextColor3 = UI.SubText

status.Font = Enum.Font.Gotham

status.TextSize = 10

status.TextXAlignment =
    Enum.TextXAlignment.Center

status.Parent = main

-- ═══════════════════════════════════════════════
-- LOGIN BUTTON
-- ═══════════════════════════════════════════════

local login = Instance.new("TextButton")

login.Size =
    UDim2.new(1, -40, 0, 36)

login.Position =
    UDim2.new(0, 20, 0, 199)

login.BackgroundColor3 = UI.Accent

login.BorderSizePixel = 0

login.Text = "เข้าสู่ระบบ"

login.TextColor3 = UI.Text

login.Font = Enum.Font.GothamBold

login.TextSize = 13

login.AutoButtonColor = false

login.Parent = main

local loginCorner = Instance.new("UICorner")

loginCorner.CornerRadius =
    UDim.new(0, 8)

loginCorner.Parent = login

-- ═══════════════════════════════════════════════
-- STATUS FUNCTION
-- ═══════════════════════════════════════════════

local function setStatus(text, color)

    status.Text = text

    status.TextColor3 = color

end

-- ═══════════════════════════════════════════════
-- REQUEST HELPER
-- ═══════════════════════════════════════════════

local function sendRequest(url, body)

    local ok, response = pcall(function()

        return request({

            Method = "POST",

            Url = url,

            Headers = {
                ["Content-Type"] =
                    "application/json"
            },

            Body = body

        })

    end)

    if not ok then

        warn(
            "[KeyVault] Request Error:",
            response
        )

        return false, nil

    end

    print(
        "[KeyVault] HTTP Status:",
        response.StatusCode
    )

    print(
        "[KeyVault] HTTP Body:",
        response.Body
    )

    return true, response

end

-- ═══════════════════════════════════════════════
-- VALIDATE KEY
-- ═══════════════════════════════════════════════

local function validateKey(key)

    if not STATE.HWID then

        return false,
            "❌ ไม่พบ HWID"

    end

    local body =
        HttpService:JSONEncode({

            key = key,

            hwid = STATE.HWID,

            username =
                LocalPlayer.Name

        })

    local requestOK, response =
        sendRequest(
            CONFIG.API_VALIDATE,
            body
        )

    if not requestOK then

        return false,
            "❌ เชื่อมต่อเซิร์ฟเวอร์ไม่ได้"

    end

    if not response.Success then

        warn(
            "[KeyVault] Validate HTTP Error:",
            response.StatusCode,
            response.Body
        )

        return false,
            "❌ Server Error " ..
            tostring(response.StatusCode)

    end

    local jsonOK, data =
        pcall(function()

            return HttpService:JSONDecode(
                response.Body
            )

        end)

    if not jsonOK then

        return false,
            "❌ Server ส่งข้อมูลไม่ถูกต้อง"

    end

    if data.success then

        STATE.Token = data.token

        STATE.IsValidated = true

        -- ถ้า Server ส่ง HWID ที่ยืนยันกลับมา
        if data.hwid
            and data.hwid ~= "" then

            STATE.HWID = data.hwid

        end

        return true, data.payload

    end

    return false,
        data.message or
        "❌ คีย์ไม่ถูกต้อง"

end

-- ═══════════════════════════════════════════════
-- LOAD PAYLOAD
-- ═══════════════════════════════════════════════

local function loadPayload(code)

    if type(code) ~= "string"
        or code == "" then

        setStatus(
            "❌ ไม่พบ Payload",
            UI.Danger
        )

        login.Interactable = true

        return

    end

    setStatus(
        "⏳ กำลังโหลด XHUB...",
        UI.Warning
    )

    task.wait(0.4)

    local compileOK, fn =
        pcall(function()

            return loadstring(code)

        end)

    if not compileOK or not fn then

        warn(
            "[KeyVault] Payload Compile Error:",
            fn
        )

        setStatus(
            "❌ โหลด Payload ไม่สำเร็จ",
            UI.Danger
        )

        login.Interactable = true

        return

    end

    setStatus(
        "✓ Login สำเร็จ!",
        UI.Success
    )

    login.Text = "✓ สำเร็จ"

    login.BackgroundColor3 =
        UI.Success

    task.wait(0.8)

    if gui and gui.Parent then
        gui:Destroy()
    end

    task.wait(0.3)

    local runOK, runError =
        pcall(fn)

    if not runOK then

        warn(
            "[KeyVault] Payload Runtime Error:",
            runError
        )

    end

end

-- ═══════════════════════════════════════════════
-- LOGIN
-- ═══════════════════════════════════════════════

local function doLogin()

    if STATE.Checking then
        return
    end

    local key =
        input.Text:gsub(
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

    login.Interactable = false

    login.Text =
        "กำลังตรวจสอบ..."

    login.BackgroundColor3 =
        Color3.fromRGB(70, 105, 175)

    setStatus(
        "⏳ กำลังตรวจสอบคีย์...",
        UI.Accent
    )

    local success, result =
        validateKey(key)

    if success then

        print(
            "[KeyVault] Validate Success"
        )

        loadPayload(result)

        STATE.Checking = false

        return

    end

    STATE.Checking = false

    STATE.IsValidated = false

    warn(
        "[KeyVault] Validate Failed:",
        result
    )

    setStatus(
        result,
        UI.Danger
    )

    login.Text =
        "ลองอีกครั้ง"

    login.BackgroundColor3 =
        UI.Danger

    login.Interactable = true

    -- Shake
    local originalPosition =
        main.Position

    for i = 1, 3 do

        TweenService:Create(
            main,

            TweenInfo.new(0.05),

            {
                Position =
                    originalPosition +
                    UDim2.new(0, 7, 0, 0)
            }

        ):Play()

        task.wait(0.05)

        TweenService:Create(
            main,

            TweenInfo.new(0.05),

            {
                Position =
                    originalPosition -
                    UDim2.new(0, 7, 0, 0)
            }

        ):Play()

        task.wait(0.05)

    end

    TweenService:Create(
        main,

        TweenInfo.new(0.1),

        {
            Position =
                originalPosition
        }

    ):Play()

    task.delay(1.5, function()

        if not gui.Parent then
            return
        end

        if not STATE.Checking then

            login.Text =
                "เข้าสู่ระบบ"

            login.BackgroundColor3 =
                UI.Accent

            login.Interactable = true

            status.Text = ""

        end

    end)

end

-- ═══════════════════════════════════════════════
-- BUTTON
-- ═══════════════════════════════════════════════

login.MouseButton1Click:Connect(function()

    doLogin()

end)

-- ═══════════════════════════════════════════════
-- ENTER
-- ═══════════════════════════════════════════════

input.FocusLost:Connect(function(
    enterPressed
)

    inputStroke.Color = UI.Stroke

    if enterPressed then

        doLogin()

    end

end)

-- ═══════════════════════════════════════════════
-- INPUT FOCUS
-- ═══════════════════════════════════════════════

input.Focused:Connect(function()

    inputStroke.Color =
        UI.Accent

end)

-- ═══════════════════════════════════════════════
-- OPEN ANIMATION
-- ═══════════════════════════════════════════════

main.Size =
    UDim2.new(0, 0, 0, 0)

main.Position =
    UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(

    main,

    TweenInfo.new(
        0.4,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ),

    {
        Size =
            UDim2.new(0, 320, 0, 250),

        Position =
            UDim2.new(
                0.5,
                -160,
                0.5,
                -125
            )
    }

):Play()

-- ═══════════════════════════════════════════════
-- HEARTBEAT
-- ═══════════════════════════════════════════════

task.spawn(function()

    while gui.Parent do

        task.wait(
            CONFIG.HEARTBEAT_INTERVAL
        )

        if STATE.IsValidated
            and STATE.Token then

            local body =
                HttpService:JSONEncode({

                    token =
                        STATE.Token,

                    hwid =
                        STATE.HWID

                })

            local requestOK, response =
                sendRequest(
                    CONFIG.API_HEARTBEAT,
                    body
                )

            if not requestOK then

                warn(
                    "[KeyVault] Heartbeat Request Error"
                )

            elseif response.StatusCode == 401 then

                warn(
                    "[KeyVault] Key invalidated"
                )

                STATE.Token = nil
                STATE.IsValidated = false

            elseif not response.Success then

                warn(
                    "[KeyVault] Heartbeat Failed:",
                    response.StatusCode,
                    response.Body
                )

            else

                local jsonOK, data =
                    pcall(function()

                        return HttpService:JSONDecode(
                            response.Body
                        )

                    end)

                if jsonOK
                    and data.success then

                    print(
                        "[KeyVault] Heartbeat OK"
                    )

                else

                    warn(
                        "[KeyVault] Invalid Heartbeat Response"
                    )

                end

            end
        end
    end
end)

-- ═══════════════════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════════════════

_G.KeyVaultCleanup = function()

    STATE.IsValidated = false

    STATE.Checking = false

    STATE.Token = nil

    if gui and gui.Parent then
        gui:Destroy()
    end

end

-- ═══════════════════════════════════════════════
-- READY
-- ═══════════════════════════════════════════════

print("[KeyVault] Ready")

if STATE.HWID then
    print("[KeyVault] HWID loaded successfully")
else
    warn("[KeyVault] HWID is unavailable")
end