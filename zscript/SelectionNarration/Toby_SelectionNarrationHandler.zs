class Toby_SelectionNarrationHandler : EventHandler
{
    int maxPlayers;
    Array<string> previousWeapon;
    private ui bool isNotFirstRun;
    private ui Toby_SoundBindingsLoaderStaticHandler bindings;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_SelectionNarrationHandler registered!", "Toby_Developer");
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();
        }
    }

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        for (int i = 0; i < maxPlayers; i++)
        {
            previousWeapon.push("");
        }
    }

    override void WorldTick()
    {
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            if (!players[i].mo) { continue; }
            string currentWeapon = players[i].mo.player.ReadyWeapon.GetClassName();
            if (currentWeapon == previousWeapon[i]) { continue; }
            if (previousWeapon[i] == "")
            {
                previousWeapon[i] = currentWeapon;
                continue;
            }
            if (Cvar.GetCvar("Toby_SelectionNarrationWeapons", players[i]).GetBool())
            {
                EventHandler.SendInterfaceEvent(i, "Toby_SelectionNarrationWeapon:"..currentWeapon);
            }
            previousWeapon[i] = currentWeapon;
        }
    }

    override void InterfaceProcess(ConsoleEvent e)
    {
        Array<String> eventAndArguments;
        e.Name.split(eventAndArguments, ":", TOK_KEEPEMPTY);
        string event = eventAndArguments[0];
        Array<string> args;
        if (eventAndArguments.Size() > 1)
        {
            for (int i = 1; i < eventAndArguments.Size(); i++)
            {
                args.push(eventAndArguments[i]);
            }
        }

        if (event == "Toby_SelectionNarrationWeapon")
        {
            Toby_SelectionNarrator.NarrateWeaponName(args[0], bindings.weaponsSoundBindingsContainer);
        }
    }
}
