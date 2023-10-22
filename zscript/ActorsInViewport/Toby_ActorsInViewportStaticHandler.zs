class Toby_ActorsInViewportStaticHandler: StaticEventHandler
{
    ui bool isNotFirstRun;

    Toby_ViewportProjector projector;
    Toby_ActorsInViewportStorage storage;

    int maxPlayers;
    Array<Toby_ActorsInViewportStorage> storages;
    Array<Toby_ViewportProjector> projectors;
    ui Array<bool> checkingActorsInViewport;

    override void OnRegister()
    {
        projector = Toby_ViewportProjector.Create();
        storage = Toby_ActorsInViewportStorage.Create();
        maxPlayers = 8;
        for (int i = 0; i < maxPlayers; i++)
        {
            storages.push(Toby_ActorsInViewportStorage.Create());
        }
        for (int i = 0; i < maxPlayers; i++)
        {
            projectors.push(Toby_ViewportProjector.Create());
        }
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            for (int i = 0; i < maxPlayers; i++)
            {
                checkingActorsInViewport.push(false);
            }
        }
    }

    override void WorldTick()
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        if (!(CVar.FindCvar("Toby_Developer").GetBool() && CVar.FindCvar("Toby_Developer_ActorsInViewportDebug").GetBool())) { return; }
        storage.GetActorsThatCanSeePlayer(playerActor);
    }

    override void RenderOverlay(RenderEvent e)
    {
        projector.viewport.FromHud();
        if (!projector.canProject)
        {
            return;
        }

        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        if (!(CVar.FindCvar("Toby_Developer").GetBool() && CVar.FindCvar("Toby_Developer_ActorsInViewportDebug").GetBool())) { return; }

        projector.projection.CacheResolution();
        projector.projection.CacheFov(player.fov);
        projector.projection.OrientForRenderOverlay(e);
        projector.projection.BeginProjection();

        storage.ResetFilters(playerActor, projector);
        for (let i = 0; i < storage.actorsThatCanSeePlayer.Size(); i++)
        {
            if (!storage.actorsThatCanSeePlayer[i]) { continue; }
            if (storage.actorsThatCanSeePlayer[i] == playerActor) { continue; }
            projector.projection.projectActorPos(storage.actorsThatCanSeePlayer[i], (0,0,0), 1.0);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            storage.FilterActor(storage.actorsThatCanSeePlayer[i]);
        }

        Toby_ViewportOnScreenDebug.DrawDebugInformation(storage);
    }

    override void RenderUnderlay(RenderEvent e)
    {
        if (!checkingActorsInViewport[consoleplayer]) { return; }

        projectors[consoleplayer].viewport.FromHud();
        if (!projector.canProject) { return; }

        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        projectors[consoleplayer].projection.CacheResolution();
        projectors[consoleplayer].projection.CacheFov(player.fov);
        projectors[consoleplayer].projection.OrientForRenderOverlay(e);
        projectors[consoleplayer].projection.BeginProjection();

        storages[consoleplayer].ResetFilters(playerActor, projector);

        for (let i = 0; i < storages[consoleplayer].actorsThatCanSeePlayer.Size(); i++)
        {
            if (!storages[consoleplayer].actorsThatCanSeePlayer[i]) { continue; }
            if (storages[consoleplayer].actorsThatCanSeePlayer[i] == playerActor) { continue; }
            projector.projection.projectActorPos(storages[consoleplayer].actorsThatCanSeePlayer[i], (0,0,0), 1.0);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            storages[consoleplayer].FilterActor(storages[consoleplayer].actorsThatCanSeePlayer[i]);
        }

        checkingActorsInViewport[consoleplayer] = false;
    }

    override void InterfaceProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }
        if (e.Name == "Toby_CheckActorsInViewportInterface")
        {
            checkingActorsInViewport[consoleplayer] = true;
        }
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }
        if (e.Name == "Toby_CheckActorsInViewport")
        {
            storages[e.Player].GetActorsThatCanSeePlayer(playerActor);
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckActorsInViewportInterface");
        }
    }
}
