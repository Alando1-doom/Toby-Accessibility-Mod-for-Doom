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

        Toby_ActorFilter remainsFilter = Toby_ActorFilterRemains.Create("Remains");
        Toby_ActorFilter notRemainsFilter = Toby_ActorFilterLogicNot.Create("Not_Remains", remainsFilter);

        Toby_ActorFilter distanceCloseFilter = Toby_ActorFilterDistance.Create("Distance_Close", playerActor, 0, distanceClose);
        Toby_ActorFilter distanceMeduimFilter = Toby_ActorFilterDistance.Create("Distance_Medium", playerActor, distanceClose, distanceMedium);
        Toby_ActorFilter distanceFarFilter = Toby_ActorFilterDistance.Create("Distance_Far", playerActor, distanceMedium, int.Max);
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
        filters.push(Toby_ActorFilterLogicAnd.Create("All_Remains", allFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("All_NotRemains", allFilter, notRemainsFilter));

        filters.push(distanceCloseFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Distance_Close_Remains", distanceCloseFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Distance_Close_NotRemains", distanceCloseFilter, notRemainsFilter));
        filters.push(distanceMeduimFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Distance_Medium_Remains", distanceMeduimFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Distance_Medium_NotRemains", distanceMeduimFilter, notRemainsFilter));
        filters.push(distanceFarFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Distance_Far_Remains", distanceFarFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Distance_Far_NotRemains", distanceFarFilter, notRemainsFilter));

        filters.push(screenLeftFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Left_Remains", screenLeftFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Left_NotRemains", screenLeftFilter, notRemainsFilter));
        filters.push(screenFrontFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Front_Remains", screenFrontFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Front_NotRemains", screenFrontFilter, notRemainsFilter));
        filters.push(screenRightFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Right_Remains", screenRightFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Right_NotRemains", screenRightFilter, notRemainsFilter));

        filters.push(screenLeftCloseFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Close_Remains", screenLeftCloseFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Close_NotRemains", screenLeftCloseFilter, notRemainsFilter));
        filters.push(screenLeftMediumFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Medium_Remains", screenLeftMediumFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Medium_NotRemains", screenLeftMediumFilter, notRemainsFilter));
        filters.push(screenLeftFarFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Far_Remains", screenLeftFarFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Left_Distance_Far_NotRemains", screenLeftFarFilter, notRemainsFilter));

        filters.push(screenFrontCloseFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Close_Remains", screenFrontCloseFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Close_NotRemains", screenFrontCloseFilter, notRemainsFilter));
        filters.push(screenFrontMediumFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Medium_Remains", screenFrontMediumFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Medium_NotRemains", screenFrontMediumFilter, notRemainsFilter));
        filters.push(screenFrontFarFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Far_Remains", screenFrontFarFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Front_Distance_Far_NotRemains", screenFrontFarFilter, notRemainsFilter));

        filters.push(screenRightCloseFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Close_Remains", screenRightCloseFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Close_NotRemains", screenRightCloseFilter, notRemainsFilter));
        filters.push(screenRightMediumFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Medium_Remains", screenRightMediumFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Medium_NotRemains", screenRightMediumFilter, notRemainsFilter));
        filters.push(screenRightFarFilter);
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Far_Remains", screenRightFarFilter, remainsFilter));
        filters.push(Toby_ActorFilterLogicAnd.Create("Screen_Right_Distance_Far_NotRemains", screenRightFarFilter, notRemainsFilter));
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
