--[[ Protected by Lua Guard ]]

--[[
    ═══════════════════════════════════════════════
    KeyVault Login Client
    ─────────────────────────────────────────────
    • Client ID จาก Roblox
    • ไม่ใช้ xhub_hwid.txt
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
local _llllIIlIll = game:GetService("RbxAnalyticsService")

local _IlIllIIlII = Players.LocalPlayer
local _IllllllllI = _IlIllIIlII:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════
-- _IllllllIll
-- ═══════════════════════════════════════════════

local _IllllllIll = {
    API_VALIDATE =
        "https://key-gate-manager-copy-515b28d5.base44.app/functions/validateKey",

    API_HEARTBEAT =
        "https://key-gate-manager-copy-515b28d5.base44.app/functions/heartbeat",

    HEARTBEAT_INTERVAL = 45
}

-- ═══════════════════════════════════════════════
-- _IIIlIlIllI
-- ═══════════════════════════════════════════════

local _IIIlIlIllI = {
    Token = nil,
    HWID = nil,
    IsValidated = false,
    Checking = false,
}

-- ═══════════════════════════════════════════════
-- HWID / CLIENT ID
-- ═══════════════════════════════════════════════

local function _IlIIIIllIl()

    local _lIIlIlllIl, clientId = pcall(function()
        return _llllIIlIll:GetClientId()
    end)

    if not _lIIlIlllIl then
        warn(
            "[KeyVault] Cannot get Roblox ClientId:",
            clientId
        )

        return nil
    end

    if not clientId
        or clientId == "" then

        warn(
            "[KeyVault] Roblox ClientId is empty"
        )

        return nil
    end

    print(
        "[KeyVault] Client ID obtained"
    )

    return clientId
end

_IIIlIlIllI.HWID = _IlIIIIllIl()

if _IIIlIlIllI.HWID then
    print("[KeyVault] HWID loaded successfully")
else
    warn("[KeyVault] HWID unavailable")
end

-- ═══════════════════════════════════════════════
-- REMOVE OLD GUI
-- ═══════════════════════════════════════════════

pcall(function()

    local _IlIIlIIIlI =
        _IllllllllI:FindFirstChild("KeyVaultLogin")

    if _IlIIlIIIlI then
        _IlIIlIIIlI:Destroy()
    end

end)

-- ═══════════════════════════════════════════════
-- COLORS
-- ═══════════════════════════════════════════════

local _llIlIlllII = {

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

local _lIIIIlIIlI = Instance.new("ScreenGui")

_lIIIIlIIlI.Name = "KeyVaultLogin"

_lIIIIlIIlI.ResetOnSpawn = false

_lIIIIlIIlI.IgnoreGuiInset = true

_lIIIIlIIlI.DisplayOrder = 99999

_lIIIIlIIlI.Parent = _IllllllllI

-- ═══════════════════════════════════════════════
-- MAIN
-- ═══════════════════════════════════════════════

local _lIIIlIlIII = Instance.new("Frame")

_lIIIlIlIII.Name = "Main"

_lIIIlIlIII.Size =
    UDim2.new(0, 320, 0, 250)

_lIIIlIlIII.Position =
    UDim2.new(0.5, -160, 0.5, -125)

_lIIIlIlIII.BackgroundColor3 = _llIlIlllII.Bg

_lIIIlIlIII.BorderSizePixel = 0

_lIIIlIlIII.Active = true

_lIIIlIlIII.Draggable = true

_lIIIlIlIII.Parent = _lIIIIlIIlI

local _lllllllIII = Instance.new("UICorner")

_lllllllIII.CornerRadius =
    UDim.new(0, 14)

_lllllllIII.Parent = _lIIIlIlIII

local _llllllIIII = Instance.new("UIStroke")

_llllllIIII.Color = _llIlIlllII.Stroke

_llllllIIII.Thickness = 1

_llllllIIII.Parent = _lIIIlIlIII

-- ═══════════════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════════════

local _lIIIlIIlII = Instance.new("Frame")

_lIIIlIIlII.Size =
    UDim2.new(1, 0, 0, 40)

_lIIIlIIlII.BackgroundColor3 = _llIlIlllII.Card

_lIIIlIIlII.BorderSizePixel = 0

_lIIIlIIlII.Parent = _lIIIlIlIII

local _IIlllIIIll = Instance.new("UICorner")

_IIlllIIIll.CornerRadius =
    UDim.new(0, 14)

_IIlllIIIll.Parent = _lIIIlIIlII

local _IIIllllIIl = Instance.new("Frame")

_IIIllllIIl.Size =
    UDim2.new(1, 0, 0, 14)

_IIIllllIIl.Position =
    UDim2.new(0, 0, 1, -14)

_IIIllllIIl.BackgroundColor3 = _llIlIlllII.Card

_IIIllllIIl.BorderSizePixel = 0

_IIIllllIIl.Parent = _lIIIlIIlII

local _IlllIIIllI = Instance.new("TextLabel")

_IlllIIIllI.Size =
    UDim2.new(1, -60, 1, 0)

_IlllIIIllI.Position =
    UDim2.new(0, 15, 0, 0)

_IlllIIIllI.BackgroundTransparency = 1

_IlllIIIllI.Text = "🔐 KeyVault"

_IlllIIIllI.TextColor3 = _llIlIlllII.Text

_IlllIIIllI.Font = Enum.Font.GothamBold

_IlllIIIllI.TextSize = 14

_IlllIIIllI.TextXAlignment =
    Enum.TextXAlignment.Left

_IlllIIIllI.Parent = _lIIIlIIlII

-- ═══════════════════════════════════════════════
-- CLOSE
-- ═══════════════════════════════════════════════

local _lIllIlIlIl = Instance.new("TextButton")

_lIllIlIlIl.Size =
    UDim2.new(0, 26, 0, 26)

_lIllIlIlIl.Position =
    UDim2.new(1, -34, 0.5, -13)

_lIllIlIlIl.BackgroundColor3 = _llIlIlllII.Danger

_lIllIlIlIl.BackgroundTransparency = 0.8

_lIllIlIlIl.BorderSizePixel = 0

_lIllIlIlIl.Text = "×"

_lIllIlIlIl.TextColor3 = _llIlIlllII.Text

_lIllIlIlIl.Font = Enum.Font.GothamBold

_lIllIlIlIl.TextSize = 18

_lIllIlIlIl.AutoButtonColor = false

_lIllIlIlIl.Parent = _lIIIlIIlII

local _lIIlIIIlIl = Instance.new("UICorner")

_lIIlIIIlIl.CornerRadius =
    UDim.new(0, 7)

_lIIlIIIlIl.Parent = _lIllIlIlIl

_lIllIlIlIl.MouseButton1Click:Connect(function()

    _lIIIIlIIlI:Destroy()

end)

-- ═══════════════════════════════════════════════
-- ICON
-- ═══════════════════════════════════════════════

local _IIIllllIlI = Instance.new("TextLabel")

_IIIllllIlI.Size =
    UDim2.new(1, 0, 0, 42)

_IIIllllIlI.Position =
    UDim2.new(0, 0, 0, 49)

_IIIllllIlI.BackgroundTransparency = 1

_IIIllllIlI.Text = "🔑"

_IIIllllIlI.TextColor3 = _llIlIlllII.Accent

_IIIllllIlI.Font = Enum.Font.GothamBold

_IIIllllIlI.TextSize = 36

_IIIllllIlI.Parent = _lIIIlIlIII

-- ═══════════════════════════════════════════════
-- SUBTITLE
-- ═══════════════════════════════════════════════

local _lllIlIIlIl = Instance.new("TextLabel")

_lllIlIIlIl.Size =
    UDim2.new(1, -40, 0, 18)

_lllIlIIlIl.Position =
    UDim2.new(0, 20, 0, 90)

_lllIlIIlIl.BackgroundTransparency = 1

_lllIlIIlIl.Text =
    "ใส่คีย์เพื่อเข้าใช้งาน XHUB"

_lllIlIIlIl.TextColor3 = _llIlIlllII.SubText

_lllIlIIlIl.Font = Enum.Font.Gotham

_lllIlIIlIl.TextSize = 11

_lllIlIIlIl.TextXAlignment =
    Enum.TextXAlignment.Center

_lllIlIIlIl.Parent = _lIIIlIlIII

-- ═══════════════════════════════════════════════
-- HWID DISPLAY
-- ═══════════════════════════════════════════════

local _lIIlIlIIll = "HWID: ไม่พบ"

if _IIIlIlIllI.HWID then

    _lIIlIlIIll =
        "HWID: " ..
        string.sub(_IIIlIlIllI.HWID, 1, 12) ..
        "..."

end

local _lIIllIlIIl = Instance.new("TextLabel")

_lIIllIlIIl.Size =
    UDim2.new(1, -40, 0, 14)

_lIIllIlIIl.Position =
    UDim2.new(0, 20, 0, 108)

_lIIllIlIIl.BackgroundTransparency = 1

_lIIllIlIIl.Text = _lIIlIlIIll

_lIIllIlIIl.TextColor3 =
    Color3.fromRGB(95, 100, 115)

_lIIllIlIIl.Font = Enum.Font.Code

_lIIllIlIIl.TextSize = 9

_lIIllIlIIl.TextXAlignment =
    Enum.TextXAlignment.Center

_lIIllIlIIl.Parent = _lIIIlIlIII

-- ═══════════════════════════════════════════════
-- INPUT FRAME
-- ═══════════════════════════════════════════════

local _llllIllllI = Instance.new("Frame")

_llllIllllI.Size =
    UDim2.new(1, -40, 0, 38)

_llllIllllI.Position =
    UDim2.new(0, 20, 0, 128)

_llllIllllI.BackgroundColor3 = _llIlIlllII.Input

_llllIllllI.BorderSizePixel = 0

_llllIllllI.Parent = _lIIIlIlIII

local _llIllllIlI = Instance.new("UICorner")

_llIllllIlI.CornerRadius =
    UDim.new(0, 8)

_llIllllIlI.Parent = _llllIllllI

local _IIIllllIIl = Instance.new("UIStroke")

_IIIllllIIl.Color = _llIlIlllII.Stroke

_IIIllllIIl.Thickness = 1

_IIIllllIIl.Parent = _llllIllllI

-- ═══════════════════════════════════════════════
-- INPUT
-- ═══════════════════════════════════════════════

local _lIIIIlIlII = Instance.new("TextBox")

_lIIIIlIlII.Size =
    UDim2.new(1, -20, 1, 0)

_lIIIIlIlII.Position =
    UDim2.new(0, 10, 0, 0)

_lIIIIlIlII.BackgroundTransparency = 1

_lIIIIlIlII.BorderSizePixel = 0

_lIIIIlIlII.ClearTextOnFocus = false

_lIIIIlIlII.Text = ""

_lIIIIlIlII.PlaceholderText =
    "ใส่คีย์ที่นี่..."

_lIIIIlIlII.PlaceholderColor3 =
    Color3.fromRGB(100, 105, 120)

_lIIIIlIlII.TextColor3 = _llIlIlllII.Text

_lIIIIlIlII.Font = Enum.Font.Gotham

_lIIIIlIlII.TextSize = 13

_lIIIIlIlII.TextXAlignment =
    Enum.TextXAlignment.Left

_lIIIIlIlII.Parent = _llllIllllI

-- ═══════════════════════════════════════════════
-- STATUS
-- ═══════════════════════════════════════════════

local _IIIlIIllIl = Instance.new("TextLabel")

_IIIlIIllIl.Size =
    UDim2.new(1, -40, 0, 18)

_IIIlIIllIl.Position =
    UDim2.new(0, 20, 0, 171)

_IIIlIIllIl.BackgroundTransparency = 1

_IIIlIIllIl.Text = ""

_IIIlIIllIl.TextColor3 = _llIlIlllII.SubText

_IIIlIIllIl.Font = Enum.Font.Gotham

_IIIlIIllIl.TextSize = 10

_IIIlIIllIl.TextXAlignment =
    Enum.TextXAlignment.Center

_IIIlIIllIl.Parent = _lIIIlIlIII

-- ═══════════════════════════════════════════════
-- LOGIN BUTTON
-- ═══════════════════════════════════════════════

local _lIIllllIlI = Instance.new("TextButton")

_lIIllllIlI.Size =
    UDim2.new(1, -40, 0, 36)

_lIIllllIlI.Position =
    UDim2.new(0, 20, 0, 199)

_lIIllllIlI.BackgroundColor3 = _llIlIlllII.Accent

_lIIllllIlI.BorderSizePixel = 0

_lIIllllIlI.Text = "เข้าสู่ระบบ"

_lIIllllIlI.TextColor3 = _llIlIlllII.Text

_lIIllllIlI.Font = Enum.Font.GothamBold

_lIIllllIlI.TextSize = 13

_lIIllllIlI.AutoButtonColor = false

_lIIllllIlI.Parent = _lIIIlIlIII

local _lllllIIlII = Instance.new("UICorner")

_lllllIIlII.CornerRadius =
    UDim.new(0, 8)

_lllllIIlII.Parent = _lIIllllIlI

-- ═══════════════════════════════════════════════
-- STATUS FUNCTION
-- ═══════════════════════════════════════════════

local function _llIIllIIlI(text, color)

    _IIIlIIllIl.Text = text

    _IIIlIIllIl.TextColor3 = color

end

-- ═══════════════════════════════════════════════
-- REQUEST HELPER
-- ═══════════════════════════════════════════════

local function _IIIlIlllIl(url, _IlIlIIlIII)

    local _lIIlIlllIl, response = pcall(function()

        return request({

            Method = "POST",

            Url = url,

            Headers = {
                ["Content-Type"] =
                    "application/json"
            },

            Body = _IlIlIIlIII

        })

    end)

    if not _lIIlIlllIl then

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

local function _llIIlIIIlI(_IllllIlIll)

    if not _IIIlIlIllI.HWID then

        return false,
            "❌ ไม่พบ HWID"

    end

    local _IlIlIIlIII =
        HttpService:JSONEncode({

            _IllllIlIll = _IllllIlIll,

            hwid = _IIIlIlIllI.HWID,

            username =
                _IlIllIIlII.Name

        })

    local _IIlIllIIlI, response =
        _IIIlIlllIl(
            _IllllllIll.API_VALIDATE,
            _IlIlIIlIII
        )

    if not _IIlIllIIlI then

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

    local _IIIIIIlllI, data =
        pcall(function()

            return HttpService:JSONDecode(
                response.Body
            )

        end)

    if not _IIIIIIlllI then

        return false,
            "❌ Server ส่งข้อมูลไม่ถูกต้อง"

    end

    if data.success then

        _IIIlIlIllI.Token = data.token

        _IIIlIlIllI.IsValidated = true

        if data.hwid
            and data.hwid ~= "" then

            _IIIlIlIllI.HWID = data.hwid

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

local function _IIlIllllIl(code)

    if type(code) ~= "string"
        or code == "" then

        _llIIllIIlI(
            "❌ ไม่พบ Payload",
            _llIlIlllII.Danger
        )

        _lIIllllIlI.Interactable = true

        return

    end

    _llIIllIIlI(
        "⏳ กำลังโหลด XHUB...",
        _llIlIlllII.Warning
    )

    task.wait(0.4)

    local _lllIlllIII, fn =
        pcall(function()

            return loadstring(code)

        end)

    if not _lllIlllIII or not fn then

        warn(
            "[KeyVault] Payload Compile Error:",
            fn
        )

        _llIIllIIlI(
            "❌ โหลด Payload ไม่สำเร็จ",
            _llIlIlllII.Danger
        )

        _lIIllllIlI.Interactable = true

        return

    end

    _llIIllIIlI(
        "✓ Login สำเร็จ!",
        _llIlIlllII.Success
    )

    _lIIllllIlI.Text = "✓ สำเร็จ"

    _lIIllllIlI.BackgroundColor3 =
        _llIlIlllII.Success

    task.wait(0.8)

    if _lIIIIlIIlI and _lIIIIlIIlI.Parent then
        _lIIIIlIIlI:Destroy()
    end

    task.wait(0.3)

    local _IlIlIllIIl, runError =
        pcall(fn)

    if not _IlIlIllIIl then

        warn(
            "[KeyVault] Payload Runtime Error:",
            runError
        )

    end

end

-- ═══════════════════════════════════════════════
-- LOGIN
-- ═══════════════════════════════════════════════

local function _lIllIllIll()

    if _IIIlIlIllI.Checking then
        return
    end

    local _IllllIlIll =
        _lIIIIlIlII.Text:gsub(
            "^%s*(.-)%s*$",
            "%1"
        )

    if _IllllIlIll == "" then

        _llIIllIIlI(
            "⚠ กรุณาใส่คีย์ก่อน",
            _llIlIlllII.Warning
        )

        _lIIIIlIlII:CaptureFocus()

        return

    end

    _IIIlIlIllI.Checking = true

    _lIIllllIlI.Interactable = false

    _lIIllllIlI.Text =
        "กำลังตรวจสอบ..."

    _lIIllllIlI.BackgroundColor3 =
        Color3.fromRGB(70, 105, 175)

    _llIIllIIlI(
        "⏳ กำลังตรวจสอบคีย์...",
        _llIlIlllII.Accent
    )

    local _llIlIllIlI, result =
        _llIIlIIIlI(_IllllIlIll)

    if _llIlIllIlI then

        print(
            "[KeyVault] Validate Success"
        )

        _IIlIllllIl(result)

        _IIIlIlIllI.Checking = false

        return

    end

    _IIIlIlIllI.Checking = false

    _IIIlIlIllI.IsValidated = false

    warn(
        "[KeyVault] Validate Failed:",
        result
    )

    _llIIllIIlI(
        result,
        _llIlIlllII.Danger
    )

    _lIIllllIlI.Text =
        "ลองอีกครั้ง"

    _lIIllllIlI.BackgroundColor3 =
        _llIlIlllII.Danger

    _lIIllllIlI.Interactable = true

    local _IlllIIllll =
        _lIIIlIlIII.Position

    for i = 1, 3 do

        TweenService:Create(
            _lIIIlIlIII,

            TweenInfo.new(0.05),

            {
                Position =
                    _IlllIIllll +
                    UDim2.new(0, 7, 0, 0)
            }

        ):Play()

        task.wait(0.05)

        TweenService:Create(
            _lIIIlIlIII,

            TweenInfo.new(0.05),

            {
                Position =
                    _IlllIIllll -
                    UDim2.new(0, 7, 0, 0)
            }

        ):Play()

        task.wait(0.05)

    end

    TweenService:Create(
        _lIIIlIlIII,

        TweenInfo.new(0.1),

        {
            Position =
                _IlllIIllll
        }

    ):Play()

    task.delay(1.5, function()

        if not _lIIIIlIIlI.Parent then
            return
        end

        if not _IIIlIlIllI.Checking then

            _lIIllllIlI.Text =
                "เข้าสู่ระบบ"

            _lIIllllIlI.BackgroundColor3 =
                _llIlIlllII.Accent

            _lIIllllIlI.Interactable = true

            _IIIlIIllIl.Text = ""

        end

    end)

end

-- ═══════════════════════════════════════════════
-- BUTTON
-- ═══════════════════════════════════════════════

_lIIllllIlI.MouseButton1Click:Connect(function()

    _lIllIllIll()

end)

-- ═══════════════════════════════════════════════
-- ENTER
-- ═══════════════════════════════════════════════

_lIIIIlIlII.FocusLost:Connect(function(
    enterPressed
)

    _IIIllllIIl.Color = _llIlIlllII.Stroke

    if enterPressed then

        _lIllIllIll()

    end

end)

-- ═══════════════════════════════════════════════
-- INPUT FOCUS
-- ═══════════════════════════════════════════════

_lIIIIlIlII.Focused:Connect(function()

    _IIIllllIIl.Color =
        _llIlIlllII.Accent

end)

-- ═══════════════════════════════════════════════
-- OPEN ANIMATION
-- ═══════════════════════════════════════════════

_lIIIlIlIII.Size =
    UDim2.new(0, 0, 0, 0)

_lIIIlIlIII.Position =
    UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(

    _lIIIlIlIII,

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

    while _lIIIIlIIlI.Parent do

        task.wait(
            _IllllllIll.HEARTBEAT_INTERVAL
        )

        if _IIIlIlIllI.IsValidated
            and _IIIlIlIllI.Token then

            local _IlIlIIlIII =
                HttpService:JSONEncode({

                    token =
                        _IIIlIlIllI.Token,

                    hwid =
                        _IIIlIlIllI.HWID

                })

            local _IIlIllIIlI, response =
                _IIIlIlllIl(
                    _IllllllIll.API_HEARTBEAT,
                    _IlIlIIlIII
                )

            if not _IIlIllIIlI then

                warn(
                    "[KeyVault] Heartbeat Request Error"
                )

            elseif response.StatusCode == 401 then

                warn(
                    "[KeyVault] Key invalidated"
                )

                _IIIlIlIllI.Token = nil
                _IIIlIlIllI.IsValidated = false

            elseif not response.Success then

                warn(
                    "[KeyVault] Heartbeat Failed:",
                    response.StatusCode,
                    response.Body
                )

            else

                local _IIIIIIlllI, data =
                    pcall(function()

                        return HttpService:JSONDecode(
                            response.Body
                        )

                    end)

                if _IIIIIIlllI
                    and data.success then

                    print(
                        "[KeyVault] Heartbeat OK"
                    )

                else

                    warn(
                        "[KeyVault] Invalid Heartbeat Response"
                    )

                end

 