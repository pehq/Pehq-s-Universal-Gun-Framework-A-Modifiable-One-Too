local Data = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Basic data (or unsorted)
Data.GunName = "Pistol" --will use the gun name for default paths if the path isn't present
Data.ShootType = "Step" --Multiple shoot types, they are Step (the bullet Steps fowards), Hitscan (uses mouse.hit, good for rcl), Raycast (casts a ray and see what was hit)
Data.ShootOrigin = "Head" --from what part does the bullet spawn at. Will look for part in the character


--Model (if paths are nil then it'll attempt to use the gunname)
Data.ServerGunModel = nil --TODO
Data.ClientGunModel = nil --TODO
Data.Actions = nil --Testing Note: might remove
Data.Bullet = nil --TODO
Data.CameraMode = Enum.CameraMode.LockFirstPerson

--Animation
Data.ClientAnimationType = "Roblox" --Options include Roblox (Roblox animation from assetid), tweening (similar to acs, exists for acs port), MoonAnimator (Uses Moonlite), and Joint (Similar to how animations were done before animations were a thing)
Data.ServerAnimationType = "Roblox" --Options include Roblox and Joint. (Some options were excluded since they are incapable of running on the server)

--Viewmodel
Data.ViewmodelEnabled = false 
Data.FPViewmodelType = "Viewmodel" --Either a "Viewmodel" or the "Roblox"'s character. The custom Viewmodel requires it's own animation on the client while Roblox could let you reuse animations run on the  leave blank if you don't want a viewmodel
Data.ViewmodelName = "Roblox" --custom Viewmodel to look for in ReplicatedStorage. Will only work if FPViewmodelType is "Viewmodel"
Data.BodyPartsToShowInFPS = {"LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm", "LeftArm", "RightArm"} --Enter both R6 and R15 parts, will apply nevertheless

--Mouse
Data.CustomMouseIcon = false
Data.MouseIconType = "Image" --Either an Image or Gui
Data.MouseImageId = "" --If MouseIconType is an Image

--Cross-Platform Support (PC support is the base that these platforms will be built on (obviously))
Data.MobileSupport = false
Data.ConsoleSupport = false
Data.VRSupport = false

return Data