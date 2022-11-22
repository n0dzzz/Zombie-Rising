AddCSLuaFile("sv_money.lua")
include("shared.lua")
include("sv_money.lua")

local Player = LocalPlayer()

local Items = {{"models/viper/mw/weapons/w_augolf.mdl","mg_augolf","Aug",200},{"models/viper/mw/weapons/v_crossbow.mdl","Crossbow",500}}
local LabelFont = surface.CreateFont("LabelFont", {
    font = "TargetID", 
    size = 25,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
})

local function CreateGui()
    local Frame = vgui.Create("DFrame")
    Frame:SetTitle("")
    Frame:SetDraggable(false)
    Frame:SetSize(500,500)
    Frame:Center()
    Frame:MakePopup()

    local DScrollPanel = vgui.Create("DScrollPanel", Frame)
    DScrollPanel:Dock(FILL)
    local YPos = 5
    for k,v in pairs(Items) do

        local ItemPanel = vgui.Create("DPanel", DScrollPanel)
        ItemPanel:SetPos(0,YPos)
        ItemPanel:SetSize(Frame:GetWide() -10,Frame:GetTall() * 0.2)
        local model = vgui.Create("DModelPanel", ItemPanel)
        model:SetPos(10,-10)
        model:SetModel(tostring(v[1]))
        model:SetSize(100,100)
        model:SetFOV(40)
        model:SetCamPos(Vector(50, 0, 0))
        model:SetLookAt(Vector(0, 0, 0))
        function model:LayoutEntity(ent)
            ent:SetAngles(Angle(0, RealTime()*100,  0))
        end
        
        local ItemLabel = vgui.Create("DLabel", ItemPanel)
        ItemLabel:SetPos((ItemPanel:GetWide() * 0.5) + (#tostring(v[2]) * -9), 0)
        ItemLabel:SetSize(1000,100)
        ItemLabel:SetColor(Color(0,0,0))
        ItemLabel:SetFont("LabelFont")
        ItemLabel:SetText(tostring(v[2]))

        local ItemButton = vgui.Create("DButton", ItemPanel)
        ItemButton:SetFont("LabelFont")
        ItemButton:SetPos(ItemPanel:GetWide() - 140, 30)
        ItemButton:SetSize(95,40)
        ItemButton:SetText("$"..tostring(v[#v]))
        ItemButton:SetColor(Color(0,150,53))

        function ItemButton:DoClick()
            if Player:GetMoney() >= v[#v] then
                for index,weapon in pairs(Player:GetWeapons()) do
                    if weapon:GetClass() == v[2] then
                        notification.AddLegacy("You don't have enough money for that", 2, 2)
                        surface.PlaySound("physics/surfaces/sand_impact_bullet1.wav")
                    end
                end

                net.Start("RecieveWeapon")
                    net.WriteTable({v[2],v[#v]})
                net.SendToServer()
            else
                notification.AddLegacy("You don't have enough money for that", 1, 2)
                surface.PlaySound("physics/surfaces/sand_impact_bullet1.wav")
            end
        end


        YPos = YPos + ItemPanel:GetTall() * 1.1 
    end
end

net.Receive("OpenInteraction", function()
    CreateGui()
end)

hook.Add( "HUDPaint", "Interaction", function()
    if not Player:IsValid() then return end
    if not IsValid(Player:GetEyeTrace()) then return end

    if Player:GetEyeTrace().Entity:GetModel() == "models/items/ammocrate_ar2.mdl" && Player:GetPos():Distance(Player:GetEyeTrace().Entity:GetPos()) <= 100 then
        draw.DrawText( "Use your interaction key to open the menu! ", "TargetID", ScrW() * 0.5, ScrH() * 0.5, color_white, TEXT_ALIGN_CENTER )
    end
end)
