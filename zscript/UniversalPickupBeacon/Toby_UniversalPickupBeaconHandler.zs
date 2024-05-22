class Toby_UniversalPickupBeaconHandler: EventHandler
{
    Toby_ClassIgnoreListLoaderStaticHandler classIgnoreListLoader;

    override void OnRegister()
    {
        classIgnoreListLoader = Toby_ClassIgnoreListLoaderStaticHandler.GetInstance();
    }

    override void WorldThingSpawned(WorldEvent e)
    {
        if (!(e.Thing is 'Inventory')) { return; }
        if (classIgnoreListLoader.IsInIgnoreList(e.Thing, classIgnoreListLoader.universalPickupBeaconIgnoreList)) { return; }
        Toby_UniversalPickupBeacon beacon = Toby_UniversalPickupBeacon(e.Thing.Spawn("Toby_UniversalPickupBeacon", e.Thing.pos));
        beacon.SetReferenceActor(e.Thing);
    }
}
