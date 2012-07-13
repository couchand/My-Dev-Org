public with sharing class ScopingFeatureModel extends ListModel.Element {
	public Id id { get; private set; }
	public Id scopeId	{ get; set; }
	public String name	{ get; set; }
	private Scoping_Feature__c record; 
	
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
	
	public ScopingFeatureModel()
	{
		taskList = new ListModel();
	}
	
	public ScopingTaskModel addTask()
	{
		ScopingTaskModel task = new ScopingTaskModel();
		taskList.add( task );
		
		if( null != id ) task.featureId = id;
		
		return task;
	}
	
	public ScopingTaskModel removeTask( Integer index )
	{
		return (ScopingTaskModel)taskList.remove( index );
	}
	
	public void putTask( Integer index, ScopingTaskModel task )
	{
		taskList.put( index, task );
	}
	
	public void moveTask( Integer fromIndex, Integer toIndex )
	{
		taskList.move( fromIndex, toIndex );
	}
	
	public ScopingTaskModel addTask( Scoping_Task__c taskRecord )
	{
		ScopingTaskModel task = new ScopingTaskModel();
		
		task.setRecord(taskRecord);
		
		taskList.add(task);
		
		return task;
	}
	
	public void setRecord( Scoping_Feature__c recordIn )
	{
		id		= recordIn.Id;
		scopeId = recordIn.Scope__c;
		name	= recordIn.Name;
	}
	
	public Scoping_Feature__c getRecord()
	{
		if( null == record )
		{
			record = new Scoping_Feature__c( Id = id );
			
			record.Scope__c = scopeId;
			record.Name		= name;
		}
		
		record.Sort_Order__c = index;
		
		return record;
	}
}