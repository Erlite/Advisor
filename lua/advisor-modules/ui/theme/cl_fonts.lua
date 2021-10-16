-- local function ScreenScale(x)
--   return x / 2560 * ScrW()
-- end

local function GenerateAdvisorFonts()
    surface.CreateFont("Advisor:Rubik.Header",
    {
        font = "Rubik",
        size = ScreenScale(6),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.Footer",
    {
        font = "Rubik",
        size = ScreenScale(5),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.Body",
    {
        font = "Rubik",
        size = ScreenScale(5.5),
        antialias = true,
    })

    surface.CreateFont("Advisor:Rubik.Button",
    {
        font = "Rubik",
        size = ScreenScale(6),
        antialias = true,
        weight = 525,
    })

    surface.CreateFont("Advisor:Rubik.TextEntry", 
    {
        font = "Rubik",
        size = ScreenScale(5),
        antialias = true,
    })

    surface.CreateFont("Advisor:Awesome",
    {
        font = "Font Awesome 5 Free Solid",
        antialias = true,
        extended = true,
        size = ScreenScale(5),
    })

    surface.CreateFont("Advisor:SmallAwesome",
    {
        font = "Font Awesome 5 Free Solid",
        antialias = true,
        extended = true,
        size = ScreenScale(4),
    })
end

GenerateAdvisorFonts()
hook.Add("OnScreenSizeChanged", "Advisor:OnScreenSizeChanged:ReGenerateFonts", GenerateAdvisorFonts)