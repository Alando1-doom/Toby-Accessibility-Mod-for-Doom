class Toby_MenuInjectorStaticHandler : StaticEventHandler
{
    ui string currentMenuName;
    ui string lastMenuName;

    override void OnRegister()
    {
        console.printf("Static event handler registered!");
    }

    override bool UiProcess(UiEvent e)
    {
        if (lastMenuName == "")
        {
            lastMenuName = "null";
        }
        currentMenuName = "null";
        Menu currentMenu = Menu.GetCurrentMenu();
        if (currentMenu)
        {
            currentMenuName = currentMenu.GetClassName();
            MenuEventProcessor.Process(currentMenu, KeyCharToMKey(e.KeyChar));
        }
        if (!currentMenu && IsUiProcessor)
        {
            EventHandler.SendNetworkEvent("Toby_DisableUiProcessor");
        }
        lastMenuName = currentMenuName;
        return false;
    }

    override void NetworkProcess (ConsoleEvent e)
    {
        if (e.Player != consoleplayer) { return; }
        if (e.Name == "Toby_EnableUiProcessor")
        {
            IsUiProcessor = true;
            return;
        }
        if (e.Name == "Toby_DisableUiProcessor")
        {
            IsUiProcessor = false;
            return;
        }
    }

    override void UITick()
    {
        Menu currentMenu = Menu.GetCurrentMenu();
        currentMenuName = "null";
        if (currentMenu)
        {
            currentMenuName = currentMenu.GetClassName();
        }
        if (currentMenu && !IsUiProcessor)
        {
            EventHandler.SendNetworkEvent("Toby_EnableUiProcessor");
        }
    }

    ui int KeyCharToMKey(int keyChar)
    {
        int mKey = -1;
        if (keyChar == UiEvent.Key_Return) mKey = Menu.MKEY_Enter;
        if (keyChar == UiEvent.Key_Escape) mKey = Menu.MKEY_Back;
        if (keyChar == UiEvent.Key_Up) mKey = Menu.MKEY_Up;
        if (keyChar == UiEvent.Key_Down) mKey = Menu.MKEY_Down;
        if (keyChar == UiEvent.Key_Left) mKey = Menu.MKEY_Left;
        if (keyChar == UiEvent.Key_Right) mKey = Menu.MKEY_Right;
        if (keyChar == UiEvent.Key_PgUp) mKey = Menu.MKEY_PageUp;
        if (keyChar == UiEvent.Key_PgDn) mKey = Menu.MKEY_PageDown;
        if (keyChar == UiEvent.Key_Backspace) mKey = Menu.MKEY_Clear;
        return mKey;
    }
}