@isTest
private class ShannonEntropy
{
    public static void assertDelta( Decimal expected, Double actual, Decimal delta )
    {
        System.assert(
            expected - delta <= actual,
            'expected ' + actual + ' to be within ' + delta + ' of ' + expected
        );
        System.assert(
            actual <= expected + delta,
            'expected ' + actual + ' to be within ' + delta + ' of ' + expected
        );
    }

    private static testMethod void testShannonEntropy()
    {
        Benchmark iterative = new Benchmark();
        Benchmark functional = new Benchmark();

        List<Integer> values = new List<Integer>{ 1, 2, 3, 1, 4, 3, 2, 4 };

        iterative.start();

        Integer myLen = values.size();

        Map<Integer, Integer> myCounts = new Map<Integer, Integer>();

        for ( Integer value : values )
        {
            myCounts.put( value, myCounts.containsKey( value ) ? 1 + myCounts.get( value ) : 1 );
        }

        List<Integer> myValueCounts = new List<Integer>();

        for ( Integer value : values )
        {
            myValueCounts.add( myCounts.get( value ) );
        }

        List<Double> normalized = new List<Double>();

        for ( Integer value : values )
        {
            normalized.add( (1.0 * value) / (1.0 * myLen) );
        }

        List<Double> myPLogP = new List<Double>();

        for ( Double myP : normalized )
        {
            myPLogP.add( myP * Math.log10( myP ) );
        }

        Double myEntropy = 0;

        for ( Double val : myPLogP )
        {
            myEntropy += val;
        }

        myEntropy = -myEntropy;

        iterative.stop();

        Test.startTest();

            functional.start();

            Collection a = new Collection( values );

            Integer len = a.size();
            Collection.Mapper divideByLen = new Mapper.DivideBy( len );
            Collection.Mapper multiplyByLog = new Mapper.MultiplyByLog();
            Collection.Reducer sum = new Reducer.SumDouble();

            Collection.GroupedCollection valuesByValue = a.doGroup( new Mapper.IntegerIdentity() );
            Map<Object, Object> valueCounts = valuesByValue.doReduceGroups( new Reducer.Count() );

            Collection.Mapper countMap = new Mapper.MapMapper( valueCounts );
            Collection countOfValues = a.doMap( countMap );

            Collection p = countOfValues.doMap( divideByLen );
            Collection pLogP = p.doMap( multiplyByLog );
            Double entropy = -(Double)pLogP.doReduce( sum );

            functional.stop();

        Test.stopTest();

        assertDelta( myEntropy, entropy, 0.075 );

        System.assert( false,
            'iterative ' + iterative.getNetUsage('ScriptStatements') + ' statements ' +
                         + iterative.getNetUsage('HeapSize') + ' heap ' + '\n' +
            'functional ' + functional.getNetUsage('ScriptStatements') + ' statements ' +
                          + functional.getNetUsage('HeapSize') + ' heap '
        );
    }
}
