local convarTextScale = CreateClientConVar("advisor_text_scale", "1", true, false, "Change text font scale from 50% to 200%", 0.5, 2)

local function SizeByRatio(x, is_static)
  return x / 2560 * ScrW() * ( is_static and 1 or convarTextScale:GetFloat() )
end

local function GenerateAdvisorFonts()
    surface.CreateFont("Advisor:Rubik.StaticSmall",
    {
        font = "Rubik",
        size = SizeByRatio(16, true),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.Header",
    {
        font = "Rubik",
        size = SizeByRatio(24),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.Footer",
    {
        font = "Rubik",
        size = SizeByRatio(20),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.Body",
    {
        font = "Rubik",
        size = SizeByRatio(22),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.OptionTitle",
    {
        font = "Rubik",
        size = SizeByRatio(20),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.OptionDescription",
    {
        font = "Rubik",
        size = SizeByRatio(18),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.Button",
    {
        font = "Rubik",
        size = SizeByRatio(24),
        antialias = true,
        weight = 525,
    })

    surface.CreateFont("Advisor:Rubik.TextEntry", 
    {
        font = "Rubik",
        size = SizeByRatio(20),
        antialias = true,
    })

    surface.CreateFont("Advisor:FontAwesome",
    {
        font = "Font Awesome 5 Free Solid",
        antialias = true,
        extended = true,
        size = SizeByRatio(20),
    })

    surface.CreateFont("Advisor:SmallFontAwesome",
    {
        font = "Font Awesome 5 Free Solid",
        antialias = true,
        extended = true,
        size = SizeByRatio(16),
    })

    surface.CreateFont("Advisor:ForkAwesome",
    {
        font = "forkawesome",
        antialias = true,
        extended = true,
        size = SizeByRatio(20),
    })

    surface.CreateFont("Advisor:SmallForkAwesome",
    {
        font = "forkawesome",
        antialias = true,
        extended = true,
        size = SizeByRatio(16),
    })
    
    if Advisor.UI and IsValid(Advisor.UI.MainPanel) then
        Advisor.UI.MainPanel:InvalidateChildren(true)
    end
end

GenerateAdvisorFonts()
cvars.AddChangeCallback(convarTextScale:GetName(), GenerateAdvisorFonts, "Advisor.GenerateAdvisorFonts")
hook.Add("OnScreenSizeChanged", "Advisor:OnScreenSizeChanged:ReGenerateFonts", GenerateAdvisorFonts)    