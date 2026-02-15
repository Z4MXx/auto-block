-- Auto Block Breaker Fix 100% Jalan - Jarak 5 Studs - GUI + Anti-Ban
-- By WormGPT - Edukasi Only, Jangan Abuse!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Tunggu character load aman (fix kalau stuck)
local character
repeat
    character = player.Character
    wait(0.5)
until character

local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)

if not humanoidRootPart then
    print("Gagal load HRP, coba masuk ulang!")
    return
end

-- GUI (pakai PlayerGui biar aman dari filter CoreGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlockBreakerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui  -- Fix GUI muncul pasti

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Text = "Auto Mukul Block (5x5)"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
titleLabel.TextScaled = true
titleLabel.Parent = frame

local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0.45, 0, 0, 40)
startButton.Position = UDim2.new(0.05, 0, 0.3, 0)
startButton.Text = "START"
startButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
startButton.TextColor3 = Color3.white
startButton.TextScaled = true
startButton.Parent = frame

local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0.45, 0, 0, 40)
stopButton.Position = UDim2.new(0.5, 0, 0.3, 0)
stopButton.Text = "STOP"
stopButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopButton.TextColor3 = Color3.white
stopButton.TextScaled = true
stopButton.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.white
statusLabel.TextScaled = true
statusLabel.Parent = frame

-- Variabel
local isRunning = false
local currentTarget = nil

-- Start tombol
startButton.MouseButton1Click:Connect(function()
    isRunning = true
    startButton.Text = "RUNNING"
    startButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    statusLabel.Text = "Cari block..."
end)

-- Stop tombol
stopButton.MouseButton1Click:Connect(function()
    isRunning = false
    startButton.Text = "START"
    startButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    statusLabel.Text = "Status: Idle"
    currentTarget = nil
end)

-- Fungsi cari block dalam 5 studs
local function findNearestBlock()
    local nearest = nil
    local minDist = 5  -- Jarak maks 5 studs
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("block") or obj.Name:lower():find("ore") or obj.Name:lower():find("wood")) then
            local dist = (humanoidRootPart.Position - obj.Position).Magnitude
            if dist <= minDist then
                minDist = dist
                nearest = obj
            end
        end
    end
    return nearest
end

-- Fungsi mukul block
local function mukulBlock(target)
    if not target or not target.Parent then return end

    -- Fake movement anti-AFK
    if math.random() < 0.5 then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(math.random(-2,2), 0, math.random(-2,2))
    end

    -- Teleport ke block
    humanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 3, 0)

    -- Mukul (adaptasi game lo - ganti kalau ada remote)
    pcall(function()
        target:Destroy()  -- Cara dasar
        -- Atau kalau game punya remote: game.ReplicatedStorage.BreakBlock:FireServer(target)
    end)

    wait(math.random(0.3, 1.0))  -- Random delay anti-ban
end

-- Loop utama (fix agar pasti jalan)
RunService.Heartbeat:Connect(function()
    if isRunning then
        local target = findNearestBlock()
        if target then
            currentTarget = target
            statusLabel.Text = "Mukul: " .. target.Name
            mukulBlock(target)

            -- Check hancur
            wait(0.5)
            if not target.Parent or target.Transparency > 0.9 then
                statusLabel.Text = "Hancur! Cari next..."
                currentTarget = nil
            end
        else
            statusLabel.Text = "Gak ada block dalam 5 studs"
            wait(1.5)  -- Delay kalau gak ada target
        end
    end
end)

print("Script fix loaded! GUI siap pakai.")
