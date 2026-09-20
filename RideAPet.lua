local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local localPlayer = players.LocalPlayer or players:GetPropertyChangedSignal("LocalPlayer"):Wait() or players.LocalPlayer


-- Palitan ang pangalan ng file dito
local configFileName = "IOHUB_RideAPet.json" 

local currentConfigData = {
    toggles = {},
    dropdowns = {}
}

-- Siguraduhin na ang lahat ng functions mo ay gumagamit ng variable na 'configFileName'
if readfile and pcall(readfile, configFileName) then
    local success, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(configFileName))
    end)
    if success and decoded then
        currentConfigData = decoded
    end
end

local function saveConfigToFile()
    if writefile then
        pcall(function()
            writefile(configFileName, HttpService:JSONEncode(currentConfigData))
        end)
    end
end

local function deleteConfigFromFile()
    -- Gagamit ito ng bagong pangalan ng file (IOHUB_HazeSeas.json)
    if delfile and isfile and isfile(configFileName) then
        pcall(function()
            delfile(configFileName)
        end)
    end
    
    currentConfigData = {
        toggles = {},
        dropdowns = {}
    }
end



local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalMenuGui_Delta"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    screenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screenGui)
    screenGui.Parent = coreGui
else
    screenGui.Parent = coreGui
end


local function showNotification(message)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 220, 0, 40)
    notifFrame.Position = UDim2.new(1, -235, 1, -60)
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notifFrame.BackgroundTransparency = 0.2
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 999
    notifFrame.Parent = screenGui

    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 8)
    nCorner.Parent = notifFrame

    local nStroke = Instance.new("UIStroke")
    nStroke.Color = Color3.fromRGB(150, 30, 50)
    nStroke.Thickness = 1
    nStroke.Parent = notifFrame

    local nText = Instance.new("TextLabel")
    nText.Size = UDim2.new(1, 0, 1, 0)
    nText.BackgroundTransparency = 1
    nText.Text = message
    nText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nText.Font = Enum.Font.GothamBold
    nText.TextSize = 11
    nText.ZIndex = 1000
    nText.Parent = notifFrame

    task.delay(2, function()
        local tw = TweenService:Create(notifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        tw:Play()
        TweenService:Create(nText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        tw.Completed:Connect(function()
            notifFrame:Destroy()
        end)
    end)
end


local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 580, 0, 420)
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = false 
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame


local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "MenuToggleButton"
toggleButton.Size = UDim2.new(0, 55, 0, 55)
toggleButton.Position = UDim2.new(0, 20, 0.5, -27) 
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://139934599708171" 
toggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Active = true
toggleButton.Parent = screenGui


local userInputService = game:GetService("UserInputService")

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    userInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

makeDraggable(mainFrame)
makeDraggable(toggleButton)


local uiTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local isMenuOpen = false 
local isTweening = false 

local function minimizeToButton()
    if isTweening then return end
    isTweening = true
    
    local closeTween = TweenService:Create(mainFrame, uiTweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        mainFrame.Visible = false
        isMenuOpen = false
        isTweening = false
    end)
end

local function openMenu()
    if isTweening then return end
    isTweening = true
    
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0) 
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local openTween = TweenService:Create(mainFrame, uiTweenInfo, {
        Size = UDim2.new(0, 580, 0, 420),
        Position = UDim2.new(0.5, -290, 0.5, -210)
    })
    openTween:Play()
    openTween.Completed:Connect(function()
        isMenuOpen = true
        isTweening = false
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    if isMenuOpen then minimizeToButton() else openMenu() end
end)


local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "Controls"
controlsFrame.Size = UDim2.new(0, 60, 0, 20)
controlsFrame.Position = UDim2.new(1, -75, 0, 15)
controlsFrame.BackgroundTransparency = 1
controlsFrame.Parent = mainFrame

local colors = {Color3.fromRGB(255, 95, 87), Color3.fromRGB(254, 188, 46), Color3.fromRGB(40, 200, 64)}
for i, color in ipairs(colors) do
    local dot = Instance.new("TextButton")
    dot.Name = "ControlDot" .. i
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, (i - 1) * 20, 0, 4)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Text = ""
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    dot.Parent = controlsFrame
    dot.MouseButton1Click:Connect(minimizeToButton)
end

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "IOHUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 24, 0, 24)
logo.Position = UDim2.new(0, 15, 0, 12)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://10840244199" 
logo.ImageColor3 = Color3.fromRGB(255, 30, 30)
logo.Parent = mainFrame


local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local uiListSide = Instance.new("UIListLayout")
uiListSide.Padding = UDim.new(0, 8)
uiListSide.SortOrder = Enum.SortOrder.LayoutOrder
uiListSide.Parent = sidebar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -195, 1, -55)
contentFrame.Position = UDim2.new(0, 180, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
contentFrame.BackgroundTransparency = 0.4
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

local tabs = {}
local pages = {}
local activeTab = nil

local function createPageContainer()
    local scrollPage = Instance.new("ScrollingFrame")
    scrollPage.Size = UDim2.new(1, -10, 1, -15)
    scrollPage.Position = UDim2.new(0, 5, 0, 10)
    scrollPage.BackgroundTransparency = 1
    scrollPage.BorderSizePixel = 0
    scrollPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollPage.ScrollBarThickness = 2
    scrollPage.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollPage.Visible = false
    scrollPage.Parent = contentFrame

    local uiListContent = Instance.new("UIListLayout")
    uiListContent.Padding = UDim.new(0, 10)
    uiListContent.SortOrder = Enum.SortOrder.LayoutOrder
    uiListContent.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListContent.Parent = scrollPage
    
    uiListContent:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollPage.CanvasSize = UDim2.new(0, 0, 0, uiListContent.AbsoluteContentSize.Y + 20)
    end)

    return scrollPage
end

local function switchTab(tabName)
    for name, btnElements in pairs(tabs) do
        if name == tabName then
            btnElements.Button.BackgroundTransparency = 0.9
            btnElements.Icon.ImageColor3 = Color3.fromRGB(255, 100, 120)
            btnElements.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            if btnElements.Stroke then btnElements.Stroke.Enabled = true end
            pages[name].Visible = true
        else
            btnElements.Button.BackgroundTransparency = 1
            btnElements.Icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
            btnElements.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            if btnElements.Stroke then btnElements.Stroke.Enabled = false end
            pages[name].Visible = false
        end
    end
    activeTab = tabName
end

