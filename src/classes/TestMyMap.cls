@isTest
private class TestMyMap {

    static testMethod void myUnitTest() {
        Map<String,SObject> thisMap = MyMap.getMap( [SELECT Id, FirstName, LastName FROM Contact], 'FirstName');
        
        for( String a : thisMap.keySet() )
        	system.debug( 'key:' + a + ' val:' + thisMap.get( a ) );
    }
}