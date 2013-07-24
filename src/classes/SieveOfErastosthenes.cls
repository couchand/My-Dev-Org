@isTest
private class SieveOfErastosthenes
{
    private static testMethod void testSieve()
    {
        Integer n = 10;
        Collection.Mapper countFromTwo = new Unfolder.CountFrom( 2 );
        Collection a = Collection.doUnfold( countFromTwo, n );
        List<Integer> result = new List<Integer>();

        Test.startTest();

            while ( !a.isEmpty() )
            {
                Integer p = (Integer)a.shift();

                Collection.Mapper selectModP = new Selector.NotDivisibleBy( p );

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
