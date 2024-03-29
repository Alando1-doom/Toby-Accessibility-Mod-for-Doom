//Original ACS implementation by Jarewill

class Toby_PlayerStatusCheckStaticHandler: StaticEventHandler
{
    ui bool isNotFirstRun;
    ui Toby_SoundBindingsContainer keysSoundBindingsContainer;
    ui Toby_SoundBindingsContainer weaponsSoundBindingsContainer;
    ui Toby_SoundBindingsContainer ammoSoundBindingsContainer;
    ui Toby_SoundBindingsContainer armorSoundBindingsContainer;

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            keysSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_KeyNameSoundBindings");
            weaponsSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_WeaponNameSoundBindings");
            ammoSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_AmmoNameSoundBindings");
            armorSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_ArmorNameSoundBindings");
        }
    }

    override void InterfaceProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        if (!player.mo) { return; }
        if (e.Name == "Toby_CheckHealthInterface")
        {
            if (CVar.FindCvar("Toby_UseLegacyHealthChecker").GetBool())
            {
                Toby_HealthChecker.CheckHealthLegacy(player);
            }
            else
            {
                Toby_HealthChecker.CheckHealth(player);
            }
        }
        if (e.Name == "Toby_CheckArmorInterface")
        {
            Toby_ArmorChecker.CheckArmor(player, armorSoundBindingsContainer);
        }
        if (e.Name == "Toby_CheckAmmoInterface")
        {
            if (CVar.FindCvar("Toby_UseLegacyAmmoChecker").GetBool())
            {
                Toby_AmmoChecker.CheckAmmoLegacy(player);
            }
            else
            {
                Toby_AmmoChecker.CheckAmmo(player, weaponsSoundBindingsContainer, ammoSoundBindingsContainer);
            }
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
        if (e.Name == "Toby_CheckArmor")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckArmorInterface");
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
