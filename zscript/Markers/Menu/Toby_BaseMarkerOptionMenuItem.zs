class Toby_BaseMarkerOptionMenuItem : OptionMenuItem
{
    string command;

    Toby_BaseMarkerOptionMenuItem Init(string label, string command)
    {
        Super.Init(label, command);
        self.command = command;
        return self;
    }

    override int Draw(OptionMenuDescriptor d, int y, int indent, bool selected) {
        drawLabel(indent, y, Font.CR_GOLD);
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
