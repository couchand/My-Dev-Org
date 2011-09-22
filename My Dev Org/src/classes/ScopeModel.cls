global with sharing class ScopeModel {
	public Id id { get; private set; }
	public String name { get; set; }
	public Decimal codeReview { get; set; }
	public Decimal deployment { get; set; }
	public Decimal projectManagement { get; set; }
	public Decimal reactive { get; set; }
	public Decimal testing { get; set; }
	
	public Decimal total { get; private set; }
	public Decimal estimate50 { get; private set; }
	
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
	
	public void addFeature()
	{
		featureList.add(new ScopingFeatureModel());
	}
	
	public ScopingFeatureModel addFeature(Scoping_Feature__c featureRecord)
	{
		ScopingFeatureModel feature = new ScopingFeatureModel();
		
		feature.setRecord( featureRecord );
		
		featureList.add( feature );
		
		return feature;
	}
	
	public Scope__c getRecord()
	{
		Scope__c record = new Scope__c( Id = id );
		
		record.Name						= name;
		record.Code_Review__c			= codeReview;
		record.Deployment__c			= deployment;
		record.Project_Management__c	= projectManagement;
		record.Reactive__c				= reactive;
		record.Testing__c				= testing;
		
		return record;
	}
	
	public void setRecord( Scope__c record )
	{
		id					= record.Id;
		name				= record.Name;
		codeReview			= record.Code_Review__c;
		deployment			= record.Deployment__c;
		projectManagement	= record.Project_Management__c;
		reactive			= record.Reactive__c;
		testing				= record.Testing__c;
		
		total				= record.Total__c;
		estimate50			= record.Sum_of_X50_Estimates__c;
	}
}