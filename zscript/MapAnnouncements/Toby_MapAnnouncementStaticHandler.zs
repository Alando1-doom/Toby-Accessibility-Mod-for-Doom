class Toby_MapAnnouncementStaticHandler : StaticEventHandler
{
    ui Toby_MapAnnouncementManager manager;
    ui Toby_SoundBindingsLoaderStaticHandler bindings;
    ui bool isNotFirstRun;
    ui bool worldLoadedEvent;

    bool isSaveGame;
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
            bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();
            manager = Toby_MapAnnouncementManager.Create(bindings.mapNamesBindingsContainer);
        }

        if (worldLoadedEvent)
        {
            manager.SetTargetTickCount(checksum, isSaveGame);
            worldLoadedEvent = false;
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
        EventHandler.SendInterfaceEvent(consoleplayer, "Toby_MapAnnouncementWorldLoadedInterface");
    }

    override void InterfaceProcess(ConsoleEvent e)
    {
        if (e.Name == "Toby_MapAnnouncementWorldLoadedInterface")
        {
            worldLoadedEvent = true;
        }
    }

    override void PostUITick()
    {
        manager.Update();
    }
}
