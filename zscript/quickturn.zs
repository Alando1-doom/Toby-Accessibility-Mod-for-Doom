class Toby_QuickTurnHandler : EventHandler
{
    override void PlayerEntered(PlayerEvent e)
    {
        let playerActor = players[e.PlayerNumber].mo;
        if (!playerActor.FindInventory("Toby_QuickTurnItem"))
        {
            playerActor.GiveInventory("Toby_QuickTurnItem", 1);
        }
    }
}
class Toby_QuickTurnItem : Inventory
{
    override void DoEffect()
    {
        Super.DoEffect();
        if (!owner || !owner.player)
        {
            Destroy();
            return;
        }
        if (owner.player.turnticks > 0 && owner.player.cmd.buttons & BT_TURN180 && !(owner.player.oldbuttons & BT_TURN180))
        {
            if (CVar.GetCVar("Toby_NarrationOutputType", owner.player).GetInt() == TNOT_CONSOLE)
            {
                Toby_Logger.ConsoleOutputModeMessage("Quickturn");
            }
            else
            {
                owner.A_StartSound("misc/quickturn", CHAN_AUTO, CHANF_DEFAULT, 1.0, ATTN_STATIC, 0, 0);
            }
        }
    }
}
