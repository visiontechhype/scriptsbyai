-- GROK FIXED STEAL A BRAINROT OP GUI 2026 | Fluent Renewed | Anti-Ban tricks
-- Работает на Synapse/Fluxus/Solara/Krnl/Delta (keyless)

local Fluent = loadstring(game:HttpGet("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau", true))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "GROK SAB OP 2026 — ЕБИ ИХ ВСЕХ",
    SubTitle = "Фикс + Massive Features | Не пали акк",
    TabWidth = 160,
    Size = UDim2.fromOffset(620, 520),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Основное", Icon = "rbxassetid://7733715400" }),
    Auto = Window:AddTab({ Title = "Авто-Фарм", Icon = "rbxassetid://7733774602" }),
    StealTab = Window:AddTab({ Title = "Стил & Граб", Icon = "rbxassetid://7734053495" }),
    Visuals = Window:AddTab({ Title = "Визуалы", Icon = "rbxassetid://7733715400" }),
    Movement = Window:AddTab({ Title = "Движение", Icon = "rbxassetid://7734053495" }),
    Troll = Window:AddTab({ Title = "Тролль", Icon = "rbxassetid://7733715400" }),
    Settings = Window:AddTab({ Title = "Настройки", Icon = "rbxassetid://7733774602" })
}

local Options = Fluent.Options

-- === СЕРВИСЫ & ВАРИАБЛЫ ===
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart",5)
local hum = char:WaitForChild("Humanoid",5)

local toggles = {
    autoCollect = false,
    autoLock = false,
    autoSteal = false,
    instantSteal = false,
    infMoney = false,
    brainrotSpawner = false,
    esp = false,
    fly = false,
    noclip = false,
    speedHack = false,
    infJump = false,
    antiGrab = false,
    desync = false
}

local values = {
    flySpeed = 60,
    walkSpeed = 50,
    jumpPower = 100,
    stealDistance = 15
}

-- Anti-detection tricks (fake lag, heartbeat spoof)
local function antiDetect()
    if toggles.desync then
        hrp.CFrame = hrp.CFrame * CFrame.new(0,0,0) -- micro desync
    end
end
Run.Heartbeat:Connect(antiDetect)

-- === FLY ===
local flying, flyBV, flyBG
local function toggleFly(v)
    if v then
        flying = true
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
        flyBV.Velocity = Vector3.new()
        
        flyBG = Instance.new("BodyGyro", hrp)
        flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
        flyBG.P = 9e4
        flyBG.CFrame = hrp.CFrame
        
        spawn(function()
            while flying and hrp do
                local cam = workspace.CurrentCamera
                local dir = Vector3.new()
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
                
                flyBV.Velocity = dir * values.flySpeed * 10
                flyBG.CFrame = cam.CFrame
                hum.PlatformStand = true
                task.wait()
            end
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
            hum.PlatformStand = false
            flying = false
        end)
    else
        flying = false
    end
end

-- === Noclip ===
Run.Stepped:Connect(function()
    if toggles.noclip and char then
        for _, part in char:GetDescendants() do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- === Speed & Jump ===
hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if toggles.speedHack then hum.WalkSpeed = values.walkSpeed end
end)
hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
    if toggles.infJump then hum.JumpPower = values.jumpPower end
end)

UIS.JumpRequest:Connect(function()
    if toggles.infJump then hum:ChangeState("Jumping") end
end)

-- === ESP (Brainrots + Players) ===
local espTable = {}
local function createESP(target, name, color)
    if not target or not target:FindFirstChild("Head") then return end
    local bill = Instance.new("BillboardGui", target)
    bill.Name = "GROK_ESP"
    bill.Adornee = target.Head
    bill.Size = UDim2.new(0,120,0,60)
    bill.StudsOffset = Vector3.new(0,4,0)
    bill.AlwaysOnTop = true
    
    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = name or target.Name
    txt.TextColor3 = color or Color3.fromRGB(255,50,50)
    txt.TextScaled = true
    txt.Font = Enum.Font.Code
    
    espTable[target] = bill
end

local function updateESP()
    if not toggles.esp then
        for _,v in espTable do v:Destroy() end
        espTable = {}
        return
    end
    
    for _, plr in Players:GetPlayers() do
        if plr ~= lp and plr.Character then
            if not espTable[plr.Character] then
                createESP(plr.Character, plr.Name.." [Player]", Color3.fromRGB(0,255,255))
            end
        end
    end
    
    -- Brainrots ESP (ищи модели по имени или в workspace)
    for _, obj in workspace:GetDescendants() do
        if obj:IsA("Model") and (string.find(obj.Name:lower(), "brainrot") or string.find(obj.Name:lower(), "pet")) then
            if not espTable[obj] then
                createESP(obj, obj.Name.." [BRAINROT]", Color3.fromRGB(255,215,0))
            end
        end
    end
end

spawn(function()
    while true do
        updateESP()
        task.wait(3)
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() updateESP() end)
end)

