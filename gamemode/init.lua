AddCSLuaFile("sv_money.lua")
AddCSLuaFile("sv_weaponbox.lua")
AddCSLuaFile( "sv_zombiespawn.lua" )

include( "shared.lua" )
include( "sv_zombiespawn.lua" )
include( "sv_money.lua" )
include( "sv_weaponbox.lua" )

CreateConVar("RoundNumberVar", 1)
hook.Add("PlayerSpawn", "SpawnStartup", function(ply)
    
   ply:StripWeapons()

   local sboxweapons = GetConVar("sbox_weapons")
   sboxweapons:SetBool(false)

   GetConVar("mgbase_sv_customization"):SetBool(false)
   ply:Give("mg_m1911") 
   ply:Give("item_ammo_pistol_large") 
end)
