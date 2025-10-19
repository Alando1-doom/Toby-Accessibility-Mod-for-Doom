class Toby_ProximityDetectorHandler: EventHandler
{
    Array<Toby_HurtfloorDetector> hurtfloorDetectors;

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

        if (hurtfloorDetectors.Size() < maxPlayers) { return; }
        hurtfloorDetectors[e.PlayerNumber].Init(e.PlayerNumber);
    }

    override void WorldLoaded(WorldEvent e)
    {
        int maxPlayers = 8;
        for (int i = 0; i < maxPlayers; i++)
        {
            hurtfloorDetectors.push(new("Toby_HurtfloorDetector"));
            hurtfloorDetectors[i].Init(i);
        }
    }

    override void WorldTick()
    {
        for (int i = 0; i < maxPlayers; i++)
        {
            hurtfloorDetectors[i].Update();
        }
    }

    override void InterfaceProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        if (!player.mo) { return; }

        int narrationOutputType = CVar.FindCvar("Toby_NarrationOutputType").GetInt();

        if (e.Name == "Toby_HurtfloorDetectorToggleInterface")
        {
            HurtfloorDetectorToggleByOutputType(narrationOutputType, hurtfloorDetectors[consoleplayer].GetEnabled());
        }
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

        if (e.Name == "Toby_HurtfloorDetectorToggle")
        {
            hurtfloorDetectors[e.Player].ToggleEnabled();
            EventHandler.SendInterfaceEvent(e.Player, "Toby_HurtfloorDetectorToggleInterface");
        }
    }

    ui static void HurtfloorDetectorToggleByOutputType(int narrationOutputType, bool enabled)
    {
        if (narrationOutputType == TNOT_CONSOLE)
        {
            if (enabled)
            {
                Toby_Logger.ConsoleOutputModeMessage("Hurtfloor detector enabled");
            }
            else
            {
                Toby_Logger.ConsoleOutputModeMessage("Hurtfloor detector disabled");
            }
        }
        else
        {
            if (enabled)
            {
                Toby_SoundQueueStaticHandler.AddSound("toby/hurtfloordetector/enabled", -1);
            }
            else
            {
                Toby_SoundQueueStaticHandler.AddSound("toby/hurtfloordetector/disabled", -1);
            }
            Toby_SoundQueueStaticHandler.PlayQueue(0);
        }
    }
}
