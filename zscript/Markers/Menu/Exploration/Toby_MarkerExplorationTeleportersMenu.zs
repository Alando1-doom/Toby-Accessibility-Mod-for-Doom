class Toby_MarkerExplorationTeleportersMenu : Toby_MarkerExplorationBaseMenu
{
    override Toby_MarkerDestinationCollection BuildCollection(Toby_ExplorationTracker tracker)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerExplorationMenuHelpers.CreateDestinationCollectionTeleportLines(
            tracker,
            tracker.exploredLines,
            GetIgnoreDistance(),
            false
        );
        return collection;
    }

    override bool MenuEvent(int key, bool fromController) {
        return Super.MenuEvent(key, fromController);
    }
}
