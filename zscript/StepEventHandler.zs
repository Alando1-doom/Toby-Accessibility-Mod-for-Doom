/*
	NOTES:
	
	the pythagoras'd player speed value (called "speed" in the code below) caps
	at 16.666667 or 21 when doing SR50 no matter the Player.ForwardMove or
	Player.SideMove value.
*/

class StepEventHandler : EventHandler
{
	// can probably be done without a magic number but it works for now
	const MAX_SPEED = 16.666667;
	
	// a wait timer for each player. when wait[i] hits 0 it plays a footstep
	private Array<double> wait;
	
	/*
	*	functions
	*/
	
	private String getStepSound(PlayerPawn pl)
	{
		String flat = TexMan.getName(pl.floorPic);
		Sound test = StringTable.localize("$_STEP_" .. flat).indexOf("_STEP_");
		
		if (test == "{ no sound }") {
			return "step/crete";
		}
		
		return StringTable.localize("$_STEP_" .. flat);
	}
	
	/*
	*	overrides
	*/
	
	override void worldLoaded(WorldEvent e)
	{
		for (int i = 0; i < players.size(); ++i) {			
			wait.insert(i, 1.0);
			Console.printf("%d", consolePlayer);
		}
		
		super.worldLoaded(e);
	}
	
	override void worldTick()
	{
		double speed;
		PlayerPawn pl;
		
		for (int i = 0; i < players.size(); ++i)
		{
			if (players[i].mo)
			{
				pl = players[i].mo;
				
				if (players[i].onground)
				{
					speed = clamp(sqrt(pl.vel.x * pl.vel.x + pl.vel.y * pl.vel.y),
								0.0, MAX_SPEED);
					
					// you can probably find out that this means that a sound is
					// only played when the player is moving > 2.0 speed
					if (speed > 2.0)
					{
						if (wait[i] <= 0.0)
						{
							pl.A_PlaySound(getStepSound(pl), CHAN_AUTO,
									clamp(speed / MAX_SPEED, 0.4, 1.0));
							wait[i] = 7.0 * clamp(MAX_SPEED / speed, 1.0, 1.5);
						}
						
						--wait[i];
					}
					else
					{
						wait[i] = 1.0;
					}
				}
				else // to create the "shuffling down stairs" effect
				{
					wait[i] = 0.0;
				}
			}
		}
		super.worldTick();
	}
	
	override void playerEntered(PlayerEvent e)
	{
		wait.insert(e.playerNumber, 1.0);
	}
	
	override void playerRespawned(PlayerEvent e)
	{
		wait[e.playerNumber] = 1.0;
	}
	
	override void playerDisconnected(PlayerEvent e)
	{
	}
	
}
