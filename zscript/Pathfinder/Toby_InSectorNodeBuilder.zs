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

    Toby_PathfindingNodeContainer GetNodesForSector(int sectorId, Actor explorer)
    {
        // Sorry, I think we need to skip on caching
        // Or at least there should be a mechanism that would mark sectors as dirty
        // So that they could be recalculated instead of recalculating every time -PR

        // Actually, I can make it a little bit better -PR
        if (sectorNodes[sectorId])
        {
            Sector s = level.sectors[sectorId];
            if (sectorNodes[sectorId].nodes.Size() < 0) { return sectorNodes[sectorId]; }
            if (sectorNodes[sectorId].nodes[0].pos.z == s.CenterFloor()) { return sectorNodes[sectorId]; }
            for (int i = 0; i < sectorNodes[sectorId].nodes.Size(); i++)
            {
                sectorNodes[sectorId].nodes[i].pos.z = s.CenterFloor();
            }
            return sectorNodes[sectorId];
        }
        sectorNodes[sectorId] = BuildNodesForSector(sectorId, explorer);
        return sectorNodes[sectorId];
    }

    Toby_PathfindingNodeContainer BuildNodesForSector(int sectorId, Actor explorer)
    {
        Toby_PathfindingNodeContainer container = Toby_PathfindingNodeContainer.Create();
        Sector s = level.sectors[sectorId];

        FillLinePairArray(s);
        PlaceNodes(s, container);
        container.LinkAllNodesInSectorsDistanceAware(explorer);

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
        double extendedDistance = sqrt(2) * players[consoleplayer].mo.radius + 1;

        for (int i = 0; i < linePairArray.Size(); i++)
        {
            vector2 ba = linePairArray[i].vertex1.p - linePairArray[i].sharedVertex.p;
            vector2 bc = linePairArray[i].vertex2.p - linePairArray[i].sharedVertex.p;

            vector2 unitBA = ba.Unit();
            vector2 unitBC = bc.Unit();

            vector2 bisector1 = (unitBA + unitBC).Unit();
            vector2 bisector2 = -1 * bisector1;

            //Edge case where angle between BA and BC is 180 degrees
            if (unitBA dot unitBC == -1)
            {
                bisector1 = (-unitBA.y, unitBA.x);
                bisector2 = -bisector1;
            }

            vector2 bisectorPoint1 = linePairArray[i].sharedVertex.p + bisector1;
            vector2 bisectorPoint2 = linePairArray[i].sharedVertex.p + bisector2;

            vector2 extendedBisectorPoint1 = linePairArray[i].sharedVertex.p + bisector1 * extendedDistance;
            vector2 extendedBisectorPoint2 = linePairArray[i].sharedVertex.p + bisector2 * extendedDistance;

            vector2 bisectorPointInThisSector;
            bool bisectorPointFound = false;
            bool sectorOverride = false;
            if (level.PointInSector(bisectorPoint1) == s && level.IsPointInLevel((bisectorPoint1, s.CenterFloor())))
            {
                bisectorPointFound = true;
                bisectorPointInThisSector = extendedBisectorPoint1;
            }
            if (level.PointInSector(bisectorPoint2) == s && level.IsPointInLevel((bisectorPoint2, s.CenterFloor())))
            {
                bisectorPointFound = true;
                bisectorPointInThisSector = extendedBisectorPoint2;
            }
            if (!bisectorPointFound)
            {
                if (level.IsPointInLevel((bisectorPoint1, s.CenterFloor())))
                {
                    bisectorPointFound = true;
                    sectorOverride = true;
                    bisectorPointInThisSector = extendedBisectorPoint1;
                }
                if (level.IsPointInLevel((bisectorPoint2, s.CenterFloor())))
                {
                    bisectorPointFound = true;
                    sectorOverride = true;
                    bisectorPointInThisSector = extendedBisectorPoint2;
                }
                continue;
            }
            Toby_PathfindingNode newNode = container.AddNode((bisectorPointInThisSector, s.CenterFloor()), -4);
            if (sectorOverride)
            {
                newNode.sectorIndexOverride = s.Index();
            }
        }
    }
}
