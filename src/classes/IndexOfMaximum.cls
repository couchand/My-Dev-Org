@isTest
private class IndexOfMaximum
{
    private static testMethod void testIndex()
    {
        Collection.Reducer maximum = new Reducer.Maximum();
        Collection.Reducer firstIndex;
        List<Integer> inputs = new List<Integer>{ 3, 1, 4, 1, 5, 9 };
        Collection a = new Collection( inputs );

        Test.startTest();

            Integer theMax = (Integer)a.doReduce( maximum );
            firstIndex = new Reducer.FirstIndex( theMax );
            Integer firstMaxIndex = (Integer)a.doReduce( firstIndex );

        Test.stopTest();

        System.assertEquals( 5, firstMaxIndex );
    }
}
