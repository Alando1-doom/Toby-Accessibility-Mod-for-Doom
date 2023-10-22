class Toby_ActorsInViewportHandler: EventHandler
{
    Toby_ViewportProjector projector;
    Toby_ActorsInViewportStorage storage;

    override void OnRegister()
    {
        projector = Toby_ViewportProjector.Create();
        storage = Toby_ActorsInViewportStorage.Create();
    }

    override void WorldTick()
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        projector.PrepareProjection();

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
}

class PosInfo
{
    string name;
    int amount;
}

class PosInfoStorage
{
    Array<PosInfo> storage;

    void AddName(string name)
    {
        bool nameFound = false;

        for (let i = 0; i < storage.Size(); i++)
        {
            if (storage[i].name == name)
            {
                nameFound = true;
                storage[i].amount++;
            }
        }
        if (!nameFound)
        {
            PosInfo info = new("PosInfo");
            info.name = name;
            info.amount = 1;
            storage.push(info);
        }
    }
}
