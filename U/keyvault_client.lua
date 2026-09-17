--[[KeyVault Client - Minimal]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CONFIG = {
    API = "https://key-gate-manager-copy-515b28d5.base44.app/functions/validateKey",
    HEARTBEAT = "https://key-gate-manager-copy-515b28d5.base44.app/functions/heartbeat",
}

local HWID_FILE = "xhub_hwid.txt"
local STATE = { Token = nil, HWID = nil, IsValidated = false }

-- HWID
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
print("[KeyVault] HWID:", STATE.HWID)

-- UI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.5
bg.Parent = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Text = "🔐 KeyVault"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BorderSizePixel = 0
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(0, 260, 0, 40)
input.Position = UDim2.new(0, 20, 0, 60)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.PlaceholderText = "Enter Key..."
input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.BorderSizePixel = 0
input.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 260, 0, 30)
status.Position = UDim2.new(0, 20, 0, 110)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 260, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 150)
btn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "LOGIN"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.BorderSizePixel = 0
btn.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.BorderSizePixel = 0
close.Parent = frame

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Validate
local function validateKey(key)
    local body = HttpService:JSONEncode({
        key = key,
        hwid = STATE.HWID,
        username = LocalPlayer.Name
    })
    
    local ok, res = pcall(function()
        return HttpService:RequestAsync({
            Url = CONFIG.API,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)
    
    if not ok then return false, "Network Error" end
    if not res.Success then return false, "Server Error" end
    
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(res.Body)
    end)
    
    if not ok2 then return false, "Parse Error" end
    
    if data.success then
        STATE.Token = data.token
        STATE.IsValidated = true
        return true, data.payload
    else
        return false, data.message or "Invalid Key"
    end
end

-- Button
btn.MouseButton1Click:Connect(function()
    local key = input.Text:gsub("^%s*(.-)%s*$", "%1")
    
    if key == "" then
        status.Text = "Enter a key"
        return
    end
    
    status.Text = "Checking..."
    status.TextColor3 = Color3.fromRGB(255, 200, 80)
    btn.Interactable = false
    
    task.wait(0.5)
    
    local success, result = validateKey(key)
    
    if success then
        status.Text = "Success!"
        status.TextColor3 = Color3.fromRGB(100, 255, 100)
        btn.Text = "LOADED"
        btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        
        task.wait(1)
        
        local fn = loadstring(result)
        if fn then
            gui:Destroy()
            task.wait(0.5)
            pcall(fn)
        end
    else
        status.Text = result
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
        btn.Text = "RETRY"
        btn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        
        task.wait(2)
        btn.Text = "LOGIN"
        btn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        status.Text = ""
        btn.Interactable = true
    end
end)

input.FocusLost:Connect(function(enterPressed)
    if enterPressed then btn:ActivateButton() end
end)

-- Heartbeat
task.spawn(function()
    task.wait(45)
    while STATE.IsValidated do
        local body = HttpService:JSONEncode({ token = STATE.Token, hwid = STATE.HWID })
        pcall(function()
            HttpService:RequestAsync({
                Url = CONFIG.HEARTBEAT,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body
            })
        end)
        task.wait(45)
    end
end)

_G.ResetKeyVaultHWID = function()
    if isfile and isfile(HWID_FILE) then
        if delfile then delfile(HWID_FILE) else writefile(HWID_FILE, "") end
        return true
    end
end

print("[KeyVault] Ready")