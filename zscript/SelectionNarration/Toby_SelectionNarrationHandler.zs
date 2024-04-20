class Toby_SelectionNarrationHandler : EventHandler
{
    int maxPlayers;
    Array<string> previousWeapon;
    Array<string> previousItem;
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
            previousItem.push("");
        }
    }

    override void WorldTick()
    {
        DetectAndNarrateWeaponSwitch();
        DetectAndNarrateItemSwitch();
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

        if (event == "Toby_SelectionNarrationItem")
        {
            Toby_SelectionNarrator.NarrateItemName(args[0], args[1].ToInt(), bindings.itemsSoundBindingsContainer);
        }
    }

    private void DetectAndNarrateWeaponSwitch()
    {
        for (int i = 0; i < maxPlayers; i++)
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

    private void DetectAndNarrateItemSwitch()
    {
        for (int i = 0; i < maxPlayers; i++)
        {
            if (!players[i].mo) { continue; }
            string currentItem = "";
            int amount = 0;
            if (players[i].mo.InvSel)
            {
                Inventory inv = players[i].mo.InvSel;
                currentItem = inv.GetClassName();
                amount = inv.amount;
            }
            if (currentItem == previousItem[i]) { continue; }
            if (previousItem[i] == "")
            {
                previousItem[i] = currentItem;
                continue;
            }
            if (Cvar.GetCvar("Toby_SelectionNarrationItems", players[i]).GetBool())
            {
                EventHandler.SendInterfaceEvent(i, "Toby_SelectionNarrationItem:"..currentItem..":"..amount);
            }
            previousItem[i] = currentItem;
        }
    }

    private int GetSbarItemCount(Actor a)
    {
        int count = 0;
        for(Inventory item = a.inv; item != null; item = item.inv) {
            if (item.bInvBar)
            {
                count++;
            }
        }
        return count;
    }
}