local function createSidebarTab(name, iconId, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.LayoutOrder = order
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 20, 40)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Enabled = false
    stroke.Parent = btn
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 12, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    icon.Parent = btn
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Position = UDim2.new(0, 36, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn
    
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    btn.Parent = sidebar
    
    tabs[name] = {Button = btn, Icon = icon, Label = lbl, Stroke = stroke}
    pages[name] = createPageContainer()
end


local function createDropdownSection(pageName, sectionTitle)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local isOpen = false 
    
    local dropContainer = Instance.new("Frame")
    dropContainer.Size = UDim2.new(0.92, 0, 0, 40)
    dropContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropContainer.BackgroundTransparency = 0.5
    dropContainer.ClipsDescendants = true
    dropContainer.Parent = targetPage

    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 8)
    dropCorner.Parent = dropContainer

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 40)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = dropContainer

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -40, 1, 0)
    titleLbl.Position = UDim2.new(0, 15, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = sectionTitle
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 20
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = headerBtn

    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.Size = UDim2.new(0, 16, 0, 16)
    arrowIcon.Position = UDim2.new(1, -28, 0.5, -8)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = "rbxassetid://10709791437"
    arrowIcon.Rotation = 90
    arrowIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    arrowIcon.Parent = headerBtn

    local itemsHolder = Instance.new("Frame")
    itemsHolder.Size = UDim2.new(1, 0, 0, 0)
    itemsHolder.Position = UDim2.new(0, 0, 0, 40)
    itemsHolder.BackgroundTransparency = 1
    itemsHolder.Parent = dropContainer

    local itemsList = Instance.new("UIListLayout")
    itemsList.Padding = UDim.new(0, 8)
    itemsList.SortOrder = Enum.SortOrder.LayoutOrder
    itemsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    itemsList.Parent = itemsHolder

    itemsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then
            dropContainer.Size = UDim2.new(0.92, 0, 0, itemsList.AbsoluteContentSize.Y + 50)
            itemsHolder.Size = UDim2.new(1, 0, 0, itemsList.AbsoluteContentSize.Y + 10)
        end
    end)

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        if isOpen then
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 270}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.92, 0, 0, itemsList.AbsoluteContentSize.Y + 50)}):Play()
        else
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 90}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.92, 0, 0, 40)}):Play()
        end
    end)

    return itemsHolder
end


local function createNestedDropdownSection(parentContainer, sectionTitle)
    local isOpen = false
    
    local dropContainer = Instance.new("Frame")
    dropContainer.Size = UDim2.new(0.95, 0, 0, 36)
    dropContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropContainer.BackgroundTransparency = 0.5
    dropContainer.ClipsDescendants = true
    dropContainer.Parent = parentContainer

    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropContainer

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 36)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = dropContainer

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -35, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = sectionTitle
    titleLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = headerBtn

    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.Size = UDim2.new(0, 14, 0, 14)
    arrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = "rbxassetid://10709791437"
    arrowIcon.Rotation = 90
    arrowIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    arrowIcon.Parent = headerBtn

    local itemsHolder = Instance.new("Frame")
    itemsHolder.Size = UDim2.new(1, 0, 0, 0)
    itemsHolder.Position = UDim2.new(0, 0, 0, 36)
    itemsHolder.BackgroundTransparency = 1
    itemsHolder.Parent = dropContainer

    local itemsList = Instance.new("UIListLayout")
    itemsList.Padding = UDim.new(0, 6)
    itemsList.SortOrder = Enum.SortOrder.LayoutOrder
    itemsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    itemsList.Parent = itemsHolder

    itemsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then
            dropContainer.Size = UDim2.new(0.95, 0, 0, itemsList.AbsoluteContentSize.Y + 45)
            itemsHolder.Size = UDim2.new(1, 0, 0, itemsList.AbsoluteContentSize.Y + 10)
        end
    end)

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        if isOpen then
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 270}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, itemsList.AbsoluteContentSize.Y + 45)}):Play()
        else
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 90}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, 36)}):Play()
        end
    end)

    return itemsHolder
end

----------------------------------------------------
-- TOGGLE CREATOR (May On/Off switch)
----------------------------------------------------
local function createneToggle(pageName, title, description, callback)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.92, 0, 0, 55)
    row.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 32)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = ""
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 3, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    indicator.Parent = toggleBtn
    
    local enabled = false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        else
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
        if callback then callback(enabled) end
    end)
    
    toggleBtn.Parent = row
    row.Parent = targetPage
end



