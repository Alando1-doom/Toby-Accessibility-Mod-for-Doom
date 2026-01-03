class Toby_MarkerExplorationBaseMenu : OptionMenu
{
    override void Init(Menu parent, OptionMenuDescriptor desc)
    {
        Super.Init(parent, desc);
        mDesc.mItems.Clear();
        mDesc.mSelectedItem = -1;

        mDesc.mItems.Push(new("Toby_MarkerPathfindingOptionMenuItem").Init("Stop pathfinding", "Toby_ResetPathfindingCommand"));
        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_ExplorationTracker tracker = handler.explorationTrackers[consoleplayer];

        Toby_MarkerDestinationCollection collection = BuildCollection(tracker);
        Toby_QuickSort.QuickSort(collection, 0, collection.Size() - 1);

        bool useDirectDistance = CVar.FindCvar("Toby_UseLegacyExplorationDistance").GetBool();
        for (int i = 0; i < collection.Size(); i++)
        {
            AddMenuItem(collection, i, useDirectDistance);
        }
    }

    protected int GetIgnoreDistance()
    {
        // ignoreDistance for destination deduplication
        // if two possible destination points are too close - discard one of them -PR
        return 16 * 10; //PlayerPawn.radius * 10;
    }

    protected virtual Toby_MarkerDestinationCollection BuildCollection(Toby_ExplorationTracker tracker)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerDestinationCollection.Create();
        return collection;
    }

    void AddMenuItem(Toby_MarkerDestinationCollection collection,
        int index,
        bool useDirectDistance
    )
    {
        Toby_MarkerDestinationItem item = (Toby_MarkerDestinationItem)(collection.GetObject(index));
        int distance = Round(item.pathLength);
        if (useDirectDistance)
        {
            distance = Round(item.distance);
        }
        string chessboardCoords = Toby_ChessboardCoordsChecker.WorldToChessboardCoords(item.coordinates);
        string description = item.direction.." - "..distance.." - "..chessboardCoords;
        if (item.destinationActor != "")
        {
            class<Actor> actorClass = item.destinationActor;
            description = GetDefaultByType(actorClass).GetTag().." - "..description;
        }
        string coordinates = item.coordinates.x..":"..item.coordinates.y..":"..item.coordinates.z;

        string className = "";
        if (item.destinationActor != "")
        {
            className = item.destinationActor;
        }
        Toby_MarkerExplorationMenuItem menuItem = Toby_MarkerExplorationMenuItem.Create(
            distance,
            item.direction,
            className,
            chessboardCoords
        );
        mDesc.mItems.Push(menuItem.Init(description, coordinates));
    }
}
