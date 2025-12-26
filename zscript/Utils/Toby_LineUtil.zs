class Toby_LineUtil
{
    static bool IsTeleportLine(Line l)
    {
        return (
            l.special == TOBY_AS_TELEPORT_ZOMBIE_CHANGER
            || l.special == TOBY_AS_TELEPORT
            || l.special == TOBY_AS_TELEPORT_NO_FOG
            || l.special == TOBY_AS_TELEPORT_OTHER
            || l.special == TOBY_AS_TELEPORT_GROUP
            || l.special == TOBY_AS_TELEPORT_IN_SECTOR
            || l.special == TOBY_AS_TELEPORT_NO_STOP
            || l.special == TOBY_AS_TELEPORT_LINE
        );
    }

    static bool IsExit(Line l)
    {
        return (
            l.special == TOBY_AS_EXIT_NORMAL
            || l.special == TOBY_AS_TELEPORT_NEW_MAP
        );
    }

    static bool IsSecretExit(Line l)
    {
        return (
            l.special == TOBY_AS_EXIT_SECRET
        );
    }

    static bool IsEndGame(Line l)
    {
        return (
            l.special == TOBY_AS_TELEPORT_END_GAME
        );
    }
}
