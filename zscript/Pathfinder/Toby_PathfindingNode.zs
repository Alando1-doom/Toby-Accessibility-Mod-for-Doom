class Toby_PathfindingNode
{
    int id;

    double gScore;
    double hScore;
    double fScore;

    int sectorIndexOverride;

    //LineId is required to determine that similar node exists on the same line between sectors
    int lineId;

    Vector3 pos;
    Array<Toby_PathfindingNode> edges;
    Array<Toby_PathfindingNode> backwardsEdges;

    static Toby_PathfindingNode Create(Vector3 pos, int lineId, int id)
    {
        Toby_PathfindingNode node = new("Toby_PathfindingNode");
        node.pos = (pos.x, pos.y, pos.z);
        node.gScore = Int.Max;
        node.hScore = Int.Max;
        node.fScore = Int.Max;
        node.lineId = lineId;
        node.id = id;
        node.sectorIndexOverride = -1;
        return node;
    }

    void AddEdge(Toby_PathfindingNode otherNode)
    {
        if (self == otherNode) { return; }
        if (IsAlreadyConnected(otherNode)) { return; }

        edges.push(otherNode);
        otherNode.backwardsEdges.push(self);
    }

    bool IsAlreadyConnected(Toby_PathfindingNode otherNode)
    {
        for (int i = 0; i < edges.Size(); i++)
        {
            if (edges[i] == otherNode)
            {
                return true;
            }
        }
        return false;
    }

    void SetScore(float g, float h)
    {
        gScore = g;
        hScore = h;
        fScore = g + h;
    }

    void UpdateGScore(float g)
    {
        gScore = g;
        fScore = g + hScore;
    }

    float GetFScore()
    {
        return fScore;
    }
}
