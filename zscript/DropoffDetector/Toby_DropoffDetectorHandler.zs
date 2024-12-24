class Toby_DropoffDetectorHandler : EventHandler
{
    Toby_ClassIgnoreListLoaderStaticHandler wallHitIgnoreListLoader;

    override void OnRegister()
    {
        wallHitIgnoreListLoader = Toby_ClassIgnoreListLoaderStaticHandler.GetInstance();
    }

    override void PlayerSpawned(PlayerEvent e)
    {
        Actor playerActor = players[e.PlayerNumber].mo;
        playerActor.GiveInventory("Toby_DropoffSoundEmitterManagerItem", 1);

        Toby_DropoffSoundEmitterManagerItem manager = Toby_DropoffSoundEmitterManagerItem(playerActor.FindInventory("Toby_DropoffSoundEmitterManagerItem"));
        manager.SetHandlerReference(self);
    }
}
