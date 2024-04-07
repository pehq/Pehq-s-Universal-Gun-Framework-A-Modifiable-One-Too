local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local Mouse = player:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Modules
local Viewmodels = ReplicatedStorage.Viewmodels
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

--in-scope variables
local lastViewmodel = nil
local ConnectionsToDisconnectOnUnequip = {}

local function ChangeLocalTransparancyOfModelBasedOnFP(model)
    for i, v in pairs(viewmodel:GetDescendants()) do
        if v:IsA("BasePart") then
            if character.Head.LocalTransparencyModifier == 1 then --fully transparent
                v.LocalTransparencyModifier = 0 --Makes it visible while preserving base transparency
            else
               v.LocalTransparencyModifier = 1 
            end
        end
    end
end

local function SetCharacterViewmodel(bodypartstoshowinfp) --TODO: #3 Make it so the arms move with the camera
    for i, v in pairs(bodypartstoshowinfp) do
        character[v].LocalTransparencyModifier = 0 --TODO: #2 test if character's limbs will be visisble on respawn
    end
end

local function CreateModelViewmodel(viewmodel: Model)
    viewmodel.Parent = cam

    local ViewmodelOffest = gunAnim.ViewmodelOffest ~= nil and gunAnim.ViewmodelOffest or CFrame.new(0,0,0)

    local function RenderBeforeCamera(delta)
        viewmodel.PrimaryPart.CFrame = cam.CFrame * ViewmodelOffest
    end

    character.Head:GetPropertyChangedSignal:Connect(function(property) --check if player is in first person by seeing if the head becomes transparent
        if property ~= "LocalTransparencyModifier" then
            return
        end

        ChangeLocalTransparancyOfModelBasedOnFP(viewmodel)
    end)

    RunService:BindToRenderStep("PUGFAM12ViewmodelRender", Enum.RenderPriority.Camera.Value - 1, RenderBeforeCamera)
end

local function onGunEquip(child)
    if not child:GetAttribute("PAGFAM12") then --Returns if it doesn't have PAGFAM12 property
        return
    end

    local GunData = require(child.PagfamGunData)
    local GunAnim = require(child.PagfamAnimData)
    local GunActions = require(child.PagfamGunActions)

    --create viewmodel
    if GunData.ViewmodelEnabled == true then
        if GunData.FPViewmodelType == "Viewmodel" then
            local curViewmodel = Viewmodels[gunData.ViewmodelName]:Clone()
            CreateModelViewmodel(curViewmodel)
        elseif gunData.FPViewmodelType == "Roblox" then
            SetCharacterViewmodel(GunData.BodyPartsToShowInFPS)
        end 
    end
    
    --Bind Actions
    for i, ActionValues in pairs(GunActions.ContextActions) do
        ContextActionService:BindActionAtPriority(ActionValues.actionName, ActionValues.functionToBind, ActionValues.MobileButtons ~= nil and ActionValues.MobileButtons.createTouchButton == true and true or false, ActionValues.priorityLevel, table.unpack(ActionValues.inputTypes))
        if ActionValues.MobileButtons ~= nil then --if THE MOBILE SUPPORT IS REAAAALLLLL
            --Mobile base info
            local MobileButtons = ActionValues.MobileButtons
            ContextActionService:SetDescription(ActionValues.actionName, MobileButtons.description ~= nil and MobileButtons.description or "")
            ContextActionService:SetTitle(ActionValues.actionName, MobileButtons.title ~= nil and MobileButtons.title or "")
            ContextActionService:SetImage(ActionValues.actionName, MobileButtons.image ~= nil and MobileButtons.image or nil)
            if MobileButtons.position ~= nil then --using if statement here because position has a default value idk of
                ContextActionService:SetPosition(ActionValues.actionName, MobileButtons.position)
            end
        end
    end

    local removing
    removing = character.ChildRemoved:Connect(function(childremoved)
        if child ~= childremoved then return end
        
        for i, v in pairs(ConnectionsToDisconnectOnUnequip) do
            v:Disconnect()
        end

        for i, ActionValues in pairs(GunActions.ContextActions) do
            ContextActionService:UnbindAction(ActionValues.actionName)
        end
        
        RunService:UnBindToRenderStep("PUGFAM12ViewmodelRender")
        gunData = nil
        gunAnim = nil
        curViewmodel:Destroy()
        removing:Disconnect()
    end)
end

character.ChildAdded:connect(onGunEquip)