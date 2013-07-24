@isTest
private class SieveOfErastosthenes
{
    private static testMethod void testSieve()
    {
        Integer n = 100;
        List<Integer> result = new List<Integer>();
        List<Integer> myA = new List<Integer>();
        List<Integer> primes = new List<Integer>();

        Benchmark iterative = new Benchmark();

        for ( Integer counter = 2; counter <= n; counter++ )
        {
            myA.add( counter );
        }

        while ( !myA.isEmpty() )
        {
            Integer p = myA.remove(0);

            List<Integer> newA = new List<Integer>();

            for ( Integer value : myA )
            {
                if ( Math.mod( value, p ) != 0 )
                {
                    newA.add( value );
                }
            }

            myA = newA;

            primes.add( p );
        }

        iterative.stop();

        Test.startTest();

            Benchmark functional = new Benchmark();

            Collection.Mapper countFromTwo = new Unfolder.CountFrom( 2 );
            Collection a = Collection.doUnfold( countFromTwo, n );

            while ( !a.isEmpty() )
            {
                Integer p = (Integer)a.shift();

                Collection.Mapper selectModP = new Selector.NotDivisibleBy( p );

                a = a.doSelect( selectModP );

                result.add( p );
            }

            functional.stop();

        Test.stopTest();

        for ( Integer i = 0; i < primes.size(); i++  )
        {
            System.assertEquals( primes[i], result[i], '' + result );
        }

        System.assert( false,
            'iterative ' + iterative.getNetUsage('ScriptStatements') + ' statements ' +
            'functional ' + functional.getNetUsage('ScriptStatements') + ' statements '
        );
    }
}
