@isTest
private class TestScopingFeatureModel
{
	static final String TEST_NAME = 'Test Feature';
	static final Integer NUM_TASKS		= 7;
	static final Integer AN_INDEX		= 4;
	static final Integer ANOTHER_INDEX	= 2;
	static final String  SEARCH_TAG		= 'TAG__X__TASK';
		
	static testMethod void testGetRecord()
	{
		Scope__c scope = new Scope__c();
		insert scope;
		
		ScopingFeatureModel model = new ScopingFeatureModel();
		
		model.scopeId	= scope.Id;
		model.name		= TEST_NAME;
		
		Test.startTest();
		
			Scoping_Feature__c record = model.getRecord();
			
		Test.stopTest();
				
		System.assertNotEquals( null, record, 'The model should return a record.' );
		System.assertEquals( scope.Id, record.Scope__c, 'The parent Scope should be populated.' );
		System.assertEquals( TEST_NAME, record.Name, 'The Name should be populated.' );
	}
	
	static testMethod void testSetRecord()
	{
		Scoping_Feature__c featureRecord = new Scoping_Feature__c();
		
		featureRecord.Name = TEST_NAME;
		
		Test.startTest();
		
			ScopingFeatureModel feature = new ScopingFeatureModel();
			feature.setRecord( featureRecord );
			
		Test.stopTest();
		
		System.assertEquals( TEST_NAME, feature.name, 'The feature\'s name should be set.' );
	}
	
	static testMethod void testAddTask()
	{
		ScopingFeatureModel model = new ScopingFeatureModel();
		
		Test.startTest();
		
			ScopingTaskModel task = model.addTask();
		
		Test.stopTest();
		
		System.assertEquals( 1, model.tasks.size(),		'The model should have a single task.'		);
		System.assertEquals( model.id, task.featureId,	'The new task should point to the feature.'	);
	}
	
	static testMethod void testAddTaskFromRecord()
	{
		ScopingFeatureModel model = new ScopingFeatureModel();
		
		Scoping_Task__c taskRecord = new Scoping_Task__c();
		taskRecord.Name = TEST_NAME;
		
		Test.startTest();
		
			ScopingTaskModel task = model.addTask( taskRecord );
		
		Test.stopTest();
		
		System.assertEquals( 1, model.tasks.size(),	'The model should have a single task.'	);
		System.assertEquals( TEST_NAME, task.name,	'The existing task should be added.'	);
	}
	
	static testMethod void testRemoveTask()
	{
		ScopingFeatureModel model = new ScopingFeatureModel();
		
		for( Integer i = NUM_TASKS; i > 0; i-- )
		{
			model.addTask();
		}

		model.tasks[AN_INDEX].Name = SEARCH_TAG;
		
		Test.startTest();
		
			ScopingTaskModel task = model.removeTask( AN_INDEX );
			
		Test.stopTest();
		
		System.assertNotEquals( null, task, 'The removed task should be returned.' );
		
		System.assertEquals( NUM_TASKS - 1, model.tasks.size(),	'One task should be removed.'			);
		System.assertEquals( SEARCH_TAG, task.Name,				'The correct task should be removed.'	);
	}
	
	static testMethod void testPutTask()
	{
		ScopingFeatureModel model = new ScopingFeatureModel();
		
		for( Integer i = NUM_TASKS; i > 0; i-- )
		{
			model.addTask();
		}

		ScopingTaskModel task = new ScopingTaskModel();
		task.Name = SEARCH_TAG;
		
		Test.startTest();
		
			model.putTask( AN_INDEX, task );
			
		Test.stopTest();
		
		System.assertEquals( NUM_TASKS + 1, model.tasks.size(),			'One task should be inserted.'						);
		System.assertEquals( SEARCH_TAG, model.tasks[AN_INDEX].Name,	'The task should be inserted in the correct place.'	);
	}
	
	static testMethod void testMoveTask()
	{
		ScopingFeatureModel model = new ScopingFeatureModel();
		
		for( Integer i = NUM_TASKS; i > 0; i-- )
		{
			model.addTask();
		}

		model.tasks[AN_INDEX].Name = SEARCH_TAG;
		
		Test.startTest();
			model.moveTask( AN_INDEX, ANOTHER_INDEX );
		Test.stopTest();
		
		System.assertEquals( NUM_TASKS, model.tasks.size(),					'The number of tasks should be the same.'			);
		System.assertEquals( SEARCH_TAG, model.tasks[ANOTHER_INDEX].Name,	'The task should be moved to the correct place.'	);
	}
}