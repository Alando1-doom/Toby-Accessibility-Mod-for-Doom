class CheatGiverBase : CustomInventory
{
    action state A_JumpIfCVARInt(statelabel label, string cvarName, int cvarValue)
    {
        PlayerPawn playerActor = PlayerPawn(self);
        if (!playerActor) { return null; }
        if (!(playerActor is "PlayerPawn")) { return null; }
        if (!playerActor.player) { return null; }
        int actual = CVar.GetCVar(cvarName, playerActor.player).GetInt();
        if (actual != cvarValue) { return null; }
        else return ResolveState(label);
    }

    States
    {
        Spawn:
        TNT1 A -1;
        Stop;
    }
}
