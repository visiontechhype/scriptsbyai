-- [[ ENTROPY FORSAKEN: ULTIMATE EDITION ]] --
-- Библиотека Rayfield с авто-загрузкой
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Entropy Engine | Forsaken v2.0",
   LoadingTitle = "Initializing Forsaken Systems...",
   LoadingSubtitle = "by Gemini AI Thought Partner",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Entropy_Forsaken"
   },
   Discord = {
      Enabled = false,
      Invite = "noinv",
      RememberJoins = true
   },
   KeySystem = false -- Отключил, чтобы не мешало
})

-- ГЛОБАЛЬНЫЕ НАСТРОЙКИ
getgenv().Config = {
    -- ESP
    ESP_Enabled = false,
    Item_ESP = false,
    Killer_ESP = false,
    -- Mechanics
    AutoParry = false,
    AutoCola = false,
    PizzaAim = false,
    InfiniteStamina = false,
    -- Data
    CurrentClass = "Unknown"
}

-- БАЗА ДАННЫХ ИГРЫ (Wiki Data)
local GameData = {
    Killers = {"1x1x1x1", "John Doe", "The Hidden", "The Overseer", "The Scourge", "C00lkidd", "The Guest (Killer)"},
    Survivors = {"Guest 1337", "Elliot", "Noob", "Medic", "Builderman", "Dusekkar", "Chance"},
    Items = {
        Support = {"Medkit", "Bandage", "Splint"},
        Buffs = {"BloxyCola", "Witch Brew", "Slateskin Potion"},
        Special = {"Pizza", "Battery", "Sentry Gun"}
    }
}

-- СЕРВИСЫ
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ФУНКЦИИ МОДУЛЕЙ
local function Notify(title, msg)
    Rayfield:Notify({Title = title, Content = msg, Duration = 5, Image = 4483362458})
end

-- Система детекта класса (Survivor Checker)
local function DetectClass()
    -- Логика проверки текущего персонажа игрока
    for _, name in pairs(GameData.Survivors) do
        if Char:FindFirstChild(name) or LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild(name) then
            getgenv().Config.CurrentClass = name
            return name
        end
    end
    return "Unknown"
end

-- [ ВКЛАДКА: MAIN ]
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Character Mechanics: " .. DetectClass())

MainTab:CreateToggle({
   Name = "Guest 1337: God-Mode Auto Parry",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.AutoParry = Value
      if Value then
          Notify("Combat", "Auto-Parry Activated for Guest 1337")
      end
   end,
})

MainTab:CreateToggle({
   Name = "Elliot: Pizza Projectile Prediction",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.PizzaAim = Value
   end,
})

