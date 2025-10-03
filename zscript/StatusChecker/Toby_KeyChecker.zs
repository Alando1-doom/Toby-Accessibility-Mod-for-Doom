class Toby_KeyChecker
{
    ui static void CheckKeys(PlayerInfo player, Toby_SoundBindingsContainer keysSoundBindings)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        Toby_SoundQueueStaticHandler.Clear();
        bool hasAnyKey = false;
        for (int i = 0; i < keysSoundBindings.soundBindings.Size(); i++)
        {
            string keyClassName = keysSoundBindings.soundBindings[i].At("ActorClass");
            if (playerActor.CountInv(keyClassName) > 0)
            {
                string soundName = keysSoundBindings.soundBindings[i].At("SoundToPlay");
                Toby_SoundQueueStaticHandler.AddSound(soundName, -1);
                hasAnyKey = true;
            }
        }
        if (!hasAnyKey)
        {
            Toby_SoundQueueStaticHandler.AddSound("ann/nokey", -1);
        }
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckKeysTextOnly(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        string textToPrint = "";
        for (Inventory item = playerActor.inv; item; item = item.inv)
        {
            if (!(item is "Key")) { continue; }
            textToPrint = textToPrint .. item.GetTag() .. " ";
        }
        if (textToPrint == "")
        {
            Toby_Logger.ConsoleOutputModeMessage("No keys");
            return;
        }
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }

    ui static void CheckKeysByOutputType(int narrationOutputType, PlayerInfo player, Toby_SoundBindingsContainer keySoundBindings)
    {
        if (narrationOutputType == TNOT_CONSOLE)
        {
            Toby_KeyChecker.CheckKeysTextOnly(player);
        }
        else
        {
            Toby_KeyChecker.CheckKeys(player, keySoundBindings);
        }
    }
}
