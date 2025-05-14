-- GrowaGarden.lua
-- Enhanced Fly and Teleport functionality for Grow a Garden

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player references
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- UI Library (Kavo UI)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AikaV3rm/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow a Garden GUI", "RJTheme3")

-- ===== FLY TAB =====
local FlyTab = Window:NewTab("Fly")
local FlySec = FlyTab:NewSection("Flight Controls")

-- Flight state variables
local flying = false
local flySpeed = 50
local bodyVel, bodyGyro

-- Toggle Fly On/Off
FlySec:NewToggle("Enable Fly", "Toggle flight mode", function(state)
    if state then
        flying = true
        -- NoClip: disable collisions
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        humanoid.PlatformStand = true
        -- Create BodyVelocity
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.Parent = hrp
        -- Create BodyGyro
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp
        -- Bind movement
        RunService:BindToRenderStep("Fly", Enum.RenderPriority.Camera.Value, function()
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then
                bodyVel.Velocity = dir.Unit * flySpeed
                bodyGyro.CFrame = cam.CFrame
            else
                bodyVel.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        Library:Notify("Flying enabled")
    else
        flying = false
        -- Unbind and cleanup
        RunService:UnbindFromRenderStep("Fly")
        if bodyVel then bodyVel:Destroy(); bodyVel = nil end
        if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
        humanoid.PlatformStand = false
        -- Re-enable collisions
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        Library:Notify("Flying disabled")
    end
end)

-- Slider for flight speed
FlySec:NewSlider("Fly Speed", "Adjust flight speed", {10, 200, true}, function(val)
    flySpeed = val
end)

-- ===== SPEED TAB =====
local SpeedTab = Window:NewTab("Speed")
local SpeedSec = SpeedTab:NewSection("WalkSpeed")
SpeedSec:NewSlider("Speed", "Change WalkSpeed", {16, 200, true}, function(val)
    humanoid.WalkSpeed = val
end)

-- ===== TELEPORT TAB =====
local TP_Tab = Window:NewTab("Teleport")
local TP_Sec = TP_Tab:NewSection("Destinations")

-- Generic teleport function
local function teleportTo(keyword)
    local target
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(keyword:lower()) then
            target = obj
            break
        end
    end
    if target then
        hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
        Library:Notify("Teleported to " .. keyword)
    else
        Library:Notify(keyword .. " not found")
    end
end

-- Teleport buttons
TP_Sec:NewButton("Go to Garden", "Teleport to garden area", function()
    teleportTo("garden")
end)
TP_Sec:NewButton("Seed Shop", "Teleport to seed shop", function()
    teleportTo("seed")
end)
TP_Sec:NewButton("Egg Shop", "Teleport to egg shop", function()
    teleportTo("egg")
end)
TP_Sec:NewButton("Event Area", "Teleport to event area", function()
    teleportTo("event")
end)
