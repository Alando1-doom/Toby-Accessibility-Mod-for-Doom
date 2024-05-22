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

        bool isIgnoredClassName = false;
        Toby_ClassIgnoreListContainer ignoreList = classIgnoreListLoader.universalPickupBeaconIgnoreList;
        for (int i = 0; i < ignoreList.classNames.Size(); i++)
        {
            if (e.Thing.GetClassName() == ignoreList.classNames[i])
            {
                isIgnoredClassName = true;
                break;
            }
        }
        if (isIgnoredClassName) { return; }
        Toby_UniversalPickupBeacon beacon = Toby_UniversalPickupBeacon(e.Thing.Spawn("Toby_UniversalPickupBeacon", e.Thing.pos));
        beacon.SetReferenceActor(e.Thing);
    }
}
