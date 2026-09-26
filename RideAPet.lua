local RunService = game:GetService("RunService")

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local HttpService = cloneref(game:GetService("HttpService"))

local WindUI

do
	local ok, result = pcall(function()
		return require("./src/Init")
	end)

	if ok then
		WindUI = result
	else
		if cloneref(game:GetService("RunService")):IsStudio() then
			WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
		else
			WindUI =
				loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
		end
	end
end



-- */  Window  /* --
local Window = WindUI:CreateWindow({
	Title = "IOHUB",
	--Author = "by .ftgs • Footagesus",
	Folder = "ftgshub",
	Icon = "solar:folder-2-bold-duotone",
	--Theme = "Mellowsi",
	--IconSize = 22*2,
	NewElements = true,
	--Size = UDim2.fromOffset(700,700),

	HideSearchBar = false,

	OpenButton = {
		Title = "IOHUB", -- can be changed
		CornerRadius = UDim.new(1, 0), -- fully rounded
		StrokeThickness = 3, -- removing outline
		Enabled = true, -- enable or disable openbutton
		Draggable = true,
		OnlyMobile = false,
		Scale = 0.5,

		Color = ColorSequence.new( -- gradient
			Color3.fromHex("#30FF6A"),
			Color3.fromHex("#e7ff2f")
		),
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac", -- Default or Mac
	},
})



-- */  Colors  /* --
local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")


local Tabs = {
MainTab = Window:Tab({
       Title = "Main",
     Icon = "egg",
    Border = true,
   }),
}

-- this is for auto select tab 
-- when script is loaded if not
-- the right panel is empty
task.defer(function()
	Tabs.MainTab:Select()
end)



-- ==================== UI LIBRARY TOGGLE ====================
local isEnabled = false

Tabs.MainTab:Toggle({
	Title = "Instant Prompt",
	Desc = "Make the Prompt Becomes One Tap",
	Value = false,
	Callback = function(state)
		isEnabled = state
		
		-- Function para baguhin ang hold duration ng mga prompt
		local function updatePrompts()
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") then
					if isEnabled then
						-- Ginagawa itong 0 para ma-tap agad nang walang hintayan
						descendant.HoldDuration = 0
					else
						-- Pwede mong ibalik sa default (halimbawa ay 0.5 o kung ano man ang orig)
						-- O kaya ay hayaan na lang kung may sarili silang duration
					end
				end
			end
		end

		updatePrompts()
		
		-- Opsyonal: Para ma-detect din ang mga bagong mag-a-appear na prompt sa laro
		if isEnabled then
			workspace.DescendantAdded:Connect(function(descendant)
				if isEnabled and descendant:IsA("ProximityPrompt") then
					descendant.HoldDuration = 0
				end
			end)
		end
	end,
})

Tabs.MainTab:Space()
--------------------------------------------------
-- AUTO COLLECT EGG (MAIN TAB) - FREE WALK WHEN NO EGG
--------------------------------------------------

_G.SelectedEggTargets = {}
_G.AutoEggEnabled = false

local eggChoicesList = {
    "Cherub Egg",
    "Solaris Egg",
    "Blackhole Egg",
    "Galaxy Egg",
       "Tidal Egg",
    "Volcanic Egg",
    "Bloom Egg",
    "Sinister Egg",
    "Easter Egg",
    "Skull Egg",
    "Aurora Egg",
    "Diamond Egg",
    "Dominus Egg",
    "Flaming Egg",
    "Glass Egg",
    "Cracked Egg",
    "Flower Egg",
    "Soul Egg",
    "Leaf Egg",
    "Mushroom Egg",
    "Stone Egg",
    "Slime Egg",
    "Crystal Egg",
}

-- 1. MULTI-SELECT Dropdown
Tabs.MainTab:Dropdown({
    Title = "Select Egg Target",
    Desc = "Choose One or Multi Eggs to Collect",
    Values = eggChoicesList,
    Value = {},
    AllowNone = true,
    Multi = true,
    Callback = function(selectedTable)
        _G.SelectedEggTargets = {}

        if type(selectedTable) == "table" then
            for key, value in pairs(selectedTable) do
                if type(key) == "number" and type(value) == "string" then
                    _G.SelectedEggTargets[value] = true
                elseif type(key) == "string" and value == true then
                    _G.SelectedEggTargets[key] = true
                end
            end
        end
    end,
})

-- 2. Toggle para sa Auto Collect Egg
Tabs.MainTab:Toggle({
    Title = "Auto Collect Egg",
    Desc = "Automatically Collect the Selected Egg when Spawned",
    Value = false,
    Callback = function(state)
        _G.AutoEggEnabled = state

        if state then
            task.spawn(function()
                local Players = game:GetService("Players")
                local Workspace = game:GetService("Workspace")
                local TweenService = game:GetService("TweenService")
                local player = Players.LocalPlayer

                -- ===== HELPER: Kunin ang plot mo =====
                local function getMyPlot()
                    local plots = Workspace:FindFirstChild("Plots")
                    if not plots then return nil end

                    for _, plot in ipairs(plots:GetChildren()) do
                        local data = plot:FindFirstChild("Data")
                        local owner = data and data:FindFirstChild("Owner")

                        if owner then
                            if owner:IsA("ObjectValue") then
                                if owner.Value == player then
                                    return plot
                                end
                            elseif owner:IsA("StringValue") then
                                if owner.Value == player.Name or owner.Value == player.DisplayName then
                                    return plot
                                end
                            end
                        end
                    end
                    return nil
                end

                -- ===== HELPER: Plot center CFrame =====
                local function getPlotCenterCFrame(plot)
                    if not plot then return nil end

                    if plot.PrimaryPart then
                        return plot.PrimaryPart.CFrame
                    end

                    local hrp = plot:FindFirstChild("HumanoidRootPart", true)
                    if hrp then return hrp.CFrame end

                    for _, partName in ipairs({"Spawn", "Base", "Center", "Home"}) do
                        local part = plot:FindFirstChild(partName, true)
                        if part and part:IsA("BasePart") then
                            return part.CFrame
                        end
                    end

                    local ok, pivot = pcall(function() return plot:GetPivot() end)
                    if ok and pivot then return pivot end

                    for _, desc in ipairs(plot:GetDescendants()) do
                        if desc:IsA("BasePart") then
                            return desc.CFrame
                        end
                    end

                    return nil
                end

                -- ===== HELPER: Tween pabalik sa plot =====
                local function returnToPlot(hrp)
                    local myPlot = getMyPlot()
                    local plotCenter = getPlotCenterCFrame(myPlot)

                    if not plotCenter then return end

                    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = plotCenter + Vector3.new(0, 5, 0)})
                    tween:Play()

                    pcall(function()
                        tween.Completed:Wait()
                    end)

                    task.wait(0.3)
                end

                -- ===== MAIN LOOP =====
                while _G.AutoEggEnabled do
                    task.wait(0.5)

                    if next(_G.SelectedEggTargets) == nil then
                        continue
                    end

                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")

                    if not hrp then
                        task.wait(1)
                        continue
                    end

                    local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
                    if not renderedEggs then
                        task.wait(1)
                        continue
                    end

                    local targetCFrame = nil
                    local foundPrompt = nil

                    -- Hanapin ang egg
                    for _, eggModel in ipairs(renderedEggs:GetChildren()) do
                        if _G.SelectedEggTargets[eggModel.Name] then
                            local pickup = eggModel:FindFirstChild("Pickup", true)

                            if pickup then
                                local targetPart = pickup
                                if pickup:IsA("ProximityPrompt") then
                                    foundPrompt = pickup
                                    targetPart = pickup.Parent
                                elseif not pickup:IsA("BasePart") and not pickup:IsA("Model") then
                                    targetPart = pickup.Parent
                                    foundPrompt = targetPart:FindFirstChildOfClass("ProximityPrompt")
                                else
                                    foundPrompt = eggModel:FindFirstChildOfClass("ProximityPrompt", true)
                                end

                                if targetPart:IsA("Model") then
                                    targetCFrame = targetPart.PrimaryPart and targetPart.PrimaryPart.CFrame or targetPart:GetPivot()
                                elseif targetPart:IsA("BasePart") then
                                    targetCFrame = targetPart.CFrame
                                end

                                if targetCFrame then break end
                            end
                        end
                    end

                    -- ✅ KUNG MAY NAHANAP: tween papunta, fire, uwi sa plot
                    if targetCFrame then
                        local tweenInfo = TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 3, 0)})
                        tween:Play()

                        local success = false
                        pcall(function()
                            tween.Completed:Wait()
                            success = true
                        end)

                        if success and foundPrompt and foundPrompt:IsA("ProximityPrompt") then
                            pcall(function()
                                fireproximityprompt(foundPrompt)
                            end)

                            task.wait(0.3)

                            -- Uwi sa plot PAGKATAPOS MAKUHA
                            returnToPlot(hrp)
                            task.wait(0.5)
                        end
                    end
                    -- ❌ KUNG WALANG NAHANAP: wala tayong gagawin — free walk ka lang
                end
            end)
        end
    end,
})



local Tabs = {
AutomaticallyTab = Window:Tab({
       Title = "Automatically",
     Icon = "workflow",
    Border = true,
   }),
}


-- 2. Auto Upgrade Toggle
-- Global variable para sa Auto Upgrade
_G.AutoUpgradeEnabled = false

Tabs.AutomaticallyTab:Toggle({
    Title = "Auto Upgrade (Max)",
    Desc = "Automatically Max Luck Upgrade",
    Value = false,
    Callback = function(state)
        _G.AutoUpgradeEnabled = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                -- Hanapin ang RemoteEvent para sa Upgrades
                local upgradesEvent = ReplicatedStorage:FindFirstChild("Remotes")
                    and ReplicatedStorage.Remotes:FindFirstChild("Game")
                    and ReplicatedStorage.Remotes.Game:FindFirstChild("Plot")
                    and ReplicatedStorage.Remotes.Game.Plot:FindFirstChild("Upgrades")

                while _G.AutoUpgradeEnabled do
                    task.wait(0.5) -- Interval o bilis ng pag-fire ng server event

                    if upgradesEvent then
                        pcall(function()
                            upgradesEvent:FireServer("Max")
                        end)
                    else
                        -- Sakaling magbago o mag-load pa lang ang path, hahanapin ulit nito
                        upgradesEvent = ReplicatedStorage:FindFirstChild("Remotes")
                            and ReplicatedStorage.Remotes:FindFirstChild("Game")
                            and ReplicatedStorage.Remotes.Game:FindFirstChild("Plot")
                            and ReplicatedStorage.Remotes.Game.Plot:FindFirstChild("Upgrades")
                    end
                end
            end)
        end
    end,
})





local Tabs = {
EventTab = Window:Tab({
       Title = "Event",
     Icon = "calendar-clock",
    Border = true,
   }),
}

--------------------------------------------------
-- CUSTOM EGG TEXT INPUT & FLEXIBLE SEARCH TOGGLE
--------------------------------------------------

_G.CustomEggQuery = ""
_G.AutoCustomEggEnabled = false

-- 1. Custom Text Input para sa pag-type ng keyword
Tabs.EventTab:Input({
    Title = "Custom Egg Name",
    Desc = "example Cherub",
    Callback = function(textValue)
        if textValue and textValue ~= "" then
            _G.CustomEggQuery = textValue:gsub("^%s*(.-)%s*$", "%1"):lower()
        else
            _G.CustomEggQuery = ""
        end
    end,
})

-- 2. Toggle para sa Custom Egg Auto Collect
Tabs.EventTab:Toggle({
    Title = "Turn on Auto Collect Custom Egg",
    Desc = "Automatically Collect the Egg Name You Input",
    Value = false,
    Callback = function(state)
        _G.AutoCustomEggEnabled = state

        if state then
            task.spawn(function()
                local Players = game:GetService("Players")
                local Workspace = game:GetService("Workspace")
                local TweenService = game:GetService("TweenService")
                local player = Players.LocalPlayer

                -- ===== HELPER: Kunin ang plot mo (ObjectValue + StringValue) =====
                local function getMyPlot()
                    local plots = Workspace:FindFirstChild("Plots")
                    if not plots then return nil end

                    for _, plot in ipairs(plots:GetChildren()) do
                        local data = plot:FindFirstChild("Data")
                        local owner = data and data:FindFirstChild("Owner")

                        if owner then
                            if owner:IsA("ObjectValue") then
                                if owner.Value == player then
                                    return plot
                                end
                            elseif owner:IsA("StringValue") then
                                if owner.Value == player.Name or owner.Value == player.DisplayName then
                                    return plot
                                end
                            end
                        end
                    end
                    return nil
                end

                -- ===== HELPER: Plot center CFrame =====
                local function getPlotCenterCFrame(plot)
                    if not plot then return nil end

                    if plot.PrimaryPart then
                        return plot.PrimaryPart.CFrame
                    end

                    local hrp = plot:FindFirstChild("HumanoidRootPart", true)
                    if hrp then return hrp.CFrame end

                    for _, partName in ipairs({"Spawn", "Base", "Center", "Home"}) do
                        local part = plot:FindFirstChild(partName, true)
                        if part and part:IsA("BasePart") then
                            return part.CFrame
                        end
                    end

                    local ok, pivot = pcall(function() return plot:GetPivot() end)
                    if ok and pivot then return pivot end

                    for _, desc in ipairs(plot:GetDescendants()) do
                        if desc:IsA("BasePart") then
                            return desc.CFrame
                        end
                    end

                    return nil
                end

                -- ===== HELPER: Tween pabalik sa plot =====
                local function returnToPlot(hrp)
                    local myPlot = getMyPlot()
                    local plotCenter = getPlotCenterCFrame(myPlot)

                    if not plotCenter then return end

                    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = plotCenter + Vector3.new(0, 5, 0)})
                    tween:Play()

                    pcall(function()
                        tween.Completed:Wait()
                    end)

                    task.wait(0.3)
                end

                -- ===== MAIN LOOP =====
                while _G.AutoCustomEggEnabled do
                    task.wait(0.5)

                    if _G.CustomEggQuery and _G.CustomEggQuery ~= "" then
                        local character = player.Character
                        local hrp = character and character:FindFirstChild("HumanoidRootPart")

                        if not hrp then
                            task.wait(1)
                            continue
                        end

                        local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
                        if not renderedEggs then
                            task.wait(1)
                            continue
                        end

                        local targetCFrame = nil
                        local foundPrompt = nil

                        -- Flexible Search
                        for _, eggModel in ipairs(renderedEggs:GetChildren()) do
                            local modelNameLower = eggModel.Name:lower()

                            if modelNameLower:find(_G.CustomEggQuery, 1, true) then
                                local pickup = eggModel:FindFirstChild("Pickup", true)

                                if pickup then
                                    local targetPart = pickup
                                    if pickup:IsA("ProximityPrompt") then
                                        foundPrompt = pickup
                                        targetPart = pickup.Parent
                                    elseif not pickup:IsA("BasePart") and not pickup:IsA("Model") then
                                        targetPart = pickup.Parent
                                        foundPrompt = targetPart:FindFirstChildOfClass("ProximityPrompt")
                                    else
                                        foundPrompt = eggModel:FindFirstChildOfClass("ProximityPrompt", true)
                                    end

                                    if targetPart:IsA("Model") then
                                        targetCFrame = targetPart.PrimaryPart and targetPart.PrimaryPart.CFrame or targetPart:GetPivot()
                                    elseif targetPart:IsA("BasePart") then
                                        targetCFrame = targetPart.CFrame
                                    end

                                    if targetCFrame then
                                        break
                                    end
                                end
                            end
                        end

                        -- ✅ KUNG MAY NAHANAP: tween papunta, fire, uwi sa plot
                        if targetCFrame then
                            local tweenInfo = TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 3, 0)})
                            tween:Play()

                            local success = false
                            pcall(function()
                                tween.Completed:Wait()
                                success = true
                            end)

                            if success and foundPrompt and foundPrompt:IsA("ProximityPrompt") then
                                pcall(function()
                                    fireproximityprompt(foundPrompt)
                                end)

                                task.wait(0.3)

                                -- Uwi sa plot PAGKATAPOS MAKUHA
                                returnToPlot(hrp)
                                task.wait(0.5)
                            end
                        end
                        -- ❌ KUNG WALANG NAHANAP: free walk lang
                    end
                end
            end)
        end
    end,
})



local Tabs = {
MiscTab = Window:Tab({
       Title = "Misc",
     Icon = "view",
    Border = true,
   }),
}


----------------------------------------------------
-- 1. EGG LISTAHAN AT MULTI-SELECT ESP SETUP (FIXED)
----------------------------------------------------
local Workspace = game:GetService("Workspace")

local eggChoicesList = {
    "Cherub Egg",
    "Solaris Egg",
    "Blackhole Egg",
    "Galaxy Egg",
    "Sinister Egg",
    "Easter Egg",
    "Skull Egg",
    "Aurora Egg",
    "Diamond Egg",
    "Dominus Egg",
    "Flaming Egg",
    "Glass Egg",
    "Cracked Egg",
    "Flower Egg",
    "Soul Egg",
    "Leaf Egg",
    "Mushroom Egg",
    "Stone Egg",
    "Slime Egg",
    "Crystal Egg",
    
      "Tidal Egg",
    "Volcanic Egg",
    "Bloom Egg",
  
    
}

-- Global variables
local selectedEggsMap = {} -- Dictionary para mabilis ang check
local isEggEspOn = false

-- Multi-select Dropdown
Tabs.MiscTab:Dropdown({
    Title = "Select Eggs to ESP",
    Desc = "Choose the Egg You Want",
    Values = eggChoicesList,
    Value = {},
    AllowNone = true,
    Multi = true,
    Callback = function(selectedTable)
        selectedEggsMap = {}

        if type(selectedTable) == "table" then
            for key, value in pairs(selectedTable) do
                if type(key) == "number" and type(value) == "string" then
                    selectedEggsMap[value] = true
                elseif type(key) == "string" and value == true then
                    selectedEggsMap[key] = true
                end
            end
        end
    end,
})

-- Toggle para i-on o i-off ang ESP
Tabs.MiscTab:Toggle({
    Title = "Turn on ESP Eggs",
    Desc = "Highlights the Selected Egg",
    Value = false,
    Callback = function(state)
        isEggEspOn = state

        if state then
            task.spawn(function()
                while isEggEspOn do
                    task.wait(0.5) -- I-refresh para sa mga bagong spawn na itlog

                    -- Kung biglang pinatay habang nag-aantay sa wait, itigil agad ang loop
                    if not isEggEspOn then break end

                    local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
                    if renderedEggs then
                        for _, eggModel in ipairs(renderedEggs:GetChildren()) do
                            -- Suriin kung ang pangalan ng itlog ay nasa loob ng iyong selectedEggsMap
                            if selectedEggsMap[eggModel.Name] then
                                -- Lagyan ng Highlight kung wala pa
                                local highlight = eggModel:FindFirstChild("CustomEggHighlight")
                                if not highlight then
                                    highlight = Instance.new("Highlight")
                                    highlight.Name = "CustomEggHighlight"
                                    highlight.Adornee = eggModel
                                    highlight.FillColor = Color3.fromRGB(0, 255, 128) -- Kulay berde/neon
                                    highlight.FillTransparency = 0.4
                                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    highlight.OutlineTransparency = 0
                                    highlight.Parent = eggModel
                                end

                                -- Lagyan ng BillboardGui para sa Pangalan kung wala pa
                                local billboard = eggModel:FindFirstChild("CustomEggBillboard")
                                if not billboard then
                                    billboard = Instance.new("BillboardGui")
                                    billboard.Name = "CustomEggBillboard"
                                    billboard.Size = UDim2.new(0, 150, 0, 50)
                                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                                    billboard.AlwaysOnTop = true

                                    local textLabel = Instance.new("TextLabel")
                                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                                    textLabel.BackgroundTransparency = 1
                                    textLabel.Text = "[ " .. eggModel.Name .. " ]"
                                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                                    textLabel.TextStrokeTransparency = 0
                                    textLabel.Font = Enum.Font.GothamBold
                                    textLabel.TextSize = 14
                                    textLabel.Parent = billboard

                                    billboard.Adornee = eggModel
                                    billboard.Parent = eggModel
                                end
                            else
                                -- Tanggalin ang ESP kung hindi napili
                                local highlight = eggModel:FindFirstChild("CustomEggHighlight")
                                if highlight then highlight:Destroy() end

                                local billboard = eggModel:FindFirstChild("CustomEggBillboard")
                                if billboard then billboard:Destroy() end
                            end
                        end
                    end
                end

                -- PANGHULING PAGLILINIS kapag huminto ang while loop
                local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
                if renderedEggs then
                    for _, eggModel in ipairs(renderedEggs:GetChildren()) do
                        local highlight = eggModel:FindFirstChild("CustomEggHighlight")
                        if highlight then highlight:Destroy() end

                        local billboard = eggModel:FindFirstChild("CustomEggBillboard")
                        if billboard then billboard:Destroy() end
                    end
                end
            end)
        else
            -- Kapag direktang pinatay ang Toggle, siguruhing false na ang state at burahin agad ang lahat
            isEggEspOn = false

            local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
            if renderedEggs then
                for _, eggModel in ipairs(renderedEggs:GetChildren()) do
                    local highlight = eggModel:FindFirstChild("CustomEggHighlight")
                    if highlight then highlight:Destroy() end

                    local billboard = eggModel:FindFirstChild("CustomEggBillboard")
                    if billboard then billboard:Destroy() end
                end
            end
        end
    end,
})



Tabs.MiscTab:Space()

----------------------------------------------------
-- DISABLE MESSAGE UI TOGGLE SECTION
----------------------------------------------------
_G.DisableGameMessages = false

Tabs.MiscTab:Toggle({
    Title = "Disable Notif",
    Desc = "Hide Notification GUI",
    Value = false,
    Callback = function(state)
        _G.DisableGameMessages = state
        
        task.spawn(function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            
            while _G.DisableGameMessages do
                task.wait(0.5) -- Regular na susuriin para hindi makalusot kung mag-reload ang UI
                
                pcall(function()
                    local playerGui = player:FindFirstChild("PlayerGui")
                    local reusable = playerGui and playerGui:FindFirstChild("Reusable")
                    local gameMessages = reusable and reusable:FindFirstChild("GameMessages")
                    
                    if gameMessages then
                        -- Kung ScreenGui ito, i-disable ang Enabled property
                        if gameMessages:IsA("ScreenGui") then
                            gameMessages.Enabled = false
                        -- Kung GuiObject naman (Frame, etc.), i-set sa Visible = false
                        elseif gameMessages:IsA("GuiObject") then
                            gameMessages.Visible = false
                        end
                        
                        -- Para masigurong pati ang mga laman sa loob ay matago
                        for _, child in ipairs(gameMessages:GetDescendants()) do
                            if child:IsA("GuiObject") then
                                child.Visible = false
                            end
                        end
                    end
                end)
            end
            
            -- Kapag pinatay ang Toggle (Toggle Off), ibalik sa dati ang UI
            pcall(function()
                local playerGui = player:FindFirstChild("PlayerGui")
                local reusable = playerGui and playerGui:FindFirstChild("Reusable")
                local gameMessages = reusable and reusable:FindFirstChild("GameMessages")
                
                if gameMessages then
                    if gameMessages:IsA("ScreenGui") then
                        gameMessages.Enabled = true
                    elseif gameMessages:IsA("GuiObject") then
                        gameMessages.Visible = true
                    end
                    
                    for _, child in ipairs(gameMessages:GetDescendants()) do
                        if child:IsA("GuiObject") then
                            child.Visible = true
                        end
                    end
                end
            end)
        end)
    end,
})











-- Player Section --

local Tabs = {
	PlayerTab = Window:Tab({
		Title = "Player",
		Icon = "user-round-cog",
	}),
}


-- ====================================================================
-- PLAYER ESP TOGGLE (UPDATED WITH DISTANCE & CLEAN UI)
-- ====================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerEspConnection = nil
local renderConnection = nil
local activeBillboards = {}

Tabs.PlayerTab:Toggle({
	Title = "Player ESP",
	Desc = "Highlights other players with distance info",
	Value = false,
	Callback = function(state)
	     -- tanggalin ang lahat ng ESP
		local function clearESP()
			if playerEspConnection then
				playerEspConnection:Disconnect()
				playerEspConnection = nil
			end
			if renderConnection then
				renderConnection:Disconnect()
				renderConnection = nil
			end

			-- Linisin ang highlights at billboards
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character then
					local hl = p.Character:FindFirstChild("PlayerEspHighlight")
					if hl then hl:Destroy() end
				end
			end

			for _, gui in pairs(activeBillboards) do
				if gui then gui:Destroy() end
			end
			activeBillboards = {}
		end

		if state then
	     -- toggle on
			local function setupPlayerESP(targetPlayer)
				if targetPlayer == localPlayer then return end
				
				local function addESP(char)
					if not char then return end
					local tagIdentifier = "PlayerESP_" .. targetPlayer.Name
					
		
					if CoreGui:FindFirstChild(tagIdentifier) then
						CoreGui[tagIdentifier]:Destroy()
					end

					-- highlight para sa buong katawan
					local highlight = char:FindFirstChild("PlayerEspHighlight")
					if not highlight then
						highlight = Instance.new("Highlight")
						highlight.Name = "PlayerEspHighlight"
						highlight.FillColor = Color3.fromRGB(255, 50, 50) -- Reddish tone
						highlight.FillTransparency = 0.5
						highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						highlight.OutlineTransparency = 0
						highlight.Parent = char
					end

					-- name and studs
					local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
					if head then
						local billboard = Instance.new("BillboardGui")
						billboard.Name = tagIdentifier
						billboard.Size = UDim2.new(0, 200, 0, 40)
						billboard.AlwaysOnTop = true
						billboard.ExtentsOffset = Vector3.new(0, 2.8, 0)
						billboard.Adornee = head
						billboard.Parent = CoreGui
						
						local label = Instance.new("TextLabel")
						label.Name = "InfoLabel"
						label.Size = UDim2.new(1, 0, 1, 0)
						label.BackgroundTransparency = 1
						label.TextColor3 = Color3.fromRGB(255, 255, 255)
						label.TextSize = 13
						label.Font = Enum.Font.GothamBold
						label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
						label.TextStrokeTransparency = 0.3
						label.Parent = billboard

						activeBillboards[targetPlayer.Name] = {Gui = billboard, Label = label, TargetChar = char}
					end
				end

				if targetPlayer.Character then
					addESP(targetPlayer.Character)
				end
				
				targetPlayer.CharacterAdded:Connect(function(char)
					if state then
						task.wait(1)
						addESP(char)
					end
				end)
			end

			for _, p in ipairs(Players:GetPlayers()) do
				setupPlayerESP(p)
			end

			playerEspConnection = Players.PlayerAdded:Connect(function(p)
				setupPlayerESP(p)
			end)

		-- real time update 
			renderConnection = RunService.RenderStepped:Connect(function()
				local localChar = localPlayer.Character
				local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")

				for name, data in pairs(activeBillboards) do
					local char = data.TargetChar
					local label = data.Label
					local gui = data.Gui

					if char and char:FindFirstChild("HumanoidRootPart") and localHrp then
						local hrp = char.HumanoidRootPart
						local distance = math.floor((hrp.Position - localHrp.Position).Magnitude)
						label.Text = string.format("%s | %d studs", name, distance)
					else
						if gui then gui.Enabled = false end
					end
				end
			end)

		else
		-- toggle off
			clearESP()
		end
	end,
})


Tabs.PlayerTab:Space()

-- ====================================================================
-- NOCLIP TOGGLE (PLAYER TAB)
-- ====================================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local noclipConnection = nil

Tabs.PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls and obstacles",
    Value = false,
    Callback = function(state)
        if state then
            -- ===== [TOGGLE ON] =====
            if noclipConnection then
                noclipConnection:Disconnect()
            end

            noclipConnection = RunService.Stepped:Connect(function()
                local character = player.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            -- ===== [TOGGLE OFF] =====
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end

            local character = player.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

Tabs.PlayerTab:Space()

-- ====================================================================
-- PATHBUILDER TOGGLE (PLAYER TAB)
-- ====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local lastPos = nil
local fixedY = nil
local pathConnection = nil

Tabs.PlayerTab:Toggle({
    Title = "PathBuilder",
    Desc = "Creates a black path under your feet as you walk (Disappears after 5s)",
    Value = false,
    Callback = function(state)
        if state then
            -- ===== [TOGGLE ON] =====
            lastPos = nil
            fixedY = nil

            pathConnection = RunService.Heartbeat:Connect(function()
                local character = player.Character
                if not character then return end
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                if not rootPart or not humanoid then return end

                local pos = rootPart.Position

                -- Lock Y on first step
                if not fixedY then
                    fixedY = pos.Y - 3.1
                end

                -- Allow Y to change when airborne (jumping/falling)
                local stateType = humanoid:GetState()
                if stateType == Enum.HumanoidStateType.Jumping
                    or stateType == Enum.HumanoidStateType.Freefall
                    or stateType == Enum.HumanoidStateType.Landed then
                    fixedY = pos.Y - 3.1
                end

                local below = Vector3.new(pos.X, fixedY, pos.Z)

                if lastPos then
                    if (pos - lastPos).Magnitude < 2 then return end
                end

                local part = Instance.new("Part")
                part.Name = "BlackPath"
                part.Anchored = true
                part.CanCollide = true
                part.Material = Enum.Material.SmoothPlastic
                part.Color = Color3.fromRGB(0, 0, 0)
                part.TopSurface = Enum.SurfaceType.Smooth
                part.BottomSurface = Enum.SurfaceType.Smooth
                part.CastShadow = true

                if lastPos then
                    local mid = (lastPos + below) / 2
                    local dist = (below - lastPos).Magnitude
                    part.Size = Vector3.new(4, 0.5, dist)
                    part.CFrame = CFrame.lookAt(mid, below)
                else
                    part.Size = Vector3.new(4, 0.5, 4)
                    part.CFrame = CFrame.new(below)
                end

                part.Parent = workspace
                Debris:AddItem(part, 5)
                lastPos = below
            end)
        else
            -- ===== [TOGGLE OFF] =====
            if pathConnection then
                pathConnection:Disconnect()
                pathConnection = nil
            end
            lastPos = nil
            fixedY = nil
        end
    end,
})


Tabs.PlayerTab:Space()

-- ====================================================================
-- FLY SPEED SLIDER (SETTINGS)
-- ====================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local speaker = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Shared state para sa fly
local flyActive = false
local flyConnection = nil
local flyKeyDown, flyKeyUp = nil, nil
local flightSpeed = 0  -- Default na bilis ng lipad (0 = hindi gagalaw)

Tabs.PlayerTab:Slider({
    Title = "Fly Speed",
    Desc = "Adjust Flying Speed",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 0,
        Max = 1000,
        Default = 0,
    },
    Callback = function(value)
        flightSpeed = value
    end,
})

-- ====================================================================
-- FLY TOGGLE (MOBILE & PC FRIENDLY)
-- ====================================================================
Tabs.PlayerTab:Toggle({
    Title = "Fly",
    Desc = "Allows you to Fly",
    Value = false,
    Callback = function(state)
        local char = speaker.Character or speaker.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart") 
            or char:FindFirstChild("Torso") 
            or char:FindFirstChild("UpperTorso")

        if not root or not humanoid then
            return
        end

        local velocityHandlerName = "IYFlyVelocity"
        local gyroHandlerName = "IYFlyGyro"

        if state then
            -- ===== [TOGGLE ON] =====
            flyActive = true

            if root:FindFirstChild(velocityHandlerName) then root[velocityHandlerName]:Destroy() end
            if root:FindFirstChild(gyroHandlerName) then root[gyroHandlerName]:Destroy() end

            local v3zero = Vector3.new(0, 0, 0)
            local v3inf = Vector3.new(9e9, 9e9, 9e9)

            local bv = Instance.new("BodyVelocity")
            bv.Name = velocityHandlerName
            bv.Parent = root
            bv.MaxForce = v3inf
            bv.Velocity = v3zero

            local bg = Instance.new("BodyGyro")
            bg.Name = gyroHandlerName
            bg.Parent = root
            bg.MaxTorque = v3inf
            bg.P = 1000
            bg.D = 50

            humanoid.PlatformStand = true

            local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
            local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}

            if not isMobile then
                flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
                    if processed then return end
                    if input.KeyCode == Enum.KeyCode.W then
                        CONTROL.F = 1
                    elseif input.KeyCode == Enum.KeyCode.S then
                        CONTROL.B = -1
                    elseif input.KeyCode == Enum.KeyCode.A then
                        CONTROL.L = -1
                    elseif input.KeyCode == Enum.KeyCode.D then
                        CONTROL.R = 1
                    elseif input.KeyCode == Enum.KeyCode.E then
                        CONTROL.Q = 1
                    elseif input.KeyCode == Enum.KeyCode.Q then
                        CONTROL.E = -1
                    end
                end)

                flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
                    if processed then return end
                    if input.KeyCode == Enum.KeyCode.W then
                        CONTROL.F = 0
                    elseif input.KeyCode == Enum.KeyCode.S then
                        CONTROL.B = 0
                    elseif input.KeyCode == Enum.KeyCode.A then
                        CONTROL.L = 0
                    elseif input.KeyCode == Enum.KeyCode.D then
                        CONTROL.R = 0
                    elseif input.KeyCode == Enum.KeyCode.E then
                        CONTROL.Q = 0
                    elseif input.KeyCode == Enum.KeyCode.Q then
                        CONTROL.E = 0
                    end
                end)
            end

            local success, controlModule = pcall(function()
                return require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
            end)

            flyConnection = RunService.RenderStepped:Connect(function()
                if not flyActive or not char or not humanoid or humanoid.Health <= 0 then return end

                bg.CFrame = camera.CFrame
                bv.Velocity = v3zero

                if isMobile then
                    if success and controlModule then
                        local moveDirection = controlModule:GetMoveVector()
                        local speedMultiplier = flightSpeed * 5

                        local camCFrame = camera.CFrame
                        local flyVector = Vector3.new(0, 0, 0)

                        if moveDirection.Magnitude > 0 then
                            flyVector = (camCFrame.RightVector * moveDirection.X - camCFrame.LookVector * moveDirection.Z) * speedMultiplier
                        end

                        bv.Velocity = flyVector
                    end
                else
                    bv.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + 
                    ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * (flightSpeed * 15)
                end
            end)
        else
            -- ===== [TOGGLE OFF] =====
            flyActive = false

            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if flyKeyDown then
                flyKeyDown:Disconnect()
                flyKeyDown = nil
            end
            if flyKeyUp then
                flyKeyUp:Disconnect()
                flyKeyUp = nil
            end

            pcall(function()
                if root then
                    if root:FindFirstChild(velocityHandlerName) then root[velocityHandlerName]:Destroy() end
                    if root:FindFirstChild(gyroHandlerName) then root[gyroHandlerName]:Destroy() end
                end
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end)
        end
    end,
})

Tabs.PlayerTab:Space()

-- ====================================================================
-- WALKSPEED SLIDER (PLAYER TAB)
-- ====================================================================
local Players = game:GetService("Players")
local speaker = Players.LocalPlayer

Tabs.PlayerTab:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust your character's walking speed",
    IsTooltip = true,
    IsTextbox = true, -- Pwede mong gawing false kung ayaw mo ng textbox
    Step = 1,
    Value = {
        Min = 0,
        Max = 1000,
        Default = 16, -- 16 ang default walkspeed sa Roblox
    },
    Callback = function(value)
        pcall(function()
            local char = speaker.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = value
                end
            end
        end)
    end,
})




-- Settings Section --

local Tabs = {
	SettingTab = Window:Tab({
		Title = "Setting",
		Icon = "cog",
	}),
}

local Keybind = Tabs.SettingTab:Keybind({
    Title = "UI Keybind",
    Desc = "Keybind to open ui",
    Value = "Z", -- Pinalitaning Z ang default key[span_1](start_span)[span_1](end_span)
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])[span_2](start_span)[span_2](end_span)
    end,
})

-- I-lock ito para hindi na mabago ng user
Keybind:Lock()


-- ====================================================================
-- ANTI-LAG / LOW GRAPHICS TOGGLE (WINDUI VERSION)
-- ====================================================================
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local antilagConnection = nil
local originalSettings = {}

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end)
end

Tabs.SettingTab:Toggle({
    Title = "Anti-Lag / Low Graphics",
    Desc = "Boosts FPS by disabling shadows, particles, and heavy textures",
    Value = false,
    Callback = function(state)
        if state then
            -- ===== [TOGGLE ON] =====
            

            local Terrain = Workspace:FindFirstChildWhichIsA("Terrain")
            if Terrain then
                originalSettings.WaterWaveSize = Terrain.WaterWaveSize
                originalSettings.WaterWaveSpeed = Terrain.WaterWaveSpeed
                originalSettings.WaterReflectance = Terrain.WaterReflectance
                originalSettings.WaterTransparency = Terrain.WaterTransparency
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 1
            end

            originalSettings.GlobalShadows = Lighting.GlobalShadows
            originalSettings.FogEnd = Lighting.FogEnd
            originalSettings.FogStart = Lighting.FogStart
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 9e9

            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    originalSettings[v] = {CastShadow = v.CastShadow, Material = v.Material, Reflectance = v.Reflectance}
                    v.CastShadow = false
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") then
                    if originalSettings[v] == nil then originalSettings[v] = v.Transparency end
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    if originalSettings[v] == nil then originalSettings[v] = v.Lifetime end
                    v.Lifetime = NumberRange.new(0)
                end
            end

            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") then
                    originalSettings[v] = v.Enabled
                    v.Enabled = false
                end
            end

            antilagConnection = Workspace.DescendantAdded:Connect(function(child)
                task.spawn(function()
                    if child:IsA("ForceField") or child:IsA("Sparkles") or child:IsA("Smoke") or child:IsA("Fire") or child:IsA("Beam") then
                        RunService.Heartbeat:Wait()
                        child:Destroy()
                    elseif child:IsA("BasePart") then
                        child.CastShadow = false
                    end
                end)
            end)

            
        else
            -- ===== [TOGGLE OFF] =====
            if antilagConnection then
                antilagConnection:Disconnect()
                antilagConnection = nil
            end

            local Terrain = Workspace:FindFirstChildWhichIsA("Terrain")
            if Terrain and originalSettings.WaterTransparency then
                Terrain.WaterWaveSize = originalSettings.WaterWaveSize
                Terrain.WaterWaveSpeed = originalSettings.WaterWaveSpeed
                Terrain.WaterReflectance = originalSettings.WaterReflectance
                Terrain.WaterTransparency = originalSettings.WaterTransparency
            end

            Lighting.GlobalShadows = originalSettings.GlobalShadows ~= nil and originalSettings.GlobalShadows or true
            Lighting.FogEnd = originalSettings.FogEnd ~= nil and originalSettings.FogEnd or 100000
            Lighting.FogStart = originalSettings.FogStart ~= nil and originalSettings.FogStart or 0

            for _, v in pairs(game:GetDescendants()) do
                if originalSettings[v] then
                    if v:IsA("BasePart") then
                        v.CastShadow = originalSettings[v].CastShadow
                        v.Material = originalSettings[v].Material
                        v.Reflectance = originalSettings[v].Reflectance
                    elseif v:IsA("Decal") then
                        v.Transparency = originalSettings[v]
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        v.Lifetime = originalSettings[v]
                    end
                end
            end

            for _, v in pairs(Lighting:GetDescendants()) do
                if originalSettings[v] ~= nil and v:IsA("PostEffect") then
                    v.Enabled = originalSettings[v]
                end
            end

            originalSettings = {}
            
        end
    end,
})



-- ====================================================================
-- DAYTIME / MORNING TOGGLE (SETTING TAB)
-- ====================================================================
local Lighting = game:GetService("Lighting")

Tabs.SettingTab:Toggle({
    Title = "DayTime/Morning",
    Desc = "Leave to the Darkness",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                -- ===== [TOGGLE ON: Gawing Tanghali] =====
                Lighting.ClockTime = 14
                Lighting.Brightness = 3
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
                Lighting.Ambient = Color3.fromRGB(150, 150, 150)
                Lighting.GlobalShadows = false
                
                for _, child in ipairs(Lighting:GetChildren()) do
                    if child:IsA("Atmosphere") then
                        child.Density = 0
                        child.Haze = 0
                        child.Color = Color3.fromRGB(255, 255, 255)
                        child.Decay = Color3.fromRGB(255, 255, 255)
                    elseif child:IsA("ColorCorrectionEffect") then
                        child.TintColor = Color3.fromRGB(255, 255, 255)
                        child.Saturation = 0.1
                        child.Contrast = 0.1
                    elseif child:IsA("Sky") then
                        child.StarCount = 0
                    end
                end
            else
                -- ===== [TOGGLE OFF: Ibalik sa Normal/Gabi] =====
                Lighting.ClockTime = 0
                Lighting.Brightness = 1
                Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
                Lighting.Ambient = Color3.fromRGB(70, 70, 70)
                Lighting.GlobalShadows = true
                
                for _, child in ipairs(Lighting:GetChildren()) do
                    if child:IsA("Atmosphere") then
                        child.Density = 0.35 -- O i-adjust ayon sa default ng laro
                        child.Haze = 0
                        child.Color = Color3.fromRGB(199, 199, 199)
                        child.Decay = Color3.fromRGB(106, 112, 125)
                    elseif child:IsA("ColorCorrectionEffect") then
                        child.TintColor = Color3.fromRGB(255, 255, 255)
                        child.Saturation = 0
                        child.Contrast = 0
                    elseif child:IsA("Sky") then
                        child.StarCount = 3000
                    end
                end
            end
        end)
    end,
})




local antiAfkConnection = nil

Tabs.SettingTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents you from being kicked for being idle",
    Value = false,
    Callback = function(state)
        if state then
            antiAfkConnection = LocalPlayer.Idled:Connect(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.2)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        else
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end,
})


Tabs.SettingTab:Space()

