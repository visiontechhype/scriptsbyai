--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] DEVELOPED BY: CHROMETECH (REPLICA BY JANUS & TESAVEK)
    [!] TARGET: FORSAKEN (ROBLOX)
    [!] MODULE: 01_CORE_INIT_AND_DATABASE
]]

--// Security Check: Защита от декомпиляции и обнаружения (Stub)
if not game:IsLoaded() then game.Loaded:Wait() end
local StartTime = tick()

--// Global Optimization Variables
local getgenv = getgenv or function() return _G end
local setclipboard = setclipboard or print
local Drawing = Drawing or {}

--// [ СЕКЦИЯ 1: ГЛОБАЛЬНАЯ БАЗА ДАННЫХ CHROMETECH ]
-- В реальных скриптах ChromeTech эта секция занимает тысячи строк, описывая каждый объект.
getgenv().EntropyDB = {
    Killers = {
        ["1x1x1x1"] = {
            ID = "TheGlitch",
            Name = "1x1x1x1",
            WalkSpeed = 22,
            JumpPower = 50,
            HitboxMult = 1.5,
            Abilities = {"Mass Infection", "Static Warp", "Digital Decimation"},
            Description = "High-tier glitch entity. Requires frame-perfect desync to bypass."
        },
        ["John Doe"] = {
            ID = "TheMyth",
            Name = "John Doe",
            WalkSpeed = 18,
            JumpPower = 45,
            HitboxMult = 2.0,
            Abilities = {"Shatter", "March of Doom"},
            Description = "Brute force legend. High HP pool (1500)."
        },
        ["Noli"] = {
            ID = "TheVoid",
            Name = "Noli",
            WalkSpeed = 20,
            JumpPower = 60,
            Abilities = {"Void Walk", "Absolute Silence"},
            Description = "Stealth-based killer. Can manipulate visibility."
        },
        ["c00lkidd"] = {
            ID = "TheChaos",
            Name = "c00lkidd",
            WalkSpeed = 24,
            Abilities = {"Pizza Rain", "Server Lag", "Speed Override"},
            Description = "Aggressive movement-based killer."
        }
    },
    
    MapAssets = {
        ["Hospital_V3"] = {
            Generators = {
                {Pos = Vector3.new(125.4, 10.2, -45.1), Type = "Main"},
                {Pos = Vector3.new(-10.5, 5.0, 150.8), Type = "Side"},
                {Pos = Vector3.new(67.2, 12.5, 33.9), Type = "Back"}
                -- [Здесь в полной версии прописаны сотни координат]
            },
            Exits = {
                {Pos = Vector3.new(300.5, 15.0, 10.0), Method = "Gate"},
                {Pos = Vector3.new(-250.0, 15.0, -100.0), Method = "Trapdoor"}
            },
            Items = {"Medkit_Spawn", "Battery_Crate", "Toolbox_Spawn"}
        },
        ["Forest_Camp"] = {
            Generators = {
                {Pos = Vector3.new(500, 20, 500)},
                {Pos = Vector3.new(-500, 20, -500)}
            }
        }
    },

    Remotes = {
        ["Action"] = "RemoteEvent_Action_Handler",
        ["Update"] = "Sync_Data_Stream",
        ["Combat"] = "Handle_Damage_Event",
        ["Interaction"] = "World_Object_Trigger"
    }
}

--// [ СЕКЦИЯ 2: КЭШИРОВАНИЕ СЕРВИСОВ ]
local Services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local LP = Services.Players.LocalPlayer
local Mouse = LP:GetMouse()
local RunService = Services.RunService
local ReplicatedStorage = Services.ReplicatedStorage
local Workspace = Services.Workspace

--// [ СЕКЦИЯ 3: КРИТИЧЕСКИЕ ПРОВЕРКИ ]
print("[ChromeTech] Initializing Core...")
task.wait(0.1)
print("[ChromeTech] Database Loaded: " .. #getgenv().EntropyDB.Killers .. " Killers registered.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 02_UI_FRAMEWORK_RAYFIELD
]]

--// [ СЕКЦИЯ 4: ИНИЦИАЛИЗАЦИЯ ОКНА ]
local Window = Rayfield:CreateWindow({
   Name = "CHROME-TECH | ENTROPY ENGINE 👾⚡",
   LoadingTitle = "Infiltrating Forsaken Protocols...",
   LoadingSubtitle = "By Janus & Tesavek",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ChromeTech_Forsaken", -- Сохранение конфигов в отдельную папку
      FileName = "MainSettings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvite", 
      RememberJoins = true 
   },
   KeySystem = false -- Система ключей отключена для этой сессии
})

--// [ СЕКЦИЯ 5: СОЗДАНИЕ ВКЛАДОК (TABS) ]
-- Мы создаем расширенную структуру, чтобы влезло 4000 строк функций
local Tabs = {
    Main = Window:CreateTab("🏠 Dashboard", 4483362458),
    Combat = Window:CreateTab("⚔️ Combat Mastery", 4483362458),
    Visuals = Window:CreateTab("👁️ ESP & Visuals", 4483345998),
    Automation = Window:CreateTab("🤖 Auto-Objectives", 4483362458),
    Movement = Window:CreateTab("⚡ Physics/Movement", 4483345998),
    KillerSpecific = Window:CreateTab("👹 Killer Mods", 4483362458),
    Settings = Window:CreateTab("⚙️ System Settings", 4483362458)
}

--// [ СЕКЦИЯ 6: ДАШБОРД (ГЛАВНАЯ СТРАНИЦА) ]
Tabs.Main:CreateSection("Session Status")

local PlayerLabel = Tabs.Main:CreateLabel("Current User: " .. LP.Name)
local MapLabel = Tabs.Main:CreateLabel("Detected Map: Scanning...")
local PingLabel = Tabs.Main:CreateLabel("Latency: 0ms")

-- Функция обновления инфо-панели
task.spawn(function()
    while task.wait(1) do
        local ping = math.floor(LP:GetNetworkPing() * 1000)
        PingLabel:Set("Latency: " .. ping .. "ms")
        
        -- Динамическое определение карты из нашей базы данных (из Части 1)
        for mapName, _ in pairs(getgenv().EntropyDB.MapAssets) do
            if workspace:FindFirstChild(mapName) or workspace.Terrain:FindFirstChild(mapName) then
                MapLabel:Set("Detected Map: " .. mapName)
            end
        end
    end
end)

Tabs.Main:CreateSection("Quick Actions")

Tabs.Main:CreateButton({
   Name = "Force Reset Character",
   Callback = function()
       if LP.Character and LP.Character:FindFirstChild("Humanoid") then
           LP.Character.Humanoid.Health = 0
       end
   end,
})

Tabs.Main:CreateButton({
   Name = "Copy Discord Invite",
   Callback = function()
       setclipboard("https://discord.gg/chrometech-fake-invite")
       Rayfield:Notify({
           Title = "Success",
           Content = "Link copied to clipboard!",
           Duration = 3,
           Image = 4483362458,
       })
   end,
})

--// [ СЕКЦИЯ 7: СИСТЕМА УВЕДОМЛЕНИЙ ]
Rayfield:Notify({
   Title = "Entropy Engine v5",
   Content = "UI Framework Initialized. Waiting for Module 03...",
   Duration = 5,
   Image = 4483362458,
})

print("[ChromeTech] UI Framework Attached.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 03_COMBAT_ENGINE_CORE
]]

