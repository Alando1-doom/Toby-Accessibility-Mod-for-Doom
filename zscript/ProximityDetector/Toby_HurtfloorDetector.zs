// Sorry, this is so incredibly messy, I've just been so tired lately - PR
// TODO:
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
            if (Toby_LineSegmentIntersectionUtil.IsBlocking(l)) { continue; }

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

        double rayOffsetFrontRight = 45;
        double rayOffsetBackRight = 135;
        double rayOffsetFrontLeft = -45;
        double rayOffsetBackLeft = -135;

        uint frontRightIndex = 0;
        uint backRightIndex = 1;
        uint frontLeftIndex = 2;
        uint backLeftIndex = 3;

        double rayOffsets[4];
        rayOffsets[frontRightIndex] = rayOffsetFrontRight;
        rayOffsets[backRightIndex] = rayOffsetBackRight;
        rayOffsets[frontLeftIndex] = rayOffsetFrontLeft;
        rayOffsets[backLeftIndex] = rayOffsetBackLeft;

        Vector2 rays[4];
        for (int i = 0; i < rays.Size(); i++)
        {
            rays[i] = referenceActor.AngleToVector(
                referenceActor.angle + rayOffsets[i]
            );
        }

        Array<Toby_VectorPair> lineSegments;
        for (int i = 0; i < linesToCheck.Size(); i++)
        {
            Line l = level.lines[linesToCheck.values[i]];
            if (Toby_LineSegmentIntersectionUtil.IsBlocking(l)) { continue; }

            if (!IsHurtFloorSector(l.frontSector) &&
                !IsHurtFloorSector(l.backSector))
            {
                continue;
            }

            bool wasSplit = false;

            for (int rayIndex = 0; rayIndex < rays.Size(); rayIndex++)
            {
                bool intersects;
                Vector2 intersection;

                [intersects, intersection] =
                    Toby_LineSegmentIntersectionUtil.RayIntersectsSegment(
                        referenceActor.pos.xy,
                        rays[rayIndex],
                        l.v1.p,
                        l.v2.p
                    );

                if (!intersects) { continue; }

                lineSegments.Push(Toby_VectorPair.Create(l.v1.p, intersection));
                lineSegments.Push(Toby_VectorPair.Create(intersection, l.v2.p));

                wasSplit = true;
                break;
            }

            if (!wasSplit)
            {
                lineSegments.Push(Toby_VectorPair.Create(l.v1.p, l.v2.p));
            }
        }

        // This makes it so that 0 is front, 1 is back, 2 is left and 3 is right.
        uint directionsSize = 4;
        // By the way. Do you know why this directionsSize is not a const?
        // Because I still can't figure out how consts work in ZScript
        // If I knew I would've probably used it in those static array sizes as well! -PR
        int firstRay[4]  = { frontRightIndex, backRightIndex, frontLeftIndex, frontRightIndex };
        int secondRay[4] = { frontLeftIndex, backLeftIndex, backLeftIndex, backRightIndex };

        double minDistances[4];
        Vector2 nearestPoints[4];

        for (int direction = 0; direction < directionsSize; direction++)
        {
            minDistances[direction] = Double.Max;
            nearestPoints[direction] = (0, 0);
        }

        double cos45 = Cos(45);

        for (int i = 0; i < lineSegments.Size(); i++)
        {
            Vector2 closestPoint = Toby_LineSegmentIntersectionUtil.ClosestPointOnSegment(
                referenceActor.pos.xy,
                lineSegments[i].v1,
                lineSegments[i].v2
            );

            Vector2 offset = closestPoint - referenceActor.pos.xy;
            Vector2 unitOffset = offset.Unit();
            double distance = offset.Length();

            for (int direction = 0; direction < directionsSize; direction++)
            {
                double firstDot = rays[firstRay[direction]] dot unitOffset;
                double secondDot = rays[secondRay[direction]] dot unitOffset;

                if ((firstDot > cos45 || secondDot > cos45) &&
                    distance < minDistances[direction])
                {
                    minDistances[direction] = distance;
                    nearestPoints[direction] = closestPoint;
                }
            }
        }

        for (int direction = 0; direction < directionsSize; direction++)
        {
            Actor emitter = soundEmitters[direction];
            Vector2 point = nearestPoints[direction];

            if (point.Length() > 0)
            {
                emitter.SetOrigin((point, referenceActor.pos.z), false);

                if (!emitter.InStateSequence(
                    emitter.CurState,
                    emitter.ResolveState("Hurtfloor")))
                {
                    emitter.SetStateLabel("Hurtfloor");
                }
            }
            else
            {
                emitter.SetOrigin((0, 0, 0), false);
                emitter.SetStateLabel("Spawn");
            }
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
        for (int i = 0; i < s.Get3DFloorCount(); i++)
        {
            F3DFloor current3dFloor = s.Get3DFloor(i);
            Sector modelSector = current3dFloor.model;
            if (IsHurtFloor(modelSector))
            {
                return true;
            }
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
