class Toby_ClassIgnoreListLoaderStaticHandler : StaticEventHandler
{
    Toby_ClassIgnoreListContainer universalPickupBeaconIgnoreList;
    Toby_ClassIgnoreListContainer snapToTargetIgnoreList;
    Toby_ClassIgnoreListContainer wallHitIgnoreList;
    Toby_ClassIgnoreListContainer areaScannerIgnoreList;

    static Toby_ClassIgnoreListLoaderStaticHandler GetInstance()
    {
        return Toby_ClassIgnoreListLoaderStaticHandler(StaticEventHandler.Find("Toby_ClassIgnoreListLoaderStaticHandler"));
    }

    ui static Toby_ClassIgnoreListLoaderStaticHandler GetInstanceUi()
    {
        return Toby_ClassIgnoreListLoaderStaticHandler(StaticEventHandler.Find("Toby_ClassIgnoreListLoaderStaticHandler"));
    }

    override void OnRegister()
    {
        universalPickupBeaconIgnoreList = Toby_ClassIgnoreListContainer.Create("Toby_UniversalPickupBeaconIgnoreList");
        snapToTargetIgnoreList = Toby_ClassIgnoreListContainer.Create("Toby_SnapToTargetIgnoreList");
        wallHitIgnoreList = Toby_ClassIgnoreListContainer.Create("Toby_WallHitIgnoreList");
        areaScannerIgnoreList = Toby_ClassIgnoreListContainer.Create("Toby_AreaScannerIgnoreList");
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

    ui bool IsInIgnoreListStringUi(string str, Toby_ClassIgnoreListContainer ignoreList)
    {
        bool isInIgnoreList = false;
        for (int i = 0; i < ignoreList.classNames.Size(); i++)
        {
            if (str == ignoreList.classNames[i])
            {
                isInIgnoreList = true;
                break;
            }
        }
        return isInIgnoreList;
    }
}
