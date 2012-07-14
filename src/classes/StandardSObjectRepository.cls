public class StandardSObjectRepository implements ISObjectRepository
{
	public SObject find( Id objectId )
	{
		String objectPrefix = ((String)objectId).substring(0,3);
		SObjectType__c objectType = [SELECT Name FROM SObjectType__c WHERE Key_Prefix__c = :objectPrefix];
		String query = 'SELECT Id, Name, LastModifiedDate FROM ' + objectType.Name + ' WHERE Id = :objectId';

		List<SObject> objectCandidates = Database.query( query );

		if( objectCandidates.isEmpty() )
			throw new SObjectNotFoundException();

		return objectCandidates[0];
	}

	public void save( SObject anSObject )
	{
		update anSObject;
	}

	public class SObjectNotFoundException extends Exception {}
}
