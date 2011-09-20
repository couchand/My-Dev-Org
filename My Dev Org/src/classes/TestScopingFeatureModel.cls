@isTest
private class TestScopingFeatureModel {/*
	static testMethod void testGetRecord()
	{
		final String TEST_NAME = 'Test Scope';

		Scope__c scope = new Scope__c();
		insert scope;
		
		ScopingFeatureModel model = new ScopingFeatureModel();
		model.scopeId = scope.Id;
		model.name = TEST_NAME;
		
		Test.startTest();
			Scoping_Feature__c record = model.getRecord();
		Test.stopTest();
				
		System.assertNotEquals( null, record, 'The model should return a record.' );
		System.assertEquals( scope.Id, record.Scope__c, 'The parent Scope should be populated.' );
		System.assertEquals( TEST_NAME, record.Name, 'The Name should be populated.' );
	}
	
	static testMethod void testAddTask()
	{
		ScopingFeatureModel model = new ScopingFeatureModel();
		
		Test.startTest();
			model.addTask();
		Test.stopTest();
		
		System.assertEquals( 1, model.tasks.size(), 'The model should have a single feature.' );
	}*/
}