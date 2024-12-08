class Toby_Pathfinder
{
    Toby_PathfindingNodeContainer nodeContainer;

    Array<Toby_PathfindingNode> openList;
    Array<Toby_PathfindingNode> closedList;

    Array<Toby_PathfindingNode> path;
    bool pathfindingActive;
    bool pathFound;
    bool pathDoesNotExist;
    bool pathConstructed;
    bool pathFinalized;

    Toby_PathfindingNode pathStart;
    Toby_PathfindingNode pathEnd;
    Toby_PathfindingNode startNode;
    Toby_PathfindingNode endNode;
    Toby_PathfindingNode projectionNodeStart;
    Toby_PathfindingNode projectionNodeEnd;

    static Toby_Pathfinder Create(Toby_PathfindingNodeContainer nodeContainer)
    {
        Toby_Pathfinder pathfinder = new("Toby_Pathfinder");

        pathfinder.nodeContainer = nodeContainer;
        pathfinder.openList.Clear();
        pathfinder.closedList.Clear();
        pathfinder.path.Clear();
        pathfinder.pathfindingActive = false;
        pathfinder.pathFound = false;
        pathfinder.pathDoesNotExist = false;
        pathfinder.pathConstructed = false;
        pathfinder.pathFinalized = false;

        pathfinder.pathStart = null;
        pathfinder.pathEnd = null;
        pathfinder.projectionNodeStart = null;
        pathfinder.projectionNodeEnd = null;
        pathfinder.startNode = null;
        pathfinder.endNode = null;

        return pathfinder;
    }

    void TotalReset()
    {
        ResetPathfinder((0, 0, 0), (0, 0, 0));
        pathStart = null;
        pathEnd = null;
        pathfindingActive = false;
    }

    void FindPath()
    {
        if (!pathfindingActive) { return; }
        if (pathDoesNotExist || pathFinalized)
        {
            return;
        }
        int maxCycles = 100;
        for (int i = 0; i < maxCycles; i++)
        {
            if (!pathFound)
            {
                ProcessOpenList();
            }
            if (pathFound && !pathConstructed)
            {
                ConstructPath();
            }
            if (pathConstructed && !pathFinalized)
            {
                FinalizePath();
            }
        }
    }

    void ResetPathfinder(Vector3 start, Vector3 end)
    {
        pathfindingActive = true;
        pathFound = false;
        pathDoesNotExist = false;
        pathConstructed = false;
        pathFinalized = false;
        openList.Clear();
        closedList.Clear();
        path.Clear();

        pathStart = Toby_PathfindingNode.Create(start, -2, -1);
        pathEnd = Toby_PathfindingNode.Create(end, -2, -1);

        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            node.SetScore(Int.Max, 0);
        }
    }

    void StartPathfinding(Vector3 start, Vector3 end, Toby_PathfindingNodeContainer nodeContainer)
    {
        if (pathfindingActive) { return; }
        self.nodeContainer = nodeContainer;

        ResetPathfinder(start, end);
        if (!Toby_SectorMathUtil.IntersectsSectorBoundary(start.xy, end.xy))
        {
            path.push(pathStart);
            path.push(pathEnd);
            pathFound = true;
            pathConstructed = true;
            pathFinalized = true;
            pathfindingActive = false;
            return;
        }

        startNode = GetNearestNode(start);
        if (!startNode)
        {
            pathfindingActive = false;
            return;
        }
        endNode = GetNearestNode(end);
        if (!endNode)
        {
            pathfindingActive = false;
            return;
        }
        startNode.SetScore(0, CalculateScore(startNode, endNode));

        openList.Push(startNode);
    }

    void ProcessOpenList()
    {
        if (pathFound)
        {
            // console.printf("Path already found");
            return;
        }
        if (openList.Size() == 0 && !pathFound)
        {
            pathDoesNotExist = true;
            pathfindingActive = false;
            // console.printf("Path can not be found");
            return;
        }
        if (openList.Size() == 0) { return; }

        Toby_PathfindingNode currentNode = GetMinFScoreNodeFromOpenList();
        int currentNodeIndex = openList.Find(currentNode);

        if (currentNodeIndex == openList.Size()) { return; }
        closedList.Push(currentNode);
        openList.Delete(currentNodeIndex, 1);

        for (int i = 0; i < currentNode.edges.Size(); i++)
        {
            Toby_PathfindingNode processedNode = currentNode.edges[i];
            bool isInClosedList = !(closedList.Find(processedNode) == closedList.Size());
            bool isInOpenList = !(openList.Find(processedNode) == openList.Size());
            // if (isInOpenList || isInClosedList) { continue; }
            if (isInClosedList) { continue; }
            if(!isInOpenList)
            {
                openList.Push(processedNode);
            }
            //I've added this coefficient to break the symmetry when H + G always resulted in same F in some situations -PR
            double heuristicCoefficient = 1.0;
            double hScore = CalculateScore(processedNode, endNode) * heuristicCoefficient;
            double gScore = CalculateScore(processedNode, currentNode) + currentNode.gScore;
            if (processedNode.GetFScore() < gScore + hScore) { continue; }
            processedNode.SetScore(gScore, hScore);
        }

        if (currentNode == endNode)
        {
            currentNode.SetScore(currentNode.gScore, 10);
            pathFound = true;
            // console.printf("Path found");
        }
    }

    void ConstructPath()
    {
        if (pathConstructed)
        {
            // console.printf("Path already constructed");
            return;
        }
        if (!pathFound)
        {
            // console.printf("Path not found yet");
            return;
        }
        if (openList.Size() == 0 && !pathFound)
        {
            // console.printf("Path can not be found");
            return;
        }

        if (path.Size() == 0)
        {
            path.Insert(0, endNode);

            if (startNode == endNode)
            {
                pathConstructed = true;
                // console.printf("Path constructed");
            }
            return;
        }

        Toby_PathfindingNode currentNode = path[0];
        Toby_PathfindingNode minScoreNode = null;
        double minFScore = Int.Max;

        // This is a bit stupid but it prevents crashes so I'm leaving it in
        // Crashes occur when player's center is handing over the edge of a sector that
        // is not visited yet and pathfinding attempt is made.
        // I don't know how to fix this otherwise -PR
        if (!currentNode)
        {
            pathDoesNotExist = true;
            pathFound = false;
            pathfindingActive = false;
            pathConstructed = false;
            console.printf("Path construction failed on currentNode");
            return;
        }
        for(int i = 0; i < currentNode.backwardsEdges.Size(); i++)
        {
            Toby_PathfindingNode processedNode = currentNode.backwardsEdges[i];
            bool isInPath = !(path.Find(processedNode) == path.Size());
            if (isInPath) { continue; }
            // Symmetry?
            // console.printf("Current node: "..currentNode.id.."; ".."Processed Node "..processedNode.id..": "..processedNode.hScore.." + "..processedNode.gScore.." = "..processedNode.GetFScore());
            if (processedNode.GetFScore() <= minFScore)
            {
                minFScore = processedNode.GetFScore();
                minScoreNode = processedNode;
            }
        }
        if (!minScoreNode)
        {
            pathDoesNotExist = true;
            pathFound = false;
            pathfindingActive = false;
            pathConstructed = false;
            // console.printf("Path construction failed on minScoreNode");
            return;
        }
        path.Insert(0, minScoreNode);
        if (minScoreNode == startNode)
        {
            pathConstructed = true;
            // console.printf("Path constructed");
        }
    }

    void FinalizePath()
    {
        if (!pathConstructed)
        {
            // console.printf("Path is not constructed yet");
            return;
        }
        if (pathFinalized)
        {
            // console.printf("Path already finalized");
            return;
        }

        if (path.Size() <= 2)
        {
            pathFinalized = true;
            pathfindingActive = false;
            return;
        }

        Vector2 projectionStart = GetProjectionPointOnEdge(path[0].pos.xy, path[1].pos.xy, pathStart.pos.xy);
        projectionNodeStart = Toby_PathfindingNode.Create((projectionStart, pathStart.pos.z), -2, -2);
        path.Delete(0, 1);
        path.Insert(0, projectionNodeStart);
        path.Insert(0, pathStart);

        Vector2 projectionEnd = GetProjectionPointOnEdge(path[path.Size() - 1].pos.xy, path[path.Size() - 2].pos.xy, pathEnd.pos.xy);
        projectionNodeEnd = Toby_PathfindingNode.Create((projectionEnd, pathEnd.pos.z), -2, -2);
        path.Delete(path.Size() - 1, 1);
        path.push(projectionNodeEnd);
        path.push(pathEnd);

        pathFinalized = true;
        pathfindingActive = false;
        // console.printf("Path finalized");
    }

    Toby_PathfindingNode GetNearestNode(Vector3 pos)
    {
        Toby_PathfindingNode shortestDistanceNode = null;
        double shortestDistanceToNode = Int.Max;
        for (int i = 0; i < nodeContainer.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodeContainer.nodes[i];
            bool inSameSector = Toby_SectorMathUtil.IsInSameSector(pos, node.pos);
            if (!inSameSector) { continue; }
            bool intersectsAnyLine = Toby_SectorMathUtil.IntersectsSectorBoundary(pos.xy, node.pos.xy);
            if (intersectsAnyLine) { continue; }
            double distance = (pos.xy - node.pos.xy).length();
            if (distance < shortestDistanceToNode)
            {
                shortestDistanceToNode = distance;
                shortestDistanceNode = node;
            }
        }
        return shortestDistanceNode;
    }

    double CalculateScore(Toby_PathfindingNode currentNode, Toby_PathfindingNode otherNode)
    {
        return (currentNode.pos - otherNode.pos).length();
    }

    Toby_PathfindingNode GetMinFScoreNodeFromOpenList()
    {
        double minFScore = Int.Max;
        Toby_PathfindingNode minFScoreNode;
        for (int i = 0; i < openList.Size(); i++)
        {
            if (openList[i].GetFScore() <= minFScore)
            {
                minFScore = openList[i].GetFScore();
                minFScoreNode = openList[i];
            }
        }
        return minFScoreNode;
    }

    Vector2 GetProjectionPointOnEdge(Vector2 edgeStartA, Vector2 edgeEndB, Vector2 pointC)
    {
        Vector2 ab = edgeEndB - edgeStartA;
        Vector2 ac = pointC - edgeStartA;
        if (ab dot ab == 0)
        {
            return edgeStartA;
        }
        double projectionScalar = (ab dot ac) / (ab dot ab);

        projectionScalar = Max(0, Min(1, projectionScalar));

        Vector2 projection = edgeStartA + ab * projectionScalar;

        return projection;
    }

    double GetDistanceToEdge(Vector2 edgeStartA, Vector2 edgeEndB, Vector2 pointC)
    {
        Vector2 projectionPoint = GetProjectionPointOnEdge(edgeStartA, edgeEndB, pointC);
        double distance = (pointC - projectionPoint).Length();
        return distance;
    }
}
