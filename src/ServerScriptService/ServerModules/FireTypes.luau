--Firetype, derived from rate of fire. Called on the server?
local FireType = {}
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Pagfam12ReplicatedStorage.Modules
local Events = ReplicatedStorage.Pagfam12ReplicatedStorage.RemoteEvents
local ServerModules = ServerScriptService.ServerModules
local ShootTypes = require(ServerModules.ShootTypes)


function FireType.Constant(functable:{["FunctionName"]:string, ["FunctionParams"]:table}, firetypeparams)
    if not firetypeparams.IsHeld then
        warn("IsHeld value doesn't exists for constant firetype, have proper handling!")
        return
    end
    
    if firetypeparams.IsHeld == true then
        
    else
        return
    end
end

function FireType.Single(functable:{["FunctionName"]:string, ["FunctionParams"]:table})

end

function FireType.Multi(funcName, funcParams)
	
end

return FireType