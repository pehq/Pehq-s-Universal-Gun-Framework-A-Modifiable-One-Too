--Pehq's Amazing Gun Framework, A Moddable 1

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--ShootTypes
local StepConnections = {}

local function StepBulletsAdded(obj)
    local StepBulletSpeed = obj:GetAttribute("Speed") * -1
    StepConnections[obj] = RunService.Renderstepped:Connect(function(deltatime)
        obj.CFrame *= CFrame.new(0, 0, StepBulletSpeed)
    end)
end

function StepBulletsRemoved(obj)
    if StepConnections[obj] then
        StepConnections[obj]:Disconnect()
        StepConnections[obj] = nil
    end
end

CollectionService:GetInstanceAddedSignal("StepBullets"):Connect(onInstanceAdded)
CollectionService:GetInstanceRemovedSignal("StepBullets"):Connect(onInstanceRemoved)

--when plr joins

Players.PlayerAdded:Connect(function(plr)
    local char = plr.Character or plr.CharacterAdded:Wait()

    --Gun equipped
    char.ChildAdded:Connect(function(child)
        if not child:IsA("Tool") or not child:GetAttribute("PehqGun") then
            return
        end

        local GunData = require(child.PehqGunData)


    end)    
)