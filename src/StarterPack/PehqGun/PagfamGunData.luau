local Data = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Basic data (or unsorted)
Data.GunName = "Pistol" --will use the gun name for default paths if the path isn't present
Data.ShootType = "Step" --Multiple shoot types, they are Step (the bullet Steps fowards), Hitscan (uses mouse.hit, good for rcl), Raycast (casts a ray and see what was hit)
Data.ShootOrigin = "Head" --from what part does the bullet spawn at. Will look for part in the character
Data.CameraMode = Enum.CameraMode.LockFirstPerson
Data.Firerate = 0.1
Data.EquipTime = 1
Data.ReloadTime = 3
Data.OffHandReloading = false
Data.AimEnabled = true
Data.AimToggle = true --if false then aim will need to be held down
Data.AimDownSightTime = 0 --time it takes for player to be able to shoot after toggling aim

--Model (if paths are nil then it'll attempt to use the gunname)
Data.ServerGunModel = nil --TODO
Data.ClientGunModel = nil --TODO
Data.Actions = nil --Testing Note: might remove
Data.Bullet = nil --Path to bullet model, can be put in table for multiple different bullets
Data.BulletSpeed = 64 --In studs per second
Data.BulletLifetime = 60 --How long will the bullet live for. (Speed = distance / time)

--Animation
Data.ClientAnimationType = "Roblox" --Options include Roblox (Roblox animation from assetid), tweening (similar to acs, exists for acs port), MoonAnimator (Uses Moonlite), and Joint (Similar to how animations were done before animations were a thing)
Data.ServerAnimationType = "Roblox" --Options include Roblox and Joint. (Some options were excluded since they are incapable of running on the server)

--Viewmodel
Data.ViewmodelEnabled = true 
Data.FPViewmodelType = "Viewmodel" --Either a "Viewmodel" or the "Roblox"'s character. The custom Viewmodel requires it's own animation on the client while Roblox could let you reuse animations run on the  leave blank if you don't want a viewmodel
Data.ViewmodelName = "Roblox" --custom Viewmodel to look for in ReplicatedStorage. Will only work if FPViewmodelType is "Viewmodel"
Data.BodyPartsToShowInFPS = {"Left Hand", "Left Lower Arm", "Left Upper Arm", "Right Hand", "Right Lower Arm", "Right Upper Arm", "Left Arm", "Right Arm"} --Enter both R6 and R15 parts, will apply nevertheless

--Mouse
Data.CustomMouseIcon = false
Data.MouseIconType = "Image" --Either an Image or Gui
Data.MouseImageId = "" --If MouseIconType is an Image

--Cross-Platform Support (PC support is the base that these platforms will be built on (obviously))
Data.MobileSupport = false
Data.ConsoleSupport = false
Data.VRSupport = false

return Data