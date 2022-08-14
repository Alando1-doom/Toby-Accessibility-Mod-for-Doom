class Toby_MenuStaticHandler : StaticEventHandler
{
    ui string currentMenuName;
    ui string lastMenuName;

    ui Toby_MenuState currentMenuState;
    ui Toby_MenuState previousMenuState;
    ui Toby_MenuEventProcessor menuEventProcessor;
    ui bool isNotFirstRun;

    ui Toby_MenuSoundBindingsContainer menuSoundBindingsContainer;

    override void OnRegister()
    {
        console.printf("Static event handler registered!");
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
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            currentMenuState = new("Toby_MenuState");
            previousMenuState = new("Toby_MenuState");
            currentMenuState.SetNullState();
            previousMenuState.SetNullState();
            menuSoundBindingsContainer = new("Toby_MenuSoundBindingsContainer");
            menuSoundBindingsContainer.Init();
            menuEventProcessor = new("Toby_MenuEventProcessor");
            menuEventProcessor.Init(menuSoundBindingsContainer);
        }

        Menu currentMenu = Menu.GetCurrentMenu();
        currentMenuState.UpdateMenuState(currentMenu);
        int detectedChange = currentMenuState.DetectChanges(previousMenuState);
        if (detectedChange > 0)
        {
            menuEventProcessor.Process(currentMenuState, previousMenuState, detectedChange);
        }
        currentMenuState.CopyValuesTo(previousMenuState);
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
