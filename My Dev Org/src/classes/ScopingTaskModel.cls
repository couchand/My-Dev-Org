public with sharing class ScopingTaskModel {
	public Id featureId { get; set; }
	public String name { get; set; }
	public String details { get; set; }
	public Decimal estimate50 { get; set; }
	
	public Scoping_Task__c getRecord()
	{
		Scoping_Task__c record = new Scoping_Task__c();
		
		record.Scoping_Feature__c = featureId;
		record.X50_Estimate__c = estimate50;
		
		return record;
	}
}