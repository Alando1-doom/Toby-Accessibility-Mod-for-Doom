//This is where to look for menu classes to override their behavior: https://github.com/coelckers/gzdoom/tree/master/wadsrc/static/zscript/engine/ui/menu
class NarratedListMenu : ListMenu
{
	override bool MenuEvent (int mkey, bool fromcontroller)
	{
		Super.MenuEvent(mkey, fromcontroller);
		MenuEventProcessor.Process(self, mKey);
        return true;
	}
}