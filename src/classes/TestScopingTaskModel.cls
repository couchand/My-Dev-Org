@isTest
private class TestScopingTaskModel {
	static final String  NAME			= 'X__TEST_NAME__X';
	static final String  DETAILS		= 'X__TEST_DETAILS__X';
	static final Decimal ESTIMATE_50	= 4;
	static final Decimal ESTIMATE_90	= 7;
	
	static testMethod void testProperties()
	{
		ScopingTaskModel task = new ScopingTaskModel();
		
		Test.startTest();
		
			task.name		= NAME;
			task.details	= DETAILS;
			task.estimate50	= ESTIMATE_50;
			task.estimate90	= ESTIMATE_90;
			
		Test.stopTest();
		
		System.assertEquals( NAME,			task.name,			'The task name should be set.'			);
		System.assertEquals( DETAILS,		task.details,		'The task details should be set.'		);
		System.assertEquals( ESTIMATE_50,	task.estimate50,	'The task 50% estimate should be set.'	);
		System.assertEquals( ESTIMATE_90,	task.estimate90,	'The task 90% estimate should be set.'	);
	}

	static testMethod void testGetRecord()
	{
		ScopeModel scope = new ScopeModel();		
		ScopingFeatureModel feature = scope.addFeature();
		
		insert scope.getRecord();
		insert feature.getRecord();
		
		ScopingTaskModel task = feature.addTask();
		
		task.name		= NAME;
		task.details	= DETAILS;
		task.estimate50	= ESTIMATE_50;
		task.estimate90	= ESTIMATE_90;
				
		Test.startTest();
			Scoping_Task__c taskRecord = task.getRecord();
		Test.stopTest();
				
		System.assertNotEquals( null, taskRecord, 'The model should return a record.' );
		
		System.assertEquals( feature.id,	taskRecord.Scoping_Feature__c,	'The parent Feature should be populated.'	);
		System.assertEquals( NAME,		  	taskRecord.Name,				'The task name should be set.'				);
		System.assertEquals( DETAILS,		taskRecord.Details__c,			'The task name should be set.'				);
		System.assertEquals( ESTIMATE_50,	taskRecord.X50_Estimate__c,		'The task name should be set.'				);
		System.assertEquals( ESTIMATE_90,	taskRecord.X90_Estimate__c,		'The task name should be set.'				);
	}
	
	static testMethod void testInsertRecord()
	{
		ScopeModel scope = new ScopeModel();		
		ScopingFeatureModel feature = scope.addFeature();
		
		insert scope.getRecord();
		insert feature.getRecord();
		
		ScopingTaskModel task = feature.addTask();
		
		task.name		= NAME;
		task.details	= DETAILS;
		task.estimate50	= ESTIMATE_50;
		task.estimate90	= ESTIMATE_90;
				
		Test.startTest();
		
			insert task.getRecord();
			
		Test.stopTest();
		
		Id modelId = task.getRecord().id;
		
		System.assertNotEquals( null, modelId, 'The model should know the new Id.' );
		
		Scoping_Task__c taskRecord = [SELECT Id, Name, Details__c, X50_Estimate__c, X90_Estimate__c, Scoping_Feature__c
										FROM Scoping_Task__c WHERE Id = :modelId];
		
		System.assertEquals( feature.id,	taskRecord.Scoping_Feature__c,	'The parent Feature should be populated.'	);
		System.assertEquals( NAME,			taskRecord.Name,				'The task name should be set.'				);
		System.assertEquals( DETAILS,		taskRecord.Details__c,			'The task details should be set.'			);
		System.assertEquals( ESTIMATE_50,	taskRecord.X50_Estimate__c,		'The task 50% estimate should be set.'		);
		System.assertEquals( ESTIMATE_90,	taskRecord.X90_Estimate__c,		'The task 90% estimate should be set.'		);
	}
	
	static testMethod void testSetRecord()
	{
		ScopeModel scope = new ScopeModel();		
		ScopingFeatureModel feature = scope.addFeature();
		
		insert scope.getRecord();
		insert feature.getRecord();
		
		ScopingTaskModel task = feature.addTask();
		
		task.name		= NAME;
		task.details	= DETAILS;
		task.estimate50	= ESTIMATE_50;
		task.estimate90	= ESTIMATE_90;
		
		insert task.getRecord();
				
		Test.startTest();
		
			ScopingTaskModel copy = new ScopingTaskModel();
			copy.setRecord( task.getRecord() );
			
		Test.stopTest();
		
		System.assertEquals( NAME,			copy.name,			'The task name should be set.'			);
		System.assertEquals( DETAILS,		copy.details,		'The task details should be set.'		);
		System.assertEquals( ESTIMATE_50,	copy.estimate50,	'The task 50% estimate should be set.'	);
		System.assertEquals( ESTIMATE_90,	copy.estimate90,	'The task 90% estimate should be set.'	);
	}
}