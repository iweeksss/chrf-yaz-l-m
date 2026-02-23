-- ==============================================================================
-- [ CHRF YAZILIM HUB v4.0 - TIER 1 PREMIUM EDITION ]
-- Legit & Rage Aimbot + Yeni Gösterge Sistemleri
-- ==============================================================================

pcall(function() getgenv().CHRFHubLoaded = true end)

-- KÜTÜPHANEYİ ÇEKME İŞLEMİ (Buraya kendi raw github linkini yapıştır)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/iweeksss/chrf-yaz-l-m/refs/heads/main/a.lua"))()

-- [[ LOKAL DEĞİŞKENLER VE SERVİSLER ]]
local math_abs, math_clamp, math_floor = math.abs, math.clamp, math.floor
local Vector2_new, Vector3_new, CFrame_new, CFrame_Angles = Vector2.new, Vector3.new, CFrame.new, CFrame.Angles
local Color3_fromRGB, Color3_new = Color3.fromRGB, Color3.new

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local function AutoShootPress() if mouse1press then mouse1press() end end
local function AutoShootRelease() if mouse1release then mouse1release() end end

-- [[ GENİŞLETİLMİŞ AYARLAR ]]
local Settings = {
    -- Aimbot
    LegitAimbot = false, RageAimbot = false, AutoShoot = false, 
    AimPart = "Head", Smoothness = 3, 
    FOV = 100, ShowFOV = false, FOVColor = Color3_fromRGB(138, 15, 34), FOVThickness = 1.5,
    TeamCheck = true, AimBind = "MouseButton2", 
    Hitbox = false, HitboxSize = 5, HitboxTrans = 0.5,
    
    -- ESP
    ESP = false, ShowNames = true, ShowHealth = true, ShowDistance = true, 
    ShowSkeleton = true, ShowBox = false, ShowTracer = false,
    HighlightColor = Color3_fromRGB(140, 0, 255), VisibleColor = Color3_fromRGB(0, 255, 0), 
    TeamColor = Color3_fromRGB(0, 160, 255), SkeletonColor = Color3_fromRGB(255, 255, 255),
    
    -- Movement
    WalkSpeedOn = false, WalkSpeed = 50,
    JumpPowerOn = false, JumpPower = 100, InfJump = false,
    FlySpeed = 50, Flying = false, Noclip = false, 
    ThirdPerson = false, ThirdPersonDist = 12, 
    
    -- Misc
    Spinbot = false, SpinSpeed = 50, AntiAFK = true,
    ShowWatermark = true, ShowActiveMods = true
}

local ActiveAimBind, AimBindType, SpinAngle, isShooting = Enum.UserInputType.MouseButton2, "Mouse", 0, false 

-- Saniyede bir FPS ve Pingi gönder
local lastTick, frameCount = tick(), 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTick >= 1 then
        local ping = 0
        pcall(function() ping = math_floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        Library:UpdateWatermark(string.format("CHRF YAZILIM | FPS: %d | Ping: %dms", frameCount, ping))
        frameCount, lastTick = 0, tick()
    end
end)

-- [[ GELİŞMİŞ ESP SİSTEMİ ]]
local wallCheckParams = RaycastParams.new()
wallCheckParams.FilterType = Enum.RaycastFilterType.Exclude
wallCheckParams.IgnoreWater = true

local FOVCircle = Drawing.new("Circle")
FOVCircle.Filled = false

local Drawings = {}
local function CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for k, v in pairs(properties) do drawing[k] = v end
    return drawing
end

