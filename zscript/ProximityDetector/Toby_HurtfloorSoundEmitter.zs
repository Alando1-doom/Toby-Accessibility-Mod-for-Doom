class Toby_HurtfloorSoundEmitter : Actor
{
    Default
    {
        -SOLID;
        +NOGRAVITY;
    }

    States
    {
        Spawn:
            TNT1 A 30;
            loop;
        Hurtfloor:
            TROO A 10 A_StartSound("toby/hurtfloordetector/rad", CHAN_AUTO, CHANF_DEFAULT, 1.0, 1);
            loop;
    }
}
