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
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local ServerStorage = game:GetService("ServerStorage")
-- local ActionHandler --why does this exists? (I think it might have something to do with the ActionLog variable)

PhysicsService:RegisterCollisionGroup("ViewmodelCollisions") --Test tsktsk

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

--Player Join Function
local function PlrAdded(plr)
	createPlrContainer(plr)
	plr.CharacterAdded:Connect(function(char)
		
		for _, v:Instance in pairs(char:GetChildren()) do --filters out all accessories
			if v:IsA("Accessory") then
				for _, vParts in pairs(v:GetChildren()) do
					if vParts:IsA("BasePart") then
						vParts.CanQuery = false
					end
				end
			end
		end
		
		
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
			local GunModel:Model = GunData.ServerGunModel:Clone()
			
			local Motor6D:Motor6D = Instance.new("Motor6D")
			Motor6D.Name = "BodyAttach"
			Motor6D.Part1 = GunModel.PrimaryPart
			
			for i, v in pairs(GunData.CharacterHandleAttachPart) do --attach to bodypart, will cycle parts if it didn't find the target part
				if not char:FindFirstChild(v) then
					continue
				end
				
				Motor6D.Part0 = char[v]
				
				print(char[v])
				
				Motor6D.Parent = char[v]
				break
			end
			
			

			GunModel.Parent = char
			
			--animate
			local tmpId = KeyframeSequenceProvider:RegisterKeyframeSequence(ServerStorage.RBX_ANIMSAVES.Rig.idle)
			local Animator:Animator = char.Humanoid.Animator
			local Amination = Instance.new("Animation")
			Amination.AnimationId = tmpId
			local AnimationTrack = Animator:LoadAnimation(Amination)
			AnimationTrack:Play()

			-- TODO:Add #1 to client script 

			local ActionLog = {}

			local ActionEvent
			ActionEvent = PlayerData.RemoteEvents.Action.OnServerEvent:Connect(function(eventplr, actionName, actionProperties, FireTypeProp)
				if plr ~= eventplr then
					return 
				end
				
				print(actionProperties)
				
				if actionProperties then
					for i, v in pairs(actionProperties) do
						ActionLog[i] = v
					end	
				end


				if GunData.FireType and GunData.ShootType then
					FireTypes[GunData.FireType](GunData.ShootType, {plr, child, ActionLog}, FireTypeProp)
				end

				--ShootTypes[actionProperties.ShootType](plr, child, actionProperties.TargetPos)
			end)

			local UpdateEvent
			UpdateEvent = PlayerData.RemoteEvents.Update.OnServerEvent:Connect(function(eventplr, updateactionname, updateactionProperties)
				if plr ~= eventplr then
					return
				end

				ActionLog[updateactionname] = updateactionProperties
			end)

			local ToolUnequip
			ToolUnequip = char.ChildRemoved:Connect(function()
				if child ~= ToolUnequip then
					return
				end


				AnimationTrack:Stop()
				print("Removed")
				ActionEvent:Disconnect()
				UpdateEvent:Disconnect()
				ToolEquipped:Disconnect()
				ToolUnequip:Disconnect()
			end)
		end)

		local charRemoved
		charRemoved = plr.CharacterRemoving:Connect(function(char)
			
			ToolEquipped:Disconnect()
			charRemoved:Disconnect()
		end)
	end)
end

--when plr joins

Players.PlayerAdded:Connect(PlrAdded)