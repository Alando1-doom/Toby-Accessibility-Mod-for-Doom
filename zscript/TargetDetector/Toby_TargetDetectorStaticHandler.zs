class Toby_TargetDetectorStaticHandler : StaticEventHandler
{
    private ui Toby_TargetDetector targetDetector;
    private ui bool isNotFirstRun;
    private ui Toby_SoundBindingsLoaderStaticHandler bindings;
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
            bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();
            targetDetector = Toby_TargetDetector.Create(bindings.targetDetectorBindingsContainer);
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
