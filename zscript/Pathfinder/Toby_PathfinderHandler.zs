class Toby_PathfinderHandler : EventHandler
{
    //I feel like I need to move visual debuggers to separate class
    Toby_ViewportProjector projector;

    Toby_SectorMovementDetector sectorMovementDetector;
    Toby_InSectorNodeBuilder inSectorNodeBuilder;

    Toby_LineInteractionTracker lineInteractionTracker;
    Array<Toby_ExplorationTracker> explorationTrackers;
    Array<Toby_ExplorationPathfinder> explorationPathfinders;
    Array<Toby_ExplorationPathfinder> explorationPathfindersForMenu;

    Array<Toby_PathfindingNodeContainer> nodeContainers;
    Array<Toby_PathfindingNodeBuilder> nodeBuilders;
    Array<Toby_Pathfinder> pathfinders;
    Array<Toby_Pathfinder> pathfindersForMenu;
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
        lineInteractionTracker = Toby_LineInteractionTracker.Create();
        inSectorNodeBuilder = Toby_InSectorNodeBuilder.Create();
        sectorMovementDetector = Toby_SectorMovementDetector.Create();
        projector = Toby_ViewportProjector.Create();

        maxPlayers = 8;
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            Actor playerActor = players[i].mo;

            Toby_PathfindingNodeContainer nodeContainer = Toby_PathfindingNodeContainer.Create();
            Toby_PathfindingNodeBuilder nodeBuilder = Toby_PathfindingNodeBuilder.Create(nodeContainer, playerActor);
            Toby_Pathfinder pathfinder = Toby_Pathfinder.Create(nodeContainer);
            Toby_Pathfinder pathfinderForMenu = Toby_Pathfinder.Create(nodeContainer);
            Toby_PathfinderFollower pathfinderFollower = Toby_PathfinderFollower.Create(pathfinder);
            Toby_PathfinderThinker pathfinderThinker = Toby_PathfinderThinker.Create(pathfinder, pathfinderFollower, playerActor);
            Toby_ExplorationTracker explorationTracker = Toby_ExplorationTracker.Create(playerActor, sectorMovementDetector, lineInteractionTracker);
            Toby_ExplorationPathfinder explorationPathfinder = Toby_ExplorationPathfinder.Create(playerActor, explorationTracker, inSectorNodeBuilder, nodeContainer);
            Toby_ExplorationPathfinder explorationPathfinderForMenu = Toby_ExplorationPathfinder.Create(playerActor, explorationTracker, inSectorNodeBuilder, nodeContainer);
            explorationTrackers.push(explorationTracker);
            explorationPathfinders.push(explorationPathfinder);
            explorationPathfindersForMenu.push(explorationPathfinderForMenu);
            nodeContainers.push(nodeContainer);
            nodeBuilders.push(nodeBuilder);
            pathfinders.push(pathfinder);
            pathfindersForMenu.push(pathfinderForMenu);
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

    override void WorldLineActivated(WorldEvent e)
    {
        lineInteractionTracker.ActivateLine(e.ActivatedLine.Index());
    }

    override void WorldTick()
    {
        sectorMovementDetector.Update();
        for (int i = 0; i < maxPlayers; i++)
        {

            PlayerInfo player = players[i];
            if (!player) { continue; }
            Actor playerActor = player.mo;
            if (!playerActor) { continue; }

            explorationTrackers[i].Update();

            UpdatePathfindingMarker(i, playerActor);

            destinationReachedPrevious[i] = destinationReachedCurrent[i];
            destinationReachedCurrent[i] = pathfinderFollowers[i].destinationReached;

            pathFoundPrevious[i] = pathFoundCurrent[i];
            pathFoundCurrent[i] = pathfinders[i].pathFinalized;

            pathCantBeFoundPrevious[i] = pathCantBeFoundCurrent[i];
            pathCantBeFoundCurrent[i] = pathfinders[i].pathDoesNotExist;

            currentNodePrevious[i] = currentNodeCurrent[i];
            currentNodeCurrent[i] = pathfinderFollowers[i].GetCurrentPathNode();
        }
        lineInteractionTracker.Update();
    }

    void UpdatePathfindingMarker(int playerNumber, Actor playerActor)
    {
        int minDistance = 150;
        if (!pathfinderFollowers[playerNumber].destinationReached)
        {
            bool markerEnabled = pathfindingMarkers[playerNumber].InStateSequence(pathfindingMarkers[playerNumber].CurState, pathfindingMarkers[playerNumber].ResolveState("Enabled"));
            if (!markerEnabled)
            {
                pathfindingMarkers[playerNumber].SetStateLabel("Enabled");
            }

            if (markerEnabled)
            {
                double angleToTarget = playerActor.AngleTo(pathfindingMarkers[playerNumber]) - playerActor.angle;
                angleToTarget = (angleToTarget + 180) % 360;
                if (angleToTarget < 0)
                    angleToTarget += 360;
                angleToTarget -= 180;

                Toby_Marker_Pathfinding marker = Toby_Marker_Pathfinding(pathfindingMarkers[playerNumber]);
                if (Abs(angleToTarget) <= 15)
                {
                    marker.SetMarkerSound("pathfinder/nodebeaconfast");
                }
                else
                {
                    marker.SetMarkerSound("pathfinder/nodebeacon");
                }
            }

            if (currentNodeCurrent[playerNumber])
            {
                Vector3 nextNodeVector = currentNodeCurrent[playerNumber].pos - playerActor.pos;
                if (nextNodeVector.Length() >= minDistance)
                {
                    Vector3 newPos = playerActor.pos + nextNodeVector.Unit() * minDistance;
                    int zPos = Max(playerActor.GetZAt(newPos.x, newPos.y, 0, GZF_ABSOLUTEPOS), newPos.z);
                    pathfindingMarkers[playerNumber].SetOrigin((newPos.xy, zPos), true);
                }
                else
                {
                    pathfindingMarkers[playerNumber].SetOrigin(currentNodeCurrent[playerNumber].pos, true);
                }
            }
        }

        if (pathfinderFollowers[playerNumber].destinationReached || pathfinders[playerNumber].pathDoesNotExist)
        {
            if (!pathfindingMarkers[playerNumber].InStateSequence(pathfindingMarkers[playerNumber].CurState, pathfindingMarkers[playerNumber].ResolveState("Spawn")))
            {
                pathfindingMarkers[playerNumber].SetStateLabel("Spawn");
            }
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
            pathfinderThinkers[e.Player].FindPath(playerActor.pos, markerActor.pos, nodeContainers[e.Player]);
        }

        if (eventAndArgument[0] == "Toby_FindPathExploration")
        {
            vector2 destinationFlat = (eventAndArgument[1].ToDouble(), eventAndArgument[2].ToDouble());
            vector3 destination = (destinationFlat, eventAndArgument[3].ToDouble());
            // console.printf("Destination: "..destination);
            int destinationSector = level.PointInSector(destinationFlat).Index();
            explorationPathfinders[e.Player].FindPathFromDestinationToExploredSector(destinationSector);
            pathfinderThinkers[e.Player].FindPath(playerActor.pos, destination, explorationPathfinders[e.Player].explorationNodes);

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
        if (CVar.FindCvar("Toby_NarrationOutputType").GetInt() == TNOT_CONSOLE)
        {
            if (pathFoundPrevious[consoleplayer] != pathFoundCurrent[consoleplayer] && pathFoundCurrent[consoleplayer])
            {
                Toby_Logger.ConsoleOutputModeMessage("Path found");
            }

            if (pathCantBeFoundPrevious[consoleplayer] != pathCantBeFoundCurrent[consoleplayer] && pathCantBeFoundCurrent[consoleplayer])
            {
                Toby_Logger.ConsoleOutputModeMessage("Path not found");
            }

            if (destinationReachedPrevious[consoleplayer] != destinationReachedCurrent[consoleplayer] && destinationReachedCurrent[consoleplayer])
            {
                Toby_Logger.ConsoleOutputModeMessage("Destination reached");
            }
        }
        else
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
        }

        if (currentNodePrevious[consoleplayer] != currentNodeCurrent[consoleplayer] && !destinationReachedCurrent[consoleplayer])
        {
            // console.printf("Next node reached");
            S_StartSound("pathfinder/nodereached", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
        }
    }

    ui static Toby_PathfinderHandler GetInstanceUi()
    {
        return Toby_PathfinderHandler(EventHandler.Find("Toby_PathfinderHandler"));
    }

    play static Toby_PathfinderHandler GetInstancePlay()
    {
        return Toby_PathfinderHandler(EventHandler.Find("Toby_PathfinderHandler"));
    }
}
