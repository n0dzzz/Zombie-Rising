AddCSLuaFile( "sv_money.lua" )
AddCSLuaFile( "sv_zombiespawn.lua" )
AddCSLuaFile( "sv_weaponbox.lua" )

include( "cl_init.lua" )
include( "cl_hud.lua" )
include( "cl_weaponbox.lua" )
include( "shared.lua" )

hook.Add("PlayerSpawn", "SpawnStartup", function(ply)
    
   ply:StripWeapons()

   local sboxweapons = GetConVar("sbox_weapons")
   sboxweapons:SetBool(false)

   GetConVar("mgbase_sv_customization"):SetBool(false)
   ply:Give("mg_m1911") 
   ply:GiveAmmo(9999, "Pistol", true)
   
end)
