local CHRFLib = {}
local AllElements = {} 

function CHRFLib:CreateWindow(hubName)
    hubName = hubName or "CHRF YAZILIM"
    local isClosed = false
    local isAnimating = false -- AÇ/KAPA BUG FİX İÇİN KİLİT
    
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    -- [[ ULTRA PREMIUM RENK PALETİ ]]
    local Colors = {
        Background = Color3.fromRGB(16, 12, 12),
        TabMenu = Color3.fromRGB(22, 16, 16),
        ElementBg = Color3.fromRGB(28, 20, 20),
        Accent = Color3.fromRGB(170, 20, 40),
        AccentDark = Color3.fromRGB(110, 10, 20),
        TextMain = Color3.fromRGB(250, 250, 250),
        TextMuted = Color3.fromRGB(160, 150, 150),
        Stroke = Color3.fromRGB(50, 30, 30)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CHRF_Premium_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 99999 

    -- [[ BİLDİRİM SİSTEMİ ]]
    local NotifContainer = Instance.new("Frame", ScreenGui)
    NotifContainer.Name = "NotifContainer"
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Position = UDim2.new(1, -270, 1, -20) 
    NotifContainer.Size = UDim2.new(0, 260, 1, 0)
    NotifContainer.AnchorPoint = Vector2.new(0, 1)
    local NotifList = Instance.new("UIListLayout", NotifContainer)
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifList.Padding = UDim.new(0, 12)

    function CHRFLib:MakeNotification(cfg)
        local title = cfg.Title or "Bildirim"
        local content = cfg.Content or "İçerik"
        local time = cfg.Time or 3
        local isDiscord = cfg.IsDiscord or false

        local notif = Instance.new(isDiscord and "TextButton" or "Frame", NotifContainer)
        notif.BackgroundColor3 = Colors.Background
        notif.Size = UDim2.new(1, 50, 0, 70)
        notif.BackgroundTransparency = 1
        if isDiscord then notif.Text = "" end
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
        local nStroke = Instance.new("UIStroke", notif)
        nStroke.Color = Colors.Accent
        nStroke.Thickness = 1.5
        nStroke.Transparency = 1

        local sideBar = Instance.new("Frame", notif)
        sideBar.BackgroundColor3 = Colors.Accent
        sideBar.Size = UDim2.new(0, 4, 1, -12)
        sideBar.Position = UDim2.new(0, 6, 0, 6)
        sideBar.BackgroundTransparency = 1
        Instance.new("UICorner", sideBar).CornerRadius = UDim.new(1, 0)

        local nTitle = Instance.new("TextLabel", notif)
        nTitle.BackgroundTransparency = 1
        nTitle.Position = UDim2.new(0, 18, 0, 8)
        nTitle.Size = UDim2.new(1, -28, 0, 20)
        nTitle.Font = Enum.Font.GothamBold
        nTitle.Text = title
        nTitle.TextColor3 = Colors.Accent
        nTitle.TextSize = 14
        nTitle.TextXAlignment = Enum.TextXAlignment.Left
        nTitle.TextTransparency = 1

        local nContent = Instance.new("TextLabel", notif)
        nContent.BackgroundTransparency = 1
        nContent.Position = UDim2.new(0, 18, 0, 28)
        nContent.Size = UDim2.new(1, -28, 0, 35)
        nContent.Font = Enum.Font.GothamSemibold
        nContent.Text = content
        nContent.TextColor3 = Colors.TextMain
        nContent.TextSize = 12
        nContent.TextXAlignment = Enum.TextXAlignment.Left
        nContent.TextWrapped = true
        nContent.TextTransparency = 1

        if isDiscord then
            local glow = Instance.new("UIGradient", notif)
            glow.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
                ColorSequenceKeypoint.new(1, Colors.Background)
            }
            nStroke.Color = Color3.fromRGB(88, 101, 242)
            sideBar.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            nTitle.TextColor3 = Color3.fromRGB(88, 101, 242)

            notif.MouseEnter:Connect(function()
                TweenService:Create(nStroke, TweenInfo.new(0.3), {Thickness = 2.5}):Play()
            end)
            notif.MouseLeave:Connect(function()
                TweenService:Create(nStroke, TweenInfo.new(0.3), {Thickness = 1.5}):Play()
            end)
            
            notif.MouseButton1Click:Connect(function()
                pcall(function()
                    if request then
                        request({
                            Url = "http://127.0.0.1:6463/rpc?v=1",
                            Method = "POST",
                            Headers = {
                                ["Content-Type"] = "application/json",
                                ["Origin"] = "https://discord.com"
                            },
                            Body = game:GetService("HttpService"):JSONEncode({
                                cmd = "INVITE_BROWSER",
                                args = {code = "JdPvbjRswP"},
                                nonce = game:GetService("HttpService"):GenerateGUID(false)
                            })
                        })
                    elseif setclipboard then
                        setclipboard("https://discord.gg/JdPvbjRswP")
                    end
                end)
            end)
        end

        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.05}):Play()
        TweenService:Create(sideBar, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
        TweenService:Create(nStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
        TweenService:Create(nTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        TweenService:Create(nContent, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        
        task.delay(time, function()
            local tOut = TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1})
            TweenService:Create(sideBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(nStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
            TweenService:Create(nTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(nContent, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            tOut:Play()
            tOut.Completed:Wait()
            notif:Destroy()
        end)
    end

    -- DISCORD OTOMATİK BİLDİRİM (1 Dakikada 1 Kez)
    task.spawn(function()
        task.wait(6) 
        while true do
            CHRFLib:MakeNotification({
                Title = "CHRF+ Software", 
                Content = "En güncel ve güçlü hileler için Discord'a katıl! (Tıklayarak katılabilirsin)", 
                Time = 8,
                IsDiscord = true
            })
            task.wait(60) 
        end
    end)


    -- [[ SEKSİ INTRO ARAYÜZÜ ]]
    local IntroFrame = Instance.new("Frame", ScreenGui)
    IntroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroFrame.Size = UDim2.new(0, 0, 0, 0) 
    IntroFrame.BackgroundColor3 = Colors.Background
    IntroFrame.ClipsDescendants = true
    Instance.new("UICorner", IntroFrame).CornerRadius = UDim.new(0, 12)
    local IntroStroke = Instance.new("UIStroke", IntroFrame)
    IntroStroke.Color = Colors.Accent
    IntroStroke.Thickness = 2
    IntroStroke.Transparency = 1 

    local IntroTitle = Instance.new("TextLabel", IntroFrame)
    IntroTitle.BackgroundTransparency = 1
    IntroTitle.Size = UDim2.new(1, -20, 0, 45)
    IntroTitle.Position = UDim2.new(0, 10, 0, 15)
    IntroTitle.Font = Enum.Font.GothamBlack
    IntroTitle.Text = hubName
    IntroTitle.TextColor3 = Colors.TextMain
    IntroTitle.TextScaled = true 
    local TitleConstraint = Instance.new("UITextSizeConstraint", IntroTitle)
    TitleConstraint.MaxTextSize = 26
    TitleConstraint.MinTextSize = 15

    local IntroSub = Instance.new("TextLabel", IntroFrame)
    IntroSub.BackgroundTransparency = 1
    IntroSub.Size = UDim2.new(1, 0, 0, 20)
    IntroSub.Position = UDim2.new(0, 0, 0, 65)
    IntroSub.Font = Enum.Font.GothamBold
    IntroSub.Text = "Premium Edition Initializing..."
    IntroSub.TextColor3 = Colors.TextMuted
    IntroSub.TextSize = 13

    local DevLabel = Instance.new("TextLabel", IntroFrame)
    DevLabel.BackgroundTransparency = 1
    DevLabel.Size = UDim2.new(1, 0, 0, 15)
    DevLabel.Position = UDim2.new(0, 0, 0, 90) 
    DevLabel.Font = Enum.Font.GothamSemibold
    DevLabel.Text = "Developers: iWeeKs, Tonyalı, Samaras"
    DevLabel.TextColor3 = Colors.Accent
    DevLabel.TextSize = 12
    DevLabel.TextTransparency = 1

    local LoadBg = Instance.new("Frame", IntroFrame)
    LoadBg.BackgroundColor3 = Colors.ElementBg
    LoadBg.Size = UDim2.new(0, 420, 0, 4)
    LoadBg.AnchorPoint = Vector2.new(0.5, 0)
    LoadBg.Position = UDim2.new(0.5, 0, 1, -30)
    Instance.new("UICorner", LoadBg).CornerRadius = UDim.new(1, 0)

    local LoadFill = Instance.new("Frame", LoadBg)
    LoadFill.BackgroundColor3 = Colors.Accent
    LoadFill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", LoadFill).CornerRadius = UDim.new(1, 0)

    -- [[ ANA ARAYÜZ ]]
    local MainWhiteFrame = Instance.new("Frame", ScreenGui)
    MainWhiteFrame.Name = "Main"
    MainWhiteFrame.BackgroundColor3 = Colors.Accent
    MainWhiteFrame.BorderSizePixel = 0
    MainWhiteFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainWhiteFrame.Size = UDim2.new(0, 0, 0, 0)
    MainWhiteFrame.Visible = false 
    Instance.new("UICorner", MainWhiteFrame).CornerRadius = UDim.new(0, 10)
    
    local MainGradient = Instance.new("UIGradient", MainWhiteFrame)
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.Accent),
        ColorSequenceKeypoint.new(1, Colors.Background)
    }
    MainGradient.Rotation = 45

    local MainWhiteFrame_2 = Instance.new("Frame", MainWhiteFrame)
    MainWhiteFrame_2.BackgroundColor3 = Colors.Background
    MainWhiteFrame_2.BorderSizePixel = 0
    MainWhiteFrame_2.Position = UDim2.new(0, 2, 0, 2)
    MainWhiteFrame_2.Size = UDim2.new(1, -4, 1, -4)
    Instance.new("UICorner", MainWhiteFrame_2).CornerRadius = UDim.new(0, 8)

    local TooltipLabel = Instance.new("TextLabel", MainWhiteFrame_2)
    TooltipLabel.BackgroundColor3 = Colors.Accent
    TooltipLabel.Size = UDim2.new(1, -135, 0, 25)
    TooltipLabel.Position = UDim2.new(0, 130, 1, -30)
    TooltipLabel.Font = Enum.Font.GothamSemibold
    TooltipLabel.TextColor3 = Colors.TextMain
    TooltipLabel.TextSize = 12
    TooltipLabel.Text = ""
    TooltipLabel.TextTransparency = 1
    TooltipLabel.BackgroundTransparency = 1
    TooltipLabel.ZIndex = 10
    Instance.new("UICorner", TooltipLabel).CornerRadius = UDim.new(0, 4)

    local function ShowTooltip(text)
        if text and text ~= "" then
            TooltipLabel.Text = text
            TweenService:Create(TooltipLabel, TweenInfo.new(0.2), {TextTransparency = 0, BackgroundTransparency = 0.1}):Play()
        end
    end
    local function HideTooltip()
        TweenService:Create(TooltipLabel, TweenInfo.new(0.2), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    end

    task.spawn(function()
        local t1 = TweenService:Create(IntroFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 170)}) 
        TweenService:Create(IntroStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
        t1:Play()
        t1.Completed:Wait()
        
        TweenService:Create(DevLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 0, Position = UDim2.new(0, 0, 0, 85)}):Play()

        task.wait(0.2)
        local t2 = TweenService:Create(LoadFill, TweenInfo.new(1.8, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)})
        t2:Play()
        t2.Completed:Wait()
        
        IntroSub.Text = "Welcome to the Future!"
        IntroSub.TextColor3 = Colors.Accent
        task.wait(0.5)
        
        local t3 = TweenService:Create(IntroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        TweenService:Create(IntroStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(DevLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        t3:Play()
        t3.Completed:Wait()
        IntroFrame:Destroy()
        
        MainWhiteFrame.Visible = true
        TweenService:Create(MainWhiteFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 550, 0, 350), 
            Position = UDim2.new(0.5, -275, 0.5, -175)
        }):Play()
    end)

    local tabFrame = Instance.new("Frame", MainWhiteFrame_2)
    tabFrame.BackgroundColor3 = Colors.TabMenu
    tabFrame.Position = UDim2.new(0, 6, 0, 6)
    tabFrame.Size = UDim2.new(0, 130, 1, -12)
    Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 6)
    local tabStroke = Instance.new("UIStroke", tabFrame)
    tabStroke.Color = Colors.Stroke
    tabStroke.Thickness = 1
    local tabList = Instance.new("UIListLayout", tabFrame)
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 6)
    local tabPadd = Instance.new("UIPadding", tabFrame)
    tabPadd.PaddingTop = UDim.new(0, 10)

    local header = Instance.new("Frame", MainWhiteFrame_2)
    header.Name = "TopBar"
    header.BackgroundColor3 = Colors.Accent
    header.Position = UDim2.new(0, 142, 0, 6)
    header.Size = UDim2.new(1, -148, 0, 42)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)
    
    local HeaderGradient = Instance.new("UIGradient", header)
    HeaderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.Accent),
        ColorSequenceKeypoint.new(1, Colors.AccentDark)
    }

    local libTitle = Instance.new("TextLabel", header)
    libTitle.BackgroundTransparency = 1
    libTitle.Position = UDim2.new(0, 15, 0, 0)
    libTitle.Size = UDim2.new(0.6, 0, 1, 0)
    libTitle.Font = Enum.Font.GothamBlack
    libTitle.Text = hubName
    libTitle.TextColor3 = Colors.TextMain
    libTitle.TextSize = 16
    libTitle.TextXAlignment = Enum.TextXAlignment.Left

    local searchBtn = Instance.new("ImageButton", header)
    searchBtn.BackgroundTransparency = 1
    searchBtn.Position = UDim2.new(1, -65, 0.5, -10)
    searchBtn.Size = UDim2.new(0, 20, 0, 20)
    searchBtn.Image = "rbxassetid://6031154871"
    
    local searchBox = Instance.new("TextBox", header)
    searchBox.Visible = false
    searchBox.BackgroundColor3 = Colors.ElementBg
    searchBox.Position = UDim2.new(1, -210, 0.5, -15)
    searchBox.Size = UDim2.new(0, 140, 0, 30)
    searchBox.Font = Enum.Font.GothamSemibold
    searchBox.PlaceholderText = "Özellik Ara..."
    searchBox.Text = ""
    searchBox.TextColor3 = Colors.TextMain
    searchBox.TextSize = 13
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
    local searchStroke = Instance.new("UIStroke", searchBox)
    searchStroke.Color = Colors.Accent
    searchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local closeLib = Instance.new("ImageButton", header)
    closeLib.BackgroundTransparency = 1
    closeLib.Position = UDim2.new(1, -30, 0.5, -10)
    closeLib.Size = UDim2.new(0, 20, 0, 20)
    closeLib.Image = "rbxassetid://4988112250"

    local elementContainer = Instance.new("Frame", MainWhiteFrame_2)
    elementContainer.Name = "ElementContainer"
    elementContainer.BackgroundColor3 = Colors.Background
    elementContainer.Position = UDim2.new(0, 142, 0, 54)
    elementContainer.Size = UDim2.new(1, -148, 1, -60)
    elementContainer.BackgroundTransparency = 1
    local pagesFolder = Instance.new("Folder", elementContainer)
    
    local searchTab = Instance.new("ScrollingFrame", pagesFolder)
    searchTab.BackgroundTransparency = 1
    searchTab.Size = UDim2.new(1, 0, 1, 0)
    searchTab.ScrollBarThickness = 3
    searchTab.Visible = false
    local searchList = Instance.new("UIListLayout", searchTab)
    searchList.SortOrder = Enum.SortOrder.LayoutOrder
    searchList.Padding = UDim.new(0, 8)
    
    local ActivePage = nil
    local isSearchOpen = false
    searchBtn.MouseButton1Click:Connect(function()
        isSearchOpen = not isSearchOpen
        searchBox.Visible = isSearchOpen
        if not isSearchOpen then searchBox.Text = "" end
    end)

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchBox.Text)
        if query == "" then
            searchTab.Visible = false
            if ActivePage then ActivePage.Visible = true end
            for frame, data in pairs(AllElements) do
                frame.Parent = data.OriginalParent
                frame.Visible = true
            end
        else
            if ActivePage then ActivePage.Visible = false end
            searchTab.Visible = true
            for frame, data in pairs(AllElements) do
                if string.find(string.lower(data.Name), query) then
                    frame.Parent = searchTab
                    frame.Visible = true
                else
                    frame.Visible = false
                    frame.Parent = data.OriginalParent
                end
            end
        end
    end)

    local MinimizedPanel = Instance.new("Frame", MainWhiteFrame)
    MinimizedPanel.Size = UDim2.new(1, 0, 1, 0)
    MinimizedPanel.BackgroundTransparency = 1
    MinimizedPanel.Visible = false
    local minText = Instance.new("TextLabel", MinimizedPanel)
    minText.Size = UDim2.new(1, 0, 1, 0)
    minText.BackgroundTransparency = 1
    minText.Font = Enum.Font.GothamBold
    minText.Text = "CHRF YAZILIM"
    minText.TextColor3 = Colors.TextMain
    minText.TextSize = 14

    local resizeHandle = Instance.new("TextButton", MainWhiteFrame_2)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Position = UDim2.new(1, -15, 1, -15)
    resizeHandle.Size = UDim2.new(0, 15, 0, 15)
    resizeHandle.Text = "◢"
    resizeHandle.TextColor3 = Colors.TextMuted
    resizeHandle.TextSize = 14
    
    local isResizing, dragStart, startSize = false, nil, UDim2.new(0, 550, 0, 350)
    local Draggable, DragMousePosition, FramePosition = false, nil, nil
    local isDraggingMin, minDragStart = false, nil

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(MainWhiteFrame.Position.X.Scale, MainWhiteFrame.Position.Y.Scale)
        end
    end)

    MinimizedPanel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(MainWhiteFrame.Position.X.Scale, MainWhiteFrame.Position.Y.Scale)
            isDraggingMin = false
            minDragStart = input.Position
        end
    end)

    -- AÇ/KAPA BUG FİX (KİLİT MEKANİZMASI EKLENDİ)
    MinimizedPanel.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not isDraggingMin and not isAnimating then
                isAnimating = true
                isClosed = false
                local tOpen = TweenService:Create(MainWhiteFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = startSize})
                tOpen:Play()
                MinimizedPanel.Visible = false
                MainWhiteFrame_2.Visible = true
                tOpen.Completed:Wait()
                isAnimating = false
            end
            isDraggingMin = false
            minDragStart = nil
        end
    end)

    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = true
            dragStart = input.Position
            startSize = MainWhiteFrame.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newX = math.clamp(startSize.X.Offset + delta.X, 480, 900)
            local newY = math.clamp(startSize.Y.Offset + delta.Y, 300, 600)
            MainWhiteFrame.Size = UDim2.new(0, newX, 0, newY)
        elseif Draggable and not isResizing then
            local NewPosition = FramePosition + ((Vector2.new(input.Position.X, input.Position.Y) - DragMousePosition) / Camera.ViewportSize)
            MainWhiteFrame.Position = UDim2.new(NewPosition.X, 0, NewPosition.Y, 0)
            if minDragStart and (input.Position - minDragStart).Magnitude > 5 then
                isDraggingMin = true
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            isResizing = false 
            Draggable = false
            if not isClosed then startSize = MainWhiteFrame.Size end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
            ScreenGui.Enabled = not ScreenGui.Enabled
            if ScreenGui.Enabled then
                UserInputService.MouseIconEnabled = true 
                if ActivePage then ActivePage.Visible = true end
            end
        end
    end)

    -- AÇ/KAPA BUG FİX (KİLİT MEKANİZMASI EKLENDİ)
    closeLib.MouseButton1Click:Connect(function()
        if not isClosed and not isAnimating then
            isAnimating = true
            isClosed = true
            if not startSize then startSize = MainWhiteFrame.Size end
            MainWhiteFrame_2.Visible = false
            MinimizedPanel.Visible = true
            local tClose = TweenService:Create(MainWhiteFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 160, 0, 40)})
            tClose:Play()
            tClose.Completed:Wait()
            isAnimating = false
        end
    end)
    
    -- [[ KÜTÜPHANEYE ÖZEL ARAMA UI MODÜLÜ ]]
    function CHRFLib:CreatePlayerSelector(callback)
        local SelectorGui = Instance.new("ScreenGui", game.CoreGui)
        SelectorGui.Name = "CHRF_SelectorLayer"
        SelectorGui.ResetOnSpawn = false
        SelectorGui.DisplayOrder = 2147483647 
        SelectorGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

        local CustomPlayerSelector = Instance.new("Frame", SelectorGui)
        CustomPlayerSelector.Size = UDim2.new(0, 240, 0, 350)
        CustomPlayerSelector.Position = UDim2.new(0.5, -120, 0.5, -175)
        CustomPlayerSelector.BackgroundColor3 = Colors.ElementBg
        CustomPlayerSelector.BorderSizePixel = 0
        CustomPlayerSelector.Visible = false
        CustomPlayerSelector.Active = true
        CustomPlayerSelector.ZIndex = 9999999
        
        local psDrag, psDragInp, psDragStart, psStartPos
        CustomPlayerSelector.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                psDrag = true; psDragStart = input.Position; psStartPos = CustomPlayerSelector.Position
            end
        end)
        CustomPlayerSelector.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then psDragInp = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == psDragInp and psDrag then
                local delta = input.Position - psDragStart
                CustomPlayerSelector.Position = UDim2.new(psStartPos.X.Scale, psStartPos.X.Offset + delta.X, psStartPos.Y.Scale, psStartPos.Y.Offset + delta.Y)
            end
        end)
        CustomPlayerSelector.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then psDrag = false end
        end)

        Instance.new("UICorner", CustomPlayerSelector).CornerRadius = UDim.new(0, 8)
        local CPSStroke = Instance.new("UIStroke", CustomPlayerSelector)
        CPSStroke.Color = Colors.Accent
        CPSStroke.Thickness = 2

        local CPSTitle = Instance.new("TextLabel", CustomPlayerSelector)
        CPSTitle.Size = UDim2.new(1, -40, 0, 35)
        CPSTitle.Position = UDim2.new(0, 10, 0, 0)
        CPSTitle.BackgroundTransparency = 1
        CPSTitle.Text = "Oyuncu Seç"
        CPSTitle.TextColor3 = Colors.TextMain
        CPSTitle.Font = Enum.Font.GothamBold
        CPSTitle.TextSize = 15
        CPSTitle.TextXAlignment = Enum.TextXAlignment.Left
        CPSTitle.ZIndex = 9999999

        local CPSClose = Instance.new("TextButton", CustomPlayerSelector)
        CPSClose.Size = UDim2.new(0, 35, 0, 35)
        CPSClose.Position = UDim2.new(1, -35, 0, 0)
        CPSClose.BackgroundTransparency = 1
        CPSClose.Text = "X"
        CPSClose.TextColor3 = Color3.fromRGB(255, 60, 60)
        CPSClose.Font = Enum.Font.GothamBold
        CPSClose.TextSize = 16
        CPSClose.ZIndex = 9999999
        CPSClose.MouseButton1Click:Connect(function() CustomPlayerSelector.Visible = false end)

        local CPSSearch = Instance.new("TextBox", CustomPlayerSelector)
        CPSSearch.Size = UDim2.new(1, -20, 0, 35)
        CPSSearch.Position = UDim2.new(0, 10, 0, 40)
        CPSSearch.BackgroundColor3 = Colors.Background
        CPSSearch.TextColor3 = Colors.TextMain
        CPSSearch.PlaceholderText = " İsmi buraya yaz..."
        CPSSearch.Font = Enum.Font.GothamSemibold
        CPSSearch.TextSize = 13
        CPSSearch.TextXAlignment = Enum.TextXAlignment.Left
        CPSSearch.ZIndex = 9999999
        Instance.new("UICorner", CPSSearch).CornerRadius = UDim.new(0, 6)
        local searchStroke = Instance.new("UIStroke", CPSSearch)
        searchStroke.Color = Colors.Stroke

        local CPSScroll = Instance.new("ScrollingFrame", CustomPlayerSelector)
        CPSScroll.Size = UDim2.new(1, -20, 1, -95)
        CPSScroll.Position = UDim2.new(0, 10, 0, 85)
        CPSScroll.BackgroundTransparency = 1
        CPSScroll.ScrollBarThickness = 5
        CPSScroll.ScrollBarImageColor3 = Colors.Accent
        CPSScroll.ZIndex = 9999999

        local CPSListLayout = Instance.new("UIListLayout", CPSScroll)
        CPSListLayout.Padding = UDim.new(0, 5)
        CPSListLayout.SortOrder = Enum.SortOrder.Name

        local function Refresh(filterText)
            for _, child in ipairs(CPSScroll:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            
            filterText = filterText and string.lower(filterText) or ""
            
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local pName = string.lower(p.Name)
                    local pDisp = string.lower(p.DisplayName)
                    
                    if filterText == "" or string.find(pName, filterText) or string.find(pDisp, filterText) then
                        local btn = Instance.new("TextButton", CPSScroll)
                        btn.Name = p.Name
                        btn.Size = UDim2.new(1, -10, 0, 30)
                        btn.BackgroundColor3 = Colors.Background
                        btn.TextColor3 = Colors.TextMain
                        btn.Text = "  " .. p.Name
                        btn.Font = Enum.Font.GothamSemibold
                        btn.TextSize = 13
                        btn.TextXAlignment = Enum.TextXAlignment.Left
                        btn.ZIndex = 9999999
                        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
                        
                        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.AccentDark}):Play() end)
                        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Background}):Play() end)

                        btn.MouseButton1Click:Connect(function()
                            CustomPlayerSelector.Visible = false
                            if callback then callback(p.Name) end
                        end)
                    end
                end
            end
            CPSScroll.CanvasSize = UDim2.new(0, 0, 0, CPSListLayout.AbsoluteContentSize.Y)
        end

        CPSSearch.Changed:Connect(function(prop)
            if prop == "Text" then Refresh(CPSSearch.Text) end
        end)
        
        return function()
            CPSSearch.Text = ""
            Refresh("")
            CustomPlayerSelector.Visible = true
        end
    end

    local SectionHandler = {}

    function SectionHandler:CreateSection(secName)
        local tabBtn = Instance.new("TextButton", tabFrame)
        tabBtn.BackgroundColor3 = Colors.Background
        tabBtn.Size = UDim2.new(1, -10, 0, 35)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = secName
        tabBtn.TextColor3 = Colors.TextMuted
        tabBtn.TextSize = 13
        tabBtn.AutoButtonColor = false
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
        local btnStroke = Instance.new("UIStroke", tabBtn)
        btnStroke.Color = Colors.Stroke
        btnStroke.Thickness = 1

        local newPage = Instance.new("ScrollingFrame", pagesFolder)
        newPage.BackgroundTransparency = 1
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ScrollBarThickness = 3
        newPage.ScrollBarImageColor3 = Colors.Accent
        newPage.Visible = false

        local pageItemList = Instance.new("UIListLayout", newPage)
        pageItemList.SortOrder = Enum.SortOrder.LayoutOrder
        pageItemList.Padding = UDim.new(0, 8)

        local UIPadding = Instance.new("UIPadding", newPage)
        UIPadding.PaddingRight = UDim.new(0, 5)
        UIPadding.PaddingLeft = UDim.new(0, 2)

        local function UpdateSize()
            newPage.CanvasSize = UDim2.new(0, 0, 0, pageItemList.AbsoluteContentSize.Y + 10)
            searchTab.CanvasSize = UDim2.new(0, 0, 0, searchList.AbsoluteContentSize.Y + 10)
        end
        newPage.ChildAdded:Connect(UpdateSize)
        newPage.ChildRemoved:Connect(UpdateSize)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(pagesFolder:GetChildren()) do
                if v ~= searchTab then v.Visible = false end
            end
            newPage.Visible = true
            ActivePage = newPage
            for _, v in pairs(tabFrame:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Colors.Background, TextColor3 = Colors.TextMuted}):Play()
                end
            end
            TweenService:Create(tabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.TextMain}):Play()
            if isSearchOpen then
                searchBox.Text = ""
                isSearchOpen = false
                searchBox.Visible = false
            end
        end)

        if #pagesFolder:GetChildren() == 2 then
            tabBtn.BackgroundColor3 = Colors.Accent
            tabBtn.TextColor3 = Colors.TextMain
            newPage.Visible = true
            ActivePage = newPage
        end

        local ElementHandler = {}

        local function CreateBaseFrame(height, desc)
            local frame = Instance.new("Frame")
            frame.BackgroundColor3 = Colors.ElementBg
            frame.Size = UDim2.new(1, 0, 0, height)
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", frame).Color = Colors.Stroke
            if desc then
                frame.MouseEnter:Connect(function() ShowTooltip(desc) end)
                frame.MouseLeave:Connect(function() HideTooltip() end)
            end
            return frame
        end

        function ElementHandler:TextLabel(labelText)
            local frame = CreateBaseFrame(35)
            frame.Parent = newPage
            local label = Instance.new("TextLabel", frame)
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -20, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.Font = Enum.Font.GothamBold
            label.Text = labelText
            label.TextColor3 = Colors.Accent
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            AllElements[frame] = {Name = labelText, OriginalParent = newPage}
        end

        function ElementHandler:TextButton(buttonText, buttonInfo, callback, desc)
            local frame = CreateBaseFrame(45, desc)
            frame.Parent = newPage
            local info = Instance.new("TextLabel", frame)
            info.BackgroundTransparency = 1
            info.Position = UDim2.new(0, 10, 0, 0)
            info.Size = UDim2.new(0.5, 0, 1, 0)
            info.Font = Enum.Font.GothamSemibold
            info.Text = buttonText
            info.TextColor3 = Colors.TextMain
            info.TextSize = 13
            info.TextXAlignment = Enum.TextXAlignment.Left
            local btn = Instance.new("TextButton", frame)
            btn.BackgroundColor3 = Colors.Accent
            btn.Position = UDim2.new(1, -100, 0.5, -14)
            btn.Size = UDim2.new(0, 90, 0, 28)
            btn.Font = Enum.Font.GothamBold
            btn.Text = buttonInfo
            btn.TextColor3 = Colors.TextMain
            btn.TextSize = 12
            btn.AutoButtonColor = false
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.AccentDark, Size = UDim2.new(0, 92, 0, 30), Position = UDim2.new(1, -101, 0.5, -15)}):Play() end)
            btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent, Size = UDim2.new(0, 90, 0, 28), Position = UDim2.new(1, -100, 0.5, -14)}):Play() end)
            
            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 85, 0, 26), Position = UDim2.new(1, -97, 0.5, -13)}):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 92, 0, 30), Position = UDim2.new(1, -101, 0.5, -15)}):Play()
                callback()
            end)
            AllElements[frame] = {Name = buttonText, OriginalParent = newPage}
        end

        function ElementHandler:Toggle(togInfo, callback, default, desc)
            local frame = CreateBaseFrame(45, desc)
            frame.Parent = newPage
            local info = Instance.new("TextLabel", frame)
            info.BackgroundTransparency = 1
            info.Position = UDim2.new(0, 10, 0, 0)
            info.Size = UDim2.new(0.7, 0, 1, 0)
            info.Font = Enum.Font.GothamSemibold
            info.Text = togInfo
            info.TextColor3 = Colors.TextMain
            info.TextSize = 13
            info.TextXAlignment = Enum.TextXAlignment.Left
            local toggleBtn = Instance.new("TextButton", frame)
            toggleBtn.BackgroundColor3 = default and Colors.Accent or Colors.Background
            toggleBtn.Position = UDim2.new(1, -55, 0.5, -12)
            toggleBtn.Size = UDim2.new(0, 45, 0, 24)
            toggleBtn.Text = ""
            Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
            Instance.new("UIStroke", toggleBtn).Color = Colors.Stroke
            local indicator = Instance.new("Frame", toggleBtn)
            indicator.BackgroundColor3 = default and Colors.TextMain or Colors.TextMuted
            indicator.Size = UDim2.new(0, 18, 0, 18)
            indicator.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

            local toggled = default or false
            
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                callback(toggled)
                if toggled then
                    TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.Accent}):Play()
                    TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Colors.TextMain}):Play()
                else
                    TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.Background}):Play()
                    TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Colors.TextMuted}):Play()
                end 
            end)
            AllElements[frame] = {Name = togInfo, OriginalParent = newPage}
        end

        function ElementHandler:Slider(sliderInfo, min, max, callback, default, desc)
            local frame = CreateBaseFrame(55, desc)
            frame.Parent = newPage
            local info = Instance.new("TextLabel", frame)
            info.BackgroundTransparency = 1
            info.Position = UDim2.new(0, 10, 0, 5)
            info.Size = UDim2.new(0.5, 0, 0, 20)
            info.Font = Enum.Font.GothamSemibold
            info.Text = sliderInfo
            info.TextColor3 = Colors.TextMain
            info.TextSize = 13
            info.TextXAlignment = Enum.TextXAlignment.Left
            local valLabel = Instance.new("TextLabel", frame)
            valLabel.BackgroundTransparency = 1
            valLabel.Position = UDim2.new(0.5, -10, 0, 5)
            valLabel.Size = UDim2.new(0.5, 0, 0, 20)
            valLabel.Font = Enum.Font.GothamBold
            valLabel.Text = (default or min).."/"..max
            valLabel.TextColor3 = Colors.Accent
            valLabel.TextSize = 12
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            local sliderBg = Instance.new("TextButton", frame)
            sliderBg.BackgroundColor3 = Colors.Background
            sliderBg.Position = UDim2.new(0, 10, 0, 32)
            sliderBg.Size = UDim2.new(1, -20, 0, 10)
            sliderBg.Text = ""
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
            local defScale = ((default or min) - min) / (max - min)
            local sliderFill = Instance.new("Frame", sliderBg)
            sliderFill.BackgroundColor3 = Colors.Accent
            sliderFill.Size = UDim2.new(defScale, 0, 1, 0)
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
            local mouse = game.Players.LocalPlayer:GetMouse()
            local uis = game:GetService("UserInputService")
            local isSliding = false

            local function update(input)
                local relativeX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
                local scale = relativeX / sliderBg.AbsoluteSize.X
                TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
                local value = math.floor(min + ((max - min) * scale))
                valLabel.Text = value.."/"..max
                pcall(function() callback(value) end)
            end

            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isSliding = true; update(input) end
            end)
            uis.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isSliding = false end
            end)
            uis.InputChanged:Connect(function(input)
                if isSliding and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end)
            AllElements[frame] = {Name = sliderInfo, OriginalParent = newPage}
        end

        function ElementHandler:Dropdown(dInfo, list, callback, default, desc)
            local frame = CreateBaseFrame(45, desc)
            frame.Parent = newPage
            frame.ClipsDescendants = true
            local btn = Instance.new("TextButton", frame)
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, 45)
            btn.Font = Enum.Font.GothamSemibold
            btn.Text = "   "..dInfo..(default and (": "..default) or "")
            btn.TextColor3 = Colors.TextMain
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            local icon = Instance.new("ImageLabel", btn)
            icon.BackgroundTransparency = 1
            icon.Position = UDim2.new(1, -25, 0.5, -8)
            icon.Size = UDim2.new(0, 16, 0, 16)
            icon.Image = "rbxassetid://5165666242"
            icon.ImageColor3 = Colors.Accent
            local layout = Instance.new("UIListLayout", frame)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local isDropped = false
            btn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                if isDropped then
                    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 45 + (#list * 32))}):Play()
                    TweenService:Create(icon, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Rotation = 180}):Play()
                else
                    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                    TweenService:Create(icon, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Rotation = 0}):Play()
                end
            end)

            for _, item in ipairs(list) do
                local option = Instance.new("TextButton", frame)
                option.BackgroundColor3 = Colors.Background
                option.Size = UDim2.new(1, -12, 0, 28)
                option.Font = Enum.Font.Gotham
                option.Text = item
                option.TextColor3 = Colors.TextMuted
                option.TextSize = 12
                option.AutoButtonColor = false
                Instance.new("UICorner", option).CornerRadius = UDim.new(0, 6)
                
                option.MouseEnter:Connect(function() TweenService:Create(option, TweenInfo.new(0.2), {TextColor3 = Colors.TextMain}):Play() end)
                option.MouseLeave:Connect(function() TweenService:Create(option, TweenInfo.new(0.2), {TextColor3 = Colors.TextMuted}):Play() end)

                option.MouseButton1Click:Connect(function()
                    callback(item)
                    btn.Text = "   "..dInfo..": "..item
                    isDropped = false
                    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                    TweenService:Create(icon, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Rotation = 0}):Play()
                end)
            end
            AllElements[frame] = {Name = dInfo, OriginalParent = newPage}
        end

        function ElementHandler:ColorPicker(pInfo, defaultColor, callback, desc)
            local frame = CreateBaseFrame(45, desc)
            frame.Parent = newPage
            frame.ClipsDescendants = true
            
            local btn = Instance.new("TextButton", frame)
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, 45)
            btn.Font = Enum.Font.GothamSemibold
            btn.Text = "   "..pInfo
            btn.TextColor3 = Colors.TextMain
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left

            local displayColor = Instance.new("Frame", btn)
            displayColor.Size = UDim2.new(0, 35, 0, 18)
            displayColor.Position = UDim2.new(1, -45, 0.5, -9)
            displayColor.BackgroundColor3 = defaultColor or Color3.new(1,1,1)
            Instance.new("UICorner", displayColor).CornerRadius = UDim.new(0, 4)
            Instance.new("UIStroke", displayColor).Color = Colors.Stroke

            local isDropped = false
            btn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, isDropped and 140 or 45)}):Play()
            end)

            local function createColorSlider(yPos, colorName, maxC)
                local sLabel = Instance.new("TextLabel", frame)
                sLabel.BackgroundTransparency = 1
                sLabel.Size = UDim2.new(0, 20, 0, 20)
                sLabel.Position = UDim2.new(0, 10, 0, yPos)
                sLabel.Font = Enum.Font.GothamBold
                sLabel.Text = colorName
                sLabel.TextColor3 = maxC
                sLabel.TextSize = 12
                
                local sBg = Instance.new("TextButton", frame)
                sBg.BackgroundColor3 = Colors.Background
                sBg.Size = UDim2.new(1, -50, 0, 10)
                sBg.Position = UDim2.new(0, 35, 0, yPos+5)
                sBg.Text = ""
                Instance.new("UICorner", sBg).CornerRadius = UDim.new(1, 0)
                local sFill = Instance.new("Frame", sBg)
                sFill.BackgroundColor3 = maxC
                sFill.Size = UDim2.new((defaultColor and (colorName=="R" and defaultColor.R or colorName=="G" and defaultColor.G or defaultColor.B) or 1), 0, 1, 0)
                Instance.new("UICorner", sFill).CornerRadius = UDim.new(1, 0)
                return sBg, sFill
            end

            local rBg, rFill = createColorSlider(55, "R", Color3.fromRGB(255, 50, 50))
            local gBg, gFill = createColorSlider(80, "G", Color3.fromRGB(50, 255, 50))
            local bBg, bFill = createColorSlider(105, "B", Color3.fromRGB(50, 100, 255))
            local currentColor = defaultColor or Color3.new(1,1,1)
            local uis = game:GetService("UserInputService")

            local function handleSlider(bg, fill, colorIndex)
                local isS = false
                bg.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then isS = true end end)
                uis.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then isS = false end end)
                uis.InputChanged:Connect(function(inp)
                    if isS and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local scale = math.clamp((inp.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                        TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
                        if colorIndex == 1 then currentColor = Color3.new(scale, currentColor.G, currentColor.B)
                        elseif colorIndex == 2 then currentColor = Color3.new(currentColor.R, scale, currentColor.B)
                        else currentColor = Color3.new(currentColor.R, currentColor.G, scale) end
                        displayColor.BackgroundColor3 = currentColor
                        callback(currentColor)
                    end
                end)
            end
            handleSlider(rBg, rFill, 1)
            handleSlider(gBg, gFill, 2)
            handleSlider(bBg, bFill, 3)
            AllElements[frame] = {Name = pInfo, OriginalParent = newPage}
        end

        return ElementHandler
    end
    return SectionHandler
end 
return CHRFLib
