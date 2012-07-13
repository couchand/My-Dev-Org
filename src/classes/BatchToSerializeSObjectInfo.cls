global class BatchToSerializeSObjectInfo implements Database.Batchable<String>, Database.Stateful
{
	public static final String BATCH_NAME = 'SerializeSObjectInfo';
	public static final String[] ERROR_EMAILS = new String[]{ 'acouch@bluewolf.com' };
	
	global String errors = '';
	
	global BatchToSerializeSObjectInfo()
	{
	}
	
	global List<String> start( Database.BatchableContext BC )
	{
		return new List<String>( SObjectServices.typeCache.keySet() );
	}
	
	global void execute( Database.BatchableContext BC, List<String> scope )
	{
		for (  String objectName : scope )
		{
			SObjectServices.SObjectInfo objectInfo = new SObjectServices.SObjectInfo( objectName );
			
			try
			{
				ServerSideStateUtil.storeState( objectInfo.objectType.Id, SObjectServices.INFO_SLUG, JSON.serialize( objectInfo ) );
			}
			catch( ServerSideStateUtil.ServerSideStateException ex )
			{
				errors += ex.getMessage() + '\n';
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
		
			Database.executeBatch( new BatchToSerializeSObjectInfo() );
		
		Test.stopTest();
		
		// @TODO: implement test
	}
}