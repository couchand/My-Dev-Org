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
	
	public void addTask()
	{
		scope.features[0].addTask();
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
		
	}
}