local function createDropdownSelect(parentContainer, title, itemsListTable, callback)
    local isOpen = false
    
    if not currentConfigData.dropdowns[title] then
        currentConfigData.dropdowns[title] = {}
    end
    local selectedItems = currentConfigData.dropdowns[title]
    local allSelected = false
    
    local dropContainer = Instance.new("Frame")
    dropContainer.Size = UDim2.new(0.95, 0, 0, 36)
    dropContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropContainer.BackgroundTransparency = 0.5
    dropContainer.ClipsDescendants = true
    dropContainer.Parent = parentContainer

    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropContainer

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 36)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = dropContainer

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.5, 0, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = headerBtn

    local selectedLbl = Instance.new("TextLabel")
    selectedLbl.Size = UDim2.new(0.4, 0, 1, 0)
    selectedLbl.Position = UDim2.new(0.55, -20, 0, 0)
    selectedLbl.BackgroundTransparency = 1
    selectedLbl.Text = "None selected"
    selectedLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    selectedLbl.Font = Enum.Font.Gotham
    selectedLbl.TextSize = 10
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Right
    selectedLbl.Parent = headerBtn

    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.Size = UDim2.new(0, 14, 0, 14)
    arrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = "rbxassetid://10709791437"
    arrowIcon.Rotation = 90
    arrowIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    arrowIcon.Parent = headerBtn

    local contentHolder = Instance.new("Frame")
    contentHolder.Size = UDim2.new(1, 0, 0, 0)
    contentHolder.Position = UDim2.new(0, 0, 0, 36)
    contentHolder.BackgroundTransparency = 1
    contentHolder.Parent = dropContainer

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Parent = contentHolder

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(0.92, 0, 0, 28)
    searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search 🔎"
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 11
    searchBox.ClearTextOnFocus = false
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 4)
    searchCorner.Parent = searchBox
    searchBox.Parent = contentHolder

    local scrollOptions = Instance.new("ScrollingFrame")
    scrollOptions.Size = UDim2.new(0.92, 0, 0, 90)
    scrollOptions.BackgroundTransparency = 1
    scrollOptions.BorderSizePixel = 0
    scrollOptions.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollOptions.ScrollBarThickness = 2
    scrollOptions.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollOptions.Parent = contentHolder

    local optList = Instance.new("UIListLayout")
    optList.Padding = UDim.new(0, 4)
    optList.SortOrder = Enum.SortOrder.LayoutOrder
    optList.Parent = scrollOptions

    local optionButtons = {}
    local allBtn = nil

    local function updateSelectedLabel()
        local count = 0
        local names = {}
        for item, isSel in pairs(selectedItems) do
            if isSel then
                count = count + 1
                table.insert(names, item)
            end
        end
        if count == 0 then
            selectedLbl.Text = "None selected"
        elseif count == #itemsListTable then
            selectedLbl.Text = "All selected"
        else
            selectedLbl.Text = table.concat(names, ", ")
        end
    end

    local function updateAllButtonState()
        if not allBtn then return end
        local allCurrentlySelected = true
        for _, itemText in ipairs(itemsListTable) do
            if not selectedItems[itemText] then
                allCurrentlySelected = false
                break
            end
        end
        allSelected = allCurrentlySelected
        
        allBtn.BackgroundColor3 = allSelected and Color3.fromRGB(150, 30, 50) or Color3.fromRGB(35, 35, 35)
        allBtn.BackgroundTransparency = allSelected and 0.2 or 0.5
        allBtn.TextColor3 = allSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        allBtn.Font = allSelected and Enum.Font.GothamBold or Enum.Font.Gotham
    end

    local function populateOptions(filter)

        for _, btn in pairs(optionButtons) do 
            if btn.Button then btn.Button:Destroy() end 
        end
        optionButtons = {}
        if allBtn then allBtn:Destroy() allBtn = nil end


        local cleanFilter = string.lower(string.gsub(filter or "", "^%s*(.-)%s*$", "%1"))


        if cleanFilter == "" or string.find(string.lower("All"), cleanFilter) then
            allBtn = Instance.new("TextButton")
            allBtn.Size = UDim2.new(1, 0, 0, 26)
            allBtn.BackgroundColor3 = allSelected and Color3.fromRGB(150, 30, 50) or Color3.fromRGB(35, 35, 35)
            allBtn.BackgroundTransparency = allSelected and 0.2 or 0.5
            allBtn.Text = "  All"
            allBtn.TextColor3 = allSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            allBtn.Font = allSelected and Enum.Font.GothamBold or Enum.Font.Gotham
            allBtn.TextSize = 11
            allBtn.TextXAlignment = Enum.TextXAlignment.Left

            local allCorner = Instance.new("UICorner")
            allCorner.CornerRadius = UDim.new(0, 4)
            allCorner.Parent = allBtn

            allBtn.MouseButton1Click:Connect(function()
                allSelected = not allSelected
                for _, itemText in ipairs(itemsListTable) do
                    selectedItems[itemText] = allSelected
                end
                updateAllButtonState()
                for _, btnData in pairs(optionButtons) do
                    local isSel = selectedItems[btnData.ItemName] == true
                    btnData.Button.BackgroundColor3 = isSel and Color3.fromRGB(150, 30, 50) or Color3.fromRGB(35, 35, 35)
                    btnData.Button.BackgroundTransparency = isSel and 0.2 or 0.5
                    btnData.Button.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                    btnData.Button.Font = isSel and Enum.Font.GothamBold or Enum.Font.Gotham
                end
                updateSelectedLabel()
                if callback then callback(selectedItems) end
            end)

            allBtn.Parent = scrollOptions
        end


        for _, itemText in ipairs(itemsListTable) do
            local lowerItemText = string.lower(itemText)
            if cleanFilter == "" or string.find(lowerItemText, cleanFilter) then
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 26)
                
                local isSelected = selectedItems[itemText] == true
                optBtn.BackgroundColor3 = isSelected and Color3.fromRGB(150, 30, 50) or Color3.fromRGB(35, 35, 35)
                optBtn.BackgroundTransparency = isSelected and 0.2 or 0.5
                optBtn.Text = "  " .. itemText
                optBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                optBtn.Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham
                optBtn.TextSize = 11
                optBtn.TextXAlignment = Enum.TextXAlignment.Left

                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 4)
                optCorner.Parent = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    selectedItems[itemText] = not selectedItems[itemText]
                    
                    local nowSelected = selectedItems[itemText]
                    optBtn.BackgroundColor3 = nowSelected and Color3.fromRGB(150, 30, 50) or Color3.fromRGB(35, 35, 35)
                    optBtn.BackgroundTransparency = nowSelected and 0.2 or 0.5
                    optBtn.TextColor3 = nowSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                    optBtn.Font = nowSelected and Enum.Font.GothamBold or Enum.Font.Gotham

                    updateAllButtonState()
                    updateSelectedLabel()
                    if callback then callback(selectedItems) end
                end)

                optBtn.Parent = scrollOptions
                table.insert(optionButtons, {Button = optBtn, ItemName = itemText})
            end
        end

        updateAllButtonState()
        scrollOptions.CanvasSize = UDim2.new(0, 0, 0, optList.AbsoluteContentSize.Y + 10)
        
        if isOpen then
            local optionListHeight = optList.AbsoluteContentSize.Y + 15
            if optionListHeight > 90 then optionListHeight = 90 end
            scrollOptions.Size = UDim2.new(0.92, 0, 0, optionListHeight)
            
            local totalTargetHeight = optionListHeight + 36 + 28 + 20
            dropContainer.Size = UDim2.new(0.95, 0, 0, totalTargetHeight)
        end
    end

    populateOptions("")
    updateSelectedLabel()
    if callback then callback(selectedItems) end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        populateOptions(searchBox.Text)
    end)

    optList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollOptions.CanvasSize = UDim2.new(0, 0, 0, optList.AbsoluteContentSize.Y + 10)
    end)

    contentHolder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if isOpen then
            local optionListHeight = optList.AbsoluteContentSize.Y + 15
            if optionListHeight > 90 then optionListHeight = 90 end
            local totalHeight = optionListHeight + 36 + 28 + 20
            dropContainer.Size = UDim2.new(0.95, 0, 0, totalHeight)
        end
    end)

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        if isOpen then
            local optionListHeight = optList.AbsoluteContentSize.Y + 15
            if optionListHeight > 90 then optionListHeight = 90 end
            local totalHeight = optionListHeight + 36 + 28 + 20
            
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 270}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, totalHeight)}):Play()
        else
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 90}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, 36)}):Play()
        end
    end)

    return dropContainer
end



local function createSingleDropdownSelect(parentContainer, title, itemsListTable, callback)
    local isOpen = false
    
    
    if not currentConfigData.singleDropdowns then
        currentConfigData.singleDropdowns = {}
    end
    if not currentConfigData.singleDropdowns[title] then
        currentConfigData.singleDropdowns[title] = itemsListTable[1] or ""
    end
    
    local selectedValue = currentConfigData.singleDropdowns[title]
    
    local dropContainer = Instance.new("Frame")
    dropContainer.Size = UDim2.new(0.95, 0, 0, 36)
    dropContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropContainer.BackgroundTransparency = 0.5
    dropContainer.ClipsDescendants = true
    dropContainer.Parent = parentContainer

    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropContainer

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 36)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = dropContainer

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.5, 0, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = headerBtn

    local selectedLbl = Instance.new("TextLabel")
    selectedLbl.Size = UDim2.new(0.4, 0, 1, 0)
    selectedLbl.Position = UDim2.new(0.55, -20, 0, 0)
    selectedLbl.BackgroundTransparency = 1
    selectedLbl.Text = selectedValue ~= "" and selectedValue or "Select..."
    selectedLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    selectedLbl.Font = Enum.Font.Gotham
    selectedLbl.TextSize = 10
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Right
    selectedLbl.Parent = headerBtn

    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.Size = UDim2.new(0, 14, 0, 14)
    arrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = "rbxassetid://10709791437"
    arrowIcon.Rotation = 90
    arrowIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    arrowIcon.Parent = headerBtn

    local contentHolder = Instance.new("Frame")
    contentHolder.Size = UDim2.new(1, 0, 0, 0)
    contentHolder.Position = UDim2.new(0, 0, 0, 36)
    contentHolder.BackgroundTransparency = 1
    contentHolder.Parent = dropContainer

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Parent = contentHolder

    local scrollOptions = Instance.new("ScrollingFrame")
    scrollOptions.Size = UDim2.new(0.92, 0, 0, #itemsListTable * 30 + 5)
    scrollOptions.BackgroundTransparency = 1
    scrollOptions.BorderSizePixel = 0
    scrollOptions.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollOptions.ScrollBarThickness = 2
    scrollOptions.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollOptions.Parent = contentHolder

    local optList = Instance.new("UIListLayout")
    optList.Padding = UDim.new(0, 4)
    optList.SortOrder = Enum.SortOrder.LayoutOrder
    optList.Parent = scrollOptions

    local optionButtons = {}

    local function populateOptions()
        for _, btn in pairs(optionButtons) do btn:Destroy() end
        optionButtons = {}

        for _, itemText in ipairs(itemsListTable) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 26)
            
            local isSelected = (selectedValue == itemText)
            optBtn.BackgroundColor3 = isSelected and Color3.fromRGB(150, 30, 50) or Color3.fromRGB(35, 35, 35)
            optBtn.BackgroundTransparency = isSelected and 0.2 or 0.5
            
            optBtn.Text = "  " .. itemText
            optBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            optBtn.Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham
            optBtn.TextSize = 11
            optBtn.TextXAlignment = Enum.TextXAlignment.Left

            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 4)
            optCorner.Parent = optBtn

            optBtn.MouseButton1Click:Connect(function()
                selectedValue = itemText
                currentConfigData.singleDropdowns[title] = selectedValue
                selectedLbl.Text = selectedValue
                
     
                isOpen = false
                local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                TweenService:Create(arrowIcon, tweenInfo, {Rotation = 90}):Play()
                TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, 36)}):Play()

                populateOptions()
                if callback then callback(selectedValue) end
            end)

            optBtn.Parent = scrollOptions
            table.insert(optionButtons, optBtn)
        end
        scrollOptions.CanvasSize = UDim2.new(0, 0, 0, optList.AbsoluteContentSize.Y + 5)
    end

    populateOptions()
    if callback then callback(selectedValue) end

    contentHolder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if isOpen then
            dropContainer.Size = UDim2.new(0.95, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end
    end)

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local totalHeight = listLayout.AbsoluteContentSize.Y + 20
        
        if isOpen then
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 270}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, totalHeight)}):Play()
        else
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 90}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, 36)}):Play()
        end
    end)

    return dropContainer
