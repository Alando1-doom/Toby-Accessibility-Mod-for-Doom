class Toby_Logger
{
    static void Message(string message, string lockVariable)
    {
        if (CVar.FindCvar("Toby_Developer").GetBool() && CVar.FindCvar(lockVariable).GetBool())
        {
            console.Printf(message);
        }
    }
}
