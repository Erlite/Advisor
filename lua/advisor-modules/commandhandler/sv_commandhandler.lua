Advisor = Advisor or {}
Advisor.CommandHandler = Advisor.CommandHandler or {}

function Advisor.CommandHandler.OnPlayerMessage(sender, text, teamChat)
    -- Check if the message starts with the prefix.
    text = string.Trim(text)
    if not string.StartWith(text, Advisor.Config.Commands.Prefix) or #text == 1 then return end

    -- Remove the prefix
    text = text:sub(2, #text):Trim()

    local args = Advisor.Utils.ToStringArray(text)
    if #args == 0 then return end

    local commandTxt = Advisor.Config.Commands.CaseSensitive and args[1] or args[1]:lower()
    local cmd = Advisor.CommandHandler.GetCommand(commandTxt)

    if not cmd then 
        Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "commands", "unknown_command")
        return ""
    end

    if not isfunction(cmd.Callback) then
        return ""
    end

    local parsedArgs = {}
    local cmdArgs = cmd:GetArguments()
    local ctx = Advisor.CommandContext()
    ctx:SetCommand(cmd)
    ctx:SetRawMessage(text)
    ctx:SetArguments(parsedArgs)

    -- Check that we have enough arguments to satisfy the command's request.
    if #args - 1 < cmd:GetRequiredAmount() then
        local missingArg = cmdArgs[#args]
        Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "commands", "missing_argument", missingArg:GetName())
        return ""
    end

    for i = 1, #cmdArgs do
        local arg = cmdArgs[i]
        local parser = Advisor.CommandHandler.GetParser(arg:GetType())
        if not parser then 
            Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "parsers", "unknown", arg:GetType())
            return ""
        end

        if args[i] then
            local success, result = parser:Parse(ctx, args[i])
            if not success then 
                Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), result.namespace, result.key, unpack(result.args or {}))
                return ""
            end 

            parsedArgs[#parsedArgs + 1] = result
        elseif arg:GetOptional() then
            parsedArgs[#parsedArgs + 1] = arg:GetDefault()
        else
            Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "commands", "missing_argument", arg:GetName())
            return ""
        end
    end

    -- If we have more arguments than required, we'll grab the remainding text and add it as the last argument.
    if #args > #cmdArgs then
        local remainder = ""
        for i = #cmdArgs + 1, #args do
            remainder = remainder .. args[i]
        end

        parsedArgs[#parsedArgs + 1] = remainder
    end

    -- And now we execute the command.
    cmd.Callback(ctx, unpack(parsedArgs))
end

hook.Add("PlayerSay", "Advisor.HandleCommand", Advisor.CommandHandler.OnPlayerMessage)