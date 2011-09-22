@isTest
private class TestScopingTaskModel {
	static testMethod void testGetRecord()
	{
		final String name = 'Test Name';
		final String details = 'Some details about this test scoping task.';
		
		Scope__c scope = new Scope__c();
		insert scope;
		
		Scoping_Feature__c feature = new Scoping_Feature__c();
		feature.Scope__c = scope.Id;
		insert feature;
		
		ScopingTaskModel model = new ScopingTaskModel();
		model.featureId = feature.Id;
		model.name = name;
		model.details = details;
				
		Test.startTest();
			Scoping_Task__c record = model.getRecord();
		Test.stopTest();
				
		System.assertNotEquals( null, record, 'The model should return a record.' );
		System.assertEquals( feature.Id, record.Scoping_Feature__c, 'The parent Feature should be populated.' );
	}
	
	static testMethod void testInsertRecord()
	{
		Scope__c scope = new Scope__c();
		insert scope;
		
		Scoping_Feature__c feature = new Scoping_Feature__c();
		feature.Scope__c = scope.Id;
		insert feature;
		
		ScopingTaskModel model = new ScopingTaskModel();
		model.featureId = feature.Id;
		//model.name = name;
		//model.details = details;
		model.estimate50 =1;
				
		Test.startTest();
			insert model.getRecord();
		Test.stopTest();
		
		System.assertNotEquals( null, model.getRecord(), 'maybe it would be, though?' );
	}
}