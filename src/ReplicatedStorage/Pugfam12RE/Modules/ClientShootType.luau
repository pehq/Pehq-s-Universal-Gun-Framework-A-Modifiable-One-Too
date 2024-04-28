local ShootType = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PugfamRS = ReplicatedStorage.Pugfam12RE
local Events = PugfamRS.RemoteEvents

ShootType.EventShoots = {}
local EventShoots = ShootType.EventShoots

local function RCL(plr:Player, tool:Tool, prop:{["Start"]:Vector3, ["Orientation"]:Vector3, ["Length"]:number}) --plr: plr that fired, Tool: the tool used, Prop: properties
	
end

function EventShoots.RCLClient()
	Events.RCLClient.OnClientEvent:Connect(RCL)
end


return ShootType