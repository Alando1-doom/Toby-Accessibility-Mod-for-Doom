class Toby_ClassIgnoreListLoaderStaticHandler : StaticEventHandler
{
    Toby_ClassIgnoreListContainer universalPickupBeaconIgnoreList;
    Toby_ClassIgnoreListContainer snapToTargetIgnoreList;

    static Toby_ClassIgnoreListLoaderStaticHandler GetInstance()
    {
        return Toby_ClassIgnoreListLoaderStaticHandler(StaticEventHandler.Find("Toby_ClassIgnoreListLoaderStaticHandler"));
    }

    override void OnRegister()
    {
        universalPickupBeaconIgnoreList = Toby_ClassIgnoreListContainer.Create("Toby_UniversalPickupBeaconIgnoreList");
        snapToTargetIgnoreList = Toby_ClassIgnoreListContainer.Create("Toby_SnapToTargetIgnoreList");
        Toby_Logger.Message("Toby_ClassIgnoreListLoaderStaticHandler registered!", "Toby_Developer");
    }

    bool IsInIgnoreList(Actor a, Toby_ClassIgnoreListContainer ignoreList)
    {
        bool isInIgnoreList = false;
        for (int i = 0; i < ignoreList.classNames.Size(); i++)
        {
            if (a.GetClassName() == ignoreList.classNames[i])
            {
                isInIgnoreList = true;
                break;
            }
        }
        return isInIgnoreList;
    }
}
