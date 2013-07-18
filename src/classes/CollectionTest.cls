@isTest private class CollectionTest
{
    static List<Integer> inputs = new List<Integer>{ 45, 62, 3, 22, 39, 54, 76, 43, 1, 55, 8 };
    static Collection values = new Collection( inputs );

    private static testMethod void testFor()
    {
        Integer expectedTotal = 0;

        for ( Integer input : inputs )
        {
            expectedTotal += input * input;
        }

        Test.startTest();

            Collection squared = values.doMap( new Squarer() );
            Object totalObj = squared.doReduce( new Summer() );

        Test.stopTest();

        System.assert( totalObj instanceof Integer );

        Integer actualTotal = (Integer)totalObj;

        System.assertEquals( expectedTotal, actualTotal );
    }

    public class Squarer implements Collection.Mapper
    {
        public Object doMap( Object input )
        {
            Integer value = input == null ? 0 : (Integer)input;

            return value * value;
        }
    }

    public class Summer implements Collection.Reducer
    {
        public Object doReduce( Object input, Object current )
        {
            Integer left  = input   == null ? 0 : (Integer)input;
            Integer right = current == null ? 0 : (Integer)current;

            return left + right;
        }
    }

    private static testMethod void testGroup()
    {
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

        Test.startTest();

            Map<Object, Collection> groups = values.doGroup( new OddEvener() );

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
    }

    public class OddEvener implements Collection.Mapper
    {
        public Object doMap( Object input )
        {
            Integer value = (Integer)input;

            return Math.mod( value, 2 ) == 0 ? 'even' : 'odd';
        }
    }
}
