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

        if (armor.Amount > 0)
        {
            Toby_NumberToVoice.ConvertAndAddToQueue(armor.Amount);
        }
        Toby_SoundQueueStaticHandler.UnshiftSound(soundToPlay, -1);
        if (armor.Amount > 0)
        {
            Toby_SoundQueueStaticHandler.AddSound("playerstatus/percent", -1);
        }
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }
}
