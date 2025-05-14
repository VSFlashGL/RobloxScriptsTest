--// Grow a Garden — Script Hub v3
--// Created by: VSFlashGL  |  github.com/VSFlashGL/RobloxScriptsTest

--------------------------------------------------------------------
-- 🖌️ UI-библиотека Kavo
--------------------------------------------------------------------
local Library = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/xHeptco/Kavo-UI-Library/main/source.lua")
)()

local Window = Library.CreateLib("Grow a Garden | Script Hub", "Ocean")

--------------------------------------------------------------------
-- 🔕  Функция-глушитель навязчивых скриптов
--------------------------------------------------------------------
local function suppressBadScripts()
    local Players = game:GetService("Players")
    local localPlr = Players.LocalPlayer

    task.spawn(function()
        while task.wait(1) do
            -- 1) Bottom_UI.Framework
            local pg = localPlr:FindFirstChild("PlayerGui")
            if pg then
                local bottom = pg:FindFirstChild("Bottom_UI")
                if bottom then
                    local fw = bottom:FindFirstChild("Framework", true)
                    if fw and fw:IsA("LocalScript") and fw.Enabled then
                        fw.Disabled = true
                    end
                end
            end

            -- 2) скрипты в ThirdPartyUserService
            local tps = game:GetService("ThirdPartyUserService")
            for _, sc in ipairs(tps:GetChildren()) do
                if sc:IsA("LocalScript") and sc.Enabled then
                    sc.Disabled = true
                end
            end
        end
    end)
end

--------------------------------------------------------------------
-- 📑 TAB: SCRIPTS
--------------------------------------------------------------------
local scriptsTab     = Window:NewTab("Scripts")
local scriptsSection = scriptsTab:NewSection("Choose a stable script:")

local function runRemote(url, name)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url, true))()
    end)

    if ok then
        Library:Notify(name .. " loaded!", 3)
        suppressBadScripts() -- сразу запускаем «сторожа», чтобы тихо глушить ошибки
    else
        Library:Notify(("❌ %s error:\n%s"):format(name, err), 6)
    end
end

-- 🧪 BrySadW AutoFarm
scriptsSection:NewButton("🧪 BrySadW AutoFarm", "Run BrySadW autofarm", function()
    runRemote(
        "https://raw.githubusercontent.com/BrySadW/GrowAGarden/refs/heads/main/GrowAGarden.lua",
        "BrySadW AutoFarm"
    )
end)

-- 🚜 Depthso Farm
scriptsSection:NewButton("🚜 Depthso Farm", "Run Depthso autofarm", function()
    runRemote(
        "https://raw.githubusercontent.com/depthso/Grow-a-Garden/refs/heads/main/autofarm.lua",
        "Depthso Farm"
    )
end)

--------------------------------------------------------------------
-- ℹ️ TAB: INFO
--------------------------------------------------------------------
local infoTab     = Window:NewTab("Info")
local infoSection = infoTab:NewSection("About")

infoSection:NewLabel("Created by: VSFlashGL")
infoSection:NewLabel("Script Hub for Grow a Garden")
infoSection:NewLabel("GitHub: github.com/VSFlashGL/RobloxScriptsTest")
infoSection:NewLabel("v3 — extra error-suppression inside Bottom_UI & TPS scripts")

-- Kavo-UI окна перетаскиваются по умолчанию.
--------------------------------------------------------------------
-- Готово!   Залейте файл как GrowaGardenHub.lua и вызывайте:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/VSFlashGL/RobloxScriptsTest/main/GrowaGardenHub.lua"))()
--------------------------------------------------------------------
