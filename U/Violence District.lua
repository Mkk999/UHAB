_G.save = {
	FlyEnabled = false,
	VFlyEnabled = false,
	QEFlyEnabled = true,
	FlySpeed = 1,
	VFlySpeed = 1,
	Noclip = false,
	infjump = false,
	BoostFPS = false,
	BlackScreen = false,
	WhiteScreen = false,
	FPSLOCK = false,
	FPS = 60,
	AutoHide = false,
	Theme = "Dark",
	Accent = "Blue",
}
function LPH_NO_VIRTUALIZE(f)
	return f
end
local function loadSettings()
	if ((readfile and writefile) and isfile) and isfolder then
		if not (isfolder("VectorHub")) then
			makefolder("VectorHub")
		end
		if not (isfolder("VectorHub/VD/")) then
			makefolder("VectorHub/VD/")
		end
		if not (isfile(("VectorHub/VD/" .. (game.Players.LocalPlayer.Name .. ".json")))) then
			writefile(
				("VectorHub/VD/" .. (game.Players.LocalPlayer.Name .. ".json")),
				game:GetService("HttpService"):JSONEncode(_G.save)
			)
		else
			local success, result = pcall(function()
				return game:GetService("HttpService")
					:JSONDecode(readfile(("VectorHub/VD/" .. (game.Players.LocalPlayer.Name .. ".json"))))
			end)
			if success and result then
				for index001, item001 in pairs(result) do
					_G.save[index001] = item001
				end
			end
		end
	end
end
local function saveSettings()
	if ((readfile and writefile) and isfile) and isfolder then
		local data = {}
		for index002, item002 in pairs(_G.save) do
			data[index002] = item002
		end
		writefile(
			("VectorHub/VD/" .. (game.Players.LocalPlayer.Name .. ".json")),
			game:GetService("HttpService"):JSONEncode(data)
		)
	end
end
loadSettings()
pcall(function()
	local vectorImageButton = gethui():FindFirstChild("VectorImageButton")
	if vectorImageButton then
		vectorImageButton:Destroy()
	end
end)
pcall(function()
	local cascade = game:GetService("CoreGui").RobloxGui:FindFirstChild("Cascade")
	if cascade then
		cascade:Destroy()
	end
end)
pcall(function()
	gethui():FindFirstChild("VectorImageButton"):Destroy()
	for index003, item003 in pairs(gethui():GetChildren()) do
		if item003.Name == "Cascade" then
			item003:Destroy()
		end
	end
end)
for index004, item004 in pairs(game:GetService("CoreGui"):GetDescendants()) do
	if (item004.Name == "Cascade") or (item004.Name == "VectorImageButton") then
		item004:Destroy()
	end
end
local uiLibrary = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/ajkd2e2141sdf121415643dfvbcw347584fgh3o/hmm/refs/heads/main/cas")
)()
local HubAdapter = {}
HubAdapter.__index = HubAdapter
function HubAdapter.new(options)
	local self = setmetatable({}, HubAdapter)
	self._app = uiLibrary.New({
		Theme = (options.Theme or uiLibrary.Themes.Dark),
		Accent = (options.Accent or uiLibrary.Accents.Blue),
	})
	self._win = self._app:Window({
		Title = (options.Title or "Hub"),
		Subtitle = (options.Subtitle or ""),
		UIBlur = not isMobile,
		Dropshadow = not isMobile,
		Size = (options.Size or UDim2.fromOffset(850, 530)),
	})
	self._tabs = {}
	return self
end
function HubAdapter:CreateTab(sectionTitle, tabTitle, iconName, groupName, isSelected)
	if not self._sections then
		self._sections = {}
	end
	local localValue001
	if groupName and (type(groupName) == "string") then
		if not self._sections[groupName] then
			self._sections[groupName] = self._win:Section({ Disclosure = true, Title = groupName })
		end
		localValue001 = self._sections[groupName]
	else
		if type(groupName) == "boolean" then
			isSelected = groupName
		end
		localValue001 = self._win:Section({ Title = sectionTitle })
	end
	local localValue002 = localValue001:Tab({
		Title = tabTitle,
		Icon = ((iconName and uiLibrary.Symbols[iconName]) or nil),
		Selected = (isSelected or false),
	})
	local data = { _tab = localValue002, _app = self._app }
	setmetatable(data, { __index = TabAPI })
	return data
end
function HubAdapter:Notify(options)
	self._app:Notification({
		Title = (options.Title or ""),
		Subtitle = (options.Subtitle or ""),
		Duration = (options.Duration or 3),
		Icon = ((options.Icon and uiLibrary.Symbols[options.Icon]) or nil),
	})
end
TabAPI = {}
TabAPI.__index = TabAPI
function TabAPI:CreateSection(options)
	local localValue003 = (((type(options) == "table") and options.Name) or options)
	local pageSection = self._tab:PageSection({ Title = localValue003 })
	local form = pageSection:Form()
	local data = { _form = form, _app = self._app, _pageSection = pageSection }
	function data:Remove()
		if self._pageSection then
			self._pageSection:Destroy()
		end
	end
	setmetatable(data, { __index = SectionAPI })
	return data
end
SectionAPI = {}
SectionAPI.__index = SectionAPI
local function createFormRow(argument001, argument002, argument003)
	local row = argument001:Row({ SearchIndex = argument002 })
	row:Left():TitleStack({ Title = argument002, Subtitle = argument003 })
	return row
end
function SectionAPI:Toggle(configOrName, descriptionOrDefault, defaultValueOrCallback, callback)
	task.wait()
	local localValue004
	if type(configOrName) == "table" then
		local localValue005 = configOrName
		local localValue006 = string.split((localValue005.Name or ""), "\n")
		localValue004 = localValue006[1]
		descriptionOrDefault = localValue006[2]
		defaultValueOrCallback = localValue005.Default
		callback = localValue005.Callback
	else
		localValue004 = configOrName
		if (type(descriptionOrDefault) == "boolean") or (type(descriptionOrDefault) == "nil") then
			callback = defaultValueOrCallback
			defaultValueOrCallback = descriptionOrDefault
			descriptionOrDefault = nil
		end
		local localValue007 = string.split(tostring(localValue004), "\n")
		localValue004 = localValue007[1]
		descriptionOrDefault = (descriptionOrDefault or localValue007[2])
	end
	if not self._form then
		return warn("SectionAPI: Form not found")
	end
	local localValue008 = createFormRow(self._form, localValue004, descriptionOrDefault)
	local localValue009
	local rightColumn = localValue008:Right()
	if rightColumn then
		localValue009 = rightColumn:Toggle({
			Value = (defaultValueOrCallback == true),
			ValueChanged = function(_, argument004)
				if type(callback) == "function" then
					task.spawn(callback, argument004)
				end
			end,
		})
	end
	return {
		SetValue = function(argument005)
			if localValue009 then
				localValue009.Value = argument005
			end
		end,
	}
end
function SectionAPI:Slider(configOrName, description, minimum, maximum, defaultValue, compactFormat, callback)
	task.wait()
	local localValue010
	if type(configOrName) == "table" then
		local localValue011 = configOrName
		local localValue012 = string.split((localValue011.Name or ""), "\n")
		localValue010 = localValue012[1]
		description = localValue012[2]
		minimum = localValue011.Min
		maximum = localValue011.Max
		defaultValue = localValue011.Value
		compactFormat = localValue011.Format
		callback = localValue011.Callback
	else
		localValue010 = configOrName
		local localValue013 = string.split(localValue010, "\n")
		localValue010 = localValue013[1]
		description = (localValue013[2] or description)
		if type(compactFormat) == "function" then
			callback = compactFormat
			compactFormat = false
		end
	end
	minimum = (minimum or 0)
	maximum = (maximum or 100)
	local localValue014 = (tonumber(defaultValue) or minimum)
	localValue014 = math.floor(math.clamp(localValue014, minimum, maximum))
	local function localFunction001(argument006)
		local text = tostring(math.floor(argument006))
		while true do
			local localValue015, localValue016 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
			text = localValue015
			if localValue016 == 0 then
				break
			end
		end
		return text
	end
	local function localFunction002(argument007)
		argument007 = (tonumber(argument007) or 0)
		local localValue017 = math.abs(argument007)
		if localValue017 >= 1e12 then
			return string.format("%.1fT", (argument007 / 1e12))
		elseif localValue017 >= 1e9 then
			return string.format("%.1fB", (argument007 / 1e9))
		elseif localValue017 >= 1e6 then
			return string.format("%.1fM", (argument007 / 1e6))
		elseif localValue017 >= 1e3 then
			return string.format("%.1fK", (argument007 / 1e3))
		end
		return tostring(math.floor(argument007))
	end
	local function localFunction003(argument008)
		if compactFormat == true then
			return localFunction002(argument008)
		end
		return localFunction001(argument008)
	end
	local row = self._form:Row({ SearchIndex = localValue010 })
	local titleStack = row:Left():TitleStack({ Title = localValue010, Subtitle = description })
	local rightColumn = row:Right()
	local isEnabled = false
	local localValue018
	local localValue019
	localValue019 = rightColumn:Slider({
		Minimum = minimum,
		Maximum = maximum,
		Value = localValue014,
		ValueChanged = function(_, argument009)
			if isEnabled then
				return
			end
			isEnabled = true
			argument009 = math.floor(argument009)
			if localValue018 then
				pcall(function()
					local localValue020 = localFunction003(argument009)
					if localValue018.SetValue then
						localValue018:SetValue(localValue020)
					else
						localValue018.Value = localValue020
					end
				end)
			end
			if callback then
				callback(argument009)
			end
			isEnabled = false
		end,
	})
	localValue018 = rightColumn:TextField({
		Placeholder = localFunction003(localValue014),
		Value = localFunction003(localValue014),
		ValueChanged = function(_, argument010)
			if isEnabled then
				return
			end
			local localValue021 = tostring(argument010)
				:gsub(",", "")
				:gsub("[Kk]", "000")
				:gsub("[Mm]", "000000")
				:gsub("[Bb]", "000000000")
				:gsub("[Tt]", "000000000000")
			local numberValue = tonumber(localValue021)
			if not numberValue then
				return
			end
			isEnabled = true
			numberValue = math.floor(math.clamp(numberValue, minimum, maximum))
			pcall(function()
				local localValue022 = localFunction003(numberValue)
				if localValue018.SetValue then
					localValue018:SetValue(localValue022)
				else
					localValue018.Value = localValue022
				end
			end)
			pcall(function()
				if localValue019.SetValue then
					localValue019:SetValue(numberValue)
				else
					localValue019.Value = numberValue
				end
			end)
			if callback then
				callback(numberValue)
			end
			isEnabled = false
		end,
	})
	local data = {}
	function data:SetTitle(argument011)
		local localValue023 = string.split(tostring(argument011), "\n")
		titleStack.Title = (localValue023[1] or "")
		titleStack.Subtitle = (localValue023[2] or "")
	end
	function data:SetValue(argument012)
		argument012 = tonumber(argument012)
		if not argument012 then
			return
		end
		argument012 = math.floor(math.clamp(argument012, minimum, maximum))
		isEnabled = true
		pcall(function()
			if localValue019.SetValue then
				localValue019:SetValue(argument012)
			else
				localValue019.Value = argument012
			end
		end)
		pcall(function()
			local localValue024 = localFunction003(argument012)
			if localValue018.SetValue then
				localValue018:SetValue(localValue024)
			else
				localValue018.Value = localValue024
			end
		end)
		isEnabled = false
	end
	function data:GetValue()
		return localValue019.Value
	end
	function data:Remove()
		row:Destroy()
	end
	if (type(configOrName) == "table") and configOrName.Key then
		getgenv().UIRegistry = (getgenv().UIRegistry or {})
		getgenv().UIRegistry[configOrName.Key] = data
	end
	return data
end
function SectionAPI:Button(configOrName, descriptionOrCallback, buttonLabel, callback)
	task.wait()
	local localValue025
	if type(configOrName) == "table" then
		local localValue026 = configOrName
		local localValue027 = string.split((localValue026.Name or ""), "\n")
		localValue025 = localValue027[1]
		descriptionOrCallback = localValue027[2]
		buttonLabel = localValue027[1]
		callback = localValue026.Callback
	elseif type(descriptionOrCallback) == "function" then
		callback = descriptionOrCallback
		local localValue028 = string.split(configOrName, "\n")
		localValue025 = localValue028[1]
		descriptionOrCallback = localValue028[2]
		buttonLabel = localValue025
	else
		localValue025 = configOrName
		local localValue029 = string.split(localValue025, "\n")
		localValue025 = localValue029[1]
		descriptionOrCallback = (localValue029[2] or descriptionOrCallback)
	end
	local localValue030 = createFormRow(self._form, localValue025, descriptionOrCallback)
	localValue030:Right():Button({
		Label = (buttonLabel or localValue025),
		State = "Primary",
		Pushed = callback,
	})
	return {
		Remove = function()
			localValue030:Destroy()
		end,
		SetState = function(_, argument013)
			btn.State = argument013
		end,
	}