local function AddESP(player)
    if not Drawings[player.Name] then Drawings[player.Name] = {} end
    local d = Drawings[player.Name]
    
    local lines = {"Spine", "Neck", "UpperArm1", "LowerArm1", "UpperArm2", "LowerArm2", "UpperLeg1", "LowerLeg1", "UpperLeg2", "LowerLeg2"}
    for _, v in ipairs(lines) do if not d[v] then d[v] = CreateDrawing("Line", {Thickness = 1.5, Transparency = 1}) end end
    
    for i=1, 4 do if not d["Box"..i] then d["Box"..i] = CreateDrawing("Line", {Thickness = 1.5, Transparency = 1}) end end
    if not d.Tracer then d.Tracer = CreateDrawing("Line", {Thickness = 1.5, Transparency = 1}) end
    
    if not d.NameText then d.NameText = CreateDrawing("Text", {Size = 16, Center = true, Outline = true, Color = Color3_new(1,1,1)}) end
    if not d.DistText then d.DistText = CreateDrawing("Text", {Size = 14, Center = true, Outline = true, Color = Color3_fromRGB(255,255,0)}) end
    if not d.HpBg then d.HpBg = CreateDrawing("Square", {Filled = true, Color = Color3_new(0,0,0), Transparency = 0.7}) end
    if not d.HpFill then d.HpFill = CreateDrawing("Square", {Filled = true, Color = Color3_new(0,1,0), Transparency = 1}) end
end

local function UpdateESP(player)
    local d = Drawings[player.Name]
    if not d then return end
    local char, hum, hrp = player.Character, player.Character and player.Character:FindFirstChild("Humanoid"), player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if not Settings.ESP or not char or not hum or not hrp or hum.Health <= 0 then
        for _, v in pairs(d) do v.Visible = false end
        return
    end

    local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then for _, v in pairs(d) do v.Visible = false end return end

    local currentC = (Settings.TeamCheck and player.Team == LocalPlayer.Team) and Settings.TeamColor or Settings.SkeletonColor

    local head = char:FindFirstChild("Head")
    local top = head and Camera:WorldToViewportPoint(head.Position + Vector3_new(0, 0.5, 0)) or Camera:WorldToViewportPoint(hrp.Position + Vector3_new(0, 2, 0))
    local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3_new(0, 3, 0))
    local h = math_abs(top.Y - bottom.Y)
    local w = h / 2
    local x = rootPos.X - w / 2
    local y = top.Y

    if Settings.ShowBox then
        d.Box1.Visible, d.Box1.From, d.Box1.To, d.Box1.Color = true, Vector2_new(x, y), Vector2_new(x + w, y), currentC
        d.Box2.Visible, d.Box2.From, d.Box2.To, d.Box2.Color = true, Vector2_new(x, y), Vector2_new(x, y + h), currentC
        d.Box3.Visible, d.Box3.From, d.Box3.To, d.Box3.Color = true, Vector2_new(x + w, y), Vector2_new(x + w, y + h), currentC
        d.Box4.Visible, d.Box4.From, d.Box4.To, d.Box4.Color = true, Vector2_new(x, y + h), Vector2_new(x + w, y + h), currentC
    else
        d.Box1.Visible, d.Box2.Visible, d.Box3.Visible, d.Box4.Visible = false, false, false, false
    end

    if Settings.ShowTracer then
        d.Tracer.Visible = true
        d.Tracer.From = Vector2_new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        d.Tracer.To = Vector2_new(rootPos.X, rootPos.Y)
        d.Tracer.Color = currentC
    else d.Tracer.Visible = false end

    if Settings.ShowSkeleton then
        local function SetLine(n, p1N, p2N)
            local p1, p2 = char:FindFirstChild(p1N), char:FindFirstChild(p2N)
            if p1 and p2 then
                local pos1, v1 = Camera:WorldToViewportPoint(p1.Position)
                local pos2, v2 = Camera:WorldToViewportPoint(p2.Position)
                if v1 and v2 then
                    d[n].From, d[n].To, d[n].Color, d[n].Visible = Vector2_new(pos1.X, pos1.Y), Vector2_new(pos2.X, pos2.Y), currentC, true
                    return
                end
            end
            d[n].Visible = false
        end
        if char:FindFirstChild("UpperTorso") then
            SetLine("Spine", "UpperTorso", "LowerTorso"); SetLine("Neck", "Head", "UpperTorso")
            SetLine("UpperArm1", "UpperTorso", "LeftUpperArm"); SetLine("LowerArm1", "LeftUpperArm", "LeftLowerArm")
            SetLine("UpperArm2", "UpperTorso", "RightUpperArm"); SetLine("LowerArm2", "RightUpperArm", "RightLowerArm")
            SetLine("UpperLeg1", "LowerTorso", "LeftUpperLeg"); SetLine("LowerLeg1", "LeftUpperLeg", "LeftLowerLeg")
            SetLine("UpperLeg2", "LowerTorso", "RightUpperLeg"); SetLine("LowerLeg2", "RightUpperLeg", "RightLowerLeg")
        elseif char:FindFirstChild("Torso") then
            SetLine("Spine", "Head", "Torso"); SetLine("Neck", "Torso", "Torso")
            SetLine("UpperArm1", "Torso", "Left Arm"); SetLine("LowerArm1", "Left Arm", "Left Arm")
            SetLine("UpperArm2", "Torso", "Right Arm"); SetLine("LowerArm2", "Right Arm", "Right Arm")
            SetLine("UpperLeg1", "Torso", "Left Leg"); SetLine("LowerLeg1", "Left Leg", "Left Leg")
            SetLine("UpperLeg2", "Torso", "Right Leg"); SetLine("LowerLeg2", "Right Leg", "Right Leg")
        end
    else
        for k, v in pairs(d) do if string_find(k, "Arm") or string_find(k, "Leg") or k == "Spine" or k == "Neck" then v.Visible = false end end
    end

    if Settings.ShowNames then d.NameText.Visible, d.NameText.Position, d.NameText.Text = true, Vector2_new(rootPos.X, y - 16), player.Name else d.NameText.Visible = false end
    if Settings.ShowHealth then
        local hp = math_clamp(hum.Health / hum.MaxHealth, 0, 1)
        d.HpBg.Visible, d.HpBg.Size, d.HpBg.Position = true, Vector2_new(4, h), Vector2_new(x - 6, y)
        d.HpFill.Visible, d.HpFill.Size, d.HpFill.Position, d.HpFill.Color = true, Vector2_new(2, h * hp), Vector2_new(x - 5, y + (h - (h * hp))), Color3_new(1 - hp, hp, 0)
    else d.HpBg.Visible, d.HpFill.Visible = false, false end
    if Settings.ShowDistance then d.DistText.Visible, d.DistText.Position, d.DistText.Text = true, Vector2_new(rootPos.X, y + h + 2), tostring(math_floor(rootPos.Z)) .. "m" else d.DistText.Visible = false end
