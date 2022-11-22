include( "cl_hud.lua" )
include( "cl_init.lua" )
include( "shared.lua" )

AddCSLuaFile( "sv_money.lua" )
AddCSLuaFile( "sv_zombiespawn.lua" )

hook.Add("PlayerSpawn", "SpawnStartup", function(ply)
    
   ply:StripWeapons()

   local sboxweapons = GetConVar("sbox_weapons")
   sboxweapons:SetBool(false)

   ply:Give("mg_m1911") 
   ply:GiveAmmo(9999, "Pistol", true)
   
end)