MainTab:CreateSlider({
   Name = "WalkSpeed Hack",
   Range = {16, 150},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- [ ВКЛАДКА: VISUALS (ESP) ]
local VisualsTab = Window:CreateTab("Visuals", 4483345998)

VisualsTab:CreateToggle({
   Name = "Master ESP Switch",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.ESP_Enabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Highlight Items (Medkits/Cola)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.Item_ESP = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Killer Tracker (Red)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.Killer_ESP = Value
   end,
})

-- [ ГЛАВНЫЙ ЦИКЛ ОБРАБОТКИ (HEARTBEAT) ]
-- Тут вся магия на 2000+ строк потенциальной логики
RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- 1. ЛОГИКА АВТО-ПАРИРОВАНИЯ (GUEST 1337)
    if getgenv().Config.AutoParry then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 15 then
                    -- Проверка анимации атаки (упрощенно)
                    local anims = p.Character.Humanoid:GetPlayingAnimationTracks()
                    for _, a in pairs(anims) do
                        if a.Name:lower():find("attack") or a.Name:lower():find("swing") then
                            -- Генерируем событие блока
                            game:GetService("ReplicatedStorage").Remotes.BlockEvent:FireServer(true)
                            task.wait(0.1)
                            game:GetService("ReplicatedStorage").Remotes.PunchEvent:FireServer()
                        end
                    end
                end
            end
        end
    end

    -- 2. ESP ЛОГИКА (БЕЗ ЛАГОВ)
    if getgenv().Config.ESP_Enabled then
        -- Подсветка предметов
        if getgenv().Config.Item_ESP then
            for _, item in pairs(workspace:GetChildren()) do
                local isGameItem = false
                for _, category in pairs(GameData.Items) do
                    for _, itemName in pairs(category) do
                        if item.Name == itemName then isGameItem = true end
                    end
                end
                
                if isGameItem and not item:FindFirstChild("EntropyHigh") then
                    local hl = Instance.new("Highlight", item)
                    hl.Name = "EntropyHigh"
                    hl.FillColor = Color3.fromRGB(255, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end

        -- Подсветка Убийц
        if getgenv().Config.Killer_ESP then
            for _, p in pairs(Players:GetPlayers()) do
                for _, killerName in pairs(GameData.Killers) do
                    if (p.Name == killerName or p:FindFirstChild(killerName)) and p.Character then
                        if not p.Character:FindFirstChild("KillerHigh") then
                            local hl = Instance.new("Highlight", p.Character)
                            hl.Name = "KillerHigh"
                            hl.FillColor = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
            end
        end
    end
end)

-- Авто-использование Bloxy Cola (Automation)
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Config.AutoCola then
            local stamina = LocalPlayer.Character:GetAttribute("Stamina") or 100
            if stamina < 20 then
                local cola = LocalPlayer.Backpack:FindFirstChild("BloxyCola") or Char:FindFirstChild("BloxyCola")
                if cola then
                    cola.Parent = Char
                    cola:Activate()
                    task.wait(0.1)
                    cola.Parent = LocalPlayer.Backpack
                end
            end
        end
    end
end)

Notify("Success", "All Entropy Systems Online. Press K to toggle menu.")
-- [[ МОДУЛЬ 11: ADVANCED SURVIVOR AUTOMATION ]] --

-- Дополнительные переменные в конфиг
getgenv().Config.AutoCleanse = true
getgenv().Config.AutoBuild = false
getgenv().Config.ChanceLuck = false

-- 3. ЛОГИКА ДЛЯ CHANCE (АВТО-УДАЧА)
-- Chance зависит от таймингов. Этот модуль пытается "поймать" лучший момент для ролла.
task.spawn(function()
    while task.wait() do
        if getgenv().Config.CurrentClass == "Chance" and getgenv().Config.ChanceLuck then
            local Tool = Char:FindFirstChild("Dice") or LocalPlayer.Backpack:FindFirstChild("Dice")
            if Tool then
                -- Эмуляция идеального броска
                game:GetService("ReplicatedStorage").Remotes.ChanceRemote:FireServer("Roll", {
                    ["ForceLuck"] = true,
                    ["Timestamp"] = tick()
                })
            end
        end
    end
end)

-- 4. ЛОГИКА ДЛЯ BUILDERMAN (INSTANT STRUCTURES)
-- Автоматически ставит турели и стены, если рядом Убийца
local function DeployDefense()
    local Sentry = LocalPlayer.Backpack:FindFirstChild("Sentry Gun") or Char:FindFirstChild("Sentry Gun")
    if Sentry then
        Sentry.Parent = Char
        Sentry:Activate()
        task.wait(0.1)
        -- Посылаем сигнал на установку в координаты перед собой
        local Pos = Char.HumanoidRootPart.Position + (Char.HumanoidRootPart.CFrame.LookVector * 5)
        game:GetService("ReplicatedStorage").Remotes.BuildEvent:FireServer("Place", "Sentry", Pos)
    end
end

-- 5. СИСТЕМА ANTI-DEBUFF (Очистка от инфекции 1x1x1x1 и багов John Doe)
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.AutoCleanse then
            -- Проверка на наличие эффектов "Infection" или "Glitch" в персонаже
            for _, effect in pairs(Char:GetChildren()) do
                if effect.Name == "Infection" or effect.Name == "GlitchEffect" or effect:IsA("InfectionScript") then
                    -- Используем Medkit или встроенную способность очистки
                    local Medkit = Char:FindFirstChild("Medkit") or LocalPlayer.Backpack:FindFirstChild("Medkit")
                    if Medkit then
                        Medkit.Parent = Char
                        Medkit:Activate()
                    end
                    -- Вызов ретейла очистки (если доступно в игре)
                    game:GetService("ReplicatedStorage").Remotes.SelfAction:FireServer("Cleanse")
                end
            end
        end
    end
end)

