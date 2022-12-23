local function DisplayHitMarker()
    if LocalPlayer():GetNWString("CrosshairColor") == "" then LocalPlayer():SetNWString("CrosshairColor", tostring(ColorRand())) end
    local CrosshairColor = string.ToColor(LocalPlayer():GetNWString("CrosshairColor"))
    hook.Add("HUDPaint", "Display", function()
        surface.SetDrawColor(CrosshairColor.r,CrosshairColor.g,CrosshairColor.b)
        surface.DrawLine((ScrW()/2) - 10, (ScrH() / 2) - 10, (ScrW()/2) - 20, (ScrH()/2) - 20)
        surface.DrawLine((ScrW()/2) + 10, (ScrH() / 2) - 10, (ScrW()/2) + 20, (ScrH()/2) - 20)
        surface.DrawLine((ScrW()/2) + 10 , (ScrH() / 2) + 10, (ScrW()/2) + 20, (ScrH()/2) + 20)
        surface.DrawLine((ScrW()/2) - 10, (ScrH() / 2) + 10, (ScrW()/2) - 20, (ScrH()/2) + 20)
    end)
    timer.Simple(0.2, function()
        hook.Remove("HUDPaint", "Display")
    end)
end

net.Receive("SendAttacker", function(len,ply)
    surface.PlaySound("audioclips/ui/headshot.wav")
    DisplayHitMarker()
end)
