util.AddNetworkString("OpenInteraction")
util.AddNetworkString("RecieveWeapon")

AddCSLuaFile("sv_money.lua")
include("shared.lua")
include("sv_money.lua")

local CanUse = true

hook.Add("PlayerUse", "BoxInteraction", function(ply, ent)
    if CanUse && ply:GetEyeTrace().Entity:GetModel() == "models/items/ammocrate_ar2.mdl" then
        net.Start("OpenInteraction")
        net.Send(ply)

        CanUse = false

        timer.Create("Debounce", 1, 1, function()
            CanUse = true
        end)
    end

end)

net.Receive("RecieveWeapon", function(len, ply)
    local NetTable = net.ReadTable()
    
    ply:Give(tostring(NetTable[1]))
    ply:SetNWInt("MoneyAmount",ply:GetNWInt("MoneyAmount") - NetTable[2])
end)
