class Toby_BaseMenuItem : OptionMenuItem
{
    string command;

    Toby_BaseMenuItem Init(string label, string command)
    {
        Super.Init(label, command);
        self.command = command;
        return self;
    }

    override int Draw(OptionMenuDescriptor d, int y, int indent, bool selected) {
        DrawLabel(indent, y, Font.CR_GOLD);
        return indent;
    }

    void CloseAllMenus()
    {
        let curmenu = Menu.GetCurrentMenu();
        while (curmenu)
        {
            curmenu.Close();
            curmenu = Menu.GetCurrentMenu();
        }
    }
}
