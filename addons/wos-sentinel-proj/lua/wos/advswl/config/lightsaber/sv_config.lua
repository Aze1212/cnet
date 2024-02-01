--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2022
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}

/* 
	What Lightsaber Trace schema do you want to use?
	Options:
		WOS_ALCS.TRACE.CLASSIC		--Classic Rubat traces. Never stops tracing
		WOS_ALCS.TRACE.MINIMAL		--Traces only occur when swinging/attacking, good for performance but removes burn damage and scorch
		WOS_ALCS.TRACE.INTERP		--Trace travels path of lightsaber. Useful for precision but a little more intensive
		WOS_ALCS.TRACE.MINIMALINTERP		--Same as INTERP, but following MINIMAL rules. Precision with a slightly reduced load
*/
wOS.ALCS.Config.LightsaberTrace = WOS_ALCS.TRACE.INTERP

/*
	How far away can we lock onto targets with the Force Lock On ( IN UNITS )
*/
wOS.ALCS.Config.LightsaberLockOnDistance = 850

/*
	How far away can we be until the lock on breaks? ( IN SQUARE UNITS )
	SQAURE MEANS SQUARE THE NUMBER
	Example: 
		50 UNITS = 2500 SQUARE UNITS
*/
wOS.ALCS.Config.LightsaberLockOnBreakSquare = 800000

/*
	How long should a parry stun the victim? IN SECONDS
*/
wOS.ALCS.Config.LightsaberParryStun = 1

/*
	Should lightsabers damage all entities? DEFAULT: Only damages players and NPCs
	WARNING 1: If you are giving your lightsabers a lot of damage this could potentially instakill or break entities.
	WARNING 2: If you only want to damage a small amount of entities, use the damage hook instead
	WARNING 3: If you only want to prevent damage to a small amount of entities, the damage hook can also block damage by returning false
*/
wOS.ALCS.Config.LightsaberDamageAllEnts = false

/*
	What is the threshold timing for networking sync to client?
	DO NOT EDIT THIS OUTSIDE OF THE SUGGESTIONS IF YOU DON'T KNOW WHAT THIS DOES!
	The higher the number, the more optimized but less frequent the data will be checked
	Basically, we wait this much time before we do another network flag check. Ask in the support channel as there's a LOT of advantages
	for different maps (small, grouped maps will be better for less frequent network flags for example)

	Set to FALSE to auto calculate for your current tick rate (server-side and linear)

	Example: 0.35 seconds (optimized for 11 tick)
	Suggestions:
	   66 tick : 0.15 seconds
	   33 tick: 0.22 seconds
	   11 tick: 0.35 seconds

*/
wOS.ALCS.Config.DataDescUpdateRate = false