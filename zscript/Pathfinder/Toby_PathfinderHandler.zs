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

    Array<bool> destinationReachedPrevious;
    Array<bool> destinationReachedCurrent;
    Array<bool> pathFoundPrevious;
    Array<bool> pathFoundCurrent;
    Array<bool> pathCantBeFoundPrevious;
    Array<bool> pathCantBeFoundCurrent;
    Array<Toby_PathfindingNode> currentNodePrevious;
    Array<Toby_PathfindingNode> currentNodeCurrent;

    Array<Actor> pathfindingMarkers;

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

            destinationReachedPrevious.push(true);
            destinationReachedCurrent.push(true);

            pathFoundPrevious.push(false);
            pathFoundCurrent.push(false);
            pathCantBeFoundPrevious.push(false);
            pathCantBeFoundCurrent.push(false);

            currentNodePrevious.push(null);
            currentNodeCurrent.push(null);

            pathfindingMarkers.push(Actor.Spawn("Toby_Marker_Pathfinding", (0, 0, 0)));
        }
    }

    override void WorldTick()
    {
        for (int i = 0; i < maxPlayers; i++)
        {

            PlayerInfo player = players[i];
            if (!player) { continue; }
            Actor playerActor = player.mo;
            if (!playerActor) { continue; }

            // I feel like this is not great -PR
            // pathfinderThinkers[i].SetReceivingActor(players[i].mo);
            // nodeBuilders[i].SetPlayerActor(players[i].mo);

            int minDistance = 150;

            if (!pathfinderFollowers[i].destinationReached)
            {
                if (!pathfindingMarkers[i].InStateSequence(pathfindingMarkers[i].CurState, pathfindingMarkers[i].ResolveState("Enabled")))
                {
                    pathfindingMarkers[i].SetStateLabel("Enabled");
                }

                if (currentNodeCurrent[i])
                {
                    Vector3 nextNodeVector = currentNodeCurrent[i].pos - playerActor.pos;
                    if (nextNodeVector.Length() >= minDistance)
                    {
                        Vector3 newPos = playerActor.pos + nextNodeVector.Unit() * minDistance;
                        pathfindingMarkers[i].SetOrigin(newPos, false);
                    }
                    else
                    {
                        pathfindingMarkers[i].SetOrigin(currentNodeCurrent[i].pos, false);
                    }
                }
            }

            if (pathfinderFollowers[i].destinationReached || pathfinders[i].pathDoesNotExist)
            {
                if (!pathfindingMarkers[i].InStateSequence(pathfindingMarkers[i].CurState, pathfindingMarkers[i].ResolveState("Spawn")))
                {
                    pathfindingMarkers[i].SetStateLabel("Spawn");
                }
            }

            destinationReachedPrevious[i] = destinationReachedCurrent[i];
            destinationReachedCurrent[i] = pathfinderFollowers[i].destinationReached;

            pathFoundPrevious[i] = pathFoundCurrent[i];
            pathFoundCurrent[i] = pathfinders[i].pathFinalized;

            pathCantBeFoundPrevious[i] = pathCantBeFoundCurrent[i];
            pathCantBeFoundCurrent[i] = pathfinders[i].pathDoesNotExist;

            currentNodePrevious[i] = currentNodeCurrent[i];
            currentNodeCurrent[i] = pathfinderFollowers[i].GetCurrentPathNode();
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

        if (e.Name == "Toby_StopPathfinding")
        {
            pathfinderThinkers[e.Player].Reset();
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

    override void UiTick()
    {
        if (pathFoundPrevious[consoleplayer] != pathFoundCurrent[consoleplayer] && pathFoundCurrent[consoleplayer])
        {
            // console.printf("Path found");
            S_StartSound("pathfinder/pathfound", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
        }

        if (pathCantBeFoundPrevious[consoleplayer] != pathCantBeFoundCurrent[consoleplayer] && pathCantBeFoundCurrent[consoleplayer])
        {
            // console.printf("Path can't be found");
            S_StartSound("pathfinder/nopath", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
        }

        if (destinationReachedPrevious[consoleplayer] != destinationReachedCurrent[consoleplayer] && destinationReachedCurrent[consoleplayer])
        {
            // console.printf("Destination reached");
            S_StartSound("pathfinder/destreached", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
        }

        if (currentNodePrevious[consoleplayer] != currentNodeCurrent[consoleplayer] && !destinationReachedCurrent[consoleplayer])
        {
            // console.printf("Next node reached");
            S_StartSound("pathfinder/nodereached", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
        }
    }
}
