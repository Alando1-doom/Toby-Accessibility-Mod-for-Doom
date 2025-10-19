// Sorry, this is so incredibly messy, I've just been so tired lately - PR
// TODO:
//     Loop over directions instead of copying and pasting code 4 times
//     Update method is doing too much, needs to be broken into sub-methods

class Toby_HurtfloorDetector
{
    private Actor referenceActor;

    private Array<Actor> soundEmitters;

    private bool enabled;
    private bool initialized;

    play void Init(int playerNumber, bool enabledByDefault = false)
    {
        PlayerInfo player = players[PlayerNumber];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        if (soundEmitters.Size() != 4)
        {
            for (int i = 0; i < soundEmitters.Size(); i++)
            {
                soundEmitters[i].Destroy();
            }
            for (int i = 0; i < 4; i++)
            {
                Actor a = Actor.Spawn("Toby_HurtfloorSoundEmitter", (0, 0, 0));
                soundEmitters.push(a);
            }
        }

        referenceActor = playerActor;
        initialized = true;
        enabled = enabledByDefault;
    }

    play void Update()
    {
        if (soundEmitters.Size() != 4)
        {
            ShutdownAllEmitters();
            return;
        }
        if (!referenceActor)
        {
            ShutdownAllEmitters();
            return;
        }
        if (!enabled)
        {
            ShutdownAllEmitters();
            return;
        }

        Sector s = referenceActor.floorSector;
        if (IsHurtFloorSector(s))
        {
            ShutdownAllEmitters();
            return;
        }

        Toby_IntegerSet sectorsToCheck = Toby_IntegerSet.Create();
        for (int i = 0; i < s.lines.Size(); i++)
        {
            Line l = s.lines[i];
            bool isTwoSided = (l.flags & Line.ML_TWOSIDED) == Line.ML_TWOSIDED;
            bool isBlocking = (l.flags & Line.ML_BLOCKING) == Line.ML_BLOCKING;

            if (!isTwoSided) { continue; }
            if (isBlocking) { continue; }

            Sector otherSector = Toby_SectorMathUtil.GetOtherSector(s, l);
            sectorsToCheck.Add(otherSector.Index());
        }

        Toby_IntegerSet linesToCheck = Toby_IntegerSet.Create();
        for (int i = 0; i < sectorsToCheck.Size(); i++)
        {
            int sectorIndex = sectorsToCheck.values[i];
            Sector s = level.sectors[sectorIndex];
            for (int j = 0; j < s.lines.Size(); j++)
            {
                Line l = s.lines[j];
                linesToCheck.Add(l.Index());
            }
        }

        Vector2 frontRight = referenceActor.AngleToVector(referenceActor.angle + 45);
        Vector2 backRight = referenceActor.AngleToVector(referenceActor.angle + 135);
        Vector2 frontLeft = referenceActor.AngleToVector(referenceActor.angle - 45);
        Vector2 backLeft = referenceActor.AngleToVector(referenceActor.angle - 135);

        Array<Toby_VectorPair> lineSegments;
        for (int i = 0; i < linesToCheck.Size(); i++)
        {
            int lineIndex = linesToCheck.values[i];

            Line l = level.lines[lineIndex];

            bool isTwoSided = (l.flags & Line.ML_TWOSIDED) == Line.ML_TWOSIDED;
            bool isBlocking = (l.flags & Line.ML_BLOCKING) == Line.ML_BLOCKING;

            if (!isTwoSided) { continue; }
            if (isBlocking) { continue; }

            Sector frontSector = l.frontSector;
            Sector backSector = l.backSector;
            if (!IsHurtFloorSector(frontSector) && !IsHurtFloorSector(backSector)) { continue; }

            bool isIntersecting1;
            Vector2 intersection1;

            bool isIntersecting2;
            Vector2 intersection2;

            bool isIntersecting3;
            Vector2 intersection3;

            bool isIntersecting4;
            Vector2 intersection4;

            [isIntersecting1, intersection1] = Toby_LineSegmentIntersectionUtil.RayIntersectsSegment(referenceActor.pos.xy, frontRight, l.v1.p, l.v2.p);
            [isIntersecting2, intersection2] = Toby_LineSegmentIntersectionUtil.RayIntersectsSegment(referenceActor.pos.xy, backRight, l.v1.p, l.v2.p);
            [isIntersecting3, intersection3] = Toby_LineSegmentIntersectionUtil.RayIntersectsSegment(referenceActor.pos.xy, frontLeft, l.v1.p, l.v2.p);
            [isIntersecting4, intersection4] = Toby_LineSegmentIntersectionUtil.RayIntersectsSegment(referenceActor.pos.xy, backLeft, l.v1.p, l.v2.p);

            if (!(isIntersecting1 || isIntersecting2 || isIntersecting3 || isIntersecting4))
            {
                lineSegments.push(Toby_VectorPair.Create(l.v1.p, l.v2.p));
            }
            else
            {
                if (isIntersecting1)
                {
                    lineSegments.push(Toby_VectorPair.Create(l.v1.p, intersection1));
                    lineSegments.push(Toby_VectorPair.Create(intersection1, l.v2.p));
                    continue;
                }
                if (isIntersecting2)
                {
                    lineSegments.push(Toby_VectorPair.Create(l.v1.p, intersection2));
                    lineSegments.push(Toby_VectorPair.Create(intersection2, l.v2.p));
                    continue;
                }
                if (isIntersecting3)
                {
                    lineSegments.push(Toby_VectorPair.Create(l.v1.p, intersection3));
                    lineSegments.push(Toby_VectorPair.Create(intersection3, l.v2.p));
                    continue;
                }
                if (isIntersecting4)
                {
                    lineSegments.push(Toby_VectorPair.Create(l.v1.p, intersection4));
                    lineSegments.push(Toby_VectorPair.Create(intersection4, l.v2.p));
                    continue;
                }
            }
        }

        double frontMinDistance = Double.Max;
        Vector2 frontPoint = (0, 0);
        double backMinDistance = Double.Max;
        Vector2 backPoint = (0, 0);
        double leftMinDistance = Double.Max;
        Vector2 leftPoint = (0, 0);
        double rightMinDistance = Double.Max;
        Vector2 rightPoint = (0, 0);

        double cos45 = Cos(45);

        for (int i = 0; i < lineSegments.Size(); i++)
        {
            Vector2 closestPoint = Toby_LineSegmentIntersectionUtil.ClosestPointOnSegment(referenceActor.pos.xy, lineSegments[i].v1, lineSegments[i].v2);
            Vector2 actorPosToClosestPoint = closestPoint - referenceActor.pos.xy;
            Vector2 actorPosToClosestPointUnit = actorPosToClosestPoint.Unit();
            double actorPosToClosestPointLength = actorPosToClosestPoint.Length();

            double frontRightDot = frontRight dot actorPosToClosestPointUnit;
            double frontLeftDot  = frontLeft dot actorPosToClosestPointUnit;
            if (frontRightDot > cos45 || frontLeftDot > cos45)
            {
                if (actorPosToClosestPointLength < frontMinDistance)
                {
                    frontMinDistance = actorPosToClosestPointLength;
                    frontPoint = closestPoint;
                }
            }

            double backRightDot = backRight dot actorPosToClosestPointUnit;
            double backLeftDot  = backLeft dot actorPosToClosestPointUnit;
            if (backRightDot > cos45 || backLeftDot > cos45)
            {
                if (actorPosToClosestPointLength < backMinDistance)
                {
                    backMinDistance = actorPosToClosestPointLength;
                    backPoint = closestPoint;
                }
            }

            double leftFrontDot = frontLeft dot actorPosToClosestPointUnit;
            double leftBackDot  = backLeft dot actorPosToClosestPointUnit;
            if (leftFrontDot > cos45 || leftBackDot > cos45)
            {
                if (actorPosToClosestPointLength < leftMinDistance)
                {
                    leftMinDistance = actorPosToClosestPointLength;
                    leftPoint = closestPoint;
                }
            }

            double rightFrontDot = frontRight dot actorPosToClosestPointUnit;
            double rightBackDot  = backRight dot actorPosToClosestPointUnit;
            if (rightFrontDot > cos45 || rightBackDot > cos45)
            {
                if (actorPosToClosestPointLength < rightMinDistance)
                {
                    rightMinDistance = actorPosToClosestPointLength;
                    rightPoint = closestPoint;
                }
            }
        }
        if (frontPoint.Length() > 0)
        {
            soundEmitters[0].SetOrigin((frontPoint, referenceActor.pos.z), false);
            if (!soundEmitters[0].InStateSequence(soundEmitters[0].CurState, soundEmitters[0].ResolveState("Hurtfloor")))
            {
                soundEmitters[0].SetStateLabel("Hurtfloor");
            }
        }
        else
        {
            soundEmitters[0].SetOrigin((0, 0, 0), false);
            soundEmitters[0].SetStateLabel("Spawn");
        }

        if (backPoint.Length() > 0)
        {
            soundEmitters[1].SetOrigin((backPoint, referenceActor.pos.z), false);
            if (!soundEmitters[1].InStateSequence(soundEmitters[1].CurState, soundEmitters[1].ResolveState("Hurtfloor")))
            {
                soundEmitters[1].SetStateLabel("Hurtfloor");
            }
        }
        else
        {
            soundEmitters[1].SetOrigin((0, 0, 0), false);
            soundEmitters[1].SetStateLabel("Spawn");
        }

        if (leftPoint.Length() > 0)
        {
            soundEmitters[2].SetOrigin((leftPoint, referenceActor.pos.z), false);
            if (!soundEmitters[2].InStateSequence(soundEmitters[2].CurState, soundEmitters[2].ResolveState("Hurtfloor")))
            {
                soundEmitters[2].SetStateLabel("Hurtfloor");
            }
        }
        else
        {
            soundEmitters[2].SetOrigin((0, 0, 0), false);
            soundEmitters[2].SetStateLabel("Spawn");
        }

        if (rightPoint.Length() > 0)
        {
            soundEmitters[3].SetOrigin((rightPoint, referenceActor.pos.z), false);
            if (!soundEmitters[3].InStateSequence(soundEmitters[3].CurState, soundEmitters[3].ResolveState("Hurtfloor")))
            {
                soundEmitters[3].SetStateLabel("Hurtfloor");
            }
        }
        else
        {
            soundEmitters[3].SetOrigin((0, 0, 0), false);
            soundEmitters[3].SetStateLabel("Spawn");
        }
    }

