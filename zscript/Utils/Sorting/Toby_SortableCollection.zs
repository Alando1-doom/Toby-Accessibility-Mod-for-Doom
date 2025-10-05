class Toby_SortableCollection abstract
{
    abstract Object GetObject(int arrayPos);
    abstract void SetObject(int arrayPos, Object item);
    abstract int Compare(int arrayPos, int pivotPos);
}
