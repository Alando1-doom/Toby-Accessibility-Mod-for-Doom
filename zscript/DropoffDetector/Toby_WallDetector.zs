class Toby_WallDetector: Thinker
{
    private Actor owner;
    private int cooldown;
    private int cooldownMax;
    Toby_DropoffDetectorHandler handler;

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

    void SetHandlerReference(Toby_DropoffDetectorHandler handler)
    {
        self.handler = handler;
    }

    private void SpawnWallHitActors()
    {
        if (!owner) { return; }
        PlayerInfo player = owner.player;
        if (!player) { return; }
        if (player.cmd.forwardmove == 0 && player.cmd.sidemove == 0) { return; }
        if (cooldown != 0) { return; }

        Toby_WallHit projectile1 = Toby_WallHit(owner.A_SpawnProjectile("Toby_WallHit",28,0,0,2,0));
        Toby_WallHit projectile2 = Toby_WallHit(owner.A_SpawnProjectile("Toby_WallHit",28,0,180,2,0));
        Toby_WallHit projectile3 = Toby_WallHit(owner.A_SpawnProjectile("Toby_WallHit",28,0,100,2,0));
        Toby_WallHit projectile4 = Toby_WallHit(owner.A_SpawnProjectile("Toby_WallHit",28,0,260,2,0));

        projectile1.SetHandlerReference(handler);
        projectile2.SetHandlerReference(handler);
        projectile3.SetHandlerReference(handler);
        projectile4.SetHandlerReference(handler);
        cooldown = cooldownMax;
    }
}
