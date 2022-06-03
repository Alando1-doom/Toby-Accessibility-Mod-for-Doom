class NarratedOptionMenu : OptionMenu
{
	override bool MenuEvent (int mkey, bool fromcontroller)
	{
        Super.MenuEvent(mkey, fromcontroller);
        MenuEventProcessor.Process(self, mKey);
        return true;
    }
}