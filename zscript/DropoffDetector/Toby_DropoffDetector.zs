class LineTracerGiver : EventHandler
{
	override void PlayerSpawned (PlayerEvent e)
	{
		//Get player actor that spawned in world
		let player = players [e.PlayerNumber].mo;
		//Give an item to them
		player.GiveInventory ("LineTracerItem", 1);
	}
}

class ltSoundEmitter : Actor
{
	Default
	{
		+DONTSPLASH
	}
	states
	{
		spawn:
			TNT1 A 30;
			loop;
		wall:
			TNT1 A 30 A_StartSound("misc/i_pkup", CHAN_AUTO, CHANF_DEFAULT, 1.0, 10);
			loop;
		dropoffSpot:
			TNT1 A 5 A_StartSound("dropoff/beacon", CHAN_AUTO, CHANF_DEFAULT, 1.0, 1);
			loop;
		lineSwitch:
			TNT1 A 20;
			TNT1 A 7 A_StartSound("misc/p_pkup", CHAN_AUTO, CHANF_DEFAULT, 1.0, 4);
			TNT1 A 7 A_StartSound("misc/p_pkup", CHAN_AUTO, CHANF_DEFAULT, 1.0, 4);
			loop;
	}
}

class LineTracerItem : Inventory
{
	default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
	}

	//Variables that will store pointers to the sound emitting actors
	Actor frontEmitter;
	//Actor leftEmitter;
	//Actor rightEmitter;
	//Actor backEmitter;

	//This function creates sound emitters as soon as this object is created
	override void BeginPlay()
	{
		frontEmitter = Actor.Spawn('ltSoundEmitter',(0,0,0));
		//leftEmitter = Actor.Spawn('ltSoundEmitter',(0,0,0));
		//rightEmitter = Actor.Spawn('ltSoundEmitter',(0,0,0));
		//backEmitter = Actor.Spawn('ltSoundEmitter',(0,0,0));
	}

	//This item will do this action on each tick.
	//I'm using it to call LineTrace function
	//You can read about it here: https://zdoom.org/wiki/LineTrace
	override void Tick()
	{
		super.Tick();
		If(!frontEmitter){frontEmitter = Actor.Spawn('ltSoundEmitter',(0,0,0));}
		Else
		{
		int traceDistance = 88;

		FLineTraceData dFront;
		//FLineTraceData dLeft;
		//FLineTraceData dRight;
		//FLineTraceData dBack;
		owner.LineTrace(
			owner.angle, //owner is a player actor, we use it's angle and pitch to draw the line
			traceDistance, //maximum detection distance
			0, //pitch. Zero is level with the ground
			TRF_SOLIDACTORS|TRF_BLOCKSELF,//First flag allows detecting solid actor obstacles, second - stops at player blocking lines
			0, //offsetz for the starting point of the line trace, I'm starting at player height - Modified to be lower.
			data:dFront); //variable that will store information about everything hit by linetrace

		//I've traced 4 lines this time: in front of the player, leftside, rightside and behind
		//owner.LineTrace(owner.angle+90, traceDistance, 0, TRF_SOLIDACTORS|TRF_BLOCKSELF, owner.Player.ViewHeight, data:dLeft);
		//owner.LineTrace(owner.angle-90, traceDistance, 0, TRF_SOLIDACTORS|TRF_BLOCKSELF, owner.Player.ViewHeight, data:dRight);
		//owner.LineTrace(owner.angle+180, traceDistance, 0, TRF_SOLIDACTORS|TRF_BLOCKSELF, owner.Player.ViewHeight, data:dBack);
		string outputText = "";

		//This set of actions will teleport sound emitters into loactions that line traces hit
		//I'm checking if emitters exist just to be safe
		if (frontEmitter)
			frontEmitter.SetOrigin(dFront.HitLocation-dFront.HitDir*4,false);
		//if (leftEmitter)
			//leftEmitter.SetOrigin(dLeft.HitLocation-dLeft.HitDir*4,false);
		//if (rightEmitter)
			//rightEmitter.SetOrigin(dRight.HitLocation-dRight.HitDir*4,false);
		//if (backEmitter)
			//backEmitter.SetOrigin(dBack.HitLocation-dBack.HitDir*4,false);

		//This should theoretically stop at closest line and beep there if height difference is too big
		//It's cool because it beeps at exactly the point where dropoff starts
		//but as I'm testing it it seemed to be somewhat faulty so I commented everything out
		//It is possible to follow the thought process behind it
		//but it will not work out of the box if you'll uncomment it

		//I don't know if it's preformance taxing because I'm iterating over all level lines
		//But it's the only way I can think of detecting line edges
		//This is a formula for detecting intersection between two line segments
		//that I found on StackOverflow many years ago
		/*
		double originX, originY;
		double targetX, targetY;
		originX = owner.pos.X;
		originY = owner.pos.Y;
		targetX = dFront.HitLocation.x;
		targetY = dFront.HitLocation.y;
		Array<double> LineIntersectionX;
		Array<double> LineIntersectionY;
		for (int i=0; i<level.Lines.Size(); i++ ) //Iteration over all level lines
		{
			line l = level.Lines[i];
			if (l.Flags & 0x00000001 > 0) //blocking line can't be a dropoff
				continue;
			if (max(targetX,originX) < min(l.V1.P.x,l.V2.P.X))
				continue;
			if (targetX == originX)
				continue;
			double A1 = (targetY-originY)/(targetX-originX); //slope of the line between origin and target
			if (l.V1.P.x == l.V2.P.x)
				continue;
			double A2 = (l.V1.P.y - l.V2.P.y)/(l.V1.P.x - l.V2.P.x); //slope of the level line
			if (A1 == A2)
				continue; //if slopes are equal lines will never intersect
			//line formula: y = slope*x + b
			//Let's find b:
			double b1 = targetY - A1*targetX;// = Y2-A1*X2;
			double b2 = l.V1.P.y - A2*l.V1.P.x;// = Y4-A2*X4;

			double Xa = (b2 - b1) / (A1 - A2);
			if (!( (Xa < max( min(targetX,originX), min(l.V1.P.x,l.V2.P.x) )) || //if this condition is true
			       (Xa > min( max(targetX,originX), max(l.V1.P.x,l.V2.P.x) )) )) //then this two line segments intersect
			{
				double intersectionX = Xa;
				double intersectionY = A2*intersectionX + b2;
				//I'm storing intersection points in an array because I'll be interested only in slosest one
				LineIntersectionX.push(intersectionX);
				LineIntersectionY.push(intersectionY);
			}
		}
		if (LineIntersectionX.Size() > 0)
		{
			double closestX = LineIntersectionX[0];
			double closestY = LineIntersectionY[0];
			double closestDistance = sqrt((originX - closestX)*(originX - closestX) +
			                              (originY - closestY)*(originY - closestY));

			//This loop searches closest intersection point
			for (int i = 1; i < LineIntersectionX.Size(); i++)
			{
				double dist = sqrt((originX - LineIntersectionX[i])*(originX - LineIntersectionX[i]) +
				                   (originY - LineIntersectionY[i])*(originY - LineIntersectionY[i]));
				if (dist < closestDistance)
				{
					closestX = LineIntersectionX[i];
					closestY = LineIntersectionY[i];
				}
			}

			//Now let's check if it's a dropoff:
			vector3 dropoffCandidate = (closestX,closestY,owner.pos.z+owner.Player.ViewHeight) + dFront.HitDir*4;
			if (level.IsPointInLevel(dropoffCandidate))
			{
				let puff = Spawn("BulletPuff",dropoffCandidate);
				let floorCoordsUnderPuff = puff.CurSector.GetPlaneTexZ(0);
				console.printf((owner.pos.z - floorCoordsUnderPuff).."");
				if (owner.pos.z - floorCoordsUnderPuff > owner.MaxStepHeight)	//This is a check if distance between
																									//player feet and floor of the next sector
																									//is bigger than player actor can step over
				{
					//console.printf("Dropoff detected");
					frontEmitterType = 1;
					frontEmitter.SetOrigin((closestX,closestY,owner.pos.z+owner.Player.ViewHeight),false);
				}
			}
		}
		*/


		//I'm duplicating a lot of code here.
		//That's not the way to go. All of it should be in a loop and I should iterate over array of emitters.
		int frontEmitterType = 0;
		//int leftEmitterType = 0;
		//int rightEmitterType = 0;
		//int backEmitterType = 0;

		//if ( dFront.HitType == TRACE_HitWall )
			//if ((dFront.HitLine.Activation & SPAC_Use > 0) && (dFront.HitLine.Special != 0))
				//frontEmitterType = 0;
			//else
				//frontEmitterType = 1;
		if (owner.pos.z - frontEmitter.CurSector.GetPlaneTexZ(0) > 60)
			frontEmitterType = 2;

		//if ( dLeft.HitType == TRACE_HitWall )
			//if ((dLeft.HitLine.Activation & SPAC_Use > 0) && (dLeft.HitLine.Special != 0))
				//leftEmitterType = 0;
			//else
				//leftEmitterType = 1;
		//if (owner.pos.z - leftEmitter.CurSector.GetPlaneTexZ(0) > owner.MaxStepHeight)
			//leftEmitterType = 2;

		//if ( dRight.HitType == TRACE_HitWall )
			//if ((dRight.HitLine.Activation & SPAC_Use > 0) && (dRight.HitLine.Special != 0))
				//rightEmitterType = 0;
			//else
				//rightEmitterType = 1;
		//if (owner.pos.z - rightEmitter.CurSector.GetPlaneTexZ(0) > owner.MaxStepHeight)
			//rightEmitterType = 2;

		//if ( dBack.HitType == TRACE_HitWall )
			//if ((dBack.HitLine.Activation & SPAC_Use > 0) && (dBack.HitLine.Special != 0))
				//backEmitterType = 0;
			//else
				//backEmitterType = 1;
		//if (owner.pos.z - backEmitter.CurSector.GetPlaneTexZ(0) > owner.MaxStepHeight)
			//backEmitterType = 2;

		switch (frontEmitterType)
		{
			case 0:
				if (!frontEmitter.InStateSequence(frontEmitter.CurState, frontEmitter.ResolveState("spawn")))
				{
					frontEmitter.SetStateLabel("spawn");
				}
				break;
			case 1:
				if (!frontEmitter.InStateSequence(frontEmitter.CurState, frontEmitter.ResolveState("wall")))
				{
					frontEmitter.SetStateLabel("wall");
				}
				break;
			case 2:
				if (!frontEmitter.InStateSequence(frontEmitter.CurState, frontEmitter.ResolveState("dropoffSpot")))
				{
					frontEmitter.SetStateLabel("dropoffSpot");
				}
				break;
			case 3:
				if (!frontEmitter.InStateSequence(frontEmitter.CurState, frontEmitter.ResolveState("lineSwitch")))
				{
					frontEmitter.SetStateLabel("lineSwitch");
				}
				break;
		}

		//switch (leftEmitterType)
		//{
			//case 0:
				//if (!leftEmitter.InStateSequence(leftEmitter.CurState, leftEmitter.ResolveState("spawn")))
				//{
					//leftEmitter.SetStateLabel("spawn");
				//}
				//break;
			//case 1:
				//if (!leftEmitter.InStateSequence(leftEmitter.CurState, leftEmitter.ResolveState("wall")))
				//{
					//leftEmitter.SetStateLabel("wall");
				//}
				//break;
			//case 2:
				//if (!leftEmitter.InStateSequence(leftEmitter.CurState, leftEmitter.ResolveState("dropoffSpot")))
				//{
					//leftEmitter.SetStateLabel("dropoffSpot");
				//}
				//break;
			//case 3:
				//if (!leftEmitter.InStateSequence(leftEmitter.CurState, leftEmitter.ResolveState("lineSwitch")))
				//{
					//leftEmitter.SetStateLabel("lineSwitch");
				//}
				//break;
		//}

		//switch (rightEmitterType)
		//{
			//case 0:
				//if (!rightEmitter.InStateSequence(rightEmitter.CurState, rightEmitter.ResolveState("spawn")))
				//{
					//rightEmitter.SetStateLabel("spawn");
				//}
				//break;
			//case 1:
				//if (!rightEmitter.InStateSequence(rightEmitter.CurState, rightEmitter.ResolveState("wall")))
				//{
					//rightEmitter.SetStateLabel("wall");
				//}
				//break;
			//case 2:
				//if (!rightEmitter.InStateSequence(rightEmitter.CurState, rightEmitter.ResolveState("dropoffSpot")))
				//{
					//rightEmitter.SetStateLabel("dropoffSpot");
				//}
				//break;
			//case 3:
				//if (!rightEmitter.InStateSequence(rightEmitter.CurState, rightEmitter.ResolveState("lineSwitch")))
				//{
					//rightEmitter.SetStateLabel("lineSwitch");
				//}
				//break;
		//}

		//switch (backEmitterType)
		//{
			//case 0:
				//if (!backEmitter.InStateSequence(backEmitter.CurState, backEmitter.ResolveState("spawn")))
				//{
					//backEmitter.SetStateLabel("spawn");
				//}
				//break;
			//case 1:
				//if (!backEmitter.InStateSequence(backEmitter.CurState, backEmitter.ResolveState("wall")))
				//{
					//backEmitter.SetStateLabel("wall");
				//}
				//break;
			//case 2:
				//if (!backEmitter.InStateSequence(backEmitter.CurState, backEmitter.ResolveState("dropoffSpot")))
				//{
					//backEmitter.SetStateLabel("dropoffSpot");
				//}
				//break;
			//case 3:
				//if (!backEmitter.InStateSequence(backEmitter.CurState, backEmitter.ResolveState("lineSwitch")))
				//{
					//backEmitter.SetStateLabel("lineSwitch");
				//}
				//break;
		//}
		}
	}
}
