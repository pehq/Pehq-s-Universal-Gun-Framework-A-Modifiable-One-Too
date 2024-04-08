--Pehq's Amazing Gun Framework, A Moddable 1
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--ShootTypes


--when plr joins
local gunEquippedConnections = {}
Players.PlayerAdded:Connect(function(plr)
    local char = plr.Character or plr.CharacterAdded:Wait()

    --Gun equipped
    char.ChildAdded:Connect(function(child)
        if not child:IsA("Tool") or not child:GetAttribute("PAGFAM12") then
            return
        end

        local GunData = require(child.PagfamGunData)
        local GunAnim = require(child.PagfamAnimData)

        for i, v in pairs(child:GetDescendants()) do --Unanchors all parts
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end

        --Attach gun to character
        local CharGunMotor6D = Instance.new("Motor6D")
        CharGunMotor6D.Part0 = Character.Humanoid.RigType == Enum.HumanoidRigTypeR15 and GunAnim.ServerCharGunWeldR15 or Character.Humanoid.RigType == Enum.HumanoidRigTypeR6 and GunAnim.ServerCharGunWeldR6 or error("Unknown Humanoid Rig Type")
        CharGunMotor6D.Part1 = child[GunAnim.ServerGunPartMotor6d]
        CharGunMotor6D.Parent = child[GunAnim.ServerGunPartMotor6d]

        -- TODO:Add #1 to client script

    end)    
end)