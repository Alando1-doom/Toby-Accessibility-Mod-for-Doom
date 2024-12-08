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

    //Am I creating memory leaks? I hope not! -P
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
}
