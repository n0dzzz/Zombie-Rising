include( "shared.lua" )

local ZombiesTable = {
    ["npc_headcrab"] = 50,
    ["npc_zombie"] = 100,
    ["npc_fastzombie"] = 200,
    ["npc_poisonzombie"] = 300
}

local function CheckTableValue(ent)
    return ZombiesTable[ent] ~= nil
end

hook.Add("OnNPCKilled", "OnKill", function(npc, attacker, inflictor)
    attacker:SetNWInt("CurrentMoney",0)

    if CheckTableValue(npc:GetClass()) then
        attacker:SetNWInt("CurrentMoney",ZombiesTable[npc:GetClass()])
    end

    if(attacker:GetNWInt("PlayerPrestige") >= 10) then
        attacker:SetNWInt("MoneyAmount",attacker:GetNWInt("MoneyAmount") + ((attacker:GetNWInt("CurrentMoney") * 2) * attacker:GetNWInt("RoundNumberVar")))
    else 
        attacker:SetNWInt("MoneyAmount",attacker:GetNWInt("MoneyAmount") + (attacker:GetNWInt("CurrentMoney") * attacker:GetNWInt("RoundNumberVar")))
    end
end)
