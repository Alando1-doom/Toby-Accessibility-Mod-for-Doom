class Toby_VectorPair
{
    Vector2 v1;
    Vector2 v2;

    static Toby_VectorPair Create(Vector2 v1, Vector2 v2)
    {
        Toby_VectorPair pair = new("Toby_VectorPair");
        pair.v1 = v1;
        pair.v2 = v2;

        return pair;
    }
}
