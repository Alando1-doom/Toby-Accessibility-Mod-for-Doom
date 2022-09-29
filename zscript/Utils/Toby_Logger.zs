class Toby_Logger
{
    static void Message(string message)
    {
        if (CVar.FindCvar("Toby_Developer").GetBool())
        {
            console.Printf(message);
        }
    }
}
