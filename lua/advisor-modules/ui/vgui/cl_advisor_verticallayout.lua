local PANEL = {}

-- Get/set the space left between children of this vertical layout.
AccessorFunc(PANEL, "Spacing", "Spacing", FORCE_NUMBER)
-- Whether or not elements in this panel determine the height of it.
AccessorFunc(PANEL, "FlexibleHeight", "FlexibleHeight", FORCE_BOOL)
-- Cached content size for the PANEL:GetContentSize() override. Calculated in PerformLayout()
AccessorFunc(PANEL, "CurrentContentSize", "CurrentContentSize")

function PANEL:Init()
    self:SetSpacing(0)
    self:SetFlexibleHeight(false)
end

function PANEL:Paint() end

function PANEL:OnChildAdded(child)
    child:Dock(NODOCK)
end

function PANEL:PerformLayout(w, h)
    local children = self:GetChildren()
    local count = #children
    if count == 0 then return end

    local isFlexible = self:GetFlexibleHeight()
    local spacing = self:GetSpacing()
    local paddingLeft, paddingTop, paddingRight, paddingBottom = self:GetDockPadding()
    local currentY = paddingTop

    local newWidth = w - (paddingLeft + paddingRight)

    if isFlexible then
        for i = 1, count do
            local child = children[i]

            child:SetWidth(newWidth)
            child:SetPos(paddingLeft, currentY)

            currentY = currentY + child:GetTall() + spacing
        end

        local size = (currentY - spacing) + paddingBottom
        self:SetHeight(size)
        self:SetCurrentContentSize(size)
    else
        local totalPadding = paddingTop + paddingBottom
        local totalSpacing = spacing * (count - 1)
        local freeSpace = (h - totalPadding) - totalSpacing
        local elementSize = freeSpace / count

        for i = 1, count do
            local child = children[i]
            child:SetWidth(newWidth)
            child:SetX(paddingLeft)
            child:SetHeight(elementSize)
            child:SetY(currentY)

            currentY = currentY + child:GetTall() + spacing
        end

        self:SetCurrentContentSize(h)
    end
end

function PANEL:GetContentSize()
    return self:GetWide(), self:GetCurrentContentSize() or self:GetTall()
end

vgui.Register("Advisor.VerticalLayout", PANEL, "Panel")