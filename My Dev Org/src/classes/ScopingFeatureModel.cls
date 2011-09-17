public with sharing class ScopingFeatureModel {
	public Id scopeId { get; set; }
	public Id id { get; private set; }
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
	
	public void addTask(Scoping_Task__c taskRecord)
	{
		ScopingTaskModel task = new ScopingTaskModel();
		
		task.setRecord(taskRecord);
		
		tasks.add(task);
	}
	
	public void setRecord(Scoping_Feature__c record)
	{
		id = record.Id;
		scopeId = record.Scope__c;
		name = record.Name;
	}
	
	public Scoping_Feature__c getRecord()
	{
		Scoping_Feature__c record = new Scoping_Feature__c( Id = id );
		
		record.Scope__c = scopeId;
		record.Name = name;
		
		return record;
	}
}