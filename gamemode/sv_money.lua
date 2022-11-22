hook.Add("OnNPCKilled", "OnKill", function(npc, attacker, inflictor)
    attacker:SetNWInt("MoneyAmount",attacker:GetNWInt("MoneyAmount") + 250)
end)
