//I assume I'm grossly misusing structs and there should be a better way of adding them to arrays -PR

class Toby_Vector2dWrapper
{
    Vector2 v;

    static Toby_Vector2dWrapper Create(Vector2 v)
    {
        Toby_Vector2dWrapper wrapper = new("Toby_Vector2dWrapper");
        wrapper.v = v;
        return wrapper;
    }
}
