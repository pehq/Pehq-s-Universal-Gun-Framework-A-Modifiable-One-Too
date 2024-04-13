local ShootTypes = {}
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.RemoteEvents
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Camera = workspace.CurruntCamera

--Note: stuff goes through the client first so client --> Server --> all clients
--Note: Player:GetMouse feels deprecated but remains not that since it's used a lot. However it should be treated as being deprecated.
local function Raycast(Tool, Bullet, origin, orientation, RayCastParams)
    if not RayCastParams then
        RayCastParams = {}
    end
    
    local RaycastResult = workspace:Raycast(origin, orientation, RayCastParams)

    
end

--wip

function ShootTypes.Step(Tool, Bullet: any?, speed, lifetime)
    --Will shoot from plr's head (for now)
    if not speed then
        speed = 16
    end
    if not lifetime then
        lifetime = 30
    end

    Events.ShootTypes.Step:Fire(Bullet, speed, lifetime)
    -- Bullet:SetAttribute("Owner", )
    -- Bullet:SetAttribute("Speed", speed)
    -- Bullet:SetAttribute("LifeTime", lifetime)
    -- Debris:AddItem(Bullet, lifetime)
end

function ShootTypes.RobloxProjectile()
    -- body
end

--[[ smelly code!!!
ShootTypes.Functions = {
    {["ShootType"] = "Step", ["Function"] = Step},
}
]]
return ShootTypes