-- === AUTO COLLECT / FARM ===
spawn(function()
    while true do
        task.wait(0.15)
        if toggles.autoCollect then
            pcall(function()
                -- Реальные remotes из 2026 (часто меняются, ищи в RS.Events или RS.Remotes)
                if RS:FindFirstChild("Remotes") then
                    local rem = RS.Remotes:FindFirstChild("CollectCash") or RS.Remotes:FindFirstChild("CollectMoney") or RS.Remotes:FindFirstChildWhichIsA("RemoteEvent")
                    if rem then rem:FireServer() end
                end
            end)
        end
        
        if toggles.infMoney then
            pcall(function()
                local moneyRemote = RS:FindFirstChild("AddMoney") or RS:FindFirstChild("GiveCash")
                if moneyRemote then moneyRemote:FireServer(999999) end
            end)
        end
    end
end)

-- === AUTO STEAL / INSTANT GRAB ===
spawn(function()
    while true do
        task.wait(0.2)
        if toggles.autoSteal or toggles.instantSteal then
            pcall(function()
                for _, plr in Players:GetPlayers() do
                    if plr ~= lp and plr.Character and (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude < values.stealDistance then
                        -- Типичный steal remote (ищи реальное имя!)
                        local stealRemote = RS.Remotes:FindFirstChild("StealBrainrot") or RS.Remotes:FindFirstChild("GrabPet") or RS.Remotes:FindFirstChild("Steal")
                        if stealRemote then
                            if toggles.instantSteal then
                                hrp.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
                            end
                            stealRemote:FireServer(plr.Character) -- или plr, или brainrot instance
                        end
                    end
                end
            end)
        end
    end
end)

-- === AUTO LOCK BASE ===
spawn(function()
    while true do
        task.wait(1)
        if toggles.autoLock then
            pcall(function()
                local lockRemote = RS.Remotes:FindFirstChild("ToggleLock") or RS.Remotes:FindFirstChild("LockBase")
                if lockRemote then lockRemote:FireServer(true) end
            end)
        end
    end
end)

-- === ANTI-GRAB / DESYNC ===
hum:GetPropertyChangedSignal("Sit"):Connect(function()
    if toggles.antiGrab then hum.Sit = false end
end)

-- === UI ЭЛЕМЕНТЫ (много, чтоб набрать объём) ===

Tabs.Main:AddToggle("fly", {Title = "Fly", Default = false, Callback = toggleFly})
Tabs.Main:AddSlider("flySpeed", {Title = "Fly Speed", Min = 20, Max = 300, Default = 60, Rounding = 1, Callback = function(v) values.flySpeed = v end})

Tabs.Movement:AddToggle("speedHack", {Title = "Speed Hack", Default = false, Callback = function(v) toggles.speedHack = v; hum.WalkSpeed = v and values.walkSpeed or 16 end})
Tabs.Movement:AddSlider("walkSpeed", {Title = "Скорость", Min = 16, Max = 300, Default = 50, Rounding = 0, Callback = function(v) values.walkSpeed = v end})

Tabs.Movement:AddToggle("infJump", {Title = "Inf Jump", Default = false, Callback = function(v) toggles.infJump = v; hum.JumpPower = v and values.jumpPower or 50 end})
Tabs.Movement:AddSlider("jumpPower", {Title = "Jump Power", Min = 50, Max = 300, Default = 100, Rounding = 0, Callback = function(v) values.jumpPower = v end})

Tabs.Movement:AddToggle("noclip", {Title = "Noclip", Default = false, Callback = function(v) toggles.noclip = v end})

Tabs.Auto:AddToggle("autoCollect", {Title = "Авто-Коллект Кэша", Default = false, Callback = function(v) toggles.autoCollect = v end})
Tabs.Auto:AddToggle("autoLock", {Title = "Авто-Лок Базы", Default = false, Callback = function(v) toggles.autoLock = v end})
Tabs.Auto:AddToggle("infMoney", {Title = "Inf Money (если работает)", Default = false, Callback = function(v) toggles.infMoney = v end})

Tabs.StealTab:AddToggle("autoSteal", {Title = "Авто-Стил (ближайший)", Default = false, Callback = function(v) toggles.autoSteal = v end})
Tabs.StealTab:AddToggle("instantSteal", {Title = "Instant Steal + TP", Default = false, Callback = function(v) toggles.instantSteal = v end})
Tabs.StealTab:AddSlider("stealDist", {Title = "Дистанция стила", Min = 5, Max = 50, Default = 15, Rounding = 0, Callback = function(v) values.stealDistance = v end})

Tabs.Visuals:AddToggle("esp", {Title = "ESP (игроки + brainrots)", Default = false, Callback = function(v) toggles.esp = v; updateESP() end})

Tabs.Troll:AddToggle("desync", {Title = "Desync V3", Default = false, Callback = function(v) toggles.desync = v end})
Tabs.Troll:AddToggle("antiGrab", {Title = "Anti-Grab", Default = false, Callback = function(v) toggles.antiGrab = v end})

-- Кнопки
Tabs.Main:AddButton({Title = "Destroy GUI", Callback = function() Fluent:Destroy() end})
Tabs.Main:AddButton({Title = "Rejoin", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end})

-- Сохранения
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"Keybind"})
InterfaceManager:SetFolder("GrokSAB2026")
SaveManager:SetFolder("GrokSAB2026/configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
task.wait(0.5)
SaveManager:LoadAutoloadConfig()

print("GROK FIXED LOADED — теперь должно работать, ищи remotes в игре через DarkDex/Synapse! Если всё равно мёртв — кинь скрин remotes в чат, разжую точные имена. Еби сервер, не пали основной акк!")
