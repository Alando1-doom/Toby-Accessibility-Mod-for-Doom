//This is an event handler which spawns sound making actors at exit lines
//First Actor.Spawn spawns a normal sound actor for normal exits and end game exits
//Second Actor.Spawn spawns a secret sound actor for secret exits
//I didn't know how to get the floor height of the specific sector the lines belong to
//So remember to remove NOGRAVITY flag from your own sound actors

class TobyEventHandler : EventHandler
{
    override void WorldLoaded(WorldEvent e)
    {
        for (int i = 0; i < level.lines.size(); i++)
        {
            Line l = level.lines[i];

            Vector2 pos = l.v1.p + (l.delta / 2.0);
            Vector3 beaconSpawnPos = (pos.x, pos.y, 0);

            int lockNumber = Toby_LineUtil.GetLockNumber(l);

            if (Toby_LineUtil.IsExit(l) || Toby_LineUtil.IsEndGame(l))
            {
                Actor.Spawn("ExitBeacon1", beaconSpawnPos);
            }
            else if (Toby_LineUtil.IsSecretExit(l))
            {
                Actor.Spawn("SecretExitBeacon", beaconSpawnPos);
            }
            //Figuring this out caused me a massive headache
            //Why does the Doom format and UDMF have different door locking?
            //Sorry for the next lines being such a mess, couldn't figure out of any other way
            //**********************************************************************************************

            // A bit tidier now -PR

            //Red Key
            else if (Toby_LineUtil.IsRedDoor(lockNumber))
            {
                if (GameInfo.GameType & GAME_Hexen)
                {
                    Actor.Spawn("SteelKeyChecker", beaconSpawnPos);
                }
                else if (GameInfo.GameType & GAME_Heretic)
                {
                    Actor.Spawn("GreenKeyChecker_V2", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("RedKeyChecker_V2", beaconSpawnPos);
                }
            }
            //Blue Key
            else if (Toby_LineUtil.IsBlueDoor(lockNumber))
            {
                if (GameInfo.GameType & GAME_Hexen)
                {
                    Actor.Spawn("CaveKeyChecker", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("BlueKeyChecker_V2", beaconSpawnPos);
                }
            }
            //Yellow Key
            else if (Toby_LineUtil.IsYellowDoor(lockNumber))
            {
                if (GameInfo.GameType & GAME_Hexen)
                {
                    Actor.Spawn("AxeKeyChecker", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("YellowKeyChecker_V2", beaconSpawnPos);
                }
            }
            //Red Skull Key
            if (Toby_LineUtil.IsRedSkullDoor(lockNumber))
            {
                if (GameInfo.GameType & GAME_Hexen)
                {
                    Actor.Spawn("FireKeyChecker", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("RedSkullChecker_V2", beaconSpawnPos);
                }
            }
            //Blue Skull Key
            else if (Toby_LineUtil.IsBlueSkullDoor(lockNumber))
            {
                if (GameInfo.GameType & GAME_Hexen)
                {
                    Actor.Spawn("EmeraldKeyChecker", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("BlueSkullChecker_V2", beaconSpawnPos);
                }
            }
            //Yellow Skull Key
            else if (Toby_LineUtil.IsYellowSkullDoor(lockNumber))
            {
                if (GameInfo.GameType & GAME_Hexen)
                {
                    Actor.Spawn("DungeonKeyChecker", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("YellowSkullChecker_V2", beaconSpawnPos);
                }
            }
            else if (GameInfo.GameType & GAME_HEXEN && Toby_LineUtil.IsSilverKeyDoor(lockNumber))
            {
                Actor.Spawn("SilverKeyChecker", beaconSpawnPos);
            }
            else if (GameInfo.GameType & GAME_HEXEN && Toby_LineUtil.IsRustedKeyDoor(lockNumber))
            {
                Actor.Spawn("RustedKeyChecker", beaconSpawnPos);
            }
            else if (GameInfo.GameType & GAME_HEXEN && Toby_LineUtil.IsHornKeyDoor(lockNumber))
            {
                Actor.Spawn("HornKeyChecker", beaconSpawnPos);
            }
            else if (GameInfo.GameType & GAME_HEXEN && Toby_LineUtil.IsSwampKeyDoor(lockNumber))
            {
                Actor.Spawn("SwampKeyChecker", beaconSpawnPos);
            }
            else if (GameInfo.GameType & GAME_HEXEN && Toby_LineUtil.IsCastleKeyDoor(lockNumber))
            {
                Actor.Spawn("CastleKeyChecker", beaconSpawnPos);
            }
            //3 Key Checker
            else if (Toby_LineUtil.IsThreeKeyDoor(lockNumber))
            {
                if (GameInfo.GameType & GAME_Hexen)
                {
                    Actor.Spawn("AllKeyChecker", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("3KeyChecker_V2", beaconSpawnPos);
                }
            }
            //6 Key Checker
            else if (Toby_LineUtil.IsSixKeyDoor(lockNumber))
            {
                if (GameInfo.GameType & GAME_Hexen)
                {
                    Actor.Spawn("AllKeyChecker", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("6KeyChecker_V2", beaconSpawnPos);
                }
            }
            //Any Key Checker
            else if (Toby_LineUtil.IsAnyKeyDoor(lockNumber))
            {
                Actor.Spawn("AnyKeyChecker_V2", beaconSpawnPos);
            }
            //This check was altered for the switch/door differentiation
            else if (l.special != 0 && l.activation & SPAC_Use)
            {
                if (Toby_LineUtil.IsWikiDoorSpecial(l.special) && l.args[0] == 0)
                {
                    Actor.Spawn("BasicDoorChecker", beaconSpawnPos);
                }
                else
                {
                    Actor.Spawn("BasicSwitchChecker", beaconSpawnPos);
                }
            }
            //This check can now be for switches that need to be shot so you can have different sound applies to it
            else if (l.special != 0 && l.activation & SPAC_Impact)
            {
                Actor.Spawn("ShootableSwitchChecker", beaconSpawnPos);
            }
            else if (Toby_LineUtil.IsTeleportLine(l))
            {
                Actor.Spawn("TeleporterBeacon_Toby", beaconSpawnPos);
            }
        }
    }
}

//Demo Sound Beacons

Class SoundMakerNormal : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("weapons/sshoto",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerSecret : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("weapons/sshotc",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerRedCard : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("weapons/sshotl",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerBlueCard : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("misc/p_pkup",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerYellowCard : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("misc/i_pkup",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerRedSkull : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("weapons/sshotl",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerBlueSkull : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("misc/p_pkup",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerYellowSkull : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("misc/i_pkup",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerAll : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("weapons/rocklx",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerDoors : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("misc/w_pkup",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
Class SoundMakerShootable : Actor
{
    Default{+NOBLOCKMAP;}
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_StartSound("weapons/pistol",CHAN_BODY,CHANF_LOOPING,1.0,ATTN_STATIC);
        TNT1 A -1;
        Stop;
    }
}
