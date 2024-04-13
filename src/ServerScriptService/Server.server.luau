--Pehq's Amazing Gun Framework, A Moddable 1
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Pagfam12ReplicatedStorage.Modules
local FireTypes = require(Modules.FireTypes)
local ShootTypes = require(Modules.ShootTypes)
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
	local ToolEquipped
    ToolEquipped = char.ChildAdded:Connect(function(child)
        if not child:IsA("Tool") or not child:GetAttribute("PAGFAM12") then
            return
		end
		
		local PlayerData = ReplicatedStorage.Pagfam12ReplicatedStorage.PlayerData[plr.UserId]

        local GunData = require(child.PagfamGunData)
		local GunAnim = require(child.PagfamGunAnimations)

        for i, v in pairs(child:GetDescendants()) do --Unanchors all parts
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end

        --TODO Attach gun to character


		-- TODO:Add #1 to client script
		
		--Shoot Event
		local ShootEvent 
		ShootEvent = PlayerData.RemoteEvents.Shoot.OnClientEvent:Connect(function(eventplr, FireType, ShootType, isHeld)
			if eventplr ~= plr then
				return
			end
			
			
			
		end)
		
		local ToolUnequip
		ToolUnequip = char.ChildRemoved:Connect(function()
			if child ~= ToolUnequip then
				return
			end
			ShootEvent:Disconnect()
			ToolEquipped:Disconnect()
			ToolUnequip:Disconnect()
		end)
    end)
end)