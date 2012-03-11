global with sharing class ScopeModel {
	public Id id { get; private set; }
	public String name { get; set; }
	public Decimal codeReview { get; set; }
	public Decimal deployment { get; set; }
	public Decimal projectManagement { get; set; }
	public Decimal buffer { get; set; }
	public Decimal reactive { get; set; }
	public Decimal testing { get; set; }
	
	public Decimal estimate50 { get; private set; }
	public Decimal total { get; private set; }
	
	private ListModel featureList;
	
	public ScopeModel()
	{
		featureList = new ListModel();
	}
	
	public List<ScopingFeatureModel> features
	{
		get
		{
			List<ScopingFeatureModel> models = new List<ScopingFeatureModel>();
			for( ListModel.Element el : featureList.getList() )
			{
				models.add((ScopingFeatureModel)el);
			}
			return models;
		}
	}
	
	public ScopingFeatureModel addFeature()
	{
		ScopingFeatureModel feature = new ScopingFeatureModel();
		featureList.add(feature);
		return feature;
	}
	
	public ScopingFeatureModel addFeature(Scoping_Feature__c featureRecord)
	{
		ScopingFeatureModel feature = new ScopingFeatureModel();
		
		feature.setRecord( featureRecord );
		
		featureList.add( feature );
		
		return feature;
	}
	
	public void moveFeature( Integer fromIndex, Integer toIndex )
	{
		featureList.move( fromIndex, toIndex );
	}
	
	private Decimal sumEstimates()
	{
		Decimal sum = 0;
		
		for( ScopingFeatureModel feature : features )
		{
			for( ScopingTaskModel task : feature.tasks )
			{
				sum += task.estimate50;
			}
		}
		
		return sum;
	}
	
	public Scope__c getRecord()
	{
		Scope__c record = new Scope__c( Id = id );
		
		record.Name						= name;
		record.Code_Review__c			= codeReview;
		record.Deployment__c			= deployment;
		record.Project_Management__c	= projectManagement;
		record.Buffer__c				= buffer;
		record.Reactive__c				= reactive;
		record.Testing__c				= testing;
		record.Sum_of_X50_Estimates__c	= sumEstimates();
		
		return record;
	}
	
	public void setRecord( Scope__c record )
	{
		id					= record.Id;
		name				= record.Name;
		codeReview			= record.Code_Review__c;
		deployment			= record.Deployment__c;
		projectManagement	= record.Project_Management__c;
		buffer				= record.Buffer__c;
		reactive			= record.Reactive__c;
		testing				= record.Testing__c;
		
		total				= record.Total__c;
		estimate50			= record.Sum_of_X50_Estimates__c;
	}
}