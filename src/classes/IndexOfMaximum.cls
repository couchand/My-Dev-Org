@isTest
private class IndexOfMaximum
{
    public class MaximumReducer implements Collection.Reducer
    {
        public Object doReduce( Object input, Object current )
        {
            if ( null == current )
            {
                return input;
            }

            return Math.max( (Integer)input, (Integer)current );
        }

        public Type getInputType()
        {
            return Integer.class;
        }

        public Type getOutputType()
        {
            return Integer.class;
        }
    }

    public class FirstIndexReducer implements Collection.Reducer
    {
        Integer find, index;

        public FirstIndexReducer( Integer find )
        {
            this.find = find;
            this.index = 0;
        }

        public Object doReduce( Object input, Object current )
        {
            if ( current == null && find == input )
            {
                current = index;
            }

            index++;

            return current;
        }

        public Type getInputType()
        {
            return Integer.class;
        }

        public Type getOutputType()
        {
            return Integer.class;
        }
    }

    private static testMethod void testIndex()
    {
        Collection.Reducer maximum = new MaximumReducer();
        Collection.Reducer firstIndex;
        List<Integer> inputs = new List<Integer>{ 3, 1, 4, 1, 5, 9 };
        Collection a = new Collection( inputs );

        Test.startTest();

            Integer theMax = (Integer)a.doReduce( maximum );
            firstIndex = new FirstIndexReducer( theMax );
            Integer firstMaxIndex = (Integer)a.doReduce( firstIndex );

        Test.stopTest();

        System.assertEquals( 5, firstMaxIndex );
    }
}
