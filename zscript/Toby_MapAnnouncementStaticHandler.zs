class Toby_MapAnnouncementStaticHandler : StaticEventHandler
{
    ui Toby_SoundBindingsContainer mapNamesBindingsContainer;
    ui bool isNotFirstRun;

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
}
