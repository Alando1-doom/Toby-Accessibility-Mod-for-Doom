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
        Toby_PathfindingNode newNode = Toby_PathfindingNode.Create(pos, lineId, lastId);
        lastId++;
        nodes.push(newNode);
        return newNode;
    }
}
