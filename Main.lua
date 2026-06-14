local RunService = game:GetService("RunService")

local tracerPart
local tracerConnection

local function createTracer(targetPosition)

	if tracerPart then
		tracerPart:Destroy()
	end

	if tracerConnection then
		tracerConnection:Disconnect()
	end

	tracerPart = Instance.new("Part")
	tracerPart.Name = "LocationTracer"
	tracerPart.Anchored = true
	tracerPart.CanCollide = false
	tracerPart.Material = Enum.Material.Neon
	tracerPart.Color = Color3.fromRGB(255, 0, 0)
	tracerPart.Parent = workspace

	tracerConnection = RunService.RenderStepped:Connect(function()

		local character = player.Character
		if not character then
			return
		end

		local root = character:FindFirstChild("HumanoidRootPart")
		if not root then
			return
		end

		local startPos = root.Position
		local distance = (targetPosition - startPos).Magnitude

		tracerPart.Size = Vector3.new(0.5, 0.5, distance)

		tracerPart.CFrame =
			CFrame.lookAt(startPos, targetPosition)
			* CFrame.new(0, 0, -distance / 2)

	end)
end