class Toby_ActorsInViewportStaticHandler: StaticEventHandler
{
    ui bool isNotFirstRun;

    Toby_ViewportProjector projector;
    Toby_ActorsInViewportStorage storage;

    int maxPlayers;
    Array<Toby_ActorsInViewportStorage> storages;
    Array<Toby_ViewportProjector> projectors;
    ui Array<bool> checkingActorsInViewport;

    ui Toby_SoundBindingsContainer actorsInViewportSoundBindings;

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
            actorsInViewportSoundBindings = Toby_SoundBindingsContainer.Create("Toby_ActorsInViewportSoundBindings");
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

    //This is debug only
    override void RenderOverlay(RenderEvent e)
    {
        if (!(CVar.FindCvar("Toby_Developer").GetBool() && CVar.FindCvar("Toby_Developer_ActorsInViewportDebug").GetBool())) { return; }
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
        TextureId debugTexture = TexMan.CheckForTexture("STCDROM",TexMan.TYPE_ANY);

        storage.ResetFilters(playerActor, projector);
        for (let i = 0; i < storage.actorsThatCanSeePlayer.Size(); i++)
        {
            Actor actorTofilter = storage.actorsThatCanSeePlayer[i];
            if (!actorTofilter) { continue; }
            if (actorTofilter == playerActor) { continue; }
            projector.projection.projectActorPos(actorTofilter, (0, 0, actorTofilter.height/2), 1.0);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);
            storage.FilterActor(actorTofilter);
            Screen.DrawTexture(debugTexture, false, screenPos.x, screenPos.y);
        }

        Toby_ViewportOnScreenDebug.DrawDebugInformation(storage);
    }

    //This is actual feature
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
            Actor actorTofilter = storages[consoleplayer].actorsThatCanSeePlayer[i];
            if (!actorTofilter) { continue; }
            if (actorTofilter == playerActor) { continue; }
            projector.projection.projectActorPos(actorTofilter, (0, 0, actorTofilter.height/2), 1.0);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            storages[consoleplayer].FilterActor(actorTofilter);
        }

        Toby_ActorsInViewportPresets.PlayDetailedOverviewByDistanceAndScreenPosition(storages[consoleplayer], actorsInViewportSoundBindings);

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
