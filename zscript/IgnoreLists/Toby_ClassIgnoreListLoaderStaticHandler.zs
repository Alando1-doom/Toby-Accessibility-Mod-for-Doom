class Toby_ClassIgnoreListLoaderStaticHandler : StaticEventHandler
{
    Toby_ClassIgnoreListContainer universalPickupBeaconIgnoreList;

    static Toby_ClassIgnoreListLoaderStaticHandler GetInstance()
    {
        return Toby_ClassIgnoreListLoaderStaticHandler(StaticEventHandler.Find("Toby_ClassIgnoreListLoaderStaticHandler"));
    }

    override void OnRegister()
    {
        universalPickupBeaconIgnoreList = Toby_ClassIgnoreListContainer.Create("Toby_UniversalPickupBeaconIgnoreList");
        Toby_Logger.Message("Toby_ClassIgnoreListLoaderStaticHandler registered!", "Toby_Developer");
    }
}
