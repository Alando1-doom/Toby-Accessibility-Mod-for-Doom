class Toby_ProximityDetector : Actor
{
    Actor referenceActor;
    bool enabled;
    int angleOffset;
    int traceDistance;
    double attenuation;

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
            TNT1 A 0 A_PlayWindSoundBasedOnDistance();
            TNT1 A 1;
            loop;
        Death:
            TNT1 A 0;
            stop;
    }

    action state A_MimicReferenceActor()
    {
        let beacon = Toby_ProximityDetector(self);
        if (!beacon.referenceActor)
        {
            return ResolveState("Death");
        }

        FLineTraceData traceData;
        beacon.referenceActor.LineTrace(
            beacon.referenceActor.angle + beacon.angleOffset, //owner is a player actor, we use it's angle and pitch to draw the line
            beacon.traceDistance, //maximum detection distance
            0, //pitch. Zero is level with the ground
            TRF_SOLIDACTORS|TRF_BLOCKSELF,//First flag allows detecting solid actor obstacles, second - stops at player blocking lines
            beacon.referenceActor.MaxStepHeight + 1, //offsetz for the starting point of the line trace.
            data:traceData //variable that will store information about everything hit by linetrace
        );

        beacon.SetOrigin(traceData.HitLocation - traceData.HitDir*4, true);
        return null;
    }

    action state A_PlayWindSoundBasedOnDistance()
    {
        let beacon = Toby_ProximityDetector(self);
        if (!beacon.enabled)
        {
            beacon.A_StopSound(CHAN_BODY);
            return null;
        }
        if (!beacon.referenceActor)
        {
            return ResolveState("Death");
        }
        double distance = (beacon.pos - beacon.referenceActor.pos).Length();
        double normalizedDistance = double(distance - beacon.referenceActor.radius) / beacon.traceDistance;
        beacon.A_StartSound("toby/proximitydetector/wind", CHAN_BODY, CHANF_LOOPING, 1, beacon.attenuation, 1 + normalizedDistance);
        beacon.A_SoundPitch(CHAN_BODY, 1 + normalizedDistance * 3);
        return null;
    }

    void SetReferenceActor(Actor referenceActor, int angleOffset, int traceDistance, double attenuation, bool enabled)
    {
        self.enabled = enabled;
        self.referenceActor = referenceActor;
        self.angleOffset = angleOffset;
        self.traceDistance = traceDistance;
        self.attenuation = attenuation;
    }

    void UpdateTraceDistanceAndAttenuation(int traceDistance, double attenuation)
    {
        self.traceDistance = traceDistance;
        self.attenuation = attenuation;
        self.A_StopSound(CHAN_BODY);
    }

    void toggleEnabled()
    {
        self.enabled = !self.enabled;
    }
}


class ActorStorage
{
    Array<Actor> storage;
}
