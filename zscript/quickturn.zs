Class Toby_QuickTurnHandler : EventHandler
{
	Override void PlayerEntered(PlayerEvent e)
	{
		let playe = players[e.PlayerNumber].mo;
		If(!playe.FindInventory("Toby_QuickTurnItem")){playe.GiveInventory("Toby_QuickTurnItem",1);}
	}
}
Class Toby_QuickTurnItem : Inventory
{
	Override void DoEffect()
	{
		Super.DoEffect();
		If(!owner || !owner.player){Destroy(); Return;}
		If(owner.player.turnticks>0 && owner.player.cmd.buttons & BT_TURN180 && !(owner.player.oldbuttons & BT_TURN180))
		{
			owner.A_StartSound("misc/quickturn", CHAN_AUTO, CHANF_DEFAULT, 1.0, ATTN_STATIC, 0, 0);
		}
	}
}