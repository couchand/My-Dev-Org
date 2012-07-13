global with sharing class ScopingTemplateController {
	public static String OLD_FEATURE_TAG	{ get { return 'X_ofi'; } }
	public static String OLD_TASK_TAG		{ get { return 'X_oti'; } }
	public static String NEW_FEATURE_TAG	{ get { return 'X_nfi'; } }
	public static String NEW_TASK_TAG		{ get { return 'X_nti'; } }
	
	public ScopeModel scope
	{
		get
		{
			if (null == scope){
				
				Id scopeId = ApexPages.currentPage().getParameters().get('id');
				if (null != scopeId)
				{
					scope = loadScope(scopeId);
				}
				else
				{
					scope = new ScopeModel();
					ScopingFeatureModel feature = scope.addFeature();
					feature.addTask();
				}
					
			}	
			return scope;
		}
		set;
	}
	
	public void addFeature()
	{
		scope.addFeature();
	}
	
	public void addTask()
	{
		Integer featureIndex = Integer.valueOf( ApexPages.currentPage().getParameters().get( NEW_FEATURE_TAG ) );
		scope.features[featureIndex].addTask();
	}
	
	public void moveTask()
	{
		try{
			Map<String, String> params = ApexPages.currentPage().getParameters();
		
			Integer oldFeatureIndex	= Integer.valueOf( params.get( OLD_FEATURE_TAG ) ),
					oldTaskIndex	= Integer.valueOf( params.get( OLD_TASK_TAG ) ),
					newFeatureIndex	= Integer.valueOf( params.get( NEW_FEATURE_TAG ) ),
					newTaskIndex	= Integer.valueOf( params.get( NEW_TASK_TAG ) );
			
			if( oldFeatureIndex == newFeatureIndex )
			{
				scope.features[oldFeatureIndex].moveTask( oldTaskIndex, newTaskIndex );
			}
			else
			{
				ScopingTaskModel task = scope.features[oldFeatureIndex].removeTask( oldTaskIndex );
				scope.features[newFeatureIndex].putTask( newTaskIndex, task );
			}
		}
		catch( Exception e )
		{
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.FATAL, e.getMessage() ) );
		}
	}
	
	public void moveFeature()
	{
		try{
			Map<String, String> params = ApexPages.currentPage().getParameters();
		
			Integer oldFeatureIndex	= Integer.valueOf( params.get( OLD_FEATURE_TAG ) ),
					newFeatureIndex	= Integer.valueOf( params.get( NEW_FEATURE_TAG ) );
			
			scope.moveFeature( oldFeatureIndex, newFeatureIndex );
		}
		catch( Exception e )
		{
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.FATAL, e.getMessage() ) );
		}
	}
	
	public ScopeModel loadScope( Id scopeId )
	{
		ScopeModel scope = new ScopeModel();
		
		Scope__c scopeRecord = [SELECT Id, Name,
									   Code_Review__c, Deployment__c, Project_Management__c, Buffer__c,
									   Reactive__c, Testing__c, Sum_of_X50_Estimates__c, Total__c
								FROM Scope__c
								WHERE Id = :scopeId];
								
		scope.setRecord( scopeRecord );
		
		List<Scoping_Feature__c> featureRecords = [SELECT Id, Name, Scope__c,
														(SELECT Id, Name, Scoping_Feature__c,
																Details__c, X50_Estimate__c, X90_Estimate__c
														 FROM Scoping_Tasks__r
														 ORDER BY Sort_Order__c)
													FROM Scoping_Feature__c
													WHERE Scope__c = :scopeId
													ORDER BY Sort_Order__c];
		
		for( Scoping_Feature__c featureRecord : featureRecords )
		{
			ScopingFeatureModel feature = scope.addFeature(featureRecord);
			
			for( Scoping_Task__c taskRecord : featureRecord.Scoping_Tasks__r )
			{
				feature.addTask(taskRecord);
			}
		}
		
		return scope;
	}
	
	public void saveScope()
	{
		Scope__c scopeRecord = scope.getRecord();
		upsert scopeRecord;
		
		List<Scoping_Feature__c> featureRecords = new List<Scoping_Feature__c>();
		List<Scoping_Task__c> taskRecords = new List<Scoping_Task__c>();
		
		for( ScopingFeatureModel feature : scope.features )
		{
			feature.scopeId = scopeRecord.Id;

			Scoping_Feature__c featureRecord = feature.getRecord();
			
			featureRecords.add( feature.getRecord() );
			
			upsert featureRecord;
			
			for( ScopingTaskModel task : feature.tasks )
			{
				task.featureId = featureRecord.Id;
				
				taskRecords.add( task.getRecord() );
			}
		}
		
		upsert taskRecords;
	}
}