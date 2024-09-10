class Toby_MapAnnouncementManager
{
    private ui Array<Toby_MapAnnouncementEntry> database;
    private ui Toby_MapAnnouncementEntry emptyEntry;
    private ui int defaultLevelStartDelay;

    private ui string currentChecksum;
    private ui int targetTickCount;
    private ui int tickCount;

    ui static Toby_MapAnnouncementManager Create(Toby_SoundBindingsContainer soundBindingsContainer)
    {
        Toby_MapAnnouncementManager manager = new("Toby_MapAnnouncementManager");
        manager.defaultLevelStartDelay = 35;
        manager.emptyEntry = Toby_MapAnnouncementEntry.Create("", "", manager.defaultLevelStartDelay);
        manager.CreateDatabase(soundBindingsContainer);

        return manager;
    }

    ui void SetTargetTickCount(string checksum, bool isSaveGame)
    {
        currentChecksum = checksum;
        tickCount = 0;
        if (isSaveGame)
        {
            targetTickCount = defaultLevelStartDelay;
        }
        else
        {
            targetTickCount = FindEntryByChecksum(currentChecksum).levelStartPlaybackDelay;
        }
    }

    ui void Update()
    {
        if (tickCount <= targetTickCount)
        {
            tickCount++;
        }

        if (tickCount == targetTickCount)
        {
            if (CVar.FindCvar("Toby_NarrationOutputType").GetInt() == TNOT_CONSOLE)
            {
                string textToPrint = level.MapName .. " - " .. level.LevelName;
                Toby_Logger.ConsoleOutputModeMessage(textToPrint);
            }
            else
            {
                S_StartSound(FindEntryByChecksum(currentChecksum).soundToPlay, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
            }
        }
    }

    private ui Toby_MapAnnouncementEntry FindEntryByChecksum(string checksum)
    {
        for (int i = 0; i < database.Size(); i++)
        {
            if (database[i].Checksum == checksum)
            {
                return database[i];
            }
        }
        return emptyEntry;
    }

    private ui void CreateDatabase(Toby_SoundBindingsContainer soundBindingsContainer)
    {
        for (int i = 0; i < soundBindingsContainer.soundBindings.Size(); i++)
        {
            int playbackDelay = defaultLevelStartDelay;
            if (soundBindingsContainer.soundBindings[i].At("LevelStartPlaybackDelay") != "")
            {
                playbackDelay = soundBindingsContainer.soundBindings[i].At("LevelStartPlaybackDelay").ToInt();
            }
            database.push(Toby_MapAnnouncementEntry.Create(
                soundBindingsContainer.soundBindings[i].At("Checksum"),
                soundBindingsContainer.soundBindings[i].At("SoundToPlay"),
                playbackDelay
            ));
        }
    }
}
