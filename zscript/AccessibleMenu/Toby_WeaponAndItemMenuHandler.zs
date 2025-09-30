class Toby_WeaponAndItemMenuHandler : EventHandler
{
    override void OnRegister()
    {
        Toby_Logger.Message("Toby_WeaponAndItemMenuHandler registered!", "Toby_Developer");
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        Array<string> eventAndArguments;
        e.Name.split(eventAndArguments, ":", TOK_KEEPEMPTY);
        if (eventAndArguments.Size() < 1) { return; }
        string event = eventAndArguments[0];
        Array<string> args;
        if (eventAndArguments.Size() > 1)
        {
            for (int i = 1; i < eventAndArguments.Size(); i++)
            {
                args.push(eventAndArguments[i]);
            }
        }

        if (event == "Toby_SelectWeapon")
        {
            if (args.Size() < 1) { return; }

            Weapon weaponToSelect = Weapon(playerActor.FindInventory(args[0]));
            if (!weaponToSelect) { return; }

            string currentWeapon = "";
            if (player.ReadyWeapon)
            {
                currentWeapon = player.ReadyWeapon.GetClassName();
            }

            if (currentWeapon == args[0]) { return; }
            player.pendingWeapon = weaponToSelect;
        }
        if (event == "Toby_ActivateItem")
        {
            if (args.Size() < 1) { return; }
            Inventory item = playerActor.FindInventory(args[0]);
            if (!item) { return; }

            item.Use(false);
        }
    }
}
