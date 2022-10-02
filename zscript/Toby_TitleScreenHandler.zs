class Toby_TitleScreenHandler : EventHandler
{
    string levelChecksum;

    override void WorldLoaded(WorldEvent e)
    {
        levelChecksum = level.GetChecksum();
        Toby_Logger.Message("Map checksum: "..levelChecksum, "Toby_Developer");
    }

    override void RenderOverlay(RenderEvent e)
    {
        string titlemapChecksum = "8596787f9daad2bf1a1b129f6d724619";
        if (levelChecksum != titlemapChecksum) { return; }
        TextureId titlePic = TexMan.CheckForTexture("TITLEPIC");
        if (!titlepic.IsValid())
        {
            titlePic = TexMan.CheckForTexture("TITLE");
        }
        int titlePicWidth;
        int titlePicHeight;
        [titlePicWidth, titlePicHeight] = TexMan.GetSize(titlePic);
        int screenWidth = Screen.GetWidth();
        int screenHeight = Screen.GetHeight();
        int posX = 0;
        int posY = 0;
        int virtualWidth;
        int virtualHeight;
        float ratio;
        if (titlePicHeight < screenHeight)
        {
            virtualHeight = screenHeight;
            ratio = screenHeight/titlePicHeight;
            virtualWidth = titlePicWidth * ratio;
        }
        else
        {
            virtualWidth = screenWidth;
            ratio = screenWidth/titlePicWidth;
            virtualHeight = titlePicHeight * ratio;
        }
        //It seems like I need an additional width correction.
        //0.9 is a magic number. It should be 0.83333 (1/1.2) but for some reason it isn't.
        virtualWidth = virtualWidth * 0.9;
        posX = (screenWidth - virtualWidth) / 2;
        posY = (screenHeight - virtualHeight) / 2;
        Screen.DrawTexture(titlePic, false, posX, posY, DTA_KeepRatio, false, DTA_DESTWIDTH, virtualWidth, DTA_DESTHEIGHT, virtualHeight);
    }
}
