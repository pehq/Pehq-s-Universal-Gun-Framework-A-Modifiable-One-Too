--Firetype, derived from rate of fire. Called on the server?
local FireType = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Modules
local Events = ReplicatedStorage.RemoteEvents
local ShootTypes = require(Modules.ShootTypesServer)

local autoDebounce = false
function FireType.Automatic(isShooting)
    if isShooting == true then
        
    else
        return
    end
end

function FireType.SemiAutomatic()

end

local function Init()
    Events.Shoot.OnClientEvent:Connect(function(plr, Tool, FireType, held)
        --maybe i should do this on the server
    end)
end

return {
    ["Initialize"] = Init,
    ["FireTypes"] = FireType
}