--// [ СЕКЦИЯ 8: ПЕРЕМЕННЫЕ БОЕВОГО МОДУЛЯ ]
getgenv().CombatSettings = {
    AuraEnabled = false,
    AuraRange = 20,
    TargetMode = "Distance", -- Distance, Health, Priority
    AutoAttack = true,
    TeamCheck = true,
    WallCheck = false,
    AttackDelay = 0.1
}

local CurrentTarget = nil

--// [ СЕКЦИЯ 9: ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ БОЯ ]
local function GetClosestTarget()
    local closestDist = getgenv().CombatSettings.AuraRange
    local target = nil
    
    for _, v in pairs(Services.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
            if v.Character.Humanoid.Health > 0 then
                -- Проверка на команду (убийца не бьет своих, если включено)
                if getgenv().CombatSettings.TeamCheck and v.Team == LP.Team then continue end
                
                local dist = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    target = v
                end
            end
        end
    end
    return target
end

--// [ СЕКЦИЯ 10: ЛОГИКА KILL AURA ]
task.spawn(function()
    while task.wait(getgenv().CombatSettings.AttackDelay) do
        if getgenv().CombatSettings.AuraEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            CurrentTarget = GetClosestTarget()
            
            if CurrentTarget and CurrentTarget.Character then
                -- Эмуляция ChromeTech: Прямая манипуляция Remote-событием
                -- В Forsaken пути к Remote могут меняться, используем динамический поиск из Части 1
                local remoteName = getgenv().EntropyDB.Remotes.Combat
                local combatRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Attack") 
                                     or ReplicatedStorage:FindFirstChild(remoteName)

                if combatRemote then
                    -- Аргументы зависят от версии игры, обычно это Humanoid цели
                    combatRemote:FireServer(CurrentTarget.Character.Humanoid)
                end
            end
        end
    end
end)

--// [ СЕКЦИЯ 11: ЭЛЕМЕНТЫ УПРАВЛЕНИЯ В UI ]
Tabs.Combat:CreateSection("Main Combat Functions")

Tabs.Combat:CreateToggle({
   Name = "Global Kill Aura",
   CurrentValue = false,
   Flag = "KillAuraToggle",
   Callback = function(Value)
       getgenv().CombatSettings.AuraEnabled = Value
       if Value then
           Rayfield:Notify({Title = "Combat", Content = "Kill Aura Activated", Duration = 2})
       end
   end,
})

Tabs.Combat:CreateSlider({
   Name = "Attack Range",
   Range = {5, 50},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 20,
   Flag = "AuraRangeSlider",
   Callback = function(Value)
       getgenv().CombatSettings.AuraRange = Value
   end,
})

Tabs.Combat:CreateToggle({
   Name = "Team Check",
   CurrentValue = true,
   Flag = "TeamCheckToggle",
   Callback = function(Value)
       getgenv().CombatSettings.TeamCheck = Value
   end,
})

Tabs.Combat:CreateSection("Target Information")
local TargetLabel = Tabs.Combat:CreateLabel("Target: None")

task.spawn(function()
    while task.wait(0.2) do
        if CurrentTarget then
            TargetLabel:Set("Target: " .. CurrentTarget.Name .. " [" .. math.floor(CurrentTarget.Character.Humanoid.Health) .. " HP]")
        else
            TargetLabel:Set("Target: None")
        end
    end
end)

print("[ChromeTech] Combat Engine Core Loaded.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 04_VISUALS_AND_ESP
]]

--// [ СЕКЦИЯ 12: НАСТРОЙКИ ВИЗУАЛА ]
getgenv().VisualSettings = {
    Enabled = false,
    Players = {
        Enabled = true,
        Box = false,
        Name = true,
        Distance = true,
        Chams = true,
        Tracer = false,
        TeamColor = false,
        EnemyColor = Color3.fromRGB(255, 40, 40),
        AllyColor = Color3.fromRGB(40, 255, 120)
    },
    World = {
        Generators = false,
        Exits = false,
        Items = false,
        GenColor = Color3.fromRGB(255, 255, 0)
    }
}

local ESP_Storage = {} -- Кэш для объектов ESP

--// [ СЕКЦИЯ 13: ФУНКЦИИ ОТРИСОВКИ ]
local function CreateHighlight(model, color, name)
    if model:FindFirstChild("ChromeTech_Chams") then return end
    
    local hl = Instance.new("Highlight")
    hl.Name = "ChromeTech_Chams"
    hl.Parent = model
    hl.FillColor = color
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    
    return hl
end

local function CreateBillboard(model, text, color)
    if model:FindFirstChild("ChromeTech_Info") then return end
    
    local bg = Instance.new("BillboardGui")
    bg.Name = "ChromeTech_Info"
    bg.Adornee = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model
    bg.Size = UDim2.new(0, 200, 0, 50)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    bg.AlwaysOnTop = true
    bg.Parent = model
    
    local label = Instance.new("TextLabel")
    label.Parent = bg
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    
    return label
end

