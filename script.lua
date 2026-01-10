--// [ INITIALIZATION - KAVO LIB ]
local function GetLibrary()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    end)
    if success then return result else return nil end
end

local Kavo = GetLibrary()

if not Kavo then
    -- Если GitHub заблокирован, выводим сообщение в консоль (F9)
    warn("!!! ERROR: Kavo Library failed to load. Try to Re-Inject or use a VPN !!!")
    return
end

--// Создание окна
local Window = Kavo.CreateLib("Entropy Engine | ChromeTech", "DarkScene") -- Темы: DarkScene, Moonlight, Bloodshed

--// Создание вкладок (Tabs)
local MainTab = Window:NewTab("Main")
local VisualsTab = Window:NewTab("Visuals")
local MovementTab = Window:NewTab("Movement")

--// Создание секций (Sections)
local CombatSection = MainTab:NewSection("Combat Functions")
local ESPSection = VisualsTab:NewSection("Player & Gen ESP")

--// ПРИМЕР: Переключатель
CombatSection:NewToggle("Kill Aura", "Automatic attack nearby enemies", function(state)
    getgenv().CombatSettings.AuraEnabled = state
end)

--// ПРИМЕР: Слайдер (Удобнее, чем в Orion)
CombatSection:NewSlider("Aura Range", "Distance to hit", 50, 5, function(s)
    getgenv().CombatSettings.AuraRange = s
end)
