local ShootType = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PugfamRS = ReplicatedStorage.Pagfam12ReplicatedStorage
local Events = PugfamRS.RemoteEvents

ShootType.EventShoots = {}
local EventShoots = ShootType.EventShoots

local function RCL(plr:Player, tool:Tool, prop:{["TargetPos"]:Vector3}) --plr: plr that fired, Tool: the tool used, Prop: properties
	
end

function EventShoots.RclClient()
	Events.RclClient.OnClientEvent:Connect(RCL)
end


return ShootType