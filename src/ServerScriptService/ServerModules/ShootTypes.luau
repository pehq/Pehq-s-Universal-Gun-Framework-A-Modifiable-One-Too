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

--Step
function ShootTypes.Step(plr: Player, Tool, TargetPos:Vector3)
    local GunData = require(Tool.PagfamGunData)
	
	local Bullet:Instance = GunData.Bullet:Clone()
	Bullet.Parent = workspace

    --Bullet:SetAttribute("Owner", plr)
    Bullet:SetAttribute("Speed", GunData.BulletSpeed)
    Bullet:SetAttribute("LifeTime", GunData.BulletLifeTime)
    Debris:AddItem(Bullet, GunData.BulletLifeTime)

    local StepBulletSpeed = GunData.BulletSpeed * -1
    local SpeedChange
    SpeedChange = Bullet.AttributeChanged:Connect(function(attributename) --detect when the speed is changed
        if attributename ~= "Speed" then
            return
        end
        
        StepBulletSpeed = Bullet:GetAttribute("Speed") * -1
    end)

    local StartCFrame = CFrame.lookAt(plr.Character.Head.Position, TargetPos) --wowo ezz...!

    local lastPos = StartCFrame.Position

    local function CheckForCollisions(connection:RBXScriptConnection, startPos) :RaycastResult --TODO: Add shapecasting to Shoot type step
        local params = RaycastParams.new(GunData.RaycastPartFilter, Enum.RaycastFilterType.Exclude, GunData.FilterWater)
        
        local Result:RaycastResult = workspace:Raycast(startPos, lastPos - startPos, params)

        if not Result or plr == Players:GetPlayerFromCharacter(Result.Instance.Parent) or Result.Instance:FindFirstAncestor(plr.Name) then
            return
        end

		print("Hit ", Result.Instance)

        --This part runs when an object has been hit

        if Result.Instance:IsA("BasePart") and Result.Instance.Parent:FindFirstChild("Humanoid") then --If part hit is a character limb
            CreateHitMarker(plr, {["RaycastResult"] = Result})
        end

        Bullet:Destroy()
        connection:Disconnect()
    end

    local RenderStep
    if Bullet:IsA("BasePart") then
        Bullet.CFrame = StartCFrame

        RenderStep = RunService.Stepped:Connect(function(t, dt)
            lastPos = Bullet.CFrame.Position
            Bullet.CFrame *= CFrame.new(0, 0, StepBulletSpeed * dt)
                
            CheckForCollisions(RenderStep, Bullet.CFrame.Position)
        end)
    elseif Bullet:IsA("Model") then
        Bullet:PivotTo(StartCFrame)
        
		RenderStep = RunService.Stepped:Connect(function(t, dt)
			lastPos = Bullet:GetPivot().Position
            Bullet:PivotTo(Bullet:GetPivot() * CFrame.new(0, 0, StepBulletSpeed * dt))
            
            CheckForCollisions(RenderStep, Bullet:GetPivot().Position)
        end)
    end
end

function ShootTypes.Hitscan(plr, Tool, Target:Vector3) --rcl, uses special bullets where it connects at two different positions but also will directly raycast at the target
    local GunData = require(Tool.PagfamGunData)
    local Start:Vector3 = GunData.BulletBase.Position

    local Orientation = (Target - Start).Unit --returns orientation, it's being recycled for recasting the ray on the server since the target position came from the client and time has passed.

    local RaycastParams = RaycastParams.new(GunData.RaycastPartFilter, Enum.RaycastFilterType.Exclude, GunData.FilterWater)

    local Result:RaycastResult = workspace:Raycast(Start, Orientation * GunData.RayLength, RaycastParams)

end

function ShootTypes.Raycast(plr, Tool, Target) --Acs, bullet follows a ray
    
end

function ShootTypes.Projectile(plr, Tool, Start) --Creates a projectile

end

return ShootTypes