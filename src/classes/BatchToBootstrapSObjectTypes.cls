global class BatchToBootstrapSObjectTypes implements Database.Batchable<String>, Database.Stateful
{
	public static final String BATCH_NAME = 'BootstrapSObjectTypes';
	public static final String[] ERROR_EMAILS = new String[]{ 'acouch@bluewolf.com' };
	
	global String errors = '';
	global Map<String, Schema.SObjectType> globalDescribe;
	
	global BatchToBootstrapSObjectTypes()
	{
		globalDescribe = Schema.getGlobalDescribe();
	}
	
	global List<String> start( Database.BatchableContext BC )
	{
		return new List<String>( globalDescribe.keySet() );
	}
	
	global void execute( Database.BatchableContext BC, List<String> scope )
	{
		List<SObjectType__c> objectsToInsert = new List<SObjectType__c>();
		
		for (  String someObject : scope )
		{
			Schema.SObjectType token = globalDescribe.get( someObject );
			Schema.DescribeSObjectResult objectDescribe = token.getDescribe();
			
			SObjectType__c objectType = new SObjectType__c();
			
			objectType.Name = objectDescribe.getName();
			objectType.Label__c = objectDescribe.getLabel();
			objectType.Plural_Label__c = objectDescribe.getLabelPlural();
			objectType.Key_Prefix__c = objectDescribe.getKeyPrefix();
			
			objectsToInsert.add( objectType );
		}
		try
		{
			insert objectsToInsert;
		}
		catch( DMLException ex )
		{
			for( Integer i = 0; i < ex.getNumDml(); i++ )
			{
				errors += ex.getDmlMessage(i) + '\n';
			}
		}
	}
	
	global void finish( Database.BatchableContext BC ){
		
		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
							JobItemsProcessed, TotalJobItems,
							CreatedBy.Email
							FROM AsyncApexJob
							WHERE Id =:bc.getJobId()];
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		mail.setToAddresses( ERROR_EMAILS );
		mail.setSubject( 'Batch to ' + BATCH_NAME + ' ' + job.Status );
		
		String emailBody = 'Batch to ' + BATCH_NAME + ' processed '
						+ job.TotalJobItems
						+ ' batches with '
						+ job.NumberOfErrors
						+ ' failures.';
		if( errors != '' )
		{
			emailBody += '\n\n\nThe following errors occured:\n'+ errors;
		}
		
		mail.setPlainTextBody( emailBody );
		Messaging.sendEmail( new Messaging.SingleEmailMessage[]{ mail } );
	}
	
	private static testMethod void testBatch()
	{
		Test.startTest();
		
			Database.executeBatch( new BatchToBootstrapSObjectTypes() );
		
		Test.stopTest();
		
		// @TODO: implement test
	}
}