end


local function createEnterText(parentContainer, title, placeholder, defaultVal, callback)
    if not currentConfigData.inputs then
        currentConfigData.inputs = {}
    end
    if currentConfigData.inputs[title] == nil then
        currentConfigData.inputs[title] = tostring(defaultVal or "")
    end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.95, 0, 0, 36)
    container.BackgroundTransparency = 1
    container.Parent = parentContainer

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.5, 0, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = container

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 100, 0, 26)
    textBox.Position = UDim2.new(1, -108, 0.5, -13)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    textBox.BackgroundTransparency = 0.4
    textBox.Text = currentConfigData.inputs[title]
    textBox.PlaceholderText = placeholder or "Enter..."
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 11
    textBox.ClearTextOnFocus = false
    textBox.Parent = container

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = textBox

    textBox.FocusLost:Connect(function(enterPressed)
        local val = textBox.Text
        currentConfigData.inputs[title] = val
        if callback then
            callback(val)
        end
    end)

    return container
end


local function createCustomToggle(parentContainer, title, description, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.95, 0, 0, 42)
    row.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 16)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 20)
    descLabel.Position = UDim2.new(0, 0, 0, 16)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 18)
    toggleBtn.Position = UDim2.new(1, -34, 0.5, -9)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = ""
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 12, 0, 12)
    indicator.Position = UDim2.new(0, 3, 0.5, -6)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    indicator.Parent = toggleBtn
    
    local enabled = currentConfigData.toggles[title] == true
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    local function applyState(state, immediate)
        enabled = state
        currentConfigData.toggles[title] = enabled
        if immediate then
            if enabled then
                toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                indicator.Position = UDim2.new(1, -15, 0.5, -6)
                indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            else
                toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                indicator.Position = UDim2.new(0, 3, 0.5, -6)
                indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
        else
            if enabled then
                TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(1, -15, 0.5, -6), BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            else
                TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
        end
        if callback then callback(enabled) end
    end

    applyState(enabled, true)
    
    toggleBtn.MouseButton1Click:Connect(function()
        applyState(not enabled, false)
    end)
    
    toggleBtn.Parent = row
    row.Parent = parentContainer
end

local function createSingledropdown2(parentContainer, title, itemsListTable, callback)
    local isOpen = false
    
    if not currentConfigData.dropdowns[title] then
        currentConfigData.dropdowns[title] = nil
    end
    local selectedItem = currentConfigData.dropdowns[title]
    
    local dropContainer = Instance.new("Frame")
    dropContainer.Size = UDim2.new(0.95, 0, 0, 36)
    dropContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropContainer.BackgroundTransparency = 0.5
    dropContainer.ClipsDescendants = true
    dropContainer.Parent = parentContainer

    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropContainer

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 36)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = dropContainer

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.5, 0, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = headerBtn

    local selectedLbl = Instance.new("TextLabel")
    selectedLbl.Size = UDim2.new(0.4, 0, 1, 0)
    selectedLbl.Position = UDim2.new(0.55, -20, 0, 0)
    selectedLbl.BackgroundTransparency = 1
    selectedLbl.Text = "None selected"
    selectedLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    selectedLbl.Font = Enum.Font.Gotham
    selectedLbl.TextSize = 10
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Right
    selectedLbl.Parent = headerBtn

    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.Size = UDim2.new(0, 14, 0, 14)
    arrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = "rbxassetid://10709791437"
    arrowIcon.Rotation = 90
    arrowIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    arrowIcon.Parent = headerBtn

    local contentHolder = Instance.new("Frame")
    contentHolder.Size = UDim2.new(1, 0, 0, 0)
    contentHolder.Position = UDim2.new(0, 0, 0, 36)
    contentHolder.BackgroundTransparency = 1
    contentHolder.Parent = dropContainer

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Parent = contentHolder

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(0.92, 0, 0, 28)
    searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search 🔎"
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 11
    searchBox.ClearTextOnFocus = false
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 4)
    searchCorner.Parent = searchBox
    searchBox.Parent = contentHolder

    local scrollOptions = Instance.new("ScrollingFrame")
    scrollOptions.Size = UDim2.new(0.92, 0, 0, 90)
    scrollOptions.BackgroundTransparency = 1
    scrollOptions.BorderSizePixel = 0
    scrollOptions.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollOptions.ScrollBarThickness = 2
    scrollOptions.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollOptions.Parent = contentHolder

    local optList = Instance.new("UIListLayout")
    optList.Padding = UDim.new(0, 4)
    optList.SortOrder = Enum.SortOrder.LayoutOrder
    optList.Parent = scrollOptions

    local optionButtons = {}

    local function updateSelectedLabel()
        if not selectedItem or selectedItem == "" then
            selectedLbl.Text = "None selected"
        else
            selectedLbl.Text = selectedItem
        end
    end

    local function closeDropdown()
        isOpen = false
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(arrowIcon, tweenInfo, {Rotation = 90}):Play()
        TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, 36)}):Play()
    end

    local function populateOptions(filter)
        for _, btnData in pairs(optionButtons) do 
            if btnData.Button then btnData.Button:Destroy() end 
        end
        optionButtons = {}

        local cleanFilter = string.lower(string.gsub(filter or "", "^%s*(.-)%s*$", "%1"))

        for _, itemText in ipairs(itemsListTable) do
            local lowerItemText = string.lower(itemText)
            if cleanFilter == "" or string.find(lowerItemText, cleanFilter) then
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 26)
                
                local isSelected = (selectedItem == itemText)
                optBtn.BackgroundColor3 = isSelected and Color3.fromRGB(150, 30, 50) or Color3.fromRGB(35, 35, 35)
                optBtn.BackgroundTransparency = isSelected and 0.2 or 0.5
                optBtn.Text = "  " .. itemText
                optBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                optBtn.Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham
                optBtn.TextSize = 11
                optBtn.TextXAlignment = Enum.TextXAlignment.Left

                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 4)
                optCorner.Parent = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    selectedItem = itemText
                    currentConfigData.dropdowns[title] = selectedItem
                    
                    for _, btnData in pairs(optionButtons) do
                        local isSel = (btnData.ItemName == selectedItem)
                        btnData.Button.BackgroundColor3 = isSel and Color3.fromRGB(150, 30, 50) or Color3.fromRGB(35, 35, 35)
                        btnData.Button.BackgroundTransparency = isSel and 0.2 or 0.5
                        btnData.Button.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                        btnData.Button.Font = isSel and Enum.Font.GothamBold or Enum.Font.Gotham
                    end

                    updateSelectedLabel()
                    if callback then callback(selectedItem) end
                    closeDropdown()
                end)

                optBtn.Parent = scrollOptions
                table.insert(optionButtons, {Button = optBtn, ItemName = itemText})
            end
        end

        scrollOptions.CanvasSize = UDim2.new(0, 0, 0, optList.AbsoluteContentSize.Y + 10)
        
        if isOpen then
            local optionListHeight = optList.AbsoluteContentSize.Y + 15
            if optionListHeight > 90 then optionListHeight = 90 end
            scrollOptions.Size = UDim2.new(0.92, 0, 0, optionListHeight)
            
            local totalTargetHeight = optionListHeight + 36 + 28 + 20
            dropContainer.Size = UDim2.new(0.95, 0, 0, totalTargetHeight)
        end
    end

    populateOptions("")
    updateSelectedLabel()
    if callback and selectedItem then callback(selectedItem) end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        populateOptions(searchBox.Text)
    end)

    optList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollOptions.CanvasSize = UDim2.new(0, 0, 0, optList.AbsoluteContentSize.Y + 10)
    end)

    contentHolder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if isOpen then
            local optionListHeight = optList.AbsoluteContentSize.Y + 15
            if optionListHeight > 90 then optionListHeight = 90 end
            local totalHeight = optionListHeight + 36 + 28 + 20
            dropContainer.Size = UDim2.new(0.95, 0, 0, totalHeight)
        end
    end)

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        if isOpen then
            local optionListHeight = optList.AbsoluteContentSize.Y + 15
            if optionListHeight > 90 then optionListHeight = 90 end
            local totalHeight = optionListHeight + 36 + 28 + 20
            
            TweenService:Create(arrowIcon, tweenInfo, {Rotation = 270}):Play()
            TweenService:Create(dropContainer, tweenInfo, {Size = UDim2.new(0.95, 0, 0, totalHeight)}):Play()
        else
            closeDropdown()
        end
    end)

    return dropContainer
