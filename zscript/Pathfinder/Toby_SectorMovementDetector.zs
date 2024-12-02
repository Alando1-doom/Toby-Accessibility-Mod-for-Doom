class Toby_SectorMovementDetector
{
    Toby_IntegerSet sectorsMovingPrevious;
    Toby_IntegerSet sectorsMovingNow;
    Toby_IntegerSet sectorsJustStopped;

    play static Toby_SectorMovementDetector Create()
    {
        Toby_SectorMovementDetector detector = new("Toby_SectorMovementDetector");
        detector.sectorsMovingPrevious = Toby_IntegerSet.Create();
        detector.sectorsMovingNow = Toby_IntegerSet.Create();
        detector.sectorsJustStopped = Toby_IntegerSet.Create();
        return detector;
    }

    play void Update()
    {
        sectorsMovingNow.Clear();
        sectorsJustStopped.Clear();

        ThinkerIterator ti = ThinkerIterator.Create("SectorEffect", Thinker.STAT_SECTOREFFECT);
        SectorEffect sectorEffect;
        while (sectorEffect = SectorEffect(ti.Next()))
        {
            int sectorIndex = sectorEffect.GetSector().Index();
            sectorsMovingNow.Add(sectorIndex);
        }

        for (int i = 0; i < sectorsMovingPrevious.Size(); i++)
        {
            bool justStopped = !sectorsMovingNow.IsInSet(sectorsMovingPrevious.values[i]);
            if (justStopped)
            {
                sectorsJustStopped.Add(sectorsMovingPrevious.values[i]);
            }
        }

        sectorsMovingPrevious.Copy(sectorsMovingNow);
    }
}
