class Toby_TargetDetectorHandler: EventHandler
{
    Array<Actor> playerAimTargets;
    private int maxPlayers;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_TargetDetectorHandler registered!", "Toby_Developer");
    }

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            playerAimTargets.push(null);
        }
    }

    override void WorldTick()
    {
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            if (!players[i].mo) { continue; }
            Actor playerActor = players[i].mo;
            playerAimTargets[i] = playerActor.AimTarget();
        }
    }
}
