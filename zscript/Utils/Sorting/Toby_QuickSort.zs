class Toby_QuickSort
{
    static void QuickSort(Toby_SortableCollection container, int left, int right)
    {
        int i = left;
        int j = right;
        int pivotPos = (left + right) / 2;
        while (i <= j)
        {
            while (container.Compare(i, pivotPos) < 0) { i++; };
            while (container.Compare(j, pivotPos) > 0) { j--; };
            if (i <= j)
            {
                Object tmp = container.GetObject(i);
                container.SetObject(i, container.GetObject(j));
                container.SetObject(j, tmp);

                if (i == pivotPos)
                {
                    pivotPos = j;
                }

                else if (j == pivotPos)
                {
                    pivotPos = i;
                }

                i++;
                j--;
            }
        }
        if (left < j) QuickSort(container, left, j);
        if (i < right) QuickSort(container, i, right);
    }
}
