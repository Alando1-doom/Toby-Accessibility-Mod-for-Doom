class Toby_PathfindingNodeBuilder: Thinker
{
    Actor playerActor;
    Toby_PathfindingNodeContainer nodeContainer;

    int currentSectorId;
    int previousSectorId;

    vector3 currentPos;
    vector3 previousPos;

    int previousVisibleNodes;
    int currentVisibleNodes;

    Toby_PathfindingNode lastClosestNode;

    static Toby_PathfindingNodeBuilder Create(Toby_PathfindingNodeContainer nodeContainer, Actor playerActor)
    {
        Toby_PathfindingNodeBuilder nodeBuilder = new("Toby_PathfindingNodeBuilder");

        nodeBuilder.nodeContainer = nodeContainer;
        nodeBuilder.playerActor = playerActor;

        nodeBuilder.currentSectorId = playerActor.curSector.Index();
        nodeBuilder.previousSectorId = playerActor.curSector.Index();

        nodeBuilder.currentPos = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);
        nodeBuilder.previousPos = (playerActor.pos.x, playerActor.pos.y, playerActor.pos.z);

        return nodeBuilder;
    }

    override void Tick()
    {
        Super.Tick();
        if (!playerActor) { return; }
        vector3 playerPos = playerActor.pos;
        // Hopefully prevents connecting across the small cracks on the floor
        console.printf("Floor pos at: "..GetFloorHeightAtActorCoords(playerActor));
        console.printf("Player z: "..playerActor.pos.z);
        if (!((playerPos.z == GetFloorHeightAtActorCoords(playerActor))
            || ((playerActor.pos.z - GetFloorHeightAtActorCoords(playerActor)) < playerActor.MaxStepHeight) && playerActor.vel.z == 0)) { return; }
        // Replaced with velocity check, seemingly nothing is broken:
        // if (playerActor.vel.z != 0) { return; }

        previousSectorId = currentSectorId;
        currentSectorId = playerActor.curSector.Index();

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

            int minDistance = 200;
            bool similarExists = IsSimilarNodeExists(currentPos, currentIntersectedLineId, minDistance);
            if (similarExists) { return; }

            if (currentIntersectedLineId != previousIntersectedLineId)
            {
                Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, previousIntersectedLineId);
                Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, currentIntersectedLineId);
                newPreviousPosNode.AddEdge(newCurrentPosNode);
                LinkNodesInSector(newCurrentPosNode, playerActor);
                LinkNodesInSector(newPreviousPosNode, playerActor);
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
                    LinkNodesInSector(newCurrentPosNode, playerActor);
                    LinkNodesInSector(newPreviousPosNode, playerActor);
                    // console.printf("Jumped down");
                }
                if (previousPos.z < currentPos.z)
                {
                    Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, previousIntersectedLineId);
                    Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, currentIntersectedLineId);
                    newPreviousPosNode.AddEdge(newCurrentPosNode);
                    newCurrentPosNode.AddEdge(newPreviousPosNode);
                    LinkNodesInSector(newCurrentPosNode, playerActor);
                    LinkNodesInSector(newPreviousPosNode, playerActor);
                    // console.printf("Jumped up");
                }
            }
            else
            {
                Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, previousIntersectedLineId);
                Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, currentIntersectedLineId);
                newPreviousPosNode.AddEdge(newCurrentPosNode);
                newCurrentPosNode.AddEdge(newPreviousPosNode);
                LinkNodesInSector(newCurrentPosNode, playerActor);
                LinkNodesInSector(newPreviousPosNode, playerActor);
                // console.printf("Regular sector crossing");
            }
        }

        previousVisibleNodes = currentVisibleNodes;
        currentVisibleNodes = GetPossibleConnectionsCount(currentPos);

        if (currentVisibleNodes == 2 && previousVisibleNodes == 1)
        {
            Toby_PathfindingNode newCurrentPosNode = nodeContainer.AddNode(currentPos, -1);
            LinkNodesInSector(newCurrentPosNode, playerActor);
            // console.printf("Existing nodes linked up");
        }
        if (currentVisibleNodes == 0)
        {
            Toby_PathfindingNode newPreviousPosNode = nodeContainer.AddNode(previousPos, -1);
            LinkNodesInSector(newPreviousPosNode, playerActor);
            if (lastClosestNode)
            {
                lastClosestNode.AddEdge(newPreviousPosNode);
                console.printf("There is a chance that gap was crossed. Last closest node was: "..lastClosestNode.id);
            }
            console.printf("No nodes around!");
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
        double minDistance = Int.Max;
        Toby_PathfindingNode minDistanceNode = null;
        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
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

    void LinkNodesInSector(Toby_PathfindingNode newNode, Actor playerActor)
    {
        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            if (node == newNode) { continue; }
            bool inSameSector = Toby_SectorMathUtil.IsInSameSector(newNode.pos, node.pos);
            if (!inSameSector) { continue; }
            bool intersectsAnyLine = Toby_SectorMathUtil.IntersectsSectorBoundary(newNode.pos.xy, node.pos.xy);
            if (intersectsAnyLine) { continue; }
            if (node.pos.z != newNode.pos.z) { continue; }
            newNode.AddEdge(node);
            node.AddEdge(newNode);
        }
    }

    bool IsSimilarNodeExists(Vector3 pos, int lineId, int distance)
    {
        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            bool inSameSector = Toby_SectorMathUtil.IsInSameSector(pos, node.pos);
            if (!inSameSector) { continue; }
            if (node.lineId == lineId && (pos.xy - node.pos.xy).Length() < distance)
            {
                return true;
            }
        }
        return false;
    }
}