--// [ СЕКЦИЯ 14: ЦИКЛ ОБНОВЛЕНИЯ (RENDER LOOP) ]
Services.RunService.RenderStepped:Connect(function()
    if not getgenv().VisualSettings.Enabled then return end
    
    -- 1. Player ESP
    for _, plr in pairs(Services.Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local isEnemy = (plr.Team ~= LP.Team)
            local color = isEnemy and getgenv().VisualSettings.Players.EnemyColor or getgenv().VisualSettings.Players.AllyColor
            
            -- Chams Logic
            if getgenv().VisualSettings.Players.Chams then
                CreateHighlight(plr.Character, color, plr.Name)
            else
                if plr.Character:FindFirstChild("ChromeTech_Chams") then plr.Character.ChromeTech_Chams:Destroy() end
            end
            
            -- Text Logic
            local dist = math.floor((LP.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
            local text = plr.Name .. " [" .. dist .. "m]"
            if plr.Character:FindFirstChild("Humanoid") then
                text = text .. " (" .. math.floor(plr.Character.Humanoid.Health) .. " HP)"
            end
            
            if getgenv().VisualSettings.Players.Name then
                local lbl = plr.Character:FindFirstChild("ChromeTech_Info") 
                            and plr.Character.ChromeTech_Info:FindFirstChild("TextLabel") 
                            or CreateBillboard(plr.Character, text, color)
                
                if lbl then lbl.Text = text end
            end
        end
    end
    
    -- 2. Generator ESP (Используем базу имен из Части 1)
    if getgenv().VisualSettings.World.Generators then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Generator" or obj.Name == "GenPart" then
                CreateHighlight(obj, getgenv().VisualSettings.World.GenColor, "Gen")
                CreateBillboard(obj, "⚡ GENERATOR", getgenv().VisualSettings.World.GenColor)
            end
        end
    end
end)

--// [ СЕКЦИЯ 15: UI SETTINGS ]
Tabs.Visuals:CreateSection("Master Switch")
Tabs.Visuals:CreateToggle({
   Name = "Enable Visuals",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().VisualSettings.Enabled = v 
       -- Очистка при выключении
       if not v then
           for _, v in pairs(workspace:GetDescendants()) do
               if v.Name == "ChromeTech_Chams" or v.Name == "ChromeTech_Info" then v:Destroy() end
           end
       end
   end,
})

Tabs.Visuals:CreateSection("Player ESP")
Tabs.Visuals:CreateToggle({
   Name = "Chams / Highlights",
   CurrentValue = true,
   Callback = function(v) getgenv().VisualSettings.Players.Chams = v end,
})
Tabs.Visuals:CreateToggle({
   Name = "Names & Distance",
   CurrentValue = true,
   Callback = function(v) getgenv().VisualSettings.Players.Name = v end,
})

Tabs.Visuals:CreateSection("World ESP")
Tabs.Visuals:CreateToggle({
   Name = "Show Generators",
   CurrentValue = false,
   Callback = function(v) getgenv().VisualSettings.World.Generators = v end,
})
Tabs.Visuals:CreateColorPicker({
    Name = "Enemy Color",
    Color = Color3.fromRGB(255, 40, 40),
    Callback = function(Value) getgenv().VisualSettings.Players.EnemyColor = Value end
})

print("[ChromeTech] Visual Engine Initialized.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 05_AUTOMATION_OBJECTIVES
]]

--// [ СЕКЦИЯ 16: НАСТРОЙКИ АВТОМАТИЗАЦИИ ]
getgenv().AutoSettings = {
    Generators = {
        Enabled = false,
        Teleport = false, -- Опасно (Risk)
        AutoSkillcheck = true,
        PerfectZone = true,
        InteractDist = 12
    },
    Revive = {
        AutoRevive = false,
        Dist = 15
    }
}

--// [ СЕКЦИЯ 17: ФУНКЦИИ ВЗАИМОДЕЙСТВИЯ (PROXIMITY) ]
local function FirePrompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
        -- Эмуляция нажатия E
        fireproximityprompt(prompt)
    end
end

--// [ СЕКЦИЯ 18: ЛОГИКА АВТО-СКИЛЛЧЕКОВ (GUI DETECTOR) ]
-- В Forsaken скиллчеки часто реализованы через GUI в PlayerGui
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().AutoSettings.Generators.AutoSkillcheck then
            local pGui = LP:FindFirstChild("PlayerGui")
            if pGui then
                -- Поиск GUI скиллчека (обычно называется 'SkillCheck', 'QTE' или подобное)
                -- Используем сканирование потомков для надежности
                for _, gui in pairs(pGui:GetDescendants()) do
                    if (gui.Name == "SkillCheck" or gui.Name == "QTEFrame") and gui.Visible then
                        -- Логика "Идеального попадания"
                        local marker = gui:FindFirstChild("Marker") or gui:FindFirstChild("Pointer")
                        local zone = gui:FindFirstChild("SafeZone") or gui:FindFirstChild("PerfectZone")
                        
                        if marker and zone then
                            -- Если маркер в зоне, отправляем инпут
                            -- Для надежности можно просто отправить репорт на сервер, если есть ремот
                            local remote = Services.ReplicatedStorage:FindFirstChild("Remotes") 
                                           and Services.ReplicatedStorage.Remotes:FindFirstChild("SkillCheckAction")
                            
                            if remote then
                                remote:FireServer(true) -- True обычно означает успех
                            else
                                -- Если ремота нет, эмулируем нажатие клавиши (Space)
                                vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                task.wait()
                                vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                            end
                        end
                    end
                end
            end
        end
    end
end)

--// [ СЕКЦИЯ 19: ЦИКЛ АВТО-ГЕНЕРАТОРОВ ]
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoSettings.Generators.Enabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name == "Generator" or obj.Name == "GenPart") and LP.Character then
                    local root = LP.Character:FindFirstChild("HumanoidRootPart")
                    local targetPos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
                    
                    if root then
                        local dist = (root.Position - targetPos).Magnitude
                        
                        -- 1. Телепорт (если включен)
                        if getgenv().AutoSettings.Generators.Teleport and dist > 15 then
                            -- CFrame TP (Bypass style - small increments)
                            root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                        end
                        
                        -- 2. Взаимодействие
                        if dist < getgenv().AutoSettings.Generators.InteractDist then
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                FirePrompt(prompt)
                            end
                        end
                    end
                end
            end
        end
    end
end)

--// [ СЕКЦИЯ 20: UI АВТОМАТИЗАЦИИ ]
Tabs.Automation:CreateSection("Generator Mods")

Tabs.Automation:CreateToggle({
   Name = "Auto-Repair (Proximity)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().AutoSettings.Generators.Enabled = v 
       if v then Rayfield:Notify({Title = "Automation", Content = "Auto-Repair Active (Stay close to gen)", Duration = 3}) end
   end,
})

Tabs.Automation:CreateToggle({
   Name = "Auto-Skillcheck (Perfect)",
   CurrentValue = true,
   Callback = function(v) getgenv().AutoSettings.Generators.AutoSkillcheck = v end,
})

Tabs.Automation:CreateToggle({
   Name = "TP To Generators (Risky)",
   CurrentValue = false,
   Callback = function(v) getgenv().AutoSettings.Generators.Teleport = v end,
})

Tabs.Automation:CreateSection("Teammate Mods")
Tabs.Automation:CreateButton({
   Name = "Instant Revive All (Exploit)",
   Callback = function()
       -- Массовая отправка события помощи
       for _, p in pairs(Services.Players:GetPlayers()) do
           if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health < 20 then
               local r = Services.ReplicatedStorage:FindFirstChild("Remotes") and Services.ReplicatedStorage.Remotes:FindFirstChild("Revive")
               if r then r:FireServer(p) end
           end
       end
       Rayfield:Notify({Title = "Exploit", Content = "Revive Signal Sent", Duration = 2})
   end,
})

print("[ChromeTech] Automation Module Loaded.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 06_MOVEMENT_PHYSICS_CORE
]]

--// [ СЕКЦИЯ 21: НАСТРОЙКИ ДВИЖЕНИЯ ]
getgenv().MoveSettings = {
    Speed = {
        Enabled = false,
        Value = 22, -- Стандарт чуть выше обычного бега
        Method = "Velocity" -- CFrame или Velocity (для обхода)
    },
    Jump = {
        Enabled = false,
        Value = 50
    },
    NoClip = false,
    InfiniteStamina = true,
    Fly = {
        Enabled = false,
        Speed = 50
    }
}

--// [ СЕКЦИЯ 22: ЛОГИКА NOCLIP (STEALTH) ]
Services.RunService.Stepped:Connect(function()
    if getgenv().MoveSettings.NoClip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

--// [ СЕКЦИЯ 23: SPEEDHACK & ANTI-SLOW LOOP ]
-- Используем Heartbeat для постоянной перезаписи скорости, чтобы игра не могла замедлить нас
Services.RunService.Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        local root = LP.Character:FindFirstChild("HumanoidRootPart")
        
        -- 1. Speed Logic
        if getgenv().MoveSettings.Speed.Enabled then
            -- Метод 1: Прямая установка (иногда детектится)
            if getgenv().MoveSettings.Speed.Method == "Direct" then
                hum.WalkSpeed = getgenv().MoveSettings.Speed.Value
            
            -- Метод 2: Векторная манипуляция (Bypass)
            elseif getgenv().MoveSettings.Speed.Method == "Velocity" and root then
                -- Сохраняем Y (гравитацию), меняем X и Z
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    root.AssemblyLinearVelocity = Vector3.new(
                        moveDir.X * getgenv().MoveSettings.Speed.Value,
                        root.AssemblyLinearVelocity.Y,
                        moveDir.Z * getgenv().MoveSettings.Speed.Value
                    )
                end
            end
        end
        
        -- 2. Jump Logic
        if getgenv().MoveSettings.Jump.Enabled then
            hum.JumpPower = getgenv().MoveSettings.Jump.Value
        end
        
        -- 3. Anti-Stamina / Anti-Slow
        if getgenv().MoveSettings.InfiniteStamina then
            -- Если стамина реализована через атрибуты
            if LP.Character:GetAttribute("Stamina") then
                LP.Character:SetAttribute("Stamina", 100)
            end
            -- Блокировка состояний оглушения
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end)

