class Toby_Logger
{
    static void Message(string message, string lockVariable)
    {
        if (CVar.FindCvar("Toby_Developer").GetBool() && CVar.FindCvar(lockVariable).GetBool())
        {
            console.Printf(message);
        }
    }

    static ui void ConsoleOutputModeMessage(string message)
    {
        console.Printf("[Toby Accessibility Mod] %s", message);
    }

    static play void ConsoleOutputModeMessagePlay(string message, Actor a)
    {
        string stringToPrint = String.Format("[Toby Accessibility Mod] %s", message);
        a.A_Log(stringToPrint, true);
    }
}
