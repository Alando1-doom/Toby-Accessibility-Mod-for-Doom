class Toby_ActorsInViewportStorage
{
    Array<Actor> actorsThatCanSeePlayer;

    Array<Toby_ActorFilter> filters;

    static Toby_ActorsInViewportStorage Create()
    {
        Toby_ActorsInViewportStorage storage = new("Toby_ActorsInViewportStorage");
        return storage;
    }

    void ResetFilters(Actor playerActor, Toby_ViewportProjector projector)
    {
        for (int i = 0; i < filters.Size(); i++)
        {
            filters[i].ResetFilter();
        }
        filters.Clear();

        int distanceClose = 200;
        int distanceMedium = 1000;

        Toby_ActorFilter allFilter = Toby_ActorFilterAll.Create("All");

        Toby_ActorFilter distanceCloseFilter = Toby_ActorFilterDistance.Create("Distance_Close", playerActor, 0, distanceClose);
        Toby_ActorFilter distanceMeduimFilter = Toby_ActorFilterDistance.Create("Distance_Medium", playerActor, distanceClose, distanceMedium);
        Toby_ActorFilter distanceFarFilter = Toby_ActorFilterDistance.Create("Distance_Close", playerActor, distanceMedium, int.Max);
        Toby_ActorFilter screenLeftFilter = Toby_ActorFilterHorizontalScreenPosition.Create("Screen_Left", projector, 0, 0.33);
        Toby_ActorFilter screenFrontFilter = Toby_ActorFilterHorizontalScreenPosition.Create("Screen_Front", projector, 0.33, 0.66);
        Toby_ActorFilter screenRightFilter = Toby_ActorFilterHorizontalScreenPosition.Create("Screen_Right", projector, 0.66, 1);

        Toby_ActorFilter screenLeftCloseFilter = Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Close", screenLeftFilter, distanceCloseFilter);
        Toby_ActorFilter screenLeftMediumFilter = Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Medium", screenLeftFilter, distanceMeduimFilter);
        Toby_ActorFilter screenLeftFarFilter = Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Far", screenLeftFilter, distanceFarFilter);

        Toby_ActorFilter screenFrontCloseFilter = Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Close", screenFrontFilter, distanceCloseFilter);
        Toby_ActorFilter screenFrontMediumFilter = Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Medium", screenFrontFilter, distanceMeduimFilter);
        Toby_ActorFilter screenFrontFarFilter = Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Far", screenFrontFilter, distanceFarFilter);

        Toby_ActorFilter screenRightCloseFilter = Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Close", screenRightFilter, distanceCloseFilter);
        Toby_ActorFilter screenRightMediumFilter = Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Medium", screenRightFilter, distanceMeduimFilter);
        Toby_ActorFilter screenRightFarFilter = Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Far", screenRightFilter, distanceFarFilter);

        filters.push(allFilter);
        filters.push(distanceCloseFilter);
        filters.push(distanceMeduimFilter);
        filters.push(distanceFarFilter);
        filters.push(screenLeftFilter);
        filters.push(screenFrontFilter);
        filters.push(screenRightFilter);
        filters.push(screenLeftCloseFilter);
        filters.push(screenLeftMediumFilter);
        filters.push(screenLeftFarFilter);

        filters.push(screenFrontCloseFilter);
        filters.push(screenFrontMediumFilter);
        filters.push(screenFrontFarFilter);

        filters.push(screenRightCloseFilter);
        filters.push(screenRightMediumFilter);
        filters.push(screenRightFarFilter);
    }

    void FilterActor(Actor actorToFilter)
    {
        for (int i = 0; i < filters.Size(); i++)
        {
            filters[i].Filter(actorToFilter);
        }
    }

    Toby_ActorFilter GetFilterByName(string name)
    {
        Toby_ActorFilter filter = null;
        for (int i = 0; i < filters.Size(); i++)
        {
            if (filters[i].name == name)
            {
                filter = filters[i];
                break;
            }
        }
        return filter;
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
