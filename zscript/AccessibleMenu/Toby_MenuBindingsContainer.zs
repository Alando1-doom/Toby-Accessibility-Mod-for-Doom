class Toby_MenuBindingsContainer
{
    Dictionary soundBindings;

    ui void Init()
    {
        int lump = -1;
		while ((lump = WadsUtils.FindLump('Toby_MenuSoundBindings', lump + 1)) != -1)
		{
            console.printf("Lump ["..lump.."] has full name '"..Wads.GetLumpFullName(lump).."'");
        }
    }
}
