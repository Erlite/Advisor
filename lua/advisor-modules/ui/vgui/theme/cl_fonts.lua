local function SizeByRatio(x)
  return x / 2560 * ScrW()
end

local function GenerateAdvisorFonts()
  surface.CreateFont("Advisor:Rubik.Header",
  {
      font = "Rubik",
      size = SizeByRatio(32),
      antialias = true,
  })

  surface.CreateFont("Advisor:Rubik.Footer",
  {
      font = "Rubik",
      size = SizeByRatio(26),
      antialias = true,
  })

  surface.CreateFont("Advisor:Rubik.Body",
  {
      font = "Rubik",
      size = SizeByRatio(27),
      antialias = true,
  })

  surface.CreateFont("Advisor:Rubik.Button",
  {
      font = "Rubik",
      size = SizeByRatio(24),
      antialias = true,
  })

  surface.CreateFont("Advisor:Awesome",
  {
      font = "Font Awesome 5 Free Solid",
      antialias = true,
      extended = true,
      size = SizeByRatio(27),
  })

  surface.CreateFont("Advisor:SmallAwesome",
  {
      font = "Font Awesome 5 Free Solid",
      antialias = true,
      extended = true,
      size = SizeByRatio(23),
  })
end

GenerateAdvisorFonts()
hook.Add("OnScreenSizeChanged", "Advisor:OnScreenSizeChanged:ReGenerateFonts", GenerateAdvisorFonts)