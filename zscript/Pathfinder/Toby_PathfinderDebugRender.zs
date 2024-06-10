class Toby_PathfinderDebugRender
{
    static void DebugRender(Toby_ViewportProjector projector, Toby_Pathfinder p, Toby_PathfinderFollower pfFollower)
    {
        if (!p) { return; }

        Shape2D circle;
        circle = CreateCircle();
        Shape2DTransform transform;
        transform = New("Shape2DTransform");
        int circleRadius = 10;

        RenderRegularConnections(projector, p);
        RenderClosedListConnections(projector, p);
        RenderOpenListConnections(projector, p);

        RenderRegularNodes(projector, p, circle, transform, circleRadius);

        RenderStart(projector, p);
        RenderEnd(projector, p);

        RenderOpenListNodes(projector, p, circle, transform, circleRadius);
        RenderClosedListNodes(projector, p, circle, transform, circleRadius);
        RenderFoundPath(projector, p, circle, transform, circleRadius);

        RenderState(p, pfFollower);
        RenderCurrentGoalNode(projector, pfFollower, circle, transform, circleRadius);
    }

    static void RenderCurrentGoalNode(
        Toby_ViewportProjector projector,
        Toby_PathfinderFollower pfFollower,
        Shape2D circle,
        Shape2DTransform transform,
        int circleRadius)
    {
        let currentPathNode = pfFollower.GetCurrentPathNode();
        if (!currentPathNode) { return; }
        projector.projection.ProjectWorldPos(currentPathNode.pos);
        let normalPos = projector.projection.projectToNormal();
        if (!projector.viewport.IsInside(normalPos)) { return; }
        if (!projector.projection.IsInScreen()) { return; }
        let screenPos = projector.viewport.SceneToWindow(normalPos);
        RenderCircle(screenPos.x, screenPos.y, circleRadius, color(127, 0, 127), circle, transform);
    }

    static void RenderState(Toby_Pathfinder p, Toby_PathfinderFollower pfFollower)
    {
        Screen.DrawText(smallfont, Font.CR_GOLD, 500, 50 + 10 * 0, "State:");
        Screen.DrawText(smallfont, Font.CR_WHITE, 500, 50 + 10 * 1, "Pathfinding active: "..p.pathfindingActive);
        Screen.DrawText(smallfont, Font.CR_WHITE, 500, 50 + 10 * 2, "Path found: "..p.pathFound);
        Screen.DrawText(smallfont, Font.CR_WHITE, 500, 50 + 10 * 3, "Path does not exist: "..p.pathDoesNotExist);
        Screen.DrawText(smallfont, Font.CR_WHITE, 500, 50 + 10 * 4, "Path constructed: "..p.pathConstructed);
        Screen.DrawText(smallfont, Font.CR_WHITE, 500, 50 + 10 * 5, "Path finalized: "..p.pathFinalized);

        Screen.DrawText(smallfont, Font.CR_GOLD, 750, 50 + 10 * 0, "Journey state:");
        string currentPathNodeName = "None";
        let currentPathNode = pfFollower.GetCurrentPathNode();
        if (currentPathNode) {
            currentPathNodeName = "Node "..currentPathNode.id;
        }
        Screen.DrawText(smallfont, Font.CR_WHITE, 750, 50 + 10 * 1, "Current path node: "..currentPathNodeName);
        Screen.DrawText(smallfont, Font.CR_WHITE, 750, 50 + 10 * 2, "Destination reached: "..pfFollower.destinationReached);
    }

    static void RenderRegularNodes(Toby_ViewportProjector projector, Toby_Pathfinder p, Shape2D circle, Shape2DTransform transform, int circleRadius)
    {
        for (int i = 0; i < p.nodeContainer.nodes.Size(); i++)
        {
            let node = p.nodeContainer.nodes[i];
            projector.projection.ProjectWorldPos(node.pos);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);

            let edges = "";
            for (int j = 0; j < node.edges.Size(); j++)
            {
                edges = edges..", "..node.edges[j].id;
            }

            RenderCircle(screenPos.x, screenPos.y, circleRadius, color(0, 0, 0), circle, transform);
            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 1, "Node ID: "..node.id);
            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 2, "Linked to: "..edges);
            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 3, "Line ID: "..node.lineId);
            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 4, "Score (G + H = F): ".. node.gScore .. " + ".. node.hScore .." = "..node.fScore);
        }
    }

    static void RenderOpenListNodes(Toby_ViewportProjector projector, Toby_Pathfinder p, Shape2D circle, Shape2DTransform transform, int circleRadius)
    {
        Screen.DrawText(smallfont, Font.CR_GOLD, 50, 50 + 10 * 0, "Open List:");
        for (int i = 0; i < p.openList.Size(); i++)
        {
            let node = p.openList[i];
            Screen.DrawText(smallfont, Font.CR_WHITE, 50, 50 + 10 * (1 + i), "Node "..node.id);

            projector.projection.ProjectWorldPos(node.pos);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);
            RenderCircle(screenPos.x, screenPos.y, circleRadius, color(255, 127, 127), circle, transform);
        }
    }

    static void RenderClosedListNodes(Toby_ViewportProjector projector, Toby_Pathfinder p, Shape2D circle, Shape2DTransform transform, int circleRadius)
    {
        Screen.DrawText(smallfont, Font.CR_GOLD, 200, 50 + 10 * 0, "Closed List:");
        for (int i = 0; i < p.closedList.Size(); i++)
        {
            let node = p.closedList[i];
            Screen.DrawText(smallfont, Font.CR_WHITE, 200, 50 + 10 * (1 + i), "Node "..node.id);

            projector.projection.ProjectWorldPos(node.pos);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);
            RenderCircle(screenPos.x, screenPos.y, circleRadius, color(127, 127, 127), circle, transform);
        }
    }

    static void RenderFoundPath(Toby_ViewportProjector projector, Toby_Pathfinder p, Shape2D circle, Shape2DTransform transform, int circleRadius)
    {
        Screen.DrawText(smallfont, Font.CR_GOLD, 350, 50 + 10 * 0, "Found path:");
        for (int i = 0; i < p.path.Size(); i++)
        {
            let node = p.path[i];
            Screen.DrawText(smallfont, Font.CR_WHITE, 350, 50 + 10 * (1 + i), "Node "..node.id);

            projector.projection.ProjectWorldPos(node.pos);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);
            RenderCircle(screenPos.x, screenPos.y, circleRadius, Color(0, 255, 0), circle, transform);
            if (i != p.path.Size() - 1)
            {
                let nextNode = p.path[i+1];
                projector.projection.ProjectWorldPos(nextNode.pos);
                let nextNodeNormalPos = projector.projection.projectToNormal();
                if (!projector.viewport.IsInside(nextNodeNormalPos)) { continue; }
                if (!projector.projection.IsInScreen()) { continue; }
                let nextNodeScreenPos = projector.viewport.SceneToWindow(nextNodeNormalPos);
                Screen.DrawThickLine(screenPos.x, screenPos.y, nextNodeScreenPos.x, nextNodeScreenPos.y, 5, Color(0, 255, 0));
            }
        }
    }

    static void RenderStart(Toby_ViewportProjector projector, Toby_Pathfinder p)
    {
        if (p.pathStart)
        {
            projector.projection.ProjectWorldPos(p.pathStart.pos);
            let normalPos = projector.projection.projectToNormal();
            if (projector.projection.IsInScreen() && projector.viewport.IsInside(normalPos))
            {
                let screenPos = projector.viewport.SceneToWindow(normalPos);
                Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 1, "START");
            }
        }
    }

    static void RenderEnd(Toby_ViewportProjector projector, Toby_Pathfinder p)
    {
        if (p.pathEnd)
        {
            projector.projection.ProjectWorldPos(p.pathEnd.pos);
            let normalPos = projector.projection.projectToNormal();

            if (projector.projection.IsInScreen() && projector.viewport.IsInside(normalPos))
            {
                let screenPos = projector.viewport.SceneToWindow(normalPos);
                Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 1, "END");
            }
        }
    }

    static void RenderRegularConnections(Toby_ViewportProjector projector, Toby_Pathfinder p)
    {
        for (int i = 0; i < p.nodeContainer.nodes.Size(); i++)
        {
            let node = p.nodeContainer.nodes[i];
            projector.projection.ProjectWorldPos(node.pos);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);

            for (int j = 0; j < node.edges.Size(); j++)
            {
                let edge = node.edges[j];
                projector.projection.ProjectWorldPos(edge.pos);
                let edgeNormalPos = projector.projection.projectToNormal();
                if (!projector.viewport.IsInside(edgeNormalPos)) { continue; }
                if (!projector.projection.IsInScreen()) { continue; }
                let edgeScreenPos = projector.viewport.SceneToWindow(edgeNormalPos);
                Screen.DrawThickLine(screenPos.x, screenPos.y, edgeScreenPos.x, edgeScreenPos.y, 5, Color(0, 0, 0));
            }
        }
    }

    static void RenderOpenListConnections(Toby_ViewportProjector projector, Toby_Pathfinder p)
    {
        for (int i = 0; i < p.closedList.Size(); i++)
        {
            let node = p.closedList[i];
            projector.projection.ProjectWorldPos(node.pos);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);

            for (int j = 0; j < node.edges.Size(); j++)
            {
                let edge = node.edges[j];
                bool isInOpenList = false;
                for (int k = 0; k < p.openList.Size(); k++)
                {
                    if (edge == p.openList[k])
                    {
                        isInOpenList = true;
                        break;
                    }
                }
                if (!isInOpenList) { continue; }

                projector.projection.ProjectWorldPos(edge.pos);
                let edgeNormalPos = projector.projection.projectToNormal();
                if (!projector.viewport.IsInside(edgeNormalPos)) { continue; }
                if (!projector.projection.IsInScreen()) { continue; }
                let edgeScreenPos = projector.viewport.SceneToWindow(edgeNormalPos);
                Screen.DrawThickLine(screenPos.x, screenPos.y, edgeScreenPos.x, edgeScreenPos.y, 5, color(127, 127, 255));
            }
        }
    }

    static void RenderClosedListConnections(Toby_ViewportProjector projector, Toby_Pathfinder p)
    {
        for (int i = 0; i < p.closedList.Size(); i++)
        {
            let node = p.closedList[i];
            projector.projection.ProjectWorldPos(node.pos);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);

            for (int j = 0; j < node.edges.Size(); j++)
            {
                let edge = node.edges[j];
                bool isInClosedList = false;
                for (int k = 0; k < p.closedList.Size(); k++)
                {
                    if (edge == p.closedList[k])
                    {
                        isInClosedList = true;
                        break;
                    }
                }
                if (!isInClosedList) { continue; }

                projector.projection.ProjectWorldPos(edge.pos);
                let edgeNormalPos = projector.projection.projectToNormal();
                if (!projector.viewport.IsInside(edgeNormalPos)) { continue; }
                if (!projector.projection.IsInScreen()) { continue; }
                let edgeScreenPos = projector.viewport.SceneToWindow(edgeNormalPos);
                Screen.DrawThickLine(screenPos.x, screenPos.y, edgeScreenPos.x, edgeScreenPos.y, 5, Color(127, 127, 127));
            }
        }
    }

    static void RenderCircle(int x, int y, int radius, Color col, Shape2D circle, Shape2DTransform transform)
    {
        transform.Clear();
        transform.Scale((radius, radius));
        transform.Translate((x, y));
        circle.SetTransform(transform);
        Screen.DrawShapeFill(col, 1.0, circle);
    }

    static Shape2D CreateCircle()
    {
        float circleAngles = 360.0;
        Shape2D circle = New("Shape2D");
        Vector2 cc = (0.5, 0.5);
        circle.PushVertex(cc);
        circle.PushCoord((0,0));
        int steps = 10;
        double ang = 0;
        double angStep = circleAngles / steps;

        for (int i = 0; i < steps; i++)
        {
            double c = cos(ang);
            double s = sin(ang);
            circle.PushVertex((c,s));
            circle.PushCoord((0,0));
            ang += angStep;
        }

        for (int i = 1; i <= steps; i++)
        {
            int next = i + 1;
            if (next > steps)
            {
                next -= steps;
            }
            circle.PushTriangle(0, i, next);
        }

        return circle;
    }
}
