-- The W Location Finder | ver beta
-- LocalScript
-- Mobile Friendly
-- Input format: 627, 168, 268

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

--------------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------------

local TITLE = "The W Location Finder"
local VERSION = "beta"

--------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "WLocationFinder"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------
-- LOADING NOTIFICATION
--------------------------------------------------------------------

local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0,350,0,50)
notify.Position = UDim2.new(0.5,-175,0,20)
notify.BackgroundColor3 = Color3.fromRGB(30,30,30)
notify.BorderSizePixel = 0
notify.TextColor3 = Color3.new(1,1,1)
notify.Font = Enum.Font.GothamBold
notify.TextScaled = true
notify.Text = string.format(
	'Loading: "%s | ver %s" loading...',
	TITLE,
	VERSION
)
notify.Parent = gui

local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0,10)
notifyCorner.Parent = notify

task.spawn(function()
	task.wait(2)

	if notify.Parent then
		notify.Text = "Load done!"
	end

	task.wait(2)

	if notify.Parent then
		notify:Destroy()
	end
end)

--------------------------------------------------------------------
-- TOGGLE BUTTON
--------------------------------------------------------------------

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,60,0,60)
toggle.Position = UDim2.new(0,10,0.5,-30)
toggle.Text = "📍"
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBold
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggle.BorderSizePixel = 0
toggle.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1,0)
toggleCorner.Parent = toggle

--------------------------------------------------------------------
-- MAIN FRAME
--------------------------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,350,0,250)
frame.Position = UDim2.new(0.5,-175,0.5,-125)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,12)
frameCorner.Parent = frame

--------------------------------------------------------------------
-- TITLE
--------------------------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = TITLE .. " | ver " .. VERSION
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9,0,0,2)
divider.Position = UDim2.new(0.05,0,0,45)
divider.BackgroundColor3 = Color3.fromRGB(70,70,70)
divider.BorderSizePixel = 0
divider.Parent = frame

--------------------------------------------------------------------
-- COORDINATE BOX
--------------------------------------------------------------------

local coordBox = Instance.new("TextBox")
coordBox.Size = UDim2.new(0.85,0,0,45)
coordBox.Position = UDim2.new(0.075,0,0,80)
coordBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
coordBox.BorderSizePixel = 0
coordBox.TextColor3 = Color3.new(1,1,1)
coordBox.PlaceholderColor3 = Color3.fromRGB(180,180,180)
coordBox.PlaceholderText = "Example: 627, 168, 268"
coordBox.Font = Enum.Font.Gotham
coordBox.TextScaled = true
coordBox.ClearTextOnFocus = false
coordBox.Parent = frame

local coordCorner = Instance.new("UICorner")
coordCorner.CornerRadius = UDim.new(0,8)
coordCorner.Parent = coordBox

--------------------------------------------------------------------
-- STATUS LABEL
--------------------------------------------------------------------

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9,0,0,25)
statusLabel.Position = UDim2.new(0.05,0,0,135)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Waiting for coordinates..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.Parent = frame

--------------------------------------------------------------------
-- CREATE BUTTON
--------------------------------------------------------------------

local createButton = Instance.new("TextButton")
createButton.Size = UDim2.new(0.85,0,0,45)
createButton.Position = UDim2.new(0.075,0,0,170)
createButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
createButton.BorderSizePixel = 0
createButton.TextColor3 = Color3.new(1,1,1)
createButton.TextScaled = true
createButton.Font = Enum.Font.GothamBold
createButton.Text = "CREATE TRACER"
createButton.Parent = frame

local createCorner = Instance.new("UICorner")
createCorner.CornerRadius = UDim.new(0,8)
createCorner.Parent = createButton

--------------------------------------------------------------------
-- REMOVE BUTTON
--------------------------------------------------------------------

local removeButton = Instance.new("TextButton")
removeButton.Size = UDim2.new(0.85,0,0,35)
removeButton.Position = UDim2.new(0.075,0,0,220)
removeButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
removeButton.BorderSizePixel = 0
removeButton.TextColor3 = Color3.new(1,1,1)
removeButton.TextScaled = true
removeButton.Font = Enum.Font.GothamBold
removeButton.Text = "REMOVE TRACER"
removeButton.Parent = frame

local removeCorner = Instance.new("UICorner")
removeCorner.CornerRadius = UDim.new(0,8)
removeCorner.Parent = removeButton

--------------------------------------------------------------------
-- SHOW / HIDE UI
--------------------------------------------------------------------

toggle.Activated:Connect(function()
	frame.Visible = not frame.Visible
end)

--------------------------------------------------------------------
-- TRACER SYSTEM
--------------------------------------------------------------------

local tracerPart
local targetMarker
local tracerConnection

local function removeTracer()

	if tracerConnection then
		tracerConnection:Disconnect()
		tracerConnection = nil
	end

	if tracerPart then
		tracerPart:Destroy()
		tracerPart = nil
	end

	if targetMarker then
		targetMarker:Destroy()
		targetMarker = nil
	end

	statusLabel.Text = "Tracer removed."
end

local function createTracer(targetPosition)

	removeTracer()

	targetMarker = Instance.new("Part")
	targetMarker.Name = "TargetMarker"
	targetMarker.Shape = Enum.PartType.Ball
	targetMarker.Anchored = true
	targetMarker.CanCollide = false
	targetMarker.Material = Enum.Material.Neon
	targetMarker.Color = Color3.fromRGB(0,255,0)
	targetMarker.Size = Vector3.new(3,3,3)
	targetMarker.Position = targetPosition
	targetMarker.Parent = workspace

	tracerPart = Instance.new("Part")
	tracerPart.Name = "LocationTracer"
	tracerPart.Anchored = true
	tracerPart.CanCollide = false
	tracerPart.Material = Enum.Material.Neon
	tracerPart.Color = Color3.fromRGB(255,0,0)
	tracerPart.Parent = workspace

	tracerConnection = RunService.RenderStepped:Connect(function()

		local character = player.Character
		if not character then return end

		local root = character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local startPos = root.Position
		local distance = (targetPosition - startPos).Magnitude

		tracerPart.Size = Vector3.new(0.5,0.5,distance)

		tracerPart.CFrame =
			CFrame.lookAt(startPos,targetPosition)
			* CFrame.new(0,0,-distance/2)

	end)

	statusLabel.Text =
		string.format(
			"Tracking: %.0f, %.0f, %.0f",
			targetPosition.X,
			targetPosition.Y,
			targetPosition.Z
		)

	Debris:AddItem(targetMarker, 3600)
end

--------------------------------------------------------------------
-- CREATE BUTTON ACTION
--------------------------------------------------------------------

createButton.Activated:Connect(function()

	local text = coordBox.Text

	local x,y,z =
		text:match(
			"^%s*(-?[%d%.]+)%s*,%s*(-?[%d%.]+)%s*,%s*(-?[%d%.]+)%s*$"
		)

	if not x then

		createButton.Text = "INVALID FORMAT"

		task.wait(1)

		createButton.Text = "CREATE TRACER"

		return
	end

	local targetPosition = Vector3.new(
		tonumber(x),
		tonumber(y),
		tonumber(z)
	)

	createTracer(targetPosition)

	createButton.Text = "TRACER CREATED"

	task.wait(1)

	createButton.Text = "CREATE TRACER"

end)

--------------------------------------------------------------------
-- REMOVE BUTTON ACTION
--------------------------------------------------------------------

removeButton.Activated:Connect(function()
	removeTracer()
end)