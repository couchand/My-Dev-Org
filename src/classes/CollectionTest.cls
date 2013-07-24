@isTest private class CollectionTest
{
    static List<Integer> inputs = new List<Integer>{ 45, 62, 3, 22, 39, 54, 76, 43, 1, 55, 8 };
    static Collection values = new Collection( inputs );

    private static testMethod void testFor()
    {
        Benchmark iterative = new Benchmark();

        Integer expectedTotal = 0;

        for ( Integer input : inputs )
        {
            expectedTotal += input * input;
        }

        iterative.stop();

        Test.startTest();

            Benchmark functional = new Benchmark();

            Collection squared = values.doMap( new Mapper.SquareInteger() );
            Object totalObj = squared.doReduce( new Reducer.SumInteger() );

            functional.stop();

        Test.stopTest();

        System.assert( totalObj instanceof Integer );

        Integer actualTotal = (Integer)totalObj;

        System.assertEquals( expectedTotal, actualTotal );

        System.assert( false,
            'iterative ' + iterative.getNetUsage('ScriptStatements') + ' statements ' +
            'functional ' + functional.getNetUsage('ScriptStatements') + ' statements '
        );
    }

    private static testMethod void testGroup()
    {
        Benchmark iterative = new Benchmark();

        Set<Integer> odds = new Set<Integer>();
        Set<Integer> evens = new Set<Integer>();

        for ( Integer input : inputs )
        {
            if ( Math.mod( input, 2 ) == 0 )
            {
                evens.add( input );
            }
            else
            {
                odds.add( input );
            }
        }

        iterative.stop();

        Test.startTest();

            Benchmark functional = new Benchmark();

            Collection.GroupedCollection collection = values.doGroup( new Mapper.OddOrEven() );

            functional.stop();

        Test.stopTest();

        Map<Object, Collection> groups = collection.groups;

        System.assert( groups.containsKey( 'even' ) );
        System.assert( groups.containsKey( 'odd' ) );

        for ( Object value : groups.get( 'even' ).members )
        {
            System.assert( value instanceof Integer );
            System.assert( evens.contains( (Integer)value ) );
        }

        for ( Object value : groups.get( 'odd' ).members )
        {
            System.assert( value instanceof Integer );
            System.assert( odds.contains( (Integer)value ) );
        }

        System.assert( false,
            'iterative ' + iterative.getNetUsage('ScriptStatements') + ' statements ' +
            'functional ' + functional.getNetUsage('ScriptStatements') + ' statements '
        );
    }

    private static testMethod void testGroupMethods()
    {
        Collection groups = values.doGroup( new Mapper.OddOrEven() );

        Test.startTest();

            Collection mappedCollection = groups.doMap( new Mapper.OddOrEven() );
            Object count = groups.doReduce( new Reducer.Count() );

        Test.stopTest();

        System.assert( count instanceof Integer );
        System.assertEquals( 2, count );

        System.assert( mappedCollection instanceof Collection.GroupedCollection );

        Collection.GroupedCollection mapped = (Collection.GroupedCollection)mappedCollection;

        for ( Object key : mapped.groups.keySet() )
        {
            for ( Object value : mapped.groups.get( key ).members )
            {
                System.assertEquals( key, value );
            }
        }
    }
}
