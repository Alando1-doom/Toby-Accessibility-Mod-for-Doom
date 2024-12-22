class Toby_ProximityDetectorHandler: EventHandler
{
    override void PlayerSpawned(PlayerEvent e)
    {
        if (level.mapName == "TITLEMAP") { return; }
        PlayerInfo player = players[e.PlayerNumber];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }
        int traceDistance = Cvar.GetCvar("Toby_Proximity_MaxDistance", player).GetInt();
        double attenuation = Cvar.GetCvar("Toby_Proximity_Attenuation", player).GetFloat();
        bool enabled = Cvar.GetCvar("Toby_Proximity_EnabledByDefault", player).GetBool();

        Toby_ProximityDetector beaconLeft = Toby_ProximityDetector(Actor.Spawn("Toby_ProximityDetector", playerActor.pos));
        beaconLeft.SetReferenceActor(playerActor, 90, traceDistance, attenuation, enabled);
        Toby_ProximityDetector beaconRight = Toby_ProximityDetector(Actor.Spawn("Toby_ProximityDetector", playerActor.pos));
        beaconRight.SetReferenceActor(playerActor, -90, traceDistance, attenuation, enabled);
        Toby_ProximityDetector beaconFront = Toby_ProximityDetector(Actor.Spawn("Toby_ProximityDetector", playerActor.pos));
        beaconFront.SetReferenceActor(playerActor, 0, traceDistance, attenuation, enabled);
        Toby_ProximityDetector beaconBack = Toby_ProximityDetector(Actor.Spawn("Toby_ProximityDetector", playerActor.pos));
        beaconBack.SetReferenceActor(playerActor, 180, traceDistance, attenuation, enabled);
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        ThinkerIterator actorFinder = ThinkerIterator.Create("Toby_ProximityDetector");
        Toby_ProximityDetector foundActor;
        while (foundActor = Toby_ProximityDetector(actorFinder.Next(true)))
        {
            if (!(foundActor is "Toby_ProximityDetector")) { continue; }
            if (playerActor != foundActor.referenceActor) { continue; }
            if (e.Name == "Toby_ProximityUpdate")
            {
                int traceDistance = Cvar.GetCvar("Toby_Proximity_MaxDistance", player).GetInt();
                double attenuation = Cvar.GetCvar("Toby_Proximity_Attenuation", player).GetFloat();
                foundActor.UpdateTraceDistanceAndAttenuation(traceDistance, attenuation);
            }
            if (e.Name == "Toby_ProximityToggle")
            {
                foundActor.toggleEnabled();
            }
        }

        if (e.Name == "Toby_ProximityUpdate")
        {
            Toby_Logger.ConsoleOutputModeMessagePlay("Proximity detector settings updated", playerActor);
        }
    }
}
