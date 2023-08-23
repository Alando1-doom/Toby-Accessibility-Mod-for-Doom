//Original ACS implementation by Jarewill

class Toby_PlayerStatusCheckHandler: EventHandler
{
    override void InterfaceProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        if (!player.mo) { return; }
        if (e.Name == "Toby_CheckHealth")
        {
            Toby_HealthChecker.CheckHealthLegacy(player);
        }
        if (e.Name == "Toby_CheckAmmo")
        {
            Toby_AmmoChecker.CheckAmmoLegacy(player);
        }
    }
}
