class Toby_SnapToTargetHandler : EventHandler
{
    override void NetworkProcess(ConsoleEvent e)
    {
        Actor playerActor = players[consoleplayer].mo;
        if (!playerActor) { return; }

        if (e.Name == "Toby_SnapToTarget")
        {
            ThinkerIterator actorFinder = ThinkerIterator.Create("Actor");

            Array<Actor> foundActors;
            Actor foundActor;
            while (foundActor = Actor(actorFinder.Next()))
            {
                if (!foundActor) { continue; }
                if (!foundActor.bShootable) { continue; }
                if (foundActor == playerActor) { continue; }
                if (!playerActor.IsVisible(foundActor, false)) { continue; }

                foundActors.push(foundActor);
                //console.printf(""..foundActor.GetClassName());
            }


            float maxDistance = 100000;
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
                console.printf(""..foundActors[i].GetClassName().." - Distance - "..vectorPlayerToMonster.Length());
            }
            if (!closestActor) { return; }
            playerActor.A_Face(closestActor);
            console.printf("Snap to target!");
        }
    }
}
