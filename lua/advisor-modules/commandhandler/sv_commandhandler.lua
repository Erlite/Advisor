Advisor = Advisor or {}
Advisor.CommandHandler = Advisor.CommandHandler or {}

util.AddNetworkString("Advisor.ServerRunConsoleCommand")

function Advisor.CommandHandler.RunCommand(sender, raw, cmd, args)
    if not cmd or getmetatable(cmd) ~= Advisor.Command then 
        PrintTable(cmd)
        ErrorNoHaltWithStack(string.format("Expected Advisor.Command, got: '%s'", cmd and type(cmd) or "nil"))
        return 
    end

    if not isfunction(cmd.Callback) then
        return
    end

    local parsedArgs = {}
    local cmdArgs = cmd:GetArguments()
    local ctx = Advisor.CommandContext()
    ctx:SetCommand(cmd)
    ctx:SetSender(sender)
    ctx:SetRawMessage(raw)
    ctx:SetParsedArguments(parsedArgs)

    -- Check that we have enough arguments to satisfy the command's request.
    if #args < cmd:GetRequiredAmount() then
        local missingArg = cmdArgs[#args]
        Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "commands", "missing_argument", missingArg:GetName())
        return ""
    end

    for i = 1, #cmdArgs do
        local arg = cmdArgs[i]
        local msgArg = args[i]

        -- break if the argument is a remainder one
        if arg:GetRemainder() then break end

        local parser = Advisor.CommandHandler.GetParser(arg:GetType())
        if not parser then 
            Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "parsers", "unknown", arg:GetType())
            return ""
        end

        if msgArg then
            local success, result = parser:Parse(ctx, msgArg)
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

    -- If the last argument is a remainder one, we'll pass the remaining text as a string.
    local lastArg = cmdArgs[#cmdArgs]
    if lastArg and lastArg:GetRemainder() then
        local rawName = string.Split(raw, " ")[1]

        local remainder = ""
        for i = #cmdArgs, #args do
            remainder = remainder .. args[i] .. " "
        end

        parsedArgs[#parsedArgs + 1] = remainder:sub(1, #remainder - 1)
    end

    -- And now we execute the command.
    local success, errorMsg = pcall(cmd.Callback, ctx, unpack(parsedArgs))
    if success then return "" end

    Advisor.Log.Error(LogCommands, "An error has occured while executing command '%s': %s", cmd:GetName(), errorMsg)
    Advisor.Utils.LocalizedMessage(sender, Color(255, 90, 90), "commands", "error_thrown", { cmd:GetName(), errorMsg } )
end

function Advisor.CommandHandler.OnPlayerMessage(sender, text, teamChat)
    -- Check if the message starts with the prefix.
    text = string.Trim(text)
    if not string.StartWith(text, Advisor.Config.Commands.Prefix) or #text == 1 then return end

    -- Remove the prefix
    text = text:sub(2, #text):Trim()

    local args = Advisor.Utils.ToStringArray(text)
    if #args == 0 then return end

    local commandTxt = args[1]
    local cmd = Advisor.CommandHandler.GetCommand(commandTxt)

    if Advisor.Config.Commands.CaseSensitive and commandTxt ~= cmd:GetName() then
        cmd = nil
    end

    if not cmd then 
        Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "commands", "unknown_command")
        return ""
    end

    local cmdArgs = {}
    for i = 2, #args do
        cmdArgs[#cmdArgs + 1] = args[i]
    end 

    Advisor.CommandHandler.RunCommand(sender, text, cmd, cmdArgs)
    return ""
end

hook.Add("PlayerSay", "Advisor.HandleCommand", Advisor.CommandHandler.OnPlayerMessage)

net.Receive("Advisor.ServerRunConsoleCommand", function(len, ply)
    local name = net.ReadString()

    local advisorCommand = Advisor.CommandHandler.GetCommand(name)
    if not advisorCommand then return end

    local raw = net.ReadString()
    local count = net.ReadUInt(16)
    local args = {}

    for i = 1, count do
        args[#args + 1] = net.ReadString()
    end

    Advisor.CommandHandler.RunCommand(ply, raw, advisorCommand, args)
end)