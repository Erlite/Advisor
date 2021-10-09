local PANEL = {}

-- Taken from vgui/dframe.lua
AccessorFunc( PANEL, "m_bIsMenuComponent",	"IsMenu",			FORCE_BOOL )
AccessorFunc( PANEL, "m_bDraggable",		"Draggable",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable",			"Sizable",			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",		"ScreenLock",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose",	"DeleteOnClose",	FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow",		"PaintShadow",		FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth",			"MinWidth",			FORCE_NUMBER )
AccessorFunc( PANEL, "m_iMinHeight",		"MinHeight",		FORCE_NUMBER )

AccessorFunc( PANEL, "m_bBackgroundBlur",	"BackgroundBlur",	FORCE_BOOL )

function PANEL:Init()

    -- Default DFrame code
    self:SetFocusTopLevel( true )
    self:SetPaintShadow( true )

    self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )


    self.TitleBar = vgui.Create("Advisor.TitleBar", self)
    self.TitleBar:Dock(TOP)
    self:SetTitle("Window")

    self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()
end

function PANEL:GetTitle()
    return self.TitleBar:GetTitle()
end

function PANEL:SetTitle(title)
    self.TitleBar:SetTitle(title)
end

function PANEL:IsActive()

	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false

end

function PANEL:Close()

	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()

end

function PANEL:OnClose()
end

vgui.Register("Advisor.Window", PANEL, "EditablePanel")