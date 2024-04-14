--Shoot types will be called by fire types
local ShootTypes = {}

local Players = game:GetService("Players") --haha
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Pagfam12ReplicatedStorage.Modules
local Events = ReplicatedStorage.Pagfam12ReplicatedStorage.RemoteEvents
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local function CreateHitMarker(plr:Player, hitData:table)
    local owner = Instance.new("ObjectValue")
    owner.Value = plr
    owner.Name = "owner"
    
    local Hit = Instance.new("StringValue")
    Hit.Name = "PagfamHit"
    Hit.Value = HttpService:JSONEncode(hitData)

    return owner, Hit
end

function ShootTypes.Step(plr, Tool, TargetPos:Vector3)
    local GunData = require(Tool.PagfamGunData)
	
    local Bullet = GunData.Bullet:Clone()

    Bullet:SetAttribute("Owner", plr)
    Bullet:SetAttribute("Speed", GunData.BulletSpeed)
    Bullet:SetAttribute("LifeTime", GunData.BulletLifeTime)
    Debris:AddItem(Bullet, GunData.BulletLifeTime)
    
    Bullet.Parent = workspace

    local StepBulletSpeed = GunData.BulletSpeed * -1
    local SpeedChange
    SpeedChange = Bullet.AttributeChanged:Connect(function(attributename) --detect when the speed is changed
        if attributename ~= "Speed" then
            return
        end
        
        StepBulletSpeed = Bullet:GetAttribute("Speed") * -1
    end)

    local StartCFrame = CFrame.lookAt(GunData.BulletBase.Position, TargetPos) --wowo ezz...!

    local lastPos = StartCFrame.Position

    local function CheckForCollisions(startPos) :RaycastResult --TODO: Add shapecasting to Shoot type step
        local RaycastParams = RaycastParams.new(GunData.RaycastPartFilter, Enum.RaycastFilterType.Exclude, GunData.FilterWater)


        local Result:RaycastResult = workspace:Raycast(startPos, lastPos - startPos, RaycastParams)

        return Result
    end

    local RenderStep
    if Bullet:IsA("BasePart") then
        Bullet.CFrame = StartCFrame
        local NewPos = Bullet.CFrame.Position

        RenderStep = RunService.RenderStepped:Connect(function(deltaTime)
            lastPos = Bullet.CFrame.Position
            Bullet.CFrame *= CFrame.new(0, 0, StepBulletSpeed * deltaTime)
                
            local result = CheckForCollisions(NewPos)
        end)
    elseif Bullet:IsA("Model") then
        Bullet:PivotTo(StartCFrame)
        local NewPos = Bullet:GetPivot().Position
        RenderStep = RunService.RenderStepped:Connect(function(deltaTime)
            lastPos = Bullet.CFrame.Position
            Bullet:PivotTo(Bullet:GetPivot() * CFrame.new(0, 0, StepBulletSpeed * deltaTime))
            NewPos = Bullet:GetPivot().Position
            
            local result = CheckForCollisions(NewPos)
            if result ~= nil then
                
            end
        end)
    end

    local RenderStep
    RenderStep = RunService.RenderStepped:Connect(function(deltaTime)
        
    end)

    --[[
    local function createBullet()
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
        end)
    end
    
    local function StepBulletsRemoved(obj) --Finds obj by Instance.UniqueId
        if StepConnections[obj] then
            StepConnections[obj]:Disconnect()
            StepConnections[obj] = nil
        end
    end
    
    CollectionService:GetInstanceAddedSignal("StepBullets"):Connect(StepBulletsAdded)
    CollectionService:GetInstanceRemovedSignal("StepBullets"):Connect(StepBulletsRemoved)]]
end

function ShootTypes.Hitscan(plr, Tool, Target:Vector3) --rcl, uses special bullets where it connects at two different positions but also will directly raycast at the target
    local GunData = require(Tool.PagfamGunData)
    local Start:Vector3 = GunData.BulletBase.Position

    local Orientation = (Target - Start).Unit --returns orientation, it's being recycled for recasting the ray on the server since the target position came from the client and time has passed.

    local RaycastParams = RaycastParams.new(GunData.RaycastPartFilter, Enum.RaycastFilterType.Exclude, GunData.FilterWater)

    local Result:RaycastResult = workspace:Raycast(Start, Orientation * GunData.RayLength, RaycastParams)

    
end

return ShootTypes