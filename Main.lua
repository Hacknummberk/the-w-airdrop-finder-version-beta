-- The W Location Finder | ver beta
-- LocalScript

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- CONFIG
local TITLE = "The W Location Finder"
local VERSION = "beta"

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "WLocationFinder"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

------------------------------------------------------------------
-- NOTIFICATION
------------------------------------------------------------------

local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 350, 0, 50)
notify.Position = UDim2.new(0.5, -175, 0, 20)
notify.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notify.TextColor3 = Color3.new(1, 1, 1)
notify.Font = Enum.Font.GothamBold
notify.TextScaled = true
notify.BorderSizePixel = 0
notify.Parent = gui

local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0, 10)
notifyCorner.Parent = notify

notify.Text = string.format(
	'Loading: "%s | ver %s" loading...',
	TITLE,
	VERSION
)

task.spawn(function()
	task.wait(2)
	notify.Text = "Load done!"
	task.wait(2)
	notify:Destroy()
end)

------------------------------------------------------------------
-- TOGGLE BUTTON
------------------------------------------------------------------

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 60, 0, 60)
toggle.Position = UDim2.new(0, 10, 0.5, -30)
toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggle.Text = "📍"
toggle.TextScaled = true
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BorderSizePixel = 0
toggle.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggle

------------------------------------------------------------------
-- MAIN FRAME
------------------------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 290)
frame.Position = UDim2.new(0.5, -170, 0.5, -145)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Title

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = TITLE .. " | ver " .. VERSION
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

-- Divider

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0, 45)
divider.BackgroundColor3 = Color3.fromRGB(70,70,70)
divider.BorderSizePixel = 0
divider.Parent = frame

------------------------------------------------------------------
-- INPUT BOX CREATOR
------------------------------------------------------------------

local function createBox(yPos, placeholder)
	local box = Instance.new("TextBox")

	box.Size = UDim2.new(0.85, 0, 0, 40)
	box.Position = UDim2.new(0.075, 0, 0, yPos)

	box.BackgroundColor3 = Color3.fromRGB(40,40,40)
	box.TextColor3 = Color3.new(1,1,1)

	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(180,180,180)

	box.Font = Enum.Font.Gotham
	box.TextScaled = true
	box.ClearTextOnFocus = false
	box.BorderSizePixel = 0

	box.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = box

	return box
end

local xBox = createBox(65, "Enter X Coordinate")
local yBox = createBox(115, "Enter Y Coordinate")
local zBox = createBox(165, "Enter Z Coordinate")

------------------------------------------------------------------
-- CREATE TRACER BUTTON
------------------------------------------------------------------

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.85, 0, 0, 45)
button.Position = UDim2.new(0.075, 0, 0, 225)

button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1,1,1)
button.Text = "CREATE TRACER"

button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.BorderSizePixel = 0

button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

------------------------------------------------------------------
-- SHOW / HIDE UI
------------------------------------------------------------------

toggle.Activated:Connect(function()
	frame.Visible = not frame.Visible
end)

------------------------------------------------------------------
-- TRACER SYSTEM
------------------------------------------------------------------

local tracerPart
local targetMarker

local function createTracer(targetPosition)

	if tracerPart then
		tracerPart:Destroy()
	end

	if targetMarker then
		targetMarker:Destroy()
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	local startPos = root.Position
	local distance = (targetPosition - startPos).Magnitude

	tracerPart = Instance.new("Part")
	tracerPart.Name = "LocationTracer"
	tracerPart.Anchored = true
	tracerPart.CanCollide = false
	tracerPart.Material = Enum.Material.Neon
	tracerPart.Color = Color3.fromRGB(255, 0, 0)

	tracerPart.Size = Vector3.new(0.5, 0.5, distance)

	tracerPart.CFrame =
		CFrame.lookAt(startPos, targetPosition)
		* CFrame.new(0, 0, -distance / 2)

	tracerPart.Parent = workspace

	targetMarker = Instance.new("Part")
	targetMarker.Name = "TargetMarker"
	targetMarker.Shape = Enum.PartType.Ball
	targetMarker.Anchored = true
	targetMarker.CanCollide = false
	targetMarker.Material = Enum.Material.Neon
	targetMarker.Color = Color3.fromRGB(0, 255, 0)

	targetMarker.Size = Vector3.new(3, 3, 3)
	targetMarker.Position = targetPosition

	targetMarker.Parent = workspace

	Debris:AddItem(targetMarker, 300)
end

------------------------------------------------------------------
-- BUTTON ACTION
------------------------------------------------------------------

button.Activated:Connect(function()

	local x = tonumber(xBox.Text)
	local y = tonumber(yBox.Text)
	local z = tonumber(zBox.Text)

	if not (x and y and z) then
		button.Text = "INVALID XYZ"

		task.wait(1)

		button.Text = "CREATE TRACER"
		return
	end

	createTracer(Vector3.new(x, y, z))

	button.Text = "TRACER CREATED"

	task.wait(1)

	button.Text = "CREATE TRACER"
end)
