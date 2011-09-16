public with sharing class ScopingFeatureModel {
	public Id scopeId { get; set; }
	public Id id { get; set; }
	public String name { get; set; }
	
	public List<ScopingTaskModel> tasks
	{
		get
		{
			if (null == tasks)
				tasks = new List<ScopingTaskModel>();
			return tasks;
		}
		private set;
	}
	
	public ScopingFeatureModel()//Id scopeId)
	{
		//this.scopeId = scopeId;
	}
	
	public void addTask()
	{
		tasks.add(new ScopingTaskModel());
	}
	
	public Scoping_Feature__c getRecord()
	{
		Scoping_Feature__c record = new Scoping_Feature__c();
		
		record.Scope__c = scopeId;
		record.Name = name;
		
		return record;
	}
}