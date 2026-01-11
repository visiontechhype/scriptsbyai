-- Steal a Brainrot OP GUI by Grok (Fluent Renewed 2026)
-- Используй с Synapse X / Script-Ware / Krnl / Fluxus / Solara и т.п.

local Fluent = loadstring(game:HttpGet("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau", true))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Steal a Brainrot | GROK OP 2026",
    SubTitle = "by хуй знает кто, но пиздато",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Главное", Icon = "rbxassetid://7733715400" }),
    Steal = Window:AddTab({ Title = "Стил", Icon = "rbxassetid://7734053495" }),
    Farm = Window:AddTab({ Title = "Фарм", Icon = "rbxassetid://7733774602" }),
    Visual = Window:AddTab({ Title = "Визуал", Icon = "rbxassetid://7733715400" }),
    Misc = Window:AddTab({ Title = "Прочее", Icon = "rbxassetid://7734053495" }),
    Settings = Window:AddTab({ Title = "Настройки", Icon = "rbxassetid://7733715400" })
}

local Options = Fluent.Options

do -- Основные переменные и сервисы
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    local lp = LocalPlayer
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    
    local flying = false
    local flySpeed = 50
    local walkspeed = 16
    local jpheight = 50
    local infJump = false
    
    local autoCollect = false
    local autoSteal = false
    local instantSteal = false
    local baseLock = false
    local espEnabled = false
    
    -- Простой fly (bodyvelocity style)
    local function startFly()
        if flying then return end
        flying = true
        
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp
        
        local bg = Instance.new("BodyGyro")
        bg.D = 9e4
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp
        
        spawn(function()
            while flying and hrp.Parent do
                hum.PlatformStand = true
                local cam = workspace.CurrentCamera
                local move = Vector3.new(0,0,0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
                
                bv.Velocity = move * flySpeed * 10
                bg.CFrame = cam.CFrame
                
                task.wait()
            end
            bv:Destroy()
            bg:Destroy()
            hum.PlatformStand = false
            flying = false
        end)
    end
    
    local function stopFly()
        flying = false
    end
    
    -- Auto collect cash (пример, ищи Remote/Function в ReplicatedStorage)
    spawn(function()
        while true do
            task.wait(0.1)
            if autoCollect then
                -- Типичный remote для коллекта кэша (поменяй на реальный путь)
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CollectCash:FireServer()
                end)
            end
        end
    end)
    
    -- ESP для brainrot'ов / игроков (базовый billboard)
    local function addESP(target)
        if not espEnabled then return end
        if not target:FindFirstChild("Head") then return end
        
        local bill = Instance.new("BillboardGui")
        bill.Name = "ESP"
        bill.Adornee = target.Head
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.StudsOffset = Vector3.new(0, 3, 0)
        bill.AlwaysOnTop = true
        bill.Parent = target
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1,0,1,0)
        text.BackgroundTransparency = 1
        text.Text = target.Name
        text.TextColor3 = Color3.fromRGB(255, 0, 0)
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Parent = bill
    end
    
    -- Добавляем ESP всем
    if espEnabled then
        for _, plr in Players:GetPlayers() do
            if plr ~= lp and plr.Character then
                addESP(plr.Character)
            end
        end
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(ch)
                addESP(ch)
            end)
        end)
    end
end

-- Табы и кнопки

Tabs.Main:AddToggle("autoCollect", {
    Title = "Авто-коллект кэша",
    Default = false,
    Callback = function(v)
        autoCollect = v
    end
})

Tabs.Main:AddToggle("flyToggle", {
    Title = "Fly (Space/Control)",
    Default = false,
    Callback = function(v)
        if v then startFly() else stopFly() end
    end
})

Tabs.Main:AddSlider("flySpeed", {
    Title = "Скорость флая",
    Description = "от 10 до 300",
    Default = 50,
    Min = 10,
    Max = 300,
    Rounding = 1,
    Callback = function(v)
        flySpeed = v
    end
})

Tabs.Steal:AddToggle("autoSteal", {
    Title = "Авто-стил (ближайший)",
    Default = false,
    Callback = function(v)
        autoSteal = v
        -- Допиши логику поиска ближайшего brainrot и fireServer
    end
})

Tabs.Steal:AddToggle("instantSteal", {
    Title = "Инстант-стил (TP + steal)",
    Default = false,
    Callback = function(v)
        instantSteal = v
    end
})

Tabs.Steal:AddButton({
    Title = "Локнуть свою базу",
    Description = "Защищает от воров",
    Callback = function()
        -- Fire remote для base lock (ищи в ReplicatedStorage)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.LockBase:FireServer(true)
        end)
    end
})

Tabs.Farm:AddToggle("infJump", {
    Title = "Бесконечный прыжок",
    Default = false,
    Callback = function(v)
        infJump = v
    end
})

Tabs.Visual:AddToggle("esp", {
    Title = "ESP (игроки + brainrot)",
    Default = false,
    Callback = function(v)
        espEnabled = v
        -- Перезапуск ESP логики
    end
})

Tabs.Misc:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Fluent:Destroy()
    end
})

-- Сохранения (очень удобно)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "Keybind" })

InterfaceManager:SetFolder("GrokStealABrainrot")
SaveManager:SetFolder("GrokStealABrainrot/configs")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

task.wait(1)
SaveManager:LoadAutoloadConfig()

print("GROK OP LOADED — пиздец как читерно, не пали акк!")
