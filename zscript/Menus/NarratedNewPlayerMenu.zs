class NarratedNewPlayerMenu : NewPlayerMenu
{
    override bool MenuEvent (int mkey, bool fromcontroller)
	{
        Super.MenuEvent(mkey, fromcontroller);
        //MenuEventProcessor.Process(self, mkey);
        return true;
    }
}