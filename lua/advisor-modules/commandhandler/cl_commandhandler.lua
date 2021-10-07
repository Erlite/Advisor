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

net.Receive("Advisor.ClientRunCommand", function(len, ply)
    local name = net.ReadString()
    local cmd = Advisor.CommandHandler.GetCommand(name)
    if not cmd then return end

    local raw = net.ReadString()

    local count = net.ReadUInt(16)
    local args = {}
    for i = 1, count do
        args[i] = net.ReadString()
    end

    Advisor.CommandHandler.RunCommand(LocalPlayer(), raw, cmd, args)
end)