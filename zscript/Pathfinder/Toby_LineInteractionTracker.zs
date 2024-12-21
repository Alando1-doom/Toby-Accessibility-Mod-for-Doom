class Toby_LineInteractionTracker
{
    Array<bool> interactedLines;
    bool updated;

    play static Toby_LineInteractionTracker Create()
    {
        Toby_LineInteractionTracker tracker = new("Toby_LineInteractionTracker");
        for (int i = 0; i < level.lines.Size(); i++)
        {
            tracker.interactedLines.push(false);
            tracker.updated = false;
        }
        return tracker;
    }

    play void Update()
    {
        if (updated)
        {
            updated = false;
        }
    }

    play void ActivateLine(int lineIndex)
    {
        if (interactedLines[lineIndex]) { return; }
        interactedLines[lineIndex] = true;
        updated = true;
    }
}
