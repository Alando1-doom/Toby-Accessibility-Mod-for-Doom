class Toby_MarkerExplorationPickupsMenu : Toby_MarkerExplorationBaseMenu
{
    override Toby_MarkerDestinationCollection BuildCollection(Toby_ExplorationTracker tracker)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerExplorationMenuHelpers.CreateDestinationCollectionPickups(
            tracker,
            GetIgnoreDistance()
        );
        return collection;
    }
}
