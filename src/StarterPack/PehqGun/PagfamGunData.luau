local Data = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Basic data (or unsorted)

Data.GunName = "Pistol" --will use the gun name for default paths if the path isn't present
Data.ShootType = "RCLServer" --Multiple shoot types, they are Step (the bullet Steps fowards), Hitscan (uses mouse.hit, good for rcl), Raycast (casts a ray and see what was hit)
Data.FireType = "Single" --Multiple fire types, they are Single (shoot once when trigger is pulled), Constant (keep shooting when trigger is held down), and Multi (shoot an amount when trigger is pulled)
Data.ShootOrigin = "Head" --from what part does the bullet spawn at. Will look for part in the character
Data.CameraMode = Enum.CameraMode.Classic
Data.Firerate = 0.1
Data.FireTypeMultiFirerate = 0.1 --time between shots if fire type is multi
Data.EquipTime = 1
Data.ReloadTime = 3
Data.OffHandReloading = false
Data.AimEnabled = true
Data.AimToggle = true --if false then aim will need to be held down
Data.AimDownSightTime = 0 --time it takes for player to be able to shoot after toggling aim

--Model (if paths are nil then it'll attempt to use the gunname)
Data.ServerGunModel = ReplicatedStorage.Pagfam12ReplicatedStorage.GunModels.TestGunModel
Data.ClientGunModel = ReplicatedStorage.Pagfam12ReplicatedStorage.GunModels.TestGunModel
Data.ClientGunModelHandleOffset = CFrame.new(1.5, -1, -1) --CFrame value
Data.Actions = nil --Testing Note: might remove
Data.Bullet = ReplicatedStorage.Pagfam12ReplicatedStorage.Bullets.RCLBullet --Path to bullet model, can be put in table for multiple different bullets
Data.BulletBase = "BulletBase" --Name of the bullet base (uses ServerGunModel atm)
Data.CharacterHandleAttachPart = {"UpperTorso"} --Part to attach to the tool

--Animation
Data.ClientAnimationType = "Roblox" --Options include Roblox (Roblox animation from assetid), tweening (similar to acs, exists for acs port), MoonAnimator (Uses Moonlite), and Joint (Similar to how animations were done before animations were a thing)
Data.ServerAnimationType = "Roblox" --Options include Roblox and Joint. (Some options were excluded since they are incapable of running on the server)

--Viewmodel
Data.ViewmodelEnabled = true 
Data.FPViewmodelType = "Roblox" --Either a "Viewmodel" or the "Roblox"'s character. The custom Viewmodel requires it's own animation on the client while Roblox could let you reuse animations run on the  leave blank if you don't want a viewmodel
Data.ViewmodelName = "Roblox" --custom Viewmodel to look for in ReplicatedStorage. Will only work if FPViewmodelType is "Viewmodel"
Data.BodyPartsToShowInFPS = {"LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm", "LeftArm", "RightArm"} --Enter both R6 and R15 parts, will apply nevertheless
Data.ApplyHumanoidDescriptionToViewmodel = true --Applies the player's avatar to the viewmodel

--Mouse
Data.CustomMouseIcon = false
Data.MouseIconType = "Image" --Either an Image or Gui
Data.MouseImageId = "rbxasset://SystemCursors/Cross" --If MouseIconType is an Image

--Cross-Platform Support (PC support is the base that these platforms will be built on (obviously))
Data.MobileSupport = false
Data.ConsoleSupport = false
Data.VRSupport = false

--ShootTypes
--|Step
Data.BulletSpeed = 64 --In studs per second
Data.BulletLifetime = 0.5 --How long will the bullet live for. (Speed = distance / time)
--|Hitscan
Data.BulletLifetime = 0.05 --How long will the bullet live for
Data.RayLength = 1000 --Legth of the ray. 15000 is the max length (for comparison, two characters standing 700 studs away would be like 4 px in height on a FHD monitor (i think...))
Data.RaycastPartFilter = {} --additional parts to filter (you could use "Pagfam Raycast Filter"...)
Data.FilterWater = false

return Data