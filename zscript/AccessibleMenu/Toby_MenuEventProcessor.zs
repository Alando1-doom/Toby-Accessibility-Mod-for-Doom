class Toby_MenuEventProcessor
{
    Toby_MenuOutputBySoundBindings outputBySoundBindings;
    Toby_MenuOutputToConsole outputToConsole;
    Toby_SoundBindingsContainer menuSoundBindingsContainer;

    ui void Process(Toby_MenuState currentState, Toby_MenuState previousState, int detectedChange)
    {
        if (CVar.FindCvar("Toby_NarrationOutputType").GetInt() == TNOT_CONSOLE)
        {
            outputToConsole.Output(currentState, previousState, detectedChange);
        }
        else
        {
            outputBySoundBindings.Output(currentState, previousState, detectedChange);
        }
    }

    static ui Toby_MenuEventProcessor Create(Toby_SoundBindingsContainer bindings)
    {
        Toby_MenuEventProcessor processor = new("Toby_MenuEventProcessor");
        processor.menuSoundBindingsContainer = bindings;
        processor.outputBySoundBindings = Toby_MenuOutputBySoundBindings.Create(processor.menuSoundBindingsContainer);
        processor.outputToConsole = Toby_MenuOutputToConsole.Create();
        return processor;
    }
}
