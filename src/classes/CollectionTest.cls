@isTest private class CollectionTest
{
    static List<Integer> inputs = new List<Integer>{ 45, 62, 3, 22, 39, 54, 76, 43, 1, 55, 8 };
    static Collection values = new Collection( inputs );

    private static testMethod void testFor()
    {
        Integer iterativeStart = Limits.getScriptStatements();

        Integer expectedTotal = 0;

        for ( Integer input : inputs )
        {
            expectedTotal += input * input;
        }

        Integer iterativeStop = Limits.getScriptStatements();

        Test.startTest();

            Integer functionalStart = Limits.getScriptStatements();

            Collection squared = values.doMap( new Squarer() );
            Object totalObj = squared.doReduce( new Summer() );

            Integer functionalStop = Limits.getScriptStatements();

        Test.stopTest();

        System.assert( totalObj instanceof Integer );

        Integer actualTotal = (Integer)totalObj;

        System.assertEquals( expectedTotal, actualTotal );

        System.assert( false,
            'iterative ' +
            (iterativeStop - iterativeStart) + ' statements ' +
            '[' + iterativeStart + ',' + iterativeStop + '] ' +
            'functional ' +
            (functionalStop - functionalStart) + ' statements ' +
            '[' + functionalStart + ',' +functionalStop + ']'
        );
    }

    public class Squarer implements Collection.Mapper
    {
        public Object doMap( Object input )
        {
            Integer value = input == null ? 0 : (Integer)input;

            return value * value;
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

    public class Summer implements Collection.Reducer
    {
        public Object doReduce( Object input, Object current )
        {
            return ( input == null ? 0 : (Integer)input ) +
                   ( current == null ? 0 : (Integer)current );
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

    private static testMethod void testGroup()
    {
        Integer iterativeStart = Limits.getScriptStatements();

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

        Integer iterativeStop = Limits.getScriptStatements();

        Test.startTest();

            Integer functionalStart = Limits.getScriptStatements();

            Map<Object, Collection> groups = values.doGroup( new OddEvener() );

            Integer functionalStop = Limits.getScriptStatements();

        Test.stopTest();

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
            'iterative ' +
            (iterativeStop - iterativeStart) + ' statements ' +
            '[' + iterativeStart + ',' + iterativeStop + '] ' +
            'functional ' +
            (functionalStop - functionalStart) + ' statements ' +
            '[' + functionalStart + ',' +functionalStop + ']'
        );
    }

    private static testMethod void testGroupingReducerTypes()
    {
        Collection.Reducer grouper = new Collection.GroupingReducer( new OddEvener() );

        Test.startTest();

            Type inputType = grouper.getInputType();
            Type outputType = grouper.getOutputType();

        Test.stopTest();

        System.assertEquals( Integer.class, inputType );
        System.assertEquals( Type.forName('Map<String, Integer>'), outputType );
    }

    public class OddEvener implements Collection.Mapper
    {
        public Object doMap( Object input )
        {
            return Math.mod( (Integer)input, 2 ) == 0 ? 'even' : 'odd';
        }

        public Type getInputType()
        {
            return Integer.class;
        }

        public Type getOutputType()
        {
            return String.class;
        }
    }
}
