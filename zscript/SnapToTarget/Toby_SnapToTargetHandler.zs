class Toby_SnapToTargetHandler : EventHandler
{
    Toby_ClassIgnoreListLoaderStaticHandler classIgnoreListLoader;
    Array<bool> playerSnappingToTarget;
    Array<int> snappingMode;
    int maxPlayers;
    float maxDistance;

    override void OnRegister()
    {
        classIgnoreListLoader = Toby_ClassIgnoreListLoaderStaticHandler.GetInstance();
    }

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        maxDistance = 100000;
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            playerSnappingToTarget.push(false);
            snappingMode.push(0);
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
            SnapToNearestShootableActor(playerActor, i);
        }
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        if (e.Name == "Toby_SnapToTarget_KeyDown")
        {
            playerSnappingToTarget[e.Player] = true;
            snappingMode[e.Player] = CVar.GetCVar("Toby_SnapToTargetTargetingMode", players[e.Player]).GetInt();
        }
        if (e.Name == "Toby_SnapToTarget_KeyUp")
        {
            playerSnappingToTarget[e.Player] = false;
        }
    }

    private void SnapToNearestShootableActor(Actor playerActor, int playerNumber)
    {
        Array<Actor> foundActors;
        if (snappingMode[playerNumber] == TSTTTM_SHOOTABLE)
        {
            FindVisibleShootableActors(playerActor, foundActors);
        }
        if (snappingMode[playerNumber] == TSTTTM_MONSTER_COMBO)
        {
            FindMonsterComboActors(playerActor, foundActors);
        }
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

    private void FindVisibleShootableActors(Actor playerActor, Array<Actor> foundActors)
    {
        ThinkerIterator actorFinder = ThinkerIterator.Create("Actor");
        Actor foundActor;
        while (foundActor = Actor(actorFinder.Next()))
        {
            if (!foundActor) { continue; }
            if (!foundActor.bShootable) { continue; }
            if (foundActor == playerActor) { continue; }
            if (!playerActor.IsVisible(foundActor, false)) { continue; }
            if (classIgnoreListLoader.IsInIgnoreList(foundActor, classIgnoreListLoader.snapToTargetIgnoreList)) { continue; }

            foundActors.push(foundActor);
        }
    }

    private void FindMonsterComboActors(Actor playerActor, Array<Actor> foundActors)
    {
        ThinkerIterator actorFinder = ThinkerIterator.Create("Actor");
        Actor foundActor;
        while (foundActor = Actor(actorFinder.Next()))
        {
            if (!foundActor) { continue; }
            if (!foundActor.bSHOOTABLE) { continue; }
            if (!foundActor.bCOUNTKILL) { continue; }
            if (!foundActor.bSOLID) { continue; }
            if (!foundActor.bCANPUSHWALLS) { continue; }
            if (!foundActor.bCANUSEWALLS) { continue; }
            if (!foundActor.bACTIVATEMCROSS) { continue; }
            if (!foundActor.bCANPASS) { continue; }
            if (!foundActor.bISMONSTER) { continue; }
            if (foundActor == playerActor) { continue; }
            if (!playerActor.IsVisible(foundActor, false)) { continue; }
            if (classIgnoreListLoader.IsInIgnoreList(foundActor, classIgnoreListLoader.snapToTargetIgnoreList)) { continue; }

            foundActors.push(foundActor);
        }
    }
}
