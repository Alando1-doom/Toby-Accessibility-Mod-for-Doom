class Toby_ArmorChecker
{
    //Note: does not work with hexen-style armor
    ui static void CheckArmor(PlayerInfo player, Toby_SoundBindingsContainer armorSoundBindingsContainer)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;
        BasicArmor armor = BasicArmor(playerActor.FindInventory("BasicArmor"));
        if (!armor) { return; }

        string soundToPlay = "";
        for (int i = 0; i < armorSoundBindingsContainer.soundBindings.Size(); i++)
        {
            string className = armorSoundBindingsContainer.soundBindings[i].At("ActorClass");
            if (armor.ArmorType == className)
            {
                soundToPlay = armorSoundBindingsContainer.soundBindings[i].At("SoundToPlay");
                break;
            }
        }

        Toby_SoundQueueStaticHandler.AddSound(soundToPlay, -1);
        if (armor.Amount > 0)
        {
            Toby_NumberToSoundQueue numberToSoundQueue = Toby_NumberToSoundQueue.Create();
            Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(armor.Amount));
            Toby_SoundQueueStaticHandler.AddSound("stats/general/percent", -1);
        }
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckArmorTextOnly(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;
        BasicArmor armor = BasicArmor(playerActor.FindInventory("BasicArmor"));
        if (!armor) { return; }
        if (armor.Amount > 0)
        {
            class<Actor> cls = armor.ArmorType;
            string textToPrint = GetDefaultByType(cls).GetTag() .. " " .. armor.Amount .. "%";
            Toby_Logger.ConsoleOutputModeMessage(textToPrint);
        }
        else
        {
            string textToPrint = "No armor";
            Toby_Logger.ConsoleOutputModeMessage(textToPrint);
        }
    }
}
