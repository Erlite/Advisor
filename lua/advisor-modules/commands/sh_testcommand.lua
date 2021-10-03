local newCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "echo")
newCmd:AddRemainderArgument("message", "The message to echo.")
newCmd.Callback = function(ctx, rawText)
    print(rawText)
    if rawText and #rawText > 0 then
        PrintMessage(HUD_PRINTTALK, rawText)
    end
end

local addCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "add")
addCmd:AddArgument("firstNumber", "number")
addCmd:AddArgument("secondNumber", "number")
addCmd.Callback = function(ctx, first, second)
    PrintMessage(HUD_PRINTTALK, tostring(first + second))
end

local slayCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "slay")
slayCmd:AddArgument("target", "player")
slayCmd.Callback = function(ctx, targets)
    for _, found in ipairs(targets) do
        found.ply:Kill()
    end
end