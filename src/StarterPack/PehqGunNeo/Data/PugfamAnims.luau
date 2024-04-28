--Note: this simply stores the animation file and is meant to played on another script
local Anim = {}

local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PugfamRep = ReplicatedStorage.Pugfam12RE
local AnimStorage = PugfamRep.Animations

--REQUIRED VARIABLES
Anim.ViewmodelOffest = CFrame.new(0,0, -0.5) -- -0.5 is the distance between camera and player in fp mode

Anim.ServerGunPartMotor6d = "BodyAttach" --the gun part you want to weld to 
Anim.ServerCharGunWeldR15= "UpperTorso" --you could choose to only set up r15, it'll autofill the r6 one
Anim.ServerCharGunWeldR6 = "Torso"

--NOTE: animations aren't played here, they will be played on the client... This only lists the animations for the gun

Anim.Actions = {
    ["Equip"] = ""
}

--Client

--Roblox Animation (must be dedicated to the viewmodel and gun)
--Uses Anim.Actions to store animationIds

function Anim.RobloxAnim(animcontroller, action) --humanoid will also work... THEY MUST HAVE AN ANIMATION TRACK
    local anim = Instance.new("Animation")
    anim.AnimationId = Anim.Animations[action]
    
    local AnimationTrack = animcontroller:LoadAnimation(anim)

    return AnimationTrack
end

--Tween Anims (pain)
--does not uses Anim.Actions (optional) (or maybe it does...)
--Actions will be tied to name.
--[[

  Actions---> Equip
          |-> Idle
          |-> Aim
          |-> Shoot
          |-> Reload
          |-> etc...

    you can add your own in place of etc
]]

Anim.TweenAnims = {}
local TweenAnims = Anim.TweenAnims

function TweenAnims.Equip()

end

function TweenAnims.Idle()

end

function TweenAnims.Aim()

end

function TweenAnims.Shoot()

end

function TweenAnims.Reload()

end


function TweenAnims.Salute() --not inserted cause this ain't a larp gun engine... instead it's up to you!

end

--Moon anim: very exciting yet it causes LAG... only use for cinematic shots or very complex animations but try to minimize using this (like the nerf doominator, it's a 4 barreled gun with 6 ammon slots that's pump actioned. It has another trigger to switch barrels.)
--Uses Anim.Animation to reference the Moon animation save file
--Downsides are not being able to manipulate the speed, only one could be played at a time, and other stuff as well as being CLIENT ONLY... womp womp
--Credits for Moonlite module: MaximumADHD, 

function Anim.PlayMoonAnim()
    --wip
end

--Joint anim (wip but idea is that parts revolves around joints and can)
local newJoint = {} --uses oop... maybe...
newJoint.__index = newJoint

--Most stuff ^^^ up there ^^^ is documentation, here is where the real code begins

Anim.AnimationFile = {
    ["Shoot"] = {
        ["Type"] = "Roblox",
        ["Location"] = "rbxassetid://EXAMPLEID"
    },
    ["Idle"] = {
        ["Type"] = "MoonAnim",
        ["Location"] = nil, --script.MoonAnimSave
    },
    ["Reload"] = {
        ["Type"] = "TweenAnim",
        ["Location"] = TweenAnims.Reload
    },
    ["Aim"] = {
        ["Type"] = "Joint",
        ["Location"] = nil, --still thinking on this but it's similar to the roblox sword script animations
    }
}

--AGAIN... IGNORE EVEYTHING UP THERE...

--Anims are ran from the actions functions

local AnimationList = {
	["CharacterIdle"] = {
		["Type"] = "Roblox",
		["Location"] = KeyframeSequenceProvider:RegisterKeyframeSequence(AnimStorage.TestGunModel.idle)
	}
}

Anim.AnimationFile.Shoot = function(Model:Model)
	local animator = Model.Humanoid.Animator
end

Anim.AnimationFile.CharIdle = function(Model:Model)
	local animator = Model.Humanoid.Animator
	local animation = Instance.new("Animation")
	animation.Name = "Ni hao"
	animation.AnimationId = AnimationList.CharacterIdle.Location
	local animTrack:AnimationTrack = animator:LoadAnimation(animation)
	animTrack:Play()
	
	return animTrack
end

return Anim