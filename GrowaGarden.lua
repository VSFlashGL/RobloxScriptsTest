--// Grow a Garden – Script Hub
--// One-file GUI that lets you run four popular scripts on demand.
--// Created by: VSFlashGL  |  GitHub: https://github.com/VSFlashGL/RobloxScriptsTest

-- ✅ Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptco/Kavo-UI-Library/main/source.lua"))()

-- ▶️ Create main window
local Window = Library.CreateLib("Grow a Garden | Script Hub", "Ocean")

--------------------------------------------------------------------
-- 📑 TAB: SCRIPTS
--------------------------------------------------------------------
local scriptsTab      = Window:NewTab("Scripts")
local scriptsSection  = scriptsTab:NewSection("Choose a script to run:")

-- helper function to safely fetch/execute any remote script
local function runRemote(url, name)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url, true))()
    end)
    if ok then
        Library:Notify(name .. " loaded successfully!", 3)
    else
        Library:Notify("Error loading " .. name .. ":\n" .. tostring(err), 5)
    end
end

-- 🧪 BrySadW AutoFarm
scriptsSection:NewButton("🧪 BrySadW AutoFarm", "Run BrySadW autofarm script", function()
    runRemote("https://raw.githubusercontent.com/BrySadW/GrowAGarden/refs/heads/main/GrowAGarden.lua",
              "BrySadW AutoFarm")
end)

-- 🌿 Gumanba Script
scriptsSection:NewButton("🌿 Gumanba Script", "Run Gumanba script", function()
    runRemote("https://raw.githubusercontent.com/gumanba/Scripts/main/GrowaGarden",
              "Gumanba Script")
end)

-- 🚜 Depthso Farm
scriptsSection:NewButton("🚜 Depthso Farm", "Run Depthso autofarm", function()
    runRemote("https://raw.githubusercontent.com/depthso/Grow-a-Garden/refs/heads/main/autofarm.lua",
              "Depthso Farm")
end)

-- 🌱 Hakari Roslina
scriptsSection:NewButton("🌱 Hakari Roslina", "Run Hakari Roslina script", function()
    runRemote("https://raw.githubusercontent.com/hakariqScripts/Roslina/refs/heads/main/Ro",
              "Hakari Roslina")
end)

--------------------------------------------------------------------
-- ℹ️ TAB: INFO
--------------------------------------------------------------------
local infoTab      = Window:NewTab("Info")
local infoSection  = infoTab:NewSection("About")

infoSection:NewLabel("Created by: VSFlashGL")
infoSection:NewLabel("Script Hub for Grow a Garden")
infoSection:NewLabel("GitHub: github.com/VSFlashGL/RobloxScriptsTest")

--------------------------------------------------------------------
-- Misc settings ---------------------------------------------------
-- Kavo UI windows are draggable by default; nothing extra needed.
-- If your executor requires task.defer, you can wrap Library calls with it.

-- Enjoy the game and happy farming! 🌾