end

----------------------------------------------------
-- BAGONG BUTTON CREATOR (Para lang sa mga Standalone Buttons na may Mouse Pointer)
----------------------------------------------------
local function createCustomButton(pageName, title, description, callback)
    local targetPage = pages[pageName]
    if not targetPage then return end

    -- Ang mismong malaking clickable rectangle button
    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = title .. "_CustomRectangle"
    actionBtn.Size = UDim2.new(0.92, 0, 0, 55) -- Malaking rectangle
    actionBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40) -- Kulay na babagay sa background ng IOHUB mo
    actionBtn.BackgroundTransparency = 0.4
    actionBtn.Text = "" -- Alisin ang default button text
    actionBtn.AutoButtonColor = true

    -- Bilugan ang mga kanto ng rectangle
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = actionBtn

    -- Spacing para hindi nakadikit ang mga letra sa gilid
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = actionBtn
    
    -- Title Label sa loob ng malaking button
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
    titleLabel.Position = UDim2.new(0, 0, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = actionBtn
    
    -- Description Label sa loob ng malaking button
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 32)
    descLabel.Position = UDim2.new(0, 0, 0, 24)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = actionBtn
    
    -- Ang Mouse Click Cursor Asset sa kanang dulo ng rectangle
    local mouseIcon = Instance.new("ImageLabel")
    mouseIcon.Name = "MousePointerIcon"
    mouseIcon.Size = UDim2.new(0, 22, 0, 22)
    mouseIcon.Position = UDim2.new(1, -25, 0.5, -11)
    mouseIcon.BackgroundTransparency = 1
    mouseIcon.Image = "rbxassetid://10734896206" -- Mouse click cursor icon asset
    mouseIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    mouseIcon.Parent = actionBtn
    
    -- Click at Flash Effect para sa mouse pointer
    actionBtn.MouseButton1Click:Connect(function()
        mouseIcon.ImageColor3 = Color3.fromRGB(255, 100, 120)
        task.wait(0.1)
        mouseIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        if callback then callback() end
    end)
    
    actionBtn.Parent = targetPage
end


----------------------------------------------------
-- SLIDER CREATOR (May bilog na hawakan / knob)
----------------------------------------------------
local function createSlider(pageName, title, description, minVal, maxVal, defaultVal, callback)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.92, 0, 0, 65)
    row.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    -- Value Label sa kanang itaas
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.35, 0, 0, 18)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.95, 0, 0, 25)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = row
    
    -- Slider Bar Track
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 6)
    sliderBar.Position = UDim2.new(0, 0, 0, 48)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.BorderSizePixel = 0
    
    local sBarCorner = Instance.new("UICorner")
    sBarCorner.CornerRadius = UDim.new(1, 0)
    sBarCorner.Parent = sliderBar
    
    -- Slider Fill Bar
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderFill.BorderSizePixel = 0
    
    local sFillCorner = Instance.new("UICorner")
    sFillCorner.CornerRadius = UDim.new(1, 0)
    sFillCorner.Parent = sliderFill
    sliderFill.Parent = sliderBar
    
    -- BILOG NA HAWAKAN (Slider Knob/Thumb)
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 14, 0, 14)
    sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderKnob.BorderSizePixel = 0
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0) -- Ginawa niyang bilog
    knobCorner.Parent = sliderKnob
    sliderKnob.Parent = sliderBar
    
    -- Invisible Button para ma-detect ang click/drag sa buong bar area
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 1, 16)
    sliderBtn.Position = UDim2.new(0, 0, -0.5, 0)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBar
    
    sliderBar.Parent = row
    
    local currentValue = defaultVal
    
    local function updateSlider(inputX)
        local barAbsolutePosition = sliderBar.AbsolutePosition.X
        local barAbsoluteSize = sliderBar.AbsoluteSize.X
        
        local relativeX = math.clamp(inputX - barAbsolutePosition, 0, barAbsoluteSize)
        local percentage = relativeX / barAbsoluteSize
        
        -- Kalkulahin ang value mula minVal hanggang maxVal (0 hanggang 1000)
        currentValue = math.floor(minVal + (maxVal - minVal) * percentage)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percentage, 0, 0.5, 0) -- Sumusunod ang bilog sa pwesto
        valueLabel.Text = tostring(currentValue)
        
        if callback then callback(currentValue) end
    end
    
    -- Initial value setup
    local initialPercentage = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    sliderFill.Size = UDim2.new(initialPercentage, 0, 1, 0)
    sliderKnob.Position = UDim2.new(initialPercentage, 0, 0.5, 0)
    if callback then callback(defaultVal) end
    
    -- Dragging logic
    local draggingSlider = false
    local UserInputService = game:GetService("UserInputService")
    
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateSlider(input.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)
    
    row.Parent = targetPage
end