    play void ShutdownAllEmitters()
    {
        for (int i = 0; i < soundEmitters.Size(); i++)
        {
            soundEmitters[i].SetOrigin((0, 0, 0), false);
            soundEmitters[i].SetStateLabel("Spawn");
        }
    }

    bool IsHurtFloorSector(Sector s)
    {
        return IsHurtTerrain(s) || IsHurtFloor(s) || IsHurt3DFloor(s);
    }

    bool IsHurtTerrain(Sector s)
    {
        TerrainDef floorTerrain = s.GetFloorTerrain(s.floor);
        if (floorTerrain.TerrainName == "SOLID") { return false; }
        if (floorTerrain.DamageAmount == 0) { return false; }
        return true;
    }

    bool IsHurtFloor(Sector s)
    {
        if (s.damageamount == 0) { return false; }
        if (s.damageinterval == 0) { return false; }
        return true;
    }

    bool IsHurt3DFloor(Sector s)
    {
        Array<F3DFloor> f3dFloors;
        bool duplicateFound;
        for (int i = 0; i < s.Get3DFloorCount(); i++)
        {
            F3DFloor current3dFloor = s.Get3DFloor(i);
            duplicateFound = false;
            for (int j = 0; j < f3dFloors.Size(); j++)
            {
                if (f3dFloors[j].target.Index() == current3dFloor.target.Index()
                    && f3dFloors[j].model.Index() == current3dFloor.model.Index())
                {
                    duplicateFound = true;
                    break;
                }
            }
            if (duplicateFound) { continue; }
            Sector modelSector = F3DFloors[i].model;
            return isHurtFloor(modelSector);
        }
        return false;
    }

    void ToggleEnabled()
    {
        enabled = !enabled;
    }

    void SetEnabled(bool value)
    {
        enabled = value;
    }

    bool GetEnabled()
    {
        return enabled;
    }
}
