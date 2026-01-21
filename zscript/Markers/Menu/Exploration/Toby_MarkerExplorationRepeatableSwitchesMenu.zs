class Toby_MarkerExplorationRepeatableSwitchesMenu : Toby_MarkerExplorationBaseMenu
{
    override Toby_MarkerDestinationCollection BuildCollection(Toby_ExplorationTracker tracker)
    {
        Toby_MarkerDestinationCollection collection = Toby_MarkerExplorationMenuHelpers.CreateDestinationCollectionRepeatableSwitches(
            tracker,
            GetIgnoreDistance(),
            false
        );
        return collection;
    }
}
