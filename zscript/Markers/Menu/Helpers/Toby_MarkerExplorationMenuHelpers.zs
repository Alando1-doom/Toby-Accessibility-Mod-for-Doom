class Toby_MarkerExplorationMenuHelpers
{

    ui static Toby_MarkerDestinationCollection CreateDestinationCollection(Toby_ExplorationTracker tracker, Toby_IntegerSet intSet, int ignoreDistance, bool oneUnitToTarget = true)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerDestinationCollection.Create();

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_Pathfinder pathfinder = handler.pathfindersForMenu[consoleplayer];
        Toby_ExplorationPathfinder explorationPathfinder = handler.explorationPathfindersForMenu[consoleplayer];

        for (uint i = 0; i < intSet.Size(); i++)
        {
            int lineId = intSet.values[i];
            Line l = level.lines[lineId];
            Sector s = tracker.GetExploredOrVisitedSectorForLine(l);
            if (!s) { continue; }

            if (!players[consoleplayer].mo) { continue; }
            PlayerPawn playerActor = players[consoleplayer].mo;

            // 'normal' here is destination point
            vector2 normal = Toby_MarkerExplorationMenuHelpers.GetNormal(s, l, playerActor, oneUnitToTarget);

            // Deduplication
            bool tooClose = Toby_MarkerExplorationMenuHelpers.IsTooClose(collection, normal, ignoreDistance);
            if (tooClose) { continue; }

            // Check if destination can be reached
            vector3 destination = (normal, s.CenterFloor());
            int attemptCount = 5;
            int destinationSector = level.PointInSector(normal).Index();
            explorationPathfinder.FindPathFromDestinationToExploredSector(destinationSector);
            pathfinder.StartPathfinding(playerActor.pos, destination, explorationPathfinder.explorationNodes);
            for (int j = 0; j < attemptCount; j++)
            {
                if (pathfinder.pathFinalized) { break; }
                pathfinder.FindPath();
            }
            if (!pathfinder.pathFinalized) { continue; }
            double pathLength = pathfinder.GetPathLength();

            // Add to collection
            collection.AddItem(destination, playerActor, pathLength);
        }

        return collection;
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

    ui static Vector2 GetNormal(Sector s, Line l, PlayerPawn playerActor, bool oneUnitToTarget)
    {
        vector2 normal;
        if (oneUnitToTarget)
        {
            normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
            return normal;
        }
        // I can't use line trace in UI scope so I'm going to just try few times to get point in map bounds -PR
        int normalPointPlacingAttemptCount = 4;
        bool isInMapBounds = false;
        Sector normalSector;
        for (uint j = 1; j <= normalPointPlacingAttemptCount; j++)
        {
            double shortenedInteractionRange = double(playerActor.UseRange) / double(j);
            normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l, shortenedInteractionRange);
            normalSector = level.PointInSector(normal);
            if (!normalSector) { continue; }
            isInMapBounds = level.IsPointInLevel((normal, normalSector.CenterFloor()));
            if (isInMapBounds) { break; }
        }
        if (!isInMapBounds)
        {
            normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
        }
        return normal;
    }
}