end

Players.PlayerRemoving:Connect(function(player)
    if Drawings[player.Name] then for _, v in pairs(Drawings[player.Name]) do v:Remove() end Drawings[player.Name] = nil end
end)

local function IsPlayerVisible(targetChar)
    if not targetChar or not targetChar:FindFirstChild("Head") then return false end
    wallCheckParams.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
    local origin = Camera.CFrame.Position
    return workspace:Raycast(origin, targetChar.Head.Position - origin, wallCheckParams) == nil
end

local function GetClosestPlayer()
    local Target, MaxDist = nil, Settings.AutoShoot and math.huge or Settings.FOV
    local viewportCenter = Vector2_new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Settings.AimPart) then
            if Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            if not IsPlayerVisible(v.Character) then continue end
            local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(v.Character[Settings.AimPart].Position)
            local Dist = (Vector2_new(ScreenPoint.X, ScreenPoint.Y) - viewportCenter).Magnitude
            if OnScreen and Dist < MaxDist then MaxDist, Target = Dist, v end
        end
    end
    return Target
end

local function IsAimKeyPressed()
    if AimBindType == "Mouse" then return UserInputService:IsMouseButtonPressed(ActiveAimBind)
    else return UserInputService:IsKeyDown(ActiveAimBind) end
end

local function HandleAntiAFK(state)
    if getconnections then for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do if state then conn:Disable() else conn:Enable() end end end
end

-- Infinite Jump Mantığı
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- [[ CONFIG SİSTEMİ ]]
local ConfigFolder, ConfigFile = "CHRfYazilim", "CHRfYazilim/config.json"
local function SaveConfig()
    if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
    local saveSettings = {}
    for k, v in pairs(Settings) do
        if typeof(v) == "Color3" then saveSettings[k] = {R = v.R, G = v.G, B = v.B} else saveSettings[k] = v end
    end
    writefile(ConfigFile, HttpService:JSONEncode(saveSettings))
    Library:MakeNotification({Title = "Sistem", Content = "Ayarlar başarıyla kaydedildi.", Time = 3})