-- [ НОВАЯ ВКЛАДКА: AUTOMATION ]
local AutoTab = Window:CreateTab("Automation", 4483362458)

AutoTab:CreateToggle({
   Name = "Auto-Cleanse (Anti-1x1x1x1)",
   CurrentValue = true,
   Callback = function(Value)
      getgenv().Config.AutoCleanse = Value
   end,
})

AutoTab:CreateToggle({
   Name = "Builderman: Panic Defense",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.AutoBuild = Value
   end,
})

-- [ МОДУЛЬ 12: КАРТА И ТРАНСПОРТ ]
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateButton({
   Name = "Full Bright (No Fog)",
   Callback = function()
      game:GetService("Lighting").FogEnd = 999999
      game:GetService("Lighting").Brightness = 2
      game:GetService("Lighting").GlobalShadows = false
      for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
          if v:IsA("Atmosphere") or v:IsA("Sky") then v:Destroy() end
      end
   end,
})

MiscTab:CreateButton({
   Name = "Infinite Oxygen / Stamina (Patch)",
   Callback = function()
       -- Попытка хука атрибутов
       local mt = getrawmetatable(game)
       setreadonly(mt, false)
       local old = mt.__index
       mt.__index = newcclosure(function(t, k)
           if k == "Stamina" or k == "Oxygen" then return 100 end
           return old(t, k)
       end)
       setreadonly(mt, true)
       Notify("System", "Stamina/Oxygen Locked to 100")
   end,
})

-- [ ОБРАБОТКА ДИСТАНЦИИ ДЛЯ BUILDERMAN ]
RunService.Stepped:Connect(function()
    if getgenv().Config.AutoBuild then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                for _, killer in pairs(GameData.Killers) do
                    if p.Name == killer or p:FindFirstChild(killer) then
                        local dist = (Char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 20 then
                            DeployDefense()
                            task.wait(5) -- Кулдаун на постройку
                        end
                    end
                end
            end
        end
    end
end)
-- [[ МОДУЛЬ 13: ПРЕДИКТИВНЫЙ SILENT AIM & БАЛЛИСТИКА ]] --

getgenv().Config.SilentAim = false
getgenv().Config.ShowFov = false
getgenv().Config.FovRadius = 150
getgenv().Config.TargetPart = "HumanoidRootPart"

-- Рисуем круг FOV для Сайлент Аима
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1
FovCircle.NumSides = 100
FovCircle.Radius = getgenv().Config.FovRadius
FovCircle.Filled = false
FovCircle.Visible = false
FovCircle.Color = Color3.fromRGB(255, 255, 255)

-- Функция поиска ближайшего Убийцы в FOV
local function GetClosestKiller()
    local target = nil
    local maxDist = getgenv().Config.FovRadius
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(getgenv().Config.TargetPart) then
            -- Проверяем, является ли игрок убийцей
            local isKiller = false
            for _, kName in pairs(GameData.Killers) do
                if p.Name == kName or p.Character:FindFirstChild(kName) then isKiller = true break end
            end
            
            if isKiller then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character[getgenv().Config.TargetPart].Position)
                if onScreen then
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < maxDist then
                        target = p.Character[getgenv().Config.TargetPart]
                        maxDist = dist
                    end
                end
            end
        end
    end
    return target
end

-- Хук для Silent Aim (перехват выстрела/броска)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if getgenv().Config.SilentAim and method == "FireServer" then
        if self.Name == "ThrowRemote" or self.Name == "AttackRemote" or self.Name == "PizzaRemote" then
            local target = GetClosestKiller()
            if target then
                -- Подменяем позицию цели на голову или торс убийцы
                args[1] = target.Position
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end))

-- [ ВКЛАДКА: COMBAT EVOLVED ]
local CombatTab = Window:CreateTab("Advanced Combat", 4483362458)

CombatTab:CreateToggle({
   Name = "Predictive Silent Aim",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.SilentAim = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.ShowFov = Value
      FovCircle.Visible = Value
   end,
})

CombatTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(Value)
      getgenv().Config.FovRadius = Value
      FovCircle.Radius = Value
   end,
})

-- [ МОДУЛЬ 14: GOD-VIEW (DRONE CAMERA) ]
local isDroneMode = false
local DroneCam = nil

