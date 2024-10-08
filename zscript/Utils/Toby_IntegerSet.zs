class Toby_IntegerSet
{
    Array<int> values;

    static Toby_IntegerSet Create()
    {
        Toby_IntegerSet intSet = new("Toby_IntegerSet");
        return intSet;
    }

    void Clear()
    {
        values.Clear();
    }

    void Copy(Toby_IntegerSet set)
    {
        values.Copy(set.values);
    }

    int Size()
    {
        return values.Size();
    }

    void Add(int value)
    {
        if (isInSet(value)) { return; }
        values.push(value);
    }

    void Remove(int value)
    {
        for (int i = values.Size() - 1; i >= 0; i--)
        {
            if (values[i] == value)
            {
                values.Delete(i, 1);
                break;
            }
        }
    }

    bool IsInSet(int value)
    {
        bool isInSet = false;
        for (int i = 0; i < values.Size(); i++)
        {
            if (values[i] == value)
            {
                isInSet = true;
                break;
            }
        }
        return isInSet;
    }
}
