AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sv_money.lua" )

include( "shared.lua" )

hook.Add("PlayerSpawn", "SpawnStartup", function(ply)
    
   ply:StripWeapons()

   local sboxweapons = GetConVar("sbox_weapons")
   sboxweapons:SetBool(false)

   ply:Give("weapon_crowbar") 

end)
