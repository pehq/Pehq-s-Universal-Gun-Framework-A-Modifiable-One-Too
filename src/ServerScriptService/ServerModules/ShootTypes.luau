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
	Debris:AddItem(Bullet, GunData.BulletLifetime)

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
			local owner, hitmarker = CreateHitMarker(plr, {plr.Name, ["Distance"] = Result.Distance})
			owner.Parent = Result.Instance
			hitmarker.Parent = Result.Instance
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

function ShootTypes.RCL(plr, Tool:Tool, Prop) --rcl, uses special bullets where it connects at two different positions but also will directly raycast at the target
    local GunData = require(Tool.PagfamGunData)
	local Start:Vector3 = Tool.Parent.Head.Position
	local Target = Prop.TargetPos
	
	local RayLength = GunData.RayLength

    local Orientation = (Target - Start).Unit --returns orientation, it's being recycled for recasting the ray on the server since the target position came from the client and time has passed.

	local RaycastParamsThing = RaycastParams.new({GunData.RaycastPartFilter, plr.Character}, Enum.RaycastFilterType.Exclude, GunData.FilterWater)
	

	local Result:RaycastResult = workspace:Raycast(Start, Orientation * RayLength, RaycastParamsThing)
	
	print(Result)
	print(Result.Instance)
	
	if Result ~= nil then
		RayLength = (Start - Result.Position).Magnitude
	end
	
	if Result.Instance:IsA("BasePart") and Result.Instance.Parent:FindFirstChild("Humanoid") then --If part hit is a character limb
		local owner, hitmarker = CreateHitMarker(plr, {plr.Name, ["Distance"] = Result.Distance})
		owner.Parent = Result.Instance
		hitmarker.Parent = Result.Instance
	end
	
	--Now create the laser
	local Bullet:BasePart = GunData.Bullet:Clone()
	
	if not Bullet:IsA("BasePart") then
		Bullet:Destroy()
		error("Bullet isn't a BasePart, this shoottype only accepts BaseParts as a bullet")
	end
	
	Bullet.Size = Vector3.new(Bullet.Size.X, Bullet.Size.Y, RayLength)
	Bullet.PivotOffset = CFrame.new(0, 0, RayLength/2)
	Bullet:PivotTo(CFrame.new(Start) * CFrame.lookAt(Start, Orientation, Vector3.new(0,1,0)))
	Bullet.Color = plr.Team and plr.TeamColor.Color or Color3.new(1,1,1)
	
	Bullet.Parent = workspace
	
	Debris:AddItem(Bullet, GunData.BulletLifetime)
end

function ShootTypes.Raycast(plr, Tool, Target) --Acs, bullet follows a ray
    
end

function ShootTypes.Projectile(plr, Tool, Start) --Creates a projectile

end

return ShootTypes