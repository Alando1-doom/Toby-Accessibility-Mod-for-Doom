class Toby_DropoffDetectorHandler : EventHandler
{
    override void PlayerSpawned (PlayerEvent e)
    {
        let player = players [e.PlayerNumber].mo;
        player.GiveInventory ("Toby_DropoffSoundEmitterManagerItem", 1);
    }
}
