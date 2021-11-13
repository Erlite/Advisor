local PANEL = {}

-- Get/set the space left between children of this vertical layout.
AccessorFunc(PANEL, "Spacing", "Spacing", FORCE_NUMBER)

function PANEL:Init()
    self:SetSpacing(0)
end

function PANEL:Paint() end

function PANEL:OnChildAdded(child)
    child:Dock(NODOCK)
end

function PANEL:PerformLayout(w, h)
    local children = self:GetChildren()
    local count = #children
    if count == 0 then return end

    local spacing = self:GetSpacing()
    local paddingLeft, paddingTop, paddingRight, paddingBottom = self:GetDockPadding()
    local totalPadding = paddingTop + paddingBottom
    local totalSpacing = spacing * (count - 1)
    local freeSpace = (h - totalPadding) - totalSpacing
    local elementSize = freeSpace / count

    local currentY = paddingTop

    for i = 1, count do
        local child = children[i]
        child:SetWidth(w - (paddingLeft + paddingRight))
        child:SetX(paddingLeft)
        child:SetHeight(elementSize)
        child:SetY(currentY)

        currentY = currentY + elementSize + spacing
    end
end

vgui.Register("Advisor.VerticalLayout", PANEL, "Panel")