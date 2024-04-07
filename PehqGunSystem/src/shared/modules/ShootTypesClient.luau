local ShootTypes = {}
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.RemoteEvents
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--Note: stuff goes through the client first so client --> Server --> all clients

local function HitScan(mouse: Mouse) --hitscan uses mouse

end

--wip

local function Step(Bullet: any?, speed, lifetime)
    --Will shoot from plr's head
    if not speed then
        speed = 16
    end
    if not lifetime then
        lifetime = 30
    end

    Events.ShootTypes.Step:Fire(Bullet, Speed, LifeTime)
    -- Bullet:SetAttribute("Owner", )
    -- Bullet:SetAttribute("Speed", speed)
    -- Bullet:SetAttribute("LifeTime", lifetime)
    -- Debris:AddItem(Bullet, lifetime)
end

local function ShootTypes.RobloxProjectile()
    -- body
end

ShootTypes.Functions = {
    {["ShootType"] = "Step", ["Function"] = Step},
}

return ShootType