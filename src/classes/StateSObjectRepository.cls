public class StateSObjectRepository implements ISObjectRepository
{
	public SObject find( Id objectId )
	{
		String objectPrefix = ((String)objectId).substring(0,3);
		SObjectType__c objectType = [SELECT Name FROM SObjectType__c WHERE Key_Prefix__c = :objectPrefix];

		SObjectType objectToken = Schema.getGlobalDescribe().get( objectType.Name );

		SObject newSObject = objectToken.newSObject( objectId );

		UserSObject objectRetriever = new UserSObject( newSObject );

		try
		{
			State.retrieve( objectRetriever );
		}
		catch( Exception e )
		{
			throw new SObjectNotFoundException();
		}

		return objectRetriever.getSObject();
	}

	public void save( SObject anSObject )
	{
		UserSObject objectSaver = new UserSObject( anSObject );
		State.store( objectSaver );
	}

	public class SObjectNotFoundException extends Exception {}

	private class UserSObject extends State.UserSObject
	{
		UserSObject( SObject anSObject )
		{
			super( 'StateRepo', anSObject );
		}
	}
}
