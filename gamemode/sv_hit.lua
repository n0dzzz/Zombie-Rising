util.AddNetworkString("SendAttacker")

include( "shared.lua" )

hook.Add("EntityTakeDamage", "SendHit", function(target,dmginfo)
    if !target:IsNPC() then return end
    if dmginfo:GetAttacker():IsPlayer() then
        net.Start("SendAttacker")
        net.Send(dmginfo:GetAttacker())
    end
end)
