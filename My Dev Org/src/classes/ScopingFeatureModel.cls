public with sharing class ScopingFeatureModel extends ListModel.Element {
	public Id scopeId { get; set; }
	public Id id { get; private set; }
	public String name { get; set; }
	
	private ListModel taskList;
	
	public List<ScopingTaskModel> tasks
	{
		get
		{
			List<ScopingTaskModel> models = new List<ScopingTaskModel>();
			for( ListModel.Element el : taskList.getList() )
			{
				models.add((ScopingTaskModel)el);
			}
			return models;
		}
	}
	
	public ScopingFeatureModel()//Id scopeId)
	{
		//this.scopeId = scopeId;
		taskList = new ListModel();
	}
	
	public void addTask()
	{
		taskList.add(new ScopingTaskModel());
	}
	
	public ScopingTaskModel addTask(Scoping_Task__c taskRecord)
	{
		ScopingTaskModel task = new ScopingTaskModel();
		
		task.setRecord(taskRecord);
		
		taskList.add(task);
		
		return task;
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