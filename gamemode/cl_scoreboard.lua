AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local ScoreboardBase

surface.CreateFont("HUDFont", {
	font = "Segoe UI Bold",
	size = 24,
	antialias = true,
	outline = true,
})

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
            surface.SetDrawColor(45,45,45,225)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(222,16,50)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("Name", "HUDFont", w * 0.12, h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Money", "HUDFont", w * 0.3 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Prestige", "HUDFont", w * 0.45 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Rank", "HUDFont", w * 0.6 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Wins", "HUDFont", w * 0.75 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Ping", "HUDFont", w * 0.9 , h * 0.03 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
	    local PlayerWins = 0--v:GetNWInt("PlayerWins") later most likely and have it save on each win
            local PlayerPing = v:Ping()'
            
            if v:GetNWString("BackgroundColor") == "" then v:SetNWString("BackgroundColor", tostring(ColorRand())) end
            PlayerPanel.Paint = function(self,w,h)
                if IsValid(v) then
                    surface.SetDrawColor(222,16,50)
                    surface.DrawRect(0, 0, w, h)
                    draw.SimpleText(PlayerName, "HUDFont", w * 0.12 , h /2 , Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText("$"..tostring(PlayerMoney), "HUDFont", w * 0.3 , h /2 , Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(PlayerPrestige, "HUDFont", w * 0.45 , h /2 , Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(PlayerRank, "HUDFont", w * 0.6 , h /2 , Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(PlayerWins, "HUDFont", w * 0.75 , h /2 , Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(PlayerPing, "HUDFont", w * 0.9 , h /2 , Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
