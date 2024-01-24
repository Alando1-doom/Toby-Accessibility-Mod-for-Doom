class Toby_SnapToTargetHandler : EventHandler
{
    Array<bool> playerSnappingToTarget;
    int maxPlayers;
    float maxDistance;

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        maxDistance = 100000;
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            playerSnappingToTarget.push(false);
        }
    }

    override void WorldTick()
    {
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            if (!playerSnappingToTarget[i]) { continue; }
            Actor playerActor = players[i].mo;
            if (!playerActor) { continue; }
            SnapToNearestShootableActor(playerActor);
        }
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        if (e.Name == "Toby_SnapToTarget_KeyDown")
        {
            playerSnappingToTarget[e.Player] = true;
        }
        if (e.Name == "Toby_SnapToTarget_KeyUp")
        {
            playerSnappingToTarget[e.Player] = false;
        }
    }

    private void SnapToNearestShootableActor(Actor playerActor)
    {
        Array<Actor> foundActors;
        FindVisiableShootableActors(playerActor, foundActors);
        Actor closestActor = FindClosestShootableActor(playerActor, foundActors, maxDistance);
        if (!closestActor) { return; }
        double angleToTarget = playerActor.AngleTo(closestActor);
        playerActor.A_SetAngle(angleToTarget, SPF_INTERPOLATE);
    }

    private Actor FindClosestShootableActor(Actor playerActor, Array<Actor> foundActors, float maxDistance)
    {
        float minDistance = maxDistance;
        Actor closestActor;
        int i = 0;
        for (i = 0; i < foundActors.Size(); i++)
        {
            Vector2 vectorPlayerToMonster = foundActors[i].pos.xy - playerActor.pos.xy;
            if (vectorPlayerToMonster.Length() < minDistance)
            {
                minDistance = vectorPlayerToMonster.Length();
                closestActor = foundActors[i];
            }
        }
        return closestActor;
    }

    private void FindVisiableShootableActors(Actor playerActor, Array<Actor> foundActors)
    {
        ThinkerIterator actorFinder = ThinkerIterator.Create("Actor");
        Actor foundActor;
        while (foundActor = Actor(actorFinder.Next()))
        {
            if (!foundActor) { continue; }
            if (!foundActor.bShootable) { continue; }
            if (foundActor == playerActor) { continue; }
            if (!playerActor.IsVisible(foundActor, false)) { continue; }

            foundActors.push(foundActor);
        }
    }
}
