class Toby_LineUtil
{
    static int GetLockNumber(Line l)
    {
        if (l.special == TOBY_AS_DOOR_LOCKED_RAISE)
        {
            return l.args[3];
        }

        if (l.special == TOBY_AS_GENERIC_DOOR)
        {
            return l.args[4];
        }

        return l.locknumber;
    }

    static bool IsRedDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_RED_CARD
            || lockNumber == TOBY_LOCK_RED_CARD_SKULL_PRISM
            || lockNumber == TOBY_LOCK_RED_CARD_SKULL
        );
    }

    static bool IsBlueDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_BLUE_CARD
            || lockNumber == TOBY_LOCK_BLUE_CARD_SKULL_PRISM
            || lockNumber == TOBY_LOCK_BLUE_CARD_SKULL
        );
    }

    static bool IsYellowDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_YELLOW_CARD
            || lockNumber == TOBY_LOCK_YELLOW_CARD_SKULL_PRISM
            || lockNumber == TOBY_LOCK_YELLOW_CARD_SKULL
        );
    }

    static bool IsRedSkullDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_RED_SKULL
        );
    }

    static bool IsBlueSkullDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_BLUE_SKULL
        );
    }

    static bool IsYellowSkullDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_YELLOW_SKULL
        );
    }

    static bool IsSilverKeyDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_SILVER_KEY
        );
    }

    static bool IsRustedKeyDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_RUSTED_KEY
        );
    }

    static bool IsHornKeyDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_HORN_KEY
        );
    }

    static bool IsSwampKeyDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_SWAMP_KEY
        );
    }

    static bool IsCastleKeyDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_CASTLE_KEY
        );
    }

    static bool IsThreeKeyDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_THREE_KEY_DOOR
        );
    }

    static bool IsSixKeyDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_SIX_KEY_DOOR
        );
    }

    static bool IsAnyKeyDoor(int lockNumber)
    {
        return (
            lockNumber == TOBY_LOCK_ANY_KEY_DOOR_HEXEN
            || lockNumber == TOBY_LOCK_ANY_KEY_DOOR
        );
    }

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

    static bool IsWikiDoorSpecial(int specialNumber)
    {
        return (
            spec == TOBY_AS_DOOR_CLOSE
            || spec == TOBY_AS_DOOR_OPEN
            || spec == TOBY_AS_DOOR_RAISE
            || spec == TOBY_AS_DOOR_LOCKED_RAISE
            || spec == TOBY_AS_DOOR_ANIMATED
            || spec == TOBY_AS_DDOR_WAIT_RAISE
            || spec == TOBY_AS_DDOR_WAIT_CLOSE
            || spec == TOBY_AS_GENERIC_DOOR
            || spec == TOBY_AS_DOOR_CLOSE_WAIT_OPEN
            || spec == TOBY_AS_DOOR_ANIMATED_CLOSE
        );
    }
}
