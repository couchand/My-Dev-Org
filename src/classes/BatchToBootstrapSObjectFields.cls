global class BatchToBootstrapSObjectFields implements Database.Batchable<SObject>, Database.Stateful
{
	public static final String BATCH_NAME = 'BootstrapSObjectFields';
	public static final String[] ERROR_EMAILS = new String[]{ 'acouch@bluewolf.com' };
	
	global String errors = '';
	global Map<String, Schema.SObjectType> globalDescribe;
	
	global BatchToBootstrapSObjectFields()
	{
		globalDescribe = Schema.getGlobalDescribe();
	}
	
	global Database.QueryLocator start( Database.BatchableContext BC )
	{
		return Database.getQueryLocator( 'SELECT Id, Name FROM SObjectType__c' );
	}
	
	global void execute( Database.BatchableContext BC, List<SObject> scope )
	{
		List<SObjectField__c> objectsToInsert = new List<SObjectField__c>();
		
		for ( SObject someObject : scope )
		{
			Schema.SObjectType token = globalDescribe.get( (String)someObject.get('Name') );
			
			if( null == token )
			{
				System.debug('ERROR on object '+(String)someObject.get('Name'));
			}
			else
			{
				Schema.DescribeSObjectResult objectDescribe = token.getDescribe();
				
				Map<String, Schema.SObjectField> objectFields = objectDescribe.fields.getMap();
				
				for( String fieldName : objectFields.keySet() )
				{
					SObjectField__c newField = new SObjectField__c();
					
					newField.Name = fieldName;
					newField.Label__c = fieldName;
					newField.SObject__c = (Id)someObject.get('Id');
					
					objectsToInsert.add( newField );
				}
			}
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
		
			Database.executeBatch( new BatchToBootstrapSObjectFields() );
		
		Test.stopTest();
		
		// @TODO: implement test
	}
}