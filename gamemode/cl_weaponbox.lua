include("shared.lua")
AddCSLuaFile( "cl_init.lua" )

local WeaponBox = "models/items/ammocrate_ar2.mdl"

local Items = 
{
    {"models/Items/HealthKit.mdl","","Health Kit",5000},
    {"models/Items/battery.mdl","item_battery","Armor",10000},

    -- Health

    {"models/Items/BoxSRounds.mdl","item_ammo_pistol_large","Pistol Ammo",150},
    {"models/Items/BoxMRounds.mdl","item_ammo_smg1_large","SMG Ammo",300},
    {"models/Items/BoxMRounds.mdl",
    "item_ammo_ar2_large","AR Ammo",500},
    {"models/Items/BoxBuckshot.mdl","item_box_buckshot","Shotgun Ammo",750},
    {"models/Items/357ammo.mdl","item_ammo_357","Rifle Ammo",1000},

    -- Ammo

    {"models/viper/mw/weapons/v_p320.mdl","mg_p320","P320", 4000},
    {"models/viper/mw/weapons/v_glock.mdl","mg_glock","Glock", 8000},
    {"models/viper/mw/weapons/v_deagle.mdl","mg_deagle","Deagle", 10000},

    -- Pistols

    {"models/viper/mw/weapons/v_mpapa5.mdl","mg_mpapa5","MP5", 15000},
    {"models/viper/mw/weapons/v_augolf.mdl","mg_augolf","Aug",20000},
    {"models/viper/mw/attachments/uzulu/attachment_vm_sm_uzulu_receiver.mdl","mg_uzulu","Uzi", 25000},
    {"models/viper/mw/weapons/v_mpapa7.mdl","mg_mpapa7","MP7", 30000},
    {"models/viper/mw/weapons/v_secho.mdl","mg_secho","Scorpion", 35000},
    {"models/viper/mw/weapons/v_victor.mdl","mg_victor","Vector", 50000},
    
    -- Smgs

    {"models/viper/mw/weapons/v_akilo47.mdl","mg_augolf","AK47", 50000},
    {"models/viper/mw/weapons/v_falima.mdl","mg_falima","FAL", 60000},
    {"models/viper/mw/weapons/v_mike4.mdl","mg_mike4","M4A1", 85000},
    {"models/viper/mw/weapons/v_scharlie.mdl","mg_scharlie","FN Scar 17", 10000},
    {"models/viper/mw/weapons/v_tango21.mdl","mg_tango21","RAM-7", 125000},

    -- ARs

    {"models/viper/mw/weapons/v_kilo98.mdl","mg_kilo98","Kar98", 100000},
    {"models/viper/mw/weapons/v_mike14.mdl","mg_mike14","M14", 175000},
    {"models/viper/mw/weapons/v_sksierra.mdl","mg_sksierra","SKS", 235000},

    -- Rifles

    {"models/viper/mw/weapons/v_romeo870.mdl","mg_romeo870","Romeo 870", 100000},
    {"models/viper/mw/weapons/v_dpapa12.mdl","mg_dpapa12","R9-0", 175000},
    {"models/viper/mw/weapons/v_oscar12.mdl","mg_aalpha12","Jak-12", 235000},

    -- Shotguns

    {"models/viper/mw/weapons/v_dblmg.mdl","","Mini Gun", 500000},
    {"models/props/cs_assault/Money.mdl","","Customization", 100000}, -- maybe should be 100k

    -- Specials
}

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
    Frame:SetSize(800,500)
    Frame:Center()
    Frame:MakePopup()
    Frame.Paint = function(self, w, h)
        surface.SetDrawColor(Color(45,45,45))
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(Color(222,16,50))
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    function Frame:OnClose()
        net.Start("RemoveGod")
        net.SendToServer()
    end

    local DScrollPanel = vgui.Create("DScrollPanel", Frame)
    DScrollPanel:Dock(FILL)
    local YPos = 5
    for k,v in pairs(Items) do

        local ItemPanel = vgui.Create("DPanel", DScrollPanel)
        ItemPanel:SetPos(0,YPos)
        ItemPanel:SetBackgroundColor(Color(45,45,45))
        ItemPanel:SetSize(Frame:GetWide() -10,Frame:GetTall() * 0.2)
        local model = vgui.Create("DModelPanel", ItemPanel)
        model:SetPos(10,0)
        model:SetModel(tostring(v[1]))
        model:SetSize(100,100)
        model:SetFOV(40)
        model:SetCamPos(Vector(50, 0, 0))
        model:SetLookAt(Vector(0, 0, 0))
        function model:LayoutEntity(ent)
            ent:SetAngles(Angle(0, RealTime()*100,  0))
        end
        
        local ItemLabel = vgui.Create("DLabel", ItemPanel)
        ItemLabel:SetPos((ItemPanel:GetWide() * 0.5) - 80, 0)
        ItemLabel:SetSize(1000,100)
        ItemLabel:SetColor(Color(255,255,255))
        ItemLabel:SetFont("LabelFont")
        ItemLabel:SetText(tostring(v[3]))

        local ItemButton = vgui.Create("DButton", ItemPanel)
        ItemButton:SetFont("LabelFont")
        ItemButton:SetPos(ItemPanel:GetWide() - 140, 30)
        ItemButton:SetSize(95,40)
        ItemButton:SetText("$"..tostring(v[#v]))
        ItemButton:SetColor(Color(222,16,50))
        ItemButton.Paint = function(self, w, h)
            ItemButton:SetColor(Color(222,16,50))
            surface.SetDrawColor(Color(222,16,50))
            surface.DrawOutlinedRect(0, 0, w, h,2)
            
            if self:IsHovered() then
                surface.SetDrawColor(Color(0,250,0))
                surface.DrawOutlinedRect(0, 0, w, h,2)
                ItemButton:SetColor(Color(0,250,0))
            end
        end

        function ItemButton:DoClick()
            if v[3] == "Mini Gun" && LocalPlayer():GetNWInt("PlayerPrestige") < 20 then
                notification.AddLegacy("You do not meet the required prestige for that weapon(Prestige: 20).", 1, 2)
                surface.PlaySound("physics/surfaces/sand_impact_bullet1.wav")
                return 
            end
            if LocalPlayer():GetNWInt("MoneyAmount") >= v[#v] then
                for index,weapon in pairs(LocalPlayer():GetWeapons()) do
                    if weapon:GetClass() == v[2] then
                        notification.AddLegacy("You already have that weapon.", 2, 2)
                        surface.PlaySound("physics/surfaces/sand_impact_bullet1.wav")
                        return
                    end
                end

                net.Start("RecieveWeapon")
                    net.WriteTable({v[2],v[3],v[#v]})
                net.SendToServer()
                surface.PlaySound("buttons/bell1.wav")
                notification.AddLegacy("You successfully purchased ".. v[3] .. ".", 0, 2)
            else
                notification.AddLegacy("You don't have enough money for that.", 1, 2)
                surface.PlaySound("physics/surfaces/sand_impact_bullet1.wav")
            end
        end


        YPos = YPos + ItemPanel:GetTall() * 1.1 
    end
end

net.Receive("OpenInteraction", function()
    CreateGui()
end)

hook.Add("HUDPaint", "Interaction", function()
    if !IsValid(LocalPlayer():GetEyeTrace().Entity) then return end
    local Player = LocalPlayer()
    local EyeTrace = Player:GetEyeTrace()
    local EyeTraceEnt = EyeTrace.Entity
    local EntTracePosToScreen = EyeTraceEnt:GetPos():ToScreen()


    if EyeTraceEnt:GetModel() == WeaponBox && Player:GetPos():Distance(EyeTraceEnt:GetPos()) <= 85 then
        surface.SetFont("TargetID")
        surface.SetTextPos(EntTracePosToScreen["x"] - 150, EntTracePosToScreen["y"] - 120)
        surface.SetTextColor(255, 255, 255, 255)
        surface.DrawText( "Use your interaction key to open the menu! ")
    end
end)