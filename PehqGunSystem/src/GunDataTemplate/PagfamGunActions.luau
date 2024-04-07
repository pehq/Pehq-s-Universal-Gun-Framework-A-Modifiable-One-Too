local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShootTypes = require(ReplicatedStorage.Modules.ShootTypes)
local Tool = script.Parent
local PagfamAnimData = require(Tool.PagfamAnimData)
local PagfamGunData = require(Tool.PagfamGunData)
local Actions = {}

--functions called by the framework, they are called by name 
local ConnectionsToDisconnectOnUnequip = {}

function Actions.Equip()
    print("Equipped")
end

function Actions.UnEquip()
    for i, v in pairs(ConnectionsToDisconnectOnUnequip) do
        v:Disconnect()
    end
end

--Additional functions that will run after contextactionservice finishes setting up keybinds, could be used for events
function Actions.AdditionalFunctions.Something()

end

--Functions binded by keybinds using ContextActionService. These functions will be called through another script.
local function Shoot(actionName, inputState, inputObject)
    if actionName ~= "Shoot" then
        return
    end
    
end

local function Reload(actionName, inputState, inputObject)
    if actionName ~= "Reload" then
        return
    end
    
end

local function Aim(actionName, inputState, inputObject)
    if actionName ~= "Aim" then
        return
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
        }
        ["priorityLevel"] = 2000,
        ["MobileButtons"] = { --Mobile support, you can set this to nil if you don't want to implement mobile support
            ["createTouchButton"] = true,
            ["stackOrder"] = 1,
            ["description"] = "Shoot the gun" --literally does nothing Rofl
            ["title"] = "Shoot",
            ["image"] = "" --rbxassetid//00000000
            ["position"] = Udim2.new(1, -20, 0.2, 0) --shoot button position. Set it to nil for the default position (idk what position, im scripting from vscode)
        }
    },
    {
        ["actionName"] = "Reload",
        ["functionToBind"] = Reload,
        ["inputTypes"] = { 
            Enum.KeyCode.R,
            Enum.KeyCode.ButtonX,
        }
        ["priorityLevel"] = 2000,
        ["MobileButtons"] = { 
            ["createTouchButton"] = true,
            ["stackOrder"] = 1,
            ["description"] = "Reload the gun",
            ["title"] = "Reload",
            ["image"] = "",
            ["position"] = Udim2.new(1, -20, 0.4, 0),
        }
    },
    {
        ["actionName"] = "Aim",
        ["functionToBind"] = Aim,
        ["inputTypes"] = { 
            Enum.UserInputType.MouseButton2,
            Enum.KeyCode.ButtonL2,
        }
        ["priorityLevel"] = 2000,
        ["MobileButtons"] = { 
            ["createTouchButton"] = true,
            ["stackOrder"] = 1,
            ["description"] = "Aim the gun",
            ["title"] = "Aim",
            ["image"] = "",
            ["position"] = Udim2.new(1, -20, 0.6, 0),
        }
    },
    {
        ["actionName"] = "Emote",
        ["functionToBind"] = Shoot,
        ["inputTypes"] = { 
            Enum.UserInputType.MouseButton1,
            Enum.KeyCode.ButtonR2,
        }
        ["priorityLevel"] = 2000,
        ["MobileButtons"] = { 
            ["createTouchButton"] = true,
            ["stackOrder"] = 1,
            ["description"] = "Shoot the gun", 
            ["title"] = "Shoot",
            ["image"] = "",
            ["position"] = Udim2.new(1, -20, 0.8, 0), 
        }
    },
    
    
}

return Actions