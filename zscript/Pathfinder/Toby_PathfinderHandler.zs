class Toby_PathfinderHandler : EventHandler
{
    //I feel like I need to move visual debuggers to separate class
    Toby_ViewportProjector projector;

    Array<Toby_PathfindingNodeContainer> nodeContainers;
    Array<Toby_PathfindingNodeBuilder> nodeBuilders;
    Array<Toby_Pathfinder> pathfinders;
    Array<Toby_PathfinderFollower> pathfinderFollowers;
    Array<Toby_PathfinderThinker> pathfinderThinkers;
    int maxPlayers;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_PathfinderHandler registered!", "Toby_Developer");
    }

    override void WorldLoaded(WorldEvent e)
    {
        projector = Toby_ViewportProjector.Create();

        maxPlayers = 8;
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            Actor playerActor = players[i].mo;

            Toby_PathfindingNodeContainer nodeContainer = Toby_PathfindingNodeContainer.Create();
            Toby_PathfindingNodeBuilder nodeBuilder = Toby_PathfindingNodeBuilder.Create(nodeContainer, playerActor);
            Toby_Pathfinder pathfinder = Toby_Pathfinder.Create(nodeContainer);
            Toby_PathfinderFollower pathfinderFollower = Toby_PathfinderFollower.Create(pathfinder);
            Toby_PathfinderThinker pathfinderThinker = Toby_PathfinderThinker.Create(pathfinder, pathfinderFollower, playerActor);
            nodeContainers.push(nodeContainer);
            nodeBuilders.push(nodeBuilder);
            pathfinders.push(pathfinder);
            pathfinderFollowers.push(pathfinderFollower);
            pathfinderThinkers.push(pathfinderThinker);
        }
    }

    override void WorldTick()
    {
        for (int i = 0; i < maxPlayers; i++)
        {
            // I feel like this is not great -PR
            // pathfinderThinkers[i].SetReceivingActor(players[i].mo);
            // nodeBuilders[i].SetPlayerActor(players[i].mo);
        }
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        Array<String> eventAndArgument;
        e.Name.split(eventAndArgument, ":", TOK_KEEPEMPTY);

        if (eventAndArgument[0] == "Toby_FindPath")
        {
            Toby_MarkerHandler markerHandler = Toby_MarkerHandler.GetInstancePlay();
            int markerId = eventAndArgument[1].ToInt();
            Toby_MarkerRecord record = markerHandler.recordContainers[e.Player].GetMarkerById(markerId);
            if (!record) { return; }
            Actor markerActor = record.markerActor;
            pathfinderThinkers[e.Player].FindPath(playerActor.pos, markerActor.pos);
        }

        if (e.Name == "Toby_FindPath")
        {
            pathfinderThinkers[e.Player].FindPath(playerActor.pos, nodeContainers[e.Player].nodes[0].pos);
            return;
        }
    }

    //This is debug only
    override void RenderOverlay(RenderEvent e)
    {
        if (!(CVar.FindCvar("Toby_Developer").GetBool() && CVar.FindCvar("Toby_Developer_PathfindingDebug").GetBool())) { return; }

        projector.viewport.FromHud();
        if (!projector.canProject)
        {
            return;
        }

        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        projector.projection.CacheResolution();
        projector.projection.CacheFov(player.fov);
        projector.projection.OrientForRenderOverlay(e);
        projector.projection.BeginProjection();

        Toby_PathfinderDebugRender.DebugRender(projector, pathfinders[consoleplayer], pathfinderFollowers[consoleplayer]);
    }
}