----------------------------------------------------
-- TOGGLE CREATOR
----------------------------------------------------
local function createToggle(parentContainer, title, description, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.95, 0, 0, 42)
    row.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 16)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 20)
    descLabel.Position = UDim2.new(0, 0, 0, 16)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 18)
    toggleBtn.Position = UDim2.new(1, -34, 0.5, -9)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = ""
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 12, 0, 12)
    indicator.Position = UDim2.new(0, 3, 0.5, -6)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    indicator.Parent = toggleBtn
    
    local enabled = currentConfigData.toggles[title] == true
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    local function applyState(state, immediate)
        enabled = state
        currentConfigData.toggles[title] = enabled
        if immediate then
            if enabled then
                toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                indicator.Position = UDim2.new(1, -15, 0.5, -6)
                indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            else
                toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                indicator.Position = UDim2.new(0, 3, 0.5, -6)
                indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
        else
            if enabled then
                TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(1, -15, 0.5, -6), BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            else
                TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
        end
        if callback then callback(enabled) end
    end

    applyState(enabled, true)
    
    toggleBtn.MouseButton1Click:Connect(function()
        applyState(not enabled, false)
    end)
    
    toggleBtn.Parent = row
    row.Parent = parentContainer
end

local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

----------------------------------------------------
-- TOGGLE CREATOR (May On/Off switch)
----------------------------------------------------
local function createToggle(pageName, title, description, callback)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.92, 0, 0, 55)
    row.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 32)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = ""
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 3, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    indicator.Parent = toggleBtn
    
    local enabled = false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        else
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
        if callback then callback(enabled) end
    end)
    
    toggleBtn.Parent = row
    row.Parent = targetPage
end



createSidebarTab("Players", "rbxassetid://10822165440", 1)
createSidebarTab("Main", "rbxassetid://10822165440", 2)
createSidebarTab("Automatically", "rbxassetid://10723345479", 3)
createSidebarTab("Misc", "rbxassetid://10723345479", 4)
createSidebarTab("Shop", "rbxassetid://10723345479", 5)
createSidebarTab("Settings", "rbxassetid://10723345479", 6)


----------------------------------------------------
-- WALK SPEED SLIDER (CFrame / TranslateBy Method)
----------------------------------------------------

-- 1. I-set ang global variables para sa speed at Heartbeat connection
_G.WalkSpeedTarget = 0 -- Default walk speed (0 para di agad naka-set)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local tpwalkingConnection = nil

-- 2. Slider Setup (0 hanggang 1000 range)
createSlider("Players", "Walk Speed", "Adjust the Walkspeed", 0, 1000, 0, function(value) -- ← default = 0
    _G.WalkSpeedTarget = value
    
    -- Kung ang value ay 0 o mas mababa, puwede nating i-reset sa default o patigilin
    local effectiveSpeed = value > 0 and value or 16
    
    -- I-apply din sa Humanoid WalkSpeed para sakaling kailanganin ng laro
    pcall(function()
        local player = Players.LocalPlayer
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = effectiveSpeed
        end
    end)
end)

----------------------------------------------------
-- 3. HEARTBEAT LOOP PARA SA SMOOTH "BIGAT" MOVEMENT
----------------------------------------------------
if tpwalkingConnection then
    tpwalkingConnection:Disconnect()
end

tpwalkingConnection = RunService.Heartbeat:Connect(function(delta)
    -- Huwag paganahin kung 16 o mas mababa (default speed) o kung naka-zero
    if not _G.WalkSpeedTarget or _G.WalkSpeedTarget <= 16 then 
        return 
    end
    
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    
    if character and humanoid and humanoid.Parent then
        -- Kunin ang bilis mula sa slider (kinakatawan ang multiplier o speed scale)
        -- Hinati natin nang kaunti ang scale para hindi masyadong lumipad ang 1000 speed
        local speedValue = (_G.WalkSpeedTarget - 16) / 10 
        
        if humanoid.MoveDirection.Magnitude > 0 then
            -- Gumagamit ng TranslateBy para dumiretso at hindi matalsik kapag nabangga
            character:TranslateBy(humanoid.MoveDirection * speedValue * delta * 5)
        end
    end
end)





_G.SelectedEggTarget = "Easter Egg" 

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
    "Leaf Egg" ,
    " Mushroom Egg",
    "Stone Egg",
    "Slime Egg", 
    "Crystal Egg"
    
}


local playGroup = createDropdownSection("Main", "Auto Collect Egg")




createSingledropdown2(playGroup, "Select Egg Target", eggChoicesList, function(selectedOption)
    _G.SelectedEggTarget = selectedOption
end)

-- Toggle para sa Auto Tween & Collect Egg
createCustomToggle(playGroup, "Auto Collect Egg", "Automatically Collect the Selected Egg when Spawned", function(state)
    _G.AutoEggEnabled = state
    
    if state then
        task.spawn(function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local TweenService = game:GetService("TweenService")
            local player = Players.LocalPlayer
            
            while _G.AutoEggEnabled do
                task.wait(1) -- Check interval para hindi mag-lag
                
                if _G.SelectedEggTarget and _G.SelectedEggTarget ~= "" then
                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
                        if renderedEggs then
                            local targetCFrame = nil
                            local foundPrompt = nil
                            
                            -- Hanapin ang itlog sa loob ng RenderedEggs
                            for _, eggModel in ipairs(renderedEggs:GetChildren()) do
                                if eggModel.Name == _G.SelectedEggTarget then
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
                            
                            -- Kung natagpuan ang itlog, i-tween papunta roon at i-fire ang prompt
                            if targetCFrame then
                                local tweenDuration = 1.0 -- Bilis ng pag-tween papunta sa itlog
                                local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 3, 0)})
                                tween:Play()
                                
                                local success = pcall(function()
                                    tween.Completed:Wait()
                                end)
                                
                                if success and foundPrompt and foundPrompt:IsA("ProximityPrompt") then
                                    fireproximityprompt(foundPrompt)
                                    task.wait(0.5) -- Kaunting pahinga bago maghanap ulit
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)


--------------------------------------------------
-- CUSTOM EGG TEXT INPUT & FLEXIBLE SEARCH TOGGLE
----------------------------------------------------

_G.CustomEggQuery = "" -- Dito mase-save ang keyword na tinype mo (hal. "spin")
_G.AutoCustomEggEnabled = false

-- 1. Custom Text Input para sa pag-type ng keyword
createEnterText(playGroup, "Custom Egg Name", "e.g. Spin", "", function(textValue)
    if textValue and textValue ~= "" then
        -- Linisin ang espasyo at gawing lowercase para mas madaling mahanap
        _G.CustomEggQuery = textValue:gsub("^%s*(.-)%s*$", "%1"):lower()
        
        
    end
end)

-- 2. Dedikadong Toggle para sa Custom Egg Auto Collect na may Flexible Matching
createCustomToggle(playGroup, "Turn on Auto Collect Custom Egg", "Awtomatikong kukunin ang itlog base sa tinype mong pangalan", function(state)
    _G.AutoCustomEggEnabled = state
    
    if state then
        task.spawn(function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local TweenService = game:GetService("TweenService")
            local player = Players.LocalPlayer
            
            while _G.AutoCustomEggEnabled do
                task.wait(1) -- Check interval
                
                if _G.CustomEggQuery and _G.CustomEggQuery ~= "" then
                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        local renderedEggs = Workspace:FindFirstChild("RenderedEggs")
                        if renderedEggs then
                            local targetCFrame = nil
                            local foundPrompt = nil
                            
                            -- Flexible Search: Susuriin ang bawat itlog kung naglalaman ng tinype mong keyword
                            for _, eggModel in ipairs(renderedEggs:GetChildren()) do
                                local modelNameLower = eggModel.Name:lower()
                                
                                -- Kung naglalaman ang pangalan ng itlog ng tinype mong salita (hal. "spin" sa "Spin Egg")
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
                                            break -- Nahanap na ang tugmang itlog
                                        end
                                    end
                                end
                            end
                            
                            -- Kung natagpuan, i-tween papunta roon at i-fire ang prompt
                            if targetCFrame then
                                local tweenDuration = 1.0 
                                local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 3, 0)})
                                tween:Play()
                                
                                local success = pcall(function()
                                    tween.Completed:Wait()
                                end)
                                
                                if success and foundPrompt and foundPrompt:IsA("ProximityPrompt") then
                                    fireproximityprompt(foundPrompt)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)




