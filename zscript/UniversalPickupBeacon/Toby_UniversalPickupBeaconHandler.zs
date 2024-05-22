class Toby_UniversalPickupBeaconHandler: EventHandler
{
    override void WorldThingSpawned (WorldEvent e)
    {
        if (e.Thing is 'Inventory')
        {
            Toby_UniversalPickupBeacon beacon = Toby_UniversalPickupBeacon(e.Thing.Spawn("Toby_UniversalPickupBeacon", e.Thing.pos));
            beacon.SetReferenceActor(e.Thing);
        }
    }
}
