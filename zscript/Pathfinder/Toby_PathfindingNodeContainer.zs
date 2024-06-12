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
}
