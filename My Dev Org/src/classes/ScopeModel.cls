global with sharing class ScopeModel {
	public Id id { get; set; }
	public String name { get; set; }
	
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
		
		return record;
	}
}