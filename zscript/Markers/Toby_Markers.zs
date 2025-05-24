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

class Toby_Marker_AxeKey : Toby_Marker_Silent {} //Hexen Keys
class Toby_Marker_CastleKey : Toby_Marker_Silent {}
class Toby_Marker_CaveKey : Toby_Marker_Silent {}
class Toby_Marker_DungeonKey : Toby_Marker_Silent {}
class Toby_Marker_EmeraldKey : Toby_Marker_Silent {}
class Toby_Marker_FireKey : Toby_Marker_Silent {}
class Toby_Marker_HornKey : Toby_Marker_Silent {}
class Toby_Marker_RustedKey : Toby_Marker_Silent {}
class Toby_Marker_SilverKey : Toby_Marker_Silent {}
class Toby_Marker_SteelKey : Toby_Marker_Silent {}
class Toby_Marker_SwampKey : Toby_Marker_Silent {}
class Toby_Marker_AllKey : Toby_Marker_Silent {}

class Toby_Marker_Exit : Toby_Marker_Silent {}
class Toby_Marker_Secret_Exit : Toby_Marker_Silent {}

class Toby_Marker_Pathfinding : ZS_Marker_Base
{
    string soundName;

    Default
    {
        Radius 16;
        Height 20;
        Scale 0.5;
        -INVISIBLE
    }
    States
    {
        Spawn:
            TNT1 A 2 Bright
            {
                SetMarkerSound("pathfinder/nodebeacon");
            }
            Loop;
        Enabled:
            NODE A 2 Bright;
            NODE BCDABCDABC 4 Bright;
            NODE D 2 Bright
            {
                A_StartSound(soundName, CHAN_5, 0, 1.0, ATTN_NORM);
            }
            Loop;
    }

    void SetMarkerSound(string soundName)
    {
        self.soundName = soundName;
    }
}

class Toby_Marker_1 : ZS_Marker_Base
{
    States
    {
        Spawn:
            MRK1 B 2 Bright;
            MRK1 BBBBBBBB 4 Bright;
            MRK1 B 2 Bright A_SpawnItemEx("Marker1Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK2 B 2 Bright A_SpawnItemEx("Marker2Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK3 B 2 Bright A_SpawnItemEx("Marker3Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK4 B 2 Bright A_SpawnItemEx("Marker4Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK5 B 2 Bright A_SpawnItemEx("Marker5Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK6 B 2 Bright A_SpawnItemEx("Marker6Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK7 B 2 Bright A_SpawnItemEx("Marker7Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK8 B 2 Bright A_SpawnItemEx("Marker8Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK9 B 2 Bright A_SpawnItemEx("Marker9Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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
        MRK0 B 2 Bright A_SpawnItemEx("Marker10Checker", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
        Loop;
    }
}
