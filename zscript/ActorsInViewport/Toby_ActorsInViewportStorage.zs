class Toby_ActorsInViewportStorage
{
    Array<Actor> actorsThatCanSeePlayer;

    static Toby_ActorsInViewportStorage Create()
    {
        Toby_ActorsInViewportStorage storage = new("Toby_ActorsInViewportStorage");
        return storage;
    }

    play void GetActorsThatCanSeePlayer(Actor playerActor)
    {
        actorsThatCanSeePlayer.Clear();

        ThinkerIterator ti = ThinkerIterator.Create();
        Actor actorThatCanSeePlayer;
        while (actorThatCanSeePlayer = Actor(ti.Next()))
        {
            if (!actorThatCanSeePlayer.IsVisible(playerActor, true))
            {
                continue;
            }
            actorsThatCanSeePlayer.push(actorThatCanSeePlayer);
        }
    }
}
