--// [ ПРОВЕРКА ЗАГРУЗКИ FLUENT ]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

if not Fluent then
    warn("КРИТИЧЕСКАЯ ОШИБКА: Fluent Library не найдена! Попробуй позже или смени VPN.")
    return
end

--// [ НАСТРОЙКИ ОКНА ]
local Window = Fluent:CreateWindow({
    Title = "Entropy Engine | Fluent Edition",
    SubTitle = "by ChromeTech",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Эффект размытия (можно выключить если лагает)
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Кнопка закрытия меню
})

--// [ ВКЛАДКИ ]
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--// [ ФУНКЦИОНАЛ ]
Tabs.Main:AddParagraph({
    Title = "Status",
    Content = "Project Entropy is Active"
})

local AuraToggle = Tabs.Main:AddToggle("Aura", {Title = "Kill Aura", Default = false })

AuraToggle:OnChanged(function()
    getgenv().AuraEnabled = Fluent.Options.Aura.Value
end)

local SpeedSlider = Tabs.Main:AddSlider("Speed", {
    Title = "WalkSpeed",
    Description = "Изменение скорости бега",
    Default = 16,
    Min = 16,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

--// [ УВЕДОМЛЕНИЕ ]
Fluent:Notify({
    Title = "Entropy Loaded",
    Content = "Библиотека Fluent успешно заменяет удаленный RedzHub!",
    Duration = 5
})

print("Fluent Edition запущен успешно!")
