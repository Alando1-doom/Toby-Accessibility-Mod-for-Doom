class Toby_UniversalPickupBeacon : Actor
{
    Actor referenceActor;
    bool useUniversalSounds;

    Default
    {
        -SOLID;
        +NOGRAVITY;
    }

    States
    {
        Spawn:
            TNT1 A 10;
        MainLoop:
            TNT1 A 0 A_MimicReferenceActor();
            TNT1 A 0 A_PlayReferenceActorPickupSound();
            TNT1 A 40;
            loop;
        Death:
            TNT1 A 0;
            stop;
    }

    action state A_MimicReferenceActor()
    {
        let beacon = Toby_UniversalPickupBeacon(self);
        if (!beacon.referenceActor)
        {
            return ResolveState("Death");
        }
        let invItem = Inventory(beacon.referenceActor);
        if (invItem.owner)
        {
            return ResolveState("Death");
        }
        beacon.A_SetSize(beacon.referenceActor.radius, beacon.referenceActor.height, false);
        beacon.SetOrigin(beacon.referenceActor.pos, false);
        return null;
    }

    action void A_PlayReferenceActorPickupSound()
    {
        let beacon = Toby_UniversalPickupBeacon(self);
        if (!beacon.referenceActor) { return; }
        if (beacon.CheckIfSeen()) { return; }
        if (!(beacon.referenceActor is "Inventory")) { return; }
        let invItem = Inventory(beacon.referenceActor);
        if (beacon.CheckIfCollidesWithAnyPlayer())
        {
            beacon.A_StartSound("marker/Markers/undofail", CHAN_AUTO);
            return;
        }

        string soundByItemType = beacon.GetSoundByItemType(invItem);
        if (soundByItemType != "" && beacon.useUniversalSounds) {
            beacon.A_StartSound(soundByItemType, CHAN_AUTO);
            return;
        }

        beacon.A_StartSound(invItem.PickupSound, CHAN_AUTO);
    }

    string GetSoundByItemType(Inventory item)
    {
        if (item is "Ammo") return "toby/universalbeacons/ammo";
        if (item is "BasicArmor") return "toby/universalbeacons/armor";
        if (item is "Health") return "toby/universalbeacons/health";
        if (item is "Key") return "toby/universalbeacons/key";
        if (item is "Weapon") return "toby/universalbeacons/weapon";

        return "";
    }

    void UpdateUseUniversalSounds(bool useUniversalSounds)
    {
        self.useUniversalSounds = useUniversalSounds;
    }

    bool CheckIfCollidesWithAnyPlayer()
    {
        let beacon = Toby_UniversalPickupBeacon(self);
        BlockThingsIterator iterator = BlockThingsIterator.Create(beacon, -1);
        Actor mo;
        while (iterator.Next())
        {
            mo = iterator.thing;
            if (!mo || !mo.bSolid || !(mo is "PlayerPawn") || Distance2D(mo) > (beacon.radius + mo.radius/2))
            {
                continue;
            }
            return true;
        }
        return false;
    }

    void SetReferenceActor(Actor referenceActor, bool useUniversalSounds)
    {
        self.referenceActor = referenceActor;
        self.useUniversalSounds = useUniversalSounds;
    }
}
