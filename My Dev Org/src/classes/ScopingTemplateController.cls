global with sharing class ScopingTemplateController {
	public ScopeModel scope
	{
		get
		{
			if (null == scope)
				scope = new ScopeModel();
			
			return scope;
		}
		set;
	}
	
	public void addFeature()
	{
		scope.addFeature();
	}
	
	public void saveScope()
	{
		Scope__c scopeRecord = scope.getRecord();
		insert scopeRecord;
		
		List<Scoping_Feature__c> featureRecords = new List<Scoping_Feature__c>();
		List<Scoping_Task__c> taskRecords = new List<Scoping_Task__c>();
		
		for( ScopingFeatureModel feature : scope.features )
		{
			feature.scopeId = scopeRecord.Id;

			Scoping_Feature__c featureRecord = feature.getRecord();
			
			featureRecords.add( feature.getRecord() );
			
			insert featureRecord;
			
			feature.Id = featureRecord.Id;
		}
		
		for( ScopingFeatureModel feature : scope.features )
		{
			for( ScopingTaskModel task : feature.tasks )
			{
				task.featureId = feature.Id;
				
				taskRecords.add( task.getRecord() );
			}
		}
		
		insert taskRecords;
	}
	
	@RemoteAction global static ScopeModel getNewModel()
	{
		ScopeModel model = new ScopeModel();
		model.name = 'SCOPE';
		model.addFeature();
		model.features[0].name = 'FEATURE';
		model.features[0].addTask();
		model.features[0].tasks[0].name = 'TASK';
		return model;
	}
	
	@RemoteAction global static void saveModel( ScopeModel model )
	{
		upsert model;
	}
}