class Toby_CoordinateChecker
{
    ui static void CheckCoordinates(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;
        Toby_NumberToSoundQueue numberToSoundQueue = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.AddSound("alphabet/X", -1);
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(playerActor.pos.x));
        Toby_SoundQueueStaticHandler.AddSound("alphabet/Y", -1);
        numberToSoundQueue.Reset();
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(playerActor.pos.y));
        Toby_SoundQueueStaticHandler.AddSound("alphabet/Z", -1);
        numberToSoundQueue.Reset();
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(playerActor.pos.z));
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckCoordinatesTextOnly(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        string textToPrint = "X " .. int(playerActor.pos.x) .. " Y " .. int(playerActor.pos.y) .. " Z " .. int(playerActor.pos.z);
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }
}
