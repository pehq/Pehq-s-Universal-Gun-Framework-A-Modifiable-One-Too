--Pehq's Amazing Gun Framework, A Moddable 1
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function createPlrContainer(plr: Player) --Might store a template somewhere
    local container = Instance.new("Folder")
    container.Name = plr.UserId

    local settings = Instance.new("Folder") --Mutable values that could be changed from the server and read by the client
    settings.Name = "Settings"
    settings.Parent = container

    container.Parent = ReplicatedStorage.PlayerData

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
        local GunAnim = require(child.PagfamAnimData)

        for i, v in pairs(child:GetDescendants()) do --Unanchors all parts
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end

        --Attach gun to character
        local CharGunMotor6D = Instance.new("Motor6D")
        CharGunMotor6D.Part0 = char.Humanoid.RigType == Enum.HumanoidRigType.R15 and GunAnim.ServerCharGunWeldR15 or char.Humanoid.RigType == Enum.HumanoidRigType.R6 and GunAnim.ServerCharGunWeldR6 or error("Unknown Humanoid Rig Type")
        CharGunMotor6D.Part1 = child[GunAnim.ServerGunPartMotor6d]
        CharGunMotor6D.Parent = child[GunAnim.ServerGunPartMotor6d]

        -- TODO:Add #1 to client script

    end)    
end)