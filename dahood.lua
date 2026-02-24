return function(Window, Library, Settings)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera

    local function AutoShootPress() if mouse1press then mouse1press() end end
    local function AutoShootRelease() if mouse1release then mouse1release() end end

    local KillConnection = nil
    local TargetPlayerName = ""

    local function StopKill()
        Settings.LoopKill = false
        Settings.RandomKillLoop = false
        
        if KillConnection then 
            KillConnection:Disconnect()
            KillConnection = nil 
        end
        
        local lpChar = LocalPlayer.Character
        if lpChar and lpChar:FindFirstChild("HumanoidRootPart") then
            lpChar.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            for _, part in ipairs(lpChar:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                    part.CanCollide = true 
                    if part.Name == "Head" and part:FindFirstChild("face") then part.Transparency = 0 else part.Transparency = 0 end
                end
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
            if Settings.LoopKill or Settings.RandomKillLoop then
                StopKill()
                Library:MakeNotification({Title="Sistem", Content="Katliam durduruldu (P Tuşu).", Time=2})
            end
        end
    end)

    local function ExecuteKill(targetPlayer, timeLimit)
        local lpChar = LocalPlayer.Character
        if not targetPlayer or not targetPlayer.Character or not lpChar then return end
        
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local lpRoot = lpChar:FindFirstChild("HumanoidRootPart")
        local lpHum = lpChar:FindFirstChild("Humanoid")
        
        if not targetRoot or not lpRoot or not lpHum then return end

        local oldPos = lpRoot.CFrame
        local startTime = tick()

        for _, part in ipairs(lpChar:GetDescendants()) do
            if part:IsA("BasePart") then 
                part.CanCollide = false 
                if part.Name ~= "HumanoidRootPart" then part.Transparency = 1 end
            end
        end

        local mainTool = lpChar:FindFirstChildOfClass("Tool")
        if not mainTool then
            local tools = LocalPlayer.Backpack:GetChildren()
            for _, t in ipairs(tools) do
                if t:IsA("Tool") then
                    mainTool = t
                    break 
                end
            end
        end

        if mainTool and mainTool.Parent == LocalPlayer.Backpack then
            lpHum:EquipTool(mainTool)
        end

        if KillConnection then KillConnection:Disconnect() end
        KillConnection = RunService.RenderStepped:Connect(function()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.Health > 0 and tick() - startTime < timeLimit then
                
                local tRoot = targetPlayer.Character.HumanoidRootPart
                local predictedPos = tRoot.Position + (tRoot.Velocity * 0.15) 
                
                lpRoot.CFrame = CFrame.new(predictedPos) * CFrame.new(0, 0, 1.5) 
                lpRoot.Velocity = tRoot.Velocity 

                if mainTool then
                    mainTool:Activate()
                else
                    AutoShootPress()
                    task.wait(0.01)
                    AutoShootRelease()
                end
                
            else
                KillConnection:Disconnect()
                KillConnection = nil
                
                if not Settings.RandomKillLoop then
                    lpRoot.CFrame = oldPos 
                    lpRoot.Velocity = Vector3.new(0, 0, 0)
                    for _, part in ipairs(lpChar:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                            part.CanCollide = true 
                            if part.Name == "Head" and part:FindFirstChild("face") then part.Transparency = 0 else part.Transparency = 0 end
                        end
                    end
                end
            end
        end)
    end

    local function GetClosestPlayerGlobal()
        local Target, MaxDist = nil, math.huge
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
        local lpPos = LocalPlayer.Character.HumanoidRootPart.Position
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                if Settings.TeamCheck and v.Team and LocalPlayer.Team and v.Team == LocalPlayer.Team then continue end
                local dist = (v.Character.HumanoidRootPart.Position - lpPos).Magnitude
                if dist < MaxDist then MaxDist = dist; Target = v end
            end
        end
        return Target
    end

    local function GetRandomPlayer()
        local pList = {}
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                if Settings.TeamCheck and v.Team and LocalPlayer.Team and v.Team == LocalPlayer.Team then continue end
                table.insert(pList, v)
            end
        end
        if #pList > 0 then
            return pList[math.random(1, #pList)]
        end
        return nil
    end

    -- YENİ DA HOOD SEKME OLUŞTURMA
    local DaHoodTab = Window:CreateSection("Da Hood")

    DaHoodTab:TextLabel("Invis-Kill (Görünmez Katliam)")

    local openKillSelector = Library:CreatePlayerSelector(function(playerName)
        TargetPlayerName = playerName
    end)

    DaHoodTab:TextButton("Hedef Belirle (Liste Aç)", "Seç", function()
        openKillSelector()
    end)

    DaHoodTab:TextButton("Hedef: En Yakın Düşmanı Seç", "Seç", function()
        local c = GetClosestPlayerGlobal()
        if c then
            TargetPlayerName = c.Name
            Library:MakeNotification({Title="Hedef Seçildi", Content=TargetPlayerName, Time=2})
        else
            Library:MakeNotification({Title="Hata", Content="Yakında kimse yok!", Time=2})
        end
    end)

    DaHoodTab:Toggle("Seçili Hedefi YOK ET", function(v) 
        Settings.LoopKill = v
        if v then
            Settings.RandomKillLoop = false 
            if TargetPlayerName ~= "" then
                local target = Players:FindFirstChild(TargetPlayerName)
                if target and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                    Library:MakeNotification({Title="Da Hood Sistemi", Content="Hedef yokediliyor! (P ile durdur)", Time=3})
                    ExecuteKill(target, 4) 
                else
                    Settings.LoopKill = false
                    Library:MakeNotification({Title="Hata", Content="Seçili oyuncu oyunda değil veya ölü!", Time=2})
                end
            else
                Settings.LoopKill = false
                Library:MakeNotification({Title="Hata", Content="Lütfen bir oyuncu seçin!", Time=2})
            end
        else
            StopKill()
        end
    end, Settings.LoopKill)

    DaHoodTab:TextLabel("Oto Sunucu Temizleyici")
    DaHoodTab:Toggle("Rastgele İnsanları Öldür", function(v) 
        Settings.RandomKillLoop = v
        if v then
            Settings.LoopKill = false 
            Library:MakeNotification({Title="Da Hood Sistemi", Content="Katliam Başladı! Durdurmak için P'ye bas.", Time=3})
            
            task.spawn(function()
                while Settings.RandomKillLoop do
                    local rndTarget = GetRandomPlayer()
                    if rndTarget then
                        ExecuteKill(rndTarget, 3.5) 
                        task.wait(3.7) 
                    else
                        task.wait(1) 
                    end
                end
            end)
            
        else
            StopKill()
        end
    end, Settings.RandomKillLoop)

    DaHoodTab:TextLabel("Durdurmak için klavyeden 'P' tuşuna basın.")
    DaHoodTab:TextLabel(" ")
    DaHoodTab:TextLabel(" ")
end
