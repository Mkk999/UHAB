--[[ Protected by Lua Guard ]]

(function(...) 
--"\091\010\032\032\032\032\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\010\032\032\032\032\075\101\121\086\097\117\108\116\032\076\111\103\105\110\032\067\108\105\101\110\116\010\032\032\032\032\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\010\032\032\032\032\8226\032\067\108\105\101\110\116\032\073\068\032\3592\3634\3585\032\082\111\098\108\111\120\010\032\032\032\032\8226\032\3652\3617\3656\3651\3594\3657\032\120\104\117\098\095\104\119\105\100\046\116\120\116\010\032\032\032\032\8226\032\076\111\103\105\110\032\085\073\010\032\032\032\032\8226\032\3611\3640\3656\3617\032\076\111\103\105\110\032\047\032\069\110\116\101\114\010\032\032\032\032\8226\032\086\097\108\105\100\097\116\101\032\075\101\121\010\032\032\032\032\8226\032\072\101\097\114\116\098\101\097\116\010\032\032\032\032\8226\032\065\117\116\111\045\108\111\097\100\032\080\097\121\108\111\097\100\010\032\032\032\032\8226\032\3649\3626\3604\3591\032\065\080\073\032\069\114\114\111\114\032\3626\3635\3627\3619\3633\3610\032\068\101\098\117\103\010\032\032\032\032\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\010\093"

local Players = game:GetService("\080\108\097\121\101\114\115")
local TweenService = game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101")
local HttpService = game:GetService("\072\116\116\112\083\101\114\118\105\099\101")
local _IlIlIIIIlI = game:GetService("\082\098\120\065\110\097\108\121\116\105\099\115\083\101\114\118\105\099\101")

local _IllllIIIll = Players.LocalPlayer
local _IlIlIlllIl = _IllllIIIll:WaitForChild("\080\108\097\121\101\114\071\117\105")

-- ═══════════════════════════════════════════════
-- _lIllllIIll
-- ═══════════════════════════════════════════════

local _lIllllIIll = {
    API_VALIDATE =
        "\104\116\116\112\115\058\047\047\107\101\121\045\103\097\116\101\045\109\097\110\097\103\101\114\045\099\111\112\121\045\053\049\053\098\050\056\100\053\046\098\097\115\101\052\052\046\097\112\112\047\102\117\110\099\116\105\111\110\115\047\118\097\108\105\100\097\116\101\075\101\121",

    API_HEARTBEAT =
        "\104\116\116\112\115\058\047\047\107\101\121\045\103\097\116\101\045\109\097\110\097\103\101\114\045\099\111\112\121\045\053\049\053\098\050\056\100\053\046\098\097\115\101\052\052\046\097\112\112\047\102\117\110\099\116\105\111\110\115\047\104\101\097\114\116\098\101\097\116",

    HEARTBEAT_INTERVAL = 0x2D
}

-- ═══════════════════════════════════════════════
-- _IIlIlIlIIl
-- ═══════════════════════════════════════════════

local _IIlIlIlIIl = {
    Token = nil,
    HWID = nil,
    IsValidated = false,
    Checking = false,
}

-- ═══════════════════════════════════════════════
-- HWID / CLIENT ID
-- ═══════════════════════════════════════════════

local function _lIIIllIlll()

    local _lIIllIlllI, clientId = pcall(function()
        return _IlIlIIIIlI:GetClientId()
    end)

    if not _lIIllIlllI then
        warn(
            "\091\075\101\121\086\097\117\108\116\093\032\067\097\110\110\111\116\032\103\101\116\032\082\111\098\108\111\120\032\067\108\105\101\110\116\073\100\058",
            clientId
        )

        return nil
    end

    if not clientId
        or clientId == "" then

        warn(
            "\091\075\101\121\086\097\117\108\116\093\032\082\111\098\108\111\120\032\067\108\105\101\110\116\073\100\032\105\115\032\101\109\112\116\121"
        )

        return nil
    end

    print(
        "\091\075\101\121\086\097\117\108\116\093\032\067\108\105\101\110\116\032\073\068\032\111\098\116\097\105\110\101\100"
    )

    return clientId
end

_IIlIlIlIIl.HWID = _lIIIllIlll()

if _IIlIlIlIIl.HWID then
    print("\091\075\101\121\086\097\117\108\116\093\032\072\087\073\068\032\108\111\097\100\101\100\032\115\117\099\099\101\115\115\102\117\108\108\121")
else
    warn("\091\075\101\121\086\097\117\108\116\093\032\072\087\073\068\032\117\110\097\118\097\105\108\097\098\108\101")
end

-- ═══════════════════════════════════════════════
-- REMOVE OLD GUI
-- ═══════════════════════════════════════════════

pcall(function()

    local _lIIllIllIl =
        _IlIlIlllIl:FindFirstChild("\075\101\121\086\097\117\108\116\076\111\103\105\110")

    if _lIIllIllIl then
        _lIIllIllIl:Destroy()
    end

end)

-- ═══════════════════════════════════════════════
-- COLORS
-- ═══════════════════════════════════════════════

local _IIIlllIlII = {

    Bg = Color3.fromRGB(0x12, 0x13, 0x18),

    Card = Color3.fromRGB(0x1A, 0x1C, 0x23),

    Input = Color3.fromRGB(0x23, 0x25, 0x2F),

    Stroke = Color3.fromRGB(0x37, 0x3A, 0x48),

    Text = Color3.fromRGB(0xFF, 0xFF, 0xFF),

    SubText = Color3.fromRGB(0x96, 0x9B, 0xAA),

    Accent = Color3.fromRGB(0x64, 0x96, 0xFF),

    Success = Color3.fromRGB(0x3C, 0xDC, 0x64),

    Danger = Color3.fromRGB(0xFF, 0x50, 0x50),

    Warning = Color3.fromRGB(0xFF, 0xC8, 0x50),
}

-- ═══════════════════════════════════════════════
-- SCREEN GUI
-- ═══════════════════════════════════════════════

local _lllIIlIIIl = Instance.new("\083\099\114\101\101\110\071\117\105")

_lllIIlIIIl.Name = "\075\101\121\086\097\117\108\116\076\111\103\105\110"

_lllIIlIIIl.ResetOnSpawn = false

_lllIIlIIIl.IgnoreGuiInset = true

_lllIIlIIIl.DisplayOrder = 0x1869F

_lllIIlIIIl.Parent = _IlIlIlllIl

-- ═══════════════════════════════════════════════
-- MAIN
-- ═══════════════════════════════════════════════

local _lIllIlllII = Instance.new("\070\114\097\109\101")

_lIllIlllII.Name = "\077\097\105\110"

_lIllIlllII.Size =
    UDim2.new(0x0, 0x140, 0x0, 0xFA)

_lIllIlllII.Position =
    UDim2.new(0.5, -0xA0, 0.5, -0x7D)

_lIllIlllII.BackgroundColor3 = _IIIlllIlII.Bg

_lIllIlllII.BorderSizePixel = 0x0

_lIllIlllII.Active = true

_lIllIlllII.Draggable = true

_lIllIlllII.Parent = _lllIIlIIIl

local _lllIIlIIll = Instance.new("\085\073\067\111\114\110\101\114")

_lllIIlIIll.CornerRadius =
    UDim.new(0x0, 0xE)

_lllIIlIIll.Parent = _lIllIlllII

local _lIlIlIlIIl = Instance.new("\085\073\083\116\114\111\107\101")

_lIlIlIlIIl.Color = _IIIlllIlII.Stroke

_lIlIlIlIIl.Thickness = 0x1

_lIlIlIlIIl.Parent = _lIllIlllII

-- ═══════════════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════════════

local _lllIIlIlll = Instance.new("\070\114\097\109\101")

_lllIIlIlll.Size =
    UDim2.new(0x1, 0x0, 0x0, 0x28)

_lllIIlIlll.BackgroundColor3 = _IIIlllIlII.Card

_lllIIlIlll.BorderSizePixel = 0x0

_lllIIlIlll.Parent = _lIllIlllII

local _lIIlllIlIl = Instance.new("\085\073\067\111\114\110\101\114")

_lIIlllIlIl.CornerRadius =
    UDim.new(0x0, 0xE)

_lIIlllIlIl.Parent = _lllIIlIlll

local _IIlIIlIIll = Instance.new("\070\114\097\109\101")

_IIlIIlIIll.Size =
    UDim2.new(0x1, 0x0, 0x0, 0xE)

_IIlIIlIIll.Position =
    UDim2.new(0x0, 0x0, 0x1, -0xE)

_IIlIIlIIll.BackgroundColor3 = _IIIlllIlII.Card

_IIlIIlIIll.BorderSizePixel = 0x0

_IIlIIlIIll.Parent = _lllIIlIlll

local _lIIIllIlll = Instance.new("\084\101\120\116\076\097\098\101\108")

_lIIIllIlll.Size =
    UDim2.new(0x1, -0x3C, 0x1, 0x0)

_lIIIllIlll.Position =
    UDim2.new(0x0, 0xF, 0x0, 0x0)

_lIIIllIlll.BackgroundTransparency = 0x1

_lIIIllIlll.Text = "\55357\56592\032\075\101\121\086\097\117\108\116"

_lIIIllIlll.TextColor3 = _IIIlllIlII.Text

_lIIIllIlll.Font = Enum.Font.GothamBold

_lIIIllIlll.TextSize = 0xE

_lIIIllIlll.TextXAlignment =
    Enum.TextXAlignment.Left

_lIIIllIlll.Parent = _lllIIlIlll

-- ═══════════════════════════════════════════════
-- CLOSE
-- ═══════════════════════════════════════════════

local _IllllIIllI = Instance.new("\084\101\120\116\066\117\116\116\111\110")

_IllllIIllI.Size =
    UDim2.new(0x0, 0x1A, 0x0, 0x1A)

_IllllIIllI.Position =
    UDim2.new(0x1, -0x22, 0.5, -0xD)

_IllllIIllI.BackgroundColor3 = _IIIlllIlII.Danger

_IllllIIllI.BackgroundTransparency = 0.8

_IllllIIllI.BorderSizePixel = 0x0

_IllllIIllI.Text = "\215"

_IllllIIllI.TextColor3 = _IIIlllIlII.Text

_IllllIIllI.Font = Enum.Font.GothamBold

_IllllIIllI.TextSize = 0x12

_IllllIIllI.AutoButtonColor = false

_IllllIIllI.Parent = _lllIIlIlll

local _IIIIIIIllI = Instance.new("\085\073\067\111\114\110\101\114")

_IIIIIIIllI.CornerRadius =
    UDim.new(0x0, 0x7)

_IIIIIIIllI.Parent = _IllllIIllI

_IllllIIllI.MouseButton1Click:Connect(function()

    _lllIIlIIIl:Destroy()

end)

-- ═══════════════════════════════════════════════
-- ICON
-- ═══════════════════════════════════════════════

local _IIIlllIllI = Instance.new("\084\101\120\116\076\097\098\101\108")

_IIIlllIllI.Size =
    UDim2.new(0x1, 0x0, 0x0, 0x2A)

_IIIlllIllI.Position =
    UDim2.new(0x0, 0x0, 0x0, 0x31)

_IIIlllIllI.BackgroundTransparency = 0x1

_IIIlllIllI.Text = "\55357\56593"

_IIIlllIllI.TextColor3 = _IIIlllIlII.Accent

_IIIlllIllI.Font = Enum.Font.GothamBold

_IIIlllIllI.TextSize = 0x24

_IIIlllIllI.Parent = _lIllIlllII

-- ═══════════════════════════════════════════════
-- SUBTITLE
-- ═══════════════════════════════════════════════

local _IlIIIlllII = Instance.new("\084\101\120\116\076\097\098\101\108")

_IlIIIlllII.Size =
    UDim2.new(0x1, -0x28, 0x0, 0x12)

_IlIIIlllII.Position =
    UDim2.new(0x0, 0x14, 0x0, 0x5A)

_IlIIIlllII.BackgroundTransparency = 0x1

_IlIIIlllII.Text =
    "\3651\3626\3656\3588\3637\3618\3660\3648\3614\3639\3656\3629\3648\3586\3657\3634\3651\3594\3657\3591\3634\3609\032\088\072\085\066"

_IlIIIlllII.TextColor3 = _IIIlllIlII.SubText

_IlIIIlllII.Font = Enum.Font.Gotham

_IlIIIlllII.TextSize = 0xB

_IlIIIlllII.TextXAlignment =
    Enum.TextXAlignment.Center

_IlIIIlllII.Parent = _lIllIlllII

-- ═══════════════════════════════════════════════
-- HWID DISPLAY
-- ═══════════════════════════════════════════════

local _IIllIlllIl = "\072\087\073\068\058\032\3652\3617\3656\3614\3610"

if _IIlIlIlIIl.HWID then

    _IIllIlllIl =
        "\072\087\073\068\058\032" ..
        string.sub(_IIlIlIlIIl.HWID, 0x1, 0xC) ..
        "\046\046\046"

end

local _llIIlIIllI = Instance.new("\084\101\120\116\076\097\098\101\108")

_llIIlIIllI.Size =
    UDim2.new(0x1, -0x28, 0x0, 0xE)

_llIIlIIllI.Position =
    UDim2.new(0x0, 0x14, 0x0, 0x6C)

_llIIlIIllI.BackgroundTransparency = 0x1

_llIIlIIllI.Text = _IIllIlllIl

_llIIlIIllI.TextColor3 =
    Color3.fromRGB(0x5F, 0x64, 0x73)

_llIIlIIllI.Font = Enum.Font.Code

_llIIlIIllI.TextSize = 0x9

_llIIlIIllI.TextXAlignment =
    Enum.TextXAlignment.Center

_llIIlIIllI.Parent = _lIllIlllII

-- ═══════════════════════════════════════════════
-- INPUT FRAME
-- ═══════════════════════════════════════════════

local _lIlllIIIll = Instance.new("\070\114\097\109\101")

_lIlllIIIll.Size =
    UDim2.new(0x1, -0x28, 0x0, 0x26)

_lIlllIIIll.Position =
    UDim2.new(0x0, 0x14, 0x0, 0x80)

_lIlllIIIll.BackgroundColor3 = _IIIlllIlII.Input

_lIlllIIIll.BorderSizePixel = 0x0

_lIlllIIIll.Parent = _lIllIlllII

local _IIlIlIIlll = Instance.new("\085\073\067\111\114\110\101\114")

_IIlIlIIlll.CornerRadius =
    UDim.new(0x0, 0x8)

_IIlIlIIlll.Parent = _lIlllIIIll

local _llIlIIIIlI = Instance.new("\085\073\083\116\114\111\107\101")

_llIlIIIIlI.Color = _IIIlllIlII.Stroke

_llIlIIIIlI.Thickness = 0x1

_llIlIIIIlI.Parent = _lIlllIIIll

-- ═══════════════════════════════════════════════
-- INPUT
-- ═══════════════════════════════════════════════

local _IlllIlIIIl = Instance.new("\084\101\120\116\066\111\120")

_IlllIlIIIl.Size =
    UDim2.new(0x1, -0x14, 0x1, 0x0)

_IlllIlIIIl.Position =
    UDim2.new(0x0, 0xA, 0x0, 0x0)

_IlllIlIIIl.BackgroundTransparency = 0x1

_IlllIlIIIl.BorderSizePixel = 0x0

_IlllIlIIIl.ClearTextOnFocus = false

_IlllIlIIIl.Text = ""

_IlllIlIIIl.PlaceholderText =
    "\3651\3626\3656\3588\3637\3618\3660\3607\3637\3656\3609\3637\3656\046\046\046"

_IlllIlIIIl.PlaceholderColor3 =
    Color3.fromRGB(0x64, 0x69, 0x78)

_IlllIlIIIl.TextColor3 = _IIIlllIlII.Text

_IlllIlIIIl.Font = Enum.Font.Gotham

_IlllIlIIIl.TextSize = 0xD

_IlllIlIIIl.TextXAlignment =
    Enum.TextXAlignment.Left

_IlllIlIIIl.Parent = _lIlllIIIll

-- ═══════════════════════════════════════════════
-- STATUS
-- ═══════════════════════════════════════════════

local _IlllIlIIIl = Instance.new("\084\101\120\116\076\097\098\101\108")

_IlllIlIIIl.Size =
    UDim2.new(0x1, -0x28, 0x0, 0x12)

_IlllIlIIIl.Position =
    UDim2.new(0x0, 0x14, 0x0, 0xAB)

_IlllIlIIIl.BackgroundTransparency = 0x1

_IlllIlIIIl.Text = ""

_IlllIlIIIl.TextColor3 = _IIIlllIlII.SubText

_IlllIlIIIl.Font = Enum.Font.Gotham

_IlllIlIIIl.TextSize = 0xA

_IlllIlIIIl.TextXAlignment =
    Enum.TextXAlignment.Center

_IlllIlIIIl.Parent = _lIllIlllII

-- ═══════════════════════════════════════════════
-- LOGIN BUTTON
-- ═══════════════════════════════════════════════

local _IllIlIIlll = Instance.new("\084\101\120\116\066\117\116\116\111\110")

_IllIlIIlll.Size =
    UDim2.new(0x1, -0x28, 0x0, 0x24)

_IllIlIIlll.Position =
    UDim2.new(0x0, 0x14, 0x0, 0xC7)

_IllIlIIlll.BackgroundColor3 = _IIIlllIlII.Accent

_IllIlIIlll.BorderSizePixel = 0x0

_IllIlIIlll.Text = "\3648\3586\3657\3634\3626\3641\3656\3619\3632\3610\3610"

_IllIlIIlll.TextColor3 = _IIIlllIlII.Text

_IllIlIIlll.Font = Enum.Font.GothamBold

_IllIlIIlll.TextSize = 0xD

_IllIlIIlll.AutoButtonColor = false

_IllIlIIlll.Parent = _lIllIlllII

local _lllIIlllll = Instance.new("\085\073\067\111\114\110\101\114")

_lllIIlllll.CornerRadius =
    UDim.new(0x0, 0x8)

_lllIIlllll.Parent = _IllIlIIlll

-- ═══════════════════════════════════════════════
-- STATUS FUNCTION
-- ═══════════════════════════════════════════════

local function _IIIlIllllI(text, color)

    _IlllIlIIIl.Text = text

    _IlllIlIIIl.TextColor3 = color

end

-- ═══════════════════════════════════════════════
-- REQUEST HELPER
-- ═══════════════════════════════════════════════

local function _lIlIlIIlIl(url, _lIIIIlIlll)

    local _lIIllIlllI, response = pcall(function()

        return request({

            Method = "\080\079\083\084",

            Url = url,

            Headers = {
                ["\067\111\110\116\101\110\116\045\084\121\112\101"] =
                    "\097\112\112\108\105\099\097\116\105\111\110\047\106\115\111\110"
            },

            Body = _lIIIIlIlll

        })

    end)

    if not _lIIllIlllI then

        warn(
            "\091\075\101\121\086\097\117\108\116\093\032\082\101\113\117\101\115\116\032\069\114\114\111\114\058",
            response
        )

        return false, nil

    end

    print(
        "\091\075\101\121\086\097\117\108\116\093\032\072\084\084\080\032\083\116\097\116\117\115\058",
        response.StatusCode
    )

    print(
        "\091\075\101\121\086\097\117\108\116\093\032\072\084\084\080\032\066\111\100\121\058",
        response.Body
    )

    return true, response

end

-- ═══════════════════════════════════════════════
-- VALIDATE KEY
-- ═══════════════════════════════════════════════

local function _llIllIIIlI(_IlIIlIIlll)

    if not _IIlIlIlIIl.HWID then

        return false,
            "\10060\032\3652\3617\3656\3614\3610\032\072\087\073\068"

    end

    local _lIIIIlIlll =
        HttpService:JSONEncode({

            _IlIIlIIlll = _IlIIlIIlll,

            hwid = _IIlIlIlIIl.HWID,

            username =
                _IllllIIIll.Name

        })

    local _IIlllIllll, response =
        _lIlIlIIlIl(
            _lIllllIIll.API_VALIDATE,
            _lIIIIlIlll
        )

    if not _IIlllIllll then

        return false,
            "\10060\032\3648\3594\3639\3656\3629\3617\3605\3656\3629\3648\3595\3636\3619\3660\3615\3648\3623\3629\3619\3660\3652\3617\3656\3652\3604\3657"

    end

    if not response.Success then

        warn(
            "\091\075\101\121\086\097\117\108\116\093\032\086\097\108\105\100\097\116\101\032\072\084\084\080\032\069\114\114\111\114\058",
            response.StatusCode,
            response.Body
        )

        return false,
            "\10060\032\083\101\114\118\101\114\032\069\114\114\111\114\032" ..
            tostring(response.StatusCode)

    end

    local _lIlIllIllI, data =
        pcall(function()

            return HttpService:JSONDecode(
                response.Body
            )

        end)

    if not _lIlIllIllI then

        return false,
            "\10060\032\083\101\114\118\101\114\032\3626\3656\3591\3586\3657\3629\3617\3641\3621\3652\3617\3656\3606\3641\3585\3605\3657\3629\3591"

    end

    if data.success then

        _IIlIlIlIIl.Token = data.token

        _IIlIlIlIIl.IsValidated = true

        if data.hwid
            and data.hwid ~= "" then

            _IIlIlIlIIl.HWID = data.hwid

        end

        return true, data.payload

    end

    return false,
        data.message or
        "\10060\032\3588\3637\3618\3660\3652\3617\3656\3606\3641\3585\3605\3657\3629\3591"

end

-- ═══════════════════════════════════════════════
-- LOAD PAYLOAD
-- ═══════════════════════════════════════════════

local function _lllllIIlll(code)

    if type(code) ~= "\115\116\114\105\110\103"
        or code == "" then

        _IIIlIllllI(
            "\10060\032\3652\3617\3656\3614\3610\032\080\097\121\108\111\097\100",
            _IIIlllIlII.Danger
        )

        _IllIlIIlll.Interactable = true

        return

    end

    _IIIlIllllI(
        "\9203\032\3585\3635\3621\3633\3591\3650\3627\3621\3604\032\088\072\085\066\046\046\046",
        _IIIlllIlII.Warning
    )

    task.wait(0.4)

    local _IllIIIIIIl, fn =
        pcall(function()

            return loadstring(code)

        end)

    if not _IllIIIIIIl or not fn then

        warn(
            "\091\075\101\121\086\097\117\108\116\093\032\080\097\121\108\111\097\100\032\067\111\109\112\105\108\101\032\069\114\114\111\114\058",
            fn
        )

        _IIIlIllllI(
            "\10060\032\3650\3627\3621\3604\032\080\097\121\108\111\097\100\032\3652\3617\3656\3626\3635\3648\3619\3655\3592",
            _IIIlllIlII.Danger
        )

        _IllIlIIlll.Interactable = true

        return

    end

    _IIIlIllllI(
        "\10003\032\076\111\103\105\110\032\3626\3635\3648\3619\3655\3592\033",
        _IIIlllIlII.Success
    )

    _IllIlIIlll.Text = "\10003\032\3626\3635\3648\3619\3655\3592"

    _IllIlIIlll.BackgroundColor3 =
        _IIIlllIlII.Success

    task.wait(0.8)

    if _lllIIlIIIl and _lllIIlIIIl.Parent then
        _lllIIlIIIl:Destroy()
    end

    task.wait(0.3)

    local _IIlIlIIIll, runError =
        pcall(fn)

    if not _IIlIlIIIll then

        warn(
            "\091\075\101\121\086\097\117\108\116\093\032\080\097\121\108\111\097\100\032\082\117\110\116\105\109\101\032\069\114\114\111\114\058",
            runError
        )

    end

end

-- ═══════════════════════════════════════════════
-- LOGIN
-- ═══════════════════════════════════════════════

local function _IlllllIIII()

    if _IIlIlIlIIl.Checking then
        return
    end

    local _IlIIlIIlll =
        _IlllIlIIIl.Text:gsub(
            "\094\037\115\042\040\046\045\041\037\115\042\036",
            "\037\049"
        )

    if _IlIIlIIlll == "" then

        _IIIlIllllI(
            "\9888\032\3585\3619\3640\3603\3634\3651\3626\3656\3588\3637\3618\3660\3585\3656\3629\3609",
            _IIIlllIlII.Warning
        )

        _IlllIlIIIl:CaptureFocus()

        return

    end

    _IIlIlIlIIl.Checking = true

    _IllIlIIlll.Interactable = false

    _IllIlIIlll.Text =
        "\3585\3635\3621\3633\3591\3605\3619\3623\3592\3626\3629\3610\046\046\046"

    _IllIlIIlll.BackgroundColor3 =
        Color3.fromRGB(0x46, 0x69, 0xAF)

    _IIIlIl