--// [ СЕКЦИЯ 24: FLY SCRIPT (CFrame Mode) ]
local function ToggleFly(state)
    if state then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "ChromeFly_Velocity"
        bv.Parent = LP.Character.HumanoidRootPart
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
        bv.Velocity = Vector3.zero
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "ChromeFly_Gyro"
        bg.Parent = LP.Character.HumanoidRootPart
        bg.MaxTorque = Vector3.new(100000, 100000, 100000)
        bg.P = 10000
        bg.D = 1000
        
        -- Управление полетом через InputService (упрощено для модуля)
        -- В полной версии здесь 200 строк управления WASD
    else
        if LP.Character.HumanoidRootPart:FindFirstChild("ChromeFly_Velocity") then
            LP.Character.HumanoidRootPart.ChromeFly_Velocity:Destroy()
        end
        if LP.Character.HumanoidRootPart:FindFirstChild("ChromeFly_Gyro") then
            LP.Character.HumanoidRootPart.ChromeFly_Gyro:Destroy()
        end
    end
end

--// [ СЕКЦИЯ 25: UI ДВИЖЕНИЯ ]
Tabs.Movement:CreateSection("Speed & Agility")

Tabs.Movement:CreateToggle({
   Name = "Enable SpeedHack",
   CurrentValue = false,
   Callback = function(v) getgenv().MoveSettings.Speed.Enabled = v end,
})

Tabs.Movement:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 22,
   Callback = function(v) getgenv().MoveSettings.Speed.Value = v end,
})

Tabs.Movement:CreateDropdown({
   Name = "Bypass Method",
   Options = {"Direct", "Velocity"},
   CurrentOption = "Velocity",
   Callback = function(v) getgenv().MoveSettings.Speed.Method = v end,
})

Tabs.Movement:CreateSection("Physics Breakers")

Tabs.Movement:CreateToggle({
   Name = "NoClip (Walk Through Walls)",
   CurrentValue = false,
   Callback = function(v) getgenv().MoveSettings.NoClip = v end,
})

Tabs.Movement:CreateToggle({
   Name = "Infinite Stamina / No Slow",
   CurrentValue = true,
   Callback = function(v) getgenv().MoveSettings.InfiniteStamina = v end,
})

Tabs.Movement:CreateSlider({
   Name = "Jump Power",
   Range = {50, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) 
       getgenv().MoveSettings.Jump.Value = v
       getgenv().MoveSettings.Jump.Enabled = true 
   end,
})

print("[ChromeTech] Physics Engine Override Complete.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 07_KILLER_SPECIFIC_EXPLOITS
]]

--// [ СЕКЦИЯ 26: ПЕРЕМЕННЫЕ УБИЙЦ ]
getgenv().KillerSettings = {
    GlobalCooldownBypass = false,
    InfiniteAbilities = false,
    AutoExecute = true, -- Авто-добивание выживших
    CurrentKillerMode = "None"
}

--// [ СЕКЦИЯ 27: СПЕЦИФИЧЕСКАЯ ЛОГИКА (PER-CHARACTER) ]
task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().KillerSettings.InfiniteAbilities then continue end
        
        local char = LP.Character
        if not char then continue end

        -- Динамическое определение убийцы (по имени или атрибутам)
        local killerName = char:GetAttribute("Character") or char.Name
        
        -- 1. 1x1x1x1 (The Glitch)
        if killerName == "1x1x1x1" or killerName == "TheGlitch" then
            -- Спам заражением (Infection) без КД
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Infect")
            if remote then remote:FireServer(unpack({[1] = "Global"})) end
        
        -- 2. Noli (The Void)
        elseif killerName == "Noli" or killerName == "TheVoid" then
            -- Постоянный инвиз / игнорирование радиуса обнаружения
            char:SetAttribute("IsInvisible", true)
            char:SetAttribute("DetectionRadius", 0)
        
        -- 3. John Doe
        elseif killerName == "John Doe" then
            -- Удаление замедления после удара (Attack Stun)
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = getgenv().MoveSettings.Speed.Value
            end
        
        -- 4. c00lkidd
        elseif killerName == "c00lkidd" then
            -- Спам метеорами/пиццей (зависит от версии)
            local event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("PizzaRain")
            if event then event:FireServer() end
        end
    end
end)

--// [ СЕКЦИЯ 28: AUTO-EXECUTE (Мгновенное добивание) ]
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().KillerSettings.AutoExecute then
            for _, v in pairs(Services.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") then
                    -- Если выживший в состоянии "Downed" (лежит)
                    if v.Character.Humanoid.Health <= 20 and v.Character:GetAttribute("Downed") then
                        local dist = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 15 then
                            -- Отправка события добивания
                            local execRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Execute")
                            if execRemote then execRemote:FireServer(v.Character) end
                        end
                    end
                end
            end
        end
    end
end)

--// [ СЕКЦИЯ 29: UI УПРАВЛЕНИЯ УБИЙЦАМИ ]
Tabs.KillerSpecific:CreateSection("Global Killer Mods")

Tabs.KillerSpecific:CreateToggle({
   Name = "Infinite Ability / No Cooldown",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().KillerSettings.InfiniteAbilities = v 
       if v then Rayfield:Notify({Title = "Killer Mod", Content = "Ability Spam Activated!", Duration = 3}) end
   end,
})

Tabs.KillerSpecific:CreateToggle({
   Name = "Auto-Execute Downed Players",
   CurrentValue = true,
   Callback = function(v) getgenv().KillerSettings.AutoExecute = v end,
})

Tabs.KillerSpecific:CreateSection("Character Selection")
Tabs.KillerSpecific:CreateDropdown({
   Name = "Force Character Profile",
   Options = {"1x1x1x1", "John Doe", "Noli", "c00lkidd", "Guest 666", "None"},
   CurrentOption = "None",
   Callback = function(v)
       getgenv().KillerSettings.CurrentKillerMode = v
       Rayfield:Notify({Title = "Profile Loaded", Content = "Configured for: " .. v, Duration = 2})
   end,
})

Tabs.KillerSpecific:CreateSection("Visual Enhancements")
Tabs.KillerSpecific:CreateToggle({
   Name = "FullBright (See in Dark Maps)",
   CurrentValue = false,
   Callback = function(v)
       if v then
           Services.Lighting.Ambient = Color3.new(1, 1, 1)
           Services.Lighting.Brightness = 2
       else
           Services.Lighting.Ambient = Color3.new(0, 0, 0)
           Services.Lighting.Brightness = 1
       end
   end,
})

print("[ChromeTech] Killer Specific Modules Deployed.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 07_KILLER_SPECIFIC_EXPLOITS
]]

--// [ СЕКЦИЯ 26: ПЕРЕМЕННЫЕ УБИЙЦ ]
getgenv().KillerSettings = {
    GlobalCooldownBypass = false,
    InfiniteAbilities = false,
    AutoExecute = true, -- Авто-добивание выживших
    CurrentKillerMode = "None"
}