end
local function LoadConfig()
    if isfile(ConfigFile) then
        local data = HttpService:JSONDecode(readfile(ConfigFile))
        for k, v in pairs(data) do
            if typeof(v) == "table" and v.R then Settings[k] = Color3.new(v.R, v.G, v.B) else Settings[k] = v end
        end
        Library:MakeNotification({Title = "Sistem", Content = "Kayıtlı ayarlar yüklendi.", Time = 3})
    else Library:MakeNotification({Title = "Sistem", Content = "Kayıtlı ayar bulunamadı!", Time = 3}) end
end

-- [[ UI OLUŞTURMA ]]
local Window = Library:CreateWindow("CHRF YAZILIM | Universal Hub v4.0")

-- Combat Tab
local CombatTab = Window:CreateSection("Combat")
CombatTab:TextLabel("Aimbot Ayarları")
CombatTab:Toggle("Legit Aimbot", function(v) Settings.LegitAimbot = v; if v then Settings.RageAimbot = false end end, Settings.LegitAimbot, "Yumuşak ve belli etmeyen kilitlenme sağlar.")
CombatTab:Toggle("Rage Aimbot", function(v) Settings.RageAimbot = v; if v then Settings.LegitAimbot = false end end, Settings.RageAimbot, "Anında, milisaniyesinde hedefe kilitlenir.")
CombatTab:Toggle("Oto Sıkma (TriggerBot)", function(v) Settings.AutoShoot = v end, Settings.AutoShoot, "Hedef nişangaha girdiğinde otomatik ateş eder.")
CombatTab:Toggle("Takım Kontrolü", function(v) Settings.TeamCheck = v end, Settings.TeamCheck, "Takım arkadaşlarınıza kilitlenmeyi engeller.")
CombatTab:Dropdown("Aim Tuşu", {"Sağ Tık (Mouse 2)", "Sol Tık (Mouse 1)", "Q Tuşu", "E Tuşu", "C Tuşu", "Left Alt"}, function(v)
    if v == "Sağ Tık (Mouse 2)" then ActiveAimBind = Enum.UserInputType.MouseButton2; AimBindType = "Mouse"
    elseif v == "Sol Tık (Mouse 1)" then ActiveAimBind = Enum.UserInputType.MouseButton1; AimBindType = "Mouse"
    else ActiveAimBind = Enum.KeyCode[string.gsub(v, " Tuşu", "")]; AimBindType = "Key" end
end, "Sağ Tık (Mouse 2)", "Kilitlenmek için basılı tutacağınız tuş.")
CombatTab:Slider("Legit Smoothness", 1, 10, function(v) Settings.Smoothness = v end, Settings.Smoothness, "Sadece Legit Aimbot'ta çalışır. Kilitlenme hızını ayarlar.")
CombatTab:Slider("Aimbot FOV", 10, 800, function(v) Settings.FOV = v end, Settings.FOV, "Nişangah dairesinin büyüklüğünü belirler.")

CombatTab:TextLabel("FOV Özelleştirme")
CombatTab:Toggle("FOV Göster", function(v) Settings.ShowFOV = v end, Settings.ShowFOV, "Ekrandaki aimbot dairesini gösterir/gizler.")
CombatTab:ColorPicker("FOV Rengi", Settings.FOVColor, function(v) Settings.FOVColor = v end, "FOV dairesinin rengini ayarlar.")
CombatTab:Slider("FOV Kalınlığı", 1, 5, function(v) Settings.FOVThickness = v end, Settings.FOVThickness, "Daire çizgisinin kalınlığını ayarlar.")

CombatTab:TextLabel("Mermi & Hitbox (Rage)")
CombatTab:Toggle("Hitbox Büyütme", function(v) 
    Settings.Hitbox = v 
    if not v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end, Settings.Hitbox, "Düşmanların vurulma alanını devasa yapar. Havaya sıksanız bile isabet eder.")
CombatTab:Slider("Hitbox Boyutu", 5, 50, function(v) Settings.HitboxSize = v end, Settings.HitboxSize, "Büyütülecek alanın genişliğini seçin.")
CombatTab:Slider("Hitbox Görünürlüğü", 0, 10, function(v) Settings.HitboxTrans = v / 10 end, Settings.HitboxTrans * 10, "Büyütülen kutunun şeffaflığı (10 = Görünmez).")

