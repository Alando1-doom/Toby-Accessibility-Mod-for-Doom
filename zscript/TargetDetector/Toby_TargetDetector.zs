class Toby_TargetDetector
{
    private int cooldown;
    private int cooldownMax;
    private int defaultCooldown;
    private ui Array<Toby_TargetDetectorEntry> database;
    private Toby_TargetDetectorEntry emptyEntry;

    ui static Toby_TargetDetector Create(Toby_SoundBindingsContainer soundBindingsContainer)
    {
        Toby_TargetDetector targetDetector = new("Toby_TargetDetector");
        targetDetector.cooldown = 0;
        targetDetector.defaultCooldown = 6;
        targetDetector.cooldownMax = targetDetector.defaultCooldown;
        targetDetector.CreateDatabase(soundBindingsContainer);
        targetDetector.emptyEntry = Toby_TargetDetectorEntry.Create("", "weapons/lock", targetDetector.defaultCooldown);
        return targetDetector;
    }

    ui void Update(string className)
    {
        PlayTargetSound(className);
        cooldown++;
        if (cooldown > cooldownMax) {
            cooldown = 0;
        }
    }

    private ui void PlayTargetSound(string className)
    {
        if (paused) { return; }
        Toby_MenuStaticHandler menuHandler = Toby_MenuStaticHandler(StaticEventHandler.Find("Toby_MenuStaticHandler"));
        if (menuHandler.IsUiProcessor) { return; }
        Toby_TargetDetectorEntry currentEntry = FindEntryByClassName(className);
        cooldownMax = currentEntry.cooldown;
        if (cooldown != cooldownMax) { return; }
        S_StartSound(currentEntry.soundToPlay, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
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
