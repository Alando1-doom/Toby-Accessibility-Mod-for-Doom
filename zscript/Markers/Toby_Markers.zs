class ZS_Marker_Base : Mapmarker
{
    default
    {
        Radius 16;
        Height 20;
        -INVISIBLE
    }
}

class Toby_Marker_Silent : ZS_Marker_Base
{
    States
    {
        Spawn:
            TNT1 A 1 Bright;
            TNT1 BBBBBBBB 4 Bright;
            TNT1 B 2 Bright;
            Loop;
    }
}

class Toby_Marker_LevelStart : Toby_Marker_Silent {}

class Toby_Marker_RedKeyDoor : Toby_Marker_Silent {}
class Toby_Marker_BlueKeyDoor : Toby_Marker_Silent {}
class Toby_Marker_YellowKeyDoor : Toby_Marker_Silent {}
class Toby_Marker_GreenKeyDoor : Toby_Marker_Silent {} //Heretic

class Toby_Marker_RedSkullDoor : Toby_Marker_Silent {}
class Toby_Marker_BlueSkullDoor : Toby_Marker_Silent {}
class Toby_Marker_YellowSkullDoor : Toby_Marker_Silent {}

class Toby_Marker_ThreeKeyDoor : Toby_Marker_Silent {}
class Toby_Marker_SixKeyDoorDoor : Toby_Marker_Silent {}
class Toby_Marker_AnyKeyDoor : Toby_Marker_Silent {}

class Toby_Marker_Exit : Toby_Marker_Silent {}
class Toby_Marker_Secret_Exit : Toby_Marker_Silent {}

class Toby_Marker_Pathfinding : ZS_Marker_Base
{
    default
    {
        Radius 16;
        Height 20;
        +INVISIBLE
    }
    States
    {
        Spawn:
            MRK1 B 2 Bright;
            Loop;
        Enabled:
            MRK1 B 2 Bright;
            MRK1 BBBBBBBB 4 Bright;
            MRK1 B 2 Bright A_StartSound("marker/beacon1", CHAN_5, 0, 1.0, ATTN_NORM);
            Loop;
    }
}

class Toby_Marker_1 : ZS_Marker_Base
{
    States
    {
        Spawn:
            MRK1 B 2 Bright;
            MRK1 BBBBBBBB 4 Bright;
            MRK1 B 2 Bright A_StartSound("marker/beacon1", CHAN_5, 0, 1.0, ATTN_NORM);
            Loop;
    }
}

class Toby_Marker_2 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK2 B 2 Bright;
        MRK2 BBBBBBBB 4 Bright;
        MRK2 B 2 Bright A_StartSound("marker/beacon2", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}

class Toby_Marker_3 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK3 B 2 Bright;
        MRK3 BBBBBBBB 4 Bright;
        MRK3 B 2 Bright A_StartSound("marker/beacon3", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}

class Toby_Marker_4 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK4 B 2 Bright;
        MRK4 BBBBBBBB 4 Bright;
        MRK4 B 2 Bright A_StartSound("marker/beacon4", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}

class Toby_Marker_5 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK5 B 2 Bright;
        MRK5 BBBBBBBB 4 Bright;
        MRK5 B 2 Bright A_StartSound("marker/beacon5", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}

class Toby_Marker_6 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK6 B 2 Bright;
        MRK6 BBBBBBBB 4 Bright;
        MRK6 B 2 Bright A_StartSound("marker/beacon6", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}

class Toby_Marker_7 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK7 B 2 Bright;
        MRK7 BBBBBBBB 4 Bright;
        MRK7 B 2 Bright A_StartSound("marker/beacon7", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}

class Toby_Marker_8 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK8 B 2 Bright;
        MRK8 BBBBBBBB 4 Bright;
        MRK8 B 2 Bright A_StartSound("marker/beacon8", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}

class Toby_Marker_9 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK9 B 2 Bright;
        MRK9 BBBBBBBB 4 Bright;
        MRK9 B 2 Bright A_StartSound("marker/beacon9", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}

class Toby_Marker_10 : ZS_Marker_Base
{
    States
    {
    Spawn:
        MRK0 B 2 Bright;
        MRK0 BBBBBBBB 4 Bright;
        MRK0 B 2 Bright A_StartSound("marker/beacon10", CHAN_5, 0, 1.0, ATTN_NORM);
        Loop;
    }
}
