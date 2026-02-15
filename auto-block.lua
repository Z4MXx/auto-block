-- Auto Block Breaker with GUI + Anti-Ban Bypass
-- Loadstring Ready - https://github.com/yourusername/roblox-scripts/raw/main/auto_block_breaker.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Anti-Ban Settings
local antiBan = true
local randDelayMin = 0.35
local randDelayMax = 1.1
local fakeMoveChance = 0.45

-- GUI (pakai CoreGui biar aman)
local sg = Instance.new("ScreenGui")
sg.Name = "BlockBreakerGUI"
sg.ResetOnSpawn = false
sg.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Auto Block Breaker - Safe Mode"
title.TextColor3 = Color3.fromRGB(0, 255, 180)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.45, 0, 0, 45)
startBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
startBtn.Text = "START"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
startBtn.TextColor3 = Color3.white
startBtn.TextScaled = true
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.45, 0, 0, 45)
stopBtn.Position = UDim2.new(0.5, 0, 0.25, 0)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopBtn.TextColor3 = Color3.white
stopBtn.TextScaled = true
stopBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 30)
status.Position = UDim2.new(0.05, 0, 0.55, 0)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.TextColor3 = Color3.fromRGB(220, 220, 220)
status.TextScaled = true
status.Parent = frame

local running = false

startBtn.MouseButton1Click:Connect(function()
  running = true
  startBtn.Text = "RUNNING"
  startBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
  status.Text = "Mencari block..."
end)

stopBtn.MouseButton1Click:Connect(function()
  running = false
  startBtn.Text = "START"
  startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
  status.Text = "Status: Stopped"
end)

-- Fungsi cari block terdekat
local function findBlock()
  local nearest = nil
  local minDist = math.huge
  for _, obj in pairs(workspace:GetChildren()) do
    if obj:IsA("BasePart") and (obj.Name:lower():find("block") or obj.Name:lower():find("ore") or obj.Name:lower():find("wood")) then
      local dist = (hrp.Position - obj.Position).Magnitude
      if dist < minDist and dist < 60 then
        minDist = dist
        nearest = obj
      end
    end
  end
  return nearest
end

-- Fungsi mukul + anti-ban
local function hitBlock(target)
  if not target or not target.Parent then return end

  -- Fake movement
  if math.random() < fakeMoveChance then
    hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-4,4), 0, math.random(-4,4))
  end

  -- Mukul (adaptasi game lo)
  pcall(function()
    target:Destroy()  -- Ganti dengan FireServer kalau ada remote
    -- Contoh: game.ReplicatedStorage.Break:FireServer(target)
  end)

  wait(math.random() * (randDelayMax - randDelayMin) + randDelayMin)
end

-- Loop aman
RunService.Heartbeat:Connect(function()
  if running and character and hrp and hrp.Parent then
    pcall(function()
      local target = findBlock()
      if target then
        status.Text = "Mukul: " .. target.Name
        hrp.CFrame = target.CFrame * CFrame.new(0, 4, 0)
        hitBlock(target)
        wait(0.6)  -- Cek hancur
        if not target.Parent then
          status.Text = "Hancur! Cari next..."
        end
      else
        status.Text = "Gak ada block deket"
        wait(2)
      end
    end)
  end
end)

print("Auto Block Breaker Loaded! GUI muncul di layar.")
