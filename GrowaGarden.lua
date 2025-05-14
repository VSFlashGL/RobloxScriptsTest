--[[
    Grow a Garden Utility GUI v1.1  (Kavo‑UI edition)
    Author: VSFlashGL (ChatGPT rewrite)
    Date: 2025‑05‑14

    ▸ Draggable, minimalistic GUI built on Kavo UI Library (no TopbarPlus dependency)
    ▸ Tabs: Fly, Speed, Teleport
    ▸ Fly with adjustable speed & noclip
    ▸ WalkSpeed slider
    ▸ Four dynamic teleports resolved at runtime via Workspace search

    --------------------------------------------------------------
    HOW TO LOAD:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VSFlashGL/RobloxScriptsTest/main/GrowaGarden.lua"))()

    (Либо замените путь, если файл лежит под другим именем.)
--]]

-----------------------------------------------------------------
-- ⚙️  SETTINGS ----------------------------------------------------
-----------------------------------------------------------------
getgenv().FlySpeed   = 100  -- default 10‑200
getgenv().WalkSpeed  = 16   -- default 16‑200
getgenv().FlyActive  = false
-----------------------------------------------------------------

--// Services ------------------------------------------------------
local Players     = game:GetService("Players")
local UIS         = game:GetService("UserInputService")
local RunService  = game:GetService("RunService")
local Workspace   = game:GetService("Workspace")

local LP      = Players.LocalPlayer
local Char    = LP.Character or LP.CharacterAdded:Wait()
local Humanoid= Char:WaitForChild("Humanoid")
local HRP     = Char:WaitForChild("HumanoidRootPart")
local Camera  = Workspace.CurrentCamera

LP.CharacterAdded:Connect(function(c)
    Char     = c
    Humanoid = c:WaitForChild("Humanoid")
    HRP      = c:WaitForChild("HumanoidRootPart")
end)

-----------------------------------------------------------------
-- 📚  LOAD KAVO UI LIBRARY ---------------------------------------
-----------------------------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window  = Library.CreateLib("🌱 Grow a Garden Utility", "Ocean")

-----------------------------------------------------------------
-- 🗂️  TABS & SECTIONS --------------------------------------------
-----------------------------------------------------------------
local FlyTab      = Window:NewTab("Fly")
local FlySection  = FlyTab:NewSection("Flight Controls")

local SpeedTab    = Window:NewTab("Speed")
local SpeedSection= SpeedTab:NewSection("Movement Speed")

local TeleTab     = Window:NewTab("Teleport")
local TeleSection = TeleTab:NewSection("Quick Travel")

-----------------------------------------------------------------
-- ✈️  FLY FUNCTIONS ----------------------------------------------
-----------------------------------------------------------------
local BV, BG, FlyConn, NoClipConn

local function setNoClip(state)
    if state then
        if NoClipConn then return end
        NoClipConn = RunService.Stepped:Connect(function()
            for _,v in ipairs(Char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    elseif NoClipConn then
        NoClipConn:Disconnect(); NoClipConn = nil
        for _,v in ipairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

local function startFly()
    if BV then return end
    BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(1e6,1e6,1e6)
    BV.Parent   = HRP

    BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(1e6,1e6,1e6)
    BG.Parent   = HRP

    Humanoid.PlatformStand = true
    setNoClip(true)

    FlyConn = RunService.RenderStepped:Connect(function()
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Camera.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Camera.CFrame.UpVector end
        if dir.Magnitude > 0 then dir = dir.Unit end
        BV.Velocity = dir * getgenv().FlySpeed
        BG.CFrame = Camera.CFrame
    end)
end

local function stopFly()
    if FlyConn then FlyConn:Disconnect(); FlyConn=nil end
    if BV then BV:Destroy(); BV=nil end
    if BG then BG:Destroy(); BG=nil end
    setNoClip(false)
    Humanoid.PlatformStand = false
end

-----------------------------------------------------------------
-- ✈️  FLY UI -------------------------------------------------------
-----------------------------------------------------------------
FlySection:NewToggle("Enable Fly", "Toggle flight mode", false, function(state)
    getgenv().FlyActive = state
    if state then startFly() else stopFly() end
end)

FlySection:NewSlider("Fly Speed", "Adjust flight speed", 200, 10, function(val)
    getgenv().FlySpeed = val
end)

-----------------------------------------------------------------
-- 🏃  SPEED UI -----------------------------------------------------
-----------------------------------------------------------------
SpeedSection:NewSlider("WalkSpeed", "Character movement speed", 200, 16, function(val)
    getgenv().WalkSpeed = val
    if Humanoid then Humanoid.WalkSpeed = val end
end)

-----------------------------------------------------------------
-- 🌍  TELEPORT UI --------------------------------------------------
-----------------------------------------------------------------
local Destinations = {
    ["🌾 Go to Garden"] = {"Garden","Farm","FarmPlot","PlotArea"},
    ["🌱 Seed Shop"]   = {"SeedShop","Seeds","ShopSeeds","SeedStore"},
    ["🥚 Egg Shop"]    = {"EggShop","Eggs","ShopEggs","EggStore"},
    ["🎉 Event Area"]  = {"EventArea","Events","Event"},
}

local function findBasePart(list)
    for _,name in ipairs(list) do
        local obj = Workspace:FindFirstChild(name, true)
        if obj then
            if obj:IsA("BasePart") then return obj end
            if obj:IsA("Model") then
                local bp = obj:FindFirstChildWhichIsA("BasePart")
                if bp then return bp end
            end
        end
    end
end

for label, names in pairs(Destinations) do
    TeleSection:NewButton(label, "", function()
        local target = findBasePart(names)
        if target and HRP then
            HRP.CFrame = target.CFrame + Vector3.new(0,5,0)
            Library:Notify("Teleported to " .. label)
        else
            Library:Notify("Target not found: " .. label)
        end
    end)
end

-----------------------------------------------------------------
-- 🔄  INIT ---------------------------------------------------------
-----------------------------------------------------------------
Humanoid.WalkSpeed = getgenv().WalkSpeed
Library:Notify("GUI loaded!")

-- END --
