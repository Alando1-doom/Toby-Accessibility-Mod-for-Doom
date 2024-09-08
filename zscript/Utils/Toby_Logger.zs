class Toby_Logger
{
    static void Message(string message, string lockVariable)
    {
        if (CVar.FindCvar("Toby_Developer").GetBool() && CVar.FindCvar(lockVariable).GetBool())
        {
            console.Printf(message);
        }
    }

    static void ConsoleOutputModeMessage(string message)
    {
        console.Printf("[Toby Accessibility Mod] %s", message);
    }
}
