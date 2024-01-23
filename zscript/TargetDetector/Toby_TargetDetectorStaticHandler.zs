class Toby_TargetDetectorStaticHandler : StaticEventHandler
{
    private ui Toby_SoundBindingsContainer targetDetectorBindingsContainer;
    private ui Toby_TargetDetector targetDetector;
    private ui bool isNotFirstRun;
    private Toby_TargetDetectorHandler handler;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_TargetDetectorStaticHandler registered!", "Toby_Developer");
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;

            targetDetectorBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_TargetDetectorSoundBindings");
            targetDetector = Toby_TargetDetector.Create(targetDetectorBindingsContainer);
        }
    }

    override void WorldLoaded(WorldEvent e)
    {
        handler = Toby_TargetDetectorHandler(EventHandler.Find("Toby_TargetDetectorHandler"));
    }

    override void PostUITick()
    {
        if (!handler) { return; }
        if (!handler.playerAimTargets[consoleplayer]) { return; }
        if (gamestate != GS_LEVEL) { return; }
        targetDetector.Update(handler.playerAimTargets[consoleplayer].GetClassName());
    }
}