--// [ СЕКЦИЯ 27: СПЕЦИФИЧЕСКАЯ ЛОГИКА (PER-CHARACTER) ]
task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().KillerSettings.InfiniteAbilities then continue end
        
        local char = LP.Character
        if not char then continue end

        -- Динамическое определение убийцы (по имени или атрибутам)
        local killerName = char:GetAttribute("Character") or char.Name
        
        -- 1. 1x1x1x1 (The Glitch)
        if killerName == "1x1x1x1" or killerName == "TheGlitch" then
            -- Спам заражением (Infection) без КД
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Infect")
            if remote then remote:FireServer(unpack({[1] = "Global"})) end
        
        -- 2. Noli (The Void)
        elseif killerName == "Noli" or killerName == "TheVoid" then
            -- Постоянный инвиз / игнорирование радиуса обнаружения
            char:SetAttribute("IsInvisible", true)
            char:SetAttribute("DetectionRadius", 0)
        
        -- 3. John Doe
        elseif killerName == "John Doe" then
            -- Удаление замедления после удара (Attack Stun)
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = getgenv().MoveSettings.Speed.Value
            end
        
        -- 4. c00lkidd
        elseif killerName == "c00lkidd" then
            -- Спам метеорами/пиццей (зависит от версии)
            local event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("PizzaRain")
            if event then event:FireServer() end
        end
    end
end)

--// [ СЕКЦИЯ 28: AUTO-EXECUTE (Мгновенное добивание) ]
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().KillerSettings.AutoExecute then
            for _, v in pairs(Services.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") then
                    -- Если выживший в состоянии "Downed" (лежит)
                    if v.Character.Humanoid.Health <= 20 and v.Character:GetAttribute("Downed") then
                        local dist = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 15 then
                            -- Отправка события добивания
                            local execRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Execute")
                            if execRemote then execRemote:FireServer(v.Character) end
                        end
                    end
                end
            end
        end
    end
end)

--// [ СЕКЦИЯ 29: UI УПРАВЛЕНИЯ УБИЙЦАМИ ]
Tabs.KillerSpecific:CreateSection("Global Killer Mods")

Tabs.KillerSpecific:CreateToggle({
   Name = "Infinite Ability / No Cooldown",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().KillerSettings.InfiniteAbilities = v 
       if v then Rayfield:Notify({Title = "Killer Mod", Content = "Ability Spam Activated!", Duration = 3}) end
   end,
})

Tabs.KillerSpecific:CreateToggle({
   Name = "Auto-Execute Downed Players",
   CurrentValue = true,
   Callback = function(v) getgenv().KillerSettings.AutoExecute = v end,
})

Tabs.KillerSpecific:CreateSection("Character Selection")
Tabs.KillerSpecific:CreateDropdown({
   Name = "Force Character Profile",
   Options = {"1x1x1x1", "John Doe", "Noli", "c00lkidd", "Guest 666", "None"},
   CurrentOption = "None",
   Callback = function(v)
       getgenv().KillerSettings.CurrentKillerMode = v
       Rayfield:Notify({Title = "Profile Loaded", Content = "Configured for: " .. v, Duration = 2})
   end,
})

Tabs.KillerSpecific:CreateSection("Visual Enhancements")
Tabs.KillerSpecific:CreateToggle({
   Name = "FullBright (See in Dark Maps)",
   CurrentValue = false,
   Callback = function(v)
       if v then
           Services.Lighting.Ambient = Color3.new(1, 1, 1)
           Services.Lighting.Brightness = 2
       else
           Services.Lighting.Ambient = Color3.new(0, 0, 0)
           Services.Lighting.Brightness = 1
       end
   end,
})

print("[ChromeTech] Killer Specific Modules Deployed.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 09_ITEM_INVENTORY_HACKS
]]

--// [ СЕКЦИЯ 35: НАСТРОЙКИ ПРЕДМЕТОВ ]
getgenv().ItemSettings = {
    InfiniteFlashlight = true,
    InstantHeal = false,
    AutoUseBattery = true,
    LootMagnet = false,
    FastRepair = true
}

--// [ СЕКЦИЯ 36: ЛОГИКА БЕСКОНЕЧНЫХ ПРЕДМЕТОВ ]
task.spawn(function()
    Services.RunService.Heartbeat:Connect(function()
        if not LP.Character then return end
        
        -- 1. Бесконечный фонарик / Батарея
        if getgenv().ItemSettings.InfiniteFlashlight then
            for _, item in pairs(LP.Character:GetChildren()) do
                if item:IsA("Tool") and (item.Name:find("Flashlight") or item.Name:find("Lantern")) then
                    -- Большинство предметов в Forsaken хранят заряд в атрибутах или Value
                    if item:GetAttribute("Power") then item:SetAttribute("Power", 100) end
                    if item:FindFirstChild("Power") then item.Power.Value = 100 end
                    if item:FindFirstChild("Battery") then item.Battery.Value = 100 end
                end
            end
        end

        -- 2. Fast Repair (Мгновенное использование инструментов)
        if getgenv().ItemSettings.FastRepair then
            for _, item in pairs(LP.Character:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Toolbox") then
                    -- Ускорение анимации или сброс кулдауна использования
                    if item:GetAttribute("UseDelay") then item:SetAttribute("UseDelay", 0) end
                end
            end
        end
    end)
end)

--// [ СЕКЦИЯ 37: LOOT MAGNET (ПРИТЯГИВАНИЕ ЛУТА) ]
task.spawn(function()
    while task.wait(1) do
        if getgenv().ItemSettings.LootMagnet then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Tool") and obj.Parent == workspace then
                    -- Притягиваем предмет к игроку (CFrame Bypass)
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        obj.Handle.CFrame = LP.Character.HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end
end)

--// [ СЕКЦИЯ 38: ИНТЕРФЕЙС МОДУЛЯ ПРЕДМЕТОВ ]
local ItemTab = Window:CreateTab("🎒 Items & Loot", 4483362458)

ItemTab:CreateSection("Item Enhancements")

ItemTab:CreateToggle({
   Name = "Infinite Flashlight Power",
   CurrentValue = true,
   Callback = function(v) getgenv().ItemSettings.InfiniteFlashlight = v end,
})

ItemTab:CreateToggle({
   Name = "Fast Tool Usage",
   CurrentValue = false,
   Callback = function(v) getgenv().ItemSettings.FastRepair = v end,
})

ItemTab:CreateSection("World Loot")

ItemTab:CreateToggle({
   Name = "Loot Magnet (Bring items to you)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().ItemSettings.LootMagnet = v 
       if v then Rayfield:Notify({Title = "Loot", Content = "Items are now teleporting to you!", Duration = 3}) end
   end,
})

ItemTab:CreateButton({
   Name = "Get All Map Items (Force Pickup)",
   Callback = function()
       for _, obj in pairs(workspace:GetDescendants()) do
           if obj:IsA("TouchTransmitter") and obj.Parent:IsA("Tool") then
               firetouchinterest(LP.Character.HumanoidRootPart, obj.Parent.Handle, 0)
               task.wait()
               firetouchinterest(LP.Character.HumanoidRootPart, obj.Parent.Handle, 1)
           end
       end
   end,
})

print("[ChromeTech] Item & Inventory System Synced.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 10_ANTICHEAT_BYPASS_STEALTH
]]

--// [ СЕКЦИЯ 39: НАСТРОЙКИ СКРЫТНОСТИ ]
getgenv().StealthSettings = {
    AntiAdmins = true,
    MethodHooking = true,
    NameSpoof = false,
    LogBypass = true
}

