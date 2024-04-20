class Toby_MapAnnouncementStaticHandler : StaticEventHandler
{
    ui Toby_MapAnnouncementManager manager;
    ui Toby_SoundBindingsLoaderStaticHandler bindings;
    ui bool isNotFirstRun;

    bool isSaveGame;
    bool worldLoadedEvent;
    string checksum;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_MapAnnouncementStaticHandler registered!", "Toby_Developer");
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            bindings = Toby_SoundBindingsLoaderStaticHandler(StaticEventHandler.Find("Toby_SoundBindingsLoaderStaticHandler"));
            manager = Toby_MapAnnouncementManager.Create(bindings.mapNamesBindingsContainer);
        }

        if (worldLoadedEvent)
        {
            manager.SetTargetTickCount(checksum, isSaveGame);
        }
    }

    override void WorldLoaded(WorldEvent e)
    {
        if ( gamestate == GS_TITLELEVEL )
        {
            return;
        }
        isSaveGame = e.IsSaveGame;
        checksum = level.GetChecksum();
        worldLoadedEvent = true;
    }

    override void WorldTick()
    {
        if (worldLoadedEvent)
        {
            worldLoadedEvent = false;
        }
    }

    override void PostUITick()
    {
        manager.Update();
    }
}