CombatTab:TextLabel("Anti-Aim Ayarları")
CombatTab:Toggle("Mevlana (Spinbot)", function(v) Settings.Spinbot = v end, Settings.Spinbot, "Karakteriniz kendi etrafında fırıldak gibi döner.")
CombatTab:Slider("Spin Hızı", 10, 100, function(v) Settings.SpinSpeed = v end, Settings.SpinSpeed, "Dönüş hızını belirler.")

-- Visuals Tab
local VisualsTab = Window:CreateSection("Visuals")
VisualsTab:TextLabel("ESP Ana Ayar")
VisualsTab:Toggle("ESP Aktif", function(v) 
    Settings.ESP = v 
    if not v then for _, p in ipairs(Players:GetPlayers()) do RemoveESP(p) end end
end, Settings.ESP, "Duvar arkası görme özelliğini komple açar.")
VisualsTab:TextLabel("ESP Detayları")
VisualsTab:Toggle("Kutu (Box) ESP", function(v) Settings.ShowBox = v end, Settings.ShowBox, "Düşmanları karenin içine alır.")
VisualsTab:Toggle("Çizgi (Tracer) ESP", function(v) Settings.ShowTracer = v end, Settings.ShowTracer, "Ekranın altından düşmana çizgi çeker.")
VisualsTab:Toggle("İskeletler", function(v) Settings.ShowSkeleton = v end, Settings.ShowSkeleton, "Düşmanların iskelet hatlarını gösterir.")
VisualsTab:Toggle("Can Barı", function(v) Settings.ShowHealth = v end, Settings.ShowHealth, "Kalan canı bar halinde gösterir.")
VisualsTab:Toggle("İsimler", function(v) Settings.ShowNames = v end, Settings.ShowNames, "Oyuncu isimlerini gösterir.")

VisualsTab:TextLabel("ESP Renkleri")
VisualsTab:ColorPicker("Düşman Rengi (Duvar Arkası)", Settings.HighlightColor, function(v) Settings.HighlightColor = v end)
VisualsTab:ColorPicker("Düşman Rengi (Görünür)", Settings.VisibleColor, function(v) Settings.VisibleColor = v end)
VisualsTab:ColorPicker("İskelet Rengi", Settings.SkeletonColor, function(v) Settings.SkeletonColor = v end)

VisualsTab:TextLabel("Kamera Modu")
VisualsTab:Toggle("3. Şahıs (TP)", function(v) 
    Settings.ThirdPerson = v
    if not v then LocalPlayer.CameraMode, LocalPlayer.CameraMaxZoomDistance, LocalPlayer.CameraMinZoomDistance = Enum.CameraMode.Classic, 128, 0.5 end
end, Settings.ThirdPerson, "FPS oyunlarında zorla 3. şahıs bakış açısı verir.")
VisualsTab:Slider("TP Mesafesi", 5, 40, function(v) Settings.ThirdPersonDist = v end, Settings.ThirdPersonDist, "Kameranın ne kadar uzakta duracağını belirler.")

-- Movement Tab
local PlayerTab = Window:CreateSection("Movement")
PlayerTab:TextLabel("Hareket Geliştirmeleri")
PlayerTab:Toggle("Hızlı Koşma (WalkSpeed)", function(v) Settings.WalkSpeedOn = v end, Settings.WalkSpeedOn, "Karakterinizin koşma hızını manipüle eder.")
PlayerTab:Slider("Koşma Hızı", 16, 200, function(v) Settings.WalkSpeed = v end, Settings.WalkSpeed)

PlayerTab:Toggle("Yüksek Zıplama (JumpPower)", function(v) Settings.JumpPowerOn = v end, Settings.JumpPowerOn, "Zıplama yüksekliğinizi manipüle eder.")
PlayerTab:Slider("Zıplama Gücü", 50, 300, function(v) Settings.JumpPower = v end, Settings.JumpPower)

PlayerTab:Toggle("Sınırsız Zıplama (Inf Jump)", function(v) Settings.InfJump = v end, Settings.InfJump, "Havadayken boşluğa basarak sürekli yükselebilirsiniz.")

