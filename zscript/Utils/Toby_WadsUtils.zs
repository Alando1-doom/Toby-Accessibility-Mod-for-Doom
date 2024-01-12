class Toby_WadsUtils
{
    static int FindLump(string name, int startLump)
    {
        int lump = -1;
        for (int i = startLump; i < Wads.GetNumLumps(); i++)
        {
            Array<String> splitTokens;

            string lumpFullName = Wads.GetLumpFullName(i);

            splitTokens.Clear();
            lumpFullName.Split(splitTokens, "/");

            if (splitTokens.Size() == 0) { continue; }
            string lumpFileNameWithExtension = splitTokens[splitTokens.Size() - 1];

            splitTokens.Clear();
            lumpFileNameWithExtension.Split(splitTokens, ".");
            if (splitTokens.Size() == 0) { continue; }
            string lumpOnlyFileName = splitTokens[0];
            if (splitTokens.Size() > 1)
            {
                for (int j = 1; j < splitTokens.Size() - 1; j++)
                {
                    lumpOnlyFileName = lumpOnlyFileName.."."..splitTokens[j];
                }
            }
            if (lumpOnlyFileName == name.MakeLower())
            {
                lump = i;
                break;
            }
        }
        return lump;
    }
}
