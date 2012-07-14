public class MergingSObjectRepository implements ISObjectRepository
{
	private ISObjectRepository queryRepo = new StandardSObjectRepository();
	private ISObjectRepository cacheRepo = new StateSObjectRepository();

	public SObject find( Id objectId )
	{
		SObject theObject = queryRepo.find( objectId );

		cacheRepo.save( theObject );

		return theObject;
	}

	public void save( SObject anSObject )
	{
		SObject currentObject = queryRepo.find( anSObject.Id );

		SObject oldObject;

		try
		{
			oldObject = cacheRepo.find( anSObject.Id );
		}
		catch( Exception e ){}

		SObject objectToSave = mergeSObjects( currentObject, anSObject, oldObject );

		queryRepo.save( anSObject );
	}

	private SObject mergeSObjects( SObject current, SObject newOne, SObject oldOne )
	{
		DateTime currentModified = (DateTime)current.get('LastModifiedDate');
		DateTime oldModified = (DateTime)oldOne.get('LastModifiedDate');

		if( currentModified > oldModified )
			throw new SObjectChangedException('Object changed since you loaded this page!');

		return newOne;
	}

	public class SObjectNotFoundException extends Exception {}
	public class SObjectChangedException extends Exception {}

	private class UserSObject extends State.UserSObject
	{
		UserSObject( SObject anSObject )
		{
			super( 'StateRepo', anSObject );
		}
	}
}