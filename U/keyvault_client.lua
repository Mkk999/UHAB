--[[ Protected by Lua Guard ]]

--"\091\010\032\032\032\032\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\010\032\032\032\032\075\101\121\086\097\117\108\116\032\076\111\103\105\110\032\067\108\105\101\110\116\010\032\032\032\032\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\9472\010\032\032\032\032\8226\032\067\108\105\101\110\116\032\073\068\032\3592\3634\3585\032\082\111\098\108\111\120\010\032\032\032\032\8226\032\3652\3617\3656\3651\3594\3657\032\120\104\117\098\095\104\119\105\100\046\116\120\116\010\032\032\032\032\8226\032\076\111\103\105\110\032\085\073\010\032\032\032\032\8226\032\3611\3640\3656\3617\032\076\111\103\105\110\032\047\032\069\110\116\101\114\010\032\032\032\032\8226\032\086\097\108\105\100\097\116\101\032\075\101\121\010\032\032\032\032\8226\032\072\101\097\114\116\098\101\097\116\010\032\032\032\032\8226\032\065\117\116\111\045\108\111\097\100\032\080\097\121\108\111\097\100\010\032\032\032\032\8226\032\3649\3626\3604\3591\032\065\080\073\032\069\114\114\111\114\032\3626\3635\3627\3619\3633\3610\032\068\101\098\117\103\010\032\032\032\032\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\9552\010\093"

local Players = game:GetService("\080\108\097\121\101\114\115")
local TweenService = game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101")
local HttpService = game:GetService("\072\116\116\112\083\101\114\118\105\099\101")
local RbxAnalyticsService = game:GetService("\082\098\120\065\110\097\108\121\116\105\099\115\083\101\114\118\105\099\101")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("\080\108\097\121\101\114\071\117\105")

-- ═══════════════════════════════════════════════
-- CONFIG
-- ═══════════════════════════════════════════════

