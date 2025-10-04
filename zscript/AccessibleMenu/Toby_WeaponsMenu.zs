class Toby_WeaponsMenu : OptionMenu
{
    override void Init(Menu parent, OptionMenuDescriptor desc)
    {
        Super.Init(parent, desc);
        mDesc.mItems.Clear();
        mDesc.mSelectedItem = -1;
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        Array<class<Weapon> > playerWeaponClasses;

        // This piece lifted directly from m8f's Gearbox
        for (int i = 0; i < AllActorClasses.Size(); ++i)
        {
            let type = (class<Weapon>)(AllActorClasses[i]);

            if (type == null || type == "Weapon") { continue; };

            bool located;
            int slot;
            int priority;
            [located, slot, priority] = player.weapons.LocateWeapon(type);

            if (!located) { continue; };

            readonly<Weapon> def = GetDefaultByType(type);
            // Can't run from UI context :|
            // if (!def.CanPickup(player.mo)) { continue; };

            playerWeaponClasses.push(type);
        }

        for (int i = 0; i < playerWeaponClasses.Size(); i++)
        {
            string className = playerWeaponClasses[i].GetClassName();
            Weapon playerWeapon = (Weapon)(playerActor.findInventory(className));
            if (!playerWeapon) { continue; }

            string label = Toby_AmmoChecker.GetWeaponAndAmmoInfoString(playerActor, playerWeapon);
            string command = className;

            Toby_WeaponsMenuItem menuItem = (Toby_WeaponsMenuItem)(new("Toby_WeaponsMenuItem").Init(label, command));

            Toby_SoundBindingsLoaderStaticHandler bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();
            Toby_SoundQueue queue = Toby_AmmoChecker.GetWeaponAndAmmoSoundQueue(
                playerActor,
                playerWeapon,
                bindings.weaponsSoundBindingsContainer,
                bindings.ammoSoundBindingsContainer
            );
            menuItem.SetSoundQueue(queue);

            mDesc.mItems.Push(menuItem);
        }
    }
}
