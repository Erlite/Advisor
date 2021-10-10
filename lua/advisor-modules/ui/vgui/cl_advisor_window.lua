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

    self.Body = vgui.Create("Advisor.Panel", self)	
    self.Footer = vgui.Create("Advisor.Footer", self)

    self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

    function self.TitleBar:OnMousePressed(key)
        self:GetParent():OnMousePressed(key)
    end

    function self.Body:OnMousePressed(key)
        self:GetParent():OnMousePressed(key)
    end

	function self.Footer:OnMousePressed(key)
        self:GetParent():OnMousePressed(key)
    end

    function self.TitleBar:OnMouseReleased(key)
        self:GetParent():OnMouseReleased(key)
    end

    function self.Body:OnMouseReleased(key)
        self:GetParent():OnMouseReleased(key)
    end

	function self.Footer:OnMouseReleased(key)
        self:GetParent():OnMouseReleased(key)
    end
end

function PANEL:GetTitle()
    return self.TitleBar:GetTitle()
end

function PANEL:SetTitle(title)
    self.TitleBar:SetTitle(title)
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

function PANEL:Center()
	self:InvalidateLayout( true )
	self:CenterVertical()
	self:CenterHorizontal()
end

function PANEL:IsActive()
	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end
	return false
end

function PANEL:Think()

	local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )

	end

	if ( self.Sizing ) then

		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px && self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py && self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		self:SetCursorAll( "sizenwse" )
		return

	end

	local screenX, screenY = self:LocalToScreen( 0, 0 )
    local _, _, boundsWidth, boundsHeight = self:GetBounds()
	if ( self:IsChildHovered() && self.m_bSizable && mousex > ( screenX + self:GetWide() - 20 ) && mousey > ( screenY + boundsHeight - 20 ) ) then

		self:SetCursorAll( "sizenwse" )
		return

	end

	if ( self.TitleBar:IsHovered() && self:GetDraggable() && mousey < ( screenY + 24 ) ) then
		self:SetCursorAll( "sizeall" )
		return
	end

	self:SetCursorAll( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end

end

function PANEL:OnMousePressed()
	local screenX, screenY = self:LocalToScreen( 0, 0 )
    local _, _, boundsWidth, boundsHeight = self:GetBounds()

	if ( self.m_bSizable && gui.MouseX() > ( screenX + boundsWidth - 20 ) && gui.MouseY() > ( screenY + boundsHeight - 20 ) ) then
		self.Sizing = { gui.MouseX() - boundsWidth, gui.MouseY() - boundsHeight }
		self:MouseCapture( true )
		return
	end

	if ( self:GetDraggable() && gui.MouseY() < ( screenY + self.TitleBar:GetTall() ) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return
	end
end

function PANEL:SetCursorAll(new)
	self:SetCursor( new )
    self.TitleBar:SetCursor( new )
    self.Body:SetCursor( new )
    self.Footer:SetCursor( new )
end

function PANEL:OnMouseReleased()
	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )
end

vgui.Register("Advisor.Window", PANEL, "EditablePanel")