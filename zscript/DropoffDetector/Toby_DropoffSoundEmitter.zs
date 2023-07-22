class Toby_DropoffSoundEmitter : Actor
{
    Default
    {
        +DONTSPLASH
    }
    states
    {
        spawn:
            TNT1 A 30;
            loop;
        wall:
            TNT1 A 30 A_StartSound("misc/i_pkup", CHAN_AUTO, CHANF_DEFAULT, 1.0, 10);
            loop;
        dropoffSpot:
            TNT1 A 5 A_StartSound("dropoff/beacon", CHAN_AUTO, CHANF_DEFAULT, 1.0, 1);
            loop;
        lineSwitch:
            TNT1 A 20;
            TNT1 A 7 A_StartSound("misc/p_pkup", CHAN_AUTO, CHANF_DEFAULT, 1.0, 4);
            TNT1 A 7 A_StartSound("misc/p_pkup", CHAN_AUTO, CHANF_DEFAULT, 1.0, 4);
            loop;
    }
}
