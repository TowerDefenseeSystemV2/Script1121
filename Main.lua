local Player = game:GetService("Players").LocalPlayer
local PlayerGUI = Player:WaitForChild("PlayerGui")

local LastOrder = 1
local TabOrders = {}

local Module = {}
Module.__index = Module

local letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
local numbers = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
local special = {"~", "`", "!", "@", "#", "№", "$", ";", "%", "^", ":", "?", "&", "*", "(", ")", "_", "-", "+", "=", "/", "|", ".", ",", " "}

local function GenerateCode()
	local code = ""
	local length = math.random(20, 40)
	for i = 1, length do
		local randomIndex = math.random(1, 3)
		if randomIndex == 1 then
			code = code .. letters[math.random(1, #letters)]
		elseif randomIndex == 2 then
			code = code .. numbers[math.random(1, #numbers)]
		elseif randomIndex == 3 then
			code = code .. special[math.random(1, #special)]
		end
	end
	return code
end

function Module.New(HubName: string, HubIcon: string, KeySystem)
	local self = setmetatable({Name = HubName, Icon = HubIcon, Key = KeySystem}, Module)
	return self:SetupGui()
end

function Module:SetupGui()
	if self.Key then
		if not self.Key[Player.Name] then
			print("Kicked")
			Player:Kick("You are not WhiteListed to", self.Name)
			while true do
				Instance.new("Part", workspace)
			end
		end
	end

	local ScreenGUI = Instance.new("ScreenGui", PlayerGUI)
	ScreenGUI.Name = GenerateCode()
	ScreenGUI.IgnoreGuiInset = true
	ScreenGUI.DisplayOrder = 999999999

	local MainFrame = Instance.new("Frame", ScreenGUI)
	MainFrame.ZIndex = 999
	MainFrame.Name = self.Name
	MainFrame.Size = UDim2.new(0.5,0,0.5,0)
	MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
	MainFrame.Position = UDim2.new(0.5,0,0.5,0)
	MainFrame.BackgroundColor3 = Color3.new(0.364706, 0.364706, 0.364706)

	local CanvasGroup = Instance.new("CanvasGroup", MainFrame)
	CanvasGroup.Name = "Container"
	CanvasGroup.Size = UDim2.new(1,0,1,0)
	CanvasGroup.BackgroundTransparency = 1
	CanvasGroup.ZIndex = 999999997

	local Title = Instance.new("TextLabel", CanvasGroup)
	Title.Name = "Title"
	Title.Size = UDim2.new(1,0,0.1,0)
	Title.Text = self.Name
	Title.BackgroundColor3 = Color3.new(0,0,0)
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextScaled = true
	Title.ZIndex = 999999999
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.FontFace = Font.fromEnum(Enum.Font.FredokaOne)

	local TabsFrame = Instance.new("Frame", CanvasGroup)
	TabsFrame.Name = "Tabs"
	TabsFrame.Position = UDim2.new(0,0,0.1,0)
	TabsFrame.Size = UDim2.new(0.3,0,0.9,0)
	TabsFrame.BackgroundTransparency = 1
	TabsFrame.ZIndex = 999999998

	local UiList = Instance.new("UIListLayout", TabsFrame)
	UiList.SortOrder = Enum.SortOrder.LayoutOrder

	local StrokeTabs = Instance.new("UIStroke", TabsFrame)
	StrokeTabs.Thickness = 2

	local Stroke = Instance.new("UIStroke", MainFrame)
	Stroke.Thickness = 3

	local Corner = Instance.new("UICorner", MainFrame)
	Corner.CornerRadius = UDim.new(0.1,0)
	local Corner = Instance.new("UICorner", Title)
	Corner.CornerRadius = UDim.new(0.1,0)
	local Corner = Instance.new("UICorner", CanvasGroup)
	Corner.CornerRadius = UDim.new(0.1,0)

	return MainFrame
end

function Module.AddTab(MainFrame: Frame, TabName: string, Active: boolean)
	local Frame = MainFrame:FindFirstChild("Container"):FindFirstChild("Tabs")
	TabOrders[TabName] = 1

	local Tab = Instance.new("TextButton", Frame)
	Tab.Text = TabName
	Tab.TextScaled = true
	Tab.Name = TabName
	Tab.LayoutOrder = LastOrder
	Tab.Size = UDim2.new(1,0,0.1,0)
	Tab.ZIndex = 9999999

	if Active then
		Tab.BackgroundColor3 = Color3.new(0,1,0)
	end

	local TabFrame = Instance.new("ScrollingFrame", MainFrame.Container)
	TabFrame.Name = TabName
	TabFrame.Position = UDim2.new(0.3,0,0.1,0)
	TabFrame.Size = UDim2.new(0.7,0,0.9,0)
	TabFrame.BackgroundTransparency = 1
	TabFrame.ZIndex = 999999998
	TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	if Active then
		TabFrame.Visible = true
	else
		TabFrame.Visible = false
	end

	local UiList = Instance.new("UIListLayout", TabFrame)
	UiList.SortOrder = Enum.SortOrder.LayoutOrder
	UiList.Padding = UDim.new(0.01,0)

	local UiPadding = Instance.new("UIPadding", TabFrame)
	UiPadding.PaddingTop = UDim.new(0.005,0)

	Tab.Activated:Connect(function()
		for i,v: TextButton in Frame:GetChildren() do
			if v:IsA("TextButton") then
				MainFrame.Container[v.Name].Visible = false
				v.BackgroundColor3 = Color3.fromRGB(163,162,165)
			end
		end
		Tab.BackgroundColor3 = Color3.new(0,1,0)
		MainFrame.Container[TabName].Visible = true
	end)

	LastOrder += 1
end

function Module.AddButton(MainFrame: Frame, Tab:string, ButtonName: string)
	local Frame = MainFrame["Container"]:WaitForChild(Tab)

	local Button = Instance.new("TextButton", Frame)
	Button.LayoutOrder = TabOrders[Tab]
	Button.Name = ButtonName
	Button.Size = UDim2.new(0.97,0,0.13,0)
	Button.ZIndex = 999
	Button.TextScaled = true
	Button.TextXAlignment = Enum.TextXAlignment.Left

	return Button
end

function Module.AddTextLabel(MainFrame: Frame, Tab:string, LabelName: string)
	local Label = Instance.new("TextLabel", MainFrame.Container[Tab])
	Label.LayoutOrder = TabOrders[Tab]
	Label.Name = LabelName
	Label.Size = UDim2.new(1,0,0.1,0)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.TextScaled = true
	Label.ZIndex = 999
	Label.FontFace = Font.fromEnum(Enum.Font.FredokaOne)

	return Label
end



local MainFrame = Module.New("GnomeCode TOWER DEFENSE Script ( v0.1 )", "skibidi", {["Paradoxer_Dev"] = true, ["Clavizah"] = true})

local rotation = 0

--// Local Functions

local function MouseRaycast(model)
	local mousePosition = game:GetService("UserInputService"):GetMouseLocation()
	local mouseRay = workspace.CurrentCamera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
	local raycastParams = RaycastParams.new()

	local blacklist = workspace.CurrentCamera:GetChildren()
	table.insert(blacklist, model)

	for i,v in pairs(game:GetService("Players"):GetPlayers()) do
		table.insert(blacklist, v.Character)
	end

	for i,v in pairs(workspace.Mobs:GetChildren()) do
		table.insert(blacklist, v)
	end

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = blacklist

	local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)

	return raycastResult, mousePosition
end


--// Main Frame

Module.AddTab(MainFrame, "Spawn Towers", true)
Module.AddTab(MainFrame, "Credits", false)

local Label2 = Module.AddTextLabel(MainFrame, "Spawn Towers", "Towers")
Label2.Text = "Towers"
if game:GetService("ReplicatedStorage"):FindFirstChild("Towers") then
	for i,v in game:GetService("ReplicatedStorage"):FindFirstChild("Towers"):GetChildren() do
		if v:IsA("Model") then
			local SpawnTowerButton = Module.AddButton(MainFrame, "Spawn Towers", v.Name)
			SpawnTowerButton.Text = v.Name .. " " .. v.Config.Price.Value .. "$"
			
			SpawnTowerButton.Activated:Connect(function()
				local PlaceholderModel = v:Clone()
				PlaceholderModel.Parent = workspace
				
				local ConnectionPlace
				
				task.spawn(function()
					ConnectionPlace = game:GetService("RunService").RenderStepped:Connect(function()
						local result, location = MouseRaycast(PlaceholderModel)

						local x = result.Position.X
						local y = result.Position.Y + PlaceholderModel.Humanoid.HipHeight + (PlaceholderModel.PrimaryPart.Size.Y / 2)
						local z = result.Position.Z

						local cframe = CFrame.new(x,y,z) * CFrame.Angles(0, math.rad(rotation), 0)
						PlaceholderModel:SetPrimaryPartCFrame(cframe)
					end)
				end)
				
				local placeholder = true
				local connection
				connection = game:GetService("UserInputService").InputBegan:Connect(function(input, proccesed)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and placeholder and not proccesed then
						placeholder = false
						PlaceholderModel:Destroy()
						ConnectionPlace:Disconnect()
						Module.SpawnTower(v.Name)
						connection:Disconnect()
						game:GetService("ReplicatedStorage"):WaitForChild("Functions"):WaitForChild("SpawnTower"):InvokeServer(v.Name, PlaceholderModel.CFrame)
					elseif not proccesed and placeholder and input.KeyCode == Enum.KeyCode.R then
						rotation += 15
					elseif not proccesed and placeholder and input.KeyCode == Enum.KeyCode.Q then 
						ConnectionPlace:Disconnect()
						PlaceholderModel:Destroy()
					end
				end)
			end)
		end
	end
end

--// Credits Frame

local Label = Module.AddTextLabel(MainFrame, "Credits", "Scripter")
Label.Text = "Scripter: Parad0xer."

--// Functions
