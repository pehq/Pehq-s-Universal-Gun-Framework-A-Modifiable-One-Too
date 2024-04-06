local ShootTypes = {}
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")

function ShootTypes.HitScan(mouse: Mouse) --hitscan uses mouse

end

function ShootTypes.RayCast(Start:Vector3, Direction:Vector3, RaycastParams: RaycastParams) 
    --wip
end

function ShootTypes.Step(Bullet: any?, Start: CFrame, speed, lifetime)
    --dist = speed * time so it's studs per second
    if not speed then
        speed = 16
    end
    if not lifetime then
        lifetime = 60
    end

    Bullet:SetAttribute("Speed", speed)
    Bullet:SetAttribute("LifeTime", lifetime)

    Debris:AddItem(Bullet, lifetime)
end

function ShootTypes.RobloxProjectile()
    -- body
end

return ShootType