class Toby_UniversalPickupBeaconHandler: EventHandler
{
    Toby_ClassIgnoreListLoaderStaticHandler classIgnoreListLoader;
    bool useUniversalSounds;

    override void OnRegister()
    {
        classIgnoreListLoader = Toby_ClassIgnoreListLoaderStaticHandler.GetInstance();
        useUniversalSounds = Cvar.GetCvar("Toby_UniversalBeacon_UseUniversalSounds").GetBool();
    }

    override void WorldThingSpawned(WorldEvent e)
    {
        if (!(e.Thing is 'Inventory')) { return; }
        if (classIgnoreListLoader.IsInIgnoreList(e.Thing, classIgnoreListLoader.universalPickupBeaconIgnoreList)) { return; }
        Toby_UniversalPickupBeacon beacon = Toby_UniversalPickupBeacon(e.Thing.Spawn("Toby_UniversalPickupBeacon", e.Thing.pos));
        beacon.SetReferenceActor(e.Thing, useUniversalSounds);
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        if (e.Name == "Toby_UniversalBeaconUseUniversalSoundsUpdate")
        {
            useUniversalSounds = Cvar.GetCvar("Toby_UniversalBeacon_UseUniversalSounds").GetBool();
            ThinkerIterator actorFinder = ThinkerIterator.Create("Toby_UniversalPickupBeacon");
            Toby_UniversalPickupBeacon foundActor;
            while (foundActor = Toby_UniversalPickupBeacon(actorFinder.Next(true)))
            {
                foundActor.UpdateUseUniversalSounds(useUniversalSounds);
            }
            Toby_Logger.ConsoleOutputModeMessagePlay("Beacons updated", playerActor);
        }
    }
}
