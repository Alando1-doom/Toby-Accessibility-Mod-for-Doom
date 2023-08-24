//Original ACS implementation by Jarewill

class Toby_PlayerStatusCheckStaticHandler: StaticEventHandler
{
    ui bool isNotFirstRun;
    ui Toby_SoundBindingsContainer keysSoundBindingsContainer;

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            keysSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_KeyNameSoundBindings");
        }
    }

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
        if (e.Name == "Toby_CheckKeysInterface")
        {
            Toby_KeyChecker.CheckKeys(player, keysSoundBindingsContainer);
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
        if (e.Name == "Toby_CheckKeys")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckKeysInterface");
        }
    }
}
