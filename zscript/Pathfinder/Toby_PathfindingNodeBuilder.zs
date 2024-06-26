class Toby_PathfindingNodeBuilder: Thinker
{
    Actor playerActor;
    Toby_PathfindingNodeContainer nodeContainer;

    int currentSectorId;
    int previousSectorId;

    int currentFloorLevel;
    int previousFloorLevel;

    bool elevatorRideStarted;
    bool currentElevatorRideStarted;
    bool previousElevatorRideStarted;
    vector3 elevatorRideStartPos;
    vector3 elevatorRideEndPos;

    vector3 currentPos;
    vector3 previousPos;

    vector3 currentPosIncludingAirtime;
    vector3 previousPosIncludingAirtime;

    double averageMovement;

    int previousVisibleNodes;
    int currentVisibleNodes;

    Toby_PathfindingNode lastClosestNode;

    static Toby_PathfindingNodeBuilder Create(Toby_PathfindingNodeContainer nodeContainer, Actor playerActor)
    {
        Toby_PathfindingNodeBuilder nodeBuilder = new("Toby_PathfindingNodeBuilder");

        nodeBuilder.nodeContainer = nodeContainer;
        nodeBuilder.playerActor = playerActor;

        if (!playerActor) { return nodeBuilder; }

        nodeBuilder.currentSectorId = playerActor.curSector.Index();
        nodeBuilder.previousSectorId = playerActor.curSector.Index();

        nodeBuilder.elevatorRideStarted = false;
        nodeBuilder.currentElevatorRideStarted = false;
        nodeBuilder.previousElevatorRideStarted = false;
        nodeBuilder.elevatorRideStartPos = playerActor.pos;
        nodeBuilder.elevatorRideEndPos = playerActor.pos;

        nodeBuilder.currentFloorLevel = playerActor.curSector.floorplane.ZatPoint((playerActor.pos.x, playerActor.pos.y));
        nodeBuilder.previousFloorLevel = playerActor.curSector.floorplane.ZatPoint((playerActor.pos.x, playerActor.pos.y));

        nodeBuilder.currentPos = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);
        nodeBuilder.previousPos = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);

        nodeBuilder.currentPosIncludingAirtime = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);
        nodeBuilder.previousPosIncludingAirtime = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);

        nodeBuilder.averageMovement = playerActor.radius * 2;

        return nodeBuilder;
    }

    override void Tick()
    {
        Super.Tick();
        if (!playerActor) { return; }
        int minDistance = 100;

        bool teleportOccured = false;
        double movement = (currentPosIncludingAirtime.xy - previousPosIncludingAirtime.xy).Length();
        int doubleRadius = playerActor.radius * 2;
        if (movement > averageMovement)
        {
            teleportOccured = true;
        }
        else
        {
            averageMovement = (movement + averageMovement) / 2;
        }
        if (averageMovement < doubleRadius)
        {
            averageMovement = doubleRadius;
        }

        if (teleportOccured)
        {
            Toby_PathfindingNode startNode = null;
            Toby_PathfindingNode endNode = null;
            if (!IsSimilarNodeExists(previousPosIncludingAirtime, -3, minDistance))
            {
                // console.printf("Start node does not exist");
                startNode = nodeContainer.AddNode(previousPosIncludingAirtime, -3);
                LinkNodesInSector(startNode, playerActor, lastClosestNode, minDistance);
            }
            if (!IsSimilarNodeExists(currentPosIncludingAirtime, -3, minDistance))
            {
                // console.printf("End node does not exist");
                endNode = nodeContainer.AddNode(currentPosIncludingAirtime, -3);
                LinkNodesInSector(endNode, playerActor, lastClosestNode, minDistance);
            }
            if (startNode)
            {
                if (endNode)
                {
                    // console.printf("Teleport connected");
                    startNode.AddEdge(endNode);
                    endNode.AddEdge(startNode);
                }
            }
        }

        previousPosIncludingAirtime = currentPosIncludingAirtime;
        currentPosIncludingAirtime = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);

        vector3 playerPos = playerActor.pos;

        bool playerIsOnFloorLevel = playerPos.z == GetFloorHeightAtActorCoords(playerActor);
        bool playerIsWithinMaxStepHeight = Abs((playerActor.pos.z - GetFloorHeightAtActorCoords(playerActor)) <= playerActor.MaxStepHeight);

        if (!(playerIsOnFloorLevel
            || playerIsWithinMaxStepHeight && playerActor.vel.z == 0)) { return; }

        previousSectorId = currentSectorId;
        currentSectorId = playerActor.curSector.Index();

        previousFloorLevel = currentFloorLevel;
        currentFloorLevel = GetFloorHeightAtActorCoords(playerActor);

        previousElevatorRideStarted = currentElevatorRideStarted;
        currentElevatorRideStarted = elevatorRideStarted;

        if (previousFloorLevel != currentFloorLevel)
        {
            if (!elevatorRideStarted)
            {
                elevatorRideStarted = true;
                elevatorRideStartPos = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);
            }
        }
        else
        {
            if (elevatorRideStarted)
            {
                elevatorRideStarted = false;
                elevatorRideEndPos = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);
            }
        }

        previousPos = (currentPos.x, currentPos.y, currentPos.z);
        currentPos = (playerPos.x, playerPos.y, playerPos.z);

        if (currentSectorId != previousSectorId)
        {
            int currentIntersectedLineId = GetIntersectedLineId(
                currentSectorId,
                currentPos,
                previousPos
            );
            int previousIntersectedLineId = GetIntersectedLineId(
                previousSectorId,
                currentPos,
                previousPos
            );

            bool similarExists = IsSimilarNodeExists(currentPos, currentIntersectedLineId, minDistance);
            if (similarExists) { return; }

            if (currentIntersectedLineId != previousIntersectedLineId)
            {
                Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, previousIntersectedLineId);
                Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, currentIntersectedLineId);
                newPreviousPosNode.AddEdge(newCurrentPosNode);
                LinkNodesInSector(newCurrentPosNode, playerActor, lastClosestNode, minDistance);
                LinkNodesInSector(newPreviousPosNode, playerActor, lastClosestNode, minDistance);
                // console.printf("Jumped over multiple lines, possible teleportation");
            }
            bool stepHeightExceeded = IsStepHeightExceeded(currentPos, previousPos, playerActor);
            if (stepHeightExceeded)
            {
                if (previousPos.z > currentPos.z)
                {
                    Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, previousIntersectedLineId);
                    Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, currentIntersectedLineId);
                    newPreviousPosNode.AddEdge(newCurrentPosNode);
                    LinkNodesInSector(newCurrentPosNode, playerActor, lastClosestNode, minDistance);
                    LinkNodesInSector(newPreviousPosNode, playerActor, lastClosestNode, minDistance);
                    // console.printf("Jumped down");
                }
                if (previousPos.z < currentPos.z)
                {
                    Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, previousIntersectedLineId);
                    Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, currentIntersectedLineId);
                    newPreviousPosNode.AddEdge(newCurrentPosNode);
                    newCurrentPosNode.AddEdge(newPreviousPosNode);
                    LinkNodesInSector(newCurrentPosNode, playerActor, lastClosestNode, minDistance);
                    LinkNodesInSector(newPreviousPosNode, playerActor, lastClosestNode, minDistance);
                    // console.printf("Jumped up");
                }
            }
            else
            {
                Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, previousIntersectedLineId);
                Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, currentIntersectedLineId);
                newPreviousPosNode.AddEdge(newCurrentPosNode);
                newCurrentPosNode.AddEdge(newPreviousPosNode);
                LinkNodesInSector(newCurrentPosNode, playerActor, lastClosestNode, minDistance);
                LinkNodesInSector(newPreviousPosNode, playerActor, lastClosestNode, minDistance);
                // console.printf("Regular sector crossing");
            }
        }

        if (currentSectorId == previousSectorId && playerActor.vel.z == 0 && previousElevatorRideStarted != currentElevatorRideStarted && !elevatorRideStarted)
        {
            // console.printf("Elevator ride ended");
            Toby_PathfindingNode startNode = null;
            Toby_PathfindingNode endNode = null;
            if (!IsSimilarElevatorNodeExists(elevatorRideStartPos, playerActor))
            {
                // console.printf("Start node does not exist");
                startNode = nodeContainer.AddNode(elevatorRideStartPos, -2);
                LinkNodesInSector(startNode, playerActor, lastClosestNode, minDistance);
            }
            if (!IsSimilarElevatorNodeExists(elevatorRideEndPos, playerActor))
            {
                // console.printf("End node does not exist");
                endNode = nodeContainer.AddNode(elevatorRideEndPos, -2);
                LinkNodesInSector(endNode, playerActor, lastClosestNode, minDistance);
            }
            if (startNode)
            {
                if (endNode)
                {
                    // console.printf("Elevator ride connected");
                    startNode.AddEdge(endNode);
                    endNode.AddEdge(startNode);
                }
            }
        }

        previousVisibleNodes = currentVisibleNodes;
        currentVisibleNodes = GetPossibleConnectionsCount(currentPos);

        if (currentVisibleNodes == 2 && previousVisibleNodes == 1)
        {
            Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, -1);
            LinkNodesInSector(newCurrentPosNode, playerActor, lastClosestNode, minDistance);
            // console.printf("Existing nodes linked up");
        }
        if (currentVisibleNodes == 0)
        {
            Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, -1);
            LinkNodesInSector(newPreviousPosNode, playerActor, lastClosestNode, minDistance);
            // console.printf("No nodes around!");
        }
        Toby_PathfindingNode updatedLastClosestNode = GetNearestAccessibleNode(playerActor);
        if (updatedLastClosestNode != null)
        {
            lastClosestNode = updatedLastClosestNode;
        }

    }

    bool IsStepHeightExceeded(Vector3 currentPos, Vector3 previousPos, Actor a)
    {
        double heightDistance = Abs(GetFloorHeightAtCoords(currentPos) - GetFloorHeightAtCoords(previousPos));
        return heightDistance >= a.MaxStepHeight;
    }

    int GetPossibleConnectionsCount(Vector3 pos)
    {
        int count = 0;
        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            bool inSameSector = Toby_SectorMathUtil.IsInSameSector(pos, node.pos);
            if (!inSameSector) { continue; }
            bool intersectsAnyLine = Toby_SectorMathUtil.IntersectsSectorBoundary(pos.xy, node.pos.xy);
            if (intersectsAnyLine) { continue; }
            count++;
        }
        return count;
    }

    double GetFloorHeightAtActorCoords(Actor a)
    {
        return a.curSector.floorplane.ZatPoint((a.pos.x, a.pos.y));
    }

    double GetFloorHeightAtCoords(Vector3 pos)
    {
        Sector s = Level.PointInSector(pos.xy);
        return s.floorplane.ZatPoint(pos.xy);
    }

    int GetIntersectedLineId(int sectorIndex, Vector3 currentPosition, Vector3 previousPosition)
    {
        for (int i = 0; i < level.sectors[sectorIndex].lines.Size(); i++)
        {
            Line l = level.sectors[sectorIndex].lines[i];
            bool linesIntersect = Toby_LineSegmentIntersectionUtil.DoIntersect(
                l.v1.p,
                l.v2.p,
                currentPosition.xy,
                previousPosition.xy);
            if (linesIntersect)
            {
                return l.Index();
            }
        }
        return -1;
    }

    Toby_PathfindingNode GetNearestAccessibleNode(Actor playerActor)
    {
        if (!playerActor) { return null; }

        double minDistance = Int.Max;
        Toby_PathfindingNode minDistanceNode = null;
        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            if (!node) { continue; }
            if ((node.pos.xy - playerActor.pos.xy).Length() <= playerActor.radius * 2)
            {
                minDistanceNode = node;
                break;
            }
            bool inSameSector = Toby_SectorMathUtil.IsInSameSector(playerActor.pos, node.pos);
            if (!inSameSector) { continue; }
            bool intersectsAnyLine = Toby_SectorMathUtil.IntersectsSectorBoundary(playerActor.pos.xy, node.pos.xy);
            if (intersectsAnyLine) { continue; }
            if (node.pos.z != playerActor.pos.z) { continue; }
            double distance = (node.pos.xy - playerActor.pos.xy).Length();
            if (distance < minDistance)
            {
                minDistance = distance;
                minDistanceNode = node;
            }
        }
        return minDistanceNode;
    }

    void LinkNodesInSector(Toby_PathfindingNode newNode, Actor playerActor, Toby_PathfindingNode lastClosestNode, int distance)
    {
        if (!playerActor) { return; }

        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            if (node == newNode) { continue; }
            bool inSameSector = Toby_SectorMathUtil.IsInSameSector(newNode.pos, node.pos);
            if (!inSameSector) { continue; }
            bool intersectsAnyLine = Toby_SectorMathUtil.IntersectsSectorBoundary(newNode.pos.xy, node.pos.xy);
            if (intersectsAnyLine) { continue; }
            bool sameHeight = node.pos.z == newNode.pos.z;
            bool withinMaxStepHeight = Abs(node.pos.z - newNode.pos.z) <= playerActor.MaxStepHeight;
            if (!(sameHeight || withinMaxStepHeight)) { continue; }
            newNode.AddEdge(node);
            node.AddEdge(newNode);
        }

        // This dumb part somehow breaks everything sometimes, I don't know how to fix it -PR
        if (lastClosestNode)
        {
            lastClosestNode.AddEdge(newNode);

            bool withinMaxStepHeight = Abs(lastClosestNode.pos.z - newNode.pos.z) <= playerActor.MaxStepHeight;
            bool nodeIsCloseEnough = (lastClosestNode.pos.xy - newNode.pos.xy).Length() < distance;
            if (withinMaxStepHeight && nodeIsCloseEnough)
            {
                newNode.AddEdge(lastClosestNode);
            }
        }
    }

    bool IsSimilarNodeExists(Vector3 pos, int lineId, int distance)
    {
        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            bool inSameSector = Toby_SectorMathUtil.IsInSameSector(pos, node.pos);
            if (!inSameSector) { continue; }
            if (node.lineId == lineId && (pos.xy - node.pos.xy).Length() < distance && pos.z == node.pos.z)
            {
                return true;
            }
        }
        return false;
    }

    bool IsSimilarElevatorNodeExists(Vector3 pos, Actor playerActor)
    {
        if (!playerActor)
        {
            return false;
        }
        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            if (node.lineId != -2) { continue; }
            bool inSameSector = Toby_SectorMathUtil.IsInSameSector(pos, node.pos);
            if (!inSameSector) { continue; }
            if (Abs(pos.z - node.pos.z) < playerActor.MaxStepHeight)
            {
                return true;
            }
        }
        return false;
    }

    void SetPlayerActor(Actor a)
    {
        playerActor = a;
    }
}