local CONFIG = {
    API_VALIDATE =
        "\104\116\116\112\115\058\047\047\107\101\121\045\103\097\116\101\045\109\097\110\097\103\101\114\045\099\111\112\121\045\053\049\053\098\050\056\100\053\046\098\097\115\101\052\052\046\097\112\112\047\102\117\110\099\116\105\111\110\115\047\118\097\108\105\100\097\116\101\075\101\121",

    API_HEARTBEAT =
        "\104\116\116\112\115\058\047\047\107\101\121\045\103\097\116\101\045\109\097\110\097\103\101\114\045\099\111\112\121\045\053\049\053\098\050\056\100\053\046\098\097\115\101\052\052\046\097\112\112\047\102\117\110\099\116\105\111\110\115\047\104\101\097\114\116\098\101\097\116",

    HEARTBEAT_INTERVAL = 45
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
-- HWID / CLIENT ID
-- ═══════════════════════════════════════════════

local function getHWID()

    local ok, clientId = pcall(function()
        return RbxAnalyticsService:GetClientId()
    end)

    if not ok then
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

STATE.HWID = getHWID()

if STATE.HWID then
    print("\091\075\101\121\086\097\117\108\116\093\032\072\087\073\068\032\108\111\097\100\101\100\032\115\117\099\099\101\115\115\102\117\108\108\121")
else
    warn("\091\075\101\121\086\097\117\108\116\093\032\072\087\073\068\032\117\110\097\118\097\105\108\097\098\108\101")
end

-- ═══════════════════════════════════════════════
-- REMOVE OLD GUI
-- ═══════════════════════════════════════════════

pcall(function()

    local oldGui =
        PlayerGui:FindFirstChild("\075\101\121\086\097\117\108\116\076\111\103\105\110")

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

local gui = Instance.new("\083\099\114\101\101\110\071\117\105")

gui.Name = "\075\101\121\086\097\117\108\116\076\111\103\105\110"

gui.ResetOnSpawn = false

gui.IgnoreGuiInset = true

gui.DisplayOrder = 99999

gui.Parent = PlayerGui

-- ═══════════════════════════════════════════════
-- MAIN
-- ═══════════════════════════════════════════════

local main = Instance.new("\070\114\097\109\101")

main.Name = "\077\097\105\110"

main.Size =
    UDim2.new(0, 320, 0, 250)

main.Position =
    UDim2.new(0.5, -160, 0.5, -125)

main.BackgroundColor3 = UI.Bg

main.BorderSizePixel = 0

main.Active = true

main.Draggable = true

main.Parent = gui

local mainCorner = Instance.new("\085\073\067\111\114\110\101\114")

mainCorner.CornerRadius =
    UDim.new(0, 14)

mainCorner.Parent = main

local mainStroke = Instance.new("\085\073\083\116\114\111\107\101")

mainStroke.Color = UI.Stroke

mainStroke.Thickness = 1

mainStroke.Parent = main

-- ═══════════════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════════════

local titleBar = Instance.new("\070\114\097\109\101")

titleBar.Size =
    UDim2.new(1, 0, 0, 40)

titleBar.BackgroundColor3 = UI.Card

titleBar.BorderSizePixel = 0

titleBar.Parent = main

local titleCorner = Instance.new("\085\073\067\111\114\110\101\114")

titleCorner.CornerRadius =
    UDim.new(0, 14)

titleCorner.Parent = titleBar

local titleFix = Instance.new("\070\114\097\109\101")

titleFix.Size =
    UDim2.new(1, 0, 0, 14)

titleFix.Position =
    UDim2.new(0, 0, 1, -14)

titleFix.BackgroundColor3 = UI.Card

titleFix.BorderSizePixel = 0

titleFix.Parent = titleBar

local title = Instance.new("\084\101\120\116\076\097\098\101\108")

title.Size =
    UDim2.new(1, -60, 1, 0)

title.Position =
    UDim2.new(0, 15, 0, 0)

title.BackgroundTransparency = 1

title.Text = "\55357\56592\032\075\101\121\086\097\117\108\116"

title.TextColor3 = UI.Text

title.Font = Enum.Font.GothamBold

title.TextSize = 14

title.TextXAlignment =
    Enum.TextXAlignment.Left

title.Parent = titleBar

-- ═══════════════════════════════════════════════
-- CLOSE
-- ═══════════════════════════════════════════════

local close = Instance.new("\084\101\120\116\066\117\116\116\111\110")

close.Size =
    UDim2.new(0, 26, 0, 26)

close.Position =
    UDim2.new(1, -34, 0.5, -13)

close.BackgroundColor3 = UI.Danger

close.BackgroundTransparency = 0.8

close.BorderSizePixel = 0

close.Text = "\215"

close.TextColor3 = UI.Text

close.Font = Enum.Font.GothamBold

close.TextSize = 18

close.AutoButtonColor = false

close.Parent = titleBar

local closeCorner = Instance.new("\085\073\067\111\114\110\101\114")

closeCorner.CornerRadius =
    UDim.new(0, 7)

closeCorner.Parent = close

close.MouseButton1Click:Connect(function()

    gui:Destroy()

end)

-- ═══════════════════════════════════════════════
-- ICON
-- ═══════════════════════════════════════════════

local icon = Instance.new("\084\101\120\116\076\097\098\101\108")

icon.Size =
    UDim2.new(1, 0, 0, 42)

icon.Position =
    UDim2.new(0, 0, 0, 49)

icon.BackgroundTransparency = 1

icon.Text = "\55357\56593"

icon.TextColor3 = UI.Accent

icon.Font = Enum.Font.GothamBold

icon.TextSize = 36

icon.Parent = main

-- ═══════════════════════════════════════════════
-- SUBTITLE
-- ═══════════════════════════════════════════════

local subtitle = Instance.new("\084\101\120\116\076\097\098\101\108")

subtitle.Size =
    UDim2.new(1, -40, 0, 18)

subtitle.Position =
    UDim2.new(0, 20, 0, 90)

subtitle.BackgroundTransparency = 1

subtitle.Text =
    "\3651\3626\3656\3588\3637\3618\3660\3648\3614\3639\3656\3629\3648\3586\3657\3634\3651\3594\3657\3591\3634\3609\032\088\072\085\066"

subtitle.TextColor3 = UI.SubText

subtitle.Font = Enum.Font.Gotham

subtitle.TextSize = 11

subtitle.TextXAlignment =
    Enum.TextXAlignment.Center

subtitle.Parent = main

-- ═══════════════════════════════════════════════
-- HWID DISPLAY
-- ═══════════════════════════════════════════════

local hwidText = "\072\087\073\068\058\032\3652\3617\3656\3614\3610"

if STATE.HWID then

    hwidText =
        "\072\087\073\068\058\032" ..
        string.sub(STATE.HWID, 1, 12) ..
        "\046\046\046"

end

local hwidLabel = Instance.new("\084\101\120\116\076\097\098\101\108")

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

local inputFrame = Instance.new("\070\114\097\109\101")

inputFrame.Size =
    UDim2.new(1, -40, 0, 38)

inputFrame.Position =
    UDim2.new(0, 20, 0, 128)

inputFrame.BackgroundColor3 = UI.Input

inputFrame.BorderSizePixel = 0

inputFrame.Parent = main

local inputCorner = Instance.new("\085\073\067\111\114\110\101\114")

inputCorner.CornerRadius =
    UDim.new(0, 8)

inputCorner.Parent = inputFrame

local inputStroke = Instance.new("\085\073\083\116\114\111\107\101")

inputStroke.Color = UI.Stroke

inputStroke.Thickness = 1

inputStroke.Parent = inputFrame

-- ═══════════════════════════════════════════════
-- INPUT
-- ═══════════════════════════════════════════════

local input = Instance.new("\084\101\120\116\066\111\120")

input.Size =
    UDim2.new(1, -20, 1, 0)

input.Position =
    UDim2.new(0, 10, 0, 0)

input.BackgroundTransparency = 1

input.BorderSizePixel = 0

input.ClearTextOnFocus = false

input.Text = ""

input.PlaceholderText =
    "\3651\3626\3656\3588\3637\3618\3660\3607\3637\3656\3609\3637\3656\046\046\046"

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

local status = Instance.new("\084\101\120\116\076\097\098\101\108")

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

local login = Instance.new("\084\101\120\116\066\117\116\116\111\110")

login.Size =
    UDim2.new(1, -40, 0, 36)

login.Position =
    UDim2.new(0, 20, 0, 199)

login.BackgroundColor3 = UI.Accent

login.BorderSizePixel = 0

login.Text = "\3648\3586\3657\3634\3626\3641\3656\3619\3632\3610\3610"

login.TextColor3 = UI.Text

login.Font = Enum.Font.GothamBold

login.TextSize = 13

login.AutoButtonColor = false

login.Parent = main

local loginCorner = Instance.new("\085\073\067\111\114\110\101\114")

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

            Method = "\080\079\083\084",

            Url = url,

            Headers = {
                ["\067\111\110\116\101\110\116\045\084\121\112\101"] =
                    "\097\112\112\108\105\099\097\116\105\111\110\047\106\115\111\110"
            },

            Body = body

        })

    end)

    if not ok then

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

