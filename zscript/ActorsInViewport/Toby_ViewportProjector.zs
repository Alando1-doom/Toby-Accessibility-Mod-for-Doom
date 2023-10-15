class Toby_ViewportProjector
{
    Toby_Le_ProjScreen proj;
    bool canProject;
    Toby_Le_Viewport viewport;
    private Toby_Le_GlScreen glProj;
    private Toby_Le_SwScreen swProj;
    private transient Cvar cvarRenderer;

    static Toby_ViewportProjector Create()
    {
        Toby_ViewportProjector projector = new("Toby_ViewportProjector");
        projector.glProj = new("Toby_Le_GlScreen");
        projector.swProj = new("Toby_Le_SwScreen");
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
                proj = glProj;
                break;
            case 0:
            case 1:
                proj = swProj;
                break;
        }
        else
        {
            proj = glProj;
        }

        canProject = proj != NULL;
    }
}
