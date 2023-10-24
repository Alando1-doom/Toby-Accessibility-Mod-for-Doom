class Toby_NameAndAmount
{
    string name;
    int amount;

    static Toby_NameAndAmount Create(string name, int amount)
    {
        Toby_NameAndAmount counter = new("Toby_NameAndAmount");
        counter.name = name;
        counter.amount = amount;
        return counter;
    }
}
