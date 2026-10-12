



local Players = game:GetService("Players")



local VirtualInputManager = game:GetService("VirtualInputManager")



local LocalPlayer = Players.LocalPlayer







-- Built-in Anti-AFK



local antiAfkConnection = LocalPlayer.Idled:Connect(function()



    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)



    task.wait(0.2)



    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)



end)







print("Anti-AFK âœ…")















































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
    
    if not state then
        -- ✅ RESET FLAGS PAGKA-OFF
        _G.EggCollecting = false
        _G.ExitingHalloween = false
        _G.LocationMismatchCount = 0
        print("[AutoEgg] OFF 🛑")
        return
    end
    
    print("[AutoEgg] ON 🥚")
    
    if state then                        -- ✅ ITO YUNG WRAPPER
        task.spawn(function()
            -- ... rest ng code



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

                

-- ===== HELPER: Hanapin ang Model ancestor ng isang instance =====

local function getOwningModelName(inst)

    local cur = inst

    while cur and cur ~= Workspace do

        if cur:IsA("Model") then

            return cur.Name

        end

        cur = cur.Parent

    end

    return nil

end



-- ===== HELPER: Match ba ang model name sa target egg? =====

local function modelMatchesTarget(modelName, targetEggName)

    if not modelName or not targetEggName then return false end



    local a = string.lower(modelName)

    local b = string.lower(targetEggName)



    -- Exact match o substring (para sa "Egg (2)", "Egg - Copy", etc.)

    return a == b or string.find(a, b, 1, true) ~= nil

end                

                

                



-- ===== HELPER: Nearest "Pickup" prompt NA PASOK SA TARGET EGG =====

local function findNearestPickupPrompt(hrp, maxDist, targetEggName)

    if not hrp then return nil, nil end



    local nearest, nearestDist = nil, math.huge

    local debugCount = 0



    local ok, descendants = pcall(function()

        return Workspace:GetDescendants()

    end)

    if not ok or not descendants then return nil, nil end



    for _, desc in ipairs(descendants) do

        if desc:IsA("ProximityPrompt") and desc.Enabled then

            local txt = string.lower(desc.ActionText or "")



            if string.find(txt, "pick") or string.find(txt, "claim") or string.find(txt, "collect") then

                debugCount = debugCount + 1



                -- âœ… VERIFICATION: Yung owning Model ba ay target egg?

                local ownerModel = getOwningModelName(desc)



                if targetEggName and not modelMatchesTarget(ownerModel, targetEggName) then

                    -- Skip â€” hindi ito yung hinahanap nating egg

                    continue

                end



                local parent = desc.Parent

                local pos = nil



                if parent then

                    if parent:IsA("BasePart") then

                        pos = parent.Position

                    elseif parent:IsA("Model") then

                        local okPivot, pivot = pcall(function() return parent:GetPivot() end)

                        if okPivot and pivot then pos = pivot.Position end

                    end

                end



                if pos then

                    local dist = (pos - hrp.Position).Magnitude

                    if dist < nearestDist and dist <= (maxDist or math.huge) then

                        nearestDist = dist

                        nearest = desc

                    end

                end

            end

        end

    end



    if debugCount > 0 and not nearest then

        print(string.format("[AutoCollect] Nakita %d pickup prompts pero walang match sa '%s'",

            debugCount, tostring(targetEggName)))

    end



    return nearest, nearestDist

end













-- ===== FIRE BASKET DROP / CLAIM EVENT =====

local function fireBasketDrop()

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")

    local gameRemote = remotes and remotes:FindFirstChild("Game")

    local remote = gameRemote and gameRemote:FindFirstChild("BasketDrop")



    if not remote then

        warn("[AutoCollect] Hindi mahanap ang 'BasketDrop' remote!")

        return false

    end



    local ok = pcall(function()

        remote:FireServer()

    end)



    if not ok then

        warn("[AutoCollect] Failed to fire BasketDrop!")

    end



    return ok

end






-- ===== HELPER: Tween with arc (SLOW, matching recording) =====
local function arcTween(hrp, targetCF, peakHeight, speed)
    if not hrp or not targetCF then return false end
    peakHeight = peakHeight or 240
    speed = speed or 300  -- âš ï¸ BAGAL: 300 studs/sec (recording speed)
    
    enableNoclip()
    task.wait(0.05)
    
    local startPos = hrp.Position
    local endPos = targetCF.Position
    
    -- Peak position
    local midPos = Vector3.new(
        (startPos.X + endPos.X) / 2,
        math.max(startPos.Y, endPos.Y) + peakHeight,
        (startPos.Z + endPos.Z) / 2
    )
    
    -- Step 1: Tween pataas papuntang peak (SLOW)
    local dist1 = (midPos - startPos).Magnitude
    local dur1 = math.max(dist1 / speed, 0.1)
    
    print(string.format("[Arc] Up: %.0f studs / %.2fs", dist1, dur1))
    
    local tween1 = TweenService:Create(
        hrp,
        TweenInfo.new(dur1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        { CFrame = CFrame.new(midPos, endPos) }
    )
    tween1:Play()
    
    pcall(function()
        tween1.Completed:Wait()
    end)
    task.wait(0.05)
    
    -- Step 2: Tween pababa papuntang target (SLOW)
    local dist2 = (endPos - midPos).Magnitude
    local dur2 = math.max(dist2 / speed, 0.1)
    
    print(string.format("[Arc] Down: %.0f studs / %.2fs", dist2, dur2))
    
    local tween2 = TweenService:Create(
        hrp,
        TweenInfo.new(dur2, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
        { CFrame = targetCF }
    )
    tween2:Play()
    
    pcall(function()
        tween2.Completed:Wait()
    end)
    task.wait(0.1)
    
    return true
end




local function tweenSpeed(hrp, targetCF, speed)
    if not hrp or not targetCF then return false end
    speed = speed or 200

    enableNoclip()
    task.wait(0.05)

    local distance = (targetCF.Position - hrp.Position).Magnitude
    local duration = math.max(distance / speed, 0.1)

    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

    local tween = TweenService:Create(hrp, tweenInfo, { CFrame = targetCF })
    tween:Play()

    local done = false
    pcall(function()
        tween.Completed:Wait()
        done = true
    end)

    task.wait(0.1)
    return done
end


-- ===== HELPER: Walk with Y-axis bob (umaakyat-bumababa habang naglalakad) =====
local function walkWithBob(hrp, targetCF, speed, bobHeight, bobDelay)
    if not hrp or not targetCF then return false end
    speed = speed or 3000
    bobHeight = bobHeight or 8      -- Taas ng bob (studs)
    bobDelay = bobDelay or 0.15     -- Pause per bob step

    enableNoclip()
    task.wait(0.05)

    local startPos = hrp.Position
    local endPos = targetCF.Position
    local totalDist = (endPos - startPos).Magnitude

    -- Hatiin sa chunks â€” bawat chunk may up-down
    local CHUNKS = 5
    for i = 1, CHUNKS do
        local progress = i / CHUNKS
        local basePos = startPos:Lerp(endPos, progress)

        -- Up position (taas)
        local upPos = basePos + Vector3.new(0, bobHeight, 0)
        tweenSpeed(hrp, CFrame.new(upPos, endPos), speed)
        task.wait(bobDelay)

        -- Down position (baba) â€” same basePos
        tweenSpeed(hrp, CFrame.new(basePos, endPos), speed)
        task.wait(bobDelay)
    end

    -- Final: tween sa exact target
    tweenSpeed(hrp, targetCF, speed)
    return true
end


-- ===== HELPER: Bob up-down (parang nag-ccount) =====
local function bobUpDown(hrp, baseCF, times, speedPerBob)
    times = times or 3
    speedPerBob = speedPerBob or 4000

    local upCF = baseCF + Vector3.new(0, 8, 0)  -- Taas ng bob

    for i = 1, times do
        tweenSpeed(hrp, upCF, speedPerBob)
        task.wait(0.05)
        tweenSpeed(hrp, baseCF, speedPerBob)
        task.wait(0.05)
    end
end


-- ===== HELPER: Check if player is in Halloween Area =====
local function isInHalloweenArea(hrp)
    if not hrp then return false end
    
    local halloween = Workspace:FindFirstChild("HalloweenArea")
    if not halloween then return false end
    
    -- Method 1: Bounding box check (pinaka-accurate)
    local ok, cf, size = pcall(function()
        return halloween:GetBoundingBox()
    end)
    
    if ok and cf and size then
        -- Expand para siguradong kasama yung player
        local expandedSize = size + Vector3.new(100, 100, 100)
        local relativePos = cf:PointToObjectSpace(hrp.Position)
        local halfSize = expandedSize / 2
        
        if math.abs(relativePos.X) <= halfSize.X
           and math.abs(relativePos.Y) <= halfSize.Y
           and math.abs(relativePos.Z) <= halfSize.Z then
            return true
        end
    end
    
    -- Method 2: Distance sa nearest part
    local minDist = math.huge
    for _, part in ipairs(halloween:GetDescendants()) do
        if part:IsA("BasePart") then
            local d = (hrp.Position - part.Position).Magnitude
            if d < minDist then minDist = d end
            -- Early exit kung malapit na
            if minDist < 300 then return true end
        end
    end
    
    -- Method 3: Distance sa pivot (fallback)
    if minDist == math.huge then
        local ok2, pivot = pcall(function() return halloween:GetPivot() end)
        if ok2 and pivot then
            local d = (hrp.Position - pivot.Position).Magnitude
            return d < 1000
        end
    end
    
    return minDist < 500
end

-- ===== HELPER: Fire Halloween Portal (going TO halloween) =====
local function fireHalloweenPortalToHalloween()
    local ok, prompt = pcall(function()
        return Workspace.HalloweenArea
            .Portal.Model.Model
            .Part.HalloweenPromptAnchor.HalloweenPortalPrompt
    end)
    
    if not ok or not prompt then
        warn("[Location] Hindi mahanap ang halloween portal prompt (to halloween)!")
        return false
    end
    
    -- Teleport near portal muna
    local portal = Workspace.HalloweenArea.Portal.Model.Model:FindFirstChild("portal")
    if portal and portal:IsA("BasePart") then
        -- tweenSpeed(hrp, portal.CFrame + Vector3.new(0, 5, 0), 20000)
        -- â†‘ gagamitin natin sa caller, para may access sa hrp
    end
    
    local success = pcall(function()
        fireproximityprompt(prompt)
    end)
    
    print("[Location] Fired halloween portal (to halloween):", success)
    return success
end

-- ===== HELPER: Fire Portal to Main Map (going back) =====
local function firePortalToMainMap(hrp)
    local ok, portalModel = pcall(function()
        return Workspace.Map.Portal.Model:GetChildren()[7]
    end)
    
    if not ok or not portalModel then
        warn("[Location] Hindi mahanap ang main map portal!")
        return false
    end
    
    -- Teleport to portal muna
    local portalPart = portalModel:FindFirstChild("portal")
    if portalPart and portalPart:IsA("BasePart") and hrp then
        tweenSpeed(hrp, portalPart.CFrame + Vector3.new(0, 5, 0), 20000)
        task.wait(0.3)
    end
    
    -- Fire prompt
    local promptOk, prompt = pcall(function()
        return portalModel.Part.HalloweenPromptAnchor.HalloweenPortalPrompt
    end)
    
    if not promptOk or not prompt then
        warn("[Location] Hindi mahanap ang main map portal prompt!")
        return false
    end
    
    local success = pcall(function()
        fireproximityprompt(prompt)
    end)
    
    print("[Location] Fired main map portal:", success)
    return success
end







-- ===== HELPER: Post-drop flow (arc pattern) =====
local function postDropFlow(hrp, targetEggName)
    -- ===== AUTO DIP =====
    if _G.AutoDipEnabled then
        tweenSpeed(hrp, DROP_CFRAME, 5000)
        task.wait(0.1)

        fireVolcanoDip()
        task.wait(0.1)

        print("[AutoCollect] Auto Dip ON â€” Waiting 10 seconds...")
        task.wait(10)
    end

    -- ===== GET HOME POSITION =====
    local myPlot = getMyPlot()
    local plotCenter = getPlotCenterCFrame(myPlot)

    if not plotCenter then
        warn("[AutoCollect] Plot not found!")
        return
    end

    local homeCF = plotCenter + Vector3.new(0, 5, 0)

    -- ===== ðŸŽ¯ WAITING AREA (side ng home) =====
    local SIDE_DISTANCE = 200
    local waitCF = CFrame.new(
        homeCF.Position + Vector3.new(SIDE_DISTANCE, 0, 0),
        homeCF.Position
    )

    -- ===== ðŸŽ¬ STEP 1: ARC TWEEN PAPUNTANG WAITING AREA (MABAGAL) =====
print("[AutoCollect] Arc flying SLOW to waiting area...")
arcTween(hrp, waitCF, 240, 800)  -- âš ï¸ 300 studs/sec
task.wait(0.1)

    -- ===== â±ï¸ STEP 2: WAIT SA WAITING AREA =====
    print("[AutoCollect] Waiting at side...")
    task.wait(5)

    -- ===== ðŸŽ¬ STEP 3: TWEEN SA HOME BASE =====
    print("[AutoCollect] Going home...")
    tweenSpeed(hrp, homeCF, 5000)
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







                    -- Step 1: TELEPORT â†’ SPOT 1 (Entrance)



                    teleportTo(hrp, SPOT_1)



                    task.wait(0.3)







                    if entrance then



                        triggerTouched(entrance, character)



                    end



                    task.wait(0.5)







                    -- Step 2: TWEEN â†’ SPOT 2 (Validate)



                    stableTween(hrp, SPOT_2, 1.5)



                    task.wait(0.3)







                    if validate then



                        triggerTouched(validate, character)



                    end



                    task.wait(0.5)







    tweenSpeed(hrp, SPOT_3, 3000)
task.wait(0.3)





                    -- Step 4: Instant fire prompt



                    if prompt then



                        firePrompt(prompt)



                        task.wait(0.5)



                    end







                    -- ===== EXIT =====







                  -- Step 5: ðŸŽ¬ TWEEN â†’ SPOT 2 (Validate)
tweenSpeed(hrp, SPOT_2, 3000)
task.wait(0.3)







                    -- Step 6: TWEEN â†’ SPOT 1 (Entrance)



                    stableTween(hrp, SPOT_1, 1.5)



                    task.wait(0.5)







                    -- Step 7+: Post-drop flow (Dip toggle dependent)



                    -- dati:

-- postDropFlow(hrp)



-- gawin:

-- Step 7+: Post-drop flow
postDropFlow(hrp, "Volcanic Egg")

-- ✅ FLY OFF + NOCLIP OFF
task.wait(0.5)
disableFly()
disableNoclip()

-- ✅✅✅ RESET FLAG PAGKA-TAPOS NG VOLCANIC
_G.EggCollecting = false
print("[AutoEgg] 🔓 EggCollecting = false (volcanic done)")

return true



                end




-- ===== CHECK KUNG EGG AY NASA HALLOWEEN =====
local function isEggInHalloween(eggModel)
    if not eggModel then return false end
    local ha = Workspace:FindFirstChild("HalloweenArea")
    if not ha then return false end
    return eggModel:IsDescendantOf(ha)
end


-- ===== CHECK KUNG NASA HALLOWEEN AREA =====
local function isInHalloweenArea(hrp)
    if not hrp then return false end
    local refCF = CFrame.new(-46059.078, 40382.543, -20351.945)
    local dist = (hrp.Position - refCF.Position).Magnitude
    return dist < 2000
end


-- ===== MAIN LOOP (CLEAN VERSION) =====
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

    -- ===== HANAPIN ANG EGG =====
    local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
    if not renderedEggs then
        task.wait(1)
        continue
    end

    local targetCFrame = nil
    local foundPrompt = nil
    local targetEggName = nil

    -- Build selected list
    local selectedLower = {}
    for name, _ in pairs(_G.SelectedEggTargets) do
        table.insert(selectedLower, name:lower())
    end

    -- Search egg
    for _, eggModel in ipairs(renderedEggs:GetChildren()) do
        local eggNameLower = eggModel.Name:lower()
        local matched = false
        
        for _, selName in ipairs(selectedLower) do
            if eggNameLower:find(selName, 1, true) then
                matched = true
                break
            end
        end

        if matched then
            local pickup = eggModel:FindFirstChild("Pickup", true)
            if pickup then
                local targetPart = pickup
                if pickup:IsA("ProximityPrompt") then
                    foundPrompt = pickup
                    targetPart = pickup.Parent
                end

                if targetPart and targetPart:IsA("BasePart") then
                    targetCFrame = targetPart.CFrame
                elseif eggModel:IsA("Model") then
                    if eggModel.PrimaryPart then
                        targetCFrame = eggModel.PrimaryPart.CFrame
                    else
                        local ok, pivot = pcall(function() return eggModel:GetPivot() end)
                        if ok and pivot then targetCFrame = pivot end
                    end
                end

                if targetCFrame then
                    targetEggName = eggModel.Name
                    break
                end
            end
        end
    end

    if not targetCFrame then
        task.wait(0.5)
        continue
    end

    -- ✅ DISTANCE CHECK — kung malayo, skip (Auto Candy na bahala)
    local distToEgg = (targetCFrame.Position - hrp.Position).Magnitude
    
    if distToEgg > 10000 then
        print("[AutoEgg] ⏸️ Egg malayo (" .. math.floor(distToEgg) .. " studs) — hintay Auto Candy")
        task.wait(0.5)
        continue
    end

    -- ✅ MALAPIT NA — SET FLAG + COLLECT
    _G.EggCollecting = true
    print("[AutoEgg] ✅ Collecting:", targetEggName)

    -- ===== VOLCANIC EGG =====
    if targetEggName == "Volcanic Egg" then
        volcanicSequence(hrp, foundPrompt)
        task.wait(0.5)
        _G.EggCollecting = false
        print("[AutoEgg] 🔓 EggCollecting = false (volcanic)")
        continue
    end

    -- ===== NORMAL EGG =====
    enableFly()
    task.wait(0.3)

    tweenSpeed(hrp, targetCFrame + Vector3.new(0, 3, 0), 3000)
    task.wait(0.3)

    if foundPrompt and foundPrompt:IsA("ProximityPrompt") then
        firePrompt(foundPrompt)
        task.wait(0.3)
        postDropFlow(hrp, targetEggName)
    end

    disableFly()
    disableNoclip()

    _G.EggCollecting = false
    print("[AutoEgg] 🔓 EggCollecting = false (normal)")
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





Tabs.EventTab:Toggle({
    Title = "Auto Collect Candy",
    Desc = "Auto collect candy at i-drop sa CandyDropOff",
    Flag = "AutoCandyToggle",
    Value = false,
    Callback = function(state)
        _G.AutoCandyEnabled = state
        _G.ExitingHalloween = false  -- ✅ Reset flag
        
        if not state then 
            _G.ExitingHalloween = false
            print("[AutoCandy] OFF 🛑")
            return 
        end
        
        print("[AutoCandy] ON 🍬")

        task.spawn(function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local RunService = game:GetService("RunService")
            local TweenService = game:GetService("TweenService")
            local player = Players.LocalPlayer

            local SPOT_COOLDOWN = 6
            local SPOT_FAIL_COOLDOWN = 30
            local PROMPT_WAIT = 0.5
            local RETURN_SPEED = 2000
            local DROPOFF_WAIT = 1

            -- ===== HARDCODED PORTAL POSITIONS =====
            local ENTER_PORTAL_CF = CFrame.new(197.624, 40325.387, 674.741)
            local LEAVE_PORTAL_CF = CFrame.new(-46059.078, 40382.543, -20351.945)

            -- ===== GET ENTER PORTAL PROMPT =====
            local function getEnterPortalPrompt()
                local ok, prompt = pcall(function()
                    return Workspace.Map.Portal
                        .Model.Model.Model.Model
                        .portal.Part
                        .HalloweenPromptAnchor
                        .HalloweenPortalPrompt
                end)
                if ok and prompt then return prompt end
                
                local map = Workspace:FindFirstChild("Map")
                if map then
                    local portal = map:FindFirstChild("Portal")
                    if portal then
                        for _, d in ipairs(portal:GetDescendants()) do
                            if d.Name == "HalloweenPortalPrompt" and d:IsA("ProximityPrompt") then
                                return d
                            end
                        end
                    end
                end
                
                warn("[Portal] ❌ Enter portal prompt not found!")
                return nil
            end

            -- ===== GET LEAVE PORTAL PROMPT =====
            local function getLeavePortalPrompt()
                local ok, prompt = pcall(function()
                    return Workspace.HalloweenArea.Portal
                        .Model.Model
                        .Part
                        .HalloweenPromptAnchor
                        .HalloweenPortalPrompt
                end)
                if ok and prompt then return prompt end
                
                local ha = Workspace:FindFirstChild("HalloweenArea")
                if ha then
                    local portal = ha:FindFirstChild("Portal")
                    if portal then
                        for _, d in ipairs(portal:GetDescendants()) do
                            if d.Name == "HalloweenPortalPrompt" and d:IsA("ProximityPrompt") then
                                return d
                            end
                        end
                    end
                end
                
                warn("[Portal] ❌ Leave portal prompt not found!")
                return nil
            end

            local function getHRP()
                local c = player.Character
                return c and c:FindFirstChild("HumanoidRootPart")
            end

            -- ===== LOCATION DETECTION =====
            local function isInHalloweenArea(hrp)
                if not hrp then return false end
                local halloween = Workspace:FindFirstChild("HalloweenArea")
                if not halloween then return false end
                local distance = (hrp.Position - LEAVE_PORTAL_CF.Position).Magnitude
                return distance < 2000
            end

            -- ===== GO TO HALLOWEEN =====
            local function goToHalloweenArea(hrp)
                if not hrp then return false end
                print("[AutoCandy] Pupunta sa Halloween Area...")
                
                local prompt = getEnterPortalPrompt()
                if not prompt then return false end
                
                local promptPos = ENTER_PORTAL_CF.Position
                local parent = prompt.Parent
                if parent and parent:IsA("BasePart") then
                    promptPos = parent.Position
                elseif parent and parent:IsA("Model") then
                    local ok, pivot = pcall(function() return parent:GetPivot() end)
                    if ok and pivot then promptPos = pivot.Position end
                end
                
                local approachCF = CFrame.new(promptPos + Vector3.new(0, 3, 0), promptPos)
                local distance = (approachCF.Position - hrp.Position).Magnitude
                local duration = math.max(distance / 20000, 0.1)
                
                local tw = TweenService:Create(hrp,
                    TweenInfo.new(duration, Enum.EasingStyle.Linear),
                    { CFrame = approachCF })
                tw:Play()
                tw.Completed:Wait()
                task.wait(0.5)
                
                local waitStart = tick()
                while not prompt.Enabled and (tick() - waitStart) < 3 do
                    task.wait(0.2)
                end
                
                local fired = false
                for attempt = 1, 8 do
                    if prompt.Enabled then
                        pcall(function() fireproximityprompt(prompt) end)
                        task.wait(0.3)
                        if not prompt.Enabled then
                            fired = true
                            break
                        end
                    end
                    task.wait(0.3)
                end
                
                if fired then
                    print("[AutoCandy] ✅ Enter portal fired!")
                    task.wait(3)
                    return true
                end
                
                warn("[AutoCandy] ❌ Enter portal fail!")
                return false
            end

            -- ===== GO TO MAIN MAP =====
            local function goToMainMap(hrp)
                if not hrp then return false end
                print("[AutoCandy] Bumalik sa Main Map...")
                
                local prompt = getLeavePortalPrompt()
                if not prompt then return false end
                
                local promptPos = LEAVE_PORTAL_CF.Position
                local okPart, part = pcall(function()
                    return Workspace.HalloweenArea.Portal
                        .Model.Model
                        .Part
                end)
                if okPart and part and part:IsA("BasePart") then
                    promptPos = part.Position
                end
                
                local approachCF = CFrame.new(promptPos + Vector3.new(0, 3, 0), promptPos)
                local distance = (approachCF.Position - hrp.Position).Magnitude
                local duration = math.max(distance / 20000, 0.1)
                
                local tw = TweenService:Create(hrp,
                    TweenInfo.new(duration, Enum.EasingStyle.Linear),
                    { CFrame = approachCF })
                tw:Play()
                tw.Completed:Wait()
                task.wait(0.5)
                
                local waitStart = tick()
                while not prompt.Enabled and (tick() - waitStart) < 3 do
                    task.wait(0.2)
                end
                
                local fired = false
                for attempt = 1, 8 do
                    if prompt.Enabled then
                        pcall(function() fireproximityprompt(prompt) end)
                        task.wait(0.3)
                        if not prompt.Enabled then
                            fired = true
                            break
                        end
                    end
                    task.wait(0.3)
                end
                
                if fired then
                    print("[AutoCandy] ✅ Leave portal fired!")
                    task.wait(3)
                    return true
                end
                
                warn("[AutoCandy] ❌ Leave portal fail!")
                return false
            end

            -- ===== NOCLIP =====
            local noclipConn = nil
            local function enableNoclip()
                if noclipConn then return end
                noclipConn = RunService.Stepped:Connect(function()
                    local c = player.Character
                    if c then
                        for _, p in ipairs(c:GetDescendants()) do
                            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                        end
                    end
                end)
            end
            local function disableNoclip()
                if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
            end

            -- ===== LOCK =====
            local lockedCFrame, lockConn = nil, nil
            local function startLock(cf)
                lockedCFrame = cf
                if lockConn then lockConn:Disconnect() end
                lockConn = RunService.RenderStepped:Connect(function()
                    local hrp = getHRP()
                    if hrp and lockedCFrame then
                        hrp.CFrame = lockedCFrame
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end)
            end
            local function stopLock()
                lockedCFrame = nil
                if lockConn then lockConn:Disconnect(); lockConn = nil end
            end

            -- ===== TWEEN HOME =====
            local function tweenHome(hrp, targetCF, speed)
                if not hrp or not targetCF then return end
                local distance = (targetCF.Position - hrp.Position).Magnitude
                local duration = distance / speed
                if duration < 0.05 then hrp.CFrame = targetCF; return end
                stopLock()
                local tw = TweenService:Create(hrp,
                    TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCF})
                tw:Play()
                tw.Completed:Wait()
            end

            -- ===== FOLDER FINDERS =====
            local function findFolder(name)
                local direct = Workspace:FindFirstChild(name)
                if direct then return direct end
                local ha = Workspace:FindFirstChild("HalloweenArea")
                if ha then return ha:FindFirstChild(name) end
                return nil
            end

            local function getCFrameOf(inst)
                if not inst then return nil end
                if inst:IsA("BasePart") then return inst.CFrame end
                if inst:IsA("Model") then
                    if inst.PrimaryPart then return inst.PrimaryPart.CFrame end
                    local p = inst:FindFirstChildWhichIsA("BasePart", true)
                    if p then return p.CFrame end
                    local ok, pv = pcall(function() return inst:GetPivot() end)
                    if ok and pv then return pv end
                end
                local p = inst:FindFirstChildWhichIsA("BasePart", true)
                return p and p.CFrame or nil
            end

            local function getPromptFromSpot(spot)
                if not spot then return nil end
                local pk = spot:FindFirstChild("Pickup")
                if pk and (pk:IsA("ProximityPrompt") or pk:IsA("ClickDetector")) then return pk end
                local p = spot:FindFirstChildWhichIsA("ProximityPrompt", true)
                if p then return p end
                return spot:FindFirstChildWhichIsA("ClickDetector", true)
            end

            local function firePrompt(prompt)
                if not prompt then return false end
                if prompt:IsA("ProximityPrompt") then
                    return pcall(function() fireproximityprompt(prompt) end)
                elseif prompt:IsA("ClickDetector") then
                    return pcall(function() fireclickdetector(prompt) end)
                end
                return false
            end

            local cooldowns, blacklist = {}, {}
while _G.AutoCandyEnabled do
    task.wait(0.2)

    local hrp = getHRP()
    if not hrp then task.wait(0.5); continue end

    -- ✅✅✅ PRIORITY CHECK 0: AUTO BUY EGG IN PROGRESS
    if _G.AutoBuyingEgg then
        print("[AutoCandy] ⏸️ Auto Buy Egg in progress — WAIT")
        while _G.AutoCandyEnabled and _G.AutoBuyingEgg do
            task.wait(0.2)
        end
        print("[AutoCandy] ▶️ Auto Buy done — resume")
        task.wait(0.3)
        continue
    end

    -- ✅ PRIORITY CHECK 1: BUSY FLAG
    if _G.EggCollecting then
        -- ... existing code
        print("[AutoCandy] ⏸️ Egg in progress — WAIT")
        while _G.AutoCandyEnabled and _G.EggCollecting do
            task.wait(0.2)
        end
        print("[AutoCandy] ▶️ Resume")
        task.wait(0.3)
        continue
    end

    -- ✅ PRIORITY CHECK 2: MAY TARGET EGG BA
    local hasTargetEgg = false
    -- ... (existing code mo)
    -- ... rest ng code
local renderedEggs = Workspace:FindFirstChild("RenderedEggs")

if renderedEggs and _G.AutoEggEnabled then
    local selectedLower = {}
    if _G.SelectedEggTargets then
        for name, _ in pairs(_G.SelectedEggTargets) do
            table.insert(selectedLower, name:lower())
        end
    end
    
    for _, eggModel in ipairs(renderedEggs:GetChildren()) do
        local modelNameLower = eggModel.Name:lower()
        
        local matched = false
        for _, selName in ipairs(selectedLower) do
            if modelNameLower:find(selName, 1, true) then
                matched = true
                break
            end
        end
        
        if matched then
            if eggModel:FindFirstChild("Pickup", true) then
                hasTargetEgg = true
                print("[AutoCandy] 🥚 Egg detected:", eggModel.Name)
                break
            end
        end
    end
end

-- ✅ CHECK 1: MAY TARGET EGG BA?
if hasTargetEgg then
    print("[AutoCandy] ⏸️ May target egg — PAUSE")
    
    -- ✅ KUNG NAKA-FLAG NA AUTO EGG, WAIT LANG
    if _G.EggCollecting then
        print("[AutoCandy] ⏸️ Auto Egg collecting — WAIT")
        while _G.AutoCandyEnabled and _G.EggCollecting do
            task.wait(0.3)
        end
        task.wait(0.3)
        continue
    end
    
    -- ✅ WALANG NAG-CO-COLLECT PA — TELEPORT SA HOME BASE
    local inHalloweenNow = isInHalloweenArea(hrp)
    
    if inHalloweenNow then
        print("[AutoCandy] 🏠 Nasa Halloween — teleport sa home base")
        
        -- Get plot
        local myPlot = nil
        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                local data = plot:FindFirstChild("Data")
                local owner = data and data:FindFirstChild("Owner")
                if owner then
                    if owner:IsA("ObjectValue") and owner.Value == player then
                        myPlot = plot
                        break
                    elseif owner:IsA("StringValue") 
                        and (owner.Value == player.Name or owner.Value == player.DisplayName) then
                        myPlot = plot
                        break
                    end
                end
            end
        end
        
        if myPlot then
            local plotCenter = nil
            if myPlot.PrimaryPart then
                plotCenter = myPlot.PrimaryPart.CFrame
            else
                for _, partName in ipairs({"Spawn", "Base", "Center", "Home"}) do
                    local part = myPlot:FindFirstChild(partName, true)
                    if part and part:IsA("BasePart") then
                        plotCenter = part.CFrame
                        break
                    end
                end
            end
            
            if plotCenter then
                enableNoclip()
                local targetCF = plotCenter + Vector3.new(0, 5, 0)
                hrp.CFrame = targetCF
                task.wait(0.3)
                disableNoclip()
                
                print("[AutoCandy] ✅ Teleported sa home base!")
                task.wait(0.5)
            end
        end
    else
        print("[AutoCandy] Nasa Main Map na — hintayin Auto Egg")
    end
    
    -- ✅ SIMPLE WAIT + CONTINUE (walang complex loop)
    task.wait(1)
    continue
end



-- ✅✅✅ IDAGDAG ITO — PRIORITY CHECK 3
if _G.EggCollecting then
    print("[AutoCandy] ⏸️ Nag-start na Auto Egg — skip candy")
    task.wait(0.3)
    continue
end

-- ✅✅✅ IDAGDAG ITO — LOCATION CHECK
local inHalloween = isInHalloweenArea(hrp)
_G.CurrentLocation = inHalloween and "Halloween Area" or "Main Map"
print("[AutoCandy] Location:", _G.CurrentLocation)

if not inHalloween then
    print("[AutoCandy] 🎯 Nasa Main Map — pumasok sa Halloween via portal")
    
    local enterSuccess = goToHalloweenArea(hrp)
    
    if enterSuccess then
        print("[AutoCandy] ✅ Nakapasok sa Halloween — collect candy na")
        task.wait(1)
        continue
    else
        warn("[AutoCandy] ❌ Enter portal fail — retry next iteration")
        task.wait(2)
        continue
    end
end

-- ===== NASA HALLOWEEN NA — COLLECT CANDY =====
local candySpawns = findFolder("CandySpawns")
local candyFolder = findFolder("HalloweenCandy")
local dropOff = Workspace:FindFirstChild("CandyDropOff")

if not candySpawns or not candyFolder or not dropOff then
    task.wait(1); continue
end

-- ... rest ng candy collection code mo


                local candyList = {}
                for _, candy in ipairs(candyFolder:GetChildren()) do
                    local cf = getCFrameOf(candy)
                    if cf then table.insert(candyList, {candy = candy, cf = cf}) end
                end

                if #candyList == 0 then
                    print("[AutoCandy] Walang candy sa HalloweenCandy")
                    task.wait(1)
                    continue
                end

                local markers = {}
                for _, spot in ipairs(candySpawns:GetChildren()) do
                    local cf = getCFrameOf(spot)
                    if cf then table.insert(markers, {spot = spot, cf = cf}) end
                end

                local candyMap = {}
                for _, ce in ipairs(candyList) do
                    local bestMarker, bestDist = nil, math.huge
                    for _, m in ipairs(markers) do
                        local d = (m.cf.Position - ce.cf.Position).Magnitude
                        if d < bestDist then bestMarker = m.spot; bestDist = d end
                    end
                    if bestMarker then
                        candyMap[bestMarker.Name] = {candy = ce.candy, cf = ce.cf, marker = bestMarker}
                    end
                end

                local target, targetName, bestPlayerDist = nil, nil, math.huge
                for name, entry in pairs(candyMap) do
                    if (cooldowns[name] or 0) > tick() then continue end
                    if blacklist[name] and blacklist[name] > tick() then continue end
                    local d = (entry.cf.Position - hrp.Position).Magnitude
                    if d < bestPlayerDist then
                        bestPlayerDist = d
                        target = entry
                        targetName = name
                    end
                end

                if not target then 
                    print("[AutoCandy] Walang target candy (naka-cooldown?)")
                    task.wait(0.3)
                    continue 
                end

                print("[AutoCandy] 🎯 Target:", targetName, "| Dist:", math.floor(bestPlayerDist))

                enableNoclip()
                startLock(target.cf + Vector3.new(0, 3, 0))
                task.wait(PROMPT_WAIT)

                local prompt = getPromptFromSpot(target.marker)
                if not prompt then
                    blacklist[targetName] = tick() + SPOT_FAIL_COOLDOWN
                    stopLock()
                    continue
                end

                local fired = false
                for i = 1, 8 do
                    if not _G.AutoCandyEnabled then break end
                    firePrompt(prompt)
                    task.wait(0.12)
                    if not prompt.Parent or not prompt.Enabled then fired = true; break end
                end

                if fired then
                    cooldowns[targetName] = tick() + SPOT_COOLDOWN
                    local dropCF = getCFrameOf(dropOff)
                    if dropCF then tweenHome(hrp, dropCF + Vector3.new(0, 3, 0), RETURN_SPEED) end
                    task.wait(DROPOFF_WAIT)
                else
                    blacklist[targetName] = tick() + SPOT_FAIL_COOLDOWN
                end

                stopLock()
                task.wait(0.1)
            end

            stopLock()
            disableNoclip()
            print("[AutoCandy] Stopped 🛑")
        end)
    end,
}) 












-- ===== Toggle para sa Auto Buy Halloween Egg =====
Tabs.EventTab:Toggle({
    Title = "Auto Buy Halloween Egg",
    Desc = "Bumili ng Halloween Egg kapag may 350+ tokens",
    Flag = "AutoBuyHalloweenEgg",
    Value = false,
Callback = function(state)
    _G.AutoBuyHalloweenEgg = state
    
    -- ✅ RESET FLAG KAPAG NAG-OFF
    if not state then
        _G.AutoBuyingEgg = false
    
        return
    end
    

    
    task.spawn(function()
        -- ... existing code mo
                local Players = game:GetService("Players")
                local Workspace = game:GetService("Workspace")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local player = Players.LocalPlayer

                -- ===== CONFIG =====
                local TOKEN_THRESHOLD = 350
                local CHECK_INTERVAL = 1
                local TELEPORT_WAIT = 0.8
                local BUY_COOLDOWN = 2

                -- ===== TELEPORT =====
                local function teleportTo(cf)
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return false end
                    pcall(function() hrp.CFrame = cf end)
                    return true
                end

                -- ===== GET TOKEN COUNT =====
                local function getTokenCount()
                    local ok, num, raw = pcall(function()
                        local pg = player.PlayerGui
                        if not pg then return nil, nil end
                        local main = pg:FindFirstChild("Main")
                        if not main then return nil, nil end

                        local currency = main:FindFirstChild("Currency")
                        if not currency then
                            currency = main:FindFirstChild("CurrencyMobile")
                        end

                        if currency then
                            local ht = currency:FindFirstChild("HalloweenTokens")
                            if ht then
                                local c = ht:FindFirstChild("Count")
                                if c and c:IsA("TextLabel") then
                                    local text = c.Text or ""
                                    local parsed = tonumber((text:gsub("[^%d%.%-]", "")))
                                    if parsed then return parsed, text end
                                end
                            end
                        end

                        -- Fallback: deep search
                        for _, d in ipairs(pg:GetDescendants()) do
                            if d.Name == "HalloweenTokens" then
                                local c = d:FindFirstChild("Count")
                                if c and c:IsA("TextLabel") then
                                    local text = c.Text or ""
                                    local parsed = tonumber((text:gsub("[^%d%.%-]", "")))
                                    if parsed then return parsed, text end
                                end
                            end
                        end

                        return nil, nil
                    end)

                    if ok then return num, raw end
                    return nil, nil
                end

                -- ===== GET CFrame =====
                local function getCFrameOf(inst)
                    if not inst then return nil end
                    if inst:IsA("BasePart") then return inst.CFrame end
                    if inst:IsA("Model") then
                        if inst.PrimaryPart then return inst.PrimaryPart.CFrame end
                        local part = inst:FindFirstChildWhichIsA("BasePart", true)
                        if part then return part.CFrame end
                        local ok, pivot = pcall(function() return inst:GetPivot() end)
                        if ok and pivot then return pivot end
                    end
                    local part = inst:FindFirstChildWhichIsA("BasePart", true)
                    return part and part.CFrame or nil
                end

                -- ===== FIRE BUY =====
                local function fireBuy()
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local gameRemotes = remotes and remotes:FindFirstChild("Game")
                    local buyRemote = gameRemotes and gameRemotes:FindFirstChild("BuyHalloweenEgg")

                    if not buyRemote then
               
                        return false
                    end

                    local ok = pcall(function()
                        if buyRemote:IsA("RemoteFunction") then
                            buyRemote:InvokeServer("Halloween Egg")
                        elseif buyRemote:IsA("RemoteEvent") then
                            buyRemote:FireServer("Halloween Egg")
                        end
                    end)

                    if not ok then
             
                    end
                    return ok
                end

                -- ===== MAIN LOOP =====
      
                local lastBuy = 0

                while _G.AutoBuyHalloweenEgg do
                    task.wait(CHECK_INTERVAL)

                    if tick() - lastBuy < BUY_COOLDOWN then
                        continue
                    end

                    -- ===== 1. CHECK TOKENS =====
                    local tokens, rawText = getTokenCount()

                    if not tokens then
                
                        task.wait(1)
                        continue
                    end

                   -- ===== 2. IF ENOUGH → BUY =====
if tokens >= TOKEN_THRESHOLD then
    local shopGuy = Workspace:FindFirstChild("ShopGuy")
    if not shopGuy then
 
        task.wait(2)
        continue
    end

    local shopCF = getCFrameOf(shopGuy)
    if not shopCF then
     
        task.wait(2)
        continue
    end

    -- ✅✅✅ SET FLAG — PAUSE AUTO CANDY
    _G.AutoBuyingEgg = true

    task.wait(0.3)


    teleportTo(shopCF + Vector3.new(0, 3, 0))
    task.wait(TELEPORT_WAIT)


    local success = fireBuy()
    task.wait(0.5)

    if not success then
     
        fireBuy()
        task.wait(0.5)
    end

    lastBuy = tick()
    

    -- ✅✅✅ RESET FLAG — RESUME AUTO CANDY
    task.wait(0.3)
    _G.AutoBuyingEgg = false
 
else

end
                end

         
            end)
        
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



local CONFIG_NAME = "IOHUB_RideAPet"  -- â¬…ï¸ fixed name







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















--------------------------------------------------



-- SERVER HOP (SETTING TAB)



--------------------------------------------------







-- Storage ng recent servers (para iwasan)



local RECENT_FILE = "IOHUB2_recent_servers.json"



local MAX_RECENT = 5







-- Helper: Kunin yung recent servers list



local function getRecentServers()



    local HttpService = game:GetService("HttpService")



    local recent = {}







    pcall(function()



        if isfile(RECENT_FILE) then



            local data = HttpService:JSONDecode(readfile(RECENT_FILE))



            if type(data) == "table" then



                recent = data



            end



        end



    end)







    return recent



end







-- Helper: I-save yung recent servers list



local function saveRecentServers(list)



    local HttpService = game:GetService("HttpService")



    pcall(function()



        writefile(RECENT_FILE, HttpService:JSONEncode(list))



    end)



end







-- Helper: Idagdag yung current server sa recent list



local function addRecentServer(jobId)



    if not jobId or jobId == "" then return end







    local recent = getRecentServers()







    for i, id in ipairs(recent) do



        if id == jobId then



            table.remove(recent, i)



            break



        end



    end







    table.insert(recent, 1, jobId)







    while #recent > MAX_RECENT do



        table.remove(recent)



    end







    saveRecentServers(recent)



end







-- Helper: Kunin yung server list via Roblox API



local function fetchServerList(placeId)



    local HttpService = game:GetService("HttpService")







    local url = string.format(



        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",



        placeId



    )







    local success, response = pcall(function()



        return HttpService:RequestAsync({



            Url = url,



            Method = "GET",



        })



    end)







    if not success or not response or not response.Success then



        return nil



    end







    local ok, decoded = pcall(function()



        return HttpService:JSONDecode(response.Body)



    end)







    if not ok or not decoded or not decoded.data then



        return nil



    end







    return decoded.data



end







-- ===== BUTTON: Server Hop =====



Tabs.SettingTab:Button({



    Title = "Server Hop",



    Desc = "Leave and Rejoin to Different Server",



    Callback = function()



        local TeleportService = game:GetService("TeleportService")



        local Players = game:GetService("Players")



        local player = Players.LocalPlayer







        local currentJobId = game.JobId



        local placeId = game.PlaceId







        if not currentJobId or currentJobId == "" then



            WindUI:Notify({



                Title = "Error",



                Content = "Walang JobId (baka sa Studio ka nagte-test).",



                Icon = "solar:danger-bold",



                Duration = 3,



            })



            return



        end







        WindUI:Notify({



            Title = "Server Hop",



            Content = "Naghahanap ng bagong server...",



            Icon = "solar:refresh-bold",



            Duration = 3,



        })







        task.spawn(function()



            -- Idagdag yung current server sa recent list



            addRecentServer(currentJobId)







            -- Kunin lahat ng recent servers



            local recentServers = getRecentServers()



            local recentSet = {}



            for _, id in ipairs(recentServers) do



                recentSet[id] = true



            end







            -- Kunin yung server list



            local servers = fetchServerList(placeId)







            if not servers or #servers == 0 then



                WindUI:Notify({



                    Title = "Fallback",



                    Content = "Walang server list, random join.",



                    Icon = "solar:danger-bold",



                    Duration = 3,



                })







                pcall(function()



                    TeleportService:Teleport(placeId, player)



                end)



                return



            end







            -- Filter: alisin yung recent at current



            local validServers = {}



            for _, server in ipairs(servers) do



                local serverId = server.id



                local playerCount = server.playing or 0



                local maxPlayers = server.maxPlayers or 0







                if serverId 



                   and serverId ~= currentJobId 



                   and not recentSet[serverId] 



                   and playerCount < maxPlayers then



                    table.insert(validServers, server)



                end



            end







            -- Kung walang valid, alisin na lang yung recent filter



            if #validServers == 0 then



                for _, server in ipairs(servers) do



                    local serverId = server.id



                    local playerCount = server.playing or 0



                    local maxPlayers = server.maxPlayers or 0







                    if serverId 



                       and serverId ~= currentJobId 



                       and playerCount < maxPlayers then



                        table.insert(validServers, server)



                    end



                end



            end







            if #validServers == 0 then



                WindUI:Notify({



                    Title = "Fallback",



                    Content = "Walang available, random join.",



                    Icon = "solar:danger-bold",



                    Duration = 3,



                })







                pcall(function()



                    TeleportService:Teleport(placeId, player)



                end)



                return



            end







            -- Pumili ng random server



            local chosen = validServers[math.random(1, #validServers)]







            WindUI:Notify({



                Title = "Joining Server",



                Content = string.format("Players: %d/%d", 



                    chosen.playing or 0,



                    chosen.maxPlayers or 0),



                Icon = "solar:login-bold",



                Duration = 3,



            })







            task.wait(1)







            local success, err = pcall(function()



                TeleportService:TeleportToPlaceInstance(placeId, chosen.id, player)



            end)







            if not success then



                WindUI:Notify({



                    Title = "Teleport Failed",



                    Content = tostring(err),



                    Icon = "solar:danger-bold",



                    Duration = 5,



                })



            end



        end)



    end,



})































-- fixed version 2

