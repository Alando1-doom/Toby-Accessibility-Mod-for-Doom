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
        if (e.Name == "Toby_180_Turn_KeyDown")
        {
            players[e.Player].mo.angle += 180;
            EventHandler.SendInterfaceEvent(e.Player, "Toby_180TurnInterface");
        }
    }
}
