//This is an event handler which spawns sound making actors at exit lines
//First Actor.Spawn spawns a normal sound actor for normal exits and end game exits
//Second Actor.Spawn spawns a secret sound actor for secret exits
//I didn't know how to get the floor height of the specific sector the lines belong to
//So remember to remove NOGRAVITY flag from your own sound actors

class TobyEventHandler : EventHandler
{
    override void WorldLoaded(WorldEvent e)
    {
        for(int l = 0; l < level.lines.size(); l++)
        {
            Vector2 pos = level.lines[l].v1.p + (level.lines[l].delta / 2.0);
            if(level.lines[l].special==243||level.lines[l].special==75)
            {
                Actor.Spawn("ExitBeacon1",(pos.x,pos.y,0));
            }
            else if(level.lines[l].special==244)
            {
                Actor.Spawn("SecretExitBeacon",(pos.x,pos.y,0));
            }
            //Figuring this out caused me a massive headache
            //Why does the Doom format and UDMF have different door locking?
            //Sorry for the next lines being such a mess, couldn't figure out of any other way
            //**********************************************************************************************
            //Red Key
            else if(level.lines[l].locknumber==1 || level.lines[l].locknumber==129 || level.lines[l].locknumber==132)
            {
                //This is awful -Proydoha; Oh it gets worse -Jarewill
                if (GameInfo.GameType & GAME_Hexen) {
                    Actor.Spawn("SteelKeyChecker",(pos.x,pos.y,0));
                } else if (GameInfo.GameType & GAME_Heretic) {
                    Actor.Spawn("GreenKeyChecker_V2",(pos.x,pos.y,0));
                } else {
                    Actor.Spawn("RedKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==13 && (level.lines[l].args[3]==1 || level.lines[l].args[3]==129 || level.lines[l].args[3]==132))
            {
                //This is awful -Proydoha
                if (GameInfo.GameType & GAME_Hexen) {
                    Actor.Spawn("SteelKeyChecker",(pos.x,pos.y,0));
                } else if (GameInfo.GameType & GAME_Heretic) {
                    Actor.Spawn("GreenKeyChecker_V2",(pos.x,pos.y,0));
                } else {
                    Actor.Spawn("RedKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==202 && (level.lines[l].args[4]==1 || level.lines[l].args[4]==129 || level.lines[l].args[4]==132))
            {
                //This is awful -Proydoha
                if (GameInfo.GameType & GAME_Hexen) {
                    Actor.Spawn("SteelKeyChecker",(pos.x,pos.y,0));
                } else if (GameInfo.GameType & GAME_Heretic) {
                    Actor.Spawn("GreenKeyChecker_V2",(pos.x,pos.y,0));
                } else {
                    Actor.Spawn("RedKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            //Blue Key
            Else If(level.lines[l].locknumber==2 || level.lines[l].locknumber==130 || level.lines[l].locknumber==133)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("CaveKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("BlueKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==13 && (level.lines[l].args[3]==2 || level.lines[l].args[3]==130 || level.lines[l].args[3]==133))
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("CaveKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("BlueKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==202 && (level.lines[l].args[4]==2 || level.lines[l].args[4]==130 || level.lines[l].args[4]==133))
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("CaveKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("BlueKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            //Yellow Key
            Else If(level.lines[l].locknumber==3 || level.lines[l].locknumber==131 || level.lines[l].locknumber==134)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AxeKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("YellowKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==13 && (level.lines[l].args[3]==3 || level.lines[l].args[3]==131 || level.lines[l].args[3]==134))
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AxeKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("YellowKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==202 && (level.lines[l].args[4]==3 || level.lines[l].args[4]==131 || level.lines[l].args[4]==134))
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AxeKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("YellowKeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            //Red Skull Key
            Else If(level.lines[l].locknumber==4)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("FireKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("RedSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==13 && level.lines[l].args[3]==4)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("FireKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("RedSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==202 && level.lines[l].args[4]==4)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("FireKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("RedSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            //Blue Skull Key
            Else If(level.lines[l].locknumber==5)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("EmeraldKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("BlueSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==13 && level.lines[l].args[3]==5)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("EmeraldKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("BlueSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==202 && level.lines[l].args[4]==5)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("EmeraldKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("BlueSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            //Yellow Skull Key
            Else If(level.lines[l].locknumber==6)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("DungeonKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("YellowSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==13 && level.lines[l].args[3]==6)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("DungeonKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("YellowSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==202 && level.lines[l].args[4]==6)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("DungeonKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("YellowSkullChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].locknumber==7){
                Actor.Spawn("SilverKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==13 && level.lines[l].args[3]==7){
                Actor.Spawn("SilverKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==202 && level.lines[l].args[4]==7){
                Actor.Spawn("SilverKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].locknumber==8){
                Actor.Spawn("RustedKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==13 && level.lines[l].args[3]==8){
                Actor.Spawn("RustedKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==202 && level.lines[l].args[4]==8){
                Actor.Spawn("RustedKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].locknumber==9){
                Actor.Spawn("HornKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==13 && level.lines[l].args[3]==9){
                Actor.Spawn("HornKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==202 && level.lines[l].args[4]==9){
                Actor.Spawn("HornKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].locknumber==10){
                Actor.Spawn("SwampKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==13 && level.lines[l].args[3]==10){
                Actor.Spawn("SwampKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==202 && level.lines[l].args[4]==10){
                Actor.Spawn("SwampKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].locknumber==11){
                Actor.Spawn("CastleKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==13 && level.lines[l].args[3]==11){
                Actor.Spawn("CastleKeyChecker",(pos.x,pos.y,0));
            }
            Else If(GameInfo.GameType & GAME_HEXEN && level.lines[l].special==202 && level.lines[l].args[4]==11){
                Actor.Spawn("CastleKeyChecker",(pos.x,pos.y,0));
            }
            //3 Key Checker
            Else If(level.lines[l].locknumber==229)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AllKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("3KeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==13 && (level.lines[l].args[3]==229))
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AllKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("3KeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==202 && (level.lines[l].args[4]==229))
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AllKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("3KeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            //6 Key Checker
            Else If(level.lines[l].locknumber==101)
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AllKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("6KeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==13 && (level.lines[l].args[3]==101))
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AllKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("6KeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            Else If(level.lines[l].special==202 && (level.lines[l].args[4]==101))
            {
                If(GameInfo.GameType & GAME_Hexen){
                    Actor.Spawn("AllKeyChecker",(pos.x,pos.y,0));
                }Else{
                    Actor.Spawn("6KeyChecker_V2",(pos.x,pos.y,0));
                }
            }
            //Any Key Checker
            Else If(level.lines[l].locknumber==100 || level.lines[l].locknumber==228)
            {
                Actor.Spawn("AnyKeyChecker_V2",(pos.x,pos.y,0));
            }
            Else If(level.lines[l].special==13 && (level.lines[l].args[3]==100 || level.lines[l].args[3]==228))
            {
                Actor.Spawn("AnyKeyChecker_V2",(pos.x,pos.y,0));
            }
            Else If(level.lines[l].special==202 && (level.lines[l].args[4]==100 || level.lines[l].args[4]==228))
            {
                Actor.Spawn("AnyKeyChecker_V2",(pos.x,pos.y,0));
            }
            //This check was altered for the switch/door differentiation
            Else If(level.lines[l].special!=0 && level.lines[l].activation&SPAC_Use)
            {
                int spec = level.lines[l].special;
                If(((spec>=10 && spec<=14) || (spec>=105 && spec<=106) || spec==202 || spec==249 || spec==274) && level.lines[l].args[0]==0)
                {
                    Actor.Spawn("BasicDoorChecker",(pos.x,pos.y,0));
                }
                Else
                {
                    Actor.Spawn("BasicSwitchChecker",(pos.x,pos.y,0));
                }
            }
            //This check can now be for switches that need to be shot so you can have different sound applies to it
            Else If(level.lines[l].special!=0 && level.lines[l].activation&SPAC_Impact)
            {
                Actor.Spawn("ShootableSwitchChecker",(pos.x,pos.y,0));
            }
            else if(Toby_SectorMathUtil.IsTeleportLine(level.lines[l]))
            {
                Actor.Spawn("TeleporterBeacon_Toby",(pos.x,pos.y,0));
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