local function validateKey(key)

    if not STATE.HWID then

        return false,
            "\10060\032\3652\3617\3656\3614\3610\032\072\087\073\068"

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

    local jsonOK, data =
        pcall(function()

            return HttpService:JSONDecode(
                response.Body
            )

        end)

    if not jsonOK then

        return false,
            "\10060\032\083\101\114\118\101\114\032\3626\3656\3591\3586\3657\3629\3617\3641\3621\3652\3617\3656\3606\3641\3585\3605\3657\3629\3591"

    end

    if data.success then

        STATE.Token = data.token

        STATE.IsValidated = true

        if data.hwid
            and data.hwid ~= "" then

            STATE.HWID = data.hwid

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

local function loadPayload(code)

    if type(code) ~= "\115\116\114\105\110\103"
        or code == "" then

        setStatus(
            "\10060\032\3652\3617\3656\3614\3610\032\080\097\121\108\111\097\100",
            UI.Danger
        )

        login.Interactable = true

        return

    end

    setStatus(
        "\9203\032\3585\3635\3621\3633\3591\3650\3627\3621\3604\032\088\072\085\066\046\046\046",
        UI.Warning
    )

    task.wait(0.4)

    local compileOK, fn =
        pcall(function()

            return loadstring(code)

        end)

    if not compileOK or not fn then

        warn(
            "\091\075\101\121\086\097\117\108\116\093\032\080\097\121\108\111\097\100\032\067\111\109\112\105\108\101\032\069\114\114\111\114\058",
            fn
        )

        setStatus(
            "\10060\032\3650\3627\3621\3604\032\080\097\121\108\111\097\100\032\3652\3617\3656\3626\3635\3648\3619\3655\3592",
            UI.Danger
        )

        login.Interactable = true

        return

    end

    setStatus(
        "\10003\032\076\111\103\105\110\032\3626\3635\3648\3619\3655\3592\033",
        UI.Success
    )

    login.Text = "\10003\032\3626\3635\3648\3619\3655\3592"

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
            "\091\075\101\121\086\097\117\108\116\093\032\080\097\121\108\111\097\100\032\082\117\110\116\105\109\101\032\069\114\114\111\114\058",
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
            "\094\037\115\042\040\046\045\041\037\115\042\036",
            "\037\049"
        )

    if key == "" then

        setStatus(
            "\9888\032\3585\3619\3640\3603\3634\3651\3626\3656\3588\3637\3618\3660\3585\3656\3629\3609",
            UI.Warning
        )

        input:CaptureFocus()

        return

    end

    STATE.Checking = true

    login.Interactable = false

    login.Text =
        "\3585\3635\3621\3633\3591\3605\3619\3623\3592\3626\3629\3610\046\046\046"

    login.BackgroundColor3 =
        Color3.fromRGB(70, 105, 175)

    setStatus(
        "\9203\032\3585\3635\3621\3633\3591\3605\3619\3623\3592\3626\3629\3610\3588\3637\3618\3660\046\046\046",
        UI.Accent
    )

    local success, result =
        validateKey(key)

    if success then

        print(
            "\091\075\101\121\086\097\117\108\116\093\032\086\097\108\105\100\097\116\101\032\083\117\099\099\101\115\115"
        )

        loadPayload(result)

        STATE.Checking = false

        return

    end

    STATE.Checking = false

    STATE.IsValidated = false

    warn(
        "\091\075\101\121\086\097\117\108\116\093\032\086\097\108\105\100\097\116\101\032\070\097\105\108\101\100\058",
        result
    )

    setStatus(
        result,
        UI.Danger
    )

    login.Text =
        "\3621\3629\3591\3629\3637\3585\3588\3619\3633\3657\3591"

    login.BackgroundColor3 =
        UI.Danger

    login.Interactable = true

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
  