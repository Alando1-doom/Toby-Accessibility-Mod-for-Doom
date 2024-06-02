class Toby_PathfinderDebugRender
{
    static void DebugRender(Toby_ViewportProjector projector, Toby_Pathfinder p, Toby_PathfinderFollower pfFollower)
    {
        if (!p) { return; }
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

            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 1, "Node ID: "..node.id);
            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 2, "Linked to: "..edges);
            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 3, "Line ID: "..node.lineId);
            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 4, "Score (G + H = F): ".. node.gScore .. " + ".. node.hScore .." = "..node.fScore);
        }

        if (p.pathStart)
        {
            projector.projection.ProjectWorldPos(p.pathStart.pos);
            let normalPos = projector.projection.projectToNormal();
            // if (!projector.viewport.IsInside(normalPos)) { return; }
            // if (!projector.projection.IsInScreen()) { return; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);

            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 0, "START");
        }

        if (p.pathEnd)
        {
            projector.projection.ProjectWorldPos(p.pathEnd.pos);
            let normalPos = projector.projection.projectToNormal();
            // if (!projector.viewport.IsInside(normalPos)) { return; }
            // if (!projector.projection.IsInScreen()) { return; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);

            Screen.DrawText(smallfont, Font.CR_GOLD, screenPos.x, screenPos.y + 10 * 0, "END");
        }

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
            Screen.DrawText(smallfont, Font.CR_LIGHTBLUE, screenPos.x, screenPos.y, "0");
        }

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
            Screen.DrawText(smallfont, Font.CR_GREY, screenPos.x, screenPos.y, "0");
        }

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
            Screen.DrawText(smallfont, Font.CR_GREEN, screenPos.x, screenPos.y, "0");
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
}
