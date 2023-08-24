//Original ACS implementation by Jarewill

class Toby_PlayerStatusCheckHandler: EventHandler
{
    override void InterfaceProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        if (!player.mo) { return; }
        if (e.Name == "Toby_CheckHealthInterface")
        {
            Toby_HealthChecker.CheckHealthLegacy(player);
        }
        if (e.Name == "Toby_CheckAmmoInterface")
        {
            Toby_AmmoChecker.CheckAmmoLegacy(player);
        }
    }

    //Is this stupid?
    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        if (!player.mo) { return; }
        if (e.Name == "Toby_CheckHealth")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckHealthInterface");
        }
        if (e.Name == "Toby_CheckAmmo")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckAmmoInterface");
        }
    }
}
