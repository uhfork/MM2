local intensity = getgenv().intensity or 55
local sideways = getgenv().sideways or false

local uis = game:GetService"UserInputService"
local lp = game:GetService"Players".LocalPlayer
local startergui = game:GetService"StarterGui"
local character = lp.Character or lp.CharacterAdded:Wait()
local humanoid = character:WaitForChild"Humanoid"
local root = character:WaitForChild"HumanoidRootPart"
local mobile = table.find({ Enum.Platform.Android, Enum.Platform.IOS }, uis:GetPlatform()) ~= nil
local enabled = false

local function notify(title, content)
	pcall(function()
		startergui:SetCore("SendNotification", {
			Title = title,
			Text = content,
			Duration = 3
		})
	end)
end

local function issideway()
	local movedir = humanoid.MoveDirection
	if movedir.Magnitude == 0 then return false end

	local right = root.CFrame.RightVector
	local forward = root.CFrame.LookVector

	return math.abs(movedir:Dot(right)) > math.abs(movedir:Dot(forward))
end

local function dosg()
	humanoid.StateChanged:Connect(function(_, state)
		if not enabled then return end

		if state == Enum.HumanoidStateType.Jumping then
			if not sideways or issideway() then
				humanoid.WalkSpeed = intensity
			end
		elseif state == Enum.HumanoidStateType.Landed then
			humanoid.WalkSpeed = 16
		end
	end)
end

local screen
local btn
local dragging = false
local dragstart
local startpos

local function toggle()
	enabled = not enabled

	if btn then
		btn.Text = enabled and "on" or "off"
	end

	if not enabled then
		humanoid.WalkSpeed = 16
	end

	if not mobile then
		notify("speed glitch", enabled and "enabled" or "disabled")
	end
end

if mobile then
	screen = Instance.new("ScreenGui", game:GetService"CoreGui")
	screen.DisplayOrder = 999
	screen.IgnoreGuiInset = true
	screen.ResetOnSpawn = false

	btn = Instance.new("TextButton", screen)
	btn.AnchorPoint = Vector2.new(.5, .5)
	btn.BackgroundColor3 = Color3.new(0, 0, 0)
	btn.BackgroundTransparency = 0.6
	btn.BorderSizePixel = 0
	btn.Position = UDim2.fromScale(.5, .5)
	btn.Size = UDim2.fromOffset(36, 36)
	btn.Font = Enum.Font.Code
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 16
	btn.Text = "off"

	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragstart = input.Position
			startpos = btn.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	uis.InputChanged:Connect(function(input)
		if not dragging then return end

		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragstart
			btn.Position = UDim2.new(
				startpos.X.Scale, startpos.X.Offset + delta.X,
				startpos.Y.Scale, startpos.Y.Offset + delta.Y
			)
		end
	end)

	btn.MouseButton1Click:Connect(toggle)
end

uis.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.Z then
		toggle()
	end
end)

dosg()

lp.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild"Humanoid"
	root = char:WaitForChild"HumanoidRootPart"
	dosg()

	if enabled then
		humanoid.WalkSpeed = 16
	end
end)

notify("speed glitch", "loaded, press Z to toggle speed glitch")
