class Toby_DropoffSoundEmitterManagerItem : Inventory
{
    private Toby_WallDetector wallDetector;
    private Toby_DropoffDetectorHandler handler;

    default
    {
        Inventory.MaxAmount 1;
        +INVENTORY.UNDROPPABLE;
    }

    Actor frontEmitter;
    override void BeginPlay()
    {
        frontEmitter = Actor.Spawn("Toby_DropoffSoundEmitter",(0,0,0));
    }

    override void Tick()
    {
        super.Tick();
        if (!owner)
        {
            Destroy();
            return;
        }

        if (!wallDetector) {
            wallDetector = Toby_WallDetector.Create(owner);
        }
        if (!wallDetector.handler)
        {
            wallDetector.SetHandlerReference(handler);
        }

        if(!frontEmitter)
        {
            frontEmitter = Actor.Spawn("Toby_DropoffSoundEmitter", (0,0,0));
        }
        else
        {
            int traceDistance = 88;

            FLineTraceData dFront;
            owner.LineTrace(
                owner.angle, //owner is a player actor, we use it's angle and pitch to draw the line
                traceDistance, //maximum detection distance
                0, //pitch. Zero is level with the ground
                TRF_SOLIDACTORS|TRF_BLOCKSELF,//First flag allows detecting solid actor obstacles, second - stops at player blocking lines
                0, //offsetz for the starting point of the line trace, I'm starting at player height - Modified to be lower.
                data:dFront); //variable that will store information about everything hit by linetrace

            if (frontEmitter)
                frontEmitter.SetOrigin(dFront.HitLocation-dFront.HitDir*4,false);

            int frontEmitterType = 0;
            if (owner.pos.z - frontEmitter.CurSector.GetPlaneTexZ(0) > 60)
                frontEmitterType = 2;

            switch (frontEmitterType)
            {
                case 0:
                    if (!frontEmitter.InStateSequence(frontEmitter.CurState, frontEmitter.ResolveState("spawn")))
                    {
                        frontEmitter.SetStateLabel("spawn");
                    }
                    break;
                case 1:
                    if (!frontEmitter.InStateSequence(frontEmitter.CurState, frontEmitter.ResolveState("wall")))
                    {
                        frontEmitter.SetStateLabel("wall");
                    }
                    break;
                case 2:
                    if (!frontEmitter.InStateSequence(frontEmitter.CurState, frontEmitter.ResolveState("dropoffSpot")))
                    {
                        frontEmitter.SetStateLabel("dropoffSpot");
                    }
                    break;
                case 3:
                    if (!frontEmitter.InStateSequence(frontEmitter.CurState, frontEmitter.ResolveState("lineSwitch")))
                    {
                        frontEmitter.SetStateLabel("lineSwitch");
                    }
                    break;
            }
        }
    }

    void SetHandlerReference(Toby_DropoffDetectorHandler handler)
    {
        self.handler = handler;
    }
}