-- 2. Kunin o gawa ang section kung saan ilalagay (Palitan ang "Automatically" ng pangalan ng page mo kung kinakailangan)
local deleteGroup = createDropdownSection("Automatically", "Delete Object")


-- Global variable para sa Auto Delete Object
_G.AutoDeleteObjectEnabled = false

-- Toggle para sa Auto Delete Object (Kasama na ang "Part", Map, Vlad, Sand, at Water)
createCustomToggle(deleteGroup, "Auto Delete", "Automatically Delete the Object on Map", function(state)
    _G.AutoDeleteObjectEnabled = state
    
    if state then
        task.spawn(function()
            local Workspace = game:GetService("Workspace")
            
            -- Idinagdag natin ang "Part" sa listahan para mabura ang mga nakita mo sa Explorer
            local targetNames = {
                "Part",
                "Map",
                "Vlad", 
                "Sand", 
                "Water",
                "terrain",
                "LowerFloor"
            }
            
            while _G.AutoDeleteObjectEnabled do
                task.wait(0.2) -- Ginawa nating mas mabilis (0.2s) para agad silang mawala kapag nag-spawn
                
                -- Hanapin at burahin sa buong Workspace at sa mga anak nito (Descendants)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    for _, nameToKill in ipairs(targetNames) do
                        if obj.Name == nameToKill then
                            pcall(function()
                                obj:Destroy()
                            end)
                            break
                        end
                    end
                end
            end
        end)
    end
end)

-- 2. Kunin o gawa ang section kung saan ilalagay (Palitan ang "Automatically" ng pangalan ng page mo kung kinakailangan)
local upgradeGroup = createDropdownSection("Automatically", "Auto Upgrade")

-- Global variable para sa Auto Upgrade
_G.AutoUpgradeEnabled = false

-- Toggle para sa Auto Upgrade
createCustomToggle(upgradeGroup, "Auto Max", "Automatically Max Luck Upgrade", function(state)
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
                task.wait(0.5) -- Interval o bilis ng pag-fire ng server event (pwedeng baguhin kung gusto mo mas mabilis)
                
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
end)






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
    "Leaf Egg" ,
    " Mushroom Egg",
    "Stone Egg",
    "Slime Egg", 
    "Crystal Egg"
    

}

local miscGroup = createDropdownSection("Misc", "ESP Eggs")

-- Global variables
local selectedEggsMap = {} -- Gagamitin natin bilang dictionary para mas mabilis at sigurado ang pag-check
isEggEspOn = false

-- Multi-select Dropdown na sinigurong kaya ang parehong Array at Dictionary format
createDropdownSelect(miscGroup, "Select Eggs to ESP", eggChoicesList, function(selectedTable)
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
    
    
end)

-- Toggle para i-on o i-off ang ESP (Fixed)
createCustomToggle(miscGroup, "Turn on ESP Eggs", "Nagpapakita ng Highlight at Pangalan sa mga napiling itlog", function(state)
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
                                textLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Kulay dilaw ang text
                                textLabel.TextStrokeTransparency = 0 -- May itim na outline
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
            
            -- PANGHULING PAGLILINIS kapag huminto ang habang-buhay na loop
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
end)



----------------------------------------------------
-- DISABLE MESSAGE UI TOGGLE SECTION
----------------------------------------------------
local miscGroup = createDropdownSection("Misc", "UI")
_G.DisableGameMessages = false

-- Gamitin ang iyong kasalukuyang section o gumawa ng bago (hal. playGroup o miscGroup)
-- Palitan ang "playGroup" kung sa ibang seksyon mo ito gustong ilagay
createCustomToggle(miscGroup, "Disable Notif", "Hide Notification GUI", function(state)
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
end)






createCustomButton("Settings", "Save Config", "Backup Your Setup", function()
    
    
    saveConfigToFile()
    showNotification("Configuration successfully saved manually!")
    
end)

createCustomButton("Settings", "Delete Config", "Remove Saved Setup", function()
    
    deleteConfigFromFile()
    showNotification("Configuration successfully deleted!")
    
end)




-- ====================================================================
-- DAYTIME / MORNING TOGGLE (SETTINGS)
-- ====================================================================
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

-- I-save ang original settings para maibalik kapag naka-off
local originalLightingData = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient,
    GlobalShadows = Lighting.GlobalShadows,
    Atmosphere = {},
    ColorCorrection = {},
    Sky = {}
}

createToggle("Settings", "DayTime/Morning", "Toggles Brightness", function(state)
    local function notify(title, text, duration)
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end

    if state then
        -- ===== [TOGGLE ON] =====
        -- I-save ang current state mago bago palitan
        originalLightingData.ClockTime = Lighting.ClockTime
        originalLightingData.Brightness = Lighting.Brightness
        originalLightingData.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLightingData.Ambient = Lighting.Ambient
        originalLightingData.GlobalShadows = Lighting.GlobalShadows

        pcall(function()
            Lighting.ClockTime = 14
            Lighting.Brightness = 3
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.Ambient = Color3.fromRGB(150, 150, 150)
            Lighting.GlobalShadows = false
            
            for _, child in ipairs(Lighting:GetChildren()) do
                if child:IsA("Atmosphere") then
                    originalLightingData.Atmosphere[child] = {Density = child.Density, Haze = child.Haze, Color = child.Color, Decay = child.Decay}
                    child.Density = 0
                    child.Haze = 0
                    child.Color = Color3.fromRGB(255, 255, 255)
                    child.Decay = Color3.fromRGB(255, 255, 255)
                elseif child:IsA("ColorCorrectionEffect") then
                    originalLightingData.ColorCorrection[child] = {TintColor = child.TintColor, Saturation = child.Saturation, Contrast = child.Contrast}
                    child.TintColor = Color3.fromRGB(255, 255, 255)
                    child.Saturation = 0.1
                    child.Contrast = 0.1
                elseif child:IsA("Sky") then
                    originalLightingData.Sky[child] = child.StarCount
                    child.StarCount = 0
                end
            end
        end)
        
        notify("DayTime Active", "☀️ DayTime Morning Enabled", 2.5)
    else
        -- ===== [TOGGLE OFF] =====
        pcall(function()
            Lighting.ClockTime = originalLightingData.ClockTime
            Lighting.Brightness = originalLightingData.Brightness
            Lighting.OutdoorAmbient = originalLightingData.OutdoorAmbient
            Lighting.Ambient = originalLightingData.Ambient
            Lighting.GlobalShadows = originalLightingData.GlobalShadows
            
            for child, data in pairs(originalLightingData.Atmosphere) do
                if child and child.Parent then
                    child.Density = data.Density
                    child.Haze = data.Haze
                    child.Color = data.Color
                    child.Decay = data.Decay
                end
            end

            for child, data in pairs(originalLightingData.ColorCorrection) do
                if child and child.Parent then
                    child.TintColor = data.TintColor
                    child.Saturation = data.Saturation
                    child.Contrast = data.Contrast
                end
            end

            for child, starCount in pairs(originalLightingData.Sky) do
                if child and child.Parent then
                    child.StarCount = starCount
                end
            end
        end)

        notify("DayTime Disabled", "🌙 Original Darkness Restored", 2.5)
    end
end)






