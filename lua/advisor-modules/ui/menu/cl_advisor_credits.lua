local PANEL = {}

function PANEL:Init()  
    self.AdvisorIconMat = Material("resource/materials/advisor.png", "smooth")
    self.GCAIconMat = Material("resource/materials/gca.png", "smooth")

    self.Image = vgui.Create("DImage", self)
    self.Image:SetMaterial(self.AdvisorIconMat)
    self.Image:SetSize(128, 128)
    self.Image:SetMouseInputEnabled(true)
    self.Image:SetCursor("hand")

    function self.Image:OnMousePressed()
        gui.OpenURL("https://github.com/Erlite/gmod-advisor")
    end

    self.GCAImage = vgui.Create("DImage", self)
    self.GCAImage:SetMaterial(self.GCAIconMat)
    self.GCAImage:SetSize(128, 128)
    self.GCAImage:SetMouseInputEnabled(true)
    self.GCAImage:SetCursor("hand")
    
    function self.GCAImage:OnMousePressed()
        gui.OpenURL("https://g-ca.fr/")
    end


    self.CreditBody = vgui.Create("DTextEntry", self)
    self.CreditBody:SetEditable(false)
    self.CreditBody:SetMultiline(true)
    self.CreditBody:SetFont("Rubik.Header")
    
    local text = 
    [[
Advisor

The ultimate open source administration framework.
Created by Erlite @ github.com/Erlite & Erlite#1337

Special Thanks:

- Game Creators Area @ discord.gg/gca
- Enzo @ en-zo.dev
- Brique au bob
- Pilot2
- Yoh Sambre
    ]]

    self.CreditBody:SetTextColor(Color(255, 255, 255))
    self.CreditBody:SetText(text)
    self.CreditBody:SizeToContents()
    self.CreditBody:SetPaintBackground(false)
end

function PANEL:PerformLayout(w, h)
    self.Image:SetPos(32, 32)
    self.GCAImage:SetPos(64 + self.Image:GetWide(), 32)
    self.CreditBody:SetPos( 32, 48 + self.Image:GetTall())
    self.CreditBody:SetSize( w, h )
end 

vgui.Register("Advisor.Menu.Credits", PANEL, "Advisor.Panel")