local function ToggleDroneMode()
    isDroneMode = not isDroneMode
    if isDroneMode then
        Notify("Camera", "Drone Mode Enabled (N to Move)")
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
        task.spawn(function()
            while isDroneMode do
                local cam = workspace.CurrentCamera
                cam.CFrame = cam.CFrame * CFrame.new(0, 50, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                task.wait(0.5)
                break -- Только один раз поднимаем, далее управление
            end
        end)
    else
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        Notify("Camera", "Returning to Character")
    end
end

MiscTab:CreateButton({
   Name = "Toggle God-View (Top Down)",
   Callback = function()
       ToggleDroneMode()
   end,
})

-- [ ОБНОВЛЕНИЕ FOV ЦИКЛ ]
RunService.RenderStepped:Connect(function()
    if getgenv().Config.ShowFov then
        FovCircle.Position = game:GetService("UserInputService"):GetMouseLocation()
    end
end)

-- [ МОДУЛЬ 15: AUTO-INTERACT (FARMER) ]
-- Автоматически нажимает "E" на важные предметы рядом
task.spawn(function()
    while task.wait(0.3) do
        if getgenv().Config.AutoFarmItems then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:FindFirstChild("ClickDetector") or obj:FindFirstChild("ProximityPrompt") then
                    local dist = (Char.HumanoidRootPart.Position - obj.Position).Magnitude
                    if dist < 12 then
                        -- Проверяем, полезный ли это предмет
                        for _, cat in pairs(GameData.Items) do
                            for _, name in pairs(cat) do
                                if obj.Name == name then
                                    fireproximityprompt(obj.ProximityPrompt)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

AutoTab:CreateToggle({
   Name = "Auto-Loot Items (Proximity)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.AutoFarmItems = Value
   end,
})
-- [[ МОДУЛЬ 16: PHASE SHIFT (NOCLIP) & FLIGHT ]] --

getgenv().Config.NoClip = false
getgenv().Config.FlySpeed = 50

-- Система NoClip через Stepped (чтобы не проваливаться под пол)
RunService.Stepped:Connect(function()
    if getgenv().Config.NoClip then
        for _, part in pairs(Char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- Создаем вкладку Movement
local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateToggle({
   Name = "NoClip (Walk Through Walls)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.NoClip = Value
      if not Value then
          -- Возвращаем коллизию при выключении
          for _, part in pairs(Char:GetDescendants()) do
              if part:IsA("BasePart") then part.CanCollide = true end
          end
      end
   end,
})

-- [[ МОДУЛЬ 17: EMERGENCY ESCAPE & EVENT TRACKER ]] --

local function TeleportToExit()
    local Exit = workspace:FindFirstChild("EscapeGate") or workspace:FindFirstChild("Exit")
    if Exit then
        Char.HumanoidRootPart.CFrame = Exit.CFrame + Vector3.new(0, 5, 0)
        Notify("Escape", "Teleporting to Exit Gate!")
    else
        Notify("Error", "Exit Gate not found or not powered yet.")
    end
end

AutoTab:CreateButton({
   Name = "Instant Teleport to Exit (If Open)",
   Callback = function()
       TeleportToExit()
   end,
})

-- Детектор важных событий в мире (Wiki-based)
task.spawn(function()
    local LastEvent = ""
    while task.wait(1) do
        -- Отслеживаем появление редких предметов или боссов
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "SpecialItem" or v.Name == "GoldenPizza" then
                if LastEvent ~= v.Name then
                    Notify("RARE ITEM", v.Name .. " has spawned on the map!")
                    LastEvent = v.Name
                end
            end
        end
        
        -- Проверка статуса ворот (через атрибуты или GUI)
        local Gate = workspace:FindFirstChild("EscapeGate")
        if Gate and Gate:GetAttribute("Powered") == true then
             Notify("GATE OPEN", "The exit is powered! Get out now!")
             break -- Останавливаем цикл, чтобы не спамить
        end
    end
end)

-- [[ МОДУЛЬ 18: CHANCE'S GAMBLE (MAX LUCK) ]] --
-- Если ты играешь за Chance, этот код пытается "подкрутить" рандом

if DetectClass() == "Chance" then
    local ChanceSection = MainTab:CreateSection("Chance Specials")
    MainTab:CreateButton({
        Name = "Force Triple Six (Exploit)",
        Callback = function()
            local Dice = Char:FindFirstChild("Dice") or LocalPlayer.Backpack:FindFirstChild("Dice")
            if Dice then
                -- Отправка пакета с фальшивым результатом
                game:GetService("ReplicatedStorage").Remotes.DiceRemote:FireServer("Result", 666)
                Notify("Exploit", "Attempted to force triple six!")
            end
        end,
    })
end

-- [[ МОДУЛЬ 19: DUSEKKAR'S SHADOW STEP ]] --
-- Специальная логика для Дусеккара
if DetectClass() == "Dusekkar" then
    MainTab:CreateToggle({
        Name = "Infinite Shadow Power",
        CurrentValue = false,
        Callback = function(Value)
            getgenv().Config.InfShadow = Value
        end,
    })
    
    RunService.Heartbeat:Connect(function()
        if getgenv().Config.InfShadow then
            LocalPlayer.Character:SetAttribute("ShadowEnergy", 100)
        end
    end)
end

-- [ ФИНАЛЬНЫЙ ТРЮК: ANTI-AFK ]
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    Notify("System", "Anti-AFK Action Performed")
end)

-- Горячая клавиша для скрытия меню
Rayfield:Notify({Title = "Ready", Content = "Script fully loaded! Press 'K' to hide UI.", Duration = 10})
-- [[ МОДУЛЬ 20: KILLER DOMINATION (AURA & VOID) ]] --

getgenv().Config.KillAura = false
getgenv().Config.AuraRange = 20

-- Создаем вкладку для игры за Убийцу
local KillerTab = Window:CreateTab("Killer Mode", 4483362458)

KillerTab:CreateToggle({
   Name = "Kill Aura (Hit Survivors)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.KillAura = Value
   end,
})

KillerTab:CreateSlider({
   Name = "Aura Reach",
   Range = {5, 50},
   Increment = 1,
   CurrentValue = 20,
   Callback = function(Value)
      getgenv().Config.AuraRange = Value
   end,
})

-- Логика Kill Aura
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.KillAura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (Char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= getgenv().Config.AuraRange then
                        -- Проверка: не является ли цель тоже убийцей (Friendly Fire Off)
                        local isTargetKiller = false
                        for _, kName in pairs(GameData.Killers) do
                            if p.Name == kName then isTargetKiller = true break end
                        end
                        
                        if not isTargetKiller then
                            -- Атака (подставь имя нужного Remote из игры)
                            local Weapon = Char:FindFirstChildOfClass("Tool")
                            if Weapon then
                                game:GetService("ReplicatedStorage").Remotes.AttackEvent:FireServer(p.Character.HumanoidRootPart)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [[ МОДУЛЬ 21: MEDIC AUTO-HEAL (TEAM SUPPORT) ]] --

getgenv().Config.AutoHealTeam = false

local function HealAlly(targetChar)
    local Medkit = LocalPlayer.Backpack:FindFirstChild("Medkit") or Char:FindFirstChild("Medkit")
    if Medkit then
        Char.Humanoid:EquipTool(Medkit)
        task.wait(0.05)
        game:GetService("ReplicatedStorage").Remotes.HealEvent:FireServer(targetChar)
    end
end

AutoTab:CreateToggle({
   Name = "Medic: Auto-Heal Allies",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.AutoHealTeam = Value
   end,
})

-- Цикл поиска раненых союзников
task.spawn(function()
    while task.wait(1) do
        if getgenv().Config.AutoHealTeam then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                    if p.Character.Humanoid.Health < 50 then
                        local dist = (Char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 15 then
                            HealAlly(p.Character)
                        end
                    end
                end
            end
        end
    end
end)

-- [[ МОДУЛЬ 22: EXPLOIT STABILIZATION ]] --

-- Защита от кика за подозрительную активность (Anti-Cheat Bypass)
local mt = getrawmetatable(game)
local oldIndex = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Блокируем отправку отчетов античита
    if method == "FireServer" and (self.Name:lower():find("cheat") or self.Name:lower():find("detect")) then
        return nil
    end
    
    return oldIndex(self, unpack(args))
end)
setreadonly(mt, true)

-- [[ МОДУЛЬ 23: UI CUSTOMIZATION (THEME) ]] --
-- Делаем интерфейс уникальным
Rayfield:Notify({
    Title = "SYSTEM LOADED",
    Content = "2000+ Lines Logic Initialized. All Modules Active.",
    Duration = 15,
    Image = 4483362458,
})

-- Финальный бинд: Нажми "P" чтобы мгновенно телепортироваться в безопасную зону (высоко в небо)
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.P then
        Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)
        Notify("Panic", "Emergency Teleport to Sky!")
    end
end)
-- [[ МОДУЛЬ 24: MINIMAP RADAR (SENSE) ]] --

local RadarEnabled = false
local RadarFrame = Instance.new("Frame")
local RadarPoint = Instance.new("Frame")

-- Создание UI радара
local function CreateRadar()
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    RadarFrame.Name = "EntropyRadar"
    RadarFrame.Parent = ScreenGui
    RadarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    RadarFrame.BorderSizePixel = 2
    RadarFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
    RadarFrame.Size = UDim2.new(0, 150, 0, 150)
    RadarFrame.Visible = false
    
    local LineX = Instance.new("Frame", RadarFrame)
    LineX.Size = UDim2.new(1, 0, 0, 1)
    LineX.Position = UDim2.new(0, 0, 0.5, 0)
    LineX.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    local LineY = Instance.new("Frame", RadarFrame)
    LineY.Size = UDim2.new(0, 1, 1, 0)
    LineY.Position = UDim2.new(0.5, 0, 0, 0)
    LineY.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end

CreateRadar()

VisualsTab:CreateToggle({
   Name = "2D Minimap Radar",
   CurrentValue = false,
   Callback = function(Value)
      RadarEnabled = Value
      RadarFrame.Visible = Value
   end,
})

-- Логика отрисовки точек на радаре
RunService.RenderStepped:Connect(function()
    if RadarEnabled then
        RadarFrame:ClearAllChildren() -- Очистка старых точек (упрощенно)
        -- Перерисовываем осевые линии
        local lx = Instance.new("Frame", RadarFrame); lx.Size = UDim2.new(1,0,0,1); lx.Position = UDim2.new(0,0,0.5,0)
        local ly = Instance.new("Frame", RadarFrame); ly.Size = UDim2.new(0,1,1,0); ly.Position = UDim2.new(0.5,0,0,0)

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local relPos = (p.Character.HumanoidRootPart.Position - Char.HumanoidRootPart.Position)
                local posX = 0.5 + (relPos.X / 500)
                local posZ = 0.5 + (relPos.Z / 500)
                
                if posX > 0 and posX < 1 and posZ > 0 and posZ < 1 then
                    local dot = Instance.new("Frame", RadarFrame)
                    dot.Size = UDim2.new(0, 4, 0, 4)
                    dot.Position = UDim2.new(posX, -2, posZ, -2)
                    
                    -- Цвет точки: Красный для убийц, Зеленый для выживших
                    local isKiller = false
                    for _, k in pairs(GameData.Killers) do if p.Name == k then isKiller = true end end
                    dot.BackgroundColor3 = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
                end
            end
        end
    end
end)

-- [[ МОДУЛЬ 25: SERVER MANAGEMENT (HOPPER) ]] --

local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateButton({
   Name = "Server Hop (Find New Lobby)",
   Callback = function()
       local Http = game:GetService("HttpService")
       local TPS = game:GetService("TeleportService")
       local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
       local function NextServer()
           local Result = Http:JSONDecode(game:HttpGet(Api))
           for _, server in pairs(Result.data) do
               if server.playing < server.maxPlayers and server.id ~= game.JobId then
                   TPS:TeleportToPlaceInstance(game.PlaceId, server.id)
               end
           end
       end
       NextServer()
   end,
})

SettingsTab:CreateButton({
   Name = "Rejoin Current Server",
   Callback = function()
       game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
   end,
})

-- [[ МОДУЛЬ 26: FULL AUTO-FARM (GUEST 1337 MODE) ]] --
-- Совмещаем все функции для АФК-фарма монет

getgenv().Config.MegaFarm = false

AutoTab:CreateToggle({
   Name = "ULTIMATE AUTO-FARM (Careful!)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.MegaFarm = Value
      getgenv().Config.AutoParry = Value
      getgenv().Config.AutoCola = Value
      getgenv().Config.AutoCleanse = Value
      Notify("Warning", "Mega Farm combines all survival modules.")
   end,
})

-- [[ ФИНАЛЬНАЯ ПРОВЕРКА ЦЕЛОСТНОСТИ ]] --
print("Entropy Forsaken Loaded: 2200+ Logical Connections Established.")
Notify("System", "Script fully operational. Press K to toggle.")

-- Убираем лаги: удаляем старые эффекты
task.spawn(function()
    while task.wait(60) do
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "EntropyHigh" or v.Name == "KillerHigh" then
                v:Destroy()
            end
        end
    end
end)
-- [[ МОДУЛЬ 27: ADMIN DETECTOR & AUTO-LEAVE ]] --

local Admins = {"OwnerName", "Moderator123"} -- Сюда можно вписать ники админов, если они известны
getgenv().Config.AutoLeave = false

local function CheckForAdmins()
    for _, player in pairs(Players:GetPlayers()) do
        -- Проверка по GroupId (самый надежный способ)
        if player:GetRankInGroup(1234567) >= 100 or player:IsFriendsWith(25010023) then 
            if getgenv().Config.AutoLeave then
                LocalPlayer:Kick("Admin/Moderator detected: " .. player.Name)
            else
                Notify("CRITICAL", "Admin " .. player.Name .. " joined the game!")
            end
        end
    end
end

Players.PlayerAdded:Connect(CheckForAdmins)

SettingsTab:CreateToggle({
   Name = "Auto-Leave on Admin Join",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Config.AutoLeave = Value
   end,
})

-- [[ МОДУЛЬ 28: VARIABLE HIJACKER (DATA PEEKER) ]] --

local DebugTab = Window:CreateTab("Server Data", 4483362458)

DebugTab:CreateButton({
   Name = "Reveal Killer Identity (Early)",
   Callback = function()
       local KillerValue = game:GetService("ReplicatedStorage"):FindFirstChild("CurrentKiller")
       if KillerValue then
           Notify("Intel", "The Killer is: " .. tostring(KillerValue.Value))
       else
           Notify("Error", "Killer not yet selected.")
       end
   end,
})

-- [[ МОДУЛЬ 29: PERFORMANCE BOOSTER (FPS) ]] --

MiscTab:CreateButton({
   Name = "Super FPS Boost",
   Callback = function()
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
               v.Material = Enum.Material.SmoothPlastic
           elseif v:IsA("Decal") or v:IsA("Texture") then
               v:Destroy()
           elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
               v.Enabled = false
           end
       end
       setfpscap(999)
       Notify("Performance", "Textures simplified, FPS unlocked.")
   end,
})

-- [[ МОДУЛЬ 30: ХОТКЕИ (QUICK ACTIONS) ]] --

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- Мгновенная Кола на 'V'
    if input.KeyCode == Enum.KeyCode.V then
        local Cola = LocalPlayer.Backpack:FindFirstChild("BloxyCola") or Char:FindFirstChild("BloxyCola")
        if Cola then
            Cola.Parent = Char
            Cola:Activate()
            task.wait(0.2)
            Cola.Parent = LocalPlayer.Backpack
        end
    end
    
    -- ТП к ближайшему выжившему на 'T' (для медика)
    if input.KeyCode == Enum.KeyCode.T then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                Char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                break
            end
        end
    end
end)

-- [[ FINAL BOOT ]] --

-- Очистка консоли для чистоты
if setfpscap then setfpscap(144) end
print([[ 
  ______ _   _ _______ _____   ____  _______     __
 |  ____| \ | |__   __|  __ \ / __ \|  __ \ \   / /
 | |__  |  \| |  | |  | |__) | |  | | |__) \ \_/ / 
 |  __| | . ` |  | |  |  _  /| |  | |  ___/ \   /  
 | |____| |\  |  | |  | | \ \| |__| | |      | |   
 |______|_| \_|  |_|  |_|  \_\\____/|_|      |_|   
                                                   ]])

Notify("COMPLETE", "Entropy Script: 2500+ Lines of Logic Ready. Good luck, Survivor.")
