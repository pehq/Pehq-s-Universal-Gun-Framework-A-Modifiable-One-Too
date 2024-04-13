local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.RemoteEvents
local ShootTypes = require(ReplicatedStorage.Modules.ShootTypesClient)
local Tool = script.Parent
local PagfamAnimData = require(Tool.PagfamAnimData)
local PagfamGunData = require(Tool.PagfamGunData)
local Actions = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local Equipping = false
local FireRateCoolDown = false
local Reloading = false
local isAiming = false

local function CheckConditions()
    if Equipping == true or FireRateCoolDown == true or Reloading == true then
        return false
    end
    return true
end

--functions called by the framework, they are called by name 
local ConnectionsToDisconnectOnUnequip = {}

function Actions.Equip()
    Equipping = true
    task.wait(PagfamAnimData.EquipTime)
    Equipping = false
end

function Actions.UnEquip()
    for _, v in pairs(ConnectionsToDisconnectOnUnequip) do
        v:Disconnect()
    end
end

--Additional functions that will run after contextactionservice finishes setting up keybinds, could be used for events
function Actions.AdditionalFunctions.OnSit()
    local sitConnection
    sitConnection = character.Humanoid.Seated:Connect(function(active, currentSeatPart)
        sitConnection:Disconnect()
    end)
end

--Functions binded by keybinds using ContextActionService. These functions will be called through another script.
local MouseDown = false

local function Shoot(actionName, inputState, inputObject)
    if actionName ~= "Shoot" then
        return
    end

    --Semi (shoot once then let go)
    if inputState == Enum.UserInputState.Begin and CheckConditions() then
        FireRateCoolDown = true
        Events.ShootTypes.Step:FireServer(Tool, "Semi") --use remote function to yield?
        task.spawn(function()
            task.wait(PagfamGunData.Firerate)
            FireRateCoolDown = false
        end)
    end
    
    --Auto (continous shooting)
    if inputState == Enum.UserInputState.Begin and CheckConditions() then
        Events.ShootTypes.Step:FireServer(Tool, "Auto", true)
    elseif inputState == Enum.UserInputState.End then
        MouseDown = false
        Events.ShootTypes.Step:FireServer(Tool, "Auto", false)
        FireRateCoolDown = true
        task.spawn(function()
            task.wait(PagfamGunData.Firerate)
            FireRateCoolDown = false
        end)
    end

    --Burst (number of shots per trigger pulled)
    if inputState == Enum.UserInputState.Begin and CheckConditions() then
        FireRateCoolDown = true
        Events.ShootTypes.Step:FireServer(Tool, "Burst") --use remote function to yield?
        task.spawn(function()
            task.wait(PagfamGunData.Firerate)
            FireRateCoolDown = false
        end)
    end
end

local function Reload(actionName, inputState, inputObject)
    if actionName ~= "Reload" then
        return
    end
    local unequippedgun = false
    Reloading = true
    --Play anim

    local UnequipToolConnection
    unequippedgun = Tool.Unequipped:Connect(
        unequippedgun = true
    end)

    task.wait(PagfamGunData.ReloadTime)

    UnequipToolConnection:Disconnect()

    if PagfamGunData.OffHandReloading == true or not unequippedgun then
        --reload function
    end
end

local function Aim(actionName, inputState, inputObject)
    if actionName ~= "Aim" then
        return
    end

    if not isAiming then
        isAiming = true
    else

    end
end

local function Emote(actionName, inputState, inputObject)
    if actionName ~= "Emote" then
        return
    end

end


--Actions are done from the client
Actions.ContextActions = {
    {
        ["actionName"] = "Shoot",
        ["functionToBind"] = Shoot,
        ["inputTypes"] = { --Multiple keybinds, you can add controller support here
            Enum.UserInputType.MouseButton1,
            Enum.KeyCode.ButtonR2,
        },
        ["priorityLevel"] = 2000,
        ["MobileButtons"] = { --Mobile support, you can set this to nil if you don't want to implement mobile support
            ["createTouchButton"] = true,
            ["stackOrder"] = 1,
            ["description"] = "Shoot the gun", --literally does nothing Rofl
            ["title"] = "Shoot",
            ["image"] = "", --rbxassetid//00000000
            ["position"] = {-20, 1, 0.2, 0}, --shoot button position. Stored as Udim2.new(position) Set it to nil for the default position (idk what position, im scripting from vscode). 
        },
    },
    {
        ["actionName"] = "Reload",
        ["functionToBind"] = Reload,
        ["inputTypes"] = { 
            Enum.KeyCode.R,
            Enum.KeyCode.ButtonX,
        },
        ["priorityLevel"] = 2000,
        ["MobileButtons"] = { 
            ["createTouchButton"] = true,
            ["stackOrder"] = 1,
            ["description"] = "Reload the gun",
            ["title"] = "Reload",
            ["image"] = "",
            ["position"] = {1, -20, 0.4, 0},
        }
    },
    {
        ["actionName"] = "Aim",
        ["functionToBind"] = Aim,
        ["inputTypes"] = { 
            Enum.UserInputType.MouseButton2,
            Enum.KeyCode.ButtonL2,
        },
        ["priorityLevel"] = 2000,
        ["MobileButtons"] = { 
            ["createTouchButton"] = true,
            ["stackOrder"] = 1,
            ["description"] = "Aim the gun",
            ["title"] = "Aim",
            ["image"] = "",
            ["position"] = {1, -20, 0.6, 0},
        }
    },
    {
        ["actionName"] = "Emote",
        ["functionToBind"] = Shoot,
        ["inputTypes"] = { 
            Enum.UserInputType.MouseButton1,
            Enum.KeyCode.ButtonR2,
        },
        ["priorityLevel"] = 2000,
        ["MobileButtons"] = { 
            ["createTouchButton"] = true,
            ["stackOrder"] = 1,
            ["description"] = "Shoot the gun", 
            ["title"] = "Shoot",
            ["image"] = "",
            ["position"] = {1, -20, 0.8, 0}, 
        }
    },
    
    
}

return Actions