Advisor = Advisor or {}
Advisor.Theme = Advisor.Theme or {}

Advisor.Theme.Panel =
{
    Background = Color(41, 41, 41),
}

Advisor.Theme.TitleBar = 
{
    -- Color used for the background of the title bar.
    Background = Color(24, 24, 24),

    -- Font used for header displays.
    Font = "Rubik.Header",

    -- Radius of rounded edges for title bars. Set to 0 to disable.
    CornerRadius = 4,
}

Advisor.Theme.Button = 
{
    Close = 
    {
        Idle = Color(24, 24, 24),
        Hovered = Color(225, 45, 57),
        Pressed = Color(208, 17, 36),
        Disabled = Color(141, 141, 141)
    }
}