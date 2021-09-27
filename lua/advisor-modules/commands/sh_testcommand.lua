local newCmd = Advisor.CommandHandler.RegisterCommand("Advisor", "echo")
newCmd.Callback = function(ctx, rawText)
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