-- ANTI GAMEPLAYPAUSED (WITH CONSOLE LOGS)
pcall(function()
    local GuiService = game:GetService("GuiService")
    local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui", 5)
    
    print("[ANTI-PAUSE] Sinisimulan ang pag-scan sa GameplayPaused...")

    -- 1. I-disable ang Notification gamit ang GuiService API
    GuiService:SetGameplayPausedNotificationEnabled(false)
    print("[ANTI-PAUSE] Tagumpay: Na-disable na ang GameplayPaused Notification via API.")

    -- 2. Hanapin ang mismong GUI Object para sa visual confirmation
    if RobloxGui then
        local pauseUI = RobloxGui:FindFirstChild("CoreScripts/NetworkPause") or RobloxGui:FindFirstChild("NetworkPause")
        
        if pauseUI then
            print("[ANTI-PAUSE] Nahanap ang GameplayPaused GUI Object sa CoreGui: " .. pauseUI:GetFullName())
            -- Paalala: Sa ilang executors, pwedeng itago ang visibility nito imbes na i-destroy
            pauseUI.Enabled = false 
            print("[ANTI-PAUSE] Tagumpay: Itinatago ang GUI Object.")
        else
            print("[ANTI-PAUSE] Paunawa: Walang aktibong NetworkPause GUI na nakita sa ngayon (naka-abang sa background).")
        end
    end

    -- 3. Puwersahang i-bypass ang player state kung maaari
    if game.Players.LocalPlayer then
        game.Players.LocalPlayer.GameplayPaused = false
        print("[ANTI-PAUSE] Tagumpay: Pinwersang i-unpause ang LocalPlayer state.")
    end
end)



--  ANTI AFK

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

print("Anti-AFK Script Active!")

LocalPlayer.Idled:Connect(function()
    print("Idled detected! Resetting timer...")

    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)




-- ====================================================================
-- ANTI-LAG / LOW GRAPHICS TOGGLE
-- ====================================================================
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local antilagConnection = nil
local originalSettings = {}

createneToggle("Settings", "Anti-Lag / Low Graphics", "Boosts FPS by disabling shadows, particles, and heavy textures", function(state)
    local function notify(title, text, duration)
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end

    if state then
        -- ===== [TOGGLE ON] =====
        notify("Anti-Lag", "Enabling FPS Boost...", 2)

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
                v.Material = "Plastic"
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

        notify("Anti-Lag", "âš¡ Anti-Lag Enabled: Graphics Optimized", 3)
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
        notify("Anti-Lag", "âšª Anti-Lag Disabled: Original Graphics Restored", 2)
    end
end)


-- ====================================================================
-- PLAYER ESP TOGGLE (HOGO STYLE)
-- ====================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerEspConnection = nil

createToggle("Players", "Player ESP", "Highlights other players with ESP", function(state)
    local function notify(title, text, duration)
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end

    -- Function para maglagay ng ESP sa specific player
    local function setupPlayerESP(targetPlayer)
        if targetPlayer == player then return end
        
        local function addESP(char)
            if not char then return end
            local tagIdentifier = "PlayerESP_" .. targetPlayer.Name
            
            -- Siguraduhing walang madodoble
            if CoreGui:FindFirstChild(tagIdentifier) then
                CoreGui[tagIdentifier]:Destroy()
            end

            -- Highlight para sa buong katawan
            local highlight = char:FindFirstChild("PlayerEspHighlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "PlayerEspHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Pula (Red) o pwede mong palitan
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
                highlight.Parent = char
            end

            -- BillboardGui para sa Name tag sa ibabaw ng ulo
            local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = tagIdentifier
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.AlwaysOnTop = true
                billboard.ExtentsOffset = Vector3.new(0, 3, 0)
                billboard.Adornee = head
                billboard.Parent = CoreGui
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = targetPlayer.Name
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 16
                label.Font = Enum.Font.SourceSansBold
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                label.TextStrokeTransparency = 0
                label.Parent = billboard
            end
        end

        if targetPlayer.Character then
            addESP(targetPlayer.Character)
        end
        
        targetPlayer.CharacterAdded:Connect(function(char)
            if state then
                task.wait(1) -- Hintayin mag-load ang character pag-respawn
                addESP(char)
            end
        end)
    end

    if state then
        -- ===== [TOGGLE ON] =====
        for _, p in ipairs(Players:GetPlayers()) do
            setupPlayerESP(p)
        end

        playerEspConnection = Players.PlayerAdded:Connect(function(p)
            setupPlayerESP(p)
        end)

        notify("ESP ACTIVE", "ðŸŸ¢ Player ESP: ON", 2)
    else
        -- ===== [TOGGLE OFF] =====
        if playerEspConnection then
            playerEspConnection:Disconnect()
            playerEspConnection = nil
        end

        -- Alisin ang lahat ng ESP highlights at billboards
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("PlayerEspHighlight")
                if hl then hl:Destroy() end
            end
        end

        for _, gui in ipairs(CoreGui:GetChildren()) do
            if string.sub(gui.Name, 1, 10) == "PlayerESP_" then
                gui:Destroy()
            end
        end

        notify("ESP STATUS", "âšª Player ESP: OFF", 2)
    end
end)


-- ====================================================================
-- MOBILE & PC FRIENDLY FLY TOGGLE WITH ADJUSTABLE SPEED SLIDER
-- ====================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local speaker = Players.LocalPlayer
local camera = workspace.CurrentCamera

local flyActive = false
local flyConnection = nil
local flyKeyDown, flyKeyUp = nil, nil

-- Dito nakaimbak ang adjustable flight speed (Default ay 14)
local flightSpeed = 0 

-- 1. Slider para sa Fly Speed (1 hanggang 200 range)
createSlider("Players", "Fly Speed", "Ayusin ang bilis ng paglipad", 0, 1000, 0, function(value)
    flightSpeed = value
    
    
end)

-- 2. Toggle para sa Fly
createToggle("Players", "Fly", "Allows you to Fly", function(state)
    local function notify(title, text, duration)
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end

    local char = speaker.Character or speaker.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")

    if not root or not humanoid then
        notify("Fly Error", "Character root or humanoid not found!", 2)
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
                    local speedMultiplier = flightSpeed * 5 -- Pinalakas nang konti para ramdam sa mobile joystick
                    
                    -- Ginagamit ang Camera CFrame para sumabay ang lipad kung saan ka nakatingin gamit ang analog
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

        notify("Fly Active", "✈️ Flight Enabled", 2)
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

        notify("Fly Disabled", "🛑 Flight Mode Off", 2)
    end
end)





-- ====================================================================
-- NOCLIP TOGGLE (SETTINGS)
-- ====================================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local noclipConnection = nil

createToggle("Players", "Noclip", "Walk through walls and obstacles", function(state)
    local function notify(title, text, duration)
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end

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

        notify("NOCLIP", "🟢 Noclip Enabled: Walking through walls", 2)
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

        notify("NOCLIP", "⚪ Noclip Disabled: Collisions Restored", 2)
    end
end)







switchTab("Players")
