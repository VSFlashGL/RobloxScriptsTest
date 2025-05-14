--// Grow a Garden — Script Hub v2 (error-free)
--// Created by: VSFlashGL  |  GitHub: https://github.com/VSFlashGL/RobloxScriptsTest

-- ────────────────────────────────────────────────────────────
--  ⚙️  Загрузка Kavo UI
-- ────────────────────────────────────────────────────────────
local Library = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/xHeptco/Kavo-UI-Library/main/source.lua")
)()

local Window = Library.CreateLib("Grow a Garden | Script Hub", "Ocean")

--------------------------------------------------------------------
-- 📑 TAB: SCRIPTS
--------------------------------------------------------------------
local scriptsTab     = Window:NewTab("Scripts")
local scriptsSection = scriptsTab:NewSection("Available scripts (stable):")

local function runRemote(url, name)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url, true))()
    end)
    if ok then
        Library:Notify(name .. " loaded!", 3)
    else
        Library:Notify(("❌ %s error:\n%s"):format(name, err), 6)
    end
end

-- 🧪 BrySadW AutoFarm
scriptsSection:NewButton("🧪 BrySadW AutoFarm", "Run BrySadW autofarm", function()
    runRemote("https://raw.githubusercontent.com/BrySadW/GrowAGarden/refs/heads/main/GrowAGarden.lua",
              "BrySadW AutoFarm")
end)

-- 🚜 Depthso Farm
scriptsSection:NewButton("🚜 Depthso Farm", "Run Depthso autofarm", function()
    runRemote("https://raw.githubusercontent.com/depthso/Grow-a-Garden/refs/heads/main/autofarm.lua",
              "Depthso Farm")
end)

--------------------------------------------------------------------
-- ℹ️ TAB: INFO
--------------------------------------------------------------------
local infoTab     = Window:NewTab("Info")
local infoSection = infoTab:NewSection("About")

infoSection:NewLabel("Created by: VSFlashGL")
infoSection:NewLabel("Script Hub for Grow a Garden")
infoSection:NewLabel("GitHub: github.com/VSFlashGL/RobloxScriptsTest")
infoSection:NewLabel("Only stable scripts are kept to avoid runtime errors.")

-- Kavo-UI окна перетаскиваются по умолчанию.
-- Удачного фарма! 🌾