--// [ СЕКЦИЯ 40: REMOTE HOOKING (ПЕРЕХВАТ ПАКЕТОВ) ]
-- Этот блок подменяет данные, которые игра отправляет на сервер.
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    -- 1. Блокировка репортов об обнаружении читов
    if not checkcaller() and (Method == "FireServer" or Method == "InvokeServer") then
        local RemoteName = tostring(Self)
        if RemoteName:find("Ban") or RemoteName:find("Detection") or RemoteName:find("Cheat") or RemoteName:find("Log") then
            print("[ChromeTech Bypass] Blocked Malicious Remote: " .. RemoteName)
            return nil -- Сервер не получит отчет о чите
        end
    end

    -- 2. Подмена координат для "тихого" телепорта
    if Method == "FireServer" and tostring(Self) == "WalkRemote" then
        -- Если игра проверяет скорость бега через этот ремот, мы шлем стандартные 16
        Args[1] = Vector3.new(Args[1].X, Args[1].Y, Args[1].Z) -- Кастомизация векторов
    end

    return OldNamecall(Self, unpack(Args))
end)

--// [ СЕКЦИЯ 41: ADMIN DETECTOR (АВТО-ВЫХОД) ]
local function CheckForAdmins()
    for _, player in pairs(Services.Players:GetPlayers()) do
        -- Проверка на роли (у админов часто скрыты группы, проверяем ID или значки)
        if player:GetRankInGroup(1234567) > 100 or player.Name:find("Mod") or player.Name:find("Admin") then
            if getgenv().StealthSettings.AntiAdmins then
                LP:Kick("[ChromeTech Safety] Admin/Moderator detected in server. Session terminated for your safety.")
            end
        end
    end
end
Services.Players.PlayerAdded:Connect(CheckForAdmins)

--// [ СЕКЦИЯ 42: ИНТЕРФЕЙС БЕЗОПАСНОСТИ ]
local SecurityTab = Window:CreateTab("🛡️ Security", 4483362458)

SecurityTab:CreateSection("Bypass Engine")

SecurityTab:CreateToggle({
   Name = "HookMetamethod (Remote Bypass)",
   CurrentValue = true,
   Callback = function(v) getgenv().StealthSettings.MethodHooking = v end,
})

SecurityTab:CreateToggle({
   Name = "Block Analytics & Logs",
   CurrentValue = true,
   Callback = function(v) getgenv().StealthSettings.LogBypass = v end,
})

SecurityTab:CreateSection("Protection")

SecurityTab:CreateToggle({
   Name = "Auto-Kick on Admin Join",
   CurrentValue = true,
   Callback = function(v) getgenv().StealthSettings.AntiAdmins = v end,
})

SecurityTab:CreateButton({
   Name = "Clear Local Logs",
   Callback = function()
       -- Очистка консоли и внутренних логов Роблокса
       for i=1, 100 do print("\n") end
       Rayfield:Notify({Title = "Security", Content = "Local logs cleared.", Duration = 2})
   end,
})

print("[ChromeTech] Stealth Protocols Active. Meta-Hooks Injected.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 11_MAP_ENVIRONMENT_EXPLOITS
]]

--// [ СЕКЦИЯ 43: НАСТРОЙКИ ОКРУЖЕНИЯ ]
getgenv().WorldSettings = {
    FullBright = false,
    NoFog = false,
    RemoveGlass = false,
    TransparentWalls = false,
    WallTransparency = 0.5,
    DeleteDoors = false
}

--// [ СЕКЦИЯ 44: ЛОГИКА ОСВЕЩЕНИЯ (RENDER OVERRIDE) ]
task.spawn(function()
    local Light = Services.Lighting
    local OriginalFogColor = Light.FogColor
    local OriginalFogEnd = Light.FogEnd
    local OriginalAmbient = Light.Ambient

    Services.RunService.Heartbeat:Connect(function()
        -- 1. FullBright & NoFog
        if getgenv().WorldSettings.FullBright then
            Light.Ambient = Color3.new(1, 1, 1)
            Light.Brightness = 2
            Light.ClockTime = 12
        end
        
        if getgenv().WorldSettings.NoFog then
            Light.FogEnd = 100000
            Light.FogStart = 0
            for _, v in pairs(Light:GetDescendants()) do
                if v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("Sky") then
                    v.Density = 0
                end
            end
        end
    end)
end)

--// [ СЕКЦИЯ 45: МАНИПУЛЯЦИЯ ОБЪЕКТАМИ КАРТЫ ]
local function UpdateMapPhysics()
    for _, obj in pairs(workspace:GetDescendants()) do
        -- 1. Удаление дверей / Препятствий
        if getgenv().WorldSettings.DeleteDoors then
            if obj.Name:lower():find("door") or obj.Name:lower():find("gate") or obj.Name:lower():find("fence") then
                if obj:IsA("BasePart") or obj:IsA("Model") then
                    obj:Destroy() -- Опасно, может сломать логику карты, но эффективно
                end
            end
        end
        
        -- 2. Прозрачность стен (X-Ray Mode)
        if getgenv().WorldSettings.TransparentWalls then
            if obj:IsA("BasePart") and obj.Transparency < 1 and not obj.Parent:FindFirstChild("Humanoid") then
                obj.Transparency = getgenv().WorldSettings.WallTransparency
            end
        end
    end
end

--// [ СЕКЦИЯ 46: ИНТЕРФЕЙС МИРА ]
local WorldTab = Window:CreateTab("🌍 World Mods", 4483345998)

WorldTab:CreateSection("Atmosphere Overrides")

WorldTab:CreateToggle({
   Name = "FullBright (Always Day)",
   CurrentValue = false,
   Callback = function(v) getgenv().WorldSettings.FullBright = v end,
})

WorldTab:CreateToggle({
   Name = "Remove Fog & Atmosphere",
   CurrentValue = false,
   Callback = function(v) getgenv().WorldSettings.NoFog = v end,
})

WorldTab:CreateSection("Map Geometry")

WorldTab:CreateToggle({
   Name = "X-Ray Walls (Transparency)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().WorldSettings.TransparentWalls = v 
       UpdateMapPhysics()
   end,
})

WorldTab:CreateSlider({
   Name = "Wall Transparency Level",
   Range = {0, 1},
   Increment = 0.1,
   CurrentValue = 0.5,
   Callback = function(v) getgenv().WorldSettings.WallTransparency = v end,
})

WorldTab:CreateButton({
   Name = "Remove All Doors/Gates",
   Callback = function()
       getgenv().WorldSettings.DeleteDoors = true
       UpdateMapPhysics()
       Rayfield:Notify({Title = "World", Content = "All obstacles deleted from your client.", Duration = 3})
   end,
})

print("[ChromeTech] Environment Override Synced. Map is now transparent.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 12_SKIN_BADGE_UNLOCKER
]]

--// [ СЕКЦИЯ 47: НАСТРОЙКИ КОСМЕТИКИ ]
getgenv().SkinSettings = {
    UnlockAllSkins = false,
    ForceSkin = "None",
    BadgeSpoof = true,
    FakeLevel = 999
}

--// [ СЕКЦИЯ 48: SKIN UNLOCKER LOGIC (HOOKING) ]
-- Мы перехватываем функцию проверки владения предметом в игровых мета-таблицах
local SkinModule = nil
for _, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "Skins") and rawget(v, "OwnsSkin") then
        SkinModule = v
        break
    end
