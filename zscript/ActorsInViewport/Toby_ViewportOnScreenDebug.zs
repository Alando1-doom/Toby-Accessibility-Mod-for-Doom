class Toby_ViewportOnScreenDebug
{
    static ui void DrawText(string text, double posX, double posY, int fontColor)
    {
        double scale = 0.5;
        double alpha = 1.0;
        Screen.DrawText(smallFont,
                    fontColor,
                    posX * scale, //x
                    posY * scale, //y
                    text, //text
                    DTA_KeepRatio,        //doesn't adjust screen size for DTA_Virtual* if the aspect ratio is not 4:3 (?)
                    true, //???
                    DTA_VirtualWidth,    //pretend the canvas is this wide
                    int(scale * Screen.GetWidth()),
                    DTA_VirtualHeight,    //pretend the canvas is this tall
                    int(scale * Screen.GetHeight()),
                    DTA_Alpha,            //alpha value for translucency
                    alpha
                );
    }
}
