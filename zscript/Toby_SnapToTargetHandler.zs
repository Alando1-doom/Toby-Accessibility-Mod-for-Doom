class Toby_SnapToTargetHandler : EventHandler
{
    override void NetworkProcess(ConsoleEvent e)
    {
        Actor playerActor = players[consoleplayer].mo;
        if (!playerActor) { return; }

        if (e.Name == "Toby_SnapToTarget")
        {
            SnapToNearestShootableActor(playerActor);
        }
    }

    private void SnapToNearestShootableActor(Actor playerActor)
    {
        Array<Actor> foundActors;
        float maxDistance = 100000;
        FindVisiableShootableActors(playerActor, foundActors);
        Actor closestActor = FindClosestShootableActor(playerActor, foundActors, maxDistance);
        if (!closestActor) { return; }
        playerActor.A_Face(closestActor);
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
