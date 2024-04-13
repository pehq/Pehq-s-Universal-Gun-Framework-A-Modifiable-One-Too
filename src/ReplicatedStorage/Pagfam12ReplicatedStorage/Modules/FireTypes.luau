--Firetype, derived from rate of fire. Called on the server?
local FireType = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Pagfam12ReplicatedStorage.Modules
local Events = ReplicatedStorage.Pagfam12ReplicatedStorage.RemoteEvents
local ShootTypes = require(Modules.FireTypes) --nuh uh

local autoDebounce = false
function FireType.Constant(func, funcParams, isShooting)
    if isShooting == true then
        
    else
        return
    end
end

function FireType.Single(func, funcParams)

end

function FireType.Multi(func, funcParams)
	
end

return FireType