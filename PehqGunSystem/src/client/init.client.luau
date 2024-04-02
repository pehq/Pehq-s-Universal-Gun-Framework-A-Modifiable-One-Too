local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Modules
local Viewmodels = ReplicatedStorage.Viewmodels
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera

local function onGunEquip(child)
    if not child:FindFirstChild("PehqGun") or child.PehqGun.Value == false then --Returns if not a gun
        return
    end

    local gunData = require(child.PehqGunData)
    local gunAnim = require(child.PehqAnimData)

    local curViewmodel:Model = Viewmodels:FindFirstChild(gunData.Viewmodel):Clone()

    curViewmodel.Parent = cam

    local function RenderBeforeCamera(delta)
        curViewmodel.PrimaryPart.CFrame = cam.CFrame * gunAnim.Offset
    end

    RunService:BindToRenderStep("PehqGunBeforeCamera", Enum.RenderPriority.Camera.Value - 1, RenderBeforeCamera)

    local removing
    removing = character.ChildRemoved:Connect(function(childremoved)
        if child ~= childremoved then return end
        
        gunData = nil
        gunAnim = nil
        curViewmodel:Destroy()
        removing:Disconnect()
    end)
end

character.ChildAdded:connect(onGunEquip)