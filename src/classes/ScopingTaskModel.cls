public with sharing class ScopingTaskModel extends ListModel.Element {
	public Id id { get; private set; }
	public Id featureId			{ get; set; }
	public String name			{ get; set; }
	public String details		{ get; set; }
	public Decimal estimate50	{ get; set; }
	public Decimal estimate90	{ get; set; }
	private Scoping_Task__c record;
	
	public Scoping_Task__c getRecord()
	{
		if( null == record )
		{
			record = new Scoping_Task__c( Id = id );
			
			record.Scoping_Feature__c	= featureId;
			record.Name					= name;
			record.Details__c			= details;
			record.X50_Estimate__c		= estimate50;
			record.X90_Estimate__c		= estimate90;
		}
		record.Sort_Order__c = index;
		
		return record;
	}
	
	public void setRecord( Scoping_Task__c recordIn )
	{
		id			= recordIn.Id;
		featureId	= recordIn.Scoping_Feature__c;
		name		= recordIn.Name;
		details		= recordIn.Details__c;
		estimate50	= recordIn.X50_Estimate__c;
		estimate90	= recordIn.X90_Estimate__c;
	}
}