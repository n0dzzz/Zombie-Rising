util.AddNetworkString("OpenInteraction")
util.AddNetworkString("RecieveWeapon")
util.AddNetworkString("RemoveGod")

include("shared.lua")

local CanUse = true

hook.Add("PlayerUse", "BoxInteraction", function(ply, ent)
    if CanUse && ply:GetEyeTrace().Entity:GetModel() == "models/items/ammocrate_ar2.mdl" then
        net.Start("OpenInteraction")
        net.Send(ply)
        ply:GodEnable() 

        CanUse = false
    end
end)

net.Receive("RecieveWeapon", function(len, ply)
    local NetTable = net.ReadTable()

    ply:Give(tostring(NetTable[1]))
    if NetTable[2] == "Health Kit" then
        ply:SetHealth(ply:GetMaxHealth())
    end

    if NetTable[2] == "Customization" then
        GetConVar("mgbase_sv_customization"):SetBool(true)
    end

    if NetTable[2] == "Mini Gun" then
        if (ply:GetNWInt("PlayerPrestige") >= 20) then
            ply:Give("mg_dblmg")
        end
    end
    
    ply:SetNWInt("MoneyAmount",ply:GetNWInt("MoneyAmount") - tonumber(NetTable[#NetTable]))
end)

net.Receive("RemoveGod", function(len, ply)
    timer.Create("GracePeriod", 1, 1, function()
        ply:GodDisable()
    end)

    timer.Create("Debounce", 3, 1, function()
        CanUse = true
    end)
end)
