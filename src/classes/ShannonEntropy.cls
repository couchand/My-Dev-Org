@isTest
private class ShannonEntropy
{
    public static void assertDelta( Decimal expected, Double actual, Decimal delta )
    {
        System.assert(
            expected - delta <= actual
        );
        System.assert(
            actual <= expected + delta
        );
    }

    private static testMethod void testShannonEntropy()
    {
        List<Integer> values = new List<Integer>{ 1, 2, 3, 1, 4, 3, 2, 4 };
        Collection a = new Collection( values );

        Integer len = a.size();
        Collection.Mapper valueCounts = new Unfolder.ValueCount();
        Collection.Mapper divideByLen = new Mapper.DivideBy( len );
        Collection.Mapper multiplyByLog = new Mapper.MultiplyByLog();
        Collection.Reducer sum = new SumReducer();

        Test.startTest();

            Collection countOfValues = Collection.doUnfold( valueCounts, a );
            Collection p = countOfValues.doMap( divideByLen );
            Collection pLogP = p.doMap( multiplyByLog );
            Double entropy = -(Double)pLogP.doReduce( sum );

        Test.stopTest();

        assertDelta( 0.6, entropy, 0.005 );
    }

    public class SumReducer extends Collection.DoubleReducer
    {
        public Object doReduce( Object input, Object current )
        {
            if ( current == null )
            {
                return input;
            }
            return ((Double)input) + ((Double)current);
        }
    }
}