end
function SectionAPI:Dropdown(configOrName, defaultValue, options, callback, unused)
	task.wait()
	local localValue031, localValue032, localValue033
	if type(configOrName) == "table" then
		local localValue034 = configOrName
		local localValue035 = string.split((localValue034.Name or ""), "\n")
		localValue031 = localValue035[1]
		localValue032 = localValue035[2]
		localValue033 = localValue035[3]
		defaultValue = localValue034.Default
		options = localValue034.List
		callback = localValue034.Callback
	else
		local localValue036 = string.split(configOrName, "\n")
		localValue031 = localValue036[1]
		localValue032 = localValue036[2]
		localValue033 = localValue036[3]
	end
	local function localFunction004()
		if type(options) == "function" then
			return options()
		end
		return (options or {})
	end
	local localValue037 = localFunction004()
	local numberValue = 1
	if defaultValue then
		for index005, item005 in ipairs(localValue037) do
			if item005 == defaultValue then
				numberValue = index005
				break
			end
		end
	end
	local function localFunction005(argument014)
		return (
			(
				localValue032
				and (
					(localValue032:find("%%s") and localValue032:format(argument014))
					or (localValue032 .. ("\n" .. ((localValue033 or "•") .. (" " .. argument014))))
				)
			) or argument014
		)
	end
	local localValue038 = ((defaultValue or localValue037[numberValue]) or "")
	local row = self._form:Row({ SearchIndex = localValue031 })
	local titleStack = row:Left():TitleStack({ Title = localValue031, Subtitle = localFunction005(localValue038) })
	local localValue040 = row:Right():PullDownButton({
		Options = localValue037,
		Value = numberValue,
		Search = (#localValue037 > 10),
		ValueChanged = function(self, argument015)
			local localValue039 = (self.Options[argument015] or "")
			titleStack.Subtitle = localFunction005(localValue039)
			if callback then
				callback(localValue039)
			end
		end,
	})
	return {
		Refresh = function()
			local localValue041 = localFunction004()
			localValue040.Options = localValue041
			local localValue042 = (localValue040.Options[localValue040.Value] or "")
			local isEnabled = false
			for _, item006 in ipairs(localValue041) do
				if item006 == localValue042 then
					isEnabled = true
					break
				end
			end
			if not isEnabled then
				localValue040.Value = 1
				local localValue043 = (localValue041[1] or "")
				titleStack.Subtitle = localFunction005(localValue043)
				if callback then
					callback(localValue043)
				end
			end
		end,
		Remove = function()
			if row then
				row:Destroy()
			end
		end,
		SetValue = function(argument016)
			for index006, item007 in ipairs(localValue040.Options) do
				if item007 == argument016 then
					localValue040.Value = index006
					titleStack.Subtitle = localFunction005(argument016)
					break
				end
			end
		end,
	}
end
function SectionAPI:MultiDropdown(configOrName, defaultValues, options, callback)
	task.wait()
	local localValue044, localValue045, localValue046
	if type(configOrName) == "table" then
		local localValue047 = configOrName
		local localValue048 = string.split((localValue047.Name or ""), "\n")
		localValue044 = localValue048[1]
		localValue045 = localValue048[2]
		localValue046 = localValue048[3]
		defaultValues = (localValue047.Default or defaultValues)
		options = (localValue047.List or options)
		callback = (localValue047.Callback or callback)
	else
		local localValue049 = string.split(configOrName, "\n")
		localValue044 = localValue049[1]
		localValue045 = localValue049[2]
		localValue046 = localValue049[3]
	end
	local function localFunction006()
		if type(options) == "function" then
			return options()
		end
		return (options or {})
	end
	local localValue050 = localFunction006()
	local data = {}
	local data2 = {}
	if type(defaultValues) == "table" then
		for _, item008 in ipairs(defaultValues) do
			for index007, item009 in ipairs(localValue050) do
				if item009 == item008 then
					table.insert(data, index007)
					table.insert(data2, item009)
					break
				end
			end
		end
	elseif type(defaultValues) == "string" then
		for index008, item010 in ipairs(localValue050) do
			if item010 == defaultValues then
				table.insert(data, index008)
				table.insert(data2, item010)
				break
			end
		end
	end
	local function localFunction007(argument017)
		return (((#argument017 > 0) and table.concat(argument017, ", ")) or "ไม่ได้เลือก")
	end
	local function localFunction008(argument018)
		if not localValue045 then
			return argument018
		end
		if localValue046 then
			return (localValue045 .. ("\n" .. (localValue046 .. (" " .. argument018))))
		end
		if localValue045:find("%%s") then
			return localValue045:format(argument018)
		end
		return (localValue045 .. (" • " .. argument018))
	end
	local row = self._form:Row({ SearchIndex = localValue044 })
	local titleStack = row:Left()
		:TitleStack({ Title = localValue044, Subtitle = localFunction008(localFunction007(data2)) })
	local localValue051 = row:Right():PullDownButton({
		Options = localValue050,
		Multi = true,
		Value = data,
		Search = (#localValue050 > 10),
		ValueChanged = function(self, argument019)
			local data3 = {}
			if type(argument019) == "table" then
				for _, item011 in ipairs(argument019) do
					table.insert(data3, self.Options[item011])
				end
			elseif type(argument019) == "number" then
				table.insert(data3, self.Options[argument019])
			end
			titleStack.Subtitle = localFunction008(localFunction007(data3))
			if callback then
				callback(data3)
			end
		end,
	})
	return {
		Refresh = function()
			local localValue052 = localFunction006()
			localValue051.Options = localValue052
			local localValue053 = (localValue051.Value or {})
			local data3 = {}
			for _, item012 in ipairs(localValue053) do
				if localValue052[item012] then
					table.insert(data3, item012)
				end
			end
			localValue051.Value = data3
			local data4 = {}
			for _, item013 in ipairs(data3) do
				table.insert(data4, localValue052[item013])
			end
			titleStack.Subtitle = localFunction008(localFunction007(data4))
			if callback then
				callback(data4)
			end
		end,
		SetValue = function(argument020)
			if type(argument020) ~= "table" then
				argument020 = { argument020 }
			end
			local data3 = {}
			local data4 = {}
			for _, item014 in ipairs(argument020) do
				for index009, item015 in ipairs(localValue051.Options) do
					if item015 == item014 then
						table.insert(data3, index009)
						table.insert(data4, item015)
						break
					end
				end
			end
			localValue051.Value = data3
			titleStack.Subtitle = localFunction008(localFunction007(data4))
		end,
	}
end
function SectionAPI:Textbox(configOrName, defaultText, callback)
	task.wait()
	local localValue054, localValue055, localValue056, localValue057
	if type(configOrName) == "table" then
		local localValue058 = configOrName
		local localValue059 = string.split((localValue058.Name or ""), "\n")
		localValue054 = localValue059[1]
		localValue055 = localValue059[2]
		localValue056 = (localValue058.Placeholder or "")
		localValue057 = (localValue058.Default or "")
		callback = defaultText
	else
		local localValue060 = string.split(configOrName, "\n")
		localValue054 = localValue060[1]
		localValue055 = localValue060[2]
		localValue056 = ""
		localValue057 = ""
		if type(defaultText) == "function" then
			callback = defaultText
		else
			localValue057 = (defaultText or "")
		end
	end
	local localValue061 = createFormRow(self._form, localValue054, localValue055)
	localValue061:Right():TextField({
		Placeholder = localValue056,
		Value = localValue057,
		ValueChanged = function(_, argument021)
			if callback then
				callback(argument021)
			end
		end,
	})
end
function SectionAPI:Label(text)
	task.wait()
	local localValue062 = (((type(text) == "table") and (text.Name or "")) or text)
	local localValue063 = string.split(localValue062, "\n")
	local row = self._form:Row({ SearchIndex = localValue063[1] })
	row:Left():Label({ Text = localValue063[1] })
end
function SectionAPI:DynamicLabel(text)
	task.wait()
	local row = self._form:Row({ SearchIndex = (text or "") })
	local localValue064 = row:Left():Label({ Text = (text or "") })
	local data = {}
	function data:Set(argument022)
		localValue064.Text = argument022
		row.SearchIndex = (argument022 or "")
	end
	function data:Remove()
		row:Destroy()
	end
	return data
end
function SectionAPI:Keybind(configOrName, defaultKey, currentKey, callback)
	task.wait()
	local localValue065
	if type(configOrName) == "table" then
		local localValue066 = configOrName
		local localValue067 = string.split((localValue066.Name or ""), "\n")
		localValue065 = localValue067[1]
		defaultKey = localValue067[2]
		currentKey = localValue066.Default
		callback = localValue066.Callback
	else
		local localValue068 = string.split(configOrName, "\n")
		localValue065 = localValue068[1]
		defaultKey = (localValue068[2] or defaultKey)
		if (type(defaultKey) == "userdata") or (type(defaultKey) == "nil") then
			callback = currentKey
			currentKey = defaultKey
			defaultKey = localValue068[2]
		end
	end
	local localValue069 = createFormRow(self._form, localValue065, defaultKey)
	localValue069:Right():KeybindField({
		Value = currentKey,
		ValueChanged = function(_, argument023)
			if callback then
				callback(argument023)
			end
		end,
	})
end
function SectionAPI:Image(image, size, transparency)
	task.wait()
	if not image then
		return nil
	end
	local row = self._form:Row({})
	local success, result = pcall(function()
		return row:Left():Symbol({
			Image = (
				(
					((type(image) == "number") or not (tostring(image):find("rbxassetid://")))
					and ("rbxassetid://" .. tostring(image))
				) or tostring(image)
			),
			Size = UDim2.fromOffset((size or 42), (transparency or 42)),
			Style = "Primary",
		})
	end)
	if not success then
		row:Destroy()
		return nil
	end
	return {
		Destroy = function()
			if row then
				row:Destroy()
			end
		end,
	}
end
function SectionAPI:Choice(configOrName, choices, callback, argument024)
	task.wait()
	local localValue070, localValue071
	if type(configOrName) == "table" then
		local localValue072 = configOrName
		local localValue073 = string.split((localValue072.Name or ""), "\n")
		localValue070 = localValue073[1]
		localValue071 = localValue073[2]
		choices = (localValue072.List or {})
		callback = localValue072.Value
		argument024 = localValue072.Callback
	else
		local localValue074 = string.split(configOrName, "\n")
		localValue070 = localValue074[1]
		localValue071 = localValue074[2]
	end
	choices = (choices or {})
	local localValue075 = (callback or choices[1])
	local row = self._form:Row({ SearchIndex = localValue070 })
	local titleStack = row:Left():TitleStack({
		Title = localValue070,
		Subtitle = ((localValue071 and (localValue071 .. (" • " .. tostring(localValue075)))) or tostring(
			localValue075
		)),
	})
	local rightColumn = row:Right()
	local data = {}
	local function localFunction009()
		for index010, item016 in pairs(data) do
			local localValue076 = (index010 == localValue075)
			item016.Label = ((localValue076 and ("● " .. tostring(index010))) or ("○ " .. tostring(index010)))
			item016.State = ((localValue076 and "Primary") or "Secondary")
		end
		titleStack.Subtitle = (
			(localValue071 and (localValue071 .. (" • " .. tostring(localValue075)))) or tostring(localValue075)
		)
	end
	for _, item017 in ipairs(choices) do
		local button = rightColumn:Button({
			Label = "",
			State = "Secondary",
			Pushed = function()
				localValue075 = item017
				localFunction009()
				if argument024 then
					task.spawn(argument024, item017)
				end
			end,
		})
		data[item017] = button
	end
	localFunction009()
	if argument024 and (localValue075 ~= nil) then
		task.spawn(argument024, localValue075)
	end
	local data2 = {}
	function data2:Set(argument025)
		if data[argument025] then
			localValue075 = argument025
			localFunction009()
			if argument024 then
				task.spawn(argument024, argument025)
			end
		end
	end
	function data2:Get()
		return localValue075
	end
	function data2:Destroy()
		if row then
			row:Destroy()
		end
	end
	return data2
end
function SectionAPI:Separator()
	task.wait()
	local row = self._form:Row({ SearchIndex = "" })
	row:Left():Label({
		Text = "─────────────────────────────",
	})
	return {
		Remove = function()
			row:Destroy()
		end,
	}
end
function SectionAPI:TitleLabel(title, subtitle)
	task.wait()
	local row = self._form:Row({ SearchIndex = (title or "") })
	local titleStack = row:Left():TitleStack({ Title = (title or ""), Subtitle = (subtitle or "") })
	return {
		SetTitle = function(_, argument026)
			titleStack.Title = (argument026 or "")
		end,
		SetSubtitle = function(_, argument027)
			titleStack.Subtitle = (argument027 or "")
		end,
		Remove = function()
			row:Destroy()
		end,
	}
end
function SectionAPI:PerkHeader(title, description, isUniversal)
	task.wait()
	local localValue077 = string.format("[%s]", (description or "?"))
	local localValue078 = ((isUniversal and (localValue077 .. "  ◆ Not limited by Slot Type")) or localValue077)
	local localValue079 = (
		(isUniversal and (localValue077 .. "  ◆ ไม่ถูก Slot Type จำกัด")) or localValue077
	)
	local row = self._form:Row({ SearchIndex = (title or "") })
	local titleStack = row:Left():TitleStack({ Title = (title or ""), Subtitle = localValue078 })
	table.insert(getgenv().PerkDetailLabels, {
		label = {
			Set = function(_, argument028)
				titleStack.Subtitle = argument028
			end,
		},
		prefix = "",
		english = localValue078,
		thai = localValue079,
	})
	return {
		Remove = function()
			row:Destroy()
		end,
	}
end
function SectionAPI:StatLabel(title, value, suffix)
	task.wait()
	local row = self._form:Row({ SearchIndex = (value or "") })
	local localValue080 = row:Left():Label({ Text = ((title or "") .. (value or "")) })
	table.insert(getgenv().PerkDetailLabels, {
		OIOI = {
			Set = function(_, argument029)
				localValue080.Text = argument029
			end,
		},
		G_1I = (title or ""),
		__1I = (value or ""),
		IIOI = ((suffix or value) or ""),
	})
	return {
		Remove = function()
			row:Destroy()
		end,
	}
end
function SectionAPI:EffectLabel(title, description)
	task.wait()
	local row = self._form:Row({ SearchIndex = (title or "") })
	local localValue081 = row:Left():Label({
		Text = ("  ★ " .. (title or "")),
	})
	table.insert(getgenv().PerkDetailLabels, {
		GIOI = {
			Set = function(_, argument030)
				localValue081.Text = argument030
			end,
		},
		prefix = "  ★ ",
		SIOI = (title or ""),
		ZIOI = ((description or title) or ""),
	})
	return {
		Remove = function()
			row:Destroy()
		end,
	}
end
function SectionAPI:ReduceHeader()
	task.wait()
	local textValue = "▼ Reduces on hit:"
	local textValue2 = "▼ ลดค่าเมื่อโจมตีโดน:"
	local row = self._form:Row({ SearchIndex = "" })
	local localValue082 = row:Left():Label({
		Text = ("  " .. textValue),
	})
	table.insert(getgenv().PerkDetailLabels, {
		olOI = {
			Set = function(_, argument031)
				localValue082.Text = argument031
			end,
		},
		prefix = "  ",
		english = textValue,
		thai = textValue2,
	})
	return {
		Remove = function()
			row:Destroy()
		end,
	}
end
function safeGet(argument032, ...)
	local localValue083 = argument032
	for _, item018 in ipairs({ ... }) do
		if typeof(localValue083) == "Instance" then
			localValue083 = localValue083:FindFirstChild(item018)
		else
			return nil
		end
		if localValue083 == nil then
			return nil
		end
	end
	return localValue083
end
local gameName = (game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Survive Zombie Arena")
local hub = HubAdapter.new({
	Title = ("Vector Hub" .. (" : " .. (gameName .. ""))),
	Subtitle = "Made by Ryuenz (F1 For Close UI)",
	Theme = uiLibrary.Themes.Dark,
	Accent = uiLibrary.Accents.Blue,
	Size = (
		(game:GetService("UserInputService").TouchEnabled and UDim2.fromOffset(450, 395)) or UDim2.fromOffset(850, 530)
	),
})
_G.Window = hub
_G.Logo = 128425033657295
getgenv().Players = game:GetService("Players")
getgenv().UserInputService = game:GetService("UserInputService")
getgenv().RunService = game:GetService("RunService")
getgenv().TweenService = game:GetService("TweenService")
getgenv().Lighting = game:GetService("Lighting")
getgenv().HttpService = game:GetService("HttpService")
getgenv().TeleportService = game:GetService("TeleportService")
getgenv().LocalPlayer = getgenv().Players.LocalPlayer
getgenv().LogoGui = Instance.new("ScreenGui")
getgenv().ImageButton = Instance.new("ImageButton")
getgenv().UICorner = Instance.new("UICorner")
getgenv().ClickSound = Instance.new("Sound")
getgenv().FlashFrame = Instance.new("Frame")
getgenv().UICorner2 = Instance.new("UICorner")
getgenv().LogoGui.Name = "VectorImageButton"
getgenv().LogoGui.Parent = gethui()
getgenv().LogoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
getgenv().ImageButton.Parent = getgenv().LogoGui
getgenv().ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
getgenv().ImageButton.BorderSizePixel = 0
getgenv().ImageButton.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
getgenv().ImageButton.Size = UDim2.new(0, 35, 0, 33)
getgenv().ImageButton.Draggable = true
getgenv().ImageButton.Image = ("http://www.roblox.com/asset/?id=" .. _G.Logo)
getgenv().UICorner.Parent = getgenv().ImageButton
getgenv().FlashFrame.Size = UDim2.new(0, 20, 0, 20)
getgenv().FlashFrame.Position = UDim2.new(0, 0, 0, 0)
getgenv().FlashFrame.AnchorPoint = Vector2.new(0.5, 0.5)
getgenv().FlashFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
getgenv().FlashFrame.BackgroundTransparency = 1
getgenv().FlashFrame.ZIndex = 2
getgenv().FlashFrame.Parent = getgenv().ImageButton
getgenv().UICorner2.Parent = getgenv().FlashFrame
getgenv().UICorner2.CornerRadius = UDim.new(1, 10)
getgenv().playClickFlash = function()
	local localValue084 = getgenv().LocalPlayer:GetMouse()
	local localValue085 = (
		(localValue084.X - getgenv().ImageButton.AbsolutePosition.X) / getgenv().ImageButton.AbsoluteSize.X
	)
	local localValue086 = (
		(localValue084.Y - getgenv().ImageButton.AbsolutePosition.Y) / getgenv().ImageButton.AbsoluteSize.Y
	)
	getgenv().FlashFrame.Position = UDim2.new(localValue085, 0, localValue086, 0)
	getgenv().FlashFrame.Size = UDim2.new(0, 20, 0, 20)
	getgenv().FlashFrame.BackgroundTransparency = 0.3
	getgenv().TweenService
		:Create(getgenv().FlashFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1,
			Size = UDim2.new(1.8, 0, 1.8, 0),
		})
		:Play()
end
local userInputService = game:GetService("UserInputService")
local playersService = game:GetService("Players")
local localPlayer = playersService.LocalPlayer
getgenv().minimizeKeybind = (getgenv().minimizeKeybind or Enum.KeyCode.F1)
local isEnabled = false
local function localFunction010()
	local localValue087 = localPlayer.Team
	return (localValue087 and ((localValue087.Name == "Spectator") or (localValue087.Name == "Spectators")))
end
local function localFunction011()
	return ((hub and hub._win) and not hub._win.Minimized)
end
local function localFunction012()
	if localFunction011() then
		userInputService.MouseBehavior = Enum.MouseBehavior.Default
		userInputService.MouseIconEnabled = true
		return
	end
	if localFunction010() then
		return
	end
	userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	userInputService.MouseIconEnabled = false
end
local function localFunction013()
	if isEnabled then
		return
	end
	isEnabled = true
	local localValue088 = getrawmetatable(game)
	local localValue089 = (isreadonly and isreadonly(localValue088))
	setreadonly(localValue088, false)
	local localValue090 = localValue088.__newindex
	local localValue091 = localValue088.__index
	localValue088.__newindex = newcclosure(function(self, argument033, argument034)
		if (self == userInputService) and localFunction011() then
			if argument033 == "MouseBehavior" then
				return localValue090(self, argument033, Enum.MouseBehavior.Default)
			end
			if argument033 == "MouseIconEnabled" then
				return localValue090(self, argument033, true)
			end
		end
		return localValue090(self, argument033, argument034)
	end)
	localValue088.__index = newcclosure(function(self, argument035)
		if (self == userInputService) and localFunction011() then
			if argument035 == "MouseBehavior" then
				return Enum.MouseBehavior.Default
			end
			if argument035 == "MouseIconEnabled" then
				return true
			end
		end
		return localValue091(self, argument035)
	end)
	if localValue089 ~= nil then
		setreadonly(localValue088, localValue089)
	else
		setreadonly(localValue088, true)
	end
end
local function localFunction014()
	if not hub or not hub._win then
		return
	end
	hub._win.Minimized = not hub._win.Minimized
	localFunction012()
end
localFunction013()
if getgenv().ImageButton then
	getgenv().ImageButton.MouseButton1Click:Connect(function()
		if getgenv().ClickSound then
			getgenv().ClickSound:Play()
		end
		if getgenv().playClickFlash then
			getgenv().playClickFlash()
		end
		localFunction014()
	end)
end
userInputService.InputEnded:Connect(function(argument036, argument037)
	if argument037 then
		return
	end
	if argument036.KeyCode == getgenv().minimizeKeybind then
		localFunction014()
	end
end)
localPlayer:GetPropertyChangedSignal("Team"):Connect(localFunction012)
localFunction012()
local data = {
	Information = getgenv().InfoTab,
	OP = getgenv().OP,
	Survivors = getgenv().Survivors,
	Killer = getgenv().Killer,
	SK = getgenv().SK,
	Misc = getgenv().Misc,
}
for index011, item019 in pairs(data) do
	if item019 and item019._tab then
		item019._tab.Activated:Connect(function()
			_G.save.LastTab = index011
			saveSettings()
		end)
	else
	end
end
local localValue092 = (_G.save.LastTab or "Farm")
getgenv().InfoTab = hub:CreateTab("Info", "Information", "crown", "Info", (localValue092 == "Information"))
local creditSection = InfoTab:CreateSection("Credit")
creditSection:Label("Script Made By Ryuenz#6264")
local localValue093 = creditSection:DynamicLabel("Copy Discord Link → กด Copy Link")
local textValue = "Copy Discord Link → Click Copy Link"
local textValue2 = "ก็อปลิ้งดิสคอร์ด → กด Copy Link"
task.spawn(LPH_NO_VIRTUALIZE(function()
	while true do
		localValue093:Set(textValue)
		localValue093:Set(textValue2)
		wait(0.1)
	end
end))
creditSection:Button("Copy Discord Link", "เข้าร่วม Discord", "Copy Link", function()
	local function localFunction015(argument038, argument039, argument040)
		if type(argument039) == argument038 then
			return argument039
		end
		return argument040
	end
	local httpService = game:GetService("HttpService")
	local localValue094 = localFunction015(
		"function",
		(
			(((request or http_request) or (syn and syn.request)) or (http and http.request))
			or (fluxus and fluxus.request)
		),
		nil
	)
	if localValue094 then
		localValue094({
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				Origin = "https://discord.com",
			},
			Body = httpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				nonce = httpService:GenerateGUID(false),
				args = {
					code = "5Yv9d26PHu",
				},
			}),
		})
	end
	setclipboard("https://discord.gg/977JQXX82w")
	hub:Notify({
		Title = "Vector Hub",
		Subtitle = "Copied Discord link!",
		Duration = 3,
	})
end)
creditSection:Button("Protect Name", "ซ่อนชื่อในเกม", "Protect", function()
	loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3fe82db790953de0da11d9a70008ffea.lua"))()
end)
getgenv().UIRegistry = (getgenv().UIRegistry or {})
getgenv().OP = hub:CreateTab("Main", "OP", "flame", "Main", (localValue092 == "OP"))
getgenv().Survivors = hub:CreateTab("Main", "Survivors", "person2", "Main", (localValue092 == "Survivors"))
getgenv().Killer = hub:CreateTab("Main", "Killer", "person", "Main", (localValue092 == "Killer"))
getgenv().SK = hub:CreateTab("Main", "S&K", "questionmark", "Main", (localValue092 == "S&K"))
local playersService2 = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer2 = playersService2.LocalPlayer
local function localFunction016()
	local data2 = {
		"None",
	}
	for _, item020 in pairs(playersService2:GetPlayers()) do
		if item020 ~= localPlayer2 then
			local localValue095 = ((item020.Team and item020.Team.Name) or "No Team")
			table.insert(data2, (item020.Name .. (" (" .. (localValue095 .. ")"))))
		end
	end
	return data2
end
local function localFunction017(argument041)
	return argument041:match("^(.+) %(")
end
local teleportOpFunctionsSection = OP:CreateSection("(Teleport) - OP Functions")
teleportOpFunctionsSection:Label("Players - Teleport")
_G.SelectPlayerTP = "None"
local dropdown = teleportOpFunctionsSection:Dropdown(
	"Select TP Player\nเลือกผู้เล่นสำหรับวาร์ป",
	"None",
	function()
		return localFunction016()
	end,
	function(argument042)
		_G.SelectPlayerTP = argument042
	end
)
getgenv().UIRegistry["SelectPlayerTP"] = dropdown
local function localFunction018()
	local localValue096 = localFunction016()
	local isEnabled2 = false
	for _, item021 in ipairs(localValue096) do
		if item021 == _G.SelectPlayerTP then
			isEnabled2 = true
			break
		end
	end
	if not isEnabled2 then
		_G.SelectPlayerTP = "None"
	end
	dropdown.Refresh()
end
playersService2.PlayerAdded:Connect(function(argument043)
	task.wait(0.5)
	localFunction018()
	argument043:GetPropertyChangedSignal("Team"):Connect(function()
		task.wait(0.2)
		localFunction018()
	end)
end)
playersService2.PlayerRemoving:Connect(function()
	task.wait(0.1)
	localFunction018()
end)
for _, item022 in pairs(playersService2:GetPlayers()) do
	if item022 ~= localPlayer2 then
		item022:GetPropertyChangedSignal("Team"):Connect(function()
			task.wait(0.2)
			localFunction018()
		end)
	end
end
getgenv().UIRegistry["AutoTP"] = teleportOpFunctionsSection:Toggle(
	"Teleport To Player\nวาร์ปไปหาผู้เล่น",
	false,
	function(argument044)
		_G.save.AutoTP = argument044
	end
)

playersService2.PlayerAdded:Connect(function(argument045)
	task.wait(0.5)
	localFunction018()
	argument045:GetPropertyChangedSignal("Team"):Connect(function()
		task.wait(0.2)
		localFunction018()
	end)
end)
for _, item023 in pairs(playersService2:GetPlayers()) do
	if item023 ~= localPlayer2 then
		item023:GetPropertyChangedSignal("Team"):Connect(function()
			task.wait(0.2)
			localFunction018()
		end)
	end
end
local function localFunction019()
	if not _G.SelectPlayerTP or (_G.SelectPlayerTP == "None") then
		return nil
	end
	local localValue097 = localFunction017(_G.SelectPlayerTP)
	if not localValue097 then
		return nil
	end
	local instance = playersService2:FindFirstChild(localValue097)
	if not instance or not instance.Character then
		return nil
	end
	return instance.Character:FindFirstChild("HumanoidRootPart")
end
task.spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait(0.5) do
		if _G.save.AutoTP then
			local character = localPlayer2.Character
			local localValue098 = (character and character:FindFirstChild("HumanoidRootPart"))
			local localValue099 = localFunction019()
			if localValue098 and localValue099 then
				localValue098.CFrame = (localValue099.CFrame * CFrame.new(2, 0, 2))
			end
		end
	end
end))
_G.GeneratorMode = "Highest Progress\nเครื่องที่ปั่นได้เยอะ"
teleportOpFunctionsSection:Label("Generator - Teleport")
local dropdown2 = teleportOpFunctionsSection:Dropdown(
	"Teleport To Generator Mode\nเลือกโหมดที่จะวาร์ปไปหาเครื่อง",
	"Highest Progress\nเครื่องที่ปั่นได้เยอะ",
	{
		"Lowest Progress\nเครื่องที่ปั่นได้น้อย",
		"Highest Progress\nเครื่องที่ปั่นได้เยอะ",
		"Being Repaired\nเครื่องที่กำลังมีคนปั่น",
		"Being Damaged\nเครื่องที่โดนพัง",
	},
	function(argument046)
		_G.GeneratorMode = argument046
	end
)
getgenv().UIRegistry["GeneratorMode"] = dropdown2
getgenv().UIRegistry["AutoTPGen"] = teleportOpFunctionsSection:Toggle(
	"Teleport To Generator\nวาร์ปไปเครื่องปั่น",
	false,
	function(argument047)
		_G.save.AutoTPGen = argument047
	end
)
local data2 = {}
task.spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait(1) do
		for _, item024 in pairs(workspace.Map:GetDescendants()) do
			if item024:IsA("Model") and (item024.Name == "Generator") then
				local localValue100 = item024:GetAttribute("RepairProgress")
				if localValue100 then
					data2[item024] = localValue100
				end
			end
		end
	end
