local Players = game:GetService("Players") --HAHAHAW
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Pugfam12RE.Modules
local Viewmodels = ReplicatedStorage.Pugfam12RE.Viewmodels
local Events = ReplicatedStorage.Pugfam12RE.RemoteEvents
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local ContextActionService = game:GetService("ContextActionService")

local ClientShootType = require(Modules.ClientShootType)

--in-scope variables
local lastViewmodel = nil
local ConnectionsToDisconnectOnUnequip = {}
local LocalTransparencyModifierContainer = {}


local function SetLocalTransparency()
	for i, v in pairs(LocalTransparencyModifierContainer) do
		v.LocalTransparencyModifier = 0
	end
end

local function CreateModelViewmodel(viewmodel: Model, gunanim)
    
end

local function onGunEquip(child:Tool)
    if not child:GetAttribute("Pugfam12") then --Returns if it doesn't have PAGFAM12 property or if it's false
        return
	end
	
	print("Added")

	local Data = child.Data
	local GunData = require(Data.PugfamData)
	local GunAnim = require(Data.PugfamAnims)
	local GunActions = require(Data.PugfamActs)
	
	--initialize data
	local SavedCameraMode = player.CameraMode
    if GunData.CameraMode then
        player.CameraMode = GunData.CameraMode
	end
	
	if GunData.FilterAccessories == true then  --filters out all accessories
		for _, v:Instance in pairs(character:GetChildren()) do
			if v:IsA("Accessory") then
				for _, vParts in pairs(v:GetChildren()) do
					if vParts:IsA("BasePart") then
						vParts.CanQuery = false
					end
				end
			end
		end
	end
	
	if GunData.FilterLocalChar then --filters the plrs char
		for i, v:Instance in pairs(character:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanQuery = false
			end
		end
	end
	
	local ViewmodelGun:Model = GunData.ViewmodelGunModel:Clone()

    --create viewmodel
    local curViewmodel:Model = nil
    if GunData.ViewmodelEnabled == true then
		if GunData.FPViewmodelType == "Viewmodel" then
			--Create Viewmodel
			curViewmodel = Viewmodels[GunData.ViewmodelName]:Clone()
			
			curViewmodel.Parent = cam

			local ViewmodelOffest = GunAnim.ViewmodelOffest or CFrame.new(0,0,0)

			local function RenderBeforeCamera(dt)
				curViewmodel.HumanoidRootPart.CFrame = cam.CFrame * ViewmodelOffest
			end

			--Collisions
			for _, v:BasePart in pairs(curViewmodel:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
					v.CollisionGroup = "ViewmodelCollisions"
				end
			end

			table.insert(ConnectionsToDisconnectOnUnequip, RunService.RenderStepped:Connect(RenderBeforeCamera))
			
			--Attach gun to viewmodel
			local Motor6D:Motor6D = Instance.new("Motor6D")
			Motor6D.Part0 = ViewmodelGun.PrimaryPart
			Motor6D.Part1 = curViewmodel.PrimaryPart
			Motor6D.Parent = ViewmodelGun.PrimaryPart
			
			Motor6D.C1 = GunData.ClientGunModelHandleOffset
			
			ViewmodelGun.Parent = curViewmodel

			if GunData.ApplyHumanoidDescriptionToViewmodel == true then --TODO: Rehaul this
				local Humanoid:Humanoid = curViewmodel:FindFirstChild("Humanoid")
				
				local PlrHumanDesc = Players:GetHumanoidDescriptionFromUserId(player.UserId)
				
				local HumanDesc = Instance.new("HumanoidDescription")
				HumanDesc.Shirt = PlrHumanDesc.Shirt
				HumanDesc.RightArm = PlrHumanDesc.RightArm
				HumanDesc.LeftArm = PlrHumanDesc.LeftArm
				
				Humanoid:ApplyDescription(HumanDesc)
			end
			
			
		elseif GunData.FPViewmodelType == "Roblox" then
			
			for i, v in pairs(character:GetChildren()) do
				if v:IsA("BasePart") and table.find(GunData.BodyPartsToShowInFPS, v.Name) ~= nil then
					table.insert(LocalTransparencyModifierContainer, v)
				end
			end
			
			local ViewmodelShow
			ViewmodelShow = RunService.RenderStepped:Connect(function(dt)
				SetLocalTransparency()
			end)
			
			table.insert(ConnectionsToDisconnectOnUnequip, ViewmodelShow)
		end 
	end
    
    GunActions.Equip() --Run equip
    
    --Bind Actions
    for _, ActionValues in pairs(GunActions.ContextActions) do
        ContextActionService:BindActionAtPriority(ActionValues.actionName, ActionValues.functionToBind, (ActionValues.MobileButtons ~= nil and ActionValues.MobileButtons.createTouchButton == true) and true or false, ActionValues.priorityLevel, table.unpack(ActionValues.inputTypes))
        if ActionValues.MobileButtons ~= nil then --if THE MOBILE SUPPORT IS REAAAALLLLL
            --Mobile base info
            local MobileButtons = ActionValues.MobileButtons
            ContextActionService:SetDescription(ActionValues.actionName, MobileButtons.description ~= nil and MobileButtons.description or "")
            ContextActionService:SetTitle(ActionValues.actionName, MobileButtons.title ~= nil and MobileButtons.title or "")
            ContextActionService:SetImage(ActionValues.actionName, MobileButtons.image ~= nil and MobileButtons.image or nil)
            if MobileButtons.position ~= nil then --using if statement here because position has a default value idk of
				ContextActionService:SetPosition(ActionValues.actionName, UDim2.new(table.unpack(MobileButtons.position)))
            end
        end
	end
	
    --Run additional functions
	print(GunActions)
	if GunActions.AdditionalFunctions ~= nil then
        for _, v in pairs(GunActions.AdditionalFunctions) do
            v()
        end
    end

    local removing
    removing = character.ChildRemoved:Connect(function(childremoved)
		if child ~= childremoved then return end
		
		print("Removed")

        player.CameraMode = SavedCameraMode

        GunActions.UnEquip()
        
        for _, v in pairs(ConnectionsToDisconnectOnUnequip) do
            v:Disconnect()
        end

        for _, ActionValues in pairs(GunActions.ContextActions) do
            ContextActionService:UnbindAction(ActionValues.actionName)
        end
		
        GunData = nil
		GunAnim = nil
		GunActions = nil
		
        if curViewmodel then
            if curViewmodel then
                if lastViewmodel then
                    lastViewmodel:Destroy()
                end
                lastViewmodel = curViewmodel:Clone()
                curViewmodel:Destroy()
            end
		end
		
        removing:Disconnect()
    end)
end

local ToolAdded
ToolAdded = character.ChildAdded:Connect(onGunEquip)

player.CharacterAdded:Connect(function(character)
	ToolAdded = character.ChildAdded:Connect(onGunEquip)
end)


player.CharacterRemoving:Connect(function(char)
	ToolAdded:Disconnect()
end)

for i, v in pairs(ClientShootType.EventShoots) do
	v() --set up events
end

--Client Shoot types
for i, v in pairs(ClientShootType.EventShoots) do
	v()
end