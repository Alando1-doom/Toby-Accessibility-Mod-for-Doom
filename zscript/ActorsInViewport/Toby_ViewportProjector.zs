class Toby_ViewportProjector
{
    Toby_Le_ProjScreen projection;
    bool canProject;
    Toby_Le_Viewport viewport;
    private Toby_Le_GlScreen glProjection;
    private Toby_Le_SwScreen swProjection;
    private transient Cvar cvarRenderer;

    static Toby_ViewportProjector Create()
    {
        Toby_ViewportProjector projector = new("Toby_ViewportProjector");
        projector.glProjection = new("Toby_Le_GlScreen");
        projector.swProjection = new("Toby_Le_SwScreen");
        projector.cvarRenderer = Cvar.GetCvar("vid_rendermode", players[consoleplayer]);
        projector.PrepareProjection();

        return projector;
    }

    // kd: This selects the correct projector for your renderer and determines
    // whether you can even do a projection.
    void PrepareProjection()
    {
        if(cvarRenderer)
        switch(cvarRenderer.GetInt())
        {
            default:
                projection = glProjection;
                break;
            case 0:
            case 1:
                projection = swProjection;
                break;
        }
        else
        {
            projection = glProjection;
        }

        canProject = projection != NULL;
    }
}