end))
local function localFunction020()
	local localValue101 = nil
	local localValue102 = nil
	for _, item025 in pairs(workspace.Map:GetDescendants()) do
		if item025:IsA("Model") and (item025.Name == "Generator") then
			local localValue103 = item025:GetAttribute("RepairProgress")
			local localValue104 = item025:FindFirstChildWhichIsA("BasePart")
			if localValue103 and localValue104 then
				local localValue105 = data2[item025]
				if
					_G.GeneratorMode
					== "Lowest Progress\nเครื่องที่ปั่นได้น้อย"
				then
					if localValue103 < 100 then
						if not localValue102 or (localValue103 < localValue102) then
							localValue102 = localValue103
							localValue101 = localValue104
						end
					end
				elseif
					_G.GeneratorMode
					== "Highest Progress\nเครื่องที่ปั่นได้เยอะ"
				then
					if localValue103 < 100 then
						if not localValue102 or (localValue103 > localValue102) then
							localValue102 = localValue103
							localValue101 = localValue104
						end
					end
				elseif
					_G.GeneratorMode
					== "Being Repaired\nเครื่องที่กำลังมีคนปั่น"
				then
					if (localValue105 and (localValue103 > localValue105)) and (localValue103 < 100) then
						localValue101 = localValue104
						break
					end
				elseif _G.GeneratorMode == "Being Damaged\nเครื่องที่โดนพัง" then
					if (localValue105 and (localValue103 < localValue105)) and (localValue103 < 100) then
						localValue101 = localValue104
						break
					end
				end
			end
		end
	end
	return localValue101
end
task.spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait(0.5) do
		if _G.save.AutoTPGen then
			local character = game.Players.LocalPlayer.Character
			local localValue106 = (character and character:FindFirstChild("HumanoidRootPart"))
			local localValue107 = localFunction020()
			if localValue106 and localValue107 then
				localValue106.CFrame = localValue107.CFrame
			end
		end
	end
end))
local data3 = {
	Less = "Low Progress Gate\nประตูใกล้เปิดน้อย",
	More = "High Progress Gate\nประตูใกล้เปิดแล้ว",
	Safe = "Safe Gate\nประตูไกล Killer",
}
_G.GateMode = "More"
local data4 = {}
for _, item026 in pairs(data3) do
	table.insert(data4, item026)
end
teleportOpFunctionsSection:Label("Gate - Teleport")
local dropdown3 = teleportOpFunctionsSection:Dropdown(
	"Teleport To Gate Mode\nเลือกโหมดประตู",
	data3.More,
	data4,
	function(argument048)
		for index012, item027 in pairs(data3) do
			if item027 == argument048 then
				_G.GateMode = index012
				break
			end
		end
	end
)
getgenv().UIRegistry["GateMode"] = dropdown3
getgenv().UIRegistry["AutoTPGate"] = teleportOpFunctionsSection:Toggle(
	"Teleport To Gate\nวาร์ปไปประตู",
	false,
	function(argument049)
		_G.save.AutoTPGate = argument049
	end
)
local function localFunction021()
	for _, item028 in pairs(playersService2:GetPlayers()) do
		if item028.Team and (item028.Team.Name == "Killer") then
			local character = item028.Character
			local localValue108 = (character and character:FindFirstChild("HumanoidRootPart"))
			if localValue108 then
				return localValue108
			end
		end
	end
end
local function localFunction022(argument050)
	local exitLever = argument050:FindFirstChild("ExitLever")
	if not exitLever then
		return 0
	end
	local data5 = {
		{
			name = "Bulb3",
			value = 100,
		},
		{
			name = "Bulb2",
			value = 65,
		},
		{
			name = "Bulb1",
			value = 35,
		},
	}
	for _, item029 in ipairs(data5) do
		local instance = exitLever:FindFirstChild(item029.name)
		if instance and instance:IsA("BasePart") then
			local localValue109 = instance.Color
			if ((localValue109.R > 0.9) and (localValue109.G < 0.1)) and (localValue109.B < 0.1) then
				return item029.value
			end
		end
	end
	return (
		(
			(argument050:GetAttribute("Progress") or argument050:GetAttribute("OpenProgress"))
			or argument050:GetAttribute("GateProgress")
		) or 0
	)
end
local function localFunction023()
	local localValue110 = nil
	local localValue111 = nil
	local localValue112 = localFunction021()
	for _, item030 in pairs(workspace.Map:GetChildren()) do
		if item030:IsA("Model") and (item030.Name == "Gate") then
			if item030:FindFirstChild("ExitLever") then
				local localValue113 = item030:FindFirstChildWhichIsA("BasePart")
				local localValue114 = localFunction022(item030)
				if localValue113 and localValue114 then
					if _G.GateMode == "Less" then
						if not localValue111 or (localValue114 < localValue111) then
							localValue111 = localValue114
							localValue110 = localValue113
						end
					elseif _G.GateMode == "More" then
						if not localValue111 or (localValue114 > localValue111) then
							localValue111 = localValue114
							localValue110 = localValue113
						end
					elseif _G.GateMode == "Safe" then
						if localValue112 then
							local localValue115 = (localValue113.Position - localValue112.Position).Magnitude
							if localValue115 > 100 then
								localValue110 = localValue113
								break
							end
						end
					end
				end
			end
		end
	end
	return localValue110
end
task.spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait(0.5) do
		if _G.save.AutoTPGate then
			local character = playersService2.LocalPlayer.Character
			local localValue116 = (character and character:FindFirstChild("HumanoidRootPart"))
			local localValue117 = localFunction023()
			if localValue116 and localValue117 then
				localValue116.CFrame = (localValue117.CFrame * CFrame.new(0, 0, 3))
			end
		end
	end
end))
getgenv().SurvivorsOP = OP:CreateSection("(Survivors) - OP Functions")
getgenv().UIRegistry["AutoUnhook"] = SurvivorsOP:Toggle(
	"Auto Unhook\nปลดตะขออัตโนมัติ",
	false,
	function(argument051)
		_G.save.AutoUnhook = argument051
	end
)
spawn(LPH_NO_VIRTUALIZE(function()
	while true do
		task.wait(0.1)
		if _G.save.AutoUnhook then
			local localPlayer3 = game.Players.LocalPlayer
			local character = localPlayer3.Character
			local localValue118 = (character and character:FindFirstChild("HumanoidRootPart"))
			if localValue118 then
				for _, item031 in pairs(workspace:GetChildren()) do
					if item031:IsA("Model") and (item031 ~= character) then
						if item031:GetAttribute("IsHooked") == true then
							local humanoidRootPart = item031:FindFirstChild("HumanoidRootPart")
							if humanoidRootPart then
								for _, item032 in pairs(workspace.Map:GetDescendants()) do
									if item032:IsA("Model") and (item032.Name == "Hook") then
										local hookPoint = item032:FindFirstChild("HookPoint")
										if hookPoint then
											local localValue119 = (humanoidRootPart.Position - hookPoint.Position).Magnitude
											if localValue119 <= 10 then
												localValue118.CFrame = hookPoint.CFrame
												game:GetService("ReplicatedStorage").Remotes.Carry.UnHookEvent
													:FireServer(hookPoint)
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end))
local killerOpFunctionsSection = OP:CreateSection("(Killer) - OP Functions")
local playersService3 = game:GetService("Players")
local replicatedStorage2 = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local localPlayer3 = playersService3.LocalPlayer
local isEnabled2 = false
local function Attack()
	local localValue120 = (
		(replicatedStorage2.Remotes and replicatedStorage2.Remotes.Attacks)
		and replicatedStorage2.Remotes.Attacks:FindFirstChild("Lunge")
	)
	if localValue120 then
		localValue120:FireServer()
	end
end
local function localFunction024(argument052)
	if isEnabled2 then
		return
	end
	isEnabled2 = true
	local localValue121 = (
		(replicatedStorage2.Remotes and replicatedStorage2.Remotes.Carry)
		and replicatedStorage2.Remotes.Carry:FindFirstChild("CarrySurvivorEvent")
	)
	if localValue121 then
		localValue121:FireServer(argument052)
	end
	task.wait(0.1)
	isEnabled2 = false
end
local function localFunction025()
	local character = localPlayer3.Character
	local localValue122 = (character and character:FindFirstChild("HumanoidRootPart"))
	if not localValue122 then
		return false
	end
	for _, item033 in pairs(workspace.Map:GetDescendants()) do
		if item033:IsA("Model") and (item033.Name == "Hook") then
			local hookPoint = item033:FindFirstChild("HookPoint")
			if hookPoint and not (item033:GetAttribute("IsHooked")) then
				localValue122.CFrame = hookPoint:GetPivot()
				localValue122.Velocity = Vector3.new(0, 0, 0)
				local localValue123 = (
					(replicatedStorage2.Remotes and replicatedStorage2.Remotes.Carry)
					and replicatedStorage2.Remotes.Carry:FindFirstChild("HookEvent")
				)
				if localValue123 then
					localValue123:FireServer(hookPoint)
				end
				return true
			end
		end
	end
	return false
end
local localValue124 = nil
runService:BindToRenderStep("KillerAimLock", (Enum.RenderPriority.Camera.Value + 1), function()
	if not _G.save.AutoKill then
		localValue124 = nil
		return
	end
	if localValue124 and localValue124.Parent then
		local currentCamera = workspace.CurrentCamera
		local humanoidRootPart = localValue124:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			local localValue125 = currentCamera.CFrame.Position
			currentCamera.CFrame = currentCamera.CFrame:Lerp(CFrame.new(localValue125, humanoidRootPart.Position), 1)
		end
	end
end)
getgenv().UIRegistry["AutoKill"] = killerOpFunctionsSection:Toggle(
	"Auto Kill Survivors\nฆ่าผู้เล่นอัตโนมัติ",
	false,
	function(argument053)
		_G.save.AutoKill = argument053
		if not argument053 then
			localValue124 = nil
		end
	end
)
runService.Heartbeat:Connect(function()
	if not _G.save.AutoKill then
		return
	end
	if isEnabled2 then
		return
	end
	local character = localPlayer3.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	local localValue126 = character:GetAttribute("IsCarrying")
	local localValue127 = character:GetAttribute("Immobile")
	pcall(function()
		for _, item034 in pairs(workspace:GetChildren()) do
			if
				(item034:IsA("Model") and item034:GetAttribute("repairboost")) and (item034.Name ~= localPlayer3.Name)
			then
				local humanoidRootPart2 = item034:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart2 then
					local localValue128 = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude
					if
						(item034:GetAttribute("IsCarried") and not (item034:GetAttribute("IsHooked")))
						and (localValue128 < 10)
					then
						localValue124 = item034
						localFunction025()
						return
					end
				end
			end
		end
		for _, item035 in pairs(workspace:GetChildren()) do
			if
				(item035:IsA("Model") and item035:GetAttribute("repairboost")) and (item035.Name ~= localPlayer3.Name)
			then
				local humanoidRootPart2 = item035:FindFirstChild("HumanoidRootPart")
				local localValue129 = item035:GetAttribute("Knocked")
				local localValue130 = item035:GetAttribute("IsCarried")
				local localValue131 = item035:GetAttribute("IsHooked")
				if humanoidRootPart2 then
					localValue124 = item035
					if ((localValue129 and not localValue130) and not localValue131) and not localValue126 then
						humanoidRootPart.CFrame = item035:GetPivot()
						localFunction024(item035)
						return
					elseif ((not localValue129 and not localValue131) and not localValue126) and not localValue127 then
						humanoidRootPart.CFrame = (item035:GetPivot() * CFrame.new(0, 0, 6))
						Attack()
						return
					end
				end
			end
		end
		localValue124 = nil
	end)
end)
local Gate = getgenv().Survivors:CreateSection("Gate")
local function localFunction026()
	local data5 = {}
	for _, item036 in pairs(workspace.Map:GetDescendants()) do
		if (item036.Name == "Gate") and item036:FindFirstChild("ExitLever") then
			table.insert(data5, item036)
		end
	end
	return data5