PlayerTab:TextLabel("Fizik & Uçuş")
PlayerTab:Toggle("Noclip (Duvar Geç)", function(v) Settings.Noclip = v end, Settings.Noclip, "Duvarların ve objelerin içinden geçmenizi sağlar.")
PlayerTab:Toggle("Uçuş (Fly)", function(v) Settings.Flying = v end, Settings.Flying, "Havada süzülmenizi sağlar. (WASD ile uçulur)")
PlayerTab:Slider("Uçuş Hızı", 10, 500, function(v) Settings.FlySpeed = v end, Settings.FlySpeed, "Fly açıkken uçma hızını belirler.")

-- Teleport Tab
local TeleportTab = Window:CreateSection("Teleport")
local SelectedPlayerTP = ""
local plrs = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(plrs, p.Name) end end

TeleportTab:TextLabel("Oyuncu İşlemleri")
TeleportTab:Dropdown("Oyuncu Seç", plrs, function(Value) SelectedPlayerTP = Value end, "", "Aşağıdaki işlemler için birini seç.")
TeleportTab:TextButton("Yanına Işınlan", "Git", function()
    if SelectedPlayerTP ~= "" then
        local target = Players:FindFirstChild(SelectedPlayerTP)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame_new(0, 0, 3)
            Library:MakeNotification({Title="Işınlanma", Content=SelectedPlayerTP.." adlı oyuncuya gidildi.", Time=2})
        end
    end
end, "Seçtiğiniz oyuncunun arkasına anında ışınlar.")

TeleportTab:TextButton("Oyuncuyu İzle (Spectate)", "İzle", function()
    if SelectedPlayerTP ~= "" then
        local target = Players:FindFirstChild(SelectedPlayerTP)
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = target.Character.Humanoid
            Library:MakeNotification({Title="Kamera", Content=SelectedPlayerTP.." izleniyor.", Time=2})
        end
    end
end, "Kameranızı seçtiğiniz oyuncuya bağlar.")

TeleportTab:TextButton("İzlemeyi Bırak", "Sıfırla", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
        Library:MakeNotification({Title="Kamera", Content="Kendi karakterinize dönüldü.", Time=2})
    end
end, "Kamerayı tekrar kendi karakterinize döndürür.")

-- Ayarlar (Settings) Tab
local ConfigTab = Window:CreateSection("Ayarlar")
ConfigTab:TextLabel("Hile Yapılandırması")
ConfigTab:TextButton("Ayarları Kaydet", "Kaydet", function() SaveConfig() end, "Mevcut olan tüm hile ayarlarınızı cihazınıza kaydeder.")
ConfigTab:TextButton("Ayarları Yükle", "Yükle", function() LoadConfig() end, "Önceden kaydettiğiniz ayarları geri yükler.")

ConfigTab:TextLabel("Arayüz Göstergeleri")
ConfigTab:Toggle("FPS & Ping Göstergesi", function(v) Settings.ShowWatermark = v; Library:SetWatermarkVisible(v) end, Settings.ShowWatermark, "Sağ üstteki bilgi penceresini açar/kapatır.")
ConfigTab:Toggle("Aktif Modlar Paneli", function(v) Settings.ShowActiveMods = v; Library:SetActiveModsVisible(v) end, Settings.ShowActiveMods, "Açık olan hileleri gösteren paneli açar/kapatır.")
ConfigTab:Toggle("Göstergeleri Taşı", function(v) Library.CanDragIndicators = v end, false, "Bunu açtığınızda ekrandaki göstergeleri farenizle istediğiniz yere sürükleyebilirsiniz.")

ConfigTab:TextLabel("Optimizasyon & Diğer")
ConfigTab:Toggle("Anti-AFK", function(v) Settings.AntiAFK = v; HandleAntiAFK(v) end, Settings.AntiAFK, "Oyunda hareketsiz kaldığınız için atılmanızı engeller.")
ConfigTab:TextButton("FPS Boost", "Temizle", function()
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9
    for _, v in ipairs(game:GetService("Lighting"):GetChildren()) do
        if v:IsA("BlurEffect") and v.Name ~= "CHRF_Blur" or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("Atmosphere") then v:Destroy() end
    end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        elseif v:IsA("Decal") or (v:IsA("Texture") and v.Name ~= "roblox") then v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Fire") or v:IsA("Smoke") then v:Destroy() end
    end
    Library:MakeNotification({Title="Sistem", Content="Gereksiz efektler silindi. FPS Arttırıldı.", Time=3})
end, "Oyundaki gereksiz detayları silerek performansı aşırı artırır.")

