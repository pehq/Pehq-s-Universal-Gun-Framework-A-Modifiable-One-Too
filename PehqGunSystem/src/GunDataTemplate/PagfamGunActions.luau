local UserInputService = game:GetService("UserInputService")
local Tool = script.Parent
local PagfamAnimData = require(Tool.PagfamAnimData)
local PagfamGunData = require(Tool.PagfamGunData)
local Actions = {}

--TODO: let keybinds to be changed
Actions.Keybinds = {
    ["Mouse1"] = "Shoot"
} 

--functions called by client
function Actions.Equip(actionName, actionName, inputState, inputObject)
    -- body
    print("Equipped")
end

function Actions.UnEquip(actionName, actionName, inputState, inputObject)

end

--Functions binded by keybinds using ContextActionService. These functions will be called through another script
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
    {["Action"] = "Shoot", ["Function"] = Shoot},
    {["Action"] = "Reload", ["Function"] = Reload},
    
}

return Actions