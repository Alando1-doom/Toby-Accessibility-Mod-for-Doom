class Toby_SelectionNarrator
{
    ui static void NarrateWeaponName(string weaponName, Toby_SoundBindingsContainer weaponsSoundBindings)
    {
        Toby_SoundQueueStaticHandler.Clear();

        for (int i = 0; i < weaponsSoundBindings.soundBindings.Size(); i++)
        {
            string className = weaponsSoundBindings.soundBindings[i].At("ActorClass");
            if (weaponName == className)
            {
                string soundName = weaponsSoundBindings.soundBindings[i].At("SoundToPlay");
                Toby_SoundQueueStaticHandler.AddSound(soundName, -1);
                break;
            }
        }

        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void NarrateWeaponNameTextOnly(string weaponName)
    {
        class<Actor> cls = weaponName;
        if (!cls) { return; }
        string textToPrint = GetDefaultByType(cls).GetTag();
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }

    ui static void NarrateItemName(string itemName, int amount, Toby_SoundBindingsContainer itemsSoundBindings)
    {
        Toby_SoundQueueStaticHandler.Clear();

        for (int i = 0; i < itemsSoundBindings.soundBindings.Size(); i++)
        {
            string className = itemsSoundBindings.soundBindings[i].At("ActorClass");
            if (itemName == className)
            {
                string soundName = itemsSoundBindings.soundBindings[i].At("SoundToPlay");
                Toby_SoundQueueStaticHandler.AddSound(soundName, -1);
                break;
            }
        }

        Toby_NumberToSoundQueue numberToSoundQueue = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(amount));

        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void NarrateItemNameTextOnly(string itemName, int amount)
    {
        class<Actor> cls = itemName;
        if (!cls) { return; }
        string textToPrint = GetDefaultByType(cls).GetTag() .. " " .. amount;
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }
}
