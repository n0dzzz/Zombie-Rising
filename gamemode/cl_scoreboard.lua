AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local function CreateScoreboard(ToggleScoreboard)
    if ToggleScoreboard then
        ScoreboardBase = vgui.Create("DFrame")
        ScoreboardBase:SetTitle("")
        ScoreboardBase:SetSize(ScrW() * 0.5, ScrH() * 0.6)
        ScoreboardBase:Center()
        ScoreboardBase:ShowCloseButton(false)
        ScoreboardBase:SetDraggable(false)
        ScoreboardBase:MakePopup()
        ScoreboardBase.Paint = function(self,w,h)
            surface.SetDrawColor(0,0,0,200)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText("Name", "TargetID", w * 0.153 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Money", "TargetID", w * 0.384 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Prestige", "TargetID", w * 0.587 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Rank", "TargetID", w * 0.735 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Ping", "TargetID", w * 0.868 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local ypos = 0
        local PlayerScrollPanel = vgui.Create("DScrollPanel",ScoreboardBase)
        PlayerScrollPanel:SetPos(3,ScoreboardBase:GetTall() * 0.05)
        PlayerScrollPanel:SetSize(ScoreboardBase:GetWide() - 6,ScoreboardBase:GetTall() * 0.95)
        for k,v in pairs(player.GetAll()) do
            local PlayerPanel = vgui.Create("DPanel", PlayerScrollPanel)
            PlayerPanel:SetPos(0,ypos)
            PlayerPanel:SetSize(PlayerScrollPanel:GetWide(),PlayerScrollPanel:GetTall() * 0.05)
            local PlayerName = v:Name()
            local PlayerMoney = v:GetNWInt("MoneyAmount")
            local PlayerPrestige = v:GetNWInt("PlayerPrestige")
            local PlayerRank = v:GetNWInt("PlayerRank")
            local PlayerPing = v:Ping()
            PlayerPanel.Paint = function(self,w,h)
                if IsValid(v) then
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawRect(0, 0, w, h)
                    draw.SimpleText(PlayerName, "TargetID", w * 0.153 , h /2 , Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText("$"..tostring(PlayerMoney), "TargetID", w * 0.384 , h /2 , Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(PlayerPrestige, "TargetID", w * 0.587 , h /2 , Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(PlayerRank, "TargetID", w * 0.735 , h /2 , Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(PlayerPing, "TargetID", w * 0.868 , h /2 , Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                end
            end
            ypos = ypos + PlayerPanel:GetTall() * 1.1
        end
    else
        if IsValid(ScoreboardBase) then
            ScoreboardBase:Remove()
        end
    end
end


hook.Add("ScoreboardShow", "OpenScoreboard", function()
    CreateScoreboard(true)
    return false
end)

hook.Add("ScoreboardHide", "CloseScoreboard", function()
    CreateScoreboard(false)
end)
