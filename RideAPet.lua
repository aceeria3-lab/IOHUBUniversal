local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Built-in Anti-AFK
local antiAfkConnection = LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)

print("Anti-AFK ✅")











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
				loadstring(game:HttpGet("https://raw.githubusercontent.com/aceeria3-lab/WINDUIIOHUB/refs/heads/main/dist/main2.lua"))()
		end
	end
end



local Window = WindUI:CreateWindow({
    Title = "IOHUB",
    Folder = "IOHUB",
    Icon = "rbxassetid://139934599708171",
    IconSize = 35,
    
    NewElements = true,
    HideSearchBar = false,

    OpenButton = {
        Title = "IOHUB",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.8,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#e7ff2f")
        ),
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
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






--------------------------------------------------
-- AUTO COLLECT EGG (MAIN TAB) - WITH VOLCANIC SEQUENCE
--------------------------------------------------

_G.SelectedEggTargets = {}
_G.AutoEggEnabled = false
_G.AutoDipEnabled = false

local eggChoicesList = {
    "Cherub Egg",
    "Solaris Egg",
    "Blackhole Egg",
    "Volcanic Egg",
    "Galaxy Egg",
      "Tidal Egg",
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
    Flag = "SelectEggTarget",
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

-- 2. Toggle para sa Auto Dip
Tabs.MainTab:Toggle({
    Title = "Auto Dip",
    Desc = "Teleport to Drop Location, Fire Dip, Wait 10s, then Return to Plot. If OFF, diretso sa Plot.",
    Flag = "AutoDip",
    Value = false,
    Callback = function(state)
        _G.AutoDipEnabled = state
    end,
})

-- 3. Toggle para sa Auto Collect Egg
Tabs.MainTab:Toggle({
    Title = "Auto Collect Egg",
    Desc = "Automatically Collect the Selected Egg when Spawned",
    Flag = "AutoCollectEgg",
    Value = false,
    Callback = function(state)
        _G.AutoEggEnabled = state

        if state then
            task.spawn(function()
                local Players = game:GetService("Players")
                local Workspace = game:GetService("Workspace")
                local TweenService = game:GetService("TweenService")
                local RunService = game:GetService("RunService")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local player = Players.LocalPlayer

                -- ===== SPOT COORDINATES (Volcanic) =====
                local SPOT_1 = CFrame.new(-4926.280, 41288.426, -3695.847)  -- Entrance
                local SPOT_2 = CFrame.new(-5050.522, 41267.402, -3511.556)  -- Validate
                local SPOT_3 = CFrame.new(-5329.609, 40912.852, -3581.365)  -- Egg location

                -- ===== DROP LOCATION =====
                local DROP_CFRAME = CFrame.new(-5102.84277, 41405.6289, -3489.11401)

                -- ===== FIRE VOLCANO DIP EVENT (Cobalt) =====
                local function fireVolcanoDip()
                    local ok, remote = pcall(function()
                        return ReplicatedStorage
                            :FindFirstChild("packages")
                            :FindFirstChild("Net")
                            :FindFirstChild("RE/VolcanoDip")
                    end)

                    if not ok or not remote then
                        warn("[AutoCollect] Hindi mahanap ang 'RE/VolcanoDip' remote!")
                        return false
                    end

                    local success = pcall(function()
                        remote:FireServer()
                    end)

                    if not success then
                        warn("[AutoCollect] Failed to fire VolcanoDip!")
                    end

                    return success
                end

                -- ===== HELPER: Kunin ang plot mo =====
                local function getMyPlot()
                    local plots = Workspace:FindFirstChild("Plots")
                    if not plots then return nil end

                    for _, plot in ipairs(plots:GetChildren()) do
                        local data = plot:FindFirstChild("Data")
                        local owner = data and data:FindFirstChild("Owner")

                        if owner then
                            if owner:IsA("ObjectValue") then
                                if owner.Value == player then return plot end
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
                    if plot.PrimaryPart then return plot.PrimaryPart.CFrame end

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

                -- ===== HELPER: Generic tween sa CFrame =====
                local function tweenTo(hrp, targetCFrame, duration, offsetY)
                    if not targetCFrame then return false end

                    local finalCFrame = targetCFrame + Vector3.new(0, offsetY or 3, 0)
                    local tweenInfo = TweenInfo.new(duration or 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = finalCFrame})
                    tween:Play()

                    local completed = false
                    pcall(function()
                        tween.Completed:Wait()
                        completed = true
                    end)

                    task.wait(0.2)
                    return completed
                end

                -- ===== HELPER: Tween pabalik sa plot =====
                local function returnToPlot(hrp)
                    local myPlot = getMyPlot()
                    local plotCenter = getPlotCenterCFrame(myPlot)

                    if not plotCenter then
                        warn("[AutoCollect] Plot not found!")
                        return
                    end

                    tweenTo(hrp, plotCenter, 1.5, 5)
                end

                -- ===== HELPER: Noclip ON/OFF =====
                local noclipConnection = nil

                local function enableNoclip()
                    if noclipConnection then return end

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
                end

                local function disableNoclip()
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

                -- ===== HELPER: FLY MODE ON/OFF =====
                local flyConnection = nil
                local flyVelocity = nil
                local flyGyro = nil

                local function enableFly()
                    local character = player.Character
                    if not character then return end

                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if not hrp or not humanoid then return end

                    if hrp:FindFirstChild("DemoFlyVelocity") then hrp.DemoFlyVelocity:Destroy() end
                    if hrp:FindFirstChild("DemoFlyGyro") then hrp.DemoFlyGyro:Destroy() end

                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "DemoFlyVelocity"
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = hrp
                    flyVelocity = bv

                    local bg = Instance.new("BodyGyro")
                    bg.Name = "DemoFlyGyro"
                    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bg.P = 10000
                    bg.D = 100
                    bg.CFrame = hrp.CFrame
                    bg.Parent = hrp
                    flyGyro = bg

                    humanoid.PlatformStand = true

                    flyConnection = RunService.RenderStepped:Connect(function()
                        if flyGyro and flyGyro.Parent and hrp then
                            flyGyro.CFrame = hrp.CFrame
                        end
                    end)
                end

                local function disableFly()
                    if flyConnection then
                        flyConnection:Disconnect()
                        flyConnection = nil
                    end

                    local character = player.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character:FindFirstChildOfClass("Humanoid")

                        if hrp then
                            if hrp:FindFirstChild("DemoFlyVelocity") then hrp.DemoFlyVelocity:Destroy() end
                            if hrp:FindFirstChild("DemoFlyGyro") then hrp.DemoFlyGyro:Destroy() end
                        end

                        if humanoid then
                            humanoid.PlatformStand = false
                        end
                    end

                    flyVelocity = nil
                    flyGyro = nil
                end

                -- ===== HELPER: Instant Teleport (NOCLIP ON during teleport) =====
                local function teleportTo(hrp, targetCFrame)
                    if not targetCFrame or not hrp then return false end

                    enableNoclip()
                    task.wait(0.1)

                    pcall(function()
                        hrp.CFrame = targetCFrame
                    end)

                    task.wait(0.1)

                    disableNoclip()

                    return true
                end

                -- ===== HELPER: Stable Tween (NOCLIP OFF during tween) =====
                local function stableTween(hrp, targetCFrame, duration)
                    if not targetCFrame then return false end

                    disableNoclip()
                    task.wait(0.1)

                    local tweenInfo = TweenInfo.new(duration or 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
                    tween:Play()

                    local completed = false
                    pcall(function()
                        tween.Completed:Wait()
                        completed = true
                    end)

                    task.wait(0.2)
                    return completed
                end

                -- ===== HELPER: Instant Fire Prompt =====
                local function firePrompt(prompt)
                    if not prompt or not prompt:IsA("ProximityPrompt") then return false end

                    local success = pcall(function()
                        fireproximityprompt(prompt)
                    end)

                    return success
                end

                -- ===== HELPER: Manual Touched Trigger =====
                local function triggerTouched(part, character)
                    if not part or not part:IsA("BasePart") then return end

                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end

                    pcall(function()
                        part.Touched:Fire(hrp)
                    end)

                    for _, desc in ipairs(part:GetDescendants()) do
                        if desc:IsA("BasePart") then
                            pcall(function()
                                desc.Touched:Fire(hrp)
                            end)
                        end
                    end
                end

                -- ===== HELPER: Post-drop flow (Auto Dip toggle dependent) =====
                local function postDropFlow(hrp)
                    if _G.AutoDipEnabled then
                        -- ✅ AUTO DIP ON: Teleport → DROP → Fire Dip → Wait 10s → Teleport → Plot
                        teleportTo(hrp, DROP_CFRAME)
                        task.wait(0.5)

                        fireVolcanoDip()
                        task.wait(0.3)

                        -- ⏳ Wait 10 seconds bago mag teleport sa plot
                        print("[AutoCollect] Auto Dip ON — Waiting 10 seconds...")
                        task.wait(10)
                    end
                    -- ❌ AUTO DIP OFF: Skip drop location + dip, diretso sa plot (walang wait)

                    -- Teleport → My Plot (last destination, always)
                    local myPlot = getMyPlot()
                    local plotCenter = getPlotCenterCFrame(myPlot)

                    if plotCenter then
                        teleportTo(hrp, plotCenter + Vector3.new(0, 5, 0))
                        task.wait(0.5)
                    end
                end

                -- ===== HELPER: Volcanic Egg sequence =====
                local function volcanicSequence(hrp, prompt)
                    local character = player.Character
                    local volcano = Workspace:FindFirstChild("Volcano")
                    if not volcano then
                        warn("[AutoCollect] Walang 'Volcano' folder sa Workspace!")
                        return false
                    end

                    local entrance = volcano:FindFirstChild("VolcanoEntrance")
                    local validate = volcano:FindFirstChild("VolcanoValidate")

                    enableFly()
                    task.wait(0.5)

                    -- ===== ENTRY =====

                    -- Step 1: TELEPORT → SPOT 1 (Entrance)
                    teleportTo(hrp, SPOT_1)
                    task.wait(0.3)

                    if entrance then
                        triggerTouched(entrance, character)
                    end
                    task.wait(0.5)

                    -- Step 2: TWEEN → SPOT 2 (Validate)
                    stableTween(hrp, SPOT_2, 1.5)
                    task.wait(0.3)

                    if validate then
                        triggerTouched(validate, character)
                    end
                    task.wait(0.5)

                    -- Step 3: TELEPORT → SPOT 3 (Egg)
                    teleportTo(hrp, SPOT_3)
                    task.wait(0.5)

                    -- Step 4: Instant fire prompt
                    if prompt then
                        firePrompt(prompt)
                        task.wait(0.5)
                    end

                    -- ===== EXIT =====

                    -- Step 5: TELEPORT → SPOT 2 (Validate)
                    teleportTo(hrp, SPOT_2)
                    task.wait(0.3)

                    -- Step 6: TWEEN → SPOT 1 (Entrance)
                    stableTween(hrp, SPOT_1, 1.5)
                    task.wait(0.5)

                    -- Step 7+: Post-drop flow (Dip toggle dependent)
                    postDropFlow(hrp)

                    -- ✅ FLY OFF + NOCLIP OFF
                    task.wait(0.5)
                    disableFly()
                    disableNoclip()

                    return true
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
                    local targetEggName = nil

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

                                if targetCFrame then
                                    targetEggName = eggModel.Name
                                    break
                                end
                            end
                        end
                    end

                    -- ✅ KUNG MAY NAHANAP
                    if targetCFrame then

                        -- ===== VOLCANIC EGG SPECIAL SEQUENCE =====
                        if targetEggName == "Volcanic Egg" then
                            volcanicSequence(hrp, foundPrompt)
                            task.wait(0.5)
                            continue
                        end
                        -- ===== END VOLCANIC SEQUENCE =====

                        -- ===== NORMAL EGG SEQUENCE =====
                        enableFly()
                        task.wait(0.3)

                        -- Step 1: TELEPORT → EGG
                        teleportTo(hrp, targetCFrame + Vector3.new(0, 3, 0))
                        task.wait(0.3)

                        if foundPrompt and foundPrompt:IsA("ProximityPrompt") then
                            -- Step 2: Fire Egg Prompt
                            firePrompt(foundPrompt)
                            task.wait(0.3)

                            -- Step 3+: Post-drop flow (Dip toggle dependent)
                            postDropFlow(hrp)
                        end

                        disableFly()
                        disableNoclip()
                    end
                    -- ❌ KUNG WALANG NAHANAP: free walk lang
                end
            end)
        end
    end,
})


Tabs.MainTab:Space()

--------------------------------------------------
-- COLLECT & GIVE (MAIN TAB)
--------------------------------------------------

_G.GiveTargetPlayer = nil
_G.GiveTargetEggs = {}
_G.GiveEnabled = false

-- ===== HELPER: Kunin lahat ng existing players =====
local function getAllPlayers()
    local list = {}
    local Players = game:GetService("Players")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            table.insert(list, p.Name)
        end
    end

    if #list == 0 then
        table.insert(list, "(no players)")
    end

    return list
end

-- ===== DROPDOWN REFERENCES =====
local givePlayerDropdown = nil

-- 1. SINGLE-SELECT Dropdown: Player Target
givePlayerDropdown = Tabs.MainTab:Dropdown({
    Title = "Give Egg To Player Plot",
    Desc = "Choose Player then Give Egg to Them",
    Flag = "GiveTargetPlayer",
    Values = getAllPlayers(),
    Value = "",
    AllowNone = true,
    Multi = false,
    Callback = function(selected)
        if type(selected) == "table" then
            selected = selected[1] or ""
        end
        _G.GiveTargetPlayer = selected
    end,
})



-- 2. MULTI-SELECT Dropdown: Egg Targets
Tabs.MainTab:Dropdown({
    Title = "Eggs to Collect & Give",
    Desc = "Choose Egg",
    Flag = "GiveTargetEggs",
    Values = eggChoicesList,
    Value = {},
    AllowNone = true,
    Multi = true,
    Callback = function(selectedTable)
        _G.GiveTargetEggs = {}

        if type(selectedTable) == "table" then
            for key, value in pairs(selectedTable) do
                if type(key) == "number" and type(value) == "string" then
                    _G.GiveTargetEggs[value] = true
                elseif type(key) == "string" and value == true then
                    _G.GiveTargetEggs[key] = true
                end
            end
        end
    end,
})

-- 3. START Button
Tabs.MainTab:Button({
    Title = "Start Collect & Give",
    Desc = "Collect and Give to Player Plot",
    Callback = function()
        -- Validate
        if not _G.GiveTargetPlayer or _G.GiveTargetPlayer == "" or _G.GiveTargetPlayer == "(no players)" then
            WindUI:Notify({
                Title = "Error",
                Content = "Pumili muna ng target player!",
                Icon = "solar:danger-bold",
                Duration = 3,
            })
            return
        end

        if next(_G.GiveTargetEggs) == nil then
            WindUI:Notify({
                Title = "Error",
                Content = "Pumili muna ng egg target!",
                Icon = "solar:danger-bold",
                Duration = 3,
            })
            return
        end

        _G.GiveEnabled = true

        WindUI:Notify({
            Title = "Collect & Give Started",
            Content = "Target: " .. _G.GiveTargetPlayer,
            Icon = "solar:play-circle-bold",
            Duration = 3,
        })

        task.spawn(function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local TweenService = game:GetService("TweenService")
            local RunService = game:GetService("RunService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local player = Players.LocalPlayer

            -- ===== BasketDrop Remote =====
            local basketDropRemote = nil
            pcall(function()
                basketDropRemote = ReplicatedStorage:FindFirstChild("Remotes")
                    and ReplicatedStorage.Remotes:FindFirstChild("Game")
                    and ReplicatedStorage.Remotes.Game:FindFirstChild("BasketDrop")
            end)

            if not basketDropRemote then
                WindUI:Notify({
                    Title = "Error",
                    Content = "Hindi mahanap ang BasketDrop remote!",
                    Icon = "solar:danger-bold",
                    Duration = 5,
                })
                _G.GiveEnabled = false
                return
            end

            -- ===== SPOT COORDINATES (Volcanic) =====
            local SPOT_1 = CFrame.new(-4926.280, 41288.426, -3695.847)
            local SPOT_2 = CFrame.new(-5050.522, 41267.402, -3511.556)
            local SPOT_3 = CFrame.new(-5329.609, 40912.852, -3581.365)

            -- ===== HELPER: Plot by player name =====
            local function getPlotByPlayerName(targetName)
                local plots = Workspace:FindFirstChild("Plots")
                if not plots then return nil end

                local targetPlayerInstance = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name == targetName then
                        targetPlayerInstance = p
                        break
                    end
                end

                for _, plot in ipairs(plots:GetChildren()) do
                    local data = plot:FindFirstChild("Data")
                    local owner = data and data:FindFirstChild("Owner")

                    if owner then
                        if owner:IsA("ObjectValue") then
                            if targetPlayerInstance and owner.Value == targetPlayerInstance then
                                return plot
                            end
                            if owner.Value and owner.Value.Name == targetName then
                                return plot
                            end
                        elseif owner:IsA("StringValue") then
                            if owner.Value == targetName then
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
                if plot.PrimaryPart then return plot.PrimaryPart.CFrame end

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

            -- ===== HELPER: Noclip =====
            local noclipConnection = nil

            local function enableNoclip()
                if noclipConnection then return end

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
            end

            local function disableNoclip()
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

            -- ===== HELPER: Fly =====
            local flyConnection = nil
            local flyGyro = nil

            local function enableFly()
                local character = player.Character
                if not character then return end

                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not hrp or not humanoid then return end

                if hrp:FindFirstChild("GiveFlyVelocity") then hrp.GiveFlyVelocity:Destroy() end
                if hrp:FindFirstChild("GiveFlyGyro") then hrp.GiveFlyGyro:Destroy() end

                local bv = Instance.new("BodyVelocity")
                bv.Name = "GiveFlyVelocity"
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp

                local bg = Instance.new("BodyGyro")
                bg.Name = "GiveFlyGyro"
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.P = 10000
                bg.D = 100
                bg.CFrame = hrp.CFrame
                bg.Parent = hrp
                flyGyro = bg

                humanoid.PlatformStand = true

                flyConnection = RunService.RenderStepped:Connect(function()
                    if flyGyro and flyGyro.Parent and hrp then
                        flyGyro.CFrame = hrp.CFrame
                    end
                end)
            end

            local function disableFly()
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end

                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if hrp then
                        if hrp:FindFirstChild("GiveFlyVelocity") then hrp.GiveFlyVelocity:Destroy() end
                        if hrp:FindFirstChild("GiveFlyGyro") then hrp.GiveFlyGyro:Destroy() end
                    end

                    if humanoid then
                        humanoid.PlatformStand = false
                    end
                end

                flyGyro = nil
            end

            -- ===== HELPER: Stable Tween (NOCLIP OFF during tween) =====
            local function stableTween(hrp, targetCFrame, duration)
                if not targetCFrame then return false end

                disableNoclip()
                task.wait(0.1)

                local tweenInfo = TweenInfo.new(duration or 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
                tween:Play()

                local completed = false
                pcall(function()
                    tween.Completed:Wait()
                    completed = true
                end)

                task.wait(0.2)
                return completed
            end

            -- ===== HELPER: Instant Fire Prompt =====
            local function firePrompt(prompt)
                if not prompt or not prompt:IsA("ProximityPrompt") then return false end
                local success = pcall(function()
                    fireproximityprompt(prompt)
                end)
                return success
            end

            -- ===== HELPER: Touched Trigger =====
            local function triggerTouched(part, character)
                if not part or not part:IsA("BasePart") then return end

                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                pcall(function()
                    part.Touched:Fire(hrp)
                end)

                for _, desc in ipairs(part:GetDescendants()) do
                    if desc:IsA("BasePart") then
                        pcall(function()
                            desc.Touched:Fire(hrp)
                        end)
                    end
                end
            end

            -- ===== HELPER: Teleport (NOCLIP ON during teleport) =====
            local function teleport(hrp, targetCFrame)
                if not targetCFrame then return false end

                enableNoclip()
                task.wait(0.1)

                pcall(function()
                    hrp.CFrame = targetCFrame
                end)

                task.wait(0.1)

                disableNoclip()

                return true
            end

            -- ===== HELPER: Volcanic Sequence =====
            local function volcanicSequence(hrp, prompt)
                local character = player.Character
                local volcano = Workspace:FindFirstChild("Volcano")

                if not volcano then return false end

                local entrance = volcano:FindFirstChild("VolcanoEntrance")
                local validate = volcano:FindFirstChild("VolcanoValidate")

                -- Step 1: Teleport to Spot 1
                enableFly()
                enableNoclip()
                task.wait(0.3)

                teleport(hrp, SPOT_1)
                task.wait(0.3)

                -- Step 2: Tween to Spot 2 (NOCLIP OFF via stableTween)
                stableTween(hrp, SPOT_2, 1.5)
                task.wait(0.3)
                if validate then triggerTouched(validate, character) end
                task.wait(0.3)

                -- Step 3: Teleport to Spot 3
                teleport(hrp, SPOT_3)
                task.wait(0.3)

                if entrance then triggerTouched(entrance, character) end
                task.wait(0.3)

                if prompt then
                    firePrompt(prompt)
                    task.wait(0.5)
                end

                -- Step 4: Teleport back to Spot 2
                teleport(hrp, SPOT_2)
                task.wait(0.3)

                -- Step 5: Tween to Spot 1 (NOCLIP OFF via stableTween)
                stableTween(hrp, SPOT_1, 1.5)
                task.wait(0.3)

                return true
            end

            -- ============================================================
            -- ONE-SHOT: Hanapin egg, i-collect, i-give, tapos STOP
            -- ============================================================

            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if not hrp then
                WindUI:Notify({
                    Title = "Error",
                    Content = "Walang character!",
                    Icon = "solar:danger-bold",
                    Duration = 3,
                })
                _G.GiveEnabled = false
                return
            end

            local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
            if not renderedEggs then
                WindUI:Notify({
                    Title = "Error",
                    Content = "Walang RenderedEggs folder!",
                    Icon = "solar:danger-bold",
                    Duration = 3,
                })
                _G.GiveEnabled = false
                return
            end

            -- Hanapin ang egg
            local targetCFrame = nil
            local foundPrompt = nil
            local targetEggName = nil

            for _, eggModel in ipairs(renderedEggs:GetChildren()) do
                if _G.GiveTargetEggs[eggModel.Name] then
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
                            targetEggName = eggModel.Name
                            break
                        end
                    end
                end
            end

            -- ✅ KUNG MAY NAHANAP
            if targetCFrame then

                -- ===== VOLCANIC EGG =====
                if targetEggName == "Volcanic Egg" then
                    volcanicSequence(hrp, foundPrompt)

                    -- ✅ Teleport to target plot + fire BasketDrop
                    local targetPlot = getPlotByPlayerName(_G.GiveTargetPlayer)
                    local targetPlotCenter = getPlotCenterCFrame(targetPlot)

                    if targetPlotCenter then
                        teleport(hrp, targetPlotCenter + Vector3.new(0, 5, 0))
                        task.wait(0.5)

                        pcall(function()
                            basketDropRemote:FireServer()
                        end)

                        task.wait(0.5)
                    else
                        warn("[Collect & Give] Target plot not found for: " .. tostring(_G.GiveTargetPlayer))
                    end

                    -- ✅ OFF FLY + NOCLIP
                    disableFly()
                    disableNoclip()
                    task.wait(0.3)

                -- ===== NORMAL EGG =====
                else
                    enableFly()
                    enableNoclip()
                    task.wait(0.3)

                    -- Teleport to egg
                    teleport(hrp, targetCFrame + Vector3.new(0, 3, 0))
                    task.wait(0.3)

                    if foundPrompt and foundPrompt:IsA("ProximityPrompt") then
                        firePrompt(foundPrompt)
                        task.wait(0.3)

                        -- Teleport to target plot
                        local targetPlot = getPlotByPlayerName(_G.GiveTargetPlayer)
                        local targetPlotCenter = getPlotCenterCFrame(targetPlot)

                        if targetPlotCenter then
                            teleport(hrp, targetPlotCenter + Vector3.new(0, 5, 0))
                            task.wait(0.5)

                            pcall(function()
                                basketDropRemote:FireServer()
                            end)

                            task.wait(0.5)
                        else
                            warn("[Collect & Give] Target plot not found for: " .. tostring(_G.GiveTargetPlayer))
                        end
                    end

                    disableFly()
                    disableNoclip()
                end

                WindUI:Notify({
                    Title = "Done",
                    Content = "Egg collected & given. Click Start ulit para mag-collect.",
                    Icon = "solar:check-circle-bold",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "No Egg Found",
                    Content = "Walang egg na available sa selected targets.",
                    Icon = "solar:danger-bold",
                    Duration = 3,
                })
            end

            -- ✅ AUTO-STOP
            _G.GiveEnabled = false
        end)
    end,
})


-- ===== REFRESH BUTTON: I-update yung player list =====
Tabs.MainTab:Button({
    Title = "Refresh Player List",
    Desc = "Update the Drop-down List",
    Callback = function()
        local newList = getAllPlayers()

        if givePlayerDropdown and givePlayerDropdown.Refresh then
            givePlayerDropdown:Refresh(newList)

            WindUI:Notify({
                Title = "Refreshed",
                Content = "Naka-" .. tostring(#newList) .. " players sa listahan",
                Icon = "solar:refresh-bold",
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "Note",
                Content = "Restart script para ma-refresh yung listahan",
                Icon = "solar:info-circle-bold",
                Duration = 3,
            })
        end
    end,
}) -- end refresh player


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

    Flag = "AutoUpgrade",
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
_G.AutoCustomDipEnabled = false

-- 1. Custom Text Input para sa pag-type ng keyword
Tabs.EventTab:Input({
    Title = "Custom Egg Name",
    Desc = "example Cherub",
    Flag = "CustomEggName",
    Callback = function(textValue)
        if textValue and textValue ~= "" then
            _G.CustomEggQuery = textValue:gsub("^%s*(.-)%s*$", "%1"):lower()
        else
            _G.CustomEggQuery = ""
        end
    end,
})

-- 2. Toggle para sa Auto Dip (Custom)
Tabs.EventTab:Toggle({
    Title = "Auto Dip (Custom)",
    Desc = "Teleport to Drop Location, Fire Dip, Wait 10s, then Return to Plot. If OFF, diretso sa Plot.",
    Flag = "CustomAutoDip",
    Value = false,
    Callback = function(state)
        _G.AutoCustomDipEnabled = state
    end,
})

-- 3. Toggle para sa Custom Egg Auto Collect
Tabs.EventTab:Toggle({
    Title = "Turn on Auto Collect Custom Egg",
    Desc = "Automatically Collect the Egg Name You Input",
    Flag = "CustomEggToggle",
    Value = false,
    Callback = function(state)
        _G.AutoCustomEggEnabled = state

        if state then
            task.spawn(function()
                local Players = game:GetService("Players")
                local Workspace = game:GetService("Workspace")
                local TweenService = game:GetService("TweenService")
                local RunService = game:GetService("RunService")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local player = Players.LocalPlayer

                -- ===== SPOT COORDINATES (Volcanic) =====
                local SPOT_1 = CFrame.new(-4926.280, 41288.426, -3695.847)  -- Entrance
                local SPOT_2 = CFrame.new(-5050.522, 41267.402, -3511.556)  -- Validate
                local SPOT_3 = CFrame.new(-5329.609, 40912.852, -3581.365)  -- Egg location

                -- ===== DROP LOCATION =====
                local DROP_CFRAME = CFrame.new(-5102.84277, 41405.6289, -3489.11401)

                -- ===== FIRE VOLCANO DIP EVENT (Cobalt) =====
                local function fireVolcanoDip()
                    local ok, remote = pcall(function()
                        return ReplicatedStorage
                            :FindFirstChild("packages")
                            :FindFirstChild("Net")
                            :FindFirstChild("RE/VolcanoDip")
                    end)

                    if not ok or not remote then
                        warn("[AutoCustomEgg] Hindi mahanap ang 'RE/VolcanoDip' remote!")
                        return false
                    end

                    local success = pcall(function()
                        remote:FireServer()
                    end)

                    if not success then
                        warn("[AutoCustomEgg] Failed to fire VolcanoDip!")
                    end

                    return success
                end

                -- ===== HELPER: Kunin ang plot mo =====
                local function getMyPlot()
                    local plots = Workspace:FindFirstChild("Plots")
                    if not plots then return nil end

                    for _, plot in ipairs(plots:GetChildren()) do
                        local data = plot:FindFirstChild("Data")
                        local owner = data and data:FindFirstChild("Owner")

                        if owner then
                            if owner:IsA("ObjectValue") then
                                if owner.Value == player then return plot end
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
                    if plot.PrimaryPart then return plot.PrimaryPart.CFrame end

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

                -- ===== HELPER: Generic tween sa CFrame =====
                local function tweenTo(hrp, targetCFrame, duration, offsetY)
                    if not targetCFrame then return false end

                    local finalCFrame = targetCFrame + Vector3.new(0, offsetY or 3, 0)
                    local tweenInfo = TweenInfo.new(duration or 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = finalCFrame})
                    tween:Play()

                    local completed = false
                    pcall(function()
                        tween.Completed:Wait()
                        completed = true
                    end)

                    task.wait(0.2)
                    return completed
                end

                -- ===== HELPER: Tween pabalik sa plot =====
                local function returnToPlot(hrp)
                    local myPlot = getMyPlot()
                    local plotCenter = getPlotCenterCFrame(myPlot)

                    if not plotCenter then
                        warn("[AutoCustomEgg] Plot not found!")
                        return
                    end

                    tweenTo(hrp, plotCenter, 1.5, 5)
                end

                -- ===== HELPER: Noclip ON/OFF =====
                local noclipConnection = nil

                local function enableNoclip()
                    if noclipConnection then return end

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
                end

                local function disableNoclip()
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

                -- ===== HELPER: FLY MODE ON/OFF =====
                local flyConnection = nil
                local flyVelocity = nil
                local flyGyro = nil

                local function enableFly()
                    local character = player.Character
                    if not character then return end

                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if not hrp or not humanoid then return end

                    if hrp:FindFirstChild("DemoFlyVelocity") then hrp.DemoFlyVelocity:Destroy() end
                    if hrp:FindFirstChild("DemoFlyGyro") then hrp.DemoFlyGyro:Destroy() end

                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "DemoFlyVelocity"
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = hrp
                    flyVelocity = bv

                    local bg = Instance.new("BodyGyro")
                    bg.Name = "DemoFlyGyro"
                    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bg.P = 10000
                    bg.D = 100
                    bg.CFrame = hrp.CFrame
                    bg.Parent = hrp
                    flyGyro = bg

                    humanoid.PlatformStand = true

                    flyConnection = RunService.RenderStepped:Connect(function()
                        if flyGyro and flyGyro.Parent and hrp then
                            flyGyro.CFrame = hrp.CFrame
                        end
                    end)
                end

                local function disableFly()
                    if flyConnection then
                        flyConnection:Disconnect()
                        flyConnection = nil
                    end

                    local character = player.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character:FindFirstChildOfClass("Humanoid")

                        if hrp then
                            if hrp:FindFirstChild("DemoFlyVelocity") then hrp.DemoFlyVelocity:Destroy() end
                            if hrp:FindFirstChild("DemoFlyGyro") then hrp.DemoFlyGyro:Destroy() end
                        end

                        if humanoid then
                            humanoid.PlatformStand = false
                        end
                    end

                    flyVelocity = nil
                    flyGyro = nil
                end

                -- ===== HELPER: Instant Teleport (NOCLIP ON during teleport) =====
                local function teleportTo(hrp, targetCFrame)
                    if not targetCFrame or not hrp then return false end

                    enableNoclip()
                    task.wait(0.1)

                    pcall(function()
                        hrp.CFrame = targetCFrame
                    end)

                    task.wait(0.1)

                    disableNoclip()

                    return true
                end

                -- ===== HELPER: Stable Tween (NOCLIP OFF during tween) =====
                local function stableTween(hrp, targetCFrame, duration)
                    if not targetCFrame then return false end

                    disableNoclip()
                    task.wait(0.1)

                    local tweenInfo = TweenInfo.new(duration or 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
                    tween:Play()

                    local completed = false
                    pcall(function()
                        tween.Completed:Wait()
                        completed = true
                    end)

                    task.wait(0.2)
                    return completed
                end

                -- ===== HELPER: Instant Fire Prompt =====
                local function firePrompt(prompt)
                    if not prompt or not prompt:IsA("ProximityPrompt") then return false end

                    local success = pcall(function()
                        fireproximityprompt(prompt)
                    end)

                    return success
                end

                -- ===== HELPER: Manual Touched Trigger =====
                local function triggerTouched(part, character)
                    if not part or not part:IsA("BasePart") then return end

                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end

                    pcall(function()
                        part.Touched:Fire(hrp)
                    end)

                    for _, desc in ipairs(part:GetDescendants()) do
                        if desc:IsA("BasePart") then
                            pcall(function()
                                desc.Touched:Fire(hrp)
                            end)
                        end
                    end
                end

                -- ===== HELPER: Post-drop flow (Auto Dip toggle dependent) =====
                local function postDropFlow(hrp)
                    if _G.AutoCustomDipEnabled then
                        -- ✅ AUTO DIP ON: Teleport → DROP → Fire Dip → Wait 10s → Teleport → Plot
                        teleportTo(hrp, DROP_CFRAME)
                        task.wait(0.5)

                        fireVolcanoDip()
                        task.wait(0.3)

                        -- ⏳ Wait 10 seconds bago mag teleport sa plot
                        print("[AutoCustomEgg] Auto Dip ON — Waiting 10 seconds...")
                        task.wait(10)
                    end
                    -- ❌ AUTO DIP OFF: Skip drop location + dip, diretso sa plot (walang wait)

                    -- Teleport → My Plot (last destination, always)
                    local myPlot = getMyPlot()
                    local plotCenter = getPlotCenterCFrame(myPlot)

                    if plotCenter then
                        teleportTo(hrp, plotCenter + Vector3.new(0, 5, 0))
                        task.wait(0.5)
                    end
                end

                -- ===== HELPER: Volcanic Egg sequence (TELEPORT + TWEEN MIX) =====
                local function volcanicSequence(hrp, prompt)
                    local character = player.Character
                    local volcano = Workspace:FindFirstChild("Volcano")
                    if not volcano then
                        warn("[AutoCustomEgg] Walang 'Volcano' folder sa Workspace!")
                        return false
                    end

                    local entrance = volcano:FindFirstChild("VolcanoEntrance")
                    local validate = volcano:FindFirstChild("VolcanoValidate")

                    -- ✅ FLY ON
                    enableFly()
                    task.wait(0.5)

                    -- ===== ENTRY =====

                    -- Step 1: TELEPORT → SPOT 1 (Entrance)
                    teleportTo(hrp, SPOT_1)
                    task.wait(0.3)

                    if entrance then
                        triggerTouched(entrance, character)
                    end
                    task.wait(0.5)

                    -- Step 2: TWEEN → SPOT 2 (Validate)
                    stableTween(hrp, SPOT_2, 1.5)
                    task.wait(0.3)

                    if validate then
                        triggerTouched(validate, character)
                    end
                    task.wait(0.5)

                    -- Step 3: TELEPORT → SPOT 3 (Egg)
                    teleportTo(hrp, SPOT_3)
                    task.wait(0.5)

                    -- Step 4: Instant fire prompt
                    if prompt then
                        firePrompt(prompt)
                        task.wait(0.5)
                    end

                    -- ===== EXIT =====

                    -- Step 5: TELEPORT → SPOT 2 (Validate)
                    teleportTo(hrp, SPOT_2)
                    task.wait(0.3)

                    -- Step 6: TWEEN → SPOT 1 (Entrance)
                    stableTween(hrp, SPOT_1, 1.5)
                    task.wait(0.5)

                    -- Step 7+: Post-drop flow (Dip toggle dependent)
                    postDropFlow(hrp)

                    -- ✅ FLY OFF + NOCLIP OFF
                    task.wait(0.5)
                    disableFly()
                    disableNoclip()

                    return true
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
                        local targetEggName = nil

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
                                        targetEggName = eggModel.Name
                                        break
                                    end
                                end
                            end
                        end

                        -- ✅ KUNG MAY NAHANAP
                        if targetCFrame then

                            -- ===== VOLCANIC EGG SPECIAL SEQUENCE =====
                            if targetEggName == "Volcanic Egg" then
                                volcanicSequence(hrp, foundPrompt)
                                task.wait(0.5)
                                continue
                            end
                            -- ===== END VOLCANIC SEQUENCE =====

                            -- ===== NORMAL EGG SEQUENCE (TELEPORT) =====
                            enableFly()
                            task.wait(0.3)

                            -- Step 1: TELEPORT → EGG
                            teleportTo(hrp, targetCFrame + Vector3.new(0, 3, 0))
                            task.wait(0.3)

                            if foundPrompt and foundPrompt:IsA("ProximityPrompt") then
                                -- Step 2: Fire Egg Prompt
                                firePrompt(foundPrompt)
                                task.wait(0.3)

                                -- Step 3+: Post-drop flow (Dip toggle dependent)
                                postDropFlow(hrp)
                            end

                            disableFly()
                            disableNoclip()
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



-- Global variables

local selectedEggsMap = {} -- Dictionary para mabilis ang check

local isEggEspOn = false


-- Multi-select Dropdown

Tabs.MiscTab:Dropdown({

    Title = "Select Eggs to ESP",

    Desc = "Choose the Egg You Want",

    Flag = "EspEggSelect",
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
    Flag = "EspEgg",
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

    Flag = "DisableNotification",
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

	Flag = "PlayerEsp",
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

    Flag = "Noclip",
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

    Flag = "PathBuilder",
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
    Flag = "FlySpeed",
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
    Flag = "FlyToggle",
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
   Flag = "WalkSpeedSlider",
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

    Flag = "AntiLag",
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

    Flag = "DayTime",
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













Tabs.SettingTab:Space()
--------------------------------------------------
-- CONFIG MANAGER (Auto-load sa start)
--------------------------------------------------
local ConfigManager = Window.ConfigManager
local CONFIG_NAME = "IOHUB_RideAPet"  -- ⬅️ fixed name

local function getConfig()
    return ConfigManager:CreateConfig(CONFIG_NAME)
end

-- ====== SAVE BUTTON ======
Tabs.SettingTab:Button({
    Title = "Save Config",
    Desc = "Save current settings",
    Callback = function()
        local cfg = getConfig()

        if cfg:Save() then
            WindUI:Notify({
                Title = "Config Saved",
                Content = "Settings saved as '" .. CONFIG_NAME .. "'",
                Icon = "solar:check-circle-bold",
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "Save Failed",
                Content = "Failed to Save.",
                Icon = "solar:danger-bold",
                Duration = 3,
            })
        end
    end,
})

-- ====== DELETE BUTTON ======
Tabs.SettingTab:Button({
    Title = "Delete Config",
    Desc = "Delete the saved config",
    Callback = function()
        local cfg = getConfig()

        if cfg:Delete() then
            WindUI:Notify({
                Title = "Config Deleted",
                Content = "'" .. CONFIG_NAME .. "' has been deleted!",
                Icon = "solar:trash-bin-trash-bold",
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "Delete Failed",
                Content = "Config Not Found '" .. CONFIG_NAME .. "'",
                Icon = "solar:danger-bold",
                Duration = 3,
            })
        end
    end,
})

-- ====== AUTO-LOAD SA START (system-level, walang toggle) ======
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        local cfg = getConfig()
        cfg:Load()
    end)
end)













Tabs.SettingTab:Space()
