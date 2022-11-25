hook.Add("OnNPCKilled", "OnKill", function(npc, attacker, inflictor)

    if(attacker:GetNWInt("PlayerPrestige") >= 10) then
        attacker:SetNWInt("MoneyAmount",attacker:GetNWInt("MoneyAmount") + 200 * attacker:GetNWInt("RoundNumberVar"))
    else 
        attacker:SetNWInt("MoneyAmount",attacker:GetNWInt("MoneyAmount") + 100 * attacker:GetNWInt("RoundNumberVar"))
    end

end)