end
local function localFunction027(argument054)
	local localValue132 = localFunction026()
	local localValue133 = localValue132[argument054]
	if localValue133 then
		for _, item037 in pairs(localValue133:GetChildren()) do
			if (item037.Name ~= "ExitLever") and (item037.Name ~= "Box") then
				item037:Destroy()
			end
		end
	end
end
function InstantGate1()
	localFunction027(1)
end
function InstantGate2()
	localFunction027(2)
end
local function localFunction028(argument055)
	local localValue134 = localFunction026()
	local localValue135 = localValue134[argument055]
	if localValue135 then
		for _, item038 in pairs(localValue135:GetChildren()) do
			if item038.Name == "Box" then
				local localValue136 = (
					localPlayer3.Character and localPlayer3.Character:FindFirstChild("HumanoidRootPart")
				)
				if localValue136 then
					localValue136.CFrame = item038.CFrame
				end
				break
			end
		end
	end
end
function InstantEscapeGate1()
	localFunction028(1)
end
function InstantEscapeGate2()
	localFunction028(2)
end
Gate:Label("🚪 Gate Control")
Gate:Button("Open Gate 1\nเปิดประตูทางออก 1", function()
	InstantGate1()
end)
Gate:Button("Open Gate 2\nเปิดประตูทางออก 2", function()
	InstantGate2()
end)
Gate:Label("🏃 Escape")
Gate:Button("Escape via Gate 1\nหนีออกทางประตู 1", function()
	InstantEscapeGate1()
end)
Gate:Button("Escape via Gate 2\nหนีออกทางประตู 2", function()
	InstantEscapeGate2()
end)
local runService2 = game:GetService("RunService")
local playersService4 = game:GetService("Players")
local virtualInputManager = game:GetService("VirtualInputManager")
local userInputService2 = game:GetService("UserInputService")
local localPlayer4 = playersService4.LocalPlayer
local isEnabled3 = false
local localValue137
local function localFunction029()
	local playerGui = localPlayer4:WaitForChild("PlayerGui")
	local data5 = {
		"SkillCheckPromptGui",
		"SkillCheckPromptGui-con",
	}
	for _, item039 in ipairs(data5) do
		local instance = playerGui:FindFirstChild(item039)
		if instance and instance:FindFirstChild("Check") then
			local localValue138 = instance.Check
			if localValue138.Visible then
				return localValue138
			end
		end
	end
end
local function localFunction030()
	local playerGui = localPlayer4.PlayerGui
	if userInputService2.TouchEnabled then
		local survivorMob = playerGui:FindFirstChild("Survivor-mob")
		if survivorMob then
			local localValue139 = survivorMob.Controls.action
			if localValue139 then
				firesignal(localValue139.MouseButton1Down)
				return
			end
		end
	end
	virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
	virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end
local function localFunction031()
	if not _G.save.AutoSkillCheck then
		return
	end
	if isEnabled3 then
		return
	end
	local localValue140 = localFunction029()
	if not localValue140 then
		return
	end
	local line = localValue140:FindFirstChild("Line")
	local goal = localValue140:FindFirstChild("Goal")
	if not line or not goal then
		return
	end
	local localValue141 = (104 + goal.Rotation)
	local localValue142 = (114 + goal.Rotation)
	if (line.Rotation >= localValue141) and (line.Rotation <= localValue142) then
		isEnabled3 = true
		localFunction030()
		task.delay(0.25, function()
			isEnabled3 = false
		end)
	end
end
_G.StartAutoSkillCheck = function()
	if localValue137 then
		return
	end
	localValue137 = runService2.RenderStepped:Connect(localFunction031)
	print("[AutoSkillCheck] Started")
end
_G.StopAutoSkillCheck = function()
	if localValue137 then
		localValue137:Disconnect()
		localValue137 = nil
	end
	isEnabled3 = false
	print("[AutoSkillCheck] Stopped")
end
local function localFunction032()
	local playerGui = localPlayer4:WaitForChild("PlayerGui")
	local function localFunction033(argument056)
		local check = argument056:FindFirstChild("Check")
		if not check then
			return
		end
		check:GetPropertyChangedSignal("Visible"):Connect(function()
			if check.Visible and _G.save.AutoSkillCheck then
				_G.StartAutoSkillCheck()
			end
		end)
	end
	for _, item040 in ipairs({
		"SkillCheckPromptGui",
		"SkillCheckPromptGui-con",
	}) do
		local instance = playerGui:FindFirstChild(item040)
		if instance then
			localFunction033(instance)
		end
	end
	playerGui.ChildAdded:Connect(function(argument057)
		if (argument057.Name == "SkillCheckPromptGui") or (argument057.Name == "SkillCheckPromptGui-con") then
			task.wait(0.2)
			localFunction033(argument057)
		end
	end)
end
localFunction032()
local minigameCheckSection = getgenv().Survivors:CreateSection("Minigame Check")
getgenv().UIRegistry["AutoSkillCheck"] = minigameCheckSection:Toggle(
	"Auto Minigame Skill Check\nออโต้สกิลเช็ค",
	(_G.save.AutoSkillCheck or false),
	function(argument058)
		_G.save.AutoSkillCheck = argument058
		saveSettings()
		if not argument058 then
			_G.StopAutoSkillCheck()
		end
	end
)
local function localFunction034(argument059)
	for _, item041 in pairs(playersService4:GetPlayers()) do
		if ((item041 ~= localPlayer4) and item041.Team) and string.lower(item041.Team.Name):find("killer") then
			local character = item041.Character
			if (character and character:FindFirstChild("Humanoid")) and (character.Humanoid.Health > 0) then
				if argument059 == "Head" then
					return character:FindFirstChild("Head")
				else
					return character:FindFirstChild("HumanoidRootPart")
				end
			end
		end
	end
	return nil
end
local localValue143
localValue143 = hookmetamethod(
	game,
	"__index",
	newcclosure(function(self, argument060)
		if (not (checkcaller()) and (argument060 == "CFrame")) and self:IsA("Camera") then
			local character = localPlayer4.Character
			if character and (character:GetAttribute("Aiming") == true) then
				local localValue144 = nil
				if _G.save.AimbotGun then
					localValue144 = localFunction034("HumanoidRootPart")
				elseif _G.save.AimbotFlashlight then
					localValue144 = localFunction034("Head")
				end
				if localValue144 then
					local localValue145 = localValue143(self, "CFrame")
					local localValue146 = localValue145.Position
					return CFrame.new(localValue146, localValue144.Position)
				end
			end
		end
		return localValue143(self, argument060)
	end)
)
local aimbotGunSection = getgenv().Survivors:CreateSection("Aimbot Gun")
getgenv().UIRegistry["AimbotGun"] = aimbotGunSection:Toggle(
	"Aimbot Gun\nอิมบอทปืน",
	(_G.save.AimbotGun or false),
	function(argument061)
		_G.save.AimbotGun = argument061
		saveSettings()
	end
)
local aimbotFlashlightSection = getgenv().Survivors:CreateSection("Aimbot Flashlight")
getgenv().UIRegistry["AimbotFlashlight"] = aimbotFlashlightSection:Toggle(
	"Aimbot Flashlight\nอิมบอทไฟฉาย",
	(_G.save.AimbotFlashlight or false),
	function(argument062)
		_G.save.AimbotFlashlight = argument062
		saveSettings()
	end
)
local data5 = {}
local function localFunction035(argument063, argument064)
	local humanoid = argument063:WaitForChild("Humanoid", 15)
	local animator = humanoid:WaitForChild("Animator", 15)
	if animator and not data5[animator] then
		data5[animator] = true
		animator.AnimationPlayed:Connect(function(argument065) end)
		humanoid.Died:Connect(function()
			data5[animator] = nil
		end)
	end
end
local function localFunction036()
	for _, item042 in pairs(playersService4:GetPlayers()) do
		if item042.Team and (item042.Team.Name == "Killer") then
			if item042.Character then
				task.spawn(localFunction035, item042.Character, item042.Name)
			end
			item042.CharacterAdded:Connect(function(argument066)
				task.wait(1)
				localFunction035(argument066, item042.Name)
			end)
		end
	end
end
localFunction036()
playersService4.PlayerAdded:Connect(function(argument067)
	argument067:GetPropertyChangedSignal("Team"):Connect(function()
		if argument067.Team and (argument067.Team.Name == "Killer") then
			localFunction036()
		end
	end)
end)
task.spawn(LPH_NO_VIRTUALIZE(function()
	while true do
		localFunction036()
		task.wait(5)
	end
end))
local data6 = {
	["DefaultLunge"] = {
		Lunge = {
			"rbxassetid://105374834496520",
			"rbxassetid://115244153053858",
			"rbxassetid://110355011987939",
			"rbxassetid://117042998468241",
			"rbxassetid://129784271201071",
			"rbxassetid://122812055447896",
			"rbxassetid://113255068724446",
			"rbxassetid://118907603246885",
			"rbxassetid://135002183282873",
		},
		Attack = {
			"rbxassetid://111920872708571",
			"rbxassetid://130593238885843",
			"rbxassetid://139369275981139",
			"rbxassetid://133963973694098",
			"rbxassetid://132817836308238",
			"rbxassetid://78432063483146",
			"rbxassetid://74968262036854",
			"rbxassetid://121216847022485",
		},
	},
	["NoLunge"] = {
		Attack = {
			"rbxassetid://138720291317243",
			"rbxassetid://109402730355822",
			"rbxassetid://106871536134254",
		},
	},
	["Special"] = {
		Dash = {
			"rbxassetid://98163597193511",
			"rbxassetid://80411309607666",
		},
	},
}
local numberValue = 25
local numberValue2 = 15
local workspaceService = game:GetService("Workspace")
local data7 = {
	"WallHitbox",
	"Hitbox",
	"Slash",
	"Damage",
}
local function localFunction037(argument068)
	if not (argument068:IsA("BasePart")) then
		return false
	end
	for _, item043 in pairs(data7) do
		if string.find(string.lower(argument068.Name), string.lower(item043)) then
			return true
		end
	end
	return false
end
local function localFunction038(argument069, argument070)
	return ((argument069.Position - argument070.Position).Magnitude <= 10)
end
local function localFunction039()
	if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Survivor-mob") then
		firesignal(game.Players.LocalPlayer.PlayerGui["Survivor-mob"].Controls["Gui-mob"].MouseButton1Down)
	elseif not (game.Players.LocalPlayer.PlayerGui:FindFirstChild("Survivor-mob")) then
		virtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
		virtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
	end
end

local function localFunction040(argument071, argument072)
	local localValue147 = argument071.Position
	local localValue148 = (argument072.Parent:FindFirstChild("HumanoidRootPart") or argument072)
	local localValue149 = (localValue148.Position - localValue147)
	local localValue150 = RaycastParams.new()
	localValue150.FilterType = Enum.RaycastFilterType.Blacklist
	localValue150.FilterDescendantsInstances = { argument071.Parent }
	local localValue151 = workspace:Raycast(localValue147, localValue149, localValue150)
	if localValue151 then
		local localValue152 = localValue151.Instance
		if localValue152:IsDescendantOf(argument072.Parent) then
			return "PLAYER", localValue151
		else
			return "BLOCKED", localValue151
		end
	end
	return "NONE", nil
end
local function localFunction041(argument073, argument074)
	local localValue153 = argument073.CFrame.LookVector
	local localValue154 = (argument074.Position - argument073.Position).Unit
	local localValue155 = localValue153:Dot(localValue154)
	return (localValue155 > 0.7), localValue155
end
local function localFunction042(argument075, argument076, argument077)
	local localValue156 = Instance.new("Part")
	localValue156.Anchored = true
	localValue156.CanCollide = false
	localValue156.Material = Enum.Material.Neon
	localValue156.Transparency = 0.3
	if argument077 == "PLAYER" then
		localValue156.Color = Color3.fromRGB(0, 255, 0)
	elseif argument077 == "WALL" then
		localValue156.Color = Color3.fromRGB(255, 255, 0)
	else
		localValue156.Color = Color3.fromRGB(255, 0, 0)
	end
	local localValue157 = argument076.Magnitude
	localValue156.Size = Vector3.new(0.1, 0.1, localValue157)
	localValue156.CFrame = (
		CFrame.new(argument075, (argument075 + argument076)) * CFrame.new(0, 0, (-localValue157 / 2))
	)
	localValue156.Parent = workspace
	game:GetService("Debris"):AddItem(localValue156, 0.1)
end
local function localFunction043(argument078, argument079)
	return (argument078.Position - argument079.Position).Magnitude
end
local function localFunction044(argument080, argument081)
	for _, item044 in pairs(argument081) do
		if string.find(argument080.Animation.AnimationId, item044) then
			return true
		end
	end
	return false
end
local function localFunction045()
	for index013 = 1, 3 do
		game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("Items")
			:WaitForChild("Parrying Dagger")
			:WaitForChild("parry")
			:FireServer()
		localFunction039()
	end
end
game:GetService("RunService").RenderStepped:Connect(function()
	local character = localPlayer4.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	local localValue158 = localFunction034()
	if not localValue158 then
		return
	end
	local humanoidRootPart2 = localValue158:FindFirstChild("HumanoidRootPart")
	local humanoid = localValue158:FindFirstChild("Humanoid")
	if not humanoidRootPart2 or not humanoid then
		return
	end
	local localValue159 = localFunction043(humanoidRootPart, humanoidRootPart2)
	local localValue160 = humanoid:GetPlayingAnimationTracks()
	for _, item045 in pairs(localValue160) do
		if localFunction044(item045, data6.Special.Dash) and (localValue159 <= numberValue) then
			local localValue161, localValue162 = localFunction041(humanoidRootPart2, humanoidRootPart)
			local localValue163, localValue164 = localFunction040(humanoidRootPart2, humanoidRootPart)
			local localValue165 = (humanoidRootPart.Position - humanoidRootPart2.Position)
			localFunction042(humanoidRootPart2.Position, localValue165, localValue163)
			if localValue161 and (localValue163 == "PLAYER") then
				print("✅ มอง + ไม่ติดกำแพง | Dot:", localValue162)
				localFunction045()
				warn("⚡ GOD MODE DASH READ")
				return
			end
		end
		if _G.CheckLunge then
			if localFunction044(item045, data6.DefaultLunge.Lunge) and (localValue159 <= numberValue2) then
				local localValue166, localValue167 = localFunction041(humanoidRootPart2, humanoidRootPart)
				local localValue168, localValue169 = localFunction040(humanoidRootPart2, humanoidRootPart)
				local localValue170 = (humanoidRootPart.Position - humanoidRootPart2.Position)
				localFunction042(humanoidRootPart2.Position, localValue170, localValue168)
				if localValue166 and (localValue168 == "PLAYER") then
					localFunction045()
					warn("🛡️ PARRY LUNGE")
					return
				end
			end
		end
		if _G.CheckAttack then
			if
				(
					localFunction044(item045, data6.DefaultLunge.Attack)
					or localFunction044(item045, data6.NoLunge.Attack)
				) and (localValue159 <= numberValue2)
			then
				local localValue171, localValue172 = localFunction041(humanoidRootPart2, humanoidRootPart)
				local localValue173, localValue174 = localFunction040(humanoidRootPart2, humanoidRootPart)
				local localValue175 = (humanoidRootPart.Position - humanoidRootPart2.Position)
				localFunction042(humanoidRootPart2.Position, localValue175, localValue173)
				if localValue171 and (localValue173 == "PLAYER") then
					localFunction045()
					warn("⚔️ PARRY ATTACK")
					return
				end
			end
		end
	end
end)
workspaceService.ChildAdded:Connect(function(argument082)
	if not _G.UseHitbox then
		return
	end
	local character = game.Players.LocalPlayer.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	if localFunction037(argument082) then
		local localValue176 = localFunction034()
		if not localValue176 then
			return
		end
		local humanoidRootPart2 = localValue176:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return
		end
		local localValue177 = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude
		if localFunction038(argument082, humanoidRootPart) or (localValue177 <= numberValue2) then
			localFunction045()
			warn("🟥 PARRY (HITBOX DETECTED)")
		end
	end
end)
_G.CheckLunge = (_G.save.AutoParry or false)
_G.CheckAttack = (_G.save.AutoParry or false)
_G.UseHitbox = (_G.save.AutoParry or false)
local parrySection = getgenv().Survivors:CreateSection("Parry")
parrySection:Toggle("Auto Parry\nออโต้บล็อค", (_G.save.AutoParry or false), function(argument083)
	_G.save.AutoParry = argument083
	saveSettings()
	if argument083 and _G.save.AutoParry then
		_G.CheckLunge = true
		_G.CheckAttack = true
		_G.UseHitbox = true
	elseif not argument083 and not _G.save.AutoParry then
		_G.CheckLunge = false
		_G.CheckAttack = false
		_G.UseHitbox = false
	end
end)
local survivorSpeedSection = getgenv().Survivors:CreateSection("Survivor Speed")
spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait(0.2) do
		local instance = workspace:FindFirstChild(localPlayer4.Name)
		if (instance and localPlayer4.Team) and (localPlayer4.Team.Name ~= "Killer") then
			if _G.save.EnableRunSpeed then
				if instance:GetAttribute("speedboost") ~= _G.save.RunSpeed then
					instance:SetAttribute("speedboost", _G.save.RunSpeed)
				end
			end
			if _G.save.EnableVaultSpeed then
				if instance:GetAttribute("vaultspeed") ~= _G.save.VaultSpeed then
					instance:SetAttribute("vaultspeed", _G.save.VaultSpeed)
				end
			end
		end
	end
