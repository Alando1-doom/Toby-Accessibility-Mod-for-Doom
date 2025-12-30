class Toby_MarkerExplorationUnexploredMenu : Toby_MarkerExplorationBaseMenu
{
    override Toby_MarkerDestinationCollection BuildCollection(Toby_ExplorationTracker tracker)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerExplorationMenuHelpers.CreateDestinationCollection(
            tracker,
            tracker.unexploredLines,
            GetIgnoreDistance()
        );
        return collection;
    }

    override bool MenuEvent(int key, bool fromController) {
        return Super.MenuEvent(key, fromController);
    }
}
