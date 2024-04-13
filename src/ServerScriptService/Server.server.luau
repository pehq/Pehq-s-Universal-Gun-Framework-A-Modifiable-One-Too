--Pehq's Amazing Gun Framework, A Moddable 1
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")

PhysicsService:RegisterCollisionGroup("ViewmodelCollisions")

for _, v in pairs(PhysicsService:GetRegisteredCollisionGroups()) do
	if v.name ~= "ViewmodelCollisions" then
		PhysicsService:CollisionGroupSetCollidable(v.name, "ViewmodelCollisions", false)
	end
end

local function createPlrContainer(plr: Player) --Might store a template somewhere
    local container = Instance.new("Folder")
    container.Name = plr.UserId

    local settingsContainer = Instance.new("Folder") --Mutable values that could be changed from the server and read by the client
	settingsContainer.Name = "Settings"
	settingsContainer.Parent = container

	local RemoteEventsContainer = Instance.new("Folder")
	RemoteEventsContainer.Name = "RemoteEvents"
	RemoteEventsContainer.Parent = container

	local ShootEvent = Instance.new("RemoteEvent")
	ShootEvent.Name = "Shoot"
	ShootEvent.Parent = RemoteEventsContainer

    container.Parent = ReplicatedStorage.Pagfam12ReplicatedStorage.PlayerData

    return container
end

--ShootTypes


--when plr joins
local gunEquippedConnections = {}
Players.PlayerAdded:Connect(function(plr)
    createPlrContainer(plr)
    
    local char = plr.Character or plr.CharacterAdded:Wait()


    --Gun equipped
    char.ChildAdded:Connect(function(child)
        if not child:IsA("Tool") or not child:GetAttribute("PAGFAM12") then
            return
        end

        local GunData = require(child.PagfamGunData)
		local GunAnim = require(child.PagfamGunAnimations)

        for i, v in pairs(child:GetDescendants()) do --Unanchors all parts
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end

        --TODO Attach gun to character


        -- TODO:Add #1 to client script

    end)    
end)