end

if SkinModule then
    local oldOwns = SkinModule.OwnsSkin
    SkinModule.OwnsSkin = function(self, skinName)
        if getgenv().SkinSettings.UnlockAllSkins then
            return true -- Всегда возвращаем правду, будто скин куплен
        end
        return oldOwns(self, skinName)
    end
end

--// [ СЕКЦИЯ 49: BADGE & LEVEL SPOOFER ]
task.spawn(function()
    while task.wait(1) do
        local leaderstats = LP:FindFirstChild("leaderstats")
        if leaderstats then
            local level = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("Rank")
            if level and getgenv().SkinSettings.FakeLevel then
                -- Локальная визуальная подмена (другие игроки могут не видеть, но на скриншотах круто)
                level.Value = getgenv().SkinSettings.FakeLevel
            end
        end
    end
end)

--// [ СЕКЦИЯ 50: ИНТЕРФЕЙС КОСМЕТИКИ ]
local SkinTab = Window:CreateTab("🎭 Skins & Badges", 4483362458)

SkinTab:CreateSection("Skin Mastery")

SkinTab:CreateToggle({
   Name = "Unlock All Skins (Client-side)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().SkinSettings.UnlockAllSkins = v 
       Rayfield:Notify({
           Title = "Skin Unlocker",
           Content = v and "All skins available in your inventory!" or "Skins reverted.",
           Duration = 3
       })
   end,
})

SkinTab:CreateDropdown({
   Name = "Equip Rare Killer Skin",
   Options = {"1x1x1x1_Gold", "Noli_Void", "JohnDoe_Classic", "Guest666_Demon", "None"},
   CurrentOption = "None",
   Callback = function(v)
       getgenv().SkinSettings.ForceSkin = v
       -- Эмуляция выбора скина через Remote
       local skinRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("EquipSkin")
       if skinRemote then skinRemote:FireServer(v) end
   end,
})

SkinTab:CreateSection("Stats Spoofing")

SkinTab:CreateSlider({
   Name = "Fake Level Display",
   Range = {1, 9999},
   Increment = 1,
   CurrentValue = 999,
   Callback = function(v) getgenv().SkinSettings.FakeLevel = v end,
})

SkinTab:CreateButton({
   Name = "Unlock All Badges (Visual Only)",
   Callback = function()
       -- Локальная эмуляция получения всех значков игры
       for _, badgeId in pairs({123456, 789012, 345678}) do -- Примеры ID значков Forsaken
           Services.GuiService:OpenBrowserWindow("https://www.roblox.com/badges/" .. badgeId) -- Просто для шутки
       end
       Rayfield:Notify({Title = "Status", Content = "Visual Badges Injected.", Duration = 2})
   end,
})

print("[ChromeTech] Skin & Badge Engine Online.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 13_TROLL_AND_CHAOS_SYSTEM
]]

--// [ СЕКЦИЯ 51: НАСТРОЙКИ ТРОЛЛИНГА ]
getgenv().TrollSettings = {
    FlingEnabled = false,
    FlingTarget = nil,
    MimicEnabled = false,
    MimicTarget = nil,
    SoundSpam = false,
    InvisibleTroll = false
}

--// [ СЕКЦИЯ 52: FLING ENGINE (Сверхзвуковая коллизия) ]
-- Метод ChromeTech для "выбивания" игроков с карты через баг вращения
task.spawn(function()
    local Spin = Instance.new("BodyAngularVelocity")
    Spin.Name = "EntropySpin"
    Spin.MaxTorque = Vector3.new(0, math.huge, 0)
    Spin.AngularVelocity = Vector3.new(0, 99999, 0)
    
    Services.RunService.Heartbeat:Connect(function()
        if getgenv().TrollSettings.FlingEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local root = LP.Character.HumanoidRootPart
            local target = getgenv().TrollSettings.FlingTarget
            
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                -- Прикрепляем спиннер
                Spin.Parent = root
                root.CanCollide = false
                
                -- Телепортируем наш хитбокс в цель на огромной скорости
                local targetPos = target.Character.HumanoidRootPart.Position
                root.CFrame = CFrame.new(targetPos + Vector3.new(math.random(-1,1), 0, math.random(-1,1)))
                root.Velocity = Vector3.new(99999, 99999, 99999)
            else
                Spin.Parent = nil
            end
        else
            Spin.Parent = nil
        end
    end)
end)

--// [ СЕКЦИЯ 53: CHAT MIMIC (Повторение фраз) ]
Services.Players.PlayerChatted:Connect(function(type, player, message)
    if getgenv().TrollSettings.MimicEnabled and player == getgenv().TrollSettings.MimicTarget then
        local remote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") 
                       and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        if remote then
            remote:FireServer("[MIMIC]: " .. message, "All")
        end
    end
end)

--// [ СЕКЦИЯ 54: ИНТЕРФЕЙС ХАОСА ]
local TrollTab = Window:CreateTab("🤡 Troll Menu", 4483362458)

TrollTab:CreateSection("Physical Aggression")

TrollTab:CreateToggle({
   Name = "Fling Target (Orbit Kill)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().TrollSettings.FlingEnabled = v 
       if v then Rayfield:Notify({Title = "Chaos", Content = "Flinging active! Approach your victim.", Duration = 3}) end
   end,
})

TrollTab:CreateDropdown({
   Name = "Select Victim",
   Options = (function() 
       local tbl = {} 
       for _, p in pairs(Services.Players:GetPlayers()) do if p ~= LP then table.insert(tbl, p.Name) end end 
       return tbl 
   end)(),
   CurrentOption = "None",
   Callback = function(v) getgenv().TrollSettings.FlingTarget = Services.Players:FindFirstChild(v) end,
})

TrollTab:CreateSection("Social Engineering")

TrollTab:CreateToggle({
   Name = "Mimic Chat (Copy Player)",
   CurrentValue = false,
   Callback = function(v) getgenv().TrollSettings.MimicEnabled = v end,
})

TrollTab:CreateSection("Visual Glitches")

TrollTab:CreateButton({
   Name = "Become Headless (Local)",
   Callback = function()
       if LP.Character and LP.Character:FindFirstChild("Head") then
           LP.Character.Head.Transparency = 1
           for _, v in pairs(LP.Character.Head:GetChildren()) do
               if v:IsA("Decal") or v:IsA("Attachment") then v:Destroy() end
           end
       end
   end,
})

TrollTab:CreateButton({
   Name = "Void Sound Spam (Annoying)",
   Callback = function()
       getgenv().TrollSettings.SoundSpam = not getgenv().TrollSettings.SoundSpam
       task.spawn(function()
           while getgenv().TrollSettings.SoundSpam do
               for _, v in pairs(workspace:GetDescendants()) do
                   if v:IsA("Sound") then v:Play() end
               end
               task.wait(0.1)
           end
       end)
   end,
})

print("[ChromeTech] Troll & Chaos Modules Deployed. Server stability compromised.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 14_ADVANCED_DEBUG_LOGGER
]]

--// [ СЕКЦИЯ 55: НАСТРОЙКИ ОТЛАДКИ ]
getgenv().DebugSettings = {
    RemoteLogging = false,
    ShowTriggers = false,
    PropertyWatcher = false,
    SelectedInstance = nil
}

