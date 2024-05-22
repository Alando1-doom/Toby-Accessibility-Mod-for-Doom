class Toby_ClassIgnoreListContainer
{
    Array<string> classNames;

    static ui Toby_ClassIgnoreListContainer Create(string lumpName)
    {
        Toby_ClassIgnoreListContainer container = new("Toby_ClassIgnoreListContainer");
        Array<String> splitTokens;
        int lump = -1;
        while ((lump = Toby_WadsUtils.FindLump(lumpName, lump + 1)) != -1)
        {
            Toby_Logger.Message("Lump ["..lump.."] has full name '"..Wads.GetLumpFullName(lump).."'", "Toby_Developer");
            string lumpContent = Wads.ReadLump(lump);
            splitTokens.Clear();
            lumpContent.Split(splitTokens, "\n", TOK_SKIPEMPTY);

            for (int i = 0; i < splitTokens.Size(); i++)
            {
                //Dumb check for commented line
                if (splitTokens[i].IndexOf("//") == 0) { continue; }

                bool sameClassNameFound = false;
                for (int j = 0; j < container.classNames.Size(); j++)
                {
                    if (container.classNames[j] == splitTokens[i])
                    {
                        sameClassNameFound = true;
                        break;
                    }
                }
                if (!sameClassNameFound)
                {
                    container.classNames.push(splitTokens[i]);
                }
            }
            Toby_Logger.Message("Classes added to ignore list: "..container.classNames.Size(), "Toby_Developer");
        }
        return container;
    }
}
