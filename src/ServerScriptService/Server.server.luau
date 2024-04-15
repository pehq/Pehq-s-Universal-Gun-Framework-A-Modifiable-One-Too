--Pehq's Amazing Gun Framework, A Moddable 1
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Pagfam12ReplicatedStorage.Modules
local ServerModules = ServerScriptService.ServerModules
local FireTypes = require(ServerModules.FireTypes)
local ShootTypes = require(ServerModules.ShootTypes)
local PhysicsService = game:GetService("PhysicsService")
local ActionHandler

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

	local ActionEvent = Instance.new("RemoteEvent") --when action is committed
	ActionEvent.Name = "Action"
	ActionEvent.Parent = RemoteEventsContainer

	local UpdateEvent = Instance.new("RemoteEvent") --when the action committed needs to be updated (like mouse pos)
	UpdateEvent.Name = "Update"
	UpdateEvent.Parent = RemoteEventsContainer


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

        for _, v in pairs(child:GetDescendants()) do --Unanchors all parts
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end

        --TODO: Attach gun to character


		-- TODO:Add #1 to client script
		
		local ActionEvent

		ActionEvent = PlayerData.RemoteEvents.Action.OnClientEvent:Connect(function(eventplr, actionName, actionProperties)
			if plr ~= eventplr then
				return 
			end

			

			PlayerData.RemoteEvents.Update.OnClientEvent:Connect(function(updateplr, updateactionname, updateactionProperties)
				if plr ~= updateplr or actionName ~= updateactionname then
					return
				end

				for prop, v in pairs(updateactionProperties) do
					actionProperties[prop] = v
				end
			end)
		end)
		
		local ToolUnequip
		ToolUnequip = char.ChildRemoved:Connect(function()
			if child ~= ToolUnequip then
				return
			end
			ActionEvent:Disconnect()
			ToolEquipped:Disconnect()
			ToolUnequip:Disconnect()
		end)
    end)
end)