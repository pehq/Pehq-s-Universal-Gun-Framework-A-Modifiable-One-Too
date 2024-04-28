local ShootType = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PugfamRS = ReplicatedStorage.Pugfam12RE
local Events = PugfamRS.RemoteEvents
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")


ShootType.EventShoots = {}
local EventShoots = ShootType.EventShoots

local function RCL(plr:Player, tool:Tool, prop:{["StartPos"]:Vector3, ["TargetPos"]:Vector3, ["RayResult"]:RaycastResult}) --plr: plr that fired, Tool: the tool used, Prop: properties. This creates the bullets on the client
	local data = require(tool.Data.PugfamData)
	
	local Bullet:BasePart = data.Bullet:Clone()
	
	local StartPos = tool[data.BulletBase].Position
	
	Bullet.Size = Vector3.new(Bullet.Size.X, Bullet.Size.Y, (prop.TargetPos - StartPos).Magnitude)
	Bullet.CFrame = CFrame.new(StartPos, prop.TargetPos) * CFrame.new(0, 0, - Bullet.Size.Z / 2)
	Bullet.Color = plr.TeamColor.Color
	
	Bullet.Parent = workspace
	
	Debris:AddItem(Bullet, data.BulletLifetime)
	
	local BulletUpdatePos
	BulletUpdatePos = RunService.RenderStepped:Connect(function(dt)
		if not tool.Data or not Bullet then
			BulletUpdatePos:Disconnect()
		end
		Bullet.CFrame = CFrame.new(tool[data.BulletBase].Position, prop.TargetPos) * CFrame.new(0, 0, - Bullet.Size.Z / 2)
	end)
end

function EventShoots.RCLClient()
	local event
	event = Events.RCLClient.OnClientEvent:Connect(RCL)
	
	return event
end


return ShootType