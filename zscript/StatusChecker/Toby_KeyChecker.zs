class Toby_KeyChecker
{
    ui static void CheckKeys(PlayerInfo player, Toby_SoundBindingsContainer keysSoundBindings)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        Toby_SoundQueueStaticHandler.Clear();
        for (int i = 0; i < keysSoundBindings.soundBindings.Size(); i++)
        {
            string keyClassName = keysSoundBindings.soundBindings[i].At("ActorClass");
            if (playerActor.CountInv(keyClassName) > 0)
            {
                string soundName = keysSoundBindings.soundBindings[i].At("SoundToPlay");
                Toby_SoundQueueStaticHandler.AddSound(soundName, -1);
            }
        }
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }
}
