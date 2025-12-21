class Toby_MarkerExplorationKeysMenu : OptionMenu
{
    override void Init(Menu parent, OptionMenuDescriptor desc)
    {
        Super.Init(parent, desc);
        mDesc.mItems.Clear();
        mDesc.mSelectedItem = -1;

        mDesc.mItems.Push(new("Toby_MarkerPathfindingOptionMenuItem").Init("Stop pathfinding", "Toby_ResetPathfindingCommand"));
        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_ExplorationTracker tracker = handler.explorationTrackers[consoleplayer];

        // ignoreDistance for destination deduplication
        // if two possible destination points are too close - discard one of them -PR
        int ignoreDistance = 16 * 10; //PlayerPawn.radius * 10;

        Toby_MarkerDestinationCollection collection = Toby_MarkerExplorationMenuHelpers.CreateDestinationCollectionKeys(
            tracker,
            ignoreDistance
        );
        Toby_QuickSort.QuickSort(collection, 0, collection.Size() - 1);

        bool useDirectDistance = CVar.FindCvar("Toby_UseLegacyExplorationDistance").GetBool();
        for (int i = 0; i < collection.Size(); i++)
        {
            Toby_MarkerDestinationItem item = (Toby_MarkerDestinationItem)(collection.GetObject(i));
            int distance = Round(item.pathLength);
            if (useDirectDistance)
            {
                distance = Round(item.distance);
            }
            string description = item.direction.. " - "..distance;
            string coordinates = item.coordinates.x..":"..item.coordinates.y..":"..item.coordinates.z;
            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, coordinates));
        }
    }

    override bool MenuEvent(int key, bool fromController) {
        return Super.MenuEvent(key, fromController);
    }
}
