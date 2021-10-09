Advisor = Advisor or {}
Advisor.CommandHandler = Advisor.CommandHandler or {}

function Advisor.CommandHandler.Server_RunCommand(raw, cmd, args)

    local name = cmd:GetName()

    net.Start("Advisor.ServerRunConsoleCommand")
        net.WriteString(name)
        net.WriteString(raw)
        net.WriteUInt(#args, 16)

        for i = 1, #args do
            net.WriteString(args[i])
        end
    net.SendToServer()
end