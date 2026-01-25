class Toby_TargetDetector
{
    private int cooldown;
    private int cooldownMax;
    private int defaultCooldown;
    private ui Array<Toby_TargetDetectorEntry> database;
    private Toby_TargetDetectorEntry emptyEntry;

    private bool targetAnnouncementEnabled;
    private int lastUpdate;
    private int targetResetTime;
    private string previousTarget;
    private int narrationType;
    private Toby_SoundBindingsLoaderStaticHandler bindings;

    ui static Toby_TargetDetector Create(Toby_SoundBindingsLoaderStaticHandler bindings)
    {
        Toby_TargetDetector targetDetector = new("Toby_TargetDetector");
        targetDetector.cooldown = 0;
        targetDetector.defaultCooldown = 6;
        targetDetector.cooldownMax = targetDetector.defaultCooldown;

        targetDetector.targetAnnouncementEnabled = false;
        targetDetector.previousTarget = "";
        targetDetector.targetResetTime = 75;
        targetDetector.lastUpdate = 0;

        targetDetector.bindings = bindings;
        targetDetector.CreateDatabase(bindings.targetDetectorBindingsContainer);
        targetDetector.emptyEntry = Toby_TargetDetectorEntry.Create("", "weapons/lock", targetDetector.defaultCooldown);
        targetDetector.narrationType = Cvar.GetCvar("Toby_NarrationOutputType", players[consoleplayer]).GetInt();
        return targetDetector;
    }

    ui void Update(string className)
    {
        PlayTargetSound(className);
        cooldown++;
        if (cooldown > cooldownMax)
        {
            cooldown = 0;
        }
        HandleTargetReset(className);
        if (className != previousTarget)
        {
            AnnounceTargetChange(className);
        }
        previousTarget = className;
        lastUpdate = level.mapTime;
    }

    ui void ToggleTargetAnnouncement()
    {
        targetAnnouncementEnabled = !targetAnnouncementEnabled;
        if (narrationType == TNOT_CONSOLE)
        {
            if (targetAnnouncementEnabled)
            {
                Toby_Logger.ConsoleOutputModeMessage("Target Announcement Enabled");
            }
            else
            {
                Toby_Logger.ConsoleOutputModeMessage("Target Announcement Disabled");
            }
        }
        else
        {
            if (targetAnnouncementEnabled)
            {
                S_StartSound("stats/targetannouncement/enabled", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
            }
            else
            {
                S_StartSound("stats/targetannouncement/disabled", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
            }
        }
    }

    private ui void PlayTargetSound(string className)
    {
        if (paused) { return; }
        if (consoleState == c_down) { return; }
        if (menuactive) { return; }
        Toby_TargetDetectorEntry currentEntry = FindEntryByClassName(className);
        cooldownMax = currentEntry.cooldown;
        if (cooldown != cooldownMax) { return; }
        S_StartSound(currentEntry.soundToPlay, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
    }

    private ui void HandleTargetReset(string className)
    {
        int timeDifference = level.mapTime - lastUpdate;
        if (level.mapTime - lastUpdate > targetResetTime)
        {
            previousTarget = "";
        }
    }

    private ui void AnnounceTargetChange(string className)
    {
        if (!targetAnnouncementEnabled) { return; }
        if (paused) { return; }
        if (consoleState == c_down) { return; }
        if (menuactive) { return; }
        if (narrationType == TNOT_CONSOLE)
        {
            AnnounceTargetChangeTextOnly(className);
        }
        else
        {
            AnnounceTargetChangeVoiced(className);
        }
    }

    private ui void AnnounceTargetChangeVoiced(string className)
    {
        string soundToPlay = Toby_SoundBindingsLoaderStaticHandler.GetActorSoundName(bindings.actorsInViewportSoundBindings, className);
        S_StartSound(soundToPlay, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
    }

    private ui void AnnounceTargetChangeTextOnly(string className)
    {
        class<Actor> actorClass = className;
        string classTagOrName = GetDefaultByType(actorClass).GetTag();
        Toby_Logger.ConsoleOutputModeMessage(classTagOrName);
    }

    private ui Toby_TargetDetectorEntry FindEntryByClassName(string className)
    {
        for (int i = 0; i < database.Size(); i++)
        {
            if (database[i].className == className)
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
            string soundToPlay = soundBindingsContainer.soundBindings[i].At("SoundToPlay");
            int playbackCooldown = S_GetLength(soundToPlay) * 1000 / GameTicRate;
            if (soundBindingsContainer.soundBindings[i].At("Cooldown") != "")
            {
                playbackCooldown = soundBindingsContainer.soundBindings[i].At("Cooldown").ToInt();
            }
            database.push(Toby_TargetDetectorEntry.Create(
                soundBindingsContainer.soundBindings[i].At("ClassName"),
                soundToPlay,
                playbackCooldown
            ));
        }
    }
}
