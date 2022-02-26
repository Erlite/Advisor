Advisor = Advisor or {}
Advisor.Theme = Advisor.Theme or {}

Advisor.Theme.FlavorText = 
{
    "Who needs ULX anyway?",
    "Protocol 3: Protect the community.",
    "Also play Titanfall 2!",
    "segmentation fault (core dumped)",
    "(⌐▨_▨)",
    "The ultimate open-source administration framework!",
    "Fun fact: this is the first time Erlite's worked on UI.",
    "Have a very safe day!",
    "How are you holding up? Because I'm a potato.",
    "Roxas, that's a stick.",
    "Got it memorized?",
    "Sir, finishing the mission.",
}

Advisor.Theme.Panel =
{
    -- Color of the panel's background
    Background = Color(41, 41, 41),

    -- Color of the footer's background
    Footer = Color(209, 129, 1),
    -- Radius of the rounded edges for the bottom of the panel.
    FooterBottomRadius = 4,
}

Advisor.Theme.ScrollPanel = 
{
    Background = Color(31, 31, 31),
    VerticalBar = Color(75, 75, 75),
    VerticalGrip = Color(209, 129, 1),
    BottomLeftCornerRadius = 4,
}

Advisor.Theme.Category = 
{
    Background = Color(21, 21, 21),
    TextColor = Color(255, 255, 255),
}

Advisor.Theme.MenuOption = 
{
    IdleBackground = Color(31, 31, 31),
    HoveredBackground = Color(11, 11, 11),
    SelectedBackground = Color(11, 11, 11),
    SelectedAccent = Color(209, 129, 1),
}

Advisor.Theme.TitleBar = 
{
    -- Color used for the background of the title bar.
    Background = Color(24, 24, 24),

    -- Font used for header displays.
    Font = "Advisor:Rubik.Header",

    -- Radius of rounded edges for title bars. Set to 0 to disable.
    CornerRadius = 4,
}

Advisor.Theme.Button = 
{
    -- Which corners to round, like draw.RoundedBoxEx
    -- topLeft, topRight, bottomLeft, bottomRight
    RoundedCorners = { true, true, true, true },
    -- Radius of the rounded corners on buttons. Set to 0 to disable.
    CornerRadius = 4,
    -- Space between the Icon and the Text on buttons.
    IconMargin = 6,

    -- Default colors for buttons.
    Default = 
    {
        Text = Color(241, 232, 255),
        Idle = Color(209, 129, 1),
        Hovered = Color(199, 124, 5),
        Pressed = Color(189, 124, 5),
        Disabled = Color(141, 141, 141),
    },

    Discord = 
    {
        Text = Color(241, 232, 255),
        Idle = Color(86, 99, 247),
        Hovered = Color(77, 89, 218),
        Pressed = Color(72, 83, 201),
        Disabled = Color(141, 141, 141)
    },

    Close = 
    {
        Idle = Color(24, 24, 24),
        Hovered = Color(225, 45, 57),
        Pressed = Color(208, 17, 36),
        Disabled = Color(141, 141, 141)
    },

    Maximize = 
    {
        Idle = Color(24, 24, 24),
        Hovered = Color(75, 75, 75),
        Pressed = Color(52, 59, 59),
        Disabled = Color(141, 141, 141)
    },

    Minimize = 
    {
        Idle = Color(24, 24, 24),
        Hovered = Color(75, 75, 75),
        Pressed = Color(52, 59, 59),
        Disabled = Color(141, 141, 141)
    },

    Delete = 
    {
        Idle = Color(255, 90, 90),
        Hovered = Color(233, 77, 77),
        Pressed = Color(196, 68, 68),
        Disabled = Color(141, 141, 141),
    },
}

Advisor.Theme.HeaderBox = 
{
    HeaderValidationAccent = Color(60, 241, 60),
    HeaderErrorAccent = Color(255, 90, 90),
    HeaderTextColor = Color(255, 255, 255),
    HeaderCornerRadius = 4,
    HeaderAccentColor = Color(209, 129, 1),
    HeaderBackgroundColor = Color(21, 21, 21),
    BodyBackgroundColor = Color(31, 31, 31),
    BodyTextColor = Color(255, 255, 255),
    BodyCornerRadius = 4,
}

Advisor.Theme.TextEntry =
{
    CornerRadius = 4,
    BackgroundColor =  Color(31, 31, 31),
    IdleAccentColor = Color(21, 21, 21),
    SelectedAccentColor = Color(209, 129, 1),
    TextColor = Color(255, 255, 255),
    HighlightColor = Color(209, 129, 1),
    CursorColor = Color(209, 129, 1),
}

Advisor.Theme.SettingOption = 
{
    SeparatorColor = Color(100, 100, 100),
}

Advisor.Theme.ColorButton = 
{
    CornerRadius = 4,
    EmptyOutlineColor = Color(100, 100, 100),
}

Advisor.Theme.Tooltip = 
{
    CornerRadius = 4,
    BackgroundColor = Color(24, 25, 28),
    OutlineColor = Color(209, 129, 1),
    TextColor = Color(255, 255, 255),
}

Advisor.Theme.ColorPicker = 
{
    CornerRadius = 4,
    BackgroundColor = Color(25, 25, 25),
    OutlineColor = Color(209, 129, 1),
}