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

        timer.Create("Debounce", 1, 1, function()
            CanUse = true
        end)
    end

end)

net.Receive("RecieveWeapon", function(len, ply)
    local NetTable = net.ReadTable()

    ply:Give(tostring(NetTable[1]))
    if NetTable[2] == "Health Kit" then
        ply:SetHealth(ply:GetMaxHealth())
    end
    
    ply:SetNWInt("MoneyAmount",ply:GetNWInt("MoneyAmount") - tonumber(NetTable[#NetTable]))
end)

net.Receive("RemoveGod", function(len, ply)
    ply:GodDisable()
end)