end))
getgenv().UIRegistry["RunSpeed"] = survivorSpeedSection:Slider({
	Name = "Run Speed\nความเร็ววิ่ง",
	Min = 0.1,
	Max = 10,
	Value = (_G.save.RunSpeed or 1),
	Callback = function(argument084)
		_G.save.RunSpeed = argument084
		saveSettings()
	end,
})
getgenv().UIRegistry["EnableRunSpeed"] = survivorSpeedSection:Toggle(
	"Enable Run Speed\nเปิดใช้ความเร็ววิ่ง",
	(_G.save.EnableRunSpeed or false),
	function(argument085)
		_G.save.EnableRunSpeed = argument085
		saveSettings()
	end
)
getgenv().UIRegistry["VaultSpeed"] = survivorSpeedSection:Slider({
	Name = "Vault Speed\nความเร็วข้ามหน้าต่าง",
	Min = 0.1,
	Max = 10,
	Value = (_G.save.VaultSpeed or 1),
	Callback = function(argument086)
		_G.save.VaultSpeed = argument086
		saveSettings()
	end,
})
getgenv().UIRegistry["EnableVaultSpeed"] = survivorSpeedSection:Toggle(
	"Enable Vault Speed\nเปิดใช้ความเร็วข้าม",
	(_G.save.EnableVaultSpeed or false),
	function(argument087)
		_G.save.EnableVaultSpeed = argument087
		saveSettings()
	end
)
local flashlightProtectionSection = getgenv().Killer:CreateSection("Flashlight Protection")
getgenv().UIRegistry["NoFlashBlind"] = flashlightProtectionSection:Toggle(
	"No Flash Blind\nไม่โดนแฟลชไฟฉาย",
	(_G.save.NoFlashBlind or false),
	function(argument088)
		_G.save.NoFlashBlind = argument088
		local localPlayer5 = game:GetService("Players").LocalPlayer
		local localValue178 = localPlayer5:GetAttribute("SelectedKiller")
		local instance = localPlayer5.PlayerGui:FindFirstChild(localValue178)
		if instance and instance:FindFirstChild("Blind") then
			instance.Blind.Visible = not argument088
		end
		saveSettings()
	end
)
local killerSpeedSettingsSection = getgenv().Killer:CreateSection("Killer Speed Settings")
spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait(0.2) do
		if localPlayer4.Team or (localPlayer4.Team.Name ~= "Killer") then
			local instance = workspace:FindFirstChild(localPlayer4.Name)
			if instance then
				if _G.save.EnableRunSpeed then
					if instance:GetAttribute("speedboost") ~= _G.save.RunSpeed then
						instance:SetAttribute("speedboost", _G.save.RunSpeed)
					end
				end
				if _G.save.EnableBreakSpeed then
					if instance:GetAttribute("breakspeed") ~= _G.save.BreakSpeed then
						instance:SetAttribute("breakspeed", _G.save.BreakSpeed)
					end
				end
			end
		end
	end
end))
getgenv().UIRegistry["RunSpeed"] = killerSpeedSettingsSection:Slider({
	Name = "Run Speed\nความเร็ววิ่ง",
	Min = 1,
	Max = 1000,
	Value = (_G.save.RunSpeed or 1),
	Callback = function(argument089)
		_G.save.RunSpeed = argument089
		saveSettings()
	end,
})
getgenv().UIRegistry["EnableRunSpeed"] = killerSpeedSettingsSection:Toggle(
	"Enable Run Speed\nเปิดใช้ความเร็ววิ่ง",
	(_G.save.EnableRunSpeed or false),
	function(argument090)
		_G.save.EnableRunSpeed = argument090
		saveSettings()
	end
)
getgenv().UIRegistry["BreakSpeed"] = killerSpeedSettingsSection:Slider({
	Name = "Break Speed\nความเร็วทำลาย",
	Min = 1,
	Max = 1000,
	Value = (_G.save.BreakSpeed or 1),
	Callback = function(argument091)
		_G.save.BreakSpeed = argument091
		saveSettings()
	end,
})
getgenv().UIRegistry["EnableBreakSpeed"] = killerSpeedSettingsSection:Toggle(
	"Enable Break Speed\nเปิดใช้ความเร็วทำลาย",
	(_G.save.EnableBreakSpeed or false),
	function(argument092)
		_G.save.EnableBreakSpeed = argument092
		saveSettings()
	end
)
local antiStunSystemSection = getgenv().Killer:CreateSection("Anti Stun System")
local textValue3 = "92125118598365"
local isEnabled4 = false
local function localFunction046(argument093)
	local humanoid = argument093:WaitForChild("Humanoid")
	humanoid.AnimationPlayed:Connect(function(argument094)
		if not isEnabled4 then
			return
		end
		local localValue179 = argument094.Animation
		if not localValue179 then
			return
		end
		local localValue180 = (localValue179.AnimationId or "")
		if string.find(localValue180, textValue3) then
			argument094:AdjustSpeed(5)
			print("⛔ Skip Stun Anim:", localValue180)
		end
	end)
	spawn(LPH_NO_VIRTUALIZE(function()
		while argument093 and argument093.Parent do
			task.wait(0.2)
			if isEnabled4 then
				local localValue181 = argument093:GetAttribute("speedboost")
				if localValue181 and (localValue181 < 1) then
					argument093:SetAttribute("speedboost", 1)
				end
				if argument093:GetAttribute("Immobile") then
					argument093:SetAttribute("Immobile", false)
				end
				if argument093:GetAttribute("IsStunned") then
					argument093:SetAttribute("IsStunned", false)
				end
			end
		end
	end))
end
getgenv().UIRegistry["AntiStun"] = antiStunSystemSection:Toggle(
	"Enable Anti Stun\nป้องกันสตัน/หยุด",
	(_G.save.AntiStun or false),
	function(argument095)
		_G.save.AntiStun = argument095
		isEnabled4 = argument095
		saveSettings()
	end
)
if localPlayer4.Character then
	localFunction046(localPlayer4.Character)
end
localPlayer4.CharacterAdded:Connect(function(argument096)
	localFunction046(argument096)
end)
local aimbotSurvivorsSection = getgenv().Killer:CreateSection("AimbotSurvivors")
local playersService5 = game:GetService("Players")
local localPlayer5 = playersService5.LocalPlayer
_G.save.NEAR_DISTANCE = (_G.save.NEAR_DISTANCE or 15)
local numberValue3 = 1
local numberValue4 = 0.2
local function localFunction047()
	local localValue182, localValue183 = nil, _G.save.NEAR_DISTANCE
	local character = localPlayer5.Character
	local localValue184 = (character and character:FindFirstChild("HumanoidRootPart"))
	if not localValue184 then
		return nil
	end
	for _, item046 in pairs(playersService5:GetPlayers()) do
		if ((item046 ~= localPlayer5) and item046.Team) and string.lower(item046.Team.Name):find("survivor") then
			local character2 = item046.Character
			local localValue185 = (character2 and character2:FindFirstChild("HumanoidRootPart"))
			local localValue186 = (character2 and character2:FindFirstChildOfClass("Humanoid"))
			if (localValue185 and localValue186) and (localValue186.Health > 0) then
				local localValue187 = (localValue185.Position - localValue184.Position).Magnitude
				if (localValue187 < localValue183) and (localValue187 > numberValue3) then
					localValue182 = character2
					localValue183 = localValue187
				end
			end
		end
	end
	return localValue182
end
local function localFunction048(argument097, argument098)
	local localValue188 = RaycastParams.new()
	localValue188.FilterType = Enum.RaycastFilterType.Exclude
	localValue188.FilterDescendantsInstances = { localPlayer5.Character, workspace.CurrentCamera }
	local localValue189 =
		workspace:Raycast(argument098.Position, (argument097.Position - argument098.Position), localValue188)
	return (not localValue189 or localValue189.Instance:IsDescendantOf(argument097.Parent))
end
local localValue190
localValue190 = hookmetamethod(
	game,
	"__index",
	newcclosure(function(self, argument099)
		if checkcaller() then
			return localValue190(self, argument099)
		end
		if (argument099 ~= "CFrame") or not (self:IsA("Camera")) then
			return localValue190(self, argument099)
		end
		if not _G.save.AimbotPlayers then
			return localValue190(self, argument099)
		end
		local character = localPlayer5.Character
		local localValue191 = (character and character:FindFirstChild("HumanoidRootPart"))
		if not localValue191 then
			return localValue190(self, argument099)
		end
		if localPlayer5.Team and (localPlayer5.Team.Name == "Survivors") then
			return localValue190(self, argument099)
		end
		local instance = workspace:FindFirstChild(localPlayer5.Name)
		if instance and instance:GetAttribute("IsCarrying") then
			return localValue190(self, argument099)
		end
		local localValue192 = character:FindFirstChildOfClass("Humanoid")
		if not localValue192 then
			return localValue190(self, argument099)
		end
		local isEnabled5 = false
		for _, item047 in pairs(localValue192:GetPlayingAnimationTracks()) do
			if
				(
					(
						localFunction044(item047, data6.Special.Dash)
						or localFunction044(item047, data6.DefaultLunge.Lunge)
					) or localFunction044(item047, data6.DefaultLunge.Attack)
				) or localFunction044(item047, data6.NoLunge.Attack)
			then
				isEnabled5 = true
				break
			end
		end
		if not isEnabled5 then
			return localValue190(self, argument099)
		end
		local localValue193 = localFunction047()
		if not localValue193 then
			return localValue190(self, argument099)
		end
		if localValue193:GetAttribute("IsHooked") == true then
			return localValue190(self, argument099)
		end
		if localValue193:GetAttribute("Knocked") == true then
			return localValue190(self, argument099)
		end
		if localValue193:GetAttribute("IsCarried") == true then
			return localValue190(self, argument099)
		end
		local head = localValue193:FindFirstChild("Head")
		if not head then
			return localValue190(self, argument099)
		end
		if not (localFunction048(head, localValue191)) then
			return localValue190(self, argument099)
		end
		local localValue194 = localValue190(self, "CFrame")
		local localValue195 = CFrame.new(localValue194.Position, head.Position)
		return localValue194:Lerp(localValue195, numberValue4)
	end)
)
getgenv().UIRegistry["NEAR_DISTANCE"] = aimbotSurvivorsSection:Slider({
	Name = "Lock Distance\nระยะล็อคเป้าหมาย",
	Min = 1,
	Max = 150,
	Value = (_G.save.NEAR_DISTANCE or 15),
	Callback = function(argument100)
		_G.save.NEAR_DISTANCE = argument100
		saveSettings()
	end,
})
getgenv().UIRegistry["AimbotPlayers"] = aimbotSurvivorsSection:Toggle(
	"AimbotSurvivors\nอิมบอทผู้รอดชีวิต",
	(_G.save.AimbotPlayers or false),
	function(argument101)
		_G.save.AimbotPlayers = argument101
		saveSettings()
	end
)
local data8 = {
	"Alex",
	"Brandon",
	"Cobra",
	"Rabbit",
	"Richter",
	"Richard",
	"Tony",
}
local killerTheMaskedSection = getgenv().Killer:CreateSection("Killer : The Masked")
getgenv().UIRegistry["SelectMask"] = killerTheMaskedSection:Dropdown(
	"Select Mask\nเลือกหน้ากาก",
	_G.SelectMask,
	data8,
	function(argument102)
		_G.SelectMask = argument102
	end
)
killerTheMaskedSection:Button("Use Mask Power", function()
	game:GetService("ReplicatedStorage")
		:WaitForChild("Remotes")
		:WaitForChild("Killers")
		:WaitForChild("Masked")
		:WaitForChild("Activatepower")
		:FireServer(_G.SelectMask)
end)
_G.save.EnabledESP = (_G.save.EnabledESP or false)
_G.save.ESP = (
	_G.save.ESP
	or {
		Selected = {},
		Generator = false,
		Gate = false,
		Hook = false,
		Pallet = false,
		Window = false,
		Killer = false,
		Survivor = false,
	}
)
local map = workspace:WaitForChild("Map")
local playersService6 = game:GetService("Players")
local localPlayer6 = playersService6.LocalPlayer
local data9 = {}
local numberValue5 = 0.5
local localValue196 = math.huge
local data10 = { Generator = {}, Hook = {}, Gate = {}, Pallet = {}, Window = {} }
local function localFunction049(argument103)
	if argument103 <= 50 then
		return Color3.fromRGB(255, math.floor((argument103 * 5.1)), 0)
	else
		return Color3.fromRGB(math.floor((255 - ((argument103 - 50) * 5.1))), 255, 0)
	end
end
local function localFunction050(argument104)
	return (argument104:IsA("Model") and (argument104.Name == "Generator"))
end
local function localFunction051(argument105)
	return (argument105:IsA("Model") and (argument105.Name == "Hook"))
end
local function localFunction052(argument106)
	return ((argument106:IsA("Model") and (argument106.Name == "Gate")) and argument106:FindFirstChild("ExitLever"))
end
local function localFunction053(argument107)
	return (argument107.Name == "Palletwrong")
end
local function localFunction054(argument108)
	return (((argument108.Name == "Bottom") and argument108.Parent) and (argument108.Parent.Name == "Window"))
end

local function localFunction055(argument109)
	if argument109:FindFirstChild("GeneratorESP") then
		return
	end
	for _, item048 in ipairs(argument109:GetChildren()) do
		if item048:IsA("Highlight") then
			item048:Destroy()
		end
	end
	local localValue197 = (argument109.PrimaryPart or argument109:FindFirstChildWhichIsA("BasePart"))
	if not localValue197 then
		return
	end
	local localValue198 = Instance.new("Highlight")
	localValue198.Name = "GeneratorESP"
	localValue198.FillTransparency = 0.4
	localValue198.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	localValue198.Parent = argument109
	local localValue199 = Instance.new("BillboardGui", argument109)
	localValue199.Name = "GeneratorBillboard"
	localValue199.Adornee = localValue197
	localValue199.Size = UDim2.fromOffset(90, 35)
	localValue199.StudsOffset = Vector3.new(0, 3, 0)
	localValue199.AlwaysOnTop = true
	local localValue200 = Instance.new("Frame", localValue199)
	localValue200.Size = UDim2.fromScale(1, 1)
	localValue200.BackgroundTransparency = 1
	localValue200.BorderSizePixel = 0
	Instance.new("UICorner", localValue200).CornerRadius = UDim.new(0, 6)
	local localValue201 = Instance.new("Frame", localValue200)
	localValue201.Size = UDim2.new(0.9, 0, 0.2, 0)
	localValue201.Position = UDim2.new(0.05, 0, 0.3, 0)
	localValue201.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	localValue201.BorderSizePixel = 0
	Instance.new("UICorner", localValue201).CornerRadius = UDim.new(1, 0)
	local localValue202 = Instance.new("Frame", localValue201)
	localValue202.Name = "Fill"
	localValue202.BorderSizePixel = 0
	Instance.new("UICorner", localValue202).CornerRadius = UDim.new(1, 0)
	local localValue203 = Instance.new("TextLabel", localValue200)
	localValue203.Size = UDim2.new(1, 0, 0.3, 0)
	localValue203.BackgroundTransparency = 1
	localValue203.TextScaled = true
	localValue203.Font = Enum.Font.GothamBold
	localValue203.TextColor3 = Color3.new(1, 1, 1)
	local function localFunction056()
		local localValue204 = math.floor((argument109:GetAttribute("RepairProgress") or 0))
		if (localValue204 >= 100) or not _G.save.ESP.Generator then
			if localValue198.Parent then
				localValue198:Destroy()
			end
			if localValue199.Parent then
				localValue199:Destroy()
			end
			return
		end
		local localValue205 = localFunction049(localValue204)
		localValue198.FillColor = localValue205
		localValue202.Size = UDim2.new((localValue204 / 100), 0, 1, 0)
		localValue202.BackgroundColor3 = localValue205
		localValue203.Text = ("⚙️ " .. (localValue204 .. "%"))
	end
	localFunction056()
	argument109:GetAttributeChangedSignal("RepairProgress"):Connect(localFunction056)
end
local function localFunction057(argument110)
	if argument110:FindFirstChild("HookESP") or not _G.save.ESP.Hook then
		return
	end
	for _, item049 in ipairs(argument110:GetChildren()) do
		if item049:IsA("Highlight") then
			item049:Destroy()
		end
	end
	local localValue206 = Instance.new("Highlight")
	localValue206.Name = "HookESP"
	localValue206.FillColor = Color3.fromRGB(255, 255, 255)
	localValue206.FillTransparency = 0.5
	localValue206.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	localValue206.Parent = argument110
