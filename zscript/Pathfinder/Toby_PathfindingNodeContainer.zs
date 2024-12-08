class Toby_PathfindingNodeContainer
{
    int lastId;
    Array<Toby_PathfindingNode> nodes;

    static Toby_PathfindingNodeContainer Create()
    {
        Toby_PathfindingNodeContainer container = new("Toby_PathfindingNodeContainer");
        container.lastId = 0;
        return container;
    }

    Toby_PathfindingNode AddNode(Vector3 pos, int lineId)
    {
        for (int i = 0; i < nodes.Size(); i++)
        {
            if ((nodes[i].pos - pos).Length() == 0)
            {
                return nodes[i];
            }
        }
        Toby_PathfindingNode newNode = Toby_PathfindingNode.Create(pos, lineId, lastId);
        lastId++;
        nodes.push(newNode);
        return newNode;
    }

    Toby_PathfindingNode FindNodeById(int id)
    {
        for (int i = 0; i < nodes.Size(); i++)
        {
            if (nodes[i].id == id)
            {
                return nodes[i];
            }
        }
        return null;
    }

    Toby_PathfindingNode AddExistingNode(Toby_PathfindingNode node)
    {
        nodes.push(node);
        return node;
    }

    //Am I creating memory leaks? I hope not! -PR
    void MergeOtherContainer(Toby_PathfindingNodeContainer other)
    {
        if (!other) { return; }
        //Need to clone original container first to avoid mutating it
        Toby_PathfindingNodeContainer clone = other.CloneContainer();
        for (int i = 0; i < clone.nodes.Size(); i++)
        {
            if (!clone.nodes[i]) { continue; }
            AddExistingNode(clone.nodes[i]);
        }
    }

    Toby_PathfindingNodeContainer CloneContainer()
    {
        Toby_PathfindingNodeContainer clone = Toby_PathfindingNodeContainer.Create();
        for (int i = 0; i < nodes.Size(); i++)
        {
            clone.AddNode(nodes[i].pos, nodes[i].lineId);
        }

        for (int i = 0; i < nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodes[i];
            Toby_PathfindingNode cloneNode = clone.nodes[i];
            for (int j = 0; j < node.edges.Size(); j++)
            {
                Toby_PathfindingNode edge = node.edges[j];
                Toby_PathfindingNode cloneEdge = clone.FindNodeById(edge.id);
                cloneNode.AddEdge(cloneEdge);
            }
        }

        return clone;
    }

    void LinkAllNodesInSectors()
    {
        for (int i = 0; i < nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodes[i];
            for (int j = 0; j < nodes.Size(); j++)
            {
                Toby_PathfindingNode newNode = nodes[j];
                if (node == newNode) { continue; }
                bool inSameSector = Toby_SectorMathUtil.IsInSameSector(newNode.pos, node.pos);
                if (!inSameSector) { continue; }
                bool intersectsAnyLine = Toby_SectorMathUtil.IntersectsSectorBoundary(newNode.pos.xy, node.pos.xy);
                if (intersectsAnyLine) { continue; }
                newNode.AddEdge(node);
                node.AddEdge(newNode);
            }
        }
    }

    void RemoveUnlinkedNodes()
    {
        for (int i = nodes.Size() - 1; i >= 0; i--)
        {
            if ((nodes[i].edges.Size() == 0) && (nodes[i].backwardsEdges.Size() == 0))
            {
                nodes.Delete(i, 1);
            }
        }
    }

    void LinkAllNodesInSectorsDistanceAware(Actor explorer)
    {
        for (int i = 0; i < nodes.Size(); i++)
        {
            Toby_PathfindingNode node = nodes[i];
            for (int j = 0; j < nodes.Size(); j++)
            {
                Toby_PathfindingNode newNode = nodes[j];
                if (node == newNode) { continue; }
                bool inSameSector = IsInSameSectorIncludingOverrides(node, newNode);
                if (!inSameSector) { continue; }
                bool intersectsAnyLine = IntersectsSectorBoundaryIncludingOverrides(newNode, node);
                if (intersectsAnyLine) { continue; }
                bool isTooCloseToExplorer = IsTooCloseToSectorLines(newNode, node, explorer);
                if (isTooCloseToExplorer) { continue; }
                newNode.AddEdge(node);
                node.AddEdge(newNode);
            }
        }
    }

    bool IsTooCloseToSectorLines(Toby_PathfindingNode node1, Toby_PathfindingNode node2, Actor explorer)
    {
        int arbitraryNumberThatWored = 5;
        bool distanceCheck = (node1.pos - node2.pos).Length() < explorer.radius * arbitraryNumberThatWored;
        if (node1.lineId >= 0 && distanceCheck) { return false; }
        if (node2.lineId >= 0 && distanceCheck) { return false; }

        Sector s = Level.PointInSector(node1.pos.xy);
        if (node1.sectorIndexOverride != -1)
        {
            s = level.sectors[node1.sectorIndexOverride];
        }
        for (int i = 0; i < s.lines.Size(); i++)
        {
            Line l = s.lines[i];
            double distance = Toby_LineSegmentIntersectionUtil.GetMinimalDistance(l.v1.p, l.v2.p, node1.pos.xy, node2.pos.xy);
            if (distance > explorer.radius)
            {
                continue;
            }
            bool isReachable = Toby_SectorMathUtil.IsSectorReachableByActor(s, l, explorer, false);
            if (isReachable)
            {
                continue;
            }
            return true;
        }
        return false;
    }

    bool IsInSameSectorIncludingOverrides(Toby_PathfindingNode node1, Toby_PathfindingNode node2)
    {
        if (node1.sectorIndexOverride == -1 && node2.sectorIndexOverride == -1)
        {
            return Toby_SectorMathUtil.IsInSameSector(node1.pos, node2.pos);
        }
        if (node1.sectorIndexOverride == -1 && node2.sectorIndexOverride != -1)
        {
            return Level.PointInSector(node2.pos.xy).Index() == node1.sectorIndexOverride;
        }
        if (node1.sectorIndexOverride != -1 && node2.sectorIndexOverride == -1)
        {
            return Level.PointInSector(node1.pos.xy).Index() == node2.sectorIndexOverride;
        }
        return false;
    }

    bool IntersectsSectorBoundaryIncludingOverrides(Toby_PathfindingNode node1, Toby_PathfindingNode node2)
    {
        if (node1.sectorIndexOverride == -1 && node2.sectorIndexOverride == -1)
        {
            return Toby_SectorMathUtil.IntersectsSectorBoundary(node1.pos.xy, node2.pos.xy);
        }
        if (node1.sectorIndexOverride == -1 && node2.sectorIndexOverride != -1)
        {
            return false;
        }
        if (node1.sectorIndexOverride != -1 && node2.sectorIndexOverride == -1)
        {
            return false;
        }
        return true;
    }
}
