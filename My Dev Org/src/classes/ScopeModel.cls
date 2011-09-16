global with sharing class ScopeModel {
	public Id id { get; set; }
	public String name { get; set; }
	public Decimal codeReview { get; set; }
	public Decimal deployment { get; set; }
	public Decimal projectManagement { get; set; }
	public Decimal reactive { get; set; }
	public Decimal testing { get; set; }
	
	public List<ScopingFeatureModel> features
	{
		get
		{
			if (null == features)
				features = new List<ScopingFeatureModel>();
			return features;
		}
		private set;
	}
	
	public void addFeature()
	{
		features.add(new ScopingFeatureModel());
	}
	
	public Scope__c getRecord()
	{
		Scope__c record = new Scope__c();
		
		record.Name = name;
		record.Code_Review__c = codeReview;
		record.Deployment__c = deployment;
		record.Project_Management__c = projectManagement;
		record.Reactive__c = reactive;
		record.Testing__c = testing;
		
		return record;
	}
}