AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local CurrentPlayer = 0
local open = false
local SpectateFrame
local AlivePlayers = {}
local StartTime = CurTime()

local LabelFont = surface.CreateFont("LabelFont", {
    font = "TargetID", 
    size = 25,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
})

local function SpectateGui(open)

    if open then 
        SpectateFrame = vgui.Create("DFrame")
        SpectateFrame:ShowCloseButton(false)
        SpectateFrame:SetSize(350,100)
        SpectateFrame:Center()
        SpectateFrame:SetPos(SpectateFrame.x, 50)
        SpectateFrame:SetTitle("")
        SpectateFrame:SetDraggable(false)
        SpectateFrame:MakePopup()
        SpectateFrame:SetDeleteOnClose(true)

        SpectateFrame.Paint = function(self,w,h)

            surface.SetDrawColor(0,0,0)
            surface.DrawRect(0, 0, w, h) 
            surface.SetDrawColor( 255, 44, 44, 255 )
            surface.DrawOutlinedRect(0,0, w, h,2)
        end

        local BackButton = vgui.Create("Button", SpectateFrame)
        BackButton:SetText("<")
        BackButton:SetSize(80,100)
        BackButton:SetColor(Color( 255,255,255 ))
        BackButton:SetFont("LabelFont")

        BackButton.Paint = function(self,w,h)
            surface.SetDrawColor( 255, 44, 44, 255 )
            surface.DrawOutlinedRect(0,0,w,h,2)
        end

        function BackButton:DoClick()
            if CurrentPlayer <= 0 then
                CurrentPlayer = #AlivePlayers
            else
                CurrentPlayer = CurrentPlayer -  1
            end
        end

        local ForwardButton = vgui.Create("Button", SpectateFrame)
        ForwardButton:SetText(">")
        ForwardButton:SetSize(80,100)
        ForwardButton:SetColor(Color( 255,255,255 ))
        ForwardButton:SetPos(SpectateFrame:GetWide() - 80, 0)
        ForwardButton:SetFont("LabelFont")

        ForwardButton.Paint = function(self,w,h)
            surface.SetDrawColor( 255, 44, 44, 255 )
            surface.DrawOutlinedRect(0,0,w,h,2)
        end

        function ForwardButton:DoClick()
            if CurrentPlayer >= #AlivePlayers then
                CurrentPlayer = 0
            else
                CurrentPlayer = CurrentPlayer + 1
            end
        end
        
        local PlayerButton = vgui.Create("Button", SpectateFrame)
        PlayerButton:SetSize((ForwardButton.x - 39) - (BackButton.x + 39), 100)
        PlayerButton:SetFont("LabelFont")
        PlayerButton:Center()
        PlayerButton:SetColor(Color( 255,255,255 ))

        PlayerButton.Paint = function(self,w,h)
            surface.SetDrawColor( 255, 44, 44, 255 )
            surface.DrawOutlinedRect(0,0,w,h,2)

            if IsValid(AlivePlayers[CurrentPlayer]) then
                PlayerButton:SetText(AlivePlayers[CurrentPlayer]:Nick())
            else
                PlayerButton:SetText("No alive players")
            end
        end

        function PlayerButton:DoClick()
            net.Start("BeginSpectate")
                net.WriteEntity(AlivePlayers[CurrentPlayer])
            net.SendToServer()
        end

    else
        if IsValid(SpectateFrame) then
            SpectateFrame:Close()
        end
    end

end

hook.Add("Think", "GetAlivePlayers", function()
    for k,v in pairs(player.GetAll()) do
        if v:Alive() && !table.HasValue(AlivePlayers, v) then
            table.insert(AlivePlayers, #AlivePlayers, v)
        end
    end
    for i,p in pairs(AlivePlayers) do
        if IsValid(p) && !p:Alive() then
            if i == 0 then table.Empty(AlivePlayers) return end
            table.remove(AlivePlayers, i)
        end
    end
    if table.IsEmpty(AlivePlayers) then
        if CurTime() - StartTime < 15 then return end
        net.Start("EndGame")
        net.SendToServer()
    end
end)

net.Receive("PlayerDeath", function()
    open = true
    SpectateGui(open)
end)

net.Receive("PlayerRespawn", function()
    open = false
    SpectateGui(open)
end)
