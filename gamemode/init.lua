AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile("sv_money.lua")
AddCSLuaFile("sv_weaponbox.lua")

include( "shared.lua" )
include( "sv_zombiespawn.lua" )
include( "sv_money.lua" )
include( "sv_weaponbox.lua" )

hook.Add("PlayerSpawn", "SpawnStartup", function(ply)
    
   ply:StripWeapons()

   local sboxweapons = GetConVar("sbox_weapons")
   sboxweapons:SetBool(false)

   GetConVar("mgbase_sv_customization"):SetBool(false)
   ply:Give("mg_m1911") 
   
end)