class Toby_InSectorNodeBuilder
{
    Array<Toby_PathfindingNodeContainer> sectorNodes;
    Array<Toby_LinePair> linePairArray;

    play static Toby_InSectorNodeBuilder Create()
    {
        Toby_InSectorNodeBuilder nodeBuilder = new("Toby_InSectorNodeBuilder");
        for (int i = 0; i < level.sectors.Size(); i++)
        {
            nodeBuilder.sectorNodes.push(null);
        }
        return nodeBuilder;
    }

    Toby_PathfindingNodeContainer GetNodesForSector(int sectorId)
    {
        if (sectorNodes[sectorId])
        {
            return sectorNodes[sectorId];
        }
        sectorNodes[sectorId] = BuildNodesForSector(sectorId);
        return sectorNodes[sectorId];
    }

    Toby_PathfindingNodeContainer BuildNodesForSector(int sectorId)
    {
        Toby_PathfindingNodeContainer container = Toby_PathfindingNodeContainer.Create();
        Sector s = level.sectors[sectorId];

        FillLinePairArray(s);
        PlaceNodes(s, container);
        LinkAllNodesInSector(container);

        return container;
    }

    void FillLinePairArray(Sector s)
    {
        linePairArray.Clear();
        for (int i = 0; i < s.lines.Size(); i++)
        {
            Line l1 = s.lines[i];
            for (int j = 0; j < s.lines.Size(); j++)
            {
                Line l2 = s.lines[j];
                if (l1 == l2) { continue; }
                Vertex sharedVertex;
                Vertex vertex1;
                Vertex vertex2;
                if (l1.v1 == l2.v1)
                {
                    sharedVertex = l1.v1;
                    vertex1 = l1.v2;
                    vertex2 = l2.v2;
                }
                if (l1.v1 == l2.v2)
                {
                    sharedVertex = l1.v1;
                    vertex1 = l1.v2;
                    vertex2 = l2.v1;
                }
                if (l1.v2 == l2.v1)
                {
                    sharedVertex = l1.v2;
                    vertex1 = l1.v1;
                    vertex2 = l2.v2;
                }
                if (l1.v2 == l2.v2)
                {
                    sharedVertex = l1.v2;
                    vertex1 = l1.v1;
                    vertex2 = l2.v1;
                }
                if (!sharedVertex) { continue; }
                linePairArray.push(Toby_LinePair.Create(sharedVertex, vertex1, vertex2, l1, l2));
            }
        }
    }

    void PlaceNodes(Sector s, Toby_PathfindingNodeContainer container)
    {
        for (int i = 0; i < linePairArray.Size(); i++)
        {
            vector2 ba = linePairArray[i].vertex1.p - linePairArray[i].sharedVertex.p;
            vector2 bc = linePairArray[i].vertex2.p - linePairArray[i].sharedVertex.p;
            vector2 bisector1 = (ba + bc).Unit();
            vector2 bisector2 = -1 * bisector1;
            vector2 bisectorPoint1 = linePairArray[i].sharedVertex.p + bisector1;
            vector2 bisectorPoint2 = linePairArray[i].sharedVertex.p + bisector2;
            vector2 bisectorPointInThisSector;
            bool bisectorPointFound = false;
            if (level.PointInSector(bisectorPoint1) == s)
            {
                bisectorPointFound = true;
                bisectorPointInThisSector = bisectorPoint1;
            }
            if (level.PointInSector(bisectorPoint2) == s)
            {
                bisectorPointFound = true;
                bisectorPointInThisSector = bisectorPoint2;
            }
            if (!bisectorPointFound) { continue; }
            container.AddNode((bisectorPointInThisSector, s.CenterFloor()), -4);
        }
    }

    void LinkAllNodesInSector(Toby_PathfindingNodeContainer container)
    {
        for (int i = 0; i < container.nodes.Size(); i++)
        {
            Toby_PathfindingNode node = container.nodes[i];
            for (int j = 0; j < container.nodes.Size(); j++)
            {
                Toby_PathfindingNode newNode = container.nodes[j];
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
}