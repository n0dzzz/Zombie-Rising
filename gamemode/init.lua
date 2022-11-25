AddCSLuaFile("sv_money.lua")
AddCSLuaFile("sv_weaponbox.lua")
AddCSLuaFile( "sv_zombiespawn.lua" )
AddCSLuaFile( "sv_rank.lua" )

include( "shared.lua" )
include( "sv_zombiespawn.lua" )
include( "sv_money.lua" )
include( "sv_weaponbox.lua" )
include( "sv_rank.lua" )

CreateConVar("RoundNumberVar", 1)
hook.Add("PlayerSpawn", "SpawnStartup", function(ply)

   ply:StripWeapons()

   local sboxweapons = GetConVar("sbox_weapons")
   sboxweapons:SetBool(false)

   GetConVar("mgbase_sv_customization"):SetBool(false)
   ply:Give("mg_m1911") 
   ply:Give("item_ammo_pistol_large") 

   if (ply:GetNWInt("PlayerPrestige") >= 1) then
      ply:SetArmor(25)
   end

   if (ply:GetNWInt("PlayerPrestige") >= 3) then
      ply:Give("mg_glock") 
   end

   if (ply:GetNWInt("PlayerPrestige") >= 7) then
      ply:SetArmor(50)
   end

   if (ply:GetNWInt("PlayerPrestige") >= 13) then
      ply:Give("mg_akilo47") 
      ply:Give("item_ammo_ar2_large") 
   end

   if (ply:GetNWInt("PlayerPrestige") >= 15) then
      ply:SetMaxHealth(200)
      ply:SetHealth(200)
   end

   if (ply:GetNWInt("PlayerPrestige") >= 17) then
      ply:SetArmor(75)
   end

end)

hook.Add("EntityTakeDamage", "RemoveFriendlyFire", function(target,dmg)
   if target:IsPlayer() && dmg:GetAttacker():IsPlayer() then
      dmg:ScaleDamage(0)
   end
end)