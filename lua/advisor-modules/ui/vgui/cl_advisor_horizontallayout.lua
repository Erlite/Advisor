local PANEL = {}

-- Get/set the space left between children of this horizontal layout.
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
    local paddingLeft, _, paddingRight = self:GetDockPadding()
    local totalPadding = paddingLeft + paddingRight
    local totalSpacing = spacing * (count - 1)
    local freeSpace = (w - totalPadding) - totalSpacing
    local elementSize = freeSpace / count

    local currentX = paddingLeft

    for i = 1, count do
        local child = children[i]
        child:SetWidth(elementSize)
        child:SetX(currentX)

        currentX = currentX + elementSize + spacing
    end
end

vgui.Register("Advisor.HorizontalLayout", PANEL, "Panel")