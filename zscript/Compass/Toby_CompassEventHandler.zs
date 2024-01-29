class Toby_CompassEventHandler: EventHandler
{
    override void InterfaceProcess(ConsoleEvent e)
    {
        if (e.Name == "Toby_180TurnInterface")
        {
            S_StartSound("compass/180turn", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
        }
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }
        if (e.Name == "Toby_180_Turn_KeyDown")
        {
            playerActor.A_SetAngle(playerActor.angle + 180, SPF_INTERPOLATE);
            EventHandler.SendInterfaceEvent(e.Player, "Toby_180TurnInterface");
        }
    }
}