end
local function localFunction058(argument111)
	if argument111:FindFirstChild("GateESP") or not _G.save.ESP.Gate then
		return
	end
	for _, item050 in ipairs(argument111:GetChildren()) do
		if item050:IsA("Highlight") then
			item050:Destroy()
		end
	end
	local localValue207 = Instance.new("Highlight")
	localValue207.Name = "GateESP"
	localValue207.FillTransparency = 0.4
	localValue207.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	localValue207.Parent = argument111
	local localValue208 = (argument111.PrimaryPart or argument111:FindFirstChildWhichIsA("BasePart"))
	if not localValue208 then
		return
	end
	local localValue209 = Instance.new("BillboardGui", argument111)
	localValue209.Name = "GateBillboard"
	localValue209.Size = UDim2.fromOffset(100, 40)
	localValue209.Adornee = localValue208
	localValue209.StudsOffset = Vector3.new(0, 3, 0)
	localValue209.AlwaysOnTop = true
	local localValue210 = Instance.new("Frame", localValue209)
	localValue210.Size = UDim2.fromScale(1, 1)
	localValue210.BackgroundTransparency = 1
	local localValue211 = Instance.new("TextLabel", localValue210)
	localValue211.Size = UDim2.new(1, 0, 1, 0)
	localValue211.BackgroundTransparency = 1
	localValue211.TextScaled = true
	localValue211.Font = Enum.Font.GothamBold
	localValue211.TextColor3 = Color3.new(1, 1, 1)
	localValue211.TextXAlignment = Enum.TextXAlignment.Center
	local exitLever = argument111:FindFirstChild("ExitLever")
	local function localFunction059()
		if not argument111.Parent or not _G.save.ESP.Gate then
			return
		end
		local localValue212 = localFunction022(argument111)
		localValue207.FillColor = localFunction049(localValue212)
		localValue211.Text = (localValue212 .. "%")
	end
	localFunction059()
	if exitLever then
		exitLever:GetAttributeChangedSignal("Progress"):Connect(localFunction059)
	end
end
local function localFunction060(argument112)
	if not _G.save.ESP.Pallet or argument112:FindFirstChild("PalletESP") then
		return
	end
	for _, item051 in ipairs(argument112:GetChildren()) do
		if item051:IsA("Highlight") then
			item051:Destroy()
		end
	end
	local localValue213 = Instance.new("Highlight")
	localValue213.Name = "PalletESP"
	localValue213.FillColor = Color3.fromRGB(255, 255, 0)
	localValue213.FillTransparency = 0.5
	localValue213.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	localValue213.Parent = argument112
end
local function localFunction061(argument113)
	if not _G.save.ESP.Window or argument113:FindFirstChild("WindowESP") then
		return
	end
	for _, item052 in ipairs(argument113:GetChildren()) do
		if item052:IsA("Highlight") then
			item052:Destroy()
		end
	end
	argument113.Transparency = 0
	local localValue214 = Instance.new("Highlight")
	localValue214.Name = "WindowESP"
	localValue214.FillColor = Color3.fromRGB(255, 255, 0)
	localValue214.FillTransparency = 0.3
	localValue214.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	localValue214.Parent = argument113
end
local function localFunction062()
	for _, item053 in pairs(map:GetDescendants()) do
		if localFunction050(item053) then
			table.insert(data10.Generator, item053)
		elseif localFunction051(item053) then
			table.insert(data10.Hook, item053)
		elseif localFunction052(item053) then
			table.insert(data10.Gate, item053)
		elseif localFunction053(item053) then
			table.insert(data10.Pallet, item053)
		elseif localFunction054(item053) then
			table.insert(data10.Window, item053)
		end
	end
end
local function localFunction063()
	for _, item054 in ipairs(data10.Generator) do
		localFunction055(item054)
	end
	for _, item055 in ipairs(data10.Hook) do
		localFunction057(item055)
	end
	for _, item056 in ipairs(data10.Gate) do
		localFunction058(item056)
	end
	for _, item057 in ipairs(data10.Pallet) do
		localFunction060(item057)
	end
	for _, item058 in ipairs(data10.Window) do
		localFunction061(item058)
	end
end
local function localFunction064()
	local data11 = {}
	for _, item059 in pairs(data10) do
		for _, item060 in ipairs(item059) do
			table.insert(data11, item060)
		end
	end
	for _, item061 in ipairs(data11) do
		if item061 and item061.Parent then
			for _, item062 in ipairs(item061:GetChildren()) do
				if item062:IsA("Highlight") and item062.Name:find("ESP") then
					item062:Destroy()
				end
			end
			if item061:FindFirstChild("GeneratorBillboard") then
				item061.GeneratorBillboard:Destroy()
			end
			if item061:FindFirstChild("GateBillboard") then
				item061.GateBillboard:Destroy()
			end
		end
	end
end
map.DescendantAdded:Connect(function(argument114)
	if localFunction050(argument114) then
		table.insert(data10.Generator, argument114)
		if _G.save.EnabledESP then
			localFunction055(argument114)
		end
	elseif localFunction051(argument114) then
		table.insert(data10.Hook, argument114)
		if _G.save.EnabledESP then
			localFunction057(argument114)
		end
	elseif localFunction052(argument114) then
		table.insert(data10.Gate, argument114)
		if _G.save.EnabledESP then
			localFunction058(argument114)
		end
	elseif localFunction053(argument114) then
		table.insert(data10.Pallet, argument114)
		if _G.save.EnabledESP then
			localFunction060(argument114)
		end
	elseif localFunction054(argument114) then
		table.insert(data10.Window, argument114)
		if _G.save.EnabledESP then
			localFunction061(argument114)
		end
	end
end)
local function localFunction065(argument115)
	if not _G.save.EnabledESP then
		return false
	end
	return (_G.save.ESP.Killer or _G.save.ESP.Survivor)
end
local function localFunction066(argument116)
	if (argument116 == localPlayer6) or data9[argument116] then
		return
	end
	local character = argument116.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	local localValue215 = Instance.new("Highlight")
	localValue215.Name = "PlayerESP"
	localValue215.FillTransparency = 0.5
	localValue215.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	localValue215.Enabled = false
	localValue215.Parent = character
	local localValue216 = Instance.new("BillboardGui")
	localValue216.Name = "PlayerBillboard"
	localValue216.Adornee = humanoidRootPart
	localValue216.Size = UDim2.fromOffset(180, 70)
	localValue216.StudsOffset = Vector3.new(0, 3, 0)
	localValue216.AlwaysOnTop = true
	localValue216.Enabled = false
	localValue216.Parent = character
	local localValue217 = Instance.new("TextLabel")
	localValue217.BackgroundTransparency = 1
	localValue217.Size = UDim2.fromScale(1, 1)
	localValue217.Font = Enum.Font.Code
	localValue217.TextSize = 14
	localValue217.RichText = true
	localValue217.TextStrokeTransparency = 0
	localValue217.Parent = localValue216
	data9[argument116] = { Highlight = localValue215, Billboard = localValue216, Label = localValue217 }
end
local function localFunction067(argument117)
	local localValue218 = data9[argument117]
	if not localValue218 then
		return
	end
	if localValue218.Highlight and localValue218.Highlight.Parent then
		localValue218.Highlight:Destroy()
	end
	if localValue218.Billboard and localValue218.Billboard.Parent then
		localValue218.Billboard:Destroy()
	end
	data9[argument117] = nil
end
local function localFunction068(argument118)
	local localValue219 = data9[argument118]
	if not localValue219 then
		return
	end
	local character = argument118.Character
	local character2 = localPlayer6.Character
	if not character or not character2 then
		localValue219.Highlight.Enabled = false
		localValue219.Billboard.Enabled = false
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart or not humanoidRootPart2 then
		localValue219.Highlight.Enabled = false
		localValue219.Billboard.Enabled = false
		return
	end
	local localValue220 = localFunction065(argument118)
	localValue219.Highlight.Enabled = localValue220
	localValue219.Billboard.Enabled = localValue220
	if not localValue220 then
		return
	end
	local localValue221 = math.floor((humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude)
	local localValue222 = argument118.TeamColor.Color
	localValue219.Highlight.FillColor = localValue222
	localValue219.Label.TextColor3 = localValue222
	localValue219.Label.Text =
		string.format("<b>%s</b>\n%s\n%dM", argument118.Name, argument118.Team.Name, localValue221)
end
local function localFunction069(argument119)
	if argument119 == localPlayer6 then
		return
	end
	argument119.CharacterAdded:Connect(function()
		task.wait(1)
		localFunction067(argument119)
		localFunction066(argument119)
	end)
	argument119.CharacterRemoving:Connect(function()
		localFunction067(argument119)
	end)
	if argument119.Character then
		localFunction066(argument119)
	end
end
local function localFunction070()
	local data11 = {}
	for index014, item063 in pairs(data9) do
		if item063.Highlight and item063.Highlight.Parent then
			item063.Highlight:Destroy()
		end
		if item063.Billboard and item063.Billboard.Parent then
			item063.Billboard:Destroy()
		end
		table.insert(data11, index014)
	end
	for _, item064 in ipairs(data11) do
		data9[item064] = nil
	end
end
local function localFunction071()
	localFunction064()
	localFunction070()
end
localFunction062()
if _G.save.EnabledESP then
	localFunction063()
end
for _, item065 in ipairs(playersService6:GetPlayers()) do
	localFunction069(item065)
end
playersService6.PlayerAdded:Connect(localFunction069)
playersService6.PlayerRemoving:Connect(localFunction067)
task.spawn(function()
	while task.wait(numberValue5) do
		for index015 in pairs(data9) do
			localFunction068(index015)
		end
	end
end)
local eSPSection = getgenv().SK:CreateSection("ESP")
eSPSection:Toggle(
	"Enabled ESP\nเปิดใช้งาน ESP",
	(_G.save.EnabledESP or false),
	function(argument120)
		_G.save.EnabledESP = argument120
		if argument120 then
			local localValue223 = (_G.save.ESP.Selected or {})
			for index016 in pairs(_G.save.ESP) do
				if index016 ~= "Selected" then
					_G.save.ESP[index016] = false
				end
			end
			for _, item066 in ipairs(localValue223) do
				_G.save.ESP[item066] = true
			end
			localFunction063()
			for _, item067 in pairs(playersService6:GetPlayers()) do
				localFunction066(item067)
			end
		else
			for index017 in pairs(_G.save.ESP) do
				if index017 ~= "Selected" then
					_G.save.ESP[index017] = false
				end
			end
			localFunction071()
		end
		saveSettings()
	end
)
eSPSection:MultiDropdown(
	"Select ESP\nเลือกสิ่งที่จะแสดง",
	(_G.save.ESP.Selected or {}),
	{
		"Generator",
		"Gate",
		"Hook",
		"Pallet",
		"Window",
		"Killer",
		"Survivor",
	},
	function(argument121)
		_G.save.ESP.Selected = argument121
		for index018 in pairs(_G.save.ESP) do
			if index018 ~= "Selected" then
				_G.save.ESP[index018] = false
			end
		end
		localFunction071()
		for _, item068 in ipairs(argument121) do
			_G.save.ESP[item068] = true
		end
		if _G.save.EnabledESP then
			localFunction063()
			for _, item069 in pairs(playersService6:GetPlayers()) do
				localFunction066(item069)
			end
		end
		saveSettings()
	end
)
local moonwalkSection = getgenv().SK:CreateSection("Moonwalk")
_G.save.Keybindmoonwalk = (_G.save.Keybindmoonwalk or Enum.KeyCode.R)
_G.save.EnabledMoonWalk = (_G.save.EnabledMoonWalk or false)
local playersService7 = game:GetService("Players")
local userInputService3 = game:GetService("UserInputService")
local runService3 = game:GetService("RunService")
local replicatedStorage3 = game:GetService("ReplicatedStorage")
local localPlayer7 = playersService7.LocalPlayer
local updateCharacterLook = replicatedStorage3.Remotes.Game:WaitForChild("UpdateCharacterLook")
local numberValue6 = 0
local isEnabled5 = false
local function localFunction072(argument122, argument123)
	if numberValue6 == 1 then
		return -argument122
	elseif numberValue6 == 2 then
		return -argument123
	elseif numberValue6 == 3 then
		return argument123
	elseif numberValue6 == 4 then
		return argument122
	end
end
local function localFunction073()
	local character = localPlayer7.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.AutoRotate = false
	end
	if not isEnabled5 then
		isEnabled5 = true
		runService3:BindToRenderStep("Moonwalk", (Enum.RenderPriority.Camera.Value + 10), function()
			if not _G.save.EnabledMoonWalk or (numberValue6 == 0) then
				return
			end
			local character2 = localPlayer7.Character
			if not character2 then
				return
			end
			local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return
			end
			local currentCamera = workspace.CurrentCamera
			local localValue224 = currentCamera.CFrame.LookVector
			local localValue225 = currentCamera.CFrame.RightVector
			local localValue226 = localFunction072(localValue224, localValue225)
			if not localValue226 then
				return
			end
			humanoidRootPart.CFrame = CFrame.new(
				humanoidRootPart.Position,
				(humanoidRootPart.Position + Vector3.new(localValue226.X, 0, localValue226.Z))
			)
		end)
	end
end
local function localFunction074()
	local character = localPlayer7.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.AutoRotate = true
	end
	if isEnabled5 then
		isEnabled5 = false
		runService3:UnbindFromRenderStep("Moonwalk")
	end
end
local function localFunction075()
	if not _G.save.EnabledMoonWalk then
		return
	end
	numberValue6 = (numberValue6 + 1)
	if numberValue6 > 4 then
		numberValue6 = 0
	end
	if numberValue6 == 0 then
		_G.save.EnabledMoonWalk = false
		print("🔴 OFF")
		localFunction074()
	else
		print("🟢 Mode:", numberValue6)
		localFunction073()
	end
end
userInputService3.InputBegan:Connect(function(argument124, argument125)
	if argument125 then
		return
	end
	if not _G.save.EnabledMoonWalk then
		return
	end
	if argument124.KeyCode == _G.save.Keybindmoonwalk then
		localFunction075()
	end
end)
local userInputService4 = game:GetService("UserInputService")
local playerGui = localPlayer7:WaitForChild("PlayerGui")
local localValue227 = nil
local isEnabled6 = false
function FrameToggleEnabledDisabled()
	isEnabled6 = not isEnabled6
	if localValue227 then
		localValue227.Enabled = isEnabled6
		return
	end
	local tweenServiceService = game:GetService("TweenService")
	local localValue228 = Instance.new("ScreenGui")
	localValue228.Name = "MoonwalkMobileUI"
	localValue228.Parent = playerGui
	localValue228.ResetOnSpawn = false
	localValue228.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	localValue227 = localValue228
	local localValue229 = Instance.new("Frame")
	localValue229.Size = UDim2.new(0, 160, 0, 56)
	localValue229.Position = UDim2.new(0.05, 0, 0.4, 0)
	localValue229.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	localValue229.BackgroundTransparency = 0.1
	localValue229.BorderSizePixel = 0
	localValue229.Parent = localValue228
	local localValue230 = Instance.new("UICorner")
	localValue230.CornerRadius = UDim.new(0, 16)
	localValue230.Parent = localValue229
	local localValue231 = Instance.new("UIStroke")
	localValue231.Color = Color3.fromRGB(255, 255, 255)
	localValue231.Transparency = 0.85
	localValue231.Thickness = 1
	localValue231.Parent = localValue229
	local localValue232 = Instance.new("Frame")
	localValue232.Size = UDim2.new(0, 8, 0, 8)
	localValue232.Position = UDim2.new(0, 16, 0.5, -4)
	localValue232.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
	localValue232.BorderSizePixel = 0
	localValue232.Parent = localValue229
	local localValue233 = Instance.new("UICorner")
	localValue233.CornerRadius = UDim.new(1, 0)
	localValue233.Parent = localValue232
	local localValue234 = Instance.new("TextLabel")
	localValue234.Size = UDim2.new(1, -40, 1, 0)
	localValue234.Position = UDim2.new(0, 32, 0, 0)
	localValue234.BackgroundTransparency = 1
	localValue234.Text = "Moonwalk : OFF"
	localValue234.TextColor3 = Color3.fromRGB(180, 180, 190)
	localValue234.TextScaled = false
	localValue234.TextSize = 14
	localValue234.Font = Enum.Font.GothamMedium
	localValue234.TextXAlignment = Enum.TextXAlignment.Left
	localValue234.Parent = localValue229
	local localValue235 = Instance.new("TextButton")
	localValue235.Size = UDim2.new(1, 0, 1, 0)
	localValue235.Position = UDim2.new(0, 0, 0, 0)
	localValue235.BackgroundTransparency = 1
	localValue235.Text = ""
	localValue235.Parent = localValue229
	local localValue236 = Instance.new("Frame")
	localValue236.Size = UDim2.new(0, 20, 0, 20)
	localValue236.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	localValue236.BackgroundTransparency = 0.4
	localValue236.BorderSizePixel = 0
	localValue236.Parent = localValue228
	local localValue237 = Instance.new("UICorner")
	localValue237.CornerRadius = UDim.new(1, 0)
	localValue237.Parent = localValue236
	local localValue238 = Instance.new("TextLabel")
	localValue238.Size = UDim2.new(1, 0, 1, 0)
	localValue238.BackgroundTransparency = 1
	localValue238.Text = "↔"
	localValue238.TextColor3 = Color3.fromRGB(200, 200, 210)
	localValue238.TextSize = 10
	localValue238.Font = Enum.Font.GothamBold
	localValue238.Parent = localValue236
	local function localFunction076()
		localValue236.Position = UDim2.new(
			localValue229.Position.X.Scale,
			((localValue229.Position.X.Offset + localValue229.Size.X.Offset) - 10),
			localValue229.Position.Y.Scale,
			((localValue229.Position.Y.Offset + localValue229.Size.Y.Offset) - 10)
		)
	end
	localFunction076()
	local function localFunction077()
		if numberValue6 == 0 then
			localValue234.Text = "Moonwalk : OFF"
			localValue234.TextColor3 = Color3.fromRGB(160, 160, 170)
			localValue232.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
			tweenServiceService
				:Create(localValue229, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(18, 18, 22) })
				:Play()
			tweenServiceService
				:Create(
					localValue231,
					TweenInfo.new(0.2),
					{ Color = Color3.fromRGB(255, 255, 255), Transparency = 0.85 }
				)
				:Play()
		else
			localValue234.Text = ("Mode : " .. numberValue6)
			localValue234.TextColor3 = Color3.fromRGB(100, 240, 160)
			localValue232.BackgroundColor3 = Color3.fromRGB(60, 220, 120)
			tweenServiceService
				:Create(localValue229, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(10, 30, 20),
				})
				:Play()
			tweenServiceService
				:Create(localValue231, TweenInfo.new(0.2), {
					Color = Color3.fromRGB(60, 220, 120),
					Transparency = 0.5,
				})
				:Play()
		end
	end
	localValue235.MouseButton1Click:Connect(function()
		local localValue239 = localValue229.Size
		tweenServiceService
			:Create(localValue229, TweenInfo.new(0.07, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0, (localValue239.X.Offset - 8), 0, (localValue239.Y.Offset - 4)),
			})
			:Play()
		task.wait(0.07)
		tweenServiceService
			:Create(
				localValue229,
				TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
				{ Size = localValue239 }
			)
			:Play()
		if not _G.save.EnabledMoonWalk then
			_G.save.EnabledMoonWalk = true
		end
		localFunction075()
		localFunction077()
	end)
	local isEnabled7, localValue240, localValue241, localValue242 = false, nil, nil, nil
	localValue235.InputBegan:Connect(function(argument126)
		if
			(argument126.UserInputType == Enum.UserInputType.MouseButton1)
			or (argument126.UserInputType == Enum.UserInputType.Touch)
		then
			isEnabled7 = true
			localValue241 = argument126.Position
			localValue242 = localValue229.Position
			argument126.Changed:Connect(function()
				if argument126.UserInputState == Enum.UserInputState.End then
					isEnabled7 = false
				end
			end)
		end
	end)
	localValue235.InputChanged:Connect(function(argument127)
		if
			(argument127.UserInputType == Enum.UserInputType.MouseMovement)
			or (argument127.UserInputType == Enum.UserInputType.Touch)
		then
			localValue240 = argument127
		end
	end)
	userInputService4.InputChanged:Connect(function(argument128)
		if (argument128 == localValue240) and isEnabled7 then
			local localValue243 = (argument128.Position - localValue241)
			localValue229.Position = UDim2.new(
				localValue242.X.Scale,
				(localValue242.X.Offset + localValue243.X),
				localValue242.Y.Scale,
				(localValue242.Y.Offset + localValue243.Y)
			)
			localFunction076()
		end
	end)
	local isEnabled8, localValue244, localValue245 = false, nil, nil
	localValue236.InputBegan:Connect(function(argument129)
		if
			(argument129.UserInputType == Enum.UserInputType.MouseButton1)
			or (argument129.UserInputType == Enum.UserInputType.Touch)
		then
			isEnabled8 = true
			localValue244 = argument129.Position
			localValue245 = localValue229.Size
			argument129.Changed:Connect(function()
				if argument129.UserInputState == Enum.UserInputState.End then
					isEnabled8 = false
				end
			end)
		end
	end)
	userInputService4.InputChanged:Connect(function(argument130)
		if isEnabled8 then
			local localValue246 = (argument130.Position - localValue244)
			local localValue247 = math.clamp((localValue245.X.Offset + localValue246.X), 120, 280)
			local localValue248 = math.clamp((localValue245.Y.Offset + localValue246.Y), 44, 110)
			localValue229.Size = UDim2.new(0, localValue247, 0, localValue248)
			localValue234.TextSize = math.clamp((localValue248 * 0.25), 12, 18)
			localFunction076()
		end
	end)
	localFunction077()
