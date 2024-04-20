class Toby_SoundBindingsLoaderStaticHandler : StaticEventHandler
{
    ui bool isNotFirstRun;

    ui Toby_SoundBindingsContainer keysSoundBindingsContainer;
    ui Toby_SoundBindingsContainer weaponsSoundBindingsContainer;
    ui Toby_SoundBindingsContainer ammoSoundBindingsContainer;
    ui Toby_SoundBindingsContainer armorSoundBindingsContainer;
    ui Toby_SoundBindingsContainer targetDetectorBindingsContainer;
    ui Toby_SoundBindingsContainer mapNamesBindingsContainer;
    ui Toby_SoundBindingsContainer actorsInViewportSoundBindings;
    ui Toby_SoundBindingsContainer menuSoundBindingsContainer;

    ui static Toby_SoundBindingsLoaderStaticHandler GetInstance()
    {
        return Toby_SoundBindingsLoaderStaticHandler(StaticEventHandler.Find("Toby_SoundBindingsLoaderStaticHandler"));
    }

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_SoundBindingsLoaderStaticHandler registered!", "Toby_Developer");
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            keysSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_KeyNameSoundBindings");
            weaponsSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_WeaponNameSoundBindings");
            ammoSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_AmmoNameSoundBindings");
            armorSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_ArmorNameSoundBindings");
            targetDetectorBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_TargetDetectorSoundBindings");
            mapNamesBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_MapNameSoundBindings");
            actorsInViewportSoundBindings = Toby_SoundBindingsContainer.Create("Toby_ActorsInViewportSoundBindings");
            menuSoundBindingsContainer = Toby_SoundBindingsContainer.Create("Toby_MenuSoundBindings");
        }
    }
}
