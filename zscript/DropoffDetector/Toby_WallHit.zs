class Toby_WallHit : Actor
{
    Toby_DropoffDetectorHandler handler;

    default
    {
        Radius 9;
        Height 8;
        Speed 2;
        Health 1;
        Damage 0;
        Projectile;
        +NOTIMEFREEZE;
        +NOBLOCKMAP;
        +BLOCKASPLAYER;
        -NOGRAVITY;
        DeathSound "misc/wallhit";
    }

    States
    {
    Spawn:
        TNT1 A 1;
        TNT1 A 1;
        TNT1 A 3;
        TNT1 A 0;
        Stop;

    Death:
        TNT1 A 1;
        Stop;
    }

    void SetHandlerReference(Toby_DropoffDetectorHandler handler)
    {
        self.handler = handler;
    }

    override int SpecialMissileHit(Actor victim)
    {
        if (!handler) { return Super.SpecialMissileHit(victim); }
        if (handler.wallHitIgnoreListLoader.IsInIgnoreList(victim, handler.wallHitIgnoreListLoader.wallHitIgnoreList)) { return 1; }
        return Super.SpecialMissileHit(victim);
    }

    override bool CanCollideWith(Actor other, bool passive)
    {
        if (!handler) { return Super.CanCollideWith(other, passive); }
        if (handler.wallHitIgnoreListLoader.IsInIgnoreList(other, handler.wallHitIgnoreListLoader.wallHitIgnoreList)) { return false; }
        return Super.CanCollideWith(other, passive);
    }
}
