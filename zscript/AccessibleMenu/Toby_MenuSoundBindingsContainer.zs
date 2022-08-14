class Toby_MenuSoundBindingsContainer
{
    Array<Dictionary> menuSoundBindings;

    ui void Init()
    {
        Array<String> splitTokens;
        int lump = -1;
		while ((lump = WadsUtils.FindLump('Toby_MenuSoundBindings', lump + 1)) != -1)
		{
            console.printf("Lump ["..lump.."] has full name '"..Wads.GetLumpFullName(lump).."'");
            string lumpContent = Wads.ReadLump(lump);
            splitTokens.Clear();
            lumpContent.Split(splitTokens, "\n", TOK_SKIPEMPTY);

            for (int i = 0; i < splitTokens.Size(); i++)
            {
                //Failsafe
                //{"a":"b"}
                //9 chars long, can't be smaller
                if (splitTokens[i].Length() < 9) { continue; }

                menuSoundBindings.push(Dictionary.FromString(splitTokens[i]));

            }
            console.printf("Menu sound bindings added: "..menuSoundBindings.Size());
        }
    }
}
