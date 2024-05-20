class Toby_MenuStaticHandler : StaticEventHandler
{
    ui string currentMenuName;
    ui string lastMenuName;

    ui Toby_MenuState currentMenuState;
    ui Toby_MenuState previousMenuState;
    ui Toby_MenuEventProcessor menuEventProcessor;
    ui bool isNotFirstRun;
    ui Toby_SoundBindingsLoaderStaticHandler bindings;

    ui int lastKeyPressed;

    override void OnRegister()
    {
        IsUiProcessor = false;
        Toby_Logger.Message("Toby_MenuStaticHandler registered!", "Toby_Developer");
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        if (e.Player != consoleplayer) { return; }
        if (e.Name == "Toby_EnableUiProcessor")
        {
            Toby_Logger.Message("UiProcessor Enabled", "Toby_Developer");
            IsUiProcessor = true;
            return;
        }
        if (e.Name == "Toby_DisableUiProcessor")
        {
            Toby_Logger.Message("UiProcessor Disabled", "Toby_Developer");
            IsUiProcessor = false;
            return;
        }
    }

    override bool UiProcess(UiEvent e)
    {
        lastKeyPressed = e.keyChar;
        return false;
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            InitAccessibleMenus();
        }

        Menu currentMenu = Menu.GetCurrentMenu();
        currentMenuState.UpdateMenuState(currentMenu, lastKeyPressed);

        int detectedChange = currentMenuState.DetectChanges(previousMenuState);
        HandleUiProcessor(detectedChange);

        if (detectedChange > 0)
        {
            menuEventProcessor.Process(currentMenuState, previousMenuState, detectedChange);
        }
        lastKeyPressed = -1;
        currentMenuState.CopyValuesTo(previousMenuState);
    }

    ui void InitAccessibleMenus()
    {
        isNotFirstRun = true;
        lastKeyPressed = -1;
        currentMenuState = new("Toby_MenuState");
        previousMenuState = new("Toby_MenuState");
        currentMenuState.SetNullState();
        previousMenuState.SetNullState();
        bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();

        menuEventProcessor = new("Toby_MenuEventProcessor");
        menuEventProcessor.Create(bindings.menuSoundBindingsContainer);
    }

    ui void HandleUiProcessor(int detectedChange)
    {
        if (detectedChange == Toby_MenuState.MenuDismissed
            || detectedChange == Toby_MenuState.GameSaved
            || detectedChange == Toby_MenuState.GameLoaded
            || detectedChange == Toby_MenuState.GameStarted
            || (
                //This accounts for entering a key in keybinds menu
                detectedChange == Toby_MenuState.MenuChanged
                && currentMenuState.menuClass == "EnterKey")
            )
        {
            EventHandler.SendNetworkEvent("Toby_DisableUiProcessor");
            Toby_Logger.Message("SentNetworkEvent - Toby_DisableUiProcessor", "Toby_Developer");
        }
        if (detectedChange == Toby_MenuState.MenuChanged
            && ((
                previousMenuState.menuClass == "null"
                && currentMenuState.menuClass != "null")
            || (
                //This accounts for entering a key in keybinds menu
                currentMenuState.menuName == "ActionControlsMenu"
                && previousMenuState.menuClass == "EnterKey")
            ))
        {
            EventHandler.SendNetworkEvent("Toby_EnableUiProcessor");
            Toby_Logger.Message("SentNetworkEvent - Toby_EnableUiProcessor", "Toby_Developer");
        }
    }
}
