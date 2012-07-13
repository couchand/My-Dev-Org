global class BatchToBootstrapSObjectFieldInfo implements Database.Batchable<SObject>, Database.Stateful
{
	public static final String BATCH_NAME = 'BootstrapSObjectFieldInfo';
	public static final String[] ERROR_EMAILS = new String[]{ 'acouch@bluewolf.com' };
	
	global String errors = '';
	global Map<String, Schema.SObjectType> globalDescribe;
	global Map<String, Map<String, Schema.SObjectField>> objectFieldsMap;
	
	global BatchToBootstrapSObjectFieldInfo()
	{
		globalDescribe = Schema.getGlobalDescribe();
	}
	
	global Database.QueryLocator start( Database.BatchableContext BC )
	{
		return Database.getQueryLocator( 'SELECT Id, Name, SObject__r.Name FROM SObjectField__c' );
	}
	
	global void execute( Database.BatchableContext BC, List<SObject> scope )
	{
		objectFieldsMap = new Map<String, Map<String, Schema.SObjectField>>();
		
		List<SObjectField__c> objectsToUpdate = new List<SObjectField__c>();
		
		for ( SObject someObject : scope )
		{
			SObjectField__c fieldToUpdate = (SObjectField__c)someObject;
			
			if( !objectFieldsMap.containsKey( fieldToUpdate.SObject__r.Name ) )
			{
				Schema.SObjectType token = globalDescribe.get( fieldToUpdate.SObject__r.Name );
				Schema.DescribeSObjectResult objectDescribe = token.getDescribe();
				
				Map<String, Schema.SObjectField> objectFields = objectDescribe.fields.getMap();
				
				objectFieldsMap.put( fieldToUpdate.SObject__r.Name, objectFields );
			}
			
			Schema.DescribeFieldResult fieldDescribe = objectFieldsMap.get( fieldToUpdate.SObject__r.Name ).get( fieldToUpdate.Name ).getDescribe();
			
			fieldToUpdate.Name = fieldDescribe.getName();
			fieldToUpdate.Label__c = fieldDescribe.getLabel();
			fieldToUpdate.Type__c = fieldDescribe.getType().name();
			
			objectsToUpdate.add( fieldToUpdate );
		}
		try
		{
			update objectsToUpdate;
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
		List<SObjectField__c> fields = [SELECT Id FROM SObjectField__c];
		delete fields;
		
		SObjectType__c accountObject = [SELECT Id FROM SObjectType__c WHERE Name = 'Account'];
		
		List<SObjectField__c> objectsToInsert = new List<SObjectField__c>();
		
		Schema.SObjectType token = Schema.getGlobalDescribe().get( 'Account' );
		
		if( null == token )
		{
			System.debug('ERROR on object Account');
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
				newField.SObject__c = accountObject.Id;
				
				objectsToInsert.add( newField );
			}
		}
		insert objectsToInsert;
		
		Test.startTest();
		
			Database.executeBatch( new BatchToBootstrapSObjectFieldInfo() );
		
		Test.stopTest();
		
		// @TODO: implement test
	}
}