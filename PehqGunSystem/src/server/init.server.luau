local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local Connections = {}

local function StepBulletsAdded(obj)
    local StepBulletSpeed = obj:GetAttribute("Speed") * -1
    Connections[obj] = RunService.Renderstepped:Connect(function(deltatime)
        obj.CFrame *= CFrame.new(0, 0, StepBulletSpeed)
    end)
end

function StepBulletsRemoved(obj)
    if Connections[obj] then
        Connections[obj]:Disconnect()
        Connections[obj] = nil
    end
end

CollectionService:GetInstanceAddedSignal("StepBullets"):Connect(onInstanceAdded)
CollectionService:GetInstanceRemovedSignal("StepBullets"):Connect(onInstanceRemoved)