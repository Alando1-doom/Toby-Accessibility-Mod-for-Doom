class Toby_WallDetector: Thinker
{
    private Actor owner;
    private int cooldown;
    private int cooldownMax;

    static Toby_WallDetector Create(Actor owner)
    {
        Toby_WallDetector wallDetector = new("Toby_WallDetector");
        wallDetector.cooldown = 0;
        wallDetector.cooldownMax = 5;
        wallDetector.owner = owner;
        return wallDetector;
    }

    override void Tick()
    {
        Super.Tick();
        SpawnWallHitActors();
        if (cooldown > 0) {
            cooldown--;
        }
    }

    private void SpawnWallHitActors()
    {
        if (!owner) { return; }
        PlayerInfo player = owner.player;
        if (!player) { return; }
        console.printf(""..player.bob);
        //Not an option, this will ignore controller inputs
        //if (!((player.buttons & BT_MOVERIGHT) || (player.buttons & BT_MOVELEFT) || (player.buttons & BT_FORWARD) || (player.buttons & BT_BACK))) { return; }
        //Not an option, this will ignore ceases when player hits the wall at 90 degrees
        //if (owner.Vel.length() == 0) { return; }
        if (player.bob == 0) { return; }
        if (cooldown != 0) { return; }
        owner.A_ThrowGrenade("WallHit", -12, 2.5, 1);
        owner.A_ThrowGrenade("WallHit", -12, -2.5, 1);
        owner.A_SpawnProjectile("WallHit",24,0,100,2,0);
        owner.A_SpawnProjectile("WallHit",24,0,260,2,0);
        cooldown = cooldownMax;
    }
}