end
getgenv().UIRegistry["Keybindmoonwalk"] = moonwalkSection:Keybind(
	"Keybind Moonwalk\nคีย์ลัดมูนวอค",
	(tostring(_G.save.Keybindmoonwalk) or ""),
	function(argument131)
		_G.save.Keybindmoonwalk = argument131
	end
)
moonwalkSection:Button(
	"Button Toggle Moonwalk(Mobile)\nปุ่มเปิดปิดมูนวอค(สำหรับมือถือ)",
	function()
		FrameToggleEnabledDisabled()
	end
)
getgenv().UIRegistry["EnabledMoonWalk"] = moonwalkSection:Toggle(
	"Enabled Moonwalk\nเปิดใช้งานมูนวอค",
	(_G.save.EnabledMoonWalk or false),
	function(argument132)
		_G.save.EnabledMoonWalk = argument132
		saveSettings()
		if not argument132 then
			numberValue6 = 0
			localFunction074()
		end
	end
)
getgenv().Players = game:GetService("Players")
getgenv().UserInputService = game:GetService("UserInputService")
getgenv().RunService = game:GetService("RunService")
getgenv().TweenService = game:GetService("TweenService")
getgenv().Lighting = game:GetService("Lighting")
getgenv().HttpService = game:GetService("HttpService")
getgenv().TeleportService = game:GetService("TeleportService")
getgenv().LocalPlayer = getgenv().Players.LocalPlayer
getgenv().Camera = workspace.CurrentCamera
getgenv().Connections = {}
getgenv().Terrain = workspace.Terrain
getgenv().Character = nil
getgenv().HumanoidRootPart = nil
function SafeInitCharacter(argument133)
	if not argument133 then
		return
	end
	local humanoidRootPart = argument133:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	getgenv().Character = argument133
	getgenv().HumanoidRootPart = humanoidRootPart
end
local character = getgenv().LocalPlayer.Character
if character then
	SafeInitCharacter(character)
end
getgenv().updateCharacterReferences = function(argument134)
	SafeInitCharacter(argument134)
end
getgenv().Connections.characterAdded = getgenv().LocalPlayer.CharacterAdded:Connect(function(argument135)
	SafeInitCharacter(argument135)
end)
getgenv().getHumanoid = function()
	return (getgenv().Character and getgenv().Character:FindFirstChildOfClass("Humanoid"))
end
getgenv().Misc = hub:CreateTab("Other", "Misc", "gear", "Other")
getgenv().Char = Misc:CreateSection({
	Name = "Character",
	Side = "Left",
})
_G.FlyEnabled = (_G.save.FlyEnabled or false)
_G.QEFlyEnabled = (_G.save.QEFlyEnabled ~= false)
_G.FlySpeed = (_G.save.FlySpeed or 1)
getgenv().IsOnMobile =
	table.find({ Enum.Platform.IOS, Enum.Platform.Android }, getgenv().UserInputService:GetPlatform())
getgenv().FLYING = false
getgenv().flyConnections = {}
getgenv().cleanupFlyConnections = function()
	for _, item070 in pairs(getgenv().flyConnections) do
		if item070 then
			item070:Disconnect()
		end
	end
	getgenv().flyConnections = {}
end
getgenv().getRoot = function(argument136)
	return (argument136 and argument136:FindFirstChild("HumanoidRootPart"))
end
getgenv().StopFly = function()
	getgenv().FLYING = false
	getgenv().cleanupFlyConnections()
	local localValue249 = getgenv().getRoot(getgenv().Character)
	if localValue249 then
		local bodyVelocity = localValue249:FindFirstChild("BodyVelocity")
		local bodyGyro = localValue249:FindFirstChild("BodyGyro")
		if bodyVelocity then
			bodyVelocity:Destroy()
		end
		if bodyGyro then
			bodyGyro:Destroy()
		end
	end
	local localValue250 = getgenv().getHumanoid()
	if localValue250 then
		localValue250.PlatformStand = false
	end
	if getgenv().Camera then
		getgenv().Camera.CameraType = Enum.CameraType.Custom
	end
end
getgenv().StartFly = function(argument137)
	getgenv().StopFly()
	if not getgenv().Character then
		getgenv().LocalPlayer.CharacterAdded:Wait()
	end
	local localValue251 = getgenv().getRoot(getgenv().Character)
	local localValue252 = getgenv().getHumanoid()
	if not localValue251 or not localValue252 then
		return
	end
	getgenv().FLYING = true
	local data11 = {
		F = 0,
		B = 0,
		L = 0,
		R = 0,
		Q = 0,
		E = 0,
	}
	local data12 = {
		F = 0,
		B = 0,
		L = 0,
		R = 0,
		Q = 0,
		E = 0,
	}
	local numberValue7 = 0
	local localValue253 = Instance.new("BodyGyro")
	localValue253.Name = "BodyGyro"
	localValue253.P = 9e4
	localValue253.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	localValue253.CFrame = localValue251.CFrame
	localValue253.Parent = localValue251
	local localValue254 = Instance.new("BodyVelocity")
	localValue254.Name = "BodyVelocity"
	localValue254.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	localValue254.Velocity = Vector3.new(0, 0, 0)
	localValue254.Parent = localValue251
	getgenv().flyConnections.flyLoop = getgenv().RunService.Heartbeat:Connect(function()
		if not getgenv().FLYING or not localValue251.Parent then
			getgenv().StopFly()
			return
		end
		if not argument137 then
			localValue252.PlatformStand = true
		end
		if (((data11.L + data11.R) ~= 0) or ((data11.F + data11.B) ~= 0)) or ((data11.Q + data11.E) ~= 0) then
			numberValue7 = 50
		elseif numberValue7 ~= 0 then
			numberValue7 = 0
		end
		if (((data11.L + data11.R) ~= 0) or ((data11.F + data11.B) ~= 0)) or ((data11.Q + data11.E) ~= 0) then
			local localValue255 = getgenv().Camera.CFrame
			localValue254.Velocity = (
				(
					(localValue255.LookVector * (data11.F + data11.B))
					+ (
						(
							localValue255
							* CFrame.new(
								(data11.L + data11.R),
								((((data11.F + data11.B) + data11.Q) + data11.E) * 0.2),
								0
							).Position
						) - localValue255.Position
					)
				) * numberValue7
			)
			data12 = { F = data11.F, B = data11.B, L = data11.L, R = data11.R, Q = data11.Q, E = data11.E }
		elseif numberValue7 ~= 0 then
			local localValue256 = getgenv().Camera.CFrame
			localValue254.Velocity = (
				(
					(localValue256.LookVector * (data12.F + data12.B))
					+ (
						(
							localValue256
							* CFrame.new(
								(data12.L + data12.R),
								((((data12.F + data12.B) + data12.Q) + data12.E) * 0.2),
								0
							).Position
						) - localValue256.Position
					)
				) * numberValue7
			)
		else
			localValue254.Velocity = Vector3.new(0, 0, 0)
		end
		localValue253.CFrame = getgenv().Camera.CFrame
	end)
	getgenv().flyConnections.keyDown = getgenv().UserInputService.InputBegan:Connect(function(argument138, argument139)
		if not getgenv().FLYING or argument139 then
			return
		end
		local localValue257 = argument138.KeyCode
		local localValue258 = ((argument137 and _G.VFlySpeed) or _G.FlySpeed)
		if localValue257 == Enum.KeyCode.W then
			data11.F = localValue258
		elseif localValue257 == Enum.KeyCode.S then
			data11.B = -localValue258
		elseif localValue257 == Enum.KeyCode.A then
			data11.L = -localValue258
		elseif localValue257 == Enum.KeyCode.D then
			data11.R = localValue258
		elseif _G.QEFlyEnabled and (localValue257 == Enum.KeyCode.E) then
			data11.Q = (localValue258 * 2)
		elseif _G.QEFlyEnabled and (localValue257 == Enum.KeyCode.Q) then
			data11.E = (-localValue258 * 2)
		end
		getgenv().Camera.CameraType = Enum.CameraType.Track
	end)
	getgenv().flyConnections.keyUp = getgenv().UserInputService.InputEnded:Connect(function(argument140)
		if not getgenv().FLYING then
			return
		end
		local localValue259 = argument140.KeyCode
		if localValue259 == Enum.KeyCode.W then
			data11.F = 0
		elseif localValue259 == Enum.KeyCode.S then
			data11.B = 0
		elseif localValue259 == Enum.KeyCode.A then
			data11.L = 0
		elseif localValue259 == Enum.KeyCode.D then
			data11.R = 0
		elseif localValue259 == Enum.KeyCode.E then
			data11.Q = 0
		elseif localValue259 == Enum.KeyCode.Q then
			data11.E = 0
		end
	end)
end
getgenv().StartMobileFly = function(argument141)
	getgenv().StopFly()
	if not getgenv().Character then
		getgenv().LocalPlayer.CharacterAdded:Wait()
	end
	local localValue260 = getgenv().getRoot(getgenv().Character)
	local localValue261 = getgenv().getHumanoid()
	if not localValue260 or not localValue261 then
		return
	end
	getgenv().FLYING = true
	local localValue262 = Vector3.new(9e9, 9e9, 9e9)
	local localValue263 = Vector3.new(0, 0, 0)
	local localValue264 = Instance.new("BodyVelocity")
	localValue264.Name = "BodyVelocity"
	localValue264.MaxForce = localValue263
	localValue264.Velocity = localValue263
	localValue264.Parent = localValue260
	local localValue265 = Instance.new("BodyGyro")
	localValue265.Name = "BodyGyro"
	localValue265.MaxTorque = localValue262
	localValue265.P = 1000
	localValue265.D = 50
	localValue265.Parent = localValue260
	local localValue266 =
		require(getgenv().LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	getgenv().flyConnections.mobileLoop = getgenv().RunService.Heartbeat:Connect(function()
		if not getgenv().FLYING then
			getgenv().StopFly()
			return
		end
		local localValue267 = getgenv().getRoot(getgenv().Character)
		local localValue268 = getgenv().getHumanoid()
		if not localValue267 or not localValue268 then
			return
		end
		local bodyVelocity = localValue267:FindFirstChild("BodyVelocity")
		local bodyGyro = localValue267:FindFirstChild("BodyGyro")
		if not bodyVelocity or not bodyGyro then
			return
		end
		bodyVelocity.MaxForce = localValue262
		bodyGyro.MaxTorque = localValue262
		if not argument141 then
			localValue268.PlatformStand = true
		end
		bodyGyro.CFrame = getgenv().Camera.CFrame
		bodyVelocity.Velocity = localValue263
		local localValue269 = ((argument141 and _G.VFlySpeed) or _G.FlySpeed)
		local localValue270 = localValue266:GetMoveVector()
		local localValue271 = getgenv().Camera.CFrame
		if localValue270.Magnitude > 0 then
			bodyVelocity.Velocity = (
				(localValue271.RightVector * ((localValue270.X * localValue269) * 50))
				- (localValue271.LookVector * ((localValue270.Z * localValue269) * 50))
			)
		end
	end)
end
getgenv().ToggleFly = function(argument142)
	if (argument142 and _G.VFlyEnabled) or (not argument142 and _G.FlyEnabled) then
		if getgenv().IsOnMobile then
			getgenv().StartMobileFly(argument142)
		else
			getgenv().StartFly(argument142)
		end
	else
		getgenv().StopFly()
	end
end
getgenv().UIRegistry["Fly"] = Char:Toggle("Fly\nบิน", (_G.save.FlyEnabled or false), function(argument143)
	_G.FlyEnabled = argument143
	_G.save.FlyEnabled = argument143
	saveSettings()
	getgenv().ToggleFly(false)
end)
getgenv().UIRegistry["QEFly"] = Char:Toggle(
	"QE Fly\nบินขึ้น/ลงด้วย Q/E",
	(_G.save.QEFlyEnabled ~= false),
	function(argument144)
		_G.QEFlyEnabled = argument144
		_G.save.QEFlyEnabled = argument144
		saveSettings()
	end
)
getgenv().UIRegistry["FlySpeed"] = Char:Slider({
	Name = "Fly Speed\nความเร็วการบิน",
	Min = 0.1,
	Max = 10,
	Value = (_G.save.FlySpeed or 1),
	Callback = function(argument145)
		_G.FlySpeed = argument145
		_G.save.FlySpeed = argument145
		saveSettings()
	end,
})
getgenv().TeleportData = { isAltDown = false, enabled = false }
getgenv().UIRegistry["ClickTeleport"] = Char:Toggle(
	"Click Teleport (Alt + Click)\nคลิกเทเลพอร์ต (Alt + Click)",
	getgenv().TeleportData.enabled,
	function(argument146)
		getgenv().TeleportData.enabled = argument146
		if getgenv().Connections.teleportInput then
			getgenv().Connections.teleportInput:Disconnect()
		end
		if getgenv().Connections.teleportEnd then
			getgenv().Connections.teleportEnd:Disconnect()
		end
		if argument146 then
			getgenv().Connections.teleportInput = getgenv().UserInputService.InputBegan:Connect(
				function(argument147, argument148)
					if argument148 then
						return
					end
					if argument147.KeyCode == Enum.KeyCode.LeftAlt then
						getgenv().TeleportData.isAltDown = true
					elseif
						(argument147.UserInputType == Enum.UserInputType.MouseButton1)
						and getgenv().TeleportData.isAltDown
					then
						if not getgenv().HumanoidRootPart then
							return
						end
						local localValue272 = getgenv().LocalPlayer:GetMouse()
						local localValue273 = getgenv().Camera:ScreenPointToRay(localValue272.X, localValue272.Y)
						local localValue274 = RaycastParams.new()
						localValue274.FilterDescendantsInstances = { getgenv().Character }
						localValue274.FilterType = Enum.RaycastFilterType.Blacklist
						local localValue275 =
							workspace:Raycast(localValue273.Origin, (localValue273.Direction * 1000), localValue274)
						if localValue275 and getgenv().HumanoidRootPart then
							getgenv().HumanoidRootPart.CFrame =
								CFrame.new((localValue275.Position + Vector3.new(0, 3, 0)))
						end
					end
				end
			)
			getgenv().Connections.teleportEnd = getgenv().UserInputService.InputEnded:Connect(function(argument149)
				if argument149.KeyCode == Enum.KeyCode.LeftAlt then
					getgenv().TeleportData.isAltDown = false
				end
			end)
		end
	end
)
getgenv().UIRegistry["Noclip"] = Char:Toggle(
	"Noclip\nเดินทะลุ",
	(_G.save.Noclip or false),
	function(argument150)
		_G.Noclip = argument150
		_G.save.Noclip = argument150
		saveSettings()
	end
)
task.spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait() do
		if _G.Noclip and getgenv().Character then
			for _, item071 in pairs(getgenv().Character:GetDescendants()) do
				if item071:IsA("BasePart") then
					item071.CanCollide = false
				end
			end
		end
	end
end))
local uiSection = Misc:CreateSection({
	Name = "Qof",
	Side = "Right",
})
getgenv().UIRegistry["BlackScreen"] = uiSection:Toggle(
	"Black Screen\nจอดำช่วยลดการทำงานของเครื่อง",
	(_G.save.BlackScreen or false),
	function(argument151)
		_G.save.BlackScreen = argument151
		saveSettings()
		_G.BlackScreen = argument151
		local localPlayer8 = game.Players.LocalPlayer
		local playerGui2 = localPlayer8:WaitForChild("PlayerGui")
		local blackScreenOverlay = playerGui2:FindFirstChild("BlackScreenOverlay")
		if argument151 then
			if not blackScreenOverlay then
				blackScreenOverlay = Instance.new("ScreenGui")
				blackScreenOverlay.Name = "BlackScreenOverlay"
				blackScreenOverlay.IgnoreGuiInset = true
				blackScreenOverlay.DisplayOrder = 9999
				blackScreenOverlay.ResetOnSpawn = false
				blackScreenOverlay.Parent = playerGui2
			end
			local blackFrame = blackScreenOverlay:FindFirstChild("BlackFrame")
			if not blackFrame then
				blackFrame = Instance.new("Frame")
				blackFrame.Name = "BlackFrame"
				blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
				blackFrame.BorderSizePixel = 0
				blackFrame.Size = UDim2.new(1, 0, 1, 0)
				blackFrame.Position = UDim2.new(0, 0, 0, 0)
				blackFrame.ZIndex = 10
				blackFrame.Parent = blackScreenOverlay
			end
			blackFrame.Visible = true
			game:GetService("RunService"):Set3dRenderingEnabled(false)
		else
			if blackScreenOverlay then
				local blackFrame = blackScreenOverlay:FindFirstChild("BlackFrame")
				if blackFrame then
					blackFrame.Visible = false
				end
			end
			game:GetService("RunService"):Set3dRenderingEnabled(true)
		end
	end
)
getgenv().UIRegistry["WhiteScreen"] = uiSection:Toggle(
	"White Screen\nจอขาวช่วยลดการทำงานของเครื่อง",
	(_G.save.WhiteScreen or false),
	function(argument152)
		_G.WhiteScreen = argument152
		_G.save.WhiteScreen = argument152
		saveSettings()
		getgenv().RunService:Set3dRenderingEnabled(not argument152)
	end
)
local otherTab = hub:CreateTab("Other", "Servers", "square3Layers3d", "Other")
local otherTab2 = hub:CreateTab("Other", "Appearance", "paintbrush", "Other")
local uiSection2 = otherTab:CreateSection({
	Name = "Server",
	Side = "Right",
})
local localValue276 = getgenv().TeleportService
getgenv().LP = getgenv().LocalPlayer
uiSection2:Textbox("JobID\nจ็อบไอดี", (_G.save.JobId_Textbox or ""), function(argument153)
	_G.save.JobId_Textbox = argument153
	saveSettings()
end)
getgenv().UIRegistry["AutoJoinJobID"] = uiSection2:Toggle(
	"Auto Join JobID\nออโต้เข้าจ็อบไอดี",
	(_G.save.AutoJoinJobID or false),
	function(argument154)
		_G.save.AutoJoinJobID = argument154
		saveSettings()
		if argument154 then
			task.spawn(LPH_NO_VIRTUALIZE(function()
				while _G.save.AutoJoinJobID do
					if _G.save.JobId_Textbox and (_G.save.JobId_Textbox ~= "") then
						localValue276:TeleportToPlaceInstance(game.PlaceId, _G.save.JobId_Textbox, localPlayer7)
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = "VectorHub",
							Text = "Success JobID Please Wait",
							Icon = "rbxassetid://16129235054",
							Duration = 3,
						})
					else
						warn(
							"กรุณาใส่ JobID ในช่องก่อนเปิดใช้งาน Auto Join JobID"
						)
						_G.save.AutoJoinJobID = false
						saveSettings()
						break
					end
					task.wait(1)
				end
			end))
		end
	end
)
getgenv().UIRegistry["JoinJobID"] = uiSection2:Button(
	"Join JobID\nเข้าร่วมจ็อบไอดี",
	function()
		localValue276:TeleportToPlaceInstance(game.PlaceId, _G.save.JobId_Textbox, localPlayer7)
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "VectorHub",
			Text = "Success JobID Please Wait",
			Icon = "rbxassetid://16129235054",
			Duration = 3,
		})
	end
)
uiSection2:Button("Copy JobID\nก็อปปี้จ็อบไอดี", function()
	setclipboard(game.JobId)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "VectorHub",
		Text = "Success Copy JobID",
		Icon = "rbxassetid://16129235054",
		Duration = 3,
	})
