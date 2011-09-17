public with sharing class ScopingTaskModel {
	public Id id { get; private set; }
	public Id featureId { get; set; }
	public String name { get; set; }
	public String details { get; set; }
	public Decimal estimate50 { get; set; }
	public Decimal estimate90 { get; set; }
	
	public Scoping_Task__c getRecord()
	{
		Scoping_Task__c record = new Scoping_Task__c( Id = id );
		
		record.Scoping_Feature__c = featureId;
		record.Name = name;
		record.Details__c = details;
		record.X50_Estimate__c = estimate50;
		record.X90_Estimate__c = estimate90;
		
		return record;
	}
	
	public void setRecord( Scoping_Task__c record )
	{
		id = record.Id;
		featureId = record.Scoping_Feature__c;
		name = record.Name;
		details = record.Details__c;
		estimate50 = record.X50_Estimate__c;
		estimate90 = record.X90_Estimate__c;
	}
}