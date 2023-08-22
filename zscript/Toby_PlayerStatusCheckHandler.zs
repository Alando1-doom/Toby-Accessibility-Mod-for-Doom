//Original ACS implementation by Jarewill

class Toby_PlayerStatusCheckHandler: EventHandler
{
    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }
        if (e.Name == "Toby_CheckHealth")
        {
            console.printf("Health: "..playerActor.health);
            console.printf("Max Health: "..playerActor.SpawnHealth());
            Array<Toby_PlayerStatusCondition> conditions;
            conditions.push(Toby_PlayerStatusCondition.Create(0, 0.2, "stat/health/critical"));
            conditions.push(Toby_PlayerStatusCondition.Create(0.2, 0.4, "stat/health/low"));
            conditions.push(Toby_PlayerStatusCondition.Create(0.4, 0.6, "stat/health/poor"));
            conditions.push(Toby_PlayerStatusCondition.Create(0.6, 0.8, "stat/health/avg"));
            conditions.push(Toby_PlayerStatusCondition.Create(0.8, 1.0, "stat/health/good"));
            conditions.push(Toby_PlayerStatusCondition.Create(1.0, double.Max, "stat/health/great"));

            for (int i = 0; i < conditions.Size(); i++)
            {
                if (conditions[i].Evaluate(playerActor.health, playerActor.SpawnHealth()))
                {
                    S_StartSound(conditions[i].soundToPlay, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
                    break;
                }
            }
        }

        if (e.Name == "Toby_CheckAmmo")
        {
            if (!player.ReadyWeapon) { return; }
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
}
