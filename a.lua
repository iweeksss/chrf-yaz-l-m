local CHRFLib = {}
local AllElements = {} 

function CHRFLib:CreateWindow(hubName)
    hubName = hubName or "CHRF YAZILIM"
    local isClosed = false
    local TweenService = game:GetService("TweenService")
    
    -- Renk Paleti (Siyah / Bordo Teması)
    local Colors = {
        Background = Color3.fromRGB(15, 12, 12),
        TabMenu = Color3.fromRGB(20, 16, 16),
        ElementBg = Color3.fromRGB(25, 20, 20),
        Accent = Color3.fromRGB(138, 15, 34),
        TextMain = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(170, 160, 160),
        Stroke = Color3.fromRGB(45, 30, 30)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CHRF_Premium_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [[ AKTİF MODLAR PANELİ (YENİ) ]]
    local ActiveModsFrame = Instance.new("Frame", ScreenGui)
    ActiveModsFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 8)
    ActiveModsFrame.BackgroundTransparency = 0.4
    ActiveModsFrame.Position = UDim2.new(0, 10, 0.4, 0)
    ActiveModsFrame.Size = UDim2.new(0, 150, 0, 30)
    Instance.new("UICorner", ActiveModsFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", ActiveModsFrame).Color = Colors.Stroke
    
    local ActiveTitle = Instance.new("TextLabel", ActiveModsFrame)
    ActiveTitle.BackgroundTransparency = 1
    ActiveTitle.Size = UDim2.new(1, 0, 0, 30)
    ActiveTitle.Font = Enum.Font.GothamBold
    ActiveTitle.Text = "AKTİF MODLAR"
    ActiveTitle.TextColor3 = Colors.Accent
    ActiveTitle.TextSize = 12
    
    local ActiveList = Instance.new("UIListLayout", ActiveModsFrame)
    ActiveList.SortOrder = Enum.SortOrder.LayoutOrder
    ActiveList.Padding = UDim.new(0, 2)
    
    -- Sürüklenebilir Aktif Modlar Paneli
    local amDrag, amPos, amStart
    ActiveModsFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            amDrag = true
            amPos = input.Position
            amStart = ActiveModsFrame.Position
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if amDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - amPos
            ActiveModsFrame.Position = UDim2.new(amStart.X.Scale, amStart.X.Offset + delta.X, amStart.Y.Scale, amStart.Y.Offset + delta.Y)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then amDrag = false end
    end)

    local activeMods = {}
    function CHRFLib:SetModState(modName, isActive)
        if isActive then
            if not activeMods[modName] then
                local lbl = Instance.new("TextLabel", ActiveModsFrame)
                lbl.BackgroundTransparency = 1
                lbl.Size = UDim2.new(1, -10, 0, 20)
                lbl.Position = UDim2.new(0, 10, 0, 0)
                lbl.Font = Enum.Font.GothamSemibold
                lbl.Text = "• " .. modName
                lbl.TextColor3 = Colors.TextMain
                lbl.TextSize = 11
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                activeMods[modName] = lbl
                ActiveModsFrame.Size = UDim2.new(0, 150, 0, 30 + (ActiveList.AbsoluteContentSize.Y))
            end
        else
            if activeMods[modName] then
                activeMods[modName]:Destroy()
                activeMods[modName] = nil
                ActiveModsFrame.Size = UDim2.new(0, 150, 0, 30 + (ActiveList.AbsoluteContentSize.Y))
            end
        end
    end

    -- [[ BİLDİRİM SİSTEMİ ]]
    local NotifContainer = Instance.new("Frame", ScreenGui)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Position = UDim2.new(1, -260, 1, -20)
    NotifContainer.Size = UDim2.new(0, 250, 1, 0)
    NotifContainer.AnchorPoint = Vector2.new(0, 1)
    local NotifList = Instance.new("UIListLayout", NotifContainer)
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifList.Padding = UDim.new(0, 10)

    function CHRFLib:MakeNotification(cfg)
        local notif = Instance.new("Frame", NotifContainer)
        notif.BackgroundColor3 = Colors.ElementBg
        notif.Size = UDim2.new(1, 50, 0, 60) 
        notif.BackgroundTransparency = 1
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
        local nStroke = Instance.new("UIStroke", notif)
        nStroke.Color = Colors.Accent
        nStroke.Transparency = 1

        local nTitle = Instance.new("TextLabel", notif)
        nTitle.BackgroundTransparency = 1
        nTitle.Position = UDim2.new(0, 10, 0, 5)
        nTitle.Size = UDim2.new(1, -20, 0, 20)
        nTitle.Font = Enum.Font.GothamBold
        nTitle.Text = cfg.Title or "Bildirim"
        nTitle.TextColor3 = Colors.Accent
        nTitle.TextSize = 14
        nTitle.TextXAlignment = Enum.TextXAlignment.Left
        nTitle.TextTransparency = 1

        local nContent = Instance.new("TextLabel", notif)
        nContent.BackgroundTransparency = 1
        nContent.Position = UDim2.new(0, 10, 0, 25)
        nContent.Size = UDim2.new(1, -20, 0, 30)
        nContent.Font = Enum.Font.GothamSemibold
        nContent.Text = cfg.Content or ""
        nContent.TextColor3 = Colors.TextMain
        nContent.TextSize = 12
        nContent.TextXAlignment = Enum.TextXAlignment.Left
        nContent.TextWrapped = true
        nContent.TextTransparency = 1

        TweenService:Create(notif, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
        TweenService:Create(nStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
        TweenService:Create(nTitle, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        TweenService:Create(nContent, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        
        task.delay(cfg.Time or 3, function()
            TweenService:Create(notif, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            TweenService:Create(nStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
            TweenService:Create(nTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
            local t = TweenService:Create(nContent, TweenInfo.new(0.4), {TextTransparency = 1})
            t:Play()
            t.Completed:Wait()
            notif:Destroy()
        end)
    end

    -- [[ ANA MENÜ ARAYÜZÜ ]]
    local MainWhiteFrame = Instance.new("Frame", ScreenGui)
    MainWhiteFrame.BackgroundColor3 = Colors.Accent
    MainWhiteFrame.BorderSizePixel = 0
    MainWhiteFrame.Position = UDim2.new(0.5, -264, 0.5, -155)
    MainWhiteFrame.Size = UDim2.new(0, 528, 0, 310)
    Instance.new("UICorner", MainWhiteFrame).CornerRadius = UDim.new(0, 8)
    
    -- DROP SHADOW (GÖLGE) EFEKTİ YENİ!
    local Shadow = Instance.new("ImageLabel", MainWhiteFrame)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = -5
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

    -- GRADIENT GEÇİŞ EFEKTİ YENİ!
    local MainGradient = Instance.new("UIGradient", MainWhiteFrame)
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 10, 20))
    }
    MainGradient.Rotation = 45

    local MainWhiteFrame_2 = Instance.new("Frame", MainWhiteFrame)
    MainWhiteFrame_2.BackgroundColor3 = Colors.Background
    MainWhiteFrame_2.BorderSizePixel = 0
    MainWhiteFrame_2.Position = UDim2.new(0, 2, 0, 2)
    MainWhiteFrame_2.Size = UDim2.new(1, -4, 1, -4)
    Instance.new("UICorner", MainWhiteFrame_2).CornerRadius = UDim.new(0, 6)

    -- TOOLTIP (BİLGİ BALONCUĞU) SİSTEMİ YENİ!
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

    local tabFrame = Instance.new("Frame", MainWhiteFrame_2)
    tabFrame.BackgroundColor3 = Colors.TabMenu
    tabFrame.Position = UDim2.new(0, 5, 0, 5)
    tabFrame.Size = UDim2.new(0, 120, 1, -10)
    Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", tabFrame).Color = Colors.Stroke
    local tabList = Instance.new("UIListLayout", tabFrame)
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 5)
    Instance.new("UIPadding", tabFrame).PaddingTop = UDim.new(0, 8)

    local header = Instance.new("Frame", MainWhiteFrame_2)
    header.BackgroundColor3 = Colors.Accent
    header.Position = UDim2.new(0, 130, 0, 5)
    header.Size = UDim2.new(1, -135, 0, 40)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)
    
    local HeaderGradient = Instance.new("UIGradient", header)
    HeaderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 10, 20))
    }

    local libTitle = Instance.new("TextLabel", header)
    libTitle.BackgroundTransparency = 1
    libTitle.Position = UDim2.new(0, 15, 0, 0)
    libTitle.Size = UDim2.new(0.6, 0, 1, 0)
    libTitle.Font = Enum.Font.GothamBold
    libTitle.Text = hubName
    libTitle.TextColor3 = Colors.TextMain
    libTitle.TextSize = 16
    libTitle.TextXAlignment = Enum.TextXAlignment.Left

    local closeLib = Instance.new("ImageButton", header)
    closeLib.BackgroundTransparency = 1
    closeLib.Position = UDim2.new(1, -30, 0.5, -10)
    closeLib.Size = UDim2.new(0, 20, 0, 20)
    closeLib.Image = "rbxassetid://4988112250"

    local elementContainer = Instance.new("Frame", MainWhiteFrame_2)
    elementContainer.BackgroundColor3 = Colors.Background
    elementContainer.Position = UDim2.new(0, 130, 0, 50)
    elementContainer.Size = UDim2.new(1, -135, 1, -55)
    elementContainer.BackgroundTransparency = 1
    local pagesFolder = Instance.new("Folder", elementContainer)

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
    
    local isResizing, dragStart, startSize = false, nil, UDim2.new(0, 528, 0, 310)
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(MainWhiteFrame.Position.X.Scale, MainWhiteFrame.Position.Y.Scale)
            isDraggingMin = false
            minDragStart = input.Position
        end
    end)
    MinimizedPanel.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not isDraggingMin then
                isClosed = false
                MainWhiteFrame:TweenSize(startSize, "Out", "Quint", 0.3)
                MinimizedPanel.Visible = false
                MainWhiteFrame_2.Visible = true
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
            MainWhiteFrame.Size = UDim2.new(0, math.clamp(startSize.X.Offset + delta.X, 450, 900), 0, math.clamp(startSize.Y.Offset + delta.Y, 250, 600))
        elseif Draggable and not isResizing then
            MainWhiteFrame.Position = UDim2.new(FramePosition.X + ((input.Position.X - DragMousePosition.X) / Camera.ViewportSize.X), 0, FramePosition.Y + ((input.Position.Y - DragMousePosition.Y) / Camera.ViewportSize.Y), 0)
            if minDragStart and (input.Position - minDragStart).Magnitude > 5 then isDraggingMin = true end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            isResizing, Draggable = false, false
            if not isClosed then startSize = MainWhiteFrame.Size end
        end
    end)

    -- MOUSE SERBEST BIRAKMA (YENİ)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
            ScreenGui.Enabled = not ScreenGui.Enabled
            if ScreenGui.Enabled then
                UserInputService.MouseIconEnabled = true -- Menü açıldığında fare serbest kalır
            end
        end
    end)

    closeLib.MouseButton1Click:Connect(function()
        if not isClosed then
            isClosed = true
            if not startSize then startSize = MainWhiteFrame.Size end
            MainWhiteFrame_2.Visible = false
            MinimizedPanel.Visible = true
            MainWhiteFrame:TweenSize(UDim2.new(0, 160, 0, 40), "In", "Quint", 0.3)
        end
    end)

    local SectionHandler = {}
    function SectionHandler:CreateSection(secName)
        local tabBtn = Instance.new("TextButton", tabFrame)
        tabBtn.BackgroundColor3 = Colors.Background
        tabBtn.Size = UDim2.new(1, -10, 0, 35)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = secName
        tabBtn.TextColor3 = Colors.TextMuted
        tabBtn.TextSize = 13
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)
        Instance.new("UIStroke", tabBtn).Color = Colors.Stroke

        local newPage = Instance.new("ScrollingFrame", pagesFolder)
        newPage.BackgroundTransparency = 1
        newPage.Size = UDim2.new(1, 0, 1, -35)
        newPage.ScrollBarThickness = 3
        newPage.ScrollBarImageColor3 = Colors.Accent
        newPage.Visible = false

        local pageItemList = Instance.new("UIListLayout", newPage)
        pageItemList.SortOrder = Enum.SortOrder.LayoutOrder
        pageItemList.Padding = UDim.new(0, 6)
        Instance.new("UIPadding", newPage).PaddingRight = UDim.new(0, 5)

        local function UpdateSize() newPage.CanvasSize = UDim2.new(0, 0, 0, pageItemList.AbsoluteContentSize.Y + 10) end
        newPage.ChildAdded:Connect(UpdateSize)
        newPage.ChildRemoved:Connect(UpdateSize)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(pagesFolder:GetChildren()) do v.Visible = false end
            newPage.Visible = true
            for _, v in pairs(tabFrame:GetChildren()) do
                if v:IsA("TextButton") then TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Background, TextColor3 = Colors.TextMuted}):Play() end
            end
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.TextMain}):Play()
        end)

        if #pagesFolder:GetChildren() == 1 then
            tabBtn.BackgroundColor3 = Colors.Accent
            tabBtn.TextColor3 = Colors.TextMain
            newPage.Visible = true
        end

        local ElementHandler = {}

        local function CreateBaseFrame(height, desc)
            local frame = Instance.new("Frame")
            frame.BackgroundColor3 = Colors.ElementBg
            frame.Size = UDim2.new(1, 0, 0, height)
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
            Instance.new("UIStroke", frame).Color = Colors.Stroke
            if desc then
                frame.MouseEnter:Connect(function() ShowTooltip(desc) end)
                frame.MouseLeave:Connect(function() HideTooltip() end)
            end
            return frame
        end

        function ElementHandler:TextLabel(labelText)
            local frame = CreateBaseFrame(30)
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
        end

        function ElementHandler:TextButton(buttonText, buttonInfo, callback, desc)
            local frame = CreateBaseFrame(40, desc)
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
            btn.Position = UDim2.new(1, -90, 0.5, -12)
            btn.Size = UDim2.new(0, 80, 0, 24)
            btn.Font = Enum.Font.GothamBold
            btn.Text = buttonInfo
            btn.TextColor3 = Colors.TextMain
            btn.TextSize = 12
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(callback)
        end

        function ElementHandler:Toggle(togInfo, callback, default, desc)
            local frame = CreateBaseFrame(40, desc)
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
            toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBtn.Size = UDim2.new(0, 40, 0, 24)
            toggleBtn.Text = ""
            Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
            Instance.new("UIStroke", toggleBtn).Color = Colors.Stroke
            local indicator = Instance.new("Frame", toggleBtn)
            indicator.BackgroundColor3 = default and Colors.TextMain or Colors.TextMuted
            indicator.Size = UDim2.new(0, 16, 0, 16)
            indicator.Position = default and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

            local toggled = default or false
            if toggled then CHRFLib:SetModState(togInfo, true) end -- Aktif panele ekle
            
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                callback(toggled)
                CHRFLib:SetModState(togInfo, toggled)
                if toggled then
                    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                    TweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = Colors.TextMain}):Play()
                else
                    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Background}):Play()
                    TweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = Colors.TextMuted}):Play()
                end 
            end)
        end

        function ElementHandler:Slider(sliderInfo, min, max, callback, default, desc)
            local frame = CreateBaseFrame(50, desc)
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
            sliderBg.Position = UDim2.new(0, 10, 0, 30)
            sliderBg.Size = UDim2.new(1, -20, 0, 8)
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
                sliderFill.Size = UDim2.new(scale, 0, 1, 0)
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
        end

        function ElementHandler:Dropdown(dInfo, list, callback, default, desc)
            local frame = CreateBaseFrame(40, desc)
            frame.Parent = newPage
            frame.ClipsDescendants = true
            local btn = Instance.new("TextButton", frame)
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, 40)
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
                    TweenService:Create(frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40 + (#list * 30))}):Play()
                    TweenService:Create(icon, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    TweenService:Create(frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(icon, TweenInfo.new(0.2), {Rotation = 0}):Play()
                end
            end)

            for _, item in ipairs(list) do
                local option = Instance.new("TextButton", frame)
                option.BackgroundColor3 = Colors.Background
                option.Size = UDim2.new(1, -10, 0, 28)
                option.Font = Enum.Font.Gotham
                option.Text = item
                option.TextColor3 = Colors.TextMuted
                option.TextSize = 12
                Instance.new("UICorner", option).CornerRadius = UDim.new(0, 4)
                option.MouseButton1Click:Connect(function()
                    callback(item)
                    btn.Text = "   "..dInfo..": "..item
                    isDropped = false
                    TweenService:Create(frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(icon, TweenInfo.new(0.2), {Rotation = 0}):Play()
                end)
            end
        end

        function ElementHandler:ColorPicker(pInfo, defaultColor, callback, desc)
            local frame = CreateBaseFrame(40, desc)
            frame.Parent = newPage
            frame.ClipsDescendants = true
            local btn = Instance.new("TextButton", frame)
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Font = Enum.Font.GothamSemibold
            btn.Text = "   "..pInfo
            btn.TextColor3 = Colors.TextMain
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left

            local displayColor = Instance.new("Frame", btn)
            displayColor.Size = UDim2.new(0, 30, 0, 16)
            displayColor.Position = UDim2.new(1, -40, 0.5, -8)
            displayColor.BackgroundColor3 = defaultColor or Color3.new(1,1,1)
            Instance.new("UICorner", displayColor).CornerRadius = UDim.new(0, 4)
            Instance.new("UIStroke", displayColor).Color = Colors.Stroke

            local isDropped = false
            btn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                TweenService:Create(frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, isDropped and 130 or 40)}):Play()
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
                sBg.Size = UDim2.new(1, -50, 0, 8)
                sBg.Position = UDim2.new(0, 35, 0, yPos+6)
                sBg.Text = ""
                Instance.new("UICorner", sBg).CornerRadius = UDim.new(1, 0)
                local sFill = Instance.new("Frame", sBg)
                sFill.BackgroundColor3 = maxC
                sFill.Size = UDim2.new((defaultColor and (colorName=="R" and defaultColor.R or colorName=="G" and defaultColor.G or defaultColor.B) or 1), 0, 1, 0)
                Instance.new("UICorner", sFill).CornerRadius = UDim.new(1, 0)
                return sBg, sFill
            end

            local rBg, rFill = createColorSlider(50, "R", Color3.fromRGB(255, 50, 50))
            local gBg, gFill = createColorSlider(75, "G", Color3.fromRGB(50, 255, 50))
            local bBg, bFill = createColorSlider(100, "B", Color3.fromRGB(50, 100, 255))
            local currentColor = defaultColor or Color3.new(1,1,1)
            local uis = game:GetService("UserInputService")

            local function handleSlider(bg, fill, colorIndex)
                local isS = false
                bg.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then isS = true end end)
                uis.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then isS = false end end)
                uis.InputChanged:Connect(function(inp)
                    if isS and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local scale = math.clamp((inp.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                        fill.Size = UDim2.new(scale, 0, 1, 0)
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
        end

        return ElementHandler
    end
    return SectionHandler
end 
return CHRFLib
