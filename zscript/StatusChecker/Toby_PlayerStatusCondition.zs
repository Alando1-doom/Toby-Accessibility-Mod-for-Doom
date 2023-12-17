class Toby_PlayerStatusCondition
{
    private double min;
    private double max;
    string soundToPlay;

    static Toby_PlayerStatusCondition Create(double min, double max, string soundToPlay)
    {
        Toby_PlayerStatusCondition condition = new("Toby_PlayerStatusCondition");
        condition.min = min;
        condition.max = max;
        condition.soundToPlay = soundToPlay;
        return condition;
    }

    bool Evaluate(int value, int baseMaxValue)
    {
        double normalizedValue = double(value) / double(baseMaxValue);
        return (normalizedValue > min && normalizedValue <= max);
    }
}
