class Toby_MarkerExplorationMenuItem : Toby_MenuItemWithSoundQueue
{
    int distance;
    string direction;
    string className;
    string chessboardCoords;

    static Toby_MarkerExplorationMenuItem Create(
        int distance,
        string direction,
        string className,
        string chessboardCoords
    )
    {
        Toby_MarkerExplorationMenuItem menuItem = new("Toby_MarkerExplorationMenuItem");
        menuItem.distance = distance;
        menuItem.direction = direction;
        menuItem.className = className;
        menuItem.chessboardCoords = chessboardCoords;

        Toby_SoundBindingsLoaderStaticHandler bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();

        Toby_SoundQueue finalQueue = Toby_SoundQueue.Create();

        Toby_StringToSoundQueue stringSoundQueueBuilder = Toby_StringToSoundQueue.Create();
        Toby_SoundQueue directionSoundQueue = stringSoundQueueBuilder.CreateQueueFromDirection(direction);
        Toby_NumberToSoundQueue numberQueueBuilder = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueue distanceQueue = numberQueueBuilder.CreateQueueFromInt(distance);
        Toby_SoundQueue chessboardCoordsQueue = stringSoundQueueBuilder.CreateQueueFromText(chessboardCoords);

        if (className != "")
        {
            finalQueue.AddSound(GetActorSoundName(bindings.actorsInViewportSoundBindings, className), -1);
        }
        finalQueue.AddQueue(directionSoundQueue);
        finalQueue.AddQueue(distanceQueue);
        finalQueue.AddQueue(chessboardCoordsQueue);

        menuItem.SetSoundQueue(finalQueue);

        return menuItem;
    }

    private static string GetActorSoundName(Toby_SoundBindingsContainer bindings, string classNameToFind)
    {
        string soundToPlay = "";
        for (int i = 0; i < bindings.soundBindings.Size(); i++)
        {
            string className = bindings.soundBindings[i].At("ActorClass");
            if (classNameToFind == className)
            {
                soundToPlay = bindings.soundBindings[i].At("SoundToPlay");
            }
        }
        return soundToPlay;
    }

    override bool Activate()
    {
        Menu.MenuSound("menu/choose");
        if (command == "Toby_ResetPathfindingCommand")
        {
            EventHandler.SendNetworkEvent("Toby_StopPathfinding");
        }
        else
        {
            EventHandler.SendNetworkEvent("Toby_FindPathExploration:"..command);
        }

        CloseAllMenus();

        return true;
    }
}