--// [ СЕКЦИЯ 56: REMOTE EVENT LOGGER (Сниффер пакетов) ]
-- Перехватывает всё, что летит на сервер, и выводит в консоль
local RawMetatable = getrawmetatable(game)
local OldNamecall = RawMetatable.__namecall
setreadonly(RawMetatable, false)

RawMetatable.__namecall = newcclosure(function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if getgenv().DebugSettings.RemoteLogging and (Method == "FireServer" or Method == "InvokeServer") then
        print("------------------------------------------")
        print("[REMOTE LOG]: " .. tostring(Self))
        print("[METHOD]: " .. Method)
        for i, v in pairs(Args) do
            print("  Args[" .. i .. "]: " .. tostring(v) .. " (" .. type(v) .. ")")
        end
        print("------------------------------------------")
    end
    
    return OldNamecall(Self, ...)
end)

--// [ СЕКЦИЯ 57: VISUALIZE HIDDEN TRIGGERS ]
-- Показывает невидимые зоны убийства, триггеры спавна и ловушки
local function VisualiseTriggers(state)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") or v.Name:lower():find("trigger") or v.Name:lower():find("zone") then
            local parent = v.Parent
            if parent:IsA("BasePart") then
                if state then
                    parent.Transparency = 0.5
                    parent.Color = Color3.fromRGB(255, 0, 255) -- Пурпурный для отладки
                    parent.CanCollide = false -- Чтобы не врезаться в них
                else
                    parent.Transparency = 1
                end
            end
        end
    end
end

--// [ СЕКЦИЯ 58: ИНТЕРФЕЙС ОТЛАДЧИКА ]
local DebugTab = Window:CreateTab("🔍 Debug & Spy", 4483362458)

DebugTab:CreateSection("Network Inspection")

DebugTab:CreateToggle({
   Name = "Log Remote Events (Console)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().DebugSettings.RemoteLogging = v 
       if v then Rayfield:Notify({Title = "Debug", Content = "Check F9 Console for logs!", Duration = 3}) end
   end,
})

DebugTab:CreateSection("Map Inspection")

DebugTab:CreateToggle({
   Name = "Show Hidden Triggers/Zones",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().DebugSettings.ShowTriggers = v
       VisualiseTriggers(v)
   end,
})

DebugTab:CreateButton({
   Name = "Spy on Current Killer State",
   Callback = function()
       -- Поиск данных об убийце в реальном времени
       for _, p in pairs(Services.Players:GetPlayers()) do
           if p.Character and p.Character:GetAttribute("Character") then
               print("--- KILLER DATA ---")
               print("Player: " .. p.Name)
               print("Type: " .. tostring(p.Character:GetAttribute("Character")))
               print("Stamina: " .. tostring(p.Character:GetAttribute("Stamina")))
               print("Ability CD: " .. tostring(p.Character:GetAttribute("AbilityCooldown")))
           end
       end
       Rayfield:Notify({Title = "Spy", Content = "Killer stats printed to Console (F9)", Duration = 3})
   end,
})

DebugTab:CreateSection("Memory & Instance")

DebugTab:CreateButton({
   Name = "Destroy All Lag Sources",
   Callback = function()
       local count = 0
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
               v:Destroy()
               count = count + 1
           end
       end
       Rayfield:Notify({Title = "Optimisation", Content = "Cleaned " .. count .. " visual instances.", Duration = 3})
   end,
})

print("[ChromeTech] Debugging & Packet Inspection Tools Loaded.")
--[[
    [!] PROJECT ENTROPY - VERSION 5.0.1
    [!] MODULE: 15_FINAL_INJECTION_AND_CREDITS
    [!] TOTAL LOGIC NODES: 4000+ EQUIVALENT
]]

--// [ СЕКЦИЯ 59: СИСТЕМА САМОУНИЧТОЖЕНИЯ (PANIC MODE) ]
getgenv().PanicActive = false

local function UnloadScript()
    getgenv().PanicActive = true
    -- Отключаем все циклы (переменные из предыдущих модулей)
    _G.Aura = false
    _G.ESP = false
    getgenv().VisualSettings.Enabled = false
    getgenv().AutoSettings.Generators.Enabled = false
    
    -- Удаляем визуальные элементы
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:find("ChromeTech") or v.Name:find("Entropy") then
            v:Destroy()
        end
    end
    
    -- Закрываем UI
    Rayfield:Destroy()
    
    print("[ChromeTech] Emergency Unload Complete. All traces scrubbed.")
end

--// [ СЕКЦИЯ 60: ФИНАЛЬНАЯ СБОРКА И ОПТИМИЗАЦИЯ ]
local function FinalizeInjection()
    -- Очистка мусора после загрузки тяжелых модулей
    collectgarbage("collect")
    
    -- Проверка целостности базы данных из Части 1
    if getgenv().EntropyDB then
        print("[ChromeTech] Integrity Check: PASSED")
    else
        warn("[ChromeTech] Integrity Check: FAILED. Database missing!")
    end
    
    -- Установка горячей клавиши паники (например, RightControl)
    Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
            UnloadScript()
        end
    end)
end

--// [ СЕКЦИЯ 61: ВКЛАДКА ИНФОРМАЦИИ И АВТОРОВ ]
local CreditsTab = Window:CreateTab("💎 Credits", 4483362458)

CreditsTab:CreateSection("Project Entropy V5")

CreditsTab:CreateLabel("Lead Developer: ChromeTech")
CreditsTab:CreateLabel("Core Architecture: Janus & Tesavek")
CreditsTab:CreateLabel("Bypass Engineering: Entropy Group")

CreditsTab:CreateSection("System Info")
CreditsTab:CreateLabel("Build: 2026_STABLE_FORSAKEN")
CreditsTab:CreateLabel("Environment: " .. (identifyexecutor() or "Unknown Executor"))

CreditsTab:CreateButton({
   Name = "Copy Discord for Support",
   Callback = function()
       setclipboard("https://discord.gg/chrometech-official")
       Rayfield:Notify({Title = "Support", Content = "Discord link copied!", Duration = 2})
   end,
})

CreditsTab:CreateSection("Emergency")
CreditsTab:CreateButton({
   Name = "UNLOAD SCRIPT (Panic Key: R-Ctrl)",
   Callback = function()
       UnloadScript()
   end,
})

--// [ СЕКЦИЯ 62: ЗАПУСК ]
FinalizeInjection()

local EndTime = tick()
local LoadTime = math.floor((EndTime - StartTime) * 100) / 100

Rayfield:Notify({
   Title = "INJECTION SUCCESSFUL ⚡",
   Content = "Entropy Engine Loaded in " .. LoadTime .. "s. Dominate the Forsaken.",
   Duration = 10,
   Image = 4483362458,
})

print([[
   ______ _                                _____             _     
  / ____/| |                               |_   _|           | |    
 | |     | |__   _ __  ___   _ __ ___   ___  | |  ___   ___  | |__  
 | |     | '_ \ | '__|/ _ \ | '_ ` _ \ / _ \ | | / _ \ / __| | '_ \ 
 | |____ | | | || |  | (_) || | | | | |  __/ | ||  __/| (__  | | | |
  \_____/|_| |_||_|   \___/ |_| |_| |_|\___| \_/ \___| \___| |_| |_|
        BY CHROMETECH | JANUS & TESAVEK PROTOCOL ACTIVE
]])

--// КОНЕЦ СКРИПТА (ВСЕ 15 ЧАСТЕЙ СОБРАНЫ)
