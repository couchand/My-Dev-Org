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
        Collection.Mapper valueCounts = new ValueCountUnfolder();
        Collection.Mapper divideByLen = new DivideByMapper( len );
        Collection.Mapper multiplyByLog = new MultiplyByLogMapper();
        Collection.Reducer sum = new SumReducer();

        Test.startTest();

            Collection countOfValues = Collection.doUnfold( valueCounts, a );
            Collection p = countOfValues.doMap( divideByLen );
            Collection pLogP = p.doMap( multiplyByLog );
            Double entropy = -(Double)pLogP.doReduce( sum );

        Test.stopTest();

        assertDelta( 0.6, entropy, 0.005 );
    }

    public class ValueCountUnfolder extends Collection.IntegerMapper
    {
        public Object doMap( Object input )
        {
            Collection values = (Collection)input;

            if ( values.isEmpty() )
            {
                return null;
            }

            Integer first = (Integer)values.shift();
            Collection.Mapper areTheFirst = new EqualsSelector( first );

            return 1 + values.removeIf( areTheFirst ).size();
        }
    }

    public class EqualsSelector extends Collection.IntegerMapper
    {
        Integer find;

        public EqualsSelector( Integer find )
        {
            this.find = find;
        }

        public Object doMap( Object input )
        {
            return find == (Integer)input;
        }
    }

    public class DivideByMapper extends Collection.DoubleMapper
    {
        Double divisor;

        public DivideByMapper( Double divisor )
        {
            this.divisor = divisor;
        }

        public Object doMap( Object input )
        {
            return ((Double)input) / divisor;
        }
    }

    public class MultiplyByLogMapper extends Collection.DoubleMapper
    {
        public Object doMap( Object input )
        {
            return ((Double)input) * Math.log10( (Double)input );
        }
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
