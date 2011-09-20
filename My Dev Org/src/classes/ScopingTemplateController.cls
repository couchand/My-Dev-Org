global with sharing class ScopingTemplateController {
	public ScopeModel scope
	{
		get
		{
			if (null == scope){
				
				Id scopeId = ApexPages.currentPage().getParameters().get('id');
				if (null != scopeId)
					scope = loadScope(scopeId);
				else
					scope = new ScopeModel();
					
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
		scope.features[0].addTask();
	}
	
	public ScopeModel loadScope( Id scopeId )
	{
		ScopeModel scope = new ScopeModel();
		
		Scope__c scopeRecord = [SELECT Id, Name,
									   Code_Review__c, Deployment__c, Project_Management__c,
									   Reactive__c, Testing__c, Sum_of_X50_Estimates__c, Total__c
								FROM Scope__c
								WHERE Id = :scopeId];
								
		scope.setRecord( scopeRecord );
		
		List<Scoping_Feature__c> featureRecords = [SELECT Id, Name, Scope__c,
														(SELECT Id, Name, Scoping_Feature__c,
																Details__c, X50_Estimate__c, X90_Estimate__c
														 FROM Scoping_Tasks__r)
													FROM Scoping_Feature__c
													WHERE Scope__c = :scopeId];
		
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
	
	/*@RemoteAction global static ScopeModel getNewModel()
	{
		ScopeModel model = new ScopeModel();
		model.name = 'SCOPE';
		model.addFeature();
		model.features[0].name = 'FEATURE';
		model.features[0].addTask();
		model.features[0].tasks[0].name = 'TASK';
		return model;
	}
	
	@RemoteAction global static void saveModel( String modelJSON )
	{
		ScopeModel model = new ScopeModel();
		Scope__c record;
		List<Scoping_Feature__c> features = new List<Scoping_Feature__c>();
		
		JSONObject json = new JSONObject( modelJSON );
		
		model.name = json.getString('name');
		
		record = model.getRecord();
		upsert record;

		for( JSONObject.Value jsonFeature : (List<JSONObject.Value>)json.get('features') )
		{
			ScopingFeatureModel feature = new ScopingFeatureModel();
			
			feature.scopeId = record.Id;
			feature.name = ((JSONObject)jsonFeature.valueToObject()).getString('name');
			
			features.add( feature.getRecord() );
		}
		
		upsert features;
		
	}*/
}