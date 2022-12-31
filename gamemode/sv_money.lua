hook.Add("OnNPCKilled", "OnKill", function(npc, attacker, inflictor)
    if npc:GetClass() == "npc_vj_zs_zombie" then
        attacker:SetNWInt("CurrentMoney",100)
    end

    if npc:GetClass() == "npc_vj_zs_fastzombie" then
        attacker:SetNWInt("CurrentMoney",200)
    end

    if npc:GetClass() == "npc_vj_zs_poisonzombie" then
        attacker:SetNWInt("CurrentMoney",300)
    end

    if npc:GetClass() == "npc_vj_zs_zombine" then
        attacker:SetNWInt("CurrentMoney",400)
    end

    if(attacker:GetNWInt("PlayerPrestige") >= 10) then
        attacker:SetNWInt("MoneyAmount",attacker:GetNWInt("MoneyAmount") + ((attacker:GetNWInt("CurrentMoney") * 2) * attacker:GetNWInt("RoundNumberVar")))
    else 
        attacker:SetNWInt("MoneyAmount",attacker:GetNWInt("MoneyAmount") + (attacker:GetNWInt("CurrentMoney") * attacker:GetNWInt("RoundNumberVar")))
    end
end)
