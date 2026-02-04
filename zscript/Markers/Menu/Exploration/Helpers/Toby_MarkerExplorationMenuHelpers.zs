class Toby_MarkerExplorationMenuHelpers
{
    ui static Toby_MarkerDestinationCollection CreateDestinationCollection(Toby_ExplorationTracker tracker, Toby_IntegerSet intSet, int ignoreDistance, bool oneUnitToTarget = true)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerDestinationCollection.Create();

        if (!players[consoleplayer].mo) { return collection; }
        PlayerPawn playerActor = players[consoleplayer].mo;

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_Pathfinder pathfinder = handler.pathfindersForMenu[consoleplayer];
        Toby_ExplorationPathfinder explorationPathfinder = handler.explorationPathfindersForMenu[consoleplayer];

        for (uint i = 0; i < intSet.Size(); i++)
        {
            int lineId = intSet.values[i];
            Line l = level.lines[lineId];
            Sector s = tracker.GetExploredOrVisitedSectorForLine(l);
            if (!s)
            {
                s = l.frontSector; // A little bit dodgy assumption but I hope isReachable will fail if this assumption is bad -PR
            }

            // 'normal' here is destination point
            vector2 normal = Toby_SectorMathUtil.GetNormal(s, l, playerActor, oneUnitToTarget);

            // Deduplication
            bool tooClose = Toby_MarkerExplorationMenuHelpers.IsTooClose(collection, normal, ignoreDistance);
            if (tooClose) { continue; }

            // Check if destination can be reached
            Vector3 destination = (normal, s.CenterFloor());
            bool isReachable = Toby_MarkerExplorationMenuHelpers.IsReachableByPathfinder(
                pathfinder,
                explorationPathfinder,
                destination,
                playerActor
            );
            double pathLength = pathfinder.GetPathLength();
            if (pathLength == 0) { continue; }

            // Add to collection
            if (oneUnitToTarget)
            {
                collection.AddItem(destination, playerActor, pathLength);
            }
            else
            {
                string actorClass = Toby_LineSpawnerHelper.GetBeaconClassForLine(l);
                collection.AddItem(destination, playerActor, pathLength, actorClass);
            }
        }

        return collection;
    }

    ui static Toby_MarkerDestinationCollection CreateDestinationCollectionRepeatableSwitches(Toby_ExplorationTracker tracker, int ignoreDistance, bool oneUnitToTarget = true)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerDestinationCollection.Create();

        if (!players[consoleplayer].mo) { return collection; }
        PlayerPawn playerActor = players[consoleplayer].mo;

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_Pathfinder pathfinder = handler.pathfindersForMenu[consoleplayer];
        Toby_ExplorationPathfinder explorationPathfinder = handler.explorationPathfindersForMenu[consoleplayer];

        for (uint i = 0; i < level.lines.Size(); i++)
        {
            Line l = level.lines[i];
            int lineId = l.Index();
            if (!Toby_LineUtil.IsRepeatable(l)) { continue; }
            if (!Toby_LineUtil.IsUseActivated(l)) { continue; }
            bool isNonInteracted = tracker.nonInteractedLines.IsInSet(lineId);
            bool isInteracted = tracker.lineInteractionTracker.interactedLines[lineId];
            if (!(isNonInteracted || isInteracted)) { continue; }
            Sector s = tracker.GetExploredOrVisitedSectorForLine(l);
            if (!s)
            {
                s = l.frontSector; // A little bit dodgy assumption but I hope isReachable will fail if this assumption is bad -PR
            }

            // 'normal' here is destination point
            vector2 normal = Toby_SectorMathUtil.GetNormal(s, l, playerActor, oneUnitToTarget);

            // Deduplication
            bool tooClose = Toby_MarkerExplorationMenuHelpers.IsTooClose(collection, normal, ignoreDistance);
            if (tooClose) { continue; }

            // Check if destination can be reached
            Vector3 destination = (normal, s.CenterFloor());
            bool isReachable = Toby_MarkerExplorationMenuHelpers.IsReachableByPathfinder(
                pathfinder,
                explorationPathfinder,
                destination,
                playerActor
            );
            double pathLength = pathfinder.GetPathLength();
            if (pathLength == 0) { continue; }

            // Add to collection
            if (oneUnitToTarget)
            {
                collection.AddItem(destination, playerActor, pathLength);
            }
            else
            {
                string actorClass = Toby_LineSpawnerHelper.GetBeaconClassForLine(l);
                collection.AddItem(destination, playerActor, pathLength, actorClass);
            }
        }

        return collection;
    }

    ui static Toby_MarkerDestinationCollection CreateDestinationCollectionTeleportLines(Toby_ExplorationTracker tracker, Toby_IntegerSet intSet, int ignoreDistance, bool oneUnitToTarget = true)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerDestinationCollection.Create();

        if (!players[consoleplayer].mo) { return collection; }
        PlayerPawn playerActor = players[consoleplayer].mo;

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_Pathfinder pathfinder = handler.pathfindersForMenu[consoleplayer];
        Toby_ExplorationPathfinder explorationPathfinder = handler.explorationPathfindersForMenu[consoleplayer];

        for (uint i = 0; i < intSet.Size(); i++)
        {
            int lineId = intSet.values[i];
            Line l = level.lines[lineId];
            bool isTeleportLine = Toby_LineUtil.IsTeleportLine(l);
            bool isWalkOverExit = (Toby_LineUtil.IsExit(l) || Toby_LineUtil.IsSecretExit(l) || Toby_LineUtil.IsEndGame(l)) && Toby_LineUtil.IsCrossActivated(l);
            bool teleportOrExit = isWalkOverExit || isTeleportLine;
            if (!teleportOrExit) { continue; }
            Sector s = tracker.GetExploredOrVisitedSectorForLine(l);
            if (!s) { continue; }

            // 'normal' here is destination point
            vector2 normal = Toby_SectorMathUtil.GetNormal(s, l, playerActor, oneUnitToTarget);

            // Deduplication
            bool tooClose = Toby_MarkerExplorationMenuHelpers.IsTooClose(collection, normal, ignoreDistance);
            if (tooClose) { continue; }

            // Check if destination can be reached
            Vector3 destination = (normal, s.CenterFloor());
            bool isReachable = Toby_MarkerExplorationMenuHelpers.IsReachableByPathfinder(
                pathfinder,
                explorationPathfinder,
                destination,
                playerActor
            );
            double pathLength = pathfinder.GetPathLength();
            if (pathLength == 0) { continue; }

            // Add to collection
            string actorClass = Toby_LineSpawnerHelper.GetBeaconClassForLine(l);
            collection.AddItem(destination, playerActor, pathLength, actorClass);
        }

        return collection;
    }

    // Awful -PR
    ui static bool IsKeyOrTobyKey(Inventory a)
    {
        if (a is "Key") { return true; }

        if (a.GetClassName() == "BlueCard_TO") { return true; }
        if (a.GetClassName() == "BlueSkullKey_TO") { return true; }
        if (a.GetClassName() == "RedCard_TO") { return true; }
        if (a.GetClassName() == "RedSkullKey_TO") { return true; }
        if (a.GetClassName() == "YellowCard_TO") { return true; }
        if (a.GetClassName() == "YellowSkullKey_TO") { return true; }

        if (a.GetClassName() == "GreenKey_Toby") { return true; }
        if (a.GetClassName() == "BlueKey_Toby") { return true; }
        if (a.GetClassName() == "YellowKey_Toby") { return true; }

        if (a.GetClassName() == "SteelKey_Toby") { return true; }
        if (a.GetClassName() == "CaveKey_Toby") { return true; }
        if (a.GetClassName() == "AxeKey_Toby") { return true; }
        if (a.GetClassName() == "FireKey_Toby") { return true; }
        if (a.GetClassName() == "EmeraldKey_Toby") { return true; }
        if (a.GetClassName() == "DungeonKey_Toby") { return true; }
        if (a.GetClassName() == "SilverKey_Toby") { return true; }
        if (a.GetClassName() == "RustedKey_Toby") { return true; }
        if (a.GetClassName() == "HornKey_Toby") { return true; }
        if (a.GetClassName() == "SwampKey_Toby") { return true; }
        if (a.GetClassName() == "CastleKey_Toby") { return true; }
        return false;
    }

    ui static Toby_MarkerDestinationCollection CreateDestinationCollectionKeys(Toby_ExplorationTracker tracker, int ignoreDistance)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerDestinationCollection.Create();

        if (!players[consoleplayer].mo) { return collection; }
        PlayerPawn playerActor = players[consoleplayer].mo;

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_Pathfinder pathfinder = handler.pathfindersForMenu[consoleplayer];
        Toby_ExplorationPathfinder explorationPathfinder = handler.explorationPathfindersForMenu[consoleplayer];

        ThinkerIterator actorFinder = ThinkerIterator.Create("Inventory");
        Inventory foundActor;
        while (foundActor = (Inventory)(actorFinder.Next()))
        {
            if (foundActor.owner) { continue; }
            if (!Toby_MarkerExplorationMenuHelpers.IsKeyOrTobyKey(foundActor)) { continue; }
            int sectorIndex = foundActor.curSector.Index();
            if (!(tracker.IsVisited(sectorIndex) || tracker.isExplored(sectorIndex))) { continue; }

            // Deduplication
            bool tooClose = Toby_MarkerExplorationMenuHelpers.IsSameClassNameTooClose(
                collection,
                foundActor.pos.xy,
                ignoreDistance,
                foundActor
            );
            if (tooClose) { continue; }

            // Check if destination can be reached
            Vector3 destination = foundActor.pos;
            bool isReachable = Toby_MarkerExplorationMenuHelpers.IsReachableByPathfinder(
                pathfinder,
                explorationPathfinder,
                destination,
                playerActor
            );
            if (!isReachable) { continue; }
            double pathLength = pathfinder.GetPathLength();
            if (pathLength == 0) { continue; }
            collection.AddItem(destination, playerActor, pathLength, foundActor.GetClassName());
        }

        // Add to collection
        return collection;
    }

    ui static Toby_MarkerDestinationCollection CreateDestinationCollectionPickups(Toby_ExplorationTracker tracker, int ignoreDistance)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerDestinationCollection.Create();

        if (!players[consoleplayer].mo) { return collection; }
        PlayerPawn playerActor = players[consoleplayer].mo;

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_Pathfinder pathfinder = handler.pathfindersForMenu[consoleplayer];
        Toby_ExplorationPathfinder explorationPathfinder = handler.explorationPathfindersForMenu[consoleplayer];

        ThinkerIterator actorFinder = ThinkerIterator.Create("Inventory");
        Inventory foundActor;
        while (foundActor = (Inventory)(actorFinder.Next()))
        {
            if (Toby_MarkerExplorationMenuHelpers.IsKeyOrTobyKey(foundActor)) { continue; }
            if (foundActor.owner) { continue; }
            int sectorIndex = foundActor.curSector.Index();
            if (!(tracker.IsVisited(sectorIndex) || tracker.isExplored(sectorIndex))) { continue; }

            // Deduplication
            bool tooClose = Toby_MarkerExplorationMenuHelpers.IsSameClassNameTooClose(
                collection,
                foundActor.pos.xy,
                ignoreDistance,
                foundActor
            );
            if (tooClose) { continue; }

            // Check if destination can be reached
            Vector3 destination = foundActor.pos;
            bool isReachable = Toby_MarkerExplorationMenuHelpers.IsReachableByPathfinder(
                pathfinder,
                explorationPathfinder,
                destination,
                playerActor
            );
            if (!isReachable) { continue; }
            double pathLength = pathfinder.GetPathLength();
            if (pathLength == 0) { continue; }
            collection.AddItem(destination, playerActor, pathLength, foundActor.GetClassName());
        }

        // Add to collection
        return collection;
    }

    ui static bool IsReachableByPathfinder(Toby_Pathfinder pathfinder, Toby_ExplorationPathfinder explorationPathfinder, Vector3 destination, PlayerPawn playerActor)
    {
        int attemptCount = 5 * 100; // 100 is the default for FindPath
        int destinationSector = level.PointInSector(destination.xy).Index();
        explorationPathfinder.FindPathFromDestinationToExploredSector(destinationSector);
        pathfinder.StartPathfinding(playerActor.pos, destination, explorationPathfinder.explorationNodes);
        pathfinder.FindPath(attemptCount);
        return pathfinder.pathFinalized;
    }

    ui static bool IsTooClose(Toby_MarkerDestinationCollection collection, Vector2 coordinates2d, int ignoreDistance)
    {
        bool tooClose = false;
        for (uint j = 0; j < collection.Size(); j++)
        {
            Toby_MarkerDestinationItem item = (Toby_MarkerDestinationItem)(collection.GetObject(j));
            if (!item) { continue; }
            double distanceToPoint = ((item.coordinates.x, item.coordinates.y) - coordinates2d).Length();
            if (distanceToPoint < ignoreDistance)
            {
                tooClose = true;
                break;
            };
        }
        return tooClose;
    }

    ui static bool IsSameClassNameTooClose(Toby_MarkerDestinationCollection collection, Vector2 coordinates2d, int ignoreDistance, Actor otherActor)
    {
        bool tooClose = false;
        for (uint j = 0; j < collection.Size(); j++)
        {
            Toby_MarkerDestinationItem item = (Toby_MarkerDestinationItem)(collection.GetObject(j));
            if (!item) { continue; }
            if (item.destinationActor == "") { continue; }
            if (item.destinationActor != otherActor.GetClassName()) { continue; }
            double distanceToPoint = ((item.coordinates.x, item.coordinates.y) - coordinates2d).Length();
            if (distanceToPoint < ignoreDistance)
            {
                tooClose = true;
                break;
            };
        }
        return tooClose;
    }
}
