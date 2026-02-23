local CHRFLib = {}
local AllElements = {} 

function CHRFLib:CreateWindow(hubName)
    hubName = hubName or "CHRF YAZILIM"
    local isClosed = false
    
    local TweenService = game:GetService("TweenService")
    
    -- Renk Paleti (Siyah / Bordo Teması)
    local Colors = {
        Background = Color3.fromRGB(15, 12, 12), -- Koyu Siyah/Hafif Bordo Tonu
        TabMenu = Color3.fromRGB(20, 16, 16),
        ElementBg = Color3.fromRGB(25, 20, 20),
        Accent = Color3.fromRGB(138, 15, 34), -- Saf Bordo (Burgundy)
        TextMain = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(170, 160, 160),
        Stroke = Color3.fromRGB(45, 30, 30)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CHRF_Premium_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [[ PREMIUM INTRO ARAYÜZÜ (KIRPILMA SORUNU ÇÖZÜLDÜ) ]]
    local IntroFrame = Instance.new("Frame")
    IntroFrame.Name = "IntroFrame"
    IntroFrame.Parent = ScreenGui
    IntroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroFrame.Size = UDim2.new(0, 0, 0, 0) -- Başlangıçta 0
    IntroFrame.BackgroundColor3 = Colors.Background
    IntroFrame.ClipsDescendants = true
    Instance.new("UICorner", IntroFrame).CornerRadius = UDim.new(0, 8)
    
    local IntroStroke = Instance.new("UIStroke", IntroFrame)
    IntroStroke.Color = Colors.Accent
    IntroStroke.Thickness = 2
    IntroStroke.Transparency = 1 

    local IntroTitle = Instance.new("TextLabel", IntroFrame)
    IntroTitle.BackgroundTransparency = 1
    IntroTitle.Size = UDim2.new(1, -20, 0, 40)
    IntroTitle.Position = UDim2.new(0, 10, 0, 20)
    IntroTitle.Font = Enum.Font.GothamBold
    IntroTitle.Text = hubName
    IntroTitle.TextColor3 = Colors.TextMain
    IntroTitle.TextScaled = true -- ASIL ÇÖZÜM: Yazı boyutu kutuya göre otomatik şekillenir
    
    -- Yazının çok aşırı büyümesini engellemek için sınırlandırıcı
    local TitleConstraint = Instance.new("UITextSizeConstraint", IntroTitle)
    TitleConstraint.MaxTextSize = 20
    TitleConstraint.MinTextSize = 10

    local IntroSub = Instance.new("TextLabel", IntroFrame)
    IntroSub.BackgroundTransparency = 1
    IntroSub.Size = UDim2.new(1, 0, 0, 20)
    IntroSub.Position = UDim2.new(0, 0, 0, 65)
    IntroSub.Font = Enum.Font.GothamSemibold
    IntroSub.Text = "Premium Sürüm Yükleniyor..."
    IntroSub.TextColor3 = Colors.TextMuted
    IntroSub.TextSize = 13

    local LoadBg = Instance.new("Frame", IntroFrame)
    LoadBg.BackgroundColor3 = Colors.ElementBg
    LoadBg.Size = UDim2.new(0, 400, 0, 6) -- Bar daha estetik olması için genişletildi
    LoadBg.AnchorPoint = Vector2.new(0.5, 0)
    LoadBg.Position = UDim2.new(0.5, 0, 1, -30)
    Instance.new("UICorner", LoadBg).CornerRadius = UDim.new(1, 0)

    local LoadFill = Instance.new("Frame", LoadBg)
    LoadFill.BackgroundColor3 = Colors.Accent
    LoadFill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", LoadFill).CornerRadius = UDim.new(1, 0)

    -- [[ ANA ARAYÜZ (Başlangıçta Gizli) ]]
    local MainWhiteFrame = Instance.new("Frame")
    MainWhiteFrame.Name = "MainFrame"
    MainWhiteFrame.Parent = ScreenGui
    MainWhiteFrame.BackgroundColor3 = Colors.Accent
    MainWhiteFrame.BorderSizePixel = 0
    MainWhiteFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainWhiteFrame.Size = UDim2.new(0, 0, 0, 0)
    MainWhiteFrame.Visible = false 
    
    local mainCorner = Instance.new("UICorner", MainWhiteFrame)
    mainCorner.CornerRadius = UDim.new(0, 8)

    local MainWhiteFrame_2 = Instance.new("Frame")
    MainWhiteFrame_2.Name = "InnerFrame"
    MainWhiteFrame_2.Parent = MainWhiteFrame
    MainWhiteFrame_2.BackgroundColor3 = Colors.Background
    MainWhiteFrame_2.BorderSizePixel = 0
    MainWhiteFrame_2.Position = UDim2.new(0, 2, 0, 2)
    MainWhiteFrame_2.Size = UDim2.new(1, -4, 1, -4)
    
    local mainCorner_2 = Instance.new("UICorner", MainWhiteFrame_2)
    mainCorner_2.CornerRadius = UDim.new(0, 6)

    -- [[ INTRO ANİMASYON SÜRECİ ]]
    task.spawn(function()
        -- 1. Intro Kutusunu Ekrana Büyüterek Getir (Genişlik 480 yapıldı)
        local t1 = TweenService:Create(IntroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 480, 0, 140)})
        TweenService:Create(IntroStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
        t1:Play()
        t1.Completed:Wait()
        
        task.wait(0.2)
        
        -- 2. Yükleme Barını Doldur (1.5 Saniye)
        local t2 = TweenService:Create(LoadFill, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)})
        t2:Play()
        t2.Completed:Wait()
        
        -- 3. Yazıyı Değiştir
        IntroSub.Text = "Sistem Hazır!"
        IntroSub.TextColor3 = Colors.Accent
        task.wait(0.4)
        
        -- 4. Intro Kutusunu Küçülterek Yok Et
        local t3 = TweenService:Create(IntroFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        TweenService:Create(IntroStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        t3:Play()
        t3.Completed:Wait()
        IntroFrame:Destroy()
        
        -- 5. Ana Menüyü Havalı Bir Şekilde Aç
        MainWhiteFrame.Visible = true
        local t4 = TweenService:Create(MainWhiteFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 528, 0, 310),
            Position = UDim2.new(0.5, -264, 0.5, -155)
        })
        t4:Play()
    end)

    -- Sol Sekme Paneli
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Parent = MainWhiteFrame_2
    tabFrame.BackgroundColor3 = Colors.TabMenu
    tabFrame.BorderSizePixel = 0
    tabFrame.Position = UDim2.new(0, 5, 0, 5)
    tabFrame.Size = UDim2.new(0, 120, 1, -10)
    Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 6)
    
    local tabStroke = Instance.new("UIStroke", tabFrame)
    tabStroke.Color = Colors.Stroke
    tabStroke.Thickness = 1

    local tabList = Instance.new("UIListLayout", tabFrame)
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 5)

    local tabPadd = Instance.new("UIPadding", tabFrame)
    tabPadd.PaddingTop = UDim.new(0, 8)

    -- Üst Bar (Header)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Parent = MainWhiteFrame_2
    header.BackgroundColor3 = Colors.Accent
    header.Position = UDim2.new(0, 130, 0, 5)
    header.Size = UDim2.new(1, -135, 0, 40)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)

    local libTitle = Instance.new("TextLabel")
    libTitle.Parent = header
    libTitle.BackgroundTransparency = 1
    libTitle.Position = UDim2.new(0, 15, 0, 0)
    libTitle.Size = UDim2.new(0.6, 0, 1, 0)
    libTitle.Font = Enum.Font.GothamBold
    libTitle.Text = hubName
    libTitle.TextColor3 = Colors.TextMain
    libTitle.TextSize = 16
    libTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Arama Motoru (Search)
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
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)
    local searchStroke = Instance.new("UIStroke", searchBox)
    searchStroke.Color = Colors.Accent
    searchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Kapatma (Küçültme) Butonu
    local closeLib = Instance.new("ImageButton", header)
    closeLib.BackgroundTransparency = 1
    closeLib.Position = UDim2.new(1, -30, 0.5, -10)
    closeLib.Size = UDim2.new(0, 20, 0, 20)
    closeLib.Image = "rbxassetid://4988112250"

    -- Element Konteyneri
    local elementContainer = Instance.new("Frame")
    elementContainer.Name = "ElementContainer"
    elementContainer.Parent = MainWhiteFrame_2
    elementContainer.BackgroundColor3 = Colors.Background
    elementContainer.Position = UDim2.new(0, 130, 0, 50)
    elementContainer.Size = UDim2.new(1, -135, 1, -55)
    elementContainer.BackgroundTransparency = 1

    local pagesFolder = Instance.new("Folder", elementContainer)
    
    -- Özel Arama Sonuçları Sekmesi
    local searchTab = Instance.new("ScrollingFrame", pagesFolder)
    searchTab.Name = "SearchTab"
    searchTab.BackgroundTransparency = 1
    searchTab.Size = UDim2.new(1, 0, 1, 0)
    searchTab.ScrollBarThickness = 3
    searchTab.Visible = false
    local searchList = Instance.new("UIListLayout", searchTab)
    searchList.SortOrder = Enum.SortOrder.LayoutOrder
    searchList.Padding = UDim.new(0, 6)
    
    local ActivePage = nil

    -- Arama Mantığı
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

    -- Küçültülmüş Hal Paneli (CHRF YAZILIM)
    local MinimizedPanel = Instance.new("Frame", MainWhiteFrame)
    MinimizedPanel.Name = "MinimizedPanel"
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

    -- Yeniden Boyutlandırma (Resize) ve Drag İçin Ortak Değişkenler
    local resizeHandle = Instance.new("TextButton", MainWhiteFrame_2)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Position = UDim2.new(1, -15, 1, -15)
    resizeHandle.Size = UDim2.new(0, 15, 0, 15)
    resizeHandle.Text = "◢"
    resizeHandle.TextColor3 = Colors.TextMuted
    resizeHandle.TextSize = 14
    
    local isResizing = false
    local dragStart, startSize = nil, UDim2.new(0, 528, 0, 310)
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    local Draggable = false
    local DragMousePosition, FramePosition
    local isDraggingMin = false
    local minDragStart = nil

    -- Sürükleme Mantığı (Geniş Ekran)
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(MainWhiteFrame.Position.X.Scale, MainWhiteFrame.Position.Y.Scale)
        end
    end)

    -- Sürükleme ve Tıklama Mantığı (Küçültülmüş Ekran)
    MinimizedPanel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(MainWhiteFrame.Position.X.Scale, MainWhiteFrame.Position.Y.Scale)
            isDraggingMin = false
            minDragStart = input.Position
        end
    end)

    MinimizedPanel.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not isDraggingMin then
                -- Büyütme Olayı
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
            local newX = math.clamp(startSize.X.Offset + delta.X, 450, 900)
            local newY = math.clamp(startSize.Y.Offset + delta.Y, 250, 600)
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
            if not isClosed then
                startSize = MainWhiteFrame.Size
            end
        end
    end)

    -- K Tuşu ile Menü Gizleme/Açma
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Kapatma (Küçültme) Efekti
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
        secName = secName or "Tab"

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "tabBtn_"..secName
        tabBtn.Parent = tabFrame
        tabBtn.BackgroundColor3 = Colors.Background
        tabBtn.Size = UDim2.new(1, -10, 0, 35)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = secName
        tabBtn.TextColor3 = Colors.TextMuted
        tabBtn.TextSize = 13
        tabBtn.AutoButtonColor = false
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)
        
        local btnStroke = Instance.new("UIStroke", tabBtn)
        btnStroke.Color = Colors.Stroke
        btnStroke.Thickness = 1

        local newPage = Instance.new("ScrollingFrame", pagesFolder)
        newPage.Name = "Page_"..secName
        newPage.BackgroundTransparency = 1
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ScrollBarThickness = 3
        newPage.ScrollBarImageColor3 = Colors.Accent
        newPage.Visible = false

        local pageItemList = Instance.new("UIListLayout", newPage)
        pageItemList.SortOrder = Enum.SortOrder.LayoutOrder
        pageItemList.Padding = UDim.new(0, 6)

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
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Background, TextColor3 = Colors.TextMuted}):Play()
                end
            end
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.TextMain}):Play()
            
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

        local function CreateBaseFrame(height)
            local frame = Instance.new("Frame")
            frame.BackgroundColor3 = Colors.ElementBg
            frame.Size = UDim2.new(1, 0, 0, height)
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", frame)
            stroke.Color = Colors.Stroke
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
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

        function ElementHandler:TextButton(buttonText, buttonInfo, callback)
            local frame = CreateBaseFrame(40)
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
            AllElements[frame] = {Name = buttonText, OriginalParent = newPage}
        end

        function ElementHandler:Toggle(togInfo, callback)
            local frame = CreateBaseFrame(40)
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
            toggleBtn.BackgroundColor3 = Colors.Background
            toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBtn.Size = UDim2.new(0, 40, 0, 24)
            toggleBtn.Text = ""
            Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
            local stroke = Instance.new("UIStroke", toggleBtn)
            stroke.Color = Colors.Stroke
            
            local indicator = Instance.new("Frame", toggleBtn)
            indicator.BackgroundColor3 = Colors.TextMuted
            indicator.Size = UDim2.new(0, 16, 0, 16)
            indicator.Position = UDim2.new(0, 4, 0.5, -8)
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

            local toggled = false
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                callback(toggled)
                if toggled then
                    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                    TweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = Colors.TextMain}):Play()
                else
                    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Background}):Play()
                    TweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = Colors.TextMuted}):Play()
                end 
            end)
            
            AllElements[frame] = {Name = togInfo, OriginalParent = newPage}
        end

        function ElementHandler:Slider(sliderInfo, min, max, callback)
            local frame = CreateBaseFrame(50)
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
            valLabel.Text = min.."/"..max
            valLabel.TextColor3 = Colors.Accent
            valLabel.TextSize = 12
            valLabel.TextXAlignment = Enum.TextXAlignment.Right

            local sliderBg = Instance.new("TextButton", frame)
            sliderBg.BackgroundColor3 = Colors.Background
            sliderBg.Position = UDim2.new(0, 10, 0, 30)
            sliderBg.Size = UDim2.new(1, -20, 0, 8)
            sliderBg.Text = ""
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
            
            local sliderFill = Instance.new("Frame", sliderBg)
            sliderFill.BackgroundColor3 = Colors.Accent
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
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
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isSliding = true
                    update(input)
                end
            end)
            uis.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isSliding = false end
            end)
            uis.InputChanged:Connect(function(input)
                if isSliding and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end)
            
            AllElements[frame] = {Name = sliderInfo, OriginalParent = newPage}
        end

        function ElementHandler:Dropdown(dInfo, list, callback)
            local frame = CreateBaseFrame(40)
            frame.Parent = newPage
            frame.ClipsDescendants = true
            
            local btn = Instance.new("TextButton", frame)
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Font = Enum.Font.GothamSemibold
            btn.Text = "   "..dInfo
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
            
            AllElements[frame] = {Name = dInfo, OriginalParent = newPage}
        end

        return ElementHandler
    end
    return SectionHandler
end 
return CHRFLib
