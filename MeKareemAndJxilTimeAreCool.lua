local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local miscFolder = workspace:WaitForChild("Map"):WaitForChild("Misc")

-- Settings
local isEnabled = false
local LARGE_SIZE = Vector3.new(9999999, 9999999, 9999999)
local NORMAL_SIZE = Vector3.new(1.5, 1.5, 1.5) -- Adjust to the actual original size

-- 1. Create the GUI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HitboxToggleGui"
screenGui.Parent = PlayerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 50, 0.5, -25) -- Middle left of screen
button.Text = "Hitbox: OFF"
button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel = 2
button.Parent = screenGui

-- 2. Function to apply the size change
local function updateHitbox(hitbox)
	if hitbox and hitbox:IsA("BasePart") then
		if isEnabled then
			hitbox.Size = LARGE_SIZE
			hitbox.Transparency = 0.5 -- Optional: makes it easier to see through
		else
			hitbox.Size = NORMAL_SIZE
			hitbox.Transparency = 0
		end
	end
end

-- 3. Logic for existing and new TimeChunks
local function scanAndApply()
	for _, child in ipairs(miscFolder:GetChildren()) do
		if child.Name == "TimeChunk" then
			local hitbox = child:FindFirstChild("Hitbox")
			updateHitbox(hitbox)
		end
	end
end

-- Monitor for new spawns
miscFolder.ChildAdded:Connect(function(child)
	if child.Name == "TimeChunk" then
		-- Wait a brief moment for the 'Hitbox' child to exist inside the TimeChunk
		local hitbox = child:WaitForChild("Hitbox", 5)
		updateHitbox(hitbox)
	end
end)

-- 4. Button Click Event
button.MouseButton1Click:Connect(function()
	isEnabled = not isEnabled
	
	-- Update UI visuals
	if isEnabled then
		button.Text = "Hitbox: ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
	else
		button.Text = "Hitbox: OFF"
		button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	end
	
	-- Apply to all currently in the map
	scanAndApply()
end)
