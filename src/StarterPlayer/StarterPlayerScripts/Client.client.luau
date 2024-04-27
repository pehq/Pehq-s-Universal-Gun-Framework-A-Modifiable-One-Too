local Players = game:GetService("Players") --HAHAHAW
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Viewmodels = ReplicatedStorage.Pagfam12ReplicatedStorage.Viewmodels
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local ContextActionService = game:GetService("ContextActionService")

--in-scope variables
local lastViewmodel = nil
local ConnectionsToDisconnectOnUnequip = {}
local LocalTransparencyModifierContainer = {}

local function ChangeLocalTransparancyOfModelBasedOnFP(model)
    for i, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            if character.Head.LocalTransparencyModifier == 1 then --fully transparent
                v.LocalTransparencyModifier = 0 --Makes it visible while preserving base transparency
            else
               v.LocalTransparencyModifier = 1 
            end
        end
    end
end

local function SetCharacterLocalTransparency()
	for i, v in pairs(LocalTransparencyModifierContainer) do
		v.LocalTransparencyModifier = 0
	end
end

local function CreateModelViewmodel(viewmodel: Model, gunanim)
    viewmodel.Parent = cam

    local ViewmodelOffest = gunanim.ViewmodelOffest ~= nil and gunanim.ViewmodelOffest or CFrame.new(0,0,0)

    local function RenderBeforeCamera(dt)
		viewmodel.HumanoidRootPart.CFrame = cam.CFrame * ViewmodelOffest
    end
	
	local FPVisibility
	FPVisibility = character.Head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function() --check if player is in first person by seeing if the head becomes transparent
        ChangeLocalTransparancyOfModelBasedOnFP(viewmodel)
	end)
	
	--Collisions
	for _, v:BasePart in pairs(viewmodel:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.CollisionGroup = "ViewmodelCollisions"
		end
	end

	ChangeLocalTransparancyOfModelBasedOnFP(viewmodel)

	table.insert(ConnectionsToDisconnectOnUnequip, RunService.RenderStepped:Connect(RenderBeforeCamera))
	table.insert(ConnectionsToDisconnectOnUnequip, FPVisibility)
end


local function onGunEquip(child:Model)
    if not child:GetAttribute("PAGFAM12") then --Returns if it doesn't have PAGFAM12 property or if it's false
        return
    end

    local SavedCameraMode = player.CameraMode

	local GunData = require(child.PagfamGunData)
	local GunAnim = require(child.PagfamGunAnimations)
	local GunActions = require(child.PagfamGunActions)
	
	local GunModelClient:Model = GunData.ClientGunModel:Clone()
	local CharGunModel = character:WaitForChild(GunData.ServerGunModel.Name)
	
    --initialize data
    if GunData.CameraMode then
        player.CameraMode = GunData.CameraMode
	end
	
	for _, v:Instance in pairs(character:GetChildren()) do --filters out all accessories
		if v:IsA("Accessory") then
			for _, vParts in pairs(v:GetChildren()) do
				if vParts:IsA("BasePart") then
					vParts.CanQuery = false
				end
			end
		end
	end

    --create viewmodel
    local curViewmodel:Model = nil
    if GunData.ViewmodelEnabled == true then
        if GunData.FPViewmodelType == "Viewmodel" then
            curViewmodel = Viewmodels[GunData.ViewmodelName]:Clone()
			CreateModelViewmodel(curViewmodel, GunAnim)
			
			--Attach gun to viewmodel
			
			local Motor6D:Motor6D = Instance.new("Motor6D")
			Motor6D.Part0 = GunModelClient.PrimaryPart
			Motor6D.Part1 = curViewmodel.PrimaryPart
			Motor6D.Parent = GunModelClient.PrimaryPart
			
			Motor6D.C1 = GunData.ClientGunModelHandleOffset
			
			GunModelClient.Parent = curViewmodel
			
			ChangeLocalTransparancyOfModelBasedOnFP(curViewmodel)

			
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
			for i, v in pairs(CharGunModel:GetDescendants()) do
				if v:IsA("BasePart") then
					table.insert(LocalTransparencyModifierContainer, v)
				end
			end
			for i, v in pairs(character:GetChildren()) do
				if v:IsA("BasePart") and table.find(GunData.BodyPartsToShowInFPS, v.Name) ~= nil then
					table.insert(LocalTransparencyModifierContainer, v)
				end
			end
			
			local ViewmodelShow
			ViewmodelShow = RunService.RenderStepped:Connect(function(dt)
				SetCharacterLocalTransparency()
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

character.ChildAdded:Connect(onGunEquip)