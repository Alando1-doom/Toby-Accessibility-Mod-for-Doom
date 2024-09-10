class Toby_AmmoChecker
{
    ui static void CheckAmmo(
        PlayerInfo player,
        Toby_SoundBindingsContainer weaponsSoundBindings,
        Toby_SoundBindingsContainer ammoSoundBindings)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        Toby_SoundQueueStaticHandler.Clear();

        Class<Ammo> currentWeaponPrimaryAmmoClass = player.ReadyWeapon.AmmoType1;
        Class<Ammo> currentWeaponSecondaryAmmoClass = player.ReadyWeapon.AmmoType2;
        Inventory ammoPrimary = playerActor.FindInventory(currentWeaponPrimaryAmmoClass);
        Inventory ammoSecondary = playerActor.FindInventory(currentWeaponSecondaryAmmoClass);

        //Weapon name
        for (int i = 0; i < weaponsSoundBindings.soundBindings.Size(); i++)
        {
            string className = weaponsSoundBindings.soundBindings[i].At("ActorClass");
            if (player.ReadyWeapon.GetClassName() == className)
            {
                string soundName = weaponsSoundBindings.soundBindings[i].At("SoundToPlay");
                Toby_SoundQueueStaticHandler.AddSound(soundName, -1);
                break;
            }
        }

        Toby_NumberToSoundQueue numberToSoundQueue = Toby_NumberToSoundQueue.Create();
        if (ammoPrimary) {
            string soundToPlay = GetAmmoSoundName(ammoSoundBindings, ammoPrimary.GetClassName(), ammoPrimary.amount);
            Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(ammoPrimary.amount));
            Toby_SoundQueueStaticHandler.AddSound(soundToPlay, -1);
        }

        if (ammoSecondary) {
            string soundToPlay = GetAmmoSoundName(ammoSoundBindings, ammoSecondary.GetClassName(), ammoSecondary.amount);
            Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(ammoSecondary.amount));
            Toby_SoundQueueStaticHandler.AddSound(soundToPlay, -1);
        }

        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckAmmoTextOnly(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        Class<Ammo> currentWeaponPrimaryAmmoClass = player.ReadyWeapon.AmmoType1;
        Class<Ammo> currentWeaponSecondaryAmmoClass = player.ReadyWeapon.AmmoType2;
        Inventory ammoPrimary = playerActor.FindInventory(currentWeaponPrimaryAmmoClass);
        Inventory ammoSecondary = playerActor.FindInventory(currentWeaponSecondaryAmmoClass);

        string textToPrint = player.ReadyWeapon.GetTag();
        if (ammoPrimary)
        {
            textToPrint = textToPrint .. " " .. ammoPrimary.amount .. " " .. ammoPrimary.GetTag();
        }
        if (ammoPrimary && ammoSecondary)
        {
            textToPrint = textToPrint .. ",";
        }
        if (ammoSecondary)
        {
            textToPrint = textToPrint .. " " .. ammoSecondary.amount .. " " .. ammoSecondary.GetTag();
        }
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }

    ui static string GetAmmoSoundName(Toby_SoundBindingsContainer ammoSoundBindings, string classNameToFind, int amount)
    {
        string soundToPlay = "";
        for (int i = 0; i < ammoSoundBindings.soundBindings.Size(); i++)
        {
            string className = ammoSoundBindings.soundBindings[i].At("ActorClass");
            if (classNameToFind == className)
            {
                if (amount == 1)
                {
                    soundToPlay = ammoSoundBindings.soundBindings[i].At("SoundToPlay");
                }
                else
                {
                    soundToPlay = ammoSoundBindings.soundBindings[i].At("SoundToPlayPlural");
                }

            }
        }
        return soundToPlay;
    }

    ui static void CheckAmmoLegacy(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        if (!player.ReadyWeapon) { return; }
        Actor playerActor = player.mo;
        string weaponSoundName;
        if (player.ReadyWeapon.GetClassName() == "Pistol_TO" || player.ReadyWeapon.GetClassName() == "Chaingun_TO")
        {
            weaponSoundName = "clip";
        }
        if (player.ReadyWeapon.GetClassName() == "Shotgun_TO" || player.ReadyWeapon.GetClassName() == "SuperShotgun_TO")
        {
            weaponSoundName = "shell";
        }
        if (player.ReadyWeapon.GetClassName() == "PlasmaRifle_TO" || player.ReadyWeapon.GetClassName() == "BFG9000_TO")
        {
            weaponSoundName = "cell";
        }
        if (player.ReadyWeapon.GetClassName() == "RocketLauncher_TO")
        {
            weaponSoundName = "rocket";
        }

        Array<Toby_PlayerStatusCondition> conditions;
        conditions.push(Toby_PlayerStatusCondition.Create(double.Min_Normal, 0, "stat/%s/empty"));
        conditions.push(Toby_PlayerStatusCondition.Create(0, 0.33, "stat/%s/low"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.33, 0.49999, "stat/%s/onethird"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.49999, 0.66, "stat/%s/half"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.66, 0.75, "stat/%s/twothird"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.75, 0.99999, "stat/%s/good"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.99999, double.Max, "stat/%s/full"));

        for (int i = 0; i < conditions.Size(); i++)
        {
            Class<Ammo> currentWeaponPrimaryAmmoClass = player.ReadyWeapon.AmmoType1;
            Inventory ammo = playerActor.FindInventory(currentWeaponPrimaryAmmoClass);
            if (conditions[i].Evaluate(ammo.amount, ammo.maxAmount))
            {
                string soundToPlay = String.format(conditions[i].soundToPlay, weaponSoundName);
                S_StartSound(soundToPlay, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
                break;
            }
        }
    }
}
