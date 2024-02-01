--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2022
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
--Should the player move in the direction of the animation when attacking?
--VERY VERY ( VERY )IMPORTANT NOTE: I highly recommend you disable this if your tick rate is BELOW 33. YOU WILL SEE STUTTERING OTHERWISE
wOS.ALCS.Config.EnableLunge = false

--Enabling this will stop the force icons from rendering.
--Useful for servers with 3D2D HUDs, as it will save clients some frames.
--This will also remove the little icon in the Force Select menu. 
wOS.ALCS.Config.DisableForceIcons = false

--The frequency ( in seconds ) that the wiltOS Advanced Saber Combat advertisement will print in chat.
--To disable advertisements, just set this to false
--I won't get angry if you disable it, promise
wOS.ALCS.Config.AdvertTime = false

--This is used to enable the realistic camera on first person lightsabers. 
--Players will be locked into their model's eyes and the camera will be limited by their head movements
--Good for RP purposes, but hard aim and use force abiltiies with
wOS.ALCS.Config.AlwaysFirstPerson = false

--If your server is using Zhrom's Starwars Prop Pack, this will automatically mount them to the toolgun/crafting benches
--YOU AND YOUR SERVER WILL NEED THIS ADDON!
-- http://steamcommunity.com/sharedfiles/filedetails/?id=740395760&searchtext=Zhrom
wOS.ALCS.Config.EnableZhromExtension = false

--If your server is using the CloneWars Adventure pack, this will automatically mount them to the toolgun/crafting benches
--YOU AND YOUR SERVER WILL NEED THE CLONE WAR PACK!
wOS.ALCS.Config.EnableCloneAdventures = false

-- This ignores any of the robotboy console commands and forces it for clients to not draw any hilts on their belt
-- This can be set at any time in lua so it can also be set per client with hooks!
wOS.ALCS.Config.StopDrawOnBelt = false

