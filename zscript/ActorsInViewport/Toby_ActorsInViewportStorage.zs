class Toby_ActorsInViewportStorage
{
    Array<Actor> actorsThatCanSeePlayer;

    Array<Toby_ActorsFilter> filters;

    static Toby_ActorsInViewportStorage Create()
    {
        Toby_ActorsInViewportStorage storage = new("Toby_ActorsInViewportStorage");
        return storage;
    }

    void ResetFilters(Actor playerActor, Toby_ViewportProjector projector, double fractic)
    {
        for (int i = 0; i < filters.Size(); i++)
        {
            filters[i].ResetFilter();
        }
        filters.Clear();

        int distanceClose = 200;
        int distanceMedium = 1000;
        Toby_DistanceFilter distanceCloseFilter = Toby_DistanceFilter.Create("Distance_Close", playerActor, 0, distanceClose);
        Toby_DistanceFilter distanceMeduimFilter = Toby_DistanceFilter.Create("Distance_Medium", playerActor, distanceClose, distanceMedium);
        Toby_DistanceFilter distanceFarFilter = Toby_DistanceFilter.Create("Distance_Close", playerActor, distanceMedium, int.Max);
        Toby_HorizontalScreenPositionFilter screenLeftFilter = Toby_HorizontalScreenPositionFilter.Create("Screen_Left", projector, fractic, 0, 0.33);
        Toby_HorizontalScreenPositionFilter screenFrontFilter = Toby_HorizontalScreenPositionFilter.Create("Screen_Front", projector, fractic, 0.33, 0.66);
        Toby_HorizontalScreenPositionFilter screenRightFilter = Toby_HorizontalScreenPositionFilter.Create("Screen_Right", projector, fractic, 0.66, 1);

        filters.push(Toby_AllFilter.Create("All"));
        filters.push(distanceCloseFilter);
        filters.push(distanceMeduimFilter);
        filters.push(distanceFarFilter);
        filters.push(screenLeftFilter);
        filters.push(screenFrontFilter);
        filters.push(screenRightFilter);
        filters.push(Toby_FilterAnd.Create("Screen_Left_Distance_Close", screenLeftFilter, distanceCloseFilter));
        filters.push(Toby_FilterAnd.Create("Screen_Left_Distance_Medium", screenLeftFilter, distanceMeduimFilter));
        filters.push(Toby_FilterAnd.Create("Screen_Left_Distance_Far", screenLeftFilter, distanceFarFilter));

        filters.push(Toby_FilterAnd.Create("Screen_Front_Distance_Close", screenFrontFilter, distanceCloseFilter));
        filters.push(Toby_FilterAnd.Create("Screen_Front_Distance_Medium", screenFrontFilter, distanceMeduimFilter));
        filters.push(Toby_FilterAnd.Create("Screen_Front_Distance_Far", screenFrontFilter, distanceFarFilter));

        filters.push(Toby_FilterAnd.Create("Screen_Right_Distance_Close", screenRightFilter, distanceCloseFilter));
        filters.push(Toby_FilterAnd.Create("Screen_Right_Distance_Medium", screenRightFilter, distanceMeduimFilter));
        filters.push(Toby_FilterAnd.Create("Screen_Right_Distance_Far", screenRightFilter, distanceFarFilter));
    }

    void FilterActor(Actor actorToFilter)
    {
        for (int i = 0; i < filters.Size(); i++)
        {
            filters[i].Filter(actorToFilter);
        }
    }

    Toby_ActorsFilter GetFilterByName(string name)
    {
        Toby_ActorsFilter filter = null;
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
