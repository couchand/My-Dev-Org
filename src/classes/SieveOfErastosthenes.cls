@isTest
private class SieveOfErastosthenes
{
    public class CountFromMapper implements Collection.Mapper
    {
        Integer count;

        public CountFromMapper( Integer min )
        {
            count = min;
        }

        public Object doMap( Object input )
        {
            if ( count > (Integer)input )
            {
                return null;
            }
            return count++;
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

    public class NotDivisibleSelector implements Collection.Mapper
    {
        Integer mod;

        public NotDivisibleSelector( Integer mod )
        {
            this.mod = mod;
        }

        public Object doMap( Object input )
        {
            return 0 != Math.mod( (Integer)input, mod );
        }

        public Type getInputType()
        {
            return Integer.class;
        }

        public Type getOutputType()
        {
            return Boolean.class;
        }
    }

    private static testMethod void testSieve()
    {
        Integer n = 10;
        Collection.Mapper countFromTwo = new CountFromMapper( 2 );
        Collection a = Collection.doUnfold( countFromTwo, n );
        List<Integer> result = new List<Integer>();

        Test.startTest();

            while ( !a.isEmpty() )
            {
                Integer p = (Integer)a.shift();

                Collection.Mapper selectModP = new NotDivisibleSelector( p );

                a = a.doSelect( selectModP );

                result.add( p );
            }

        Test.stopTest();

        List<Integer> primes = new List<Integer>{ 2, 3, 5, 7 };

        for ( Integer i = 0; i < primes.size(); i++  )
        {
            System.assertEquals( primes[i], result[i], '' + result );
        }
    }
}
