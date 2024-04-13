--Shoot types will be called by fire types
local ShootTypes = {}

local Players = game:GetService("Players") --haha
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Pagfam12ReplicatedStorage.Modules
local Events = ReplicatedStorage.Pagfam12ReplicatedStorage.RemoteEvents
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local function Step(plr, Tool)
	
    local function createBullet()
        local GunData = require(Tool.PagfamGunData)
        local Bullet = GunData.Bullet:Clone()
        Bullet:SetAttribute("Owner", plr)
		Bullet:SetAttribute("Speed", GunData.BulletSpeed)
        Bullet:SetAttribute("LifeTime", GunData.BulletLifeTime)
		Debris:AddItem(Bullet, GunData.BulletLifeTime)

        Bullet.Parent = workspace

        CollectionService:AddTag("StepBullets")
    end

    createBullet()
    
    local StepConnections = {}

    local function StepBulletsAdded(obj)
        local StepBulletSpeed = obj:GetAttribute("Speed") * -1 --Multiplied by -1 here to save resources
        if obj:IsA("BasePart") then
            local LastCFrame = obj.CFrame
    
            StepConnections[obj] = RunService.Renderstepped:Connect(function(deltatime)
                obj.CFrame *= CFrame.new(0, 0, StepBulletSpeed) * deltatime
                LastCFrame = obj.CFrame
            end)
        elseif obj:IsA("Model") then
            local LastCFrame = obj:GetPivot()
    
            StepConnections[obj] = RunService.Renderstepped:Connect(function(deltatime)
                obj:TranslateBy(Vector3.new(0, 0, StepBulletSpeed) * deltatime)
                LastCFrame = obj.CFrame
            end)
        end
    end
    
    local function StepBulletsRemoved(obj) --Finds obj by Instance.UniqueId
        if StepConnections[obj] then
            StepConnections[obj]:Disconnect()
            StepConnections[obj] = nil
        end
    end
    
    CollectionService:GetInstanceAddedSignal("StepBullets"):Connect(StepBulletsAdded)
    CollectionService:GetInstanceRemovedSignal("StepBullets"):Connect(StepBulletsRemoved)
end


ShootTypes.Functions = {
    {["ShootType"] = "Step", ["Function"] = Step}
}

return ShootTypes