local Data = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Basic data
DataGunName = "Pistol"

--Model (if paths are nil then it'll attempt to use the gunname)
Data.ServerGunModel = nil --TODO
Data.ClientGunModel = nil --TODO
Data.ViewmodelName = "Roblox"
Data.Actions = nil --TODO
Data.Bullet = nil --TODO
Data.CameraMode = Enum.CameraMode.LockFirstPerson

--Viewmodel
Data.ViewmodelEnabled = false 
Data.FPViewmodelType = "Viewmodel" --Either a "Viewmodel" or the "Roblox"'s character. The custom Viewmodel requires it's own animation on the client while Roblox could let you reuse animations run on the  leave blank if you don't want a viewmodel
Data.BodyPartsToShowInFPS = {"LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm"} --Enter both R6 and R15 parts, will apply nevertheless

--Mouse
Data.CustomMouseIcon = false
Data.MouseIconType = "Image" --Either an Image or Gui

--Cross-Platform Support (PC support is the base that these platforms will be built on (obviously))
Data.MobileSupport = false
Data.ConsoleSupport = false
Data.VRSupport = false

return Data