class Toby_MarkerExplorationKeysMenu : Toby_MarkerExplorationBaseMenu
{
    override Toby_MarkerDestinationCollection BuildCollection(Toby_ExplorationTracker tracker)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerExplorationMenuHelpers.CreateDestinationCollectionKeys(
            tracker,
            GetIgnoreDistance()
        );
        return collection;
    }
}
