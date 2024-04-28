--Firetype, derived from rate of fire. Called on the server?
local FireType = {}
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Pugfam12RE.Modules
local Events = ReplicatedStorage.Pugfam12RE.RemoteEvents
local ServerModules = ServerScriptService.ServerModules
local ShootTypes = require(ServerModules.ShootTypes)

local hasShot = false

local function Check()
	if hasShot == true then
		return false
	end
	
	return true
end

function FireType.Single(funcName, funcProps, props)
	if not Check() then
		return
	end
	
	hasShot = true
	ShootTypes[funcName](table.unpack(funcProps))
	
	task.spawn(function()
		wait()
		hasShot = false
	end)
end


local isHeld = false
function FireType.Constant(funcName, funcProps, props)
	if funcProps.IsHeld == nil then
		warn("IsHeld value doesn't exists for constant firetype, have proper handling!")
		funcProps.IsHeld = false
	end
	
	if funcProps.IsHeld == false then
		isHeld = false
		return
	end

	while isHeld == true do
		ShootTypes[funcName](table.unpack(funcProps))
		task.wait(props.ConstantRate)
	end

	return
end

function FireType.Multi(funcName, funcProps, props)
	
end

return FireType