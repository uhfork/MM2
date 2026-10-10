local p = game:GetService("Players")
local d = game:GetService("Debris")
local l = p.LocalPlayer
local c = l.Character
local b = l:FindFirstChild("Backpack")
local y = true
local r = 0 -- change how long will the bomb reload here

local function maketehbomb(t)
	if not t then
		return
	end

	local u = c:FindFirstChild("UpperTorso")
	local h = t:FindFirstChild("Handle")

	task.wait(.1)

	h.Transparency = 1

	local j = h:Clone()
	j.Transparency = 0
	j.CanCollide = true
	j.Anchored = false

	local w = Vector3.new(-0.19205892086029053, -0.9809870719909668, 0.027887430042028427)
	j.CFrame = CFrame.new(u.Position) * CFrame.new(0, -2.8, 0)
	j.AssemblyLinearVelocity = (w * 50) + Vector3.new(0, 20, 0)

	d:AddItem(j, 4)
	j.Parent = workspace

	task.delay(r, function()
		if h and h.Parent then
			h.Transparency = 0
		end
	end)
end
local function maketehtool()
	if not b or not c then
		return
	end
	local t = Instance.new("Tool", b)
	t.Name = "FakeBomb"
	t.TextureId = "http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=250&height=250&assetId=342187115"
	t.CanBeDropped = false
	t.Grip = CFrame.new(-0.600000024, 0, -0.400000006, -0.93645668, 0, -0.350783229, -0.168174446, 0.87758255, 0.448961258, 0.307841241, 0.47942555, -0.821818054)

	local h = Instance.new("Part", t)
	h.Name = "Handle"
	h.BrickColor = BrickColor.new("Sand green")
	h.Size = Vector3.new(1.65, 0.9, 1.3)
	h.CanCollide = false
	h.Anchored = false

	local m = Instance.new("SpecialMesh", h)
	m.MeshId = "http://www.roblox.com/asset/?id=104516854"
	m.Scale = Vector3.new(1.5, 1.5, 1.5)
	m.TextureId = "http://www.roblox.com/asset/?id=104516981"

	t.Equipped:Connect(function(m)
		if m == nil then
			return
		end

		m.Button1Down:Connect(function()
			local h, u = c:FindFirstChild("Humanoid"), c:FindFirstChild("UpperTorso")

			if not (y and (h and (h.Health > 0 and u))) then
				return
			end

			y = false
			maketehbomb(t)
			task.wait(r)
			y = true
		end)
	end)
end
maketehtool()