end)
local basicSection = otherTab:CreateSection("Basic")
basicSection:Button("Rejoin\nเข้าเซิฟเวอร์เดิม", function()
	getgenv().TeleportService:Teleport(game.PlaceId, getgenv().LocalPlayer)
end)
getgenv().ServerHop = function()
	local localValue277 = (
		"https://games.roblox.com/v1/games/" .. (game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
	)
	local decodedData = getgenv().HttpService:JSONDecode(game:HttpGet(localValue277))
	for _, item072 in ipairs((decodedData.data or {})) do
		if item072.playing < item072.maxPlayers then
			getgenv().TeleportService:TeleportToPlaceInstance(game.PlaceId, item072.id, getgenv().Players.LocalPlayer)
			return
		end
	end
end
basicSection:Button("Server Hop\nย้ายไปเซิฟใหม่", function()
	getgenv().ServerHop()
end)
local smartServerSection = otherTab:CreateSection("Smart Server")
smartServerSection:Slider({
	Name = "Max Players Filter\nเลือกจำนวนเพลย์เยอร์",
	Min = 1,
	Max = tonumber(getgenv().Players.MaxPlayers),
	Value = 5,
	Callback = function(argument155)
		_G.SetP = argument155
	end,
})
smartServerSection:Button(
	"Smart Hop\nหาเซิฟเวอร์ที่จำนวนผู้เล่นน้อย",
	function()
		local localValue278 = _G.SetP
		local decodedData = getgenv().HttpService:JSONDecode(
			game:HttpGet(("https://games.roblox.com/v1/games/" .. (game.PlaceId .. "/servers/Public?limit=100")))
		)
		for _, item073 in ipairs((decodedData.data or {})) do
			if item073.playing <= localValue278 then
				getgenv().TeleportService:TeleportToPlaceInstance(game.PlaceId, item073.id, getgenv().LocalPlayer)
				break
			end
		end
	end
)
smartServerSection:Button(
	"Low Ping Hop\nย้ายเซิฟหาเซิฟเวอร์ปิงน้อย",
	function()
		pcall(function()
			local localValue279, localValue280 = nil, math.random(50, 200)
			local decodedData = getgenv().HttpService:JSONDecode(
				game:HttpGet(("https://games.roblox.com/v1/games/" .. (game.PlaceId .. "/servers/Public?limit=100")))
			)
			for _, item074 in ipairs((decodedData.data or {})) do
				local numberValue7 = tonumber(item074.ping)
				if numberValue7 and (numberValue7 < localValue280) then
					localValue280 = numberValue7
					localValue279 = item074.id
				end
			end
			if localValue279 then
				getgenv().TeleportService:TeleportToPlaceInstance(
					game.PlaceId,
					tostring(localValue279),
					getgenv().LocalPlayer
				)
			end
		end)
	end
)
local appearanceSection = otherTab2:CreateSection("Appearance")
local data11 = {}
for index019, _ in pairs(uiLibrary.Themes) do
	table.insert(data11, index019)
end
table.sort(data11)
local data12 = {}
for index020, _ in pairs(uiLibrary.Accents) do
	table.insert(data12, index020)
end
table.sort(data12)
local localValue281 = (_G.save.Theme or "Dark")
local localValue282 = (_G.save.Accent or "Blue")
if uiLibrary.Themes[localValue281] then
	hub._app.Theme = uiLibrary.Themes[localValue281]
end
if uiLibrary.Accents[localValue282] then
	hub._app.Accent = uiLibrary.Accents[localValue282]
end
appearanceSection:Dropdown({
	Name = "Application Theme\nธีม",
	Default = localValue281,
	List = data11,
	Callback = function(argument156)
		if not uiLibrary.Themes[argument156] then
			return
		end
		_G.save.Theme = argument156
		saveSettings()
		hub._app.Theme = uiLibrary.Themes[argument156]
	end,
})
appearanceSection:Dropdown({
	Name = "Application Accent\nโทนสี",
	Default = localValue282,
	List = data12,
	Callback = function(argument157)
		if not uiLibrary.Accents[argument157] then
			return
		end
		_G.save.Accent = argument157
		saveSettings()
		hub._app.Accent = uiLibrary.Accents[argument157]
	end,
})
local advancedSettingsSection = otherTab2:CreateSection("Advanced Settings")
local row = advancedSettingsSection._form:Row({
	SearchIndex = "FPS",
})
local titleStack = row:Left():TitleStack({
	Title = ("FPS ( " .. (tostring(_G.save.FPS) .. " )")),
	Subtitle = "ปรับจำนวนเฟรมเรท",
})
row:Right():Slider({
	Minimum = 1,
	Maximum = 240,
	Value = _G.save.FPS,
	ValueChanged = function(_, argument158)
		argument158 = math.floor(argument158)
		_G.save.FPS = argument158
		saveSettings()
		titleStack.Title = ("FPS ( " .. (argument158 .. " )"))
	end,
})
advancedSettingsSection:Toggle(
	"Set FPS\nปรับเฟรมเรท",
	(_G.save.FPSLOCK or false),
	function(argument159)
		_G.FPSLOCK = argument159
		_G.save.FPSLOCK = argument159
		saveSettings()
	end
)
task.spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait() do
		if _G.FPSLOCK then
			pcall(function()
				setfpscap(_G.save.FPS)
			end)
		else
			setfpscap(math.huge)
		end
	end
end))
advancedSettingsSection:Button("Reset UI Size\nรีเซทขนาดหน้าต่างโปร", function()
	hub._win.Size = (
		(getgenv().UserInputService.TouchEnabled and UDim2.fromOffset(550, 325)) or UDim2.fromOffset(850, 530)
	)
end)
advancedSettingsSection:Toggle(
	"Auto Hide UI\nออโต้ซ่อนหน้าต่างโปร",
	(_G.save.AutoHide or false),
	function(argument160)
		_G.AutoHide = argument160
		_G.save.AutoHide = argument160
		saveSettings()
	end
)
if _G.AutoHide then
	hub._win.Minimized = not hub._win.Minimized
end
task.spawn(LPH_NO_VIRTUALIZE(function()
	local userInputService5 = game:GetService("UserInputService")
	if userInputService5.TouchEnabled then
		return
	end
	repeat
		task.wait()
	until hub and hub._win
	local localValue283 = hub._win
	local function localFunction078()
		if not localValue283.Minimized then
			userInputService5.MouseIconEnabled = true
			userInputService5.MouseBehavior = Enum.MouseBehavior.Default
		end
	end
	if typeof(localValue283) == "Instance" then
		localValue283:GetPropertyChangedSignal("Minimized"):Connect(localFunction078)
		localFunction078()
	else
		while task.wait(0.1) do
			localFunction078()
		end
	end
end))
local inputSection = otherTab2:CreateSection("Input")
inputSection:Keybind(
	"Minimize Shortcut\nปุ่มซ่อนหน้าต่างโปร",
	getgenv().minimizeKeybind,
	getgenv().minimizeKeybind,
	function(argument161)
		getgenv().minimizeKeybind = argument161
	end
)
inputSection:Toggle(
	"Searchable\nการค้นหาฟังก์ชั่น",
	hub._win.Searching,
	function(argument162)
		hub._win.Searching = argument162
	end
)
inputSection:Toggle(
	"Draggable\nการอนุญาตลากหน้าต่างโปร",
	hub._win.Draggable,
	function(argument163)
		hub._win.Draggable = argument163
	end
)
inputSection:Toggle(
	"Resizable\nการอนุญาตปรับขนาดหน้าต่างโปร",
	hub._win.Resizable,
	function(argument164)
		hub._win.Resizable = argument164
	end
)
local effectsSection = otherTab2:CreateSection("Effects")
effectsSection:Toggle(
	"Dropshadow\nมีเงาที่ขอบหน้าต่างโปร",
	hub._win.Dropshadow,
	function(argument165)
		hub._win.Dropshadow = argument165
	end
)
effectsSection:Toggle("Background Blur\nพื้นหลังเบลอ", hub._win.UIBlur, function(argument166)
	hub._win.UIBlur = argument166
end)
getgenv().Config = hub:CreateTab("Config", "Config", "gear", "Config")
getgenv().ConfigSection = Config:CreateSection("Settings-Config")
local textValue4 = "VectorHub/VD/"
local localValue284 = game.Players.LocalPlayer.Name
local data13 = { AutoLoad = false, SelectedConfig = nil }
local function localFunction079()
	local localValue285 = (textValue4 .. (localValue284 .. "_meta.json"))
	if isfile(localValue285) then
		local success, result = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(localValue285))
		end)
		if success and result then
			data13.AutoLoad = (result.AutoLoad or false)
			data13.SelectedConfig = (result.SelectedConfig or nil)
		end
	end
end
local function localFunction080()
	writefile((textValue4 .. (localValue284 .. "_meta.json")), game:GetService("HttpService"):JSONEncode(data13))
end
local function localFunction081()
	local data14 = {}
	for _, item075 in ipairs(listfiles(textValue4)) do
		local localValue286 = item075:match((localValue284 .. "_(.+)%.json$"))
		if localValue286 and (localValue286 ~= "meta") then
			table.insert(data14, localValue286)
		end
	end
	return data14
end
local function localFunction082(argument167)
	if (argument167 == "") or (argument167 == nil) then
		return
	end
	local localValue287 = (textValue4 .. (localValue284 .. ("_" .. (argument167 .. ".json"))))
	writefile(localValue287, game:GetService("HttpService"):JSONEncode(_G.save))
end
local function localFunction083(argument168)
	if argument168 == nil then
		return
	end
	local localValue288 = (textValue4 .. (localValue284 .. ("_" .. (argument168 .. ".json"))))
	if not (isfile(localValue288)) then
		return
	end
	local success, result = pcall(function()
		return game:GetService("HttpService"):JSONDecode(readfile(localValue288))
	end)
	if success and result then
		for index021, item076 in pairs(result) do
			_G.save[index021] = item076
		end
		data13.SelectedConfig = argument168
		localFunction080()
		local localValue289 = getgenv().UIRegistry
		if localValue289 then
			for index022, item077 in pairs(localValue289) do
				if (item077 and item077.SetValue) and (_G.save[index022] ~= nil) then
					item077.SetValue(_G.save[index022])
				end
			end
		end
	end
end
local function localFunction084()
	if data13.SelectedConfig == nil then
		return
	end
	localFunction082(data13.SelectedConfig)
end
local function localFunction085(argument169)
	if argument169 == nil then
		return
	end
	local localValue290 = (textValue4 .. (localValue284 .. ("_" .. (argument169 .. ".json"))))
	if isfile(localValue290) then
		delfile(localValue290)
		if data13.SelectedConfig == argument169 then
			data13.SelectedConfig = nil
			localFunction080()
		end
	end
end
localFunction079()
if data13.AutoLoad and data13.SelectedConfig then
	localFunction083(data13.SelectedConfig)
end
local textValue5 = ""
ConfigSection:Textbox("Config Name\nชื่อ Config", "", function(argument170)
	textValue5 = argument170
end)
ConfigSection:Button("Create Config\nสร้าง Config", function()
	if textValue5 ~= "" then
		localFunction082(textValue5)
		getgenv().configDropdown.Refresh()
	end
end)
getgenv().configDropdown = ConfigSection:Dropdown(
	"Select Config\nเลือก Config\n->",
	(data13.SelectedConfig or ""),
	function()
		return localFunction081()
	end,
	function(argument171)
		data13.SelectedConfig = argument171
		localFunction080()
	end
)
ConfigSection:Button("Refresh Config\nรีเฟรช Config", function()
	getgenv().configDropdown.Refresh()
end)
ConfigSection:Button("Load Config\nโหลด Config", function()
	localFunction083(data13.SelectedConfig)
	getgenv().configDropdown.Refresh()
end)
ConfigSection:Button("Overwrite Config\nเขียนทับ Config", function()
	localFunction084()
	getgenv().configDropdown.Refresh()
end)
ConfigSection:Button("Delete Config\nลบ Config", function()
	localFunction085(data13.SelectedConfig)
	getgenv().configDropdown.Refresh()
end)
ConfigSection:Toggle("Auto Load Config", (data13.AutoLoad or false), function(argument172)
	data13.AutoLoad = argument172
	localFunction080()
end)
if getgenv().LocalPlayer.GameplayPaused then
	getgenv().LocalPlayer.GameplayPaused = false
end
getgenv().LocalPlayer:GetPropertyChangedSignal("GameplayPaused"):Connect(function()
	if getgenv().LocalPlayer.GameplayPaused then
		getgenv().LocalPlayer.GameplayPaused = false
	end
end)
_G.AutoRejoin = true
spawn(LPH_NO_VIRTUALIZE(function()
	while task.wait() do
		if _G.AutoRejoin then
			_G.AutoRejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded
				:Connect(function(argument173)
					if
						((argument173.Name == "ErrorPrompt") and argument173:FindFirstChild("MessageArea"))
						and argument173.MessageArea:FindFirstChild("ErrorFrame")
					then
						game:GetService("TeleportService"):Teleport(game.PlaceId)
					end
				end)
		end
	end
end))
local data14 = { Information = InfoTab, OP = OP, Survivors = Survivors, Killer = Killer, SK = SK, Misc = Misc }
for index023, item078 in pairs(data14) do
	item078._tab.Activated:Connect(function()
		_G.save.LastTab = index023
		saveSettings()
	end)
end
