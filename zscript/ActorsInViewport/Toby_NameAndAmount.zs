class Toby_NameAndAmount
{
    string name;
    int amount;
    bool countKill;
    int maxHp;

    static Toby_NameAndAmount Create(string name, int amount, bool countKill, int maxHp)
    {
        Toby_NameAndAmount counter = new("Toby_NameAndAmount");
        counter.name = name;
        counter.amount = amount;
        counter.countKill = countKill;
        counter.maxHp = maxHp;
        return counter;
    }
}
