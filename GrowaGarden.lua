--// Grow a Garden — Script Hub  v4
--// Created by: VSFlashGL  |  github.com/VSFlashGL/RobloxScriptsTest

--------------------------------------------------------------------
-- 🖌️  Kavo UI
--------------------------------------------------------------------
local Library = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/xHeptco/Kavo-UI-Library/main/source.lua")
)()
local Window = Library.CreateLib("Grow a Garden | Script Hub", "Ocean")

--------------------------------------------------------------------
-- 🔕  Watchdog, выключающий навязчивые скрипты
--------------------------------------------------------------------
local function suppressBadScripts()
    -- паттерны «вредных» имен
    local BAD_PREFIXES = {
        ["Bottom_UI.Framework"]    = true,
        ["ThirdPartyUserService"]  = true,
    }

    -- helper
    local function isBad(ls)
        if not ls:IsA("LocalScript") then return false end
        for prefix in pairs(BAD_PREFIXES) do
            if ls.Name:sub(1, #prefix) == prefix then return true end
        end
        return false
    end

    -- обработка уже существующих
    for _, d in ipairs(game:GetDescendants()) do
        if isBad(d) and d.Enabled then
            d.Disabled = true
        end
    end

    -- реакция на новые
    game.DescendantAdded:Connect(function(obj)
        if isBad(obj) then
            task.defer(function()
                if obj:IsA("LocalScript") and obj.Enabled then
                    obj.Disabled = true
                end
            end)
        end
    end)
end

--------------------------------------------------------------------
-- 📑 TAB: SCRIPTS
--------------------------------------------------------------------
local scriptsTab     = Window:NewTab("Scripts")
local scriptsSection = scriptsTab:NewSection("Stable scripts:")

local function runRemote(url, name)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url, true))()
    end)

    if ok then
        Library:Notify(name .. " loaded!", 3)
        suppressBadScripts() -- активируем «сторожа»
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
infoSection:NewLabel("v4 — watchdog disables Bottom_UI & ThirdPartyUserService clones")

-- Kavo-UI окна перетаскиваются по умолчанию.
--------------------------------------------------------------------
-- Загрузка: loadstring(game:HttpGet("https://raw.githubusercontent.com/VSFlashGL/RobloxScriptsTest/main/GrowaGardenHub.lua"))()
--------------------------------------------------------------------