HandleAntiAFK(Settings.AntiAFK)
Library:MakeNotification({Title="CHRF YAZILIM", Content="Hile başarıyla oyuna inject edildi!", Time=4})

-- [[ ANA RENDER DÖNGÜSÜ ]]
RunService.RenderStepped:Connect(function()
    local viewportCenter = Vector2_new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    FOVCircle.Visible = Settings.ShowFOV
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Position = viewportCenter
    FOVCircle.Color = Settings.FOVColor
    FOVCircle.Thickness = Settings.FOVThickness

    if Settings.ThirdPerson then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = Settings.ThirdPersonDist
        LocalPlayer.CameraMaxZoomDistance = Settings.ThirdPersonDist
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if Settings.WalkSpeedOn then hum.WalkSpeed = Settings.WalkSpeed end
        if Settings.JumpPowerOn then hum.JumpPower = Settings.JumpPower end
    end

    if Settings.Hitbox then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if Settings.TeamCheck and p.Team == LocalPlayer.Team then continue end
                p.Character.HumanoidRootPart.Size = Vector3_new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = Settings.HitboxTrans
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end

    -- YENİLENEN AIMBOT MANTIĞI (Legit ve Rage Ayrımı)
    local aimTarget = nil
    if (Settings.LegitAimbot or Settings.RageAimbot) and (IsAimKeyPressed() or Settings.AutoShoot) then
        aimTarget = GetClosestPlayer()
        if aimTarget then
            local targetPos = aimTarget.Character[Settings.AimPart].Position
            if Settings.RageAimbot then
                -- Anında kilitlenme (Rage)
                Camera.CFrame = CFrame_new(Camera.CFrame.Position, targetPos)
            else
                -- Yumuşak kilitlenme (Legit)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame_new(Camera.CFrame.Position, targetPos), 1 / Settings.Smoothness)
            end
        end
    end

    if Settings.AutoShoot and aimTarget then
        if not isShooting then AutoShootPress(); isShooting = true end
    else
        if isShooting then AutoShootRelease(); isShooting = false end
    end

    if Settings.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if aimTarget then
            local lookVector = CFrame_new(hrp.Position, Vector3_new(aimTarget.Character[Settings.AimPart].Position.X, hrp.Position.Y, aimTarget.Character[Settings.AimPart].Position.Z))
            hrp.CFrame = lookVector
        else
            SpinAngle = SpinAngle + Settings.SpinSpeed
            if SpinAngle >= 360 then SpinAngle = 0 end
            hrp.CFrame = hrp.CFrame * CFrame_Angles(0, math_rad(Settings.SpinSpeed), 0)
        end
    end

    if Settings.ESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local highlight = p.Character:FindFirstChild("CHRF_Highlight") or Instance.new("Highlight", p.Character)
                highlight.Name = "CHRF_Highlight"
                highlight.Enabled = true
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                
                if Settings.TeamCheck and p.Team == LocalPlayer.Team then
                    highlight.FillColor = Settings.TeamColor
                    highlight.OutlineColor = Settings.TeamColor
                elseif IsPlayerVisible(p.Character) then
                    highlight.FillColor = Settings.VisibleColor
                    highlight.OutlineColor = Settings.VisibleColor
                else
                    highlight.FillColor = Settings.HighlightColor
                    highlight.OutlineColor = Settings.HighlightColor
                end
                
                if not Drawings[p.Name] then AddESP(p) end
                UpdateESP(p)
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("CHRF_Highlight") then
                p.Character.CHRF_Highlight.Enabled = false
            end
        end
    end

    if Settings.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if Settings.Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = Vector3_new(0,0,0)
        local camCF = Camera.CFrame
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3_new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3_new(0,1,0) end
        
        hrp.Velocity = moveDir * Settings.FlySpeed
        hrp.Anchored = (moveDir == Vector3_new(0,0,0))
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
end)
