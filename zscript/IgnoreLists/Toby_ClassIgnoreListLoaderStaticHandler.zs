class Toby_ClassIgnoreListLoaderStaticHandler : StaticEventHandler
{
    ui bool isNotFirstRun;

    ui Toby_ClassIgnoreListContainer universalPickupBeaconIgnoreList;

    ui static Toby_ClassIgnoreListLoaderStaticHandler GetInstance()
    {
        return Toby_ClassIgnoreListLoaderStaticHandler(StaticEventHandler.Find("Toby_ClassIgnoreListLoaderStaticHandler"));
    }

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_ClassIgnoreListLoaderStaticHandler registered!", "Toby_Developer");
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            universalPickupBeaconIgnoreList = Toby_ClassIgnoreListContainer.Create("Toby_UniversalPickupBeaconIgnoreList");
        }
    }
}
