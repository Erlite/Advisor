local newCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "echo", "Sends the given message to the chat & console of all players.")
newCmd:AddRemainderArgument("message", "The message to echo.")
newCmd.Callback = function(ctx, rawText)
    print(rawText)
    if rawText and #rawText > 0 then
        PrintMessage(HUD_PRINTTALK, rawText)
    end
end

local addCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "add")
addCmd:AddArgument("firstNumber", "number", "The first number to add.")
addCmd:AddArgument("secondNumber", "number", "The second number to add.")
addCmd.Callback = function(ctx, first, second)
    PrintMessage(HUD_PRINTTALK, tostring(first + second))
end

local slayCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "slay", "Kills the given player(s).")
slayCmd:AddArgument("target", "player")
slayCmd.Callback = function(ctx, targets)
    for _, found in ipairs(targets) do
        found.ply:Kill()
    end
end

local reloadCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "reload", "Reloads the current map")
reloadCmd.Callback = function(ctx)
    RunConsoleCommand("changelevel", game.GetMap())
end

local menuCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "menu", "Opens Advisor's user interface.")
menuCmd.Callback = function(ctx)
    if not IsValid(ctx:GetSender()) then return end
    Advisor.UI.ClientOpenMenu(ctx:GetSender())
end

local clockCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "clock", "Show the current date and time. Can handle additional time.")
clockCmd:AddOptionalArgument("add_time", "time", 0)
clockCmd.Callback = function(ctx, time)
    local totalTime = os.time() + time
    local dateText = os.date("%d/%m/%Y - %H:%M:%S", totalTime)
    if time > 0 then
        dateText = os.date("%d/%m/%Y - %H:%M:%S") .. " => " .. dateText
    end

    local ply = ctx:GetSender()
    if not IsValid(ply) then
        print(dateText)
    else
        PrintMessage(HUD_PRINTTALK, dateText)
    end
end