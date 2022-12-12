AddCSLuaFile("sv_money.lua")
AddCSLuaFile("sv_weaponbox.lua")
AddCSLuaFile( "sv_zombiespawn.lua" )
AddCSLuaFile( "sv_rank.lua" )
AddCSLuaFile( "sv_spectate.lua" )

include( "shared.lua" )
include( "sv_zombiespawn.lua" )
include( "sv_money.lua" )
include( "sv_weaponbox.lua" )
include( "sv_rank.lua" )
include( "sv_spectate.lua" )

util.AddNetworkString("PlayerDeath")
util.AddNetworkString("PlayerRespawn")

CreateConVar("RoundNumberVar", 1)
hook.Add("PlayerSpawn", "SpawnStartup", function(ply)
   ply:UnSpectate()
   ply:StripWeapons()

   ply:SetSlowWalkSpeed(100)
   ply:SetWalkSpeed(150)
   ply:SetRunSpeed(175)

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

   net.Start("PlayerRespawn")
   net.Send(ply)

end)

hook.Add("EntityTakeDamage", "RemoveFriendlyFire", function(target,dmg)
   if target:IsPlayer() && dmg:GetAttacker():IsPlayer() then
      dmg:ScaleDamage(0)
   end
end)

hook.Add("PlayerDeathThink", "DisableRespawn", function(ply)
   ply:ScreenFade(SCREENFADE.OUT, Color(255,255,255), 0, 0)
   local RagDoll = ply:GetRagdollEntity()
   if IsValid(RagDoll) then
      RagDoll:Remove()
      net.Start("PlayerDeath")
      net.Send(ply)
   end
   return false
end)
