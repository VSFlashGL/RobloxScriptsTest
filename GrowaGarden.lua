--[[
    Grow a Garden Utility GUI v1.0
    Author: VSFlashGL (ChatGPT rewrite)
    Date: 2025‑05‑14

    • Modern draggable GUI with tabs: Fly, Speed, Teleport
    • Fly with adjustable speed & noclip
    • WalkSpeed slider
    • Four dynamic teleports (works by name‑search in Workspace)
    • No auto‑farm / planting logic – stripped as requested

    Load with:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VSFlashGL/RobloxScriptsTest/main/GrowaGardenGUI.lua"))()
--]]

---------------------------------------------------------------------
-- ⚙️  SETTINGS (edit if you wish)
---------------------------------------------------------------------
getgenv().FlyEnabled   = false
getgenv().FlySpeed     = 100   -- default for slider (10‑200)
getgenv().WalkSpeed    = 16    -- default for slider (16‑200)
---------------------------------------------------------------------

--// Services -------------------------------------------------------
local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")

local LocalPlayer   = Players.LocalPlayer
local Camera        = workspace.CurrentCamera

local Character     = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid      = Character:WaitForChild("Humanoid")
local HRP           = Character:WaitForChild("HumanoidRootPart")

-- Keep character references up‑to‑date on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid  = char:WaitForChild("Humanoid")
    HRP       = char:WaitForChild("HumanoidRootPart")
end)

---------------------------------------------------------------------
-- 🖥️  UI LIBRARY (Rayfield, one‑liner)
---------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name            = "🌱 Grow a Garden Utility GUI",
    LoadingTitle    = "Grow a Garden Utility",
    LoadingSubtitle = "Loading...",
    ConfigurationSaving = {Enabled = false},
})

---------------------------------------------------------------------
-- 📂  TABS
---------------------------------------------------------------------
local FlyTab      = Window:CreateTab("✈️ Fly", 4483362458)
local SpeedTab    = Window:CreateTab("🏃 Speed", 4483362458)
local TeleportTab = Window:CreateTab("🌍 Teleport", 4483362458)

---------------------------------------------------------------------
-- ✈️  FLY LOGIC -----------------------------------------------------
---------------------------------------------------------------------
local BV, BG, FlyConn, NoClipConn

local function setNoClip(state)
    if state then
        if NoClipConn then return end
        NoClipConn = RunService.Stepped:Connect(function()
            if getgenv().FlyEnabled and Character then
                for _,part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif NoClipConn then
        NoClipConn:Disconnect()
        NoClipConn = nil
        -- restore collisions
        for _,part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function startFly()
    if BV then return end -- already flying

    BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(1e6,1e6,1e6)
    BV.P        = 12500
    BV.Velocity = Vector3.zero
    BV.Parent   = HRP

    BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(1e6,1e6,1e6)
    BG.P         = 12500
    BG.CFrame    = HRP.CFrame
    BG.Parent    = HRP

    Humanoid.PlatformStand = true
    setNoClip(true)

    FlyConn = RunService.RenderStepped:Connect(function()
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W)          then dir += Camera.CFrame.LookVector      end
        if UIS:IsKeyDown(Enum.KeyCode.S)          then dir -= Camera.CFrame.LookVector      end
        if UIS:IsKeyDown(Enum.KeyCode.A)          then dir -= Camera.CFrame.RightVector     end
        if UIS:IsKeyDown(Enum.KeyCode.D)          then dir += Camera.CFrame.RightVector     end
        if UIS:IsKeyDown(Enum.KeyCode.Space)      then dir += Camera.CFrame.UpVector        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl)then dir -= Camera.CFrame.UpVector        end

        if dir.Magnitude > 0 then dir = dir.Unit end
        BV.Velocity = dir * getgenv().FlySpeed
        BG.CFrame   = CFrame.new(Vector3.new(), Camera.CFrame.LookVector)
    end)
end

local function stopFly()
    if FlyConn then FlyConn:Disconnect(); FlyConn = nil end
    if BV then BV:Destroy(); BV = nil end
    if BG then BG:Destroy(); BG = nil end
    setNoClip(false)
    Humanoid.PlatformStand = false
end

---------------------------------------------------------------------
-- ✈️  FLY TAB UI ----------------------------------------------------
---------------------------------------------------------------------
FlyTab:CreateToggle({
    Name         = "Enable Fly",
    CurrentValue = false,
    Callback     = function(value)
        getgenv().FlyEnabled = value
        if value then startFly() else stopFly() end
    end,
})

FlyTab:CreateSlider({
    Name         = "Fly Speed",
    Range        = {10, 200},
    Increment    = 5,
    Suffix       = "stud/s",
    CurrentValue = getgenv().FlySpeed,
    Callback     = function(val)
        getgenv().FlySpeed = val
    end,
})

---------------------------------------------------------------------
-- 🏃  SPEED TAB UI --------------------------------------------------
---------------------------------------------------------------------
SpeedTab:CreateSlider({
    Name         = "WalkSpeed",
    Range        = {16, 200},
    Increment    = 1,
    CurrentValue = getgenv().WalkSpeed,
    Callback     = function(val)
        getgenv().WalkSpeed = val
        if Humanoid then Humanoid.WalkSpeed = val end
    end,
})

---------------------------------------------------------------------
-- 🌍  TELEPORT TAB UI ----------------------------------------------
---------------------------------------------------------------------
local Destinations = {
    ["🌾 Go to Garden"] = {"Garden","Farm","FarmPlot","PlotArea"},
    ["🌱 Seed Shop"]    = {"SeedShop","Seeds","ShopSeeds"},
    ["🥚 Egg Shop"]     = {"EggShop","Eggs","ShopEggs"},
    ["🎉 Event Area"]   = {"EventArea","Events","Event"},
}

local function findFirstBasePart(nameList)
    for _,name in ipairs(nameList) do
        local obj = workspace:FindFirstChild(name, true)
        if obj then
            if obj:IsA("BasePart") then return obj end
            if obj:IsA("Model") then
                local bp = obj:FindFirstChildWhichIsA("BasePart")
                if bp then return bp end
            end
        end
    end
end

local function teleportTo(nameList, label)
    local target = findFirstBasePart(nameList)
    if target and HRP then
        HRP.CFrame = target.CFrame + Vector3.new(0, 5, 0)
    else
        Rayfield:Notify({Title="Teleport failed", Content="Couldn't find "..label, Duration=4})
    end
end

for label, names in pairs(Destinations) do
    TeleportTab:CreateButton({
        Name     = label,
        Callback = function()
            teleportTo(names, label)
        end,
    })
end

---------------------------------------------------------------------
-- 🔄  INITIAL SET‑UP -----------------------------------------------
---------------------------------------------------------------------
Humanoid.WalkSpeed = getgenv().WalkSpeed

Rayfield:Notify({Title="Grow a Garden Utility", Content="GUI loaded!", Duration=5})

-- End of script ----------------------------------------------------
