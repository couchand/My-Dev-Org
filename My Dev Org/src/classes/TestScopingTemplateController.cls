@isTest
private class TestScopingTemplateController
{/*
	static testMethod void testAddFeature()
	{
		ScopingTemplateController controller = new ScopingTemplateController();
		Test.setCurrentPage(Page.ScopingTemplate);
		
		Test.startTest();
			controller.addFeature();
		Test.stopTest();
		
		ScopeModel model = controller.scope;
		
		System.assertEquals( 1, model.features.size(), 'The Scope model should have one feature.' );
	}
	
	static testMethod void testSaveScope()
	{
		final String TEST_PROJECT_NAME = 'Test Project for Scope';
		final String TEST_FEATURE_NAME = 'Test Feature for Scope';
		final String TEST_TASK_NAME = 'Test Task for Scope';
		
		ScopingTemplateController controller = new ScopingTemplateController();
		Test.setCurrentPage(Page.ScopingTemplate);
		
		controller.scope.Name = TEST_PROJECT_NAME;
			
		controller.addFeature();
		controller.scope.features[0].name = TEST_FEATURE_NAME;
		
		controller.scope.features[0].addTask();
		controller.scope.features[0].tasks[0].name = TEST_TASK_NAME;
		controller.scope.features[0].tasks[0].estimate50 = 1;
		
		Test.startTest();
			controller.saveScope();
		Test.stopTest();
		
		Scope__c record = [SELECT Id, Name, (SELECT Name, Scope__c FROM Scoping_Features__r) FROM Scope__c  ORDER BY CreatedDate DESC LIMIT 1];
		
		System.assertEquals( TEST_PROJECT_NAME, record.Name, 'The Project Name should be populated.' );
		System.assertEquals( 1, record.Scoping_Features__r.size(), 'The Scope model should have one feature.' );
		System.assertEquals( record.Id, record.Scoping_Features__r[0].Scope__c, 'The Feature\'s Scope ID should be populated.' );
		System.assertEquals( TEST_FEATURE_NAME, record.Scoping_Features__r[0].Name, 'The Feature Name should be populated.' );
		
		List<Scoping_Task__c> taskRecords = [SELECT Name, Scoping_Feature__c FROM Scoping_Task__c WHERE Scoping_Feature__c = :record.Scoping_Features__r[0].Id];
		
		System.assertEquals( 1, taskRecords.size(), 'The Scope model should have one task.' );
		System.assertEquals( record.Id, taskRecords[0].Scoping_Feature__c, 'The Task\'s Feature ID should be populated.' );
		System.assertEquals( TEST_FEATURE_NAME, taskRecords[0].Name, 'The Task Name should be populated.' );
	}*/
}