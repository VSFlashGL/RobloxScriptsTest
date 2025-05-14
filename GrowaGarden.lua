-- Grow a Garden Script with GUI by ChatGPT

local running = false
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GrowGardenGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌱 Grow a Garden GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local startButton = Instance.new("TextButton", frame)
startButton.Size = UDim2.new(1, -20, 0, 40)
startButton.Position = UDim2.new(0, 10, 0, 40)
startButton.Text = "▶️ Старт автофарма"
startButton.Font = Enum.Font.SourceSans
startButton.TextSize = 16
startButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
startButton.TextColor3 = Color3.new(1, 1, 1)

local stopButton = Instance.new("TextButton", frame)
stopButton.Size = UDim2.new(1, -20, 0, 40)
stopButton.Position = UDim2.new(0, 10, 0, 90)
stopButton.Text = "⏹️ Стоп"
stopButton.Font = Enum.Font.SourceSans
stopButton.TextSize = 16
stopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopButton.TextColor3 = Color3.new(1, 1, 1)

-- автофарм
local function autofarm()
    while running do
        pcall(function()
            for _, plot in pairs(workspace.Plots:GetChildren()) do
                if plot:FindFirstChild("Plant") and plot.Plant:FindFirstChild("Ready") then
                    fireclickdetector(plot.Plant.ClickDetector)
                elseif plot:FindFirstChild("Empty") then
                    game:GetService("ReplicatedStorage").Remotes.Plant:FireServer("Seed")
                end
            end
        end)
        wait(1)
    end
end

startButton.MouseButton1Click:Connect(function()
    if not running then
        running = true
        startButton.Text = "⏳ Работает..."
        coroutine.wrap(autofarm)()
    end
end)

stopButton.MouseButton1Click:Connect(function()
    running = false
    startButton.Text = "▶️ Старт автофарма"
end)
