Advisor = Advisor or {}
Advisor.CommandHandler = Advisor.CommandHandler or {}

util.AddNetworkString("Advisor.ServerRunConsoleCommand")
util.AddNetworkString("Advisor.ClientRunCommand")

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

    -- Check the command realm of the command.
    local realm = cmd:GetRealm()

    if realm == Advisor.CommandRealm.Server then 
        Advisor.CommandHandler.RunCommand(sender, text, cmd, cmdArgs)
    elseif realm == Advisor.CommandRealm.Client then
        Advisor.CommandHandler.Client_RunCommand(sender, text, cmd, cmdArgs)
    elseif realm == Advisor.CommandRealm.Shared then 
        Advisor.CommandHandler.RunCommand(sender, text, cmd, cmdArgs)
        Advisor.CommandHandler.Client_RunCommand(sender, text, cmd, cmdArgs)
    end
    return ""
end

hook.Add("PlayerSay", "Advisor.HandleCommand", Advisor.CommandHandler.OnPlayerMessage)

function Advisor.CommandHandler.Client_RunCommand(client, text, cmd, args)
    if not cmd:CanRunOnClient() then 
        ErrorNoHaltWithStack("Cannot run command '", cmd:GetName(), "' on clients as it is server only.")
        return
    end

    net.Start("Advisor.ClientRunCommand")
        net.WriteString(cmd:GetName())
        net.WriteString(text)
        net.WriteUInt(#args, 16)
        for i = 1, #args do 
            net.WriteString(args[i])
        end
    net.Send(client)
end

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