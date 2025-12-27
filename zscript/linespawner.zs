class TobyEventHandler : EventHandler
{
    override void WorldLoaded(WorldEvent e)
    {
        for (int i = 0; i < level.lines.size(); i++)
        {
            Line l = level.lines[i];

            Vector2 pos = l.v1.p + (l.delta / 2.0);
            Vector3 beaconSpawnPos = (pos.x, pos.y, 0);

            string beaconClass = GetBeaconClassForLine(l);
            if (beaconClass == "") { continue; }
            Actor.Spawn(beaconClass, beaconSpawnPos);
        }
    }

    string GetBeaconClassForLine(Line l)
    {
        if (Toby_LineUtil.IsExit(l) || Toby_LineUtil.IsEndGame(l)) { return "ExitBeacon1"; }
        if (Toby_LineUtil.IsSecretExit(l)) { return "SecretExitBeacon"; }

        int lockNumber = Toby_LineUtil.GetLockNumber(l);
        if (GameInfo.GameType & GAME_HEXEN)
        {
            if (Toby_LineUtil.IsRedDoor(lockNumber)) { return "SteelKeyChecker"; }
            if (Toby_LineUtil.IsBlueDoor(lockNumber)) { return "CaveKeyChecker"; }
            if (Toby_LineUtil.IsYellowDoor(lockNumber)) { return "AxeKeyChecker"; }
            if (Toby_LineUtil.IsRedSkullDoor(lockNumber)) { return "FireKeyChecker"; }
            if (Toby_LineUtil.IsBlueSkullDoor(lockNumber)) { return "EmeraldKeyChecker"; }
            if (Toby_LineUtil.IsYellowSkullDoor(lockNumber)) { return "DungeonKeyChecker"; }
            if (Toby_LineUtil.IsSilverKeyDoor(lockNumber)) { return "SilverKeyChecker"; }
            if (Toby_LineUtil.IsRustedKeyDoor(lockNumber)) { return "RustedKeyChecker"; }
            if (Toby_LineUtil.IsHornKeyDoor(lockNumber)) { return "HornKeyChecker"; }
            if (Toby_LineUtil.IsSwampKeyDoor(lockNumber)) { return "SwampKeyChecker"; }
            if (Toby_LineUtil.IsCastleKeyDoor(lockNumber)) { return "CastleKeyChecker"; }

            if (Toby_LineUtil.IsThreeKeyDoor(lockNumber)) { return "AllKeyChecker"; }
            if (Toby_LineUtil.IsSixKeyDoor(lockNumber)) { return "AllKeyChecker"; }
        }
        if (GameInfo.GameType & GAME_HERETIC)
        {
            if (Toby_LineUtil.IsRedDoor(lockNumber)) { return "GreenKeyChecker_V2"; }
            if (Toby_LineUtil.IsBlueDoor(lockNumber)) { return "BlueKeyChecker_V2"; }
            if (Toby_LineUtil.IsYellowDoor(lockNumber)) { return "YellowKeyChecker_V2"; }
        }

        if (Toby_LineUtil.IsRedDoor(lockNumber)) { return "RedKeyChecker_V2"; }
        if (Toby_LineUtil.IsBlueDoor(lockNumber)) { return "BlueKeyChecker_V2"; }
        if (Toby_LineUtil.IsYellowDoor(lockNumber)) { return "YellowKeyChecker_V2"; }
        if (Toby_LineUtil.IsRedSkullDoor(lockNumber)) { return "RedSkullChecker_V2"; }
        if (Toby_LineUtil.IsBlueSkullDoor(lockNumber)) { return "BlueSkullChecker_V2"; }
        if (Toby_LineUtil.IsYellowSkullDoor(lockNumber)) { return "YellowSkullChecker_V2"; }

        if (Toby_LineUtil.IsThreeKeyDoor(lockNumber)) { return "3KeyChecker_V2"; }
        if (Toby_LineUtil.IsSixKeyDoor(lockNumber)) { return "6KeyChecker_V2"; }
        if (Toby_LineUtil.IsAnyKeyDoor(lockNumber)) { return "AnyKeyChecker_V2"; }

        //This check was altered for the switch/door differentiation
        if (l.special != 0 && l.activation & SPAC_Use)
        {
            if (Toby_LineUtil.IsWikiDoorSpecial(l.special) && l.args[0] == 0) { return "BasicDoorChecker"; }
            else { return "BasicSwitchChecker"; }
        }
        //This check can now be for switches that need to be shot so you can have different sound applies to it
        if (l.special != 0 && l.activation & SPAC_Impact) { return "ShootableSwitchChecker"; }
        if (Toby_LineUtil.IsTeleportLine(l)) { return "TeleporterBeacon_Toby"; }
        return "";
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
