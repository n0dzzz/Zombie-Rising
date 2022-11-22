local Meta = FindMetaTable("Player")

function Meta:AddMoney(amount)
    if self:GetNWInt("MoneyAmount") == 0 then
        self:SetNWInt("MoneyAmount", amount)
    end

    self:SetNWInt("MoneyAmount", self:GetMoney() + amount)
end

function Meta:GetMoney()
    return self:GetNWInt("MoneyAmount")
end

hook.Add("OnNPCKilled", "OnKill", function(npc, attacker, inflictor)
    attacker:AddMoney(100)
end)
