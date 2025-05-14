-- Grow a Garden Script by ChatGPT

-- Автосбор и посадка
while true do
    pcall(function()
        for _, plot in pairs(workspace.Plots:GetChildren()) do
            if plot:FindFirstChild("Plant") and plot.Plant:FindFirstChild("Ready") then
                fireclickdetector(plot.Plant.ClickDetector) -- Сбор урожая
            elseif plot:FindFirstChild("Empty") then
                game:GetService("ReplicatedStorage").Remotes.Plant:FireServer("Seed") -- Посадка
            end
        end
    end)
    wait(1)
end
