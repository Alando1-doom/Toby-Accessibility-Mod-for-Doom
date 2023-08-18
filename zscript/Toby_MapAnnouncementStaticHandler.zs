class Toby_MapAnnouncementStaticHandler : StaticEventHandler
{
    ui Toby_SoundBindingsContainer mapNamesBindingsContainer;
    ui bool isNotFirstRun;
    int mapTickCount;
    int targetSoundTick;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_MapAnnouncementStaticHandler registered!", "Toby_Developer");
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            mapNamesBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_MapNameSoundBindings");
        }
    }

    override void WorldLoaded(WorldEvent e)
    {
        if ( gamestate != GS_TITLELEVEL )
        {
            mapTickCount = 0;
            targetSoundTick = 35;
        }
    }

    override void WorldTick()
    {
        if (mapTickCount <= targetSoundTick)
        {
            mapTickCount++;
        }
    }

    override void PostUITick()
    {
        if (mapTickCount != targetSoundTick) { return; }
        if (!CVar.FindCvar("Toby_PlayMapNameAnnouncement").GetBool()) { return; }
        PlayMapName();
    }

    ui void PlayMapName()
    {
        string mapNameSound = GetMapNameSound(level.GetChecksum());
        S_StartSound(mapNameSound, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
    }

    ui string GetMapNameSound(string checksum)
    {
        string mapNameSound = "";
        for (int i = 0; i < mapNamesBindingsContainer.soundBindings.Size(); i++)
        {
            if (checksum == mapNamesBindingsContainer.soundBindings[i].At("Checksum"))
            {
                mapNameSound = mapNamesBindingsContainer.soundBindings[i].At("SoundToPlay");
                break;
            }
        }
        return mapNameSound;
    }
}
