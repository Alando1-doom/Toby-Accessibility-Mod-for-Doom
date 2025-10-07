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

        Toby_WeaponSlotItemCollection weaponCollection = Toby_WeaponSlotItemCollection.Create();

        // This piece lifted directly from m8f's Gearbox
        for (int i = 0; i < AllActorClasses.Size(); ++i)
        {
            let type = (class<Weapon>)(AllActorClasses[i]);

            if (type == null || type == "Weapon") { continue; };

            bool located;
            int slot;
            int priority;
            [located, slot, priority] = player.weapons.LocateWeapon(type);

            if (slot == 0)
            {
                slot = 10;
            }

            if (!located) { continue; };

            weaponCollection.AddItem(slot, priority, type);
        }

        Toby_QuickSort.QuickSort(weaponCollection, 0, weaponCollection.Size() - 1);

        for (int i = 0; i < weaponCollection.Size(); i++)
        {
            Toby_WeaponSlotItem item = (Toby_WeaponSlotItem)(weaponCollection.GetObject(i));
            string className = item.type.GetClassName();
            Weapon playerWeapon = (Weapon)(playerActor.findInventory(className));
            if (!playerWeapon) { continue; }

            int weaponSlot = item.slot;
            if (weaponSlot == 10)
            {
                weaponSlot = 0;
            }

            string label = weaponSlot .. ". " .. Toby_AmmoChecker.GetWeaponAndAmmoInfoString(playerActor, playerWeapon);
            string command = className;

            Toby_WeaponsMenuItem menuItem = (Toby_WeaponsMenuItem)(new("Toby_WeaponsMenuItem").Init(label, command));

            Toby_SoundBindingsLoaderStaticHandler bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();
            Toby_SoundQueue weaponAndAmmoQueue = Toby_AmmoChecker.GetWeaponAndAmmoSoundQueue(
                playerActor,
                playerWeapon,
                bindings.weaponsSoundBindingsContainer,
                bindings.ammoSoundBindingsContainer
            );
            Toby_NumberToSoundQueue slotNumberQueue = Toby_NumberToSoundQueue.Create();
            Toby_SoundQueue finalQueue = Toby_SoundQueue.Create();
            finalQueue.AddQueue(slotNumberQueue.CreateQueueFromInt(weaponSlot));
            finalQueue.AddQueue(weaponAndAmmoQueue);
            menuItem.SetSoundQueue(finalQueue);

            mDesc.mItems.Push(menuItem);
        }
    }
}
