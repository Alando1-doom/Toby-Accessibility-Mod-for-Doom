class Toby_ActorFilterHorizontalScreenPosition: Toby_ActorFilter
{
    private Toby_ViewportProjector projector;
    private double min;
    private double max;

    static Toby_ActorFilterHorizontalScreenPosition Create(string name, Toby_ViewportProjector projector, double min, double max)
    {
        Toby_ActorFilterHorizontalScreenPosition filter = new("Toby_ActorFilterHorizontalScreenPosition");
        filter.name = name;
        filter.projector = projector;
        filter.min = min;
        filter.max = max;
        return filter;
    }

    override bool CheckCondition(Actor actorToFilter)
    {
        projector.projection.projectActorPos(actorToFilter, (0, 0, actorToFilter.height/2), 1.0);
        let normalPos = projector.projection.projectToNormal();
        let screenPos = projector.viewport.SceneToWindow(normalPos);

        double screenPosXNormalized = screenPos.x / Screen.GetWidth();

        bool result = screenPosXNormalized > min && screenPosXNormalized <= max;
        return result;
    }
}
